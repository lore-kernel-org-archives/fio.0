Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57222 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdL2NA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Dec 2017 08:00:28 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eUuGx-0002Gd-8R
        for fio@vger.kernel.org; Fri, 29 Dec 2017 13:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171229130002.32E872C009F@kernel.dk>
Date: Fri, 29 Dec 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f7c305464667b118b62aff9b846d1a939fbc1547:

  Merge branch 'eta_display' of https://github.com/sitsofe/fio (2017-12-27 14:05:46 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e38feac48ffb7a45c847cabd31ab5eab7fe05a4e:

  Merge branch 'master' of https://github.com/yashi/fio (2017-12-28 08:35:11 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/yashi/fio

Yasushi SHOJI (1):
      mutex: down_timeout: check against the base time

 mutex.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/mutex.c b/mutex.c
index 9fab715..63229ed 100644
--- a/mutex.c
+++ b/mutex.c
@@ -156,14 +156,15 @@ static bool mutex_timed_out(struct timespec *t, unsigned int msecs)
 int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 {
 	struct timeval tv_s;
+	struct timespec base;
 	struct timespec t;
 	int ret = 0;
 
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 
 	gettimeofday(&tv_s, NULL);
-	t.tv_sec = tv_s.tv_sec;
-	t.tv_nsec = tv_s.tv_usec * 1000;
+	base.tv_sec = t.tv_sec = tv_s.tv_sec;
+	base.tv_nsec = t.tv_nsec = tv_s.tv_usec * 1000;
 
 	t.tv_sec += msecs / 1000;
 	t.tv_nsec += ((msecs * 1000000ULL) % 1000000000);
@@ -181,7 +182,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 		 * way too early, double check.
 		 */
 		ret = pthread_cond_timedwait(&mutex->cond, &mutex->lock, &t);
-		if (ret == ETIMEDOUT && !mutex_timed_out(&t, msecs))
+		if (ret == ETIMEDOUT && !mutex_timed_out(&base, msecs))
 			ret = 0;
 	}
 	mutex->waiters--;
