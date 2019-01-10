Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45482 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbfAJNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Jan 2019 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghZwK-00040H-Ej
        for fio@vger.kernel.org; Thu, 10 Jan 2019 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190110130002.474362C03BB@kernel.dk>
Date: Thu, 10 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b08e7d6b18b4a38f61800e7553cd5e5d282da4a8:

  engines/devdax: Make detection of device-dax instances more robust (2019-01-08 12:47:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 650346e17d045366b817814dd3e10dc94d0d990f:

  engines/io_uring: always setup ld->iovecs[] (2019-01-09 15:13:06 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Update to newer io_uring API
      engines/io_uring: always setup ld->iovecs[]

 engines/io_uring.c | 91 ++++++++++++++++++++++++++----------------------------
 os/io_uring.h      | 27 ++++++++--------
 t/io_uring.c       | 63 ++++++++++++++++++-------------------
 3 files changed, 89 insertions(+), 92 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 55f48eda..06355e9c 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -37,7 +37,7 @@ struct io_cq_ring {
 	unsigned *tail;
 	unsigned *ring_mask;
 	unsigned *ring_entries;
-	struct io_uring_event *events;
+	struct io_uring_cqe *cqes;
 };
 
 struct ioring_mmap {
@@ -52,7 +52,7 @@ struct ioring_data {
 	struct io_u **io_u_index;
 
 	struct io_sq_ring sq_ring;
-	struct io_uring_iocb *iocbs;
+	struct io_uring_sqe *sqes;
 	struct iovec *iovecs;
 	unsigned sq_ring_mask;
 
@@ -151,30 +151,32 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct fio_file *f = io_u->file;
-	struct io_uring_iocb *iocb;
+	struct io_uring_sqe *sqe;
 
-	iocb = &ld->iocbs[io_u->index];
-	iocb->fd = f->fd;
-	iocb->flags = 0;
-	iocb->ioprio = 0;
+	sqe = &ld->sqes[io_u->index];
+	sqe->fd = f->fd;
+	sqe->flags = 0;
+	sqe->ioprio = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		if (io_u->ddir == DDIR_READ) {
-			if (o->fixedbufs)
-				iocb->opcode = IORING_OP_READ_FIXED;
+		if (o->fixedbufs) {
+			if (io_u->ddir == DDIR_READ)
+				sqe->opcode = IORING_OP_READ_FIXED;
 			else
-				iocb->opcode = IORING_OP_READ;
+				sqe->opcode = IORING_OP_WRITE_FIXED;
+			sqe->addr = io_u->xfer_buf;
+			sqe->len = io_u->xfer_buflen;
 		} else {
-			if (o->fixedbufs)
-				iocb->opcode = IORING_OP_WRITE_FIXED;
+			if (io_u->ddir == DDIR_READ)
+				sqe->opcode = IORING_OP_READV;
 			else
-				iocb->opcode = IORING_OP_WRITE;
+				sqe->opcode = IORING_OP_WRITEV;
+			sqe->addr = &ld->iovecs[io_u->index];
+			sqe->len = 1;
 		}
-		iocb->off = io_u->offset;
-		iocb->addr = io_u->xfer_buf;
-		iocb->len = io_u->xfer_buflen;
+		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir))
-		iocb->opcode = IORING_OP_FSYNC;
+		sqe->opcode = IORING_OP_FSYNC;
 
 	return 0;
 }
@@ -182,25 +184,25 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
 	struct ioring_data *ld = td->io_ops_data;
-	struct io_uring_event *ev;
+	struct io_uring_cqe *cqe;
 	struct io_u *io_u;
 	unsigned index;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
-	ev = &ld->cq_ring.events[index];
-	io_u = ld->io_u_index[ev->index];
+	cqe = &ld->cq_ring.cqes[index];
+	io_u = ld->io_u_index[cqe->index];
 
-	if (ev->res != io_u->xfer_buflen) {
-		if (ev->res > io_u->xfer_buflen)
-			io_u->error = -ev->res;
+	if (cqe->res != io_u->xfer_buflen) {
+		if (cqe->res > io_u->xfer_buflen)
+			io_u->error = -cqe->res;
 		else
-			io_u->resid = io_u->xfer_buflen - ev->res;
+			io_u->resid = io_u->xfer_buflen - cqe->res;
 	} else
 		io_u->error = 0;
 
 	if (io_u->ddir == DDIR_READ) {
-		if (ev->flags & IOEV_FLAG_CACHEHIT)
+		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
 			ld->cachehit++;
 		else
 			ld->cachemiss++;
@@ -417,14 +419,14 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	sring->array = ptr + p->sq_off.array;
 	ld->sq_ring_mask = *sring->ring_mask;
 
-	ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_iocb);
-	ld->iocbs = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
+	ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_sqe);
+	ld->sqes = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
 				MAP_SHARED | MAP_POPULATE, ld->ring_fd,
-				IORING_OFF_IOCB);
-	ld->mmap[1].ptr = ld->iocbs;
+				IORING_OFF_SQES);
+	ld->mmap[1].ptr = ld->sqes;
 
