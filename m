Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34639 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758606AbbKSOxY (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Nov 2015 09:53:24 -0500
Received: by wmvv187 with SMTP id v187so29480323wmv.1
        for <fio@vger.kernel.org>; Thu, 19 Nov 2015 06:53:23 -0800 (PST)
Received: from cuboid ([185.27.182.2])
        by smtp.gmail.com with ESMTPSA id gj2sm8227230wjb.40.2015.11.19.06.53.21
        for <fio@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Thu, 19 Nov 2015 06:53:22 -0800 (PST)
Message-ID: <1447944744.32482.13.camel@x-ion.de>
Subject: [PATCH] Fix ETA calculations
From: Jens Rosenboom <j.rosenboom@x-ion.de>
Date: Thu, 19 Nov 2015 15:52:24 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Fio <fio@vger.kernel.org>

There are a couple of issues in eta.c:

- The comparison for time- vs. rate-based ETA calculation is done the
  wrong way round.
- The elapsed ramp time should only be subtracted when the thread has
  indeed entered the ramp phase.
- Currently jobs that are stonewalled are not taken into account for ETA
  calculation. This patch at least fixes this for the case that there is
  only a single job per stonewall group.
---

This patch tries to fix some issues I have found, this may
also be related to the ones mentioned earlier in
http://www.spinics.net/lists/fio/msg04187.html

The part regarding stonewalled jobs may require some further work, but
at least it gives proper values now for my standard fio runs containing
just a sequence of singular jobs.

Also, I'm still wondering about the intention behind the way done_secs
is meant to work. It cumulates time spent in finished jobs globally, but
is being used in per-job ETA calculations. This seems to break at
least for the case of stonewalled jobs, too.

 eta.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/eta.c b/eta.c
index 7eb1c27..e73cc2c 100644
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
@@ -226,6 +226,7 @@ static unsigned long thread_eta(struct thread_data *td)
 		}
 
 		eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
+		// printf("eta_sec: %lu, elapsed: %lu, perc: %02.6f, done: %llu, total: %llu\n", eta_sec, elapsed, perc, bytes_done, bytes_total);
 
 		if (td->o.timeout &&
 		    eta_sec > (timeout + done_secs - elapsed))
@@ -250,7 +251,7 @@ static unsigned long thread_eta(struct thread_data *td)
 			t_eta = __timeout + start_delay + ramp_time;
 			t_eta /= 1000000ULL;
 
-			if (in_ramp_time(td)) {
+			if ((td->runstate == TD_RAMP) && in_ramp_time(td)) {
 				unsigned long ramp_left;
 
 				ramp_left = mtime_since_now(&td->epoch);
@@ -438,19 +439,25 @@ int calc_thread_status(struct jobs_eta *je, int force)
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
+		je->eta_sec = 0;
+		for_each_td(td, i) {
+			if ((td->runstate == TD_NOT_CREATED) && (td->o.stonewall)) {
+				eta_stone += eta_secs[i];
+			} else {
+				if (eta_secs[i] > je->eta_sec)
+					je->eta_sec = eta_secs[i];
+			}
+		}
+		je->eta_sec += eta_stone;
+		// printf("stoned: %lu\n", eta_stone);
 	}
 
 	free(eta_secs);
-- 
2.4.10

