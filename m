Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3343252F7C
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 13:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707915614; cv=none; b=uAZeCY4280WoWJeBigjH3Rc033oOHpgD2Yp2X5dUZQZK7w9ivd0p6kQOnxVed0LhnP3dcqzyQXWEDQTSEjXDro/H32LPNBJwNEdlzC51asGh2/2VwR2qyxJIYdOWGuP3Y8r8IRV/FiSf/jtLG16khN+CSPUGOu1fBsNfE+pzM9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707915614; c=relaxed/simple;
	bh=0NaiAjazaKvYdVSFh1etYy/AGXpifu1fAntET3iGKGU=;
	h=Subject:From:To:Message-Id:Date; b=pORukT77TNme2JvNk2Mb0VOoeGz7zK8FNHQvM4Aj9YvLmCJMLIPBSV5nRMArA+XDV3cR/jrTLUGJXhLcSLJ2jGLbcS0Xz8Ub0rm5k4a1APeUEMcEsiNq/H55xQcMw/NbWC81GZBpQy+iEv2p6N995pvIsOBcOA2pR8L0xO30UB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZaPQ03EB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZaPQ03EB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=2VQt8TwCdTh/J5OKk1ELSzwqKCsSG7m/c0KOwF2bKIE=; b=ZaPQ03EBY1iXxFp1Fv0tB78u0V
	5y07QGLRjmyeJOh+Pr7iSFUjH/7DXiyPxT2VnnXtJBzrajPcAN05ysG+8Hhyk3zzec0WW4ZGxp1iD
	04QcCvAUBC2jd7slMfehjMpxSHW4k4kAOp17yL2oVVkoZVuGUZAHtZrLSoA/TzsEykL84KmtahHEE
	/1+cVfS2ro1SgctUKrXSww3GfQ9ocU1rPJxugJJjXCCj5b62oHSAHe4YUKk7aX+/WtgWVSof/jT8i
	VNc9SDKPnWUcXmsmcA4BZkPqZ/VaWlTq6CFsAEMiAG+Vnr6pazEPFH7L51wlv9lxbK/RFwuwoL8Pq
	qTqq2qTw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1raErt-0000000Gda8-27iL
	for fio@vger.kernel.org;
	Wed, 14 Feb 2024 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 3487B1BC0168; Wed, 14 Feb 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240214130001.3487B1BC0168@kernel.dk>
Date: Wed, 14 Feb 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 097af663e93f86106f32580bfa59e68fae007035:

  Merge branch 'vsock' of https://github.com/MPinna/fio (2024-02-12 11:56:33 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a99bd37f690ab246caa9b9d65adfa65a25967190:

  examples: add PI example with xnvme ioengine (2024-02-13 14:24:59 -0500)

----------------------------------------------------------------
Ankit Kumar (5):
      engines/xnvme: allocate iovecs only if vectored I/O is enabled
      engines/xnvme: add support for metadata
      engines:xnvme: add support for end to end data protection
      engines/xnvme: add checks for verify, block size and metadata size
      examples: add PI example with xnvme ioengine

Vincent Fu (4):
      logging: record timestamp for each thread
      helper_thread: do not send A_EXIT message when exit is called
      logging: expand runstates eligible for logging
      docs: explain duplicate logging timestamps

 HOWTO.rst             |  25 ++--
 configure             |   2 +-
 engines/xnvme.c       | 331 +++++++++++++++++++++++++++++++++++++++++++++++---
 examples/xnvme-pi.fio |  53 ++++++++
 fio.1                 |  24 ++--
 helper_thread.c       |   1 -
 stat.c                |  24 +++-
 7 files changed, 414 insertions(+), 46 deletions(-)
 create mode 100644 examples/xnvme-pi.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 53b03021..5bc1713c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2491,11 +2491,11 @@ with the caveat that when used on the command line, they must come after the
         want fio to use placement identifier only at indices 0, 2 and 5 specify
         ``fdp_pli=0,2,5``.
 
