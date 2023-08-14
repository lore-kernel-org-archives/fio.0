Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41E1DEB64DD
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233753AbjHNJlv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbjHNJl1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:27 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB2E10C1
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:22 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230814094120epoutp014f5ad12cbfac29e1eaf8423c593c7b04~7NpDRmTPe1101011010epoutp01B
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230814094120epoutp014f5ad12cbfac29e1eaf8423c593c7b04~7NpDRmTPe1101011010epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006080;
        bh=LIIOIMK2CXIxpjo1WmutVqxTmqvv64AE0AWPgxAVdAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JvMouuov+1/VXWzyaXNBL0eH52kyqGt9m8odpcJCRDoOQwhe9/1Knd+41nzaWwfVv
         Kr793jtYOLYNmobKhylVaGJwGx2z2QJuaqeoKHfzPo1O6VZm/EDAd5NjRI185QKZsu
         rE7ymTwg0StLhVq73cOYwg//Qc/EvYj32mCv3vw4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230814094120epcas5p182de006759ac49b8ec2260a888aebc6e~7NpC2Sy6o2999329993epcas5p10;
        Mon, 14 Aug 2023 09:41:20 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RPTtL1f0rz4x9Ps; Mon, 14 Aug
        2023 09:41:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
        1A.24.55173.9B6F9D46; Mon, 14 Aug 2023 18:41:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230814093849epcas5p431ac99960acca2847c4c3226c5781c7e~7Nm2wVR-91859818598epcas5p4m;
        Mon, 14 Aug 2023 09:38:49 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230814093849epsmtrp117ea5edfce66285c71ff567bdaab6bae~7Nm2u79n32343923439epsmtrp1a;
        Mon, 14 Aug 2023 09:38:49 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-ad-64d9f6b96e98
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        DD.CF.14748.926F9D46; Mon, 14 Aug 2023 18:38:49 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093848epsmtip160c2596c43e26f1248c0a4f7a33eb771~7Nm1mE63L1005510055epsmtip1H;
        Mon, 14 Aug 2023 09:38:48 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 07/10] engines:io_uring: generate and verify pi for 16b
 guard
