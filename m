Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E278EB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjHKH4y (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234288AbjHKHrA (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:00 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32732D4F
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:46:55 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230811074654epoutp021fbd70fe2f68dfbd19326aaae978995f~6RJR0R6KA2800428004epoutp02I
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:46:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230811074654epoutp021fbd70fe2f68dfbd19326aaae978995f~6RJR0R6KA2800428004epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740014;
        bh=Z9wRBW2jjnwUk2s+dWDgk3iyjdFDSudCjOHIR5qt0t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHBjyovX7+52b0zs6seZdZgf3BDe7ge0pjAWhIT1l21YR73eFLyvk2JtFo7va72/g
         jlAFBl4DZ/3UnFohxqWLyPugYoHXVUQcjZ+xOZfjTk+HHjXeHWms7t6mDYBTpfXHMy
         gzXBmHOrgMpNCiW/9VNh46WYlA7+WjpdH94oN3hs=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230811074654epcas5p20888126f13f39c62eca8f811be0a1815~6RJRkcg_-0647806478epcas5p2d;
        Fri, 11 Aug 2023 07:46:54 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4RMbTm0FVkz4x9Q3; Fri, 11 Aug
        2023 07:46:52 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        29.29.57354.A67E5D46; Fri, 11 Aug 2023 16:46:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20230811060637epcas5p4a48caa81e6548a28ed0cf3edea5e7dd7~6PxuVp1i51050810508epcas5p4f;
        Fri, 11 Aug 2023 06:06:37 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230811060637epsmtrp182b21974cbe15654dd6922f2c3e1aec1~6PxuU5v3V3260432604epsmtrp1O;
        Fri, 11 Aug 2023 06:06:37 +0000 (GMT)
X-AuditID: b6c32a44-269fb7000001e00a-ad-64d5e76a387c
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.E0.14748.DEFC5D46; Fri, 11 Aug 2023 15:06:37 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060636epsmtip1a415268eecc627ca030fb6257d51c2e7~6Pxs3WAd02733527335epsmtip14;
        Fri, 11 Aug 2023 06:06:36 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 03/10] engines:io_uring: enable support for separate
 metadata buffer
Date:   Fri, 11 Aug 2023 16:55:40 +0530
Message-Id: <20230811112547.92345-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdlhTQzfr+dUUg65uRYs1V36zW6y+289m
        8XHWC2aLo//fsllMOnSN0WL58X9MFhvaBB3YPXbOusvucflsqcemVZ1sHh+f3mLx6NuyitHj
        8ya5ALaobJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wc
        oEuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmpJVaGBgZG
        pkCFCdkZnZd5C76YVBy//561gfGrZhcjB4eEgInE6W1VXYxcHEICuxklmjb9ZIVwPjFKLO+9
        ygLhfGOUaPjUzdTFyAnWMf1eCztEYi+jRNed+8wgCSGBTiaJSceEQWw2AW2JV29vMIOsEBHQ
        kFhzNxWknlmghVFid/dsVpAaYYFIiU/7V7GB2CwCqhJH5q1gAbF5BWwknn/6zAqxTF5i5qXv
        7CBzOAVsJRatEIMoEZQ4OfMJWDkzUEnz1tnMIPMlBD6ySxz50A3V6yJxZ8kEqKOFJV4d38IO
        YUtJvOxvg7KzJTY9/AlVUyBx5EUvM4RtL9F6qh/sfmYBTYn1u/QhwrISU0+tY4LYyyfR+/sJ
        VCuvxI55MLaqxN97t1kgbGmJm++uQtkeEr/m3GSDBNUERokfhy0mMCrMQvLOLCTvzELYvICR
        eRWjZGpBcW56arJpgWFeajk8hpPzczcxglOmlssOxhvz/+kdYmTiYDzEKMHBrCTCaxt8KUWI
        NyWxsiq1KD++qDQntfgQoykwuCcyS4km5wOTdl5JvKGJpYGJmZmZiaWxmaGSOO/r1rkpQgLp
        iSWp2ampBalFMH1MHJxSDUy5t5YaL3p+5aPkh13af/YktPo26oi+nC/F/znzFbNPWnVap3HD
        d5cZxxbnBOiF3DWNerSj6/tmv+7Qli3isYEfp2ezme5rD7400z2s8va1j5vK9Cpbp/+T9LNl
        k9duXv9lV/NUxXmlJg9mKPifOMLk9/cBT6jXWT5vVfOKJHu351Wn29n25/8M65n54kh3tGOC
        Yqyankn7CS819q4VK7yrUzaUTW08dHum2o1VtwSWzNjwr4fRu9szX6DwwMRFsp8V3xd4fts6
        d8tb5UKfKZe/M23MXC+ubbj30Iz6KsOZa7jenUh7m82g6/ht45qsPeo2UYnPO0/35zhnKpxm
        PNrn7x11UnNfTLs0wxrjF0osxRmJhlrMRcWJAJMqiXsiBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO7b81dTDN49VrJYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MrovMxb8MWk4vj996wNjF81uxg5OSQETCSm32th72Lk4hAS
        2M0oMedRE5DDAZSQlli4PhGiRlhi5b/nUDXtTBKd9zezgSTYBLQlXr29wQxiiwhoSRxb18QG
        UsQs0MUosXf3NLAiYYFwiabvv1lAbBYBVYkj81aA2bwCNhLPP31mhdggLzHz0newxZwCthKL
        VoiBhIWASl7N/M0GUS4ocXLmE7BWZqDy5q2zmScwCsxCkpqFJLWAkWkVo2RqQXFuem6yYYFh
        Xmq5XnFibnFpXrpecn7uJkZwYGtp7GC8N/+f3iFGJg7GQ4wSHMxKIry2wZdShHhTEiurUovy
        44tKc1KLDzFKc7AoifMazpidIiSQnliSmp2aWpBaBJNl4uCUamDqOPHS8/PxrSWPz5XkPxTi
        /cR7dI65pHH/+r9/ffYuKX5cMzEzUD3pozuDktqtm3OML/HbKX3dt+Xosoknd0+Z95YhT/S0
        2/Frgh9dOiwbckwrmBJiXnjfeyM+X2/tE5a6nXH7Wq8rvL0aKO9wfd5bpeoP2zYen7NdM+Ca
        fuIsLpMtHHoVB08Yrkg7XFpZ6LVq//6Jdj9eWVwsWO8mv/rozYVl8ew7lz7bukT6sa2isOS8
        m9+FdW8vNE8K3th97q1ExbX2+V8mzeBcv4R7iU31a44T8glBRzR8ds4N2iXy+9HNzWu1d71e
        s9io+dKJV0/dTlmf/hqinFO/5ucS3ckbxGdf+3Xh8hqGVcK925hdjeqUWIozEg21mIuKEwFd
        8WcB2wIAAA==
X-CMS-MailID: 20230811060637epcas5p4a48caa81e6548a28ed0cf3edea5e7dd7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060637epcas5p4a48caa81e6548a28ed0cf3edea5e7dd7
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060637epcas5p4a48caa81e6548a28ed0cf3edea5e7dd7@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch enables support for separate metadata buffer with
io_uring_cmd ioengine. As we are unaware of metadata size during buffer
allocation, we provide an option md_per_io_size. This option must be
used to specify metadata buffer size for single IO, if namespace is
formatted with a separate metadata buffer.

For the sake of consistency this is the same option as used by SPDK's
external ioengine.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst          |  4 ++++
 engines/io_uring.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.c     | 16 ++++++--------
 fio.1              |  3 +++
 4 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index ac8314f3..6e0677f2 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2487,6 +2487,10 @@ with the caveat that when used on the command line, they must come after the
         want fio to use placement identifier only at indices 0, 2 and 5 specify
         ``fdp_pli=0,2,5``.
 
+.. option:: md_per_io_size=int : [io_uring_cmd]
+
+	Size in bytes for separate metadata buffer per IO. Default: 0.
+
 .. option:: cpuload=int : [cpuio]
 
 	Attempt to use the specified percentage of CPU cycles. This is a mandatory
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 30d9ccd7..4916e3b0 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -59,6 +59,7 @@ struct ioring_data {
 	int ring_fd;
 
 	struct io_u **io_u_index;
+	char *md_buf;
 
 	int *fds;
 
@@ -95,6 +96,7 @@ struct ioring_options {
 	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
+	unsigned int md_per_io_size;
 	enum uring_cmd_type cmd_type;
 };
 
@@ -217,6 +219,16 @@ static struct fio_option options[] = {
 		.group	= FIO_OPT_G_IOURING,
 	},
 	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
+	{
+		.name	= "md_per_io_size",
+		.lname	= "Separate Metadata Buffer Size per I/O",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, md_per_io_size),
+		.def	= "0",
+		.help	= "Size of separate metadata buffer per I/O (Default: 0)",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -631,6 +643,7 @@ static void fio_ioring_cleanup(struct thread_data *td)
 
 		fio_cmdprio_cleanup(&ld->cmdprio);
 		free(ld->io_u_index);
+		free(ld->md_buf);
 		free(ld->iovecs);
 		free(ld->fds);
 		free(ld->dsm);
@@ -1016,6 +1029,7 @@ static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
 	struct ioring_data *ld;
+	unsigned long long md_size;
 	int ret;
 
 	/* sqthread submission requires registered files */
@@ -1036,6 +1050,28 @@ static int fio_ioring_init(struct thread_data *td)
 
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
+
+	/*
+	 * metadata buffer for nvme command.
+	 * We are only supporting iomem=malloc / mem=malloc as of now.
+	 */
+	if (!strcmp(td->io_ops->name, "io_uring_cmd") &&
+	    (o->cmd_type == FIO_URING_CMD_NVME) && o->md_per_io_size) {
+		md_size = (unsigned long long) o->md_per_io_size
+				* (unsigned long long) td->o.iodepth;
+		md_size += page_mask + td->o.mem_align;
+		if (td->o.mem_align && td->o.mem_align > page_size)
+			md_size += td->o.mem_align - page_size;
+		if (td->o.mem_type == MEM_MALLOC) {
+			ld->md_buf = malloc(md_size);
+			if (!ld->md_buf)
+				return 1;
+		} else {
+			log_err("fio: Only iomem=malloc or mem=malloc is supported\n");
+			return 1;
+		}
+	}
+
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
@@ -1062,8 +1098,17 @@ static int fio_ioring_init(struct thread_data *td)
 static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	char *p;
 
 	ld->io_u_index[io_u->index] = io_u;
+
+	if (!strcmp(td->io_ops->name, "io_uring_cmd")) {
+		p = PTR_ALIGN(ld->md_buf, page_mask) + td->o.mem_align;
+		p += o->md_per_io_size * io_u->index;
+		io_u->mmap_data = p;
+	}
+
 	return 0;
 }
 
@@ -1117,6 +1162,15 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
+			if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
+			    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) *
+						  data->ms))) {
+				log_err("%s: md_per_io_size should be at least %llu bytes\n",
+					f->file_name,
+					((td->o.max_bs[ddir] / data->lba_size) * data->ms));
+				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
+				return 1;
+			}
                 }
 	}
 	if (!ld || !o->registerfiles)
