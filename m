Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49725 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934179AbcLPNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Dec 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cHs7I-0008TJ-11
        for fio@vger.kernel.org; Fri, 16 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161216130002.175832C00E7@kernel.dk>
Date: Fri, 16 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 13e0f06b805eb0bb3a100ed710c7da18684c8950:

  Change misleading error message for invalid size= value (2016-12-13 09:32:59 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 0d60927f167d318a685b9e5309bb392c624776e4:

  fio: move _FORTIFY_SOURCE to only when optimization is turned on (2016-12-15 14:55:00 -0700)

----------------------------------------------------------------
Dave Jiang (2):
      fio: add device dax engine
      fio: move _FORTIFY_SOURCE to only when optimization is turned on

 Makefile          |   7 +-
 configure         |  11 ++
 engines/dev-dax.c | 368 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 384 insertions(+), 2 deletions(-)
 create mode 100644 engines/dev-dax.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index b3a12dd..d27380b 100644
--- a/Makefile
+++ b/Makefile
@@ -20,7 +20,7 @@ all:
 include config-host.mak
 endif
 
-DEBUGFLAGS = -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+DEBUGFLAGS = -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
@@ -29,7 +29,7 @@ PROGS	= fio
 SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py tools/hist/fiologparser_hist.py)
 
 ifndef CONFIG_FIO_NO_OPT
-  CFLAGS += -O3
+  CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 ifdef CONFIG_GFIO
@@ -127,6 +127,9 @@ endif
 ifdef CONFIG_PMEMBLK
   SOURCE += engines/pmemblk.c
 endif
+ifdef CONFIG_LINUX_DEVDAX
+  SOURCE += engines/dev-dax.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/configure b/configure
index 833b6d3..03bed3b 100755
--- a/configure
+++ b/configure
@@ -136,6 +136,7 @@ exit_val=0
 gfio_check="no"
 libhdfs="no"
 pmemblk="no"
+devdax="no"
 disable_lex=""
 prefix=/usr/local
 
@@ -174,6 +175,8 @@ for opt do
   ;;
   --enable-pmemblk) pmemblk="yes"
   ;;
+  --enable-devdax) devdax="yes"
+  ;;
   --disable-lex) disable_lex="yes"
   ;;
   --enable-lex) disable_lex="no"
@@ -205,6 +208,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
   echo "--enable-pmemblk       Enable NVML libpmemblk support"
+  echo "--enable-devdax        Enable NVM Device Dax support"
   echo "--disable-lex          Disable use of lex/yacc for math"
   echo "--enable-lex           Enable use of lex/yacc for math"
   echo "--disable-shm          Disable SHM support"
@@ -1566,6 +1570,10 @@ echo "MTD                           $mtd"
 # Report whether pmemblk engine is enabled
 echo "NVML libpmemblk engine        $pmemblk"
 
+##########################################
+# Report whether dev-dax engine is enabled
+echo "NVM Device Dax engine        $devdax"
+
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
@@ -1917,6 +1925,9 @@ fi
 if test "$pmemblk" = "yes" ; then
   output_sym "CONFIG_PMEMBLK"
 fi
