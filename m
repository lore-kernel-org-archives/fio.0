Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbbELMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 May 2015 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ys8r2-0000E6-P7
	for fio@vger.kernel.org; Tue, 12 May 2015 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150512120002.884BF2C1079@kernel.dk>
Date: Tue, 12 May 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bddc8d161ac433712d601765dbf455349f9dada1:

  workqueue: style cleanup (2015-05-10 11:16:40 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3a5db9201bf7b1717f63cb8f7dbd025903117f70:

  Add 'per_job_logs' option (2015-05-11 13:39:36 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      Add 'per_job_logs' option

 HOWTO            | 15 ++++++++++++---
 backend.c        |  2 +-
 cconv.c          |  2 ++
 fio.1            | 13 ++++++++++---
 init.c           | 32 ++++++++++++++++++++++----------
 iolog.c          |  9 ++++++---
 iolog.h          |  2 +-
 options.c        |  9 +++++++++
 thread_options.h |  4 ++++
 9 files changed, 67 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d62d408..406cfca 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1440,6 +1440,10 @@ replay_align=int	Force alignment of IO offsets and lengths in a trace
 replay_scale=int	Scale sector offsets down by this factor when
 		replaying traces.
 
+per_job_logs=bool	If set, this generates bw/clat/iops log with per
+		file private filenames. If not set, jobs with identical names
+		will share the log filename. Default: true.
+
 write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		file. Can be used to store data of the bandwidth of the
 		jobs in their lifetime. The included fio_generate_plots
@@ -1447,7 +1451,8 @@ write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		graphs. See write_lat_log for behaviour of given
 		filename. For this option, the suffix is _bw.x.log, where
 		x is the index of the job (1..N, where N is the number of
-		jobs).
+		jobs). If 'per_job_logs' is false, then the filename will not
+		include the job index.
 
 write_lat_log=str Same as write_bw_log, except that this option stores io
 		submission, completion, and total latencies instead. If no
@@ -1460,13 +1465,17 @@ write_lat_log=str Same as write_bw_log, except that this option stores io
 		The actual log names will be foo_slat.x.log, foo_clat.x.log,
 		and foo_lat.x.log, where x is the index of the job (1..N,
 		where N is the number of jobs). This helps fio_generate_plot
-		fine the logs automatically.
+		fine the logs automatically. If 'per_job_logs' is false, then
+		the filename will not include the job index.
+
 
 write_iops_log=str Same as write_bw_log, but writes IOPS. If no filename is
 		given with this option, the default filename of
 		"jobname_type.x.log" is used,where x is the index of the job
 		(1..N, where N is the number of jobs). Even if the filename
-		is given, fio will still append the type of log.
+		is given, fio will still append the type of log. If
+		'per_job_logs' is false, then the filename will not include
+		the job index.
 
 log_avg_msec=int By default, fio will log an entry in the iops, latency,
 		or bw log for every IO that completes. When writing to the
diff --git a/backend.c b/backend.c
index 1dcdcf0..c58294b 100644
--- a/backend.c
+++ b/backend.c
@@ -2261,7 +2261,7 @@ int fio_backend(void)
 			for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 				struct io_log *log = agg_io_log[i];
 
-				flush_log(log);
+				flush_log(log, 0);
 				free_log(log);
 			}
 		}
diff --git a/cconv.c b/cconv.c
index 1e095af..bc9edb2 100644
--- a/cconv.c
+++ b/cconv.c
@@ -248,6 +248,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
+	o->per_job_logs = le32_to_cpu(top->per_job_logs);
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 
@@ -415,6 +416,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->skip_bad = cpu_to_le32(o->skip_bad);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
+	top->per_job_logs = cpu_to_le32(o->per_job_logs);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		top->bs[i] = cpu_to_le32(o->bs[i]);
diff --git a/fio.1 b/fio.1
index e5451b1..6c4e5c8 100644
--- a/fio.1
+++ b/fio.1
@@ -1271,26 +1271,33 @@ Force alignment of IO offsets and lengths in a trace to this power of 2 value.
 .BI replay_scale \fR=\fPint
 Scale sector offsets down by this factor when replaying traces.
 .TP
+.BI per_job_logs \fR=\fPbool
+If set, this generates bw/clat/iops log with per file private filenames. If
+not set, jobs with identical names will share the log filename. Default: true.
+.TP
 .BI write_bw_log \fR=\fPstr
 If given, write a bandwidth log of the jobs in this job file. Can be used to
 store data of the bandwidth of the jobs in their lifetime. The included
 fio_generate_plots script uses gnuplot to turn these text files into nice
 graphs. See \fBwrite_lat_log\fR for behaviour of given filename. For this
 option, the postfix is _bw.x.log, where x is the index of the job (1..N,
-where N is the number of jobs)
+where N is the number of jobs). If \fBper_job_logs\fR is false, then the
+filename will not include the job index.
 .TP
 .BI write_lat_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes I/O completion latencies.  If no
 filename is given with this option, the default filename of
 "jobname_type.x.log" is used, where x is the index of the job (1..N, where
 N is the number of jobs). Even if the filename is given, fio will still
