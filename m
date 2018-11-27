Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55164 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbeK0X6A (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Nov 2018 18:58:00 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gRcyG-0002eC-Cx
        for fio@vger.kernel.org; Tue, 27 Nov 2018 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181127130001.B35602C0119@kernel.dk>
Date: Tue, 27 Nov 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 41dd12d62f43160bc8d8574127d0c2b861e1ee1d:

  options: fix 'kb_base' being of the wrong type (2018-11-25 09:56:06 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4cf30b66c62f3f5e6501390d564cf0d966823591:

  workqueue: update IO counters promptly after handling IO (2018-11-26 09:16:52 -0700)

----------------------------------------------------------------
Vincent Fu (1):
      workqueue: update IO counters promptly after handling IO

 workqueue.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/workqueue.c b/workqueue.c
index faed245..b595951 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -190,8 +190,6 @@ static void *worker_thread(void *data)
 				if (wq->wake_idle)
 					pthread_cond_signal(&wq->flush_cond);
 			}
-			if (wq->ops.update_acct_fn)
-				wq->ops.update_acct_fn(sw);
 
 			pthread_cond_wait(&sw->cond, &sw->lock);
 		} else {
@@ -200,11 +198,10 @@ handle_work:
 		}
 		pthread_mutex_unlock(&sw->lock);
 		handle_list(sw, &local_list);
+		if (wq->ops.update_acct_fn)
+			wq->ops.update_acct_fn(sw);
 	}
 
-	if (wq->ops.update_acct_fn)
-		wq->ops.update_acct_fn(sw);
-
 done:
 	sk_out_drop();
 	return NULL;