+if test "$devdax" = "yes" ; then
+  output_sym "CONFIG_LINUX_DEVDAX"
+fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
new file mode 100644
index 0000000..6372576
--- /dev/null
+++ b/engines/dev-dax.c
@@ -0,0 +1,368 @@
+/*
+ * device DAX engine
+ *
+ * IO engine that reads/writes from files by doing memcpy to/from
+ * a memory mapped region of DAX enabled device.
+ *
+ * Copyright (C) 2016 Intel Corp
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ *
+ */
+
+/*
+ * device dax engine
+ * IO engine that access a DAX device directly for read and write data
+ *
+ * To use:
+ *   ioengine=dev-dax
+ *
+ *   Other relevant settings:
+ *     iodepth=1
+ *     direct=0	   REQUIRED
+ *     filename=/dev/daxN.N
+ *     bs=2m
+ *
+ *     direct should be left to 0. Using dev-dax implies that memory access
+ *     is direct. However, dev-dax does not support O_DIRECT flag by design
+ *     since it is not necessary.
+ *
+ *     bs should adhere to the device dax alignment at minimally.
+ *
+ * libpmem.so
+ *   By default, the dev-dax engine will let the system find the libpmem.so
+ *   that it uses. You can use an alternative libpmem by setting the
+ *   FIO_PMEM_LIB environment variable to the full path to the desired
+ *   libpmem.so.
+ */
+
+#include <stdio.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/sysmacros.h>
+#include <dlfcn.h>
+#include <libgen.h>
+
+#include "../fio.h"
+#include "../verify.h"
+
+/*
+ * Limits us to 1GB of mapped files in total to model after
+ * mmap engine behavior
+ */
+#define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
+
+struct fio_devdax_data {
+	void *devdax_ptr;
+	size_t devdax_sz;
+	off_t devdax_off;
+};
+
+static void * (*pmem_memcpy_persist)(void *dest, const void *src, size_t len);
+
+static int fio_devdax_file(struct thread_data *td, struct fio_file *f,
+			   size_t length, off_t off)
+{
+	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
+	int flags = 0;
+
+	if (td_rw(td))
+		flags = PROT_READ | PROT_WRITE;
+	else if (td_write(td)) {
+		flags = PROT_WRITE;
+
+		if (td->o.verify != VERIFY_NONE)
+			flags |= PROT_READ;
+	} else
+		flags = PROT_READ;
+
+	fdd->devdax_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
+	if (fdd->devdax_ptr == MAP_FAILED) {
+		fdd->devdax_ptr = NULL;
+		td_verror(td, errno, "mmap");
+	}
+
+	if (td->error && fdd->devdax_ptr)
+		munmap(fdd->devdax_ptr, length);
+
+	return td->error;
+}
+
+/*
+ * Just mmap an appropriate portion, we cannot mmap the full extent
+ */
+static int fio_devdax_prep_limited(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
+
+	if (io_u->buflen > f->real_file_size) {
+		log_err("fio: bs too big for dev-dax engine\n");
+		return EIO;
+	}
+
+	fdd->devdax_sz = min(MMAP_TOTAL_SZ, f->real_file_size);
+	if (fdd->devdax_sz > f->io_size)
+		fdd->devdax_sz = f->io_size;
+
+	fdd->devdax_off = io_u->offset;
+
+	return fio_devdax_file(td, f, fdd->devdax_sz, fdd->devdax_off);
+}
+
+/*
+ * Attempt to mmap the entire file
+ */
+static int fio_devdax_prep_full(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
+	int ret;
+
+	if (fio_file_partial_mmap(f))
+		return EINVAL;
+
+	if (io_u->offset != (size_t) io_u->offset ||
+	    f->io_size != (size_t) f->io_size) {
+		fio_file_set_partial_mmap(f);
+		return EINVAL;
+	}
+
+	fdd->devdax_sz = f->io_size;
+	fdd->devdax_off = 0;
+
+	ret = fio_devdax_file(td, f, fdd->devdax_sz, fdd->devdax_off);
+	if (ret)
+		fio_file_set_partial_mmap(f);
+
+	return ret;
+}
+
+static int fio_devdax_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
+	int ret;
+
+	/*
+	 * It fits within existing mapping, use it
+	 */
+	if (io_u->offset >= fdd->devdax_off &&
+	    io_u->offset + io_u->buflen < fdd->devdax_off + fdd->devdax_sz)
+		goto done;
+
+	/*
+	 * unmap any existing mapping
+	 */
+	if (fdd->devdax_ptr) {
+		if (munmap(fdd->devdax_ptr, fdd->devdax_sz) < 0)
+			return errno;
+		fdd->devdax_ptr = NULL;
+	}
+
+	if (fio_devdax_prep_full(td, io_u)) {
+		td_clear_error(td);
+		ret = fio_devdax_prep_limited(td, io_u);
+		if (ret)
+			return ret;
+	}
+
+done:
+	io_u->mmap_data = fdd->devdax_ptr + io_u->offset - fdd->devdax_off -
+				f->file_offset;
+	return 0;
+}
+
+static int fio_devdax_queue(struct thread_data *td, struct io_u *io_u)
+{
+	fio_ro_check(td, io_u);
+	io_u->error = 0;
+
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		memcpy(io_u->xfer_buf, io_u->mmap_data, io_u->xfer_buflen);
+		break;
+	case DDIR_WRITE:
+		pmem_memcpy_persist(io_u->mmap_data, io_u->xfer_buf,
+				    io_u->xfer_buflen);
+		break;
+	case DDIR_SYNC:
+	case DDIR_DATASYNC:
+	case DDIR_SYNC_FILE_RANGE:
+		break;
+	default:
+		io_u->error = EINVAL;
+		break;
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_devdax_init(struct thread_data *td)
+{
+	struct thread_options *o = &td->o;
+	const char *path;
+	void *dl;
+
+	if ((o->rw_min_bs & page_mask) &&
+	    (o->fsync_blocks || o->fdatasync_blocks)) {
+		log_err("fio: mmap options dictate a minimum block size of "
+			"%llu bytes\n", (unsigned long long) page_size);
+		return 1;
+	}
+
+	path = getenv("FIO_PMEM_LIB");
+	if (!path)
+		path = "libpmem.so";
+
+	dl = dlopen(path, RTLD_NOW | RTLD_NODELETE);
+	if (!dl) {
+		log_err("fio: unable to open libpmem: %s\n", dlerror());
+		return 1;
+	}
+
+	pmem_memcpy_persist = dlsym(dl, "pmem_memcpy_persist");
+	if (!pmem_memcpy_persist) {
+		log_err("fio: unable to load libpmem: %s\n", dlerror());
+		return 1;
+	}
+
+	return 0;
+}
+
+static int fio_devdax_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_devdax_data *fdd;
+	int ret;
+
+	ret = generic_open_file(td, f);
+	if (ret)
+		return ret;
+
+	fdd = calloc(1, sizeof(*fdd));
+	if (!fdd) {
+		int fio_unused __ret;
+		__ret = generic_close_file(td, f);
+		return 1;
+	}
+
+	FILE_SET_ENG_DATA(f, fdd);
+
+	return 0;
+}
+
+static int fio_devdax_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_devdax_data *fdd = FILE_ENG_DATA(f);
+
+	FILE_SET_ENG_DATA(f, NULL);
+	free(fdd);
+	fio_file_clear_partial_mmap(f);
+
+	return generic_close_file(td, f);
+}
+
+static int
+fio_devdax_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	char spath[PATH_MAX];
+	char npath[PATH_MAX];
+	char *rpath;
+	FILE *sfile;
+	uint64_t size;
+	struct stat st;
+	int rc;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (f->filetype != FIO_TYPE_CHAR)
+		return -EINVAL;
+
+	rc = stat(f->file_name, &st);
+	if (rc < 0) {
+		log_err("%s: failed to stat file %s: %d\n",
+			td->o.name, f->file_name, errno);
+		return -errno;
+	}
+
+	snprintf(spath, PATH_MAX, "/sys/dev/char/%d:%d/subsystem",
+		 major(st.st_rdev), minor(st.st_rdev));
+
+	rpath = realpath(spath, npath);
+	if (!rpath) {
+		log_err("%s: realpath on %s failed: %d\n",
+			td->o.name, spath, errno);
+		return -errno;
+	}
+
+	/* check if DAX device */
+	if (strcmp("/sys/class/dax", rpath)) {
+		log_err("%s: %s not a DAX device!\n",
+			td->o.name, f->file_name);
+	}
+
+	snprintf(spath, PATH_MAX, "/sys/dev/char/%d:%d/size",
+		 major(st.st_rdev), minor(st.st_rdev));
+
+	sfile = fopen(spath, "r");
+	if (!sfile) {
+		log_err("%s: fopen on %s failed: %d\n",
+			td->o.name, spath, errno);
+		return 1;
+	}
+
+	rc = fscanf(sfile, "%lu", &size);
+	if (rc < 0) {
+		log_err("%s: fscanf on %s failed: %d\n",
+			td->o.name, spath, errno);
+		return 1;
+	}
+
+	f->real_file_size = size;
+
+	fclose(sfile);
+
+	if (f->file_offset > f->real_file_size) {
+		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
+					(unsigned long long) f->file_offset,
+					(unsigned long long) f->real_file_size);
+		return 1;
+	}
+
+	fio_file_set_size_known(f);
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name		= "dev-dax",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= fio_devdax_init,
+	.prep		= fio_devdax_prep,
+	.queue		= fio_devdax_queue,
+	.open_file	= fio_devdax_open_file,
+	.close_file	= fio_devdax_close_file,
+	.get_file_size	= fio_devdax_get_file_size,
+	.flags		= FIO_SYNCIO | FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
+};
+
+static void fio_init fio_devdax_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_devdax_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
