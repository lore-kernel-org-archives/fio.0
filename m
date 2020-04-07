Return-Path: <prvs=35932a8d3=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 3/4] fio: Introduce libzbc IO engine
Date: Tue,  7 Apr 2020 10:58:59 +0900
Message-Id: <20200407015900.1335019-4-damien.lemoal@wdc.com>
In-Reply-To: <20200407015900.1335019-1-damien.lemoal@wdc.com>
References: <20200407015900.1335019-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Many storage users in the field are using Linux enterprise distributions
with somewhat old kernel versions 3.x that do not have zoned block
device/ZBC/ZAC support, or distributions with more recent kernel
versions that do not have zoned block device support enabled by
default, i.e. not supported by the distribution vendor.

Despite this, there are many examples of production applications using
SMR disks directly using SCSI passthrough commands.

SMR disks performance tests and qualification using fio in such
environments is possible using the sg IO engine but writing scripts
is not easy as the zonemode=zbd cannot be used due to its lack of
support for ZBC operations (report zones, zone reset, etc).

Rather than modifying the sg IO engine, a simpler approach to provide
passthrough SMR support in fio is to use libzbc
(https://github.com/hgst/libzbc) to implement a ZBC compliant ioengine
supporting zonemode=zbd zone operations. With this, it becomes possible
to run more easily fio against SMR disks on systems without kernel
zoned block device support. This approach will also naturally enable
support for other ZBD disks varieties besides ZAC/ZBC SMR disks, namely
the upcoming Zone Domains/Zone Realms (ZD/ZR) drives, aka, dynamic
hybrid SMR drives.

This new libzbc IO engine implements the three IO engine methods related
to zoned devices: get_zoned_model(), report_zones() and reset_wp(),
allowing the use of zonemode=zbd. Special open_file(), close_file() and
get_file_size() methods are provided and implemented using libzbc
functions. The queue() operation allows only synchronous read and write
operations using the libzbc functions zbc_pread() and zbc_pwrite().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Makefile         |   3 +
 configure        |  34 ++++
 engines/libzbc.c | 422 +++++++++++++++++++++++++++++++++++++++++++++++
 fio.1            |   6 +
 4 files changed, 465 insertions(+)
 create mode 100644 engines/libzbc.c

diff --git a/Makefile b/Makefile
index cb314d95..5bcd6064 100644
--- a/Makefile
+++ b/Makefile
@@ -160,6 +160,9 @@ endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
+ifdef CONFIG_LIBZBC
+  SOURCE += engines/libzbc.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/configure b/configure
index 3093915b..ae2b3589 100755
--- a/configure
+++ b/configure
@@ -2397,6 +2397,37 @@ if compile_prog "" "" "linux_blkzoned"; then
 fi
 print_config "Zoned block device support" "$linux_blkzoned"
 
+##########################################
+# libzbc probe
+if test "$libzbc" != "yes" ; then
+  libzbc="no"
+fi
+cat > $TMPC << EOF
+#include <libzbc/zbc.h>
+int main(int argc, char **argv)
+{
+  struct zbc_device *dev = NULL;
+
+  return zbc_open("foo=bar", O_RDONLY, &dev);
+}
+EOF
+if compile_prog "" "-lzbc" "libzbc"; then
+  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
+  if test "$libzbcvermaj" -ge "5" ; then
+    libzbc="yes"
+    LIBS="-lzbc $LIBS"
+  else
+    print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
+    libzbc="no"
+  fi
+else
+  if test "$libzbc" = "yes" ; then
+      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
+  fi
+  libzbc="no"
+fi
+print_config "libzbc engine" "$libzbc"
+
 ##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
@@ -2864,6 +2895,9 @@ fi
 if test "$linux_blkzoned" = "yes" ; then
   output_sym "CONFIG_HAS_BLKZONED"
 fi
+if test "$libzbc" = "yes" ; then
+  output_sym "CONFIG_LIBZBC"
+fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
   if test "$build_static" = "yes"; then
diff --git a/engines/libzbc.c b/engines/libzbc.c
new file mode 100644
index 00000000..8c682de6
--- /dev/null
+++ b/engines/libzbc.c
@@ -0,0 +1,422 @@
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * This file is released under the GPL.
+ *
+ * libzbc engine
+ * IO engine using libzbc library to talk to SMR disks.
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <libzbc/zbc.h>
+
+#include "fio.h"
+#include "err.h"
+#include "zbd_types.h"
+
+struct libzbc_data {
+	struct zbc_device	*zdev;
+	enum zbc_dev_model	model;
+	uint64_t		nr_sectors;
+};
+
+static int libzbc_get_dev_info(struct libzbc_data *ld, struct fio_file *f)
+{
+	struct zbc_device_info *zinfo;
+
+	zinfo = calloc(1, sizeof(*zinfo));
+	if (!zinfo)
+		return -ENOMEM;
+
+	zbc_get_device_info(ld->zdev, zinfo);
+	ld->model = zinfo->zbd_model;
+	ld->nr_sectors = zinfo->zbd_sectors;
+
+	dprint(FD_ZBD, "%s: vendor_id:%s, type: %s, model: %s\n",
+	       f->file_name, zinfo->zbd_vendor_id,
+	       zbc_device_type_str(zinfo->zbd_type),
+	       zbc_device_model_str(zinfo->zbd_model));
+
+	free(zinfo);
+
+	return 0;
+}
+
+static int libzbc_open_dev(struct thread_data *td, struct fio_file *f,
+			   struct libzbc_data **p_ld)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+        int ret, flags = OS_O_DIRECT;
+
+	if (ld) {
+		/* Already open */
+		assert(ld->zdev);
+		goto out;
+	}
+
+	if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR) {
+		td_verror(td, EINVAL, "wrong file type");
+		log_err("ioengine libzbc only works on block or character devices\n");
+		return -EINVAL;
+	}
+
+        if (td_write(td)) {
+		if (!read_only)
+			flags |= O_RDWR;
+	} else if (td_read(td)) {
+		if (f->filetype == FIO_TYPE_CHAR && !read_only)
+			flags |= O_RDWR;
+		else
+			flags |= O_RDONLY;
+	} else if (td_trim(td)) {
+		td_verror(td, EINVAL, "libzbc does not support trim");
+                log_err("%s: libzbc does not support trim\n",
+                        f->file_name);
+                return -EINVAL;
+	}
+
+        if (td->o.oatomic) {
+		td_verror(td, EINVAL, "libzbc does not support O_ATOMIC");
+                log_err("%s: libzbc does not support O_ATOMIC\n",
+                        f->file_name);
+                return -EINVAL;
+        }
+
+	ld = calloc(1, sizeof(*ld));
+	if (!ld)
+		return -ENOMEM;
+
+	ret = zbc_open(f->file_name,
+		       flags | ZBC_O_DRV_SCSI | ZBC_O_DRV_ATA, &ld->zdev);
+	if (ret) {
+		log_err("%s: zbc_open() failed, err=%d\n",
+			f->file_name, ret);
+		return ret;
+	}
+
+	ret = libzbc_get_dev_info(ld, f);
+	if (ret) {
+		zbc_close(ld->zdev);
+		free(ld);
+		return ret;
+	}
+
+	td->io_ops_data = ld;
+out:
+	if (p_ld)
+		*p_ld = ld;
+
+	return 0;
+}
+
+static int libzbc_close_dev(struct thread_data *td)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	int ret = 0;
+
+	td->io_ops_data = NULL;
+	if (ld) {
+		if (ld->zdev)
+			ret = zbc_close(ld->zdev);
+		free(ld);
+	}
+
+	return ret;
+}
+static int libzbc_open_file(struct thread_data *td, struct fio_file *f)
+{
+	return libzbc_open_dev(td, f, NULL);
+}
+
+static int libzbc_close_file(struct thread_data *td, struct fio_file *f)
+{
+	int ret;
+
+	ret = libzbc_close_dev(td);
+	if (ret)
+		log_err("%s: close device failed err %d\n",
+			f->file_name, ret);
+
+	return ret;
+}
+
+static void libzbc_cleanup(struct thread_data *td)
+{
+	libzbc_close_dev(td);
+}
+
+static int libzbc_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	/* Passthrough IO do not cache data. Nothing to do */
+	return 0;
+}
+
+static int libzbc_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	struct libzbc_data *ld;
+	int ret;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	ret = libzbc_open_dev(td, f, &ld);
+	if (ret)
+		return ret;
+
+	f->real_file_size = ld->nr_sectors << 9;
+	fio_file_set_size_known(f);
+
+	return 0;
+}
+
+static int libzbc_get_zoned_model(struct thread_data *td, struct fio_file *f,
+				  enum zbd_zoned_model *model)
+{
+	struct libzbc_data *ld;
+	int ret;
+
+	if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR) {
+		*model = ZBD_IGNORE;
+		return 0;
+	}
+
+	ret = libzbc_open_dev(td, f, &ld);
+	if (ret)
+		return ret;
+
+	switch (ld->model) {
+	case ZBC_DM_HOST_AWARE:
+		*model = ZBD_HOST_AWARE;
+		break;
+	case ZBC_DM_HOST_MANAGED:
+		*model = ZBD_HOST_MANAGED;
+		break;
+	default:
+		*model = ZBD_NONE;
+		break;
+	}
+
+	return 0;
+}
+
+static int libzbc_report_zones(struct thread_data *td, struct fio_file *f,
+			       uint64_t offset, struct zbd_zone *zbdz,
+			       unsigned int nr_zones)
+{
+	struct libzbc_data *ld;
+	uint64_t sector = offset >> 9;
+	struct zbc_zone *zones;
+	unsigned int i;
+	int ret;
+
+	ret = libzbc_open_dev(td, f, &ld);
+	if (ret)
+		return ret;
+
+	if (sector >= ld->nr_sectors)
+		return 0;
+
+	zones = calloc(nr_zones, sizeof(struct zbc_zone));
+	if (!zones) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = zbc_report_zones(ld->zdev, sector, ZBC_RO_ALL, zones, &nr_zones);
+	if (ret < 0) {
+		log_err("%s: zbc_report_zones failed, err=%d\n",
+			f->file_name, ret);
+		goto out;
+	}
+
+	for (i = 0; i < nr_zones; i++, zbdz++) {
+		zbdz->start = zones[i].zbz_start << 9;
+		zbdz->len = zones[i].zbz_length << 9;
+		zbdz->wp = zones[i].zbz_write_pointer << 9;
+
+		switch (zones[i].zbz_type) {
+		case ZBC_ZT_CONVENTIONAL:
+			zbdz->type = ZBD_ZONE_TYPE_CNV;
+			break;
+		case ZBC_ZT_SEQUENTIAL_REQ:
+			zbdz->type = ZBD_ZONE_TYPE_SWR;
+			break;
+		case ZBC_ZT_SEQUENTIAL_PREF:
+			zbdz->type = ZBD_ZONE_TYPE_SWP;
+			break;
+		default:
+			td_verror(td, errno, "invalid zone type");
+			log_err("%s: invalid type for zone at sector %llu.\n",
+				f->file_name, (unsigned long long)zbdz->start);
+			ret = -EIO;
+			goto out;
+		}
+
+		switch (zones[i].zbz_condition) {
+		case ZBC_ZC_NOT_WP:
+			zbdz->cond = ZBD_ZONE_COND_NOT_WP;
+			break;
+		case ZBC_ZC_EMPTY:
+			zbdz->cond = ZBD_ZONE_COND_EMPTY;
+			break;
+		case ZBC_ZC_IMP_OPEN:
+			zbdz->cond = ZBD_ZONE_COND_IMP_OPEN;
+			break;
+		case ZBC_ZC_EXP_OPEN:
+			zbdz->cond = ZBD_ZONE_COND_EXP_OPEN;
+			break;
+		case ZBC_ZC_CLOSED:
+			zbdz->cond = ZBD_ZONE_COND_CLOSED;
+			break;
+		case ZBC_ZC_FULL:
+			zbdz->cond = ZBD_ZONE_COND_FULL;
+			break;
+		case ZBC_ZC_RDONLY:
+		case ZBC_ZC_OFFLINE:
+		default:
+			/* Treat all these conditions as offline (don't use!) */
+			zbdz->cond = ZBD_ZONE_COND_OFFLINE;
+			break;
+		}
+	}
+
+	ret = nr_zones;
+out:
+	free(zones);
+	return ret;
+}
+
+static int libzbc_reset_wp(struct thread_data *td, struct fio_file *f,
+			   uint64_t offset, uint64_t length)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	uint64_t sector = offset >> 9;
+	uint64_t end_sector = (offset + length) >> 9;
+	unsigned int nr_zones;
+	struct zbc_errno err;
+	int i, ret;
+
+	assert(ld);
+	assert(ld->zdev);
+
+	nr_zones = (length + td->o.zone_size - 1) / td->o.zone_size;
+	if (!sector && end_sector >= ld->nr_sectors) {
+		/* Reset all zones */
+		ret = zbc_reset_zone(ld->zdev, 0, ZBC_OP_ALL_ZONES);
+		if (ret)
+			goto err;
+
+		return 0;
+	}
+
+	for (i = 0; i < nr_zones; i++, sector += td->o.zone_size >> 9) {
+		ret = zbc_reset_zone(ld->zdev, sector, 0);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+
+err:
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "zbc_reset_zone failed");
+	if (err.sk)
+		log_err("%s: reset wp failed %s:%s\n",
+			f->file_name,
+			zbc_sk_str(err.sk), zbc_asc_ascq_str(err.asc_ascq));
+	return -ret;
+}
+
+ssize_t libzbc_rw(struct thread_data *td, struct io_u *io_u)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	struct fio_file *f = io_u->file;
+	uint64_t sector = io_u->offset >> 9;
+	size_t count = io_u->xfer_buflen >> 9;
+	struct zbc_errno err;
+	ssize_t ret;
+
+	if (io_u->ddir == DDIR_WRITE)
+		ret = zbc_pwrite(ld->zdev, io_u->xfer_buf, count, sector);
+	else
+		ret = zbc_pread(ld->zdev, io_u->xfer_buf, count, sector);
+	if (ret == count)
+		return ret;
+
+	if (ret > 0) {
+		log_err("Short %s, len=%zu, ret=%zd\n",
+			io_u->ddir == DDIR_READ ? "read" : "write",
+			count << 9, ret << 9);
+		return -EIO;
+	}
+
+	/* I/O error */
+	zbc_errno(ld->zdev, &err);
+	td_verror(td, errno, "libzbc i/o failed");
+	if (err.sk) {
+		log_err("%s: op %u offset %llu+%llu failed (%s:%s), err %zd\n",
+			f->file_name, io_u->ddir,
+			io_u->offset, io_u->xfer_buflen,
+			zbc_sk_str(err.sk),
+			zbc_asc_ascq_str(err.asc_ascq), ret);
+	} else {
+		log_err("%s: op %u offset %llu+%llu failed, err %zd\n",
+			f->file_name, io_u->ddir,
+			io_u->offset, io_u->xfer_buflen, ret);
+	}
+
+	return -EIO;
+}
+
+static enum fio_q_status libzbc_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct libzbc_data *ld = td->io_ops_data;
+	struct fio_file *f = io_u->file;
+	ssize_t ret = 0;
+
+	fio_ro_check(td, io_u);
+
+	dprint(FD_ZBD, "%p:%s: libzbc queue %llu\n",
+	       td, f->file_name, io_u->offset);
+
+	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		ret = libzbc_rw(td, io_u);
+	} else if (ddir_sync(io_u->ddir)) {
+		ret = zbc_flush(ld->zdev);
+		if (ret)
+			log_err("zbc_flush error %zd\n", ret);
+	} else if (io_u->ddir != DDIR_TRIM) {
+		log_err("Unsupported operation %u\n", io_u->ddir);
+		ret = -EINVAL;
+	}
+	if (ret < 0)
+		io_u->error = -ret;
+
+	return FIO_Q_COMPLETED;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "libzbc",
+	.version		= FIO_IOOPS_VERSION,
+	.open_file		= libzbc_open_file,
+	.close_file		= libzbc_close_file,
+	.cleanup		= libzbc_cleanup,
+	.invalidate		= libzbc_invalidate,
+	.get_file_size		= libzbc_get_file_size,
+	.get_zoned_model	= libzbc_get_zoned_model,
+	.report_zones		= libzbc_report_zones,
+	.reset_wp		= libzbc_reset_wp,
+	.queue			= libzbc_queue,
+	.flags			= FIO_SYNCIO | FIO_NOEXTEND | FIO_RAWIO,
+};
+
+static void fio_init fio_libzbc_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_libzbc_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/fio.1 b/fio.1
index 1db12c2f..a2379f98 100644
--- a/fio.1
+++ b/fio.1
@@ -1629,6 +1629,12 @@ I/O. Requires \fBfilename\fR option to specify either block or
 character devices. This engine supports trim operations. The
 sg engine includes engine specific options.
 .TP
+.B libzbc
+Synchronous I/O engine for SMR hard-disks using the \fBlibzbc\fR
+library. The target can be either an sg character device or
+a block device file. This engine supports the zonemode=zbd zone
+operations.
+.TP
 .B null
 Doesn't transfer any data, just pretends to. This is mainly used to
 exercise fio itself and for debugging/testing purposes.
-- 
2.25.1


