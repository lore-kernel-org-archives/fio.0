Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49924 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfAHNAZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Jan 2019 08:00:25 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ggqzX-0006pA-Nl
        for fio@vger.kernel.org; Tue, 08 Jan 2019 13:00:23 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190108130001.9CB9B2C0118@kernel.dk>
Date: Tue,  8 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f310970e737975088e41ea14c399450ba8ae3a49:

  t/aio-ring: cleanup the code a bit (2019-01-05 07:42:30 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6e70fd303855575c99c520e8c46b7d85c9f21dc8:

  io_uring.h should include <linux/fs.h> (2019-01-08 05:43:38 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Rename t/aio-ring to t/io_uring
      Rename aioring engine to io_uring
      io_uring.h should include <linux/fs.h>

 Makefile                          |  15 +-
 arch/arch-x86_64.h                |   2 +-
 engines/{aioring.c => io_uring.c} | 283 ++++++++++++++------------------------
 options.c                         |   8 +-
 os/io_uring.h                     | 101 ++++++++++++++
 t/{aio-ring.c => io_uring.c}      | 121 ++++++----------
 6 files changed, 254 insertions(+), 276 deletions(-)
 rename engines/{aioring.c => io_uring.c} (58%)
 create mode 100644 os/io_uring.h
 rename t/{aio-ring.c => io_uring.c} (81%)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index f111ae6a..5bc82f9a 100644
--- a/Makefile
+++ b/Makefile
@@ -68,9 +68,6 @@ endif
 ifdef CONFIG_LIBAIO
   SOURCE += engines/libaio.c
 endif
-ifdef CONFIG_LIBAIO
-  SOURCE += engines/aioring.c
-endif
 ifdef CONFIG_RDMA
   SOURCE += engines/rdma.c
 endif
@@ -154,7 +151,7 @@ endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
-		oslib/linux-dev-lookup.c
+		oslib/linux-dev-lookup.c engines/io_uring.c
   LIBS += -lpthread -ldl
   LDFLAGS += -rdynamic
 endif
@@ -266,8 +263,8 @@ T_VS_PROGS = t/fio-verify-state
 T_PIPE_ASYNC_OBJS = t/read-to-pipe-async.o
 T_PIPE_ASYNC_PROGS = t/read-to-pipe-async
 
-T_AIO_RING_OBJS = t/aio-ring.o
-T_AIO_RING_PROGS = t/aio-ring
+T_IOU_RING_OBJS = t/io_uring.o
+T_IOU_RING_PROGS = t/io_uring
 
 T_MEMLOCK_OBJS = t/memlock.o
 T_MEMLOCK_PROGS = t/memlock
@@ -287,7 +284,7 @@ T_OBJS += $(T_VS_OBJS)
 T_OBJS += $(T_PIPE_ASYNC_OBJS)
 T_OBJS += $(T_MEMLOCK_OBJS)
 T_OBJS += $(T_TT_OBJS)
-T_OBJS += $(T_AIO_RING_OBJS)
+T_OBJS += $(T_IOU_RING_OBJS)
 
 ifneq (,$(findstring CYGWIN,$(CONFIG_TARGET_OS)))
     T_DEDUPE_OBJS += os/windows/posix.o lib/hweight.o
@@ -447,8 +444,8 @@ cairo_text_helpers.o: cairo_text_helpers.c cairo_text_helpers.h
 printing.o: printing.c printing.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
-t/aio-ring: $(T_AIO_RING_OBJS)
-	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_AIO_RING_OBJS) $(LIBS)
+t/io_uring: $(T_IOU_RING_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IOU_RING_OBJS) $(LIBS)
 
 t/read-to-pipe-async: $(T_PIPE_ASYNC_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_PIPE_ASYNC_OBJS) $(LIBS)
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index d0a98b8b..a5864bab 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -44,7 +44,7 @@ static inline unsigned long long get_cpu_clock(void)
 #define ARCH_HAVE_FFZ
 #define ARCH_HAVE_SSE4_2
 #define ARCH_HAVE_CPU_CLOCK
-#define ARCH_HAVE_AIORING
+#define ARCH_HAVE_IOURING
 
 #define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
 #define RDSEED_LONG	".byte 0x48,0x0f,0xc7,0xf8"
diff --git a/engines/aioring.c b/engines/io_uring.c
similarity index 58%
rename from engines/aioring.c
rename to engines/io_uring.c
index 8cecb6ad..ebca08c8 100644
--- a/engines/aioring.c
+++ b/engines/io_uring.c
@@ -1,15 +1,14 @@
 /*
- * aioring engine
+ * io_uring engine
  *
- * IO engine using the new native Linux libaio ring interface. See:
+ * IO engine using the new native Linux aio io_uring interface. See:
  *
- * http://git.kernel.dk/cgit/linux-block/log/?h=aio-poll
+ * http://git.kernel.dk/cgit/linux-block/log/?h=io_uring
  *
  */
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
-#include <libaio.h>
 #include <sys/time.h>
 #include <sys/resource.h>
 
@@ -19,81 +18,17 @@
 #include "../lib/memalign.h"
 #include "../lib/fls.h"
 
-#ifdef ARCH_HAVE_AIORING
-
-/*
- * io_uring_setup(2) flags
- */
-#ifndef IOCTX_FLAG_SCQRING
-#define IOCTX_FLAG_SCQRING	(1 << 0)
-#endif
-#ifndef IOCTX_FLAG_IOPOLL
-#define IOCTX_FLAG_IOPOLL	(1 << 1)
-#endif
-#ifndef IOCTX_FLAG_FIXEDBUFS
-#define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
-#endif
-#ifndef IOCTX_FLAG_SQTHREAD
-#define IOCTX_FLAG_SQTHREAD	(1 << 3)
-#endif
-#ifndef IOCTX_FLAG_SQWQ
-#define IOCTX_FLAG_SQWQ		(1 << 4)
-#endif
-#ifndef IOCTX_FLAG_SQPOLL
-#define IOCTX_FLAG_SQPOLL	(1 << 5)
-#endif
-
-#define IORING_OFF_SQ_RING	0ULL
-#define IORING_OFF_CQ_RING	0x8000000ULL
-#define IORING_OFF_IOCB		0x10000000ULL
-
-/*
- * io_uring_enter(2) flags
- */
-#ifndef IORING_ENTER_GETEVENTS
-#define IORING_ENTER_GETEVENTS	(1 << 0)
-#endif
+#ifdef ARCH_HAVE_IOURING
 
 typedef uint64_t u64;
 typedef uint32_t u32;
+typedef int32_t s32;
 typedef uint16_t u16;
+typedef uint8_t u8;
 
-#define IORING_SQ_NEED_WAKEUP	(1 << 0)
-
-#define IOEV_RES2_CACHEHIT	(1 << 0)
-
-struct aio_sqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 flags;
-	u32 dropped;
-	u32 array;
-	u32 resv[3];
-};
-
-struct aio_cqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 overflow;
-	u32 events;
-	u32 resv[4];
-};
-
-struct aio_uring_params {
-	u32 sq_entries;
-	u32 cq_entries;
-	u32 flags;
-	u16 sq_thread_cpu;
-	u16 resv[9];
-	struct aio_sqring_offsets sq_off;
-	struct aio_cqring_offsets cq_off;
-};
+#include "../os/io_uring.h"
 
