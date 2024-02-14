Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D704125A6
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707893969; cv=none; b=P0uXDHlMxodjh0uTvDWJkGeS4gPLsQgBT9RgvxQVarTMe+hqw1pauIEMHEylsCxHO64Ajj3FCCQnCf91Xr1xO0rY88Awbz48h0S+C97pqxzztXZz0eQKCDtFjRYg6HzJ8MaouKOPld/z7Ph5sI6n/tfHJSXGVnVKGhryCy5i0eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707893969; c=relaxed/simple;
	bh=qV5PwwV/ahPe22GeDq0ozBvbW1/erG10dTQfbYQMjn8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uhyBp5MwfJNyRPnBFGPCE5Au/1UX5l3OY/PeWQvJcR2T2DsH7cUtX7DTJtxJh9CHShlymIi+nrJKZ7efmkMCSUS+crzI9qak6UlJz9KjZgJHipgNGWJF6NZmmUASume9tFIRzxlDUCvsr8oyVAs42SqHVV3bmAwpdb4fIr2DQIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fWQQ59Si; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fWQQ59Si"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240214065924epoutp02a0dc3c4bdbbf8d42a72e6192c631a0fb~zqIMj6ylM0219502195epoutp02C
	for <fio@vger.kernel.org>; Wed, 14 Feb 2024 06:59:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240214065924epoutp02a0dc3c4bdbbf8d42a72e6192c631a0fb~zqIMj6ylM0219502195epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1707893964;
	bh=ky9/JWgyFVDmh7db3t+8cDPGOhxuNXk8Nc0W02LKGuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWQQ59SiiCDTMJdgK6HRy8L/kc+Vc0UKl107kne/Krs4Z9YzKaalpQTFjsb9Q2r2f
	 wkcOB8FYjX39alVuOOGMQx4UICOmrfYLYJL8mgdyQ4TAauvP6yV8JOB9MgxKlwE6fW
	 k/DmwbVL1VwSwZNz0bmJFAQUuieZTtBjEu4Uq4yw=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240214065924epcas5p433af28b38538eed39aacfe689858bd90~zqIL5UldR1698216982epcas5p4y;
	Wed, 14 Feb 2024 06:59:24 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4TZTZf68CWz4x9Q1; Wed, 14 Feb
	2024 06:59:22 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	72.79.08567.9C46CC56; Wed, 14 Feb 2024 15:59:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240214064926epcas5p29dcccdd0abe0e0ffb75c64835ec6a01a~zp-e6iI-r0114901149epcas5p2A;
	Wed, 14 Feb 2024 06:49:26 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240214064926epsmtrp2cf58396e94cfc9fecba0e9e15006600c~zp-e5-dEN2841428414epsmtrp2h;
	Wed, 14 Feb 2024 06:49:26 +0000 (GMT)
