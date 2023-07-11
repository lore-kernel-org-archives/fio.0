Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC30BEB64DC
	for <fio@archiver.kernel.org>; Tue, 11 Jul 2023 07:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbjGKHpp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 11 Jul 2023 03:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbjGKHpf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 11 Jul 2023 03:45:35 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5452C1989
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 00:45:27 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230711074525epoutp04b94847399dbf48abe1841f338375fefe~wwIIUwuuS1481314813epoutp043
        for <fio@vger.kernel.org>; Tue, 11 Jul 2023 07:45:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230711074525epoutp04b94847399dbf48abe1841f338375fefe~wwIIUwuuS1481314813epoutp043
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1689061525;
        bh=xhhICK5mie6QAN3skcrFiuvzbC1deZbMW77Hf+twctg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hFsmueG8kcGYAW1YAqcjxlbY+CXOYEz/flfDDAjnmygXLOX4j8JwzuSIsNeOzuyGL
         QKBQgWRxQ8drBZ0ecjDH8PB3wCXdmUEZ71VH4ZhIR3EPpINAIaPOoEQylSxhp+4QHh
         3z/U+boJXmQ36qOrdTtu1OZceumMSF3vya/DUNCM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230711074524epcas5p25600e4bac8e503c1576d81f7923524f7~wwIIEnWDy1340513405epcas5p2w;
        Tue, 11 Jul 2023 07:45:24 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4R0XwM33CGz4x9Pp; Tue, 11 Jul
        2023 07:45:23 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        45.90.57354.F880DA46; Tue, 11 Jul 2023 16:45:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230711073514epcas5p31993ba169c4bde8169dc31a5528289a3~wv-Pns7mz1707517075epcas5p3X;
        Tue, 11 Jul 2023 07:35:14 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230711073514epsmtrp2be59672aa167c8da7390467270ac251b~wv-PhBFxz2722327223epsmtrp2B;
        Tue, 11 Jul 2023 07:35:14 +0000 (GMT)
X-AuditID: b6c32a44-269fb7000001e00a-a1-64ad088f3147
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        00.B5.14748.2360DA46; Tue, 11 Jul 2023 16:35:14 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230711073513epsmtip1fd702e34c81ae6240706ca8f4d1ad5d7~wv-OjJIMU0243002430epsmtip1R;
        Tue, 11 Jul 2023 07:35:13 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 3/3] engines/xnvme: add support for fdp
