Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHWMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 23 Aug 2020 08:00:06 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7A3C061573
        for <fio@vger.kernel.org>; Sun, 23 Aug 2020 05:00:05 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k9ofL-0002Z0-N3
        for fio@vger.kernel.org; Sun, 23 Aug 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200823120002.2959E1BC01C0@kernel.dk>
Date: Sun, 23 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d836624b3a7eb3433bdf8f7193b44daacd5ba6d1:

  engines/io_uring: don't attempt to set RLIMITs (2020-08-21 16:22:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 84106576cefbbd9f5dfa5ee33b245f77938d0269:

  t/io_uring: cleanup vectored vs non-vectored (2020-08-22 11:26:39 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/io_uring: use non-vectored read/write if available
      t/io_uring: use non-vectored reads if available
      t/io_uring: cleanup vectored vs non-vectored

 engines/io_uring.c  |  37 +++++++++++++++
 os/linux/io_uring.h | 131 +++++++++++++++++++++++++++++++++++++++++++++++-----
 t/io_uring.c        |  32 +++++++++++++
 3 files changed, 188 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 2b1b1357..ec8cb18a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -174,6 +174,7 @@ static struct fio_option options[] = {
 		.lname	= "Non-vectored",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct ioring_options, nonvectored),
+		.def	= "-1",
 		.help	= "Use non-vectored read/write commands",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_IOURING,
@@ -547,6 +548,40 @@ static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 	return 0;
 }
 
