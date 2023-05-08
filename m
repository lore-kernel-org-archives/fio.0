Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9949DC77B75
	for <fio@archiver.kernel.org>; Fri, 12 May 2023 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240336AbjELJLi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 May 2023 05:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbjELJLh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 May 2023 05:11:37 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2928626AE
        for <fio@vger.kernel.org>; Fri, 12 May 2023 02:11:36 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230512091134epoutp04fce93e8ff318b766b7567fb003325c81~eWmOIm7s70078700787epoutp04j
        for <fio@vger.kernel.org>; Fri, 12 May 2023 09:11:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230512091134epoutp04fce93e8ff318b766b7567fb003325c81~eWmOIm7s70078700787epoutp04j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1683882694;
        bh=gFO8MjZsCyL/qIoRmY295FsIP1xbl9l/U332Prr8TnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6YvJc3i8XwtT4XVKDQNLUxlk8uc4pLkw3WatbAL7ILN/Kpm8W1lSGJY9aXldGyl6
         CeUOZC06HbCP83ky2NuEYLx0O0hA7wo3R/1EUmnp3P59cNEaEqhqiISppm3yJIwm8M
         PvqeSx6qn5wFIznuvBEeHjKZbkaspiIwyb7hzkMg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230512091133epcas5p2321649ec88461bf7d89a0f8984407271~eWmN1n14Z1939519395epcas5p2r;
        Fri, 12 May 2023 09:11:33 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QHjgS2Hrxz4x9Pt; Fri, 12 May
        2023 09:11:32 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D7.0A.54880.4C20E546; Fri, 12 May 2023 18:11:32 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73~dJPRXF_UR3100331003epcas5p1C;
        Mon,  8 May 2023 10:41:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230508104107epsmtrp1bcffde394fc2e9259fece455c4908ed0~dJPRWbuXK2323523235epsmtrp14;
        Mon,  8 May 2023 10:41:07 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-c7-645e02c4f88e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.3B.27706.3C1D8546; Mon,  8 May 2023 19:41:07 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230508104106epsmtip149a56b4fcdd19c7b3852a586eaef64c3~dJPQcddRN3005830058epsmtip13;
        Mon,  8 May 2023 10:41:06 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 1/1] engines/io_uring: io_uring_cmd engine cleanup and fixes
