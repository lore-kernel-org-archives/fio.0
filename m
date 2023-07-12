Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6F7AC001DC
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 08:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbjGMIqB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 04:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbjGMIpg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 04:45:36 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B812211B
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 01:45:23 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230713084521epoutp03ef7d9a2637bb00427082372a01479447~xYPCNtw-H1397313973epoutp03x
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 08:45:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230713084521epoutp03ef7d9a2637bb00427082372a01479447~xYPCNtw-H1397313973epoutp03x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689237921;
        bh=yTFPwKVDUICH48eKvYFgcZ5tOBlOXi//a8rhwhJvXic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GLzVSxuYmxKmAlgYylrHE0fOnolLdpDqFv7r4tPm+qoXEXq1CHuvjHp4yncLada1/
         bTg2gGCujQ7tFebtb1URCtMoApmAk/eZ4gZtkU3Aullo0TFs2Y/WWoRDn7aBFZejLm
         uoJbuiNSzhEtL9IB+AmkoPPEUR58X9u4YWhJikvU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230713084521epcas5p1e4b7b79b733dd245e2e00f50a20e33a9~xYPB7XOK52707327073epcas5p16;
        Thu, 13 Jul 2023 08:45:21 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4R1p8b4C4Cz4x9Q8; Thu, 13 Jul
        2023 08:45:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.26.06099.D99BFA46; Thu, 13 Jul 2023 17:45:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050115epcas5p143d5ad2bf082eb31b68a30fcc8a6ef61~xBiFPY9OH0751107511epcas5p1G;
        Wed, 12 Jul 2023 05:01:15 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230712050115epsmtrp13f5662e9de455006afa562bf3b0bbd92~xBiFOxftd0214902149epsmtrp1b;
        Wed, 12 Jul 2023 05:01:15 +0000 (GMT)
X-AuditID: b6c32a4b-d308d700000017d3-1a-64afb99d0865
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        88.B3.14748.B933EA46; Wed, 12 Jul 2023 14:01:15 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230712050114epsmtip1e69398fd036eab1f873f525500d55828~xBiEGAH_i3185131851epsmtip1d;
        Wed, 12 Jul 2023 05:01:14 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 4/4] engines/xnvme: add support for fdp