+static void fio_ioring_probe(struct thread_data *td)
+{
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
+	struct io_uring_probe *p;
+	int ret;
+
+	/* already set by user, don't touch */
+	if (o->nonvectored != -1)
+		return;
+
+	/* default to off, as that's always safe */
+	o->nonvectored = 0;
+
+	p = malloc(sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	if (!p)
+		return;
+
+	memset(p, 0, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	ret = syscall(__NR_io_uring_register, ld->ring_fd,
+			IORING_REGISTER_PROBE, p, 256);
+	if (ret < 0)
+		goto out;
+
+	if (IORING_OP_WRITE > p->ops_len)
+		goto out;
+
+	if ((p->ops[IORING_OP_READ].flags & IO_URING_OP_SUPPORTED) &&
+	    (p->ops[IORING_OP_WRITE].flags & IO_URING_OP_SUPPORTED))
+		o->nonvectored = 1;
+out:
+	free(p);
+}
+
 static int fio_ioring_queue_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
@@ -573,6 +608,8 @@ static int fio_ioring_queue_init(struct thread_data *td)
 
 	ld->ring_fd = ret;
 
+	fio_ioring_probe(td);
+
 	if (o->fixedbufs) {
 		ret = syscall(__NR_io_uring_register, ld->ring_fd,
 				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 03d2dde4..d39b45fd 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -1,4 +1,4 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/* SPDX-License-Identifier: (GPL-2.0 WITH Linux-syscall-note) OR MIT */
 /*
  * Header file for the io_uring interface.
  *
@@ -11,6 +11,10 @@
 #include <linux/fs.h>
 #include <linux/types.h>
 
+#ifdef __cplusplus
+extern "C" {
+#endif
+
 /*
  * IO submission data structure (Submission Queue Entry)
  */
@@ -23,12 +27,16 @@ struct io_uring_sqe {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
 	};
-	__u64	addr;		/* pointer to buffer or iovecs */
+	union {
+		__u64	addr;	/* pointer to buffer or iovecs */
+		__u64	splice_off_in;
+	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
-		__u16		poll_events;
+		__u16		poll_events;	/* compatibility */
+		__u32		poll32_events;	/* word-reversed for BE */
 		__u32		sync_range_flags;
 		__u32		msg_flags;
 		__u32		timeout_flags;
@@ -36,22 +44,51 @@ struct io_uring_sqe {
 		__u32		cancel_flags;
 		__u32		open_flags;
 		__u32		statx_flags;
+		__u32		fadvise_advice;
+		__u32		splice_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
-		__u16	buf_index;	/* index into fixed buffers, if used */
+		struct {
+			/* pack this to avoid bogus arm OABI complaints */
+			union {
+				/* index into fixed buffers, if used */
+				__u16	buf_index;
+				/* for grouped buffer selection */
+				__u16	buf_group;
+			} __attribute__((packed));
+			/* personality to use, if used */
+			__u16	personality;
+			__s32	splice_fd_in;
+		};
 		__u64	__pad2[3];
 	};
 };
 
+enum {
+	IOSQE_FIXED_FILE_BIT,
+	IOSQE_IO_DRAIN_BIT,
+	IOSQE_IO_LINK_BIT,
+	IOSQE_IO_HARDLINK_BIT,
+	IOSQE_ASYNC_BIT,
+	IOSQE_BUFFER_SELECT_BIT,
+};
+
 /*
  * sqe->flags
  */
-#define IOSQE_FIXED_FILE	(1U << 0)	/* use fixed fileset */
-#define IOSQE_IO_DRAIN		(1U << 1)	/* issue after inflight IO */
-#define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
-#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */
-#define IOSQE_ASYNC		(1U << 4)	/* always go async */
+/* use fixed fileset */
+#define IOSQE_FIXED_FILE	(1U << IOSQE_FIXED_FILE_BIT)
+/* issue after inflight IO */
+#define IOSQE_IO_DRAIN		(1U << IOSQE_IO_DRAIN_BIT)
+/* links next sqe */
+#define IOSQE_IO_LINK		(1U << IOSQE_IO_LINK_BIT)
+/* like LINK, but stronger */
+#define IOSQE_IO_HARDLINK	(1U << IOSQE_IO_HARDLINK_BIT)
+/* always go async */
+#define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
+/* select buffer from sqe->buf_group */
+#define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 
 /*
  * io_uring_setup() flags
@@ -60,6 +97,8 @@ struct io_uring_sqe {
 #define IORING_SETUP_SQPOLL	(1U << 1)	/* SQ poll thread */
 #define IORING_SETUP_SQ_AFF	(1U << 2)	/* sq_thread_cpu is valid */
 #define IORING_SETUP_CQSIZE	(1U << 3)	/* app defines CQ size */
+#define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
+#define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 
 enum {
 	IORING_OP_NOP,
@@ -86,6 +125,16 @@ enum {
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
+	IORING_OP_FADVISE,
+	IORING_OP_MADVISE,
+	IORING_OP_SEND,
+	IORING_OP_RECV,
+	IORING_OP_OPENAT2,
+	IORING_OP_EPOLL_CTL,
+	IORING_OP_SPLICE,
+	IORING_OP_PROVIDE_BUFFERS,
+	IORING_OP_REMOVE_BUFFERS,
+	IORING_OP_TEE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -101,6 +150,12 @@ enum {
  */
 #define IORING_TIMEOUT_ABS	(1U << 0)
 
+/*
+ * sqe->splice_flags
+ * extends splice(2) flags
+ */
+#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
@@ -110,6 +165,17 @@ struct io_uring_cqe {
 	__u32	flags;
 };
 
+/*
+ * cqe->flags
+ *
+ * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
+ */
+#define IORING_CQE_F_BUFFER		(1U << 0)
+
+enum {
+	IORING_CQE_BUFFER_SHIFT		= 16,
+};
+
 /*
  * Magic offsets for the application to mmap the data it needs
  */
@@ -136,6 +202,7 @@ struct io_sqring_offsets {
  * sq_ring->flags
  */
 #define IORING_SQ_NEED_WAKEUP	(1U << 0) /* needs io_uring_enter wakeup */
+#define IORING_SQ_CQ_OVERFLOW	(1U << 1) /* CQ ring is overflown */
 
 struct io_cqring_offsets {
 	__u32 head;
@@ -144,9 +211,18 @@ struct io_cqring_offsets {
 	__u32 ring_entries;
 	__u32 overflow;
 	__u32 cqes;
-	__u64 resv[2];
+	__u32 flags;
+	__u32 resv1;
+	__u64 resv2;
 };
 
+/*
+ * cq_ring->flags
+ */
+
+/* disable eventfd notifications */
+#define IORING_CQ_EVENTFD_DISABLED	(1U << 0)
+
 /*
  * io_uring_enter(2) flags
  */
@@ -163,7 +239,8 @@ struct io_uring_params {
 	__u32 sq_thread_cpu;
 	__u32 sq_thread_idle;
 	__u32 features;
-	__u32 resv[4];
+	__u32 wq_fd;
+	__u32 resv[3];
 	struct io_sqring_offsets sq_off;
 	struct io_cqring_offsets cq_off;
 };
@@ -174,6 +251,10 @@ struct io_uring_params {
 #define IORING_FEAT_SINGLE_MMAP		(1U << 0)
 #define IORING_FEAT_NODROP		(1U << 1)
 #define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
+#define IORING_FEAT_RW_CUR_POS		(1U << 3)
+#define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
+#define IORING_FEAT_FAST_POLL		(1U << 5)
+#define IORING_FEAT_POLL_32BITS 	(1U << 6)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -185,10 +266,36 @@ struct io_uring_params {
 #define IORING_REGISTER_EVENTFD		4
 #define IORING_UNREGISTER_EVENTFD	5
 #define IORING_REGISTER_FILES_UPDATE	6
+#define IORING_REGISTER_EVENTFD_ASYNC	7
+#define IORING_REGISTER_PROBE		8
+#define IORING_REGISTER_PERSONALITY	9
+#define IORING_UNREGISTER_PERSONALITY	10
 
 struct io_uring_files_update {
 	__u32 offset;
-	__s32 *fds;
+	__u32 resv;
+	__aligned_u64 /* __s32 * */ fds;
 };
 
+#define IO_URING_OP_SUPPORTED	(1U << 0)
+
+struct io_uring_probe_op {
+	__u8 op;
+	__u8 resv;
+	__u16 flags;	/* IO_URING_OP_* flags */
+	__u32 resv2;
+};
+
+struct io_uring_probe {
+	__u8 last_op;	/* last opcode supported */
+	__u8 ops_len;	/* length of ops[] array below */
+	__u16 resv;
+	__u32 resv2[3];
+	struct io_uring_probe_op ops[0];
+};
+
+#ifdef __cplusplus
+}
+#endif
+
 #endif
diff --git a/t/io_uring.c b/t/io_uring.c
index 7fa84f99..8d258136 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -94,6 +94,8 @@ static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 static int do_nop = 0;		/* no-op SQ ring commands */
 
+static int vectored = 1;
+
 static int io_uring_register_buffers(struct submitter *s)
 {
 	if (do_nop)
@@ -125,6 +127,29 @@ static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 	return syscall(__NR_io_uring_setup, entries, p);
 }
 
+static void io_uring_probe(int fd)
+{
+	struct io_uring_probe *p;
+	int ret;
+
+	p = malloc(sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	if (!p)
+		return;
+
+	memset(p, 0, sizeof(*p) + 256 * sizeof(struct io_uring_probe_op));
+	ret = syscall(__NR_io_uring_register, fd, IORING_REGISTER_PROBE, p, 256);
+	if (ret < 0)
+		goto out;
+
+	if (IORING_OP_READ > p->ops_len)
+		goto out;
+
+	if ((p->ops[IORING_OP_READ].flags & IO_URING_OP_SUPPORTED))
+		vectored = 0;
+out:
+	free(p);
+}
+
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
@@ -184,6 +209,11 @@ static void init_io(struct submitter *s, unsigned index)
 		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
 		sqe->len = bs;
 		sqe->buf_index = index;
+	} else if (!vectored) {
+		sqe->opcode = IORING_OP_READ;
+		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
+		sqe->len = bs;
+		sqe->buf_index = 0;
 	} else {
 		sqe->opcode = IORING_OP_READV;
 		sqe->addr = (unsigned long) &s->iovecs[index];
@@ -414,6 +444,8 @@ static int setup_ring(struct submitter *s)
 	}
 	s->ring_fd = fd;
 
+	io_uring_probe(fd);
+
 	if (fixedbufs) {
 		ret = io_uring_register_buffers(s);
 		if (ret < 0) {

