Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872DDC433F5
	for <fio@archiver.kernel.org>; Fri, 13 May 2022 12:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbiEMMAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 13 May 2022 08:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241025AbiEMMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 May 2022 08:00:12 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085DD285EF4
        for <fio@vger.kernel.org>; Fri, 13 May 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=gLBK01dejHBMw4Xzbx8XWlvp5XMKyOYek3R1kuPGVJI=; b=CISYY4mJ9VfqgQT1Ks5QXNT9kp
        aFIvbQMXYoNUzXbhiTDwfx7+lyMCux3KeDfvSUprHL21cCcJlhCgQqHUas2lj4qMkvj5ZIknLoNel
        OtxkxnpIkQsRqxiHN5mStNd0MXJvVczUMbnazjvms8qW3fXovtUB+TfFkKTU+YY0IhRaiCkXuGIrf
        ZW1eTslYdGSrs6wvV5iUW598ytNVcF96LPmU762aWVuZ6pfzLnh0U2gTpyW0o8VU/CM1PiMoIDiwa
        C+sYtJa2YYj4t/TIv09PZ3nzuDrMBG384bJiKR9J74ukz4EryT7oD96WUokcYKPVNr+5MMuHbBXqu
        FWf+1BbQ==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npTxl-007K4e-Nl
        for fio@vger.kernel.org; Fri, 13 May 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 5C0B61BC0122; Fri, 13 May 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220513120002.5C0B61BC0122@kernel.dk>
Date:   Fri, 13 May 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 12db6deb8b767ac89dd73e34dbc6f06905441e07:

  Merge branch 'patch-1' of https://github.com/ferdnyc/fio (2022-05-01 07:29:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6f1a24593c227a4f392f454698aca20e95f0006c:

  Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy` (2022-05-12 11:02:55 -0600)

----------------------------------------------------------------
Ammar Faizi (2):
      backend: Fix indentation
      Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`

Ankit Kumar (3):
      engines/xnvme: add xnvme engine
      docs: documentation for xnvme ioengine
      examples: add example job file for xnvme engine usage

 HOWTO.rst                  |  55 ++-
 Makefile                   |  13 +-
 backend.c                  |   2 +-
 configure                  |  22 +
 engines/xnvme.c            | 981 +++++++++++++++++++++++++++++++++++++++++++++
 examples/xnvme-compare.fio |  72 ++++
 examples/xnvme-zoned.fio   |  87 ++++
 fio.1                      |  70 +++-
 optgroup.h                 |   2 +
 options.c                  |   5 +
 10 files changed, 1302 insertions(+), 7 deletions(-)
 create mode 100644 engines/xnvme.c
 create mode 100644 examples/xnvme-compare.fio
 create mode 100644 examples/xnvme-zoned.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 6a3e09f5..84bea5c5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2171,6 +2171,12 @@ I/O engine
 		**exec**
 			Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
 
+		**xnvme**
+			I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
+			flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
+			the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
+			engine specific options. (See https://xnvme.io).
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2260,7 +2266,7 @@ with the caveat that when used on the command line, they must come after the
 	making the submission and completion part more lightweight. Required
 	for the below :option:`sqthread_poll` option.
 
-.. option:: sqthread_poll : [io_uring]
+.. option:: sqthread_poll : [io_uring] [xnvme]
 
 	Normally fio will submit IO by issuing a system call to notify the
 	kernel of available items in the SQ ring. If this option is set, the
@@ -2275,7 +2281,7 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: hipri
 
-   [io_uring]
+   [io_uring], [xnvme]
 
         If this option is set, fio will attempt to use polled IO completions.
         Normal IO completions generate interrupts to signal the completion of
@@ -2725,6 +2731,51 @@ with the caveat that when used on the command line, they must come after the
 
 	If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
 
+.. option:: xnvme_async=str : [xnvme]
+
+	Select the xnvme async command interface. This can take these values.
+
+	**emu**
+		This is default and used to emulate asynchronous I/O.
+	**thrpool**
+		Use thread pool for Asynchronous I/O.
+	**io_uring**
+		Use Linux io_uring/liburing for Asynchronous I/O.
+	**libaio**
+		Use Linux aio for Asynchronous I/O.
+	**posix**
+		Use POSIX aio for Asynchronous I/O.
+	**nil**
+		Use nil-io; For introspective perf. evaluation
+
+.. option:: xnvme_sync=str : [xnvme]
+
+	Select the xnvme synchronous command interface. This can take these values.
+
+	**nvme**
+		This is default and uses Linux NVMe Driver ioctl() for synchronous I/O.
+	**psync**
+		Use pread()/write() for synchronous I/O.
+
+.. option:: xnvme_admin=str : [xnvme]
+
+	Select the xnvme admin command interface. This can take these values.
+
+	**nvme**
+		This is default and uses linux NVMe Driver ioctl() for admin commands.
+	**block**
+		Use Linux Block Layer ioctl() and sysfs for admin commands.
+	**file_as_ns**
+		Use file-stat to construct NVMe idfy responses.
+
+.. option:: xnvme_dev_nsid=int : [xnvme]
+
+	xnvme namespace identifier, for userspace NVMe driver.
+
+.. option:: xnvme_iovec=int : [xnvme]
+
+	If this option is set. xnvme will use vectored read/write commands.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index e670c1f2..ed66305a 100644
--- a/Makefile
+++ b/Makefile
@@ -223,7 +223,12 @@ ifdef CONFIG_LIBZBC
   libzbc_LIBS = -lzbc
   ENGINES += libzbc
 endif
-
+ifdef CONFIG_LIBXNVME
+  xnvme_SRCS = engines/xnvme.c
+  xnvme_LIBS = $(LIBXNVME_LIBS)
+  xnvme_CFLAGS = $(LIBXNVME_CFLAGS)
+  ENGINES += xnvme
+endif
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
 		oslib/linux-dev-lookup.c engines/io_uring.c
@@ -530,8 +535,12 @@ else
 	$(QUIET_LEX)$(LEX) $<
 endif
 
+ifneq (,$(findstring -Wimplicit-fallthrough,$(CFLAGS)))
+LEX_YY_CFLAGS := -Wno-implicit-fallthrough
+endif
+
 lex.yy.o: lex.yy.c y.tab.h
-	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) $(LEX_YY_CFLAGS) -c $<
 
 y.tab.o: y.tab.c y.tab.h
 	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
