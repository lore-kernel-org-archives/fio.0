Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52616EB64DD
	for <fio@archiver.kernel.org>; Wed,  9 Aug 2023 06:03:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjHIGDB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 9 Aug 2023 02:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjHIGDA (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 9 Aug 2023 02:03:00 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EAB1BFE
        for <fio@vger.kernel.org>; Tue,  8 Aug 2023 23:02:58 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230809060256epoutp04b01915117e9de1f99961a6b7a4f8e008~5ob7e2UXq1877518775epoutp04J
        for <fio@vger.kernel.org>; Wed,  9 Aug 2023 06:02:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230809060256epoutp04b01915117e9de1f99961a6b7a4f8e008~5ob7e2UXq1877518775epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691560976;
        bh=6fd4eY+svlvF+SyRHFoC1fNbvdzb0qabvpoRhFZAids=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTMJ+fiWSyX35t/2AdlQ/RJ62cVZyDDztHLdPNJALFJZRHTYePLrCPRc2weInlHXx
         sqfIRcIVqwgF5gbl6cuPXXRaCNj4O8MdZZNVxRFGm36kaOuBMUBDNqQ9sDLi5IX2BC
         iD/BPlohb6yTbpby2dYqHooM47viy+wJU/XJ80ME=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230809060255epcas5p22261024a15e952f8c8cff986557e6fc9~5ob7NBvpV1127511275epcas5p2v;
        Wed,  9 Aug 2023 06:02:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RLKGk35rSz4x9Pp; Wed,  9 Aug
        2023 06:02:54 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.A0.44250.E0C23D46; Wed,  9 Aug 2023 15:02:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055416epcas5p1bd18cd6413c64f10780e9c0ccdc92706~5oUXgPLop1418514185epcas5p1h;
        Wed,  9 Aug 2023 05:54:16 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230809055416epsmtrp1923711f8bd07c025beb1685bd279670a~5oUXfoKCv3170131701epsmtrp1k;
        Wed,  9 Aug 2023 05:54:16 +0000 (GMT)
X-AuditID: b6c32a4a-ec1fd7000000acda-39-64d32c0eca84
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
        18.D2.64355.80A23D46; Wed,  9 Aug 2023 14:54:16 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230809055415epsmtip1cc6effda69681dab4d53faa5c96a4296~5oUWW1Zmc0678306783epsmtip1u;
        Wed,  9 Aug 2023 05:54:15 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 03/10] engines:io_uring: enable support for separate
 metadata buffer
