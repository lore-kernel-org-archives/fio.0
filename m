Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726817AbgD3MAE (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 30 Apr 2020 08:00:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10706C09B040
        for <fio@vger.kernel.org>; Thu, 30 Apr 2020 05:00:03 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jU7rG-0007kz-QO
        for fio@vger.kernel.org; Thu, 30 Apr 2020 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200430120001.9C7491BC0165@kernel.dk>
Date: Thu, 30 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3966740cd903ed95f306e59892075faf9fd2a151:

  Merge branch 'gcc1' of https://github.com/kusumi/fio (2020-04-21 15:44:31 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b2ed1c4a07c6afc4ae90482ca5f70026a4bc34e6:

  Merge branch 'helper_thread_test' of https://github.com/vincentkfu/fio (2020-04-29 09:05:11 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'helper_thread_test' of https://github.com/vincentkfu/fio

Vincent Fu (3):
      helper_thread: cleanups
      helper_thread: fix inconsistent status intervals
      helper_thread: refactor status-interval and steadystate code

 helper_thread.c | 54 +++++++++++++++++++++++++++++++++++-------------------
 stat.c          | 12 ------------
 2 files changed, 35 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/helper_thread.c b/helper_thread.c
index 78749855..ad1a08f3 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -128,11 +128,30 @@ void helper_thread_exit(void)
 	pthread_join(helper_data->thread, NULL);
 }
 
+static unsigned int task_helper(struct timespec *last, struct timespec *now, unsigned int period, void do_task())
+{
+	unsigned int next, since;
+
+	since = mtime_since(last, now);
+	if (since >= period || period - since < 10) {
+		do_task();
+		timespec_add_msec(last, since);
+		if (since > period)
+			next = period - (since - period);
+		else
+			next = period;
+	} else
+		next = period - since;
+
+	return next;
+}
+
 static void *helper_thread_main(void *data)
 {
 	struct helper_data *hd = data;
-	unsigned int msec_to_next_event, next_log, next_ss = STEADYSTATE_MSEC;
-	struct timespec ts, last_du, last_ss;
+	unsigned int msec_to_next_event, next_log, next_si = status_interval;
+	unsigned int next_ss = STEADYSTATE_MSEC;
+	struct timespec ts, last_du, last_ss, last_si;
 	char action;
 	int ret = 0;
 
@@ -157,20 +176,19 @@ static void *helper_thread_main(void *data)
 #endif
 	memcpy(&last_du, &ts, sizeof(ts));
 	memcpy(&last_ss, &ts, sizeof(ts));
+	memcpy(&last_si, &ts, sizeof(ts));
 
 	fio_sem_up(hd->startup_sem);
 
 	msec_to_next_event = DISK_UTIL_MSEC;
 	while (!ret && !hd->exit) {
-		uint64_t since_du, since_ss = 0;
+		uint64_t since_du;
 		struct timeval timeout = {
-			.tv_sec  = DISK_UTIL_MSEC / 1000,
-			.tv_usec = (DISK_UTIL_MSEC % 1000) * 1000,
+			.tv_sec  = msec_to_next_event / 1000,
+			.tv_usec = (msec_to_next_event % 1000) * 1000,
 		};
 		fd_set rfds, efds;
 
-		timespec_add_msec(&ts, msec_to_next_event);
-
 		if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) < 0) {
 			FD_ZERO(&rfds);
 			FD_SET(hd->pipe[0], &rfds);
@@ -209,25 +227,23 @@ static void *helper_thread_main(void *data)
 		if (action == A_DO_STAT)
 			__show_running_run_stats();
 
+		if (status_interval) {
+			next_si = task_helper(&last_si, &ts, status_interval, __show_running_run_stats);
+			msec_to_next_event = min(next_si, msec_to_next_event);
+		}
+
 		next_log = calc_log_samples();
 		if (!next_log)
 			next_log = DISK_UTIL_MSEC;
 
 		if (steadystate_enabled) {
-			since_ss = mtime_since(&last_ss, &ts);
-			if (since_ss >= STEADYSTATE_MSEC || STEADYSTATE_MSEC - since_ss < 10) {
-				steadystate_check();
-				timespec_add_msec(&last_ss, since_ss);
-				if (since_ss > STEADYSTATE_MSEC)
-					next_ss = STEADYSTATE_MSEC - (since_ss - STEADYSTATE_MSEC);
-				else
-					next_ss = STEADYSTATE_MSEC;
-			} else
-				next_ss = STEADYSTATE_MSEC - since_ss;
+			next_ss = task_helper(&last_ss, &ts, STEADYSTATE_MSEC, steadystate_check);
+			msec_to_next_event = min(next_ss, msec_to_next_event);
                 }
 
-		msec_to_next_event = min(min(next_log, msec_to_next_event), next_ss);
-		dprint(FD_HELPERTHREAD, "since_ss: %llu, next_ss: %u, next_log: %u, msec_to_next_event: %u\n", (unsigned long long)since_ss, next_ss, next_log, msec_to_next_event);
+		msec_to_next_event = min(next_log, msec_to_next_event);
+		dprint(FD_HELPERTHREAD, "next_si: %u, next_ss: %u, next_log: %u, msec_to_next_event: %u\n",
+			next_si, next_ss, next_log, msec_to_next_event);
 
 		if (!is_backend)
 			print_thread_status();
diff --git a/stat.c b/stat.c
index efa811d2..2cf11947 100644
--- a/stat.c
+++ b/stat.c
@@ -2354,8 +2354,6 @@ void __show_running_run_stats(void)
 	fio_sem_up(stat_sem);
 }
 
-static bool status_interval_init;
-static struct timespec status_time;
 static bool status_file_disabled;
 
 #define FIO_STATUS_FILE		"fio-dump-status"
@@ -2398,16 +2396,6 @@ static int check_status_file(void)
 
 void check_for_running_stats(void)
 {
-	if (status_interval) {
-		if (!status_interval_init) {
-			fio_gettime(&status_time, NULL);
-			status_interval_init = true;
-		} else if (mtime_since_now(&status_time) >= status_interval) {
-			show_running_run_stats();
-			fio_gettime(&status_time, NULL);
-			return;
-		}
-	}
 	if (check_status_file()) {
 		show_running_run_stats();
 		return;

