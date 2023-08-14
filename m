Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98762C41513
	for <fio@archiver.kernel.org>; Mon, 14 Aug 2023 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjHNJlU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Aug 2023 05:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234006AbjHNJlD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Aug 2023 05:41:03 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11C8109
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 02:41:01 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230814094100epoutp02b3defa6c8fbe928128aaae89de51c9f6~7NowYdO0J2662926629epoutp02G
        for <fio@vger.kernel.org>; Mon, 14 Aug 2023 09:41:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230814094100epoutp02b3defa6c8fbe928128aaae89de51c9f6~7NowYdO0J2662926629epoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1692006060;
        bh=Z9wRBW2jjnwUk2s+dWDgk3iyjdFDSudCjOHIR5qt0t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odyyMabAwWq3U4qyNSd2/DZ9eLbCmes7MGik7i6NPpOttH4jp4RmwrKxSTzA2PvM8
         aYZ/W9jNjajnHOn3/0W54j5bG+g5lBwzbCgxXbcTSEjRhrdPssxqrGwERZhH75Pldy
         Ns5eSsbm3zw/pUf7uPYv6tviwc4oaN9BsKD6nJ60=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230814094059epcas5p3d925fdcd8680901358e218684fb876e6~7NowCcsP20917709177epcas5p3t;
        Mon, 14 Aug 2023 09:40:59 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RPTt20p1xz4x9Pp; Mon, 14 Aug
        2023 09:40:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E1.4B.57354.9A6F9D46; Mon, 14 Aug 2023 18:40:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230814093842epcas5p22d5ee07c754ebd5067df214fe4f26dec~7NmvtQFXR3200132001epcas5p27;
        Mon, 14 Aug 2023 09:38:42 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230814093842epsmtrp1497f13bc9681bc297c7e2a4168930dd7~7NmvsoCdi2343923439epsmtrp1O;
        Mon, 14 Aug 2023 09:38:42 +0000 (GMT)
X-AuditID: b6c32a44-007ff7000001e00a-d0-64d9f6a959a0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AD.E9.34491.226F9D46; Mon, 14 Aug 2023 18:38:42 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230814093840epsmtip15b3ee79eb6cd8791b911f55995ed6e36~7NmuTJeWt1006110061epsmtip1E;
        Mon, 14 Aug 2023 09:38:40 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v3 03/10] engines:io_uring: enable support for separate
 metadata buffer
Date:   Mon, 14 Aug 2023 20:27:40 +0530
Message-Id: <20230814145747.114725-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230814145747.114725-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmhu7KbzdTDBZMELdYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        AbpESaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCd0XmZt+CLScXx++9ZGxi/anYxcnJICJhIvFs6jbWLkYtDSGA3o8S8w3dYIJxPjBL7
        z75hhnC+MUpMa7/N2MXIAday7rYrRHwvo8TrI/eh2juZJH5/mskEMpdNQFvi1dsbzCANIgIa
        EmvupoLUMAu0MErs7p7NClIjLBApse/JVTCbRUBV4tmlS+wgNq+ArcTBlU9YIe6Tl5h56TtY
        nFPATuL/lN9QNYISJ2c+YQGxmYFqmrfOBrtUQuAtu8T2tj1sEM0uEld6IQ6SEBCWeHV8CzuE
        LSXxsr8Nys6W2PTwJ1RNgcSRF73MELa9ROupfrAHmAU0Jdbv0ocIy0pMPbWOCWIvn0Tv7ydQ
        rbwSO+bB2KoSf+/dZoGwpSVuvrsKZXtIfLr8iAkSWBMZJeYufcE6gVFhFpJ/ZiH5ZxbC6gWM
        zKsYJVMLinPTU5NNCwzzUsvhkZycn7uJEZw4tVx2MN6Y/0/vECMTB+MhRgkOZiUR3lvu11KE
        eFMSK6tSi/Lji0pzUosPMZoCA3wis5Rocj4wdeeVxBuaWBqYmJmZmVgamxkqifO+bp2bIiSQ
        nliSmp2aWpBaBNPHxMEp1cBktGjyCZfXZ45tmvU6NeNVd6HXoxavC7eMOuT1psirr3oZzzyP
        +2BG9+6i3+1fajeLWBQX9kgdONfXFJppVcJXcuZEaNAZg5Urr5hdcLuqN+fG0r/JZ9fsqk0o
        XrcwIjVPembDhkseDTdPCzYV990QVb4hKVTHfG/1ZumIpsgOKfalbLxiExfW2X05ssLqWZmI
        24lOXvYY1iaHuhWcryWlZ6yR/XIlQHvt8r6ytScn7516IkO743TEUs0F7r78jCflguM3K+7c
        seeUV8g5SQHWm3zz5ijeF+6fc4OJv2C755YXUjcnRytx8ifLOPovDWm2mZh+be0e1oDPq6ay
        PFzPZJmuVX95R8nXC/uPWlxSYinOSDTUYi4qTgQAowA7YyUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSnK7St5spBkeusVisufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFcdmkpOZklqUW6dslcGV0XuYt+GJScfz+e9YGxq+aXYwcHBICJhLrbrt2MXJxCAns
        ZpTo33yTCSIuLbFwfWIXIyeQKSyx8t9zdhBbSKCdSaL/oS2IzSagLfHq7Q1mEFtEQEvi2Lom
        NpA5zAJdjBJ7d09jA5kjLBAuceWsEUgNi4CqxLNLl8Dm8ArYShxc+YQVYr68xMxL38HinAJ2
        Ev+n/IbaZSuxauFeVoh6QYmTM5+wgNjMQPXNW2czT2AUmIUkNQtJagEj0ypGydSC4tz03GLD
        AsO81HK94sTc4tK8dL3k/NxNjOCg1tLcwbh91Qe9Q4xMHIyHGCU4mJVEeG+5X0sR4k1JrKxK
        LcqPLyrNSS0+xCjNwaIkziv+ojdFSCA9sSQ1OzW1ILUIJsvEwSnVwCS7v0ROb4NfUGvaEva6
        fYtWda8VEV5sqZJafci2qLCVJ1y729NO4A/nW2aZ4DtuV/4znuiVqMi5x7///fxNczbs49x/
        3b7qjdjP2HeXbwXsubK9W+DSv7cFSxMK95T0S66YpFrBEH20KTpM4OtM/Uzj3fvN7TX4DirV
        z2z9+3qmNuOmuhU+mtqemfva+pdXT67uKVCJDexTsN74lY/9nkDpVJ5DB5VdeCwmxO88K2Zy
        aUuO3IztXycnHGxZEeZf+MjxuUpUB3/Q8bLJS0oijc9OP6kpcU33SoNjcucbNofQr9f3uU5+
        IbO4Jrntce2826zWrTsYDz4Ne5c25bfsJJ3E6yFfOqVc6hLYC512K7EUZyQaajEXFScCANTk
        27/ZAgAA
X-CMS-MailID: 20230814093842epcas5p22d5ee07c754ebd5067df214fe4f26dec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230814093842epcas5p22d5ee07c754ebd5067df214fe4f26dec
References: <20230814145747.114725-1-ankit.kumar@samsung.com>
        <CGME20230814093842epcas5p22d5ee07c754ebd5067df214fe4f26dec@epcas5p2.samsung.com>
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

