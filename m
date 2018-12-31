Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:32782 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbeLaNAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Dec 2018 08:00:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gdxB0-0001L4-OI
        for fio@vger.kernel.org; Mon, 31 Dec 2018 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181231130001.E10432C0118@kernel.dk>
Date: Mon, 31 Dec 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 10c4d1318fff63eef1d22c6be6d816210277ae17:

  t/aio-ring: print head/tail as unsigneds (2018-12-21 15:37:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ac4f3d4e4cf16b1097249a819fe7111b2674b3f4:

  aioring: remove IOCB_FLAG_HIPRI (2018-12-30 17:19:40 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      aioring: update API
      aioring: remove IOCB_FLAG_HIPRI

 engines/aioring.c | 23 ++++-------------------
 t/aio-ring.c      | 16 ++++------------
 2 files changed, 8 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/engines/aioring.c b/engines/aioring.c
index 50826964..f836009d 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -21,10 +21,6 @@
 
 #ifdef ARCH_HAVE_AIORING
 
-#ifndef IOCB_FLAG_HIPRI
-#define IOCB_FLAG_HIPRI	(1 << 2)
-#endif
-
 /*
  * io_setup2(2) flags
  */
@@ -51,11 +47,8 @@
 /*
  * io_ring_enter(2) flags
  */
-#ifndef IORING_FLAG_SUBMIT
-#define IORING_FLAG_SUBMIT	(1 << 0)
-#endif
 #ifndef IORING_FLAG_GETEVENTS
-#define IORING_FLAG_GETEVENTS	(1 << 1)
+#define IORING_FLAG_GETEVENTS	(1 << 0)
 #endif
 
 typedef uint64_t u64;
@@ -196,7 +189,6 @@ static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct aioring_data *ld = td->io_ops_data;
 	struct fio_file *f = io_u->file;
-	struct aioring_options *o = td->eo;
 	struct iocb *iocb;
 
 	iocb = &ld->iocbs[io_u->index];
@@ -211,10 +203,7 @@ static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
 		iocb->u.c.buf = io_u->xfer_buf;
 		iocb->u.c.nbytes = io_u->xfer_buflen;
 		iocb->u.c.offset = io_u->offset;
-		if (o->hipri)
-			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		else
-			iocb->u.c.flags = 0;
+		iocb->u.c.flags = 0;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -377,7 +366,7 @@ static int fio_aioring_commit(struct thread_data *td)
 		struct aio_sq_ring *ring = ld->sq_ring;
 
 		if (ring->kflags & IORING_SQ_NEED_WAKEUP)
-			io_ring_enter(ld->aio_ctx, ld->queued, 0, IORING_FLAG_SUBMIT);
+			io_ring_enter(ld->aio_ctx, ld->queued, 0, 0);
 		ld->queued = 0;
 		return 0;
 	}
@@ -386,8 +375,7 @@ static int fio_aioring_commit(struct thread_data *td)
 		unsigned start = ld->sq_ring->head;
 		long nr = ld->queued;
 
-		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_SUBMIT |
-						IORING_FLAG_GETEVENTS);
+		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_GETEVENTS);
 		if (ret > 0) {
 			fio_aioring_queued(td, start, ret);
 			io_u_mark_submit(td, ret);
@@ -507,9 +495,6 @@ static int fio_aioring_post_init(struct thread_data *td)
 			iocb = &ld->iocbs[i];
 			iocb->u.c.buf = io_u->buf;
 			iocb->u.c.nbytes = td_max_bs(td);
-
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 		}
 	}
 
diff --git a/t/aio-ring.c b/t/aio-ring.c
index 900f4640..c0c5009e 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -22,8 +22,6 @@
 #include <pthread.h>
 #include <sched.h>
 
-#define IOCB_FLAG_HIPRI		(1 << 2)
-
 #define IOCTX_FLAG_IOPOLL	(1 << 0)
 #define IOCTX_FLAG_SCQRING	(1 << 1)	/* Use SQ/CQ rings */
 #define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
@@ -66,8 +64,7 @@ struct aio_cq_ring {
 	struct io_event events[0];
 };
 
-#define IORING_FLAG_SUBMIT	(1 << 0)
-#define IORING_FLAG_GETEVENTS	(1 << 1)
+#define IORING_FLAG_GETEVENTS	(1 << 0)
 
 #define DEPTH			32
 
@@ -134,8 +131,6 @@ static void init_io(struct submitter *s, int fd, struct iocb *iocb)
 	iocb->aio_fildes = fd;
 	iocb->aio_lio_opcode = IO_CMD_PREAD;
 	iocb->u.c.offset = offset;
-	if (polled)
-		iocb->u.c.flags = IOCB_FLAG_HIPRI;
 	if (!fixedbufs)
 		iocb->u.c.nbytes = BS;
 }
@@ -254,7 +249,7 @@ static void *submitter_fn(void *data)
 
 	prepped = 0;
 	do {
-		int to_wait, flags, to_submit, this_reap;
+		int to_wait, to_submit, this_reap;
 
 		if (!prepped && s->inflight < DEPTH)
 			prepped = prep_more_ios(s, fd, min(DEPTH - s->inflight, BATCH_SUBMIT));
@@ -267,11 +262,8 @@ submit:
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
 
-		flags = IORING_FLAG_GETEVENTS;
-		if (to_submit)
-			flags |= IORING_FLAG_SUBMIT;
-
-		ret = io_ring_enter(s->ioc, to_submit, to_wait, flags);
+		ret = io_ring_enter(s->ioc, to_submit, to_wait,
+					IORING_FLAG_GETEVENTS);
 		s->calls++;
 
 		this_reap = reap_events(s);

