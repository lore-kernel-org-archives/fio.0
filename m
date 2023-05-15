Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AAAC7EE24
	for <fio@archiver.kernel.org>; Mon, 15 May 2023 05:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238441AbjEOFuZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 May 2023 01:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238303AbjEOFuL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 May 2023 01:50:11 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5148D271F
        for <fio@vger.kernel.org>; Sun, 14 May 2023 22:49:53 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230515054951epoutp019f121aee4b3e5ca5fc904becd2ad7e82~fOx9V27Yy0726307263epoutp01E
        for <fio@vger.kernel.org>; Mon, 15 May 2023 05:49:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230515054951epoutp019f121aee4b3e5ca5fc904becd2ad7e82~fOx9V27Yy0726307263epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684129791;
        bh=miFNNYs6Ug1rZO+Psc+Yg81lz91lweVS6v9UWJEUQHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAseDD8VGRFVPUVj49O9qxXcsFkOMf6Cb+DNG8JN8qMY05BO4In9+bzo58yMAJe+S
         OYdfD65PT4TyaAoT3x7gNXxxWCWJagToIc7bS6FoP7vep8mXgXm+ntBHU4pb25e9bi
         K5SxnlAsjH+b5oCXUzuFTQLmod5gJAhDn00uSeLo=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230515054951epcas5p4a90929990502ad1596700d5d489a8444~fOx9E_1Ko1784017840epcas5p4S;
        Mon, 15 May 2023 05:49:51 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4QKT3K2nnCz4x9QC; Mon, 15 May
        2023 05:49:49 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.B8.57769.DF7C1646; Mon, 15 May 2023 14:49:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230515054352epcas5p15ceded12f770df07d842f324f1ef7857~fOsveCJL11957319573epcas5p1O;
        Mon, 15 May 2023 05:43:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230515054352epsmtrp18e0ee5f0df91e90ace8c2a6b4b7c6571~fOsvWq2Cc1628916289epsmtrp1h;
        Mon, 15 May 2023 05:43:52 +0000 (GMT)
X-AuditID: b6c32a4a-ccfff7000001e1a9-3a-6461c7fd011f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        43.0B.28392.896C1646; Mon, 15 May 2023 14:43:52 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230515054351epsmtip27a4b14a670079d405101551b54b1e7ee~fOsub7_mH0628906289epsmtip2d;
        Mon, 15 May 2023 05:43:51 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com, joshi.k@samsung.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 2/2] engines/io_uring: io_uring_cmd engine fixes
Date:   Mon, 15 May 2023 16:33:40 +0530
Message-Id: <20230515110340.21984-3-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230515110340.21984-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmlu7f44kpBof2s1qsufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJaobJuM1MSU1CKF1Lzk/JTM
        vHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoK1KCmWJOaVAoYDE4mIlfTubovzS
        klSFjPziElul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyM898WsBUsMq14cTO6gfGM
        ZhcjJ4eEgInEslcL2bsYuTiEBHYzSlz/0MgE4XxilFi1cSorhPOZUeLftp/sMC3LX69hhkjs
        YpS4uH8dVFUnk0T/if2MIFVsAtoSr97eYAaxRQSEJfZ3tLKA2MwCWRInVrSB2cICzhKXOmaA
        TWURUJXY9eciWJxXwEbi5NdZTBDb5CVmXvoOVsMpYCvRsP03VI2gxMmZT6Bmyks0b50NdpGE
        wDl2iYeHvzFCNLtIPN73iQXCFpZ4dXwL1AtSEi/726DsbIlND39CLSuQOPKilxnCtpdoPdUP
        ZHMALdCUWL9LHyIsKzH11DomiL18Er2/n0C18krsmAdjq0r8vXcbaq20xM13V6FsD4lvU9dD
        A3sCMLDXXWGawKgwC8k/s5D8Mwth9QJG5lWMkqkFxbnpqcWmBUZ5qeXwWE7Oz93ECE6JWl47
        GB8++KB3iJGJg/EQowQHs5IIb/vM+BQh3pTEyqrUovz4otKc1OJDjKbAAJ/ILCWanA9Mynkl
        8YYmlgYmZmZmJpbGZoZK4rzqtieThQTSE0tSs1NTC1KLYPqYODilGpg6Fi6aNs1wrsXswibO
        bVO27beznMu9w6fz8D09xycNn+M97xiXRU2p9rQ2+J3hUHlWujrc0yM0+m/KHfbdj+/El7Cu
        LPn24Nw3gbvai1Kmv37xctO8eU1Wvx6vCpy2wr3xd+DxtXnucWd1DOur9leL/VrGkP+9Yr38
        jw3V3x7kJNaedb1nNeW1LEfKZHO95VGXpU7N2H/hwu5ZBo4Waybm+ppJdc77GSW584d1qZTW
        shVTPz1SSVa68KhztW3y/luzH710/u2YP9OzjWfzhJtSB0v/Ne9+axgaHvLU8pqv28TDb+bP
        Xhi4OapDcqvjjGkV/4RTf8x8o71D+rj8tYzlKpZFJ7S+u187MZPneVTLOSWW4oxEQy3mouJE
        AO21rDESBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsWy7bCSvO6MY4kpBhcvaFusufKb3WL13X42
        i4+zXjBbHP3/ls1iQ5ugA6vHzll32T0uny316NuyitHj8ya5AJYoLpuU1JzMstQifbsErozz
        3xawFSwyrXhxM7qB8YxmFyMnh4SAicTy12uYuxi5OIQEdjBKHDp4lLWLkQMoIS2xcH0iRI2w
        xMp/z9khatqZJFYcPssOkmAT0JZ49fYGM4gtAlS0v6OVBaSXWSBP4tsqFZCwsICzxKWOGWDl
        LAKqErv+XGQBsXkFbCROfp3FBDFfXmLmpe9gNZwCthIN23+D1QgB1Sy/togJol5Q4uTMJ2Bx
        ZqD65q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6xYYFRXmq5XnFibnFpXrpecn7uJkZwuGpp
        7WDcs+qD3iFGJg7GQ4wSHMxKIrztM+NThHhTEiurUovy44tKc1KLDzFKc7AoifNe6DoZLySQ
        nliSmp2aWpBaBJNl4uCUamBKsD3tczdNwer16i6DBa/Yex4dXLtS8c7bMCYn4U97P07x2N6S
        oRCrE+6goTHpzPUZ0ebPVYNWJL9++aWycSKr76qKhHOnv7zzfTFhyvK1LzK5ksPeCbVKZZ72
        kw97fKLy1o4dRQ8vvNN47DD/qUN8voWqtoW3+q3Yo3fv1n70vqxR+Yz1/MJrzAZNKml6u7bF
        d8vr+JhxMHtqra79lOXOz3HDwYmnfcuK3b9dlP9e0lverzRjx1OWs3KbDz3R1c/YF3ryT/Wq
        k3O/xfuYbdi3fjlb0a6uXP41hZGnu8/vu/1wj52ZjezqSeVa7OZXZ7s/LWHz8Ez4sIpJeL94
        0ZrG+mIrLd6vN6QZXW7+sjdXYinOSDTUYi4qTgQA6y3dZMYCAAA=
