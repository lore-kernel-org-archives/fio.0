Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34156 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753933AbcJLMBc (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Oct 2016 08:01:32 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1buICY-0002KN-VP
        for fio@vger.kernel.org; Wed, 12 Oct 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161012120001.DADA42C0400@kernel.dk>
Date: Wed, 12 Oct 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d619275cfad893e37e8c59e5c9e0bc5ca4946b82:

  filehash: fix init/exit (2016-09-27 10:28:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d23ae82785f99927331e358d2c0deac5e53f2df1:

  Update bandwidth log documentation (2016-10-11 16:04:28 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      windowsaio: fix completion thread affinitization

Omar Sandoval (4):
      init: fix --bandwidth-log without argument
      iolog: fix --bandwidth-log segfaults
      iolog: make write_*_log prefix optional
      Update bandwidth log documentation

 README               |  2 +-
 cconv.c              |  8 ++++++++
 engines/windowsaio.c |  9 +++++++--
 fio.1                | 16 +++++++--------
 init.c               | 28 +++++++++++++++-----------
 iolog.c              |  2 +-
 options.c            | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
 server.h             |  2 +-
 stat.c               |  2 +-
 thread_options.h     | 12 +++++++++++
 10 files changed, 107 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index a69a578..a8a4fdf 100644
--- a/README
+++ b/README
@@ -149,7 +149,7 @@ $ fio
 	--parse-only		Parse options only, don't start any IO
 	--output		Write output to file
 	--runtime		Runtime in seconds
-	--bandwidth-log		Generate per-job bandwidth logs
+	--bandwidth-log		Generate aggregate bandwidth logs
 	--minimal		Minimal (terse) output
 	--output-format=type	Output format (terse,json,json+,normal)
 	--terse-version=type	Terse version output format (default 3, or 2 or 4).
diff --git a/cconv.c b/cconv.c
index 194e342..6e0f609 100644
--- a/cconv.c
+++ b/cconv.c
@@ -280,6 +280,10 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
 	o->per_job_logs = le32_to_cpu(top->per_job_logs);
+	o->write_bw_log = le32_to_cpu(top->write_bw_log);
+	o->write_lat_log = le32_to_cpu(top->write_lat_log);
+	o->write_iops_log = le32_to_cpu(top->write_iops_log);
+	o->write_hist_log = le32_to_cpu(top->write_hist_log);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 	o->rate_process = le32_to_cpu(top->rate_process);
@@ -460,6 +464,10 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
+	top->write_bw_log = cpu_to_le32(o->write_bw_log);
+	top->write_lat_log = cpu_to_le32(o->write_lat_log);
+	top->write_iops_log = cpu_to_le32(o->write_iops_log);
+	top->write_hist_log = cpu_to_le32(o->write_hist_log);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		top->bs[i] = cpu_to_le32(o->bs[i]);
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 0e164b6..f5cb048 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -113,10 +113,15 @@ static int fio_windowsaio_init(struct thread_data *td)
 
 		if (!rc)
 		{
+			DWORD threadid;
+
 			ctx->iocp = hFile;
 			ctx->wd = wd;
-			wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, NULL);
-			if (wd->iothread == NULL)
+			wd->iothread = CreateThread(NULL, 0, IoCompletionRoutine, ctx, 0, &threadid);
+
+			if (wd->iothread != NULL)
+				fio_setaffinity(threadid, td->o.cpumask);
+			else
 				log_err("windowsaio: failed to create io completion thread\n");
 		}
 
diff --git a/fio.1 b/fio.1
index 8d596fb..48c2060 100644
--- a/fio.1
+++ b/fio.1
@@ -30,7 +30,7 @@ dump of the latency buckets.
 Limit run time to \fIruntime\fR seconds.
 .TP
 .B \-\-bandwidth\-log
-Generate per-job bandwidth logs.
+Generate aggregate bandwidth logs.
 .TP
 .B \-\-minimal
 Print statistics in a terse, semicolon-delimited format.
@@ -1462,13 +1462,13 @@ If set, this generates bw/clat/iops log with per file private filenames. If
 not set, jobs with identical names will share the log filename. Default: true.
 .TP
 .BI write_bw_log \fR=\fPstr
-If given, write a bandwidth log of the jobs in this job file. Can be used to
-store data of the bandwidth of the jobs in their lifetime. The included
-fio_generate_plots script uses gnuplot to turn these text files into nice
-graphs. See \fBwrite_lat_log\fR for behaviour of given filename. For this
-option, the postfix is _bw.x.log, where x is the index of the job (1..N,
-where N is the number of jobs). If \fBper_job_logs\fR is false, then the
-filename will not include the job index. See the \fBLOG FILE FORMATS\fR
+If given, write a bandwidth log for this job. Can be used to store data of the
+bandwidth of the jobs in their lifetime. The included fio_generate_plots script
+uses gnuplot to turn these text files into nice graphs. See \fBwrite_lat_log\fR
+for behaviour of given filename. For this option, the postfix is _bw.x.log,
+where x is the index of the job (1..N, where N is the number of jobs). If
+\fBper_job_logs\fR is false, then the filename will not include the job index.
+See the \fBLOG FILE FORMATS\fR
 section.
 .TP
 .BI write_lat_log \fR=\fPstr
diff --git a/init.c b/init.c
index c556fa2..d8c0bd1 100644
--- a/init.c
+++ b/init.c
@@ -103,7 +103,7 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 	},
 	{
 		.name		= (char *) "bandwidth-log",
-		.has_arg	= required_argument,
+		.has_arg	= no_argument,
 		.val		= 'b' | FIO_CLIENT_FLAG,
 	},
 	{
@@ -1389,7 +1389,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
-	if (o->lat_log_file) {
+	if (o->write_lat_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1400,6 +1400,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->lat_log_file ? o->lat_log_file : o->name;
 		const char *suf;
 
 		if (p.log_gz_store)
@@ -1407,20 +1408,20 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "lat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "lat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->lat_log, &p, logname);
 
-		gen_log_name(logname, sizeof(logname), "slat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "slat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->slat_log, &p, logname);
 
-		gen_log_name(logname, sizeof(logname), "clat", o->lat_log_file,
+		gen_log_name(logname, sizeof(logname), "clat", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_log, &p, logname);
 	}
 
-	if (o->hist_log_file) {
+	if (o->write_hist_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1431,6 +1432,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->hist_log_file ? o->hist_log_file : o->name;
 		const char *suf;
 
 #ifndef CONFIG_ZLIB
@@ -1445,12 +1447,12 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "clat_hist", o->hist_log_file,
+		gen_log_name(logname, sizeof(logname), "clat_hist", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_hist_log, &p, logname);
 	}
 
-	if (o->bw_log_file) {
+	if (o->write_bw_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1461,6 +1463,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->bw_log_file ? o->bw_log_file : o->name;
 		const char *suf;
 
 		if (fio_option_is_set(o, bw_avg_time))
@@ -1476,11 +1479,11 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "bw", o->bw_log_file,
+		gen_log_name(logname, sizeof(logname), "bw", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->bw_log, &p, logname);
 	}
-	if (o->iops_log_file) {
+	if (o->write_iops_log) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
@@ -1491,6 +1494,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			.log_gz = o->log_gz,
 			.log_gz_store = o->log_gz_store,
 		};
+		const char *pre = o->iops_log_file ? o->iops_log_file : o->name;
 		const char *suf;
 
 		if (fio_option_is_set(o, iops_avg_time))
@@ -1506,7 +1510,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		gen_log_name(logname, sizeof(logname), "iops", o->iops_log_file,
+		gen_log_name(logname, sizeof(logname), "iops", pre,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->iops_log, &p, logname);
 	}
@@ -2001,7 +2005,7 @@ static void usage(const char *name)
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
 	printf("  --runtime\t\tRuntime in seconds\n");
-	printf("  --bandwidth-log\tGenerate per-job bandwidth logs\n");
+	printf("  --bandwidth-log\tGenerate aggregate bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
 	printf("  --output-format=x\tOutput format (terse,json,json+,normal)\n");
 	printf("  --terse-version=x\tSet terse version output format to 'x'\n");
diff --git a/iolog.c b/iolog.c
index 6576ca5..ab9c878 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1065,7 +1065,7 @@ void flush_log(struct io_log *log, bool do_append)
 		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
 		flist_del_init(&cur_log->list);
 		
-		if (log == log->td->clat_hist_log)
+		if (log->td && log == log->td->clat_hist_log)
 			flush_hist_samples(f, log->hist_coarseness, cur_log->log,
 			                   log_sample_sz(log, cur_log));
 		else
diff --git a/options.c b/options.c
index 50b4d09..bcda556 100644
--- a/options.c
+++ b/options.c
@@ -1311,6 +1311,50 @@ static int str_size_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
+static int str_write_bw_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.bw_log_file = strdup(str);
+
+	td->o.write_bw_log = 1;
+	return 0;
+}
+
+static int str_write_lat_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.lat_log_file = strdup(str);
+
+	td->o.write_lat_log = 1;
+	return 0;
+}
+
+static int str_write_iops_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.iops_log_file = strdup(str);
+
+	td->o.write_iops_log = 1;
+	return 0;
+}
+
+static int str_write_hist_log_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+
+	if (str)
+		td->o.hist_log_file = strdup(str);
+
+	td->o.write_hist_log = 1;
+	return 0;
+}
+
 static int rw_verify(struct fio_option *o, void *data)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -3507,8 +3551,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_bw_log",
 		.lname	= "Write bandwidth log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, bw_log_file),
+		.cb	= str_write_bw_log_cb,
 		.help	= "Write log of bandwidth during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3516,8 +3561,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_lat_log",
 		.lname	= "Write latency log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, lat_log_file),
+		.cb	= str_write_lat_log_cb,
 		.help	= "Write log of latency during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3525,8 +3571,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_iops_log",
 		.lname	= "Write IOPS log",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, iops_log_file),
+		.cb	= str_write_iops_log_cb,
 		.help	= "Write log of IOPS during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
@@ -3566,8 +3613,9 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "write_hist_log",
 		.lname	= "Write latency histogram logs",
-		.type	= FIO_OPT_STR_STORE,
+		.type	= FIO_OPT_STR,
 		.off1	= offsetof(struct thread_options, hist_log_file),
+		.cb	= str_write_hist_log_cb,
 		.help	= "Write log of latency histograms during run",
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
diff --git a/server.h b/server.h
index 6c572a1..3b592c7 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 57,
+	FIO_SERVER_VER			= 58,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 3c72a6c..1e889f5 100644
--- a/stat.c
+++ b/stat.c
@@ -2023,7 +2023,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
 		s->val = val;
-		s->time = t + iolog->td->unix_epoch;
+		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
 
diff --git a/thread_options.h b/thread_options.h
index 1b4590f..5e379e3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -233,6 +233,12 @@ struct thread_options {
 
 	char *read_iolog_file;
 	char *write_iolog_file;
+
+	unsigned int write_bw_log;
+	unsigned int write_lat_log;
+	unsigned int write_iops_log;
+	unsigned int write_hist_log;
+
 	char *bw_log_file;
 	char *lat_log_file;
 	char *iops_log_file;
@@ -492,6 +498,12 @@ struct thread_options_pack {
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
+
+	uint32_t write_bw_log;
+	uint32_t write_lat_log;
+	uint32_t write_iops_log;
+	uint32_t write_hist_log;
+
 	uint8_t bw_log_file[FIO_TOP_STR_MAX];
 	uint8_t lat_log_file[FIO_TOP_STR_MAX];
 	uint8_t iops_log_file[FIO_TOP_STR_MAX];
