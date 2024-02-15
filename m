Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A88912A14D
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995368; cv=none; b=CpwXUT8gl3qkgbUMg9LCgMZGIAuSPV2jwS7BN3iRiqj/wfBS9WH0iJcUaYjMSY5bX9XWkM75d5jViFBZPgje95G9cdWE1OywFBFumByOa1ntlsdS+N6cDRqBnbUB6hyfuQoZsVnwfBtso8efqO2f44647aAEFqAGiLxtqPBpJ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995368; c=relaxed/simple;
	bh=YyRTWOF8y67SHW/ecgJtQIspCFj++bwTJhNJaoGAgwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Za9rFIb4hRuqa/iOqDItosCUyDncZSAH1GOQxybGWYLdOZ7hInlEd7QUlUIKp/ZNHfjnN1Fv2IeOjkY3Nr24pxyo9oaQkU40vi+k3wj/+GbdjWei0L6LL2DVpfMKScQXEF+AL27b5wqGVXBzxOzoMZg/6U0vwrfXHdLPCK6gU1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qS2xPxv3; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qS2xPxv3"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240215110923epoutp030caceee41ffa7d41971a5c181ef92c40~0BLvPIhsx2486824868epoutp03U
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240215110923epoutp030caceee41ffa7d41971a5c181ef92c40~0BLvPIhsx2486824868epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707995363;
	bh=1LCN8Id33QNZUePr6QxdZK39YAkX/JgES4d+pzR9Qh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qS2xPxv3+SBSUZN6w3ToSEtYdgVR9OCAmLuk8v6ym22+b8hU/kZING+5Mb+GJoWpM
	 OAGjPIuykJpG0hqcZeO3i4WstzhkCOOZnGAdLOhgCt/LB/Hc/A3F3R+Zwa/Xc/gmpy
	 ICCr6RPaYdnoCMjopwLEOvNGOvBEfTF17hh0SHEg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240215110922epcas5p4a8014005d52646f8728f667e6f14a7d5~0BLu33_Ki2634026340epcas5p4B;
	Thu, 15 Feb 2024 11:09:22 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TbC4d0sD5z4x9Pp; Thu, 15 Feb
	2024 11:09:21 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5C.74.09672.0E0FDC56; Thu, 15 Feb 2024 20:09:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240215100106epcas5p2c755350dbd4dd81e04ab0d62bb8c2370~0AQH2YTFA1413114131epcas5p2y;
	Thu, 15 Feb 2024 10:01:06 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240215100106epsmtrp19fd0ba5959394e6c1747031790700798~0AQH1QoYr0893808938epsmtrp1b;
	Thu, 15 Feb 2024 10:01:06 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-f9-65cdf0e05680
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4B.A0.07368.2E0EDC56; Thu, 15 Feb 2024 19:01:06 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240215100105epsmtip2f00a8dc407b481f3dd744d2de1255785~0AQG-Y9sv2362323623epsmtip2x;
	Thu, 15 Feb 2024 10:01:05 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH v2 3/3] engines/io_uring: add multi range dsm support
