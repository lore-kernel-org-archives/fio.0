Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38138 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfALNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Jan 2019 08:00:11 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1giItU-0008D0-RA
        for fio@vger.kernel.org; Sat, 12 Jan 2019 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190112130001.BCA2A2C0164@kernel.dk>
Date: Sat, 12 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a7abc9fb769596d3bbf6d779e99d1cb8c1fcd49b:

  t/io_uring: add support for registered files (2019-01-10 22:29:27 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e0abe38815e1c8cf7a319c6fbd0b1d60691db3d5:

  t/io_uring: only set IORING_ENTER_GETEVENTS when actively reaping (2019-01-11 14:40:16 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      io_uring: update to newer API
      t/io_uring: remember to set p->sq_thread_cpu
      engines/io_uring: remove unused ld->io_us array
      t/io_uring: only set IORING_ENTER_GETEVENTS when actively reaping

 engines/io_uring.c | 27 +++++++++++++++------------
 os/io_uring.h      | 31 ++++++++++++++++++++-----------
 t/io_uring.c       | 47 ++++++++++++++++++++++++++++-------------------
 3 files changed, 63 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 7591190a..ca3e157f 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -48,7 +48,6 @@ struct ioring_mmap {
 struct ioring_data {
 	int ring_fd;
 
-	struct io_u **io_us;
 	struct io_u **io_u_index;
 
 	struct io_sq_ring sq_ring;
@@ -150,25 +149,31 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	sqe->buf_index = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
-		if (io_u->ddir == DDIR_READ)
-			sqe->opcode = IORING_OP_READV;
-		else
-			sqe->opcode = IORING_OP_WRITEV;
-
 		if (o->fixedbufs) {
-			sqe->flags |= IOSQE_FIXED_BUFFER;
+			if (io_u->ddir == DDIR_READ)
+				sqe->opcode = IORING_OP_READ_FIXED;
+			else
+				sqe->opcode = IORING_OP_WRITE_FIXED;
 			sqe->addr = io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
+			if (io_u->ddir == DDIR_READ)
+				sqe->opcode = IORING_OP_READV;
+			else
+				sqe->opcode = IORING_OP_WRITEV;
 			sqe->addr = &ld->iovecs[io_u->index];
 			sqe->len = 1;
 		}
 		sqe->off = io_u->offset;
-	} else if (ddir_sync(io_u->ddir))
+	} else if (ddir_sync(io_u->ddir)) {
+		sqe->fsync_flags = 0;
+		if (io_u->ddir == DDIR_DATASYNC)
+			sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
 		sqe->opcode = IORING_OP_FSYNC;
+	}
 
-	sqe->data = (unsigned long) io_u;
+	sqe->user_data = (unsigned long) io_u;
 	return 0;
 }
 
@@ -182,7 +187,7 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	cqe = &ld->cq_ring.cqes[index];
-	io_u = (struct io_u *) cqe->data;
+	io_u = (struct io_u *) cqe->user_data;
 
 	if (cqe->res != io_u->xfer_buflen) {
 		if (cqe->res > io_u->xfer_buflen)
@@ -390,7 +395,6 @@ static void fio_ioring_cleanup(struct thread_data *td)
 			fio_ioring_unmap(ld);
 
 		free(ld->io_u_index);
-		free(ld->io_us);
 		free(ld->iovecs);
 		free(ld);
 	}
@@ -526,7 +530,6 @@ static int fio_ioring_init(struct thread_data *td)
 
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
-	ld->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
 	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
diff --git a/os/io_uring.h b/os/io_uring.h
index e1d3df0b..74370aed 100644
--- a/os/io_uring.h
+++ b/os/io_uring.h
@@ -16,7 +16,7 @@
  */
 struct io_uring_sqe {
 	__u8	opcode;		/* type of operation for this sqe */
-	__u8	flags;		/* IOSQE_ flags below */
+	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
 	__u64	off;		/* offset into file */
@@ -27,18 +27,18 @@ struct io_uring_sqe {
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
-		__u32		__resv;
+		__u32		fsync_flags;
 	};
 	__u16	buf_index;	/* index into fixed buffers, if used */
-	__u16	__pad2[3];
-	__u64	data;		/* data to be passed back at completion time */
+	__u16	__pad2;
+	__u32	__pad3;
+	__u64	user_data;	/* data to be passed back at completion time */
 };
 
 /*
  * sqe->flags
  */
-#define IOSQE_FIXED_BUFFER	(1 << 0)	/* use fixed buffer */
-#define IOSQE_FIXED_FILE	(1 << 1)	/* use fixed fileset */
+#define IOSQE_FIXED_FILE	(1 << 0)	/* use fixed fileset */
 
 /*
  * io_uring_setup() flags
@@ -50,13 +50,19 @@ struct io_uring_sqe {
 #define IORING_OP_READV		1
 #define IORING_OP_WRITEV	2
 #define IORING_OP_FSYNC		3
-#define IORING_OP_FDSYNC	4
+#define IORING_OP_READ_FIXED	4
+#define IORING_OP_WRITE_FIXED	5
+
+/*
+ * sqe->fsync_flags
+ */
+#define IORING_FSYNC_DATASYNC	(1 << 0)
 
 /*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	data;		/* sqe->data submission passed back */
+	__u64	user_data;	/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 };
@@ -87,6 +93,9 @@ struct io_sqring_offsets {
 	__u32 resv[3];
 };
 