Date:   Mon,  8 May 2023 21:31:18 +0530
Message-Id: <20230508160118.25334-2-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230508160118.25334-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmhu4RprgUg9UrBCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2axoU3QgdVj56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpm
        XrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0FYlhbLEnFKgUEBicbGSvp1NUX5p
        SapCRn5xia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbG32XT2QtmmVbMWneTuYFx
        g2YXIyeHhICJxNyuM2wgtpDAbkaJK/84uxi5gOxPjBIH9nUwQzjfGCU23t7ICNPx4ucSqMRe
        Rolf/f9YIZxOJolzJ66BzWIT0JZ49fYGM4gtIiAssb+jlQXEZhbIkjixog3MFhbwkZh1roGp
        i5GDg0VAVeLLY3+QMK+AjcSpaTPYIZbJS8y89B3M5hSwlfjXMoUdokZQ4uTMJ1Aj5SWat84G
        O0hC4By7RPuHG6wgMyUEXCS+t8VDzBGWeHV8C9RMKYmX/W1QdrbEpoc/mSDsAokjL3qZIWx7
        idZT/cwgY5gFNCXW79KHCMtKTD21jgliLZ9E7+8nUK28EjvmwdiqEn/v3WaBsKUlbr67CmV7
        SPze+5cNElQTGCXOXDnDOoFRYRaSd2YheWcWwuoFjMyrGCVTC4pz01OLTQsM81LL4XGcnJ+7
        iRGcDrU8dzDeffBB7xAjEwfjIUYJDmYlEd63S6JThHhTEiurUovy44tKc1KLDzGaAoN7IrOU
        aHI+MCHnlcQbmlgamJiZmZlYGpsZKonzqtueTBYSSE8sSc1OTS1ILYLpY+LglGpgss2Zdbx8
        3mE3zsAmnhpR813aLGtvqIofe7TOZ3506EGmimVC5u/2OW1q2eJkYTM1pmpexqzHXJe3LHkl
        ObWnqb+2t1dVkv1unfnvWdvivbmlC8tnn/y4/Fe/SqJN1eRnT5IXvyzdvCE52HvaF/adgR3C
        O0IOraqfz5afcKj5bMGEA6/uuyafLVZsCtkmdo5jw/wLol9u/cvJnJNn+2TT1Pw9Znv3xC2O
        SZrr+6Rre3HevG1Zx2tnpRxQj14ezV/jJeL663zqCd7uj1dC017+eL/RReHA56aVSmpiyRYT
        1LvYkyZc3Nbd8exvKuesuS9f6+2csdveoev4ZuO3E+ussl52/+Het0XlnpOh4SXh5UosxRmJ
        hlrMRcWJAGxIVkwQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSnO7hixEpBvc7JS3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2axoU3QgdVj56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bf
        ZdPZC2aZVsxad5O5gXGDZhcjJ4eEgInEi59LmLsYuTiEBHYzSixu3AnkcAAlpCUWrk+EqBGW
        WPnvOTtETTuTxNzmrSwgCTYBbYlXb28wg9giQEX7O1pZQHqZBfIkvq1SAQkLC/hIzDrXwAQS
        ZhFQlfjy2B8kzCtgI3Fq2gx2iPHyEjMvfQezOQVsJf61TAGzhYBqZmyZzwRRLyhxcuYTsK3M
        QPXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOBw1dLc
        wbh91Qe9Q4xMHIyHGCU4mJVEeFclhKUI8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9
        sSQ1OzW1ILUIJsvEwSnVwGTqPDP1n7Rj5OLFJ90nRNr2b+ndvMd8pu7hZyuWrp138RrrtoIy
        sdQzLwzzi/5qNN341XFp4eOv34Wm9v046PrHpH2BiE/oObFl78oEKmeKCRyLkrtyx+9PZTR/
        e5Gx+bTdW/bVhmpWPrz9YMXDoz2HTI36Zyq6vA99vLnyw7upOssaHycun5/JotNyIofTSX/S
        1YztSWx3bpdfFWm3V3hhtPuFs8DL11t3e+qdtFv26flNLt+0hjef1le71UuXa3HUVoewXUyf
        l7qhScvbd5FrA+MSJu+MDarNHwPvpK+o9Lk7d8v8Dc/zLnIsDbLuXyCkuS2x1bWOb+uTxO6L
        5ZZyadLBVdkWp7OVVuwWN1NiKc5INNRiLipOBACsUSbqxgIAAA==
X-CMS-MailID: 20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73
References: <20230508160118.25334-1-ankit.kumar@samsung.com>
        <CGME20230508104107epcas5p1f66b2d5c59293d9d902502e23add5c73@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

- The io_uring_cmd ioengine assumes that logical block size is power of 2.
In case of extended LBA where metadata is transferred as part of LBA
this is not correct. Use division operation for that. The existing
calculation for power of 2 LBA remains the same.

- The current implementation doesn't support protection info and
metadata transferred as separate buffer, return error for these
scenarios.

- Add checks to verify that block sizes are multiple of LBA size.
- Add support for 64 LBA formats as per the latest NVM command set
specification.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 31 +++++++++++++++++++++----
 engines/nvme.c     | 57 +++++++++++++++++++++++++++++++++++++---------
 engines/nvme.h     |  3 ++-
 3 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index f5ffe9f4..32ddba19 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1177,22 +1177,41 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
+		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
 		/* Store the namespace-id and lba size. */
 		data = FILE_ENG_DATA(f);
 		if (data == NULL) {
-			ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+			ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
 			if (ret)
 				return ret;
 
 			data = calloc(1, sizeof(struct nvme_data));
 			data->nsid = nsid;
-			data->lba_shift = ilog2(lba_size);
+			if (ms)
+				data->lba_ext = lba_size + ms;
+			else
+				data->lba_shift = ilog2(lba_size);
 
 			FILE_SET_ENG_DATA(f, data);
 		}
+
+		data = FILE_ENG_DATA(f);
+		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
+
+		for_each_rw_ddir(ddir) {
+			if (td->o.min_bs[ddir] % lba_size != 0 ||
+				td->o.max_bs[ddir] % lba_size != 0) {
+				if (data->lba_ext)
+					log_err("bs must be a multiple of "
+						"(LBA data size + Metadata size)\n");
+				else
+					log_err("bs must be a multiple of LBA data size\n");
+				return 1;
+			}
+                }
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
@@ -1243,16 +1262,20 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
 		unsigned int nsid, lba_size = 0;
