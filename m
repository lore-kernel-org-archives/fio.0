Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A3ECEB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjHIGDZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjHIGDY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:24 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9CB1FD6
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:03:11 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230809060309epoutp023e8c262597c8371ef0f6ab0534439200~5ocHdGxdQ2531625316epoutp02e
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:03:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230809060309epoutp023e8c262597c8371ef0f6ab0534439200~5ocHdGxdQ2531625316epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560989;
        bh=P0ASYpZnbq16f6eMwYjW/FmeXMiXsnngWo+kScG2csE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmLc4Xe8438dNAqXCWl0klMTZr3xbTP9yaU+P/ZV0AVXIypQI9/ZB/6dgBRZvgx+I
         6EM+HDZGz5ckT1MOnG3PPvmTHoLRpHh3T1A90/4B6yiIf6iWkdAdqieLWDGaSKi+gA
         FjbmP5Y+b579h5mgVh3/wOx7yg1+1ox785Ojgl74=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230809060308epcas5p49937eff3bdac70da33ca0422afb0a8b9~5ocHI1P4t1789317893epcas5p4M;
        Wed,  9 Aug 2023 06:03:08 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RLKGz07Hqz4x9Q1; Wed,  9 Aug
        2023 06:03:07 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E0.58.55173.A1C23D46; Wed,  9 Aug 2023 15:03:06 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230809055421epcas5p4ff594788202cc188c5fbed3f19763e0c~5oUcaSvQ71660116601epcas5p4-;
        Wed,  9 Aug 2023 05:54:21 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055421epsmtrp112ce13727c2239c561f92121ce470de5~5oUcZmhTy3170131701epsmtrp1s;
        Wed,  9 Aug 2023 05:54:21 +0000 (GMT)
X-AuditID: b6c32a50-e61c07000001d785-f1-64d32c1a9af1
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.AE.30535.D0A23D46; Wed,  9 Aug 2023 14:54:21 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055420epsmtip1f8a29b5180dc1de9d76572e2bf1eced8~5oUbPQXN80677006770epsmtip1m;
        Wed,  9 Aug 2023 05:54:20 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 07/10] engines:io_uring: generate and verify pi for 16b
 guard
