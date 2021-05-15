Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhEOMBV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 May 2021 08:01:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AB0C061573
        for <fio@vger.kernel.org>; Sat, 15 May 2021 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lhsxh-00AFoS-IJ
        for fio@vger.kernel.org; Sat, 15 May 2021 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210515120001.9387D1BC0165@kernel.dk>
Date: Sat, 15 May 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 30bec59eab3908b681cbc2866179f7166a849c83:

  os: define EDQUOT to EIO if the OS doesn't provide it (2021-05-11 07:58:03 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dfecde6a4b49bd299b2a7192c10533b9beb4820d:

  Merge branch '2021-05-13/stat-fix-integer-overflow' of https://github.com/flx42/fio (2021-05-14 09:36:59 -0600)

----------------------------------------------------------------
Felix Abecassis (1):
      stat: fix integer overflow in convert_agg_kbytes_percent

Jens Axboe (1):
      Merge branch '2021-05-13/stat-fix-integer-overflow' of https://github.com/flx42/fio

Niklas Cassel (4):
      zbd: only put an upper limit on max open zones once
      oslib/linux-blkzoned: move sysfs reading into its own function
      ioengines: add get_max_open_zones zoned block device operation
      engines/libzbc: add support for the get_max_open_zones io op

 engines/libzbc.c            | 21 +++++++++++
 engines/skeleton_external.c | 13 +++++++
 ioengines.h                 |  4 +-
 oslib/blkzoned.h            |  7 ++++
 oslib/linux-blkzoned.c      | 83 ++++++++++++++++++++++++++++++-----------
 stat.c                      |  2 +-
 zbd.c                       | 91 ++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 191 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libzbc.c b/engines/libzbc.c
index 2aacf7bb..3dde93db 100644
--- a/engines/libzbc.c
+++ b/engines/libzbc.c
@@ -19,6 +19,7 @@ struct libzbc_data {
 	struct zbc_device	*zdev;
 	enum zbc_dev_model	model;
 	uint64_t		nr_sectors;
+	uint32_t		max_open_seq_req;
 };
 
 static int libzbc_get_dev_info(struct libzbc_data *ld, struct fio_file *f)
@@ -32,6 +33,7 @@ static int libzbc_get_dev_info(struct libzbc_data *ld, struct fio_file *f)
 	zbc_get_device_info(ld->zdev, zinfo);
 	ld->model = zinfo->zbd_model;
 	ld->nr_sectors = zinfo->zbd_sectors;
+	ld->max_open_seq_req = zinfo->zbd_max_nr_open_seq_req;
 
 	dprint(FD_ZBD, "%s: vendor_id:%s, type: %s, model: %s\n",
 	       f->file_name, zinfo->zbd_vendor_id,
@@ -335,6 +337,24 @@ err:
 	return -ret;
 }
 
+static int libzbc_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				     unsigned int *max_open_zones)
+{
+	struct libzbc_data *ld;
+	int ret;
+
+	ret = libzbc_open_dev(td, f, &ld);
+	if (ret)
+		return ret;
+
+	if (ld->max_open_seq_req == ZBC_NO_LIMIT)
+		*max_open_zones = 0;
+	else
+		*max_open_zones = ld->max_open_seq_req;
+
+	return 0;
+}
+
 ssize_t libzbc_rw(struct thread_data *td, struct io_u *io_u)
 {
 	struct libzbc_data *ld = td->io_ops_data;
@@ -414,6 +434,7 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model	= libzbc_get_zoned_model,
 	.report_zones		= libzbc_report_zones,
 	.reset_wp		= libzbc_reset_wp,
+	.get_max_open_zones	= libzbc_get_max_open_zones,
 	.queue			= libzbc_queue,
 	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
 };
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index 7f3e4cb3..c79b6f11 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -193,6 +193,18 @@ static int fio_skeleton_reset_wp(struct thread_data *td, struct fio_file *f,
 	return 0;
 }
 
