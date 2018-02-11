Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37362 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752597AbeBKNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 11 Feb 2018 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1ekrEn-0004kd-0i
        for fio@vger.kernel.org; Sun, 11 Feb 2018 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180211130001.E28592C00B7@kernel.dk>
Date: Sun, 11 Feb 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0cf542af81751d7b318afe4429001c1aab6baee5:

  Include 'numjobs' in global options output (2018-02-08 15:46:46 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3c0a8bc2f33ba721a97b459d5b32acbf4460450f:

  init: fixup some bad style in previous commit (2018-02-10 14:44:49 -0700)

----------------------------------------------------------------
Damian Yurzola (1):
      init: fix broken verify_interval

Jens Axboe (1):
      init: fixup some bad style in previous commit

 init.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index ae3c4f7..25661be 100644
--- a/init.c
+++ b/init.c
@@ -802,11 +802,12 @@ static int fixup_options(struct thread_data *td)
 			o->verify_interval = o->min_bs[DDIR_READ];
 
 		/*
-		 * Verify interval must be a factor or both min and max
+		 * Verify interval must be a factor of both min and max
 		 * write size
 		 */
-		if (o->verify_interval % o->min_bs[DDIR_WRITE] ||
-		    o->verify_interval % o->max_bs[DDIR_WRITE])
+		if (!o->verify_interval ||
+		    (o->min_bs[DDIR_WRITE] % o->verify_interval) ||
+		    (o->max_bs[DDIR_WRITE] % o->verify_interval))
 			o->verify_interval = gcd(o->min_bs[DDIR_WRITE],
 							o->max_bs[DDIR_WRITE]);
 	}
@@ -1585,7 +1586,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			p.avg_msec = min(o->log_avg_msec, o->bw_avg_time);
 		else
 			o->bw_avg_time = p.avg_msec;
-	
+
 		p.hist_msec = o->log_hist_msec;
 		p.hist_coarseness = o->log_hist_coarseness;
 
@@ -1616,7 +1617,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			p.avg_msec = min(o->log_avg_msec, o->iops_avg_time);
 		else
 			o->iops_avg_time = p.avg_msec;
-	
+
 		p.hist_msec = o->log_hist_msec;
 		p.hist_coarseness = o->log_hist_coarseness;
 
