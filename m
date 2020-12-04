Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgLDNAv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Dec 2020 08:00:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B205EC0613D1
        for <fio@vger.kernel.org>; Fri,  4 Dec 2020 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klAgt-000309-VR
        for fio@vger.kernel.org; Fri, 04 Dec 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201204130001.E554B1BC0158@kernel.dk>
Date: Fri,  4 Dec 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7914c6147adaf3ef32804519ced850168fff1711:

  Merge branch 'regrow_agg_logs' of https://github.com/pmoust/fio (2020-11-27 08:55:12 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f9eb98cba4cfc5351bace61c21eda67fb625266b:

  Merge branch 'stat-int-creep3' of https://github.com/jeffreyalien/fio (2020-12-03 16:09:43 -0700)

----------------------------------------------------------------
Jeff Lien (1):
      stat: Prevent the BW and IOPS logging interval from creeping up

Jens Axboe (1):
      Merge branch 'stat-int-creep3' of https://github.com/jeffreyalien/fio

 stat.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/stat.c b/stat.c
index d42586e7..b7237953 100644
--- a/stat.c
+++ b/stat.c
@@ -2747,7 +2747,8 @@ static unsigned long add_log_sample(struct thread_data *td,
 
 	__add_stat_to_log(iolog, ddir, elapsed, td->o.log_max != 0, priority_bit);
 
-	iolog->avg_last[ddir] = elapsed - (this_window - iolog->avg_msec);
+	iolog->avg_last[ddir] = elapsed - (elapsed % iolog->avg_msec);
+
 	return iolog->avg_msec;
 }
 
@@ -2985,7 +2986,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 	next_log = avg_time;
 
 	spent = mtime_since(parent_tv, t);
-	if (spent < avg_time && avg_time - spent >= LOG_MSEC_SLACK)
+	if (spent < avg_time && avg_time - spent > LOG_MSEC_SLACK)
 		return avg_time - spent;
 
 	if (needs_lock)
@@ -3078,13 +3079,16 @@ static int add_iops_samples(struct thread_data *td, struct timespec *t)
 int calc_log_samples(void)
 {
 	struct thread_data *td;
-	unsigned int next = ~0U, tmp;
+	unsigned int next = ~0U, tmp = 0, next_mod = 0, log_avg_msec_min = -1U;
 	struct timespec now;
 	int i;
+	long elapsed_time = 0;
 
 	fio_gettime(&now, NULL);
 
 	for_each_td(td, i) {
+		elapsed_time = mtime_since_now(&td->epoch);
+
 		if (!td->o.stats)
 			continue;
 		if (in_ramp_time(td) ||
@@ -3095,17 +3099,34 @@ int calc_log_samples(void)
 		if (!td->bw_log ||
 			(td->bw_log && !per_unit_log(td->bw_log))) {
 			tmp = add_bw_samples(td, &now);
-			if (tmp < next)
-				next = tmp;
+
+			if (td->bw_log)
+				log_avg_msec_min = min(log_avg_msec_min, (unsigned int)td->bw_log->avg_msec);
 		}
 		if (!td->iops_log ||
 			(td->iops_log && !per_unit_log(td->iops_log))) {
 			tmp = add_iops_samples(td, &now);
-			if (tmp < next)
-				next = tmp;
+
+			if (td->iops_log)
+				log_avg_msec_min = min(log_avg_msec_min, (unsigned int)td->iops_log->avg_msec);
 		}
+
+		if (tmp < next)
+			next = tmp;
 	}
 
+	/* if log_avg_msec_min has not been changed, set it to 0 */
+	if (log_avg_msec_min == -1U)
+		log_avg_msec_min = 0;
+
+	if (log_avg_msec_min == 0)
+		next_mod = elapsed_time;
+	else
+		next_mod = elapsed_time % log_avg_msec_min;
+
+	/* correction to keep the time on the log avg msec boundary */
+	next = min(next, (log_avg_msec_min - next_mod));
+
 	return next == ~0U ? 0 : next;
 }
 

