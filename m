Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57020 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2999140AbdDZMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 26 Apr 2017 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d3LcB-0004Tl-Bj
        for fio@vger.kernel.org; Wed, 26 Apr 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170426120001.D9AD12C1710@kernel.dk>
Date: Wed, 26 Apr 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d7658cedd1f31d1285f1f1e1cfe42fabb7cd6c8f:

  Return non-negtive error in order to print right error msg (2017-04-19 20:34:19 +0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 306fea38fa61c305703d0269b1fc8e7da3b91a1f:

  stat: make next log time decision cleaner (2017-04-25 18:14:00 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      stat: make next log time decision cleaner

 stat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index fde7af2..27d1fea 100644
--- a/stat.c
+++ b/stat.c
@@ -2479,9 +2479,10 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.bw_avg_time)
-		return min(next_log, td->o.bw_avg_time);
+		next = td->o.bw_avg_time;
+	else
+		next = td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
 
-	next = td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
 	return min(next, next_log);
 }
 
@@ -2554,9 +2555,10 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.iops_avg_time)
-		return min(next_log, td->o.iops_avg_time);
+		next = td->o.iops_avg_time;
+	else
+		next = td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
 
-	next = td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
 	return min(next, next_log);
 }
 
