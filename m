Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39233 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaF2R5U (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 29 Jun 2014 13:57:20 -0400
Received: by mail-qc0-f181.google.com with SMTP id x13so6171386qcv.40
        for <fio@vger.kernel.org>; Sun, 29 Jun 2014 10:57:20 -0700 (PDT)
Received: from vonneumann (209-6-77-78.c3-0.abr-ubr1.sbo-abr.ma.cable.rcn.com. [209.6.77.78])
        by mx.google.com with ESMTPSA id x11sm27565045qax.45.2014.06.29.10.57.19
        for <fio@vger.kernel.org>
        (version=TLSv1.2 cipher=RC4-SHA bits=128/128);
        Sun, 29 Jun 2014 10:57:19 -0700 (PDT)
From: Abutalib Aghayev <agayev@gmail.com>
Subject: [PATCH] Log offsets of I/O operations
Date: Sun, 29 Jun 2014 13:43:12 -0400
Message-ID: <87pphr7g5d.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org


This is a quick and dirty patch to log offsets of I/O operations as
well.  It is useful if you would like to make offset vs latency plot for
random I/O, which may not be interesting to many people, so feel free to
ignore it.

diff --git a/io_u.c b/io_u.c
index 997e113..5b9d483 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1567,7 +1567,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		unsigned long tusec;

 		tusec = utime_since(&io_u->start_time, &icd->time);
-		add_lat_sample(td, idx, tusec, bytes);
+		add_lat_sample(td, idx, tusec, bytes, io_u->offset);

 		if (td->flags & TD_F_PROFILE_OPS) {
 			struct prof_io_ops *ops = &td->prof_io_ops;
@@ -1585,7 +1585,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	}

 	if (!td->o.disable_clat) {
-		add_clat_sample(td, idx, lusec, bytes);
+		add_clat_sample(td, idx, lusec, bytes, io_u->offset);
 		io_u_mark_latency(td, lusec);
 	}

@@ -1823,7 +1823,8 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 		unsigned long slat_time;

 		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
-		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen);
+		add_slat_sample(td, io_u->ddir, slat_time, io_u->xfer_buflen,
+				io_u->offset);
 	}
 }

diff --git a/iolog.c b/iolog.c
index fd1e9e4..0cea099 100644
--- a/iolog.c
+++ b/iolog.c
@@ -593,10 +593,11 @@ void __finish_log(struct io_log *log, const char *name)
 	buf = set_file_buffer(f);

 	for (i = 0; i < log->nr_samples; i++) {
-		fprintf(f, "%lu, %lu, %u, %u\n",
+		fprintf(f, "%lu, %lu, %u, %u, %lu\n",
 				(unsigned long) log->log[i].time,
 				(unsigned long) log->log[i].val,
-				log->log[i].ddir, log->log[i].bs);
+				log->log[i].ddir, log->log[i].bs,
+				log->log[i].offset);
 	}

 	fclose(f);
diff --git a/iolog.h b/iolog.h
index 3af5668..45e2cbb 100644
--- a/iolog.h
+++ b/iolog.h
@@ -26,6 +26,7 @@ struct io_sample {
 	uint64_t val;
 	uint32_t ddir;
 	uint32_t bs;
+	uint64_t offset;
 };

 enum {
@@ -121,11 +122,11 @@ extern void write_iolog_close(struct thread_data *);
  */
 extern void finalize_logs(struct thread_data *td);
 extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
-				unsigned int);
+				unsigned int, unsigned long long);
 extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned int,
 				struct timeval *);
 extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
diff --git a/stat.c b/stat.c
index 3adb46e..30f9fbb 100644
--- a/stat.c
+++ b/stat.c
@@ -1563,7 +1563,7 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long data)

 static void __add_log_sample(struct io_log *iolog, unsigned long val,
 			     enum fio_ddir ddir, unsigned int bs,
-			     unsigned long t)
+			     unsigned long t, unsigned long long offset)
 {
 	const int nr_samples = iolog->nr_samples;

@@ -1591,6 +1591,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 	iolog->log[nr_samples].time = t;
 	iolog->log[nr_samples].ddir = ddir;
 	iolog->log[nr_samples].bs = bs;
+	iolog->log[nr_samples].offset = offset;
 	iolog->nr_samples++;
 }

@@ -1646,19 +1647,19 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
 		unsigned long mr;

 		mr = iolog->avg_window[DDIR_READ].mean.u.f + 0.50;
-		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed);
+		__add_log_sample(iolog, mr, DDIR_READ, 0, elapsed, 0);
 	}
 	if (iolog->avg_window[DDIR_WRITE].samples) {
 		unsigned long mw;

 		mw = iolog->avg_window[DDIR_WRITE].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed);
+		__add_log_sample(iolog, mw, DDIR_WRITE, 0, elapsed, 0);
 	}
 	if (iolog->avg_window[DDIR_TRIM].samples) {
 		unsigned long mw;

 		mw = iolog->avg_window[DDIR_TRIM].mean.u.f + 0.50;
-		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed);
+		__add_log_sample(iolog, mw, DDIR_TRIM, 0, elapsed, 0);
 	}

 	reset_io_stat(&iolog->avg_window[DDIR_READ]);
@@ -1668,7 +1669,7 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)

 static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 			   unsigned long val, enum fio_ddir ddir,
-			   unsigned int bs)
+			   unsigned int bs, unsigned long long offset)
 {
 	unsigned long elapsed, this_window;

@@ -1681,7 +1682,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, val, ddir, bs, elapsed);
+		__add_log_sample(iolog, val, ddir, bs, elapsed, offset);
 		return;
 	}

@@ -1730,7 +1731,7 @@ void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
 		return;

 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis());
+	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis(), 0);
 }

 static void add_clat_percentile_sample(struct thread_stat *ts,
@@ -1743,7 +1744,8 @@ static void add_clat_percentile_sample(struct thread_stat *ts,
 }

 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs)
+		     unsigned long usec, unsigned int bs,
+		     unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;

@@ -1753,14 +1755,15 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], usec);

 	if (td->clat_log)
-		add_log_sample(td, td->clat_log, usec, ddir, bs);
+		add_log_sample(td, td->clat_log, usec, ddir, bs, offset);

 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
 }

 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-		     unsigned long usec, unsigned int bs)
+		     unsigned long usec, unsigned int bs,
+		     unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;

@@ -1770,11 +1773,12 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], usec);

 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, usec, ddir, bs);
+		add_log_sample(td, td->slat_log, usec, ddir, bs, offset);
 }

 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
-		    unsigned long usec, unsigned int bs)
+		    unsigned long usec, unsigned int bs,
+		    unsigned long long offset)
 {
 	struct thread_stat *ts = &td->ts;

@@ -1784,7 +1788,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->lat_stat[ddir], usec);

 	if (td->lat_log)
-		add_log_sample(td, td->lat_log, usec, ddir, bs);
+		add_log_sample(td, td->lat_log, usec, ddir, bs, offset);
 }

 void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
@@ -1818,7 +1822,7 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 		add_stat_sample(&ts->bw_stat[ddir], rate);

 		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs);
+			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);

 		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
 	}
@@ -1857,7 +1861,7 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 		add_stat_sample(&ts->iops_stat[ddir], iops);

 		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs);
+			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);

 		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
 	}