-struct aio_sq_ring {
+struct io_sq_ring {
 	u32 *head;
 	u32 *tail;
 	u32 *ring_mask;
@@ -102,32 +37,31 @@ struct aio_sq_ring {
 	u32 *array;
 };
 
-struct aio_cq_ring {
+struct io_cq_ring {
 	u32 *head;
 	u32 *tail;
 	u32 *ring_mask;
 	u32 *ring_entries;
-	struct io_event *events;
+	struct io_uring_event *events;
 };
 
-struct aioring_mmap {
+struct ioring_mmap {
 	void *ptr;
 	size_t len;
 };
 
-struct aioring_data {
+struct ioring_data {
 	int ring_fd;
 
 	struct io_u **io_us;
 	struct io_u **io_u_index;
 
-	struct aio_sq_ring sq_ring;
-	struct iocb *iocbs;
+	struct io_sq_ring sq_ring;
+	struct io_uring_iocb *iocbs;
 	struct iovec *iovecs;
 	unsigned sq_ring_mask;
 
-	struct aio_cq_ring cq_ring;
-	struct io_event *events;
+	struct io_cq_ring cq_ring;
 	unsigned cq_ring_mask;
 
 	int queued;
@@ -137,10 +71,10 @@ struct aioring_data {
 	uint64_t cachehit;
 	uint64_t cachemiss;
 
-	struct aioring_mmap mmap[3];
+	struct ioring_mmap mmap[3];
 };
 
-struct aioring_options {
+struct ioring_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int fixedbufs;
@@ -150,10 +84,9 @@ struct aioring_options {
 	unsigned int sqwq;
 };
 
-static int fio_aioring_sqthread_cb(void *data,
-				   unsigned long long *val)
+static int fio_ioring_sqthread_cb(void *data, unsigned long long *val)
 {
-	struct aioring_options *o = data;
+	struct ioring_options *o = data;
 
 	o->sqthread = *val;
 	o->sqthread_set = 1;
@@ -165,7 +98,7 @@ static struct fio_option options[] = {
 		.name	= "hipri",
 		.lname	= "High Priority",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct aioring_options, hipri),
+		.off1	= offsetof(struct ioring_options, hipri),
 		.help	= "Use polled IO completions",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -174,7 +107,7 @@ static struct fio_option options[] = {
 		.name	= "fixedbufs",
 		.lname	= "Fixed (pre-mapped) IO buffers",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct aioring_options, fixedbufs),
+		.off1	= offsetof(struct ioring_options, fixedbufs),
 		.help	= "Pre map IO buffers",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -183,7 +116,7 @@ static struct fio_option options[] = {
 		.name	= "sqthread",
 		.lname	= "Use kernel SQ thread on this CPU",
 		.type	= FIO_OPT_INT,
-		.cb	= fio_aioring_sqthread_cb,
+		.cb	= fio_ioring_sqthread_cb,
 		.help	= "Offload submission to kernel thread",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -192,7 +125,7 @@ static struct fio_option options[] = {
 		.name	= "sqthread_poll",
 		.lname	= "Kernel SQ thread should poll",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct aioring_options, sqthread_poll),
+		.off1	= offsetof(struct ioring_options, sqthread_poll),
 		.help	= "Used with sqthread, enables kernel side polling",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -201,7 +134,7 @@ static struct fio_option options[] = {
 		.name	= "sqwq",
 		.lname	= "Offload submission to kernel workqueue",
 		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct aioring_options, sqwq),
+		.off1	= offsetof(struct ioring_options, sqwq),
 		.help	= "Offload submission to kernel workqueue",
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
@@ -211,50 +144,49 @@ static struct fio_option options[] = {
 	},
 };
 
-static int io_uring_enter(struct aioring_data *ld, unsigned int to_submit,
+static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
 	return syscall(__NR_sys_io_uring_enter, ld->ring_fd, to_submit,
 			min_complete, flags);
 }
 
-static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
+static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 {
-	struct aioring_data *ld = td->io_ops_data;
+	struct ioring_data *ld = td->io_ops_data;
 	struct fio_file *f = io_u->file;
-	struct iocb *iocb;
+	struct io_uring_iocb *iocb;
 
 	iocb = &ld->iocbs[io_u->index];
+	iocb->fd = f->fd;
+	iocb->flags = 0;
+	iocb->ioprio = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
 		if (io_u->ddir == DDIR_READ)
-			iocb->aio_lio_opcode = IO_CMD_PREAD;
+			iocb->opcode = IORING_OP_READ;
 		else
-			iocb->aio_lio_opcode = IO_CMD_PWRITE;
-		iocb->aio_reqprio = 0;
-		iocb->aio_fildes = f->fd;
-		iocb->u.c.buf = io_u->xfer_buf;
-		iocb->u.c.nbytes = io_u->xfer_buflen;
-		iocb->u.c.offset = io_u->offset;
-		iocb->u.c.flags = 0;
+			iocb->opcode = IORING_OP_WRITE;
+		iocb->off = io_u->offset;
+		iocb->addr = io_u->xfer_buf;
+		iocb->len = io_u->xfer_buflen;
 	} else if (ddir_sync(io_u->ddir))
-		io_prep_fsync(iocb, f->fd);
+		iocb->opcode = IORING_OP_FSYNC;
 
-	iocb->data = io_u;
 	return 0;
 }
 
-static struct io_u *fio_aioring_event(struct thread_data *td, int event)
+static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct io_event *ev;
+	struct ioring_data *ld = td->io_ops_data;
+	struct io_uring_event *ev;
 	struct io_u *io_u;
 	unsigned index;
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	ev = &ld->cq_ring.events[index];
-	io_u = ev->data;
+	io_u = ld->io_u_index[ev->index];
 
 	if (ev->res != io_u->xfer_buflen) {
 		if (ev->res > io_u->xfer_buflen)
@@ -265,7 +197,7 @@ static struct io_u *fio_aioring_event(struct thread_data *td, int event)
 		io_u->error = 0;
 
 	if (io_u->ddir == DDIR_READ) {
-		if (ev->res2 & IOEV_RES2_CACHEHIT)
+		if (ev->flags & IOEV_FLAG_CACHEHIT)
 			ld->cachehit++;
 		else
 			ld->cachemiss++;
@@ -274,11 +206,11 @@ static struct io_u *fio_aioring_event(struct thread_data *td, int event)
 	return io_u;
 }
 
-static int fio_aioring_cqring_reap(struct thread_data *td, unsigned int events,
+static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct aio_cq_ring *ring = &ld->cq_ring;
+	struct ioring_data *ld = td->io_ops_data;
+	struct io_cq_ring *ring = &ld->cq_ring;
 	u32 head, reaped = 0;
 
 	head = *ring->head;
@@ -295,19 +227,19 @@ static int fio_aioring_cqring_reap(struct thread_data *td, unsigned int events,
 	return reaped;
 }
 
-static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
-				 unsigned int max, const struct timespec *t)
+static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
+				unsigned int max, const struct timespec *t)
 {
-	struct aioring_data *ld = td->io_ops_data;
+	struct ioring_data *ld = td->io_ops_data;
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
-	struct aioring_options *o = td->eo;
-	struct aio_cq_ring *ring = &ld->cq_ring;
+	struct ioring_options *o = td->eo;
+	struct io_cq_ring *ring = &ld->cq_ring;
 	unsigned events = 0;
 	int r;
 
 	ld->cq_ring_off = *ring->head;
 	do {
-		r = fio_aioring_cqring_reap(td, events, max);
+		r = fio_ioring_cqring_reap(td, events, max);
 		if (r) {
 			events += r;
 			continue;
@@ -328,11 +260,11 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 	return r < 0 ? r : events;
 }
 
-static enum fio_q_status fio_aioring_queue(struct thread_data *td,
-					   struct io_u *io_u)
+static enum fio_q_status fio_ioring_queue(struct thread_data *td,
+					  struct io_u *io_u)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct aio_sq_ring *ring = &ld->sq_ring;
+	struct ioring_data *ld = td->io_ops_data;
+	struct io_sq_ring *ring = &ld->sq_ring;
 	unsigned tail, next_tail;
 
 	fio_ro_check(td, io_u);
@@ -364,9 +296,9 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 	return FIO_Q_QUEUED;
 }
 
-static void fio_aioring_queued(struct thread_data *td, int start, int nr)
+static void fio_ioring_queued(struct thread_data *td, int start, int nr)
 {
-	struct aioring_data *ld = td->io_ops_data;
+	struct ioring_data *ld = td->io_ops_data;
 	struct timespec now;
 
 	if (!fio_fill_issue_time(td))
@@ -375,7 +307,7 @@ static void fio_aioring_queued(struct thread_data *td, int start, int nr)
 	fio_gettime(&now, NULL);
 
 	while (nr--) {
-		struct aio_sq_ring *ring = &ld->sq_ring;
+		struct io_sq_ring *ring = &ld->sq_ring;
 		int index = ring->array[start & ld->sq_ring_mask];
 		struct io_u *io_u = ld->io_u_index[index];
 
@@ -386,10 +318,10 @@ static void fio_aioring_queued(struct thread_data *td, int start, int nr)
 	}
 }
 
-static int fio_aioring_commit(struct thread_data *td)
+static int fio_ioring_commit(struct thread_data *td)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct aioring_options *o = td->eo;
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	int ret;
 
 	if (!ld->queued)
@@ -397,7 +329,7 @@ static int fio_aioring_commit(struct thread_data *td)
 
 	/* Nothing to do */
 	if (o->sqthread_poll) {
-		struct aio_sq_ring *ring = &ld->sq_ring;
+		struct io_sq_ring *ring = &ld->sq_ring;
 
 		if (*ring->flags & IORING_SQ_NEED_WAKEUP)
 			io_uring_enter(ld, ld->queued, 0, 0);
@@ -411,7 +343,7 @@ static int fio_aioring_commit(struct thread_data *td)
 
 		ret = io_uring_enter(ld, nr, 0, IORING_ENTER_GETEVENTS);
 		if (ret > 0) {
-			fio_aioring_queued(td, start, ret);
+			fio_ioring_queued(td, start, ret);
 			io_u_mark_submit(td, ret);
 
 			ld->queued -= ret;
@@ -421,7 +353,7 @@ static int fio_aioring_commit(struct thread_data *td)
 			continue;
 		} else {
 			if (errno == EAGAIN) {
-				ret = fio_aioring_cqring_reap(td, 0, ld->queued);
+				ret = fio_ioring_cqring_reap(td, 0, ld->queued);
 				if (ret)
 					continue;
 				/* Shouldn't happen */
@@ -436,7 +368,7 @@ static int fio_aioring_commit(struct thread_data *td)
 	return ret;
 }
 
-static void fio_aioring_unmap(struct aioring_data *ld)
+static void fio_ioring_unmap(struct ioring_data *ld)
 {
 	int i;
 
@@ -445,22 +377,16 @@ static void fio_aioring_unmap(struct aioring_data *ld)
 	close(ld->ring_fd);
 }
 
-static void fio_aioring_cleanup(struct thread_data *td)
+static void fio_ioring_cleanup(struct thread_data *td)
 {
-	struct aioring_data *ld = td->io_ops_data;
+	struct ioring_data *ld = td->io_ops_data;
 
 	if (ld) {
 		td->ts.cachehit += ld->cachehit;
 		td->ts.cachemiss += ld->cachemiss;
 
-		/*
-		 * Work-around to avoid huge RCU stalls at exit time. If we
-		 * don't do this here, then it'll be torn down by exit_aio().
-		 * But for that case we can parallellize the freeing, thus
-		 * speeding it up a lot.
-		 */
 		if (!(td->flags & TD_F_CHILD))
-			fio_aioring_unmap(ld);
+			fio_ioring_unmap(ld);
 
 		free(ld->io_u_index);
 		free(ld->io_us);
@@ -469,10 +395,10 @@ static void fio_aioring_cleanup(struct thread_data *td)
 	}
 }
 
-static int fio_aioring_mmap(struct aioring_data *ld, struct aio_uring_params *p)
+static int fio_ioring_mmap(struct ioring_data *ld, struct io_uring_params *p)
 {
-	struct aio_sq_ring *sring = &ld->sq_ring;
-	struct aio_cq_ring *cring = &ld->cq_ring;
+	struct io_sq_ring *sring = &ld->sq_ring;
+	struct io_cq_ring *cring = &ld->cq_ring;
 	void *ptr;
 
 	ld->mmap[0].len = p->sq_off.array + p->sq_entries * sizeof(u32);
@@ -488,14 +414,14 @@ static int fio_aioring_mmap(struct aioring_data *ld, struct aio_uring_params *p)
 	sring->array = ptr + p->sq_off.array;
 	ld->sq_ring_mask = *sring->ring_mask;
 
-	ld->mmap[1].len = p->sq_entries * sizeof(struct iocb);
+	ld->mmap[1].len = p->sq_entries * sizeof(struct io_uring_iocb);
 	ld->iocbs = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
 				MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 				IORING_OFF_IOCB);
 	ld->mmap[1].ptr = ld->iocbs;
 
 	ld->mmap[2].len = p->cq_off.events +
-				p->cq_entries * sizeof(struct io_event);
+				p->cq_entries * sizeof(struct io_uring_event);
 	ptr = mmap(0, ld->mmap[2].len, PROT_READ | PROT_WRITE,
 			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
 			IORING_OFF_CQ_RING);
@@ -509,27 +435,26 @@ static int fio_aioring_mmap(struct aioring_data *ld, struct aio_uring_params *p)
 	return 0;
 }
 
-static int fio_aioring_queue_init(struct thread_data *td)
+static int fio_ioring_queue_init(struct thread_data *td)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct aioring_options *o = td->eo;
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	int depth = td->o.iodepth;
-	struct aio_uring_params p;
+	struct io_uring_params p;
 	int ret;
 
 	memset(&p, 0, sizeof(p));
-	p.flags = IOCTX_FLAG_SCQRING;
 
 	if (o->hipri)
-		p.flags |= IOCTX_FLAG_IOPOLL;
+		p.flags |= IORING_SETUP_IOPOLL;
 	if (o->sqthread_set) {
 		p.sq_thread_cpu = o->sqthread;
-		p.flags |= IOCTX_FLAG_SQTHREAD;
+		p.flags |= IORING_SETUP_SQTHREAD;
 		if (o->sqthread_poll)
-			p.flags |= IOCTX_FLAG_SQPOLL;
+			p.flags |= IORING_SETUP_SQPOLL;
 	}
 	if (o->sqwq)
-		p.flags |= IOCTX_FLAG_SQWQ;
+		p.flags |= IORING_SETUP_SQWQ;
 
 	if (o->fixedbufs) {
 		struct rlimit rlim = {
@@ -538,7 +463,7 @@ static int fio_aioring_queue_init(struct thread_data *td)
 		};
 
 		setrlimit(RLIMIT_MEMLOCK, &rlim);
-		p.flags |= IOCTX_FLAG_FIXEDBUFS;
+		p.flags |= IORING_SETUP_FIXEDBUFS;
 	}
 
 	ret = syscall(__NR_sys_io_uring_setup, depth, ld->iovecs, &p);
@@ -546,13 +471,13 @@ static int fio_aioring_queue_init(struct thread_data *td)
 		return ret;
 
 	ld->ring_fd = ret;
-	return fio_aioring_mmap(ld, &p);
+	return fio_ioring_mmap(ld, &p);
 }
 
-static int fio_aioring_post_init(struct thread_data *td)
+static int fio_ioring_post_init(struct thread_data *td)
 {
-	struct aioring_data *ld = td->io_ops_data;
-	struct aioring_options *o = td->eo;
+	struct ioring_data *ld = td->io_ops_data;
+	struct ioring_options *o = td->eo;
 	struct io_u *io_u;
 	int err;
 
@@ -568,7 +493,7 @@ static int fio_aioring_post_init(struct thread_data *td)
 		}
 	}
 
-	err = fio_aioring_queue_init(td);
+	err = fio_ioring_queue_init(td);
 	if (err) {
 		td_verror(td, errno, "io_queue_init");
 		return 1;
@@ -582,9 +507,9 @@ static unsigned roundup_pow2(unsigned depth)
 	return 1UL << __fls(depth - 1);
 }
 
-static int fio_aioring_init(struct thread_data *td)
+static int fio_ioring_init(struct thread_data *td)
 {
-	struct aioring_data *ld;
+	struct ioring_data *ld;
 
 	ld = calloc(1, sizeof(*ld));
 
@@ -602,39 +527,39 @@ static int fio_aioring_init(struct thread_data *td)
 	return 0;
 }
 
-static int fio_aioring_io_u_init(struct thread_data *td, struct io_u *io_u)
+static int fio_ioring_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
-	struct aioring_data *ld = td->io_ops_data;
+	struct ioring_data *ld = td->io_ops_data;
 
 	ld->io_u_index[io_u->index] = io_u;
 	return 0;
 }
 
 static struct ioengine_ops ioengine = {
-	.name			= "aio-ring",
+	.name			= "io_uring",
 	.version		= FIO_IOOPS_VERSION,
-	.init			= fio_aioring_init,
-	.post_init		= fio_aioring_post_init,
-	.io_u_init		= fio_aioring_io_u_init,
-	.prep			= fio_aioring_prep,
-	.queue			= fio_aioring_queue,
-	.commit			= fio_aioring_commit,
-	.getevents		= fio_aioring_getevents,
-	.event			= fio_aioring_event,
-	.cleanup		= fio_aioring_cleanup,
+	.init			= fio_ioring_init,
+	.post_init		= fio_ioring_post_init,
+	.io_u_init		= fio_ioring_io_u_init,
+	.prep			= fio_ioring_prep,
+	.queue			= fio_ioring_queue,
+	.commit			= fio_ioring_commit,
+	.getevents		= fio_ioring_getevents,
+	.event			= fio_ioring_event,
+	.cleanup		= fio_ioring_cleanup,
 	.open_file		= generic_open_file,
 	.close_file		= generic_close_file,
 	.get_file_size		= generic_get_file_size,
 	.options		= options,
-	.option_struct_size	= sizeof(struct aioring_options),
+	.option_struct_size	= sizeof(struct ioring_options),
 };
 
-static void fio_init fio_aioring_register(void)
+static void fio_init fio_ioring_register(void)
 {
 	register_ioengine(&ioengine);
 }
 
-static void fio_exit fio_aioring_unregister(void)
+static void fio_exit fio_ioring_unregister(void)
 {
 	unregister_ioengine(&ioengine);
 }
diff --git a/options.c b/options.c
index 626c7c17..6d832354 100644
--- a/options.c
+++ b/options.c
@@ -1773,13 +1773,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Linux native asynchronous IO",
 			  },
 #endif
-#ifdef CONFIG_LIBAIO
-#ifdef ARCH_HAVE_AIORING
-			  { .ival = "aio-ring",
-			    .help = "Linux native asynchronous IO",
+#ifdef ARCH_HAVE_IOURING
+			  { .ival = "io_uring",
+			    .help = "Fast Linux native aio",
 			  },
 #endif
-#endif
 #ifdef CONFIG_POSIXAIO
 			  { .ival = "posixaio",
 			    .help = "POSIX asynchronous IO",
diff --git a/os/io_uring.h b/os/io_uring.h
new file mode 100644
index 00000000..8dda7951
--- /dev/null
+++ b/os/io_uring.h
@@ -0,0 +1,101 @@
+#ifndef IO_URING_H
+#define IO_URING_H
+
+#include <linux/fs.h>
+
+/*
+ * IO submission data structure
+ */
+struct io_uring_iocb {
+	u8	opcode;
+	u8	flags;
+	u16	ioprio;
+	s32	fd;
+	u64	off;
+	union {
+		void	*addr;
+		u64	__pad;
+	};
+	u32	len;
+	union {
+		__kernel_rwf_t	rw_flags;
+		u32		__resv;
+	};
+};
+
+/*
+ * io_uring_setup() flags
+ */
+#define IORING_SETUP_IOPOLL	(1 << 0)	/* io_context is polled */
+#define IORING_SETUP_FIXEDBUFS	(1 << 1)	/* IO buffers are fixed */
+#define IORING_SETUP_SQTHREAD	(1 << 2)	/* Use SQ thread */
+#define IORING_SETUP_SQWQ	(1 << 3)	/* Use SQ workqueue */
+#define IORING_SETUP_SQPOLL	(1 << 4)	/* SQ thread polls */
+
+#define IORING_OP_READ		1
+#define IORING_OP_WRITE		2
+#define IORING_OP_FSYNC		3
+#define IORING_OP_FDSYNC	4
+#define IORING_OP_READ_FIXED	5
+#define IORING_OP_WRITE_FIXED	6
+
+/*
+ * IO completion data structure
+ */
+struct io_uring_event {
+	__u64	index;		/* what iocb this event came from */
+	s32	res;		/* result code for this event */
+	u32	flags;
+};
+
+#define IOEV_FLAG_CACHEHIT	(1 << 0)	/* IO did not hit media */
+
+/*
+ * Magic offsets for the application to mmap the data it needs
+ */
+#define IORING_OFF_SQ_RING		0ULL
+#define IORING_OFF_CQ_RING		0x8000000ULL
+#define IORING_OFF_IOCB			0x10000000ULL
+
+/*
+ * Filled with the offset for mmap(2)
+ */
+struct io_sqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 flags;
+	u32 dropped;
+	u32 array;
+	u32 resv[3];
+};
+
+#define IORING_SQ_NEED_WAKEUP	(1 << 0) /* needs io_uring_enter wakeup */
+
+struct io_cqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 overflow;
+	u32 events;
+	u32 resv[4];
+};
+
+#define IORING_ENTER_GETEVENTS	(1 << 0)
+
+/*
+ * Passed in for io_uring_setup(2). Copied back with updated info on success
+ */
+struct io_uring_params {
+	u32 sq_entries;
+	u32 cq_entries;
+	u32 flags;
+	u16 sq_thread_cpu;
+	u16 resv[9];
+	struct io_sqring_offsets sq_off;
+	struct io_cqring_offsets cq_off;
+};
+
+#endif
diff --git a/t/aio-ring.c b/t/io_uring.c
similarity index 81%
rename from t/aio-ring.c
rename to t/io_uring.c
index 1a4fe44b..83d723f9 100644
--- a/t/aio-ring.c
+++ b/t/io_uring.c
@@ -1,6 +1,3 @@
-/*
- * gcc -D_GNU_SOURCE -Wall -O2 -o aio-ring aio-ring.c  -lpthread -laio
- */
 #include <stdio.h>
 #include <errno.h>
 #include <assert.h>
@@ -15,69 +12,29 @@
 #include <sys/syscall.h>
 #include <sys/resource.h>
 #include <sys/mman.h>
+#include <sys/uio.h>
 #include <linux/fs.h>
 #include <fcntl.h>
 #include <unistd.h>
-#include <libaio.h>
 #include <string.h>
 #include <pthread.h>
 #include <sched.h>
 
 #include "../arch/arch.h"
 
-#define IOCTX_FLAG_SCQRING	(1 << 0)	/* Use SQ/CQ rings */
-#define IOCTX_FLAG_IOPOLL	(1 << 1)
-#define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
-#define IOCTX_FLAG_SQTHREAD	(1 << 3)	/* Use SQ thread */
-#define IOCTX_FLAG_SQWQ		(1 << 4)	/* Use SQ wq */
-#define IOCTX_FLAG_SQPOLL	(1 << 5)
-
-#define IOEV_RES2_CACHEHIT	(1 << 0)
-
-#define barrier()	__asm__ __volatile__("": : :"memory")
-
-#define min(a, b)		((a < b) ? (a) : (b))
-
 typedef uint64_t u64;
 typedef uint32_t u32;
+typedef int32_t s32;
 typedef uint16_t u16;
+typedef uint8_t u8;
 
-#define IORING_OFF_SQ_RING	0ULL
-#define IORING_OFF_CQ_RING	0x8000000ULL
-#define IORING_OFF_IOCB		0x10000000ULL
-
-struct aio_sqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 flags;
-	u32 dropped;
-	u32 array;
-	u32 resv[3];
-};
+#include "../os/io_uring.h"
 
-struct aio_cqring_offsets {
-	u32 head;
-	u32 tail;
-	u32 ring_mask;
-	u32 ring_entries;
-	u32 overflow;
-	u32 events;
-	u32 resv[4];
-};
+#define barrier()	__asm__ __volatile__("": : :"memory")
 
-struct aio_uring_params {
-	u32 sq_entries;
-	u32 cq_entries;
-	u32 flags;
-	u16 sq_thread_cpu;
-	u16 resv[9];
-	struct aio_sqring_offsets sq_off;
-	struct aio_cqring_offsets cq_off;
-};
+#define min(a, b)		((a < b) ? (a) : (b))
 
-struct aio_sq_ring {
+struct io_sq_ring {
 	u32 *head;
 	u32 *tail;
 	u32 *ring_mask;
@@ -85,16 +42,14 @@ struct aio_sq_ring {
 	u32 *array;
 };
 
-struct aio_cq_ring {
+struct io_cq_ring {
 	u32 *head;
 	u32 *tail;
 	u32 *ring_mask;
 	u32 *ring_entries;
-	struct io_event *events;
+	struct io_uring_event *events;
 };
 
-#define IORING_ENTER_GETEVENTS	(1 << 0)
-
 #define DEPTH			32
 
 #define BATCH_SUBMIT		8
@@ -109,10 +64,10 @@ struct submitter {
 	unsigned long max_blocks;
 	int ring_fd;
 	struct drand48_data rand;
-	struct aio_sq_ring sq_ring;
-	struct iocb *iocbs;
+	struct io_sq_ring sq_ring;
+	struct io_uring_iocb *iocbs;
 	struct iovec iovecs[DEPTH];
-	struct aio_cq_ring cq_ring;
+	struct io_cq_ring cq_ring;
 	int inflight;
 	unsigned long reaps;
 	unsigned long done;
@@ -132,7 +87,7 @@ static int sq_thread = 0;	/* use kernel submission thread */
 static int sq_thread_cpu = 0;	/* pin above thread to this CPU */
 
 static int io_uring_setup(unsigned entries, struct iovec *iovecs,
-			  struct aio_uring_params *p)
+			  struct io_uring_params *p)
 {
 	return syscall(__NR_sys_io_uring_setup, entries, iovecs, p);
 }
@@ -151,23 +106,25 @@ static int gettid(void)
 
 static void init_io(struct submitter *s, int fd, unsigned index)
 {
-	struct iocb *iocb = &s->iocbs[index];
+	struct io_uring_iocb *iocb = &s->iocbs[index];
 	unsigned long offset;
 	long r;
 
 	lrand48_r(&s->rand, &r);
 	offset = (r % (s->max_blocks - 1)) * BS;
 
-	iocb->aio_fildes = fd;
-	iocb->aio_lio_opcode = IO_CMD_PREAD;
-	iocb->u.c.buf = s->iovecs[index].iov_base;
-	iocb->u.c.nbytes = BS;
-	iocb->u.c.offset = offset;
+	iocb->opcode = IORING_OP_READ;
+	iocb->flags = 0;
+	iocb->ioprio = 0;
+	iocb->fd = fd;
+	iocb->off = offset;
+	iocb->addr = s->iovecs[index].iov_base;
+	iocb->len = BS;
 }
 
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 {
-	struct aio_sq_ring *ring = &s->sq_ring;
+	struct io_sq_ring *ring = &s->sq_ring;
 	u32 index, tail, next_tail, prepped = 0;
 
 	next_tail = tail = *ring->tail;
@@ -217,8 +174,8 @@ static int get_file_size(int fd, unsigned long *blocks)
 
 static int reap_events(struct submitter *s)
 {
-	struct aio_cq_ring *ring = &s->cq_ring;
-	struct io_event *ev;
+	struct io_cq_ring *ring = &s->cq_ring;
+	struct io_uring_event *ev;
 	u32 head, reaped = 0;
 
 	head = *ring->head;
@@ -228,15 +185,15 @@ static int reap_events(struct submitter *s)
 			break;
 		ev = &ring->events[head & cq_ring_mask];
 		if (ev->res != BS) {
-			struct iocb *iocb = ev->obj;
+			struct io_uring_iocb *iocb = &s->iocbs[ev->index];
 
-			printf("io: unexpected ret=%ld\n", ev->res);
+			printf("io: unexpected ret=%d\n", ev->res);
 			printf("offset=%lu, size=%lu\n",
-					(unsigned long) iocb->u.c.offset,
-					(unsigned long) iocb->u.c.nbytes);
+					(unsigned long) iocb->off,
+					(unsigned long) iocb->len);
 			return -1;
 		}
-		if (ev->res2 & IOEV_RES2_CACHEHIT)
+		if (ev->flags & IOEV_FLAG_CACHEHIT)
 			s->cachehit++;
 		else
 			s->cachemiss++;
@@ -359,23 +316,22 @@ static void arm_sig_int(void)
 
 static int setup_ring(struct submitter *s)
 {
-	struct aio_sq_ring *sring = &s->sq_ring;
-	struct aio_cq_ring *cring = &s->cq_ring;
-	struct aio_uring_params p;
+	struct io_sq_ring *sring = &s->sq_ring;
+	struct io_cq_ring *cring = &s->cq_ring;
+	struct io_uring_params p;
 	void *ptr;
 	int fd;
 
 	memset(&p, 0, sizeof(p));
 
-	p.flags = IOCTX_FLAG_SCQRING;
 	if (polled)
-		p.flags |= IOCTX_FLAG_IOPOLL;
+		p.flags |= IORING_SETUP_IOPOLL;
 	if (fixedbufs)
-		p.flags |= IOCTX_FLAG_FIXEDBUFS;
+		p.flags |= IORING_SETUP_FIXEDBUFS;
 	if (buffered)
-		p.flags |= IOCTX_FLAG_SQWQ;
+		p.flags |= IORING_SETUP_SQWQ;
 	else if (sq_thread) {
-		p.flags |= IOCTX_FLAG_SQTHREAD;
+		p.flags |= IORING_SETUP_SQTHREAD;
 		p.sq_thread_cpu = sq_thread_cpu;
 	}
 
@@ -400,12 +356,12 @@ static int setup_ring(struct submitter *s)
 	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
-	s->iocbs = mmap(0, p.sq_entries * sizeof(struct iocb),
+	s->iocbs = mmap(0, p.sq_entries * sizeof(struct io_uring_iocb),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_IOCB);
 	printf("iocbs ptr   = 0x%p\n", s->iocbs);
 
-	ptr = mmap(0, p.cq_off.events + p.cq_entries * sizeof(struct io_event),
+	ptr = mmap(0, p.cq_off.events + p.cq_entries * sizeof(struct io_uring_event),
 			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
 			IORING_OFF_CQ_RING);
 	printf("cq_ring ptr = 0x%p\n", ptr);
@@ -501,5 +457,6 @@ int main(int argc, char *argv[])
 	} while (!finish);
 
 	pthread_join(s->thread, &ret);
+	close(s->ring_fd);
 	return 0;
 }

