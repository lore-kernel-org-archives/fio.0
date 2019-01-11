Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57748 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731545AbfAKNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Jan 2019 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ghwPu-0000Zc-Cj
        for fio@vger.kernel.org; Fri, 11 Jan 2019 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190111130002.4B2742C03CF@kernel.dk>
Date: Fri, 11 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 650346e17d045366b817814dd3e10dc94d0d990f:

  engines/io_uring: always setup ld->iovecs[] (2019-01-09 15:13:06 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a7abc9fb769596d3bbf6d779e99d1cb8c1fcd49b:

  t/io_uring: add support for registered files (2019-01-10 22:29:27 -0700)

----------------------------------------------------------------
Jens Axboe (10):
      Update to newer io_uring API
      Makefile: make t/io_uring depend on os/io_uring.h
      io_uring: io_uring_setup(2) takes a 'nr_iovecs' field now
      Update io_uring API
      io_uring: cleanup sq thread poll/cpu setup
      t/io_uring: restore usage of IORING_SETUP_IOPOLL
      t/io_uring: make more efficient for multiple files
      t/io_uring: enable SQ thread poll mode
      t/io_uring: make submits/reaps per-second reflected with sq thread poll
      t/io_uring: add support for registered files

 Makefile           |   1 +
 arch/arch-x86_64.h |   7 +-
 engines/io_uring.c | 100 +++++++++++-----------
 os/io_uring.h      |  50 ++++++++---
 t/io_uring.c       | 242 +++++++++++++++++++++++++++++++++++++----------------
 5 files changed, 264 insertions(+), 136 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 5bc82f9a..3701317e 100644
--- a/Makefile
+++ b/Makefile
@@ -444,6 +444,7 @@ cairo_text_helpers.o: cairo_text_helpers.c cairo_text_helpers.h
 printing.o: printing.c printing.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
+t/io_uring.o: os/io_uring.h
 t/io_uring: $(T_IOU_RING_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IOU_RING_OBJS) $(LIBS)
 
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index a5864bab..665c6b04 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -2,10 +2,13 @@
 #define ARCH_X86_64_H
 
 #ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup	335
+#define __NR_sys_io_uring_setup		335
 #endif
 #ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter	336
+#define __NR_sys_io_uring_enter		336
+#endif
+#ifndef __NR_sys_io_uring_register
+#define __NR_sys_io_uring_register	337
 #endif
 
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 06355e9c..7591190a 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -73,18 +73,17 @@ struct ioring_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int fixedbufs;
-	unsigned int sqthread;
-	unsigned int sqthread_set;
-	unsigned int sqthread_poll;
-	unsigned int sqwq;
+	unsigned int sqpoll_thread;
+	unsigned int sqpoll_set;
+	unsigned int sqpoll_cpu;
 };
 
-static int fio_ioring_sqthread_cb(void *data, unsigned long long *val)
+static int fio_ioring_sqpoll_cb(void *data, unsigned long long *val)
 {
 	struct ioring_options *o = data;
 
-	o->sqthread = *val;
-	o->sqthread_set = 1;
+	o->sqpoll_cpu = *val;
+	o->sqpoll_set = 1;
 	return 0;
 }
 
@@ -107,30 +106,21 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
-	{
-		.name	= "sqthread",
-		.lname	= "Use kernel SQ thread on this CPU",
-		.type	= FIO_OPT_INT,
-		.cb	= fio_ioring_sqthread_cb,
-		.help	= "Offload submission to kernel thread",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
 	{
 		.name	= "sqthread_poll",
-		.lname	= "Kernel SQ thread should poll",
-		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct ioring_options, sqthread_poll),
-		.help	= "Used with sqthread, enables kernel side polling",
+		.lname	= "Kernel SQ thread polling",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct ioring_options, sqpoll_thread),
+		.help	= "Offload submission/completion to kernel thread",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
 	{
-		.name	= "sqwq",
-		.lname	= "Offload submission to kernel workqueue",
-		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct ioring_options, sqwq),
-		.help	= "Offload submission to kernel workqueue",
+		.name	= "sqthread_poll_cpu",
+		.lname	= "SQ Thread Poll CPU",
+		.type	= FIO_OPT_INT,
+		.cb	= fio_ioring_sqpoll_cb,
+		.help	= "What CPU to run SQ thread polling on",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
@@ -157,20 +147,20 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	sqe->fd = f->fd;
 	sqe->flags = 0;
 	sqe->ioprio = 0;
