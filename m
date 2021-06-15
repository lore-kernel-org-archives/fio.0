Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFOMCL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Jun 2021 08:02:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE1BC061574
        for <fio@vger.kernel.org>; Tue, 15 Jun 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lt7ja-007pEx-Rq
        for fio@vger.kernel.org; Tue, 15 Jun 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210615120001.74F071BC00F4@kernel.dk>
Date: Tue, 15 Jun 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dd4620b7f9171edaa10955c4826454a05af27c85:

  io_uring: drop redundant IO_MODE_OFFLOAD check (2021-06-10 16:40:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a59b12d2a5eb92c1128a5d8ebcd03b1831962ce5:

  t/zbd: update test case 42 (2021-06-14 08:54:56 -0600)

----------------------------------------------------------------
Niklas Cassel (5):
      zbd: disallow pipes for zonemode=zbd
      zbd: allow zonemode=zbd with regular files by emulating zones
      zbd: remove zbd_zoned_model ZBD_IGNORE
      zbd: change some f->zbd_info conditionals to asserts
      t/zbd: update test case 42

 engines/libzbc.c            |  6 ++----
 engines/skeleton_external.c |  1 -
 oslib/linux-blkzoned.c      |  6 ++----
 t/zbd/test-zbd-support      |  2 +-
 zbd.c                       | 37 +++++++++++++++++++++++++------------
 zbd_types.h                 |  7 +++----
 6 files changed, 33 insertions(+), 26 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 3dde93db..7f2bc431 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -180,10 +180,8 @@ static int libzbc_get_zoned_model(struct thread_data *td, struct fio_file *f,
 	struct libzbc_data *ld;
 	int ret;
 
-	if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR) {
-		*model = ZBD_IGNORE;
-		return 0;
-	}
+	if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR)
+		return -EINVAL;
 
 	ret = libzbc_open_dev(td, f, &ld);
 	if (ret)
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index c79b6f11..cff83a10 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -156,7 +156,6 @@ static int fio_skeleton_close(struct thread_data *td, struct fio_file *f)
 /*
  * Hook for getting the zoned model of a zoned block device for zonemode=zbd.
  * The zoned model can be one of (see zbd_types.h):
- * - ZBD_IGNORE: skip regular files
  * - ZBD_NONE: regular block device (zone emulation will be used)
  * - ZBD_HOST_AWARE: host aware zoned block device
  * - ZBD_HOST_MANAGED: host managed zoned block device
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 6f89ec6f..4e441d29 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -140,10 +140,8 @@ int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
 {
 	char *model_str = NULL;
 
-	if (f->filetype != FIO_TYPE_BLOCK) {
-		*model = ZBD_IGNORE;
-		return 0;
-	}
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EINVAL;
 
 	*model = ZBD_NONE;
 
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index a684f988..57e6d05e 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -922,7 +922,7 @@ test41() {
 test42() {
     require_regular_block_dev || return $SKIP_TESTCASE
     read_one_block --zonemode=zbd --zonesize=0 |
-	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
+	grep -q 'Specifying the zone size is mandatory for regular file/block device with --zonemode=zbd'
 }
 
 # Check whether fio handles --zonesize=1 correctly for regular block devices.
diff --git a/zbd.c b/zbd.c
index 5d9e331a..8e99eb95 100644
--- a/zbd.c
+++ b/zbd.c
@@ -32,6 +32,17 @@ int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
 {
 	int ret;
 
+	if (f->filetype == FIO_TYPE_PIPE) {
+		log_err("zonemode=zbd does not support pipes\n");
+		return -EINVAL;
+	}
+
+	/* If regular file, always emulate zones inside the file. */
+	if (f->filetype == FIO_TYPE_FILE) {
+		*model = ZBD_NONE;
+		return 0;
+	}
+
 	if (td->io_ops && td->io_ops->get_zoned_model)
 		ret = td->io_ops->get_zoned_model(td, f, model);
 	else
@@ -409,7 +420,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	int i;
 
 	if (zone_size == 0) {
-		log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
+		log_err("%s: Specifying the zone size is mandatory for regular file/block device with --zonemode=zbd\n\n",
 			f->file_name);
 		return 1;
 	}
@@ -430,6 +441,12 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
+	if (f->real_file_size < zone_size) {
+		log_err("%s: file/device size %"PRIu64" is smaller than zone size %"PRIu64"\n",
+			f->file_name, f->real_file_size, zone_size);
+		return -EINVAL;
+	}
+
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -644,8 +661,6 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return ret;
 
 	switch (zbd_model) {
-	case ZBD_IGNORE:
-		return 0;
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
 		ret = parse_zone_info(td, f);
@@ -663,6 +678,7 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return -EINVAL;
 	}
 
+	assert(f->zbd_info);
 	f->zbd_info->model = zbd_model;
 
 	ret = zbd_set_max_open_zones(td, f);
@@ -792,8 +808,7 @@ int zbd_setup_files(struct thread_data *td)
 		struct fio_zone_info *z;
 		int zi;
 
-		if (!zbd)
-			continue;
+		assert(zbd);
 
 		f->min_zone = zbd_zone_idx(f, f->file_offset);
 		f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
@@ -1454,8 +1469,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 	uint32_t zone_idx;
 	uint64_t zone_end;
 
-	if (!zbd_info)
-		return;
+	assert(zbd_info);
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
@@ -1515,8 +1529,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
 
-	if (!zbd_info)
-		return;
+	assert(zbd_info);
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
@@ -1572,6 +1585,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
 	assert(td->o.zone_size);
+	assert(f->zbd_info);
 
 	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
 	z = get_zone(f, zone_idx);
@@ -1646,6 +1660,7 @@ enum fio_ddir zbd_adjust_ddir(struct thread_data *td, struct io_u *io_u,
 	 * devices with all empty zones. Overwrite the first I/O direction as
 	 * write to make sure data to read exists.
 	 */
+	assert(io_u->file->zbd_info);
 	if (ddir != DDIR_READ || !td_rw(td))
 		return ddir;
 
@@ -1675,9 +1690,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	uint64_t new_len;
 	int64_t range;
 
-	if (!f->zbd_info)
-		return io_u_accept;
-
+	assert(f->zbd_info);
 	assert(min_bs);
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
diff --git a/zbd_types.h b/zbd_types.h
index 5ed41aa0..0a8630cb 100644
--- a/zbd_types.h
+++ b/zbd_types.h
@@ -14,10 +14,9 @@
  * Zoned block device models.
  */
 enum zbd_zoned_model {
-	ZBD_IGNORE,		/* Ignore file */
-	ZBD_NONE,		/* Regular block device */
-	ZBD_HOST_AWARE,		/* Host-aware zoned block device */
-	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */
+	ZBD_NONE		= 0x1,	/* No zone support. Emulate zones. */
+	ZBD_HOST_AWARE		= 0x2,	/* Host-aware zoned block device */
+	ZBD_HOST_MANAGED	= 0x3,	/* Host-managed zoned block device */
 };
 
 /*

