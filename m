Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9E6C001B0
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjHKHrj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjHKHri (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:38 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A30211B
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:47:37 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230811074735epoutp013e66df9a84a02a96934a98bcbb676c7b~6RJ4Nfsca2538725387epoutp01b
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:47:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230811074735epoutp013e66df9a84a02a96934a98bcbb676c7b~6RJ4Nfsca2538725387epoutp01b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740055;
        bh=Q6pY007VLI8Awn5NU3rVUUn9HN7WkUrlU9iNEJQpllk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xcvo6wXCGQSpL2hLM2VOtxPbl/y/qnN7eqMr2verOHKB3/DAFyP187hVHNQKthxcb
         6EHIaBBRkBOfym38mABuDfbqJSPPku6Fp6aZclKgBsLpcmAmW+fKE5OFXJ4GFdS4jB
         qVbQj4jIYNXM9PnXkuJESMAY0uOxomMU+7aXP9u0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230811074734epcas5p42c2abbf66380f2bc883db5de83724a17~6RJ3W7p810955209552epcas5p4N;
        Fri, 11 Aug 2023 07:47:34 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RMbVX0Ch1z4x9Px; Fri, 11 Aug
        2023 07:47:32 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.69.57354.397E5D46; Fri, 11 Aug 2023 16:47:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230811060648epcas5p3b641c40e820511d5336e983cf7f31392~6Px40Cw1E2549625496epcas5p3j;
        Fri, 11 Aug 2023 06:06:48 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230811060648epsmtrp2660ba68c1c71f86f0be270168489f8a0~6Px4zZnEq2376023760epsmtrp2R;
        Fri, 11 Aug 2023 06:06:48 +0000 (GMT)
X-AuditID: b6c32a44-269fb7000001e00a-44-64d5e793f257
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.E0.14748.8FFC5D46; Fri, 11 Aug 2023 15:06:48 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060647epsmtip1a2b31211996914e2c36064c5e101be6b~6Px3bu01m2768827688epsmtip1U;
        Fri, 11 Aug 2023 06:06:47 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 10/10] engines:io_uring: generate and verify pi for 64b
 guard