+	sqe->buf_index = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		if (io_u->ddir == DDIR_READ)
+			sqe->opcode = IORING_OP_READV;
+		else
+			sqe->opcode = IORING_OP_WRITEV;
+
 		if (o->fixedbufs) {
-			if (io_u->ddir == DDIR_READ)
-				sqe->opcode = IORING_OP_READ_FIXED;
-			else
-				sqe->opcode = IORING_OP_WRITE_FIXED;
+			sqe->flags |= IOSQE_FIXED_BUFFER;
 			sqe->addr = io_u->xfer_buf;
 			sqe->len = io_u->xfer_buflen;
+			sqe->buf_index = io_u->index;
 		} else {
-			if (io_u->ddir == DDIR_READ)
-				sqe->opcode = IORING_OP_READV;
-			else
-				sqe->opcode = IORING_OP_WRITEV;
 			sqe->addr = &ld->iovecs[io_u->index];
 			sqe->len = 1;
 		}
@@ -178,6 +168,7 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	} else if (ddir_sync(io_u->ddir))
 		sqe->opcode = IORING_OP_FSYNC;
 
+	sqe->data = (unsigned long) io_u;
 	return 0;
 }
 
@@ -191,7 +182,7 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	cqe = &ld->cq_ring.cqes[index];
-	io_u = ld->io_u_index[cqe->index];
+	io_u = (struct io_u *) cqe->data;
 
 	if (cqe->res != io_u->xfer_buflen) {
 		if (cqe->res > io_u->xfer_buflen)
@@ -250,7 +241,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 			continue;
 		}
 