Date: Thu, 15 Feb 2024 20:48:12 +0530
Message-Id: <20240215151812.138370-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240215151812.138370-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmlu7DD2dTDU4/YLZYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
	JakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZnR9msxc8M6rY9P0+awPj
	FY0uRk4OCQETifat85i6GLk4hAR2M0ps6PnMCuF8YpT4cKWPCaRKSOAbo8T7Bl6YjrsHbrFC
	xPcySlyd7wLR0MkkcfX8anaQBJuAtsSrtzeYuxg5OEQENCTW3E0FCTMLhEr0t3SwgNjCAq4S
	XRu2gdksAqoS7b0rwWxeAVuJSaunsUPskpeYeek7O8gYTgE7ia//cyBKBCVOznzCAjFSXqJ5
	62xmkBMkBC6xSxz8vguq10Xiz6lbULawxKvjW6BsKYmX/W1QdrbEpoc/mSDsAokjL3qZIWx7
	idZT/WDnMwtoSqzfpQ8RlpWYemodE8RePone30+gWnkldsyDsVUl/t67zQJhS0vcfHcVyvaQ
	mP2siw0SbBMZJdb2CU9gVJiF5J1ZSN6ZhbB5ASPzKkbJ1ILi3PTUYtMC47zUcngMJ+fnbmIE
	p0It7x2Mjx580DvEyMTBeIhRgoNZSYR3Uu+ZVCHelMTKqtSi/Pii0pzU4kOMpsDgnsgsJZqc
	D0zGeSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MOka7WnnCZro
	Nd9pmaDWA8MjDmrf5Fx6txyJfeT2+fGyBr5Le/L/Hb0WLfJckdVa4e2+yPKtcwUPbmY90HLu
	p5WJ1MTuL5XbMp+3fNm5f7eXs9J1s/ge56vt29K+iL53Lz69a1Hrm0nv86R5SjVNpX9fj/j9
	PLR3Wk+RM2tNnWd45JP5By/FVlawll77Mz/owR9JNqnzP2xbanX6+m98L202klT3rwo2Lv0e
	drgh7O/kecw+ORa3VR+K3eVV/RIcwri37FlYms5L6bhPrMxsRYs6MtYXJCyY38Jz1sz6yZs5
	SjMnMr9JMVprYpOjqmbg/Tb2/tVb5VuupEocP757udjxNUxbWpc3qStL/njUrMRSnJFoqMVc
	VJwIALstUTwOBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsWy7bCSvO6jB2dTDa5NUbBYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmd
	H2azFzwzqtj0/T5rA+MVjS5GTg4JAROJuwdusXYxcnEICexmlDgwbS1zFyMHUEJaYuH6RIga
	YYmV/56zQ9S0M0lsbf7FCJJgE9CWePX2BjOILSKgJXFsXRMbiM0sEC7ROBukgZNDWMBVomvD
	NhYQm0VAVaK9dyWYzStgKzFp9TR2iAXyEjMvfWcH2cspYCfx9X8OSFgIqOTb9xmsEOWCEidn
	PmGBGC8v0bx1NvMERoFZSFKzkKQWMDKtYpRMLSjOTc9NNiwwzEst1ytOzC0uzUvXS87P3cQI
	DlgtjR2M9+b/0zvEyMTBeIhRgoNZSYR3Uu+ZVCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8hjNm
	pwgJpCeWpGanphakFsFkmTg4pRqYpNdc758coLc8JfLNwaemyq+9OMqVdp92K907exaP/1/r
	BwJ/e9t0NU85pRUqStxZYPd8hvd8ZY0XQsk9t1pvO5xi0U2cdVnKlrP+xT55m/tvFPv5FvjJ
	SJxjnl7yfXLgNsEP5d1OXNNZFr2WbLpxJfWg0AHjhE8BM7kKpPhO7Nir1s5Xay7YwvXed/1W
	2aCNr+wT/RaoZ9fJ3pPPKzPzidX77zRxQVuFcHsr/6kKrvb585teX2mYW79kid9pwebYh4+N
	WpmW2+RP3fFzQmf0QYZsjkNtu81m3rls9UHeO4tvY2s4v16zzeWwWYfzH+l9uyi9923Vawtf
	pfllPnNFBdbnFnh72WQJO12LYVNiKc5INNRiLipOBABJgZsqxwIAAA==
X-CMS-MailID: 20240215100106epcas5p2c755350dbd4dd81e04ab0d62bb8c2370
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240215100106epcas5p2c755350dbd4dd81e04ab0d62bb8c2370
References: <20240215151812.138370-1-ankit.kumar@samsung.com>
	<CGME20240215100106epcas5p2c755350dbd4dd81e04ab0d62bb8c2370@epcas5p2.samsung.com>

Update the io_uring_cmd ioengine to support multiple ranges for trim.
This includes allocating buffer for multiple ranges, and changes to
the nvme trim helper functions.
Add an example on how to use multi range trim.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c                      | 34 ++++++++++++++++++++-----
 engines/nvme.c                          | 34 ++++++++++++++++++-------
 engines/nvme.h                          |  7 ++++-
 examples/uring-cmd-trim-multi-range.fio | 21 +++++++++++++++
 4 files changed, 79 insertions(+), 17 deletions(-)
 create mode 100644 examples/uring-cmd-trim-multi-range.fio

diff --git a/engines/io_uring.c b/engines/io_uring.c
index c0cb5a78..9069fa3e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -81,7 +81,7 @@ struct ioring_data {
 
 	struct cmdprio cmdprio;
 
-	struct nvme_dsm_range *dsm;
+	struct nvme_dsm *dsm;
 };
 
 struct ioring_options {
@@ -385,6 +385,9 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	struct nvme_uring_cmd *cmd;
 	struct io_uring_sqe *sqe;
+	struct nvme_dsm *dsm;
+	void *ptr = ld->dsm;
+	unsigned int dsm_size;
 
 	/* only supports nvme_uring_cmd */
 	if (o->cmd_type != FIO_URING_CMD_NVME)
@@ -423,9 +426,13 @@ static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	cmd = (struct nvme_uring_cmd *)sqe->cmd;
+	dsm_size = sizeof(*ld->dsm) + td->o.num_range * sizeof(struct nvme_dsm_range);
+	ptr += io_u->index * dsm_size;
+	dsm = (struct nvme_dsm *)ptr;
+
 	return fio_nvme_uring_cmd_prep(cmd, io_u,
 			o->nonvectored ? NULL : &ld->iovecs[io_u->index],
-			&ld->dsm[io_u->index]);
+			dsm);
 }
 
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
@@ -1133,8 +1140,11 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
+	struct nvme_dsm *dsm;
+	void *ptr;
+	unsigned int dsm_size;
 	unsigned long long md_size;
