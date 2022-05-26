Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5EBC433F5
	for <fio@archiver.kernel.org>; Thu, 26 May 2022 16:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346481AbiEZQs1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 26 May 2022 12:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347535AbiEZQs0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 May 2022 12:48:26 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B4F562EA
        for <fio@vger.kernel.org>; Thu, 26 May 2022 09:48:24 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220526164820epoutp017d033c20a520e81b6fe637141d186e4b~ytZ0_xyKj3258932589epoutp01G
        for <fio@vger.kernel.org>; Thu, 26 May 2022 16:48:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220526164820epoutp017d033c20a520e81b6fe637141d186e4b~ytZ0_xyKj3258932589epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653583700;
        bh=3Na+RV7kodDBJBOYdvbO1NMHQu3PdJITm8k8cBL0vuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5X8P7lFa4a+yzz9cugoqfboVJ03oSPzzsY5vh4JkR1nkDDJi+Txdq8bzZunvZJan
         aoZXIpknU/n/cqln2w69olLeD/CwxG/W4hvR/fRJlnRJCJSKmsjD0Avp1MkoEoeiVG
         YWCOhulXPDtwRqucSVeufWesUHYB8jG3FEIvNEA4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220526164819epcas5p3e5e4012353a514aa4f408e2926caa18a~ytZ0PahP81080310803epcas5p3D;
        Thu, 26 May 2022 16:48:19 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8DQR1Zx2z4x9Pp; Thu, 26 May
        2022 16:48:15 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        76.BC.10063.F4FAF826; Fri, 27 May 2022 01:48:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103~yr2B_BB801183111831epcas5p4K;
        Thu, 26 May 2022 14:54:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220526145402epsmtrp1b1287fd06b68d69a5aca0e0d098901e8~yr2B8fSlc0378803788epsmtrp1d;
        Thu, 26 May 2022 14:54:02 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-cd-628faf4fdbc2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.4E.08924.9849F826; Thu, 26 May 2022 23:54:01 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220526145401epsmtip2298367fbc10e754e43d82e9d50936431~yr2A4tziC1808418084epsmtip2H;
        Thu, 26 May 2022 14:54:00 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v2 4/8] engines/io_uring: add new I/O engine for uring
 passthrough support
Date:   Thu, 26 May 2022 20:18:05 +0530
Message-Id: <20220526144809.14877-5-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmpq7/+v4kg1u72S2aJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbF2y1rWgpOpFZf3X2JpYLwc0MXI
        ySEhYCIxZcZjti5GLg4hgd2MEhenLGaFcD4xSrRP3cYOUiUk8JlR4sRuyy5GDrCOydOkIWp2
        MUpcmnAYqqGVSWLp43ZmkAY2AW2JV29vgNkiAsIS+ztaWUBsZoFYiefbGphAbGGBGInla8+z
        gtgsAqoSWxu2sIAs4BWwkVi+uQziOnmJ1RsOgI3hFLCVOHd7BtilEgKr2CU+fTjJCFHkIvHp
        4CwmCFtY4tXxLewQtpTEy/42KDtbovHRXzYIu0Ri563tzBC2vcTFPX+ZQPYyC2hKrN+lDxGW
        lZh6ah0TxMl8Er2/n0CN55XYMQ/GVpX4e+82C4QtLXHz3VUo20Pi9pSr0HCbwCjx9qXeBEa5
        WQgbFjAyrmKUTC0ozk1PLTYtMMxLLYdHWXJ+7iZGcJLS8tzBePfBB71DjEwcjIcYJTiYlUR4
        LzztTRLiTUmsrEotyo8vKs1JLT7EaAoMvonMUqLJ+cA0mVcSb2hiaWBiZmZmYmlsZqgkzivw
        vzFJSCA9sSQ1OzW1ILUIpo+Jg1OqgWnBg83vZBdE6W77wNZ06ZiVksF1l3ez/tpe8tBe9bLG
        4bGX1gKtv1y3tSNfTpgRVbnps4x6ZUjL9Qa+Bcv5u1dvyl/W88884N+aNa8m/FLosD7xYMtR
        4+cuLPJ7/+awMVTJSM7un6N8/sKKz8o7Kt/slguJDM3Lt97zo36uWpD21yfVi6K5Hmtq17Mz
        qnL0f1LrjfdmMJzG+P1URsL5vcv0em8t2cbKor6NV3TCpPjLrXGn236EhCv8/3s3Y9LlL56r
        751wF8/NedPw7/IfhaV9ZtuubtwVt9Ij/u86pyWvr5nG2/lsjL0iHfM5aqPzpfvLiy0DNO5k
        Bfk55AvtiNMT373njlg92+cFi5b4rLimxFKckWioxVxUnAgAnkzO19sDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsWy7bCSvG7nlP4kgzebbSyaJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZkwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsXbLWtaC
        k6kVl/dfYmlgvBzQxcjBISFgIjF5mnQXIxeHkMAORomj55YzQ8SlJRauT+xi5AQyhSVW/nvO
        DlHTzCSx7HEvG0iCTUBb4tXbG8wgtghQ0f6OVhYQm1kgUWLHpF2MILawQJTEvjeLwOpZBFQl
        tjZsYQGZzytgI7F8cxnEfHmJ1RsOgI3hFLCVOHd7Bli5EFDJv30XmSYw8i1gZFjFKJlaUJyb
        nltsWGCUl1quV5yYW1yal66XnJ+7iREcRlpaOxj3rPqgd4iRiYPxEKMEB7OSCO+Fp71JQrwp
        iZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDJOrBftnpxOoKz
        ME35duyEY2s0b4tPmfBUPyrN5MZiC4VLXFO+1of7333jzLsyWTvfxEE1KGrD721Lj58p50+a
        FXElXDRe+ZjiHIdrNd0tTlLRXJpG17Mj9mx0OXwhIjt2ydK9Cear2Paaq5zW05kbM/X1wr1S
        B2VnJbxzf5X8IeoxS2jWslVX44uW1s5+eNPdiPv4vKJH9hPuWmicShVfGDv/5h+pGr9nqatO
        vtztIxKv6LXeVPTBqVuPRM/5tG/fzdtUcvIyV4XaFf2F9x/Mkr0lwu75Z5nMp1qJqm++5Y9M
        YpedXdRy+9byFUxGpbtPb1ns67QnRXub56IJzw/PvD5p8UWBHRuPZGR2htpYKbEUZyQaajEX
        FScCAIgk2IeSAgAA
