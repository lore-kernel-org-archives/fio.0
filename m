Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B034EC04A6A
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjHIGC7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjHIGC6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:02:58 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFF31FCD
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:02:55 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230809060253epoutp0114689806adafbcd9f2d1249b44d2d35c~5ob4vd_9g3197331973epoutp01L
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:02:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230809060253epoutp0114689806adafbcd9f2d1249b44d2d35c~5ob4vd_9g3197331973epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560973;
        bh=8qrFoPGTW8qXCaFfproyE5I+Z1cDgZo2IirOqcBA5eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7Dl5afHdZXdRAMn3PxfQs4OZz0KgThF5Bkpn94jc1X5KaLb2Oi48WjAy50FqqwzW
         YlUQ8rZTF9Bbyp1xIDgxY6DcQDC0SQIOnUTBWIlYKUdAbY2DLkx+c63A6ZZ6U21BJK
         QQKbcOqQZos3t6ptaRC6UAkrf2Eocr3NbSJofCHw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230809060252epcas5p4a467f5769f38e89187388849f8dcc1d4~5ob3-XN8f3261332613epcas5p46;
        Wed,  9 Aug 2023 06:02:52 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RLKGg21Rdz4x9QD; Wed,  9 Aug
        2023 06:02:51 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.38.55173.B0C23D46; Wed,  9 Aug 2023 15:02:51 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230809055415epcas5p43e7c72bd7e9d670899e441a26b85581f~5oUWTdkwr1660116601epcas5p4x;
        Wed,  9 Aug 2023 05:54:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055415epsmtrp1e05e3587238abc44a584112452762208~5oUWSuJ_g3170131701epsmtrp1i;
        Wed,  9 Aug 2023 05:54:15 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-c7-64d32c0bb64f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        82.BB.34491.70A23D46; Wed,  9 Aug 2023 14:54:15 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055414epsmtip1630ba1b93e73355bd137cc267f37304a~5oUVKRW6Y0788707887epsmtip1C;
        Wed,  9 Aug 2023 05:54:13 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 02/10] engines:io_uring: update arguments to fetch nvme data
Date:   Wed,  9 Aug 2023 16:43:06 +0530
Message-Id: <20230809111314.76947-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmhi63zuUUg1NrOC3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnzPx6maXgqVrF29N7WBoYV8t1MXJySAiYSCzYfoypi5GLQ0hgD6PElT2bWSGcT4wS
        9+6eZYZwvjFK7D17nw2mZdKEwywQib2MEh/3v2WHcDqZJL78vsEEUsUmoC3x6u0NoHYODhEB
        DYk1d1NBapgFWhgldnfPZgWpERbwkei/84odxGYRUJXY/uE+WC+vgI3E8S3HGCG2yUvMvPQd
        rIZTwFZi1ZobLBA1ghInZz4Bs5mBapq3zmaGqP/KLtF2IxVkr4SAi8TTeZUQYWGJV8e3sEPY
        UhIv+9ug7GyJTQ9/MkHYBRJHXvRCjbGXaD3VD3Y+s4CmxPpd+hBhWYmpp9YxQWzlk+j9/QSq
        lVdixzwYW1Xi773bLBC2tMTNd1ehbA+J/TeXgtlCAhMYJebM5ZjAqDALyTOzkDwzC2HzAkbm
        VYxSqQXFuempyaYFhrp5qeXwSE7Oz93ECE6cWgE7GFdv+Kt3iJGJg/EQowQHs5IIr23wpRQh
        3pTEyqrUovz4otKc1OJDjKbA4J7ILCWanA9M3Xkl8YYmlgYmZmZmJpbGZoZK4ryvW+emCAmk
        J5akZqemFqQWwfQxcXBKNTBV5U+/cfffnftqrlIHZ2/T7xGOumB2kVGgf2vmoc7/Dw/93vOs
        8rx9zK9Zetkngs89332V6Xute6zL7ZnHYlgdV109NfngiivRM5/uyv77bIuSf/OVrLySAz6F
        D0u57/JV7b9u9Pxv1av204tTr7Es/qD4RWu2ZV7TgcnPJkj+1b/KdkUhVmhKd7C2Z8H9xHO7
        fLp7Z8fuz5s6wWrH7quKHVayRRPkgvel7P1/N34F/4ZJUTMjyk94pD5TTkzSPPM1ufPIC4m6
        xMz/BTc2XZTzvDhnUSVf5stl5bITJrFXaG289XaHZsZf3cWz7a35dpz7bZx38WVURd0Z8anx
        f9s/t8kW31sXwpn8OdnyxofUFiWW4oxEQy3mouJEAELOilIlBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsWy7bCSnC671uUUg+4/bBZrrvxmt1h9t5/N
        4uOsF8wWR/+/ZbOYdOgao8Xy4/+YLDa0CTqwe+ycdZfd4/LZUo9NqzrZPD4+vcXi0bdlFaPH
        501yAWxRXDYpqTmZZalF+nYJXBkzv15mKXiqVvH29B6WBsbVcl2MnBwSAiYSkyYcZuli5OIQ
        EtjNKLFt7zLmLkYOoIS0xML1iRA1whIr/z1nh6hpZ5JYtGQeK0iCTUBb4tXbG8wgtoiAlsSx
        dU1sIEXMAl2MEnt3T2MDSQgL+Ej033nFDmKzCKhKbP9wnwnE5hWwkTi+5RgjxAZ5iZmXvoPV
        cArYSqxac4MFxBYCqln4diIzRL2gxMmZT8DizED1zVtnM09gFJiFJDULSWoBI9MqRsnUguLc
        9NxiwwLDvNRyveLE3OLSvHS95PzcTYzg4NbS3MG4fdUHvUOMTByMhxglOJiVRHhtgy+lCPGm
        JFZWpRblxxeV5qQWH2KU5mBREucVf9GbIiSQnliSmp2aWpBaBJNl4uCUamA6nfBj5+nLE/jf
        bWVdWmBobOcs7/Dz784Ftrs4fMR29TMvcX13/m3MroD4kwZ3/LruuHTsTY0X3H6VbaprocQb
        dZ4JG9Q1V5uHMm1YzWtq2/iOOV4oNXHTTw+BM/cifZrXT1/gsv3a3W/mFye+3sds9Oj2C7eN
        KzLs/mv+8e99c+yefdPkt923Ys4/8/25Iyovif+Bm3Xyd93Oz5PPZmhM/jVT2GJnlJvyN27p
        ggOG73SKL92699JfNCA3YedeY8ci7ZR1+ss6ZvM175Xq3fr8tfhs5itTtn3e3n7hZZr1+vaS
        v9osvN/mPozp3mLZ6t6/8+tt/TNZFlOfBhy1uROz9GBix3fdWX2qT/WX+y9lUmIpzkg01GIu
        Kk4EACaMoDHdAgAA
X-CMS-MailID: 20230809055415epcas5p43e7c72bd7e9d670899e441a26b85581f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055415epcas5p43e7c72bd7e9d670899e441a26b85581f
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055415epcas5p43e7c72bd7e9d670899e441a26b85581f@epcas5p4.samsung.com>
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
index 135b982d..2b707927 100644
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
@@ -1172,23 +1166,17 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
 
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

