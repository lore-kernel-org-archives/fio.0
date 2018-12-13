Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729460AbeLMNR7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Dec 2018 08:17:59 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXQsH-0005b8-L7
        for fio@vger.kernel.org; Thu, 13 Dec 2018 13:17:57 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181213130002.168362C0051@kernel.dk>
Date: Thu, 13 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0527b23f9112b59dc63f3b40a7f40d45c48ec60d:

  t/aio-ring: updates/cleanups (2018-12-10 15:14:36 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 702906e9e3e03e9836421d5e5b5eaae3cd99d398:

  engines/libaio: remove features deprecated from old interface (2018-12-12 22:02:16 -0700)

----------------------------------------------------------------
Jens Axboe (10):
      t/aio-ring: update to newer API
      t/aio-ring: update to new io_setup2(2)
      t/aio-ring: set nr_events after clear
      ioengine: remove ancient alias for libaio
      Add aioring engine
      t/aio-ring: update for new API
      aioring: hide it if archs don't define syscalls
      aioring: check for arch support AFTER including the headers
      aioring: remove qd > 1 restriction
      engines/libaio: remove features deprecated from old interface

 Makefile           |   3 +
 arch/arch-x86_64.h |   4 +
 engines/aioring.c  | 547 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/libaio.c   | 150 ++-------------
 ioengines.c        |   2 +-
 options.c          |   7 +
 t/aio-ring.c       |  72 ++++---
 7 files changed, 621 insertions(+), 164 deletions(-)
 create mode 100644 engines/aioring.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 284621d3..f111ae6a 100644
--- a/Makefile
+++ b/Makefile
@@ -68,6 +68,9 @@ endif
 ifdef CONFIG_LIBAIO
   SOURCE += engines/libaio.c
 endif
+ifdef CONFIG_LIBAIO
+  SOURCE += engines/aioring.c
+endif
 ifdef CONFIG_RDMA
   SOURCE += engines/rdma.c
 endif
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index ac670d08..d49bcd7f 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -4,6 +4,9 @@
 #ifndef __NR_sys_io_setup2
 #define __NR_sys_io_setup2	335
 #endif
+#ifndef __NR_sys_io_ring_enter
+#define __NR_sys_io_ring_enter	336
+#endif
 
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
@@ -41,6 +44,7 @@ static inline unsigned long long get_cpu_clock(void)
 #define ARCH_HAVE_FFZ
 #define ARCH_HAVE_SSE4_2
 #define ARCH_HAVE_CPU_CLOCK
+#define ARCH_HAVE_AIORING
 
 #define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
 #define RDSEED_LONG	".byte 0x48,0x0f,0xc7,0xf8"
diff --git a/engines/aioring.c b/engines/aioring.c
new file mode 100644
index 00000000..1598cc12
--- /dev/null
+++ b/engines/aioring.c
@@ -0,0 +1,547 @@
+/*
+ * aioring engine
+ *
+ * IO engine using the new native Linux libaio ring interface
+ *
+ */
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <libaio.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+
+#include "../fio.h"
+#include "../lib/pow2.h"
+#include "../optgroup.h"
+#include "../lib/memalign.h"
+
+#ifdef ARCH_HAVE_AIORING
+
+#ifndef IOCB_FLAG_HIPRI
+#define IOCB_FLAG_HIPRI	(1 << 2)
+#endif
+
+/*
+ * io_setup2(2) flags
+ */
+#ifndef IOCTX_FLAG_IOPOLL
+#define IOCTX_FLAG_IOPOLL	(1 << 0)
+#endif
+#ifndef IOCTX_FLAG_SCQRING
+#define IOCTX_FLAG_SCQRING	(1 << 1)
+#endif
+#ifndef IOCTX_FLAG_FIXEDBUFS
+#define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
+#endif
+#ifndef IOCTX_FLAG_SQTHREAD
+#define IOCTX_FLAG_SQTHREAD	(1 << 3)
+#endif
+#ifndef IOCTX_FLAG_SQWQ
+#define IOCTX_FLAG_SQWQ		(1 << 4)
+#endif
+
+/*
+ * io_ring_enter(2) flags
+ */
+#ifndef IORING_FLAG_SUBMIT
+#define IORING_FLAG_SUBMIT	(1 << 0)
+#endif
+#ifndef IORING_FLAG_GETEVENTS
+#define IORING_FLAG_GETEVENTS	(1 << 1)
+#endif
+
+typedef uint64_t u64;
+typedef uint32_t u32;
+typedef uint16_t u16;
+
+struct aio_sq_ring {
+	union {
+		struct {
+			u32 head;
+			u32 tail;
+			u32 nr_events;
+			u16 sq_thread_cpu;
+			u64 iocbs;
+		};
+		u32 pad[16];
+	};
+	u32 array[0];
+};
+
+struct aio_cq_ring {
+	union {
+		struct {
+			u32 head;
+			u32 tail;
+			u32 nr_events;
+		};
+		struct io_event pad;
+	};
+	struct io_event events[0];
+};
+
+struct aioring_data {
+	io_context_t aio_ctx;
+	struct io_u **io_us;
+	struct io_u **io_u_index;
+
+	struct aio_sq_ring *sq_ring;
+	struct iocb *iocbs;
+
+	struct aio_cq_ring *cq_ring;
+	struct io_event *events;
+
+	int queued;
+	int cq_ring_off;
+};
+
+struct aioring_options {
+	void *pad;
+	unsigned int hipri;
+	unsigned int fixedbufs;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "hipri",
+		.lname	= "High Priority",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct aioring_options, hipri),
+		.help	= "Use polled IO completions",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= "fixedbufs",
+		.lname	= "Fixed (pre-mapped) IO buffers",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct aioring_options, fixedbufs),
+		.help	= "Pre map IO buffers",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+static int fio_aioring_commit(struct thread_data *td);
+
+static int io_ring_enter(io_context_t ctx, unsigned int to_submit,
+			 unsigned int min_complete, unsigned int flags)
+{
+#ifdef __NR_sys_io_ring_enter
+	return syscall(__NR_sys_io_ring_enter, ctx, to_submit, min_complete,
+			flags);
+#else
+	return -1;
+#endif
+}
+
+static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct fio_file *f = io_u->file;
+	struct aioring_options *o = td->eo;
+	struct iocb *iocb;
+
+	iocb = &ld->iocbs[io_u->index];
+
+	if (io_u->ddir == DDIR_READ) {
+		if (o->fixedbufs) {
+			iocb->aio_fildes = f->fd;
+			iocb->aio_lio_opcode = IO_CMD_PREAD;
+			iocb->u.c.offset = io_u->offset;
+		} else {
+			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		}
+	} else if (io_u->ddir == DDIR_WRITE) {
+		if (o->fixedbufs) {
+			iocb->aio_fildes = f->fd;
+			iocb->aio_lio_opcode = IO_CMD_PWRITE;
+			iocb->u.c.offset = io_u->offset;
+		} else {
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		}
+	} else if (ddir_sync(io_u->ddir))
+		io_prep_fsync(iocb, f->fd);
+
+	iocb->data = io_u;
+	return 0;
+}
+
+static struct io_u *fio_aioring_event(struct thread_data *td, int event)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct io_event *ev;
+	struct io_u *io_u;
+	int index;
+
+	index = event + ld->cq_ring_off;
+	if (index >= ld->cq_ring->nr_events)
+		index -= ld->cq_ring->nr_events;
+
+	ev = &ld->cq_ring->events[index];
+	io_u = ev->data;
+
+	if (ev->res != io_u->xfer_buflen) {
+		if (ev->res > io_u->xfer_buflen)
+			io_u->error = -ev->res;
+		else
+			io_u->resid = io_u->xfer_buflen - ev->res;
+	} else
+		io_u->error = 0;
+
+	return io_u;
+}
+
+static int fio_aioring_cqring_reap(struct thread_data *td, unsigned int events,
+				   unsigned int max)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct aio_cq_ring *ring = ld->cq_ring;
+	u32 head, reaped = 0;
+
+	head = ring->head;
+	do {
+		read_barrier();
+		if (head == ring->tail)
+			break;
+		reaped++;
+		head++;
+		if (head == ring->nr_events)
+			head = 0;
+	} while (reaped + events < max);
+
+	ring->head = head;
+	write_barrier();
+	return reaped;
+}
+
+static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
+				 unsigned int max, const struct timespec *t)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
+	struct aio_cq_ring *ring = ld->cq_ring;
+	int r, events = 0;
+
+	ld->cq_ring_off = ring->head;
+	do {
+		r = fio_aioring_cqring_reap(td, events, max);
+		if (r) {
+			events += r;
+			continue;
+		}
+
+		r = io_ring_enter(ld->aio_ctx, 0, actual_min,
+					IORING_FLAG_GETEVENTS);
+		if (r < 0) {
+			if (errno == EAGAIN)
+				continue;
+			perror("ring enter");
+			break;
+		}
+	} while (events < min);
+
+	return r < 0 ? r : events;
+}
+
+static enum fio_q_status fio_aioring_queue(struct thread_data *td,
+					   struct io_u *io_u)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct aio_sq_ring *ring = ld->sq_ring;
+	unsigned tail, next_tail;
+
+	fio_ro_check(td, io_u);
+
+	if (ld->queued == td->o.iodepth)
+		return FIO_Q_BUSY;
+
+	/*
+	 * fsync is tricky, since it can fail and we need to do it
+	 * serialized with other io. the reason is that linux doesn't
+	 * support aio fsync yet. So return busy for the case where we
+	 * have pending io, to let fio complete those first.
+	 */
+	if (ddir_sync(io_u->ddir)) {
+		if (ld->queued)
+			return FIO_Q_BUSY;
+
+		do_io_u_sync(td, io_u);
+		return FIO_Q_COMPLETED;
+	}
+
+	if (io_u->ddir == DDIR_TRIM) {
+		if (ld->queued)
+			return FIO_Q_BUSY;
+
+		do_io_u_trim(td, io_u);
+		io_u_mark_submit(td, 1);
+		io_u_mark_complete(td, 1);
+		return FIO_Q_COMPLETED;
+	}
+
+	tail = ring->tail;
+	next_tail = tail + 1;
+	if (next_tail == ring->nr_events)
+		next_tail = 0;
+	read_barrier();
+	if (next_tail == ring->head)
+		return FIO_Q_BUSY;
+
+	ring->array[tail] = io_u->index;
+	ring->tail = next_tail;
+	write_barrier();
+
+	ld->queued++;
+	return FIO_Q_QUEUED;
+}
+
+static void fio_aioring_queued(struct thread_data *td, int start, int nr)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct timespec now;
+
+	if (!fio_fill_issue_time(td))
+		return;
+
+	fio_gettime(&now, NULL);
+
+	while (nr--) {
+		int index = ld->sq_ring->array[start];
+		struct io_u *io_u = io_u = ld->io_u_index[index];
+
+		memcpy(&io_u->issue_time, &now, sizeof(now));
+		io_u_queued(td, io_u);
+
+		start++;
+		if (start == ld->sq_ring->nr_events)
+			start = 0;
+	}
+}
+
+static int fio_aioring_commit(struct thread_data *td)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	int ret;
+
+	if (!ld->queued)
+		return 0;
+
+	do {
+		int start = ld->sq_ring->head;
+		long nr = ld->queued;
+
+		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_SUBMIT |
+						IORING_FLAG_GETEVENTS);
+		if (ret == -1)
+			perror("io_ring_enter");
+		if (ret > 0) {
+			fio_aioring_queued(td, start, ret);
+			io_u_mark_submit(td, ret);
+
+			ld->queued -= ret;
+			ret = 0;
+		} else if (ret == -EINTR || !ret) {
+			if (!ret)
+				io_u_mark_submit(td, ret);
+			continue;
+		} else if (ret == -EAGAIN) {
+			/*
+			 * If we get EAGAIN, we should break out without
+			 * error and let the upper layer reap some
+			 * events for us. If we have no queued IO, we
+			 * must loop here. If we loop for more than 30s,
+			 * just error out, something must be buggy in the
+			 * IO path.
+			 */
+			if (ld->queued) {
+				ret = 0;
+				break;
+			}
+			usleep(1);
+			continue;
+		} else if (ret == -ENOMEM) {
+			/*
+			 * If we get -ENOMEM, reap events if we can. If
+			 * we cannot, treat it as a fatal event since there's
+			 * nothing we can do about it.
+			 */
+			if (ld->queued)
+				ret = 0;
+			break;
+		} else
+			break;
+	} while (ld->queued);
+
+	return ret;
+}
+
+static size_t aioring_cq_size(struct thread_data *td)
+{
+	return sizeof(struct aio_cq_ring) + 2 * td->o.iodepth * sizeof(struct io_event);
+}
+
+static size_t aioring_sq_iocb(struct thread_data *td)
+{
+	return sizeof(struct iocb) * td->o.iodepth;
+}
+
+static size_t aioring_sq_size(struct thread_data *td)
+{
+	return sizeof(struct aio_sq_ring) + td->o.iodepth * sizeof(u32);
+}
+
+static void fio_aioring_cleanup(struct thread_data *td)
+{
+	struct aioring_data *ld = td->io_ops_data;
+
+	if (ld) {
+		/*
+		 * Work-around to avoid huge RCU stalls at exit time. If we
+		 * don't do this here, then it'll be torn down by exit_aio().
+		 * But for that case we can parallellize the freeing, thus
+		 * speeding it up a lot.
+		 */
+		if (!(td->flags & TD_F_CHILD))
+			io_destroy(ld->aio_ctx);
+		free(ld->io_u_index);
+		free(ld->io_us);
+		fio_memfree(ld->sq_ring, aioring_sq_size(td), false);
+		fio_memfree(ld->iocbs, aioring_sq_iocb(td), false);
+		fio_memfree(ld->cq_ring, aioring_cq_size(td), false);
+		free(ld);
+	}
+}
+
+static int fio_aioring_queue_init(struct thread_data *td)
+{
+#ifdef __NR_sys_io_setup2
+	struct aioring_data *ld = td->io_ops_data;
+	struct aioring_options *o = td->eo;
+	int flags = IOCTX_FLAG_SCQRING;
+	int depth = td->o.iodepth;
+
+	if (o->hipri)
+		flags |= IOCTX_FLAG_IOPOLL;
+	if (o->fixedbufs) {
+		struct rlimit rlim = {
+			.rlim_cur = RLIM_INFINITY,
+			.rlim_max = RLIM_INFINITY,
+		};
+
+		setrlimit(RLIMIT_MEMLOCK, &rlim);
+		flags |= IOCTX_FLAG_FIXEDBUFS;
+	}
+
+	return syscall(__NR_sys_io_setup2, depth, flags,
+			ld->sq_ring, ld->cq_ring, &ld->aio_ctx);
+#else
+	return -1;
+#endif
+}
+
+static int fio_aioring_post_init(struct thread_data *td)
+{
+	struct aioring_data *ld = td->io_ops_data;
+	struct aioring_options *o = td->eo;
+	struct io_u *io_u;
+	struct iocb *iocb;
+	int err = 0;
+
+	if (o->fixedbufs) {
+		int i;
+
+		for (i = 0; i < td->o.iodepth; i++) {
+			io_u = ld->io_u_index[i];
+			iocb = &ld->iocbs[i];
+			iocb->u.c.buf = io_u->buf;
+			iocb->u.c.nbytes = td_max_bs(td);
+
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		}
+	}
+
+	err = fio_aioring_queue_init(td);
+	if (err) {
+		td_verror(td, -err, "io_queue_init");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int fio_aioring_init(struct thread_data *td)
+{
+	struct aioring_data *ld;
+
+	/* ring needs an extra entry, add one to achieve QD set */
+	td->o.iodepth++;
+
+	ld = calloc(1, sizeof(*ld));
+
+	/* io_u index */
+	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
+	ld->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
+
+	ld->iocbs = fio_memalign(page_size, aioring_sq_iocb(td), false);
+	memset(ld->iocbs, 0, aioring_sq_iocb(td));
+
+	ld->sq_ring = fio_memalign(page_size, aioring_sq_size(td), false);
+	memset(ld->sq_ring, 0, aioring_sq_size(td));
+	ld->sq_ring->nr_events = td->o.iodepth;
+	ld->sq_ring->iocbs = (u64) (uintptr_t) ld->iocbs;
+
+	ld->cq_ring = fio_memalign(page_size, aioring_cq_size(td), false);
+	memset(ld->cq_ring, 0, aioring_cq_size(td));
+	ld->cq_ring->nr_events = td->o.iodepth * 2;
+
+	td->io_ops_data = ld;
+	return 0;
+}
+
+static int fio_aioring_io_u_init(struct thread_data *td, struct io_u *io_u)
+{
+	struct aioring_data *ld = td->io_ops_data;
+
+	ld->io_u_index[io_u->index] = io_u;
+	return 0;
+}
+
+static struct ioengine_ops ioengine = {
+	.name			= "aio-ring",
+	.version		= FIO_IOOPS_VERSION,
+	.init			= fio_aioring_init,
+	.post_init		= fio_aioring_post_init,
+	.io_u_init		= fio_aioring_io_u_init,
+	.prep			= fio_aioring_prep,
+	.queue			= fio_aioring_queue,
+	.commit			= fio_aioring_commit,
+	.getevents		= fio_aioring_getevents,
+	.event			= fio_aioring_event,
+	.cleanup		= fio_aioring_cleanup,
+	.open_file		= generic_open_file,
+	.close_file		= generic_close_file,
+	.get_file_size		= generic_get_file_size,
+	.options		= options,
+	.option_struct_size	= sizeof(struct aioring_options),
+};
+
+static void fio_init fio_aioring_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+static void fio_exit fio_aioring_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
+#endif
diff --git a/engines/libaio.c b/engines/libaio.c
index 03335094..8844ac8b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -20,14 +20,8 @@
 #define IOCB_FLAG_HIPRI	(1 << 2)
 #endif
 
-#ifndef IOCTX_FLAG_USERIOCB
-#define IOCTX_FLAG_USERIOCB	(1 << 0)
-#endif
 #ifndef IOCTX_FLAG_IOPOLL
-#define IOCTX_FLAG_IOPOLL	(1 << 1)
-#endif
-#ifndef IOCTX_FLAG_FIXEDBUFS
-#define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
+#define IOCTX_FLAG_IOPOLL	(1 << 0)
 #endif
 
 static int fio_libaio_commit(struct thread_data *td);
@@ -38,7 +32,6 @@ struct libaio_data {
 	struct iocb **iocbs;
 	struct io_u **io_us;
 
-	struct iocb *user_iocbs;
 	struct io_u **io_u_index;
 
 	/*
@@ -60,8 +53,6 @@ struct libaio_options {
 	void *pad;
 	unsigned int userspace_reap;
 	unsigned int hipri;
-	unsigned int useriocb;
-	unsigned int fixedbufs;
 };
 
 static struct fio_option options[] = {
@@ -83,24 +74,6 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
-	{
-		.name	= "useriocb",
-		.lname	= "User IOCBs",
-		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct libaio_options, useriocb),
-		.help	= "Use user mapped IOCBs",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
-	{
-		.name	= "fixedbufs",
-		.lname	= "Fixed (pre-mapped) IO buffers",
-		.type	= FIO_OPT_STR_SET,
-		.off1	= offsetof(struct libaio_options, fixedbufs),
-		.help	= "Pre map IO buffers",
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_LIBAIO,
-	},
 	{
 		.name	= NULL,
 	},
@@ -117,36 +90,20 @@ static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
 
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 {
-	struct libaio_data *ld = td->io_ops_data;
 	struct fio_file *f = io_u->file;
 	struct libaio_options *o = td->eo;
 	struct iocb *iocb;
 
-	if (o->useriocb)
-		iocb = &ld->user_iocbs[io_u->index];
-	else
-		iocb = &io_u->iocb;
+	iocb = &io_u->iocb;
 
 	if (io_u->ddir == DDIR_READ) {
-		if (o->fixedbufs) {
-			iocb->aio_fildes = f->fd;
-			iocb->aio_lio_opcode = IO_CMD_PREAD;
-			iocb->u.c.offset = io_u->offset;
-		} else {
-			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		}
+		io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->hipri)
+			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		if (o->fixedbufs) {
-			iocb->aio_fildes = f->fd;
-			iocb->aio_lio_opcode = IO_CMD_PWRITE;
-			iocb->u.c.offset = io_u->offset;
-		} else {
-			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		}
+		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (o->hipri)
+			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -156,16 +113,11 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 static struct io_u *fio_libaio_event(struct thread_data *td, int event)
 {
 	struct libaio_data *ld = td->io_ops_data;
-	struct libaio_options *o = td->eo;
 	struct io_event *ev;
 	struct io_u *io_u;
 
 	ev = ld->aio_events + event;
-	if (o->useriocb) {
-		int index = (int) (uintptr_t) ev->obj;
-		io_u = ld->io_u_index[index];
-	} else
-		io_u = container_of(ev->obj, struct io_u, iocb);
+	io_u = container_of(ev->obj, struct io_u, iocb);
 
 	if (ev->res != io_u->xfer_buflen) {
 		if (ev->res > io_u->xfer_buflen)
@@ -261,7 +213,6 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 					  struct io_u *io_u)
 {
 	struct libaio_data *ld = td->io_ops_data;
-	struct libaio_options *o = td->eo;
 
 	fio_ro_check(td, io_u);
 
@@ -292,11 +243,7 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	if (o->useriocb)
-		ld->iocbs[ld->head] = (struct iocb *) (uintptr_t) io_u->index;
-	else
-		ld->iocbs[ld->head] = &io_u->iocb;
-
+	ld->iocbs[ld->head] = &io_u->iocb;
 	ld->io_us[ld->head] = io_u;
 	ring_inc(ld, &ld->head, 1);
 	ld->queued++;
@@ -415,87 +362,46 @@ static void fio_libaio_cleanup(struct thread_data *td)
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
-		if (ld->user_iocbs) {
-			size_t size = td->o.iodepth * sizeof(struct iocb);
-			fio_memfree(ld->user_iocbs, size, false);
-		}
 		free(ld);
 	}
 }
 
 static int fio_libaio_old_queue_init(struct libaio_data *ld, unsigned int depth,
-				     bool hipri, bool useriocb, bool fixedbufs)
+				     bool hipri)
 {
 	if (hipri) {
 		log_err("fio: polled aio not available on your platform\n");
 		return 1;
 	}
-	if (useriocb) {
-		log_err("fio: user mapped iocbs not available on your platform\n");
-		return 1;
-	}
-	if (fixedbufs) {
-		log_err("fio: fixed buffers not available on your platform\n");
-		return 1;
-	}
 
 	return io_queue_init(depth, &ld->aio_ctx);
 }
 
 static int fio_libaio_queue_init(struct libaio_data *ld, unsigned int depth,
-				 bool hipri, bool useriocb, bool fixedbufs)
+				 bool hipri)
 {
 #ifdef __NR_sys_io_setup2
 	int ret, flags = 0;
 
 	if (hipri)
 		flags |= IOCTX_FLAG_IOPOLL;
-	if (useriocb)
-		flags |= IOCTX_FLAG_USERIOCB;
-	if (fixedbufs) {
-		struct rlimit rlim = {
-			.rlim_cur = RLIM_INFINITY,
-			.rlim_max = RLIM_INFINITY,
-		};
-
-		setrlimit(RLIMIT_MEMLOCK, &rlim);
-		flags |= IOCTX_FLAG_FIXEDBUFS;
-	}
 
-	ret = syscall(__NR_sys_io_setup2, depth, flags, ld->user_iocbs,
-			NULL, NULL, &ld->aio_ctx);
+	ret = syscall(__NR_sys_io_setup2, depth, flags, NULL, NULL,
+			&ld->aio_ctx);
 	if (!ret)
 		return 0;
 	/* fall through to old syscall */
 #endif
-	return fio_libaio_old_queue_init(ld, depth, hipri, useriocb, fixedbufs);
+	return fio_libaio_old_queue_init(ld, depth, hipri);
 }
 
 static int fio_libaio_post_init(struct thread_data *td)
 {
 	struct libaio_data *ld = td->io_ops_data;
 	struct libaio_options *o = td->eo;
-	struct io_u *io_u;
-	struct iocb *iocb;
 	int err = 0;
 
-	if (o->fixedbufs) {
-		int i;
-
-		for (i = 0; i < td->o.iodepth; i++) {
-			io_u = ld->io_u_index[i];
-			iocb = &ld->user_iocbs[i];
-			iocb->u.c.buf = io_u->buf;
-			iocb->u.c.nbytes = td_max_bs(td);
-
-			iocb->u.c.flags = 0;
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		}
-	}
-
-	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri, o->useriocb,
-					o->fixedbufs);
+	err = fio_libaio_queue_init(ld, td->o.iodepth, o->hipri);
 	if (err) {
 		td_verror(td, -err, "io_queue_init");
 		return 1;
@@ -506,20 +412,10 @@ static int fio_libaio_post_init(struct thread_data *td)
 
 static int fio_libaio_init(struct thread_data *td)
 {
-	struct libaio_options *o = td->eo;
 	struct libaio_data *ld;
 
 	ld = calloc(1, sizeof(*ld));
 
-	if (o->useriocb) {
-		size_t size;
-
-		ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
-		size = td->o.iodepth * sizeof(struct iocb);
-		ld->user_iocbs = fio_memalign(page_size, size, false);
-		memset(ld->user_iocbs, 0, size);
-	}
-
 	ld->entries = td->o.iodepth;
 	ld->is_pow2 = is_power_of_2(ld->entries);
 	ld->aio_events = calloc(ld->entries, sizeof(struct io_event));
@@ -530,25 +426,11 @@ static int fio_libaio_init(struct thread_data *td)
 	return 0;
 }
 
-static int fio_libaio_io_u_init(struct thread_data *td, struct io_u *io_u)
-{
-	struct libaio_options *o = td->eo;
-
-	if (o->useriocb) {
-		struct libaio_data *ld = td->io_ops_data;
-
-		ld->io_u_index[io_u->index] = io_u;
-	}
-
-	return 0;
-}
-
 static struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
-	.io_u_init		= fio_libaio_io_u_init,
 	.prep			= fio_libaio_prep,
 	.queue			= fio_libaio_queue,
 	.commit			= fio_libaio_commit,
diff --git a/ioengines.c b/ioengines.c
index b7df8608..45e769e6 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -131,7 +131,7 @@ static struct ioengine_ops *__load_ioengine(const char *name)
 	/*
 	 * linux libaio has alias names, so convert to what we want
 	 */
-	if (!strncmp(engine, "linuxaio", 8) || !strncmp(engine, "aio", 3)) {
+	if (!strncmp(engine, "linuxaio", 8)) {
 		dprint(FD_IO, "converting ioengine name: %s -> libaio\n", name);
 		strcpy(engine, "libaio");
 	}
diff --git a/options.c b/options.c
index 7a7006c1..626c7c17 100644
--- a/options.c
+++ b/options.c
@@ -1773,6 +1773,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "Linux native asynchronous IO",
 			  },
 #endif
+#ifdef CONFIG_LIBAIO
+#ifdef ARCH_HAVE_AIORING
+			  { .ival = "aio-ring",
+			    .help = "Linux native asynchronous IO",
+			  },
+#endif
+#endif
 #ifdef CONFIG_POSIXAIO
 			  { .ival = "posixaio",
 			    .help = "POSIX asynchronous IO",
diff --git a/t/aio-ring.c b/t/aio-ring.c
index c6106348..322f2ffa 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -24,38 +24,42 @@
 
 #define IOCB_FLAG_HIPRI		(1 << 2)
 
-#define IOCTX_FLAG_IOPOLL	(1 << 1)
-#define IOCTX_FLAG_USERIOCB	(1 << 0)
+#define IOCTX_FLAG_IOPOLL	(1 << 0)
+#define IOCTX_FLAG_SCQRING	(1 << 1)	/* Use SQ/CQ rings */
 #define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
-#define IOCTX_FLAG_SCQRING	(1 << 3)	/* Use SQ/CQ rings */
-#define IOCTX_FLAG_SQTHREAD	(1 << 4)	/* Use SQ thread */
-#define IOCTX_FLAG_SQWQ		(1 << 5)	/* Use SQ wq */
+#define IOCTX_FLAG_SQTHREAD	(1 << 3)	/* Use SQ thread */
+#define IOCTX_FLAG_SQWQ		(1 << 4)	/* Use SQ wq */
 
 #define barrier()	__asm__ __volatile__("": : :"memory")
 
 #define min(a, b)		((a < b) ? (a) : (b))
 
+typedef uint64_t u64;
 typedef uint32_t u32;
+typedef uint16_t u16;
 
-struct aio_iocb_ring {
+struct aio_sq_ring {
 	union {
 		struct {
-			u32 head, tail;
+			u32 head;
+			u32 tail;
 			u32 nr_events;
-			u32 sq_thread_cpu;
+			u16 sq_thread_cpu;
+			u64 iocbs;
 		};
-		struct iocb pad_iocb;
+		u32 pad[16];
 	};
-	struct iocb iocbs[0];
+	u32 array[0];
 };
 
-struct aio_io_event_ring {
+struct aio_cq_ring {
 	union {
 		struct {
-			u32 head, tail;
+			u32 head;
+			u32 tail;
 			u32 nr_events;
 		};
-		struct io_event pad_event;
+		struct io_event pad;
 	};
 	struct io_event events[0];
 };
@@ -76,8 +80,9 @@ struct submitter {
 	unsigned long max_blocks;
 	io_context_t ioc;
 	struct drand48_data rand;
-	struct aio_iocb_ring *sq_ring;
-	struct aio_io_event_ring *cq_ring;
+	struct aio_sq_ring *sq_ring;
+	struct iocb *iocbs;
+	struct aio_cq_ring *cq_ring;
 	int inflight;
 	unsigned long reaps;
 	unsigned long done;
@@ -96,10 +101,10 @@ static int sq_thread = 0;	/* use kernel submission thread */
 static int sq_thread_cpu = 0;	/* pin above thread to this CPU */
 
 static int io_setup2(unsigned int nr_events, unsigned int flags,
-		     struct iocb *iocbs, struct aio_iocb_ring *sq_ring,
-		     struct aio_io_event_ring *cq_ring, io_context_t *ctx_idp)
+		     struct aio_sq_ring *sq_ring, struct aio_cq_ring *cq_ring,
+		     io_context_t *ctx_idp)
 {
-	return syscall(335, nr_events, flags, iocbs, sq_ring, cq_ring, ctx_idp);
+	return syscall(335, nr_events, flags, sq_ring, cq_ring, ctx_idp);
 }
 
 static int io_ring_enter(io_context_t ctx, unsigned int to_submit,
@@ -132,8 +137,7 @@ static void init_io(struct submitter *s, int fd, struct iocb *iocb)
 
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 {
-	struct aio_iocb_ring *ring = s->sq_ring;
-	struct iocb *iocb;
+	struct aio_sq_ring *ring = s->sq_ring;
 	u32 tail, next_tail, prepped = 0;
 
 	next_tail = tail = ring->tail;
@@ -146,8 +150,8 @@ static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 		if (next_tail == ring->head)
 			break;
 
-		iocb = &s->sq_ring->iocbs[tail];
-		init_io(s, fd, iocb);
+		init_io(s, fd, &s->iocbs[tail]);
+		s->sq_ring->array[tail] = tail;
 		prepped++;
 		tail = next_tail;
 	} while (prepped < max_ios);
@@ -185,7 +189,7 @@ static int get_file_size(int fd, unsigned long *blocks)
 
 static int reap_events(struct submitter *s)
 {
-	struct aio_io_event_ring *ring = s->cq_ring;
+	struct aio_cq_ring *ring = s->cq_ring;
 	struct io_event *ev;
 	u32 head, reaped = 0;
 
@@ -196,8 +200,7 @@ static int reap_events(struct submitter *s)
 			break;
 		ev = &ring->events[head];
 		if (ev->res != BS) {
-			int index = (int) (uintptr_t) ev->obj;
-			struct iocb *iocb = &s->sq_ring->iocbs[index];
+			struct iocb *iocb = ev->obj;
 
 			printf("io: unexpected ret=%ld\n", ev->res);
 			printf("offset=%lu, size=%lu\n", (unsigned long) iocb->u.c.offset, (unsigned long) iocb->u.c.nbytes);
@@ -351,20 +354,31 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	size = sizeof(struct aio_iocb_ring) + RING_SIZE * sizeof(struct iocb);
+	size = sizeof(struct iocb) * RING_SIZE;
+	if (posix_memalign(&p, 4096, size))
+		return 1;
+	memset(p, 0, size);
+	s->iocbs = p;
+
+	size = sizeof(struct aio_sq_ring) + RING_SIZE * sizeof(u32);
 	if (posix_memalign(&p, 4096, size))
 		return 1;
 	s->sq_ring = p;
 	memset(p, 0, size);
+	s->sq_ring->nr_events = RING_SIZE;
+	s->sq_ring->iocbs = (u64) s->iocbs;
 
-	size = sizeof(struct aio_io_event_ring) + RING_SIZE * sizeof(struct io_event);
+	/* CQ ring must be twice as big */
+	size = sizeof(struct aio_cq_ring) +
+			2 * RING_SIZE * sizeof(struct io_event);
 	if (posix_memalign(&p, 4096, size))
 		return 1;
 	s->cq_ring = p;
 	memset(p, 0, size);
+	s->cq_ring->nr_events = 2 * RING_SIZE;
 
 	for (j = 0; j < RING_SIZE; j++) {
-		struct iocb *iocb = &s->sq_ring->iocbs[j];
+		struct iocb *iocb = &s->iocbs[j];
 
 		if (posix_memalign(&iocb->u.c.buf, BS, BS)) {
 			printf("failed alloc\n");
@@ -385,7 +399,7 @@ int main(int argc, char *argv[])
 		s->sq_ring->sq_thread_cpu = sq_thread_cpu;
 	}
 
-	err = io_setup2(RING_SIZE, flags, s->sq_ring->iocbs, s->sq_ring, s->cq_ring, &s->ioc);
+	err = io_setup2(RING_SIZE, flags, s->sq_ring, s->cq_ring, &s->ioc);
 	if (err) {
 		printf("ctx_init failed: %s, %d\n", strerror(errno), err);
 		return 1;

