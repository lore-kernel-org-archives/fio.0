Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA613EB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbjHIGDc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjHIGDc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:32 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF84E1FD5
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:23 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230809060321epoutp029e89d7d1f54c4ee5cf5575b90f06f11b~5ocTZGXBE2954929549epoutp02S
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230809060321epoutp029e89d7d1f54c4ee5cf5575b90f06f11b~5ocTZGXBE2954929549epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691561001;
        bh=XcmeJgm/8ly3mVuLSQn2GYIJoPHUHDi2DP7hf4vSupQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uaup8kBhpyXMsAT0tY7ToUBG0r1FM3sd0zHyoOYpIqo3JqbmWMaZdwNNRx2mjkMzp
         RNPRu/nV4bd8vWMc5VN9pmBHvmsGIcErumQoi+a3vdtZYz3abKtnzXOpuIev8Eu3b4
         qT3DcNwS5uLV6ctXn9kruRGVN9CERjPdlXfskhhU=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230809060321epcas5p37c05b215a678e86963331d427340d2a7~5ocTBNPJJ0657106571epcas5p3G;
        Wed,  9 Aug 2023 06:03:21 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RLKHB1svBz4x9Pv; Wed,  9 Aug
        2023 06:03:18 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.C0.44250.32C23D46; Wed,  9 Aug 2023 15:03:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230809055425epcas5p48d90059042b45333d73d8b814b0a501c~5oUf-AkBf1660116601epcas5p4J;
        Wed,  9 Aug 2023 05:54:25 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055425epsmtrp1b632cfc7984c7dad3c9f893e3f90fdb0~5oUf_boO43170131701epsmtrp1u;
        Wed,  9 Aug 2023 05:54:25 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-72-64d32c2399ca
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.D2.64355.11A23D46; Wed,  9 Aug 2023 14:54:25 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055424epsmtip189db59a39f82fec4763c4447e377dfc0~5oUe3QG7J0790107901epsmtip1G;
        Wed,  9 Aug 2023 05:54:24 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 10/10] engines:io_uring: generate and verify pi for 64b
 guard
Date:   Wed,  9 Aug 2023 16:43:14 +0530
Message-Id: <20230809111314.76947-11-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmhq6yzuUUg9/P1C3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRn3Ltwh7ngvGnFpo6HTA2M+7W6GDk5JARMJCbvms7SxcjFISSwm1HiSPsFKOcTo8Si
        rU8RnOOzTrDDtKz5OYkJIrGTUeLdw3WMEE4nk8THI62sIFVsAtoSr97eYO5i5OAQEdCQWHM3
        FaSGWaCFUWJ392ywGmEBf4lpP/exgdSwCKhK/OrVBAnzCthKbPjSyAqxTF5i5qXvYIs5geKr
        1txggagRlDg58wmYzQxU07x1NjPIfAmBl+wSx+43M0I0u0jc3j6TDcIWlnh1fAvUB1ISL/vb
        oOxsiU0PfzJB2AUSR170MkPY9hKtp/rB7mcW0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXySuyY
        B2OrSvy9d5sFwpaWuPnuKpTtIfFh12awv4QEJjBKPNwdN4FRYRaSd2YheWcWwuYFjMyrGCVT
        C4pz01OLTQuM8lLL4ZGcnJ+7iRGcOLW8djA+fPBB7xAjEwfjIUYJDmYlEV7b4EspQrwpiZVV
        qUX58UWlOanFhxhNgcE9kVlKNDkfmLrzSuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1O
        TS1ILYLpY+LglGpgWsTIxeDnPinB+9A7g1C1JFYOAW/RDxrfPlzjT7tyMHprxjarOJf5j29K
        TynrynBestmd7fak8hmZah2KsawK+zWl9nGfKYvTdZndnx/HYu7NdJz15drl76aLz8+pvTzZ
        pKf4Vc2Ejwpcavatb409cyYJfVp71NWn+mGnQn6J048ZGiU5eU8OlwmqyEhwXuf77frCwKEr
        YlrstJYnUzLyJ5w1ucKd5cJ9Zw+D9mLXs+XZsetz9djmWv3Zzcd/i2Hz5N5rybrKHVURd4rn
        aG9ceV2z9a3dxth/a1ZcyU3eb3rt5P4yvSapGlc57cTqhohCPbfXE0oY61fe5ptxvdIsML9x
        a7osM9/8k59uRSuxFGckGmoxFxUnAgB8zhocJQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnK6g1uUUg8dL5C3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDLuXbjDXHDetGJTx0OmBsb9Wl2MnBwSAiYSa35OYupi5OIQ
        EtjOKHFt5XcghwMoIS2xcH0iRI2wxMp/z9khatqZJBo3/mEHSbAJaEu8enuDGcQWEdCSOLau
        iQ2kiFmgi1Fi7+5pbCCDhAV8JdbcMwExWQRUJX71aoKU8wrYSmz40sgKMV9eYual72AjOYHi
        q9bcYAGxhQRsJBa+ncgMUS8ocXLmE7A4M1B989bZzBMYBWYhSc1CklrAyLSKUTS1oDg3PTe5
        wFCvODG3uDQvXS85P3cTIzigtYJ2MC5b/1fvECMTB+MhRgkOZiURXtvgSylCvCmJlVWpRfnx
        RaU5qcWHGKU5WJTEeZVzOlOEBNITS1KzU1MLUotgskwcnFINTDb5zovu/PsoXu2pnLlD2Xev
        46OXZa+NK55d6DBb5Px/13fHrALbV38iQ1XO9x28OEFQbK//oZLsyIB3H7ZN2f7+/AzT3e7c
        14zWhy/YnLnWIaBad/mS7VPnCByZ2pmZ3fAy5XVggDrX55eO9pdL1ivV62rF1Zeyr26epfNf
        XcZEU2SRqsKvl2qbVCLn9eV4RVyfk8jV5Xn+7aVVlydevKCpuyVCKljjVVZOmrlByJaFS+1P
        94R+u7yobTqf/1njpjMcs+IktAPy36teOzeDp3Yqy2fdXn3j/f2a9gqzOoK6DT5d+HJEbqJT
        ZuHclUb+nxsNBX4Ldx9bIfrB/+3RQI78r5ei/W4y1Z95Hdv2UImlOCPRUIu5qDgRABgrlFPX
        AgAA
