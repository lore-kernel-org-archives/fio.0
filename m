Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbcBENAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Feb 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1aRfzY-0005Qs-7l
	for fio@vger.kernel.org; Fri, 05 Feb 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160205130001.B3F142C2155@kernel.dk>
Date: Fri,  5 Feb 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d96d3bb34689d0290174134e5a4770056dd4f980:

  stat: cleanup average logging (2016-02-03 21:10:33 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e6989e10964f5ae30e0ba8f0cd27a663baf5617b:

  log: add support for logging max instead of averages (2016-02-04 12:09:48 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      log: add support for logging max instead of averages

 HOWTO            |  6 +++++-
 cconv.c          |  2 ++
 fio.1            |  9 +++++++--
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 stat.c           | 25 +++++++++++++++----------
 thread_options.h |  7 ++++++-
 7 files changed, 46 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4a910a1..6d80360 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1570,8 +1570,12 @@ log_avg_msec=int By default, fio will log an entry in the iops, latency,
 		disk log, that can quickly grow to a very large size. Setting
 		this option makes fio average the each log entry over the
 		specified period of time, reducing the resolution of the log.
-		Defaults to 0.
+		See log_max as well. Defaults to 0, logging all entries.
 
+log_max=bool	If log_avg_msec is set, fio logs the average over that window.
+		If you instead want to log the maximum value, set this option
+		to 1. Defaults to 0, meaning that averaged values are logged.
+.
 log_offset=int	If this is set, the iolog options will include the byte
 		offset for the IO entry as well as the other data values.
 
diff --git a/cconv.c b/cconv.c
index 6d8d0b3..6f57d90 100644
--- a/cconv.c
+++ b/cconv.c
@@ -160,6 +160,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->allrand_repeatable = le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed = le64_to_cpu(top->rand_seed);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
+	o->log_max = le32_to_cpu(top->log_max);
 	o->log_offset = le32_to_cpu(top->log_offset);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
@@ -348,6 +349,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->allrand_repeatable = cpu_to_le32(o->allrand_repeatable);
 	top->rand_seed = __cpu_to_le64(o->rand_seed);
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
+	top->log_max = cpu_to_le32(o->log_max);
 	top->log_offset = cpu_to_le32(o->log_offset);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
diff --git a/fio.1 b/fio.1
index 6cc6379..246bcd2 100644
--- a/fio.1
+++ b/fio.1
@@ -1423,8 +1423,13 @@ then the filename will not include the job index.
 By default, fio will log an entry in the iops, latency, or bw log for every
 IO that completes. When writing to the disk log, that can quickly grow to a
 very large size. Setting this option makes fio average the each log entry
-over the specified period of time, reducing the resolution of the log.
-Defaults to 0.
+over the specified period of time, reducing the resolution of the log. See
+\fBlog_max\fR as well.  Defaults to 0, logging all entries.
+.TP
+.BI log_max \fR=\fPbool
+If \fBlog_avg_msec\fR is set, fio logs the average over that window. If you
+instead want to log the maximum value, set this option to 1.  Defaults to
+0, meaning that averaged values are logged.
 .TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the IO
diff --git a/options.c b/options.c
index 0bf1390..3902087 100644
--- a/options.c
+++ b/options.c
@@ -3074,6 +3074,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "log_max_value",
+		.lname	= "Log maximum instead of average",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(log_max),
+		.help	= "Log max sample in a window instead of average",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "log_offset",
 		.lname	= "Log offset of IO",
 		.type	= FIO_OPT_BOOL,
diff --git a/server.h b/server.h
index 05f98e5..a726894 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 51,
+	FIO_SERVER_VER			= 52,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 73fd9f9..d2720a4 100644
--- a/stat.c
+++ b/stat.c
@@ -1943,7 +1943,7 @@ void reset_io_stats(struct thread_data *td)
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-			      unsigned long elapsed)
+			      unsigned long elapsed, bool log_max)
 {
 	/*
 	 * Note an entry in the log. Use the mean from the logged samples,
@@ -1953,19 +1953,24 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	if (iolog->avg_window[ddir].samples) {
 		unsigned long val;
 
-		val = iolog->avg_window[ddir].mean.u.f + 0.50;
+		if (log_max)
+			val = iolog->avg_window[ddir].max_val;
+		else
+			val = iolog->avg_window[ddir].mean.u.f + 0.50;
+
 		__add_log_sample(iolog, val, ddir, 0, elapsed, 0);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
 }
 
-static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed)
+static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
+			     bool log_max)
 {
 	int ddir;
 
 	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
-		__add_stat_to_log(iolog, ddir, elapsed);
+		__add_stat_to_log(iolog, ddir, elapsed, log_max);
 }
 
 static void add_log_sample(struct thread_data *td, struct io_log *iolog,
@@ -2001,7 +2006,7 @@ static void add_log_sample(struct thread_data *td, struct io_log *iolog,
 	if (this_window < iolog->avg_msec)
 		return;
 
-	_add_stat_to_log(iolog, elapsed);
+	_add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
 
 	iolog->avg_last = elapsed;
 }
@@ -2013,15 +2018,15 @@ void finalize_logs(struct thread_data *td)
 	elapsed = mtime_since_now(&td->epoch);
 
 	if (td->clat_log)
-		_add_stat_to_log(td->clat_log, elapsed);
+		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
 	if (td->slat_log)
-		_add_stat_to_log(td->slat_log, elapsed);
+		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
 	if (td->lat_log)
-		_add_stat_to_log(td->lat_log, elapsed);
+		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
 	if (td->bw_log)
-		_add_stat_to_log(td->bw_log, elapsed);
+		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
 	if (td->iops_log)
-		_add_stat_to_log(td->iops_log, elapsed);
+		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
 void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
diff --git a/thread_options.h b/thread_options.h
index 858f307..384534a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -120,6 +120,7 @@ struct thread_options {
 	unsigned long long rand_seed;
 	unsigned int dep_use_os_rand;
 	unsigned int log_avg_msec;
+	unsigned int log_max;
 	unsigned int log_offset;
 	unsigned int log_gz;
 	unsigned int log_gz_store;
@@ -369,6 +370,7 @@ struct thread_options_pack {
 	uint64_t rand_seed;
 	uint32_t dep_use_os_rand;
 	uint32_t log_avg_msec;
+	uint32_t log_max;
 	uint32_t log_offset;
 	uint32_t log_gz;
 	uint32_t log_gz_store;
@@ -380,6 +382,7 @@ struct thread_options_pack {
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
+	uint32_t pad0;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
@@ -397,6 +400,7 @@ struct thread_options_pack {
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
 	uint32_t barrier_blocks;
+	uint32_t pad1;
 	uint64_t start_delay;
 	uint64_t start_delay_high;
 	uint64_t timeout;
@@ -461,6 +465,7 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -483,7 +488,6 @@ struct thread_options_pack {
 	uint32_t rate_iops[DDIR_RWDIR_CNT];
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
 	uint32_t rate_process;
-	uint32_t padding_0;   /* for alignment assert */
 
 	uint8_t ioscheduler[FIO_TOP_STR_MAX];
 
@@ -516,6 +520,7 @@ struct thread_options_pack {
 	uint64_t number_ios;
 
 	uint32_t sync_file_range;
+	uint32_t pad3;
 
 	uint64_t latency_target;
 	uint64_t latency_window;
