Return-Path: <prvs=4589743b3=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/6] zbd: Support zone capacity smaller than zone size
Date: Wed, 15 Jul 2020 15:41:36 +0900
Message-Id: <20200715064141.116415-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
References: <20200715064141.116415-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Hans Holmberg <hans.holmberg@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

NVMe ZNS specification defines zone capacity. The report zone interface
of Linux kernel supports it. This patch adds support for this new
interface.

Refer BLK_ZONE_REP_CAPACITY flag in the report zone header to check if
the zone capacity is reported. If this flag is set, ensure that the
writes and reads to the zone happen within the zone capacity. Avoid write
beyond capacity limit not to cause IO error. Avoid read beyond capacity
limit not to report unreasonable fast throughput.

Introduce helper functions zbd_zone_end() and zbd_zone_capacity_end() to
improve readability of zone limit check code.

Also modify configure to check availability of BLK_ZONE_REP_CAPACITY flag
as well as blkzoned.h header only when target OS is Linux.

Of note is that this skips the region between zone capacity and zone end
then reduces total I/O bytes of sequential write workloads.

Signed-off-by: Aravind Ramesh <aravind.ramesh@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 configure              | 19 +++++++++++
 engines/libzbc.c       |  1 +
 oslib/linux-blkzoned.c | 11 +++++++
 zbd.c                  | 74 +++++++++++++++++++++++++++++++++---------
 zbd.h                  |  2 ++
 zbd_types.h            |  1 +
 6 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/configure b/configure
index 6991393b..b079a2a5 100755
--- a/configure
+++ b/configure
@@ -2390,6 +2390,7 @@ if compile_prog "" "" "valgrind_dev"; then
 fi
 print_config "Valgrind headers" "$valgrind_dev"
 
+if test "$targetos" = "Linux" ; then
 ##########################################
 # <linux/blkzoned.h> probe
 if test "$linux_blkzoned" != "yes" ; then
@@ -2407,6 +2408,24 @@ if compile_prog "" "" "linux_blkzoned"; then
 fi
 print_config "Zoned block device support" "$linux_blkzoned"
 
+##########################################
+# Check BLK_ZONE_REP_CAPACITY
+cat > $TMPC << EOF
+#include <linux/blkzoned.h>
+int main(void)
+{
+  return BLK_ZONE_REP_CAPACITY;
+}
+EOF
+if compile_prog "" "" "blkzoned report capacity"; then
+  output_sym "CONFIG_HAVE_REP_CAPACITY"
+  rep_capacity="yes"
+else
+  rep_capacity="no"
+fi
+print_config "Zoned block device capacity" "$rep_capacity"
+fi
+
 ##########################################
 # libzbc probe
 if test "$libzbc" != "yes" ; then
diff --git a/engines/libzbc.c b/engines/libzbc.c
index fdde8ca6..f736a131 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -235,6 +235,7 @@ static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
 		zbdz->start = zones[i].zbz_start << 9;
 		zbdz->len = zones[i].zbz_length << 9;
 		zbdz->wp = zones[i].zbz_write_pointer << 9;
+		zbdz->capacity = zbdz->len;
 
 		switch (zones[i].zbz_type) {
 		case ZBC_ZT_CONVENTIONAL:
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 1cf06363..6fe78b9c 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -113,6 +113,16 @@ out:
 	return 0;
 }
 
+static uint64_t zone_capacity(struct blk_zone_report *hdr,
+			      struct blk_zone *blkz)
+{
+#ifdef CONFIG_HAVE_REP_CAPACITY
+	if (hdr->flags & BLK_ZONE_REP_CAPACITY)
+		return blkz->capacity << 9;
+#endif
+	return blkz->len << 9;
+}
+
 int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 			  uint64_t offset, struct zbd_zone *zones,
 			  unsigned int nr_zones)
@@ -149,6 +159,7 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 		z->start = blkz->start << 9;
 		z->wp = blkz->wp << 9;
 		z->len = blkz->len << 9;
+		z->capacity = zone_capacity(hdr, blkz);
 
 		switch (blkz->type) {
 		case BLK_ZONE_TYPE_CONVENTIONAL:
diff --git a/zbd.c b/zbd.c
index cf2cded9..c738a58b 100644
--- a/zbd.c
+++ b/zbd.c
@@ -140,6 +140,24 @@ static inline bool zbd_zone_swr(struct fio_zone_info *z)
 	return z->type == ZBD_ZONE_TYPE_SWR;
 }
 
+/**
+ * zbd_zone_end - Return zone end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_end(const struct fio_zone_info *z)
+{
+	return (z+1)->start;
+}
+
+/**
+ * zbd_zone_capacity_end - Return zone capacity limit end location
+ * @z: zone info pointer.
+ */
+static inline uint64_t zbd_zone_capacity_end(const struct fio_zone_info *z)
+{
+	return z->start + z->capacity;
+}
+
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -154,7 +172,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 	assert((required & 511) == 0);
 
 	return zbd_zone_swr(z) &&
-		z->wp + required > z->start + f->zbd_info->zone_size;
+		z->wp + required > zbd_zone_capacity_end(z);
 }
 
 static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
