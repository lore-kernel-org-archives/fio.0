Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgGYMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 25 Jul 2020 08:00:09 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2C1C0619D3
        for <fio@vger.kernel.org>; Sat, 25 Jul 2020 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jzIqU-0003S8-0P
        for fio@vger.kernel.org; Sat, 25 Jul 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200725120002.46CE71BC01BB@kernel.dk>
Date: Sat, 25 Jul 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5090d1d0f2a109c276384c93308566b7a3bfa5ad:

  zbd: fix %lu -> %llu dprint() formatting (2020-07-21 09:40:07 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c355011a2509fdf6caa2a220e1534d61f14c4801:

  Merge branch 'sribs-patch-1039' of https://github.com/sribs/fio (2020-07-24 11:05:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'sribs-patch-1039' of https://github.com/sribs/fio

Shin'ichiro Kawasaki (1):
      t/zbd: Improve pass condition of test case #49

sribs (2):
      io_u: fix exit failure case when using rates and timeout
      stat: stop triggerring division by zero on bandwidth lower than 1KBps

 io_u.c                 | 19 +++++++++++++++++++
 stat.c                 | 25 +++++++++++++++----------
 t/zbd/test-zbd-support |  1 +
 3 files changed, 35 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index 7f50906b..6a729e51 100644
--- a/io_u.c
+++ b/io_u.c
@@ -680,7 +680,22 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.io_submit_mode == IO_MODE_INLINE)
 		io_u_quiesce(td);
 
+	if (td->o.timeout && ((usec + now) > td->o.timeout)) {
+		/*
+		 * check if the usec is capable of taking negative values
+		 */
+		if (now > td->o.timeout) {
+			ddir = DDIR_INVAL;
+			return ddir;
+		}
+		usec = td->o.timeout - now;
+	}
 	usec_sleep(td, usec);
+
+	now = utime_since_now(&td->epoch);
+	if ((td->o.timeout && (now > td->o.timeout)) || td->terminate)
+		ddir = DDIR_INVAL;
+
 	return ddir;
 }
 
@@ -896,6 +911,10 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 
 	set_rw_ddir(td, io_u);
 
+	if (io_u->ddir == DDIR_INVAL) {
+		dprint(FD_IO, "invalid direction received ddir = %d", io_u->ddir);
+		return 1;
+	}
 	/*
 	 * fsync() or fdatasync() or trim etc, we are done
 	 */
diff --git a/stat.c b/stat.c
index b3951199..23657cee 100644
--- a/stat.c
+++ b/stat.c
@@ -414,6 +414,18 @@ static void display_lat(const char *name, unsigned long long min,
 	free(maxp);
 }
 
+static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
+{
+	double p_of_agg = 100.0;
+	if (rs && rs->agg[ddir] > 1024) {
+		p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024.0);
+
+		if (p_of_agg > 100.0)
+			p_of_agg = 100.0;
+	}
+	return p_of_agg;
+}
+
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
@@ -551,11 +563,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		else
 			bw_str = "kB";
 
-		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
-			if (p_of_agg > 100.0)
-				p_of_agg = 100.0;
-		}
+		p_of_agg = convert_agg_kbytes_percent(rs, ddir, mean);
 
 		if (rs->unit_base == 1) {
 			min *= 8.0;
@@ -1376,11 +1384,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	}
 
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
-		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
-			if (p_of_agg > 100.0)
-				p_of_agg = 100.0;
-		}
+		p_of_agg = convert_agg_kbytes_percent(rs, ddir, mean);
 	} else {
 		min = max = 0;
 		p_of_agg = mean = dev = 0.0;
@@ -3130,3 +3134,4 @@ uint32_t *io_u_block_info(struct thread_data *td, struct io_u *io_u)
 	assert(idx < td->ts.nr_block_infos);
 	return info;
 }
+
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index e53a20c5..471a3487 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -856,6 +856,7 @@ test49() {
 		    --zonecapacity=${capacity} \
 		    --verify=md5  --size=${size} >>"${logfile}.${test_number}" 2>&1 ||
 	return $?
+    check_written $((capacity * 2)) || return $?
     check_read $((capacity * 2)) || return $?
 }
 

