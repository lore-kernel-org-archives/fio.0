Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53118 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfAENAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Jan 2019 08:00:14 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gflYi-0002lk-SA
        for fio@vger.kernel.org; Sat, 05 Jan 2019 13:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190105130002.179FC2C0118@kernel.dk>
Date: Sat,  5 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ac4f3d4e4cf16b1097249a819fe7111b2674b3f4:

  aioring: remove IOCB_FLAG_HIPRI (2018-12-30 17:19:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ac122fea7540ca115c157e0a835a74b891f10484:

  aioring: update to newer API (2019-01-04 22:22:54 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      t/aio-ring: update to newer mmap() API
      engines/aioring: update for newer mmap based API
      t/aio-ring: use syscall defines
      aioring: update to newer API

 arch/arch-x86_64.h |   8 +-
 engines/aioring.c  | 267 ++++++++++++++++++++++++++++++++---------------------
 t/aio-ring.c       | 262 +++++++++++++++++++++++++++++++---------------------
 3 files changed, 322 insertions(+), 215 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index d49bcd7f..d0a98b8b 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,11 +1,11 @@
 #ifndef ARCH_X86_64_H
 #define ARCH_X86_64_H
 
-#ifndef __NR_sys_io_setup2
-#define __NR_sys_io_setup2	335
+#ifndef __NR_sys_io_uring_setup
+#define __NR_sys_io_uring_setup	335
 #endif
-#ifndef __NR_sys_io_ring_enter
-#define __NR_sys_io_ring_enter	336
+#ifndef __NR_sys_io_uring_enter
+#define __NR_sys_io_uring_enter	336
 #endif
 
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
diff --git a/engines/aioring.c b/engines/aioring.c
index f836009d..ca60b281 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -22,13 +22,13 @@
 #ifdef ARCH_HAVE_AIORING
 
 /*
- * io_setup2(2) flags
+ * io_uring_setup(2) flags
  */
-#ifndef IOCTX_FLAG_IOPOLL
-#define IOCTX_FLAG_IOPOLL	(1 << 0)
-#endif
 #ifndef IOCTX_FLAG_SCQRING
-#define IOCTX_FLAG_SCQRING	(1 << 1)
+#define IOCTX_FLAG_SCQRING	(1 << 0)
+#endif
+#ifndef IOCTX_FLAG_IOPOLL
+#define IOCTX_FLAG_IOPOLL	(1 << 1)
 #endif
 #ifndef IOCTX_FLAG_FIXEDBUFS
 #define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
@@ -43,12 +43,15 @@
 #define IOCTX_FLAG_SQPOLL	(1 << 5)
 #endif
 
+#define IORING_OFF_SQ_RING	0ULL
+#define IORING_OFF_CQ_RING	0x8000000ULL
+#define IORING_OFF_IOCB		0x10000000ULL
 
 /*
- * io_ring_enter(2) flags
+ * io_uring_enter(2) flags
  */
-#ifndef IORING_FLAG_GETEVENTS
-#define IORING_FLAG_GETEVENTS	(1 << 0)
+#ifndef IORING_ENTER_GETEVENTS
+#define IORING_ENTER_GETEVENTS	(1 << 0)
 #endif
 
 typedef uint64_t u64;
@@ -59,43 +62,68 @@ typedef uint16_t u16;
 
 #define IOEV_RES2_CACHEHIT	(1 << 0)
 
+struct aio_sqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 flags;
+	u32 array;
+};
+
+struct aio_cqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 overflow;
+	u32 events;
+};
+
+struct aio_uring_params {
+	u32 sq_entries;
+	u32 cq_entries;
+	u32 flags;
+	u16 sq_thread_cpu;
+	u16 resv[9];
+	struct aio_sqring_offsets sq_off;
+	struct aio_cqring_offsets cq_off;
+};
+
 struct aio_sq_ring {
-	union {
-		struct {
-			u32 head;
-			u32 tail;
-			u32 nr_events;
-			u16 sq_thread_cpu;
-			u16 kflags;
-			u64 iocbs;
-		};
-		u32 pad[16];
-	};
-	u32 array[0];
+	u32 *head;
+	u32 *tail;
+	u32 *ring_mask;
+	u32 *ring_entries;
+	u32 *flags;
+	u32 *array;
 };
 
 struct aio_cq_ring {
-	union {
-		struct {
-			u32 head;
-			u32 tail;
-			u32 nr_events;
-		};
-		struct io_event pad;
-	};
-	struct io_event events[0];
+	u32 *head;
+	u32 *tail;
+	u32 *ring_mask;
+	u32 *ring_entries;
+	struct io_event *events;
+};
+
+struct aioring_mmap {
+	void *ptr;
+	size_t len;
 };
 
 struct aioring_data {
-	io_context_t aio_ctx;
+	int ring_fd;
+
 	struct io_u **io_us;
 	struct io_u **io_u_index;
 
-	struct aio_sq_ring *sq_ring;
+	struct aio_sq_ring sq_ring;
 	struct iocb *iocbs;
+	struct iovec *iovecs;
 	unsigned sq_ring_mask;
 
-	struct aio_cq_ring *cq_ring;
+	struct aio_cq_ring cq_ring;
 	struct io_event *events;
 	unsigned cq_ring_mask;
 
@@ -105,6 +133,8 @@ struct aioring_data {
 
 	uint64_t cachehit;
 	uint64_t cachemiss;
+
+	struct aioring_mmap mmap[3];
 };
 
 struct aioring_options {
@@ -178,11 +208,11 @@ static struct fio_option options[] = {
 	},
 };
 
-static int io_ring_enter(io_context_t ctx, unsigned int to_submit,
+static int io_uring_enter(struct aioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
-	return syscall(__NR_sys_io_ring_enter, ctx, to_submit, min_complete,
-			flags);
+	return syscall(__NR_sys_io_uring_enter, ld->ring_fd, to_submit,
+			min_complete, flags);
 }
 
 static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
@@ -220,7 +250,7 @@ static struct io_u *fio_aioring_event(struct thread_data *td, int event)
 
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
-	ev = &ld->cq_ring->events[index];
+	ev = &ld->cq_ring.events[index];
 	io_u = ev->data;
 
 	if (ev->res != io_u->xfer_buflen) {
@@ -245,19 +275,19 @@ static int fio_aioring_cqring_reap(struct thread_data *td, unsigned int events,
 				   unsigned int max)
 {
 	struct aioring_data *ld = td->io_ops_data;
-	struct aio_cq_ring *ring = ld->cq_ring;
+	struct aio_cq_ring *ring = &ld->cq_ring;
 	u32 head, reaped = 0;
 
-	head = ring->head;
+	head = *ring->head;
 	do {
 		read_barrier();
-		if (head == ring->tail)
+		if (head == *ring->tail)
 			break;
 		reaped++;
 		head++;
 	} while (reaped + events < max);
 
-	ring->head = head;
+	*ring->head = head;
 	write_barrier();
 	return reaped;
 }
@@ -268,11 +298,11 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 	struct aioring_data *ld = td->io_ops_data;
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct aioring_options *o = td->eo;
-	struct aio_cq_ring *ring = ld->cq_ring;
+	struct aio_cq_ring *ring = &ld->cq_ring;
 	unsigned events = 0;
 	int r;
 
-	ld->cq_ring_off = ring->head;
+	ld->cq_ring_off = *ring->head;
 	do {
 		r = fio_aioring_cqring_reap(td, events, max);
 		if (r) {
@@ -281,12 +311,12 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 		}
 
 		if (!o->sqthread_poll) {
-			r = io_ring_enter(ld->aio_ctx, 0, actual_min,
-						IORING_FLAG_GETEVENTS);
+			r = io_uring_enter(ld, 0, actual_min,
+						IORING_ENTER_GETEVENTS);
 			if (r < 0) {
 				if (errno == EAGAIN)
 					continue;
-				td_verror(td, errno, "io_ring_enter get");
+				td_verror(td, errno, "io_uring_enter");
 				break;
 			}
 		}
@@ -299,7 +329,7 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 					   struct io_u *io_u)
 {
 	struct aioring_data *ld = td->io_ops_data;
-	struct aio_sq_ring *ring = ld->sq_ring;
+	struct aio_sq_ring *ring = &ld->sq_ring;
 	unsigned tail, next_tail;
 
 	fio_ro_check(td, io_u);
@@ -317,14 +347,14 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	tail = ring->tail;
+	tail = *ring->tail;
 	next_tail = tail + 1;
 	read_barrier();
-	if (next_tail == ring->head)
+	if (next_tail == *ring->head)
 		return FIO_Q_BUSY;
 
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
-	ring->tail = next_tail;
+	*ring->tail = next_tail;
 	write_barrier();
 
 	ld->queued++;
@@ -342,7 +372,8 @@ static void fio_aioring_queued(struct thread_data *td, int start, int nr)
 	fio_gettime(&now, NULL);
 
 	while (nr--) {
-		int index = ld->sq_ring->array[start & ld->sq_ring_mask];
+		struct aio_sq_ring *ring = &ld->sq_ring;
+		int index = ring->array[start & ld->sq_ring_mask];
 		struct io_u *io_u = ld->io_u_index[index];
 
 		memcpy(&io_u->issue_time, &now, sizeof(now));
@@ -363,19 +394,19 @@ static int fio_aioring_commit(struct thread_data *td)
 
 	/* Nothing to do */
 	if (o->sqthread_poll) {
-		struct aio_sq_ring *ring = ld->sq_ring;
+		struct aio_sq_ring *ring = &ld->sq_ring;
 
-		if (ring->kflags & IORING_SQ_NEED_WAKEUP)
-			io_ring_enter(ld->aio_ctx, ld->queued, 0, 0);
+		if (*ring->flags & IORING_SQ_NEED_WAKEUP)
+			io_uring_enter(ld, ld->queued, 0, 0);
 		ld->queued = 0;
 		return 0;
 	}
 
 	do {
-		unsigned start = ld->sq_ring->head;
+		unsigned start = *ld->sq_ring.head;
 		long nr = ld->queued;
 
-		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_GETEVENTS);
+		ret = io_uring_enter(ld, nr, 0, IORING_ENTER_GETEVENTS);
 		if (ret > 0) {
 			fio_aioring_queued(td, start, ret);
 			io_u_mark_submit(td, ret);
@@ -394,7 +425,7 @@ static int fio_aioring_commit(struct thread_data *td)
 				usleep(1);
 				continue;
 			}
-			td_verror(td, errno, "io_ring_enter sumit");
+			td_verror(td, errno, "io_uring_enter submit");
 			break;
 		}
 	} while (ld->queued);
@@ -402,24 +433,13 @@ static int fio_aioring_commit(struct thread_data *td)
 	return ret;
 }
 
-static size_t aioring_cq_size(struct thread_data *td)
+static void fio_aioring_unmap(struct aioring_data *ld)
 {
-	return sizeof(struct aio_cq_ring) + 2 * td->o.iodepth * sizeof(struct io_event);
-}
+	int i;
 
-static size_t aioring_sq_iocb(struct thread_data *td)
-{
-	return sizeof(struct iocb) * td->o.iodepth;
-}
-
-static size_t aioring_sq_size(struct thread_data *td)
-{
-	return sizeof(struct aio_sq_ring) + td->o.iodepth * sizeof(u32);
-}
-
-static unsigned roundup_pow2(unsigned depth)
-{
-	return 1UL << __fls(depth - 1);
+	for (i = 0; i < ARRAY_SIZE(ld->mmap); i++)
+		munmap(ld->mmap[i].ptr, ld->mmap[i].len);
+	close(ld->ring_fd);
 }
 
 static void fio_aioring_cleanup(struct thread_data *td)
@@ -437,33 +457,76 @@ static void fio_aioring_cleanup(struct thread_data *td)
 		 * speeding it up a lot.
 		 */
 		if (!(td->flags & TD_F_CHILD))
-			io_destroy(ld->aio_ctx);
+			fio_aioring_unmap(ld);
+
 		free(ld->io_u_index);
 		free(ld->io_us);
-		fio_memfree(ld->sq_ring, aioring_sq_size(td), false);
-		fio_memfree(ld->iocbs, aioring_sq_iocb(td), false);
-		fio_memfree(ld->cq_ring, aioring_cq_size(td), false);
+		free(ld->iovecs);
 		free(ld);
 	}
 }
 
