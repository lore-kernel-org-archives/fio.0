Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbcCZMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 26 Mar 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ajmst-0000Mi-Ao
	for fio@vger.kernel.org; Sat, 26 Mar 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160326120001.CBAE52C0114@kernel.dk>
Date: Sat, 26 Mar 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae46d0f5618d1d2e63d0a733b79f136d88ccac90:

  t/memlock: sample utility to use X memory from Y threads (2016-03-24 17:07:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 53280a1dc785ef0447aa5cf8e32e899ecfc22978:

  t/read-to-pipe-async: use gettimeofday() instead of clock_gettime() (2016-03-25 09:40:41 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      t/read-to-pipe-async: synchronization fixes
      t/read-to-pipe-async: use gettimeofday() instead of clock_gettime()

 t/read-to-pipe-async.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index 30a7631..e8bdc85 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -32,7 +32,6 @@
 #include <pthread.h>
 #include <errno.h>
 #include <assert.h>
-#include <time.h>
 
 #include "../flist.h"
 
@@ -231,6 +230,12 @@ static int write_work(struct work_item *work)
 	return work->seq + 1;
 }
 
+static void thread_exiting(struct thread_data *thread)
+{
+	__sync_fetch_and_add(&thread->done, 1);
+	pthread_cond_signal(&thread->done_cond);
+}
+
 static void *writer_fn(void *data)
 {
 	struct writer_thread *wt = data;
@@ -258,8 +263,7 @@ static void *writer_fn(void *data)
 			seq = write_work(work);
 	}
 
-	wt->thread.done = 1;
-	pthread_cond_signal(&wt->thread.done_cond);
+	thread_exiting(&wt->thread);
 	return NULL;
 }
 
@@ -361,14 +365,13 @@ static void *reader_fn(void *data)
 		pthread_mutex_unlock(&rt->thread.lock);
 
 		if (work) {
-			rt->busy = 1;
+			__sync_fetch_and_add(&rt->busy, 1);
 			reader_work(work);
-			rt->busy = 0;
+			__sync_fetch_and_sub(&rt->busy, 1);
 		}
 	}
 
-	rt->thread.done = 1;
-	pthread_cond_signal(&rt->thread.done_cond);
+	thread_exiting(&rt->thread);
 	return NULL;
 }
 
@@ -469,20 +472,21 @@ static void exit_thread(struct thread_data *thread,
 			void fn(struct writer_thread *),
 			struct writer_thread *wt)
 {
-	thread->exit = 1;
+	__sync_fetch_and_add(&thread->exit, 1);
 	pthread_cond_signal(&thread->cond);
 
 	while (!thread->done) {
 		pthread_mutex_lock(&thread->done_lock);
 
 		if (fn) {
-			struct timespec t;
-
-			clock_gettime(CLOCK_REALTIME, &t);
-			t.tv_sec++;
+			struct timeval tv;
+			struct timespec ts;
 
+			gettimeofday(&tv, NULL);
+			ts.tv_sec = tv.tv_sec + 1;
+			ts.tv_nsec = tv.tv_usec * 1000ULL;
 
-			pthread_cond_timedwait(&thread->done_cond, &thread->done_lock, &t);
+			pthread_cond_timedwait(&thread->done_cond, &thread->done_lock, &ts);
 			fn(wt);
 		} else
 			pthread_cond_wait(&thread->done_cond, &thread->done_lock);
@@ -606,7 +610,8 @@ int main(int argc, char *argv[])
 	while (sb.st_size) {
 		struct work_item *work;
 		size_t this_len;
-		struct timespec t;
+		struct timespec ts;
+		struct timeval tv;
 
 		prune_done_entries(wt);
 
@@ -627,15 +632,17 @@ int main(int argc, char *argv[])
 
 		queue_work(rt, work);
 
-		clock_gettime(CLOCK_REALTIME, &t);
-		t.tv_nsec += max_us * 1000ULL;
-		if (t.tv_nsec >= 1000000000ULL) {
-			t.tv_nsec -= 1000000000ULL;
-			t.tv_sec++;
+		gettimeofday(&tv, NULL);
+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec * 1000ULL;
+		ts.tv_nsec += max_us * 1000ULL;
+		if (ts.tv_nsec >= 1000000000ULL) {
+			ts.tv_nsec -= 1000000000ULL;
+			ts.tv_sec++;
 		}
 
 		pthread_mutex_lock(&work->lock);
-		pthread_cond_timedwait(&work->cond, &work->lock, &t);
+		pthread_cond_timedwait(&work->cond, &work->lock, &ts);
 		pthread_mutex_unlock(&work->lock);
 
 		off += this_len;
