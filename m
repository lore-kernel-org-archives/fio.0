Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgFVMAz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Jun 2020 08:00:55 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE0EC061794
        for <fio@vger.kernel.org>; Mon, 22 Jun 2020 05:00:53 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jnL7s-0003u3-JX
        for fio@vger.kernel.org; Mon, 22 Jun 2020 12:00:36 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200622120002.226241BC01AE@kernel.dk>
Date: Mon, 22 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1a953d975847e248be1718105621796bf9481878:

  Priority bit log file format documentation update (2020-06-12 16:24:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 653241de1eb5b9abe21cb6feb036df202d388c68:

  Merge branch 'atomics' of https://github.com/bvanassche/fio (2020-06-21 20:48:05 -0600)

----------------------------------------------------------------
Bart Van Assche (11):
      configure: Use -Wimplicit-fallthrough=2 instead of -Wimplicit-fallthrough=3
      Make __rand_0_1() compatible with clang
      fio_sem: Remove a read_barrier() call
      arch/arch.h: Introduce atomic_{load_acquire,store_release}()
      engines/libaio: Use atomic_store_release() instead of read_barrier()
      engines/io_uring: Use atomic_{load_acquire,store_release}()
      fio: Use atomic_load_acquire() and atomic_store_release() where appropriate
      t/run-fio-tests.py: Increase IOPS tolerance further
      Add a test that sets gtod_cpu=1
      Optimize the seqlock implementation
      Optimize fio_gettime_offload()

Jens Axboe (1):
      Merge branch 'atomics' of https://github.com/bvanassche/fio

 arch/arch.h        |  9 +++++++++
 configure          |  6 +++---
 engines/io_uring.c | 12 ++++--------
 engines/libaio.c   |  4 ++--
 fio_sem.c          |  1 -
 gettime-thread.c   | 23 +++++++++++++----------
 gettime.h          | 15 +++++++++------
 io_u.c             |  4 ++--
 lib/rand.h         | 10 ++++++----
 lib/seqlock.h      |  9 +++------
 t/debug.c          |  2 +-
 t/jobs/t0012.fio   | 20 ++++++++++++++++++++
 t/run-fio-tests.py | 20 ++++++++++++++++----
 verify.c           |  7 +++----
 14 files changed, 91 insertions(+), 51 deletions(-)
 create mode 100644 t/jobs/t0012.fio

---

Diff of recent changes:

diff --git a/arch/arch.h b/arch/arch.h
index 30c0d205..08c3d703 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -1,6 +1,8 @@
 #ifndef ARCH_H
 #define ARCH_H
 
+#include <stdatomic.h>
+
 #include "../lib/types.h"
 
 enum {
@@ -34,6 +36,13 @@ extern unsigned long arch_flags;
 
 #define ARCH_CPU_CLOCK_WRAPS
 
+#define atomic_load_acquire(p)					\
+	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
+			     memory_order_acquire)
+#define atomic_store_release(p, v)				\
+	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v),	\
+			      memory_order_release)
+
 /* IWYU pragma: begin_exports */
 #if defined(__i386__)
 #include "arch-x86.h"
diff --git a/configure b/configure
index 3ee8aaf2..63b30555 100755
--- a/configure
+++ b/configure
@@ -2548,7 +2548,7 @@ fi
 print_config "__kernel_rwf_t" "$__kernel_rwf_t"
 
 ##########################################
-# check if gcc has -Wimplicit-fallthrough
+# check if gcc has -Wimplicit-fallthrough=2
 fallthrough="no"
 cat > $TMPC << EOF
 int main(int argc, char **argv)
@@ -2556,10 +2556,10 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "-Wimplicit-fallthrough" "" "-Wimplicit-fallthrough"; then
+if compile_prog "-Wimplicit-fallthrough=2" "" "-Wimplicit-fallthrough=2"; then
   fallthrough="yes"
 fi