diff --git a/backend.c b/backend.c
index ffbb7e2a..e5bb4e25 100644
--- a/backend.c
+++ b/backend.c
@@ -2021,7 +2021,7 @@ static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 	for_each_td(td, i) {
 		int flags = 0;
 
-		 if (!strcmp(td->o.ioengine, "cpuio"))
+		if (!strcmp(td->o.ioengine, "cpuio"))
 			cputhreads++;
 		else
 			realthreads++;
diff --git a/configure b/configure
index d327d2ca..95b60bb7 100755
--- a/configure
+++ b/configure
@@ -171,6 +171,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libnfs="no"
+xnvme="no"
 libzbc=""
 dfs=""
 dynamic_engines="no"
@@ -240,6 +241,8 @@ for opt do
   ;;
   --disable-libzbc) libzbc="no"
   ;;
+  --enable-xnvme) xnvme="yes"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --disable-nfs) disable_nfs="yes"
@@ -291,6 +294,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
+  echo "--enable-xnvme          Enable xnvme support"
   echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc      Disable tcmalloc support"
   echo "--dynamic-libengines    Lib-based ioengines as dynamic libraries"
@@ -2583,6 +2587,19 @@ if test "$libzbc" != "no" ; then
 fi
 print_config "libzbc engine" "$libzbc"
 
+##########################################
+# Check if we have xnvme
+if test "$xnvme" != "yes" ; then
+  if check_min_lib_version xnvme 0.2.0; then
+    xnvme="yes"
+    xnvme_cflags=$(pkg-config --cflags xnvme)
+    xnvme_libs=$(pkg-config --libs xnvme)
+  else
+    xnvme="no"
+  fi
+fi
+print_config "xnvme engine" "$xnvme"
+
 ##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
@@ -3190,6 +3207,11 @@ if test "$libnfs" = "yes" ; then
   echo "LIBNFS_CFLAGS=$libnfs_cflags" >> $config_host_mak
   echo "LIBNFS_LIBS=$libnfs_libs" >> $config_host_mak
 fi
+if test "$xnvme" = "yes" ; then
+  output_sym "CONFIG_LIBXNVME"
+  echo "LIBXNVME_CFLAGS=$xnvme_cflags" >> $config_host_mak
+  echo "LIBXNVME_LIBS=$xnvme_libs" >> $config_host_mak
+fi
 if test "$dynamic_engines" = "yes" ; then
   output_sym "CONFIG_DYNAMIC_ENGINES"
 fi
