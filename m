Return-Path: <prvs=845b5b8a0=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 2/5] zbd: Support zone reset by trim
Date: Fri,  6 Aug 2021 10:07:08 +0900
Message-Id: <20210806010711.1128153-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
References: <20210806010711.1128153-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Enable trim workload for zonemode=zbd by modifying do_io_u_trim() to
call zoned block device unique function zbd_do_io_u_trim() which resets
the target zone. This allows fio to emulate workloads which mix data
read/write and zone resets with zonemode=zbd.

To call reset zones, the trim I/O shall have offset aligned to zone
start and block size same as zone size. Reset zone is called only to
sequential write required zones and sequential write preferred zones.
Conventional zones are handled in same manner as regular block devices
by calling os_trim() function.

When zones are reset with random trim workload, choose only non-empty
zones as trim target. This avoids meaningless trim to empty zones and
makes the workload more realistic. To find the non-empty zones, utilize
zbd_find_zone() helper function which is already used for read workload,
specifying 1 byte as the minimum valid data size.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 io_u.c |  9 ++++++++
 zbd.c  | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 zbd.h  |  2 ++
 3 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/io_u.c b/io_u.c
index 9a1cd547..696d25cd 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2317,10 +2317,19 @@ int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	int ret;
 
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		ret = zbd_do_io_u_trim(td, io_u);
+		if (ret == io_u_completed)
+			return io_u->xfer_buflen;
+		if (ret)
+			goto err;
+	}
+
 	ret = os_trim(f, io_u->offset, io_u->xfer_buflen);
 	if (!ret)
 		return io_u->xfer_buflen;
 
+err:
 	io_u->error = ret;
 	return 0;
 #endif
diff --git a/zbd.c b/zbd.c
index 859c7feb..1b933ce4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -375,12 +375,24 @@ static bool zbd_verify_bs(void)
 	int i, j, k;
 
 	for_each_td(td, i) {
+		if (td_trim(td) &&
+		    (td->o.min_bs[DDIR_TRIM] != td->o.max_bs[DDIR_TRIM] ||
+		     td->o.bssplit_nr[DDIR_TRIM])) {
+			log_info("bsrange and bssplit are not allowed for trim with zonemode=zbd\n");
+			return false;
+		}
 		for_each_file(td, f, j) {
 			uint64_t zone_size;
 
 			if (!f->zbd_info)
 				continue;
 			zone_size = f->zbd_info->zone_size;
+			if (td_trim(td) && td->o.bs[DDIR_TRIM] != zone_size) {
+				log_info("%s: trim block size %llu is not the zone size %llu\n",
+					 f->file_name, td->o.bs[DDIR_TRIM],
+					 (unsigned long long)zone_size);
+				return false;
+			}
 			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
@@ -1529,9 +1541,6 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
-	case DDIR_TRIM:
-		assert(z->wp == z->start);
-		break;
 	default:
 		break;
 	}
@@ -1911,8 +1920,23 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			(zbd_zone_capacity_end(zb) - io_u->offset), min_bs);
 		goto eof;
 	case DDIR_TRIM:
-		/* fall-through */
+		/* Check random trim targets a non-empty zone */
+		if (!td_random(td) || zb->wp > zb->start)
+			goto accept;
+
+		/* Find out a non-empty zone to trim */
+		zone_unlock(zb);
+		zl = get_zone(f, f->max_zone);
+		zb = zbd_find_zone(td, io_u, 1, zb, zl);
+		if (zb) {
+			io_u->offset = zb->start;
+			dprint(FD_ZBD, "%s: found new zone(%lld) for trim\n",
+			       f->file_name, io_u->offset);
+			goto accept;
+		}
+		goto eof;
 	case DDIR_SYNC:
+		/* fall-through */
 	case DDIR_DATASYNC:
 	case DDIR_SYNC_FILE_RANGE:
 	case DDIR_WAIT:
@@ -1953,3 +1977,38 @@ char *zbd_write_status(const struct thread_stat *ts)
 		return NULL;
 	return res;
 }
+
+/**
+ * zbd_do_io_u_trim - If reset zone is applicable, do reset zone instead of trim
+ *
+ * @td: FIO thread data.
+ * @io_u: FIO I/O unit.
+ *
+ * It is assumed that z->mutex is already locked.
+ * Return io_u_completed when reset zone succeeds. Return 0 when the target zone
+ * does not have write pointer. On error, return negative errno.
+ */
+int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_zone_info *z;
+	uint32_t zone_idx;
+	int ret;
+
+	zone_idx = zbd_zone_idx(f, io_u->offset);
+	z = get_zone(f, zone_idx);
+
+	if (!z->has_wp)
+		return 0;
+
+	if (io_u->offset != z->start) {
+		log_err("Trim offset not at zone start (%lld)\n", io_u->offset);
+		return -EINVAL;
+	}
+
+	ret = zbd_reset_zone((struct thread_data *)td, f, z);
+	if (ret < 0)
+		return ret;
+
+	return io_u_completed;
+}
diff --git a/zbd.h b/zbd.h
index 39dc45e3..0a73b41d 100644
--- a/zbd.h
+++ b/zbd.h
@@ -17,6 +17,7 @@ struct fio_file;
 enum io_u_action {
 	io_u_accept	= 0,
 	io_u_eof	= 1,
+	io_u_completed  = 2,
 };
 
 /**
@@ -99,6 +100,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 			      enum fio_ddir ddir);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 char *zbd_write_status(const struct thread_stat *ts);
+int zbd_do_io_u_trim(const struct thread_data *td, struct io_u *io_u);
 
 static inline void zbd_close_file(struct fio_file *f)
 {
-- 
2.31.1


