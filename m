Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB64EC04FE0
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233484AbjHNJlT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbjHNJlB (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:01 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A3DCC
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:00 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230814094056epoutp026679abb2cc53d37c4841fed6d29c76db~7Nosg5lPu2402924029epoutp02f
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:40:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230814094056epoutp026679abb2cc53d37c4841fed6d29c76db~7Nosg5lPu2402924029epoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006056;
        bh=EW4qgLnpNehbXUoK/3sJGHlsiKOVuPz8j8VoNSUb3q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SxjaWNKizB5JP2xQ3xhIZLrfoLF1BLvW4KNhneIFHMXe5LKjpY+Sgq5VWCwTvQDlV
         +jZZyF7jlhZICO7NphQ2W6q5NOrfO0ZxqwGndy8ObOUfLaVbtYCQGEbrnnt1AhtlOF
         6kV9ndMkJMissbm9SLNvc7y0J9BcYL8xkPelQfas=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230814094055epcas5p252880c66a5000595ac9f39fee688ff1a~7NosDvABW1264012640epcas5p2L;
        Mon, 14 Aug 2023 09:40:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RPTsx6gthz4x9Pq; Mon, 14 Aug
        2023 09:40:53 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.BE.44250.5A6F9D46; Mon, 14 Aug 2023 18:40:53 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230814093840epcas5p4177e2c9b9b01f99ea5fd1edd6bc8648b~7NmuH4iRR1183811838epcas5p4M;
        Mon, 14 Aug 2023 09:38:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230814093840epsmtrp1ff419486ee275bfb81ee69c26b75fb91~7NmuHGcWj2343923439epsmtrp1K;
        Mon, 14 Aug 2023 09:38:40 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-94-64d9f6a5e0b3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3C.E9.34491.026F9D46; Mon, 14 Aug 2023 18:38:40 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093838epsmtip17f465acd14205c4e40c2f12f286fce02~7NmsXCIUp0367103671epsmtip1k;
        Mon, 14 Aug 2023 09:38:38 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 02/10] engines:io_uring: update arguments to fetch nvme
 data
Date:   Mon, 14 Aug 2023 20:27:39 +0530
Message-Id: <20230814145747.114725-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmlu7SbzdTDB5tMbJYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdsXn6U5aCp2oVm/f8ZmlgXC3XxcjJISFgIjH300L2LkYuDiGB3YwS31e0MEI4nxgl
        rvy+yQrhfGOU+HN2JwtMy7qfz8BsIYG9jBIXlptBFHUySSy4eoEdJMEmoC3x6u0N5i5GDg4R
        AQ2JNXdTQWqYBVoYJXZ3z2YFqREWCJR48qeVGcRmEVCV2DVtCRuIzStgK/Hi2Rt2iGXyEjMv
        fQezOQXsJP5P+c0OUSMocXLmE7AjmIFqmrfOZgZZICHwkV2ibcYyqEtdJKavfcgKYQtLvDq+
        BWqolMTL/jYoO1ti08OfTBB2gcSRF73MELa9ROupfrAHmAU0Jdbv0ocIy0pMPbWOCWIvn0Tv
        7ydQrbwSO+bB2KoSf+/dhjpBWuLmu6tQtofE0pfPmSCBNZFR4uuCXsYJjAqzkPwzC8k/sxBW
        L2BkXsUomVpQnJueWmxaYJSXWg6P5eT83E2M4NSp5bWD8eGDD3qHGJk4GA8xSnAwK4nw3nK/
        liLEm5JYWZValB9fVJqTWnyI0RQY4BOZpUST84HJO68k3tDE0sDEzMzMxNLYzFBJnPd169wU
        IYH0xJLU7NTUgtQimD4mDk6pBiaZA4Lvf+x0YxEre5p+o9CW8dXctMo/qlNcdm6xecHwv/PF
        C568opkrzO3l/Q8xXUtmu3zy2o4VS9JeCrzfl3XUSM2UdzqXXPxBieVGSTzprfPn+y/eUpmp
        rzhxGlv+2n/Ki5Q/rD0/K02T98TcG5KKp+5PXNIxK3nmetfL6//5HciySlmwcomg/+KjS2w3
        V34JDYzcXeG5wTTyQsrEWfsSeBfZ3U9M2HD3tNPsv5YrWZwLNrOFWOcVPNvAXDpnZbO1Y4r3
        3d1ibowBhzL0NU5M2L4+NDvpr0BgyLmreTNK1swzlPshulfr5Fmtv0f0bbyPtZZo3b02+1T8
        /72f1N3m3Nx2xdtlB8fd8F8HXjzcq8RSnJFoqMVcVJwIAEIci1wmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnK7Ct5spBv2PRS3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDI2T3/KUvBUrWLznt8sDYyr5boYOTkkBEwk1v18xtLFyMUh
        JLCbUeLHrl2MXYwcQAlpiYXrEyFqhCVW/nvODlHTziQx4+4ZNpAEm4C2xKu3N5hBbBEBLYlj
        65rYQIqYBboYJfbungZWJCzgL7H85xZ2EJtFQFVi17QlYHFeAVuJF8/esENskJeYeek7mM0p
        YCfxf8pvMFsIqGbVwr2sEPWCEidnPmEBsZmB6pu3zmaewCgwC0lqFpLUAkamVYySqQXFuem5
        xYYFhnmp5XrFibnFpXnpesn5uZsYwcGtpbmDcfuqD3qHGJk4GA8xSnAwK4nw3nK/liLEm5JY
        WZValB9fVJqTWnyIUZqDRUmcV/xFb4qQQHpiSWp2ampBahFMlomDU6qBSUPFcMZah6edgt+O
        zb2kvaxqlpnwilkOu9i+a80x0vy16OYEHXZL02kh4rl8P0/Mr9IOKXrOunvxWffCb5IaqzYo
        P1rll1m7Y9qU4Dj5zX3tL+4VV/Vxvj5z6sem4i9z9nHl3Cg5l/vULuV0Q1PbX9b1kaLZeRrO
        wUsOTrykq9t27OdhgXBj19N1/NNzFx7mX2Tn+cU0/VTgpKqNwRyX520/W7cyWLI0cdOq44b7
        Hh3jDNZjte8vVj8ve8JC9FFiTcOOkBe2F+PTo3UWJEWbP9nj7TZ9CYdM1u2z0q9rp0zyWlg+
        yy76osSPubO+bBa/knTFN/ORWXR6ZdVNzQ1f54jHHtxgcEgi3m5336feWCWW4oxEQy3mouJE
        AJvDwv/dAgAA