diff --git a/engines/xnvme.c b/engines/xnvme.c
new file mode 100644
index 00000000..c11b33a8
--- /dev/null
+++ b/engines/xnvme.c
@@ -0,0 +1,981 @@
+/*
+ * fio xNVMe IO Engine
+ *
+ * IO engine using the xNVMe C API.
+ *
+ * See: http://xnvme.io/
+ *
+ * SPDX-License-Identifier: Apache-2.0
+ */
+#include <stdlib.h>
+#include <assert.h>
+#include <libxnvme.h>
+#include <libxnvme_libconf.h>
+#include <libxnvme_nvm.h>
+#include <libxnvme_znd.h>
+#include <libxnvme_spec_fs.h>
+#include "fio.h"
+#include "zbd_types.h"
+#include "optgroup.h"
+
+static pthread_mutex_t g_serialize = PTHREAD_MUTEX_INITIALIZER;
+
+struct xnvme_fioe_fwrap {
+	/* fio file representation */
+	struct fio_file *fio_file;
+
+	/* xNVMe device handle */
+	struct xnvme_dev *dev;
+	/* xNVMe device geometry */
+	const struct xnvme_geo *geo;
+
+	struct xnvme_queue *queue;
+
+	uint32_t ssw;
+	uint32_t lba_nbytes;
+
+	uint8_t _pad[24];
+};
+XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_fwrap) == 64, "Incorrect size")
+
+struct xnvme_fioe_data {
+	/* I/O completion queue */
+	struct io_u **iocq;
+
+	/* # of iocq entries; incremented via getevents()/cb_pool() */
+	uint64_t completed;
+
+	/*
+	 *  # of errors; incremented when observed on completion via
+	 *  getevents()/cb_pool()
+	 */
+	uint64_t ecount;
+
+	/* Controller which device/file to select */
+	int32_t prev;
+	int32_t cur;
+
+	/* Number of devices/files for which open() has been called */
+	int64_t nopen;
+	/* Number of devices/files allocated in files[] */
+	uint64_t nallocated;
+
+	struct iovec *iovec;
+
+	uint8_t _pad[8];
+
+	struct xnvme_fioe_fwrap files[];
+};
+XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_data) == 64, "Incorrect size")
+
+struct xnvme_fioe_options {
+	void *padding;
+	unsigned int hipri;
+	unsigned int sqpoll_thread;
+	unsigned int xnvme_dev_nsid;
+	unsigned int xnvme_iovec;
+	char *xnvme_be;
+	char *xnvme_async;
+	char *xnvme_sync;
+	char *xnvme_admin;
+};
+
+static struct fio_option options[] = {
+	{
+		.name = "hipri",
+		.lname = "High Priority",
+		.type = FIO_OPT_STR_SET,
+		.off1 = offsetof(struct xnvme_fioe_options, hipri),
+		.help = "Use polled IO completions",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "sqthread_poll",
+		.lname = "Kernel SQ thread polling",
+		.type = FIO_OPT_STR_SET,
+		.off1 = offsetof(struct xnvme_fioe_options, sqpoll_thread),
+		.help = "Offload submission/completion to kernel thread",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_be",
+		.lname = "xNVMe Backend",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_be),
+		.help = "Select xNVMe backend [spdk,linux,fbsd]",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_async",
+		.lname = "xNVMe Asynchronous command-interface",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_async),
+		.help = "Select xNVMe async. interface: [emu,thrpool,io_uring,libaio,posix,nil]",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_sync",
+		.lname = "xNVMe Synchronous. command-interface",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_sync),
+		.help = "Select xNVMe sync. interface: [nvme,psync]",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_admin",
+		.lname = "xNVMe Admin command-interface",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_admin),
+		.help = "Select xNVMe admin. cmd-interface: [nvme,block,file_as_ns]",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_dev_nsid",
+		.lname = "xNVMe Namespace-Identifier, for user-space NVMe driver",
+		.type = FIO_OPT_INT,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_dev_nsid),
+		.help = "xNVMe Namespace-Identifier, for user-space NVMe driver",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+	{
+		.name = "xnvme_iovec",
+		.lname = "Vectored IOs",
+		.type = FIO_OPT_STR_SET,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_iovec),
+		.help = "Send vectored IOs",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
+
+	{
+		.name = NULL,
+	},
+};
+
+static void cb_pool(struct xnvme_cmd_ctx *ctx, void *cb_arg)
+{
+	struct io_u *io_u = cb_arg;
+	struct xnvme_fioe_data *xd = io_u->mmap_data;
+
+	if (xnvme_cmd_ctx_cpl_status(ctx)) {
+		xnvme_cmd_ctx_pr(ctx, XNVME_PR_DEF);
+		xd->ecount += 1;
+		io_u->error = EIO;
+	}
+
+	xd->iocq[xd->completed++] = io_u;
+	xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+}
+
+static struct xnvme_opts xnvme_opts_from_fioe(struct thread_data *td)
+{
+	struct xnvme_fioe_options *o = td->eo;
+	struct xnvme_opts opts = xnvme_opts_default();
+
+	opts.nsid = o->xnvme_dev_nsid;
+	opts.be = o->xnvme_be;
+	opts.async = o->xnvme_async;
+	opts.sync = o->xnvme_sync;
+	opts.admin = o->xnvme_admin;
+
+	opts.poll_io = o->hipri;
+	opts.poll_sq = o->sqpoll_thread;
+
+	opts.direct = td->o.odirect;
+
+	return opts;
+}
+
+static void _dev_close(struct thread_data *td, struct xnvme_fioe_fwrap *fwrap)
+{
+	if (fwrap->dev)
+		xnvme_queue_term(fwrap->queue);
+
+	xnvme_dev_close(fwrap->dev);
+
+	memset(fwrap, 0, sizeof(*fwrap));
+}
+
+static void xnvme_fioe_cleanup(struct thread_data *td)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	int err;
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err)
+		log_err("ioeng->cleanup(): pthread_mutex_lock(), err(%d)\n", err);
+		/* NOTE: not returning here */
+
+	for (uint64_t i = 0; i < xd->nallocated; ++i)
+		_dev_close(td, &xd->files[i]);
+
+	if (!err) {
+		err = pthread_mutex_unlock(&g_serialize);
+		if (err)
+			log_err("ioeng->cleanup(): pthread_mutex_unlock(), err(%d)\n", err);
+	}
+
+	free(xd->iocq);
+	free(xd->iovec);
+	free(xd);
+	td->io_ops_data = NULL;
+}
+
+/**
+ * Helper function setting up device handles as addressed by the naming
+ * convention of the given `fio_file` filename.
+ *
+ * Checks thread-options for explicit control of asynchronous implementation via
+ * the ``--xnvme_async={thrpool,emu,posix,io_uring,libaio,nil}``.
+ */
+static int _dev_open(struct thread_data *td, struct fio_file *f)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap;
+	int flags = 0;
+	int err;
+
+	if (f->fileno > (int)xd->nallocated) {
+		log_err("ioeng->_dev_open(%s): invalid assumption\n", f->file_name);
+		return 1;
+	}
+
+	fwrap = &xd->files[f->fileno];
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		log_err("ioeng->_dev_open(%s): pthread_mutex_lock(), err(%d)\n", f->file_name,
+			err);
+		return -err;
+	}
+
+	fwrap->dev = xnvme_dev_open(f->file_name, &opts);
+	if (!fwrap->dev) {
+		log_err("ioeng->_dev_open(%s): xnvme_dev_open(), err(%d)\n", f->file_name, errno);
+		goto failure;
+	}
+	fwrap->geo = xnvme_dev_get_geo(fwrap->dev);
+
+	if (xnvme_queue_init(fwrap->dev, td->o.iodepth, flags, &(fwrap->queue))) {
+		log_err("ioeng->_dev_open(%s): xnvme_queue_init(), err(?)\n", f->file_name);
+		goto failure;
+	}
+	xnvme_queue_set_cb(fwrap->queue, cb_pool, NULL);
+
+	fwrap->ssw = xnvme_dev_get_ssw(fwrap->dev);
+	fwrap->lba_nbytes = fwrap->geo->lba_nbytes;
+
+	fwrap->fio_file = f;
+	fwrap->fio_file->filetype = FIO_TYPE_BLOCK;
+	fwrap->fio_file->real_file_size = fwrap->geo->tbytes;
+	fio_file_set_size_known(fwrap->fio_file);
+
+	err = pthread_mutex_unlock(&g_serialize);
+	if (err)
+		log_err("ioeng->_dev_open(%s): pthread_mutex_unlock(), err(%d)\n", f->file_name,
+			err);
+
+	return 0;
+
+failure:
+	xnvme_queue_term(fwrap->queue);
+	xnvme_dev_close(fwrap->dev);
+
+	err = pthread_mutex_unlock(&g_serialize);
+	if (err)
+		log_err("ioeng->_dev_open(%s): pthread_mutex_unlock(), err(%d)\n", f->file_name,
+			err);
+
+	return 1;
+}
+
+static int xnvme_fioe_init(struct thread_data *td)
+{
+	struct xnvme_fioe_data *xd = NULL;
+	struct fio_file *f;
+	unsigned int i;
+
+	if (!td->o.use_thread) {
+		log_err("ioeng->init(): --thread=1 is required\n");
+		return 1;
+	}
+
+	/* Allocate xd and iocq */
+	xd = calloc(1, sizeof(*xd) + sizeof(*xd->files) * td->o.nr_files);
+	if (!xd) {
+		log_err("ioeng->init(): !calloc(), err(%d)\n", errno);
+		return 1;
+	}
+
+	xd->iocq = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!xd->iocq) {
+		log_err("ioeng->init(): !calloc(), err(%d)\n", errno);
+		return 1;
+	}
+
+	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
+	if (!xd->iovec) {
+		log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
+		return 1;
+	}
+
+	xd->prev = -1;
+	td->io_ops_data = xd;
+
+	for_each_file(td, f, i)
+	{
+		if (_dev_open(td, f)) {
+			log_err("ioeng->init(): failed; _dev_open(%s)\n", f->file_name);
+			return 1;
+		}
+
+		++(xd->nallocated);
+	}
+
+	if (xd->nallocated != td->o.nr_files) {
+		log_err("ioeng->init(): failed; nallocated != td->o.nr_files\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+/* NOTE: using the first device for buffer-allocators) */
+static int xnvme_fioe_iomem_alloc(struct thread_data *td, size_t total_mem)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap = &xd->files[0];
+
+	if (!fwrap->dev) {
+		log_err("ioeng->iomem_alloc(): failed; no dev-handle\n");
+		return 1;
+	}
+
+	td->orig_buffer = xnvme_buf_alloc(fwrap->dev, total_mem);
+
+	return td->orig_buffer == NULL;
+}
+
+/* NOTE: using the first device for buffer-allocators) */
+static void xnvme_fioe_iomem_free(struct thread_data *td)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap = &xd->files[0];
+
+	if (!fwrap->dev) {
+		log_err("ioeng->iomem_free(): failed no dev-handle\n");
+		return;
+	}
+
+	xnvme_buf_free(fwrap->dev, td->orig_buffer);
+}
+
+static int xnvme_fioe_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	io_u->mmap_data = td->io_ops_data;
+
+	return 0;
+}
+
+static void xnvme_fioe_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	io_u->mmap_data = NULL;
+}
+
+static struct io_u *xnvme_fioe_event(struct thread_data *td, int event)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+
+	assert(event >= 0);
+	assert((unsigned)event < xd->completed);
+
+	return xd->iocq[event];
+}
+
+static int xnvme_fioe_getevents(struct thread_data *td, unsigned int min, unsigned int max,
+				const struct timespec *t)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap = NULL;
+	int nfiles = xd->nallocated;
+	int err = 0;
+
+	if (xd->prev != -1 && ++xd->prev < nfiles) {
+		fwrap = &xd->files[xd->prev];
+		xd->cur = xd->prev;
+	}
+
+	xd->completed = 0;
+	for (;;) {
+		if (fwrap == NULL || xd->cur == nfiles) {
+			fwrap = &xd->files[0];
+			xd->cur = 0;
+		}
+
+		while (fwrap != NULL && xd->cur < nfiles && err >= 0) {
+			err = xnvme_queue_poke(fwrap->queue, max - xd->completed);
+			if (err < 0) {
+				switch (err) {
+				case -EBUSY:
+				case -EAGAIN:
+					usleep(1);
+					break;
+
+				default:
+					log_err("ioeng->getevents(): unhandled IO error\n");
+					assert(false);
+					return 0;
+				}
+			}
+			if (xd->completed >= min) {
+				xd->prev = xd->cur;
+				return xd->completed;
+			}
+			xd->cur++;
+			fwrap = &xd->files[xd->cur];
+
+			if (err < 0) {
+				switch (err) {
+				case -EBUSY:
+				case -EAGAIN:
+					usleep(1);
+					break;
+				}
+			}
+		}
+	}
+
+	xd->cur = 0;
+
+	return xd->completed;
+}
+
+static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *io_u)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap;
+	struct xnvme_cmd_ctx *ctx;
+	uint32_t nsid;
+	uint64_t slba;
+	uint16_t nlb;
+	int err;
+	bool vectored_io = ((struct xnvme_fioe_options *)td->eo)->xnvme_iovec;
+
+	fio_ro_check(td, io_u);
+
+	fwrap = &xd->files[io_u->file->fileno];
+	nsid = xnvme_dev_get_nsid(fwrap->dev);
+
+	slba = io_u->offset >> fwrap->ssw;
+	nlb = (io_u->xfer_buflen >> fwrap->ssw) - 1;
+
+	ctx = xnvme_queue_get_cmd_ctx(fwrap->queue);
+	ctx->async.cb_arg = io_u;
+
+	ctx->cmd.common.nsid = nsid;
+	ctx->cmd.nvm.slba = slba;
+	ctx->cmd.nvm.nlb = nlb;
+
+	switch (io_u->ddir) {
+	case DDIR_READ:
+		ctx->cmd.common.opcode = XNVME_SPEC_NVM_OPC_READ;
+		break;
+
+	case DDIR_WRITE:
+		ctx->cmd.common.opcode = XNVME_SPEC_NVM_OPC_WRITE;
+		break;
+
+	default:
+		log_err("ioeng->queue(): ENOSYS: %u\n", io_u->ddir);
+		err = -1;
+		assert(false);
+		break;
+	}
+
+	if (vectored_io) {
+		xd->iovec[io_u->index].iov_base = io_u->xfer_buf;
+		xd->iovec[io_u->index].iov_len = io_u->xfer_buflen;
+
+		err = xnvme_cmd_passv(ctx, &xd->iovec[io_u->index], 1, io_u->xfer_buflen, NULL, 0,
+				      0);
+	} else {
+		err = xnvme_cmd_pass(ctx, io_u->xfer_buf, io_u->xfer_buflen, NULL, 0);
+	}
+	switch (err) {
+	case 0:
+		return FIO_Q_QUEUED;
+
+	case -EBUSY:
+	case -EAGAIN:
+		xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+		return FIO_Q_BUSY;
+
+	default:
+		log_err("ioeng->queue(): err: '%d'\n", err);
+
+		xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+
+		io_u->error = abs(err);
+		assert(false);
+		return FIO_Q_COMPLETED;
+	}
+}
+
+static int xnvme_fioe_close(struct thread_data *td, struct fio_file *f)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+
+	dprint(FD_FILE, "xnvme close %s -- nopen: %ld\n", f->file_name, xd->nopen);
+
+	--(xd->nopen);
+
+	return 0;
+}
+
+static int xnvme_fioe_open(struct thread_data *td, struct fio_file *f)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+
+	dprint(FD_FILE, "xnvme open %s -- nopen: %ld\n", f->file_name, xd->nopen);
+
+	if (f->fileno > (int)xd->nallocated) {
+		log_err("ioeng->open(): f->fileno > xd->nallocated; invalid assumption\n");
+		return 1;
+	}
+	if (xd->files[f->fileno].fio_file != f) {
+		log_err("ioeng->open(): fio_file != f; invalid assumption\n");
+		return 1;
+	}
+
+	++(xd->nopen);
+
+	return 0;
+}
+
+static int xnvme_fioe_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	/* Consider only doing this with be:spdk */
+	return 0;
+}
+
+static int xnvme_fioe_get_max_open_zones(struct thread_data *td, struct fio_file *f,
+					 unsigned int *max_open_zones)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_dev *dev;
+	const struct xnvme_spec_znd_idfy_ns *zns;
+	int err = 0, err_lock;
+
+	if (f->filetype != FIO_TYPE_FILE && f->filetype != FIO_TYPE_BLOCK &&
+	    f->filetype != FIO_TYPE_CHAR) {
+		log_info("ioeng->get_max_open_zoned(): ignoring filetype: %d\n", f->filetype);
+		return 0;
+	}
+	err_lock = pthread_mutex_lock(&g_serialize);
+	if (err_lock) {
+		log_err("ioeng->get_max_open_zones(): pthread_mutex_lock(), err(%d)\n", err_lock);
+		return -err_lock;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("ioeng->get_max_open_zones(): xnvme_dev_open(), err(%d)\n", err_lock);
+		err = -errno;
+		goto exit;
+	}
+	if (xnvme_dev_get_geo(dev)->type != XNVME_GEO_ZONED) {
+		errno = EINVAL;
+		err = -errno;
+		goto exit;
+	}
+
+	zns = (void *)xnvme_dev_get_ns_css(dev);
+	if (!zns) {
+		log_err("ioeng->get_max_open_zones(): xnvme_dev_get_ns_css(), err(%d)\n", errno);
+		err = -errno;
+		goto exit;
+	}
+
+	/*
+	 * intentional overflow as the value is zero-based and NVMe
+	 * defines 0xFFFFFFFF as unlimited thus overflowing to 0 which
+	 * is how fio indicates unlimited and otherwise just converting
+	 * to one-based.
+	 */
+	*max_open_zones = zns->mor + 1;
+
+exit:
+	xnvme_dev_close(dev);
+	err_lock = pthread_mutex_unlock(&g_serialize);
+	if (err_lock)
+		log_err("ioeng->get_max_open_zones(): pthread_mutex_unlock(), err(%d)\n",
+			err_lock);
+
+	return err;
+}
+
+/**
+ * Currently, this function is called before of I/O engine initialization, so,
+ * we cannot consult the file-wrapping done when 'fioe' initializes.
+ * Instead we just open based on the given filename.
+ *
+ * TODO: unify the different setup methods, consider keeping the handle around,
+ * and consider how to support the --be option in this usecase
+ */
+static int xnvme_fioe_get_zoned_model(struct thread_data *td, struct fio_file *f,
+				      enum zbd_zoned_model *model)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_dev *dev;
+	int err = 0, err_lock;
+
+	if (f->filetype != FIO_TYPE_FILE && f->filetype != FIO_TYPE_BLOCK &&
+	    f->filetype != FIO_TYPE_CHAR) {
+		log_info("ioeng->get_zoned_model(): ignoring filetype: %d\n", f->filetype);
+		return -EINVAL;
+	}
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		log_err("ioeng->get_zoned_model(): pthread_mutex_lock(), err(%d)\n", err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("ioeng->get_zoned_model(): xnvme_dev_open(%s) failed, errno: %d\n",
+			f->file_name, errno);
+		err = -errno;
+		goto exit;
+	}
+
+	switch (xnvme_dev_get_geo(dev)->type) {
+	case XNVME_GEO_UNKNOWN:
+		dprint(FD_ZBD, "%s: got 'unknown', assigning ZBD_NONE\n", f->file_name);
+		*model = ZBD_NONE;
+		break;
+
+	case XNVME_GEO_CONVENTIONAL:
+		dprint(FD_ZBD, "%s: got 'conventional', assigning ZBD_NONE\n", f->file_name);
+		*model = ZBD_NONE;
+		break;
+
+	case XNVME_GEO_ZONED:
+		dprint(FD_ZBD, "%s: got 'zoned', assigning ZBD_HOST_MANAGED\n", f->file_name);
+		*model = ZBD_HOST_MANAGED;
+		break;
+
+	default:
+		dprint(FD_ZBD, "%s: hit-default, assigning ZBD_NONE\n", f->file_name);
+		*model = ZBD_NONE;
+		errno = EINVAL;
+		err = -errno;
+		break;
+	}
+
+exit:
+	xnvme_dev_close(dev);
+
+	err_lock = pthread_mutex_unlock(&g_serialize);
+	if (err_lock)
+		log_err("ioeng->get_zoned_model(): pthread_mutex_unlock(), err(%d)\n", err_lock);
+
+	return err;
+}
+
+/**
+ * Fills the given ``zbdz`` with at most ``nr_zones`` zone-descriptors.
+ *
+ * The implementation converts the NVMe Zoned Command Set log-pages for Zone
+ * descriptors into the Linux Kernel Zoned Block Report format.
+ *
+ * NOTE: This function is called before I/O engine initialization, that is,
+ * before ``_dev_open`` has been called and file-wrapping is setup. Thus is has
+ * to do the ``_dev_open`` itself, and shut it down again once it is done
+ * retrieving the log-pages and converting them to the report format.
+ *
+ * TODO: unify the different setup methods, consider keeping the handle around,
+ * and consider how to support the --async option in this usecase
+ */
+static int xnvme_fioe_report_zones(struct thread_data *td, struct fio_file *f, uint64_t offset,
+				   struct zbd_zone *zbdz, unsigned int nr_zones)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	const struct xnvme_spec_znd_idfy_lbafe *lbafe = NULL;
+	struct xnvme_dev *dev = NULL;
+	const struct xnvme_geo *geo = NULL;
+	struct xnvme_znd_report *rprt = NULL;
+	uint32_t ssw;
+	uint64_t slba;
+	unsigned int limit = 0;
+	int err = 0, err_lock;
+
+	dprint(FD_ZBD, "%s: report_zones() offset: %zu, nr_zones: %u\n", f->file_name, offset,
+	       nr_zones);
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		log_err("ioeng->report_zones(%s): pthread_mutex_lock(), err(%d)\n", f->file_name,
+			err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("ioeng->report_zones(%s): xnvme_dev_open(), err(%d)\n", f->file_name,
+			errno);
+		goto exit;
+	}
+
+	geo = xnvme_dev_get_geo(dev);
+	ssw = xnvme_dev_get_ssw(dev);
+	lbafe = xnvme_znd_dev_get_lbafe(dev);
+
+	limit = nr_zones > geo->nzone ? geo->nzone : nr_zones;
+
+	dprint(FD_ZBD, "%s: limit: %u\n", f->file_name, limit);
+
+	slba = ((offset >> ssw) / geo->nsect) * geo->nsect;
+
+	rprt = xnvme_znd_report_from_dev(dev, slba, limit, 0);
+	if (!rprt) {
+		log_err("ioeng->report_zones(%s): xnvme_znd_report_from_dev(), err(%d)\n",
+			f->file_name, errno);
+		err = -errno;
+		goto exit;
+	}
+	if (rprt->nentries != limit) {
+		log_err("ioeng->report_zones(%s): nentries != nr_zones\n", f->file_name);
+		err = 1;
+		goto exit;
+	}
+	if (offset > geo->tbytes) {
+		log_err("ioeng->report_zones(%s): out-of-bounds\n", f->file_name);
+		goto exit;
+	}
+
+	/* Transform the zone-report */
+	for (uint32_t idx = 0; idx < rprt->nentries; ++idx) {
+		struct xnvme_spec_znd_descr *descr = XNVME_ZND_REPORT_DESCR(rprt, idx);
+
+		zbdz[idx].start = descr->zslba << ssw;
+		zbdz[idx].len = lbafe->zsze << ssw;
+		zbdz[idx].capacity = descr->zcap << ssw;
+		zbdz[idx].wp = descr->wp << ssw;
+
+		switch (descr->zt) {
+		case XNVME_SPEC_ZND_TYPE_SEQWR:
+			zbdz[idx].type = ZBD_ZONE_TYPE_SWR;
+			break;
+
+		default:
+			log_err("ioeng->report_zones(%s): invalid type for zone at offset(%zu)\n",
+				f->file_name, zbdz[idx].start);
+			err = -EIO;
+			goto exit;
+		}
+
+		switch (descr->zs) {
+		case XNVME_SPEC_ZND_STATE_EMPTY:
+			zbdz[idx].cond = ZBD_ZONE_COND_EMPTY;
+			break;
+		case XNVME_SPEC_ZND_STATE_IOPEN:
+			zbdz[idx].cond = ZBD_ZONE_COND_IMP_OPEN;
+			break;
+		case XNVME_SPEC_ZND_STATE_EOPEN:
+			zbdz[idx].cond = ZBD_ZONE_COND_EXP_OPEN;
+			break;
+		case XNVME_SPEC_ZND_STATE_CLOSED:
+			zbdz[idx].cond = ZBD_ZONE_COND_CLOSED;
+			break;
+		case XNVME_SPEC_ZND_STATE_FULL:
+			zbdz[idx].cond = ZBD_ZONE_COND_FULL;
+			break;
+
+		case XNVME_SPEC_ZND_STATE_RONLY:
+		case XNVME_SPEC_ZND_STATE_OFFLINE:
+		default:
+			zbdz[idx].cond = ZBD_ZONE_COND_OFFLINE;
+			break;
+		}
+	}
+
+exit:
+	xnvme_buf_virt_free(rprt);
+
+	xnvme_dev_close(dev);
+
+	err_lock = pthread_mutex_unlock(&g_serialize);
+	if (err_lock)
+		log_err("ioeng->report_zones(): pthread_mutex_unlock(), err: %d\n", err_lock);
+
+	dprint(FD_ZBD, "err: %d, nr_zones: %d\n", err, (int)nr_zones);
+
+	return err ? err : (int)limit;
+}
+
+/**
+ * NOTE: This function may get called before I/O engine initialization, that is,
+ * before ``_dev_open`` has been called and file-wrapping is setup. In such
+ * case it has to do ``_dev_open`` itself, and shut it down again once it is
+ * done resetting write pointer of zones.
+ */
+static int xnvme_fioe_reset_wp(struct thread_data *td, struct fio_file *f, uint64_t offset,
+			       uint64_t length)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_fwrap *fwrap = NULL;
+	struct xnvme_dev *dev = NULL;
+	const struct xnvme_geo *geo = NULL;
+	uint64_t first, last;
+	uint32_t ssw;
+	uint32_t nsid;
+	int err = 0, err_lock;
+
+	if (td->io_ops_data) {
+		xd = td->io_ops_data;
+		fwrap = &xd->files[f->fileno];
+
+		assert(fwrap->dev);
+		assert(fwrap->geo);
+
+		dev = fwrap->dev;
+		geo = fwrap->geo;
+		ssw = fwrap->ssw;
+	} else {
+		err = pthread_mutex_lock(&g_serialize);
+		if (err) {
+			log_err("ioeng->reset_wp(): pthread_mutex_lock(), err(%d)\n", err);
+			return -err;
+		}
+
+		dev = xnvme_dev_open(f->file_name, &opts);
+		if (!dev) {
+			log_err("ioeng->reset_wp(): xnvme_dev_open(%s) failed, errno(%d)\n",
+				f->file_name, errno);
+			goto exit;
+		}
+		geo = xnvme_dev_get_geo(dev);
+		ssw = xnvme_dev_get_ssw(dev);
+	}
+
+	nsid = xnvme_dev_get_nsid(dev);
+
+	first = ((offset >> ssw) / geo->nsect) * geo->nsect;
+	last = (((offset + length) >> ssw) / geo->nsect) * geo->nsect;
+	dprint(FD_ZBD, "first: 0x%lx, last: 0x%lx\n", first, last);
+
+	for (uint64_t zslba = first; zslba < last; zslba += geo->nsect) {
+		struct xnvme_cmd_ctx ctx = xnvme_cmd_ctx_from_dev(dev);
+
+		if (zslba >= (geo->nsect * geo->nzone)) {
+			log_err("ioeng->reset_wp(): out-of-bounds\n");
+			err = 0;
+			break;
+		}
+
+		err = xnvme_znd_mgmt_send(&ctx, nsid, zslba, false,
+					  XNVME_SPEC_ZND_CMD_MGMT_SEND_RESET, 0x0, NULL);
+		if (err || xnvme_cmd_ctx_cpl_status(&ctx)) {
+			err = err ? err : -EIO;
+			log_err("ioeng->reset_wp(): err(%d), sc(%d)", err, ctx.cpl.status.sc);
+			goto exit;
+		}
+	}
+
+exit:
+	if (!td->io_ops_data) {
+		xnvme_dev_close(dev);
+
+		err_lock = pthread_mutex_unlock(&g_serialize);
+		if (err_lock)
+			log_err("ioeng->reset_wp(): pthread_mutex_unlock(), err(%d)\n", err_lock);
+	}
+
+	return err;
+}
+
+static int xnvme_fioe_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_dev *dev;
+	int ret = 0, err;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	ret = pthread_mutex_lock(&g_serialize);
+	if (ret) {
+		log_err("ioeng->reset_wp(): pthread_mutex_lock(), err(%d)\n", ret);
+		return -ret;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("%s: failed retrieving device handle, errno: %d\n", f->file_name, errno);
+		ret = -errno;
+		goto exit;
+	}
+
+	f->real_file_size = xnvme_dev_get_geo(dev)->tbytes;
+	fio_file_set_size_known(f);
+	f->filetype = FIO_TYPE_BLOCK;
+
+exit:
+	xnvme_dev_close(dev);
+	err = pthread_mutex_unlock(&g_serialize);
+	if (err)
+		log_err("ioeng->reset_wp(): pthread_mutex_unlock(), err(%d)\n", err);
+
+	return ret;
+}
+
+FIO_STATIC struct ioengine_ops ioengine = {
+	.name = "xnvme",
+	.version = FIO_IOOPS_VERSION,
+	.options = options,
+	.option_struct_size = sizeof(struct xnvme_fioe_options),
+	.flags = FIO_DISKLESSIO | FIO_NODISKUTIL | FIO_NOEXTEND | FIO_MEMALIGN | FIO_RAWIO,
+
+	.cleanup = xnvme_fioe_cleanup,
+	.init = xnvme_fioe_init,
+
+	.iomem_free = xnvme_fioe_iomem_free,
+	.iomem_alloc = xnvme_fioe_iomem_alloc,
+
+	.io_u_free = xnvme_fioe_io_u_free,
+	.io_u_init = xnvme_fioe_io_u_init,
+
+	.event = xnvme_fioe_event,
+	.getevents = xnvme_fioe_getevents,
+	.queue = xnvme_fioe_queue,
+
+	.close_file = xnvme_fioe_close,
+	.open_file = xnvme_fioe_open,
+	.get_file_size = xnvme_fioe_get_file_size,
+
+	.invalidate = xnvme_fioe_invalidate,
+	.get_max_open_zones = xnvme_fioe_get_max_open_zones,
+	.get_zoned_model = xnvme_fioe_get_zoned_model,
+	.report_zones = xnvme_fioe_report_zones,
+	.reset_wp = xnvme_fioe_reset_wp,
+};
+
+static void fio_init fio_xnvme_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_xnvme_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/xnvme-compare.fio b/examples/xnvme-compare.fio
new file mode 100644
index 00000000..b89dfdf4
--- /dev/null
+++ b/examples/xnvme-compare.fio
@@ -0,0 +1,72 @@
+; Compare fio IO engines with a random-read workload using BS=4k at QD=1
+;
+; README
+;
+; This job-file is intended to be used as:
+;
+; # Use the built-in io_uring engine to get baseline numbers
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=io_uring \
+;   --sqthread_poll=1 \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and io_uring async. impl.
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --sqthread_poll=1 \
+;   --xnvme_async=io_uring \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and libaio async. impl.
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=libaio \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-compare.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="verify" FIO_IODEPTH=16 fio examples/xnvme-compare.fio \
+;   --section=override
+;
+[global]
+rw=randread
+size=12G
+iodepth=1
+bs=4K
+direct=1
+thread=1
+time_based=1
+runtime=7
+ramp_time=3
+norandommap=1
+
+; Avoid accidentally creating device files; e.g. "/dev/nvme0n1", "/dev/nullb0"
+allow_file_create=0
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/examples/xnvme-zoned.fio b/examples/xnvme-zoned.fio
new file mode 100644
index 00000000..1344f9a1
--- /dev/null
+++ b/examples/xnvme-zoned.fio
@@ -0,0 +1,87 @@
+; Running xNVMe/fio on a Zoned Device
+;
+; Writes 1GB at QD1 using 4K BS and verifies it.
+;
+; README
+;
+; This job-file is intended to be used as:
+;
+; # Use the built-in io_uring engine to get baseline numbers
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=io_uring \
+;   --sqthread_poll=1 \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and io_uring async. impl.
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --sqthread_poll=1 \
+;   --xnvme_async=io_uring \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with Linux backend and libaio async. impl.
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=libaio \
+;   --filename=/dev/nvme0n1
+;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-zoned.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_dev_nsid=1 \
+;   --filename=0000\\:01\\:00.0
+;
+; NOTE: The URI encoded in the filename above, the ":" must be escaped.
+;
+; On the command-line using two "\\":
+;
+; --filename=0000\\:01\\:00.0
+;
+; Within a fio-script using a single "\":
+;
+; filename=0000\:01\:00.0
+;
+; NOTE: If you want to override the default bs, iodepth, and workload, then
+; invoke it as:
+;
+; FIO_BS="512" FIO_RW="verify" FIO_IODEPTH=16 fio examples/xnvme-zoned.fio \
+;   --section=override
+;
+; To reset all zones on the device to EMPTY state aka. wipe the entire device.
+;
+; # zoned mgmt-reset /dev/nvme0n2 --slba 0x0 --all
+;
+[global]
+zonemode=zbd
+rw=write
+size=1G
+iodepth=1
+bs=4K
+direct=1
+thread=1
+ramp_time=1
+norandommap=1
+verify=crc32c
+; Avoid accidentally creating device files; e.g. "/dev/nvme0n1", "/dev/nullb0"
+allow_file_create=0
+;
+; NOTE: If fio complains about zone-size, then run:
+;
+; # zoned info /dev/nvme0n1
+;
+; The command will provide the values you need, then in the fio-script define:
+;
+; zonesize=nsect * nbytes
+;
+;zonesize=
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/fio.1 b/fio.1
index 609947dc..ded7bbfc 100644
--- a/fio.1
+++ b/fio.1
@@ -1965,6 +1965,12 @@ via kernel NFS.
 .TP
 .B exec
 Execute 3rd party tools. Could be used to perform monitoring during jobs runtime.
