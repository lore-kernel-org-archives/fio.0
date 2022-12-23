Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C32DC4332F
	for <fio@archiver.kernel.org>; Fri, 23 Dec 2022 13:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbiLWNAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 23 Dec 2022 08:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 23 Dec 2022 08:00:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CC322B26
        for <fio@vger.kernel.org>; Fri, 23 Dec 2022 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=iFSjgeG4J5B9a99nODC9ZSdF7oQIe/bpYEWW9ksMgGE=; b=b9CDykrCEaCM94BpJm384EPzFr
        R/Jina+rND8rGTD2FXhXtaYKaZX+i3bI+dP8rvJOQ5yS32zk/+MtucrPAN9463cmNOWNNpOjVricw
        LAyZDdwCRJLTwB+a3gF0nHPFzjNN7U6wfwB72n+/xvPhwx/HubT6cczd3aPk2SNtSnfstw/PoXPgc
        2AFzH4s2ttpC7X7HdE3bZBkBqjrF0XgcDKETbQAPcIrAo4wnGCw0eqNQjHbq3SYa+dHgvmDZhb1QJ
        ocn1Leh3s1MiQWcJwxC6gFaE1qLBgkxNJiAeDhQOykOqSG0CHGVI46KCJFtcHUv38G7G8FAmmf5wg
        TkFLwJAA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1p8hec-00EAj9-1O
        for fio@vger.kernel.org;
        Fri, 23 Dec 2022 13:00:03 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 055AB1BC013F; Fri, 23 Dec 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221223130002.055AB1BC013F@kernel.dk>
