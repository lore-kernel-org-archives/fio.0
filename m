Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbKTNAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Nov 2015 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZzlIJ-0004ox-7G
	for fio@vger.kernel.org; Fri, 20 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151120130002.465712C00E7@kernel.dk>
Date: Fri, 20 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d883efbdb2034b4ab23abec9cee1762d6d476247:

  Fix group_id != groupid mixup (2015-11-16 14:00:41 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3379b94e3b7da4b74afcfa9781752179ede6ec4d:

  Fix ETA calculations (2015-11-19 13:36:18 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Don't output json headers for fio backend

Jens Rosenboom (1):
      Fix ETA calculations

 eta.c  | 28 +++++++++++++++++-----------
 stat.c |  2 +-
 2 files changed, 18 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/eta.c b/eta.c
index 7eb1c27..8785540 100644
--- a/eta.c
+++ b/eta.c
@@ -214,7 +214,7 @@ static unsigned long thread_eta(struct thread_data *td)
 		if (td->o.time_based) {
 			if (timeout) {
 				perc_t = (double) elapsed / (double) timeout;
-				if (perc_t < perc)
+				if (perc_t > perc)
 					perc = perc_t;
 			} else {
 				/*
@@ -250,7 +250,7 @@ static unsigned long thread_eta(struct thread_data *td)
 			t_eta = __timeout + start_delay + ramp_time;
 			t_eta /= 1000000ULL;
 
-			if (in_ramp_time(td)) {
+			if ((td->runstate == TD_RAMP) && in_ramp_time(td)) {
 				unsigned long ramp_left;
 
 				ramp_left = mtime_since_now(&td->epoch);
@@ -438,19 +438,25 @@ int calc_thread_status(struct jobs_eta *je, int force)
 		}
 	}
 
-	if (exitall_on_terminate)
+	if (exitall_on_terminate) {
 		je->eta_sec = INT_MAX;
-	else
-		je->eta_sec = 0;
-
-	for_each_td(td, i) {
-		if (exitall_on_terminate) {
+		for_each_td(td, i) {
 			if (eta_secs[i] < je->eta_sec)
 				je->eta_sec = eta_secs[i];
-		} else {
-			if (eta_secs[i] > je->eta_sec)
-				je->eta_sec = eta_secs[i];
 		}
+	} else {
+		unsigned long eta_stone = 0;
+
+		je->eta_sec = 0;
+		for_each_td(td, i) {
+			if ((td->runstate == TD_NOT_CREATED) && td->o.stonewall)
+				eta_stone += eta_secs[i];
+			else {
+				if (eta_secs[i] > je->eta_sec)
+					je->eta_sec = eta_secs[i];
+			}
+		}
+		je->eta_sec += eta_stone;
 	}
 
 	free(eta_secs);
diff --git a/stat.c b/stat.c
index 6ee02d3..da3ad2a 100644
--- a/stat.c
+++ b/stat.c
@@ -1612,7 +1612,7 @@ void __show_run_stats(void)
 				show_thread_status_normal(ts, rs, &output[__FIO_OUTPUT_NORMAL]);
 		}
 	}
-	if (output_format & FIO_OUTPUT_JSON) {
+	if (!is_backend && (output_format & FIO_OUTPUT_JSON)) {
 		/* disk util stats, if any */
 		show_disk_util(1, root, &output[__FIO_OUTPUT_JSON]);
 
