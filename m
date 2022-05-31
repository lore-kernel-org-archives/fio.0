Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 673F4C433EF
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 09:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349240AbiFAJk1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 1 Jun 2022 05:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350017AbiFAJk0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Jun 2022 05:40:26 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E594990B
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 02:40:24 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220601094022epoutp023bfb30fb8d9310d49f9e1ee53957dea5~0db4vXG9T3007630076epoutp02M
        for <fio@vger.kernel.org>; Wed,  1 Jun 2022 09:40:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220601094022epoutp023bfb30fb8d9310d49f9e1ee53957dea5~0db4vXG9T3007630076epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1654076422;
        bh=lPZ/gKKLmmcC0sR0yo5mA99Rft8FJ7XftB2RFNRdlwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glalNcJGXcKZd5k27QghmHZTOWrBWgb0wZxqmWHbUhDTuUPMlJnBlP7NR2t3N/dec
         Rssw2A1dZsuS5vG0ngZXlTf1EumAb85igWoD50iPTzGf6sB/vmPXLvEO2Ff3LPuF+f
         tdO8zTeLQFbKRQYcmvt6bDOR/HgxpYFgzliD9zpU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220601094022epcas5p3101efb3f8061ccc29a1c815dc68d798e~0db4MjyrS0912309123epcas5p3C;
        Wed,  1 Jun 2022 09:40:22 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4LCkdq21xNz4x9Pw; Wed,  1 Jun
        2022 09:40:15 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.E4.10063.BF337926; Wed,  1 Jun 2022 18:40:11 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220531133746epcas5p36ec535b219f3e2008b14d2adc59e30f2~0NB36CrKz0065400654epcas5p35;
        Tue, 31 May 2022 13:37:46 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220531133746epsmtrp2f96d1b0d6cd03b3eae5d1fa65f39a9e5~0NB35Rr4P0382803828epsmtrp2Z;
        Tue, 31 May 2022 13:37:46 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-1f-629733fb41e0
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        78.F4.11276.A2A16926; Tue, 31 May 2022 22:37:46 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220531133745epsmtip2a5dc10817f7756a4fe0c81911e30fbcc~0NB28tC-v2550825508epsmtip2E;
        Tue, 31 May 2022 13:37:45 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: [PATCH v3 5/9] engines/io_uring: add new I/O engine for uring
 passthrough support
