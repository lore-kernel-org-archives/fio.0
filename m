Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49620 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfLXNAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Dec 2019 08:00:03 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjn9-0001nR-DP
        for fio@vger.kernel.org; Tue, 24 Dec 2019 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191224130001.875E21BC0168@kernel.dk>
Date: Tue, 24 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ab1665679b00fd2b3f955596da837d9694732b24:

  Merge branch 'doc_fixes' of https://github.com/sitsofe/fio (2019-12-21 07:04:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b10b1e70afaff8c9b00005e9238f2ad347a9c00a:

  io_uring: add option for non-vectored read/write commands (2019-12-23 08:54:25 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: add option for non-vectored read/write commands

 engines/io_uring.c  | 34 +++++++++++++++++-------
 os/linux/io_uring.h | 75 ++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 87 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9ba126d8..7c19294b 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -75,9 +75,15 @@ struct ioring_options {
 	unsigned int sqpoll_thread;
 	unsigned int sqpoll_set;
 	unsigned int sqpoll_cpu;
+	unsigned int nonvectored;
 	unsigned int uncached;
 };
 
+static const int ddir_to_op[2][2] = {
+	{ IORING_OP_READV, IORING_OP_READ },
+	{ IORING_OP_WRITEV, IORING_OP_WRITE }
+};
+
 static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
@@ -133,6 +139,15 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
 	},
+	{
+		.name	= "nonvectored",
+		.lname	= "Non-vectored",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, nonvectored),
+		.help	= "Use non-vectored read/write commands",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_IOURING,
+	},
 	{
 		.name	= "uncached",
 		.lname	= "Uncached",
@@ -174,21 +189,20 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		sqe->opcode = ddir_to_op[io_u->ddir][!!o->nonvectored];
 		if (o->fixedbufs) {
-			if (io_u->ddir == DDIR_READ)
-				sqe->opcode = IORING_OP_READ_FIXED;
-			else
-				sqe->opcode = IORING_OP_WRITE_FIXED;
 			sqe->addr = (unsigned long) io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
 			sqe->buf_index = io_u->index;
 		} else {
-			if (io_u->ddir == DDIR_READ)
-				sqe->opcode = IORING_OP_READV;
-			else
-				sqe->opcode = IORING_OP_WRITEV;
-			sqe->addr = (unsigned long) &ld->iovecs[io_u->index];
-			sqe->len = 1;
+			if (o->nonvectored) {
+				sqe->addr = (unsigned long)
+						ld->iovecs[io_u->index].iov_base;
+				sqe->len = ld->iovecs[io_u->index].iov_len;
+			} else {
+				sqe->addr = (unsigned long) &ld->iovecs[io_u->index];
+				sqe->len = 1;
+			}
 		}
 		if (!td->o.odirect && o->uncached)
 			sqe->rw_flags = RWF_UNCACHED;
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index ce03151e..03d2dde4 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -19,7 +19,10 @@ struct io_uring_sqe {
 	__u8	flags;		/* IOSQE_ flags */
 	__u16	ioprio;		/* ioprio for the request */
 	__s32	fd;		/* file descriptor to do IO on */
-	__u64	off;		/* offset into file */
+	union {
+		__u64	off;	/* offset into file */
+		__u64	addr2;
+	};
 	__u64	addr;		/* pointer to buffer or iovecs */
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -27,6 +30,12 @@ struct io_uring_sqe {
 		__u32		fsync_flags;
 		__u16		poll_events;
 		__u32		sync_range_flags;
+		__u32		msg_flags;
+		__u32		timeout_flags;
+		__u32		accept_flags;
+		__u32		cancel_flags;
+		__u32		open_flags;
+		__u32		statx_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
@@ -40,7 +49,9 @@ struct io_uring_sqe {
  */
 #define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
 #define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
-#define IOSQE_IO_LINK		(1U << 2)	/* next IO depends on this one */
+#define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
+#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
+#define IOSQE_ASYNC		(1U << 4)	/* always go async */
 
 /*
  * io_uring_setup() flags
@@ -48,22 +59,48 @@ struct io_uring_sqe {
 #define IORING_SETUP_IOPOLL	(1U << 0)	/* io_context is polled */
 #define IORING_SETUP_SQPOLL	(1U << 1)	/* SQ poll thread */
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
+#define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
+
+enum {
+	IORING_OP_NOP,
+	IORING_OP_READV,
+	IORING_OP_WRITEV,
+	IORING_OP_FSYNC,
+	IORING_OP_READ_FIXED,
+	IORING_OP_WRITE_FIXED,
+	IORING_OP_POLL_ADD,
+	IORING_OP_POLL_REMOVE,
+	IORING_OP_SYNC_FILE_RANGE,
+	IORING_OP_SENDMSG,
+	IORING_OP_RECVMSG,
+	IORING_OP_TIMEOUT,
+	IORING_OP_TIMEOUT_REMOVE,
+	IORING_OP_ACCEPT,
+	IORING_OP_ASYNC_CANCEL,
+	IORING_OP_LINK_TIMEOUT,
+	IORING_OP_CONNECT,
+	IORING_OP_FALLOCATE,
+	IORING_OP_OPENAT,
+	IORING_OP_CLOSE,
+	IORING_OP_FILES_UPDATE,
+	IORING_OP_STATX,
+	IORING_OP_READ,
+	IORING_OP_WRITE,
 
-#define IORING_OP_NOP		0
-#define IORING_OP_READV		1
-#define IORING_OP_WRITEV	2
-#define IORING_OP_FSYNC		3
-#define IORING_OP_READ_FIXED	4
-#define IORING_OP_WRITE_FIXED	5
-#define IORING_OP_POLL_ADD	6
-#define IORING_OP_POLL_REMOVE	7
-#define IORING_OP_SYNC_FILE_RANGE	8
+	/* this goes last, obviously */
+	IORING_OP_LAST,
+};
 
 /*
  * sqe->fsync_flags
  */
 #define IORING_FSYNC_DATASYNC	(1U << 0)
 
+/*
+ * sqe->timeout_flags
+ */
+#define IORING_TIMEOUT_ABS	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -125,11 +162,19 @@ struct io_uring_params {
 	__u32 flags;
 	__u32 sq_thread_cpu;
 	__u32 sq_thread_idle;
-	__u32 resv[5];
+	__u32 features;
+	__u32 resv[4];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
 
+/*
+ * io_uring_params->features flags
+ */
+#define IORING_FEAT_SINGLE_MMAP		(1U << 0)
+#define IORING_FEAT_NODROP		(1U << 1)
+#define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
+
 /*
  * io_uring_register(2) opcodes and arguments
  */
@@ -139,5 +184,11 @@ struct io_uring_params {
 #define IORING_UNREGISTER_FILES		3
 #define IORING_REGISTER_EVENTFD		4
 #define IORING_UNREGISTER_EVENTFD	5
+#define IORING_REGISTER_FILES_UPDATE	6
+
+struct io_uring_files_update {
+	__u32 offset;
+	__s32 *fds;
+};
 
 #endif

