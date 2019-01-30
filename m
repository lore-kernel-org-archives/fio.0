Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55718 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfA3NAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Jan 2019 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gopTL-0000db-JJ
        for fio@vger.kernel.org; Wed, 30 Jan 2019 13:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190130130002.078EF2C328A@kernel.dk>
Date: Wed, 30 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b532dd6d476679b08e4a56a60e8a7dd958779df9:

  io_uring: sync with kernel (2019-01-28 11:42:20 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 521164fa90df413aa7aa8fb2956095a41eba7d6a:

  io_uring: ensure we use the right argument syscall (2019-01-29 12:20:02 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: update to kernel struct io_uring_params
      t/io_uring: fix bad if
      io_uring: ensure we use the right argument syscall

 engines/io_uring.c  |  2 +-
 os/linux/io_uring.h | 24 ++++++++++++------------
 t/io_uring.c        |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5279b1d0..014f954e 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -132,7 +132,7 @@ static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
 	return syscall(__NR_sys_io_uring_enter, ld->ring_fd, to_submit,
-			min_complete, flags);
+			min_complete, flags, NULL, 0);
 }
 
 static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 589b6402..b1504502 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -39,14 +39,14 @@ struct io_uring_sqe {
 /*
  * sqe->flags
  */
-#define IOSQE_FIXED_FILE	(1 << 0)	/* use fixed fileset */
+#define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
 
 /*
  * io_uring_setup() flags
  */
-#define IORING_SETUP_IOPOLL	(1 << 0)	/* io_context is polled */
-#define IORING_SETUP_SQPOLL	(1 << 1)	/* SQ poll thread */
-#define IORING_SETUP_SQ_AFF	(1 << 2)	/* sq_thread_cpu is valid */
+#define IORING_SETUP_IOPOLL	(1U << 0)	/* io_context is polled */
+#define IORING_SETUP_SQPOLL	(1U << 1)	/* SQ poll thread */
+#define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 
 #define IORING_OP_NOP		0
 #define IORING_OP_READV		1
@@ -60,7 +60,7 @@ struct io_uring_sqe {
 /*
  * sqe->fsync_flags
  */
-#define IORING_FSYNC_DATASYNC	(1 << 0)
+#define IORING_FSYNC_DATASYNC	(1U << 0)
 
 /*
  * IO completion data structure (Completion Queue Entry)
@@ -74,7 +74,7 @@ struct io_uring_cqe {
 /*
  * io_uring_event->flags
  */
-#define IOCQE_FLAG_CACHEHIT	(1 << 0)	/* IO did not hit media */
+#define IOCQE_FLAG_CACHEHIT	(1U << 0)	/* IO did not hit media */
 
 /*
  * Magic offsets for the application to mmap the data it needs
@@ -100,7 +100,7 @@ struct io_sqring_offsets {
 /*
  * sq_ring->flags
  */
-#define IORING_SQ_NEED_WAKEUP	(1 << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
 
 struct io_cqring_offsets {
 	__u32 head;
@@ -115,8 +115,8 @@ struct io_cqring_offsets {
 /*
  * io_uring_enter(2) flags
  */
-#define IORING_ENTER_GETEVENTS	(1 << 0)
-#define IORING_ENTER_SQ_WAKEUP	(1 << 1)
+#define IORING_ENTER_GETEVENTS	(1U << 0)
+#define IORING_ENTER_SQ_WAKEUP	(1U << 1)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -125,9 +125,9 @@ struct io_uring_params {
 	__u32 sq_entries;
 	__u32 cq_entries;
 	__u32 flags;
-	__u16 sq_thread_cpu;
-	__u16 sq_thread_idle;
-	__u16 resv[8];
+	__u32 sq_thread_cpu;
+	__u32 sq_thread_idle;
+	__u32 resv[5];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
diff --git a/t/io_uring.c b/t/io_uring.c
index 9ded1590..62b48e44 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -129,7 +129,7 @@ static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
 	return syscall(__NR_sys_io_uring_enter, s->ring_fd, to_submit,
-			min_complete, flags);
+			min_complete, flags, NULL, 0);
 }
 
 static int gettid(void)
@@ -315,7 +315,7 @@ submit:
 
 			if (to_wait)
 				flags = IORING_ENTER_GETEVENTS;
-			if (*ring->flags & IORING_SQ_NEED_WAKEUP)
+			if ((*ring->flags & IORING_SQ_NEED_WAKEUP))
 				flags |= IORING_ENTER_SQ_WAKEUP;
 			ret = io_uring_enter(s, to_submit, to_wait, flags);
 			s->calls++;