Date:   Wed,  9 Aug 2023 16:43:11 +0530
Message-Id: <20230809111314.76947-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmpq6UzuUUgwdLrSzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnfPnKXbDBv+L1zBOMDYwT7LsYOTkkBEwkHp9ZyN7FyMUhJLCHUeL2xtfMEM4nRolJ
        s7pYIJxvjBJrNq5jg2n5MnM6VGIvo8S06edZQRJCAp1MEkdXJILYbALaEq/e3gAaxcEhIqAh
        seZuKkg9s0ALo8Tu7tlg9cIC/hLTZ00AG8oioCqxrO8LmM0rYCMx8cwrVohl8hIzL31nB7E5
        BWwlVq25wQJRIyhxcuYTMJsZqKZ562ywsyUEPrJLLF/exAjR7CLx/ftiFghbWOLV8S3sELaU
        xMv+Nig7W2LTw59MEHaBxJEXvcwQtr1E66l+sAeYBTQl1u/ShwjLSkw9tY4JYi+fRO/vJ1Ct
        vBI75sHYqhJ/792GWistcfPdVSjbQ+Lik9OskICbwCixoOEE2wRGhVlI/pmF5J9ZCKsXMDKv
        YpRKLSjOTU9NNi0w1M1LLYfHcnJ+7iZGcOrUCtjBuHrDX71DjEwcjIcYJTiYlUR4bYMvpQjx
        piRWVqUW5ccXleakFh9iNAWG+ERmKdHkfGDyziuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9
        sSQ1OzW1ILUIpo+Jg1OqgWnJgZtzA5VPMhg8qbxvnVa5eNKM/alrJy0rYCtdGMfTXKXLXjmp
        fLZoSv7DhY8yP716+PLwYp4Mrg72A9WqD7O2c0XURV5Jfbfm18aYQqu6TSemyIr1L9SxiVW/
        dpvzJrsTl+mky0Yx2evfyrtOt1X2PJh7snv7e8dEln9+YqveX981MZDrwKmMOx9czBkfRqxQ
        fsBY+Dxkm9u0mJmdH0yctz036rvJxO//97YP80u12ean3uqlVXGazHLxsFE4NlOh76lnSUPP
        X+fNOv6h7NkFsfyZ+qZaB9o/XG/9uujOUo9ajvkXYiZUfY4IED/SXhehFzGnTuLqCm4e7TSV
        dScXlNevC2SSWnizbtdLCSWW4oxEQy3mouJEANzjQucmBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSnC6v1uUUg7f/NS3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDK+fOUu2OBf8XrmCcYGxgn2XYycHBICJhJfZk5nAbGFBHYz
        Skx/at7FyAEUl5ZYuD4RokRYYuW/5+xdjFxAJe1MEvNbJrCDJNgEtCVevb3BDGKLCGhJHFvX
        xAZSxCzQxSixd/c0NpBBwgK+EvN2OIDUsAioSizr+8IGYvMK2EhMPPOKFWKBvMTMS9/BZnIK
        2EqsWnMD6h4biYVvJzJD1AtKnJz5BCzODFTfvHU28wRGgVlIUrOQpBYwMq1ilEwtKM5Nzy02
        LDDKSy3XK07MLS7NS9dLzs/dxAgOay2tHYx7Vn3QO8TIxMF4iFGCg1lJhNc2+FKKEG9KYmVV
        alF+fFFpTmrxIUZpDhYlcd5vr3tThATSE0tSs1NTC1KLYLJMHJxSDUyB/iX/PtxmEPaZrhh8
        zmyXlYSUY9/1cyamCyfsublNR77tdjHf+SgWGZ3SOcKiZ/WvintyXldrC76x9rVeU4v6zcCv
        bbu+CGim5DIFOS77+XY2+4wLgUsUr6q9v55xQi2pdwXDjQ47OaEn2gHn47+0fBdkaJ66kX/q
        lamvxVdNkdwt8tHXbtYN50/zQ/SLGvz7pf3usJxyfbH7T7TCqcmfJHxW3igT+nc26++yCbv1
        LO9cl+LP7Pgveo7x7vmV82MMQms75iwV+6Vewdh0P8fYqnu57Y7cBRy3LBO63S8tfMotbpP9
        +7NU2SOBIwdmBT3/K9m97niImone89ILP4wK6hKFLzCdcM23PdnSuUaJpTgj0VCLuag4EQCS
        F9Ex2gIAAA==
X-CMS-MailID: 20230809055421epcas5p4ff594788202cc188c5fbed3f19763e0c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055421epcas5p4ff594788202cc188c5fbed3f19763e0c
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055421epcas5p4ff594788202cc188c5fbed3f19763e0c@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Generate and verify protection information for 16 bit guard format, for
the nvme backend of io_uring_cmd ioengine. The support is there for
both the cases where metadata is transferred in separate buffer, or
transferred at the end of logical block creating an extended logical
block.
This support also takes into consideration when protection information
resides in last or first 8 bytes of metadata.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c |  34 +++++++++
 engines/nvme.c     | 173 +++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.h     |  12 ++++
 3 files changed, 219 insertions(+)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 93b864f0..e773e4af 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -456,7 +456,9 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	struct ioring_options *o = td->eo;
 	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
+	struct nvme_data *data;
 	unsigned index;
+	int ret;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 	if (o->cmd_type == FIO_URING_CMD_NVME)
@@ -470,6 +472,15 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	else
 		io_u->error = 0;
 
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		data = FILE_ENG_DATA(io_u->file);
+		if (data->pi_type && (io_u->ddir == DDIR_READ) && !o->pi_act) {
+			ret = fio_nvme_pi_verify(data, io_u);
+			if (ret)
+				io_u->error = ret;
+		}
+	}
+
 	return io_u;
 }
 
