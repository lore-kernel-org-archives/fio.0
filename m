Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:44274 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbaBTNVA (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Feb 2014 08:21:00 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 20 Feb 2014 13:20:59 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 1C8D21B0805F
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:36 +0000 (GMT)
Received: from d06av11.portsmouth.uk.ibm.com (d06av11.portsmouth.uk.ibm.com [9.149.37.252])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s1KDKjZ847054890
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 13:20:45 GMT
Received: from d06av11.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av11.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s1KDKvnM029962
	for <fio@vger.kernel.org>; Thu, 20 Feb 2014 06:20:57 -0700
Message-Id: <20140220132051.438966310@linux.vnet.ibm.com>
Date: Thu, 20 Feb 2014 14:20:05 +0100
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 7/9] fio: flush log files on test end
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

*Resend with hopefully non mangled patches*
References: <20140220131958.965092001@linux.vnet.ibm.com>
Content-Disposition: inline; filename=flush_log.diff

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Ensure proper flushing of all logs at the end of tests.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

---
[diffstat]
 backend.c |    1 
 iolog.h   |    1 
 stat.c    |   73 ++++++++++++++++++++++++++++++++++++++++----------------------
 3 files changed, 50 insertions(+), 25 deletions(-)

--- a/backend.c
+++ b/backend.c
@@ -1461,6 +1461,7 @@ static void *thread_main(void *data)
 	fio_unpin_memory(td);
 
 	fio_mutex_down(writeout_mutex);
+	finalize_logs(td);
 	if (td->bw_log) {
 		if (o->bw_log_file) {
 			finish_log_named(td, td->bw_log,
--- a/iolog.h
+++ b/iolog.h
@@ -117,6 +117,7 @@ extern void write_iolog_close(struct thr
 /*
  * Logging
  */
+extern void finalize_logs(struct thread_data *td);
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
--- a/stat.c
+++ b/stat.c
@@ -1579,6 +1579,37 @@ static inline void reset_io_stat(struct
 	ios->mean.u.f = ios->S.u.f = 0;
 }
 
+static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
+{
+	/*
+	 * Note an entry in the log. Use the mean from the logged samples,
+	 * making sure to properly round up. Only write a log entry if we
+	 * had actual samples done.
+	 */
+	if (iolog->avg_window[DDIR_READ].samples) {
+		unsigned long mr;
+
+		mr = iolog->avg_window[DDIR_READ].mean.u.f + 0.50;
+		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed);
+	}
+	if (iolog->avg_window[DDIR_WRITE].samples) {
+		unsigned long mw;
+
+		mw = iolog->avg_window[DDIR_WRITE].mean.u.f + 0.50;
+		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed);
+	}
+	if (iolog->avg_window[DDIR_TRIM].samples) {
+		unsigned long mw;
+
+		mw = iolog->avg_window[DDIR_TRIM].mean.u.f + 0.50;
+		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed);
+	}
+
+	reset_io_stat(&iolog->avg_window[DDIR_READ]);
+	reset_io_stat(&iolog->avg_window[DDIR_WRITE]);
+	reset_io_stat(&iolog->avg_window[DDIR_TRIM]);
+}
+
 static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 			   unsigned long val, enum fio_ddir ddir,
 			   unsigned int bs)
@@ -1612,35 +1643,27 @@ static void add_log_sample(struct thread
 	if (this_window < iolog->avg_msec)
 		return;
 
-	/*
-	 * Note an entry in the log. Use the mean from the logged samples,
-	 * making sure to properly round up. Only write a log entry if we
-	 * had actual samples done.
-	 */
-	if (iolog->avg_window[DDIR_READ].samples) {
-		unsigned long mr;
+	_add_stat_to_log(iolog, elapsed);
 
-		mr = iolog->avg_window[DDIR_READ].mean.u.f + 0.50;
-		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed);
-	}
-	if (iolog->avg_window[DDIR_WRITE].samples) {
-		unsigned long mw;
-
-		mw = iolog->avg_window[DDIR_WRITE].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed);
-	}
-	if (iolog->avg_window[DDIR_TRIM].samples) {
-		unsigned long mw;
+	iolog->avg_last = elapsed;
+}
 
-		mw = iolog->avg_window[DDIR_TRIM].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed);
-	}
+void finalize_logs(struct thread_data *td)
+{
+	unsigned long elapsed;
 
+	elapsed = mtime_since_now(&td->epoch);
 
-	reset_io_stat(&iolog->avg_window[DDIR_READ]);
-	reset_io_stat(&iolog->avg_window[DDIR_WRITE]);
-	reset_io_stat(&iolog->avg_window[DDIR_TRIM]);
-	iolog->avg_last = elapsed;
+	if (td->clat_log)
+		_add_stat_to_log(td->clat_log, elapsed);
+	if (td->slat_log)
+		_add_stat_to_log(td->slat_log, elapsed);
+	if (td->lat_log)
+		_add_stat_to_log(td->lat_log, elapsed);
+	if (td->bw_log)
+		_add_stat_to_log(td->bw_log, elapsed);
+	if (td->iops_log)
+		_add_stat_to_log(td->iops_log, elapsed);
 }
 
 void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)

