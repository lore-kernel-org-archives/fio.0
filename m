Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257BB2BB03
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707821879; cv=none; b=Ose/TpwxeqDcbAG3pS+A601mmcoRnhJVOCSjkJmr9jzggV95SWYOYDLqeCgIjsP9pvYuzDalEfUKKHb7qyr00CPlQe2tR3qWf2YfIBKIyystexq5YY6D8IYzprLkS8boKiVVVjGu9G5CdVRlgEfU1dCyY8iQmTVZBznzcLYtPBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707821879; c=relaxed/simple;
	bh=4CeHD1VYkJjIBUzWUdKoDpdKKrhvxFEvueH+Fqk47wA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=dL2M23Nrs/h4u7V/RinEHTBQJU9vLz/b7tg07aIxcF6dk/hEnqjJsMNogDvGlRRyDM1VBnINhG75rLyF4ZVflgHic3pOfhCvSyBa/v33ZC3Ic3jmvAkFKM1xdGwMbp7OC0Y/sHFq6f/PUIlopMofroIdquyUU2x+bWGNZJJRto4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n7vk1AO2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n7vk1AO2"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240213105747epoutp013c5cb1df0a02ed756de33b17e7565b2a~zZvC4dgJZ2786927869epoutp01h
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 10:57:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240213105747epoutp013c5cb1df0a02ed756de33b17e7565b2a~zZvC4dgJZ2786927869epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707821867;
	bh=xDGb3blHMuyGxjP07Aw93uw5CUNnDmFHHW5qmYl4xzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7vk1AO22v3zqPqoc5lKqr7KB7e8xvD2ikxH7m8AtQkv5h+x+GZApsFDpx7oNoVzT
	 Xy6KYlwlY978t8s1O+rqbrt/QZS/5zaCJsT55ZIDJ7tsCrmpEaDAsVBub8yA3sam6k
	 amTOCYBATOu0+SP9B3AWhYEp03j5/F3c1wybvfrg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240213105746epcas5p2f483bc927251ec2f8c5d0c476a816ca6~zZvB9gJRC1671616716epcas5p2m;
	Tue, 13 Feb 2024 10:57:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TYyw92GYJz4x9Px; Tue, 13 Feb
	2024 10:57:45 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	E3.E7.09634.62B4BC56; Tue, 13 Feb 2024 19:57:42 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101605epcas5p14343583c58b749d8f6d66b219aabaf4e~zZKoBE-4o3072430724epcas5p1X;
	Tue, 13 Feb 2024 10:16:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240213101605epsmtrp17451511a1ef6b937bf8edab93c2ff2bf~zZKoAb6xU0831308313epsmtrp1v;
	Tue, 13 Feb 2024 10:16:05 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-e5-65cb4b2611fc
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FD.AE.08817.4614BC56; Tue, 13 Feb 2024 19:16:04 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240213101604epsmtip1b655cb31aba31f0a2b32512cbdfb1088~zZKnT-17X0104501045epsmtip1h;
	Tue, 13 Feb 2024 10:16:04 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 2/5] engines/xnvme: add support for metadata
