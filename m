Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B765C433F5
	for <fio@archiver.kernel.org>; Thu,  5 May 2022 13:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiEEOBD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 5 May 2022 10:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiEEOBC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 5 May 2022 10:01:02 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72A826555
        for <fio@vger.kernel.org>; Thu,  5 May 2022 06:57:20 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220505135717epoutp039086e4241fb8505fde7c8a0352721a83~sOhftocHr1330213302epoutp03G
        for <fio@vger.kernel.org>; Thu,  5 May 2022 13:57:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220505135717epoutp039086e4241fb8505fde7c8a0352721a83~sOhftocHr1330213302epoutp03G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1651759037;
        bh=LGvOGVzIw99IQaVaEe7aW5kpp1VB9KovtH70comq+OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMYuAk1ZBE5pxeGvq/9zX17BsWME3e7E8DOSD3l5l5pPq8JBzmf2B0iXTyX6MrWaj
         c57nph8PdJMO5l90MDronQmNgPu31OjeM40TA5+ULX83kqPK01VaDTT9lgYc6N11TJ
         Zv3qrwoJbfmcCkP3BoLlMox3Yg/ViCh7onKz2mFA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220505135717epcas5p4f17a120b43e7e2f901b04c9944992d93~sOhfXfx9_3066630666epcas5p4u;
        Thu,  5 May 2022 13:57:17 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4KvFcp5TVDz4x9Pr; Thu,  5 May
        2022 13:57:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6B.2D.09827.AB7D3726; Thu,  5 May 2022 22:57:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1~sOF337obD2690526905epcas5p4K;
        Thu,  5 May 2022 13:25:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220505132539epsmtrp2edfe30905594e0e4d740b1c8d2f68a99~sOF33LyzA1067810678epsmtrp2I;
        Thu,  5 May 2022 13:25:39 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-28-6273d7bafa3f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.A3.08924.350D3726; Thu,  5 May 2022 22:25:39 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220505132538epsmtip28b8212a2f4097a080f6a7eafcdace59e~sOF27DyIC0590605906epsmtip2J;
        Thu,  5 May 2022 13:25:38 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/3] engines/xnvme: add xnvme engine
Date:   Thu,  5 May 2022 18:49:33 +0530
Message-Id: <20220505131935.32076-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220505131935.32076-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsWy7bCmhu6u68VJBht+qVmsufKb3WL13X42
        i4+zXjBbLNy4jMnibvcMdgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2NK2zyWgnNfGCuubfzK1MC44Shj
        FyMnh4SAicSL3RtYQGwhgd2MEhM3SHcxcgHZnxglLtzuY4ZwPjNKvF9wmgmm49rfZewQHbsY
        JVavSocoamWS+NuznxkkwSagLfHq7Q0wW0RAWGJ/RyvYCmaBQomtd/rBVgsDDeq//QtoEAcH
        i4CqxI4ZYCW8AjYS2yZ9Y4bYJS+xesMBMJtTwFbiybGFLCC7JARWsUusbz7HBtIrIeAi0bQ2
        CKJeWOLV8S3sELaUxOd3e9kg7GyJxkd/oewSiZ23tkPNt5e4uOcvE8gYZgFNifW79CHCshJT
        T61jgriYT6L39xOo13kldsyDsVUl/t67zQJhS0vcfHcVyvaQePlwIiskSCYwSty994F5AqPc
        LIQVCxgZVzFKphYU56anFpsWGOWllsMjLTk/dxMjOFFpee1gfPjgg94hRiYOxkOMEhzMSiK8
        zksLkoR4UxIrq1KL8uOLSnNSiw8xmgKDbyKzlGhyPjBV5pXEG5pYGpiYmZmZWBqbGSqJ855O
        35AoJJCeWJKanZpakFoE08fEwSnVwBRqEttynk2kmCMr9Ny+GT1X7/eZPMkVPPG4+cOhRJN/
        cyI91UxEGdxPrXff3MDfpL/D0E63a9sD3+W7eRLU157vir6gbaGrU3RE56rgJQHOpUcygie0
        P7qsw+9WwnVM6Jz64/kRiy87bmP+6yF49dTUv5ZWRw42LFUPin/6f6/KTZPn74XLvczXTA++
        13497mvVB13/vytjI969WBCiVy3Z+bt7vw4jA5fI3cBVjqJ/b+ZNZo3vvK/zz59betvbGX81
        1ywM1rw9KevbhNBlzHVmimvbBBbGd98NmHlXzk/neWFw8Kdt0+KbnSZWyRwMcpNQmxjCLPQu
        jr0ivO5h7FX7r7UXlDYcT2QQZRf9p8RSnJFoqMVcVJwIAKAjokLdAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXjf4QnGSwZ+DUhZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKmNI2j6Xg
        3BfGimsbvzI1MG44ytjFyMkhIWAice3vMvYuRg4OIYEdjBKPU0BMCQFpiYXrEyEqhCVW/nsO
        VMEFVNHMJPFj6Xo2kASbgLbEq7c3mEFsEaCi/R2tLCA2s0CpRNPHVWA1wkDj+2//AhvPIqAq
        sWMGWAmvgI3EtknfmCHmy0us3nAAzOYUsJV4cmwhWI0QUM3ZnhPMExj5FjAyrGKUTC0ozk3P
        LTYsMMpLLdcrTswtLs1L10vOz93ECA4kLa0djHtWfdA7xMjEwXiIUYKDWUmE13lpQZIQb0pi
        ZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTKX164O0y+4uPyau
        Y2r/J/6YMv/6v5JCi3Wmcvbmin1Zf/b20g9CPwOmzLn3LKct+3n3sVW8O7WCbr7q0JsZMP9Y
        a2vpts0/Prj39qcwTA5NO8kYcGL1kg05ItXxS2bL3t5vVXgt3X2jqW73TpXGSiuVyfccFstq
        zog++qKER+ygxqXN5if9tRRvCcwpXZ+jVHNmmVUp++yk2B6FM8dmnr163/NZV8Tan5O95Bp6
        5Xa/aHM6uZu3nttX9GXEbsOF9nFvDY+mJj4KmmTd/Vj0RJf3o/nLohxPTrzRf1PochXnt0/7
        fbWm39s1/92/hTUR8lOelvnHbn3HeOf2eUenSf9jzs06sPhl2Of4968jJxUrsRRnJBpqMRcV
        JwIA+s6hZ5MCAAA=
