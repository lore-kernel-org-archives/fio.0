Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Thu, 27 Aug 2020 16:27:26 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH v2] zbd: rewrite verification in ZBD mode
Message-ID: <20200827132726.GA51860@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, adobriyan@gmail.com
List-ID: <fio@vger.kernel.org>

Stop relying on reproducing exact I/O patterns for verification,
which is not possible in general case of concurrent I/O done
by multiple threads/processes/jobs.

It paves the way to "verify before zone reset" feature.

Introduce
* per-zone seed
	verify pattern is derived from it,
	incremented with each zone reset, so that patterns across data
	generations differ

*) per-zone random generator state
	reseeded with each zone reset from new seed

*) per-zone I/O list
	Each I/O is recorded in this write list.

	ZNS writes (and append) are naturally sequential, so no overlapping
	occurs. Verification occurs in write order (sequential read).

	In the future, Zone Append will rewrite ipo->offset after completing.
	This can make write list not sorted, several verifying reads will be
	issued non-sequentially which is not a problem.

Delete ->verify_block -- obsoleted.

Disable "experimental_verify" option.
	AFAICS it relies on accurate I/O accounting, which is not necessary
	as all I/O is recorded in write lists.

	It also can't handle zone resets/overwrites in the middle of job.

Disable "uh oh overwriting can lead to verification failures" in zonemode=zbd.
	First, ZBD mode doesn't overwrite.
	Second, if zone reset occurs then so be it.

Changes since v1:
	fix asserts by making each thread verify only it's own I/O.

TODO:
	test async verification
	test backlog and "each N-th I/O" options
	fix too many verifying reads in some cases
	
Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 backend.c   |   50 +++++++++++++++++++++++++++++++++++++----
 filesetup.c |    7 +++++
 fio.h       |    2 +
 init.c      |    2 +
 io_u.c      |    2 -
 iolog.c     |   26 +++++++++++++++------
 iolog.h     |    1 
 verify.c    |   45 ++++++++++++++++++++++++++++++-------
 verify.h    |    5 +++-
 zbd.c       |   72 ++++++++++++++++++++++++++----------------------------------
 zbd.h       |   16 +++++++++++--
 11 files changed, 163 insertions(+), 65 deletions(-)

--- a/backend.c
+++ b/backend.c
@@ -48,6 +48,7 @@
 #include "rate-submit.h"
 #include "helper_thread.h"
 #include "pshared.h"
+#include "zbd.h"
 #include "zone-dist.h"
 
 static struct fio_sem *startup_sem;
@@ -617,7 +618,7 @@ static enum fio_q_status io_u_submit(struct thread_data *td, struct io_u *io_u)
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
  */
