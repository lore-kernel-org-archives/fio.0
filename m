Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59912 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750841AbcJYMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 25 Oct 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bz0Oh-0003b2-Uu
        for fio@vger.kernel.org; Tue, 25 Oct 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161025120002.65E432C302F@kernel.dk>
Date: Tue, 25 Oct 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca0122d822ea7dd573f05ca4cf43c5d0ff9f4adb:

  backend: if we can't grab stat_mutex, report a deadlock error and exit (2016-10-23 08:35:14 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 43f248c4527a49d3de0cd758ce669f7736028ea4:

  Use the POSIX `EDEADLK` instead of the Linux `EDEADLOCK` (2016-10-24 20:48:43 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Use the POSIX `EDEADLK` instead of the Linux `EDEADLOCK`

Jens Axboe (3):
      mutex: clear mutex when removed
      fio: make job reap timeout 5 minutes
      backend: end IO loop early, if the job is marked as terminated

 backend.c | 10 +++++++++-
 fio.h     |  2 +-
 mutex.c   |  6 ++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 093b6a3..ed4f1f0 100644
--- a/backend.c
+++ b/backend.c
@@ -1723,6 +1723,14 @@ static void *thread_main(void *data)
 			}
 		}
 
+		/*
+		 * If we took too long to shut down, the main thread could
+		 * already consider us reaped/exited. If that happens, break
+		 * out and clean up.
+		 */
+		if (td->runstate >= TD_EXITED)
+			break;
+
 		clear_state = 1;
 
 		/*
@@ -1740,7 +1748,7 @@ static void *thread_main(void *data)
 			usleep(1000);
 			if (deadlock_loop_cnt++ > 5000) {
 				log_err("fio seems to be stuck grabbing stat_mutex, forcibly exiting\n");
-				td->error = EDEADLOCK;
+				td->error = EDEADLK;
 				goto err;
 			}
 		} while (1);
diff --git a/fio.h b/fio.h
index 080842a..74c1b30 100644
--- a/fio.h
+++ b/fio.h
@@ -588,7 +588,7 @@ extern const char *runstate_to_name(int runstate);
  * Allow 60 seconds for a job to quit on its own, otherwise reap with
  * a vengeance.
  */
-#define FIO_REAP_TIMEOUT	60
+#define FIO_REAP_TIMEOUT	300
 
 #define TERMINATE_ALL		(-1U)
 extern void fio_terminate_threads(unsigned int);
diff --git a/mutex.c b/mutex.c
index 7580922..e5b045e 100644
--- a/mutex.c
+++ b/mutex.c
@@ -22,6 +22,12 @@ void __fio_mutex_remove(struct fio_mutex *mutex)
 {
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 	pthread_cond_destroy(&mutex->cond);
+
+	/*
+	 * Ensure any subsequent attempt to grab this mutex will fail
+	 * with an assert, instead of just silently hanging.
+	 */
+	memset(mutex, 0, sizeof(*mutex));
 }
 
 void fio_mutex_remove(struct fio_mutex *mutex)
