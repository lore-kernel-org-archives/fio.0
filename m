Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7266EB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbjHKHqy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234191AbjHKHqx (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:46:53 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB85B2727
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:46:50 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230811074649epoutp024d44df50ac3de2f4fd0ecff2b7e42398~6RJMz61gq2839128391epoutp02p
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:46:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230811074649epoutp024d44df50ac3de2f4fd0ecff2b7e42398~6RJMz61gq2839128391epoutp02p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740009;
        bh=EW4qgLnpNehbXUoK/3sJGHlsiKOVuPz8j8VoNSUb3q4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyGBuNyj0DLeVegcZTbCCcchbxcIp/1yx3EUjRbw/Z3bh/v2zX7ePDtKqTlVmWZ+P
         1+cgv5l/yE+FY8gPDvFOkw7b5WQfXsbts62tuEL1+s36uoOiMrryTLe4P+AXJ3MXkV
         fvhW90I/Xpc+J+ZRBH583ElSogoHjJERfCDZhI7Q=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230811074648epcas5p4be1b753c79734fe3e69ef4737b96e170~6RJMdVOe01919319193epcas5p4D;
        Fri, 11 Aug 2023 07:46:48 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4RMbTf6HM0z4x9Q7; Fri, 11 Aug
        2023 07:46:46 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.3E.44250.667E5D46; Fri, 11 Aug 2023 16:46:46 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230811060636epcas5p3e84849b062c7c7812e8392ad0eb4d8c0~6PxswwV7R2549625496epcas5p35;
        Fri, 11 Aug 2023 06:06:36 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230811060636epsmtrp1509c20f12d672caf61482efadc50c036~6PxswCEuM3264632646epsmtrp1u;
        Fri, 11 Aug 2023 06:06:36 +0000 (GMT)
X-AuditID: b6c32a4a-ec1fd7000000acda-7d-64d5e766c9c8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.8B.34491.BEFC5D46; Fri, 11 Aug 2023 15:06:35 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060634epsmtip13342220f9408eb5bdf77dd7a262d9c36~6PxrniFPk2733527335epsmtip13;
        Fri, 11 Aug 2023 06:06:34 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 02/10] engines:io_uring: update arguments to fetch nvme
 data
Date:   Fri, 11 Aug 2023 16:55:39 +0530
Message-Id: <20230811112547.92345-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpm7a86spBtfvGFqsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjO2Dz9KUvBU7WKzXt+szQwrpbrYuTkkBAwkbjWdJu5i5GLQ0hgN6PEovZlrBDOJ0aJ
        qw+eMUI43xglNr1pZ4ZpWXnpKlRiL6PEwweToJxOJonmDS2sIFVsAtoSr97eAOrg4BAR0JBY
        czcVpIZZoIVRYnf3bLAaYYFAiQ/LXjOB2CwCqhKLli9jAbF5BWwk/s5tZoLYJi8x89J3dpA5
        nAK2EotWiEGUCEqcnPkErJwZqKR562ywHyQEvrJLTDj+BarXRaL5/DMoW1ji1fEt7BC2lMTL
        /jYoO1ti08OfUDUFEkde9EJ9aS/Reqof7H5mAU2J9bv0IcKyElNPrWOC2Msn0fv7CVQrr8SO
        eTC2qsTfe7dZIGxpiZvvrkLZHhK7T56GhvUERomLr9YyT2BUmIXkn1lI/pmFsHoBI/MqRsnU
        guLc9NRi0wKjvNRyeCwn5+duYgSnTi2vHYwPH3zQO8TIxMF4iFGCg1lJhNc2+FKKEG9KYmVV
        alF+fFFpTmrxIUZTYHhPZJYSTc4HJu+8knhDE0sDEzMzMxNLYzNDJXHe161zU4QE0hNLUrNT
        UwtSi2D6mDg4pRqYYg9M6r8ezRJ4byMrzz2Bp62brk8s2tkzIa75ivHL04YWnxj5eH++ZC40
        kpI9f2l7vbn0m8NHd7reu2DdL5zV8qt7obKLROjZgjt3nlk6/V4yW2CFXv+pJz8W3MuKXL5m
        y9LtaRs9n2h8rYtO85jTqZYnkTzlttv2+AsMXRee95yPLd/910neuWRO5tmWDulc3eSYDZI8
        ZWfX1KvOjf57Xaj1mU7yPCm/6rm3P3PkiYpXTv12JmN6sssz1t9/+Dx0JNbYf3QIUv3zXCQq
        cn7/rOtl81t7rl9dIfTZIXjGkmvi825evS/7b/pskQ3/1XbWxNq2lq/t+Sy8rnXK1j3Rhnv7
        fcW9VEN431cXsTAJK7EUZyQaajEXFScCAPvAKfwmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnO7r81dTDCYft7JYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MrYPP0pS8FTtYrNe36zNDCuluti5OSQEDCRWHnpKmMXIxeH
        kMBuRomvLc+Zuhg5gBLSEgvXJ0LUCEus/PecHaKmnUni8ry3zCAJNgFtiVdvb4DZIgJaEsfW
        NbGBFDELdDFK7N09jQ0kISzgL3H+zX4mEJtFQFVi0fJlLCA2r4CNxN+5zUwQG+QlZl76zg6y
        mFPAVmLRCjGQsBBQyauZv9kgygUlTs58AtbKDFTevHU28wRGgVlIUrOQpBYwMq1ilEwtKM5N
        zy02LDDMSy3XK07MLS7NS9dLzs/dxAgObS3NHYzbV33QO8TIxMF4iFGCg1lJhNc2+FKKEG9K
        YmVValF+fFFpTmrxIUZpDhYlcV7xF70pQgLpiSWp2ampBalFMFkmDk6pBqa1b4zz++//O3HD
        yVZ8oXC7z5eF1rrVKzlUbV8e+bRg/44W7gMHt1Qd+Cb3hIH5n3/GxssOjnpVUtF3k/9uWpz6
        eI6RWOae8KwGXcW1GtelP/7jO3zeYq3S599P17QFuUQ6pE5aGrbcK1X85qdHh4JVmCNmHr+3
        I20W68+6L8+jub0kWIrzpyZ41a76ypGxzZrZN0V2fddNoZCM50ohntIecnE3F5svUJgzV/TC
        cvHkltXcr9fMXnPoiu7/9y58abXndjbu9j+06cvKGS5FZ/mmTUmWeXS0V3V7Uebj2LexwZwH
        sniyT95PsRWXXfB9y7/vcnfW1E9bqV6YN+XMi+dPtd/xCJ9iOfZty8uHdxLalViKMxINtZiL
        ihMBGS9Ck9wCAAA=
X-CMS-MailID: 20230811060636epcas5p3e84849b062c7c7812e8392ad0eb4d8c0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060636epcas5p3e84849b062c7c7812e8392ad0eb4d8c0
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060636epcas5p3e84849b062c7c7812e8392ad0eb4d8c0@epcas5p3.samsung.com>
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