diff --git a/engines/nvme.c b/engines/nvme.c
index 7e891eed..65725e3c 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -79,6 +79,10 @@ int fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
 		cmd->addr = (__u64)(uintptr_t)io_u->xfer_buf;
 		cmd->data_len = io_u->xfer_buflen;
 	}
+	if (data->lba_shift && data->ms) {
+		cmd->metadata = (__u64)(uintptr_t)io_u->mmap_data;
+		cmd->metadata_len = (nlb + 1) * data->ms;
+	}
 	cmd->nsid = data->nsid;
 	return 0;
 }
@@ -149,21 +153,13 @@ int fio_nvme_get_info(struct fio_file *f, __u64 *nlba, struct nvme_data *data)
 		format_idx = (ns.flbas & 0xf) + (((ns.flbas >> 5) & 0x3) << 4);
 
 	data->lba_size = 1 << ns.lbaf[format_idx].ds;
+	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
 
 	/*
-	 * Only extended LBA can be supported.
 	 * Bit 4 for flbas indicates if metadata is transferred at the end of
 	 * logical block creating an extended LBA.
 	 */
-	data->ms = le16_to_cpu(ns.lbaf[format_idx].ms);
-	if (data->ms && !((ns.flbas >> 4) & 0x1)) {
-		log_err("%s: only extended logical block can be supported\n",
-			f->file_name);
-		err = -ENOTSUP;
-		goto out;
-	}
-
-	if (data->ms)
+	if (data->ms && ((ns.flbas >> 4) & 0x1))
 		data->lba_ext = data->lba_size + data->ms;
 	else
 		data->lba_shift = ilog2(data->lba_size);
diff --git a/fio.1 b/fio.1
index f62617e7..6b49a747 100644
--- a/fio.1
+++ b/fio.1
@@ -2247,6 +2247,9 @@ By default, the job will cycle through all available Placement IDs, so use this
 to isolate these identifiers to specific jobs. If you want fio to use placement
 identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
 .TP
+.BI (io_uring_cmd)md_per_io_size \fR=\fPint
+Size in bytes for separate metadata buffer per IO. Default: 0.
+.TP
 .BI (cpuio)cpuload \fR=\fPint
 Attempt to use the specified percentage of CPU cycles. This is a mandatory
 option when using cpuio I/O engine.
-- 
2.25.1