@@ -1190,6 +1201,7 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
+	struct nvme_pi_data *pi_data;
 	char *p;
 
 	ld->io_u_index[io_u->index] = io_u;
@@ -1198,11 +1210,32 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
 		p += o->md_per_io_size * io_u->index;
 		io_u->mmap_data = p;
+
+		if (!o->pi_act) {
+			pi_data = calloc(1, sizeof(*pi_data));
+			pi_data->io_flags |= o->prchk;
+			pi_data->apptag_mask = o->apptag_mask;
+			pi_data->apptag = o->apptag;
+			io_u->engine_data = pi_data;
+		}
 	}
 
 	return 0;
 }
 
+static void fio_ioring_io_u_free(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_options *o = td->eo;
+	struct nvme_pi *pi;
+
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+	    (o->cmd_type == FIO_URING_CMD_NVME)) {
+		pi = io_u->engine_data;
+		free(pi);
+		io_u->engine_data = NULL;
+	}
+}
+
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -1408,6 +1441,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
 	.commit			= fio_ioring_commit,
diff --git a/engines/nvme.c b/engines/nvme.c
index 8793d742..e89faee5 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -4,6 +4,7 @@
  */
 
 #include "nvme.h"
+#include "../crc/crc-t10dif.h"
 
 static inline __u64 get_slba(struct nvme_data *data, struct io_u *io_u)
 {
@@ -21,6 +22,158 @@ static inline __u32 get_nlb(struct nvme_data *data, struct io_u *io_u)
 		return (io_u->xfer_buflen >> data->lba_shift) - 1;
 }
 