+static int fio_aioring_mmap(struct aioring_data *ld, struct aio_uring_params *p)
+{
+	struct aio_sq_ring *sring = &ld->sq_ring;
+	struct aio_cq_ring *cring = &ld->cq_ring;
+	void *ptr;
+
+	ld->mmap[0].len = p->sq_off.array + p->sq_entries * sizeof(u32);
+	ptr = mmap(0, ld->mmap[0].len, PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
+			IORING_OFF_SQ_RING);
+	ld->mmap[0].ptr = ptr;
+	sring->head = ptr + p->sq_off.head;
+	sring->tail = ptr + p->sq_off.tail;
+	sring->ring_mask = ptr + p->sq_off.ring_mask;
+	sring->ring_entries = ptr + p->sq_off.ring_entries;
+	sring->flags = ptr + p->sq_off.flags;
+	sring->array = ptr + p->sq_off.array;
+	ld->sq_ring_mask = *sring->ring_mask;
+
+	ld->mmap[1].len = p->sq_entries * sizeof(struct iocb);
+	ld->iocbs = mmap(0, ld->mmap[1].len, PROT_READ | PROT_WRITE,
+				MAP_SHARED | MAP_POPULATE, ld->ring_fd,
+				IORING_OFF_IOCB);
+	ld->mmap[1].ptr = ld->iocbs;
+
+	ld->mmap[2].len = p->cq_off.events +
+				p->cq_entries * sizeof(struct io_event);
+	ptr = mmap(0, ld->mmap[2].len, PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, ld->ring_fd,
+			IORING_OFF_CQ_RING);
+	ld->mmap[2].ptr = ptr;
+	cring->head = ptr + p->cq_off.head;
+	cring->tail = ptr + p->cq_off.tail;
+	cring->ring_mask = ptr + p->cq_off.ring_mask;
+	cring->ring_entries = ptr + p->cq_off.ring_entries;
+	cring->events = ptr + p->cq_off.events;
+	ld->cq_ring_mask = *cring->ring_mask;
+	return 0;
+}
+
 static int fio_aioring_queue_init(struct thread_data *td)
 {
 	struct aioring_data *ld = td->io_ops_data;
 	struct aioring_options *o = td->eo;
-	int flags = IOCTX_FLAG_SCQRING;
 	int depth = td->o.iodepth;
+	struct aio_uring_params p;
+	int ret;
+
+	memset(&p, 0, sizeof(p));
+	p.flags = IOCTX_FLAG_SCQRING;
 
 	if (o->hipri)
-		flags |= IOCTX_FLAG_IOPOLL;
+		p.flags |= IOCTX_FLAG_IOPOLL;
 	if (o->sqthread_set) {
-		ld->sq_ring->sq_thread_cpu = o->sqthread;
-		flags |= IOCTX_FLAG_SQTHREAD;
+		p.sq_thread_cpu = o->sqthread;
+		p.flags |= IOCTX_FLAG_SQTHREAD;
 		if (o->sqthread_poll)
-			flags |= IOCTX_FLAG_SQPOLL;
+			p.flags |= IOCTX_FLAG_SQPOLL;
 	}
 	if (o->sqwq)
-		flags |= IOCTX_FLAG_SQWQ;
+		p.flags |= IOCTX_FLAG_SQWQ;
 
 	if (o->fixedbufs) {
 		struct rlimit rlim = {
@@ -472,11 +535,15 @@ static int fio_aioring_queue_init(struct thread_data *td)
 		};
 
 		setrlimit(RLIMIT_MEMLOCK, &rlim);
-		flags |= IOCTX_FLAG_FIXEDBUFS;
+		p.flags |= IOCTX_FLAG_FIXEDBUFS;
 	}
 
-	return syscall(__NR_sys_io_setup2, depth, flags,
-			ld->sq_ring, ld->cq_ring, &ld->aio_ctx);
+	ret = syscall(__NR_sys_io_uring_setup, depth, ld->iovecs, &p);
+	if (ret < 0)
+		return ret;
+
+	ld->ring_fd = ret;
+	return fio_aioring_mmap(ld, &p);
 }
 
 static int fio_aioring_post_init(struct thread_data *td)