Date:   Wed, 12 Jul 2023 15:50:41 +0530
Message-Id: <20230712102041.20283-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230712102041.20283-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTQ3fuzvUpBpO+W1msufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjcq2yUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHar6RQlphTChQK
        SCwuVtK3synKLy1JVcjILy6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzvj97yFb
        wSb7iilH+5kaGL8ZdzFyckgImEh83PaWqYuRi0NIYDejxJp3j1kgnE+MEp3f/rCBVAkJfGOU
        +Pk9FaZjx+Nv7BBFexklvr5pZYQo6mSSOHkiC8RmE9CWePX2BnMXIweHiICGxJq7YL3MAtkS
        i04tYwaxhQWsJI6u/MEKUsIioCqx/J0ESJhXwEbiw9VrTBCr5CVmXvrODlLCKWAr8fmRFUSJ
        oMTJmU9YICbKSzRvnc0MUX6PXWLtTRUI20Xi0p/DLBC2sMSr41vYIWwpiZf9bVB2tsSmhz+h
        VhVIHHnRCzXHXqL1VD/Y8cwCmhLrd+lDhGUlpp5axwSxlk+i9/cTqFZeiR3zYGxVib/3bkOt
        lZa4+e4qlO0h0b99JjMk0CYAQ3b7PdYJjAqzkLwzC8k7sxBWL2BkXsUomVpQnJueWmxaYJyX
        Wg6P4OT83E2M4OSo5b2D8dGDD3qHGJk4GA8xSnAwK4nwqmxblyLEm5JYWZValB9fVJqTWnyI
        0RQY2hOZpUST84HpOa8k3tDE0sDEzMzMxNLYzFBJnPd169wUIYH0xJLU7NTUgtQimD4mDk6p
        Bqbbp7oNGPaWqDgfVHfeEcczff/hmkk/uhhEcla8Nswpb/5SN2/f4Y07/Wr6xfaXinKZTTVt
        aFy98QLj2RtPFVlufTPcVa7WlWvovnWhVIR2p8raGUkWP3/wLfMTNNzffL/FUs7hdeT8tU8D
        fdNWCcyylNRJW8ZSxBH7IEFO/ZrpFcezDEJqx3917/S7wbq2at3q7l3vT/bOPGblpStWEK5+
        VC7s6Du191+TWyUjOqqOq6t3n1+gYHz5G2PWGrblLeaRB2dVPObT4DxoUrrr5Zb6sw/uN6W9
        yptokBzz+aR5loRzfOyT5fm5X/2n737LJZJz7n6KaM8iCRfuU77/Ule3bXXL87K7Ehc2S3mF
        khJLcUaioRZzUXEiAKZ7F9cXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnO5s43UpBnfeCFmsufKb3WL13X42
        i4+zXjBbTDp0jdHibvcMdosNbYIObB47Z91l97h8ttRj06pONo++LasYPT5vkgtgjeKySUnN
        ySxLLdK3S+DK+P3vIVvBJvuKKUf7mRoYvxl3MXJySAiYSOx4/I29i5GLQ0hgN6NE49MJrF2M
        HEAJaYmF6xMhaoQlVv57DlXTziSxYUYzO0iCTUBb4tXbG8wgtoiAlsSxdU1sIL3MAvkS1+/l
        goSFBawkjq78ATaSRUBVYvk7CZAwr4CNxIer15ggxstLzLz0nR2khFPAVuLzIyuQsBBQyc8D
        O9khygUlTs58wgJiMwOVN2+dzTyBUWAWktQsJKkFjEyrGCVTC4pz03OTDQsM81LL9YoTc4tL
        89L1kvNzNzGCA1hLYwfjvfn/9A4xMnEwHmKU4GBWEuEtOLgqRYg3JbGyKrUoP76oNCe1+BCj
        NAeLkjiv4YzZKUIC6YklqdmpqQWpRTBZJg5OqQYm+x0Ve2yV6tezX5r8QqcvLsLmg9rH36l3
        /mcJXrnelD7VzpK5t+W9YcCHnAmv9LNEogrlHS9cXGe4i8+T64vZEwOhnqxNPmuXZ6ZzJvw+
        uvjilNnJetudzJofr/n4SvXen2auzlhRF4UDBT5bZAJT1t5xV0iutmJY2HogLXRmZ7TB5aCm
        r1uUmNfIa9gfUqgtC/xzwz3ymKxRycRPb0yCLV/sYDvLemj5neANBxl4JuqyyR8LCFui7/Do
        tf9v/rjzb/1zdxv/tdDqPr912nv7la3xf+cn997UqJ5RYNlm+2Jv3NfkzS86Dv1/76fwIOeM
        Ktuxnf8+T7CefSCGsyXqGUOglaa0/5P1u6rOh/9QYinOSDTUYi4qTgQAG4fWec8CAAA=
X-CMS-MailID: 20230712050115epcas5p143d5ad2bf082eb31b68a30fcc8a6ef61
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230712050115epcas5p143d5ad2bf082eb31b68a30fcc8a6ef61
References: <20230712102041.20283-1-ankit.kumar@samsung.com>
        <CGME20230712050115epcas5p143d5ad2bf082eb31b68a30fcc8a6ef61@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add FDP support to xnvme I/O engine. This support can be used only with
nvme-ns generic character device (/dev/ngXnY). The available backends are
--xnvme_async=io_uring_cmd and --xnvme_sync=nvme.
Add a xnvme-fdp config example file.

Update the minimum required xnvme version to 0.7.0

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst              |  6 ++--
 configure              |  2 +-
 engines/xnvme.c        | 78 +++++++++++++++++++++++++++++++++++++++++-
 examples/xnvme-fdp.fio | 36 +++++++++++++++++++
 fio.1                  |  6 ++--
 5 files changed, 120 insertions(+), 8 deletions(-)
 create mode 100644 examples/xnvme-fdp.fio

diff --git a/HOWTO.rst b/HOWTO.rst
index 24789f41..b047877e 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2431,11 +2431,11 @@ with the caveat that when used on the command line, they must come after the
 	For direct I/O, requests will only succeed if cache invalidation isn't required,
 	file blocks are fully allocated and the disk request could be issued immediately.
 
-.. option:: fdp=bool : [io_uring_cmd]
+.. option:: fdp=bool : [io_uring_cmd] [xnvme]
 
 	Enable Flexible Data Placement mode for write commands.
 