X-CMS-MailID: 20230809055425epcas5p48d90059042b45333d73d8b814b0a501c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055425epcas5p48d90059042b45333d73d8b814b0a501c
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055425epcas5p48d90059042b45333d73d8b814b0a501c@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Generate and verify protection information for 64 bit guard format, for
the nvme backend of io_uring_cmd ioengine. The support is there for
both the cases where metadata is transferred in separate buffer, or
transferred at the end of logical block creating an extended logical
block.
This support also takes into consideration when protection information
resides in last or first 8 bytes of metadata.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/nvme.c | 159 +++++++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h |   7 +++
 2 files changed, 166 insertions(+)

diff --git a/engines/nvme.c b/engines/nvme.c
index 724950be..db0d70bf 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -6,6 +6,7 @@
 
 #include "nvme.h"
 #include "../crc/crc-t10dif.h"
+#include "../crc/crc64.h"
 
 static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
 {
@@ -175,6 +176,159 @@ next:
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
+				guard = fio_crc64_rocksoft_generic(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_rocksoft_generic(0, buf, data->lba_size);
+				guard = fio_crc64_rocksoft_generic(guard, md_buf,
+								   pi_data->interval);
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
+				guard = fio_crc64_rocksoft_generic(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc64_rocksoft_generic(0, buf, data->lba_size);
+				guard = fio_crc64_rocksoft_generic(guard, md_buf,
+								   pi_data->interval);
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
+			if ((be16_to_cpu(pi->apptag) & pi_data->apptag_mask) !=
+			    (pi_data->apptag & pi_data->apptag_mask)) {
+				log_err("%s: APPTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					(pi_data->apptag & pi_data->apptag_mask),
+					be16_to_cpu(pi->apptag) & pi_data->apptag_mask);
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
@@ -253,6 +407,8 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
 		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
 			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
+		else if (data->guard_type == NVME_NVM_NS_64B_GUARD)
+			fio_nvme_generate_pi_64b_guard(data, io_u, opts);
 	}
 
 	switch (data->pi_type) {
@@ -287,6 +443,9 @@ int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
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

