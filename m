Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbcFGMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Jun 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1bAFfv-0001Qh-4y
	for fio@vger.kernel.org; Tue, 07 Jun 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160607120002.2D2E62C00A6@kernel.dk>
Date: Tue,  7 Jun 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 82e65aecd90a35171eb9930ba7b08d27fee95640:

  Documentation: fix psyncv2 typo (2016-06-03 09:00:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a89b401289ef823c51760c71018b43d0c17532b:

  stat: fix reversed check for ramp time (2016-06-06 21:23:53 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Fix ramp time breakage
      stat: remove redundant unit log check
      stat: fix reversed check for ramp time

 fio_time.h |  6 ++++--
 stat.c     |  8 +-------
 time.c     | 10 +++++-----
 3 files changed, 10 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/fio_time.h b/fio_time.h
index cb271c2..e31ea09 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -1,6 +1,8 @@
 #ifndef FIO_TIME_H
 #define FIO_TIME_H
 
+#include "lib/types.h"
+
 struct thread_data;
 extern uint64_t utime_since(const struct timeval *,const  struct timeval *);
 extern uint64_t utime_since_now(const struct timeval *);
@@ -14,8 +16,8 @@ extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timeval *);
 extern void set_genesis_time(void);
-extern int ramp_time_over(struct thread_data *);
-extern int in_ramp_time(struct thread_data *);
+extern bool ramp_time_over(struct thread_data *);
+extern bool in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
 extern void timeval_add_msec(struct timeval *, unsigned int);
 
diff --git a/stat.c b/stat.c
index 5384884..a8ccd9a 100644
--- a/stat.c
+++ b/stat.c
@@ -2260,9 +2260,6 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
 
-	if (per_unit_log(td->bw_log))
-		return 0;
-
 	spent = mtime_since(&td->bw_sample_time, t);
 	if (spent < td->o.bw_avg_time &&
 	    td->o.bw_avg_time - spent >= 10)
@@ -2331,9 +2328,6 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	unsigned long spent, iops;
 	enum fio_ddir ddir;
 
-	if (per_unit_log(td->iops_log))
-		return 0;
-
 	spent = mtime_since(&td->iops_sample_time, t);
 	if (spent < td->o.iops_avg_time &&
 	    td->o.iops_avg_time - spent >= 10)
@@ -2393,7 +2387,7 @@ int calc_log_samples(void)
 	fio_gettime(&now, NULL);
 
 	for_each_td(td, i) {
-		if (!ramp_time_over(td) ||
+		if (in_ramp_time(td) ||
 		    !(td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING)) {
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
 			continue;
diff --git a/time.c b/time.c
index 0e64af5..f1c5d3f 100644
--- a/time.c
+++ b/time.c
@@ -84,7 +84,7 @@ uint64_t utime_since_genesis(void)
 	return utime_since_now(&genesis);
 }
 
-int in_ramp_time(struct thread_data *td)
+bool in_ramp_time(struct thread_data *td)
 {
 	return td->o.ramp_time && !td->ramp_time_over;
 }
@@ -101,12 +101,12 @@ static void parent_update_ramp(struct thread_data *td)
 	td_set_runstate(parent, TD_RAMP);
 }
 
-int ramp_time_over(struct thread_data *td)
+bool ramp_time_over(struct thread_data *td)
 {
 	struct timeval tv;
 
 	if (!td->o.ramp_time || td->ramp_time_over)
-		return 1;
+		return true;
 
 	fio_gettime(&tv, NULL);
 	if (utime_since(&td->epoch, &tv) >= td->o.ramp_time) {
@@ -114,10 +114,10 @@ int ramp_time_over(struct thread_data *td)
 		reset_all_stats(td);
 		td_set_runstate(td, TD_RAMP);
 		parent_update_ramp(td);
-		return 1;
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 void fio_time_init(void)