-	ld->mmap[2].len = p->cq_off.events +
-				p->cq_entries * sizeof(struct io_uring_event);
+	ld->mmap[2].len = p->cq_off.cqes +
+				p->cq_entries * sizeof(struct io_uring_cqe);
 	ptr = mmap(0, ld->mmap[2].len, PROT_READ | PROT_WRITE,
 			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 			IORING_OFF_CQ_RING);
@@ -433,7 +435,7 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	cring->tail = ptr + p->cq_off.tail;
 	cring->ring_mask = ptr + p->cq_off.ring_mask;
 	cring->ring_entries = ptr + p->cq_off.ring_entries;
-	cring->events = ptr + p->cq_off.events;
+	cring->cqes = ptr + p->cq_off.cqes;
 	ld->cq_ring_mask = *cring->ring_mask;
 	return 0;
 }
@@ -443,6 +445,7 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	int depth = td->o.iodepth;
+	struct iovec *vecs = NULL;
 	struct io_uring_params p;
 	int ret;
 
@@ -466,10 +469,10 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		};
 
 		setrlimit(RLIMIT_MEMLOCK, &rlim);
-		p.flags |= IORING_SETUP_FIXEDBUFS;
+		vecs = ld->iovecs;
 	}
 
-	ret = syscall(__NR_sys_io_uring_setup, depth, ld->iovecs, &p);
+	ret = syscall(__NR_sys_io_uring_setup, depth, vecs, &p);
 	if (ret < 0)
 		return ret;
 
@@ -480,20 +483,15 @@ static int fio_ioring_queue_init(struct thread_data *td)
 static int fio_ioring_post_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
-	struct ioring_options *o = td->eo;
 	struct io_u *io_u;
-	int err;
-
-	if (o->fixedbufs) {
-		int i;
+	int err, i;
 
-		for (i = 0; i < td->o.iodepth; i++) {
-			struct iovec *iov = &ld->iovecs[i];
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct iovec *iov = &ld->iovecs[i];
 
-			io_u = ld->io_u_index[i];
-			iov->iov_base = io_u->buf;
-			iov->iov_len = td_max_bs(td);
-		}
+		io_u = ld->io_u_index[i];
+		iov->iov_base = io_u->buf;
+		iov->iov_len = td_max_bs(td);
 	}
 
 	err = fio_ioring_queue_init(td);
@@ -523,7 +521,6 @@ static int fio_ioring_init(struct thread_data *td)
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 	ld->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
-
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
diff --git a/os/io_uring.h b/os/io_uring.h
index 7dd21126..20e4c22e 100644
--- a/os/io_uring.h
+++ b/os/io_uring.h
@@ -12,9 +12,9 @@
 #include <linux/types.h>
 
 /*
- * IO submission data structure
+ * IO submission data structure (Submission Queue Entry)
  */