Date: Tue, 13 Feb 2024 21:03:12 +0530
Message-Id: <20240213153315.134202-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240213153315.134202-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7bCmuq6a9+lUg5ez9CzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
	jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
	LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOOLanh6lgpXPFj63dLA2Mz0y7GDk4
	JARMJDpmGnQxcnEICexmlLi3fjojhPOJUeL0rhmsEM43Rol3G9aydTFygnUcutPJDJHYyyjx
	+v8vdgink0li4d6LzCBVbALaEq/e3mAG2SEioCGx5m4qSJhZwE7i6uGXYIOEBWwk/t7dxApi
	swioSixd18kEUs4rYCvx7G0cxC55iZmXvrOD2JxArXvftYC18goISpyc+YQFYqS8RPPW2WD3
	SAicYpdoff2bFaLZRWLmyeNQRwtLvDq+hR3ClpJ42d8GZWdLbHr4kwnCLpA48qKXGcK2l2g9
	1Q92PrOApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtV4u+92ywQtrTEzXdXoWwPiX/r
	foGdIyQwkVHizyzvCYwKs5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCYl1oOj+Lk/NxNjOAU
	qOW5g/Hugw96hxiZOBgPMUpwMCuJ8F6acSJViDclsbIqtSg/vqg0J7X4EKMpMLgnMkuJJucD
	k3BeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1MGe3i3nfMTkz1
	Ujx/efqPHwZ8U4zsnmZbzNu9UpqBTd82pm+jR/nj1uv637XcD8iWN3hu3mN8tkDO+s8fq8mC
	T/K6jJgPxd07n2G2Ld4s6NGGF775aW0fRfbe73ZfH7eaQSjgaEpJ4+m//FyXNjCa2yyOFf0y
	fa2QRcL/5ZfO50xYEmg74fuMu+wb+bOOnTjDKMfkzXe+QuRMxvlCfzM1RQOZll+39C5welt+
	YBT9nfV2hXqzS2TCstargvPX5lRl/WlZtGUHv0io9IyLlgly8j9U+bhusZzx27A0Ubbn7j2u
	iY9V/tVIfBXNYKxe+cm63utOn0HdWR0nU4ZJyY+OZyarLzu6t7zkh6/Uz0YlluKMREMt5qLi
	RADRssUxCgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWy7bCSnG6K4+lUg7/vrCzWXPnNbrH6bj+b
	xcdZL5gtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4tqeHqWCl
	c8WPrd0sDYzPTLsYOTkkBEwkDt3pZO5i5OIQEtjNKPFpy30ghwMoIS2xcH0iRI2wxMp/z9kh
	atqZJH4uWMAIkmAT0JZ49fYGM4gtIqAlcWxdExuIzSzgIPFv1xYwW1jARuLv3U2sIDaLgKrE
	0nWdTCDzeQVsJZ69jYOYLy8x89J3dhCbU8BOYu+7FrBWIaCSK1NWg8V5BQQlTs58wgIxXl6i
	eets5gmMArOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcplpaOxj3
	rPqgd4iRiYPxEKMEB7OSCO+lGSdShXhTEiurUovy44tKc1KLDzFKc7AoifN+e92bIiSQnliS
	mp2aWpBaBJNl4uCUamAq8PBbuS2d4WXUAsvrc1S4i/7aMAlP7+L9a1596nnD8p9v5n30+np5
	6aWXVzwvNutcOqltezBp/XFnoxXrGeSrylqKki80fBE4/HLjvlt+VX0bskyXpmdxeb122K6/
	VpwlwrW7SfPQy2TtvKQti9xeSHw9P5Vrf/HH2a4u1tskNA+lq+6Z1q3xJnvK08trtST5F0t+
	3V9yViv7BMsS7S9zJqxwFL3vwS0u1z7XPWpnyUxN3UIPJ+VHD1WYPzgUZ5oXvF0U8yrKpztE
	glmJ7dE/iReiK5029i0IvZ07Q8t3KtPdzeFhPvMU5t7Jrppx+d9vxlNzn/GsN/3u+/fren+5
	X2fcpqTcf/HoqUu80Ww5JZbijERDLeai4kQApzUxscICAAA=
X-CMS-MailID: 20240213101605epcas5p14343583c58b749d8f6d66b219aabaf4e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240213101605epcas5p14343583c58b749d8f6d66b219aabaf4e
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
	<CGME20240213101605epcas5p14343583c58b749d8f6d66b219aabaf4e@epcas5p1.samsung.com>

This enables support for separate metadata buffers with xnvme ioengine.
This is done by providing xnvme specific option md_per_io_size, which
for the sake of consistency is the same option used by io_uring_cmd
engine and SPDK's external ioengine.

Bump up the required xnvme support to v0.7.4

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst       |   2 +-
 configure       |   2 +-
 engines/xnvme.c | 122 +++++++++++++++++++++++++++++++++++++++++++-----
 fio.1           |   2 +-
 4 files changed, 114 insertions(+), 14 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 53b03021..443a667c 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2491,7 +2491,7 @@ with the caveat that when used on the command line, they must come after the
         want fio to use placement identifier only at indices 0, 2 and 5 specify
         ``fdp_pli=0,2,5``.
 