-.. option:: md_per_io_size=int : [io_uring_cmd]
+.. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
 	Size in bytes for separate metadata buffer per IO. Default: 0.
 
-.. option:: pi_act=int : [io_uring_cmd]
+.. option:: pi_act=int : [io_uring_cmd] [xnvme]
 
 	Action to take when nvme namespace is formatted with protection
 	information. If this is set to 1 and namespace is formatted with
@@ -2511,7 +2511,7 @@ with the caveat that when used on the command line, they must come after the
 	it will use the default slower generator.
 	(see: https://github.com/intel/isa-l)
 
-.. option:: pi_chk=str[,str][,str] : [io_uring_cmd]
+.. option:: pi_chk=str[,str][,str] : [io_uring_cmd] [xnvme]
 
 	Controls the protection information check. This can take one or more
 	of these values. Default: none.
@@ -2524,12 +2524,12 @@ with the caveat that when used on the command line, they must come after the
 	**APPTAG**
 		Enables protection information checking of application tag field.
 
-.. option:: apptag=int : [io_uring_cmd]
+.. option:: apptag=int : [io_uring_cmd] [xnvme]
 
 	Specifies logical block application tag value, if namespace is
 	formatted to use end to end protection information. Default: 0x1234.
 
-.. option:: apptag_mask=int : [io_uring_cmd]
+.. option:: apptag_mask=int : [io_uring_cmd] [xnvme]
 
 	Specifies logical block application tag mask value, if namespace is
 	formatted to use end to end protection information. Default: 0xffff.
@@ -4066,12 +4066,15 @@ Measurements and reporting
 
 .. option:: log_avg_msec=int
 
-	By default, fio will log an entry in the iops, latency, or bw log for every
-	I/O that completes. When writing to the disk log, that can quickly grow to a
-	very large size. Setting this option makes fio average the each log entry
-	over the specified period of time, reducing the resolution of the log.  See
-	:option:`log_window_value` as well. Defaults to 0, logging all entries.
-	Also see `Log File Formats`_.
+        By default, fio will log an entry in the iops, latency, or bw log for
+        every I/O that completes. When writing to the disk log, that can
+        quickly grow to a very large size. Setting this option directs fio to
+        instead record an average over the specified duration for each log
+        entry, reducing the resolution of the log. When the job completes, fio
+        will flush any accumulated latency log data, so the final log interval
+        may not match the value specified by this option and there may even be
+        duplicate timestamps. See :option:`log_window_value` as well. Defaults
+        to 0, logging entries for each I/O. Also see `Log File Formats`_.
 
 .. option:: log_hist_msec=int
 
diff --git a/configure b/configure
index becb193e..3eef022b 100755
--- a/configure
+++ b/configure
@@ -2697,7 +2697,7 @@ fi
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "no" ; then
-  if check_min_lib_version xnvme 0.7.0; then
+  if check_min_lib_version xnvme 0.7.4; then
     xnvme="yes"
     xnvme_cflags=$(pkg-config --cflags xnvme)
     xnvme_libs=$(pkg-config --libs xnvme)
diff --git a/engines/xnvme.c b/engines/xnvme.c
index 2a0b3520..a8137286 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -11,6 +11,7 @@
 #include <assert.h>
 #include <libxnvme.h>
 #include "fio.h"
+#include "verify.h"
 #include "zbd_types.h"
 #include "fdp.h"
 #include "optgroup.h"
@@ -30,8 +31,10 @@ struct xnvme_fioe_fwrap {
 
 	uint32_t ssw;
 	uint32_t lba_nbytes;
+	uint32_t md_nbytes;
+	uint32_t lba_pow2;
 
-	uint8_t _pad[24];
+	uint8_t _pad[16];
 };
 XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_fwrap) == 64, "Incorrect size")
 
@@ -58,19 +61,31 @@ struct xnvme_fioe_data {
 	uint64_t nallocated;
 
 	struct iovec *iovec;
-
-	uint8_t _pad[8];
+	struct iovec *md_iovec;
 
 	struct xnvme_fioe_fwrap files[];
 };
 XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_data) == 64, "Incorrect size")
 
