Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD1C22627
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707820251; cv=none; b=LqEFD6tM2jvK5RJdAx1NKEDOKRahzW5y+I4DAD0jt5EFOpMk6y/k2kAG+pPSWbGezNJdeJRSMuYD1NtMmUDtwETdQ6iB4nZALRvAnsJk4Vk7TFvojQW6RDmw+dsCDoTUzMgSs0r5xsnOGOb1ByZ9p78pTaTlfxh7RMnlldayIfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707820251; c=relaxed/simple;
	bh=ChSwn67fJ+HM6uKKYBr6PYpXLAPCW6NSFDdDyYI2qfM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eFcYSarwtV+ugfkNaTS8fW4DLmH2P0M6eBAInBtvZYi99zWS20JlUMN8kRvG2PVmZrndyLSrsCf/SP7apXtkwOpH2MT3xjcNeEar42BhlC+l7317vaNKfj0qm/KGaCajSzMwbpLuxuXbxsJBepSRih/C7qCSNcVqqznRUREsNGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eFd6MSEv; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eFd6MSEv"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240213103046epoutp048fb074ff6f4525229a3a05f9b6435055~zZXc7mJ_21813918139epoutp04Z
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:30:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240213103046epoutp048fb074ff6f4525229a3a05f9b6435055~zZXc7mJ_21813918139epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707820246;
	bh=a4/3wuJgGyk30K8FMnMjD2BmHhl0K2ZLBzVoMXghltE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFd6MSEv64Hv0mg7RoOBVotOsgbgIvud5kDGi04M4RhfQapWQWbDzK206InTkxXH3
	 3PM5iBfUfwLFB8zNgOZcBZvvqux1OU+5R41oDmy9dHJw+ERRk8/5urogYHnSy06jFZ
	 3c2IHsRlFsz45EkBc8o6+oHClsaF0/5fJcpQLbls=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240213103046epcas5p1d5e165f24d90553734e43b9365a077ca~zZXclsEHm2272422724epcas5p1R;
	Tue, 13 Feb 2024 10:30:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TYyK03zqdz4x9Pt; Tue, 13 Feb
	2024 10:30:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	58.A4.09634.4D44BC56; Tue, 13 Feb 2024 19:30:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240213101606epcas5p25ae0cab4102c92c6e93133df182b8486~zZKo7MJDl1344213442epcas5p2k;
	Tue, 13 Feb 2024 10:16:06 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240213101605epsmtrp2c3e47fefe7864807f7d85c150a3dc1e2~zZKo6pUGX1175011750epsmtrp23;
	Tue, 13 Feb 2024 10:16:05 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-19-65cb44d426a2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B9.50.07368.5614BC56; Tue, 13 Feb 2024 19:16:05 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101605epsmtip165df33a8a9ef77781a35ea03dc02cabb~zZKoJRh3q0107401074epsmtip1U;
	Tue, 13 Feb 2024 10:16:05 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 3/5] engines:xnvme: add support for end to end data
 protection