+		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
-		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+		ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
 		if (ret)
 			return ret;
 
 		data = calloc(1, sizeof(struct nvme_data));
 		data->nsid = nsid;
-		data->lba_shift = ilog2(lba_size);
+		if (ms)
+			data->lba_ext = lba_size + ms;
+		else
+			data->lba_shift = ilog2(lba_size);
 
 		f->real_file_size = lba_size * nlba;
 		fio_file_set_size_known(f);
diff --git a/engines/nvme.c b/engines/nvme.c
index fd2161f3..b99eae9c 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -21,8 +21,13 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	else
 		return -ENOTSUP;
 
-	slba = io_u->offset >> data->lba_shift;
-	nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+	if (data->lba_ext) {
+		slba = io_u->offset / data->lba_ext;
+		nlb = (io_u->xfer_buflen / data->lba_ext) - 1;
+	} else {
+		slba = io_u->offset >> data->lba_shift;
+		nlb = (io_u->xfer_buflen >> data->lba_shift) - 1;
+	}
 
 	/* cdw10 and cdw11 represent starting lba */
 	cmd->cdw10 = slba & 0xffffffff;
@@ -65,8 +70,13 @@ int fio_nvme_trim(const struct thread_data *td, struct fio_file *f,
 	struct nvme_dsm_range dsm;
 	int ret;
 
-	dsm.nlb = (len >> data->lba_shift);
-	dsm.slba = (offset >> data->lba_shift);
+	if (data->lba_ext) {
+		dsm.nlb = len / data->lba_ext;
+		dsm.slba = offset / data->lba_ext;
+	} else {
+		dsm.nlb = len >> data->lba_shift;
+		dsm.slba = offset >> data->lba_shift;
+	}
 
 	ret = nvme_trim(f->fd, data->nsid, 1, sizeof(struct nvme_dsm_range),
 			&dsm);
@@ -94,11 +104,12 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 }
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba)
+		      __u32 *ms, __u64 *nlba)
 {
 	struct nvme_id_ns ns;
 	int namespace_id;
 	int fd, err;
+	__u32 format_idx;
 
 	if (f->filetype != FIO_TYPE_CHAR) {
 		log_err("ioengine io_uring_cmd only works with nvme ns "
@@ -113,9 +124,8 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	namespace_id = ioctl(fd, NVME_IOCTL_ID);
 	if (namespace_id < 0) {
 		err = -errno;
-		log_err("failed to fetch namespace-id");
-		close(fd);
-		return err;
+		log_err("%s: failed to fetch namespace-id\n", f->file_name);
+		goto out;
 	}
 
 	/*
@@ -125,17 +135,42 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
 				NVME_CSI_NVM, &ns);
 	if (err) {
-		log_err("failed to fetch identify namespace\n");
+		log_err("%s: failed to fetch identify namespace\n",
+			f->file_name);
 		close(fd);
 		return err;
 	}
 
 	*nsid = namespace_id;
-	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+
+	if (ns.nlbaf < 16)
+		format_idx = ns.flbas & 0xf;
+	else
+		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
+
+	*lba_sz = 1 << ns.lbaf[format_idx].ds;
+
+	/* Only extended LBA can be supported */
+	*ms = le16_to_cpu(ns.lbaf[format_idx].ms);
+	if (*ms && !((ns.flbas >> 4) & 0x1)) {
+		log_err("%s: only extended logical block can be supported\n",
+			f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
+
+	/* Check for end to end data protection support */
+	if (ns.dps & 0x3) {
+		log_err("%s: end to end data protection not supported\n",
+			f->file_name);
+		err = -ENOTSUP;
+		goto out;
+	}
 	*nlba = ns.nsze;
 
+out:
 	close(fd);
-	return 0;
+	return err;
 }
 
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
diff --git a/engines/nvme.h b/engines/nvme.h
index 408594d5..f1d84d68 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -88,6 +88,7 @@ enum nvme_zns_zs {
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
+	__u32 lba_ext;
 };
 
 struct nvme_lbaf {
@@ -223,7 +224,7 @@ int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba);
+		      __u32 *ms, __u64 *nlba);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov);
-- 
2.25.1

