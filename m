Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726530AbgHQMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Aug 2020 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AA4C061389
        for <fio@vger.kernel.org>; Mon, 17 Aug 2020 05:00:07 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k7do5-00056Q-4J
        for fio@vger.kernel.org; Mon, 17 Aug 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200817120002.582CB1BC01BE@kernel.dk>
Date: Mon, 17 Aug 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0ce7e3e584be6f4f834fb2fec8e52deb23e1dd12:

  Merge branch 'issue-1065' of https://github.com/XeS0r/fio into master (2020-08-14 16:02:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dde39f8c356158207eb2fc8ff6c9d2daad910a84:

  fio: add for_each_rw_ddir() macro (2020-08-16 21:01:22 -0700)

----------------------------------------------------------------
Alexey Dobriyan (1):
      fio: add for_each_rw_ddir() macro

Jens Axboe (1):
      Fio 3.22

 FIO-VERSION-GEN |  2 +-
 backend.c       | 16 +++++++--------
 eta.c           | 12 +++++------
 init.c          | 62 ++++++++++++++++++++++++---------------------------------
 io_ddir.h       |  2 ++
 stat.c          | 16 +++++++--------
 6 files changed, 48 insertions(+), 62 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 48e575fc..bf0fee99 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.21
+DEF_VER=fio-3.22
 
 LF='
 '
diff --git a/backend.c b/backend.c
index 0e454cdd..a4367672 100644
--- a/backend.c
+++ b/backend.c
@@ -223,12 +223,10 @@ static bool check_min_rate(struct thread_data *td, struct timespec *now)
 {
 	bool ret = false;
 
-	if (td->bytes_done[DDIR_READ])
-		ret |= __check_min_rate(td, now, DDIR_READ);
-	if (td->bytes_done[DDIR_WRITE])
-		ret |= __check_min_rate(td, now, DDIR_WRITE);
-	if (td->bytes_done[DDIR_TRIM])
-		ret |= __check_min_rate(td, now, DDIR_TRIM);
+	for_each_rw_ddir(ddir) {
+		if (td->bytes_done[ddir])
+			ret |= __check_min_rate(td, now, ddir);
+	}
 
 	return ret;
 }
@@ -1876,9 +1874,9 @@ static void *thread_main(void *data)
 
 	update_rusage_stat(td);
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
-	td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
-	td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
-	td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
+	for_each_rw_ddir(ddir) {
+		td->ts.io_bytes[ddir] = td->io_bytes[ddir];
+	}
 
 	if (td->o.verify_state_save && !(td->flags & TD_F_VSTATE_SAVED) &&
 	    (td->o.verify != VERIFY_NONE && td_write(td)))
diff --git a/eta.c b/eta.c
index 13f61ba4..e8c72780 100644
--- a/eta.c
+++ b/eta.c
@@ -383,8 +383,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	struct thread_data *td;
 	int i, unified_rw_rep;
 	uint64_t rate_time, disp_time, bw_avg_time, *eta_secs;
-	unsigned long long io_bytes[DDIR_RWDIR_CNT];
-	unsigned long long io_iops[DDIR_RWDIR_CNT];
+	unsigned long long io_bytes[DDIR_RWDIR_CNT] = {};
+	unsigned long long io_iops[DDIR_RWDIR_CNT] = {};
 	struct timespec now;
 
 	static unsigned long long rate_io_bytes[DDIR_RWDIR_CNT];
@@ -413,8 +413,6 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	je->elapsed_sec = (mtime_since_genesis() + 999) / 1000;
 
-	io_bytes[DDIR_READ] = io_bytes[DDIR_WRITE] = io_bytes[DDIR_TRIM] = 0;
-	io_iops[DDIR_READ] = io_iops[DDIR_WRITE] = io_iops[DDIR_TRIM] = 0;
 	bw_avg_time = ULONG_MAX;
 	unified_rw_rep = 0;
 	for_each_td(td, i) {
@@ -509,9 +507,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
 				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
-		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0, 0);
-		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0, 0);
-		add_agg_sample(sample_val(je->rate[DDIR_TRIM]), DDIR_TRIM, 0, 0);
+		for_each_rw_ddir(ddir) {
+			add_agg_sample(sample_val(je->rate[ddir]), ddir, 0, 0);
+		}
 	}
 
 	disp_time = mtime_since(&disp_prev_time, &now);
diff --git a/init.c b/init.c
index 84325f1e..6ff7c68d 100644
--- a/init.c
+++ b/init.c
@@ -564,13 +564,11 @@ static int setup_rate(struct thread_data *td)
 {
 	int ret = 0;
 
-	if (td->o.rate[DDIR_READ] || td->o.rate_iops[DDIR_READ])
-		ret = __setup_rate(td, DDIR_READ);
-	if (td->o.rate[DDIR_WRITE] || td->o.rate_iops[DDIR_WRITE])
-		ret |= __setup_rate(td, DDIR_WRITE);
-	if (td->o.rate[DDIR_TRIM] || td->o.rate_iops[DDIR_TRIM])
-		ret |= __setup_rate(td, DDIR_TRIM);
-
+	for_each_rw_ddir(ddir) {
+		if (td->o.rate[ddir] || td->o.rate_iops[ddir]) {
+			ret |= __setup_rate(td, ddir);
+		}
+	}
 	return ret;
 }
 
@@ -662,31 +660,25 @@ static int fixup_options(struct thread_data *td)
 	if (td_read(td))
 		o->overwrite = 1;
 
