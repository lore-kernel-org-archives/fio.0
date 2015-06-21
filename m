Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40927 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbFUMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 21 Jun 2015 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6duv-00059K-Dk
	for fio@vger.kernel.org; Sun, 21 Jun 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150621120001.CAAC12C00CB@kernel.dk>
Date: Sun, 21 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d86ae56c2995f90b5ac38de981d6f46114dabdf3:

  HOWTO: make it clear that deviation is standard deviation (2015-06-16 09:30:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 75dc383e9d05369c830559496afa382178905e39:

  Fix latency logging for io_submit_mode=offload (2015-06-20 13:21:48 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Fix latency logging for io_submit_mode=offload

 io_u.c | 10 +++++++---
 stat.c | 12 ++++++++++++
 2 files changed, 19 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 63a176f..d80ef98 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1604,6 +1604,9 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	const int no_reduce = !gtod_reduce(td);
 	unsigned long lusec = 0;
 
+	if (td->parent)
+		td = td->parent;
+
 	if (no_reduce)
 		lusec = utime_since(&io_u->issue_time, &icd->time);
 
@@ -1633,9 +1636,6 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		io_u_mark_latency(td, lusec);
 	}
 
-	if (td->parent)
-		td = td->parent;
-
 	if (!td->o.disable_bw)
 		add_bw_sample(td, idx, bytes, &icd->time);
 
@@ -1891,6 +1891,10 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 		unsigned long slat_time;
 
 		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
+
+		if (td->parent)
+			td = td->parent;
+
 		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
 				io_u->offset);
 	}
diff --git a/stat.c b/stat.c
index 7d6ee63..30a2c1e 100644
--- a/stat.c
+++ b/stat.c
@@ -1962,6 +1962,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (!ddir_rw(ddir))
 		return;
 
+	td_io_u_lock(td);
+
 	add_stat_sample(&ts->clat_stat[ddir], usec);
 
 	if (td->clat_log)
@@ -1969,6 +1971,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
+
+	td_io_u_unlock(td);
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
@@ -1979,10 +1983,14 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (!ddir_rw(ddir))
 		return;
 
+	td_io_u_lock(td);
+
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
 	if (td->slat_log)
 		add_log_sample(td, td->slat_log, usec, ddir, bs, offset);
+
+	td_io_u_unlock(td);
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
@@ -1993,10 +2001,14 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (!ddir_rw(ddir))
 		return;
 
+	td_io_u_lock(td);
+
 	add_stat_sample(&ts->lat_stat[ddir], usec);
 
 	if (td->lat_log)
 		add_log_sample(td, td->lat_log, usec, ddir, bs, offset);
+
+	td_io_u_unlock(td);
 }
 
 void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
--
To unsubscribe from this list: send the line "unsubscribe fio" in