Date: Tue, 13 Feb 2024 21:03:13 +0530
Message-Id: <20240213153315.134202-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240213153315.134202-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7bCmlu4Vl9OpBp9XyVqsufKb3WL13X42
	i4+zXjBbbGgTdGDx2DnrLrvH5bOlHn1bVjF6fN4kF8ASlW2TkZqYklqkkJqXnJ+SmZduq+Qd
	HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RQSaEsMacUKBSQWFyspG9nU5RfWpKqkJFf
	XGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBgZApUmJCdsXdDdsHDkIqn7yeyNzCed+li5OSQ
	EDCRaLjymbmLkYtDSGA3o8T7C5PZQBJCAp8YJXbeUYdIfGOUuL9gJRtMx+VZh9kgEnsZJV5f
	+MUC4XQySaycNB2sik1AW+LV2xtAczk4RAQ0JNbcTQUJMwvYSVw9/BKsRFggQKJ9/jUWEJtF
	QFVi6bx2sDivgK3E053zWCGWyUvMvPSdHcTmBOrd+64FqkZQ4uTMJywQM+UlmrfOBntBQuAY
	u8SUA/9YIJpdJKa8esQIYQtLvDq+hR3ClpL4/G4v1DfZEpse/mSCsAskjrzoZYaw7SVaT/WD
	3c8soCmxfpc+RFhWYuqpdUwQe/kken8/gWrlldgxD8ZWlfh77zbUCdISN99dhbI9JPa3z4GG
	1URGibXTHzFPYFSYheSfWUj+mYWwegEj8ypGydSC4tz01GLTAsO81HJ4HCfn525iBCdBLc8d
	jHcffNA7xMjEwXiIUYKDWUmE99KME6lCvCmJlVWpRfnxRaU5qcWHGE2BAT6RWUo0OR+YhvNK
	4g1NLA1MzMzMTCyNzQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamDyuX6ApetxtK1ezOee
	u8xSfC8/mzj1+bcVm0btFej/v415r0DfkpqACLWHpqU6fkm1X3anX9fy1ZequsKqWz3lNou8
	cfDSigY93hvGQW3Rs5/Natxu9VG5/WmA3XGu/d9ajW4XfVmVYvI5eEJRw7EPx75X/7geEWd9
	4VjcRPdvq49+mrFvsnaYvKfEba7dwtffXl0at35WmvTKqx2n31v7fu6T4fP99r5A4at1c03R
	amMRhd8/5TnUPbUehIVNKv2sdOg2/2fG+/st0zi3Flyfuah7VnEfn/CMZsmt3Zmxc5ymGrY7
	2SyWa9tk89eMvd3rseRKO8/z+y6Wh+2pzZ/juHr1irksblUz1zu1/FNiKc5INNRiLipOBADu
	fKmbCwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnG6q4+lUg3UXTSzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MrYuyG74GFI
	xdP3E9kbGM+7dDFyckgImEhcnnWYrYuRi0NIYDejxIwri9m7GDmAEtISC9cnQtQIS6z895wd
	oqadSWJFz0kmkASbgLbEq7c3mEFsEQEtiWPrmthAbGYBB4l/u7aA2cICfhK7/r0Cq2ERUJVY
	Oq8dLM4rYCvxdOc8VogF8hIzL31nB7E5Bewk9r5rAasRAqq5MmU1O0S9oMTJmU9YIObLSzRv
	nc08gVFgFpLULCSpBYxMqxglUwuKc9Nzkw0LDPNSy/WKE3OLS/PS9ZLzczcxgsNUS2MH4735
	//QOMTJxMB5ilOBgVhLhvTTjRKoQb0piZVVqUX58UWlOavEhRmkOFiVxXsMZs1OEBNITS1Kz
	U1MLUotgskwcnFINTG+azhWfVn7zmXGHs2f0uTuHNr6q/uLVdENonwVbo8rfmps+cgaf2RyN
	xfWEY/ak7riwSuVqX+UFtxf3Pxt8Fm68L+1aclQt7vhN6f3/RHriBabPDLsWt3lW39Wn2jL6
	e56oMx9sX5a258Xxf1kbku9bzJYSjKp6/y3yz28/y0jvF2Jfde8IbTbbsbhqhV3Iso3zHbN9
	bdu6eF3u6sQs37NXzMzojHN8XrzH6awlk1zZQh6aWBwMf/p8x0fx6pPK5Ydvv+qat4ExntH9
	b9FEH4PMrwUOnoE7dS6fvSzy7alRYuoJH7XitY4hRobcz58Zf51YHXf/eth5nW18aQLyO9b2
	1ZzL7r1/YE0Uo3TUfiWW4oxEQy3mouJEAHtTuhnCAgAA
X-CMS-MailID: 20240213101606epcas5p25ae0cab4102c92c6e93133df182b8486
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101606epcas5p25ae0cab4102c92c6e93133df182b8486
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
	<CGME20240213101606epcas5p25ae0cab4102c92c6e93133df182b8486@epcas5p2.samsung.com>

This patch enables support for protection information to xnvme
ioengine.