-	if (!o->min_bs[DDIR_READ])
-		o->min_bs[DDIR_READ] = o->bs[DDIR_READ];
-	if (!o->max_bs[DDIR_READ])
-		o->max_bs[DDIR_READ] = o->bs[DDIR_READ];
-	if (!o->min_bs[DDIR_WRITE])
-		o->min_bs[DDIR_WRITE] = o->bs[DDIR_WRITE];
-	if (!o->max_bs[DDIR_WRITE])
-		o->max_bs[DDIR_WRITE] = o->bs[DDIR_WRITE];
-	if (!o->min_bs[DDIR_TRIM])
-		o->min_bs[DDIR_TRIM] = o->bs[DDIR_TRIM];
-	if (!o->max_bs[DDIR_TRIM])
-		o->max_bs[DDIR_TRIM] = o->bs[DDIR_TRIM];
-
-	o->rw_min_bs = min(o->min_bs[DDIR_READ], o->min_bs[DDIR_WRITE]);
-	o->rw_min_bs = min(o->min_bs[DDIR_TRIM], o->rw_min_bs);
+	for_each_rw_ddir(ddir) {
+		if (!o->min_bs[ddir])
+			o->min_bs[ddir] = o->bs[ddir];
+		if (!o->max_bs[ddir])
+			o->max_bs[ddir] = o->bs[ddir];
+	}
+
+	o->rw_min_bs = -1;
+	for_each_rw_ddir(ddir) {
+		o->rw_min_bs = min(o->rw_min_bs, o->min_bs[ddir]);
+	}
 
 	/*
 	 * For random IO, allow blockalign offset other than min_bs.
 	 */
-	if (!o->ba[DDIR_READ] || !td_random(td))
-		o->ba[DDIR_READ] = o->min_bs[DDIR_READ];
-	if (!o->ba[DDIR_WRITE] || !td_random(td))
-		o->ba[DDIR_WRITE] = o->min_bs[DDIR_WRITE];
-	if (!o->ba[DDIR_TRIM] || !td_random(td))
-		o->ba[DDIR_TRIM] = o->min_bs[DDIR_TRIM];
+	for_each_rw_ddir(ddir) {
+		if (!o->ba[ddir] || !td_random(td))
+			o->ba[ddir] = o->min_bs[ddir];
+	}
 
 	if ((o->ba[DDIR_READ] != o->min_bs[DDIR_READ] ||
 	    o->ba[DDIR_WRITE] != o->min_bs[DDIR_WRITE] ||
@@ -765,14 +757,12 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: rate and rate_iops are mutually exclusive\n");
 		ret |= 1;
 	}
-	if ((o->rate[DDIR_READ] && (o->rate[DDIR_READ] < o->ratemin[DDIR_READ])) ||
-	    (o->rate[DDIR_WRITE] && (o->rate[DDIR_WRITE] < o->ratemin[DDIR_WRITE])) ||
-	    (o->rate[DDIR_TRIM] && (o->rate[DDIR_TRIM] < o->ratemin[DDIR_TRIM])) ||
-	    (o->rate_iops[DDIR_READ] && (o->rate_iops[DDIR_READ] < o->rate_iops_min[DDIR_READ])) ||
-	    (o->rate_iops[DDIR_WRITE] && (o->rate_iops[DDIR_WRITE] < o->rate_iops_min[DDIR_WRITE])) ||
-	    (o->rate_iops[DDIR_TRIM] && (o->rate_iops[DDIR_TRIM] < o->rate_iops_min[DDIR_TRIM]))) {
-		log_err("fio: minimum rate exceeds rate\n");
-		ret |= 1;
+	for_each_rw_ddir(ddir) {
+		if ((o->rate[ddir] && (o->rate[ddir] < o->ratemin[ddir])) ||
+		    (o->rate_iops[ddir] && (o->rate_iops[ddir] < o->rate_iops_min[ddir]))) {
+			log_err("fio: minimum rate exceeds rate, ddir %d\n", +ddir);
+			ret |= 1;
+		}
 	}
 
 	if (!o->timeout && o->time_based) {
diff --git a/io_ddir.h b/io_ddir.h
index deaa8b5a..a42da97a 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -16,6 +16,8 @@ enum fio_ddir {
 	DDIR_RWDIR_SYNC_CNT = 4,
 };
 
+#define for_each_rw_ddir(ddir)	for (enum fio_ddir ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+
 static inline const char *io_ddir_name(enum fio_ddir ddir)
 {
 	static const char *name[] = { "read", "write", "trim", "sync",
diff --git a/stat.c b/stat.c
index 23657cee..7f987c7f 100644
--- a/stat.c
+++ b/stat.c
@@ -1078,12 +1078,10 @@ static void show_thread_status_normal(struct thread_stat *ts,
 	if (strlen(ts->description))
 		log_buf(out, "  Description  : [%s]\n", ts->description);
 
-	if (ts->io_bytes[DDIR_READ])
-		show_ddir_status(rs, ts, DDIR_READ, out);
-	if (ts->io_bytes[DDIR_WRITE])
-		show_ddir_status(rs, ts, DDIR_WRITE, out);
-	if (ts->io_bytes[DDIR_TRIM])
-		show_ddir_status(rs, ts, DDIR_TRIM, out);
+	for_each_rw_ddir(ddir) {
+		if (ts->io_bytes[ddir])
+			show_ddir_status(rs, ts, ddir, out);
+	}
 
 	show_latencies(ts, out);
 
@@ -2315,9 +2313,9 @@ void __show_running_run_stats(void)
 
 	for_each_td(td, i) {
 		td->update_rusage = 1;
-		td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
-		td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
-		td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
+		for_each_rw_ddir(ddir) {
+			td->ts.io_bytes[ddir] = td->io_bytes[ddir];
+		}
 		td->ts.total_run_time = mtime_since(&td->epoch, &ts);
 
 		rt[i] = mtime_since(&td->start, &ts);

