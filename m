Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FF8C433FE
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 16:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiEWQ3G (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 12:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiEWQ3D (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 12:29:03 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0405674DF
        for <fio@vger.kernel.org>; Mon, 23 May 2022 09:29:01 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220523162900epoutp0350b350daae7492b22643bb60d78f65d9~xyNFuCuiN1562815628epoutp03b
        for <fio@vger.kernel.org>; Mon, 23 May 2022 16:29:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220523162900epoutp0350b350daae7492b22643bb60d78f65d9~xyNFuCuiN1562815628epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653323340;
        bh=iiSK7R4slTAVBwalUFO4do7lJdPVQ0k6hhd+gU63yfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNPxohMotnpGc5TGF32NvhZPFILwndQD2c06Hd2vc3fqCr6PVQgibQpgzi/EtUyrY
         3RouNpVGMBwx+qdofwuuDuDkgWi4nUr5i6n8uOm+UmlfRJsGKzeWUFhOE1OUs4AU/c
         Xxy19uNwoN4M2OMe5IRSwMUIR1PtAgTcvQPtXOyA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220523162859epcas5p423c430f7275c5a3ee7fe91588f6b7756~xyNE4h77L1056510565epcas5p4r;
        Mon, 23 May 2022 16:28:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L6N7Y0c05z4x9Pv; Mon, 23 May
        2022 16:28:57 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.CF.09827.846BB826; Tue, 24 May 2022 01:28:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07~xvk2z96yP2982229822epcas5p4a;
        Mon, 23 May 2022 13:16:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220523131619epsmtrp213a90ab7ae99297d8e7cc7dead710f12~xvk2zUC2R2897628976epsmtrp2d;
        Mon, 23 May 2022 13:16:19 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-a6-628bb648514f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.6D.08924.2298B826; Mon, 23 May 2022 22:16:18 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220523131618epsmtip2963dc181a24800cd74e59c907e396941~xvk12YJ141839118391epsmtip2-;
        Mon, 23 May 2022 13:16:17 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH 3/7] engines/io_uring: add new I/O engine for uring
 passthrough support
Date:   Mon, 23 May 2022 18:40:35 +0530
Message-Id: <20220523131039.17697-4-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220523131039.17697-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmuq7ntu4kg7chFk0T/jJbrL7bz2bx
        cdYLZouj/9+yWSzcuIzJgdXj8tlSj74tqxg9Pm+SC2COyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmH9+G2PB5zbGih+LDzI2MO7J7mLk
        4JAQMJG4caWoi5GLQ0hgN6PEvSON7BDOJ0aJ1WebmCGcz4wSx5adBXI4wTrmXjrAAmILCexi
        lNjbEwBR1MoksaZpO1iCTUBb4tXbG2ANIgLCEvs7WsHizAKxEs+3NTCB2MICkRJX9+5iA7FZ
        BFQlfv+5DVbDK2Aj8ePKKqhl8hKrNxwAszkFbCXufPgHdpGEwDp2ia6Fx9khilwk1rz9yAph
        C0u8Or4FKi4l8fndXjYIO1ui8dFfKLtEYuet7VAL7CUu7vnLBAoLZgFNifW79CHCshJTT61j
        griZT6L39xMmiDivxI55MLaqxN97EDdLCEhL3Hx3Fcr2kNh5oJsVEkATGCW6pvNPYJSbhbBh
        ASPjKkbJ1ILi3PTUYtMCo7zUcnikJefnbmIEpyktrx2MDx980DvEyMTBeIhRgoNZSYR3e2JH
        khBvSmJlVWpRfnxRaU5q8SFGU2D4TWSWEk3OBybKvJJ4QxNLAxMzMzMTS2MzQyVxXoH/jUlC
        AumJJanZqakFqUUwfUwcnFINTA3vH2/48mmO/3wXiScyN6qcq/NSgh5o23+VeHR7eW6m6B+X
        NqYDvWJTWb2Ob/Y9v2hJ8o9duYw1mRqPPxx73xm5RHT5WvZtDcJ/6oLfsKv5LmSzn/2k1vNV
        1xfb7v8LPzj2xCzZFPz3OEf0oZxtZY3WW20/997dyNqo8Dzw3HVPrb0/l905sYf3mXbF/8wV
        HrqaZTahT+/EqRXseXx21em6r8ctDtyZLPa/7dyfR6J8XHNj/U1Dq67Zzj/34lDo/hMxrfzy
        DPJHX89/UsF+vEzY4R7Po4Slexc4yrWWS72zc1khbWR17avXspP52av/Z/Rc1eyYyqscYnXy
        00StktKbKzvW+oRZ6MVvTn3dxKHEUpyRaKjFXFScCADZ3GzP3AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42LZdlhJXlepszvJ4PYHG4umCX+ZLVbf7Wez
        +DjrBbPF0f9v2SwWblzG5MDqcflsqUffllWMHp83yQUwR3HZpKTmZJalFunbJXBlzD+/jbHg
        cxtjxY/FBxkbGPdkdzFyckgImEjMvXSApYuRi0NIYAejxNf99xi7GDmAEtISC9cnQtQIS6z8
        95wdxBYSaGaSuHpBE8RmE9CWePX2BjOILQJUs7+jlQXEZhZIlNgxaRcjiC0sEC7R1/YILM4i
        oCrx+89tMJtXwEbix5VVzBDz5SVWbzgAZnMK2Erc+fCPGeQEIaCaHT9CJjDyLWBkWMUomVpQ
        nJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERxIWlo7GPes+qB3iJGJg/EQowQHs5II7/bEjiQh
        3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamFq3Fj7VzBSf
        +H/Wmphao6fW03es6TgQzHFQ8+SZd8KaG1VPPv3iMzv8U4FZr/whobCYy5/eP9L7uU/1vuoS
        3edbrJ4dLJ3Z+Hej01N+9m+hS1w89WW4VbaenOhY9zmi5P2bn8y1Lp3zLludj0jbvOry6pSP
        uTr1rqaujma+c+/ym8U5+a9ZmHoz4S6TWap3H0uj8rLyX4rHBb85zvXkDzaa63v6t/zPYyv2
        iS65+t7GtuuLy+MLCxIEpU/cOrz+y8oACd1PDXsOszjqOz25tlh98pZpwbNvnww8E74jMLUx
        wdhV9MVlI53VO7kmHhT8Y/x0EXfaC/6kvSyuN3JdpqfbR0x8H6D536v0gHCaibESS3FGoqEW
        c1FxIgCGzjjfkwIAAA==
X-CMS-MailID: 20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131619epcas5p47af80b04e8015a949e157875f0cb0f07@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add a new I/O engine (io_uring_cmd) for sending uring passthrough
commands. The new I/O engine will be built only if its support is
present in the kernel. It will also use most of the existing
helpers from the I/O engine io_uring. The I/O preparation,
completion, file open, file close and post init paths are going to
differ and hence io_uring_cmd will have its own helper for them.

Add a new io_uring_cmd engine specific flag to support nvme
passthrough commands. Filename name for this specific option
must specify nvme-ns generic character device (dev/ngXnY).
This provides io_uring_cmd I/O engine a bandwidth to support
various passthrough commands in future.

The engine_pos and engine_data fields in struct fio_file are
separated now. This will help I/O engine io_uring_cmd to store
specific data as well as keep track of register files.

The supported io_uring_cmd options are:
 * registerfiles
 * sqthread_poll
 * sqthread_poll_cpu
 * cmd_type

co-authored-By: Anuj Gupta <anuj20.g@samsung.com>
co-authored-By: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c  | 457 +++++++++++++++++++++++++++++++++++++++++++-
 file.h              |  12 +-
 os/linux/io_uring.h |   9 +
 3 files changed, 467 insertions(+), 11 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1e15647e..75248624 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -25,6 +25,17 @@
 #include "../os/linux/io_uring.h"
 #include "cmdprio.h"
 
+#ifdef CONFIG_LIBNVME
+#include <sys/stat.h>
+#include <nvme/ioctl.h>
+#endif
+
+#ifdef CONFIG_URING_CMD
+enum uring_cmd_type {
+	FIO_URING_CMD_NVME = 1,
+};
+#endif
+
 struct io_sq_ring {
 	unsigned *head;
 	unsigned *tail;
@@ -47,6 +58,11 @@ struct ioring_mmap {
 	size_t len;
 };
 
+struct nvme_data {
+	uint32_t nsid;
+	uint32_t lba_size;
+};
+
 struct ioring_data {
 	int ring_fd;
 
@@ -85,6 +101,9 @@ struct ioring_options {
 	unsigned int uncached;
 	unsigned int nowait;
 	unsigned int force_async;
+#ifdef CONFIG_URING_CMD
+	enum uring_cmd_type cmd_type;
+#endif
 };
 
 static const int ddir_to_op[2][2] = {
@@ -270,6 +289,23 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+#ifdef CONFIG_URING_CMD
+	{
+		.name	= "cmd_type",
+		.lname	= "Uring cmd type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct ioring_options, cmd_type),
+		.help	= "Specify uring-cmd type",
+		.posval = {
+			  { .ival = "nvme",
+			    .oval = FIO_URING_CMD_NVME,
+			    .help = "Issue nvme-uring-cmd",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
+#endif
 	{
 		.name	= NULL,
 	},
@@ -373,6 +409,61 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+#ifdef CONFIG_URING_CMD
+static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct fio_file *f = io_u->file;
+	struct io_uring_sqe *sqe;
+
+	/* nvme_uring_cmd case */
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+#ifdef CONFIG_LIBNVME
+		struct nvme_data *data = FILE_ENG_DATA(io_u->file);
+		struct nvme_uring_cmd *cmd;
+		unsigned long long slba;
+		unsigned long long nlb;
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
+		sqe->cmd_op = NVME_URING_CMD_IO;
+
+		slba = io_u->offset / data->lba_size;
+		nlb = (io_u->xfer_buflen / data->lba_size) - 1;
+
+		cmd = (struct nvme_uring_cmd *)sqe->cmd;
+		memset(cmd, 0, sizeof(struct nvme_uring_cmd));
+
+		/* cdw10 and cdw11 represent starting lba */
+		cmd->cdw10 = slba & 0xffffffff;
+		cmd->cdw11 = slba >> 32;
+		/* cdw12 represent number of lba's for read/write */
+		cmd->cdw12 = nlb;
+		cmd->addr = (__u64)io_u->xfer_buf;
+		cmd->data_len = io_u->xfer_buflen;
+		cmd->nsid = data->nsid;
+
+		if (io_u->ddir == DDIR_READ)
+			cmd->opcode = nvme_cmd_read;
+		if (io_u->ddir == DDIR_WRITE)
+			cmd->opcode = nvme_cmd_write;
+
+		return 0;
+#endif
+	}
+	return -EINVAL;
+}
+#endif
+
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -396,6 +487,31 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	return io_u;
 }
 
+#ifdef CONFIG_URING_CMD
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
+#endif
+
 static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
@@ -622,14 +738,22 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
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
@@ -728,6 +852,64 @@ retry:
 	return fio_ioring_mmap(ld, &p);
 }
 
+#ifdef CONFIG_URING_CMD
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
+	if (o->hipri && o->cmd_type == FIO_URING_CMD_NVME) {
+		log_err("fio: nvme_uring_cmd doesn't support hipri\n");
+		return ENOTSUP;
+	}
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
+	if (o->fixedbufs) {
+		log_err("fio: io_uring_cmd doesn't support fixedbufs\n");
+		return ENOTSUP;
+	}
+	return fio_ioring_mmap(ld, &p);
+}
+#endif
+
 static int fio_ioring_register_files(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -811,6 +993,62 @@ static int fio_ioring_post_init(struct thread_data *td)
 	return 0;
 }
 
+#ifdef CONFIG_URING_CMD
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
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+#ifndef CONFIG_LIBNVME
+		log_err("fio: install libnvme for nvme io_uring passthrough "
+			"command support\n");
+		return 1;
+#endif
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
+#endif
+
 static int fio_ioring_init(struct thread_data *td)
 {
 	struct ioring_options *o = td->eo;
@@ -848,6 +1086,45 @@ static int fio_ioring_init(struct thread_data *td)
 	return 0;
 }
 
+#ifdef CONFIG_URING_CMD
+static int fio_ioring_cmd_init(struct thread_data *td)
+{
+	struct ioring_options *o = td->eo;
+	struct ioring_data *ld;
+	int ret;
+
+	/* sqthread submission requires registered files */
+	if (o->sqpoll_thread)
+		o->registerfiles = 1;
+
+	if (o->registerfiles && td->o.nr_files != td->o.open_files) {
+		log_err("fio: io_uring registered files require nr_files to "
+			"be identical to open_files\n");
+		return 1;
+	}
+
+	ld = calloc(1, sizeof(*ld));
+
+	/* ring depth must be a power-of-2 */
+	ld->iodepth = td->o.iodepth;
+	td->o.iodepth = roundup_pow2(td->o.iodepth);
+
+	/* io_u index */
+	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
+	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
+
+	td->io_ops_data = ld;
+
+	ret = fio_cmdprio_init(td, &ld->cmdprio, &o->cmdprio_options);
+	if (ret || (ld->cmdprio.mode != CMDPRIO_MODE_NONE)) {
+		log_err("fio: io_uring_cmd doesn't support I/O priority "
+			"classes\n");
+		return ENOTSUP;
+	}
+	return 0;
+}
+#endif
+
 static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -856,6 +1133,51 @@ static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+#ifdef CONFIG_LIBNVME
+static int fio_nvme_get_info(struct fio_file *f, unsigned int *nsid,
+			     unsigned int *lba_sz, unsigned long long *nlba)
+{
+	struct nvme_id_ns ns;
+	unsigned int namespace_id;
+	int fd, err;
+
+	if (f->filetype != FIO_TYPE_CHAR) {
+		log_err("ioengine io_uring_cmd only works with nvme ns "
+			"generic char devices (/dev/ngXnY)\n");
+		return 1;
+	}
+
+	fd = open(f->file_name, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	namespace_id = ioctl(fd, NVME_IOCTL_ID);
+	if (namespace_id < 0) {
+		log_err("failed to fetch namespace-id");
+		close(fd);
+		return -errno;
+	}
+
+	/*
+	 * Identify namespace to get namespace-id, namespace size in LBA's
+	 * and LBA data size.
+	 */
+	err = nvme_identify_ns(fd, namespace_id, &ns);
+	if (err) {
+		log_err("failed to fetch identify namespace\n");
+		close(fd);
+		return err;
+	}
+
+	*nsid = namespace_id;
+	*lba_sz = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
+	*nlba = ns.nsze;
+
+	close(fd);
+	return 0;
+}
+#endif
+
 static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -868,6 +1190,43 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
+#ifdef CONFIG_URING_CMD
+static int fio_ioring_cmd_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+#ifdef CONFIG_LIBNVME
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
+			f->real_file_size = nlba * lba_size;
+
+			FILE_SET_ENG_DATA(f, data);
+		}
+#endif
+	}
+	if (!ld || !o->registerfiles)
+		return generic_open_file(td, f);
+
+	f->fd = ld->fds[f->engine_pos];
+	return 0;
+}
+#endif
+
 static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -880,7 +1239,65 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-static struct ioengine_ops ioengine = {
+#ifdef CONFIG_URING_CMD
+static int fio_ioring_cmd_close_file(struct thread_data *td,
+				     struct fio_file *f)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+#ifdef CONFIG_LIBNVME
+		struct nvme_data *data = FILE_ENG_DATA(f);
+
+		FILE_SET_ENG_DATA(f, NULL);
+		free(data);
+#endif
+	}
+	if (!ld || !o->registerfiles)
+		return generic_close_file(td, f);
+
+	f->fd = -1;
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_URING_CMD
+static int fio_ioring_cmd_get_file_size(struct thread_data *td,
+					struct fio_file *f)
+{
+	struct ioring_options *o = td->eo;
+
+	if (fio_file_size_known(f))
+		return 0;
+
+	if (o->cmd_type == FIO_URING_CMD_NVME) {
+#ifdef CONFIG_LIBNVME
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
+#endif
+	}
+	return generic_get_file_size(td, f);
+}
+#endif
+
+static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
 	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD,
@@ -900,13 +1317,41 @@ static struct ioengine_ops ioengine = {
 	.option_struct_size	= sizeof(struct ioring_options),
 };
 
+#ifdef CONFIG_URING_CMD
+static struct ioengine_ops ioengine_uring_cmd = {
+	.name			= "io_uring_cmd",
+	.version		= FIO_IOOPS_VERSION,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD | FIO_MEMALIGN | FIO_RAWIO,
+	.init			= fio_ioring_cmd_init,
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
+#endif
+
 static void fio_init fio_ioring_register(void)
 {
-	register_ioengine(&ioengine);
+	register_ioengine(&ioengine_uring);
+#ifdef CONFIG_URING_CMD
+	register_ioengine(&ioengine_uring_cmd);
+#endif
 }
 
 static void fio_exit fio_ioring_unregister(void)
 {
-	unregister_ioengine(&ioengine);
+	unregister_ioengine(&ioengine_uring);
+#ifdef CONFIG_URING_CMD
+	unregister_ioengine(&ioengine_uring_cmd);
+#endif
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