X-CMS-MailID: 20230814093840epcas5p4177e2c9b9b01f99ea5fd1edd6bc8648b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093840epcas5p4177e2c9b9b01f99ea5fd1edd6bc8648b
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093840epcas5p4177e2c9b9b01f99ea5fd1edd6bc8648b@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This is a prep patch to keep number of arguments for fio_nvme_get_info
in check. The follow up patches will enable metadata, protection info.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 38 +++++++++++++-------------------------
 engines/nvme.c     | 16 ++++++++++------
 engines/nvme.h     |  5 +++--
 3 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 09065463..30d9ccd7 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1086,30 +1086,24 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
-		unsigned int nsid, lba_size = 0;
-		__u32 ms = 0;
+		unsigned int lba_size = 0;
 		__u64 nlba = 0;
 		int ret;
 
 		/* Store the namespace-id and lba size. */
 		data = FILE_ENG_DATA(f);
 		if (data == NULL) {
-			ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
-			if (ret)
-				return ret;
-
 			data = calloc(1, sizeof(struct nvme_data));
-			data->nsid = nsid;
-			if (ms)
-				data->lba_ext = lba_size + ms;
-			else
-				data->lba_shift = ilog2(lba_size);
+			ret = fio_nvme_get_info(f, &nlba, data);
+			if (ret) {
+				free(data);
+				return ret;
+			}
 
 			FILE_SET_ENG_DATA(f, data);
 		}
 
-		assert(data->lba_shift < 32);
-		lba_size = data->lba_ext ? data->lba_ext : (1U << data->lba_shift);
+		lba_size = data->lba_ext ? data->lba_ext : data->lba_size;
 
 		for_each_rw_ddir(ddir) {
 			if (td->o.min_bs[ddir] % lba_size ||
@@ -1173,23 +1167,17 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		struct nvme_data *data = NULL;
-		unsigned int nsid, lba_size = 0;
-		__u32 ms = 0;
 		__u64 nlba = 0;
 		int ret;
 
-		ret = fio_nvme_get_info(f, &nsid, &lba_size, &ms, &nlba);
-		if (ret)
-			return ret;
-
 		data = calloc(1, sizeof(struct nvme_data));
-		data->nsid = nsid;
-		if (ms)
-			data->lba_ext = lba_size + ms;
-		else
-			data->lba_shift = ilog2(lba_size);
+		ret = fio_nvme_get_info(f, &nlba, data);
+		if (ret) {
+			free(data);
+			return ret;
+		}
 
-		f->real_file_size = lba_size * nlba;
+		f->real_file_size = data->lba_size * nlba;
 		fio_file_set_size_known(f);
 
 		FILE_SET_ENG_DATA(f, data);
diff --git a/engines/nvme.c b/engines/nvme.c
index b18ad4c2..7e891eed 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -99,8 +99,7 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 	return ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
 }
 
-int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u32 *ms, __u64 *nlba)
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 {
 	struct nvme_id_ns ns;
 	int namespace_id;
@@ -137,7 +136,7 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		return err;
 	}
 
-	*nsid = namespace_id;
+	data->nsid = namespace_id;
 
 	/*
 	 * 16 or 64 as maximum number of supported LBA formats.
@@ -149,21 +148,26 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	else
 		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
 
-	*lba_sz = 1 << ns.lbaf[format_idx].ds;
+	data->lba_size = 1 << ns.lbaf[format_idx].ds;
 
 	/*
 	 * Only extended LBA can be supported.
 	 * Bit 4 for flbas indicates if metadata is transferred at the end of
 	 * logical block creating an extended LBA.
 	 */
-	*ms = le16_to_cpu(ns.lbaf[format_idx].ms);
-	if (*ms && !((ns.flbas >> 4) & 0x1)) {
+	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
+	if (data->ms && !((ns.flbas >> 4) & 0x1)) {
 		log_err("%s: only extended logical block can be supported\n",
 			f->file_name);
 		err = -ENOTSUP;
 		goto out;
 	}
 
+	if (data->ms)
+		data->lba_ext = data->lba_size + data->ms;
+	else
+		data->lba_shift = ilog2(data->lba_size);
+
 	/* Check for end to end data protection support */
 	if (ns.dps & 0x3) {
 		log_err("%s: end to end data protection not supported\n",
diff --git a/engines/nvme.h b/engines/nvme.h
index 238471dd..e742b14f 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -88,7 +88,9 @@ enum nvme_zns_zs {
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
+	__u32 lba_size;
 	__u32 lba_ext;
+	__u16 ms;
 };
 
 struct nvme_lbaf {
@@ -219,8 +221,7 @@ struct nvme_dsm_range {
 int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
-int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u32 *ms, __u64 *nlba);
+int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov, struct nvme_dsm_range *dsm);
-- 
2.25.1

