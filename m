Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57964 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfAMNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 13 Jan 2019 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gifN6-0000oY-3A
        for fio@vger.kernel.org; Sun, 13 Jan 2019 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190113130002.3A2C92C0164@kernel.dk>
Date: Sun, 13 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e0abe38815e1c8cf7a319c6fbd0b1d60691db3d5:

  t/io_uring: only set IORING_ENTER_GETEVENTS when actively reaping (2019-01-11 14:40:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8025517dfa599be4bc795e4af7c9012d10b81bc5:

  t/io_uring: add IORING_OP_NOP support (2019-01-12 22:14:54 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/io_uring: add IORING_OP_NOP support

 os/io_uring.h |  1 +
 t/io_uring.c  | 28 +++++++++++++++++++++-------
 2 files changed, 22 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/os/io_uring.h b/os/io_uring.h
index 74370aed..0f4460d6 100644
--- a/os/io_uring.h
+++ b/os/io_uring.h
@@ -47,6 +47,7 @@ struct io_uring_sqe {
 #define IORING_SETUP_SQPOLL	(1 << 1)	/* SQ poll thread */
 #define IORING_SETUP_SQ_AFF	(1 << 2)	/* sq_thread_cpu is valid */
 
+#define IORING_OP_NOP		0
 #define IORING_OP_READV		1
 #define IORING_OP_WRITEV	2
 #define IORING_OP_FSYNC		3
diff --git a/t/io_uring.c b/t/io_uring.c
index d4160c3d..8d3f3a9b 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -93,6 +93,7 @@ static int fixedbufs = 1;	/* use fixed user buffers */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
+static int do_nop = 0;		/* no-op SQ ring commands */
 
 static int io_uring_register_buffers(struct submitter *s)
 {
@@ -101,6 +102,9 @@ static int io_uring_register_buffers(struct submitter *s)
 		.nr_iovecs = DEPTH
 	};
 
+	if (do_nop)
+		return 0;
+
 	return syscall(__NR_sys_io_uring_register, s->ring_fd,
 			IORING_REGISTER_BUFFERS, &reg);
 }
@@ -110,6 +114,9 @@ static int io_uring_register_files(struct submitter *s)
 	struct io_uring_register_files reg;
 	int i;
 
+	if (do_nop)
+		return 0;
+
 	s->fds = calloc(s->nr_files, sizeof(__s32));
 	for (i = 0; i < s->nr_files; i++) {
 		s->fds[i] = s->files[i].real_fd;
@@ -151,6 +158,11 @@ static void init_io(struct submitter *s, unsigned index)
 	struct file *f;
 	long r;
 
+	if (do_nop) {
+		sqe->opcode = IORING_OP_NOP;
+		return;
+	}
+
 	if (s->nr_files == 1) {
 		f = &s->files[0];
 	} else {
@@ -248,11 +260,13 @@ static int reap_events(struct submitter *s)
 		if (head == *ring->tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
-		f = (struct file *) cqe->user_data;
-		f->pending_ios--;
-		if (cqe->res != BS) {
-			printf("io: unexpected ret=%d\n", cqe->res);
-			return -1;
+		if (!do_nop) {
+			f = (struct file *) cqe->user_data;
+			f->pending_ios--;
+			if (cqe->res != BS) {
+				printf("io: unexpected ret=%d\n", cqe->res);
+				return -1;
+			}
 		}
 		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
 			s->cachehit++;
@@ -454,7 +468,7 @@ int main(int argc, char *argv[])
 	struct rlimit rlim;
 	void *ret;
 
-	if (argc < 2) {
+	if (!do_nop && argc < 2) {
 		printf("%s: filename\n", argv[0]);
 		return 1;
 	}
@@ -464,7 +478,7 @@ int main(int argc, char *argv[])
 		flags |= O_DIRECT;
 
 	i = 1;
-	while (i < argc) {
+	while (!do_nop && i < argc) {
 		struct file *f = &s->files[s->nr_files];
 
 		fd = open(argv[i], flags);