+.TP
+.B xnvme
+I/O engine using the xNVMe C API, for NVMe devices. The xnvme engine provides
+flexibility to access GNU/Linux Kernel NVMe driver via libaio, IOCTLs, io_uring,
+the SPDK NVMe driver, or your own custom NVMe driver. The xnvme engine includes
+engine specific options. (See \fIhttps://xnvme.io/\fR).
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2039,7 +2045,7 @@ release them when IO is done. If this option is set, the pages are pre-mapped
 before IO is started. This eliminates the need to map and release for each IO.
 This is more efficient, and reduces the IO latency as well.
 .TP
-.BI (io_uring)hipri
+.BI (io_uring,xnvme)hipri
 If this option is set, fio will attempt to use polled IO completions. Normal IO
 completions generate interrupts to signal the completion of IO, polled
 completions do not. Hence they are require active reaping by the application.
@@ -2052,7 +2058,7 @@ This avoids the overhead of managing file counts in the kernel, making the
 submission and completion part more lightweight. Required for the below
 sqthread_poll option.
 .TP
-.BI (io_uring)sqthread_poll
+.BI (io_uring,xnvme)sqthread_poll
 Normally fio will submit IO by issuing a system call to notify the kernel of
 available items in the SQ ring. If this option is set, the act of submitting IO
 will be done by a polling thread in the kernel. This frees up cycles for fio, at
@@ -2480,6 +2486,66 @@ Defines the time between the SIGTERM and SIGKILL signals. Default is 1 second.
 .TP
 .BI (exec)std_redirect\fR=\fbool
 If set, stdout and stderr streams are redirected to files named from the job name. Default is true.
+.TP
+.BI (xnvme)xnvme_async\fR=\fPstr
+Select the xnvme async command interface. This can take these values.
+.RS
+.RS
+.TP
+.B emu
+This is default and used to emulate asynchronous I/O
+.TP
+.BI thrpool
+Use thread pool for Asynchronous I/O
+.TP
+.BI io_uring
+Use Linux io_uring/liburing for Asynchronous I/O
+.TP
+.BI libaio
+Use Linux aio for Asynchronous I/O
+.TP
+.BI posix
+Use POSIX aio for Asynchronous I/O
+.TP
+.BI nil
+Use nil-io; For introspective perf. evaluation
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_sync\fR=\fPstr
+Select the xnvme synchronous command interface. This can take these values.
+.RS
+.RS
+.TP
+.B nvme
+This is default and uses Linux NVMe Driver ioctl() for synchronous I/O
+.TP
+.BI psync
+Use pread()/write() for synchronous I/O
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_admin\fR=\fPstr
+Select the xnvme admin command interface. This can take these values.
+.RS
+.RS
+.TP
+.B nvme
+This is default and uses Linux NVMe Driver ioctl() for admin commands
+.TP
+.BI block
+Use Linux Block Layer ioctl() and sysfs for admin commands
+.TP
+.BI file_as_ns
+Use file-stat as to construct NVMe idfy responses
+.RE
+.RE
+.TP
+.BI (xnvme)xnvme_dev_nsid\fR=\fPint
+xnvme namespace identifier, for userspace NVMe driver.
+.TP
+.BI (xnvme)xnvme_iovec
+If this option is set, xnvme will use vectored read/write commands.
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/optgroup.h b/optgroup.h
index 3ac8f62a..dc73c8f3 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -72,6 +72,7 @@ enum opt_category_group {
 	__FIO_OPT_G_DFS,
 	__FIO_OPT_G_NFS,
 	__FIO_OPT_G_WINDOWSAIO,
+	__FIO_OPT_G_XNVME,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -118,6 +119,7 @@ enum opt_category_group {
 	FIO_OPT_G_LIBCUFILE	= (1ULL << __FIO_OPT_G_LIBCUFILE),
 	FIO_OPT_G_DFS		= (1ULL << __FIO_OPT_G_DFS),
 	FIO_OPT_G_WINDOWSAIO	= (1ULL << __FIO_OPT_G_WINDOWSAIO),
+	FIO_OPT_G_XNVME         = (1ULL << __FIO_OPT_G_XNVME),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
diff --git a/options.c b/options.c
index 3b83573b..2b183c60 100644
--- a/options.c
+++ b/options.c
@@ -2144,6 +2144,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  { .ival = "nfs",
 			    .help = "NFS IO engine",
 			  },
+#endif
+#ifdef CONFIG_LIBXNVME
+			  { .ival = "xnvme",
+			    .help = "XNVME IO engine",
+			  },
 #endif
 		},
 	},
