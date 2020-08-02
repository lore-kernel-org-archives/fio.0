Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726578AbgHBMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 Aug 2020 08:00:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9627CC06174A
        for <fio@vger.kernel.org>; Sun,  2 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k2Cer-0006pW-Kr
        for fio@vger.kernel.org; Sun, 02 Aug 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200802120001.640621BC01CB@kernel.dk>
Date: Sun,  2 Aug 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b5aba537d844f73187eb931179ac59e7da570e7c:

  iolog: ensure that dynamic log entries are at least queue depth sized (2020-07-27 16:00:20 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 87622bf5295880682bfad5ba14116cf5facbaf2c:

  Merge branch 'master' of https://github.com/bvanassche/fio into master (2020-08-01 15:07:38 -0600)

----------------------------------------------------------------
Bart Van Assche (1):
      Prevent that fio hangs when using io_submit_mode=offload

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio into master

 rate-submit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/rate-submit.c b/rate-submit.c
index b7b70372..13dbe7a2 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -97,8 +97,11 @@ static int io_workqueue_fn(struct submit_worker *sw,
 			td->cur_depth -= ret;
 	}
 
-	if (error || td->error)
+	if (error || td->error) {
+		pthread_mutex_lock(&td->io_u_lock);
 		pthread_cond_signal(&td->parent->free_cond);
+		pthread_mutex_unlock(&td->io_u_lock);
+	}
 
 	return 0;
 }