X-CMS-MailID: 20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1
References: <20220505131935.32076-1-ankit.kumar@samsung.com>
        <CGME20220505132539epcas5p41f26baadd8e697ae00f637a29f7544a1@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch introduces a new fio engine to work with xNVMe >= 0.2.0.
xNVMe provides a user space library (libxnvme) to work with NVMe
devices. The NVMe driver being used by libxnvme is re-targetable and
can be any one of the GNU/Linux Kernel NVMe driver via libaio,
IOCTLs, io_uring, the SPDK NVMe driver, or your own custom NVMe driver.

For more info visit https://xnvme.io
https://github.com/OpenMPDK/xNVMe

Co-Authored-By: Ankit Kumar <ankit.kumar@samsung.com>
Co-Authored-By: Simon A. F. Lund <simon.lund@samsung.com>
Co-Authored-By: Mads Ynddal <m.ynddal@samsung.com>
Co-Authored-By: Michael Bang <mi.bang@samsung.com>
Co-Authored-By: Karl Bonde Torp <k.torp@samsung.com>
Co-Authored-By: Gurmeet Singh <gur.singh@samsung.com>
Co-Authored-By: Pierre Labat <plabat@micron.com>
---
 Makefile        |    7 +-
 configure       |   22 ++
 engines/xnvme.c | 1000 +++++++++++++++++++++++++++++++++++++++++++++++
 optgroup.h      |    2 +
 options.c       |    5 +
 5 files changed, 1035 insertions(+), 1 deletion(-)
 create mode 100644 engines/xnvme.c