@@ -271,7 +289,7 @@ static bool zbd_verify_sizes(void)
 			z = &f->zbd_info->zone_info[zone_idx];
 			if ((f->file_offset != z->start) &&
 			    (td->o.td_ddir != TD_DDIR_READ)) {
-				new_offset = (z+1)->start;
+				new_offset = zbd_zone_end(z);
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
@@ -384,6 +402,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		p->wp = p->start;
 		p->type = ZBD_ZONE_TYPE_SWR;
 		p->cond = ZBD_ZONE_COND_EMPTY;
+		p->capacity = zone_size;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
@@ -456,10 +475,11 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			mutex_init_pshared_with_type(&p->mutex,
 						     PTHREAD_MUTEX_RECURSIVE);
 			p->start = z->start;
+			p->capacity = z->capacity;
 			switch (z->cond) {
 			case ZBD_ZONE_COND_NOT_WP:
 			case ZBD_ZONE_COND_FULL:
-				p->wp = p->start + zone_size;
+				p->wp = p->start + p->capacity;
 				break;
 			default:
 				assert(z->start <= z->wp);
@@ -707,7 +727,7 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, z));
 
-	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
+	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);
 }
 
 /* The caller must hold f->zbd_info->mutex */
@@ -1068,7 +1088,7 @@ found_candidate_zone:
 	/* Both z->mutex and f->zbd_info->mutex are held. */
 
 examine_zone:
-	if (z->wp + min_bs <= (z+1)->start) {
+	if (z->wp + min_bs <= zbd_zone_capacity_end(z)) {
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
@@ -1112,7 +1132,7 @@ examine_zone:
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		zone_lock(td, f, z);
-		if (z->wp + min_bs <= (z+1)->start)
+		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
@@ -1143,9 +1163,9 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 		assert(z);
 	}
 
-	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
+	if (z->verify_block * min_bs >= z->capacity)
 		log_err("%s: %d * %d >= %llu\n", f->file_name, z->verify_block,
-			min_bs, (unsigned long long) f->zbd_info->zone_size);
+			min_bs, (unsigned long long)z->capacity);
 	io_u->offset = z->start + z->verify_block++ * min_bs;
 	return z;
 }
@@ -1231,7 +1251,7 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 	switch (io_u->ddir) {
 	case DDIR_WRITE:
 		zone_end = min((uint64_t)(io_u->offset + io_u->buflen),
-			       (z + 1)->start);
+			       zbd_zone_capacity_end(z));
 		pthread_mutex_lock(&zbd_info->mutex);
 		/*
 		 * z->wp > zone_end means that one or more I/O errors
@@ -1327,6 +1347,26 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
 
+	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
+	z = &f->zbd_info->zone_info[zone_idx];
+
+	/*
+	 * When the zone capacity is smaller than the zone size and the I/O is
+	 * sequential write, skip to zone end if the latest position is at the
+	 * zone capacity limit.
+	 */
+	if (z->capacity < f->zbd_info->zone_size && !td_random(td) &&
+	    ddir == DDIR_WRITE &&
+	    f->last_pos[ddir] >= zbd_zone_capacity_end(z)) {
+		dprint(FD_ZBD,
+		       "%s: Jump from zone capacity limit to zone end:"
+		       " (%lu -> %lu) for zone %u (%ld)\n",
+		       f->file_name, f->last_pos[ddir], zbd_zone_end(z),
+		       zbd_zone_nr(f->zbd_info, z), z->capacity);
+		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
+		f->last_pos[ddir] = zbd_zone_end(z);
+	}
+
 	/*
 	 * zone_skip is valid only for sequential workloads.
 	 */
@@ -1340,11 +1380,8 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	 * - For reads with td->o.read_beyond_wp == false, the last position
 	 *   reached the zone write pointer.
 	 */
-	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
-	z = &f->zbd_info->zone_info[zone_idx];
-
 	if (td->zone_bytes >= td->o.zone_size ||
-	    f->last_pos[ddir] >= (z+1)->start ||
+	    f->last_pos[ddir] >= zbd_zone_end(z) ||
 	    (ddir == DDIR_READ &&
 	     (!td->o.read_beyond_wp) && f->last_pos[ddir] >= z->wp)) {
 		/*
@@ -1530,6 +1567,13 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
+
+			if (zb->capacity < min_bs) {
+				log_err("zone capacity %llu smaller than minimum block size %d\n",
+					(unsigned long long)zb->capacity,
+					min_bs);
+				goto eof;
+			}
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
@@ -1545,7 +1589,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * small.
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
-			      (zb + 1)->start - io_u->offset);
+			      zbd_zone_capacity_end(zb) - io_u->offset);
 		new_len = new_len / min_bs * min_bs;
 		if (new_len == io_u->buflen)
 			goto accept;
@@ -1556,7 +1600,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			((zb + 1)->start - io_u->offset),
+			(zbd_zone_capacity_end(zb) - io_u->offset),
 			min_bs);
 		goto eof;
 	case DDIR_TRIM:
diff --git a/zbd.h b/zbd.h
index e942a7f6..021174c1 100644
--- a/zbd.h
+++ b/zbd.h
@@ -23,6 +23,7 @@ enum io_u_action {
  * struct fio_zone_info - information about a single ZBD zone
  * @start: zone start location (bytes)
  * @wp: zone write pointer location (bytes)
+ * @capacity: maximum size usable from the start of a zone (bytes)
  * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
@@ -35,6 +36,7 @@ struct fio_zone_info {
 	pthread_mutex_t		mutex;
 	uint64_t		start;
 	uint64_t		wp;
+	uint64_t		capacity;
 	uint32_t		verify_block;
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
diff --git a/zbd_types.h b/zbd_types.h
index d63c0d0a..5ed41aa0 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -50,6 +50,7 @@ struct zbd_zone {
 	uint64_t		start;
 	uint64_t		wp;
 	uint64_t		len;
+	uint64_t		capacity;
 	enum zbd_zone_type	type;
 	enum zbd_zone_cond	cond;
 };
-- 
2.26.2


