Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 8/9] zbd: support verification
Date: Tue,  5 May 2020 20:56:34 +0300
Message-Id: <20200505175634.2517-8-adobriyan@gmail.com>
In-Reply-To: <20200505175634.2517-1-adobriyan@gmail.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

Verification is not supported in ZBD mode which is codified in this
assert:

	if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
		assert(td->o.verify == VERIFY_NONE);

However, sequential write property is excellent for actually doing
verification if write_list and seeds are maintained per-zone.
It will work automatically with
* overlapping jobs
* zone resets in the middle of job
* different write block sizes

This also paves the way to "verify before zone reset" and
"verify zeroes after wp" features.

Introduce
*) per-zone seed,
	incremented with each reset, so that patterns differ
*) per-zone random generator state,
	reseeded with each zone reset
*) per-zone write I/O list
	linked list is natural for sequential writes

*) per-zone verify_mutex
	This will be used for verify-zeroes-after-wp, definitely.
	Currently it is more a peace of mind member otherwise list
	corruption asserts trigger IIRC.
	TODO: explain why it is needed.

Delete ->verify_block -- obsoleted.

There are also some funny things going on with flushing and resetting
files in the middle of I/O but non-overlapping case more or less works.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---
 backend.c | 44 +++++++++++++++++++++++++++++---
 fio.h     |  2 ++
 init.c    |  1 +
 io_u.c    |  2 +-
 iolog.c   | 24 ++++++++++++------
 iolog.h   |  1 +
 verify.c  | 45 ++++++++++++++++++++++++++-------
 verify.h  |  4 ++-
 zbd.c     | 75 ++++++++++++++++++++++++++++---------------------------
 zbd.h     | 20 +++++++++++++--
 10 files changed, 158 insertions(+), 60 deletions(-)

diff --git a/backend.c b/backend.c
index 452975cf..05ca5dc1 100644
--- a/backend.c
+++ b/backend.c
@@ -48,6 +48,7 @@
 #include "rate-submit.h"
 #include "helper_thread.h"
 #include "pshared.h"
+#include "zbd.h"
 #include "zone-dist.h"
 
 static struct fio_sem *startup_sem;
@@ -615,7 +616,7 @@ static enum fio_q_status io_u_submit(struct thread_data *td, struct io_u *io_u)
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
  */