-static void do_verify(struct thread_data *td, uint64_t verify_bytes)
+void do_verify(struct thread_data *td, uint64_t verify_bytes, struct fio_file *td_f, struct fio_zone_info *zi, bool sync)
 {
 	struct fio_file *f;
 	struct io_u *io_u;
@@ -631,8 +632,12 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	 * read from disk.
 	 */
 	for_each_file(td, f, i) {
+		if (td_f && f != td_f)
+			continue;
 		if (!fio_file_open(f))
 			continue;
+		if (!sync)
+			break;
 		if (fio_io_sync(td, f))
 			break;
 		if (file_invalidate_cache(td, f))
@@ -650,8 +655,14 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	 * random seeds in headers. The main loop will reset
 	 * all random number generators if randrepeat is set.
 	 */
-	if (!td->o.rand_repeatable)
-		td_fill_verify_state_seed(td);
+	if (!td->o.rand_repeatable) {
+		if (zi) {
+			bool use64 = td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64;
+			init_rand_seed(&zi->rand_state, zi->seed, use64);
+		} else {
+			td_fill_verify_state_seed(td);
+		}
+	}
 
 	td_set_runstate(td, TD_VERIFYING);
 
@@ -679,7 +690,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 			if (!io_u)
 				break;
 
-			if (get_next_verify(td, io_u)) {
+			if (get_next_verify(td, io_u, td_f, zi)) {
 				put_io_u(td, io_u);
 				break;
 			}
@@ -1518,6 +1529,31 @@ static uint64_t do_dry_run(struct thread_data *td)
 	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
+static void do_verify_zbd(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i) {
+		struct zoned_block_device_info *zbd = f->zbd_info;
+		bool sync;
+
+		if (!zbd)
+			continue;
+
+		sync = true;
+		for (uint32_t z = f->min_zone; z < f->max_zone; z++) {
+			struct fio_zone_info *zi = &zbd->zone_info[z];
+
+			if (!zbd_zone_swr(zi))
+				continue;
+
+			do_verify(td, 0, f, zi, sync);
+			sync = false;
+		}
+	}
+}
+
 struct fork_data {
 	struct thread_data *td;
 	struct sk_out *sk_out;
@@ -1841,7 +1877,11 @@ static void *thread_main(void *data)
 
 		fio_gettime(&td->start, NULL);
 
-		do_verify(td, verify_bytes);
+		if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			do_verify_zbd(td);
+		} else {
+			do_verify(td, verify_bytes, NULL, NULL, true);
+		}
 
 		/*
 		 * See comment further up for why this is done here.
--- a/filesetup.c
+++ b/filesetup.c
@@ -14,6 +14,7 @@
 #include "hash.h"
 #include "lib/axmap.h"
 #include "rwlock.h"
+#include "verify.h"
 #include "zbd.h"
 
 #ifdef CONFIG_LINUX_FALLOCATE
@@ -1271,6 +1272,12 @@ done:
 		err = zbd_setup_files(td);
 		if (err)
 			goto err_out;
+
+		if (td->o.experimental_verify && td->o.verify != VERIFY_NONE) {
+			td->o.experimental_verify = 0;
+			log_err("warning: experimental verification is incompatible with zonemode=zbd\n");
+			log_err("warning: switching to regular verification\n");
+		}
 	}
 	return 0;
 
--- a/fio.h
+++ b/fio.h
@@ -140,6 +140,7 @@ enum {
 	FIO_RAND_POISSON2_OFF,
 	FIO_RAND_POISSON3_OFF,
 	FIO_RAND_PRIO_CMDS,
+	FIO_RAND_ZBD,
 	FIO_RAND_NR_OFFS,
 };
 
@@ -256,6 +257,7 @@ struct thread_data {
 	struct frand_state buf_state;
 	struct frand_state buf_state_prev;
 	struct frand_state dedupe_state;
+	struct frand_state zbd_state;
 	struct frand_state zone_state;
 	struct frand_state prio_state;
 
--- a/init.c
+++ b/init.c
@@ -776,6 +776,7 @@ static int fixup_options(struct thread_data *td)
 
 	if (o->verify != VERIFY_NONE) {
 		if (td_write(td) && o->do_verify && o->numjobs > 1 &&
+		    o->zone_mode != ZONE_MODE_ZBD &&
 		    (o->filename ||
 		     !(o->unique_filename &&
 		       strstr(o->filename_format, "$jobname") &&
@@ -1018,6 +1019,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->poisson_state[1], td->rand_seeds[FIO_RAND_POISSON2_OFF], 0);
 	init_rand_seed(&td->poisson_state[2], td->rand_seeds[FIO_RAND_POISSON3_OFF], 0);
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
+	init_rand_seed(&td->zbd_state, td->rand_seeds[FIO_RAND_ZBD], use64);
 	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
 	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
 
--- a/io_u.c
+++ b/io_u.c
@@ -1650,7 +1650,7 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
 			get_verify = 1;
 		}
 
-		if (get_verify && !get_next_verify(td, io_u)) {
+		if (get_verify && !get_next_verify(td, io_u, NULL, NULL)) {
 			td->verify_batch--;
 			return true;
 		}
--- a/iolog.c
+++ b/iolog.c
@@ -19,6 +19,7 @@
 #include "smalloc.h"
 #include "blktrace.h"
 #include "pshared.h"
+#include "zbd.h"
 #include "lib/roundup.h"
 
 #include <netinet/in.h>
@@ -233,6 +234,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	ipo->file = io_u->file;
 	ipo->offset = io_u->offset;
 	ipo->len = io_u->buflen;
+	ipo->seed = io_u->rand_seed;
 	ipo->numberio = io_u->numberio;
 	ipo->flags = IP_F_IN_FLIGHT;
 
@@ -243,12 +245,22 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 		td->trim_entries++;
 	}
 
-	/*
-	 * Only sort writes if we don't have a random map in which case we need
-	 * to check for duplicate blocks and drop the old one, which we rely on
-	 * the rb insert/lookup for handling.
-	 */
-	if (file_randommap(td, ipo->file)) {
+
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		struct fio_file *f = ipo->file;
+		uint32_t z = zbd_zone_idx(f, ipo->offset);
+		struct fio_zone_info *zi = &f->zbd_info->zone_info[z];
+
+		pthread_mutex_lock(&zi->mutex);
+		flist_add_tail(&ipo->list, &zi->write_list);
+		pthread_mutex_unlock(&zi->mutex);
+		return;
+	} else if (file_randommap(td, ipo->file)) {
+		/*
+		 * Only sort writes if we don't have a random map in which case we need
+		 * to check for duplicate blocks and drop the old one, which we rely on
+		 * the rb insert/lookup for handling.
+		 */
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
@@ -324,7 +336,7 @@ void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
 
 	if (ipo->flags & IP_F_ONRB)
 		rb_erase(&ipo->rb_node, &td->io_hist_tree);
-	else if (ipo->flags & IP_F_ONLIST)
+	else
 		flist_del(&ipo->list);
 
 	free(ipo);
--- a/iolog.h
+++ b/iolog.h
@@ -211,6 +211,7 @@ struct io_piece {
 		struct fio_file *file;
 	};
 	unsigned long long offset;
+	uint64_t seed;
 	unsigned short numberio;
 	unsigned long len;
 	unsigned int flags;
--- a/verify.c
+++ b/verify.c
@@ -12,6 +12,7 @@
 #include "fio.h"
 #include "verify.h"
 #include "trim.h"
+#include "zbd.h"
 #include "lib/rand.h"
 #include "lib/hweight.h"
 #include "lib/pattern.h"
@@ -55,7 +56,17 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
 
-		if (!use_seed) {
+		if (use_seed) {
+		} else if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			struct fio_file *f = io_u->file;
+			struct zoned_block_device_info *zbd = f->zbd_info;
+			uint32_t z = zbd_zone_idx(f, io_u->offset);
+			struct fio_zone_info *zi = &zbd->zone_info[z];
+
+			seed = __rand(&zi->rand_state);
+			if (sizeof(int) != sizeof(long *))
+				seed *= (unsigned long)__rand(&zi->rand_state);
+		} else {
 			seed = __rand(&td->verify_state);
 			if (sizeof(int) != sizeof(long *))
 				seed *= (unsigned long)__rand(&td->verify_state);
@@ -1292,7 +1303,7 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
-int get_next_verify(struct thread_data *td, struct io_u *io_u)
+int get_next_verify(struct thread_data *td, struct io_u *io_u, struct fio_file *f, struct fio_zone_info *zi)
 {
 	struct io_piece *ipo = NULL;
 
@@ -1302,7 +1313,25 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 	if (io_u->file)
 		return 0;
 
-	if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
+	if (zi) {
+		struct flist_head *lh;
+
+		pthread_mutex_lock(&zi->mutex);
+		flist_for_each(lh, &zi->write_list) {
+			ipo = flist_entry(lh, struct io_piece, list);
+			/*
+			 * Everyone verifies only its own writes to not deal
+			 * with cross thread file locking.
+			 */
+			if (ipo->file == f) {
+				flist_del_init(&ipo->list);
+				goto unlock_zone;
+			}
+		}
+		ipo = NULL;
+unlock_zone:
+		pthread_mutex_unlock(&zi->mutex);
+	} else if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
 		struct fio_rb_node *n = rb_first(&td->io_hist_tree);
 
 		ipo = rb_entry(n, struct io_piece, rb_node);
@@ -1331,11 +1360,14 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ipo) {
-		td->io_hist_len--;
+		if (!zi) {
+			td->io_hist_len--;
+		}
 
 		io_u->offset = ipo->offset;
 		io_u->verify_offset = ipo->offset;
 		io_u->buflen = ipo->len;
+		io_u->rand_seed = ipo->seed;
 		io_u->numberio = ipo->numberio;
 		io_u->file = ipo->file;
 		io_u_set(td, io_u, IO_U_F_VER_LIST);
@@ -1363,11 +1395,6 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		free(ipo);
 		dprint(FD_VERIFY, "get_next_verify: ret io_u %p\n", io_u);
 
-		if (!td->o.verify_pattern_bytes) {
-			io_u->rand_seed = __rand(&td->verify_state);
-			if (sizeof(int) != sizeof(long *))
-				io_u->rand_seed *= __rand(&td->verify_state);
-		}
 		return 0;
 	}
 
--- a/verify.h
+++ b/verify.h
@@ -5,6 +5,8 @@
 #include "compiler/compiler.h"
 #include "verify-state.h"
 
+struct fio_zone_info;
+
 #define FIO_HDR_MAGIC	0xacca
 
 enum {
@@ -93,8 +95,9 @@ struct vhdr_xxhash {
 /*
  * Verify helpers
  */
+void do_verify(struct thread_data *, uint64_t, struct fio_file *, struct fio_zone_info *, bool);
 extern void populate_verify_io_u(struct thread_data *, struct io_u *);
-extern int __must_check get_next_verify(struct thread_data *td, struct io_u *);
+extern int __must_check get_next_verify(struct thread_data *td, struct io_u *, struct fio_file *, struct fio_zone_info *);
 extern int __must_check verify_io_u(struct thread_data *, struct io_u **);
 extern int verify_io_u_async(struct thread_data *, struct io_u **);
 extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, uint64_t seed, int use_seed);
--- a/zbd.c
+++ b/zbd.c
@@ -119,7 +119,7 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
  * @offset: offset in bytes. If this offset is in the first zone_size bytes
  *	    past the disk size then the index of the sentinel is returned.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 {
 	uint32_t zone_idx;
 
@@ -131,15 +131,6 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 	return min(zone_idx, f->zbd_info->nr_zones);
 }
 
-/**
- * zbd_zone_swr - Test whether a zone requires sequential writes
- * @z: zone info pointer.
- */
-static inline bool zbd_zone_swr(struct fio_zone_info *z)
-{
-	return z->type == ZBD_ZONE_TYPE_SWR;
-}
-
 /**
  * zbd_zone_end - Return zone end location
  * @z: zone info pointer.
@@ -573,8 +564,27 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	}
 
 	if (ret == 0) {
-		f->zbd_info->model = zbd_model;
-		f->zbd_info->max_open_zones = td->o.max_open_zones;
+		struct zoned_block_device_info *zbd = f->zbd_info;
+		bool use64 = td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64;
+		uint64_t seed_diff;
+
+		zbd->model = zbd_model;
+		zbd->max_open_zones = td->o.max_open_zones;
+
+		if (use64) {
+			seed_diff = ~(uint64_t)0 / zbd->nr_zones;
+		} else {
+			seed_diff = ~(uint32_t)0 / zbd->nr_zones;
+		}
+
+		for (uint32_t z = 0; z < zbd->nr_zones; z++) {
+			struct fio_zone_info *zi = &zbd->zone_info[z];
+
+			/* Spread seeds as zone reset will increment them. */
+			zi->seed = td->rand_seeds[FIO_RAND_ZBD] + z * seed_diff;
+			init_rand_seed(&zi->rand_state, zi->seed, use64);
+			INIT_FLIST_HEAD(&zi->write_list);
+		}
 	}
 	return ret;
 }
@@ -713,7 +723,16 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	f->zbd_info->sectors_with_data -= z->wp - z->start;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	z->wp = z->start;
-	z->verify_block = 0;
+
+	z->seed++;
+	init_rand_seed(&z->rand_state, z->seed, td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64);
+
+	while (!flist_empty(&z->write_list)) {
+		struct io_piece *ipo = flist_first_entry(&z->write_list, struct io_piece, list);
+
+		flist_del(&ipo->list);
+		free(ipo);
+	}
 
 	td->ts.nr_zone_resets++;
 
@@ -1138,27 +1157,6 @@ out:
 	return z;
 }
 
-/* The caller must hold z->mutex. */
-static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
-						    struct io_u *io_u,
-						    struct fio_zone_info *z)
-{
-	const struct fio_file *f = io_u->file;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-
-	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
-		pthread_mutex_unlock(&z->mutex);
-		z = zbd_convert_to_open_zone(td, io_u);
-		assert(z);
-	}
-
-	if (z->verify_block * min_bs >= z->capacity)
-		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long)z->capacity);
-	io_u->offset = z->start + z->verify_block++ * min_bs;
-	return z;
-}
-
 /*
  * Find another zone for which @io_u fits below the write pointer. Start
  * searching in zones @zb + 1 .. @zl and continue searching in zones
@@ -1467,11 +1465,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING) {
-			if (td_write(td))
-				zb = zbd_replay_write_order(td, io_u, zb);
-			goto accept;
-		}
 		/*
 		 * Check that there is enough written data in the zone to do an
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
@@ -1545,7 +1538,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify == VERIFY_NONE);
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone
--- a/zbd.h
+++ b/zbd.h
@@ -24,7 +24,6 @@ enum io_u_action {
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
  * @capacity: maximum size usable from the start of a zone (bytes)
- * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
@@ -37,11 +36,14 @@ struct fio_zone_info {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		capacity;
-	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		open:1;
 	unsigned int		reset_zone:1;
+
+	struct frand_state	rand_state;
+	uint64_t		seed;
+	struct flist_head	write_list;
 };
 
 /**
@@ -91,6 +93,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
+uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
@@ -115,4 +118,13 @@ static inline void zbd_put_io_u(struct io_u *io_u)
 	}
 }
 
+/**
+ * zbd_zone_swr - Test whether a zone requires sequential writes
+ * @z: zone info pointer.
+ */
+static inline bool zbd_zone_swr(struct fio_zone_info *z)
+{
+	return z->type == ZBD_ZONE_TYPE_SWR;
+}
+
 #endif /* FIO_ZBD_H */

