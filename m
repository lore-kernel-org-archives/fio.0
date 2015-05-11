Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51317 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbbEKMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 May 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YrmNT-000078-E0
	for fio@vger.kernel.org; Mon, 11 May 2015 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150511120001.B01992C1079@kernel.dk>
Date: Mon, 11 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 94d8288ef299b544d518da69f21a6df9a04eb086:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2015-05-08 09:21:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bddc8d161ac433712d601765dbf455349f9dada1:

  workqueue: style cleanup (2015-05-10 11:16:40 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      workqueue: style cleanup

 workqueue.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/workqueue.c b/workqueue.c
index 92088ba..b9a967f 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -401,13 +401,8 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 			break;
 
 	wq->max_workers = i;
-	if (!wq->max_workers) {
-err:
-		log_err("Can't create rate workqueue\n");
-		td_verror(td, ESRCH, "workqueue_init");
-		workqueue_exit(wq);
-		return 1;
-	}
+	if (!wq->max_workers)
+		goto err;
 
 	/*
 	 * Wait for them all to be started and initialized
@@ -437,8 +432,12 @@ err:
 		pthread_mutex_unlock(&wq->flush_lock);
 	} while (1);
 
-	if (error)
-		goto err;
+	if (!error)
+		return 0;
 
-	return 0;
+err:
+	log_err("Can't create rate workqueue\n");
+	td_verror(td, ESRCH, "workqueue_init");
+	workqueue_exit(wq);
+	return 1;
 }