-		if (!o->sqthread_poll) {
+		if (!o->sqpoll_thread) {
 			r = io_uring_enter(ld, 0, actual_min,
 						IORING_ENTER_GETEVENTS);
 			if (r < 0) {
@@ -332,10 +323,15 @@ static int fio_ioring_commit(struct thread_data *td)
 	if (!ld->queued)
 		return 0;
 
-	/* Nothing to do */
-	if (o->sqthread_poll) {
+	/*
+	 * Kernel side does submission. just need to check if the ring is
+	 * flagged as needing a kick, if so, call io_uring_enter(). This
+	 * only happens if we've been idle too long.
+	 */
+	if (o->sqpoll_thread) {
 		struct io_sq_ring *ring = &ld->sq_ring;
 
+		read_barrier();
 		if (*ring->flags & IORING_SQ_NEED_WAKEUP)
 			io_uring_enter(ld, ld->queued, 0, 0);
 		ld->queued = 0;
@@ -445,7 +441,6 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	int depth = td->o.iodepth;
-	struct iovec *vecs = NULL;
 	struct io_uring_params p;
 	int ret;
 
@@ -453,14 +448,13 @@ static int fio_ioring_queue_init(struct thread_data *td)
 
 	if (o->hipri)
 		p.flags |= IORING_SETUP_IOPOLL;
-	if (o->sqthread_set) {
-		p.sq_thread_cpu = o->sqthread;
-		p.flags |= IORING_SETUP_SQTHREAD;
-		if (o->sqthread_poll)
-			p.flags |= IORING_SETUP_SQPOLL;
+	if (o->sqpoll_thread) {
+		p.flags |= IORING_SETUP_SQPOLL;
+		if (o->sqpoll_set) {
+			p.flags |= IORING_SETUP_SQ_AFF;
+			p.sq_thread_cpu = o->sqpoll_cpu;
+		}
 	}
-	if (o->sqwq)
-		p.flags |= IORING_SETUP_SQWQ;
 
 	if (o->fixedbufs) {
 		struct rlimit rlim = {
@@ -469,14 +463,26 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		};
 
 		setrlimit(RLIMIT_MEMLOCK, &rlim);
-		vecs = ld->iovecs;
 	}
 
-	ret = syscall(__NR_sys_io_uring_setup, depth, vecs, &p);
+	ret = syscall(__NR_sys_io_uring_setup, depth, &p);
 	if (ret < 0)
 		return ret;
 
 	ld->ring_fd = ret;
+
+	if (o->fixedbufs) {
+		struct io_uring_register_buffers reg = {
+			.iovecs = ld->iovecs,
+			.nr_iovecs = depth
+		};
+
+		ret = syscall(__NR_sys_io_uring_register, ld->ring_fd,
+				IORING_REGISTER_BUFFERS, &reg);
+		if (ret < 0)
+			return ret;
+	}
+
 	return fio_ioring_mmap(ld, &p);
 }
 
diff --git a/os/io_uring.h b/os/io_uring.h
index 20e4c22e..e1d3df0b 100644
--- a/os/io_uring.h
+++ b/os/io_uring.h
@@ -15,42 +15,48 @@
  * IO submission data structure (Submission Queue Entry)
  */
 struct io_uring_sqe {
-	__u8	opcode;
-	__u8	flags;
-	__u16	ioprio;
-	__s32	fd;
-	__u64	off;
+	__u8	opcode;		/* type of operation for this sqe */
+	__u8	flags;		/* IOSQE_ flags below */
+	__u16	ioprio;		/* ioprio for the request */
+	__s32	fd;		/* file descriptor to do IO on */
+	__u64	off;		/* offset into file */
 	union {
-		void	*addr;
+		void	*addr;	/* buffer or iovecs */
 		__u64	__pad;
 	};
-	__u32	len;
+	__u32	len;		/* buffer size or number of iovecs */
 	union {
 		__kernel_rwf_t	rw_flags;
 		__u32		__resv;
 	};
+	__u16	buf_index;	/* index into fixed buffers, if used */
+	__u16	__pad2[3];
+	__u64	data;		/* data to be passed back at completion time */
 };
 
+/*
+ * sqe->flags
+ */
+#define IOSQE_FIXED_BUFFER	(1 << 0)	/* use fixed buffer */
+#define IOSQE_FIXED_FILE	(1 << 1)	/* use fixed fileset */
+
 /*
  * io_uring_setup() flags
  */
 #define IORING_SETUP_IOPOLL	(1 << 0)	/* io_context is polled */
-#define	IORING_SETUP_SQTHREAD	(1 << 1)	/* Use SQ thread */
-#define IORING_SETUP_SQWQ	(1 << 2)	/* Use SQ workqueue */
-#define IORING_SETUP_SQPOLL	(1 << 3)	/* SQ thread polls */
+#define IORING_SETUP_SQPOLL	(1 << 1)	/* SQ poll thread */
+#define IORING_SETUP_SQ_AFF	(1 << 2)	/* sq_thread_cpu is valid */
 
 #define IORING_OP_READV		1
 #define IORING_OP_WRITEV	2
 #define IORING_OP_FSYNC		3
 #define IORING_OP_FDSYNC	4
-#define IORING_OP_READ_FIXED	5
-#define IORING_OP_WRITE_FIXED	6
 
 /*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
-	__u64	index;		/* what sqe this event came from */
+	__u64	data;		/* sqe->data submission passed back */
 	__s32	res;		/* result code for this event */
 	__u32	flags;
 };
@@ -111,4 +117,22 @@ struct io_uring_params {
 	struct io_cqring_offsets cq_off;
 };
 
+/*
+ * io_uring_register(2) opcodes and arguments
+ */
+#define IORING_REGISTER_BUFFERS		0
+#define IORING_UNREGISTER_BUFFERS	1
+#define IORING_REGISTER_FILES		2
+#define IORING_UNREGISTER_FILES		3
+
+struct io_uring_register_buffers {
+	struct iovec *iovecs;
+	unsigned nr_iovecs;
+};
+
+struct io_uring_register_files {
+	int *fds;
+	unsigned nr_fds;
+};
+
 #endif
diff --git a/t/io_uring.c b/t/io_uring.c
index 3edc87c6..0461329b 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -33,6 +33,7 @@ struct io_sq_ring {
 	unsigned *tail;
 	unsigned *ring_mask;
 	unsigned *ring_entries;
+	unsigned *flags;
 	unsigned *array;
 };
 
@@ -44,18 +45,25 @@ struct io_cq_ring {
 	struct io_uring_cqe *cqes;
 };
 
-#define DEPTH			32
+#define DEPTH			128
 
-#define BATCH_SUBMIT		8
-#define BATCH_COMPLETE		8
+#define BATCH_SUBMIT		64
+#define BATCH_COMPLETE		64
 
 #define BS			4096
 
+#define MAX_FDS			16
+
 static unsigned sq_ring_mask, cq_ring_mask;
 
+struct file {
+	unsigned long max_blocks;
+	unsigned pending_ios;
+	int fd;
+};
+
 struct submitter {
 	pthread_t thread;
-	unsigned long max_blocks;
 	int ring_fd;
 	struct drand48_data rand;
 	struct io_sq_ring sq_ring;
@@ -68,22 +76,51 @@ struct submitter {
 	unsigned long calls;
 	unsigned long cachehit, cachemiss;
 	volatile int finish;
-	char filename[128];
+
+	struct file files[MAX_FDS];
+	unsigned nr_files;
+	unsigned cur_file;
 };
 
 static struct submitter submitters[1];
 static volatile int finish;
 
 static int polled = 1;		/* use IO polling */
-static int fixedbufs = 0;	/* use fixed user buffers */
+static int fixedbufs = 1;	/* use fixed user buffers */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
-static int sq_thread = 0;	/* use kernel submission thread */
-static int sq_thread_cpu = 0;	/* pin above thread to this CPU */
+static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
+static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 
-static int io_uring_setup(unsigned entries, struct iovec *iovecs,
-			  struct io_uring_params *p)
+static int io_uring_register_buffers(struct submitter *s)
 {
-	return syscall(__NR_sys_io_uring_setup, entries, iovecs, p);
+	struct io_uring_register_buffers reg = {
+		.iovecs = s->iovecs,
+		.nr_iovecs = DEPTH
+	};
+
+	return syscall(__NR_sys_io_uring_register, s->ring_fd,
+			IORING_REGISTER_BUFFERS, &reg);
+}
+
+static int io_uring_register_files(struct submitter *s)
+{
+	struct io_uring_register_files reg;
+	int i, ret;
+
+	reg.fds = calloc(s->nr_files, sizeof(int));
+	for (i = 0; i < s->nr_files; i++)
+		reg.fds[i] = s->files[i].fd;
+	reg.nr_fds = s->nr_files;
+
+	ret = syscall(__NR_sys_io_uring_register, s->ring_fd,
+			IORING_REGISTER_FILES, &reg);
+	free(reg.fds);
+	return ret;
+}
+
+static int io_uring_setup(unsigned entries, struct io_uring_params *p)
+{
+	return syscall(__NR_sys_io_uring_setup, entries, p);
 }
 
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
@@ -98,31 +135,52 @@ static int gettid(void)
 	return syscall(__NR_gettid);
 }
 
-static void init_io(struct submitter *s, int fd, unsigned index)
+static unsigned file_depth(struct submitter *s)
+{
+	return (DEPTH + s->nr_files - 1) / s->nr_files;
+}
+
+static void init_io(struct submitter *s, unsigned index)
 {
 	struct io_uring_sqe *sqe = &s->sqes[index];
 	unsigned long offset;
+	struct file *f;
 	long r;
 
+	if (s->nr_files == 1) {
+		f = &s->files[0];
+	} else {
+		f = &s->files[s->cur_file];
+		if (f->pending_ios >= file_depth(s)) {
+			s->cur_file++;
+			if (s->cur_file == s->nr_files)
+				s->cur_file = 0;
+		}
+	}
+	f->pending_ios++;
+
 	lrand48_r(&s->rand, &r);
-	offset = (r % (s->max_blocks - 1)) * BS;
+	offset = (r % (f->max_blocks - 1)) * BS;
 
+	sqe->flags = IOSQE_FIXED_FILE;
+	sqe->opcode = IORING_OP_READV;
 	if (fixedbufs) {
-		sqe->opcode = IORING_OP_READ_FIXED;
 		sqe->addr = s->iovecs[index].iov_base;
 		sqe->len = BS;
+		sqe->buf_index = index;
+		sqe->flags |= IOSQE_FIXED_BUFFER;
 	} else {
-		sqe->opcode = IORING_OP_READV;
 		sqe->addr = &s->iovecs[index];
 		sqe->len = 1;
+		sqe->buf_index = 0;
 	}
-	sqe->flags = 0;
 	sqe->ioprio = 0;
-	sqe->fd = fd;
+	sqe->fd = f->fd;
 	sqe->off = offset;
+	sqe->data = (unsigned long) f;
 }
 
-static int prep_more_ios(struct submitter *s, int fd, int max_ios)
+static int prep_more_ios(struct submitter *s, int max_ios)
 {
 	struct io_sq_ring *ring = &s->sq_ring;
 	unsigned index, tail, next_tail, prepped = 0;
@@ -135,7 +193,7 @@ static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 			break;
 
 		index = tail & sq_ring_mask;
-		init_io(s, fd, index);
+		init_io(s, index);
 		ring->array[index] = index;
 		prepped++;
 		tail = next_tail;
@@ -150,22 +208,22 @@ static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 	return prepped;
 }
 
-static int get_file_size(int fd, unsigned long *blocks)
+static int get_file_size(struct file *f)
 {
 	struct stat st;
 
-	if (fstat(fd, &st) < 0)
+	if (fstat(f->fd, &st) < 0)
 		return -1;
 	if (S_ISBLK(st.st_mode)) {
 		unsigned long long bytes;
 
-		if (ioctl(fd, BLKGETSIZE64, &bytes) != 0)
+		if (ioctl(f->fd, BLKGETSIZE64, &bytes) != 0)
 			return -1;
 
-		*blocks = bytes / BS;
+		f->max_blocks = bytes / BS;
 		return 0;
 	} else if (S_ISREG(st.st_mode)) {
-		*blocks = st.st_size / BS;
+		f->max_blocks = st.st_size / BS;
 		return 0;
 	}
 
@@ -180,17 +238,16 @@ static int reap_events(struct submitter *s)
 
 	head = *ring->head;
 	do {
+		struct file *f;
+
 		barrier();
 		if (head == *ring->tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
+		f = (struct file *) cqe->data;
+		f->pending_ios--;
 		if (cqe->res != BS) {
-			struct io_uring_sqe *sqe = &s->sqes[cqe->index];
-
 			printf("io: unexpected ret=%d\n", cqe->res);
-			printf("offset=%lu, size=%lu\n",
-					(unsigned long) sqe->off,
-					(unsigned long) sqe->len);
 			return -1;
 		}
 		if (cqe->flags & IOCQE_FLAG_CACHEHIT)
@@ -210,29 +267,11 @@ static int reap_events(struct submitter *s)
 static void *submitter_fn(void *data)
 {
 	struct submitter *s = data;
-	int fd, ret, prepped, flags;
+	struct io_sq_ring *ring = &s->sq_ring;
+	int ret, prepped;
 
 	printf("submitter=%d\n", gettid());
 
-	flags = O_RDONLY;
-	if (!buffered)
-		flags |= O_DIRECT;
-	fd = open(s->filename, flags);
-	if (fd < 0) {
-		perror("open");
-		goto done;
-	}
-
-	if (get_file_size(fd, &s->max_blocks)) {
-		printf("failed getting size of device/file\n");
-		goto err;
-	}
-	if (s->max_blocks <= 1) {
-		printf("Zero file/device size?\n");
-		goto err;
-	}
-	s->max_blocks--;
-
 	srand48_r(pthread_self(), &s->rand);
 
 	prepped = 0;
@@ -241,7 +280,7 @@ static void *submitter_fn(void *data)
 
 		if (!prepped && s->inflight < DEPTH) {
 			to_prep = min(DEPTH - s->inflight, BATCH_SUBMIT);
-			prepped = prep_more_ios(s, fd, to_prep);
+			prepped = prep_more_ios(s, to_prep);
 		}
 		s->inflight += prepped;
 submit_more:
@@ -252,13 +291,30 @@ submit:
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
 
-		ret = io_uring_enter(s, to_submit, to_wait,
-					IORING_ENTER_GETEVENTS);
-		s->calls++;
+		/*
+		 * Only need to call io_uring_enter if we're not using SQ thread
+		 * poll, or if IORING_SQ_NEED_WAKEUP is set.
+		 */
+		if (!sq_thread_poll || (*ring->flags & IORING_SQ_NEED_WAKEUP)) {
+			ret = io_uring_enter(s, to_submit, to_wait,
+						IORING_ENTER_GETEVENTS);
+			s->calls++;
+		}
 
-		this_reap = reap_events(s);
-		if (this_reap == -1)
-			break;
+		/*
+		 * For non SQ thread poll, we already got the events we needed
+		 * through the io_uring_enter() above. For SQ thread poll, we
+		 * need to loop here until we find enough events.
+		 */
+		this_reap = 0;
+		do {
+			int r;
+			r = reap_events(s);
+			if (r == -1)
+				break;
+			else if (r > 0)
+				this_reap += r;
+		} while (sq_thread_poll && this_reap < to_wait);
 		s->reaps += this_reap;
 
 		if (ret >= 0) {
@@ -290,9 +346,7 @@ submit:
 			break;
 		}
 	} while (!s->finish);
-err:
-	close(fd);
-done:
+
 	finish = 1;
 	return NULL;
 }
@@ -319,30 +373,40 @@ static int setup_ring(struct submitter *s)
 	struct io_sq_ring *sring = &s->sq_ring;
 	struct io_cq_ring *cring = &s->cq_ring;
 	struct io_uring_params p;
+	int ret, fd;
 	void *ptr;
-	int fd;
 
 	memset(&p, 0, sizeof(p));
 
 	if (polled)
 		p.flags |= IORING_SETUP_IOPOLL;
-	if (buffered)
-		p.flags |= IORING_SETUP_SQWQ;
-	else if (sq_thread) {
-		p.flags |= IORING_SETUP_SQTHREAD;
-		p.sq_thread_cpu = sq_thread_cpu;
+	if (sq_thread_poll) {
+		p.flags |= IORING_SETUP_SQPOLL;
+		if (sq_thread_cpu != -1)
+			p.flags |= IORING_SETUP_SQ_AFF;
 	}
 
-	if (fixedbufs)
-		fd = io_uring_setup(DEPTH, s->iovecs, &p);
-	else
-		fd = io_uring_setup(DEPTH, NULL, &p);
+	fd = io_uring_setup(DEPTH, &p);
 	if (fd < 0) {
 		perror("io_uring_setup");
 		return 1;
 	}
-
 	s->ring_fd = fd;
+
+	if (fixedbufs) {
+		ret = io_uring_register_buffers(s);
+		if (ret < 0) {
+			perror("io_uring_register_buffers");
+			return 1;
+		}
+	}
+
+	ret = io_uring_register_files(s);
+	if (ret < 0) {
+		perror("io_uring_register_files");
+		return 1;
+	}
+
 	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_SQ_RING);
@@ -351,6 +415,7 @@ static int setup_ring(struct submitter *s)
 	sring->tail = ptr + p.sq_off.tail;
 	sring->ring_mask = ptr + p.sq_off.ring_mask;
 	sring->ring_entries = ptr + p.sq_off.ring_entries;
+	sring->flags = ptr + p.sq_off.flags;
 	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
@@ -376,7 +441,7 @@ int main(int argc, char *argv[])
 {
 	struct submitter *s = &submitters[0];
 	unsigned long done, calls, reap, cache_hit, cache_miss;
-	int err, i;
+	int err, i, flags, fd;
 	struct rlimit rlim;
 	void *ret;
 
@@ -385,6 +450,35 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	flags = O_RDONLY | O_NOATIME;
+	if (!buffered)
+		flags |= O_DIRECT;
+
+	i = 1;
+	while (i < argc) {
+		struct file *f = &s->files[s->nr_files];
+
+		fd = open(argv[i], flags);
+		if (fd < 0) {
+			perror("open");
+			return 1;
+		}
+		f->fd = fd;
+		if (get_file_size(f)) {
+			printf("failed getting size of device/file\n");
+			return 1;
+		}
+		if (f->max_blocks <= 1) {
+			printf("Zero file/device size?\n");
+			return 1;
+		}
+		f->max_blocks--;
+
+		printf("Added file %s\n", argv[i]);
+		s->nr_files++;
+		i++;
+	}
+
 	rlim.rlim_cur = RLIM_INFINITY;
 	rlim.rlim_max = RLIM_INFINITY;
 	if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0) {
@@ -412,7 +506,6 @@ int main(int argc, char *argv[])
 	}
 	printf("polled=%d, fixedbufs=%d, buffered=%d", polled, fixedbufs, buffered);
 	printf(" QD=%d, sq_ring=%d, cq_ring=%d\n", DEPTH, *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
-	strcpy(s->filename, argv[1]);
 
 	pthread_create(&s->thread, NULL, submitter_fn, s);
 
@@ -443,8 +536,9 @@ int main(int argc, char *argv[])
 		if (this_call - calls) {
 			rpc = (this_done - done) / (this_call - calls);
 			ipc = (this_reap - reap) / (this_call - calls);
-		}
-		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%u tail=%u), Cachehit=%0.2f%%\n",
+		} else
+			rpc = ipc = -1;
+		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (head=%u tail=%u), Cachehit=%0.2f%%\n",
 				this_done - done, rpc, ipc, s->inflight,
 				*s->cq_ring.head, *s->cq_ring.tail, hit);
 		done = this_done;

