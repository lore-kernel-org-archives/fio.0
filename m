Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715EC12BE91
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995365; cv=none; b=cZF7GoEoopXMmgOR9MGQR2PmKZRPY2pAKOD66i/QSr0oqLT4NXqppzD/nf5tkOVYCjnVnD3yqsYt8oQEjhXypFFxd5dQCGCc0KWImxEYxn6PIo6cJw0EHgAXN7fM2Kx2/u8EAIV9/9R4Sdpj6qD/AazDbDoAc3muUTpF+Oq3tuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995365; c=relaxed/simple;
	bh=SMxRAhkxf0IxYXchTDHr3LOcaOiDgoHriQvY1rjeQf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=RI0/j2Rk6yT93wZw5Y/nUkSQSnfEzxoERBbfo7Yps+nkUEx5DQ8RQi/VWByTUtjUPvlOPcD038ezOhU5VADYI9RcTNRLvnz0a1lpeQHRVMKRVFioKqiZgI6fBQbShksQmc/s9wr+Exqm+eF22Wb3d8WschQvShxXbPfHDi/pWm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=s1uXV6gj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="s1uXV6gj"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240215110920epoutp028581e0dda9c3f1a4e49697b1a00a291d~0BLsb5PGO2024720247epoutp02U
	for <fio@vger.kernel.org>; Thu, 15 Feb 2024 11:09:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240215110920epoutp028581e0dda9c3f1a4e49697b1a00a291d~0BLsb5PGO2024720247epoutp02U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707995360;
	bh=K6rRUyxs2B2aCQEwO8ETakM8oxsHC0tP+9+K5MiHH7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s1uXV6gjbUB5dWki3BwGCshyu2IhByKXi9qG2tc2pNSo1Tb2LMi01JIHnEtuOpgG8
	 IOCH8qSQJIfL89cOiMcxlmEA5dT58/dpFEEp/2ILhdvWFftg5h7JHlY/qKdO0qjH+i
	 9T0GcvY6o/s9lPqabQsArcdRTfn5OD0a8+pHEbGc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240215110919epcas5p1c6024b431b41c5460f19edd148da2aa5~0BLrvsVA13044430444epcas5p1a;
	Thu, 15 Feb 2024 11:09:19 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4TbC4Y1zSlz4x9Pw; Thu, 15 Feb
	2024 11:09:17 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	ED.A3.08567.DD0FDC56; Thu, 15 Feb 2024 20:09:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240215100105epcas5p412e9121c4520e51a680464f62ee09bb0~0AQG2stcb2601326013epcas5p4h;
	Thu, 15 Feb 2024 10:01:05 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240215100105epsmtrp22d601392a55b0ce8d78eaf70431f7583~0AQG2GdpC1302013020epsmtrp2R;
	Thu, 15 Feb 2024 10:01:05 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-d2-65cdf0ddb143
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5C.2E.08817.1E0EDC56; Thu, 15 Feb 2024 19:01:05 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240215100104epsmtip275b237450a366d93ed0afea7bab4caee~0AQGCUFem2363023630epsmtip2q;
	Thu, 15 Feb 2024 10:01:04 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH v2 2/3] engines/nvme: pass offset and len instead of io_u
Date: Thu, 15 Feb 2024 20:48:11 +0530
Message-Id: <20240215151812.138370-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240215151812.138370-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmpu7dD2dTDRbN4bVYc+U3u8Xqu/1s
	Fh9nvWC2OPr/LZvFhjZBB1aPnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZ
	eem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFuVFMoSc0qBQgGJxcVK+nY2Rfml
	JakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZB/qnMxf8lq1Ys+IeYwPj
	FokuRk4OCQETiQcNc9lBbCGB3YwS8zeldTFyAdmfgOzVn1kgnG+MEssWLWCD6Zj/9DIjRMde
	RokFS4MgijqZJCafO8wKkmAT0JZ49fYGcxcjB4eIgIbEmrupIGFmgVCJ/pYOFhBbWMBT4vfl
	s0wgNouAqkTzzXnMIDavgK3EuaZ7zBC75CVmXvrODjKGU8BO4uv/HIgSQYmTM5+wQIyUl2je
	OpsZ5AQJgXPsErM6DzFB9LpIXF96HsoWlnh1fAs7hC0l8fndXqhfsiU2PfwJVVMgceRFL9Re
	e4nWU/1g5zMLaEqs36UPEZaVmHpqHRPEXj6J3t9PoFp5JXbMg7FVJf7eu80CYUtL3Hx3Fcr2
	kHhx+ygjJKgmMkp82TKPdQKjwiwk/8xC8s8shNULGJlXMUqmFhTnpqcmmxYY5qWWw6M4OT93
	EyM4GWq57GC8Mf+f3iFGJg7GQ4wSHMxKIryTes+kCvGmJFZWpRblxxeV5qQWH2I0BYb3RGYp
	0eR8YDrOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBSaMvcdu8
	ZxqCSktKU4P7Ox5/tnv+ZPVH7TeMFYcKckVs7GpcLnIuP6D5yNfNcPu9txdqfvCKMCxguZog
	O93kbfq0a26/lnyM6v1917ykUvqLZ6rOu1keGe2/+86e2MX0c6Yma9rMSSl7D3ZrlU2YfC+G
	NWfKsgJTCaF78T8tAosubW1+06/smtBvfzosNmPmZveEuauPcSddfNf6doJMm1/c+huPK1wS
	Yj4sL2l5Yd6oOj/7oOsJiVcNp6/FufJJXz2n1LH2wz/xpaUMjoZMvd3CDFOvdq9dpnpuictX
	lWUX/Sqzbqa4fEibEZZZMzF29efN0w0fOsdp97nYaO76FLBSomqPnGyAcXrrkXxbJZbijERD
	Leai4kQAC8YcrA8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvO7DB2dTDdomylmsufKb3WL13X42
	i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsErowD
	/dOZC37LVqxZcY+xgXGLRBcjJ4eEgInE/KeXGUFsIYHdjBJNEyO7GDmA4tISC9cnQpQIS6z8
	95y9i5ELqKSdSeJs/3R2kASbgLbEq7c3mEFsEQEtiWPrmthAbGaBcInG2c/BaoQFPCV+Xz7L
	BGKzCKhKNN+cB1bPK2Arca7pHjPEAnmJmZe+s4Ps5RSwk/j6PwfiHFuJb99nsEKUC0qcnPmE
	BWK8vETz1tnMExgFZiFJzUKSWsDItIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzhc
	tbR2MO5Z9UHvECMTB+MhRgkOZiUR3km9Z1KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83573Zsi
	JJCeWJKanZpakFoEk2Xi4JRqYJq9/Tan0LYjlepcLKu6N/7uY3X+2Xy/LFvggdLnKQ8Ofitz
	njctXJKhw1T/mdbhetkHhSzMObzT5yVdfs90mzOh5bWaj9BpX6fpDhu8Ziuk+qVFeicJnn9a
	WlxU9/5iYMyOxVcWtvb9Oy46aT+3MMfDefO+qMcV/v/AkHuiQm1GdKOJxMOYfZ9SLrjHrude
	7cKtyW9hse6wR1Ak820G852rOuw5zhxWa6k8Jz+nUHNCIs8NI35LEd+9PZ3HGPenObiteLVU
	baurzGLuCyfv1h60NJqxJlAyaMmyUNfXvad+OyacLJR5ph0cJHZ9yrHVHeL2kmkNEtppcWdC
	fCerZPtbTQhbVHtxc9Tep/v4lFiKMxINtZiLihMBw2n8SMYCAAA=