Date:   Tue, 11 Jul 2023 18:24:34 +0530
Message-Id: <20230711125434.14691-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230711125434.14691-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTS7efY22Kwd+HYhZrrvxmt1h9t5/N
        4uOsF8wWkw5dY7S42z2D3WJDm6ADm8fOWXfZPS6fLfXYtKqTzaNvyypGj8+b5AJYo7JtMlIT
        U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D2KymUJeaUAoUC
        EouLlfTtbIryS0tSFTLyi0tslVILUnIKTAr0ihNzi0vz0vXyUkusDA0MjEyBChOyMy4tW81a
        sN2+4s6PJ0wNjL+Nuxg5OSQETCRenJjN2MXIxSEksJtRYvmGXywQzidGiWlHfzBBON8YJU4+
        2MIG0zJxzjWolr2MEgsX3YZq6WSSeHTsOQtIFZuAtsSrtzeYuxg5OEQENCTW3E0FCTMLZEss
        OrUMLCwsYC5xZ647SJhFQFViw95jjCA2r4CNRPvysywQu+QlZl76zg5icwrYSizrXMYEUSMo
        cXLmExaIkfISzVtnM4OcICFwj11i8bdbUIe6SMzcdg9qkLDEq+Nb2CFsKYnP7/ZC1WRLbHr4
        kwnCLpA48qKXGcK2l2g91Q92J7OApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtV4u+9
        21BrpSVuvrsKZXtI7Nr1HBqgExglZh6byziBUWEWkn9mIflnFsLqBYzMqxglUwuKc9NTk00L
        DPNSy+GRnJyfu4kRnCS1XHYw3pj/T+8QIxMH4yFGCQ5mJRHegoOrUoR4UxIrq1KL8uOLSnNS
        iw8xmgIDfCKzlGhyPjBN55XEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fE
        wSnVwKSW9Det5uGHwLffmh3vJu1rWXbq4vbvPbyG0wRLPJz1X6/L1jCzU+Q+YbBSzfy+i2CR
        7qsrIZueM199oHZj3vLO0zoSpdpJvj7vVBMbt8nyHLL9LFCrmSjx2vDm9LkPPk9+cODoeeO1
        qiZmUT8fPEueKv1PWX3Pipd8PyvEkhLu/prXnXRtqY9iSueHQt+KszZOTd7fvFzSNB8oT7vC
        JPuzKvHtg9pf7kGSTomv+QN3Nj4TTN60xUM/ykCBbcnKy7e5a2dO8DRpPjAlb+efJZfCWVsz
        U9WfM5jeL55sl2BqeGmlukSlY9/M5OOzcsRbkvqWnX/Jvl2rq/zPkePXlm7UuPz52b5GzZsG
        77OK+5RYijMSDbWYi4oTAZLMrMQbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsWy7bCSnK4R29oUg3/9ohZrrvxmt1h9t5/N
        4uOsF8wWkw5dY7S42z2D3WJDm6ADm8fOWXfZPS6fLfXYtKqTzaNvyypGj8+b5AJYo7hsUlJz
        MstSi/TtErgyLi1bzVqw3b7izo8nTA2Mv427GDk5JARMJCbOucbYxcjFISSwm1GiZ8l89i5G
        DqCEtMTC9YkQNcISK/89Z4eoaWeSmDdtBiNIgk1AW+LV2xvMILaIgJbEsXVNbCC9zAL5Etfv
        5YKYwgLmEnfmuoNUsAioSmzYewysk1fARqJ9+VkWiPHyEjMvfWcHsTkFbCWWdS5jArGFgGoW
        nn0PVS8ocXLmE7B6ZqD65q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6yYYFhXmq5XnFibnFp
        Xrpecn7uJkZwCGtp7GC8N/+f3iFGJg7GQ4wSHMxKIrwFB1elCPGmJFZWpRblxxeV5qQWH2KU
        5mBREuc1nDE7RUggPbEkNTs1tSC1CCbLxMEp1cC0ljfWakKQzxx5Ex4ZH5fu2RPO3Nz/xKF+
        /UErlWi1XZsdhF9w2ifvXrv72sFapRef2UoTVbbsbjjtaZw/Z+KbNUVLyjon+7z6V/vxq2vL
        1FbGRw/UbpxrsrMMWMP0XtJ5nYnsXdk/tet/3PHkS5SsMvprKbX+/cWpukY2h/hZ7s6w6te8
        G5m64kKhiRrLgjWG187bzYthNdl5xfAgT3SNfPCtp947Dc5efP97YeJpRpFMf4fkDI4qs1N2
        Pea1s/u+ii9a9kLy6UL7bSnz2Su4/TSC5bdWS/yzDXfhLlqbv/rdS8ndyTnri9dsvrWF3bG4
        MkMrMXJ+eG8zq0tEzsfaJXr3qg/Pu/4uesvsLe5KLMUZiYZazEXFiQABXMKW0AIAAA==
X-CMS-MailID: 20230711073514epcas5p31993ba169c4bde8169dc31a5528289a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230711073514epcas5p31993ba169c4bde8169dc31a5528289a3
References: <20230711125434.14691-1-ankit.kumar@samsung.com>
        <CGME20230711073514epcas5p31993ba169c4bde8169dc31a5528289a3@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Added FDP support to xnvme I/O engine. This support can be used only with
nvme-ns generic character device (/dev/ngXnY). The available backends are
--xnvme_async=io_uring_cmd and --xnvme_sync=nvme.
Added a xnvme-fdp config example file.

Updated the minimum required xnvme version to 0.7.0

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

