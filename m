Return-Path: <prvs=35932a8d3=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/4] fio: Generalize zonemode=zbd
Date: Tue,  7 Apr 2020 10:58:57 +0900
Message-Id: <20200407015900.1335019-2-damien.lemoal@wdc.com>
In-Reply-To: <20200407015900.1335019-1-damien.lemoal@wdc.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Generalize the implementation of the zbd zonemode for non-linux systems
and Linux systems without the blkzoned.h header file (that is, linux
systems with a kernel predating v4.10 or kernels compiled without zoned
block device support).

The configuration option CONFIG_HAS_BLKZONED determines if the system
supports or not zoned block devices. This option can be set for Linux
only for now. If it is set, the file oslib/linux-blkzoned.c is compiled
and the 3 functions defined are used by the zbd.c code to determine a
block device zoned model, get zone information and reset zones.
For systems that do not set the CONFIG_HAS_BLKZONED option,
zonemode=zbd will be useable with regular block devices with the
zbd code emulating zones as is already done currently.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Makefile               |   8 +-
 configure              |   2 +-
 fio.h                  |   2 -
 io_u.h                 |   2 -
 options.c              |   3 +-
 oslib/blkzoned.h       |  49 ++++++
 oslib/linux-blkzoned.c | 219 +++++++++++++++++++++++
 t/run-fio-tests.py     |   2 +-
 zbd.c                  | 385 +++++++++++++++++++----------------------
 zbd.h                  |  70 +-------
 zbd_types.h            |  57 ++++++
 11 files changed, 517 insertions(+), 282 deletions(-)
 create mode 100644 oslib/blkzoned.h
 create mode 100644 oslib/linux-blkzoned.c
 create mode 100644 zbd_types.h

diff --git a/Makefile b/Makefile
index 9a5dea7f..cb314d95 100644
--- a/Makefile
+++ b/Makefile
@@ -50,7 +50,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		workqueue.c rate-submit.c optgroup.c helper_thread.c \
-		steadystate.c zone-dist.c
+		steadystate.c zone-dist.c zbd.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
@@ -160,13 +160,13 @@ endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
-ifdef CONFIG_LINUX_BLKZONED
-  SOURCE += zbd.c
-endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
+ifdef CONFIG_HAS_BLKZONED
+  SOURCE += oslib/linux-blkzoned.c
+endif
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
 endif
diff --git a/configure b/configure
index d17929f1..3093915b 100755
--- a/configure
+++ b/configure
@@ -2862,7 +2862,7 @@ if test "$valgrind_dev" = "yes"; then
   output_sym "CONFIG_VALGRIND_DEV"
 fi
 if test "$linux_blkzoned" = "yes" ; then
-  output_sym "CONFIG_LINUX_BLKZONED"
+  output_sym "CONFIG_HAS_BLKZONED"
 fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
diff --git a/fio.h b/fio.h
index 2a9eef45..bbf057c1 100644
--- a/fio.h
+++ b/fio.h
@@ -172,8 +172,6 @@ struct zone_split_index {
 	uint64_t size_prev;
 };
 
-#define FIO_MAX_OPEN_ZBD_ZONES 128
-
 /*
  * This describes a single thread/process executing a fio job.
  */
diff --git a/io_u.h b/io_u.h
index 0f63cdd0..87c29201 100644
--- a/io_u.h
+++ b/io_u.h
@@ -93,7 +93,6 @@ struct io_u {
 		struct workqueue_work work;
 	};
 
-#ifdef CONFIG_LINUX_BLKZONED
 	/*
 	 * ZBD mode zbd_queue_io callback: called after engine->queue operation
 	 * to advance a zone write pointer and eventually unlock the I/O zone.
@@ -108,7 +107,6 @@ struct io_u {
 	 * or commit of an async I/O to unlock the I/O target zone.
 	 */
 	void (*zbd_put_io)(const struct io_u *);