+static void fio_nvme_generate_pi_16b_guard(struct nvme_data *data,
+					   struct io_u *io_u,
+					   struct nvme_cmd_ext_io_opts *opts)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_16b_guard_pif *pi;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 guard = 0;
+
+	if (data->pi_loc) {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - data->ms;
+		else
+			pi_data->interval = 0;
+	} else {
+		if (data->lba_ext)
+			pi_data->interval = data->lba_ext - sizeof(struct nvme_16b_guard_pif);
+		else
+			pi_data->interval = data->ms - sizeof(struct nvme_16b_guard_pif);
+	}
+
+	if (io_u->ddir != DDIR_WRITE)
+		return;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc_t10dif_generic(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif_generic(0, buf, data->lba_size);
+				guard = fio_crc_t10dif_generic(guard, md_buf, pi_data->interval);
+			}
+			pi->guard = cpu_to_be16(guard);
+		}
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_APP)
+			pi->apptag = cpu_to_be16(pi_data->apptag);
+
+		if (opts->io_flags & NVME_IO_PRINFO_PRCHK_REF) {
+			switch (data->pi_type) {
+			case NVME_NS_DPS_PI_TYPE1:
+			case NVME_NS_DPS_PI_TYPE2:
+				pi->srtag = cpu_to_be32((__u32)slba + lba_num);
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
+static int fio_nvme_verify_pi_16b_guard(struct nvme_data *data,
+					struct io_u *io_u)
+{
+	struct nvme_pi_data *pi_data = io_u->engine_data;
+	struct nvme_16b_guard_pif *pi;
+	struct fio_file *f = io_u->file;
+	unsigned char *buf = io_u->xfer_buf;
+	unsigned char *md_buf = io_u->mmap_data;
+	__u64 slba = get_slba(data, io_u);
+	__u32 nlb = get_nlb(data, io_u) + 1;
+	__u32 lba_num = 0;
+	__u16 guard = 0;
+
+	while (lba_num < nlb) {
+		if (data->lba_ext)
+			pi = (struct nvme_16b_guard_pif *)(buf + pi_data->interval);
+		else
+			pi = (struct nvme_16b_guard_pif *)(md_buf + pi_data->interval);
+
+		if (data->pi_type == NVME_NS_DPS_PI_TYPE3) {
+			if (pi->apptag == NVME_PI_APP_DISABLE &&
+			    pi->srtag == NVME_PI_REF_DISABLE)
+				goto next;
+		} else if (data->pi_type == NVME_NS_DPS_PI_TYPE1 ||
+			   data->pi_type == NVME_NS_DPS_PI_TYPE2) {
+			if (pi->apptag == NVME_PI_APP_DISABLE)
+				goto next;
+		}
+
+		if (pi_data->io_flags & NVME_IO_PRINFO_PRCHK_GUARD) {
+			if (data->lba_ext) {
+				guard = fio_crc_t10dif_generic(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif_generic(0, buf, data->lba_size);
+				guard = fio_crc_t10dif_generic(guard, md_buf, pi_data->interval);
+			}
+			if (be16_to_cpu(pi->guard) != guard) {
+				log_err("%s: Guard compare error: LBA: %llu Expected=%x, Actual=%x\n",
+					f->file_name, (unsigned long long)slba,
+					guard, be16_to_cpu(pi->guard));
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
+				if (be32_to_cpu(pi->srtag) !=
+				    ((__u32)slba + lba_num)) {
+					log_err("%s: REFTAG compare error: LBA: %llu Expected=%x, Actual=%x\n",
+						f->file_name, (unsigned long long)slba,
+						(__u32)slba + lba_num,
+						be32_to_cpu(pi->srtag));
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
+
 void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 				  struct nvme_dsm_range *dsm)
 {
@@ -96,6 +249,11 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	slba = get_slba(data, io_u);
 	cmd->cdw12 |= opts->io_flags;
 
+	if (data->pi_type && !(opts->io_flags & NVME_IO_PRINFO_PRACT)) {
+		if (data->guard_type == NVME_NVM_NS_16B_GUARD)
+			fio_nvme_generate_pi_16b_guard(data, io_u, opts);
+	}
+
 	switch (data->pi_type) {
 	case NVME_NS_DPS_PI_TYPE1:
 	case NVME_NS_DPS_PI_TYPE2:
@@ -120,6 +278,21 @@ void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 	}
 }
 
+int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u)
+{
+	int ret = 0;
+
+	switch (data->guard_type) {
+	case NVME_NVM_NS_16B_GUARD:
+		ret = fio_nvme_verify_pi_16b_guard(data, io_u);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 static int nvme_identify(int fd, __u32 nsid, enum nvme_identify_cns cns,
 			 enum nvme_csi csi, void *data)
 {
diff --git a/engines/nvme.h b/engines/nvme.h
index f3598352..a1102dfe 100644
--- a/engines/nvme.h
+++ b/engines/nvme.h
@@ -44,6 +44,9 @@ struct nvme_uring_cmd {
 #define NVME_IDENTIFY_CSI_SHIFT 24
 #define NVME_NQN_LENGTH	256
 
+#define NVME_PI_APP_DISABLE 0xFFFF
+#define NVME_PI_REF_DISABLE 0xFFFFFFFF
+
 #define NVME_ZNS_ZRA_REPORT_ZONES 0
 #define NVME_ZNS_ZRAS_FEAT_ERZ (1 << 16)
 #define NVME_ZNS_ZSA_RESET 0x4
@@ -131,6 +134,13 @@ enum nvme_io_control_flags {
 	NVME_IO_PRINFO_PRACT		= 1U << 29,
 };
 
+struct nvme_pi_data {
+	__u32 interval;
+	__u32 io_flags;
+	__u16 apptag;
+	__u16 apptag_mask;
+};
+
 struct nvme_lbaf {
 	__le16			ms;
 	__u8			ds;
@@ -415,6 +425,8 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 void fio_nvme_pi_fill(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		      struct nvme_cmd_ext_io_opts *opts);
 
+int fio_nvme_pi_verify(struct nvme_data *data, struct io_u *io_u);
+
 int fio_nvme_get_zoned_model(struct thread_data *td, struct fio_file *f,
 			     enum zbd_zoned_model *model);
 
-- 
2.25.1