X-CMS-MailID: 20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add a new I/O engine (io_uring_cmd) for sending uring passthrough
commands. It will also use most of the existing helpers from the
I/O engine io_uring. The I/O preparation, completion, file open,
file close and post init paths are going to differ and hence
io_uring_cmd will have its own helper for them.

Add a new io_uring_cmd engine specific option to support nvme
passthrough commands. Filename name for this specific option
must specify nvme-ns generic character device (dev/ngXnY).
This provides io_uring_cmd I/O engine a bandwidth to support
various passthrough commands in future.

The engine_pos and engine_data fields in struct fio_file are
separated now. This will help I/O engine io_uring_cmd to store
specific data as well as keep track of register files.

The supported options for io_uring_cmd I/O engine are:
 * registerfiles
 * sqthread_poll
 * sqthread_poll_cpu
 * cmd_type
 * nonvectored
 * force_async

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Co-authored-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c  | 304 +++++++++++++++++++++++++++++++++++++++++++-
 file.h              |  12 +-
 os/linux/io_uring.h |   9 ++
 3 files changed, 314 insertions(+), 11 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1e15647e..2088ac47 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -24,6 +24,13 @@
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
 #include "cmdprio.h"
+#include "nvme.h"
+
+#include <sys/stat.h>
+
+enum uring_cmd_type {
+	FIO_URING_CMD_NVME = 1,
+};
 
 struct io_sq_ring {
 	unsigned *head;
@@ -85,6 +92,7 @@ struct ioring_options {
 	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
+	enum uring_cmd_type cmd_type;
 };
 
 static const int ddir_to_op[2][2] = {
@@ -270,6 +278,22 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "cmd_type",
+		.lname	= "Uring cmd type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, cmd_type),
+		.help	= "Specify uring-cmd type",
+		.def	= "nvme",
+		.posval = {
+			  { .ival = "nvme",
+			    .oval = FIO_URING_CMD_NVME,
+			    .help = "Issue nvme-uring-cmd",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= NULL,
 	},
@@ -373,6 +397,45 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct fio_file *f = io_u->file;
+	struct io_uring_sqe *sqe;
+
+	/* nvme_uring_cmd case */
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_uring_cmd *cmd;
+
+		sqe = &ld->sqes[(io_u->index) << 1];
+
+		if (o->registerfiles) {
+			sqe->fd = f->engine_pos;
+			sqe->flags = IOSQE_FIXED_FILE;
+		} else {
+			sqe->fd = f->fd;
+		}
+		sqe->opcode = IORING_OP_URING_CMD;
+		sqe->user_data = (unsigned long) io_u;
+		if (o->nonvectored)
+			sqe->cmd_op = NVME_URING_CMD_IO;
+		else
+			sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+		if (o->force_async && ++ld->prepped == o->force_async) {
+			ld->prepped = 0;
+			sqe->flags |= IOSQE_ASYNC;
+		}
+
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		fio_nvme_uring_cmd_prep(cmd, io_u,
+				o->nonvectored ? NULL : &ld->iovecs[io_u->index]);
+
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -396,6 +459,29 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	return io_u;
 }
 
+static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct io_uring_cqe *cqe;
+	struct io_u *io_u;
+	unsigned index;
+
+	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
+	if (o->cmd_type == FIO_URING_CMD_NVME)
+		index <<= 1;
+
+	cqe = &ld->cq_ring.cqes[index];
+	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
+
+	if (cqe->res != 0)
+		io_u->error = -cqe->res;
+	else
+		io_u->error = 0;
+
+	return io_u;
+}
+
 static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
@@ -622,14 +708,22 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	sring->array = ptr + p->sq_off.array;
 	ld->sq_ring_mask = *sring->ring_mask;
 
-	ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_sqe);
+	if (p->flags & IORING_SETUP_SQE128)
+		ld->mmap[1].len = 2 * p->sq_entries * sizeof(struct io_uring_sqe);
+	else
+		ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_sqe);
 	ld->sqes = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
 				MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 				IORING_OFF_SQES);
 	ld->mmap[1].ptr = ld->sqes;
 