X-CMS-MailID: 20240215100105epcas5p412e9121c4520e51a680464f62ee09bb0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240215100105epcas5p412e9121c4520e51a680464f62ee09bb0
References: <20240215151812.138370-1-ankit.kumar@samsung.com>
	<CGME20240215100105epcas5p412e9121c4520e51a680464f62ee09bb0@epcas5p4.samsung.com>

Remove io_u dependency while calculating start and number of lba.
This is a prep patch for multi-range trim support where an io_u entry
will contain multiple start offset and buffer len.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index 75a5e0c1..1933b9c8 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -8,20 +8,20 @@
 #include "../crc/crc-t10dif.h"
 #include "../crc/crc64.h"
 
-static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
+static inline __u64 get_slba(struct nvme_data *data, __u64 offset)
 {
 	if (data->lba_ext)
-		return io_u->offset / data->lba_ext;
-	else
-		return io_u->offset >> data->lba_shift;
+		return offset / data->lba_ext;
+
+	return offset >> data->lba_shift;
 }
 
-static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
+static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
 {
 	if (data->lba_ext)
-		return io_u->xfer_buflen / data->lba_ext - 1;
-	else
-		return (io_u->xfer_buflen >> data->lba_shift) - 1;
+		return len / data->lba_ext - 1;
+
+	return (len >> data->lba_shift) - 1;
 }
 
 static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
@@ -32,8 +32,8 @@ static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
 	struct nvme_16b_guard_pif *pi;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 guard = 0;
 
@@ -99,8 +99,8 @@ static int fio_nvme_verify_pi_16b_guard(struct nvme_data *data,
 	struct fio_file *f = io_u->file;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 unmask_app, unmask_app_exp, guard = 0;
 
@@ -185,8 +185,8 @@ static void fio_nvme_generate_pi_64b_guard(struct nvme_data *data,
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
 	uint64_t guard = 0;
-	__u64 slba = get_slba(data, io_u);
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u64 slba = get_slba(data, io_u->offset);
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 
 	if (data->pi_loc) {
@@ -251,9 +251,9 @@ static int fio_nvme_verify_pi_64b_guard(struct nvme_data *data,
 	struct fio_file *f = io_u->file;
 	unsigned char *buf = io_u->xfer_buf;
 	unsigned char *md_buf = io_u->mmap_data;
-	__u64 slba = get_slba(data, io_u);
+	__u64 slba = get_slba(data, io_u->offset);
 	__u64 ref, ref_exp, guard = 0;
-	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 nlb = get_nlb(data, io_u->xfer_buflen) + 1;
 	__u32 lba_num = 0;
 	__u16 unmask_app, unmask_app_exp;
 
@@ -368,8 +368,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		return -ENOTSUP;
 	}
 
-	slba = get_slba(data, io_u);
-	nlb = get_nlb(data, io_u);
+	slba = get_slba(data, io_u->offset);
+	nlb = get_nlb(data, io_u->xfer_buflen);
 
 	/* cdw10 and cdw11 represent starting lba */
 	cmd->cdw10 = slba & 0xffffffff;
@@ -400,7 +400,7 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	__u64 slba;
 
-	slba = get_slba(data, io_u);
+	slba = get_slba(data, io_u->offset);
 	cmd->cdw12 |= opts->io_flags;
 
 	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
-- 
2.25.1