-print_config "-Wimplicit-fallthrough" "$fallthrough"
+print_config "-Wimplicit-fallthrough=2" "$fallthrough"
 
 ##########################################
 # check for MADV_HUGEPAGE support
diff --git a/engines/io_uring.c b/engines/io_uring.c
index cab7ecaf..cd0810f4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -301,15 +301,13 @@ static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
 
 	head = *ring->head;
 	do {
-		read_barrier();
-		if (head == *ring->tail)
+		if (head == atomic_load_acquire(ring->tail))
 			break;
 		reaped++;
 		head++;
 	} while (reaped + events < max);
 
-	*ring->head = head;
-	write_barrier();
+	atomic_store_release(ring->head, head);
 	return reaped;
 }
 
@@ -384,15 +382,13 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 
 	tail = *ring->tail;
 	next_tail = tail + 1;
-	read_barrier();
-	if (next_tail == *ring->head)
+	if (next_tail == atomic_load_acquire(ring->head))
 		return FIO_Q_BUSY;
 
 	if (o->cmdprio_percentage)
 		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
-	*ring->tail = next_tail;
-	write_barrier();
+	atomic_store_release(ring->tail, next_tail);
 
 	ld->queued++;
 	return FIO_Q_QUEUED;
diff --git a/engines/libaio.c b/engines/libaio.c
index daa576da..398fdf91 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -195,8 +195,8 @@ static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
 		} else {
 			/* There is another completion to reap */
 			events[i] = ring->events[head];
-			read_barrier();
-			ring->head = (head + 1) % ring->nr;
+			atomic_store_release(&ring->head,
+					     (head + 1) % ring->nr);
 			i++;
 		}
 	}
diff --git a/fio_sem.c b/fio_sem.c
index c34d8bf7..c7806acb 100644
--- a/fio_sem.c
+++ b/fio_sem.c
@@ -169,7 +169,6 @@ void fio_sem_up(struct fio_sem *sem)
 	assert(sem->magic == FIO_SEM_MAGIC);
 
 	pthread_mutex_lock(&sem->lock);
-	read_barrier();
 	if (!sem->value && sem->waiters)
 		do_wake = 1;
 	sem->value++;
diff --git a/gettime-thread.c b/gettime-thread.c
index 0a2cc6c4..953e4e67 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -2,9 +2,10 @@
 #include <time.h>
 
 #include "fio.h"
+#include "lib/seqlock.h"
 #include "smalloc.h"
 
-struct timespec *fio_ts = NULL;
+struct fio_ts *fio_ts;
 int fio_gtod_offload = 0;
 static pthread_t gtod_thread;
 static os_cpu_mask_t fio_gtod_cpumask;