+struct xnvme_fioe_request {
+	/* Context for NVMe PI */
+	struct xnvme_pi_ctx pi_ctx;
+
+	/* Separate metadata buffer pointer */
+	void *md_buf;
+};
+
 struct xnvme_fioe_options {
 	void *padding;
 	unsigned int hipri;
 	unsigned int sqpoll_thread;
 	unsigned int xnvme_dev_nsid;
 	unsigned int xnvme_iovec;
+	unsigned int md_per_io_size;
+	unsigned int pi_act;
+	unsigned int apptag;
+	unsigned int apptag_mask;
+	unsigned int prchk;
 	char *xnvme_be;
 	char *xnvme_mem;
 	char *xnvme_async;
@@ -79,6 +94,20 @@ struct xnvme_fioe_options {
 	char *xnvme_dev_subnqn;
 };
 
+static int str_pi_chk_cb(void *data, const char *str)
+{
+	struct xnvme_fioe_options *o = data;
+
+	if (strstr(str, "GUARD") != NULL)
+		o->prchk = XNVME_PI_FLAGS_GUARD_CHECK;
+	if (strstr(str, "REFTAG") != NULL)
+		o->prchk |= XNVME_PI_FLAGS_REFTAG_CHECK;
+	if (strstr(str, "APPTAG") != NULL)
+		o->prchk |= XNVME_PI_FLAGS_APPTAG_CHECK;
+
+	return 0;
+}
+
 static struct fio_option options[] = {
 	{
 		.name = "hipri",
@@ -171,6 +200,56 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group = FIO_OPT_G_XNVME,
 	},
+	{
+		.name	= "md_per_io_size",
+		.lname	= "Separate Metadata Buffer Size per I/O",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct xnvme_fioe_options, md_per_io_size),
+		.def	= "0",
+		.help	= "Size of separate metadata buffer per I/O (Default: 0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_XNVME,
+	},
+	{
+		.name	= "pi_act",
+		.lname	= "Protection Information Action",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct xnvme_fioe_options, pi_act),
+		.def	= "1",
+		.help	= "Protection Information Action bit (pi_act=1 or pi_act=0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_XNVME,
+	},
+	{
+		.name	= "pi_chk",
+		.lname	= "Protection Information Check",
+		.type	= FIO_OPT_STR_STORE,
+		.def	= NULL,
+		.help	= "Control of Protection Information Checking (pi_chk=GUARD,REFTAG,APPTAG)",
+		.cb	= str_pi_chk_cb,
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_XNVME,
+	},
+	{
+		.name	= "apptag",
+		.lname	= "Application Tag used in Protection Information",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct xnvme_fioe_options, apptag),
+		.def	= "0x1234",
+		.help	= "Application Tag used in Protection Information field (Default: 0x1234)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_XNVME,
+	},
+	{
+		.name	= "apptag_mask",
+		.lname	= "Application Tag Mask",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct xnvme_fioe_options, apptag_mask),
+		.def	= "0xffff",
+		.help	= "Application Tag Mask used with Application Tag (Default: 0xffff)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_XNVME,
+	},
 
 	{
 		.name = NULL,
@@ -181,6 +260,10 @@ static void cb_pool(struct xnvme_cmd_ctx *ctx, void *cb_arg)
 {
 	struct io_u *io_u = cb_arg;
 	struct xnvme_fioe_data *xd = io_u->mmap_data;
+	struct xnvme_fioe_request *fio_req = io_u->engine_data;
+	struct xnvme_fioe_fwrap *fwrap = &xd->files[io_u->file->fileno];
+	bool pi_act = (fio_req->pi_ctx.pi_flags >> 3);
+	int err;
 
 	if (xnvme_cmd_ctx_cpl_status(ctx)) {
 		xnvme_cmd_ctx_pr(ctx, XNVME_PR_DEF);
@@ -188,6 +271,15 @@ static void cb_pool(struct xnvme_cmd_ctx *ctx, void *cb_arg)
 		io_u->error = EIO;
 	}
 
+	if (!io_u->error && fwrap->geo->pi_type && (io_u->ddir == DDIR_READ) && !pi_act) {
+		err = xnvme_pi_verify(&fio_req->pi_ctx, io_u->xfer_buf,
+				      fio_req->md_buf, io_u->xfer_buflen / fwrap->lba_nbytes);
+		if (err) {
+			xd->ecount += 1;
+			io_u->error = EIO;
+		}
+	}
+
 	xd->iocq[xd->completed++] = io_u;
 	xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
 }
@@ -249,10 +341,54 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
 
 	free(xd->iocq);
 	free(xd->iovec);
+	free(xd->md_iovec);
 	free(xd);
 	td->io_ops_data = NULL;
 }
 