-#endif
 
 	/*
 	 * Callback for io completion
diff --git a/options.c b/options.c
index 4714a3a1..2372c042 100644
--- a/options.c
+++ b/options.c
@@ -13,6 +13,7 @@
 #include "lib/pattern.h"
 #include "options.h"
 #include "optgroup.h"
+#include "zbd.h"
 
 char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
@@ -3362,7 +3363,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "Maximum number of open zones",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, max_open_zones),
-		.maxval	= FIO_MAX_OPEN_ZBD_ZONES,
+		.maxval	= ZBD_MAX_OPEN_ZONES,
 		.help	= "Limit random writes to SMR drives to the specified"
 			  " number of sequential zones",
 		.def	= "0",
diff --git a/oslib/blkzoned.h b/oslib/blkzoned.h
new file mode 100644
index 00000000..4cc071dc
--- /dev/null
+++ b/oslib/blkzoned.h
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ */
+#ifndef FIO_BLKZONED_H
+#define FIO_BLKZONED_H
+
+#include "zbd_types.h"
+
+#ifdef CONFIG_HAS_BLKZONED
+extern int blkzoned_get_zoned_model(struct thread_data *td,
+			struct fio_file *f, enum zbd_zoned_model *model);
+extern int blkzoned_report_zones(struct thread_data *td,
+				struct fio_file *f, uint64_t offset,
+				struct zbd_zone *zones, unsigned int nr_zones);
+extern int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
+				uint64_t offset, uint64_t length);
+#else
+/*
+ * Define stubs for systems that do not have zoned block device support.
+ */
+static inline int blkzoned_get_zoned_model(struct thread_data *td,
+			struct fio_file *f, enum zbd_zoned_model *model)
+{
+	/*
+	 * If this is a block device file, allow zbd emulation.
+	 */
+	if (f->filetype == FIO_TYPE_BLOCK) {
+		*model = ZBD_NONE;
+		return 0;
+	}
+
+	return -ENODEV;
+}
+static inline int blkzoned_report_zones(struct thread_data *td,
+				struct fio_file *f, uint64_t offset,
+				struct zbd_zone *zones, unsigned int nr_zones)
+{
+	return -EIO;
+}
+static inline int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
+				    uint64_t offset, uint64_t length)
+{
+	return -EIO;
+}
+#endif
+
+#endif /* FIO_BLKZONED_H */
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
new file mode 100644
index 00000000..61ea3a53
--- /dev/null
+++ b/oslib/linux-blkzoned.c
@@ -0,0 +1,219 @@
+/*
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ */
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "file.h"
+#include "fio.h"
+#include "lib/pow2.h"
+#include "log.h"
+#include "oslib/asprintf.h"
+#include "smalloc.h"
+#include "verify.h"
+#include "zbd_types.h"
+
+#include <linux/blkzoned.h>
+
+/*
+ * Read up to 255 characters from the first line of a file. Strip the trailing
+ * newline.
+ */
+static char *read_file(const char *path)
+{
+	char line[256], *p = line;
+	FILE *f;
+
+	f = fopen(path, "rb");
+	if (!f)
+		return NULL;
+	if (!fgets(line, sizeof(line), f))
+		line[0] = '\0';
+	strsep(&p, "\n");
+	fclose(f);
+
+	return strdup(line);
+}
+
+int blkzoned_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			     enum zbd_zoned_model *model)
+{
+	const char *file_name = f->file_name;
+	char *zoned_attr_path = NULL;
+	char *model_str = NULL;
+	struct stat statbuf;
+	char *sys_devno_path = NULL;
+	char *part_attr_path = NULL;
+	char *part_str = NULL;
+	char sys_path[PATH_MAX];
+	ssize_t sz;
+	char *delim = NULL;
+
+	if (f->filetype != FIO_TYPE_BLOCK) {
+		*model = ZBD_IGNORE;
+		return 0;
+	}
+
+	*model = ZBD_NONE;
+
+	if (stat(file_name, &statbuf) < 0)
+		goto out;
+
+	if (asprintf(&sys_devno_path, "/sys/dev/block/%d:%d",
+		     major(statbuf.st_rdev), minor(statbuf.st_rdev)) < 0)
+		goto out;
+
+	sz = readlink(sys_devno_path, sys_path, sizeof(sys_path) - 1);
+	if (sz < 0)
+		goto out;
+	sys_path[sz] = '\0';
+
+	/*
+	 * If the device is a partition device, cut the device name in the
+	 * canonical sysfs path to obtain the sysfs path of the holder device.
+	 *   e.g.:  /sys/devices/.../sda/sda1 -> /sys/devices/.../sda
+	 */
+	if (asprintf(&part_attr_path, "/sys/dev/block/%s/partition",
+		     sys_path) < 0)
+		goto out;
+	part_str = read_file(part_attr_path);
+	if (part_str && *part_str == '1') {
+		delim = strrchr(sys_path, '/');
+		if (!delim)
+			goto out;
+		*delim = '\0';
+	}
+
+	if (asprintf(&zoned_attr_path,
+		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
+		goto out;
+
+	model_str = read_file(zoned_attr_path);
+	if (!model_str)
+		goto out;
+	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);
+	if (strcmp(model_str, "host-aware") == 0)
+		*model = ZBD_HOST_AWARE;
+	else if (strcmp(model_str, "host-managed") == 0)
+		*model = ZBD_HOST_MANAGED;
+out:
+	free(model_str);
+	free(zoned_attr_path);
+	free(part_str);
+	free(part_attr_path);
+	free(sys_devno_path);
+	return 0;
+}
+
+int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
+			  uint64_t offset, struct zbd_zone *zones,
+			  unsigned int nr_zones)
+{
+	struct blk_zone_report *hdr = NULL;
+	struct blk_zone *blkz;
+	struct zbd_zone *z;
+	unsigned int i;
+	int fd = -1, ret;
+
+	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
+	if (fd < 0)
+		return -errno;
+
+	hdr = calloc(1, sizeof(struct blk_zone_report) +
+			nr_zones * sizeof(struct blk_zone));
+	if (!hdr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	hdr->nr_zones = nr_zones;
+	hdr->sector = offset >> 9;
+	ret = ioctl(fd, BLKREPORTZONE, hdr);
+	if (ret) {
+		ret = -errno;
+		goto out;
+	}
+
+	nr_zones = hdr->nr_zones;
+	blkz = &hdr->zones[0];
+	z = &zones[0];
+	for (i = 0; i < nr_zones; i++, z++, blkz++) {
+		z->start = blkz->start << 9;
+		z->wp = blkz->wp << 9;
+		z->len = blkz->len << 9;
+
+		switch (blkz->type) {
+		case BLK_ZONE_TYPE_CONVENTIONAL:
+			z->type = ZBD_ZONE_TYPE_CNV;
+			break;
+		case BLK_ZONE_TYPE_SEQWRITE_REQ:
+			z->type = ZBD_ZONE_TYPE_SWR;
+			break;
+		case BLK_ZONE_TYPE_SEQWRITE_PREF:
+			z->type = ZBD_ZONE_TYPE_SWP;
+			break;
+		default:
+			td_verror(td, errno, "invalid zone type");
+			log_err("%s: invalid type for zone at sector %llu.\n",
+				f->file_name, (unsigned long long)offset >> 9);
+			ret = -EIO;
+			goto out;
+		}
+
+		switch (blkz->cond) {
+		case BLK_ZONE_COND_NOT_WP:
+			z->cond = ZBD_ZONE_COND_NOT_WP;
+			break;
+		case BLK_ZONE_COND_EMPTY:
+			z->cond = ZBD_ZONE_COND_EMPTY;
+			break;
+		case BLK_ZONE_COND_IMP_OPEN:
+			z->cond = ZBD_ZONE_COND_IMP_OPEN;
+			break;
+		case BLK_ZONE_COND_EXP_OPEN:
+			z->cond = ZBD_ZONE_COND_EXP_OPEN;
+			break;
+		case BLK_ZONE_COND_CLOSED:
+			z->cond = ZBD_ZONE_COND_CLOSED;
+			break;
+		case BLK_ZONE_COND_FULL:
+			z->cond = ZBD_ZONE_COND_FULL;
+			break;
+		case BLK_ZONE_COND_READONLY:
+		case BLK_ZONE_COND_OFFLINE:
+		default:
+			/* Treat all these conditions as offline (don't use!) */
+			z->cond = ZBD_ZONE_COND_OFFLINE;
+			break;
+		}
+	}
+
+	ret = nr_zones;
+out:
+	free(hdr);
+	close(fd);
+
+	return ret;
+}
+
+int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
+		      uint64_t offset, uint64_t length)
+{
+	struct blk_zone_range zr = {
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
+	};
+
+	if (ioctl(f->fd, BLKRESETZONE, &zr) < 0)
+		return -errno;
+
+	return 0;
+}
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index ea5abc4e..8e326ed5 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -465,7 +465,7 @@ class Requirements(object):
                 print("Unable to open {0} to check requirements".format(config_file))
                 Requirements._zbd = True
             else:
-                Requirements._zbd = "CONFIG_LINUX_BLKZONED" in contents
+                Requirements._zbd = "CONFIG_HAS_BLKZONED" in contents
                 Requirements._libaio = "CONFIG_LIBAIO" in contents
 
             Requirements._root = (os.geteuid() == 0)
diff --git a/zbd.c b/zbd.c
index e2f3f52f..b89d56c4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -9,10 +9,8 @@
 #include <stdlib.h>
 #include <dirent.h>
 #include <fcntl.h>
-#include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <unistd.h>
-#include <linux/blkzoned.h>
 
 #include "file.h"
 #include "fio.h"
@@ -23,6 +21,88 @@
 #include "verify.h"
 #include "zbd.h"
 
+/**
+ * zbd_get_zoned_model - Get a device zoned model
+ * @td: FIO thread data
+ * @f: FIO file for which to get model information
+ */
+int zbd_get_zoned_model(struct thread_data *td, struct fio_file *f,
+			enum zbd_zoned_model *model)
+{
+	int ret;
+
+	ret = blkzoned_get_zoned_model(td, f, model);
+	if (ret < 0) {
+		td_verror(td, errno, "get zoned model failed");
+		log_err("%s: get zoned model failed (%d).\n",
+			f->file_name, errno);
+	}
+
+	return ret;
+}
+
+/**
+ * zbd_report_zones - Get zone information
+ * @td: FIO thread data.
+ * @f: FIO file for which to get zone information
+ * @offset: offset from which to report zones
+ * @zones: Array of struct zbd_zone
+ * @nr_zones: Size of @zones array
+ *
+ * Get zone information into @zones starting from the zone at offset @offset
+ * for the device specified by @f.
+ *
+ * Returns the number of zones reported upon success and a negative error code
+ * upon failure. If the zone report is empty, always assume an error (device
+ * problem) and return -EIO.
+ */
+int zbd_report_zones(struct thread_data *td, struct fio_file *f,
+		     uint64_t offset, struct zbd_zone *zones,
+		     unsigned int nr_zones)
+{
+	int ret;
+
+	ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
+	if (ret < 0) {
+		td_verror(td, errno, "report zones failed");
+		log_err("%s: report zones from sector %llu failed (%d).\n",
+			f->file_name, (unsigned long long)offset >> 9, errno);
+	} else if (ret == 0) {
+		td_verror(td, errno, "Empty zone report");
+		log_err("%s: report zones from sector %llu is empty.\n",
+			f->file_name, (unsigned long long)offset >> 9);
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+/**
+ * zbd_reset_wp - reset the write pointer of a range of zones
+ * @td: FIO thread data.
+ * @f: FIO file for which to reset zones
+ * @offset: Starting offset of the first zone to reset
+ * @length: Length of the range of zones to reset
+ *
+ * Reset the write pointer of all zones in the range @offset...@offset+@length.
+ * Returns 0 upon success and a negative error code upon failure.
+ */
+int zbd_reset_wp(struct thread_data *td, struct fio_file *f,
+		 uint64_t offset, uint64_t length)
+{
+	int ret;
+
+	ret = blkzoned_reset_wp(td, f, offset, length);
+	if (ret < 0) {
+		td_verror(td, errno, "resetting wp failed");
+		log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
+			f->file_name, (unsigned long long)length >> 9,
+			(unsigned long long)offset >> 9, errno);
+	}
+
+	return ret;
+}
+
 /**
  * zbd_zone_idx - convert an offset into a zone number
  * @f: file pointer.
@@ -41,6 +121,15 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 	return min(zone_idx, f->zbd_info->nr_zones);
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
 /**
  * zbd_zone_full - verify whether a minimum number of bytes remain in a zone
  * @f: file pointer.
@@ -54,7 +143,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return z->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
+	return zbd_zone_swr(z) &&
 		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
@@ -93,7 +182,7 @@ static bool zbd_using_direct_io(void)
 			continue;
 		for_each_file(td, f, j) {
 			if (f->zbd_info &&
-			    f->zbd_info->model == ZBD_DM_HOST_MANAGED)
+			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
 	}
@@ -112,8 +201,7 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	zone_idx_b = zbd_zone_idx(f, f->file_offset);
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
-		if (f->zbd_info->zone_info[zone_idx].type ==
-		    BLK_ZONE_TYPE_SEQWRITE_REQ)
+		if (zbd_zone_swr(&f->zbd_info->zone_info[zone_idx]))
 			return true;
 
 	return false;
@@ -224,119 +312,6 @@ static bool zbd_verify_bs(void)
 	return true;
 }
 
-/*
- * Read zone information into @buf starting from sector @start_sector.
- * @fd is a file descriptor that refers to a block device and @bufsz is the
- * size of @buf.
- *
- * Returns 0 upon success and a negative error code upon failure.
- * If the zone report is empty, always assume an error (device problem) and
- * return -EIO.
- */
-static int read_zone_info(int fd, uint64_t start_sector,
-			  void *buf, unsigned int bufsz)
-{
-	struct blk_zone_report *hdr = buf;
-	int ret;
-
-	if (bufsz < sizeof(*hdr))
-		return -EINVAL;
-
-	memset(hdr, 0, sizeof(*hdr));
-
-	hdr->nr_zones = (bufsz - sizeof(*hdr)) / sizeof(struct blk_zone);
-	hdr->sector = start_sector;
-	ret = ioctl(fd, BLKREPORTZONE, hdr);
-	if (ret)
-		return -errno;
-	if (!hdr->nr_zones)
-		return -EIO;
-	return 0;
-}
-
-/*
- * Read up to 255 characters from the first line of a file. Strip the trailing
- * newline.
- */
-static char *read_file(const char *path)
-{
-	char line[256], *p = line;
-	FILE *f;
-
-	f = fopen(path, "rb");
-	if (!f)
-		return NULL;
-	if (!fgets(line, sizeof(line), f))
-		line[0] = '\0';
-	strsep(&p, "\n");
-	fclose(f);
-
-	return strdup(line);
-}
-
-static enum blk_zoned_model get_zbd_model(const char *file_name)
-{
-	enum blk_zoned_model model = ZBD_DM_NONE;
-	char *zoned_attr_path = NULL;
-	char *model_str = NULL;
-	struct stat statbuf;
-	char *sys_devno_path = NULL;
-	char *part_attr_path = NULL;
-	char *part_str = NULL;
-	char sys_path[PATH_MAX];
-	ssize_t sz;
-	char *delim = NULL;
-
-	if (stat(file_name, &statbuf) < 0)
-		goto out;
-
-	if (asprintf(&sys_devno_path, "/sys/dev/block/%d:%d",
-		     major(statbuf.st_rdev), minor(statbuf.st_rdev)) < 0)
-		goto out;
-
-	sz = readlink(sys_devno_path, sys_path, sizeof(sys_path) - 1);
-	if (sz < 0)
-		goto out;
-	sys_path[sz] = '\0';
-
-	/*
-	 * If the device is a partition device, cut the device name in the
-	 * canonical sysfs path to obtain the sysfs path of the holder device.
-	 *   e.g.:  /sys/devices/.../sda/sda1 -> /sys/devices/.../sda
-	 */
-	if (asprintf(&part_attr_path, "/sys/dev/block/%s/partition",
-		     sys_path) < 0)
-		goto out;
-	part_str = read_file(part_attr_path);
-	if (part_str && *part_str == '1') {
-		delim = strrchr(sys_path, '/');
-		if (!delim)
-			goto out;
-		*delim = '\0';
-	}
-
-	if (asprintf(&zoned_attr_path,
-		     "/sys/dev/block/%s/queue/zoned", sys_path) < 0)
-		goto out;
-
-	model_str = read_file(zoned_attr_path);
-	if (!model_str)
-		goto out;
-	dprint(FD_ZBD, "%s: zbd model string: %s\n", file_name, model_str);
-	if (strcmp(model_str, "host-aware") == 0)
-		model = ZBD_DM_HOST_AWARE;
-	else if (strcmp(model_str, "host-managed") == 0)
-		model = ZBD_DM_HOST_MANAGED;
-
-out:
-	free(model_str);
-	free(zoned_attr_path);
-	free(part_str);
-	free(part_attr_path);
-	free(sys_devno_path);
-	return model;
-}
-
 static int ilog2(uint64_t i)
 {
 	int log = -1;
@@ -389,8 +364,8 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 		pthread_mutex_init(&p->mutex, &attr);
 		p->start = i * zone_size;
 		p->wp = p->start + zone_size;
-		p->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
-		p->cond = BLK_ZONE_COND_EMPTY;
+		p->type = ZBD_ZONE_TYPE_SWR;
+		p->cond = ZBD_ZONE_COND_EMPTY;
 	}
 	/* a sentinel */
 	p->start = nr_zones * zone_size;
@@ -405,51 +380,41 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 }
 
 /*
- * Parse the BLKREPORTZONE output and store it in f->zbd_info. Must be called
- * only for devices that support this ioctl, namely zoned block devices.
+ * Maximum number of zones to report in one operation.
+ */
+#define ZBD_REPORT_MAX_ZONES	8192U
+
+/*
+ * Parse the device zone report and store it in f->zbd_info. Must be called
+ * only for devices that are zoned, namely those with a model != ZBD_NONE.
  */
 static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 {
-	const unsigned int bufsz = sizeof(struct blk_zone_report) +
-		4096 * sizeof(struct blk_zone);
-	uint32_t nr_zones;
-	struct blk_zone_report *hdr;
-	const struct blk_zone *z;
+	int nr_zones, nrz;
+	struct zbd_zone *zones, *z;
 	struct fio_zone_info *p;
-	uint64_t zone_size, start_sector;
+	uint64_t zone_size, offset;
 	struct zoned_block_device_info *zbd_info = NULL;
 	pthread_mutexattr_t attr;
-	void *buf;
-	int fd, i, j, ret = 0;
+	int i, j, ret = 0;
 
 	pthread_mutexattr_init(&attr);
 	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
 	pthread_mutexattr_setpshared(&attr, true);
 
-	buf = malloc(bufsz);
-	if (!buf)
+	zones = calloc(ZBD_REPORT_MAX_ZONES, sizeof(struct zbd_zone));
+	if (!zones)
 		goto out;
 
-	fd = open(f->file_name, O_RDONLY | O_LARGEFILE);
-	if (fd < 0) {
-		ret = -errno;
-		goto free;
+	nrz = zbd_report_zones(td, f, 0, zones, ZBD_REPORT_MAX_ZONES);
+	if (nrz < 0) {
+		ret = nrz;
+		log_info("fio: report zones (offset 0) failed for %s (%d).\n",
+			 f->file_name, -ret);
+		goto out;
 	}
 
-	ret = read_zone_info(fd, 0, buf, bufsz);
-	if (ret < 0) {
-		log_info("fio: BLKREPORTZONE(%lu) failed for %s (%d).\n",
-			 0UL, f->file_name, -ret);
-		goto close;
-	}
-	hdr = buf;
-	if (hdr->nr_zones < 1) {
-		log_info("fio: %s has invalid zone information.\n",
-			 f->file_name);
-		goto close;
-	}
-	z = (void *)(hdr + 1);
-	zone_size = z->len << 9;
+	zone_size = zones[0].len;
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 
 	if (td->o.zone_size == 0) {
@@ -459,7 +424,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			f->file_name, (unsigned long long) td->o.zone_size,
 			(unsigned long long) zone_size);
 		ret = -EINVAL;
-		goto close;
+		goto out;
 	}
 
 	dprint(FD_ZBD, "Device %s has %d zones of size %llu KB\n", f->file_name,
@@ -469,24 +434,24 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
 	ret = -ENOMEM;
 	if (!zbd_info)
-		goto close;
+		goto out;
 	pthread_mutex_init(&zbd_info->mutex, &attr);
 	zbd_info->refcount = 1;
 	p = &zbd_info->zone_info[0];
-	for (start_sector = 0, j = 0; j < nr_zones;) {
-		z = (void *)(hdr + 1);
-		for (i = 0; i < hdr->nr_zones; i++, j++, z++, p++) {
+	for (offset = 0, j = 0; j < nr_zones;) {
+		z = &zones[0];
+		for (i = 0; i < nrz; i++, j++, z++, p++) {
 			pthread_mutex_init(&p->mutex, &attr);
-			p->start = z->start << 9;
+			p->start = z->start;
 			switch (z->cond) {
-			case BLK_ZONE_COND_NOT_WP:
-			case BLK_ZONE_COND_FULL:
+			case ZBD_ZONE_COND_NOT_WP:
+			case ZBD_ZONE_COND_FULL:
 				p->wp = p->start + zone_size;
 				break;
 			default:
 				assert(z->start <= z->wp);
-				assert(z->wp <= z->start + (zone_size >> 9));
-				p->wp = z->wp << 9;
+				assert(z->wp <= z->start + zone_size);
+				p->wp = z->wp;
 				break;
 			}
 			p->type = z->type;
@@ -495,22 +460,26 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 				log_info("%s: invalid zone data\n",
 					 f->file_name);
 				ret = -EINVAL;
-				goto close;
+				goto out;
 			}
 		}
 		z--;
-		start_sector = z->start + z->len;
+		offset = z->start + z->len;
 		if (j >= nr_zones)
 			break;
-		ret = read_zone_info(fd, start_sector, buf, bufsz);
-		if (ret < 0) {
-			log_info("fio: BLKREPORTZONE(%llu) failed for %s (%d).\n",
-				 (unsigned long long) start_sector, f->file_name, -ret);
-			goto close;
+		nrz = zbd_report_zones(td, f, offset,
+					    zones, ZBD_REPORT_MAX_ZONES);
+		if (nrz < 0) {
+			ret = nrz;
+			log_info("fio: report zones (offset %llu) failed for %s (%d).\n",
+			 	 (unsigned long long)offset,
+				 f->file_name, -ret);
+			goto out;
 		}
 	}
+
 	/* a sentinel */
-	zbd_info->zone_info[nr_zones].start = start_sector << 9;
+	zbd_info->zone_info[nr_zones].start = offset;
 
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
@@ -520,12 +489,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 	zbd_info = NULL;
 	ret = 0;
 
-close:
-	sfree(zbd_info);
-	close(fd);
-free:
-	free(buf);
 out:
+	sfree(zbd_info);
+	free(zones);
 	pthread_mutexattr_destroy(&attr);
 	return ret;
 }
@@ -537,21 +503,31 @@ out:
  */
 static int zbd_create_zone_info(struct thread_data *td, struct fio_file *f)
 {
-	enum blk_zoned_model zbd_model;
-	int ret = 0;
+	enum zbd_zoned_model zbd_model;
+	int ret;
 
 	assert(td->o.zone_mode == ZONE_MODE_ZBD);
 
-	zbd_model = get_zbd_model(f->file_name);
+	ret = zbd_get_zoned_model(td, f, &zbd_model);
+	if (ret)
+		return ret;
+
 	switch (zbd_model) {
-	case ZBD_DM_HOST_AWARE:
-	case ZBD_DM_HOST_MANAGED:
+	case ZBD_IGNORE:
+		return 0;
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
 		ret = parse_zone_info(td, f);
 		break;
-	case ZBD_DM_NONE:
+	case ZBD_NONE:
 		ret = init_zone_info(td, f);
 		break;
+	default:
+		td_verror(td, EINVAL, "Unsupported zoned model");
+		log_err("Unsupported zoned model\n");
+		return -EINVAL;
 	}
+
 	if (ret == 0)
 		f->zbd_info->model = zbd_model;
 	return ret;
@@ -613,8 +589,6 @@ int zbd_init(struct thread_data *td)
 	int i;
 
 	for_each_file(td, f, i) {
-		if (f->filetype != FIO_TYPE_BLOCK)
-			continue;
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
@@ -642,31 +616,24 @@ int zbd_init(struct thread_data *td)
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
+static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
 			   uint64_t offset, uint64_t length)
 {
-	struct blk_zone_range zr = {
-		.sector         = offset >> 9,
-		.nr_sectors     = length >> 9,
-	};
 	uint32_t zone_idx_b, zone_idx_e;
 	struct fio_zone_info *zb, *ze, *z;
 	int ret = 0;
 
 	assert(f->fd != -1);
 	assert(is_valid_offset(f, offset + length - 1));
+
 	switch (f->zbd_info->model) {
-	case ZBD_DM_HOST_AWARE:
-	case ZBD_DM_HOST_MANAGED:
-		ret = ioctl(f->fd, BLKRESETZONE, &zr);
-		if (ret < 0) {
-			td_verror(td, errno, "resetting wp failed");
-			log_err("%s: resetting wp for %llu sectors at sector %llu failed (%d).\n",
-				f->file_name, zr.nr_sectors, zr.sector, errno);
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		ret = zbd_reset_wp(td, f, offset, length);
+		if (ret < 0)
 			return ret;
-		}
 		break;
-	case ZBD_DM_NONE:
+	default:
 		break;
 	}
 
@@ -703,7 +670,7 @@ static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 			  struct fio_zone_info *z)
 {
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
@@ -734,7 +701,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
-		if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+		if (!zbd_zone_swr(z))
 			continue;
 		zone_lock(td, z);
 		reset_wp = all_zones ? z->wp != z->start :
@@ -899,7 +866,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
 	bool res = true;
 
-	if (z->cond == BLK_ZONE_COND_OFFLINE)
+	if (z->cond == ZBD_ZONE_COND_OFFLINE)
 		return false;
 
 	/*
@@ -939,7 +906,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	zone_idx = f->zbd_info->open_zones[open_zone_idx];
 	memmove(f->zbd_info->open_zones + open_zone_idx,
 		f->zbd_info->open_zones + open_zone_idx + 1,
-		(FIO_MAX_OPEN_ZBD_ZONES - (open_zone_idx + 1)) *
+		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
 	f->zbd_info->zone_info[zone_idx].open = 0;
@@ -1148,7 +1115,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 * the nearest non-empty zone in case of random I/O.
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
-		if (z1 < zl && z1->cond != BLK_ZONE_COND_OFFLINE) {
+		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z1->mutex);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
@@ -1157,7 +1124,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 			break;
 		}
 		if (td_random(td) && z2 >= zf &&
-		    z2->cond != BLK_ZONE_COND_OFFLINE) {
+		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z2->mutex);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
@@ -1193,7 +1160,7 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = &zbd_info->zone_info[zone_idx];
 
-	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+	if (!zbd_zone_swr(z))
 		return;
 
 	if (!success)
@@ -1250,7 +1217,7 @@ static void zbd_put_io(const struct io_u *io_u)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = &zbd_info->zone_info[zone_idx];
 
-	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+	if (!zbd_zone_swr(z))
 		return;
 
 	dprint(FD_ZBD,
@@ -1341,7 +1308,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
  */
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
@@ -1359,14 +1326,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	orig_zb = zb;
 
 	/* Accept the I/O offset for conventional zones. */
-	if (zb->type == BLK_ZONE_TYPE_CONVENTIONAL)
+	if (!zbd_zone_swr(zb))
 		return io_u_accept;
 
 	/*
 	 * Accept the I/O offset for reads if reading beyond the write pointer
 	 * is enabled.
 	 */
-	if (zb->cond != BLK_ZONE_COND_OFFLINE &&
+	if (zb->cond != ZBD_ZONE_COND_OFFLINE &&
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
@@ -1385,7 +1352,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
 		 * the I/O.
 		 */
-		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
+		range = zb->cond != ZBD_ZONE_COND_OFFLINE ?
 			zb->wp - zb->start : 0;
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
@@ -1510,7 +1477,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 accept:
 	assert(zb);
-	assert(zb->cond != BLK_ZONE_COND_OFFLINE);
+	assert(zb->cond != ZBD_ZONE_COND_OFFLINE);
 	assert(!io_u->zbd_queue_io);
 	assert(!io_u->zbd_put_io);
 	io_u->zbd_queue_io = zbd_queue_io;
diff --git a/zbd.h b/zbd.h
index e0a7e447..4eaf902e 100644
--- a/zbd.h
+++ b/zbd.h
@@ -7,23 +7,13 @@
 #ifndef FIO_ZBD_H
 #define FIO_ZBD_H
 
-#include <inttypes.h>
-#include "fio.h"	/* FIO_MAX_OPEN_ZBD_ZONES */
-#ifdef CONFIG_LINUX_BLKZONED
-#include <linux/blkzoned.h>
-#endif
+#include "io_u.h"
+#include "ioengines.h"
+#include "oslib/blkzoned.h"
+#include "zbd_types.h"
 
 struct fio_file;
 
-/*
- * Zoned block device models.
- */
-enum blk_zoned_model {
-	ZBD_DM_NONE,	/* Regular block device */
-	ZBD_DM_HOST_AWARE,	/* Host-aware zoned block device */
-	ZBD_DM_HOST_MANAGED,	/* Host-managed zoned block device */
-};
-
 enum io_u_action {
 	io_u_accept	= 0,
 	io_u_eof	= 1,
@@ -42,16 +32,14 @@ enum io_u_action {
  * @reset_zone: whether or not this zone should be reset before writing to it
  */
 struct fio_zone_info {
-#ifdef CONFIG_LINUX_BLKZONED
 	pthread_mutex_t		mutex;
 	uint64_t		start;
 	uint64_t		wp;
 	uint32_t		verify_block;
-	enum blk_zone_type	type:2;
-	enum blk_zone_cond	cond:4;
+	enum zbd_zone_type	type:2;
+	enum zbd_zone_cond	cond:4;
 	unsigned int		open:1;
 	unsigned int		reset_zone:1;
-#endif
 };
 
 /**
@@ -76,7 +64,7 @@ struct fio_zone_info {
  * will be smaller than 'zone_size'.
  */
 struct zoned_block_device_info {
-	enum blk_zoned_model	model;
+	enum zbd_zoned_model	model;
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		sectors_with_data;
@@ -85,11 +73,10 @@ struct zoned_block_device_info {
 	uint32_t		refcount;
 	uint32_t		num_open_zones;
 	uint32_t		write_cnt;
-	uint32_t		open_zones[FIO_MAX_OPEN_ZBD_ZONES];
+	uint32_t		open_zones[ZBD_MAX_OPEN_ZONES];
 	struct fio_zone_info	zone_info[0];
 };
 
-#ifdef CONFIG_LINUX_BLKZONED
 void zbd_free_zone_info(struct fio_file *f);
 int zbd_init(struct thread_data *td);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);
@@ -115,45 +102,4 @@ static inline void zbd_put_io_u(struct io_u *io_u)
 	}
 }
 
-#else
-static inline void zbd_free_zone_info(struct fio_file *f)
-{
-}
-
-static inline int zbd_init(struct thread_data *td)
-{
-	return 0;
-}
-
-static inline void zbd_file_reset(struct thread_data *td, struct fio_file *f)
-{
-}
-
-static inline bool zbd_unaligned_write(int error_code)
-{
-	return false;
-}
-
-static inline enum io_u_action zbd_adjust_block(struct thread_data *td,
-						struct io_u *io_u)
-{
-	return io_u_accept;
-}
-
-static inline char *zbd_write_status(const struct thread_stat *ts)
-{
-	return NULL;
-}
-
-static inline void zbd_queue_io_u(struct io_u *io_u,
-				  enum fio_q_status status) {}
-static inline void zbd_put_io_u(struct io_u *io_u) {}
-
-static inline void setup_zbd_zone_mode(struct thread_data *td,
-					struct io_u *io_u)
-{
-}
-
-#endif
-
 #endif /* FIO_ZBD_H */
diff --git a/zbd_types.h b/zbd_types.h
new file mode 100644
index 00000000..2f2f1324
--- /dev/null
+++ b/zbd_types.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ */
+#ifndef FIO_ZBD_TYPES_H
+#define FIO_ZBD_TYPES_H
+
+#include <inttypes.h>
+
+#define ZBD_MAX_OPEN_ZONES	128
+
+/*
+ * Zoned block device models.
+ */
+enum zbd_zoned_model {
+	ZBD_IGNORE,		/* Ignore file */
+	ZBD_NONE,		/* Regular block device */
+	ZBD_HOST_AWARE,		/* Host-aware zoned block device */
+	ZBD_HOST_MANAGED,	/* Host-managed zoned block device */
+};
+
+/*
+ * Zone types.
+ */
+enum zbd_zone_type {
+	ZBD_ZONE_TYPE_CNV	= 0x1,	/* Conventional */
+	ZBD_ZONE_TYPE_SWR	= 0x2,	/* Sequential write required */
+	ZBD_ZONE_TYPE_SWP	= 0x3,	/* Sequential write preferred */
+};
+
+/*
+ * Zone conditions.
+ */
+enum zbd_zone_cond {
+        ZBD_ZONE_COND_NOT_WP    = 0x0,
+        ZBD_ZONE_COND_EMPTY     = 0x1,
+        ZBD_ZONE_COND_IMP_OPEN  = 0x2,
+        ZBD_ZONE_COND_EXP_OPEN  = 0x3,
+        ZBD_ZONE_COND_CLOSED    = 0x4,
+        ZBD_ZONE_COND_READONLY  = 0xD,
+        ZBD_ZONE_COND_FULL      = 0xE,
+        ZBD_ZONE_COND_OFFLINE   = 0xF,
+};
+
+/*
+ * Zone descriptor.
+ */
+struct zbd_zone {
+	uint64_t		start;
+	uint64_t		wp;
+	uint64_t		len;
+	enum zbd_zone_type	type;
+	enum zbd_zone_cond	cond;
+};
+
+#endif /* FIO_ZBD_TYPES_H */
-- 
2.25.1


