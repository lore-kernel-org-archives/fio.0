Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbhHGMAm (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 7 Aug 2021 08:00:42 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666AEC0613CF
        for <fio@vger.kernel.org>; Sat,  7 Aug 2021 05:00:25 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCKzl-0095lw-TY
        for fio@vger.kernel.org; Sat, 07 Aug 2021 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210807120002.3A14A1BC0139@kernel.dk>
Date: Sat,  7 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2459bd33b3dbb7a34f28c612d595311a6bc7593d:

  ioengines: fix crash with --enghelp option (2021-08-04 12:49:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to faff87e6f0da68853908652a95f0ec40dd12869d:

  t/zbd: Add test #58 to test zone reset by trim workload (2021-08-06 16:39:31 -0600)

----------------------------------------------------------------
Shin'ichiro Kawasaki (5):
      zbd: Add min_bytes argument to zbd_find_zone()
      zbd: Support zone reset by trim
      engines/libzbc: Enable trim for libzbc I/O engine
      HOWTO/man: Describe trim support by zone reset for zoned devices
      t/zbd: Add test #58 to test zone reset by trim workload

 HOWTO                  |  8 +++++
 engines/libzbc.c       | 13 ++++----
 fio.1                  |  9 +++---
 io_u.c                 |  9 ++++++
 t/zbd/test-zbd-support | 26 +++++++++++++++
 zbd.c                  | 85 +++++++++++++++++++++++++++++++++++++++++---------
 zbd.h                  |  2 ++
 7 files changed, 128 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d4e620de..04ea284b 100644
--- a/HOWTO
+++ b/HOWTO
@@ -992,6 +992,9 @@ Target file/device
 				single zone. The :option:`zoneskip` parameter
 				is ignored. :option:`zonerange` and
 				:option:`zonesize` must be identical.
+				Trim is handled using a zone reset operation.
+				Trim only considers non-empty sequential write
+				required and sequential write preferred zones.
 
 .. option:: zonerange=int
 
@@ -1965,6 +1968,11 @@ I/O engine
 			character devices. This engine supports trim operations.
 			The sg engine includes engine specific options.
 
+		**libzbc**
+			Read, write, trim and ZBC/ZAC operations to a zoned
+			block device using libzbc library. The target can be
+			either an SG character device or a block device file.
+
 		**null**
 			Doesn't transfer any data, just pretends to.  This is mainly used to
 			exercise fio itself and for debugging/testing purposes.
diff --git a/engines/libzbc.c b/engines/libzbc.c
index 7f2bc431..abee2043 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -14,6 +14,7 @@
 #include "fio.h"
 #include "err.h"
 #include "zbd_types.h"
+#include "zbd.h"
 
 struct libzbc_data {
 	struct zbc_device	*zdev;
@@ -63,7 +64,7 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 		return -EINVAL;
 	}
 
-	if (td_write(td)) {
+	if (td_write(td) || td_trim(td)) {
 		if (!read_only)
 			flags |= O_RDWR;
 	} else if (td_read(td)) {
@@ -71,10 +72,6 @@ static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
 			flags |= O_RDWR;
 		else
 			flags |= O_RDONLY;
-	} else if (td_trim(td)) {
-		td_verror(td, EINVAL, "libzbc does not support trim");
-		log_err("%s: libzbc does not support trim\n", f->file_name);
-		return -EINVAL;
 	}
 
 	if (td->o.oatomic) {
@@ -411,7 +408,11 @@ static enum fio_q_status libzbc_queue(struct thread_data *td, struct io_u *io_u)
 		ret = zbc_flush(ld->zdev);
 		if (ret)
 			log_err("zbc_flush error %zd\n", ret);
-	} else if (io_u->ddir != DDIR_TRIM) {
+	} else if (io_u->ddir == DDIR_TRIM) {
+		ret = zbd_do_io_u_trim(td, io_u);
+		if (!ret)
+			ret = EINVAL;
+	} else {
 		log_err("Unsupported operation %u\n", io_u->ddir);
 		ret = -EINVAL;
 	}
diff --git a/fio.1 b/fio.1
index 9c12ad13..ff100a1c 100644
--- a/fio.1
+++ b/fio.1
@@ -766,6 +766,8 @@ starts. The \fBzonecapacity\fR parameter is ignored.
 Zoned block device mode. I/O happens sequentially in each zone, even if random
 I/O has been selected. Random I/O happens across all zones instead of being
 restricted to a single zone.
+Trim is handled using a zone reset operation. Trim only considers non-empty
+sequential write required and sequential write preferred zones.
 .RE
 .RE
 .TP
@@ -1761,10 +1763,9 @@ character devices. This engine supports trim operations. The
 sg engine includes engine specific options.
 .TP
 .B libzbc
-Synchronous I/O engine for SMR hard-disks using the \fBlibzbc\fR
-library. The target can be either an sg character device or
-a block device file. This engine supports the zonemode=zbd zone
-operations.
+Read, write, trim and ZBC/ZAC operations to a zoned block device using
+\fBlibzbc\fR library. The target can be either an SG character device or
+a block device file.
 .TP
 .B null
 Doesn't transfer any data, just pretends to. This is mainly used to
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
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 57e6d05e..5103c406 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1215,6 +1215,32 @@ test57() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# Random writes and random trims to sequential write required zones for 30s.
+test58() {
+    local off size bs
+
+    require_seq_zones 128 || return $SKIP_TESTCASE
+
+    size=$((zone_size * 128))
+    bs="$(max $((zone_size / 128)) "$logical_block_size")"
+    prep_write
+    off=$((first_sequential_zone_sector * 512))
+    run_fio --zonemode=zbd --direct=1 --zonesize="${zone_size}" --thread=1 \
+	    --filename="${dev}" --norandommap=1 \
+            --name="precondition"  --rw=write "$(ioengine "psync")" \
+            --offset="${off}" --size=$((zone_size * 16)) --bs="${bs}" \
+	    "${job_var_opts[@]}" \
+	    --name=wjob --wait_for="precondition" --rw=randwrite \
+	    "$(ioengine "libaio")" --iodepth=8 \
+	    --offset="${off}" --size="${size}" --bs="${bs}" \
+	    --time_based --runtime=30s --flow=128 "${job_var_opts[@]}" \
+	    --name=trimjob --wait_for="precondition" --rw=randtrim \
+	    "$(ioengine "psync")" \
+	    --offset="${off}" --size="${size}" --bs="${zone_size}" \
+	    --time_based --runtime=30s --flow=1 "${job_var_opts[@]}" \
+	    >>"${logfile}.${test_number}" 2>&1
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/zbd.c b/zbd.c
index 43f12b45..1b933ce4 100644
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
@@ -1414,18 +1426,16 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 }
 
 /*
- * Find another zone for which @io_u fits in the readable data in the zone.
- * Search in zones @zb + 1 .. @zl. For random workload, also search in zones
- * @zb - 1 .. @zf.
+ * Find another zone which has @min_bytes of readable data. Search in zones
+ * @zb + 1 .. @zl. For random workload, also search in zones @zb - 1 .. @zf.
  *
  * Either returns NULL or returns a zone pointer. When the zone has write
  * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
-zbd_find_zone(struct thread_data *td, struct io_u *io_u,
+zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
 	      struct fio_zone_info *zb, struct fio_zone_info *zl)
 {
-	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
 	const struct fio_zone_info *const zf = get_zone(f, f->min_zone);
@@ -1438,7 +1448,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
 			if (z1->has_wp)
 				zone_lock(td, f, z1);
-			if (z1->start + min_bs <= z1->wp)
+			if (z1->start + min_bytes <= z1->wp)
 				return z1;
 			if (z1->has_wp)
 				zone_unlock(z1);
@@ -1449,14 +1459,14 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
 			if (z2->has_wp)
 				zone_lock(td, f, z2);
-			if (z2->start + min_bs <= z2->wp)
+			if (z2->start + min_bytes <= z2->wp)
 				return z2;
 			if (z2->has_wp)
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
-	       f->file_name);
+	dprint(FD_ZBD, "%s: no zone has %d bytes of readable data\n",
+	       f->file_name, min_bytes);
 	return NULL;
 }
 
@@ -1531,9 +1541,6 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
-	case DDIR_TRIM:
-		assert(z->wp == z->start);
-		break;
 	default:
 		break;
 	}
@@ -1785,7 +1792,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			zone_unlock(zb);
 			zl = get_zone(f, f->max_zone);
-			zb = zbd_find_zone(td, io_u, zb, zl);
+			zb = zbd_find_zone(td, io_u, min_bs, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
 				       "%s: zbd_find_zone(%lld, %llu) failed\n",
@@ -1913,8 +1920,23 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
@@ -1955,3 +1977,38 @@ char *zbd_write_status(const struct thread_stat *ts)
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