@@ -19,15 +20,17 @@ void fio_gtod_init(void)
 
 static void fio_gtod_update(void)
 {
-	if (fio_ts) {
-		struct timeval __tv;
-
-		gettimeofday(&__tv, NULL);
-		fio_ts->tv_sec = __tv.tv_sec;
-		write_barrier();
-		fio_ts->tv_nsec = __tv.tv_usec * 1000;
-		write_barrier();
-	}
+	struct timeval __tv;
+
+	if (!fio_ts)
+		return;
+
+	gettimeofday(&__tv, NULL);
+
+	write_seqlock_begin(&fio_ts->seqlock);
+	fio_ts->ts.tv_sec = __tv.tv_sec;
+	fio_ts->ts.tv_nsec = __tv.tv_usec * 1000;
+	write_seqlock_end(&fio_ts->seqlock);
 }
 
 struct gtod_cpu_data {
diff --git a/gettime.h b/gettime.h
index f92ee8c4..c55f5cba 100644
--- a/gettime.h
+++ b/gettime.h
@@ -4,6 +4,7 @@
 #include <sys/time.h>
 
 #include "arch/arch.h"
+#include "lib/seqlock.h"
 
 /*
  * Clock sources
@@ -22,20 +23,22 @@ extern int fio_start_gtod_thread(void);
 extern int fio_monotonic_clocktest(int debug);
 extern void fio_local_clock_init(void);
 
-extern struct timespec *fio_ts;
+extern struct fio_ts {
+	struct seqlock seqlock;
+	struct timespec ts;
+} *fio_ts;
 
 static inline int fio_gettime_offload(struct timespec *ts)
 {
-	time_t last_sec;
+	unsigned int seq;
 
 	if (!fio_ts)
 		return 0;
 
 	do {
-		read_barrier();
-		last_sec = ts->tv_sec = fio_ts->tv_sec;
-		ts->tv_nsec = fio_ts->tv_nsec;
-	} while (fio_ts->tv_sec != last_sec);
+		seq = read_seqlock_begin(&fio_ts->seqlock);
+		*ts = fio_ts->ts;
+	} while (read_seqlock_retry(&fio_ts->seqlock, seq));
 
 	return 1;
 }
diff --git a/io_u.c b/io_u.c
index ae1438fd..7f50906b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1934,8 +1934,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		if (io_u->error)
 			unlog_io_piece(td, io_u);
 		else {
-			io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
-			write_barrier();
+			atomic_store_release(&io_u->ipo->flags,
+					io_u->ipo->flags & ~IP_F_IN_FLIGHT);
 		}
 	}
 
diff --git a/lib/rand.h b/lib/rand.h
index 2ccc1b37..46c1c5e0 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -6,7 +6,9 @@
 #include "types.h"
 
 #define FRAND32_MAX	(-1U)
+#define FRAND32_MAX_PLUS_ONE	(1.0 * (1ULL << 32))
 #define FRAND64_MAX	(-1ULL)
+#define FRAND64_MAX_PLUS_ONE	(1.0 * (1ULL << 32) * (1ULL << 32))
 
 struct taus88_state {
 	unsigned int s1, s2, s3;
@@ -106,11 +108,11 @@ static inline double __rand_0_1(struct frand_state *state)
 	if (state->use64) {
 		uint64_t val = __rand64(&state->state64);
 
-		return (val + 1.0) / (FRAND64_MAX + 1.0);
+		return (val + 1.0) / FRAND64_MAX_PLUS_ONE;
 	} else {
 		uint32_t val = __rand32(&state->state32);
 
-		return (val + 1.0) / (FRAND32_MAX + 1.0);
+		return (val + 1.0) / FRAND32_MAX_PLUS_ONE;
 	}
 }
 
@@ -122,7 +124,7 @@ static inline uint32_t rand32_upto(struct frand_state *state, uint32_t end)
 
 	r = __rand32(&state->state32);
 	end++;
-	return (int) ((double)end * (r / (FRAND32_MAX + 1.0)));
+	return (int) ((double)end * (r / FRAND32_MAX_PLUS_ONE));
 }
 
 static inline uint64_t rand64_upto(struct frand_state *state, uint64_t end)
@@ -133,7 +135,7 @@ static inline uint64_t rand64_upto(struct frand_state *state, uint64_t end)
 
 	r = __rand64(&state->state64);
 	end++;
-	return (uint64_t) ((double)end * (r / (FRAND64_MAX + 1.0)));
+	return (uint64_t) ((double)end * (r / FRAND64_MAX_PLUS_ONE));
 }
 
 /*
diff --git a/lib/seqlock.h b/lib/seqlock.h
index 762b6ec1..afa9fd31 100644
--- a/lib/seqlock.h
+++ b/lib/seqlock.h
@@ -18,13 +18,12 @@ static inline unsigned int read_seqlock_begin(struct seqlock *s)
 	unsigned int seq;
 
 	do {
-		seq = s->sequence;
+		seq = atomic_load_acquire(&s->sequence);
 		if (!(seq & 1))
 			break;
 		nop;
 	} while (1);
 
-	read_barrier();
 	return seq;
 }
 
@@ -36,14 +35,12 @@ static inline bool read_seqlock_retry(struct seqlock *s, unsigned int seq)
 
 static inline void write_seqlock_begin(struct seqlock *s)
 {
-	s->sequence++;
-	write_barrier();
+	s->sequence = atomic_load_acquire(&s->sequence) + 1;
 }
 
 static inline void write_seqlock_end(struct seqlock *s)
 {
-	write_barrier();
-	s->sequence++;
+	atomic_store_release(&s->sequence, s->sequence + 1);
 }
 
 #endif
diff --git a/t/debug.c b/t/debug.c
index 8965cfbc..0c913368 100644
--- a/t/debug.c
+++ b/t/debug.c
@@ -1,7 +1,7 @@
 #include <stdio.h>
 
 FILE *f_err;
-struct timespec *fio_ts = NULL;
+void *fio_ts;
 unsigned long fio_debug = 0;
 
 void __dprint(int type, const char *str, ...)
diff --git a/t/jobs/t0012.fio b/t/jobs/t0012.fio
new file mode 100644
index 00000000..985eb16b
--- /dev/null
+++ b/t/jobs/t0012.fio
@@ -0,0 +1,20 @@
+# Expected results: no parse warnings, runs and with roughly 1/8 iops between
+#			the two jobs.
+# Buggy result: parse warning on flow value overflow, no 1/8 division between
+#			jobs.
+#
+
+[global]
+bs=4k
+ioengine=null
+size=100g
+runtime=3
+flow_id=1
+gtod_cpu=1
+
+[flow1]
+flow=-8
+rate_iops=1000
+
+[flow2]
+flow=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index c2352d80..ae2cb096 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -420,14 +420,14 @@ class FioJobTest_t0009(FioJobTest):
             self.passed = False
 
 
-class FioJobTest_t0011(FioJobTest):
+class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
     and that job1_iops / job0_iops ~ 8
     With two runs of fio-3.16 I observed a ratio of 8.3"""
 
     def check_result(self):
-        super(FioJobTest_t0011, self).check_result()
+        super(FioJobTest_iops_rate, self).check_result()
 
         if not self.passed:
             return
@@ -438,7 +438,7 @@ class FioJobTest_t0011(FioJobTest):
         logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
-        if iops1 < 997 or iops1 > 1003:
+        if iops1 < 995 or iops1 > 1005:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
@@ -667,7 +667,7 @@ TEST_LIST = [
     },
     {
         'test_id':          11,
-        'test_class':       FioJobTest_t0011,
+        'test_class':       FioJobTest_iops_rate,
         'job':              't0011-5d2788d5.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
@@ -675,6 +675,18 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          12,
+        'test_class':       FioJobTest_iops_rate,
+        'job':              't0012.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+        'requirements':     [Requirements.not_macos],
+        # mac os does not support CPU affinity
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/verify.c b/verify.c
index b7fa6693..5ee0029d 100644
--- a/verify.c
+++ b/verify.c
@@ -8,6 +8,7 @@
 #include <pthread.h>
 #include <libgen.h>
 
+#include "arch/arch.h"
 #include "fio.h"
 #include "verify.h"
 #include "trim.h"
@@ -1309,8 +1310,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		/*
 		 * Ensure that the associated IO has completed
 		 */
-		read_barrier();
-		if (ipo->flags & IP_F_IN_FLIGHT)
+		if (atomic_load_acquire(&ipo->flags) & IP_F_IN_FLIGHT)
 			goto nothing;
 
 		rb_erase(n, &td->io_hist_tree);
@@ -1322,8 +1322,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		/*
 		 * Ensure that the associated IO has completed
 		 */
-		read_barrier();
-		if (ipo->flags & IP_F_IN_FLIGHT)
+		if (atomic_load_acquire(&ipo->flags) & IP_F_IN_FLIGHT)
 			goto nothing;
 
 		flist_del(&ipo->list);