+static int _verify_options(struct thread_data *td, struct fio_file *f,
+			   struct xnvme_fioe_fwrap *fwrap)
+{
+	struct xnvme_fioe_options *o = td->eo;
+	unsigned int correct_md_size;
+
+	for_each_rw_ddir(ddir) {
+		if (td->o.min_bs[ddir] % fwrap->lba_nbytes || td->o.max_bs[ddir] % fwrap->lba_nbytes) {
+			if (!fwrap->lba_pow2) {
+				log_err("ioeng->_verify_options(%s): block size must be a multiple of %u "
+					"(LBA data size + Metadata size)\n", f->file_name, fwrap->lba_nbytes);
+			} else {
+				log_err("ioeng->_verify_options(%s): block size must be a multiple of LBA data size\n",
+					f->file_name);
+			}
+			return 1;
+		}
+		if (ddir == DDIR_TRIM)
+			continue;
+
+		correct_md_size = (td->o.max_bs[ddir] / fwrap->lba_nbytes) * fwrap->md_nbytes;
+		if (fwrap->md_nbytes && fwrap->lba_pow2 && (o->md_per_io_size < correct_md_size)) {
+			log_err("ioeng->_verify_options(%s): md_per_io_size should be at least %u bytes\n",
+				f->file_name, correct_md_size);
+			return 1;
+		}
+	}
+
+	/*
+	 * For extended logical block sizes we cannot use verify when
+	 * end to end data protection checks are enabled, as the PI
+	 * section of data buffer conflicts with verify.
+	 */
+	if (fwrap->md_nbytes && fwrap->geo->pi_type && !fwrap->lba_pow2 &&
+	    td->o.verify != VERIFY_NONE) {
+		log_err("ioeng->_verify_options(%s): for extended LBA, verify cannot be used when E2E data protection is enabled\n",
+			f->file_name);
+		return 1;
+	}
+
+	return 0;
+}
+
 /**
  * Helper function setting up device handles as addressed by the naming
  * convention of the given `fio_file` filename.
@@ -263,6 +399,7 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
 static int _dev_open(struct thread_data *td, struct fio_file *f)
 {
 	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_fioe_options *o = td->eo;
 	struct xnvme_fioe_data *xd = td->io_ops_data;
 	struct xnvme_fioe_fwrap *fwrap;
 	int flags = 0;
@@ -297,6 +434,31 @@ static int _dev_open(struct thread_data *td, struct fio_file *f)
 
 	fwrap->ssw = xnvme_dev_get_ssw(fwrap->dev);
 	fwrap->lba_nbytes = fwrap->geo->lba_nbytes;
+	fwrap->md_nbytes = fwrap->geo->nbytes_oob;
+
+	if (fwrap->geo->lba_extended)
+		fwrap->lba_pow2 = 0;
+	else
+		fwrap->lba_pow2 = 1;
+
+	/*
+	 * When PI action is set and PI size is equal to metadata size, the
+	 * controller inserts/removes PI. So update the LBA data and metadata
+	 * sizes accordingly.
+	 */
+	if (o->pi_act && fwrap->geo->pi_type &&
+	    fwrap->geo->nbytes_oob == xnvme_pi_size(fwrap->geo->pi_format)) {
+		if (fwrap->geo->lba_extended) {
+			fwrap->lba_nbytes -= fwrap->geo->nbytes_oob;
+			fwrap->lba_pow2 = 1;
+		}
+		fwrap->md_nbytes = 0;
+	}
+
+	if (_verify_options(td, f, fwrap)) {
+		td_verror(td, EINVAL, "_dev_open");
+		goto failure;
+	}
 
 	fwrap->fio_file = f;
 	fwrap->fio_file->filetype = FIO_TYPE_BLOCK;
