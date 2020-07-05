Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGEMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 5 Jul 2020 08:00:08 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC99C061794
        for <fio@vger.kernel.org>; Sun,  5 Jul 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1js3JV-0005kj-HN
        for fio@vger.kernel.org; Sun, 05 Jul 2020 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200705120002.3AEC21BC018D@kernel.dk>
Date: Sun,  5 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a504a3902e00b6db0183872b0ff62e35abae7119:

  configure: fix bad indentation (2020-07-03 08:34:56 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 430083bf2a3db52bcb374919140d3a978391fbf0:

  Merge branch 'windows' of https://github.com/bvanassche/fio (2020-07-04 17:29:32 -0600)

----------------------------------------------------------------
Bart Van Assche (9):
      .appveyor.yml: Select the latest software image
      t/run-fio-tests.py: Increase IOPS tolerance further
      Fix a potentially infinite loop in check_overlap()
      Enable error checking for the mutex that serializes overlapping I/O
      Add a test for serialize_overlap=1
      workqueue: Rework while loop locking
      workqueue: Fix race conditions in the workqueue mechanism
      os/windows/posix.c: Strip trailing whitespace
      os/windows/posix.c: Use INVALID_SOCKET instead of < 0

Jens Axboe (3):
      Merge branch 'overlap' of https://github.com/bvanassche/fio
      Merge branch 'workqueue' of https://github.com/bvanassche/fio
      Merge branch 'windows' of https://github.com/bvanassche/fio

 .appveyor.yml      |  3 +++
 backend.c          | 18 ++++++++++-----
 ioengines.c        |  6 +++--
 os/windows/posix.c |  8 +++----
 rate-submit.c      | 66 ++++++++++++++++++++++++++++--------------------------
 t/jobs/t0013.fio   | 14 ++++++++++++
 t/run-fio-tests.py | 19 +++++++++++++++-
 workqueue.c        | 50 +++++++++++++++++++++--------------------
 8 files changed, 116 insertions(+), 68 deletions(-)
 create mode 100644 t/jobs/t0013.fio

---

Diff of recent changes:

diff --git a/.appveyor.yml b/.appveyor.yml
index 70c337f8..5f4a33e2 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -1,5 +1,8 @@
 clone_depth: 1 # NB: this stops FIO-VERSION-GEN making tag based versions
 
+image:
+  - Visual Studio 2019
+
 environment:
   CYG_MIRROR: http://cygwin.mirror.constant.com
   CYG_ROOT: C:\cygwin64
diff --git a/backend.c b/backend.c
index 0075a733..0e454cdd 100644
--- a/backend.c
+++ b/backend.c
@@ -66,7 +66,11 @@ unsigned int stat_number = 0;
 int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
+#ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
+pthread_mutex_t overlap_check = PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP;
+#else
 pthread_mutex_t overlap_check = PTHREAD_MUTEX_INITIALIZER;
+#endif
 
 #define JOB_START_TIMEOUT	(5 * 1000)
 
@@ -1535,7 +1539,7 @@ static void *thread_main(void *data)
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 	int deadlock_loop_cnt;
 	bool clear_state;
-	int ret;
+	int res, ret;
 
 	sk_out_assign(sk_out);
 	free(fd);
@@ -1860,11 +1864,15 @@ static void *thread_main(void *data)
 	 * offload mode so that we don't clean up this job while
 	 * another thread is checking its io_u's for overlap
 	 */
-	if (td_offload_overlap(td))
-		pthread_mutex_lock(&overlap_check);
+	if (td_offload_overlap(td)) {
+		int res = pthread_mutex_lock(&overlap_check);
+		assert(res == 0);
+	}
 	td_set_runstate(td, TD_FINISHING);
-	if (td_offload_overlap(td))
-		pthread_mutex_unlock(&overlap_check);
+	if (td_offload_overlap(td)) {
+		res = pthread_mutex_unlock(&overlap_check);
+		assert(res == 0);
+	}
 
 	update_rusage_stat(td);
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
diff --git a/ioengines.c b/ioengines.c
index c1b430a1..1c5970a4 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -313,8 +313,10 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 	 * started the overlap check because the IO_U_F_FLIGHT
 	 * flag is now set
 	 */
-	if (td_offload_overlap(td))
-		pthread_mutex_unlock(&overlap_check);
+	if (td_offload_overlap(td)) {
+		int res = pthread_mutex_unlock(&overlap_check);
+		assert(res == 0);
+	}
 
 	assert(fio_file_open(io_u->file));
 
diff --git a/os/windows/posix.c b/os/windows/posix.c
index e36453e9..31271de0 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -750,7 +750,7 @@ int setgid(gid_t gid)
 int nice(int incr)
 {
 	DWORD prioclass = NORMAL_PRIORITY_CLASS;
-	
+
 	if (incr < -15)
 		prioclass = HIGH_PRIORITY_CLASS;
 	else if (incr < 0)
@@ -759,7 +759,7 @@ int nice(int incr)
 		prioclass = IDLE_PRIORITY_CLASS;
 	else if (incr > 0)
 		prioclass = BELOW_NORMAL_PRIORITY_CLASS;
-	
+
 	if (!SetPriorityClass(GetCurrentProcess(), prioclass))
 		log_err("fio: SetPriorityClass failed\n");
 
@@ -883,7 +883,7 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 	FD_ZERO(&exceptfds);
 
 	for (i = 0; i < nfds; i++) {
-		if (fds[i].fd < 0) {
+		if (fds[i].fd == INVALID_SOCKET) {
 			fds[i].revents = 0;
 			continue;
 		}
@@ -900,7 +900,7 @@ int poll(struct pollfd fds[], nfds_t nfds, int timeout)
 
 	if (rc != SOCKET_ERROR) {
 		for (i = 0; i < nfds; i++) {
-			if (fds[i].fd < 0)
+			if (fds[i].fd == INVALID_SOCKET)
 				continue;
 
 			if ((fds[i].events & POLLIN) && FD_ISSET(fds[i].fd, &readfds))
diff --git a/rate-submit.c b/rate-submit.c
index cf00d9bc..b7b70372 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2015 Jens Axboe <axboe@kernel.dk>
  *
  */
+#include <assert.h>
 #include "fio.h"
 #include "ioengines.h"
 #include "lib/getrusage.h"
@@ -11,40 +12,41 @@
 
 static void check_overlap(struct io_u *io_u)
 {
-	int i;
+	int i, res;
 	struct thread_data *td;
-	bool overlap = false;
 
-	do {
-		/*
-		 * Allow only one thread to check for overlap at a
-		 * time to prevent two threads from thinking the coast
-		 * is clear and then submitting IOs that overlap with
-		 * each other
-		 *
-		 * If an overlap is found, release the lock and
-		 * re-acquire it before checking again to give other
-		 * threads a chance to make progress
-		 *
-		 * If an overlap is not found, release the lock when the
-		 * io_u's IO_U_F_FLIGHT flag is set so that this io_u
-		 * can be checked by other threads as they assess overlap
-		 */
-		pthread_mutex_lock(&overlap_check);
-		for_each_td(td, i) {
-			if (td->runstate <= TD_SETTING_UP ||
-				td->runstate >= TD_FINISHING ||
-				!td->o.serialize_overlap ||
-				td->o.io_submit_mode != IO_MODE_OFFLOAD)
-				continue;
-
-			overlap = in_flight_overlap(&td->io_u_all, io_u);
-			if (overlap) {
-				pthread_mutex_unlock(&overlap_check);
-				break;
-			}
-		}
-	} while (overlap);
+	/*
+	 * Allow only one thread to check for overlap at a time to prevent two
+	 * threads from thinking the coast is clear and then submitting IOs
+	 * that overlap with each other.
+	 *
+	 * If an overlap is found, release the lock and re-acquire it before
+	 * checking again to give other threads a chance to make progress.
+	 *
+	 * If no overlap is found, release the lock when the io_u's
+	 * IO_U_F_FLIGHT flag is set so that this io_u can be checked by other
+	 * threads as they assess overlap.
+	 */
+	res = pthread_mutex_lock(&overlap_check);
+	assert(res == 0);
+
+retry:
+	for_each_td(td, i) {
+		if (td->runstate <= TD_SETTING_UP ||
+		    td->runstate >= TD_FINISHING ||
+		    !td->o.serialize_overlap ||
+		    td->o.io_submit_mode != IO_MODE_OFFLOAD)
+			continue;
+
+		if (!in_flight_overlap(&td->io_u_all, io_u))
+			continue;
+
+		res = pthread_mutex_unlock(&overlap_check);
+		assert(res == 0);
+		res = pthread_mutex_lock(&overlap_check);
+		assert(res == 0);
+		goto retry;
+	}
 }
 
 static int io_workqueue_fn(struct submit_worker *sw,
diff --git a/t/jobs/t0013.fio b/t/jobs/t0013.fio
new file mode 100644
index 00000000..b4ec1b42
--- /dev/null
+++ b/t/jobs/t0013.fio
@@ -0,0 +1,14 @@
+# Trigger the fio code that serializes overlapping I/O. The job size is very
+# small to make overlapping I/O more likely.
+
+[test]
+ioengine=null
+thread=1
+size=4K
+blocksize=4K
+io_submit_mode=offload
+iodepth=1
+serialize_overlap=1
+numjobs=8
+loops=1000000
+runtime=10
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index ae2cb096..c116bf5a 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -438,7 +438,7 @@ class FioJobTest_iops_rate(FioJobTest):
         logging.debug("Test %d: iops1: %f", self.testnum, iops1)
         logging.debug("Test %d: ratio: %f", self.testnum, ratio)
 
-        if iops1 < 995 or iops1 > 1005:
+        if iops1 < 950 or iops1 > 1050:
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
@@ -447,6 +447,13 @@ class FioJobTest_iops_rate(FioJobTest):
             self.passed = False
 
 
+class FioJobTest_t0013(FioJobTest):
+    """Runs fio test job t0013"""
+
+    def check_result(self):
+        super(FioJobTest_t0013, self).check_result()
+
+
 class Requirements(object):
     """Requirements consists of multiple run environment characteristics.
     These are to determine if a particular test can be run"""
@@ -687,6 +694,16 @@ TEST_LIST = [
         'requirements':     [Requirements.not_macos],
         # mac os does not support CPU affinity
     },
+    {
+        'test_id':          13,
+        'test_class':       FioJobTest_t0013,
+        'job':              't0013.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/workqueue.c b/workqueue.c
index b5959512..9e6c41ff 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -85,15 +85,14 @@ static bool all_sw_idle(struct workqueue *wq)
  */
 void workqueue_flush(struct workqueue *wq)
 {
+	pthread_mutex_lock(&wq->flush_lock);
 	wq->wake_idle = 1;
 
-	while (!all_sw_idle(wq)) {
-		pthread_mutex_lock(&wq->flush_lock);
+	while (!all_sw_idle(wq))
 		pthread_cond_wait(&wq->flush_cond, &wq->flush_lock);
-		pthread_mutex_unlock(&wq->flush_lock);
-	}
 
 	wq->wake_idle = 0;
+	pthread_mutex_unlock(&wq->flush_lock);
 }
 
 /*
@@ -159,12 +158,10 @@ static void *worker_thread(void *data)
 	if (sw->flags & SW_F_ERROR)
 		goto done;
 
+	pthread_mutex_lock(&sw->lock);
 	while (1) {
-		pthread_mutex_lock(&sw->lock);
-
 		if (flist_empty(&sw->work_list)) {
 			if (sw->flags & SW_F_EXIT) {
-				pthread_mutex_unlock(&sw->lock);
 				break;
 			}
 
@@ -173,34 +170,41 @@ static void *worker_thread(void *data)
 				workqueue_pre_sleep(sw);
 				pthread_mutex_lock(&sw->lock);
 			}
-
-			/*
-			 * We dropped and reaquired the lock, check
-			 * state again.
-			 */
-			if (!flist_empty(&sw->work_list))
-				goto handle_work;
-
+		}
+		/*
+		 * We may have dropped and reaquired the lock, check state
+		 * again.
+		 */
+		if (flist_empty(&sw->work_list)) {
 			if (sw->flags & SW_F_EXIT) {
-				pthread_mutex_unlock(&sw->lock);
 				break;
-			} else if (!(sw->flags & SW_F_IDLE)) {
+			}
+			if (!(sw->flags & SW_F_IDLE)) {
 				sw->flags |= SW_F_IDLE;
 				wq->next_free_worker = sw->index;
+				pthread_mutex_unlock(&sw->lock);
+				pthread_mutex_lock(&wq->flush_lock);
 				if (wq->wake_idle)
 					pthread_cond_signal(&wq->flush_cond);
+				pthread_mutex_unlock(&wq->flush_lock);
+				pthread_mutex_lock(&sw->lock);
+			}
+		}
+		if (flist_empty(&sw->work_list)) {
+			if (sw->flags & SW_F_EXIT) {
+				break;
 			}
-
 			pthread_cond_wait(&sw->cond, &sw->lock);
 		} else {
-handle_work:
 			flist_splice_init(&sw->work_list, &local_list);
 		}
 		pthread_mutex_unlock(&sw->lock);
 		handle_list(sw, &local_list);
 		if (wq->ops.update_acct_fn)
 			wq->ops.update_acct_fn(sw);
+		pthread_mutex_lock(&sw->lock);
 	}
+	pthread_mutex_unlock(&sw->lock);
 
 done:
 	sk_out_drop();
@@ -336,11 +340,11 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 	 * Wait for them all to be started and initialized
 	 */
 	error = 0;
+	pthread_mutex_lock(&wq->flush_lock);
 	do {
 		struct submit_worker *sw;
 
 		running = 0;
-		pthread_mutex_lock(&wq->flush_lock);
 		for (i = 0; i < wq->max_workers; i++) {
 			sw = &wq->workers[i];
 			pthread_mutex_lock(&sw->lock);
@@ -351,14 +355,12 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 			pthread_mutex_unlock(&sw->lock);
 		}
 
-		if (error || running == wq->max_workers) {
-			pthread_mutex_unlock(&wq->flush_lock);
+		if (error || running == wq->max_workers)
 			break;
-		}
 
 		pthread_cond_wait(&wq->flush_cond, &wq->flush_lock);
-		pthread_mutex_unlock(&wq->flush_lock);
 	} while (1);
+	pthread_mutex_unlock(&wq->flush_lock);
 
 	if (!error)
 		return 0;