+/*
+ * Hook called for getting the maximum number of open zones for a
+ * ZBD_HOST_MANAGED zoned block device.
+ * A @max_open_zones value set to zero means no limit.
+ */
+static int fio_skeleton_get_max_open_zones(struct thread_data *td,
+					   struct fio_file *f,
+					   unsigned int *max_open_zones)
+{
+	return 0;
+}
+
 /*
  * Note that the structure is exported, so that fio can get it via
  * dlsym(..., "ioengine"); for (and only for) external engines.
@@ -212,6 +224,7 @@ struct ioengine_ops ioengine = {
 	.get_zoned_model = fio_skeleton_get_zoned_model,
 	.report_zones	= fio_skeleton_report_zones,
 	.reset_wp	= fio_skeleton_reset_wp,
+	.get_max_open_zones = fio_skeleton_get_max_open_zones,
 	.options	= options,
 	.option_struct_size	= sizeof(struct fio_skeleton_options),
 };
diff --git a/ioengines.h b/ioengines.h
index 1d01ab0a..b3f755b4 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -8,7 +8,7 @@
 #include "io_u.h"
 #include "zbd_types.h"
 
-#define FIO_IOOPS_VERSION	29
+#define FIO_IOOPS_VERSION	30
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -59,6 +59,8 @@ struct ioengine_ops {
 			    uint64_t, struct zbd_zone *, unsigned int);
 	int (*reset_wp)(struct thread_data *, struct fio_file *,
 			uint64_t, uint64_t);
+	int (*get_max_open_zones)(struct thread_data *, struct fio_file *,
+				  unsigned int *);
 	int option_struct_size;
 	struct fio_option *options;
 };
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
index 4cc071dc..719b041d 100644
--- a/oslib/blkzoned.h
+++ b/oslib/blkzoned.h
@@ -16,6 +16,8 @@ extern int blkzoned_report_zones(struct thread_data *td,
 				struct zbd_zone *zones, unsigned int nr_zones);
 extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 				uint64_t offset, uint64_t length);
+extern int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				       unsigned int *max_open_zones);
 #else
 /*
  * Define stubs for systems that do not have zoned block device support.
@@ -44,6 +46,11 @@ static inline int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 {
 	return -EIO;
 }
+static inline int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+					      unsigned int *max_open_zones)
+{
+	return -EIO;
+}
 #endif
 
 #endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 81e4e7f0..6f89ec6f 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -74,12 +74,16 @@ static char *read_file(const char *path)
 	return strdup(line);
 }
 
-int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
-			     enum zbd_zoned_model *model)
+/*
+ * Get the value of a sysfs attribute for a block device.
+ *
+ * Returns NULL on failure.
+ * Returns a pointer to a string on success.
+ * The caller is responsible for freeing the memory.
+ */
+static char *blkzoned_get_sysfs_attr(const char *file_name, const char *attr)
 {
-	const char *file_name = f->file_name;
-	char *zoned_attr_path = NULL;
-	char *model_str = NULL;
+	char *attr_path = NULL;
 	struct stat statbuf;
 	char *sys_devno_path = NULL;
 	char *part_attr_path = NULL;
@@ -87,13 +91,7 @@ int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
 	char sys_path[PATH_MAX];
 	ssize_t sz;
 	char *delim = NULL;
-
-	if (f->filetype != FIO_TYPE_BLOCK) {
-		*model = ZBD_IGNORE;
-		return 0;
-	}
-
-	*model = ZBD_NONE;
+	char *attr_str = NULL;
 
 	if (stat(file_name, &statbuf) < 0)
 		goto out;
@@ -123,24 +121,65 @@ int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
 		*delim = '\0';
 	}
 
-	if (asprintf(&zoned_attr_path,
-		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
+	if (asprintf(&attr_path,
+		     "/sys/dev/block/%s/%s", sys_path, attr) < 0)
 		goto out;
 
-	model_str = read_file(zoned_attr_path);
+	attr_str = read_file(attr_path);
+out:
+	free(attr_path);
+	free(part_str);
+	free(part_attr_path);
+	free(sys_devno_path);
+
+	return attr_str;
+}
+
+int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model)
+{
+	char *model_str = NULL;
+
+	if (f->filetype != FIO_TYPE_BLOCK) {
+		*model = ZBD_IGNORE;
+		return 0;
+	}
+
+	*model = ZBD_NONE;
+
+	model_str = blkzoned_get_sysfs_attr(f->file_name, "queue/zoned");
 	if (!model_str)
-		goto out;
-	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);
+		return 0;
+
+	dprint(FD_ZBD, "%s: zbd model string: %s\n", f->file_name, model_str);
 	if (strcmp(model_str, "host-aware") == 0)
 		*model = ZBD_HOST_AWARE;
 	else if (strcmp(model_str, "host-managed") == 0)
 		*model = ZBD_HOST_MANAGED;
-out:
+
 	free(model_str);
-	free(zoned_attr_path);
-	free(part_str);
-	free(part_attr_path);
-	free(sys_devno_path);
+
+	return 0;
+}
+
+int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+				unsigned int *max_open_zones)
+{
+	char *max_open_str;
+
+	if (f->filetype != FIO_TYPE_BLOCK)
+		return -EIO;
+
+	max_open_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_zones");
+	if (!max_open_str)
+		return 0;
+
+	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",
+	       f->file_name, max_open_str);
+	*max_open_zones = atoll(max_open_str);
+
+	free(max_open_str);
+
 	return 0;
 }
 