@@ -325,6 +487,7 @@ failure:
 static int xnvme_fioe_init(struct thread_data *td)
 {
 	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_options *o = td->eo;
 	struct fio_file *f;
 	unsigned int i;
 
@@ -347,12 +510,25 @@ static int xnvme_fioe_init(struct thread_data *td)
 		return 1;
 	}
 
-	xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
-	if (!xd->iovec) {
-		free(xd->iocq);
-		free(xd);
-		log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
-		return 1;
+	if (o->xnvme_iovec) {
+		xd->iovec = calloc(td->o.iodepth, sizeof(*xd->iovec));
+		if (!xd->iovec) {
+			free(xd->iocq);
+			free(xd);
+			log_err("ioeng->init(): !calloc(xd->iovec), err(%d)\n", errno);
+			return 1;
+		}
+	}
+
+	if (o->xnvme_iovec && o->md_per_io_size) {
+		xd->md_iovec = calloc(td->o.iodepth, sizeof(*xd->md_iovec));
+		if (!xd->md_iovec) {
+			free(xd->iocq);
+			free(xd->iovec);
+			free(xd);
+			log_err("ioeng->init(): !calloc(xd->md_iovec), err(%d)\n", errno);
+			return 1;
+		}
 	}
 
 	xd->prev = -1;
@@ -362,8 +538,8 @@ static int xnvme_fioe_init(struct thread_data *td)
 	{
 		if (_dev_open(td, f)) {
 			/*
-			 * Note: We are not freeing xd, iocq and iovec. This
-			 * will be done as part of cleanup routine.
+			 * Note: We are not freeing xd, iocq, iovec and md_iovec.
+			 * This will be done as part of cleanup routine.
 			 */
 			log_err("ioeng->init(): failed; _dev_open(%s)\n", f->file_name);
 			return 1;
@@ -418,13 +594,61 @@ static void xnvme_fioe_iomem_free(struct thread_data *td)
 
 static int xnvme_fioe_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
+	struct xnvme_fioe_request *fio_req;
+	struct xnvme_fioe_options *o = td->eo;
+	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_fwrap *fwrap = &xd->files[0];
+
+	if (!fwrap->dev) {
+		log_err("ioeng->io_u_init(): failed; no dev-handle\n");
+		return 1;
+	}
+
 	io_u->mmap_data = td->io_ops_data;
+	io_u->engine_data = NULL;
+
+	fio_req = calloc(1, sizeof(*fio_req));
+	if (!fio_req) {
+		log_err("ioeng->io_u_init(): !calloc(fio_req), err(%d)\n", errno);
+		return 1;
+	}
+
+	if (o->md_per_io_size) {
+		fio_req->md_buf = xnvme_buf_alloc(fwrap->dev, o->md_per_io_size);
+		if (!fio_req->md_buf) {
+			free(fio_req);
+			return 1;
+		}
+	}
+
+	io_u->engine_data = fio_req;
 
 	return 0;
 }
 
 static void xnvme_fioe_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
+	struct xnvme_fioe_data *xd = NULL;
+	struct xnvme_fioe_fwrap *fwrap = NULL;
+	struct xnvme_fioe_request *fio_req = NULL;
+
+	if (!td->io_ops_data)
+		return;
+
+	xd = td->io_ops_data;
+	fwrap = &xd->files[0];
+
+	if (!fwrap->dev) {
+		log_err("ioeng->io_u_free(): failed no dev-handle\n");
+		return;
+	}
+
+	fio_req = io_u->engine_data;
+	if (fio_req->md_buf)
+		xnvme_buf_free(fwrap->dev, fio_req->md_buf);
+
+	free(fio_req);
+
 	io_u->mmap_data = NULL;
 }
 
@@ -499,8 +723,10 @@ static int xnvme_fioe_getevents(struct thread_data *td, unsigned int min, unsign
 static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_options *o = td->eo;
 	struct xnvme_fioe_fwrap *fwrap;
 	struct xnvme_cmd_ctx *ctx;
+	struct xnvme_fioe_request *fio_req = io_u->engine_data;
 	uint32_t nsid;
 	uint64_t slba;
 	uint16_t nlb;
@@ -513,8 +739,13 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	fwrap = &xd->files[io_u->file->fileno];
 	nsid = xnvme_dev_get_nsid(fwrap->dev);
 
-	slba = io_u->offset >> fwrap->ssw;
-	nlb = (io_u->xfer_buflen >> fwrap->ssw) - 1;
+	if (fwrap->lba_pow2) {
+		slba = io_u->offset >> fwrap->ssw;
+		nlb = (io_u->xfer_buflen >> fwrap->ssw) - 1;
+	} else {
+		slba = io_u->offset / fwrap->lba_nbytes;
+		nlb = (io_u->xfer_buflen / fwrap->lba_nbytes) - 1;
+	}
 
 	ctx = xnvme_queue_get_cmd_ctx(fwrap->queue);
 	ctx->async.cb_arg = io_u;
@@ -545,14 +776,80 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 		return FIO_Q_COMPLETED;
 	}
 
+	if (fwrap->geo->pi_type && !o->pi_act) {
+		err = xnvme_pi_ctx_init(&fio_req->pi_ctx, fwrap->lba_nbytes,
+					fwrap->geo->nbytes_oob, fwrap->geo->lba_extended,
+					fwrap->geo->pi_loc, fwrap->geo->pi_type,
+					(o->pi_act << 3 | o->prchk), slba, o->apptag_mask,
+					o->apptag, fwrap->geo->pi_format);
+		if (err) {
+			log_err("ioeng->queue(): err: '%d'\n", err);
+
+			xnvme_queue_put_cmd_ctx(ctx->async.queue, ctx);
+
+			io_u->error = abs(err);
+			return FIO_Q_COMPLETED;
+		}
+
+		if (io_u->ddir == DDIR_WRITE)
+			xnvme_pi_generate(&fio_req->pi_ctx, io_u->xfer_buf, fio_req->md_buf,
+					  nlb + 1);
+	}
+
+	if (fwrap->geo->pi_type)
+		ctx->cmd.nvm.prinfo = (o->pi_act << 3 | o->prchk);
+
+	switch (fwrap->geo->pi_type) {
+	case XNVME_PI_TYPE1:
+	case XNVME_PI_TYPE2:
+		switch (fwrap->geo->pi_format) {
+		case XNVME_SPEC_NVM_NS_16B_GUARD:
+			if (o->prchk & XNVME_PI_FLAGS_REFTAG_CHECK)
+				ctx->cmd.nvm.ilbrt = (uint32_t)slba;
+			break;
+		case XNVME_SPEC_NVM_NS_64B_GUARD:
+			if (o->prchk & XNVME_PI_FLAGS_REFTAG_CHECK) {
+				ctx->cmd.nvm.ilbrt = (uint32_t)slba;
+				ctx->cmd.common.cdw03 = ((slba >> 32) & 0xffff);
+			}
+			break;
+		default:
+			break;
+		}
+		if (o->prchk & XNVME_PI_FLAGS_APPTAG_CHECK) {
+			ctx->cmd.nvm.lbat = o->apptag;
+			ctx->cmd.nvm.lbatm = o->apptag_mask;
+		}
+		break;
+	case XNVME_PI_TYPE3:
+		if (o->prchk & XNVME_PI_FLAGS_APPTAG_CHECK) {
+			ctx->cmd.nvm.lbat = o->apptag;
+			ctx->cmd.nvm.lbatm = o->apptag_mask;
+		}
+		break;
+	case XNVME_PI_DISABLE:
+		break;
+	}
+
 	if (vectored_io) {
 		xd->iovec[io_u->index].iov_base = io_u->xfer_buf;
 		xd->iovec[io_u->index].iov_len = io_u->xfer_buflen;
-
-		err = xnvme_cmd_passv(ctx, &xd->iovec[io_u->index], 1, io_u->xfer_buflen, NULL, 0,
-				      0);
+		if (fwrap->md_nbytes && fwrap->lba_pow2) {
+			xd->md_iovec[io_u->index].iov_base = fio_req->md_buf;
+			xd->md_iovec[io_u->index].iov_len = fwrap->md_nbytes * (nlb + 1);
+			err = xnvme_cmd_passv(ctx, &xd->iovec[io_u->index], 1, io_u->xfer_buflen,
+					      &xd->md_iovec[io_u->index], 1,
+					      fwrap->md_nbytes * (nlb + 1));
+		} else {
+			err = xnvme_cmd_passv(ctx, &xd->iovec[io_u->index], 1, io_u->xfer_buflen,
+					      NULL, 0, 0);
+		}
 	} else {
-		err = xnvme_cmd_pass(ctx, io_u->xfer_buf, io_u->xfer_buflen, NULL, 0);
+		if (fwrap->md_nbytes && fwrap->lba_pow2)
+			err = xnvme_cmd_pass(ctx, io_u->xfer_buf, io_u->xfer_buflen,
+					     fio_req->md_buf, fwrap->md_nbytes * (nlb + 1));
+		else
+			err = xnvme_cmd_pass(ctx, io_u->xfer_buf, io_u->xfer_buflen, NULL, 0);
 	}
 	switch (err) {
 	case 0:
diff --git a/examples/xnvme-pi.fio b/examples/xnvme-pi.fio
new file mode 100644
index 00000000..ca8c0101
--- /dev/null
+++ b/examples/xnvme-pi.fio
@@ -0,0 +1,53 @@
+; README
+;
+; This job-file is intended to be used either as:
+;
+; # Use the xNVMe io-engine engine io_uring_cmd async. impl.
+; fio examples/xnvme-pi.fio \
+;   --ioengine=xnvme \
+;   --xnvme_async=io_uring_cmd \
+;   --filename=/dev/ng0n1
+;
+; # Use the xNVMe io-engine engine with nvme sync. impl.
+; fio examples/xnvme-pi.fio \
+;   --ioengine=xnvme \
+;   --xnvme_sync=nvme \
+;   --filename=/dev/ng0n1
+;
+; # Use the xNVMe io-engine engine with SPDK backend, note that you have to set the Namespace-id
+; fio examples/xnvme-pi.fio \
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
+; NOTE: This example configuration assumes that the NVMe device is formatted
+; with a separate metadata buffer. If you want to run on an extended LBA format
+; update the "bs" accordingly.
+;
+[global]
+size=100M
+iodepth=16
+bs=4K
+md_per_io_size=64
+pi_act=0
+pi_chk=GUARD,APPTAG,REFTAG
+apptag=0x0234
+apptag_mask=0xFFFF
+thread=1
+stonewall=1
+
+[write]
+rw=write
+
+[read]
+rw=read
diff --git a/fio.1 b/fio.1
index 227fcb47..7ec5c745 100644
--- a/fio.1
+++ b/fio.1
@@ -2251,10 +2251,10 @@ By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
 identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .TP
-.BI (io_uring_cmd)md_per_io_size \fR=\fPint
+.BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
 .TP
-.BI (io_uring_cmd)pi_act \fR=\fPint
+.BI (io_uring_cmd,xnvme)pi_act \fR=\fPint
 Action to take when nvme namespace is formatted with protection information.
 If this is set to 1 and namespace is formatted with metadata size equal to
 protection information size, fio won't use separate metadata buffer or extended
@@ -2268,7 +2268,7 @@ For 16 bit CRC generation fio will use isa-l if available otherwise it will
 use the default slower generator.
 (see: https://github.com/intel/isa-l)
 .TP
-.BI (io_uring_cmd)pi_chk \fR=\fPstr[,str][,str]
+.BI (io_uring_cmd,xnvme)pi_chk \fR=\fPstr[,str][,str]
 Controls the protection information check. This can take one or more of these
 values. Default: none.
 .RS
@@ -2285,11 +2285,11 @@ Enables protection information checking of application tag field.
 .RE
 .RE
 .TP
-.BI (io_uring_cmd)apptag \fR=\fPint
+.BI (io_uring_cmd,xnvme)apptag \fR=\fPint
 Specifies logical block application tag value, if namespace is formatted to use
 end to end protection information. Default: 0x1234.
 .TP
-.BI (io_uring_cmd)apptag_mask \fR=\fPint
+.BI (io_uring_cmd,xnvme)apptag_mask \fR=\fPint
 Specifies logical block application tag mask value, if namespace is formatted
 to use end to end protection information. Default: 0xffff.
 .TP
@@ -3765,12 +3765,14 @@ resulting in more precise time-related I/O statistics.
 Also see \fBlog_avg_msec\fR as well. Defaults to 1024.
 .TP
 .BI log_avg_msec \fR=\fPint
-By default, fio will log an entry in the iops, latency, or bw log for every
-I/O that completes. When writing to the disk log, that can quickly grow to a
-very large size. Setting this option makes fio average the each log entry
-over the specified period of time, reducing the resolution of the log. See
-\fBlog_window_value\fR as well. Defaults to 0, logging all entries.
-Also see \fBLOG FILE FORMATS\fR section.
+By default, fio will log an entry in the iops, latency, or bw log for every I/O
+that completes. When writing to the disk log, that can quickly grow to a very
+large size. Setting this option directs fio to instead record an average over
+the specified duration for each log entry, reducing the resolution of the log.
+When the job completes, fio will flush any accumulated latency log data, so the
+final log interval may not match the value specified by this option and there
+may even be duplicate timestamps. See \fBlog_window_value\fR as well. Defaults
+to 0, logging entries for each I/O. Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_hist_msec \fR=\fPint
 Same as \fBlog_avg_msec\fR, but logs entries for completion latency
diff --git a/helper_thread.c b/helper_thread.c
index 2a9dabf5..332ccb53 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -161,7 +161,6 @@ void helper_thread_exit(void)
 		return;
 
 	helper_data->exit = 1;
-	submit_action(A_EXIT);
 	pthread_join(helper_data->thread, NULL);
 }
 
diff --git a/stat.c b/stat.c
index 11b58626..b98e8b27 100644
--- a/stat.c
+++ b/stat.c
@@ -3576,6 +3576,22 @@ static int add_iops_samples(struct thread_data *td, struct timespec *t)
 				td->ts.iops_stat, td->iops_log, false);
 }
 
+static bool td_in_logging_state(struct thread_data *td)
+{
+	if (in_ramp_time(td))
+		return false;
+
+	switch(td->runstate) {
+	case TD_RUNNING:
+	case TD_VERIFYING:
+	case TD_FINISHING:
+	case TD_EXITED:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Returns msecs to next event
  */
@@ -3585,15 +3601,13 @@ int calc_log_samples(void)
 	struct timespec now;
 	long elapsed_time = 0;
 
-	fio_gettime(&now, NULL);
-
 	for_each_td(td) {
-		elapsed_time = mtime_since_now(&td->epoch);
+		fio_gettime(&now, NULL);
+		elapsed_time = mtime_since(&td->epoch, &now);
 
 		if (!td->o.stats)
 			continue;
-		if (in_ramp_time(td) ||
-		    !(td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING)) {
+		if (!td_in_logging_state(td)) {
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
 			continue;
 		}