-struct io_uring_iocb {
+struct io_uring_sqe {
 	__u8	opcode;
 	__u8	flags;
 	__u16	ioprio;
@@ -35,23 +35,22 @@ struct io_uring_iocb {
  * io_uring_setup() flags
  */
 #define IORING_SETUP_IOPOLL	(1 << 0)	/* io_context is polled */
-#define IORING_SETUP_FIXEDBUFS	(1 << 1)	/* IO buffers are fixed */
-#define IORING_SETUP_SQTHREAD	(1 << 2)	/* Use SQ thread */
-#define IORING_SETUP_SQWQ	(1 << 3)	/* Use SQ workqueue */
-#define IORING_SETUP_SQPOLL	(1 << 4)	/* SQ thread polls */
+#define	IORING_SETUP_SQTHREAD	(1 << 1)	/* Use SQ thread */
+#define IORING_SETUP_SQWQ	(1 << 2)	/* Use SQ workqueue */
+#define IORING_SETUP_SQPOLL	(1 << 3)	/* SQ thread polls */
 
-#define IORING_OP_READ		1
-#define IORING_OP_WRITE		2
+#define IORING_OP_READV		1
+#define IORING_OP_WRITEV	2
 #define IORING_OP_FSYNC		3
 #define IORING_OP_FDSYNC	4
 #define IORING_OP_READ_FIXED	5
 #define IORING_OP_WRITE_FIXED	6
 
 /*
- * IO completion data structure
+ * IO completion data structure (Completion Queue Entry)
  */
-struct io_uring_event {
-	__u64	index;		/* what iocb this event came from */
+struct io_uring_cqe {
+	__u64	index;		/* what sqe this event came from */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 };
@@ -59,14 +58,14 @@ struct io_uring_event {
 /*
  * io_uring_event->flags
  */
-#define IOEV_FLAG_CACHEHIT	(1 << 0)	/* IO did not hit media */
+#define IOCQE_FLAG_CACHEHIT	(1 << 0)	/* IO did not hit media */
 
 /*
  * Magic offsets for the application to mmap the data it needs
  */
 #define IORING_OFF_SQ_RING		0ULL
 #define IORING_OFF_CQ_RING		0x8000000ULL
-#define IORING_OFF_IOCB			0x10000000ULL
+#define IORING_OFF_SQES			0x10000000ULL
 
 /*
  * Filled with the offset for mmap(2)
@@ -90,7 +89,7 @@ struct io_cqring_offsets {
 	__u32 ring_mask;
 	__u32 ring_entries;
 	__u32 overflow;
-	__u32 events;
+	__u32 cqes;
 	__u32 resv[4];
 };
 
diff --git a/t/io_uring.c b/t/io_uring.c
index fb2654a3..3edc87c6 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -41,7 +41,7 @@ struct io_cq_ring {
 	unsigned *tail;
 	unsigned *ring_mask;
 	unsigned *ring_entries;
-	struct io_uring_event *events;
+	struct io_uring_cqe *cqes;
 };
 
 #define DEPTH			32
@@ -59,7 +59,7 @@ struct submitter {
 	int ring_fd;
 	struct drand48_data rand;
 	struct io_sq_ring sq_ring;
-	struct io_uring_iocb *iocbs;
+	struct io_uring_sqe *sqes;
 	struct iovec iovecs[DEPTH];
 	struct io_cq_ring cq_ring;
 	int inflight;
@@ -74,9 +74,9 @@ struct submitter {
 static struct submitter submitters[1];
 static volatile int finish;
 
-static int polled = 0;		/* use IO polling */
+static int polled = 1;		/* use IO polling */
 static int fixedbufs = 0;	/* use fixed user buffers */
-static int buffered = 1;	/* use buffered IO, not O_DIRECT */
+static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread = 0;	/* use kernel submission thread */
 static int sq_thread_cpu = 0;	/* pin above thread to this CPU */
 
@@ -100,23 +100,26 @@ static int gettid(void)
 
 static void init_io(struct submitter *s, int fd, unsigned index)
 {
-	struct io_uring_iocb *iocb = &s->iocbs[index];
+	struct io_uring_sqe *sqe = &s->sqes[index];
 	unsigned long offset;
 	long r;
 
 	lrand48_r(&s->rand, &r);
 	offset = (r % (s->max_blocks - 1)) * BS;
 
-	if (fixedbufs)
-		iocb->opcode = IORING_OP_READ_FIXED;
-	else
-		iocb->opcode = IORING_OP_READ;
-	iocb->flags = 0;
-	iocb->ioprio = 0;
-	iocb->fd = fd;
-	iocb->off = offset;
-	iocb->addr = s->iovecs[index].iov_base;
-	iocb->len = BS;
+	if (fixedbufs) {
+		sqe->opcode = IORING_OP_READ_FIXED;
+		sqe->addr = s->iovecs[index].iov_base;
+		sqe->len = BS;
+	} else {
+		sqe->opcode = IORING_OP_READV;
+		sqe->addr = &s->iovecs[index];
+		sqe->len = 1;
+	}
+	sqe->flags = 0;
+	sqe->ioprio = 0;
+	sqe->fd = fd;
+	sqe->off = offset;
 }
 
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
@@ -139,7 +142,7 @@ static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 	} while (prepped < max_ios);
 
 	if (*ring->tail != tail) {
-		/* order tail store with writes to iocbs above */
+		/* order tail store with writes to sqes above */
 		barrier();
 		*ring->tail = tail;
 		barrier();
@@ -172,7 +175,7 @@ static int get_file_size(int fd, unsigned long *blocks)
 static int reap_events(struct submitter *s)
 {
 	struct io_cq_ring *ring = &s->cq_ring;
-	struct io_uring_event *ev;
+	struct io_uring_cqe *cqe;
 	unsigned head, reaped = 0;
 
 	head = *ring->head;
@@ -180,17 +183,17 @@ static int reap_events(struct submitter *s)
 		barrier();
 		if (head == *ring->tail)
 			break;
-		ev = &ring->events[head & cq_ring_mask];
-		if (ev->res != BS) {
-			struct io_uring_iocb *iocb = &s->iocbs[ev->index];
+		cqe = &ring->cqes[head & cq_ring_mask];
+		if (cqe->res != BS) {
+			struct io_uring_sqe *sqe = &s->sqes[cqe->index];
 
-			printf("io: unexpected ret=%d\n", ev->res);
+			printf("io: unexpected ret=%d\n", cqe->res);
 			printf("offset=%lu, size=%lu\n",
-					(unsigned long) iocb->off,
-					(unsigned long) iocb->len);
+					(unsigned long) sqe->off,
+					(unsigned long) sqe->len);
 			return -1;
 		}
-		if (ev->flags & IOEV_FLAG_CACHEHIT)
+		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
 			s->cachehit++;
 		else
 			s->cachemiss++;
@@ -323,8 +326,6 @@ static int setup_ring(struct submitter *s)
 
 	if (polled)
 		p.flags |= IORING_SETUP_IOPOLL;
-	if (fixedbufs)
-		p.flags |= IORING_SETUP_FIXEDBUFS;
 	if (buffered)
 		p.flags |= IORING_SETUP_SQWQ;
 	else if (sq_thread) {
@@ -353,12 +354,12 @@ static int setup_ring(struct submitter *s)
 	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
-	s->iocbs = mmap(0, p.sq_entries * sizeof(struct io_uring_iocb),
+	s->sqes = mmap(0, p.sq_entries * sizeof(struct io_uring_sqe),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
-			IORING_OFF_IOCB);
-	printf("iocbs ptr   = 0x%p\n", s->iocbs);
+			IORING_OFF_SQES);
+	printf("sqes ptr    = 0x%p\n", s->sqes);
 
-	ptr = mmap(0, p.cq_off.events + p.cq_entries * sizeof(struct io_uring_event),
+	ptr = mmap(0, p.cq_off.cqes + p.cq_entries * sizeof(struct io_uring_cqe),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_CQ_RING);
 	printf("cq_ring ptr = 0x%p\n", ptr);
@@ -366,7 +367,7 @@ static int setup_ring(struct submitter *s)
 	cring->tail = ptr + p.cq_off.tail;
 	cring->ring_mask = ptr + p.cq_off.ring_mask;
 	cring->ring_entries = ptr + p.cq_off.ring_entries;
-	cring->events = ptr + p.cq_off.events;
+	cring->cqes = ptr + p.cq_off.cqes;
 	cq_ring_mask = *cring->ring_mask;
 	return 0;
 }