diff --git a/stat.c b/stat.c
index b7222f46..a8a96c85 100644
--- a/stat.c
+++ b/stat.c
@@ -462,7 +462,7 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
 {
 	double p_of_agg = 100.0;
 	if (rs && rs->agg[ddir] > 1024) {
-		p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024.0);
+		p_of_agg = mean * 100.0 / (double) (rs->agg[ddir] / 1024.0);
 
 		if (p_of_agg > 100.0)
 			p_of_agg = 100.0;
diff --git a/zbd.c b/zbd.c
index eed796b3..68cd58e1 100644
--- a/zbd.c
+++ b/zbd.c
@@ -113,6 +113,34 @@ int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
 	return ret;
 }
 
+/**
+ * zbd_get_max_open_zones - Get the maximum number of open zones
+ * @td: FIO thread data
+ * @f: FIO file for which to get max open zones
+ * @max_open_zones: Upon success, result will be stored here.
+ *
+ * A @max_open_zones value set to zero means no limit.
+ *
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+int zbd_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+			   unsigned int *max_open_zones)
+{
+	int ret;
+
+	if (td->io_ops && td->io_ops->get_max_open_zones)
+		ret = td->io_ops->get_max_open_zones(td, f, max_open_zones);
+	else
+		ret = blkzoned_get_max_open_zones(td, f, max_open_zones);
+	if (ret < 0) {
+		td_verror(td, errno, "get max open zones failed");
+		log_err("%s: get max open zones failed (%d).\n",
+			f->file_name, errno);
+	}
+
+	return ret;
+}
+
 /**
  * zbd_zone_idx - convert an offset into a zone number
  * @f: file pointer.
@@ -554,6 +582,51 @@ out:
 	return ret;
 }
 
+static int zbd_set_max_open_zones(struct thread_data *td, struct fio_file *f)
+{
+	struct zoned_block_device_info *zbd = f->zbd_info;
+	unsigned int max_open_zones;
+	int ret;
+
+	if (zbd->model != ZBD_HOST_MANAGED) {
+		/* Only host-managed devices have a max open limit */
+		zbd->max_open_zones = td->o.max_open_zones;
+		goto out;
+	}
+
+	/* If host-managed, get the max open limit */
+	ret = zbd_get_max_open_zones(td, f, &max_open_zones);
+	if (ret)
+		return ret;
+
+	if (!max_open_zones) {
+		/* No device limit */
+		zbd->max_open_zones = td->o.max_open_zones;
+	} else if (!td->o.max_open_zones) {
+		/* No user limit. Set limit to device limit */
+		zbd->max_open_zones = max_open_zones;
+	} else if (td->o.max_open_zones <= max_open_zones) {
+		/* Both user limit and dev limit. User limit not too large */
+		zbd->max_open_zones = td->o.max_open_zones;
+	} else {
+		/* Both user limit and dev limit. User limit too large */
+		td_verror(td, EINVAL,
+			  "Specified --max_open_zones is too large");
+		log_err("Specified --max_open_zones (%d) is larger than max (%u)\n",
+			td->o.max_open_zones, max_open_zones);
+		return -EINVAL;
+	}
+
+out:
+	/* Ensure that the limit is not larger than FIO's internal limit */
+	zbd->max_open_zones = min_not_zero(zbd->max_open_zones,
+					   (uint32_t) ZBD_MAX_OPEN_ZONES);
+	dprint(FD_ZBD, "%s: using max open zones limit: %"PRIu32"\n",
+	       f->file_name, zbd->max_open_zones);
+
+	return 0;
+}
+
 /*
  * Allocate zone information and store it into f->zbd_info if zonemode=zbd.
  *
@@ -576,9 +649,13 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
 		ret = parse_zone_info(td, f);
+		if (ret)
+			return ret;
 		break;
 	case ZBD_NONE:
 		ret = init_zone_info(td, f);
+		if (ret)
+			return ret;
 		break;
 	default:
 		td_verror(td, EINVAL, "Unsupported zoned model");
@@ -586,11 +663,15 @@ static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 		return -EINVAL;
 	}
 
-	if (ret == 0) {
-		f->zbd_info->model = zbd_model;
-		f->zbd_info->max_open_zones = td->o.max_open_zones;
+	f->zbd_info->model = zbd_model;
+
+	ret = zbd_set_max_open_zones(td, f);
+	if (ret) {
+		zbd_free_zone_info(f);
+		return ret;
 	}
-	return ret;
+
+	return 0;
 }
 
 void zbd_free_zone_info(struct fio_file *f)
@@ -726,8 +807,6 @@ int zbd_setup_files(struct thread_data *td)
 		if (zbd_is_seq_job(f))
 			assert(f->min_zone < f->max_zone);
 
-		zbd->max_open_zones = zbd->max_open_zones ?: ZBD_MAX_OPEN_ZONES;
-
 		if (td->o.max_open_zones > 0 &&
 		    zbd->max_open_zones != td->o.max_open_zones) {
 			log_err("Different 'max_open_zones' values\n");

