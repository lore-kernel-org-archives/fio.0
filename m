Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53290 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbgDHMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Apr 2020 08:00:08 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jM9NF-000102-MW
        for fio@vger.kernel.org; Wed, 08 Apr 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200408120002.8B1501BC0191@kernel.dk>
Date: Wed,  8 Apr 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ebc403fe282864eddfd68ab1793f149a1b0eb1cd:

  zbd: fixup ->zone_size_log2 if zone size is not power of 2 (2020-04-06 19:41:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9d87c646c45227c86c5a15faee2a6717a4bf1b46:

  zbd: Fix build errors on Windows and MacOS (2020-04-07 20:20:36 -0600)

----------------------------------------------------------------
Damien Le Moal (3):
      fio: Generalize zonemode=zbd
      ioengines: Add zoned block device operations
      zbd: Fix build errors on Windows and MacOS

Dmitry Fomichev (2):
      fio: Introduce libzbc IO engine
      t/zbd: Add support for libzbc IO engine tests

Dmitry Monakhov (2):
      engines: check options before dereference
      engine/rdmaio: fix io_u initialization

Jens Axboe (1):
      Merge branch 'rdma-fixes' of https://github.com/dmonakhov/fio

 Makefile                    |   9 +-
 configure                   |  36 +++-
 engines/e4defrag.c          |   2 +-
 engines/libzbc.c            | 422 ++++++++++++++++++++++++++++++++++++++++++++
 engines/rbd.c               |   8 +
 engines/rdma.c              |  17 +-
 engines/skeleton_external.c |  43 +++++
 fio.1                       |   6 +
 fio.h                       |   2 -
 io_u.h                      |   2 -
 ioengines.h                 |   9 +-
 options.c                   |   3 +-
 oslib/blkzoned.h            |  49 +++++
 oslib/linux-blkzoned.c      | 219 +++++++++++++++++++++++
 t/run-fio-tests.py          |   2 +-
 t/zbd/functions             |  38 +++-
 t/zbd/test-zbd-support      | 221 +++++++++++++++--------
 zbd.c                       | 404 ++++++++++++++++++++----------------------
 zbd.h                       |  70 +-------
 zbd_types.h                 |  57 ++++++
 20 files changed, 1247 insertions(+), 372 deletions(-)
 create mode 100644 engines/libzbc.c
 create mode 100644 oslib/blkzoned.h
 create mode 100644 oslib/linux-blkzoned.c
 create mode 100644 zbd_types.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 9a5dea7f..5bcd6064 100644
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
@@ -160,13 +160,16 @@ endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
-ifdef CONFIG_LINUX_BLKZONED
-  SOURCE += zbd.c
+ifdef CONFIG_LIBZBC
+  SOURCE += engines/libzbc.c
 endif
 
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
index d17929f1..ae2b3589 100755
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
@@ -2862,7 +2893,10 @@ if test "$valgrind_dev" = "yes"; then
   output_sym "CONFIG_VALGRIND_DEV"
 fi
 if test "$linux_blkzoned" = "yes" ; then
-  output_sym "CONFIG_LINUX_BLKZONED"
+  output_sym "CONFIG_HAS_BLKZONED"
+fi
+if test "$libzbc" = "yes" ; then
+  output_sym "CONFIG_LIBZBC"
 fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 8f71d02c..0a0004d0 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -72,7 +72,7 @@ static int fio_e4defrag_init(struct thread_data *td)
 	struct stat stub;
 	char donor_name[PATH_MAX];
 
-	if (!strlen(o->donor_name)) {
+	if (!o->donor_name || !strlen(o->donor_name)) {
 		log_err("'donorname' options required\n");
 		return 1;
 	}
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
diff --git a/engines/rbd.c b/engines/rbd.c
index 7d4d3faf..a08f4775 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -200,6 +200,14 @@ static int _fio_rbd_connect(struct thread_data *td)
 		log_err("rados_create failed.\n");
 		goto failed_early;
 	}
+	if (o->pool_name == NULL) {
+		log_err("rbd pool name must be provided.\n");
+		goto failed_early;
+	}
+	if (!o->rbd_name) {
+		log_err("rbdname must be provided.\n");
+		goto failed_early;
+	}
 
 	r = rados_conf_read_file(rbd->cluster, NULL);
 	if (r < 0) {
diff --git a/engines/rdma.c b/engines/rdma.c
index 2569a8e3..f192f432 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -1050,7 +1050,7 @@ static int fio_rdmaio_setup_connect(struct thread_data *td, const char *host,
 		return err;
 
 	/* resolve route */
-	if (strcmp(o->bindname, "") != 0) {
+	if (o->bindname && strlen(o->bindname)) {
 		addrb.ss_family = AF_INET;
 		err = aton(td, o->bindname, (struct sockaddr_in *)&addrb);
 		if (err)
@@ -1116,7 +1116,7 @@ static int fio_rdmaio_setup_listen(struct thread_data *td, short port)
 	rd->addr.sin_family = AF_INET;
 	rd->addr.sin_port = htons(port);
 
-	if (strcmp(o->bindname, "") == 0)
+	if (!o->bindname || !strlen(o->bindname))
 		rd->addr.sin_addr.s_addr = htonl(INADDR_ANY);
 	else
 		rd->addr.sin_addr.s_addr = htonl(*o->bindname);
@@ -1249,8 +1249,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 {
 	struct rdmaio_data *rd = td->io_ops_data;
 	struct rdmaio_options *o = td->eo;
-	unsigned int max_bs;
-	int ret, i;
+	int ret;
 
 	if (td_rw(td)) {
 		log_err("fio: rdma connections must be read OR write\n");
@@ -1318,6 +1317,13 @@ static int fio_rdmaio_init(struct thread_data *td)
 		rd->is_client = 1;
 		ret = fio_rdmaio_setup_connect(td, td->o.filename, o->port);
 	}
+	return ret;
+}
+static int fio_rdmaio_post_init(struct thread_data *td)
+{
+	unsigned int max_bs;
+	int i;
+	struct rdmaio_data *rd = td->io_ops_data;
 
 	max_bs = max(td->o.max_bs[DDIR_READ], td->o.max_bs[DDIR_WRITE]);
 	rd->send_buf.max_bs = htonl(max_bs);
@@ -1351,7 +1357,7 @@ static int fio_rdmaio_init(struct thread_data *td)
 
 	rd->send_buf.nr = htonl(i);
 
-	return ret;
+	return 0;
 }
 
 static void fio_rdmaio_cleanup(struct thread_data *td)
@@ -1388,6 +1394,7 @@ static struct ioengine_ops ioengine_rw = {
 	.version		= FIO_IOOPS_VERSION,
 	.setup			= fio_rdmaio_setup,
 	.init			= fio_rdmaio_init,
+	.post_init		= fio_rdmaio_post_init,
 	.prep			= fio_rdmaio_prep,
 	.queue			= fio_rdmaio_queue,
 	.commit			= fio_rdmaio_commit,
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
diff --git a/t/zbd/functions b/t/zbd/functions
index d49555a8..35087b15 100644
--- a/t/zbd/functions
+++ b/t/zbd/functions
@@ -4,18 +4,27 @@ blkzone=$(type -p blkzone 2>/dev/null)
 sg_inq=$(type -p sg_inq 2>/dev/null)
 zbc_report_zones=$(type -p zbc_report_zones 2>/dev/null)
 zbc_reset_zone=$(type -p zbc_reset_zone 2>/dev/null)
+zbc_info=$(type -p zbc_info 2>/dev/null)
 if [ -z "${blkzone}" ] &&
        { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ]; }; then
     echo "Error: neither blkzone nor zbc_report_zones is available"
     exit 1
 fi
 
+if [ -n "${use_libzbc}" ] &&
+       { [ -z "${zbc_report_zones}" ] || [ -z "${zbc_reset_zone}" ] ||
+         [ -z "${zbc_info}" ]; }; then
+    echo "Error: zbc_report_zones, or zbc_reset_zone or zbc_info is not available"
+    echo "Error: reinstall libzbc tools"
+    exit 1
+fi
+
 # Reports the starting sector and length of the first sequential zone of device
 # $1.
 first_sequential_zone() {
     local dev=$1
 
-    if [ -n "${blkzone}" ]; then
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	${blkzone} report "$dev" |
 	    sed -n 's/^[[:blank:]]*start:[[:blank:]]\([0-9a-zA-Z]*\),[[:blank:]]len[[:blank:]]\([0-9a-zA-Z]*\),.*type:[[:blank:]]2(.*/\1 \2/p' |
 	    {
@@ -33,7 +42,7 @@ first_sequential_zone() {
 max_open_zones() {
     local dev=$1
 
-    if [ -n "${sg_inq}" ]; then
+    if [ -n "${sg_inq}" ] && [ ! -n "${use_libzbc}" ]; then
 	if ! ${sg_inq} -e --page=0xB6 --len=20 --hex "$dev" 2> /dev/null; then
 	    # Non scsi device such as null_blk can not return max open zones.
 	    # Use default value.
@@ -56,13 +65,36 @@ max_open_zones() {
     fi
 }
 
+is_zbc() {
+	local dev=$1
+
+	[[ -z "$(${zbc_info} "$dev" | grep "is not a zoned block device")" ]]
+}
+
+zbc_logical_block_size() {
+	local dev=$1
+
+	${zbc_info} "$dev" |
+		grep "logical blocks" |
+		sed -n 's/^[[:blank:]]*[0-9]* logical blocks of[[:blank:]]*//p' |
+		sed 's/ B//'
+}
+
+zbc_disk_sectors() {
+        local dev=$1
+
+	zbc_info "$dev" |
+		grep "512-bytes sectors" |
+		sed -e 's/[[:blank:]]*\([0-9]*\)512-bytes sectors.*/\1/'
+}
+
 # Reset the write pointer of one zone on device $1 at offset $2. The offset
 # must be specified in units of 512 byte sectors. Offset -1 means reset all
 # zones.
 reset_zone() {
     local dev=$1 offset=$2 sectors
 
-    if [ -n "${blkzone}" ]; then
+    if [ -n "${blkzone}" ] && [ ! -n "${use_libzbc}" ]; then
 	if [ "$offset" -lt 0 ]; then
 	    sectors=$(<"/sys/class/block/${dev#/dev/}/size")
 	    ${blkzone} reset -o "${offset}" -l "$sectors" "$dev"
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index bd41fffb..be889f34 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -5,7 +5,7 @@
 # This file is released under the GPL.
 
 usage() {
-    echo "Usage: $(basename "$0") [-d] [-e] [-r] [-v] [-t <test>] <SMR drive device node>"
+    echo "Usage: $(basename "$0") [-d] [-e] [-l] [-r] [-v] [-t <test>] [-z] <SMR drive device node>"
 }
 
 max() {
@@ -24,6 +24,14 @@ min() {
     fi
 }
 
+ioengine() {
+	if [ -n "$use_libzbc" ]; then
+		echo -n "--ioengine=libzbc"
+	else
+		echo -n "--ioengine=$1"
+	fi
+}
+
 set_io_scheduler() {
     local dev=$1 sched=$2
 
@@ -87,6 +95,7 @@ run_fio() {
 
     opts=("--aux-path=/tmp" "--allow_file_create=0" \
 			    "--significant_figures=10" "$@")
+    opts+=(${var_opts[@]})
     { echo; echo "fio ${opts[*]}"; echo; } >>"${logfile}.${test_number}"
 
     "${dynamic_analyzer[@]}" "$fio" "${opts[@]}"
@@ -115,7 +124,7 @@ run_fio_on_seq() {
 # Check whether buffered writes are refused.
 test1() {
     run_fio --name=job1 --filename="$dev" --rw=write --direct=0 --bs=4K	\
-	    --size="${zone_size}" --thread=1				\
+	    "$(ioengine "psync")" --size="${zone_size}" --thread=1	\
 	    --zonemode=zbd --zonesize="${zone_size}" 2>&1 |
 	tee -a "${logfile}.${test_number}" |
 	grep -q 'Using direct I/O is mandatory for writing to ZBD drives'
@@ -137,6 +146,7 @@ test2() {
 
     off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     bs=$((2 * zone_size))
+    opts+=("$(ioengine "psync")")
     opts+=("--name=job1" "--filename=$dev" "--rw=write" "--direct=1")
     opts+=("--zonemode=zbd" "--offset=$off" "--bs=$bs" "--size=$bs")
     if [ -z "$is_zbd" ]; then
@@ -155,7 +165,7 @@ test3() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=4K")
     opts+=("--size=$size" "--zonemode=zbd")
-    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--thread=1")
+    opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--thread=1")
     if [ -z "$is_zbd" ]; then
 	opts+=("--zonesize=${zone_size}")
     fi
@@ -178,7 +188,7 @@ test4() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--bs=$size")
     opts+=("--size=$size" "--thread=1" "--read_beyond_wp=1")
-    opts+=("--ioengine=psync" "--rw=read" "--direct=1" "--disable_lat=1")
+    opts+=("$(ioengine "psync")" "--rw=read" "--direct=1" "--disable_lat=1")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -189,7 +199,7 @@ test5() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write		\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -202,7 +212,7 @@ test6() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=read		\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=read	\
 		   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -212,7 +222,7 @@ test6() {
 test7() {
     local size=$((zone_size))
 
-    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=randwrite		\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=1 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5 --size="$size"		\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -225,7 +235,7 @@ test8() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bs="$(min 16384 "${zone_size}")"			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -243,7 +253,8 @@ test9() {
     fi
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=sg --iodepth=1 --rw=randwrite --bs=16K	\
+    run_fio_on_seq --ioengine=sg					\
+		   --iodepth=1 --rw=randwrite --bs=16K			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -260,7 +271,8 @@ test10() {
     fi
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=sg --iodepth=64 --rw=randwrite --bs=16K	\
+    run_fio_on_seq --ioengine=sg 					\
+		   --iodepth=64 --rw=randwrite --bs=16K			\
 		   --do_verify=1 --verify=md5				\
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -272,7 +284,7 @@ test11() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite	\
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite	\
 		   --bsrange=4K-64K --do_verify=1 --verify=md5		\
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -284,7 +296,7 @@ test12() {
     local size
 
     size=$((8 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=1 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written $size || return $?
@@ -296,7 +308,7 @@ test13() {
     local size
 
     size=$((8 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K     \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		   --max_open_zones=4 --size=$size --do_verify=1 --verify=md5 \
 		   --debug=zbd						      \
 		   >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -314,7 +326,7 @@ test14() {
 	     >>"${logfile}.${test_number}"
 	return 0
     fi
-    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randwrite --bs=16K \
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --do_verify=1 \
 		    --verify=md5 --size=$size				   \
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -333,14 +345,14 @@ test15() {
     done
     off=$(((first_sequential_zone_sector + 2 * sectors_per_zone) * 512))
     size=$((2 * zone_size))
-    run_one_fio_job --ioengine=psync --rw=write --bs=$((zone_size / 16))\
+    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$((zone_size / 16))\
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
     check_written $size || return $?
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job --ioengine=psync --rw=read --bs=$((zone_size / 16))	\
+    run_one_fio_job "$(ioengine "psync")" --rw=read --bs=$((zone_size / 16)) \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$((size)) >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
@@ -357,7 +369,7 @@ test16() {
 
     off=$((first_sequential_zone_sector * 512))
     size=$((4 * zone_size))
-    run_one_fio_job --ioengine=libaio --iodepth=64 --rw=randread --bs=16K \
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=64 --rw=randread --bs=16K \
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off \
 		    --size=$size >>"${logfile}.${test_number}" 2>&1 || return $?
     check_read $size || return $?
@@ -373,12 +385,12 @@ test17() {
     if [ -n "$is_zbd" ]; then
 	reset_zone "$dev" $((off / 512)) || return $?
     fi
-    run_one_fio_job --ioengine=psync --rw=write --offset="$off"		\
+    run_one_fio_job "$(ioengine "psync")" --rw=write --offset="$off"	\
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --bs="$zone_size" --size="$zone_size"		\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
     check_written "$zone_size" || return $?
-    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw --bs=4K	\
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw --bs=4K \
 		    --zonemode=zbd --zonesize="${zone_size}"		\
 		    --offset=$off --loops=2 --norandommap=1\
 		    >>"${logfile}.${test_number}" 2>&1 || return $?
@@ -431,8 +443,8 @@ test24() {
     local bs loops=9 size=$((zone_size))
 
     bs=$(min $((256*1024)) "$zone_size")
-    run_fio_on_seq --ioengine=psync --rw=write --bs="$bs" --size=$size	 \
-		   --loops=$loops					 \
+    run_fio_on_seq "$(ioengine "psync")" --rw=write --bs="$bs"		\
+		   --size=$size --loops=$loops				\
 		   --zone_reset_frequency=.01 --zone_reset_threshold=.90 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size * loops)) || return $?
@@ -452,8 +464,9 @@ test25() {
     for ((i=0;i<16;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--thread=1" "--direct=1")
 	opts+=("--offset=$((first_sequential_zone_sector*512 + zone_size*i))")
-	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=write" "--bs=16K")
+	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=write" "--bs=16K")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}" "--group_reporting=1")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
 }
@@ -462,7 +475,7 @@ write_to_first_seq_zone() {
     local loops=4 r
 
     r=$(((RANDOM << 16) | RANDOM))
-    run_fio --name="$dev" --filename="$dev" --ioengine=psync --rw="$1"	\
+    run_fio --name="$dev" --filename="$dev" "$(ioengine "psync")" --rw="$1" \
 	    --thread=1 --do_verify=1 --verify=md5 --direct=1 --bs=4K	\
 	    --offset=$((first_sequential_zone_sector * 512))		\
 	    "--size=$zone_size" --loops=$loops --randseed="$r"		\
@@ -490,9 +503,10 @@ test28() {
     opts=("--debug=zbd")
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
-	opts+=("--size=$zone_size" "--ioengine=psync" "--rw=randwrite")
+	opts+=("--size=$zone_size" "$(ioengine "psync")" "--rw=randwrite")
 	opts+=("--thread=1" "--direct=1" "--zonemode=zbd")
 	opts+=("--zonesize=${zone_size}" "--group_reporting=1")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -513,9 +527,10 @@ test29() {
     for ((i=0;i<jobs;i++)); do
 	opts+=("--name=job$i" "--filename=$dev" "--offset=$off" "--bs=16K")
 	opts+=("--size=$size" "--io_size=$zone_size" "--thread=1")
-	opts+=("--ioengine=psync" "--rw=randwrite" "--direct=1")
+	opts+=("$(ioengine "psync")" "--rw=randwrite" "--direct=1")
 	opts+=("--max_open_zones=4" "--group_reporting=1")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+	opts+=(${var_opts[@]})
     done
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((jobs * zone_size)) || return $?
@@ -526,7 +541,7 @@ test30() {
     local off
 
     off=$((first_sequential_zone_sector * 512))
-    run_one_fio_job --ioengine=libaio --iodepth=8 --rw=randrw		\
+    run_one_fio_job "$(ioengine "libaio")" --iodepth=8 --rw=randrw	\
 		    --bs="$(max $((zone_size / 128)) "$logical_block_size")"\
 		    --zonemode=zbd --zonesize="${zone_size}" --offset=$off\
 		    --loops=2 --time_based --runtime=30s --norandommap=1\
@@ -548,16 +563,17 @@ test31() {
     for ((off = first_sequential_zone_sector * 512; off < disk_size;
 	  off += inc)); do
 	opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--io_size=$bs")
-	opts+=("--bs=$bs" "--size=$zone_size" "--ioengine=libaio")
+	opts+=("--bs=$bs" "--size=$zone_size" "$(ioengine "libaio")")
 	opts+=("--rw=write" "--direct=1" "--thread=1" "--stats=0")
 	opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
+	opts+=(${var_opts[@]})
     done
     "$(dirname "$0")/../../fio" "${opts[@]}" >> "${logfile}.${test_number}" 2>&1
     # Next, run the test.
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
-    opts+=("--bs=$bs" "--ioengine=psync" "--rw=randread" "--direct=1")
+    opts+=("--bs=$bs" "$(ioengine "psync")" "--rw=randread" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
     run_fio "${opts[@]}" >> "${logfile}.${test_number}" 2>&1 || return $?
@@ -571,7 +587,7 @@ test32() {
     off=$((first_sequential_zone_sector * 512))
     size=$((disk_size - off))
     opts+=("--name=$dev" "--filename=$dev" "--offset=$off" "--size=$size")
-    opts+=("--bs=128K" "--ioengine=psync" "--rw=randwrite" "--direct=1")
+    opts+=("--bs=128K" "$(ioengine "psync")" "--rw=randwrite" "--direct=1")
     opts+=("--thread=1" "--time_based" "--runtime=30")
     opts+=("--max_open_zones=$max_open_zones" "--zonemode=zbd")
     opts+=("--zonesize=${zone_size}")
@@ -586,8 +602,8 @@ test33() {
     size=$((2 * zone_size))
     io_size=$((5 * zone_size))
     bs=$((3 * zone_size / 4))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	\
-		   --io_size=$io_size --bs=$bs				\
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write	\
+		   --size=$size --io_size=$io_size --bs=$bs	\
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $(((io_size + bs - 1) / bs * bs)) || return $?
 }
@@ -598,7 +614,7 @@ test34() {
     local size
 
     size=$((2 * zone_size))
-    run_fio_on_seq --ioengine=psync --iodepth=1 --rw=write --size=$size	  \
+    run_fio_on_seq "$(ioengine "psync")" --iodepth=1 --rw=write --size=$size \
 		   --do_verify=1 --verify=md5 --bs=$((3 * zone_size / 4)) \
 		   >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'not a divisor of' "${logfile}.${test_number}"
@@ -611,9 +627,9 @@ test35() {
     off=$(((first_sequential_zone_sector + 1) * 512))
     size=$((zone_size - 2 * 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -625,9 +641,9 @@ test36() {
     off=$(((first_sequential_zone_sector) * 512))
     size=$((zone_size - 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -643,9 +659,9 @@ test37() {
     fi
     size=$((zone_size + 2 * 512))
     bs=$((zone_size / 4))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1
     check_written $((zone_size)) || return $?
 }
@@ -657,9 +673,9 @@ test38() {
     size=$((logical_block_size))
     off=$((disk_size - logical_block_size))
     bs=$((logical_block_size))
-    run_one_fio_job --offset=$off --size=$size --ioengine=psync	--iodepth=1 \
-		    --rw=write --do_verify=1 --verify=md5 --bs=$bs	    \
-		    --zonemode=zbd --zonesize="${zone_size}"		    \
+    run_one_fio_job --offset=$off --size=$size "$(ioengine "psync")"	\
+		    --iodepth=1 --rw=write --do_verify=1 --verify=md5	\
+		    --bs=$bs --zonemode=zbd --zonesize="${zone_size}"	\
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'io_size must be at least one zone' "${logfile}.${test_number}"
 }
@@ -669,7 +685,7 @@ read_one_block() {
     local bs
 
     bs=$((logical_block_size))
-    run_one_fio_job --rw=read --ioengine=psync --bs=$bs --size=$bs "$@" 2>&1 |
+    run_one_fio_job --rw=read "$(ioengine "psync")" --bs=$bs --size=$bs "$@" 2>&1 |
 	tee -a "${logfile}.${test_number}"
 }
 
@@ -725,7 +741,7 @@ test45() {
 
     [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job --ioengine=psync --iodepth=1 --rw=randwrite --bs=$bs\
+    run_one_fio_job "$(ioengine "psync")" --iodepth=1 --rw=randwrite --bs=$bs\
 		    --offset=$((first_sequential_zone_sector * 512)) \
 		    --size="$zone_size" --do_verify=1 --verify=md5 2>&1 |
 	tee -a "${logfile}.${test_number}" |
@@ -737,7 +753,7 @@ test46() {
     local size
 
     size=$((4 * zone_size))
-    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
+    run_fio_on_seq "$(ioengine "libaio")" --iodepth=64 --rw=randwrite --bs=4K \
 		   --group_reporting=1 --numjobs=8 \
 		   >> "${logfile}.${test_number}" 2>&1 || return $?
     check_written $((size * 8)) || return $?
@@ -749,7 +765,7 @@ test47() {
 
     [ -z "$is_zbd" ] && return 0
     bs=$((logical_block_size))
-    run_one_fio_job --ioengine=psync --rw=write --bs=$bs \
+    run_one_fio_job "$(ioengine "psync")" --rw=write --bs=$bs \
 		    --zonemode=zbd --zoneskip=1		 \
 		    >> "${logfile}.${test_number}" 2>&1 && return 1
     grep -q 'zoneskip 1 is not a multiple of the device zone size' "${logfile}.${test_number}"
@@ -766,7 +782,7 @@ test48() {
     [ -n "$is_zbd" ] && reset_zone "$dev" $((off / 512))
     opts=("--aux-path=/tmp" "--allow_file_create=0" "--significant_figures=10")
     opts+=("--debug=zbd")
-    opts+=("--ioengine=libaio" "--rw=randwrite" "--direct=1")
+    opts+=("$(ioengine "libaio")" "--rw=randwrite" "--direct=1")
     opts+=("--time_based" "--runtime=30")
     opts+=("--zonemode=zbd" "--zonesize=${zone_size}")
     opts+=("--max_open_zones=4")
@@ -788,6 +804,8 @@ test48() {
 tests=()
 dynamic_analyzer=()
 reset_all_zones=
+use_libzbc=
+zbd_debug=
 
 while [ "${1#-}" != "$1" ]; do
   case "$1" in
@@ -796,10 +814,12 @@ while [ "${1#-}" != "$1" ]; do
 	shift;;
     -e) dynamic_analyzer=(valgrind "--read-var-info=yes" "--tool=helgrind");
 	shift;;
+    -l) use_libzbc=1; shift;;
     -r) reset_all_zones=1; shift;;
     -t) tests+=("$2"); shift; shift;;
     -v) dynamic_analyzer=(valgrind "--read-var-info=yes");
 	shift;;
+    -z) zbd_debug=1; shift;;
     --) shift; break;;
   esac
 done
@@ -812,48 +832,93 @@ fi
 # shellcheck source=functions
 source "$(dirname "$0")/functions" || exit $?
 
+var_opts=()
+if [ -n "$zbd_debug" ]; then
+    var_opts+=("--debug=zbd")
+fi
 dev=$1
 realdev=$(readlink -f "$dev")
 basename=$(basename "$realdev")
-major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
-minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
-disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
-# When the target is a partition device, get basename of its holder device to
-# access sysfs path of the holder device
-if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
-	realsysfs=$(readlink "/sys/dev/block/$major:$minor")
-	basename=$(basename "${realsysfs%/*}")
-fi
-logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
-case "$(<"/sys/class/block/$basename/queue/zoned")" in
-    host-managed|host-aware)
+
+if [[ -b "$realdev" ]]; then
+	major=$((0x$(stat -L -c '%t' "$realdev"))) || exit $?
+	minor=$((0x$(stat -L -c '%T' "$realdev"))) || exit $?
+	disk_size=$(($(<"/sys/dev/block/$major:$minor/size")*512))
+
+	# When the target is a partition device, get basename of its
+	# holder device to access sysfs path of the holder device
+	if [[ -r "/sys/dev/block/$major:$minor/partition" ]]; then
+		realsysfs=$(readlink "/sys/dev/block/$major:$minor")
+		basename=$(basename "${realsysfs%/*}")
+	fi
+	logical_block_size=$(<"/sys/block/$basename/queue/logical_block_size")
+	case "$(<"/sys/class/block/$basename/queue/zoned")" in
+	host-managed|host-aware)
+		is_zbd=true
+		if ! result=($(first_sequential_zone "$dev")); then
+			echo "Failed to determine first sequential zone"
+			exit 1
+		fi
+		first_sequential_zone_sector=${result[0]}
+		sectors_per_zone=${result[1]}
+		zone_size=$((sectors_per_zone * 512))
+		if ! max_open_zones=$(max_open_zones "$dev"); then
+			echo "Failed to determine maximum number of open zones"
+			exit 1
+		fi
+		set_io_scheduler "$basename" deadline || exit $?
+		if [ -n "$reset_all_zones" ]; then
+			reset_zone "$dev" -1
+		fi
+		;;
+	*)
+		first_sequential_zone_sector=$(((disk_size / 2) &
+						(logical_block_size - 1)))
+		zone_size=$(max 65536 "$logical_block_size")
+		sectors_per_zone=$((zone_size / 512))
+		max_open_zones=128
+		set_io_scheduler "$basename" none || exit $?
+		;;
+	esac
+elif [[ -c "$realdev" ]]; then
+	# For an SG node, we must have libzbc option specified
+	if [[ ! -n "$use_libzbc" ]]; then
+		echo "Character device files can only be used with -l (libzbc) option"
+		exit 1
+	fi
+
+	if ! $(is_zbc "$dev"); then
+		echo "Device is not a ZBC disk"
+		exit 1
+	fi
 	is_zbd=true
+
+	if ! disk_size=($(( $(zbc_disk_sectors "$dev") * 512))); then
+		echo "Failed to determine disk size"
+		exit 1
+	fi
+	if ! logical_block_size=($(zbc_logical_block_size "$dev")); then
+		echo "Failed to determine logical block size"
+		exit 1
+	fi
 	if ! result=($(first_sequential_zone "$dev")); then
-	    echo "Failed to determine first sequential zone"
-	    exit 1
+		echo "Failed to determine first sequential zone"
+		exit 1
 	fi
 	first_sequential_zone_sector=${result[0]}
 	sectors_per_zone=${result[1]}
 	zone_size=$((sectors_per_zone * 512))
 	if ! max_open_zones=$(max_open_zones "$dev"); then
-	    echo "Failed to determine maximum number of open zones"
-	    exit 1
+		echo "Failed to determine maximum number of open zones"
+		exit 1
 	fi
-	echo "First sequential zone starts at sector $first_sequential_zone_sector; zone size: $((zone_size >> 20)) MB"
-	set_io_scheduler "$basename" deadline || exit $?
 	if [ -n "$reset_all_zones" ]; then
-	    reset_zone "$dev" -1
+		reset_zone "$dev" -1
 	fi
-	;;
-    *)
-	first_sequential_zone_sector=$(((disk_size / 2) &
-					(logical_block_size - 1)))
-	zone_size=$(max 65536 "$logical_block_size")
-	sectors_per_zone=$((zone_size / 512))
-	max_open_zones=128
-	set_io_scheduler "$basename" none || exit $?
-	;;
-esac
+fi
+
+echo -n "First sequential zone starts at sector $first_sequential_zone_sector;"
+echo " zone size: $((zone_size >> 20)) MB"
 
 if [ "${#tests[@]}" = 0 ]; then
     readarray -t tests < <(declare -F | grep "test[0-9]*" | \
diff --git a/zbd.c b/zbd.c
index e2f3f52f..f4067802 100644
--- a/zbd.c
+++ b/zbd.c
@@ -7,12 +7,9 @@
 #include <errno.h>
 #include <string.h>
 #include <stdlib.h>
-#include <dirent.h>
 #include <fcntl.h>
-#include <sys/ioctl.h>
 #include <sys/stat.h>
 #include <unistd.h>
-#include <linux/blkzoned.h>
 
 #include "file.h"
 #include "fio.h"
@@ -23,6 +20,97 @@
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
+	if (td->io_ops && td->io_ops->get_zoned_model)
+		ret = td->io_ops->get_zoned_model(td, f, model);
+	else
+		ret = blkzoned_get_zoned_model(td, f, model);
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
+	if (td->io_ops && td->io_ops->report_zones)
+		ret = td->io_ops->report_zones(td, f, offset, zones, nr_zones);
+	else
+		ret = blkzoned_report_zones(td, f, offset, zones, nr_zones);
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
+	if (td->io_ops && td->io_ops->reset_wp)
+		ret = td->io_ops->reset_wp(td, f, offset, length);
+	else
+		ret = blkzoned_reset_wp(td, f, offset, length);
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
@@ -41,6 +129,15 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
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
@@ -54,7 +151,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 {
 	assert((required & 511) == 0);
 
-	return z->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
+	return zbd_zone_swr(z) &&
 		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
@@ -93,7 +190,7 @@ static bool zbd_using_direct_io(void)
 			continue;
 		for_each_file(td, f, j) {
 			if (f->zbd_info &&
-			    f->zbd_info->model == ZBD_DM_HOST_MANAGED)
+			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
 	}
@@ -112,8 +209,7 @@ static bool zbd_is_seq_job(struct fio_file *f)
 	zone_idx_b = zbd_zone_idx(f, f->file_offset);
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size - 1);
 	for (zone_idx = zone_idx_b; zone_idx <= zone_idx_e; zone_idx++)
-		if (f->zbd_info->zone_info[zone_idx].type ==
-		    BLK_ZONE_TYPE_SEQWRITE_REQ)
+		if (zbd_zone_swr(&f->zbd_info->zone_info[zone_idx]))
 			return true;
 
 	return false;
@@ -224,119 +320,6 @@ static bool zbd_verify_bs(void)
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
@@ -389,8 +372,8 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -405,51 +388,41 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -459,7 +432,7 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 			f->file_name, (unsigned long long) td->o.zone_size,
 			(unsigned long long) zone_size);
 		ret = -EINVAL;
-		goto close;
+		goto out;
 	}
 
 	dprint(FD_ZBD, "Device %s has %d zones of size %llu KB\n", f->file_name,
@@ -469,24 +442,24 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -495,22 +468,26 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -520,12 +497,9 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
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
@@ -537,21 +511,31 @@ out:
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
@@ -613,8 +597,6 @@ int zbd_init(struct thread_data *td)
 	int i;
 
 	for_each_file(td, f, i) {
-		if (f->filetype != FIO_TYPE_BLOCK)
-			continue;
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
@@ -642,31 +624,23 @@ int zbd_init(struct thread_data *td)
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
 
-	assert(f->fd != -1);
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
 
@@ -703,7 +677,7 @@ static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
  *
  * Returns 0 upon success and a negative error code upon failure.
  */
-static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 			  struct fio_zone_info *z)
 {
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
@@ -732,9 +706,8 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
-	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
-		if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+		if (!zbd_zone_swr(z))
 			continue;
 		zone_lock(td, z);
 		reset_wp = all_zones ? z->wp != z->start :
@@ -899,7 +872,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
 	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
 	bool res = true;
 
-	if (z->cond == BLK_ZONE_COND_OFFLINE)
+	if (z->cond == ZBD_ZONE_COND_OFFLINE)
 		return false;
 
 	/*
@@ -939,7 +912,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	zone_idx = f->zbd_info->open_zones[open_zone_idx];
 	memmove(f->zbd_info->open_zones + open_zone_idx,
 		f->zbd_info->open_zones + open_zone_idx + 1,
-		(FIO_MAX_OPEN_ZBD_ZONES - (open_zone_idx + 1)) *
+		(ZBD_MAX_OPEN_ZONES - (open_zone_idx + 1)) *
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
 	f->zbd_info->zone_info[zone_idx].open = 0;
@@ -1148,7 +1121,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 * the nearest non-empty zone in case of random I/O.
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
-		if (z1 < zl && z1->cond != BLK_ZONE_COND_OFFLINE) {
+		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z1->mutex);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
@@ -1157,7 +1130,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 			break;
 		}
 		if (td_random(td) && z2 >= zf &&
-		    z2->cond != BLK_ZONE_COND_OFFLINE) {
+		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z2->mutex);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
@@ -1193,7 +1166,7 @@ static void zbd_queue_io(struct io_u *io_u, int q, bool success)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = &zbd_info->zone_info[zone_idx];
 
-	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+	if (!zbd_zone_swr(z))
 		return;
 
 	if (!success)
@@ -1250,7 +1223,7 @@ static void zbd_put_io(const struct io_u *io_u)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = &zbd_info->zone_info[zone_idx];
 
-	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+	if (!zbd_zone_swr(z))
 		return;
 
 	dprint(FD_ZBD,
@@ -1261,6 +1234,13 @@ static void zbd_put_io(const struct io_u *io_u)
 	zbd_check_swd(f);
 }
 
+/*
+ * Windows and MacOS do not define this.
+ */
+#ifndef EREMOTEIO
+#define EREMOTEIO	121	/* POSIX value */
+#endif
+
 bool zbd_unaligned_write(int error_code)
 {
 	switch (error_code) {
@@ -1341,7 +1321,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
  */
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 {
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	uint32_t zone_idx_b;
 	struct fio_zone_info *zb, *zl, *orig_zb;
 	uint32_t orig_len = io_u->buflen;
@@ -1359,14 +1339,14 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
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
 
@@ -1385,7 +1365,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * I/O of at least min_bs B. If there isn't, find a new zone for
 		 * the I/O.
 		 */
-		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
+		range = zb->cond != ZBD_ZONE_COND_OFFLINE ?
 			zb->wp - zb->start : 0;
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
@@ -1510,7 +1490,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
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