-	ld->mmap[2].len = p->cq_off.cqes +
-				p->cq_entries * sizeof(struct io_uring_cqe);
+	if (p->flags & IORING_SETUP_CQE32) {
+		ld->mmap[2].len = p->cq_off.cqes +
+					2 * p->cq_entries * sizeof(struct io_uring_cqe);
+	} else {
+		ld->mmap[2].len = p->cq_off.cqes +
+					p->cq_entries * sizeof(struct io_uring_cqe);
+	}
 	ptr = mmap(0, ld->mmap[2].len, PROT_READ | PROT_WRITE,
 			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 			IORING_OFF_CQ_RING);
@@ -728,6 +822,54 @@ retry:
 	return fio_ioring_mmap(ld, &p);
 }
 
+static int fio_ioring_cmd_queue_init(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	int depth = td->o.iodepth;
+	struct io_uring_params p;
+	int ret;
+
+	memset(&p, 0, sizeof(p));
+
+	if (o->hipri)
+		p.flags |= IORING_SETUP_IOPOLL;
+	if (o->sqpoll_thread) {
+		p.flags |= IORING_SETUP_SQPOLL;
+		if (o->sqpoll_set) {
+			p.flags |= IORING_SETUP_SQ_AFF;
+			p.sq_thread_cpu = o->sqpoll_cpu;
+		}
+	}
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		p.flags |= IORING_SETUP_SQE128;
+		p.flags |= IORING_SETUP_CQE32;
+	}
+
+	/*
+	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
+	 * than that.
+	 */
+	p.flags |= IORING_SETUP_CQSIZE;
+	p.cq_entries = depth;
+
+retry:
+	ret = syscall(__NR_io_uring_setup, depth, &p);
+	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
+			p.flags &= ~IORING_SETUP_CQSIZE;
+			goto retry;
+		}
+		return ret;
+	}
+
+	ld->ring_fd = ret;
+
+	fio_ioring_probe(td);
+
+	return fio_ioring_mmap(ld, &p);
+}
+
 static int fio_ioring_register_files(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -811,6 +953,52 @@ static int fio_ioring_post_init(struct thread_data *td)
 	return 0;
 }
 