Date:   Fri, 11 Aug 2023 16:55:47 +0530
Message-Id: <20230811112547.92345-11-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmlu7k51dTDF61WlmsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOmPNzHmtBq2nF7wm9bA2MPVpdjJwcEgImEm/fbGfqYuTiEBLYzShxbNNedgjnE6PE
        t8PHGUGqhAS+MUq8uGMI0zH/0VOoor2MEpdvfmGBcDqZJNp/bwDrYBPQlnj19gZzFyMHh4iA
        hsSau6kgNcwCLYwSu7tns4LUCAsESeyetYIFxGYRUJW4+OIrO4jNK2ArcbR9BSPENnmJmZe+
        s4PM4QSKL1ohBlEiKHFy5hOwVmagkuats5lB5ksIfGSXWP9xBgtEr4tEz/HrbBC2sMSr41vY
        IWwpic/v9kLFsyU2PfzJBGEXSBx50csMYdtLtJ7qB7ufWUBTYv0ufYiwrMTUU+uYIPbySfT+
        fgLVyiuxYx6MrSrx995tqBOkJW6+uwple0hs3NUEDasJjBKbnsxnnsCoMAvJP7OQ/DMLYfUC
        RuZVjJKpBcW56anJpgWGeanl8EhOzs/dxAhOnFouOxhvzP+nd4iRiYPxEKMEB7OSCK9t8KUU
        Id6UxMqq1KL8+KLSnNTiQ4ymwPCeyCwlmpwPTN15JfGGJpYGJmZmZiaWxmaGSuK8r1vnpggJ
        pCeWpGanphakFsH0MXFwSjUwrf2gpfMtVYHteECK8hSrf/HnIq5O0tzhFzD57dUSk0Vnv10I
        F46e+qxMKuvpngXPws+dvurHsSfv9POMgNsH83eYVN/YziEj1Stz+WP9vdP/PKbK56Q4vRc0
        P89jMCVj2bMLTyT1LjZOXF6z3bM6WXt26i4Dc5kDDwQdZy2QW5Cp5FN78+2HgG9qbU7yd43l
        rh61zZc2+WWzmzl7x6ua+D3MfLlcNdorqj0ygrW+duR90tsg0Nmzf9v1rRvEldxEO78e2PbT
        c2f3vK2TDx4/fr2BjWnVz6pVYdGSkj9nHb7zrodHZ+PJxfaZAgtMZ6REPp0tb8699e7bSTI+
        px9t+1y57mvYcZ8q4wPcyybc2qfEUpyRaKjFXFScCAAy8SkAJQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnO6P81dTDM58NbdYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MqY83Mea0GracXvCb1sDYw9Wl2MnBwSAiYS8x89Ze9i5OIQ
        EtjNKDHxxUWWLkYOoIS0xML1iRA1whIr/z2HqmlnktjVc58ZJMEmoC3x6u0NMFtEQEvi2Lom
        NpAiZoEuRom9u6exgSSEBQIkPk1eww5iswioSlx88RXM5hWwlTjavoIRYoO8xMxL39lBFnMC
        xRetEAMJCwnYSLya+ZsNolxQ4uTMJywgNjNQefPW2cwTGAVmIUnNQpJawMi0ilEytaA4Nz03
        2bDAMC+1XK84Mbe4NC9dLzk/dxMjOLS1NHYw3pv/T+8QIxMH4yFGCQ5mJRFe2+BLKUK8KYmV
        ValF+fFFpTmpxYcYpTlYlMR5DWfMThESSE8sSc1OTS1ILYLJMnFwSjUw6fTN3pq8xvLy/R6T
        wAun7889HJVRtGoLi3Oj8VPvK0tlEpwF7rCcMv31TdmM5RPvjnn/rLf33bm3Y0mwGudM3Zwt
        tzdLWsR8vNp7w/q3C7tumc40pZ2/F/bfu5Sk+ihWw9hzxwEBV16L/HP792plvj3ocW973ZHP
        Rqv7+2/Ley/qdVdmm1ElwRl+V4whJTh65+ozYevO9zPd3Pg77WWEh8WlxyfUkx9LHlsZq8vF
        /j1+0qPqPSu5m8t1Jf0jKqzmnvp12qOsz7IzQ3DZlZg/G67mmrpdDDjwdF6T4ZcXBTJL5yjZ
        yTfOfHKwaMW8r9ta8u82cf1sSJy0UOv2MaMDL7fz/LJo3uP+fXGWfXRJtBJLcUaioRZzUXEi
        AAMtb3TcAgAA
X-CMS-MailID: 20230811060648epcas5p3b641c40e820511d5336e983cf7f31392
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060648epcas5p3b641c40e820511d5336e983cf7f31392
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060648epcas5p3b641c40e820511d5336e983cf7f31392@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Generate and verify protection information for 64 bit guard format, for
the nvme backend of io_uring_cmd ioengine. The support is there for
both the cases where metadata is transferred in separate buffer, or
transferred at the end of logical block creating an extended logical
block.
This support also takes into consideration when protection information
resides in last or first 16 bytes of metadata.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 158 +++++++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h |   7 +++
 2 files changed, 165 insertions(+)

diff --git a/engines/nvme.c b/engines/nvme.c
index 18740138..76f3fe2b 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -6,6 +6,7 @@
 
 #include "nvme.h"
 #include "../crc/crc-t10dif.h"
+#include "../crc/crc64.h"
 
 static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
 {
@@ -175,6 +176,158 @@ next:
 	return 0;
 }
 