Date:   Wed,  9 Aug 2023 16:43:07 +0530
Message-Id: <20230809111314.76947-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230809111314.76947-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmui6fzuUUg9XbRC3WXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiism0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gC5RUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgY
        mQIVJmRnHD69n63grlHFjxUP2RoYJ2l0MXJySAiYSBxrOc4CYgsJ7GaUWHa5uIuRC8j+xChx
        eMZjVjhnzZTZbDAdR/fthUrsZJS4/uoPC4TTySRxYt5aRpAqNgFtiVdvbzB3MXJwiAhoSKy5
        mwpSwyzQwiixu3s2K0iNsECYxOrta5hAbBYBVYnnJzrANvAK2EjsarrKCLFNXmLmpe/sIDan
        gK3EqjU3WCBqBCVOznwCZjMD1TRvnc0MskBC4C27xMymKcwQzS4SP1ZugzpbWOLV8S3sELaU
        xMv+Nig7W2LTw59MEHaBxJEXvVC99hKtp/rBHmAW0JRYv0sfIiwrMfXUOiaIvXwSvb+fQLXy
        SuyYB2OrSvy9d5sFwpaWuPnuKpTtIXHr/zZoyE1glNi1ZyvTBEaFWUj+mYXkn1kIqxcwMq9i
        lEwtKM5NTy02LTDKSy2Hx3Jyfu4mRnDq1PLawfjwwQe9Q4xMHIyHGCU4mJVEeG2DL6UI8aYk
        VlalFuXHF5XmpBYfYjQFBvhEZinR5Hxg8s4riTc0sTQwMTMzM7E0NjNUEud93To3RUggPbEk
        NTs1tSC1CKaPiYNTqoEpyoftvM+8wty537c/eeHaxcxf38JX8fXsHO3NLtbG/oe06278Wp0S
        unbhLO2FDTmfIk/axzWIX73+KUFNN8SMn+XNdClx16ztH1pu/spaannQoCwx3DDmV7buT8Wl
        u2a/uPr4LJfT4ugNU1eocUwvfZn93VZ0o1CDWlvD77XumjYXlE4pL9otNflYgEVOzwrjyG1m
        btevak3cI6JZ4aIqWRUvrWEfZfC8doN1APdUE4Zbu7v/8iUkMW5+uGy7UdGlIjP/TQsz3/a5
        L5Q02DBP69Gqb29ff+XaKiuyeu/spHk7WdZd3V+4vGCb84uG1X9XGev2CLUvbtVz4uZUF30d
        adW8y1Hl/o2CV1843Y8rsRRnJBpqMRcVJwIAW72NCiYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnC6H1uUUgxX7JCzWXPnNbrH6bj+b
        xcdZL5gtjv5/y2Yx6dA1Rovlx/8xWWxoE3Rg99g56y67x+WzpR6bVnWyeXx8eovFo2/LKkaP
        z5vkAtiiuGxSUnMyy1KL9O0SuDIOn97PVnDXqOLHiodsDYyTNLoYOTkkBEwkju7by9rFyMUh
        JLCdUeJq80LmLkYOoIS0xML1iRA1whIr/z1nh6hpZ5JonfyGDSTBJqAt8ertDWYQW0RAS+LY
        uiY2kCJmgS5Gib27p4EVCQuESEzZPocVxGYRUJV4fqIDLM4rYCOxq+kqI8QGeYmZl76zg9ic
        ArYSq9bcYAGxhYBqFr6dyAxRLyhxcuYTsDgzUH3z1tnMExgFZiFJzUKSWsDItIpRNLWgODc9
        N7nAUK84Mbe4NC9dLzk/dxMjOKi1gnYwLlv/V+8QIxMH4yFGCQ5mJRFe2+BLKUK8KYmVValF
        +fFFpTmpxYcYpTlYlMR5lXM6U4QE0hNLUrNTUwtSi2CyTBycUg1Mmjt0U8++ERTIqpquUmhz
        euazRJ4rWsbCUu8DJXYlfRYSkZu0WuDsPou4e+Hq3+Vqp9j7RWRl57V41zq8OXVCe9vf/Prq
        c3lxftf2uP3bbclyIWty4SPVt+ILyqvsPp89uFbRfuH+tWv0vp65ty1tjaW/RNopYdO399ad
        a/fZf3W118X5LD6XdT9N+OK7RS720dJcqUh3sR0v/mzQ73yaWHf1pY5Y9Z5pdf2G8+3cPc6o
        G18OvLUnbpZU9fKqU7Z2FksWHpzwruDnxB1PS1c/cboqPv3m/qKOY5NcZ5U+NqwW3r88s3CP
        1tYA728Sm+cbphS33L9+JHXb3zox/f54li0xfzd2Fu1p2D7DnU/5sRJLcUaioRZzUXEiAGQY
        u/DZAgAA
X-CMS-MailID: 20230809055416epcas5p1bd18cd6413c64f10780e9c0ccdc92706
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230809055416epcas5p1bd18cd6413c64f10780e9c0ccdc92706
References: <20230809111314.76947-1-ankit.kumar@samsung.com>
        <CGME20230809055416epcas5p1bd18cd6413c64f10780e9c0ccdc92706@epcas5p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This patch enables support for separate metadata buffer.
As we are unaware of metadata size during buffer allocation, we provide
an option md_per_io_size. This can be used to specify metadata size for
single IO.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 HOWTO.rst          |  4 ++++
 engines/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++
 engines/nvme.c     | 16 ++++++--------
 fio.1              |  3 +++
 4 files changed, 65 insertions(+), 10 deletions(-)

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
index 2b707927..0dfd5f17 100644
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
+			log_err("fio: bad mem type: %d\n", td->o.mem_type);
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
 
@@ -1116,6 +1161,13 @@ static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
 				td_verror(td, EINVAL, "fio_ioring_cmd_open_file");
 				return 1;
 			}
+			if (data->ms && !data->lba_ext && ddir != DDIR_TRIM &&
+			    (o->md_per_io_size < ((td->o.max_bs[ddir] / data->lba_size) *
+						  data->ms))) {
+				log_err("md per io size should be sufficient for metadata payload\n");
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