This adds 4 new ioengine specific options
 * pi_act - Protection information action. Default: 1
 * pi_chk - Can be set to GUARD, APPTAG or REFTAG
 * apptag - Sets apptag field of command dword 15
 * apptag_mask - Sets apptag_mask field of command dword 15

For the sake of consistency these options are the same as the ones used
by io_uring_cmd ioengine and SPDK's external ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst       |   8 +--
 engines/xnvme.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++++
 fio.1           |   8 +--
 3 files changed, 153 insertions(+), 8 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 443a667c..f1a33e7f 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2495,7 +2495,7 @@ with the caveat that when used on the command line, they must come after the
 
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
diff --git a/engines/xnvme.c b/engines/xnvme.c
index da32678d..c726b805 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -67,6 +67,9 @@ struct xnvme_fioe_data {
 XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_data) == 64, "Incorrect size")
 
 struct xnvme_fioe_request {
+	/* Context for NVMe PI */
+	struct xnvme_pi_ctx pi_ctx;
+
 	/* Separate metadata buffer pointer */
 	void *md_buf;
 };
@@ -78,6 +81,10 @@ struct xnvme_fioe_options {
 	unsigned int xnvme_dev_nsid;
 	unsigned int xnvme_iovec;
 	unsigned int md_per_io_size;
+	unsigned int pi_act;
+	unsigned int apptag;
+	unsigned int apptag_mask;
+	unsigned int prchk;
 	char *xnvme_be;
 	char *xnvme_mem;
 	char *xnvme_async;
@@ -86,6 +93,20 @@ struct xnvme_fioe_options {
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
@@ -188,6 +209,46 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_XNVME,
 	},
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
@@ -198,6 +259,10 @@ static void cb_pool(struct xnvme_cmd_ctx *ctx, void *cb_arg)
 {
 	struct io_u *io_u = cb_arg;
 	struct xnvme_fioe_data *xd = io_u->mmap_data;
+	struct xnvme_fioe_request *fio_req = io_u->engine_data;
+	struct xnvme_fioe_fwrap *fwrap = &xd->files[io_u->file->fileno];
+	bool pi_act = (fio_req->pi_ctx.pi_flags >> 3);
+	int err;
 
 	if (xnvme_cmd_ctx_cpl_status(ctx)) {
 		xnvme_cmd_ctx_pr(ctx, XNVME_PR_DEF);
@@ -205,6 +270,15 @@ static void cb_pool(struct xnvme_cmd_ctx *ctx, void *cb_arg)
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
@@ -281,6 +355,7 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
 static int _dev_open(struct thread_data *td, struct fio_file *f)
 {
 	struct xnvme_opts opts = xnvme_opts_from_fioe(td);
+	struct xnvme_fioe_options *o = td->eo;
 	struct xnvme_fioe_data *xd = td->io_ops_data;
 	struct xnvme_fioe_fwrap *fwrap;
 	int flags = 0;
@@ -322,6 +397,20 @@ static int _dev_open(struct thread_data *td, struct fio_file *f)
 	else
 		fwrap->lba_pow2 = 1;
 
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
 	fwrap->fio_file = f;
 	fwrap->fio_file->filetype = FIO_TYPE_BLOCK;
 	fwrap->fio_file->real_file_size = fwrap->geo->tbytes;
@@ -585,6 +674,7 @@ static int xnvme_fioe_getevents(struct thread_data *td, unsigned int min, unsign
 static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct xnvme_fioe_data *xd = td->io_ops_data;
+	struct xnvme_fioe_options *o = td->eo;
 	struct xnvme_fioe_fwrap *fwrap;
 	struct xnvme_cmd_ctx *ctx;
 	struct xnvme_fioe_request *fio_req = io_u->engine_data;
@@ -637,6 +727,61 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
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
diff --git a/fio.1 b/fio.1
index 6066b9bf..0448db05 100644
--- a/fio.1
+++ b/fio.1
@@ -2254,7 +2254,7 @@ identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
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
-- 
2.25.1

