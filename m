Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27715C433F5
	for <fio@archiver.kernel.org>; Wed, 11 May 2022 19:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiEKTMR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 11 May 2022 15:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242789AbiEKTMP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 11 May 2022 15:12:15 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEE97357F
        for <fio@vger.kernel.org>; Wed, 11 May 2022 12:12:12 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220511191209epoutp03588c4fb7350bd0a486f3c21e5df80ddc~uIsHzMttB1642816428epoutp03e
        for <fio@vger.kernel.org>; Wed, 11 May 2022 19:12:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220511191209epoutp03588c4fb7350bd0a486f3c21e5df80ddc~uIsHzMttB1642816428epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652296329;
        bh=3o6d6qWQnsEbF/P2VCoGGWhFxDGOMrTNEB/lzCLAZPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apoZNQdE+ctVTU8rBAveTV6TPCX945svNoTAiP0K3/ekDtieKpHctYlDMB8v2VkwT
         i1tsifVpWFHQQC+aBqK2eulvLwz2t9rD4o0uXDoA1HGzzMMpZVk8pX5lWAnQKRPXMs
         x1cXHl3aTSWo64WDCLRJ+L0YfZoVfzXFJc14VVrQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220511191209epcas5p40db6b166325cf3909d1068913f6bee10~uIsHcbI111798917989epcas5p4a;
        Wed, 11 May 2022 19:12:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Kz4KL5H1Sz4x9Pp; Wed, 11 May
        2022 19:12:06 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.DF.10063.68A0C726; Thu, 12 May 2022 04:12:06 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20220511163555epcas5p11802150a9855558ab5823252f86dead3~uGjtfLvnQ2074820748epcas5p18;
        Wed, 11 May 2022 16:35:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220511163555epsmtrp232386b632e6d698583a85be4a97193d0~uGjtedmew0136601366epsmtrp27;
        Wed, 11 May 2022 16:35:55 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-41-627c0a86203f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E9.E0.08924.BE5EB726; Thu, 12 May 2022 01:35:55 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220511163554epsmtip29390bcb1fb9c53bd4c12ee894dc96489~uGjsiEoIK2386923869epsmtip2b;
        Wed, 11 May 2022 16:35:54 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com,
        simon.lund@samsung.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/3] engines/xnvme: add xnvme engine
Date:   Wed, 11 May 2022 22:00:17 +0530
Message-Id: <20220511163019.5608-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220511163019.5608-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsWy7bCmpm4bV02SwYIjahZrrvxmt1h9t5/N
        4uOsF8wWCzcuY7K42z2D3YHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzrjfPoGt4M5Xxorz8zYzNzD+O8bY
        xcjJISFgIvH1cyeQzcUhJLCbUeLu0pVQzidGiQf3mpghnM+MErParrLCtFw83wCV2MUo8evT
        SiYIp5VJ4t/f+WCD2QS0JV69vcEMYosICEvs72hlAbGZBQoltt7pB6sRBprUf/sXO4jNIqAq
        sfbzVrB6XgFrib3tm5ghtslLrN5wAMzmFLCR6G1eCbZZQmAVu8Tnc7OBHA4gx0Vi5iuoh4Ql
        Xh3fwg5hS0l8freXDcLOlmh89BfKLpHYeWs71Hx7iYt7/jKBjGEW0JRYv0sfIiwrMfXUOiaI
        k/kken8/YYKI80rsmAdjq0r8vXebBcKWlrj57iqU7SHx/OIqaJj0M0oc/L6NcQKj3CyEFQsY
        GVcxSqYWFOempxabFhjmpZbD4y05P3cTIzhdaXnuYLz74IPeIUYmDsZDjBIczEoivPv7KpKE
        eFMSK6tSi/Lji0pzUosPMZoCw28is5Rocj4wYeaVxBuaWBqYmJmZmVgamxkqifOeTt+QKCSQ
        nliSmp2aWpBaBNPHxMEp1cDE/NPdWNps4iHFy8/izAUmss/kVIzIFXl6SkCyYet/xyePWu6v
        1Lr32f7DhFlW1xkdpxfeza8pTtkesfHQkmulv6808G72Cl955QFzgT/Ljfvv3vya+tCEe8lB
        gZXl227p3U5Yf9Ghbk1Pnx+rg11Zv3x6kHZkTtlDhf9bNd79VvjHpMT1Yo+ag3PgK/M3756v
        5tqWqfzg1z9rA925199NtJ+mO/3Wm3a+ksQXra/4LyZMPlu1cFKxQ6qvkE/L+/V7/T7JTlob
        IsMT3Lph06N9sybuby8+OOfnfWXGf4cVA6ferjxUUDNBMPeZf7nxd9EZN9xu94cVBiqHb+LN
        PHctqGV+3aZbi8L95Gb39c4xUmIpzkg01GIuKk4EANYqKPDgAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmluLIzCtJLcpLzFFi42LZdlhJXvf10+okg0XTpS3WXPnNbrH6bj+b
        xcdZL5gtFm5cxmRxt3sGuwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVcb99AlvB
        na+MFefnbWZuYPx3jLGLkZNDQsBE4uL5BuYuRi4OIYEdjBLr+yYCORxACWmJhesTIWqEJVb+
        e84OUdPMJPHy9yU2kASbgLbEq7c3mEFsEaCi/R2tLCA2s0CpRNPHVWA1wkAL+m//YgexWQRU
        JdZ+3gpWzytgLbG3fRMzxAJ5idUbDoDZnAI2Er3NK8FsIaCa078WsU9g5FvAyLCKUTK1oDg3
        PbfYsMAoL7Vcrzgxt7g0L10vOT93EyM4nLS0djDuWfVB7xAjEwfjIUYJDmYlEd79fRVJQrwp
        iZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCZM5RuLwlWyHDj
        nGbjf3/pKR7uHzq2fI2LIx9qzrjrJ8kXGmnw9crXlYu7pK3XZk3L6o+bpZ04+2BUaqbWWk6n
        rykaT30ZGo4qzy7bu6+SW3yO5EXH+/1xW+RSt5d/XWy2PDB5i/QdftONu0W5H3UdPpn0cVcG
        y/Z3FWcsne6EqU37k3VifYP5/6lNC7wm7TCXLw46xtCTf+NPX+JZt1nacq9mL7v0eMrmqCWX
        29gfTZ2Wy873UrO5arp+8d6nK1uOH7dlEzh2sH/FrE+3vlvHltavfJrLopoakWH50fvuoTei
        lw64XM8SaxY3mfr61sQv62YrLrZc3Bh2UP3tt8Wbf6vzaJjIRj7beyzDKdJBiaU4I9FQi7mo
        OBEAkXSc8pYCAAA=
X-CMS-MailID: 20220511163555epcas5p11802150a9855558ab5823252f86dead3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220511163555epcas5p11802150a9855558ab5823252f86dead3
References: <20220511163019.5608-1-ankit.kumar@samsung.com>
        <CGME20220511163555epcas5p11802150a9855558ab5823252f86dead3@epcas5p1.samsung.com>
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
 Makefile        |   7 +-
 configure       |  22 ++
 engines/xnvme.c | 981 ++++++++++++++++++++++++++++++++++++++++++++++++
 optgroup.h      |   2 +
 options.c       |   5 +
 5 files changed, 1016 insertions(+), 1 deletion(-)
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