diff --git a/Makefile b/Makefile
index e670c1f2..8495e727 100644
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
index 00000000..ef8a5851
--- /dev/null
+++ b/engines/xnvme.c
@@ -0,0 +1,1000 @@
+/*
+ * fio xNVMe IO Engine
+ *
+ * IO engine using the xNVMe C API.
+ *
+ * See: http://xnvme.io/
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
+		.type = FIO_OPT_INT,
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
+	struct xnvme_fioe_data *xd = io_u->engine_data;
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
+#ifdef XNVME_DEBUG_ENABLED
+static void _fio_file_pr(struct fio_file *f)
+{
+	if (!f) {
+		log_info("fio_file: ~\n");
+		return;
+	}
+
+	log_info("fio_file: { ");
+	log_info("file_name: '%s', ", f->file_name);
+	log_info("fileno: %d, ", f->fileno);
+	log_info("io_size: %zu, ", f->io_size);
+	log_info("real_file_size: %zu, ", f->real_file_size);
+	log_info("file_offset: %zu", f->file_offset);
+	log_info("}\n");
+}
+#endif
+
+static int _dev_close(struct thread_data *td, struct xnvme_fioe_fwrap *fwrap)
+{
+	if (fwrap->dev)
+		xnvme_queue_term(fwrap->queue);
+
+	xnvme_dev_close(fwrap->dev);
+
+	memset(fwrap, 0, sizeof(*fwrap));
+
+	return 0;
+}
+
+static void xnvme_fioe_cleanup(struct thread_data *td)
+{
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	int err;
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err)
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", err);
+		/* NOTE: not returning here */
+
+	for (uint64_t i = 0; i < xd->nallocated; ++i) {
+		int err;
+
+		err = _dev_close(td, &xd->files[i]);
+		if (err)
+			XNVME_DEBUG("xnvme_fioe: cleanup(): Unexpected error");
+	}
+	err = pthread_mutex_unlock(&g_serialize);
+	if (err)
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err);
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
+		log_err("xnvme_fioe: _dev_open(); invalid assumption\n");
+		return 1;
+	}
+
+	fwrap = &xd->files[f->fileno];
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", err);
+		return -err;
+	}
+
+	fwrap->dev = xnvme_dev_open(f->file_name, &opts);
+	if (!fwrap->dev) {
+		log_err("xnvme_fioe: init(): {f->file_name: '%s', err: '%s'}\n", f->file_name,
+			strerror(errno));
+		goto failure;
+	}
+	fwrap->geo = xnvme_dev_get_geo(fwrap->dev);
+
+	if (xnvme_queue_init(fwrap->dev, td->o.iodepth, flags, &(fwrap->queue))) {
+		log_err("xnvme_fioe: init(): failed xnvme_queue_init()\n");
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
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err);
+
+	return 0;
+
+failure:
+	xnvme_queue_term(fwrap->queue);
+	xnvme_dev_close(fwrap->dev);
+
+	err = pthread_mutex_unlock(&g_serialize);
+	if (err)
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err);
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
+		log_err("xnvme_fioe: init(): --thread=1 is required\n");
+		return 1;
+	}
+
+	/* Allocate xd and iocq */
+	xd = calloc(1, sizeof(*xd) + sizeof(*xd->files) * td->o.nr_files);
+	if (!xd) {
+		log_err("xnvme_fioe: init(): !calloc()\n");
+		return 1;
+	}
+
+	xd->iocq = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!xd->iocq) {
+		log_err("xnvme_fioe: init(): !calloc()\n");
+		return 1;
+	}
+
+	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
+	if (!xd->iovec) {
+		log_err("xnvme_fioe: init(): !calloc(xd->iovec)\n");
+		return 1;
+	}
+
+	xd->prev = -1;
+	td->io_ops_data = xd;
+
+	for_each_file(td, f, i)
+	{
+		if (_dev_open(td, f)) {
+			log_err("xnvme_fioe: init(): _dev_open(%s)\n", f->file_name);
+			return 1;
+		}
+
+		++(xd->nallocated);
+	}
+
+	if (xd->nallocated != td->o.nr_files) {
+		log_err("xnvme_fioe: init(): nallocated != td->o.nr_files\n");
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
+		log_err("xnvme_fioe: failed iomem_alloc(); no dev-handle\n");
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
+		log_err("xnvme_fioe: failed iomem_free(); no dev-handle\n");
+		return;
+	}
+
+	xnvme_buf_free(fwrap->dev, td->orig_buffer);
+}
+
+static int xnvme_fioe_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	io_u->engine_data = td->io_ops_data;
+
+	return 0;
+}
+
+static void xnvme_fioe_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	io_u->engine_data = NULL;
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
+	if (t)
+		XNVME_DEBUG("INFO: ignoring timespec");
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
+					XNVME_DEBUG("Oh my");
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
+		log_err("xnvme_fioe: queue(): ENOSYS: %u\n", io_u->ddir);
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
+		log_err("xnvme_fioe: queue(): err: '%d'\n", err);
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
+	XNVME_DEBUG("xnvme_fioe_close: closing -- nopen: %ld", xd->nopen);
+	XNVME_DEBUG_FCALL(_fio_file_pr(f);)
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
+	XNVME_DEBUG("xnvme_fioe_open: opening -- nopen: %ld", xd->nopen);
+	XNVME_DEBUG_FCALL(_fio_file_pr(f);)
+
+	if (f->fileno > (int)xd->nallocated) {
+		XNVME_DEBUG("f->fileno > xd->nallocated; invalid assumption");
+		return 1;
+	}
+	if (xd->files[f->fileno].fio_file != f) {
+		XNVME_DEBUG("well... that is off..");
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
+		XNVME_DEBUG("INFO: ignoring filetype: %d", f->filetype);
+		return 0;
+	}
+	err_lock = pthread_mutex_lock(&g_serialize);
+	if (err_lock) {
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err_lock: %d", err_lock);
+		return -err_lock;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		XNVME_DEBUG("FAILED: retrieving device handle");
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
+		XNVME_DEBUG("FAILED: xnvme_dev_get_ns_css(), errno: %d", errno);
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
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err_lock: %d", err_lock);
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
+		XNVME_DEBUG("INFO: ignoring filetype: %d", f->filetype);
+		return -EINVAL;
+	}
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		XNVME_DEBUG("FAILED: retrieving device handle");
+		err = -errno;
+		goto exit;
+	}
+
+	switch (xnvme_dev_get_geo(dev)->type) {
+	case XNVME_GEO_UNKNOWN:
+		XNVME_DEBUG("INFO: got 'unknown', assigning ZBD_NONE");
+		*model = ZBD_NONE;
+		break;
+
+	case XNVME_GEO_CONVENTIONAL:
+		XNVME_DEBUG("INFO: got 'conventional', assigning ZBD_NONE");
+		*model = ZBD_NONE;
+		break;
+
+	case XNVME_GEO_ZONED:
+		XNVME_DEBUG("INFO: got 'zoned', assigning ZBD_HOST_MANAGED");
+		*model = ZBD_HOST_MANAGED;
+		break;
+
+	default:
+		XNVME_DEBUG("FAILED: hit-default, assigning ZBD_NONE");
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
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err_lock);
+
+	XNVME_DEBUG("INFO: so good to far...");
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
+	XNVME_DEBUG("report_zones(): '%s', offset: %zu, nr_zones: %u", f->file_name, offset,
+		    nr_zones);
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		XNVME_DEBUG("FAILED: xnvme_dev_open(), errno: %d", errno);
+		goto exit;
+	}
+
+	geo = xnvme_dev_get_geo(dev);
+	ssw = xnvme_dev_get_ssw(dev);
+	lbafe = xnvme_znd_dev_get_lbafe(dev);
+
+	limit = nr_zones > geo->nzone ? geo->nzone : nr_zones;
+
+	XNVME_DEBUG("INFO: limit: %u", limit);
+
+	slba = ((offset >> ssw) / geo->nsect) * geo->nsect;
+
+	rprt = xnvme_znd_report_from_dev(dev, slba, limit, 0);
+	if (!rprt) {
+		XNVME_DEBUG("FAILED: xnvme_znd_report_from_dev(), errno: %d", errno);
+		err = -errno;
+		goto exit;
+	}
+	if (rprt->nentries != limit) {
+		XNVME_DEBUG("FAILED: nentries != nr_zones");
+		err = 1;
+		goto exit;
+	}
+	if (offset > geo->tbytes) {
+		XNVME_DEBUG("INFO: out-of-bounds");
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
+			log_err("%s: invalid type for zone at offset%zu.\n", f->file_name,
+				zbdz[idx].start);
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
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err_lock: %d", err_lock);
+
+	XNVME_DEBUG("err: %d, nr_zones: %d", err, (int)nr_zones);
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
+			XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", err);
+			return -err;
+		}
+
+		dev = xnvme_dev_open(f->file_name, &opts);
+		if (!dev) {
+			XNVME_DEBUG("FAILED: xnvme_dev_open(), errno: %d", errno);
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
+	XNVME_DEBUG("INFO: first: 0x%lx, last: 0x%lx", first, last);
+
+	for (uint64_t zslba = first; zslba < last; zslba += geo->nsect) {
+		struct xnvme_cmd_ctx ctx = xnvme_cmd_ctx_from_dev(dev);
+
+		if (zslba >= (geo->nsect * geo->nzone)) {
+			XNVME_DEBUG("INFO: out-of-bounds");
+			err = 0;
+			break;
+		}
+
+		err = xnvme_znd_mgmt_send(&ctx, nsid, zslba, false,
+					  XNVME_SPEC_ZND_CMD_MGMT_SEND_RESET, 0x0, NULL);
+		if (err || xnvme_cmd_ctx_cpl_status(&ctx)) {
+			err = err ? err : -EIO;
+			XNVME_DEBUG("FAILED: err: %d, sc=%d", err, ctx.cpl.status.sc);
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
+			XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err_lock);
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
+		XNVME_DEBUG("FAILED: pthread_mutex_lock(), err: %d", ret);
+		return -ret;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		XNVME_DEBUG("FAILED: xnvme_dev_open(), errno: %d", errno);
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
+		XNVME_DEBUG("FAILED: pthread_mutex_unlock(), err: %d", err);
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
-- 
2.17.1