+static int fio_ioring_cmd_post_init(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct io_u *io_u;
+	int err, i;
+
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct iovec *iov = &ld->iovecs[i];
+
+		io_u = ld->io_u_index[i];
+		iov->iov_base = io_u->buf;
+		iov->iov_len = td_max_bs(td);
+	}
+
+	err = fio_ioring_cmd_queue_init(td);
+	if (err) {
+		int init_err = errno;
+
+		td_verror(td, init_err, "io_queue_init");
+		return 1;
+	}
+
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct io_uring_sqe *sqe;
+
+		if (o->cmd_type == FIO_URING_CMD_NVME) {
+			sqe = &ld->sqes[i << 1];
+			memset(sqe, 0, 2 * sizeof(*sqe));
+		} else {
+			sqe = &ld->sqes[i];
+			memset(sqe, 0, sizeof(*sqe));
+		}
+	}
+
+	if (o->registerfiles) {
+		err = fio_ioring_register_files(td);
+		if (err) {
+			td_verror(td, errno, "ioring_register_files");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
@@ -868,6 +1056,38 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = NULL;
+		unsigned int nsid, lba_size = 0;
+		unsigned long long nlba = 0;
+		int ret;
+
+		/* Store the namespace-id and lba size. */
+		data = FILE_ENG_DATA(f);
+		if (data == NULL) {
+			ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+			if (ret)
+				return ret;
+
+			data = calloc(1, sizeof(struct nvme_data));
+			data->nsid = nsid;
+			data->lba_size = lba_size;
+
+			FILE_SET_ENG_DATA(f, data);
+		}
+	}
+	if (!ld || !o->registerfiles)
+		return generic_open_file(td, f);
+
+	f->fd = ld->fds[f->engine_pos];
+	return 0;
+}
+
 static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -880,7 +1100,57 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+static int fio_ioring_cmd_close_file(struct thread_data *td,
+				     struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = FILE_ENG_DATA(f);
+
+		FILE_SET_ENG_DATA(f, NULL);
+		free(data);
+	}
+	if (!ld || !o->registerfiles)
+		return generic_close_file(td, f);
+
+	f->fd = -1;
+	return 0;
+}
+
+static int fio_ioring_cmd_get_file_size(struct thread_data *td,
+					struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+		struct nvme_data *data = NULL;
+		unsigned int nsid, lba_size = 0;
+		unsigned long long nlba = 0;
+		int ret;
+
+		ret = fio_nvme_get_info(f, &nsid, &lba_size, &nlba);
+		if (ret)
+			return ret;
+
+		data = calloc(1, sizeof(struct nvme_data));
+		data->nsid = nsid;
+		data->lba_size = lba_size;
+
+		f->real_file_size = lba_size * nlba;
+		fio_file_set_size_known(f);
+
+		FILE_SET_ENG_DATA(f, data);
+		return 0;
+	}
+	return generic_get_file_size(td, f);
+}
+
+static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
@@ -900,13 +1170,35 @@ static struct ioengine_ops ioengine = {
 	.option_struct_size	= sizeof(struct ioring_options),
 };
 
+static struct ioengine_ops ioengine_uring_cmd = {
+	.name			= "io_uring_cmd",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO,
+	.init			= fio_ioring_init,
+	.post_init		= fio_ioring_cmd_post_init,
+	.io_u_init		= fio_ioring_io_u_init,
+	.prep			= fio_ioring_cmd_prep,
+	.queue			= fio_ioring_queue,
+	.commit			= fio_ioring_commit,
+	.getevents		= fio_ioring_getevents,
+	.event			= fio_ioring_cmd_event,
+	.cleanup		= fio_ioring_cleanup,
+	.open_file		= fio_ioring_cmd_open_file,
+	.close_file		= fio_ioring_cmd_close_file,
+	.get_file_size		= fio_ioring_cmd_get_file_size,
+	.options		= options,
+	.option_struct_size	= sizeof(struct ioring_options),
+};
+
 static void fio_init fio_ioring_register(void)
 {
-	register_ioengine(&ioengine);
+	register_ioengine(&ioengine_uring);
+	register_ioengine(&ioengine_uring_cmd);
 }
 
 static void fio_exit fio_ioring_unregister(void)
 {
-	unregister_ioengine(&ioengine);
+	unregister_ioengine(&ioengine_uring);
+	unregister_ioengine(&ioengine_uring_cmd);
 }
 #endif
diff --git a/file.h b/file.h
index faf65a2a..da1b8947 100644
--- a/file.h
+++ b/file.h
@@ -126,12 +126,14 @@ struct fio_file {
 	unsigned int last_write_idx;
 
 	/*
-	 * For use by the io engine for offset or private data storage
+	 * For use by the io engine to store offset
 	 */
-	union {
-		uint64_t engine_pos;
-		void *engine_data;
-	};
+	uint64_t engine_pos;
+
+	/*
+	 * For use by the io engine for private data storage
+	 */
+	void *engine_data;
 
 	/*
 	 * if io is protected by a semaphore, this is set
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 2fa66135..929997f8 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -22,6 +22,7 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
+		__u32	cmd_op;
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
@@ -171,6 +172,14 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_MSG_RING,
+	IORING_OP_FSETXATTR,
+	IORING_OP_SETXATTR,
+	IORING_OP_FGETXATTR,
+	IORING_OP_GETXATTR,
+	IORING_OP_SOCKET,
+	IORING_OP_URING_CMD,
+
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.17.1

