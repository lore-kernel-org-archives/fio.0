Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5D75C04FDF
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbjHNJl4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235720AbjHNJle (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:34 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28E11737
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:28 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230814094127epoutp01a1ec860172ba214eed0952d8610b513b~7NpJh3Ux21101011010epoutp01I
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230814094127epoutp01a1ec860172ba214eed0952d8610b513b~7NpJh3Ux21101011010epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006087;
        bh=edvXnyht5d8+RRv+qNybVp9m6wAZ1CWbcEZfEL0V7F0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euT52DVuwmG8QP/GxBrWZRZ+ah2pwCCVz3bidipUNXKpg3onUftKYeJZiR0JRCSuI
         VG3v27/Tqq25kJgVF+fNxRUeWm11xaZa4QppNB68yNLHpctcP/qcTsEa9DbKfb3t/g
         pDuGpbe5tkt/+Fkg7JMFJYEREFt7S9BLVA0100LY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230814094127epcas5p4f9452ff7b9bf737e987b3e0255d41af6~7NpJSd1d60560505605epcas5p4L;
        Mon, 14 Aug 2023 09:41:27 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RPTtY3mVmz4x9Px; Mon, 14 Aug
        2023 09:41:25 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.4E.55522.5C6F9D46; Mon, 14 Aug 2023 18:41:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230814093854epcas5p3875babea8f98e2414d06ca075d0cd18e~7Nm7Rf7EE2608826088epcas5p3g;
        Mon, 14 Aug 2023 09:38:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230814093854epsmtrp253fd0f0f9c5e6dca30912e82da0d4719~7Nm7QufCW1844018440epsmtrp2Q;
        Mon, 14 Aug 2023 09:38:54 +0000 (GMT)
X-AuditID: b6c32a49-67ffa7000000d8e2-8c-64d9f6c51d37
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.E9.34491.E26F9D46; Mon, 14 Aug 2023 18:38:54 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093853epsmtip1dfc6c8510d9f3781854588efe44d2747~7Nm6HDv1Q1006110061epsmtip1G;
        Mon, 14 Aug 2023 09:38:53 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 10/10] engines:io_uring: generate and verify pi for 64b
 guard
Date:   Mon, 14 Aug 2023 20:27:47 +0530
Message-Id: <20230814145747.114725-11-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpu7RbzdTDFaflLZYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdMe1rXkGracX0PQvZGxh7tLoYOTkkBEwkzky+ydbFyMUhJLCbUeLEtc3sEM4nRon5
        d2+yQjjfGCUudk5lhGlp29PCBJHYyygxtWkjVH8nk8SxiQ1sIFVsAtoSr97eYO5i5OAQEdCQ
        WHM3FaSGWaCFUWJ392xWkBphgSCJ9/+Pg9WzCKhKzNq8FyzOK2AnceZFP9Q2eYmZl76zg9ic
        QPH/U36zQ9QISpyc+YQFxGYGqmneOpsZZIGEwFt2iTuTLrJBNLtIPGuawwxhC0u8Or6FHcKW
        kvj8bi9UTbbEpoc/mSDsAokjL3qh6u0lWk/1gz3ALKApsX6XPkRYVmLqqXVMEHv5JHp/P4Fq
        5ZXYMQ/GVpX4e+82C4QtLXHz3VUo20Pi+s9GaGBNZJRYeaOdeQKjwiwk/8xC8s8shNULGJlX
        MUqmFhTnpqcWmxYY5qWWw2M5OT93EyM4dWp57mC8++CD3iFGJg7GQ4wSHMxKIry33K+lCPGm
        JFZWpRblxxeV5qQWH2I0BQb4RGYp0eR8YPLOK4k3NLE0MDEzMzOxNDYzVBLnfd06N0VIID2x
        JDU7NbUgtQimj4mDU6qByVZ5wbyphR8ufrNylIrUzrS8IHPR5ZzbLU+eufZFm5mfzhNWlVmk
        XfcuP+/SgjePF2244XZKtPfm8arfP87dN9dbLOSZY+Gjlj9xzcWnbPVrPk0+v7pa/n5nQMmD
        FRc5/539/nOmRXbk0bgg07hMtVaTDlXLoEtSxr8jZ6ut//f+reQiwentfFO4CgLnzdxzYx1n
        pVCpatU23yynab+uuFb97F22tLJqboSC9IGdk8rE9NWm3jgb9/X5nSnLRecFKG+bvWRKQhfz
        4Xi1srJ8w6YTs5/IT7pVvYnlU5BlRIfOkx3LNguXSj2SOMUZe8NUYS1r2KzjtYvcotolNQ5J
        HYnekuB74k6Y5XKzVSLSf5RYijMSDbWYi4oTAR/KqcomBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnK7et5spBtt2ylmsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGVM+5pX0GpaMX3PQvYGxh6tLkZODgkBE4m2PS1MILaQwG5G
        icM7tLsYOYDi0hIL1ydClAhLrPz3nL2LkQuopJ1JYsG3GWwgCTYBbYlXb28wg9giAloSx9Y1
        sYEUMQt0MUrs3T0NrEhYIEDi/ekrYAtYBFQlZm3eywpi8wrYSZx50c8IsUFeYual7+wgNidQ
        /P+U3+wQB9lKrFoIUy8ocXLmExYQmxmovnnrbOYJjAKzkKRmIUktYGRaxSiZWlCcm55bbFhg
        mJdarlecmFtcmpeul5yfu4kRHNhamjsYt6/6oHeIkYmD8RCjBAezkgjvLfdrKUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5xV/0pggJpCeWpGanphakFsFkmTg4pRqYCq+8MpOZf2TZTA8vXtsa
        4RWO0658c3K6Yb37w6tpE3VvFl0sMrhuPnd+d9pdgaLOwwqs3d5hYmF+FwTTDd9e2XVH654j
        S+XxPcJFfEUNncr8t6docskyLV+ncVXSzkxdprftvE2Oi8zE6m2ae/xYlxcc3fdbolD0kkqQ
        56u2K9XXanVK3z7etd+xW21nwIzM438VrY/tTtmzT+vLnucHc06dCN+eXKv/KeZR3xO1y2Fn
        p2gt0ateo3Nfzy///MHkddsCXP3/M3BLbYizyvouLPmsryVnvcXZDaY6O3u9eB7/qJLfeKFx
        xtPv6rMPp4g+0xZceuKHSbza0yk83fIlASvL77in+ty9lGgZ13RFiaU4I9FQi7moOBEA9WIG
        SdsCAAA=
X-CMS-MailID: 20230814093854epcas5p3875babea8f98e2414d06ca075d0cd18e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093854epcas5p3875babea8f98e2414d06ca075d0cd18e
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093854epcas5p3875babea8f98e2414d06ca075d0cd18e@epcas5p3.samsung.com>
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
index 41e7d07b..08503b33 100644
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