-.. option:: fdp_pli_select=str : [io_uring_cmd]
+.. option:: fdp_pli_select=str : [io_uring_cmd] [xnvme]
 
 	Defines how fio decides which placement ID to use next. The following
 	types are defined:
@@ -2450,7 +2450,7 @@ with the caveat that when used on the command line, they must come after the
 	The available placement ID index/indices is defined by the option
 	:option:`fdp_pli`.
 
-.. option:: fdp_pli=str : [io_uring_cmd]
+.. option:: fdp_pli=str : [io_uring_cmd] [xnvme]
 
 	Select which Placement ID Index/Indicies this job is allowed to use for
 	writes. By default, the job will cycle through all available Placement
diff --git a/configure b/configure
index 74416fd4..6c938251 100755
--- a/configure
+++ b/configure
@@ -2651,7 +2651,7 @@ fi
 ##########################################
 # Check if we have xnvme
 if test "$xnvme" != "no" ; then
-  if check_min_lib_version xnvme 0.2.0; then
+  if check_min_lib_version xnvme 0.7.0; then
     xnvme="yes"
     xnvme_cflags=$(pkg-config --cflags xnvme)
     xnvme_libs=$(pkg-config --libs xnvme)
diff --git a/engines/xnvme.c b/engines/xnvme.c
index bb92a121..ce7b2bdd 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -16,6 +16,7 @@
 #include <libxnvme_spec_fs.h>
 #include "fio.h"
 #include "zbd_types.h"
+#include "fdp.h"
 #include "optgroup.h"
 
 static pthread_mutex_t g_serialize = PTHREAD_MUTEX_INITIALIZER;
@@ -509,6 +510,7 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	uint16_t nlb;
 	int err;
 	bool vectored_io = ((struct xnvme_fioe_options *)td->eo)->xnvme_iovec;
+	uint32_t dir = io_u->dtype;
 
 	fio_ro_check(td, io_u);
 
@@ -524,6 +526,10 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	ctx->cmd.common.nsid = nsid;
 	ctx->cmd.nvm.slba = slba;
 	ctx->cmd.nvm.nlb = nlb;
+	if (dir) {
+		ctx->cmd.nvm.dtype = io_u->dtype;
+		ctx->cmd.nvm.cdw13.dspec = io_u->dspec;
+	}
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
@@ -947,6 +953,72 @@ exit:
 	return err;
 }
 
+static int xnvme_fioe_fetch_ruhs(struct thread_data *td, struct fio_file *f,
+				 struct fio_ruhs_info *fruhs_info)
+{
+	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_dev *dev;
+	struct xnvme_spec_ruhs *ruhs;
+	struct xnvme_cmd_ctx ctx;
+	uint32_t ruhs_nbytes;
+	uint32_t nsid;
+	int err = 0, err_lock;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		log_err("ioeng->fdp_ruhs(): ignoring filetype: %d\n", f->filetype);
+		return -EINVAL;
+	}
+
+	err = pthread_mutex_lock(&g_serialize);
+	if (err) {
+		log_err("ioeng->fdp_ruhs(): pthread_mutex_lock(), err(%d)\n", err);
+		return -err;
+	}
+
+	dev = xnvme_dev_open(f->file_name, &opts);
+	if (!dev) {
+		log_err("ioeng->fdp_ruhs(): xnvme_dev_open(%s) failed, errno: %d\n",
+			f->file_name, errno);
+		err = -errno;
+		goto exit;
+	}
+
+	ruhs_nbytes = sizeof(*ruhs) + (FDP_MAX_RUHS * sizeof(struct xnvme_spec_ruhs_desc));
+	ruhs = xnvme_buf_alloc(dev, ruhs_nbytes);
+	if (!ruhs) {
+		err = -errno;
+		goto exit;
+	}
+	memset(ruhs, 0, ruhs_nbytes);
+
+	ctx = xnvme_cmd_ctx_from_dev(dev);
+	nsid = xnvme_dev_get_nsid(dev);
+
+	err = xnvme_nvm_mgmt_recv(&ctx, nsid, XNVME_SPEC_IO_MGMT_RECV_RUHS, 0, ruhs, ruhs_nbytes);
+
+	if (err || xnvme_cmd_ctx_cpl_status(&ctx)) {
+		err = err ? err : -EIO;
+		log_err("ioeng->fdp_ruhs(): err(%d), sc(%d)", err, ctx.cpl.status.sc);
+		goto free_buffer;
+	}
+
+	fruhs_info->nr_ruhs = ruhs->nruhsd;
+	for (uint32_t idx = 0; idx < fruhs_info->nr_ruhs; ++idx) {
+		fruhs_info->plis[idx] = le16_to_cpu(ruhs->desc[idx].pi);
+	}
+
+free_buffer:
+	xnvme_buf_free(dev, ruhs);
+exit:
+	xnvme_dev_close(dev);
+
+	err_lock = pthread_mutex_unlock(&g_serialize);
+	if (err_lock)
+		log_err("ioeng->fdp_ruhs(): pthread_mutex_unlock(), err(%d)\n", err_lock);
+
+	return err;
+}
+
 static int xnvme_fioe_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