@@ -484,22 +551,21 @@ static int fio_aioring_post_init(struct thread_data *td)
 	struct aioring_data *ld = td->io_ops_data;
 	struct aioring_options *o = td->eo;
 	struct io_u *io_u;
-	struct iocb *iocb;
-	int err = 0;
+	int err;
 
 	if (o->fixedbufs) {
 		int i;
 
 		for (i = 0; i < td->o.iodepth; i++) {
+			struct iovec *iov = &ld->iovecs[i];
+
 			io_u = ld->io_u_index[i];
-			iocb = &ld->iocbs[i];
-			iocb->u.c.buf = io_u->buf;
-			iocb->u.c.nbytes = td_max_bs(td);
+			iov->iov_base = io_u->buf;
+			iov->iov_len = td_max_bs(td);
 		}
 	}
 
 	err = fio_aioring_queue_init(td);
-
 	if (err) {
 		td_verror(td, errno, "io_queue_init");
 		return 1;
@@ -508,6 +574,11 @@ static int fio_aioring_post_init(struct thread_data *td)
 	return 0;
 }
 
+static unsigned roundup_pow2(unsigned depth)
+{
+	return 1UL << __fls(depth - 1);
+}
+
 static int fio_aioring_init(struct thread_data *td)
 {
 	struct aioring_data *ld;
@@ -522,19 +593,7 @@ static int fio_aioring_init(struct thread_data *td)
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 	ld->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
 
-	ld->iocbs = fio_memalign(page_size, aioring_sq_iocb(td), false);
-	memset(ld->iocbs, 0, aioring_sq_iocb(td));
-
-	ld->sq_ring = fio_memalign(page_size, aioring_sq_size(td), false);
-	memset(ld->sq_ring, 0, aioring_sq_size(td));
-	ld->sq_ring->nr_events = td->o.iodepth;
-	ld->sq_ring->iocbs = (u64) (uintptr_t) ld->iocbs;
-	ld->sq_ring_mask = td->o.iodepth - 1;
-
-	ld->cq_ring = fio_memalign(page_size, aioring_cq_size(td), false);
-	memset(ld->cq_ring, 0, aioring_cq_size(td));
-	ld->cq_ring->nr_events = td->o.iodepth * 2;
-	ld->cq_ring_mask = (2 * td->o.iodepth) - 1;
+	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
 	return 0;
diff --git a/t/aio-ring.c b/t/aio-ring.c
index c0c5009e..71978c68 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -14,6 +14,7 @@
 #include <sys/ioctl.h>
 #include <sys/syscall.h>
 #include <sys/resource.h>
+#include <sys/mman.h>
 #include <linux/fs.h>
 #include <fcntl.h>
 #include <unistd.h>
@@ -22,11 +23,14 @@
 #include <pthread.h>
 #include <sched.h>
 
-#define IOCTX_FLAG_IOPOLL	(1 << 0)
-#define IOCTX_FLAG_SCQRING	(1 << 1)	/* Use SQ/CQ rings */
+#include "../arch/arch.h"
+
+#define IOCTX_FLAG_SCQRING	(1 << 0)	/* Use SQ/CQ rings */
+#define IOCTX_FLAG_IOPOLL	(1 << 1)
 #define IOCTX_FLAG_FIXEDBUFS	(1 << 2)
 #define IOCTX_FLAG_SQTHREAD	(1 << 3)	/* Use SQ thread */
 #define IOCTX_FLAG_SQWQ		(1 << 4)	/* Use SQ wq */
+#define IOCTX_FLAG_SQPOLL	(1 << 5)
 
 #define IOEV_RES2_CACHEHIT	(1 << 0)
 
@@ -38,33 +42,55 @@ typedef uint64_t u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 
+#define IORING_OFF_SQ_RING	0ULL
+#define IORING_OFF_CQ_RING	0x8000000ULL
+#define IORING_OFF_IOCB		0x10000000ULL
+
+struct aio_sqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 flags;
+	u32 array;
+};
+
+struct aio_cqring_offsets {
+	u32 head;
+	u32 tail;
+	u32 ring_mask;
+	u32 ring_entries;
+	u32 overflow;
+	u32 events;
+};
+
+struct aio_uring_params {
+	u32 sq_entries;
+	u32 cq_entries;
+	u32 flags;
+	u16 sq_thread_cpu;
+	u16 resv[9];
+	struct aio_sqring_offsets sq_off;
+	struct aio_cqring_offsets cq_off;
+};
+
 struct aio_sq_ring {
-	union {
-		struct {
-			u32 head;
-			u32 tail;
-			u32 nr_events;
-			u16 sq_thread_cpu;
-			u64 iocbs;
-		};
-		u32 pad[16];
-	};
-	u32 array[0];
+	u32 *head;
+	u32 *tail;
+	u32 *ring_mask;
+	u32 *ring_entries;
+	u32 *array;
 };
 
 struct aio_cq_ring {
-	union {
-		struct {
-			u32 head;
-			u32 tail;
-			u32 nr_events;
-		};
-		struct io_event pad;
-	};
-	struct io_event events[0];
+	u32 *head;
+	u32 *tail;
+	u32 *ring_mask;
+	u32 *ring_entries;
+	struct io_event *events;
 };
 