+static void fio_nvme_generate_pi_64b_guard(struct nvme_data *data,
+					   struct io_u *io_u,
+					   struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_64b_guard_pif *pi;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	uint64_t guard = 0;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+
+	if (data->pi_loc) {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - data->ms;
+		else
+			pi_data->interval = 0;
+	} else {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - sizeof(struct nvme_64b_guard_pif);
+		else
+			pi_data->interval = data->ms - sizeof(struct nvme_64b_guard_pif);
+	}
+
+	if (io_u->ddir != DDIR_WRITE)
+		return;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc64_nvme(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_nvme(0, buf, data->lba_size);
+				guard = fio_crc64_nvme(guard, md_buf, pi_data->interval);
+			}
+			pi->guard = cpu_to_be64(guard);
+		}
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			pi->apptag = cpu_to_be16(pi_data->apptag);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				put_unaligned_be48(slba + lba_num, pi->srtag);
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+}
+
+static int fio_nvme_verify_pi_64b_guard(struct nvme_data *data,
+					struct io_u *io_u)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_64b_guard_pif *pi;
+	struct fio_file *f = io_u->file;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u64 ref, ref_exp, guard = 0;
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 unmask_app, unmask_app_exp;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_64b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_64b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
+			if (pi->apptag == NVME_PI_APP_DISABLE &&
+			    fio_nvme_pi_ref_escape(pi->srtag))
+				goto next;
+		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
+			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
+			if (pi->apptag == NVME_PI_APP_DISABLE)
+				goto next;
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc64_nvme(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_nvme(0, buf, data->lba_size);
+				guard = fio_crc64_nvme(guard, md_buf, pi_data->interval);
+			}
+			if (be64_to_cpu((uint64_t)pi->guard) != guard) {
+				log_err("%s: Guard compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
+					f->file_name, (unsigned long long)slba,
+					guard, be64_to_cpu((uint64_t)pi->guard));
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_APP) {
+			unmask_app = be16_to_cpu(pi->apptag) & pi_data->apptag_mask;
+			unmask_app_exp = pi_data->apptag & pi_data->apptag_mask;
+			if (unmask_app != unmask_app_exp) {
+				log_err("%s: APPTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					unmask_app_exp, unmask_app);
+				return -EIO;
+			}
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				ref = get_unaligned_be48(pi->srtag);
+				ref_exp = (slba + lba_num) & ((1ULL << 48) - 1);
+				if (ref != ref_exp) {
+					log_err("%s: REFTAG compare error: LBA: %llu Expected=%llx, Actual=%llx\n",
+						f->file_name, (unsigned long long)slba,
+						ref_exp, ref);
+					return -EIO;
+				}
+				break;
+			case NVME_NS_DPS_PI_TYPE3:
+				break;
+			}
+		}
+next:
+		if (data->lba_ext) {
+			buf += data->lba_ext;
+		} else {
+			buf += data->lba_size;
+			md_buf += data->ms;
+		}
+		lba_num++;
+	}
+
+	return 0;
+}
 void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 				  struct nvme_dsm_range *dsm)
 {
@@ -253,6 +406,8 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
 		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
 			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
+		else if (data->guard_type == NVME_NVM_NS_64B_GUARD)
+			fio_nvme_generate_pi_64b_guard(data, io_u, opts);
 	}
 
 	switch (data->pi_type) {
@@ -287,6 +442,9 @@ int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
 	case NVME_NVM_NS_16B_GUARD:
 		ret = fio_nvme_verify_pi_16b_guard(data, io_u);
 		break;
+	case NVME_NVM_NS_64B_GUARD:
+		ret = fio_nvme_verify_pi_64b_guard(data, io_u);
+		break;
 	default:
 		break;
 	}
diff --git a/engines/nvme.h b/engines/nvme.h
index fb1f7760..792b35d8 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -457,4 +457,11 @@ static inline __u64 get_unaligned_be48(__u8 *p)
 		p[3] << 16 | p[4] << 8 | p[5];
 }
 
+static inline bool fio_nvme_pi_ref_escape(__u8 *reftag)
+{
+	__u8 ref_esc[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+
+	return memcmp(reftag, ref_esc, sizeof(ref_esc)) == 0;
+}
+
 #endif
-- 
2.25.1