@@ -971,7 +1043,9 @@ static int xnvme_fioe_get_file_size(struct thread_data *td, struct fio_file *f)
 
 	f->real_file_size = xnvme_dev_get_geo(dev)->tbytes;
 	fio_file_set_size_known(f);
-	f->filetype = FIO_TYPE_BLOCK;
+
+	if (td->o.zone_mode == ZONE_MODE_ZBD)
+		f->filetype = FIO_TYPE_BLOCK;
 
 exit:
 	xnvme_dev_close(dev);
@@ -1011,6 +1085,8 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.get_zoned_model = xnvme_fioe_get_zoned_model,
 	.report_zones = xnvme_fioe_report_zones,
 	.reset_wp = xnvme_fioe_reset_wp,
+
+	.fdp_fetch_ruhs = xnvme_fioe_fetch_ruhs,
 };
 
 static void fio_init fio_xnvme_register(void)
diff --git a/examples/xnvme-fdp.fio b/examples/xnvme-fdp.fio
new file mode 100644
index 00000000..86fbe0d3
--- /dev/null
+++ b/examples/xnvme-fdp.fio
@@ -0,0 +1,36 @@
+; README
+;
+; This job-file is intended to be used either as:
+;
+; # Use the xNVMe io-engine engine io_uring_cmd async. impl.
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_async=io_uring_cmd \
+;   --filename=/dev/ng0n1
+;
+; # Use the xNVMe io-engine engine with nvme sync. impl.
+; fio examples/xnvme-fdp.fio \
+;   --section=default \
+;   --ioengine=xnvme \
+;   --xnvme_sync=nvme \
+;   --filename=/dev/ng0n1
+;
+; FIO_BS="512" FIO_RW="read" FIO_IODEPTH=16 fio examples/xnvme-fdp.fio \
+;   --section=override --ioengine=xnvme --xnvme_sync=nvme --filename=/dev/ng0n1
+;
+[global]
+rw=randwrite
+size=2M
+iodepth=1
+bs=4K
+thread=1
+fdp=1
+fdp_pli=4,5
+
+[default]
+
+[override]
+rw=${FIO_RW}
+iodepth=${FIO_IODEPTH}
+bs=${FIO_BS}
diff --git a/fio.1 b/fio.1
index 0257513b..86cb2af6 100644
--- a/fio.1
+++ b/fio.1
@@ -2192,10 +2192,10 @@ cached data. Currently the RWF_NOWAIT flag does not supported for cached write.
 For direct I/O, requests will only succeed if cache invalidation isn't required,
 file blocks are fully allocated and the disk request could be issued immediately.
 .TP
-.BI (io_uring_cmd)fdp \fR=\fPbool
+.BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
-.BI (io_uring_cmd)fdp_pli_select \fR=\fPstr
+.BI (io_uring_cmd,xnvme)fdp_pli_select \fR=\fPstr
 Defines how fio decides which placement ID to use next. The following types
 are defined:
 .RS
@@ -2211,7 +2211,7 @@ Round robin over available placement IDs. This is the default.
 The available placement ID index/indices is defined by \fBfdp_pli\fR option.
 .RE
 .TP
-.BI (io_uring_cmd)fdp_pli \fR=\fPstr
+.BI (io_uring_cmd,xnvme)fdp_pli \fR=\fPstr
 Select which Placement ID Index/Indicies this job is allowed to use for writes.
 By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
-- 
2.25.1