-#define IORING_FLAG_GETEVENTS	(1 << 0)
+#define IORING_ENTER_GETEVENTS	(1 << 0)
 
 #define DEPTH			32
 
@@ -73,17 +99,17 @@ struct aio_cq_ring {
 
 #define BS			4096
 
-static unsigned sq_ring_mask = DEPTH - 1;
-static unsigned cq_ring_mask = (2 * DEPTH) - 1;
+static unsigned sq_ring_mask, cq_ring_mask;
 
 struct submitter {
 	pthread_t thread;
 	unsigned long max_blocks;
-	io_context_t ioc;
+	int fd;
 	struct drand48_data rand;
-	struct aio_sq_ring *sq_ring;
+	struct aio_sq_ring sq_ring;
 	struct iocb *iocbs;
-	struct aio_cq_ring *cq_ring;
+	struct iovec iovecs[DEPTH];
+	struct aio_cq_ring cq_ring;
 	int inflight;
 	unsigned long reaps;
 	unsigned long done;
@@ -96,23 +122,23 @@ struct submitter {
 static struct submitter submitters[1];
 static volatile int finish;
 
-static int polled = 1;		/* use IO polling */
-static int fixedbufs = 1;	/* use fixed user buffers */
-static int buffered = 0;	/* use buffered IO, not O_DIRECT */
+static int polled = 0;		/* use IO polling */
+static int fixedbufs = 0;	/* use fixed user buffers */
+static int buffered = 1;	/* use buffered IO, not O_DIRECT */
 static int sq_thread = 0;	/* use kernel submission thread */
 static int sq_thread_cpu = 0;	/* pin above thread to this CPU */
 
-static int io_setup2(unsigned int nr_events, unsigned int flags,
-		     struct aio_sq_ring *sq_ring, struct aio_cq_ring *cq_ring,
-		     io_context_t *ctx_idp)
+static int io_uring_setup(unsigned entries, struct iovec *iovecs,
+			  struct aio_uring_params *p)
 {
-	return syscall(335, nr_events, flags, sq_ring, cq_ring, ctx_idp);
+	return syscall(__NR_sys_io_uring_setup, entries, iovecs, p);
 }
 
-static int io_ring_enter(io_context_t ctx, unsigned int to_submit,
-			 unsigned int min_complete, unsigned int flags)
+static int io_uring_enter(struct submitter *s, unsigned int to_submit,
+			  unsigned int min_complete, unsigned int flags)
 {
-	return syscall(336, ctx, to_submit, min_complete, flags);
+	return syscall(__NR_sys_io_uring_enter, s->fd, to_submit, min_complete,
+			flags);
 }
 
 static int gettid(void)
@@ -120,8 +146,9 @@ static int gettid(void)
 	return syscall(__NR_gettid);
 }
 
-static void init_io(struct submitter *s, int fd, struct iocb *iocb)
+static void init_io(struct submitter *s, int fd, unsigned index)
 {
+	struct iocb *iocb = &s->iocbs[index];
 	unsigned long offset;
 	long r;
 
@@ -130,34 +157,34 @@ static void init_io(struct submitter *s, int fd, struct iocb *iocb)
 
 	iocb->aio_fildes = fd;
 	iocb->aio_lio_opcode = IO_CMD_PREAD;
+	iocb->u.c.buf = s->iovecs[index].iov_base;
+	iocb->u.c.nbytes = BS;
 	iocb->u.c.offset = offset;
-	if (!fixedbufs)
-		iocb->u.c.nbytes = BS;
 }
 
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 {
-	struct aio_sq_ring *ring = s->sq_ring;
+	struct aio_sq_ring *ring = &s->sq_ring;
 	u32 index, tail, next_tail, prepped = 0;
 
-	next_tail = tail = ring->tail;
+	next_tail = tail = *ring->tail;
 	do {
 		next_tail++;
 		barrier();
-		if (next_tail == ring->head)
+		if (next_tail == *ring->head)
 			break;
 
 		index = tail & sq_ring_mask;
-		init_io(s, fd, &s->iocbs[index]);
-		s->sq_ring->array[index] = index;
+		init_io(s, fd, index);
+		ring->array[index] = index;
 		prepped++;
 		tail = next_tail;
 	} while (prepped < max_ios);
 
-	if (ring->tail != tail) {
+	if (*ring->tail != tail) {
 		/* order tail store with writes to iocbs above */
 		barrier();
-		ring->tail = tail;
+		*ring->tail = tail;
 		barrier();
 	}
 	return prepped;
@@ -187,14 +214,14 @@ static int get_file_size(int fd, unsigned long *blocks)
 
 static int reap_events(struct submitter *s)
 {
-	struct aio_cq_ring *ring = s->cq_ring;
+	struct aio_cq_ring *ring = &s->cq_ring;
 	struct io_event *ev;
 	u32 head, reaped = 0;
 
-	head = ring->head;
+	head = *ring->head;
 	do {
 		barrier();
-		if (head == ring->tail)
+		if (head == *ring->tail)
 			break;
 		ev = &ring->events[head & cq_ring_mask];
 		if (ev->res != BS) {
@@ -213,7 +240,7 @@ static int reap_events(struct submitter *s)
 	} while (1);
 
 	s->inflight -= reaped;
-	ring->head = head;
+	*ring->head = head;
 	barrier();
 	return reaped;
 }
@@ -262,8 +289,7 @@ submit:
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
 
-		ret = io_ring_enter(s->ioc, to_submit, to_wait,
-					IORING_FLAG_GETEVENTS);
+		ret = io_uring_enter(s, to_submit, to_wait, IORING_ENTER_GETEVENTS);
 		s->calls++;
 
 		this_reap = reap_events(s);
@@ -288,7 +314,7 @@ submit:
 			prepped = 0;
 			continue;
 		} else if (ret < 0) {
-			if ((ret == -1 && errno == EAGAIN) || ret == -EAGAIN) {
+			if (errno == EAGAIN) {
 				if (s->finish)
 					break;
 				if (this_reap)
@@ -296,10 +322,7 @@ submit:
 				to_submit = 0;
 				goto submit;
 			}
-			if (ret == -1)
-				printf("io_submit: %s\n", strerror(errno));
-			else
-				printf("io_submit: %s\n", strerror(-ret));
+			printf("io_submit: %s\n", strerror(errno));
 			break;
 		}
 	} while (!s->finish);
@@ -327,15 +350,74 @@ static void arm_sig_int(void)
 	sigaction(SIGINT, &act, NULL);
 }
 
+static int setup_ring(struct submitter *s)
+{
+	struct aio_sq_ring *sring = &s->sq_ring;
+	struct aio_cq_ring *cring = &s->cq_ring;
+	struct aio_uring_params p;
+	void *ptr;
+	int fd;
+
+	memset(&p, 0, sizeof(p));
+
+	p.flags = IOCTX_FLAG_SCQRING;
+	if (polled)
+		p.flags |= IOCTX_FLAG_IOPOLL;
+	if (fixedbufs)
+		p.flags |= IOCTX_FLAG_FIXEDBUFS;
+	if (buffered)
+		p.flags |= IOCTX_FLAG_SQWQ;
+	else if (sq_thread) {
+		p.flags |= IOCTX_FLAG_SQTHREAD;
+		p.sq_thread_cpu = sq_thread_cpu;
+	}
+
+	if (fixedbufs)
+		fd = io_uring_setup(DEPTH, s->iovecs, &p);
+	else
+		fd = io_uring_setup(DEPTH, NULL, &p);
+	if (fd < 0) {
+		perror("io_uring_setup");
+		return 1;
+	}
+
+	s->fd = fd;
+
+	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(u32),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+			fd, IORING_OFF_SQ_RING);
+	printf("sq_ring ptr = 0x%p\n", ptr);
+	sring->head = ptr + p.sq_off.head;
+	sring->tail = ptr + p.sq_off.tail;
+	sring->ring_mask = ptr + p.sq_off.ring_mask;
+	sring->ring_entries = ptr + p.sq_off.ring_entries;
+	sring->array = ptr + p.sq_off.array;
+	sq_ring_mask = *sring->ring_mask;
+
+	s->iocbs = mmap(0, p.sq_entries * sizeof(struct iocb), PROT_READ | PROT_WRITE,
+			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_IOCB);
+	printf("iocbs ptr   = 0x%p\n", s->iocbs);
+
+	ptr = mmap(0, p.cq_off.events + p.cq_entries * sizeof(struct io_event),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
+			fd, IORING_OFF_CQ_RING);
+	printf("cq_ring ptr = 0x%p\n", ptr);
+	cring->head = ptr + p.cq_off.head;
+	cring->tail = ptr + p.cq_off.tail;
+	cring->ring_mask = ptr + p.cq_off.ring_mask;
+	cring->ring_entries = ptr + p.cq_off.ring_entries;
+	cring->events = ptr + p.cq_off.events;
+	cq_ring_mask = *cring->ring_mask;
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct submitter *s = &submitters[0];
 	unsigned long done, calls, reap, cache_hit, cache_miss;
-	int flags = 0, err;
-	int j;
-	size_t size;
-	void *p, *ret;
+	int err, i;
 	struct rlimit rlim;
+	void *ret;
 
 	if (argc < 2) {
 		printf("%s: filename\n", argv[0]);
@@ -351,58 +433,24 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	size = sizeof(struct iocb) * DEPTH;
-	if (posix_memalign(&p, 4096, size))
-		return 1;
-	memset(p, 0, size);
-	s->iocbs = p;
+	for (i = 0; i < DEPTH; i++) {
+		void *buf;
 
-	size = sizeof(struct aio_sq_ring) + DEPTH * sizeof(u32);
-	if (posix_memalign(&p, 4096, size))
-		return 1;
-	s->sq_ring = p;
-	memset(p, 0, size);
-	s->sq_ring->nr_events = DEPTH;
-	s->sq_ring->iocbs = (u64) s->iocbs;
-
-	/* CQ ring must be twice as big */
-	size = sizeof(struct aio_cq_ring) +
-			2 * DEPTH * sizeof(struct io_event);
-	if (posix_memalign(&p, 4096, size))
-		return 1;
-	s->cq_ring = p;
-	memset(p, 0, size);
-	s->cq_ring->nr_events = 2 * DEPTH;
-
-	for (j = 0; j < DEPTH; j++) {
-		struct iocb *iocb = &s->iocbs[j];
-
-		if (posix_memalign(&iocb->u.c.buf, BS, BS)) {
+		if (posix_memalign(&buf, BS, BS)) {
 			printf("failed alloc\n");
 			return 1;
 		}
-		iocb->u.c.nbytes = BS;
-	}
-
-	flags = IOCTX_FLAG_SCQRING;
-	if (polled)
-		flags |= IOCTX_FLAG_IOPOLL;
-	if (fixedbufs)
-		flags |= IOCTX_FLAG_FIXEDBUFS;
-	if (buffered)
-		flags |= IOCTX_FLAG_SQWQ;
-	else if (sq_thread) {
-		flags |= IOCTX_FLAG_SQTHREAD;
-		s->sq_ring->sq_thread_cpu = sq_thread_cpu;
+		s->iovecs[i].iov_base = buf;
+		s->iovecs[i].iov_len = BS;
 	}
 
-	err = io_setup2(DEPTH, flags, s->sq_ring, s->cq_ring, &s->ioc);
+	err = setup_ring(s);
 	if (err) {
-		printf("ctx_init failed: %s, %d\n", strerror(errno), err);
+		printf("ring setup failed: %s, %d\n", strerror(errno), err);
 		return 1;
 	}
-	printf("polled=%d, fixedbufs=%d, buffered=%d\n", polled, fixedbufs, buffered);
-	printf("  QD=%d, sq_ring=%d, cq_ring=%d\n", DEPTH, s->sq_ring->nr_events, s->cq_ring->nr_events);
+	printf("polled=%d, fixedbufs=%d, buffered=%d", polled, fixedbufs, buffered);
+	printf(" QD=%d, sq_ring=%d, cq_ring=%d\n", DEPTH, *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 	strcpy(s->filename, argv[1]);
 
 	pthread_create(&s->thread, NULL, submitter_fn, s);
@@ -437,7 +485,7 @@ int main(int argc, char *argv[])
 		}
 		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%u tail=%u), Cachehit=%0.2f%%\n",
 				this_done - done, rpc, ipc, s->inflight,
-				s->cq_ring->head, s->cq_ring->tail, hit);
+				*s->cq_ring.head, *s->cq_ring.tail, hit);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;