-static void do_verify(struct thread_data *td, uint64_t verify_bytes)
+static void do_verify(struct thread_data *td, uint64_t verify_bytes, struct fio_file *td_f, struct fio_zone_info *zi, bool sync)
 {
 	struct fio_file *f;
 	struct io_u *io_u;
@@ -629,8 +630,12 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	 * read from disk.
 	 */
 	for_each_file(td, f, i) {
+		if (td_f && f != td_f)
+			continue;
 		if (!fio_file_open(f))
 			continue;
+		if (!sync)
+			continue;
 		if (fio_io_sync(td, f))
 			break;
 		if (file_invalidate_cache(td, f))
@@ -677,7 +682,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 			if (!io_u)
 				break;
 
-			if (get_next_verify(td, io_u)) {
+			if (get_next_verify(td, io_u, td_f, zi)) {
 				put_io_u(td, io_u);
 				break;
 			}
@@ -1516,6 +1521,35 @@ static uint64_t do_dry_run(struct thread_data *td)
 	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
+static void do_verify_zbd(struct thread_data *td, uint64_t verify_bytes)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i) {
+		struct zoned_block_device_info *zbd = f->zbd_info;
+		bool sync = true;
+
+		if (!zbd)
+			continue;
+
+		for (uint32_t z = f->min_zone; z < f->max_zone; z++) {
+			struct fio_zone_info *zi = &zbd->zone_info[z];
+
+			if (!zbd_zone_swr(zi))
+				continue;
+
+			if (pthread_mutex_trylock(&zi->verify_mutex) != 0) {
+				/* Someone else is verifying this zone. */
+				continue;
+			}
+			do_verify(td, verify_bytes, f, zi, sync);
+			pthread_mutex_unlock(&zi->verify_mutex);
+			sync = false;
+		}
+	}
+}
+
 struct fork_data {
 	struct thread_data *td;
 	struct sk_out *sk_out;
@@ -1839,7 +1873,11 @@ static void *thread_main(void *data)
 
 		fio_gettime(&td->start, NULL);
 
-		do_verify(td, verify_bytes);
+		if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			do_verify_zbd(td, verify_bytes);
+		} else {
+			do_verify(td, verify_bytes, NULL, NULL, true);
+		}
 
 		/*
 		 * See comment further up for why this is done here.
diff --git a/fio.h b/fio.h
index 20ca80e2..42df7a50 100644
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
 
diff --git a/init.c b/init.c
index b5315334..d41a23ff 100644
--- a/init.c
+++ b/init.c
@@ -1029,6 +1029,7 @@ static void td_fill_rand_seeds_internal(struct thread_data *td, bool use64)
 	init_rand_seed(&td->poisson_state[1], td->rand_seeds[FIO_RAND_POISSON2_OFF], 0);
 	init_rand_seed(&td->poisson_state[2], td->rand_seeds[FIO_RAND_POISSON3_OFF], 0);
 	init_rand_seed(&td->dedupe_state, td->rand_seeds[FIO_DEDUPE_OFF], false);
+	init_rand_seed(&td->zbd_state, td->rand_seeds[FIO_RAND_ZBD], use64);
 	init_rand_seed(&td->zone_state, td->rand_seeds[FIO_RAND_ZONE_OFF], false);
 	init_rand_seed(&td->prio_state, td->rand_seeds[FIO_RAND_PRIO_CMDS], false);
 
diff --git a/io_u.c b/io_u.c
index 18e94617..3cd7fb71 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1610,7 +1610,7 @@ static bool check_get_verify(struct thread_data *td, struct io_u *io_u)
 			get_verify = 1;
 		}
 
-		if (get_verify && !get_next_verify(td, io_u)) {
+		if (get_verify && !get_next_verify(td, io_u, NULL, NULL)) {
 			td->verify_batch--;
 			return true;
 		}
diff --git a/iolog.c b/iolog.c
index 917a446c..732861a8 100644
--- a/iolog.c
+++ b/iolog.c
@@ -19,6 +19,7 @@
 #include "smalloc.h"
 #include "blktrace.h"
 #include "pshared.h"
+#include "zbd.h"
 
 #include <netinet/in.h>
 #include <netinet/tcp.h>
@@ -231,6 +232,7 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	ipo->file = io_u->file;
 	ipo->offset = io_u->offset;
 	ipo->len = io_u->buflen;
+	ipo->seed = io_u->rand_seed;
 	ipo->numberio = io_u->numberio;
 	ipo->flags = IP_F_IN_FLIGHT;
 
@@ -241,12 +243,20 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 		td->trim_entries++;
 	}
 
-	/*
-	 * Only sort writes if we don't have a random map in which case we need
-	 * to check for duplicate blocks and drop the old one, which we rely on
-	 * the rb insert/lookup for handling.
-	 */
-	if (file_randommap(td, ipo->file)) {
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		struct fio_file *f = ipo->file;
+		uint32_t z = zbd_zone_idx(f, ipo->offset);
+		struct fio_zone_info *zi = &f->zbd_info->zone_info[z];
+
+		flist_add_tail(&ipo->list, &zi->write_list);
+		ipo->flags |= IP_F_ONLIST;
+		return;
+	} else if (file_randommap(td, ipo->file)) {
+		/*
+		 * Only sort writes if we don't have a random map in which case
+		 * we need to check for duplicate blocks and drop the old one,
+		 * which we rely on the rb insert/lookup for handling.
+		 */
 		INIT_FLIST_HEAD(&ipo->list);
 		flist_add_tail(&ipo->list, &td->io_hist_list);
 		ipo->flags |= IP_F_ONLIST;
@@ -322,7 +332,7 @@ void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
 
 	if (ipo->flags & IP_F_ONRB)
 		rb_erase(&ipo->rb_node, &td->io_hist_tree);
-	else if (ipo->flags & IP_F_ONLIST)
+	else
 		flist_del(&ipo->list);
 
 	free(ipo);
diff --git a/iolog.h b/iolog.h
index 981081f9..7eddb8e0 100644
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
diff --git a/verify.c b/verify.c
index b7fa6693..025e3eb0 100644
--- a/verify.c
+++ b/verify.c
@@ -11,6 +11,7 @@
 #include "fio.h"
 #include "verify.h"
 #include "trim.h"
+#include "zbd.h"
 #include "lib/rand.h"
 #include "lib/hweight.h"
 #include "lib/pattern.h"
@@ -54,7 +55,16 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
 
-		if (!use_seed) {
+		if (use_seed) {
+		} else if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			struct fio_file *f = io_u->file;
+			uint32_t z = zbd_zone_idx(f, io_u->offset);
+			struct fio_zone_info *zi = &f->zbd_info->zone_info[z];
+
+			seed = __rand(&zi->rand_state);
+			if (sizeof(int) != sizeof(long *))
+				seed *= __rand(&zi->rand_state);
+		} else {
 			seed = __rand(&td->verify_state);
 			if (sizeof(int) != sizeof(long *))
 				seed *= (unsigned long)__rand(&td->verify_state);
@@ -1291,7 +1301,7 @@ void populate_verify_io_u(struct thread_data *td, struct io_u *io_u)
 	fill_pattern_headers(td, io_u, 0, 0);
 }
 
-int get_next_verify(struct thread_data *td, struct io_u *io_u)
+int get_next_verify(struct thread_data *td, struct io_u *io_u, struct fio_file *td_f, struct fio_zone_info *zi)
 {
 	struct io_piece *ipo = NULL;
 
@@ -1301,7 +1311,26 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 	if (io_u->file)
 		return 0;
 
-	if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
+	if (zi) {
+		pthread_mutex_lock(&zi->mutex);
+		if (!flist_empty(&zi->write_list)) {
+			ipo = flist_first_entry(&zi->write_list, struct io_piece, list);
+
+			/*
+			 * Ensure that the associated IO has completed
+			 */
+			read_barrier();
+			if (ipo->flags & IP_F_IN_FLIGHT) {
+				pthread_mutex_unlock(&zi->mutex);
+				goto nothing;
+			}
+
+			flist_del(&ipo->list);
+			assert(ipo->flags & IP_F_ONLIST);
+			ipo->flags &= ~IP_F_ONLIST;
+		}
+		pthread_mutex_unlock(&zi->mutex);
+	} else if (!RB_EMPTY_ROOT(&td->io_hist_tree)) {
 		struct fio_rb_node *n = rb_first(&td->io_hist_tree);
 
 		ipo = rb_entry(n, struct io_piece, rb_node);
@@ -1332,10 +1361,13 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ipo) {
-		td->io_hist_len--;
+		if (!zi) {
+			td->io_hist_len--;
+		}
 
 		io_u->offset = ipo->offset;
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
 
diff --git a/verify.h b/verify.h
index 539e6f6c..f046d05b 100644
--- a/verify.h
+++ b/verify.h
@@ -7,6 +7,8 @@
 
 #define FIO_HDR_MAGIC	0xacca
 
+struct fio_zone_info;
+
 enum {
 	VERIFY_NONE = 0,		/* no verification */
 	VERIFY_HDR_ONLY,		/* verify header only, kept for sake of
@@ -94,7 +96,7 @@ struct vhdr_xxhash {
  * Verify helpers
  */
 extern void populate_verify_io_u(struct thread_data *, struct io_u *);
-extern int __must_check get_next_verify(struct thread_data *td, struct io_u *);
+extern int __must_check get_next_verify(struct thread_data *td, struct io_u *, struct fio_file *, struct fio_zone_info *);
 extern int __must_check verify_io_u(struct thread_data *, struct io_u **);
 extern int verify_io_u_async(struct thread_data *, struct io_u **);
 extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, uint64_t seed, int use_seed);
diff --git a/zbd.c b/zbd.c
index df46da42..c926df15 100644
--- a/zbd.c
+++ b/zbd.c
@@ -118,7 +118,7 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
  * @offset: offset in bytes. If this offset is in the first zone_size bytes
  *	    past the disk size then the index of the sentinel is returned.
  */
-static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
+uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 {
 	uint32_t zone_idx;
 
@@ -130,15 +130,6 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
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
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -499,6 +490,11 @@ out:
 	return ret;
 }
 
+static inline bool td_use64(const struct thread_data *td)
+{
+	return td->o.random_generator == FIO_RAND_GEN_TAUSWORTHE64;
+}
+
 /*
  * Allocate zone information and store it into f->zbd_info if zonemode=zbd.
  *
@@ -509,6 +505,7 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	struct zoned_block_device_info *zbd;
 	enum zbd_zoned_model zbd_model;
 	pthread_mutexattr_t attr;
+	uint64_t diff_seed;
 	int ret;
 
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
@@ -543,6 +540,23 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	pthread_mutexattr_init(&attr);
 	pthread_mutexattr_setpshared(&attr, true);
 	pthread_mutex_init(&zbd->mutex, &attr);
+
+	diff_seed = td_use64(td)
+		? ~(uint64_t)0 / zbd->nr_zones
+		: ~(uint32_t)0 / zbd->nr_zones;
+	for (uint32_t z = 0; z < zbd->nr_zones; z++) {
+		struct fio_zone_info *zi = &zbd->zone_info[z];
+
+		/*
+		 * Spread zone seeds a bit, they will be incremented
+		 * with each reset and better stay unique.
+		 */
+		zi->seed = __rand(&td->zbd_state) + z * diff_seed;
+		init_rand_seed(&zi->rand_state, zi->seed, td_use64(td));
+		INIT_FLIST_HEAD(&zi->write_list);
+		pthread_mutex_init(&zi->verify_mutex, &attr);
+	}
+
 	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	for (uint32_t z = 0; z < zbd->nr_zones; z++) {
 		struct fio_zone_info *zi = &zbd->zone_info[z];
@@ -683,13 +697,26 @@ static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
 	zone_idx_e = zbd_zone_idx(f, offset + length);
 	ze = &f->zbd_info->zone_info[zone_idx_e];
 	for (z = zb; z < ze; z++) {
+		FLIST_HEAD(write_list);
+
 		pthread_mutex_lock(&z->mutex);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		f->zbd_info->sectors_with_data -= z->wp - z->start;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		z->wp = z->start;
-		z->verify_block = 0;
+		z->seed++;
+		init_rand_seed(&z->rand_state, z->seed, td_use64(td));
+		flist_splice_init(&z->write_list, &write_list);
 		pthread_mutex_unlock(&z->mutex);
+
+		while (!flist_empty(&write_list)) {
+			struct io_piece *ipo = flist_first_entry(&write_list, struct io_piece, list);
+
+			/* Data "loss"... */
+			flist_del(&ipo->list);
+			assert(ipo->flags & IP_F_ONLIST);
+			free(ipo);
+		}
 	}
 
 	td->ts.nr_zone_resets += ze - zb;
@@ -1142,27 +1169,6 @@ out:
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
-	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
-		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long) f->zbd_info->zone_size);
-	io_u->offset = z->start + z->verify_block++ * min_bs;
-	return z;
-}
-
 /*
  * Find another zone for which @io_u fits below the write pointer. Start
  * searching in zones @zb + 1 .. @zl and continue searching in zones
@@ -1454,10 +1460,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-		if (td->runstate == TD_VERIFYING) {
-			zb = zbd_replay_write_order(td, io_u, zb);
-			goto accept;
-		}
 		/*
 		 * Check that there is enough written data in the zone to do an
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
@@ -1532,7 +1534,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Reset the zone pointer if necessary */
 		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
-			assert(td->o.verify == VERIFY_NONE);
 			/*
 			 * Since previous write requests may have been submitted
 			 * asynchronously and since we will submit the zone
diff --git a/zbd.h b/zbd.h
index fb39fb82..013c08c9 100644
--- a/zbd.h
+++ b/zbd.h
@@ -23,23 +23,29 @@ enum io_u_action {
  * struct fio_zone_info - information about a single ZBD zone
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
- * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
  * @cond: zone state (BLK_ZONE_COND_*)
  * @open: whether or not this zone is currently open. Only relevant if
  *		max_open_zones > 0.
  * @reset_zone: whether or not this zone should be reset before writing to it
+ * @seed:
+ * @rand_state:
+ * @write_list:
+ * @verify_mutex:
  */
 struct fio_zone_info {
 	pthread_mutex_t		mutex;
 	uint64_t		start;
 	uint64_t		wp;
-	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		open:1;
 	unsigned int		reset_zone:1;
+	uint64_t		seed;
+	struct frand_state	rand_state;
+	struct flist_head	write_list;
+	pthread_mutex_t		verify_mutex;
 };
 
 /**
@@ -89,6 +95,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
+uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset);
 
 static inline void zbd_queue_io_u(struct io_u *io_u, enum fio_q_status status)
 {
@@ -107,4 +114,13 @@ static inline void zbd_put_io_u(struct io_u *io_u)
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
-- 
2.26.2