-	int ret;
+	int ret, i;
 
 	/* sqthread submission requires registered files */
 	if (o->sqpoll_thread)
@@ -1195,10 +1205,19 @@ static int fio_ioring_init(struct thread_data *td)
 	 * in zbd mode where trim means zone reset.
 	 */
 	if (!strcmp(td->io_ops->name, "io_uring_cmd") && td_trim(td) &&
-	    td->o.zone_mode == ZONE_MODE_ZBD)
+	    td->o.zone_mode == ZONE_MODE_ZBD) {
 		td->io_ops->flags |= FIO_ASYNCIO_SYNC_TRIM;
-	else
-		ld->dsm = calloc(td->o.iodepth, sizeof(*ld->dsm));
+	} else {
+		dsm_size = sizeof(*ld->dsm) +
+			td->o.num_range * sizeof(struct nvme_dsm_range);
+		ld->dsm = calloc(td->o.iodepth, dsm_size);
+		ptr = ld->dsm;
+		for (i = 0; i < td->o.iodepth; i++) {
+			dsm = (struct nvme_dsm *)ptr;
+			dsm->nr_ranges = td->o.num_range;
+			ptr += dsm_size;
+		}
+	}
 
 	return 0;
 }
@@ -1466,7 +1485,8 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.name			= "io_uring_cmd",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO |
-					FIO_ASYNCIO_SETS_ISSUE_TIME,
+					FIO_ASYNCIO_SETS_ISSUE_TIME |
+					FIO_MULTI_RANGE_TRIM,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/engines/nvme.c b/engines/nvme.c
index 1933b9c8..c6629e86 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -329,24 +329,40 @@ next:
 	return 0;
 }
 void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-				  struct nvme_dsm_range *dsm)
+				  struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+	struct trim_range *range;
+	uint8_t *buf_point;
+	int i;
 
 	cmd->opcode = nvme_cmd_dsm;
 	cmd->nsid = data->nsid;
-	cmd->cdw10 = 0;
 	cmd->cdw11 = NVME_ATTRIBUTE_DEALLOCATE;
-	cmd->addr = (__u64) (uintptr_t) dsm;
-	cmd->data_len = sizeof(*dsm);
-
-	dsm->slba = get_slba(data, io_u);
-	/* nlb is a 1-based value for deallocate */
-	dsm->nlb = get_nlb(data, io_u) + 1;
+	cmd->addr = (__u64) (uintptr_t) (&dsm->range[0]);
+
+	if (dsm->nr_ranges == 1) {
+		dsm->range[0].slba = get_slba(data, io_u->offset);
+		/* nlb is a 1-based value for deallocate */
+		dsm->range[0].nlb = get_nlb(data, io_u->xfer_buflen) + 1;
+		cmd->cdw10 = 0;
+		cmd->data_len = sizeof(struct nvme_dsm_range);
+	} else {
+		buf_point = io_u->xfer_buf;
+		for (i = 0; i < io_u->number_trim; i++) {
+			range = (struct trim_range *)buf_point;
+			dsm->range[i].slba = get_slba(data, range->start);
+			/* nlb is a 1-based value for deallocate */
+			dsm->range[i].nlb = get_nlb(data, range->len) + 1;
+			buf_point += sizeof(struct trim_range);
+		}
+		cmd->cdw10 = io_u->number_trim - 1;
+		cmd->data_len = io_u->number_trim * sizeof(struct nvme_dsm_range);
+	}
 }
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm_range *dsm)
+			    struct iovec *iov, struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
diff --git a/engines/nvme.h b/engines/nvme.h
index 792b35d8..2d5204fc 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -408,6 +408,11 @@ struct nvme_dsm_range {
 	__le64	slba;
 };
 
+struct nvme_dsm {
+	__u32 nr_ranges;
+	struct nvme_dsm_range range[];
+};
+
 struct nvme_cmd_ext_io_opts {
 	__u32 io_flags;
 	__u16 apptag;
@@ -421,7 +426,7 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, __u32 pi_act,
 		      struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-			    struct iovec *iov, struct nvme_dsm_range *dsm);
+			    struct iovec *iov, struct nvme_dsm *dsm);
 
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
diff --git a/examples/uring-cmd-trim-multi-range.fio b/examples/uring-cmd-trim-multi-range.fio
new file mode 100644
index 00000000..b376481b
--- /dev/null
+++ b/examples/uring-cmd-trim-multi-range.fio
@@ -0,0 +1,21 @@
+# Multi-range trim command test with io_uring_cmd I/O engine for nvme-ns
+# generic character device.
+#
+[global]
+filename=/dev/ng0n1
+ioengine=io_uring_cmd
+cmd_type=nvme
+size=10M
+iodepth=32
+thread=1
+stonewall=1
+
+[write_bs]
+bs=4096
+rw=randtrim
+num_range=8
+
+[write_bssplit]
+bssplit=4k/10:64k/50:32k/40
+rw=trim
+num_range=8
-- 
2.25.1