-append the type of log.
+append the type of log. If \fBper_job_logs\fR is false, then the filename will
+not include the job index.
 .TP
 .BI write_iops_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with this
 option, the default filename of "jobname_type.x.log" is used, where x is the
 index of the job (1..N, where N is the number of jobs). Even if the filename
-is given, fio will still append the type of log.
+is given, fio will still append the type of log. If \fBper_job_logs\fR is false,
+then the filename will not include the job index.
 .TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
diff --git a/init.c b/init.c
index ba5bf2f..f34e818 100644
--- a/init.c
+++ b/init.c
@@ -1107,6 +1107,16 @@ int parse_dryrun(void)
 	return dump_cmdline || parse_only;
 }
 
+static void gen_log_name(char *name, size_t size, const char *logtype,
+			 const char *logname, unsigned int num,
+			 const char *suf, int per_job)
+{
+	if (per_job)
+		snprintf(name, size, "%s_%s.%d.%s", logname, logtype, num, suf);
+	else
+		snprintf(name, size, "%s_%s.%s", logname, logtype, suf);
+}
+
 /*
  * Adds a job to the list of things todo. Sanitizes the various options
  * to make sure we don't have conflicts, and initializes various
@@ -1225,14 +1235,16 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		snprintf(logname, sizeof(logname), "%s_lat.%d.%s",
-				o->lat_log_file, td->thread_number, suf);
+		gen_log_name(logname, sizeof(logname), "lat", o->lat_log_file,
+				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->lat_log, &p, logname);
-		snprintf(logname, sizeof(logname), "%s_slat.%d.%s",
-				o->lat_log_file, td->thread_number, suf);
+
+		gen_log_name(logname, sizeof(logname), "slat", o->lat_log_file,
+				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->slat_log, &p, logname);
-		snprintf(logname, sizeof(logname), "%s_clat.%d.%s",
-				o->lat_log_file, td->thread_number, suf);
+
+		gen_log_name(logname, sizeof(logname), "clat", o->lat_log_file,
+				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_log, &p, logname);
 	}
 	if (o->bw_log_file) {
@@ -1251,8 +1263,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		snprintf(logname, sizeof(logname), "%s_bw.%d.%s",
-				o->bw_log_file, td->thread_number, suf);
+		gen_log_name(logname, sizeof(logname), "bw", o->bw_log_file,
+				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->bw_log, &p, logname);
 	}
 	if (o->iops_log_file) {
@@ -1271,8 +1283,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		else
 			suf = "log";
 
-		snprintf(logname, sizeof(logname), "%s_iops.%d.%s",
-				o->iops_log_file, td->thread_number, suf);
+		gen_log_name(logname, sizeof(logname), "iops", o->iops_log_file,
+				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->iops_log, &p, logname);
 	}
 
diff --git a/iolog.c b/iolog.c
index b29684a..82b2b8a 100644
--- a/iolog.c
+++ b/iolog.c
@@ -945,12 +945,15 @@ int iolog_file_inflate(const char *file)
 
 #endif
 
-void flush_log(struct io_log *log)
+void flush_log(struct io_log *log, int do_append)
 {
 	void *buf;
 	FILE *f;
 
-	f = fopen(log->filename, "w");
+	if (!do_append)
+		f = fopen(log->filename, "w");
+	else
+		f = fopen(log->filename, "a");
 	if (!f) {
 		perror("fopen log");
 		return;
@@ -980,7 +983,7 @@ static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 	if (td->client_type == FIO_CLIENT_TYPE_GUI)
 		fio_send_iolog(td, log, log->filename);
 	else
-		flush_log(log);
+		flush_log(log, !td->o.per_job_logs);
 
 	fio_unlock_file(log->filename);
 	free_log(log);
diff --git a/iolog.h b/iolog.h
index a1e32ae..b1c13bf 100644
--- a/iolog.h
+++ b/iolog.h
@@ -215,7 +215,7 @@ extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
-extern void flush_log(struct io_log *);
+extern void flush_log(struct io_log *, int);
 extern void free_log(struct io_log *);
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
diff --git a/options.c b/options.c
index e306b28..5c6ec23 100644
--- a/options.c
+++ b/options.c
@@ -3184,6 +3184,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_PROCESS,
 	},
 	{
+		.name	= "per_job_logs",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(per_job_logs),
+		.help	= "Include job number in generated log files or not",
+		.def	= "1",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "write_bw_log",
 		.lname	= "Write bandwidth log",
 		.type	= FIO_OPT_STR_STORE,
diff --git a/thread_options.h b/thread_options.h
index 1c48bd8..f967a8a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -268,6 +268,8 @@ struct thread_options {
 
 	unsigned int replay_align;
 	unsigned int replay_scale;
+
+	unsigned int per_job_logs;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -501,6 +503,8 @@ struct thread_options_pack {
 
 	uint32_t replay_align;
 	uint32_t replay_scale;
+
+	uint32_t per_job_logs;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