Date:   Fri, 23 Dec 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 77c758db876d93022e8f2bb4fd4c1acbbf7e76ac:

  t/run-fio-tests: relax acceptance criteria for t0008 (2022-12-16 19:35:07 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c945074c0336fb1720acead38e578d4dd7f29921:

  engines/xnvme: add support for picking mem backend (2022-12-22 08:50:03 -0500)

----------------------------------------------------------------
Ankit Kumar (4):
      engines/xnvme: fixes for xnvme ioengine
      engines/xnvme: user space vfio based backend
      engines/xnvme: add subnqn to fio-options
      engines/xnvme: add support for picking mem backend

 HOWTO.rst       | 27 ++++++++++++++++++++++++++-
 engines/xnvme.c | 44 ++++++++++++++++++++++++++++++++++++++------
 fio.1           | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 95 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 97fe5350..0a48a453 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2845,6 +2845,9 @@ with the caveat that when used on the command line, they must come after the
 	**posix**
 		Use the posix asynchronous I/O interface to perform one or
 		more I/O operations asynchronously.
+	**vfio**
+		Use the user-space VFIO-based backend, implemented using
+		libvfn instead of SPDK.
 	**nil**
 		Do not transfer any data; just pretend to. This is mainly used
 		for introspective performance evaluation.
@@ -2875,7 +2878,29 @@ with the caveat that when used on the command line, they must come after the
 
 .. option:: xnvme_dev_nsid=int : [xnvme]
 
-	xnvme namespace identifier for userspace NVMe driver, such as SPDK.
+	xnvme namespace identifier for userspace NVMe driver, SPDK or vfio.
+
+.. option:: xnvme_dev_subnqn=str : [xnvme]
+
+	Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a
+	fabrics target with multiple systems.
+
+.. option:: xnvme_mem=str : [xnvme]
+
+	Select the xnvme memory backend. This can take these values.
+
+	**posix**
+		This is the default posix memory backend for linux NVMe driver.
+	**hugepage**
+		Use hugepages, instead of existing posix memory backend. The
+		memory backend uses hugetlbfs. This require users to allocate
+		hugepages, mount hugetlbfs and set an enviornment variable for
+		XNVME_HUGETLB_PATH.
+	**spdk**
+		Uses SPDK's memory allocator.
+	**vfio**
+		Uses libvfn's memory allocator. This also specifies the use
+		of libvfn backend instead of SPDK.
 
 .. option:: xnvme_iovec=int : [xnvme]
 
diff --git a/engines/xnvme.c b/engines/xnvme.c
index d8647481..bb92a121 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -75,9 +75,11 @@ struct xnvme_fioe_options {
 	unsigned int xnvme_dev_nsid;
 	unsigned int xnvme_iovec;
 	char *xnvme_be;
+	char *xnvme_mem;
 	char *xnvme_async;
 	char *xnvme_sync;
 	char *xnvme_admin;
+	char *xnvme_dev_subnqn;
 };
 
 static struct fio_option options[] = {
@@ -108,12 +110,22 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
+	{
+		.name = "xnvme_mem",
+		.lname = "xNVMe Memory Backend",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_mem),
+		.help = "Select xNVMe memory backend",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
 	{
 		.name = "xnvme_async",
 		.lname = "xNVMe Asynchronous command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_async),
-		.help = "Select xNVMe async. interface: [emu,thrpool,io_uring,libaio,posix,nil]",
+		.help = "Select xNVMe async. interface: "
+			"[emu,thrpool,io_uring,io_uring_cmd,libaio,posix,vfio,nil]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
@@ -122,7 +134,7 @@ static struct fio_option options[] = {
 		.lname = "xNVMe Synchronous. command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_sync),
-		.help = "Select xNVMe sync. interface: [nvme,psync]",
+		.help = "Select xNVMe sync. interface: [nvme,psync,block]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
@@ -131,7 +143,7 @@ static struct fio_option options[] = {
 		.lname = "xNVMe Admin command-interface",
 		.type = FIO_OPT_STR_STORE,
 		.off1 = offsetof(struct xnvme_fioe_options, xnvme_admin),
-		.help = "Select xNVMe admin. cmd-interface: [nvme,block,file_as_ns]",
+		.help = "Select xNVMe admin. cmd-interface: [nvme,block]",
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
@@ -144,6 +156,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
+	{
+		.name = "xnvme_dev_subnqn",
+		.lname = "Subsystem nqn for Fabrics",
+		.type = FIO_OPT_STR_STORE,
+		.off1 = offsetof(struct xnvme_fioe_options, xnvme_dev_subnqn),
+		.help = "Subsystem NQN for Fabrics",
+		.category = FIO_OPT_C_ENGINE,
+		.group = FIO_OPT_G_XNVME,
+	},
 	{
 		.name = "xnvme_iovec",
 		.lname = "Vectored IOs",
@@ -180,7 +201,9 @@ static struct xnvme_opts xnvme_opts_from_fioe(struct thread_data *td)
 	struct xnvme_opts opts = xnvme_opts_default();
 
 	opts.nsid = o->xnvme_dev_nsid;
+	opts.subnqn = o->xnvme_dev_subnqn;
 	opts.be = o->xnvme_be;
+	opts.mem = o->xnvme_mem;
 	opts.async = o->xnvme_async;
 	opts.sync = o->xnvme_sync;
 	opts.admin = o->xnvme_admin;
@@ -322,12 +345,15 @@ static int xnvme_fioe_init(struct thread_data *td)
 
 	xd->iocq = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!xd->iocq) {
-		log_err("ioeng->init(): !calloc(), err(%d)\n", errno);
+		free(xd);
+		log_err("ioeng->init(): !calloc(xd->iocq), err(%d)\n", errno);
 		return 1;
 	}
 
 	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
 	if (!xd->iovec) {
+		free(xd->iocq);
+		free(xd);
 		log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
 		return 1;
 	}
@@ -338,6 +364,10 @@ static int xnvme_fioe_init(struct thread_data *td)
 	for_each_file(td, f, i)
 	{
 		if (_dev_open(td, f)) {
+			/*
+			 * Note: We are not freeing xd, iocq and iovec. This
+			 * will be done as part of cleanup routine.
+			 */
 			log_err("ioeng->init(): failed; _dev_open(%s)\n", f->file_name);
 			return 1;
 		}
@@ -506,9 +536,11 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 
 	default:
 		log_err("ioeng->queue(): ENOSYS: %u\n", io_u->ddir);
-		err = -1;
+		xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+
+		io_u->error = ENOSYS;
 		assert(false);
-		break;
+		return FIO_Q_COMPLETED;
 	}
 
 	if (vectored_io) {
diff --git a/fio.1 b/fio.1
index 1074b52a..eb87533f 100644
--- a/fio.1
+++ b/fio.1
@@ -2584,6 +2584,10 @@ Use Linux aio for Asynchronous I/O
 Use the posix asynchronous I/O interface to perform one or more I/O operations
 asynchronously.
 .TP
+.BI vfio
+Use the user-space VFIO-based backend, implemented using libvfn instead of
+SPDK.
+.TP
 .BI nil
 Do not transfer any data; just pretend to. This is mainly used for
 introspective performance evaluation.
@@ -2621,7 +2625,33 @@ Use Linux Block Layer ioctl() and sysfs for admin commands.
 .RE
 .TP
 .BI (xnvme)xnvme_dev_nsid\fR=\fPint
-xnvme namespace identifier for userspace NVMe driver such as SPDK.
+xnvme namespace identifier for userspace NVMe driver SPDK or vfio.
+.TP
+.BI (xnvme)xnvme_dev_subnqn\fR=\fPstr
+Sets the subsystem NQN for fabrics. This is for xNVMe to utilize a fabrics
+target with multiple systems.
+.TP
+.BI (xnvme)xnvme_mem\fR=\fPstr
+Select the xnvme memory backend. This can take these values.
+.RS
+.RS
+.TP
+.B posix
+This is the default posix memory backend for linux NVMe driver.
+.TP
+.BI hugepage
+Use hugepages, instead of existing posix memory backend. The memory backend
+uses hugetlbfs. This require users to allocate hugepages, mount hugetlbfs and
+set an enviornment variable for XNVME_HUGETLB_PATH.
+.TP
+.BI spdk
+Uses SPDK's memory allocator.
+.TP
+.BI vfio
+Uses libvfn's memory allocator. This also specifies the use of libvfn backend
+instead of SPDK.
+.RE
+.RE
 .TP
 .BI (xnvme)xnvme_iovec
 If this option is set, xnvme will use vectored read/write commands.
