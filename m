Return-Path: <prvs=35932a8d3=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/4] ioengines: Add zoned block device operations
Date: Tue,  7 Apr 2020 10:58:58 +0900
Message-Id: <20200407015900.1335019-3-damien.lemoal@wdc.com>
In-Reply-To: <20200407015900.1335019-1-damien.lemoal@wdc.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Define three new IO engines operations: zoned model discovery, zone
information report and zone write pointer reset. These allow an
ioengine to provide special implementation of these operations if the
system does not support them natively through system calls or on Linux
to replace the default Linux blkzoned.h ioctl based generic
implementation in oslib/linux-blkzoned.c.

FIO internal and external ioengines using direct device access
(e.g. Linux SG) or OS specific IO engines can provide an implementation
of these method to enabled zoned block device zonemode=zbd workloads.

On Linux, the IO engine zone operations have precedence over the
default zone operation implementation in oslib/linux-blkzoned.c.

This patch also increments FIO_IOOPS_VERSION to 26 and adds a
skeleton implementation of the new ioengine operations in
engines/skeleton_external.c.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 engines/skeleton_external.c | 43 +++++++++++++++++++++++++++++++++++++
 ioengines.h                 |  9 +++++++-
 zbd.c                       | 17 ++++++++++-----
 3 files changed, 63 insertions(+), 6 deletions(-)

diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 1b6625b2..7f3e4cb3 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -153,6 +153,46 @@ static int fio_skeleton_close(struct thread_data *td, struct fio_file *f)
 	return generic_close_file(td, f);
 }
 
+/*
+ * Hook for getting the zoned model of a zoned block device for zonemode=zbd.
+ * The zoned model can be one of (see zbd_types.h):
+ * - ZBD_IGNORE: skip regular files
+ * - ZBD_NONE: regular block device (zone emulation will be used)
+ * - ZBD_HOST_AWARE: host aware zoned block device
+ * - ZBD_HOST_MANAGED: host managed zoned block device
+ */
+static int fio_skeleton_get_zoned_model(struct thread_data *td,
+			struct fio_file *f, enum zbd_zoned_model *model)
+{
+	*model = ZBD_NONE;
+	return 0;
+}
+
+/*
+ * Hook called for getting zone information of a ZBD_HOST_AWARE or
+ * ZBD_HOST_MANAGED zoned block device. Up to @nr_zones zone information
+ * structures can be reported using the array zones for zones starting from
+ * @offset. The number of zones reported must be returned or a negative error
+ * code in case of error.
+ */
+static int fio_skeleton_report_zones(struct thread_data *td, struct fio_file *f,
+				     uint64_t offset, struct zbd_zone *zones,
+				     unsigned int nr_zones)
+{
+	return 0;
+}
+
+/*
+ * Hook called for resetting the write pointer position of zones of a
+ * ZBD_HOST_AWARE or ZBD_HOST_MANAGED zoned block device. The write pointer
+ * position of all zones in the range @offset..@offset + @length must be reset.
+ */
+static int fio_skeleton_reset_wp(struct thread_data *td, struct fio_file *f,
+				 uint64_t offset, uint64_t length)
+{
+	return 0;
+}
+
 /*
  * Note that the structure is exported, so that fio can get it via
  * dlsym(..., "ioengine"); for (and only for) external engines.
@@ -169,6 +209,9 @@ struct ioengine_ops ioengine = {
 	.cleanup	= fio_skeleton_cleanup,
 	.open_file	= fio_skeleton_open,
 	.close_file	= fio_skeleton_close,
+	.get_zoned_model = fio_skeleton_get_zoned_model,
+	.report_zones	= fio_skeleton_report_zones,
+	.reset_wp	= fio_skeleton_reset_wp,
 	.options	= options,
 	.option_struct_size	= sizeof(struct fio_skeleton_options),
 };
diff --git a/ioengines.h b/ioengines.h
index 01a9b586..f48b4db9 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -6,8 +6,9 @@
 #include "compiler/compiler.h"
 #include "flist.h"
 #include "io_u.h"
+#include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	25
+#define FIO_IOOPS_VERSION	26
 
 /*
  * io_ops->queue() return values
@@ -44,6 +45,12 @@ struct ioengine_ops {
 	void (*iomem_free)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
 	void (*io_u_free)(struct thread_data *, struct io_u *);
+	int (*get_zoned_model)(struct thread_data *td,
+			       struct fio_file *f, enum zbd_zoned_model *);
+	int (*report_zones)(struct thread_data *, struct fio_file *,
+			    uint64_t, struct zbd_zone *, unsigned int);
+	int (*reset_wp)(struct thread_data *, struct fio_file *,
+			uint64_t, uint64_t);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/zbd.c b/zbd.c
index b89d56c4..2a324d34 100644
--- a/zbd.c
+++ b/zbd.c
@@ -31,7 +31,10 @@ int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
 {
 	int ret;
 
-	ret = blkzoned_get_zoned_model(td, f, model);
+	if (td->io_ops && td->io_ops->get_zoned_model)
+		ret = td->io_ops->get_zoned_model(td, f, model);
+	else
+		ret = blkzoned_get_zoned_model(td, f, model);
 	if (ret < 0) {
 		td_verror(td, errno, "get zoned model failed");
 		log_err("%s: get zoned model failed (%d).\n",
@@ -62,7 +65,10 @@ int zbd_report_zones(struct thread_data *td, struct fio_file *f,
 {
 	int ret;
 
-	ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
+	if (td->io_ops && td->io_ops->report_zones)
+		ret = td->io_ops->report_zones(td, f, offset, zones, nr_zones);
+	else
+		ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
 	if (ret < 0) {
 		td_verror(td, errno, "report zones failed");
 		log_err("%s: report zones from sector %llu failed (%d).\n",
@@ -92,7 +98,10 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 {
 	int ret;
 
-	ret = blkzoned_reset_wp(td, f, offset, length);
+	if (td->io_ops && td->io_ops->reset_wp)
+		ret = td->io_ops->reset_wp(td, f, offset, length);
+	else
+		ret = blkzoned_reset_wp(td, f, offset, length);
 	if (ret < 0) {
 		td_verror(td, errno, "resetting wp failed");
 		log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
@@ -623,7 +632,6 @@ static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
 	struct fio_zone_info *zb, *ze, *z;
 	int ret = 0;
 
-	assert(f->fd != -1);
 	assert(is_valid_offset(f, offset + length - 1));
 
 	switch (f->zbd_info->model) {
@@ -699,7 +707,6 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
-	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
 		if (!zbd_zone_swr(z))
 			continue;
-- 
2.25.1