-.. option:: md_per_io_size=int : [io_uring_cmd]
+.. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
 	Size in bytes for separate metadata buffer per IO. Default: 0.
 
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
index 88bbba4e..da32678d 100644
--- a/engines/xnvme.c
+++ b/engines/xnvme.c
@@ -30,8 +30,10 @@ struct xnvme_fioe_fwrap {
 
 	uint32_t ssw;
 	uint32_t lba_nbytes;
+	uint32_t md_nbytes;
+	uint32_t lba_pow2;
 
-	uint8_t _pad[24];
+	uint8_t _pad[16];
 };
 XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_fwrap) == 64, "Incorrect size")
 
@@ -58,19 +60,24 @@ struct xnvme_fioe_data {
 	uint64_t nallocated;
 
 	struct iovec *iovec;
-
-	uint8_t _pad[8];
+	struct iovec *md_iovec;
 
 	struct xnvme_fioe_fwrap files[];
 };
 XNVME_STATIC_ASSERT(sizeof(struct xnvme_fioe_data) == 64, "Incorrect size")
 
+struct xnvme_fioe_request {
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
 	char *xnvme_be;
 	char *xnvme_mem;
 	char *xnvme_async;
@@ -171,6 +178,16 @@ static struct fio_option options[] = {
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
 
 	{
 		.name = NULL,
@@ -249,6 +266,7 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
 
 	free(xd->iocq);
 	free(xd->iovec);
+	free(xd->md_iovec);
 	free(xd);
 	td->io_ops_data = NULL;
 }
@@ -297,6 +315,12 @@ static int _dev_open(struct thread_data *td, struct fio_file *f)
 
 	fwrap->ssw = xnvme_dev_get_ssw(fwrap->dev);
 	fwrap->lba_nbytes = fwrap->geo->lba_nbytes;
+	fwrap->md_nbytes = fwrap->geo->nbytes_oob;
+
+	if (fwrap->geo->lba_extended)
+		fwrap->lba_pow2 = 0;
+	else
+		fwrap->lba_pow2 = 1;
 
 	fwrap->fio_file = f;
 	fwrap->fio_file->filetype = FIO_TYPE_BLOCK;
@@ -358,6 +382,17 @@ static int xnvme_fioe_init(struct thread_data *td)
 		}
 	}
 
+	if (o->xnvme_iovec && o->md_per_io_size) {
+		xd->md_iovec = calloc(td->o.iodepth, sizeof(*xd->md_iovec));
+		if (!xd->md_iovec) {
+			free(xd->iocq);
+			free(xd->iovec);
+			free(xd);
+			log_err("ioeng->init(): !calloc(xd->md_iovec), err(%d)\n", errno);
+			return 1;
+		}
+	}
+
 	xd->prev = -1;
 	td->io_ops_data = xd;
 
@@ -365,8 +400,8 @@ static int xnvme_fioe_init(struct thread_data *td)
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
@@ -421,13 +456,61 @@ static void xnvme_fioe_iomem_free(struct thread_data *td)
 
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
 
@@ -504,6 +587,7 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
 	struct xnvme_fioe_data *xd = td->io_ops_data;
 	struct xnvme_fioe_fwrap *fwrap;
 	struct xnvme_cmd_ctx *ctx;
+	struct xnvme_fioe_request *fio_req = io_u->engine_data;
 	uint32_t nsid;
 	uint64_t slba;
 	uint16_t nlb;
@@ -516,8 +600,13 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
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
@@ -551,11 +640,22 @@ static enum fio_q_status xnvme_fioe_queue(struct thread_data *td, struct io_u *i
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
diff --git a/fio.1 b/fio.1
index 227fcb47..6066b9bf 100644
--- a/fio.1
+++ b/fio.1
@@ -2251,7 +2251,7 @@ By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
 identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .TP
-.BI (io_uring_cmd)md_per_io_size \fR=\fPint
+.BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
 .TP
 .BI (io_uring_cmd)pi_act \fR=\fPint
-- 
2.25.1

