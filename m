Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59042 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbcGWMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 Jul 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bQvbA-00056W-11
	for fio@vger.kernel.org; Sat, 23 Jul 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160723120002.4AE1E2C00A5@kernel.dk>
Date: Sat, 23 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c16556af62cd1cd1ae31b6ee8706efc43c137f77:

  drifting in output of interval-averaged values was eventually causing IOP samples to be dropped. (2016-07-20 16:21:55 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 79baf7f48a6e680e1e746e150b60c165542fdf6c:

  Fio 2.13 (2016-07-22 13:43:56 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      log: fix missing entries
      log: fix averaged latency logging
      Fio 2.13

YukiKita (1):
      Fix "exitall_on_error" option     "exitall_on_error" option should be enabled without any argument.

 FIO-VERSION-GEN        |  2 +-
 iolog.h                |  7 +++++++
 options.c              |  4 ++--
 os/windows/install.wxs |  2 +-
 stat.c                 | 43 ++++++++++++++++++++++++++++++-------------
 5 files changed, 41 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 04802dd..7065a57 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.12
+DEF_VER=fio-2.13
 
 LF='
 '
diff --git a/iolog.h b/iolog.h
index a58e3f0..0438fa7 100644
--- a/iolog.h
+++ b/iolog.h
@@ -230,6 +230,13 @@ static inline bool per_unit_log(struct io_log *log)
 	return log && !log->avg_msec;
 }
 
+static inline bool inline_log(struct io_log *log)
+{
+	return log->log_type == IO_LOG_TYPE_LAT ||
+		log->log_type == IO_LOG_TYPE_CLAT ||
+		log->log_type == IO_LOG_TYPE_SLAT;
+}
+
 extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, bool);
diff --git a/options.c b/options.c
index 4723e41..4461643 100644
--- a/options.c
+++ b/options.c
@@ -3444,8 +3444,8 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "exitall_on_error",
 		.lname	= "Exit-all on terminate in error",
-		.type	= FIO_OPT_BOOL,
-		.off1	= td_var_offset(unlink),
+		.type	= FIO_OPT_STR_SET,
+		.off1	= td_var_offset(exitall_error),
 		.help	= "Terminate all jobs when one exits in error",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_PROCESS,
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 1e8022d..f8d3773 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.12">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.13">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index 08a402a..7a35117 100644
--- a/stat.c
+++ b/stat.c
@@ -18,6 +18,8 @@
 #include "helper_thread.h"
 #include "smalloc.h"
 
+#define LOG_MSEC_SLACK	10
+
 struct fio_mutex *stat_mutex;
 
 void clear_rusage_stat(struct thread_data *td)
@@ -2107,14 +2109,14 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
-static void add_log_sample(struct thread_data *td, struct io_log *iolog,
+static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 			   unsigned long val, enum fio_ddir ddir,
 			   unsigned int bs, uint64_t offset)
 {
 	unsigned long elapsed, this_window;
 
 	if (!ddir_rw(ddir))
-		return;
+		return 0;
 
 	elapsed = mtime_since_now(&td->epoch);
 
@@ -2123,7 +2125,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 */
 	if (!iolog->avg_msec) {
 		__add_log_sample(iolog, val, ddir, bs, elapsed, offset);
-		return;
+		return 0;
 	}
 
 	/*
@@ -2137,12 +2139,17 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * need to do.
 	 */
 	this_window = elapsed - iolog->avg_last;
-	if (this_window < iolog->avg_msec)
-		return;
+	if (this_window < iolog->avg_msec) {
+		int diff = iolog->avg_msec - this_window;
+
+		if (inline_log(iolog) || diff > LOG_MSEC_SLACK)
+			return diff;
+	}
 
 	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
 
 	iolog->avg_last = elapsed - (this_window - iolog->avg_msec);
+	return iolog->avg_msec;
 }
 
 void finalize_logs(struct thread_data *td, bool unit_logs)
@@ -2264,10 +2271,13 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
+	unsigned int next, next_log;
+
+	next_log = td->o.bw_avg_time;
 
 	spent = mtime_since(&td->bw_sample_time, t);
 	if (spent < td->o.bw_avg_time &&
-	    td->o.bw_avg_time - spent >= 10)
+	    td->o.bw_avg_time - spent >= LOG_MSEC_SLACK)
 		return td->o.bw_avg_time - spent;
 
 	td_io_u_lock(td);
@@ -2295,7 +2305,8 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			next = add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			next_log = min(next_log, next);
 		}
 
 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
@@ -2306,9 +2317,10 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.bw_avg_time)
-		return td->o.bw_avg_time;
+		return min(next_log, td->o.bw_avg_time);
 
-	return td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+	next = td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+	return min(next, next_log);
 }
 
 void add_iops_sample(struct thread_data *td, struct io_u *io_u,
@@ -2332,10 +2344,13 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	struct thread_stat *ts = &td->ts;
 	unsigned long spent, iops;
 	enum fio_ddir ddir;
+	unsigned int next, next_log;
+
+	next_log = td->o.iops_avg_time;
 
 	spent = mtime_since(&td->iops_sample_time, t);
 	if (spent < td->o.iops_avg_time &&
-	    td->o.iops_avg_time - spent >= 10)
+	    td->o.iops_avg_time - spent >= LOG_MSEC_SLACK)
 		return td->o.iops_avg_time - spent;
 
 	td_io_u_lock(td);
@@ -2363,7 +2378,8 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			next = add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			next_log = min(next_log, next);
 		}
 
 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
@@ -2374,9 +2390,10 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 	td_io_u_unlock(td);
 
 	if (spent <= td->o.iops_avg_time)
-		return td->o.iops_avg_time;
+		return min(next_log, td->o.iops_avg_time);
 
-	return td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+	next = td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+	return min(next, next_log);
 }
 
 /*