Date:   Tue, 31 May 2022 19:01:51 +0530
Message-Id: <20220531133155.17493-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsWy7bCmuu5v4+lJBmd+mFs0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+PRohbWgikZFU/udjM1MN4K6mLk
        5JAQMJF4sXsSexcjF4eQwG5Giekvp7JAOJ8YJaa9eQKV+cYosfj7QlaYlv3/9zFCJPYySuze
        1gjV0sokcfvYIXaQKjYBbYlXb28wg9giAsIS+ztaWUBsZoFYiefbGphAbGGBGIkzbU/ZQGwW
        AVWJTxcWMILYvAI2EkfvnWKE2CYvsXrDAbA5nAK2EvOmrmcFWSYhsIpdYv2nNywQRS4SC34f
        gWoQlnh1fAs7hC0l8fndXjYIO1ui8dFfKLtEYuet7cwQtr3ExT1/gQ7iADpOU2L9Ln2IsKzE
        1FPrmCBu5pPo/f2ECSLOK7FjHoytKvH33m2oE6Qlbr67CmV7SKy8tgnsHCGBCYwSU86qTWCU
        m4WwYQEj4ypGydSC4tz01GLTAsO81HJ4rCXn525iBKcqLc8djHcffNA7xMjEwXiIUYKDWUmE
        t2TX1CQh3pTEyqrUovz4otKc1OJDjKbA8JvILCWanA9Mlnkl8YYmlgYmZmZmJpbGZoZK4rwC
        /xuThATSE0tSs1NTC1KLYPqYODilGpgyTrRxXTpuOldXzeXE8sJvres1VolN/Tr5lsDinQvc
        md5mn/wxY2rdomSrDr5ZW28e25j8kCXi8HmG8KbPXKEr5zxgN2LMuvgx9u7zzL2/Hh47nx/J
        uqTo6pMQTQ2FW+Xbvl2u3TPd0unQ3U/sh1sbnQSeWnnei+d4rffl22I3zuitVYFsyyIcKx67
        KWSfOar4J1Knx3h6gGyQu2L7qZwXO/K81gac6M7PCwjTnrBLc/k5ZvHY2YcCvq+bXeTd7TA5
        eMGS5EcFlgbOX69tnmvfH/I76MSm/7Yp1so65ya6fWx2uOY00//iSvmqa9kxb+00Lsm9/dy7
        x25uxpPpbIqbA/ZKKf+JCD2yNpR92VJpJZbijERDLeai4kQAUmWrj94DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkluLIzCtJLcpLzFFi42LZdlhJXldLalqSwaYHIhZNE/4yW6y+289m
        8XHWC2aLo//fslks3LiMyYHV4/LZUo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKeLSohbVg
        SkbFk7vdTA2Mt4K6GDk5JARMJPb/38fYxcjFISSwm1Hi+PJLbF2MHEAJaYmF6xMhaoQlVv57
        zg5R08wk8XtGIwtIgk1AW+LV2xvMILYIUNH+jlawOLNAosSOSbsYQWxhgSiJY2s/MoHYLAKq
        Ep8uLACL8wrYSBy9d4oRYoG8xOoNB8DmcArYSsybup4VxBYCqpn6YgHjBEa+BYwMqxglUwuK
        c9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgkNJS3MH4/ZVH/QOMTJxMB5ilOBgVhLhLdk1NUmI
        NyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGppXRfqwdslrG
        H9f8Cj7vVnPhintT1xoniTXaSqJX46Q+VmZL5+hVikrndjEKnvne4bNT67v7M7PM1U3f31+q
        3H12YuzMS9OFfX7utn88Qd9wkup5r5tTe2/JaS33No6pnqcpHzBXQtZSarGoe3vt5J1HTz35
        e/ewvV7UI+d3afvCDc0fak09y5IgfFheb5Jj76mE1a4lNXWvss9Nn7fCbvLrgolV51fGnL3f
        tv+kf7+r9659Nzra5FY8ur2M1ShklYM5S9bO7Yl6nNeCnGpaGXyyGus2zp559f/BRDGG/Uw7
        rvy+8c5qL+fqSUKHBHad6Fi8Xl1HoiAiPT/E7rFm+fqdO3QDlnjECC945Lz5jRJLcUaioRZz
        UXEiAG77LGKUAgAA
X-CMS-MailID: 20220531133746epcas5p36ec535b219f3e2008b14d2adc59e30f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220531133746epcas5p36ec535b219f3e2008b14d2adc59e30f2
References: <20220531133155.17493-1-ankit.kumar@samsung.com>
        <CGME20220531133746epcas5p36ec535b219f3e2008b14d2adc59e30f2@epcas5p3.samsung.com>
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

Added a new option cmd_type. This specifies the type of uring
command to submit. Currently it only supports nvme uring command

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Co-authored-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 engines/io_uring.c  | 318 +++++++++++++++++++++++++++++++++++++++++++-
 file.h              |  12 +-
 os/linux/io_uring.h |   9 ++
 3 files changed, 328 insertions(+), 11 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 1e15647e..a7b7b166 100644
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
@@ -373,6 +397,52 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	return 0;
 }
 
+static int fio_ioring_cmd_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct fio_file *f = io_u->file;
+	struct io_uring_sqe *sqe;
+	int ret;
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
+		sqe->rw_flags = 0;
+		if (!td->o.odirect && o->uncached)
+			sqe->rw_flags |= RWF_UNCACHED;
+		if (o->nowait)
+			sqe->rw_flags |= RWF_NOWAIT;
+
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
+		ret = fio_nvme_uring_cmd_prep(cmd, io_u,
+				o->nonvectored ? NULL : &ld->iovecs[io_u->index]);
+
+		return ret;
+	}
+	return -EINVAL;
+}
+
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -396,6 +466,29 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
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
@@ -622,14 +715,22 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
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
@@ -728,6 +829,61 @@ retry:
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
+	if (o->fixedbufs) {
+		ret = syscall(__NR_io_uring_register, ld->ring_fd,
+				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
+		if (ret < 0)
+			return ret;
+	}
+
+	return fio_ioring_mmap(ld, &p);
+}
+
 static int fio_ioring_register_files(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -811,6 +967,52 @@ static int fio_ioring_post_init(struct thread_data *td)
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
@@ -868,6 +1070,38 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
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
+			data->lba_shift = ilog2(lba_size);
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
@@ -880,7 +1114,57 @@ static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
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
+		data->lba_shift = ilog2(lba_size);
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
@@ -900,13 +1184,35 @@ static struct ioengine_ops ioengine = {
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