Date:   Mon, 14 Aug 2023 20:27:44 +0530
Message-Id: <20230814145747.114725-8-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCJsWRmVeSWpSXmKPExsWy7bCmhu7ObzdTDG6+VLNYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCd0bP7AltBn3/Fob0bWBoYP9h1MXJwSAiYSLzr0Oxi5OIQEtjDKNHa9Y8FwvnEKHF+
        whpGCOcbo8Se1olsXYycYB33Vh9lhkjsZZQ4c/EyK4TTySQxb8sCdpAqNgFtiVdvbzCD7BAR
        0JBYczcVpIZZoIVRYnf3bFaQGmGBIIl5ryaATWURUJW4uHchE4jNK2ArcffqfVaIbfISMy99
        B5vJKWAn8X/Kb3aIGkGJkzOfsIDYzEA1zVtng10kIfCVXWLWovXsEM0uEmt/3mKBsIUlXh3f
        AhWXknjZ3wZlZ0tseviTCcIukDjyopcZwraXaD3VD/YAs4CmxPpd+hBhWYmpp9YxQezlk+j9
        /QSqlVdixzwYW1Xi773bUGulJW6+uwple0jsuPgXGnITGSXe/n7OOoFRYRaSf2Yh+WcWwuoF
        jMyrGKVSC4pz01OTTQsMdfNSy+HRnJyfu4kRnDy1AnYwrt7wV+8QIxMH4yFGCQ5mJRHeW+7X
        UoR4UxIrq1KL8uOLSnNSiw8xmgJDfCKzlGhyPjB955XEG5pYGpiYmZmZWBqbGSqJ875unZsi
        JJCeWJKanZpakFoE08fEwSnVwBT/SvmClPeX/ebTo4TOH648e3d/JXue4QsF8wynW85rM9S2
        Ldx/41xDbuWn534ZQpbzyrdU9Zs/fmM1/1O55WFTpcZ9ul2OHfIiTC73Dwus0Ra95Tx9ze9Z
        y+WO8ZyacaLLqEj4lmYFcwh/k9+bkiW2yjdL/v5PSn8U1vl4gWfg4g/V6xhY0+OemvLd8Nsq
        /GLJ3CzJaKvSzJke29jkTXw75ot/vnQjSu6L2osjb/N9Zn09UtZjdODhT+MzN/jnqikdEWXy
        eJ5wRKX8aplA0fIDnrUpAvp9O6TO+4lFlSW+jqj92P/p3ILM/0+sGiLzL73yufJZ6NPyX9wb
        HXUzDp6ZHm61YIfDLNlZshJPdiuxFGckGmoxFxUnAgDu/G6wJwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnK7mt5spBhv3KFusufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGX07L7AVtDnX3Fo7waWBsYPdl2MnBwSAiYS91YfZe5i5OIQ
        EtjNKDH/2xv2LkYOoIS0xML1iRA1whIr/z1nh6hpZ5JYdm4eK0iCTUBb4tXbG8wgtoiAlsSx
        dU1sIEXMAl2MEnt3T2MDGSQsECBxbaIRSA2LgKrExb0LmUBsXgFbibtX77NCLJCXmHnpOzuI
        zSlgJ/F/ym8wWwioZtXCvawQ9YISJ2c+YQGxmYHqm7fOZp7AKDALSWoWktQCRqZVjJKpBcW5
        6bnJhgWGeanlesWJucWleel6yfm5mxjBoa2lsYPx3vx/eocYmTgYDzFKcDArifDecr+WIsSb
        klhZlVqUH19UmpNafIhRmoNFSZzXcMbsFCGB9MSS1OzU1ILUIpgsEwenVANTROTlByHvLv3i
        1Ms1nlLFf3a+0wvVmsTsTNM1QdF1v8TlvTME3Q8a3k96YX1OYf7W3PtHz8mor/xZbzZJrHCh
        zIzWc425Gm0uK+ok5v7kePnv9uqC+H8/Sk4/PHONY6JmjLzh5+XbroWYsPnM8pXoPjaN4wej
        gLuquMzVGCEZ9qsyEznvncldf2HC77/LQtc+597MtGKT4C7FLVMbgh82Of75LTeH11joyqS/
        /MKKRw+nCeVHP63sVJ7nIhJXvqD+Y2YfB4vf/8+lihcnaKffemOY3TExtl1m2Sz3wMm+5lbn
        5I1bomY0V07pWxOccYTne7wPw8lF7yv2frc7Ybvo6u1PhkGP7/nPyWZ4cYxJiaU4I9FQi7mo
        OBEAH03vFtwCAAA=
X-CMS-MailID: 20230814093849epcas5p431ac99960acca2847c4c3226c5781c7e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093849epcas5p431ac99960acca2847c4c3226c5781c7e
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093849epcas5p431ac99960acca2847c4c3226c5781c7e@epcas5p4.samsung.com>
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
index 376a2a27..7ac7c755 100644
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
@@ -1411,6 +1444,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_cmd_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
+	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
 	.queue			= fio_ioring_queue,
 	.commit			= fio_ioring_commit,
diff --git a/engines/nvme.c b/engines/nvme.c
index 8793d742..6896dfc0 100644
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
+				guard = fio_crc_t10dif(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif(0, buf, data->lba_size);
+				guard = fio_crc_t10dif(guard, md_buf, pi_data->interval);
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
+	__u16 unmask_app, unmask_app_exp, guard = 0;
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
+				guard = fio_crc_t10dif(0, buf, pi_data->interval);
+			} else {
+				guard = fio_crc_t10dif(0, buf, data->lba_size);
+				guard = fio_crc_t10dif(guard, md_buf, pi_data->interval);
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