X-CMS-MailID: 20230515054352epcas5p15ceded12f770df07d842f324f1ef7857
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515054352epcas5p15ceded12f770df07d842f324f1ef7857
References: <20230515110340.21984-1-ankit.kumar@samsung.com>
        <CGME20230515054352epcas5p15ceded12f770df07d842f324f1ef7857@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The io_uring_cmd ioengine assumes that logical block size is always
power of 2. But with namespace formats where metadata is transferred
at the end of logical block i.e. an extended logical block this is
not true.
This patch calculates the correct extended logical block size and
uses division operation for start and number of logical block
calculation. The existing calculation for power of 2 logical block
size will remain same.
This also add checks to verify that block sizes are multiple of LBA size.

This current implementation however doesn't support protection info
and metadata transferred as separate buffer. Return error for those.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c | 30 ++++++++++++++++++++++----
 engines/nvme.c     | 52 +++++++++++++++++++++++++++++++++++++---------
 engines/nvme.h     |  3 ++-
 3 files changed, 70 insertions(+), 15 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index f5ffe9f4..90e5a856 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -1177,22 +1177,40 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
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
+		lba_size = data->lba_ext ? data->lba_ext : (1 << data->lba_shift);
+
+		for_each_rw_ddir(ddir) {
+			if (td->o.min_bs[ddir] % lba_size ||
+				td->o.max_bs[ddir] % lba_size) {
+				if (data->lba_ext)
+					log_err("block size must be a multiple of "
+						"(LBA data size + Metadata size)\n");
+				else
+					log_err("block size must be a multiple of LBA data size\n");
+				return 1;
+			}
+                }
 	}
 	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
@@ -1243,16 +1261,20 @@ static int fio_ioring_cmd_get_file_size(struct thread_data *td,
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
index 96a5f064..1047ade2 100644
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
@@ -94,7 +104,7 @@ static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 }
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba)
+		      __u32 *ms, __u64 *nlba)
 {
 	struct nvme_id_ns ns;
 	int namespace_id;
@@ -114,9 +124,8 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
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
@@ -126,7 +135,8 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 	err = nvme_identify(fd, namespace_id, NVME_IDENTIFY_CNS_NS,
 				NVME_CSI_NVM, &ns);
 	if (err) {
-		log_err("failed to fetch identify namespace\n");
+		log_err("%s: failed to fetch identify namespace\n",
+			f->file_name);
 		close(fd);
 		return err;
 	}
@@ -144,10 +154,32 @@ int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
 		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
 
 	*lba_sz = 1 << ns.lbaf[format_idx].ds;
+
+	/*
+	 * Only extended LBA can be supported.
+	 * Bit 4 for flbas indicates if metadata is transferred at the end of
+	 * logical block creating an extended LBA.
+	 */
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
index 9d6288c8..f7cb820d 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -88,6 +88,7 @@ enum nvme_zns_zs {
 struct nvme_data {
 	__u32 nsid;
 	__u32 lba_shift;
+	__u32 lba_ext;
 };
 
 struct nvme_lbaf {
@@ -222,7 +223,7 @@ int fio_nvme_iomgmt_ruhs(struct thread_data *td, struct fio_file *f,
 			 struct nvme_fdp_ruh_status *ruhs, __u32 bytes);
 
 int fio_nvme_get_info(struct fio_file *f, __u32 *nsid, __u32 *lba_sz,
-		      __u64 *nlba);
+		      __u32 *ms, __u64 *nlba);
 
 int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 			    struct iovec *iov);
-- 
2.25.1

