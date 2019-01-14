Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfANNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Jan 2019 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gj1qc-0006pS-Ae
        for fio@vger.kernel.org; Mon, 14 Jan 2019 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190114130002.4DEFB2C0164@kernel.dk>
Date: Mon, 14 Jan 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8025517dfa599be4bc795e4af7c9012d10b81bc5:

  t/io_uring: add IORING_OP_NOP support (2019-01-12 22:14:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c21198d9cd52b6239c8f9de2373574a7683a0593:

  t/io_uring: use the right check for when to wait (2019-01-13 22:52:07 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      Move io_uring to os/linux/
      io_uring: ensure that the io_uring_register() structs are 32-bit safe
      io_uring: fix pointer cast warning on 32-bit
      t/io_uring: add option for register_files
      io_uring: add 32-bit x86 support
      t/io_uring: only call setrlimit() for fixedbufs
      t/io_uring: use the right check for when to wait

 Makefile                  |  2 +-
 arch/arch-x86.h           | 11 +++++++++++
 engines/io_uring.c        |  4 ++--
 os/{ => linux}/io_uring.h | 17 ++++++++++++-----
 t/io_uring.c              | 41 ++++++++++++++++++++++++++---------------
 5 files changed, 52 insertions(+), 23 deletions(-)
 rename os/{ => linux}/io_uring.h (94%)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 3701317e..fd138dd2 100644
--- a/Makefile
+++ b/Makefile
@@ -444,7 +444,7 @@ cairo_text_helpers.o: cairo_text_helpers.c cairo_text_helpers.h
 printing.o: printing.c printing.h
 	$(QUIET_CC)$(CC) $(CFLAGS) $(GTK_CFLAGS) $(CPPFLAGS) -c $<
 
-t/io_uring.o: os/io_uring.h
+t/io_uring.o: os/linux/io_uring.h
 t/io_uring: $(T_IOU_RING_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_IOU_RING_OBJS) $(LIBS)
 
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index c6bcb54c..c1c866ea 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -1,6 +1,16 @@
 #ifndef ARCH_X86_H
 #define ARCH_X86_H
 
+#ifndef __NR_sys_io_uring_setup
+#define __NR_sys_io_uring_setup		387
+#endif
+#ifndef __NR_sys_io_uring_enter
+#define __NR_sys_io_uring_enter		388
+#endif
+#ifndef __NR_sys_io_uring_register
+#define __NR_sys_io_uring_register	389
+#endif
+
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
 {
@@ -36,5 +46,6 @@ static inline unsigned long long get_cpu_clock(void)
 
 #define ARCH_HAVE_FFZ
 #define ARCH_HAVE_CPU_CLOCK
+#define ARCH_HAVE_IOURING
 
 #endif
diff --git a/engines/io_uring.c b/engines/io_uring.c
index ca3e157f..56af8d71 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -21,7 +21,7 @@
 #ifdef ARCH_HAVE_IOURING
 
 #include "../lib/types.h"
-#include "../os/io_uring.h"
+#include "../os/linux/io_uring.h"
 
 struct io_sq_ring {
 	unsigned *head;
@@ -187,7 +187,7 @@ static struct io_u *fio_ioring_event(struct thread_data *td, int event)
 	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	cqe = &ld->cq_ring.cqes[index];
-	io_u = (struct io_u *) cqe->user_data;
+	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
 	if (cqe->res != io_u->xfer_buflen) {
 		if (cqe->res > io_u->xfer_buflen)
diff --git a/os/io_uring.h b/os/linux/io_uring.h
similarity index 94%
rename from os/io_uring.h
rename to os/linux/io_uring.h
index 0f4460d6..71e92026 100644
--- a/os/io_uring.h
+++ b/os/linux/io_uring.h
@@ -29,10 +29,11 @@ struct io_uring_sqe {
 		__kernel_rwf_t	rw_flags;
 		__u32		fsync_flags;
 	};
-	__u16	buf_index;	/* index into fixed buffers, if used */
-	__u16	__pad2;
-	__u32	__pad3;
 	__u64	user_data;	/* data to be passed back at completion time */
+	union {
+		__u16	buf_index;	/* index into fixed buffers, if used */
+		__u64	__pad2[3];
+	};
 };
 
 /*
@@ -136,12 +137,18 @@ struct io_uring_params {
 #define IORING_UNREGISTER_FILES		3
 
 struct io_uring_register_buffers {
-	struct iovec *iovecs;
+	union {
+		struct iovec *iovecs;
+		__u64 pad;
+	};
 	__u32 nr_iovecs;
 };
 
 struct io_uring_register_files {
-	__s32 *fds;
+	union {
+		__s32 *fds;
+		__u64 pad;
+	};
 	__u32 nr_fds;
 };
 
diff --git a/t/io_uring.c b/t/io_uring.c
index 8d3f3a9b..7ddeef39 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -22,7 +22,7 @@
 
 #include "../arch/arch.h"
 #include "../lib/types.h"
-#include "../os/io_uring.h"
+#include "../os/linux/io_uring.h"
 
 #define barrier()	__asm__ __volatile__("": : :"memory")
 
@@ -90,6 +90,7 @@ static volatile int finish;
 
 static int polled = 1;		/* use IO polling */
 static int fixedbufs = 1;	/* use fixed user buffers */
+static int register_files = 1;	/* use fixed files */
 static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
@@ -178,7 +179,13 @@ static void init_io(struct submitter *s, unsigned index)
 	lrand48_r(&s->rand, &r);
 	offset = (r % (f->max_blocks - 1)) * BS;
 
-	sqe->flags = IOSQE_FIXED_FILE;
+	if (register_files) {
+		sqe->flags = IOSQE_FIXED_FILE;
+		sqe->fd = f->fixed_fd;
+	} else {
+		sqe->flags = 0;
+		sqe->fd = f->real_fd;
+	}
 	if (fixedbufs) {
 		sqe->opcode = IORING_OP_READ_FIXED;
 		sqe->addr = s->iovecs[index].iov_base;
@@ -191,7 +198,6 @@ static void init_io(struct submitter *s, unsigned index)
 		sqe->buf_index = 0;
 	}
 	sqe->ioprio = 0;
-	sqe->fd = f->fixed_fd;
 	sqe->off = offset;
 	sqe->user_data = (unsigned long) f;
 }
@@ -261,7 +267,7 @@ static int reap_events(struct submitter *s)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
 		if (!do_nop) {
-			f = (struct file *) cqe->user_data;
+			f = (struct file *) (uintptr_t) cqe->user_data;
 			f->pending_ios--;
 			if (cqe->res != BS) {
 				printf("io: unexpected ret=%d\n", cqe->res);
@@ -304,7 +310,7 @@ static void *submitter_fn(void *data)
 submit_more:
 		to_submit = prepped;
 submit:
-		if (s->inflight + BATCH_SUBMIT < DEPTH)
+		if (to_submit && (s->inflight + to_submit < DEPTH))
 			to_wait = 0;
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
@@ -424,10 +430,12 @@ static int setup_ring(struct submitter *s)
 		}
 	}
 
-	ret = io_uring_register_files(s);
-	if (ret < 0) {
-		perror("io_uring_register_files");
-		return 1;
+	if (register_files) {
+		ret = io_uring_register_files(s);
+		if (ret < 0) {
+			perror("io_uring_register_files");
+			return 1;
+		}
 	}
 
 	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(__u32),
@@ -465,7 +473,6 @@ int main(int argc, char *argv[])
 	struct submitter *s = &submitters[0];
 	unsigned long done, calls, reap, cache_hit, cache_miss;
 	int err, i, flags, fd;
-	struct rlimit rlim;
 	void *ret;
 
 	if (!do_nop && argc < 2) {
@@ -502,11 +509,15 @@ int main(int argc, char *argv[])
 		i++;
 	}
 
-	rlim.rlim_cur = RLIM_INFINITY;
-	rlim.rlim_max = RLIM_INFINITY;
-	if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0) {
-		perror("setrlimit");
-		return 1;
+	if (fixedbufs) {
+		struct rlimit rlim;
+
+		rlim.rlim_cur = RLIM_INFINITY;
+		rlim.rlim_max = RLIM_INFINITY;
+		if (setrlimit(RLIMIT_MEMLOCK, &rlim) < 0) {
+			perror("setrlimit");
+			return 1;
+		}
 	}
 
 	arm_sig_int();