X-AuditID: b6c32a44-3abff70000002177-ac-65cc64c92504
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	AA.73.18939.6726CC56; Wed, 14 Feb 2024 15:49:26 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
	[107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240214064925epsmtip155bdca954bfa7e19cfb301cf39e997ed~zp-eFq7Z40466504665epsmtip1K;
	Wed, 14 Feb 2024 06:49:25 +0000 (GMT)
From: Ankit Kumar <ankit.kumar@samsung.com>
To: axboe@kernel.dk, vincentfu@gmail.com
Cc: fio@vger.kernel.org, joshi.k@samsung.com, Ankit Kumar
	<ankit.kumar@samsung.com>
Subject: [PATCH 2/3] engines/nvme: pass offset and len instead of io_u
Date: Wed, 14 Feb 2024 17:36:23 +0530
Message-Id: <20240214120624.135416-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240214120624.135416-1-ankit.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmhu7JlDOpBmt/6FusufKb3WL13X42
	i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
	vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
	klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMN5t+shd8lq349i2zgXGN
	RBcjJ4eEgInE7Z4W1i5GLg4hgd2MEhcu7GKHcD4xSixct5sNzpnb0cMG07JubTsjRGIno0Tj
	vz5mCKeTSeL5zJXsIFVsAtoSr97eAEpwcIgIaEisuZsKEmYWCJXob+lgAbGFBdwkvix/CzaU
	RUBVouXNayYQm1fAVuLkg2WMEMvkJWZe+g42klPATuLKzv/sEDWCEidnPmGBmCkv0bx1NtgN
	EgLH2CWO3F/HCtHsIvHhzj9mCFtY4tXxLewQtpTE53d7ob7Jltj08CcThF0gceRFL1S9vUTr
	qX6w+5kFNCXW79KHCMtKTD21jgliL59E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67CmV7SBw/
	/IUFElYTGSVONH9gnMCoMAvJP7OQ/DMLYfUCRuZVjJKpBcW56anJpgWGeanl8EhOzs/dxAhO
	iFouOxhvzP+nd4iRiYPxEKMEB7OSCO+lGSdShXhTEiurUovy44tKc1KLDzGaAgN8IrOUaHI+
	MCXnlcQbmlgamJiZmZlYGpsZKonzvm6dmyIkkJ5YkpqdmlqQWgTTx8TBKdXAJFu09PhUvSK/
	FzYcEXYHt58uqrr39lRdzrFDOU3nbQ689l4e+vDW4hL9kmMh9+YzHmhlnsD/eZmiVMlrUYEn
	EUsUb29bp3Rqm4D0X9sXLyau6Dq85Gz5xE31rd+4j6Xsq0++/jAq860Wp7buEr3qmmu3w3kl
	A5VOa51VFFgr+FfrlVC7YGhqy8I9YjEXtrOoxxRzZxkdyjiUKZGWqMz8PG2a5Jd39g88hXfV
	Pn/xZ4qQ8t/FTnNu2U3OcNJMSf0gXDxV2z1O1O+83lwxe57j2S/Fu5WqNsxr07y4UjcyjF+u
	S+1X2TQb1w9mBQf5Jy3JtVtkcO5D+UE9oaz6C70PZida/LE3seOROHR6j8kzJZbijERDLeai
	4kQA2Dlr2REEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsWy7bCSnG5Z0plUg94LzBZrrvxmt1h9t5/N
	4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PN
	pp/sBZ9lK759y2xgXCPRxcjJISFgIrFubTtjFyMXh5DAdkaJiW8PATkcQAlpiYXrEyFqhCVW
	/nvODlHTziQxc/IBZpAEm4C2xKu3N8BsEQEtiWPrmthAbGaBcInG2SANnBzCAm4SX5a/BYuz
	CKhKtLx5zQRi8wrYSpx8sIwRYoG8xMxL38HqOQXsJK7s/A9mCwHV/Pp7nRGiXlDi5MwnLBDz
	5SWat85mnsAoMAtJahaS1AJGplWMoqkFxbnpuckFhnrFibnFpXnpesn5uZsYwYGqFbSDcdn6
	v3qHGJk4GA8xSnAwK4nwXppxIlWINyWxsiq1KD++qDQntfgQozQHi5I4r3JOZ4qQQHpiSWp2
	ampBahFMlomDU6qBad4hozSTXfpSK+44nD6ldVOWsWa5s6s9g/UWf+fle/Ofrn7/1Ol/bNTp
	Jd+TNovr7tT9sfrOLYfzTo+jovQnJmZYSB8IYt5a8yJWidcns6T0u0BKxUn73c87M1NM3yxM
	rhL9aPo9aLOBvYKSX0SC4KbrO+xV+H82zptXfOFql77yYxVVxtWvylUOzJzacJf74FGhjzZN
	7w3OP102NenamUbhuPMHfx65tvL+HP7Le94u5P7ost7VpTxSQ/b0/dnPug/4P37K65G2Ivfl
	1KInRs5G6od/3fcXlHnxckfKzqYTdkY7ODkf1dra1kW23v105cxBRmOLfK2zP+/FP+/tTOqe
	1Dxjs61pmm1G/bf1MUosxRmJhlrMRcWJADYkJ0LDAgAA
X-CMS-MailID: 20240214064926epcas5p29dcccdd0abe0e0ffb75c64835ec6a01a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240214064926epcas5p29dcccdd0abe0e0ffb75c64835ec6a01a
References: <20240214120624.135416-1-ankit.kumar@samsung.com>
	<CGME20240214064926epcas5p29dcccdd0abe0e0ffb75c64835ec6a01a@epcas5p2.samsung.com>

Remove io_u dependency while calculating start and number of lba.
This is a prep patch for multi-range trim support where an io_u entry
will contain multiple start offset and buffer len.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/engines/nvme.c b/engines/nvme.c
index 75a5e0c1..e5f17fc7 100644
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
+		return offset / data->lba_ext;
 	else
-		return io_u->offset >> data->lba_shift;
+		return offset >> data->lba_shift;
 }
 
-static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
+static inline __u32 get_nlb(struct nvme_data *data, __u64 len)
 {
 	if (data->lba_ext)
-		return io_u->xfer_buflen / data->lba_ext - 1;
+		return len / data->lba_ext - 1;
 	else
-		return (io_u->xfer_buflen >> data->lba_shift) - 1;
+		return (len >> data->lba_shift) - 1;
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

