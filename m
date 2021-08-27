Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhH0MB1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Aug 2021 08:01:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 508F5C061757
        for <fio@vger.kernel.org>; Fri, 27 Aug 2021 05:00:38 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mJaWi-00EVgo-Op
        for fio@vger.kernel.org; Fri, 27 Aug 2021 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210827120002.0B9161BC015C@kernel.dk>
Date: Fri, 27 Aug 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 15ce99bb71e7c289f62ddee94e0149f6c81549de:

  Merge branch 'master' of https://github.com/DamonPalovaara/fio (2021-08-20 20:58:42 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fd70e3619c00bc9f7b2f80cadf3fdb348cbacf51:

  io_uring: don't clear recently set sqe->rw_flags (2021-08-26 10:50:05 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'wip-cxx' of https://github.com/tchaikov/fio

Kefu Chai (1):
      arch,lib/seqlock: implement seqlock with C++ atomic if compiled with C++

Niklas Cassel (3):
      io_uring: always initialize sqe->flags
      io_uring: fix misbehaving cmdprio_percentage option
      io_uring: don't clear recently set sqe->rw_flags

 arch/arch.h        | 20 ++++++++++++++++++++
 engines/io_uring.c |  7 +++++--
 lib/seqlock.h      |  4 ++++
 3 files changed, 29 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch.h b/arch/arch.h
index a25779d4..fca003be 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -1,7 +1,11 @@
 #ifndef ARCH_H
 #define ARCH_H
 
+#ifdef __cplusplus
+#include <atomic>
+#else
 #include <stdatomic.h>
+#endif
 
 #include "../lib/types.h"
 
@@ -36,6 +40,21 @@ extern unsigned long arch_flags;
 
 #define ARCH_CPU_CLOCK_WRAPS
 
+#ifdef __cplusplus
+#define atomic_add(p, v)						\
+	std::atomic_fetch_add(p, (v))
+#define atomic_sub(p, v)						\
+	std::atomic_fetch_sub(p, (v))
+#define atomic_load_relaxed(p)					\
+	std::atomic_load_explicit(p,				\
+			     std::memory_order_relaxed)
+#define atomic_load_acquire(p)					\
+	std::atomic_load_explicit(p,				\
+			     std::memory_order_acquire)
+#define atomic_store_release(p, v)				\
+	std::atomic_store_explicit(p, (v),			\
+			     std::memory_order_release)
+#else
 #define atomic_add(p, v)					\
 	atomic_fetch_add((_Atomic typeof(*(p)) *)(p), v)
 #define atomic_sub(p, v)					\
@@ -49,6 +68,7 @@ extern unsigned long arch_flags;
 #define atomic_store_release(p, v)				\
 	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v),	\
 			      memory_order_release)
+#endif
 
 /* IWYU pragma: begin_exports */
 #if defined(__i386__)
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 9c091e37..b8d4cf91 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -234,6 +234,7 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		sqe->flags = IOSQE_FIXED_FILE;
 	} else {
 		sqe->fd = f->fd;
+		sqe->flags = 0;
 	}
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
@@ -261,8 +262,9 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 				sqe->len = 1;
 			}
 		}
+		sqe->rw_flags = 0;
 		if (!td->o.odirect && o->uncached)
-			sqe->rw_flags = RWF_UNCACHED;
+			sqe->rw_flags |= RWF_UNCACHED;
 		if (o->nowait)
 			sqe->rw_flags |= RWF_NOWAIT;
 		if (ld->ioprio_class_set)
@@ -270,7 +272,6 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
-		sqe->rw_flags = 0;
 	} else if (ddir_sync(io_u->ddir)) {
 		sqe->ioprio = 0;
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
@@ -383,6 +384,8 @@ static void fio_ioring_prio_prep(struct thread_data *td, struct io_u *io_u)
 	if (rand_between(&td->prio_state, 0, 99) < o->cmdprio_percentage) {
 		ld->sqes[io_u->index].ioprio = IOPRIO_CLASS_RT << IOPRIO_CLASS_SHIFT;
 		io_u->flags |= IO_U_F_PRIORITY;
+	} else {
+		ld->sqes[io_u->index].ioprio = 0;
 	}
 	return;
 }
diff --git a/lib/seqlock.h b/lib/seqlock.h
index 56f3e37d..ef3aa091 100644
--- a/lib/seqlock.h
+++ b/lib/seqlock.h
@@ -5,7 +5,11 @@
 #include "../arch/arch.h"
 
 struct seqlock {
+#ifdef __cplusplus
+	std::atomic<unsigned int> sequence;
+#else
 	volatile unsigned int sequence;
+#endif
 };
 
 static inline void seqlock_init(struct seqlock *s)