+/*
+ * sq_ring->flags
+ */
 #define IORING_SQ_NEED_WAKEUP	(1 << 0) /* needs io_uring_enter wakeup */
 
 struct io_cqring_offsets {
@@ -127,12 +136,12 @@ struct io_uring_params {
 
 struct io_uring_register_buffers {
 	struct iovec *iovecs;
-	unsigned nr_iovecs;
+	__u32 nr_iovecs;
 };
 
 struct io_uring_register_files {
-	int *fds;
-	unsigned nr_fds;
+	__s32 *fds;
+	__u32 nr_fds;
 };
 
 #endif
diff --git a/t/io_uring.c b/t/io_uring.c
index 0461329b..d4160c3d 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -59,7 +59,8 @@ static unsigned sq_ring_mask, cq_ring_mask;
 struct file {
 	unsigned long max_blocks;
 	unsigned pending_ios;
-	int fd;
+	int real_fd;
+	int fixed_fd;
 };
 
 struct submitter {
@@ -77,6 +78,8 @@ struct submitter {
 	unsigned long cachehit, cachemiss;
 	volatile int finish;
 
+	__s32 *fds;
+
 	struct file files[MAX_FDS];
 	unsigned nr_files;
 	unsigned cur_file;
@@ -105,17 +108,18 @@ static int io_uring_register_buffers(struct submitter *s)
 static int io_uring_register_files(struct submitter *s)
 {
 	struct io_uring_register_files reg;
-	int i, ret;
+	int i;
 
-	reg.fds = calloc(s->nr_files, sizeof(int));
-	for (i = 0; i < s->nr_files; i++)
-		reg.fds[i] = s->files[i].fd;
+	s->fds = calloc(s->nr_files, sizeof(__s32));
+	for (i = 0; i < s->nr_files; i++) {
+		s->fds[i] = s->files[i].real_fd;
+		s->files[i].fixed_fd = i;
+	}
+	reg.fds = s->fds;
 	reg.nr_fds = s->nr_files;
 
-	ret = syscall(__NR_sys_io_uring_register, s->ring_fd,
+	return syscall(__NR_sys_io_uring_register, s->ring_fd,
 			IORING_REGISTER_FILES, &reg);
-	free(reg.fds);
-	return ret;
 }
 
 static int io_uring_setup(unsigned entries, struct io_uring_params *p)
@@ -163,21 +167,21 @@ static void init_io(struct submitter *s, unsigned index)
 	offset = (r % (f->max_blocks - 1)) * BS;
 
 	sqe->flags = IOSQE_FIXED_FILE;
-	sqe->opcode = IORING_OP_READV;
 	if (fixedbufs) {
+		sqe->opcode = IORING_OP_READ_FIXED;
 		sqe->addr = s->iovecs[index].iov_base;
 		sqe->len = BS;
 		sqe->buf_index = index;
-		sqe->flags |= IOSQE_FIXED_BUFFER;
 	} else {
+		sqe->opcode = IORING_OP_READV;
 		sqe->addr = &s->iovecs[index];
 		sqe->len = 1;
 		sqe->buf_index = 0;
 	}
 	sqe->ioprio = 0;
-	sqe->fd = f->fd;
+	sqe->fd = f->fixed_fd;
 	sqe->off = offset;
-	sqe->data = (unsigned long) f;
+	sqe->user_data = (unsigned long) f;
 }
 
 static int prep_more_ios(struct submitter *s, int max_ios)
@@ -212,12 +216,12 @@ static int get_file_size(struct file *f)
 {
 	struct stat st;
 
-	if (fstat(f->fd, &st) < 0)
+	if (fstat(f->real_fd, &st) < 0)
 		return -1;
 	if (S_ISBLK(st.st_mode)) {
 		unsigned long long bytes;
 
-		if (ioctl(f->fd, BLKGETSIZE64, &bytes) != 0)
+		if (ioctl(f->real_fd, BLKGETSIZE64, &bytes) != 0)
 			return -1;
 
 		f->max_blocks = bytes / BS;
@@ -244,7 +248,7 @@ static int reap_events(struct submitter *s)
 		if (head == *ring->tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
-		f = (struct file *) cqe->data;
+		f = (struct file *) cqe->user_data;
 		f->pending_ios--;
 		if (cqe->res != BS) {
 			printf("io: unexpected ret=%d\n", cqe->res);
@@ -296,8 +300,11 @@ submit:
 		 * poll, or if IORING_SQ_NEED_WAKEUP is set.
 		 */
 		if (!sq_thread_poll || (*ring->flags & IORING_SQ_NEED_WAKEUP)) {
-			ret = io_uring_enter(s, to_submit, to_wait,
-						IORING_ENTER_GETEVENTS);
+			unsigned flags = 0;
+
+			if (to_wait)
+				flags = IORING_ENTER_GETEVENTS;
+			ret = io_uring_enter(s, to_submit, to_wait, flags);
 			s->calls++;
 		}
 
@@ -382,8 +389,10 @@ static int setup_ring(struct submitter *s)
 		p.flags |= IORING_SETUP_IOPOLL;
 	if (sq_thread_poll) {
 		p.flags |= IORING_SETUP_SQPOLL;
-		if (sq_thread_cpu != -1)
+		if (sq_thread_cpu != -1) {
 			p.flags |= IORING_SETUP_SQ_AFF;
+			p.sq_thread_cpu = sq_thread_cpu;
+		}
 	}
 
 	fd = io_uring_setup(DEPTH, &p);
@@ -463,7 +472,7 @@ int main(int argc, char *argv[])
 			perror("open");
 			return 1;
 		}
-		f->fd = fd;
+		f->real_fd = fd;
 		if (get_file_size(f)) {
 			printf("failed getting size of device/file\n");
 			return 1;

