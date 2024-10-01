Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E15183CA5
	for <fio@vger.kernel.org>; Tue,  1 Oct 2024 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727784009; cv=none; b=Nt7h88shZC1ClRKORRUPdNmQZ/1yZuHJvobQSni8RkXqsLoxg8RMQOJQ7dGwdSKKN5VCSLaDxPnxqs5BEne4dtKKtDGpxe26OGTmprwMg32aTEGjtOKSG6K4SDBvPUvjsRMQpf+P77irPROFrAtK3TCotsKdEPSAYOxUX4pC2kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727784009; c=relaxed/simple;
	bh=prPzZbvKNxBU/z2Uozk+dfjiuCfgQks3/zRTJN4GkGw=;
	h=Subject:From:To:Message-Id:Date; b=sl1ojI2jU2k4WtQMaYIqjGieKnxv6/ogqOTTdXllAk9IpRyHAso+ofMg6MR6JTa7m3RBy9i2HY45xq2ZbKSoEBZkNazgvmWUtO1EqQztPIKshPt064enNhbvaUZ2RT023z4Qk1mYSetddKQbo7dGMv56epZF6upMoPxxU/Q1AX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lBciRfXV; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lBciRfXV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gtWbd467KgfTqQgdLsI8FIivIQbVEKCvU6ifZDYf7SY=; b=lBciRfXVyqi41MVWQUtW41ltKG
	ckIZ6bPOq64m66SfQpLfa0KMNNKss+ckXbpXg/T6lV6K7+JEPuaadCqBOXis2HRQmNtVZr0LnKzK+
	WK7Fg3UnU9CPLfAQQVylj036nA95sYAlaOqUmsi2Yezhp+QlAuEXjWSh8LSKL/2FfCrVHvbQ8DbB2
	FLw1MorRbaBVLXs5bz5dg6eVoQtpKMDhyvqlx8jRJCCFblOSGn7WD0jG6wtFKjVs63fzDsdAvYkZN
	+4A1ztPdatMnuSHanM5dOVWPPNadDTfZhI/kM9NEPXqbOOQ7CeyYSkzrUvxl636TdKeNqYWqbIFs1
	Vk9zggbA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1svbXv-000000031jl-344d
	for fio@vger.kernel.org;
	Tue, 01 Oct 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 618941BC015D; Tue,  1 Oct 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241001120001.618941BC015D@kernel.dk>
Date: Tue,  1 Oct 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit fef1936ee2be62bdfedffef472a124fded94633e:

  ci/qemu: change the name of this workflow (2024-09-27 19:33:57 +0000)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 980fb7f2d9981bbfe4a3158d6293308c76a6d77a:

  engines/io_uring: add support for async TRIM (2024-09-30 09:47:18 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: only load tail once per reap loop
      engines/io_uring: add support for async TRIM

 engines/io_uring.c  | 37 +++++++++++++++++++++++++++++++------
 os/linux/io_uring.h |  5 ++++-
 t/io_uring.c        | 10 ++++++----
 3 files changed, 41 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 85cebf83..1b6a4346 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -84,6 +84,7 @@ struct ioring_data {
 	struct io_cq_ring cq_ring;
 	unsigned cq_ring_mask;
 
+	int async_trim_fail;
 	int queued;
 	int cq_ring_off;
 	unsigned iodepth;
@@ -373,6 +374,10 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 #endif
 }
 
+#ifndef BLOCK_URING_CMD_DISCARD
+#define BLOCK_URING_CMD_DISCARD	_IO(0x12, 0)
+#endif
+
 static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -448,6 +453,16 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
 			sqe->opcode = IORING_OP_FSYNC;
 		}
+	} else if (io_u->ddir == DDIR_TRIM) {
+		sqe->opcode = IORING_OP_URING_CMD;
+		sqe->addr = io_u->offset;
+		sqe->addr3 = io_u->xfer_buflen;
+		sqe->rw_flags = 0;
+		sqe->len = sqe->off = 0;
+		sqe->ioprio = 0;
+		sqe->cmd_op = BLOCK_URING_CMD_DISCARD;
+		sqe->__pad1 = 0;
+		sqe->file_index = 0;
 	}
 
 	if (o->force_async && ++ld->prepped == o->force_async) {
@@ -539,13 +554,23 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
+	/* trim returns 0 on success */
+	if (cqe->res == io_u->xfer_buflen ||
+	    (io_u->ddir == DDIR_TRIM && !cqe->res)) {
+		io_u->error = 0;
+		return io_u;
+	}
+
 	if (cqe->res != io_u->xfer_buflen) {
+		if (io_u->ddir == DDIR_TRIM) {
+			ld->async_trim_fail = 1;
+			cqe->res = 0;
+		}
 		if (cqe->res > io_u->xfer_buflen)
 			io_u->error = -cqe->res;
 		else
 			io_u->resid = io_u->xfer_buflen - cqe->res;
-	} else
-		io_u->error = 0;
+	}
 
 	return io_u;
 }
@@ -737,7 +762,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (ld->queued == ld->iodepth)
 		return FIO_Q_BUSY;
 
-	if (io_u->ddir == DDIR_TRIM && td->io_ops->flags & FIO_ASYNCIO_SYNC_TRIM) {
+	/* if async trim has been tried and failed, punt to sync */
+	if (io_u->ddir == DDIR_TRIM && ld->async_trim_fail) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
 
@@ -1632,9 +1658,8 @@ free:
 static struct ioengine_ops ioengine_uring = {
 	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_NO_OFFLOAD |
-					FIO_ASYNCIO_SETS_ISSUE_TIME |
-					FIO_ATOMICWRITES,
+	.flags			= FIO_NO_OFFLOAD | FIO_ASYNCIO_SETS_ISSUE_TIME |
+				  FIO_ATOMICWRITES,
 	.init			= fio_ioring_init,
 	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index c7a24ad8..1040f690 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -22,7 +22,10 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
-		__u32	cmd_op;
+		struct {
+			__u32	cmd_op;
+			__u32	__pad1;
+		};
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
diff --git a/t/io_uring.c b/t/io_uring.c
index aa6e09e9..0fa01837 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -699,14 +699,15 @@ static int reap_events_uring(struct submitter *s)
 {
 	struct io_cq_ring *ring = &s->cq_ring;
 	struct io_uring_cqe *cqe;
-	unsigned head, reaped = 0;
+	unsigned tail, head, reaped = 0;
 	int last_idx = -1, stat_nr = 0;
 
 	head = *ring->head;
+	tail = atomic_load_acquire(ring->tail);
 	do {
 		struct file *f;
 
-		if (head == atomic_load_acquire(ring->tail))
+		if (head == tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
 		if (!do_nop) {
@@ -755,16 +756,17 @@ static int reap_events_uring_pt(struct submitter *s)
 {
 	struct io_cq_ring *ring = &s->cq_ring;
 	struct io_uring_cqe *cqe;
-	unsigned head, reaped = 0;
+	unsigned head, tail, reaped = 0;
 	int last_idx = -1, stat_nr = 0;
 	unsigned index;
 	int fileno;
 
 	head = *ring->head;
+	tail = atomic_load_acquire(ring->tail);
 	do {
 		struct file *f;
 
-		if (head == atomic_load_acquire(ring->tail))
+		if (head == tail)
 			break;
 		index = head & cq_ring_mask;
 		cqe = &ring->cqes[index << 1];
