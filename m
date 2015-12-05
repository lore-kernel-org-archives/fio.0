Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47906 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbLENAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 5 Dec 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a4qr2-00055E-LK
	for fio@vger.kernel.org; Fri, 04 Dec 2015 13:56:56 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151205130001.D838B2C00DF@kernel.dk>
Date: Sat,  5 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0b139881150f7179688243c224a07b57eedbdfa0:

  posix_fadvise() returns positive error values (2015-12-03 15:08:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a6a3469ea8753a999b9bb9bea33299700d3094eb:

  workqueue: fix potential ABBA deadlock in stats summing (2015-12-04 13:15:36 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      io_u: make io_u_quiesce() return how many IOs it completed
      workqueue: properly account ->cur_depth
      workqueue: fix potential ABBA deadlock in stats summing

Li Zhong (1):
      powerpc: enable cpu clock for powerpc64

 arch/arch-ppc.h | 24 ++++++++++++++++++++++++
 backend.c       | 30 ++++++++++++++++++++++++++----
 io_u.c          | 10 ++++++++--
 ioengine.h      |  2 +-
 workqueue.c     | 38 +++++++++++++++++++++++++++++---------
 5 files changed, 88 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index aed41f9..161c39c 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -67,6 +67,21 @@ static inline unsigned int mfspr(unsigned int reg)
 #define SPRN_ATBL  0x20E /* Alternate Time Base Lower */
 #define SPRN_ATBU  0x20F /* Alternate Time Base Upper */
 
+#ifdef __powerpc64__
+static inline unsigned long long get_cpu_clock(void)
+{
+	unsigned long long rval;
+
+	asm volatile(
+		"90:	mfspr %0, %1;\n"
+		"	cmpwi %0,0;\n"
+		"	beq-  90b;\n"
+	: "=r" (rval)
+	: "i" (SPRN_TBRL));
+
+	return rval;
+}
+#else
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned int tbl, tbu0, tbu1;
@@ -87,6 +102,7 @@ static inline unsigned long long get_cpu_clock(void)
 	ret = (((unsigned long long)tbu0) << 32) | tbl;
 	return ret;
 }
+#endif
 
 #if 0
 static void atb_child(void)
@@ -136,4 +152,12 @@ static inline int arch_init(char *envp[])
  * #define ARCH_HAVE_CPU_CLOCK
  */
 
+/*
+ * Let's have it defined for ppc64
+ */
+
+#ifdef __powerpc64__
+#define ARCH_HAVE_CPU_CLOCK
+#endif
+
 #endif
diff --git a/backend.c b/backend.c
index 4a689eb..10622ef 100644
--- a/backend.c
+++ b/backend.c
@@ -1358,16 +1358,38 @@ static void io_workqueue_fn(struct thread_data *td, struct io_u *io_u)
 
 	td->cur_depth++;
 
-	ret = td_io_queue(td, io_u);
+	do {
+		ret = td_io_queue(td, io_u);
+		if (ret != FIO_Q_BUSY)
+			break;
+		ret = io_u_queued_complete(td, 1);
+		if (ret > 0)
+			td->cur_depth -= ret;
+		io_u_clear(io_u, IO_U_F_FLIGHT);
+	} while (1);
 
 	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
 
 	io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
 
-	if (ret == FIO_Q_QUEUED)
-		ret = io_u_queued_complete(td, 1);
+	if (ret == FIO_Q_COMPLETED)
+		td->cur_depth--;
+	else if (ret == FIO_Q_QUEUED) {
+		unsigned int min_evts;
 
-	td->cur_depth--;
+		if (td->o.iodepth == 1)
+			min_evts = 1;
+		else
+			min_evts = 0;
+
+		ret = io_u_queued_complete(td, min_evts);
+		if (ret > 0)
+			td->cur_depth -= ret;
+	} else if (ret == FIO_Q_BUSY) {
+		ret = io_u_queued_complete(td, td->cur_depth);
+		if (ret > 0)
+			td->cur_depth -= ret;
+	}
 }
 
 /*
diff --git a/io_u.c b/io_u.c
index d45a6f0..f86367b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -542,8 +542,10 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 	return DDIR_WRITE;
 }
 
-void io_u_quiesce(struct thread_data *td)
+int io_u_quiesce(struct thread_data *td)
 {
+	int completed = 0;
+
 	/*
 	 * We are going to sleep, ensure that we flush anything pending as
 	 * not to skew our latency numbers.
@@ -563,7 +565,11 @@ void io_u_quiesce(struct thread_data *td)
 		int fio_unused ret;
 
 		ret = io_u_queued_complete(td, 1);
+		if (ret > 0)
+			completed += ret;
 	}
+
+	return completed;
 }
 
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
@@ -1856,7 +1862,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
 	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
 		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/ioengine.h b/ioengine.h
index c557f7a..37f0336 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -214,7 +214,7 @@ extern void requeue_io_u(struct thread_data *, struct io_u **);
 extern int __must_check io_u_sync_complete(struct thread_data *, struct io_u *);
 extern int __must_check io_u_queued_complete(struct thread_data *, int);
 extern void io_u_queued(struct thread_data *, struct io_u *);
-extern void io_u_quiesce(struct thread_data *);
+extern int io_u_quiesce(struct thread_data *);
 extern void io_u_log_error(struct thread_data *, struct io_u *);
 extern void io_u_mark_depth(struct thread_data *, unsigned int);
 extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned int);
diff --git a/workqueue.c b/workqueue.c
index 3442375..7cd83bf 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -217,13 +217,32 @@ static void sum_val(uint64_t *dst, uint64_t *src)
 }
 #endif
 
-static void sum_ddir(struct thread_data *dst, struct thread_data *src,
-		     enum fio_ddir ddir)
+static void pthread_double_unlock(pthread_mutex_t *lock1,
+				  pthread_mutex_t *lock2)
+{
+#ifndef CONFIG_SFAA
+	pthread_mutex_unlock(lock1);
+	pthread_mutex_unlock(lock2);
+#endif
+}
+
+static void pthread_double_lock(pthread_mutex_t *lock1, pthread_mutex_t *lock2)
 {
 #ifndef CONFIG_SFAA
-	pthread_mutex_lock(&dst->io_wq.stat_lock);
-	pthread_mutex_lock(&src->io_wq.stat_lock);
+	if (lock1 < lock2) {
+		pthread_mutex_lock(lock1);
+		pthread_mutex_lock(lock2);
+	} else {
+		pthread_mutex_lock(lock2);
+		pthread_mutex_lock(lock1);
+	}
 #endif
+}
+
+static void sum_ddir(struct thread_data *dst, struct thread_data *src,
+		     enum fio_ddir ddir)
+{
+	pthread_double_lock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
 
 	sum_val(&dst->io_bytes[ddir], &src->io_bytes[ddir]);
 	sum_val(&dst->io_blocks[ddir], &src->io_blocks[ddir]);
@@ -231,10 +250,7 @@ static void sum_ddir(struct thread_data *dst, struct thread_data *src,
 	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
 	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
 
-#ifndef CONFIG_SFAA
-	pthread_mutex_unlock(&src->io_wq.stat_lock);
-	pthread_mutex_unlock(&dst->io_wq.stat_lock);
-#endif
+	pthread_double_unlock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
 }
 
 static void update_accounting(struct submit_worker *sw)
@@ -283,8 +299,12 @@ static void *worker_thread(void *data)
 
 			if (td->io_u_queued || td->cur_depth ||
 			    td->io_u_in_flight) {
+				int ret;
+
 				pthread_mutex_unlock(&sw->lock);
-				io_u_quiesce(td);
+				ret = io_u_quiesce(td);
+				if (ret > 0)
+					td->cur_depth -= ret;
 				pthread_mutex_lock(&sw->lock);
 			}
 
