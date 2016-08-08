Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56060 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcHHMAK (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 8 Aug 2016 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bWjE0-0006yQ-Mc
	for fio@vger.kernel.org; Mon, 08 Aug 2016 12:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160808120002.427E02C00A2@kernel.dk>
Date: Mon,  8 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5fd31680d0370c6b71ccfa456ade211477af81d6:

  Revert "filesetup: ensure that we catch a file flagged for extend" (2016-08-04 19:41:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 93168285bc564941d832deea172dc1f68de68666:

  stat: fixups to histogram logging (2016-08-07 15:18:38 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Merge branch 'histograms-PR' of https://github.com/cronburg/fio
      server: bump protocol version
      iolog: style updates
      stat: fixups to histogram logging

Karl Cronburg (1):
      This commit / feature adds completion latency histogram output to fio, piggybacking     on the existing histograms recorded by stat.c and adding the following command     line options:

 HOWTO                           |  22 ++
 cconv.c                         |   5 +
 fio.1                           |  29 +++
 fio.h                           |   1 +
 init.c                          |  36 +++
 iolog.c                         |  73 +++++-
 iolog.h                         |  16 ++
 options.c                       |  31 +++
 server.h                        |   2 +-
 stat.c                          |  40 ++++
 thread_options.h                |   6 +
 tools/hist/.gitignore           |   3 +
 tools/hist/fiologparser_hist.py | 486 ++++++++++++++++++++++++++++++++++++++++
 tools/hist/half-bins.py         |  38 ++++
 14 files changed, 785 insertions(+), 3 deletions(-)
 create mode 100644 tools/hist/.gitignore
 create mode 100755 tools/hist/fiologparser_hist.py
 create mode 100755 tools/hist/half-bins.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d18d59b..0085b74 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1610,6 +1610,14 @@ write_lat_log=str Same as write_bw_log, except that this option stores io
 		the filename will not include the job index. See 'Log File
 		Formats'.
 
+write_hist_log=str Same as write_lat_log, but writes I/O completion
+		latency histograms. If no filename is given with this option, the
+		default filename of "jobname_clat_hist.x.log" is used, where x is
+		the index of the job (1..N, where N is the number of jobs). Even
+		if the filename is given, fio will still append the type of log.
+		If per_job_logs is false, then the filename will not include the
+		job index. See 'Log File Formats'.
+
 write_iops_log=str Same as write_bw_log, but writes IOPS. If no filename is
 		given with this option, the default filename of
 		"jobname_type.x.log" is used,where x is the index of the job
@@ -1625,6 +1633,20 @@ log_avg_msec=int By default, fio will log an entry in the iops, latency,
 		specified period of time, reducing the resolution of the log.
 		See log_max_value as well. Defaults to 0, logging all entries.
 
+log_hist_msec=int Same as log_avg_msec, but logs entries for completion
+		latency histograms. Computing latency percentiles from averages of
+		intervals using log_avg_msec is innacurate. Setting this option makes
+		fio log histogram entries over the specified period of time, reducing
+		log sizes for high IOPS devices while retaining percentile accuracy.
+		See log_hist_coarseness as well. Defaults to 0, meaning histogram
+		logging is disabled.
+
+log_hist_coarseness=int Integer ranging from 0 to 6, defining the coarseness
+		of the resolution of the histogram logs enabled with log_hist_msec. For
+		each increment in coarseness, fio outputs half as many bins. Defaults to
+		0, for which histogram logs contain 1216 latency bins. See
+		'Log File Formats'.
+
 log_max_value=bool	If log_avg_msec is set, fio logs the average over that
 		window. If you instead want to log the maximum value, set this
 		option to 1. Defaults to 0, meaning that averaged values are
diff --git a/cconv.c b/cconv.c
index ac826a3..837963d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -39,6 +39,7 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->bw_log_file);
 	free(o->lat_log_file);
 	free(o->iops_log_file);
+	free(o->hist_log_file);
 	free(o->replay_redirect);
 	free(o->exec_prerun);
 	free(o->exec_postrun);
@@ -74,6 +75,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->bw_log_file, top->bw_log_file);
 	string_to_cpu(&o->lat_log_file, top->lat_log_file);
 	string_to_cpu(&o->iops_log_file, top->iops_log_file);
+	string_to_cpu(&o->hist_log_file, top->hist_log_file);
 	string_to_cpu(&o->replay_redirect, top->replay_redirect);
 	string_to_cpu(&o->exec_prerun, top->exec_prerun);
 	string_to_cpu(&o->exec_postrun, top->exec_postrun);
@@ -178,6 +180,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->allrand_repeatable = le32_to_cpu(top->allrand_repeatable);
 	o->rand_seed = le64_to_cpu(top->rand_seed);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
+	o->log_hist_msec = le32_to_cpu(top->log_hist_msec);
+	o->log_hist_coarseness = le32_to_cpu(top->log_hist_coarseness);
 	o->log_max = le32_to_cpu(top->log_max);
 	o->log_offset = le32_to_cpu(top->log_offset);
 	o->log_gz = le32_to_cpu(top->log_gz);
@@ -309,6 +313,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->bw_log_file, o->bw_log_file);
 	string_to_net(top->lat_log_file, o->lat_log_file);
 	string_to_net(top->iops_log_file, o->iops_log_file);
+	string_to_net(top->hist_log_file, o->hist_log_file);
 	string_to_net(top->replay_redirect, o->replay_redirect);
 	string_to_net(top->exec_prerun, o->exec_prerun);
 	string_to_net(top->exec_postrun, o->exec_postrun);
diff --git a/fio.1 b/fio.1
index 85eb0fe..d1acebc 100644
--- a/fio.1
+++ b/fio.1
@@ -1476,6 +1476,14 @@ N is the number of jobs). Even if the filename is given, fio will still
 append the type of log. If \fBper_job_logs\fR is false, then the filename will
 not include the job index. See the \fBLOG FILE FORMATS\fR section.
 .TP
+.BI write_hist_log \fR=\fPstr
+Same as \fBwrite_lat_log\fR, but writes I/O completion latency histograms. If
+no filename is given with this option, the default filename of
+"jobname_clat_hist.x.log" is used, where x is the index of the job (1..N, where
+N is the number of jobs). Even if the filename is given, fio will still append
+the type of log. If \fBper_job_logs\fR is false, then the filename will not
+include the job index. See the \fBLOG FILE FORMATS\fR section.
+.TP
 .BI write_iops_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with this
 option, the default filename of "jobname_type.x.log" is used, where x is the
@@ -1496,6 +1504,20 @@ If \fBlog_avg_msec\fR is set, fio logs the average over that window. If you
 instead want to log the maximum value, set this option to 1.  Defaults to
 0, meaning that averaged values are logged.
 .TP
+.BI log_hist_msec \fR=\fPint
+Same as \fBlog_avg_msec\fR, but logs entries for completion latency histograms.
+Computing latency percentiles from averages of intervals using \fBlog_avg_msec\fR
+is innacurate. Setting this option makes fio log histogram entries over the
+specified period of time, reducing log sizes for high IOPS devices while
+retaining percentile accuracy. See \fBlog_hist_coarseness\fR as well. Defaults
+to 0, meaning histogram logging is disabled.
+.TP
+.BI log_hist_coarseness \fR=\fPint
+Integer ranging from 0 to 6, defining the coarseness of the resolution of the
+histogram logs enabled with \fBlog_hist_msec\fR. For each increment in
+coarseness, fio outputs half as many bins. Defaults to 0, for which histogram
+logs contain 1216 latency bins. See the \fBLOG FILE FORMATS\fR section.
+.TP
 .BI log_offset \fR=\fPbool
 If this is set, the iolog options will include the byte offset for the IO
 entry as well as the other data values.
@@ -2302,6 +2324,13 @@ they aren't applicable if windowed logging is enabled. If windowed logging
 is enabled and \fBlog_max_value\fR is set, then fio logs maximum values in
 that window instead of averages.
 
+For histogram logging the logs look like this:
+
+.B time (msec), data direction, block-size, bin 0, bin 1, ..., bin 1215
+
+Where 'bin i' gives the frequency of IO requests with a latency falling in
+the i-th bin. See \fBlog_hist_coarseness\fR for logging fewer bins.
+
 .RE
 
 .SH CLIENT / SERVER
diff --git a/fio.h b/fio.h
index 87a94f6..d929467 100644
--- a/fio.h
+++ b/fio.h
@@ -141,6 +141,7 @@ struct thread_data {
 
 	struct io_log *slat_log;
 	struct io_log *clat_log;
+	struct io_log *clat_hist_log;
 	struct io_log *lat_log;
 	struct io_log *bw_log;
 	struct io_log *iops_log;
diff --git a/init.c b/init.c
index f81db3c..048bd5d 100644
--- a/init.c
+++ b/init.c
@@ -1418,6 +1418,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
+			.hist_msec = o->log_hist_msec,
+			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_LAT,
 			.log_offset = o->log_offset,
 			.log_gz = o->log_gz,
@@ -1442,10 +1444,36 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				td->thread_number, suf, o->per_job_logs);
 		setup_log(&td->clat_log, &p, logname);
 	}
+
+	if (o->hist_log_file) {
+		struct log_params p = {
+			.td = td,
+			.avg_msec = o->log_avg_msec,
+			.hist_msec = o->log_hist_msec,
+			.hist_coarseness = o->log_hist_coarseness,
+			.log_type = IO_LOG_TYPE_HIST,
+			.log_offset = o->log_offset,
+			.log_gz = o->log_gz,
+			.log_gz_store = o->log_gz_store,
+		};
+		const char *suf;
+
+		if (p.log_gz_store)
+			suf = "log.fz";
+		else
+			suf = "log";
+
+		gen_log_name(logname, sizeof(logname), "clat_hist", o->hist_log_file,
+				td->thread_number, suf, o->per_job_logs);
+		setup_log(&td->clat_hist_log, &p, logname);
+	}
+
 	if (o->bw_log_file) {
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
+			.hist_msec = o->log_hist_msec,
+			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_BW,
 			.log_offset = o->log_offset,
 			.log_gz = o->log_gz,
@@ -1457,6 +1485,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			p.avg_msec = min(o->log_avg_msec, o->bw_avg_time);
 		else
 			o->bw_avg_time = p.avg_msec;
+	
+		p.hist_msec = o->log_hist_msec;
+		p.hist_coarseness = o->log_hist_coarseness;
 
 		if (p.log_gz_store)
 			suf = "log.fz";
@@ -1471,6 +1502,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
+			.hist_msec = o->log_hist_msec,
+			.hist_coarseness = o->log_hist_coarseness,
 			.log_type = IO_LOG_TYPE_IOPS,
 			.log_offset = o->log_offset,
 			.log_gz = o->log_gz,
@@ -1482,6 +1515,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			p.avg_msec = min(o->log_avg_msec, o->iops_avg_time);
 		else
 			o->iops_avg_time = p.avg_msec;
+	
+		p.hist_msec = o->log_hist_msec;
+		p.hist_coarseness = o->log_hist_coarseness;
 
 		if (p.log_gz_store)
 			suf = "log.fz";
diff --git a/iolog.c b/iolog.c
index 4c87f1c..a9cbd5b 100644
--- a/iolog.c
+++ b/iolog.c
@@ -584,6 +584,8 @@ void setup_log(struct io_log **log, struct log_params *p,
 	l->log_gz = p->log_gz;
 	l->log_gz_store = p->log_gz_store;
 	l->avg_msec = p->avg_msec;
+	l->hist_msec = p->hist_msec;
+	l->hist_coarseness = p->hist_coarseness;
 	l->filename = strdup(filename);
 	l->td = p->td;
 
@@ -659,6 +661,48 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
+static inline int hist_sum(int j, int stride, unsigned int *io_u_plat)
+{
+	int k, sum;
+
+	for (k = sum = 0; k < stride; k++)
+		sum += io_u_plat[j + k];
+
+	return sum;
+}
+
+void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
+			uint64_t sample_size)
+{
+	struct io_sample *s;
+	int log_offset;
+	uint64_t i, j, nr_samples;
+	unsigned int *io_u_plat;
+
+	int stride = 1 << hist_coarseness;
+	
+	if (!sample_size)
+		return;
+
+	s = __get_sample(samples, 0, 0);
+	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+
+	nr_samples = sample_size / __log_entry_sz(log_offset);
+
+	for (i = 0; i < nr_samples; i++) {
+		s = __get_sample(samples, log_offset, i);
+		io_u_plat = (unsigned int *) s->val;
+		fprintf(f, "%lu, %u, %u, ", (unsigned long)s->time,
+		        io_sample_ddir(s), s->bs);
+		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
+			fprintf(f, "%lu, ", (unsigned long) hist_sum(j, stride, io_u_plat)); 
+		}
+		fprintf(f, "%lu\n", (unsigned long) 
+		        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat));
+		free(io_u_plat);
+	}
+}
+
 void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
@@ -988,7 +1032,13 @@ void flush_log(struct io_log *log, bool do_append)
 
 		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
 		flist_del_init(&cur_log->list);
-		flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(log));
+		
+		if (log == log->td->clat_hist_log)
+			flush_hist_samples(f, log->hist_coarseness, cur_log->log,
+			                   cur_log->nr_samples * log_entry_sz(log));
+		else
+			flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(log));
+		
 		sfree(cur_log);
 	}
 
@@ -1353,6 +1403,20 @@ static int write_clat_log(struct thread_data *td, int try, bool unit_log)
 	return ret;
 }
 
+static int write_clat_hist_log(struct thread_data *td, int try, bool unit_log)
+{
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->clat_hist_log, try);
+	if (!ret)
+		td->clat_hist_log = NULL;
+
+	return ret;
+}
+
 static int write_lat_log(struct thread_data *td, int try, bool unit_log)
 {
 	int ret;
@@ -1387,8 +1451,9 @@ enum {
 	SLAT_LOG_MASK	= 4,
 	CLAT_LOG_MASK	= 8,
 	IOPS_LOG_MASK	= 16,
+	CLAT_HIST_LOG_MASK = 32,
 
-	ALL_LOG_NR	= 5,
+	ALL_LOG_NR	= 6,
 };
 
 struct log_type {
@@ -1417,6 +1482,10 @@ static struct log_type log_types[] = {
 		.mask	= IOPS_LOG_MASK,
 		.fn	= write_iops_log,
 	},
+	{
+		.mask	= CLAT_HIST_LOG_MASK,
+		.fn	= write_clat_hist_log,
+	}
 };
 
 void td_writeout_logs(struct thread_data *td, bool unit_logs)
diff --git a/iolog.h b/iolog.h
index 0438fa7..011179a 100644
--- a/iolog.h
+++ b/iolog.h
@@ -18,6 +18,11 @@ struct io_stat {
 	fio_fp64_t S;
 };
 
+struct io_hist {
+	uint64_t samples;
+	unsigned long hist_last;
+};
+
 /*
  * A single data sample
  */
@@ -39,6 +44,7 @@ enum {
 	IO_LOG_TYPE_SLAT,
 	IO_LOG_TYPE_BW,
 	IO_LOG_TYPE_IOPS,
+	IO_LOG_TYPE_HIST,
 };
 
 #define DEF_LOG_ENTRIES		1024
@@ -103,6 +109,14 @@ struct io_log {
 	unsigned long avg_msec;
 	unsigned long avg_last;
 
+  /*
+   * Windowed latency histograms, for keeping track of when we need to
+   * save a copy of the histogram every approximately hist_msec milliseconds.
+   */
+	struct io_hist hist_window[DDIR_RWDIR_CNT];
+	unsigned long hist_msec;
+	int hist_coarseness;
+
 	pthread_mutex_t chunk_lock;
 	unsigned int chunk_seq;
 	struct flist_head chunk_list;
@@ -218,6 +232,8 @@ extern int iolog_file_inflate(const char *);
 struct log_params {
 	struct thread_data *td;
 	unsigned long avg_msec;
+	unsigned long hist_msec;
+	int hist_coarseness;
 	int log_type;
 	int log_offset;
 	int log_gz;
diff --git a/options.c b/options.c
index 4c56dbe..56d3e2b 100644
--- a/options.c
+++ b/options.c
@@ -3530,6 +3530,37 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "log_hist_msec",
+		.lname	= "Log histograms (msec)",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(log_hist_msec),
+		.help	= "Dump completion latency histograms at frequency of this time value",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "log_hist_coarseness",
+		.lname	= "Histogram logs coarseness",
+		.type	= FIO_OPT_INT,
+		.off1	= td_var_offset(log_hist_coarseness),
+		.help	= "Integer in range [0,6]. Higher coarseness outputs"
+			" fewer histogram bins per sample. The number of bins for"
+			" these are [1216, 608, 304, 152, 76, 38, 19] respectively.",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "write_hist_log",
+		.lname	= "Write latency histogram logs",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= td_var_offset(hist_log_file),
+		.help	= "Write log of latency histograms during run",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "log_max_value",
 		.lname	= "Log maximum instead of average",
 		.type	= FIO_OPT_BOOL,
diff --git a/server.h b/server.h
index 79c751d..c17c3bb 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 54,
+	FIO_SERVER_VER			= 55,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index d6787b7..ef9fe7d 100644
--- a/stat.c
+++ b/stat.c
@@ -1965,6 +1965,7 @@ void regrow_logs(struct thread_data *td)
 {
 	regrow_log(td->slat_log);
 	regrow_log(td->clat_log);
+	regrow_log(td->clat_hist_log);
 	regrow_log(td->lat_log);
 	regrow_log(td->bw_log);
 	regrow_log(td->iops_log);
@@ -2195,7 +2196,9 @@ static void add_clat_percentile_sample(struct thread_stat *ts,
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long usec, unsigned int bs, uint64_t offset)
 {
+	unsigned long elapsed, this_window;
 	struct thread_stat *ts = &td->ts;
+	struct io_log *iolog = td->clat_hist_log;
 
 	td_io_u_lock(td);
 
@@ -2207,6 +2210,43 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
 
+	if (iolog && iolog->hist_msec) {
+		struct io_hist *hw = &iolog->hist_window[ddir];
+
+		hw->samples++;
+		elapsed = mtime_since_now(&td->epoch);
+		if (!hw->hist_last)
+			hw->hist_last = elapsed;
+		this_window = elapsed - hw->hist_last;
+		
+		if (this_window >= iolog->hist_msec) {
+			unsigned int *io_u_plat;
+			unsigned int *dst;
+
+			/*
+			 * Make a byte-for-byte copy of the latency histogram
+			 * stored in td->ts.io_u_plat[ddir], recording it in a
+			 * log sample. Note that the matching call to free() is
+			 * located in iolog.c after printing this sample to the
+			 * log file.
+			 */
+			io_u_plat = (unsigned int *) td->ts.io_u_plat[ddir];
+			dst = malloc(FIO_IO_U_PLAT_NR * sizeof(unsigned int));
+			memcpy(dst, io_u_plat,
+				FIO_IO_U_PLAT_NR * sizeof(unsigned int));
+			__add_log_sample(iolog, (unsigned long )dst, ddir, bs,
+						elapsed, offset);
+
+			/*
+			 * Update the last time we recorded as being now, minus
+			 * any drift in time we encountered before actually
+			 * making the record.
+			 */
+			hw->hist_last = elapsed - (this_window - iolog->hist_msec);
+			hw->samples = 0;
+		}
+	}
+
 	td_io_u_unlock(td);
 }
 
diff --git a/thread_options.h b/thread_options.h
index edf090d..449c66f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -128,6 +128,8 @@ struct thread_options {
 	unsigned long long rand_seed;
 	unsigned int dep_use_os_rand;
 	unsigned int log_avg_msec;
+	unsigned int log_hist_msec;
+	unsigned int log_hist_coarseness;
 	unsigned int log_max;
 	unsigned int log_offset;
 	unsigned int log_gz;
@@ -232,6 +234,7 @@ struct thread_options {
 	char *bw_log_file;
 	char *lat_log_file;
 	char *iops_log_file;
+	char *hist_log_file;
 	char *replay_redirect;
 
 	/*
@@ -382,6 +385,8 @@ struct thread_options_pack {
 	uint64_t rand_seed;
 	uint32_t dep_use_os_rand;
 	uint32_t log_avg_msec;
+	uint32_t log_hist_msec;
+	uint32_t log_hist_coarseness;
 	uint32_t log_max;
 	uint32_t log_offset;
 	uint32_t log_gz;
@@ -486,6 +491,7 @@ struct thread_options_pack {
 	uint8_t bw_log_file[FIO_TOP_STR_MAX];
 	uint8_t lat_log_file[FIO_TOP_STR_MAX];
 	uint8_t iops_log_file[FIO_TOP_STR_MAX];
+	uint8_t hist_log_file[FIO_TOP_STR_MAX];
 	uint8_t replay_redirect[FIO_TOP_STR_MAX];
 
 	/*
diff --git a/tools/hist/.gitignore b/tools/hist/.gitignore
new file mode 100644
index 0000000..4f875da
--- /dev/null
+++ b/tools/hist/.gitignore
@@ -0,0 +1,3 @@
+*.pyc
+*.ipynb
+.ipynb_checkpoints
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
new file mode 100755
index 0000000..ce98d2e
--- /dev/null
+++ b/tools/hist/fiologparser_hist.py
@@ -0,0 +1,486 @@
+#!/usr/bin/env python2.7
+""" 
+    Utility for converting *_clat_hist* files generated by fio into latency statistics.
+    
+    Example usage:
+    
+            $ fiologparser_hist.py *_clat_hist*
+            end-time, samples, min, avg, median, 90%, 95%, 99%, max
+            1000, 15, 192, 1678.107, 1788.859, 1856.076, 1880.040, 1899.208, 1888.000
+            2000, 43, 152, 1642.368, 1714.099, 1816.659, 1845.552, 1888.131, 1888.000
+            4000, 39, 1152, 1546.962, 1545.785, 1627.192, 1640.019, 1691.204, 1744
+            ...
+    
+    Notes:
+
+    * end-times are calculated to be uniform increments of the --interval value given,
+      regardless of when histogram samples are reported. Of note:
+        
+        * Intervals with no samples are omitted. In the example above this means
+          "no statistics from 2 to 3 seconds" and "39 samples influenced the statistics
+          of the interval from 3 to 4 seconds".
+        
+        * Intervals with a single sample will have the same value for all statistics
+        
+    * The number of samples is unweighted, corresponding to the total number of samples
+      which have any effect whatsoever on the interval.
+
+    * Min statistics are computed using value of the lower boundary of the first bin
+      (in increasing bin order) with non-zero samples in it. Similarly for max,
+      we take the upper boundary of the last bin with non-zero samples in it.
+      This is semantically identical to taking the 0th and 100th percentiles with a
+      50% bin-width buffer (because percentiles are computed using mid-points of
+      the bins). This enforces the following nice properties:
+
+        * min <= 50th <= 90th <= 95th <= 99th <= max
+
+        * min and max are strict lower and upper bounds on the actual
+          min / max seen by fio (and reported in *_clat.* with averaging turned off).
+
+    * Average statistics use a standard weighted arithmetic mean.
+
+    * Percentile statistics are computed using the weighted percentile method as
+      described here: https://en.wikipedia.org/wiki/Percentile#Weighted_percentile
+      See weights() method for details on how weights are computed for individual
+      samples. In process_interval() we further multiply by the height of each bin
+      to get weighted histograms.
+    
+    * We convert files given on the command line, assumed to be fio histogram files,
+      on-the-fly into their corresponding differenced files i.e. non-cumulative histograms
+      because fio outputs cumulative histograms, but we want histograms corresponding
+      to individual time intervals. An individual histogram file can contain the cumulative
+      histograms for multiple different r/w directions (notably when --rw=randrw). This
+      is accounted for by tracking each r/w direction separately. In the statistics
+      reported we ultimately merge *all* histograms (regardless of r/w direction).
+
+    * The value of *_GROUP_NR in stat.h (and *_BITS) determines how many latency bins
+      fio outputs when histogramming is enabled. Namely for the current default of
+      GROUP_NR=19, we get 1,216 bins with a maximum latency of approximately 17
+      seconds. For certain applications this may not be sufficient. With GROUP_NR=24
+      we have 1,536 bins, giving us a maximum latency of 541 seconds (~ 9 minutes). If
+      you expect your application to experience latencies greater than 17 seconds,
+      you will need to recompile fio with a larger GROUP_NR, e.g. with:
+        
+            sed -i.bak 's/^#define FIO_IO_U_PLAT_GROUP_NR 19\n/#define FIO_IO_U_PLAT_GROUP_NR 24/g' stat.h
+            make fio
+            
+      Quick reference table for the max latency corresponding to a sampling of
+      values for GROUP_NR:
+            
+            GROUP_NR | # bins | max latency bin value
+            19       | 1216   | 16.9 sec
+            20       | 1280   | 33.8 sec
+            21       | 1344   | 67.6 sec
+            22       | 1408   | 2  min, 15 sec
+            23       | 1472   | 4  min, 32 sec
+            24       | 1536   | 9  min, 4  sec
+            25       | 1600   | 18 min, 8  sec
+            26       | 1664   | 36 min, 16 sec
+      
+    * At present this program automatically detects the number of histogram bins in
+      the log files, and adjusts the bin latency values accordingly. In particular if
+      you use the --log_hist_coarseness parameter of fio, you get output files with
+      a number of bins according to the following table (note that the first
+      row is identical to the table above):
+
+      coarse \ GROUP_NR
+                  19     20    21     22     23     24     25     26
+             -------------------------------------------------------
+            0  [[ 1216,  1280,  1344,  1408,  1472,  1536,  1600,  1664],
+            1   [  608,   640,   672,   704,   736,   768,   800,   832],
+            2   [  304,   320,   336,   352,   368,   384,   400,   416],
+            3   [  152,   160,   168,   176,   184,   192,   200,   208],
+            4   [   76,    80,    84,    88,    92,    96,   100,   104],
+            5   [   38,    40,    42,    44,    46,    48,    50,    52],
+            6   [   19,    20,    21,    22,    23,    24,    25,    26],
+            7   [  N/A,    10,   N/A,    11,   N/A,    12,   N/A,    13],
+            8   [  N/A,     5,   N/A,   N/A,   N/A,     6,   N/A,   N/A]]
+
+      For other values of GROUP_NR and coarseness, this table can be computed like this:    
+        
+            bins = [1216,1280,1344,1408,1472,1536,1600,1664]
+            max_coarse = 8
+            fncn = lambda z: list(map(lambda x: z/2**x if z % 2**x == 0 else nan, range(max_coarse + 1)))
+            np.transpose(list(map(fncn, bins)))
+      
+      Also note that you can achieve the same downsampling / log file size reduction
+      by pre-processing (before inputting into this script) with half_bins.py.
+
+    * If you have not adjusted GROUP_NR for your (high latency) application, then you
+      will see the percentiles computed by this tool max out at the max latency bin
+      value as in the first table above, and in this plot (where GROUP_NR=19 and thus we see
+      a max latency of ~16.7 seconds in the red line):
+
+            https://www.cronburg.com/fio/max_latency_bin_value_bug.png
+    
+    * Motivation for, design decisions, and the implementation process are
+      described in further detail here:
+
+            https://www.cronburg.com/fio/cloud-latency-problem-measurement/
+
+    @author Karl Cronburg <karl.cronburg@gmail.com>
+"""
+import os
+import sys
+import pandas
+import numpy as np
+
+err = sys.stderr.write
+
+def weighted_percentile(percs, vs, ws):
+    """ Use linear interpolation to calculate the weighted percentile.
+        
+        Value and weight arrays are first sorted by value. The cumulative
+        distribution function (cdf) is then computed, after which np.interp
+        finds the two values closest to our desired weighted percentile(s)
+        and linearly interpolates them.
+        
+        percs  :: List of percentiles we want to calculate
+        vs     :: Array of values we are computing the percentile of
+        ws     :: Array of weights for our corresponding values
+        return :: Array of percentiles
+    """
+    idx = np.argsort(vs)
+    vs, ws = vs[idx], ws[idx] # weights and values sorted by value
+    cdf = 100 * (ws.cumsum() - ws / 2.0) / ws.sum()
+    return np.interp(percs, cdf, vs) # linear interpolation
+
+def weights(start_ts, end_ts, start, end):
+    """ Calculate weights based on fraction of sample falling in the
+        given interval [start,end]. Weights computed using vector / array
+        computation instead of for-loops.
+    
+        Note that samples with zero time length are effectively ignored
+        (we set their weight to zero).
+
+        start_ts :: Array of start times for a set of samples
+        end_ts   :: Array of end times for a set of samples
+        start    :: int
+        end      :: int
+        return   :: Array of weights
+    """
+    sbounds = np.maximum(start_ts, start).astype(float)
+    ebounds = np.minimum(end_ts,   end).astype(float)
+    ws = (ebounds - sbounds) / (end_ts - start_ts)
+    if np.any(np.isnan(ws)):
+      err("WARNING: zero-length sample(s) detected. Log file corrupt"
+          " / bad time values? Ignoring these samples.\n")
+    ws[np.where(np.isnan(ws))] = 0.0;
+    return ws
+
+def weighted_average(vs, ws):
+    return np.sum(vs * ws) / np.sum(ws)
+
+columns = ["end-time", "samples", "min", "avg", "median", "90%", "95%", "99%", "max"]
+percs   = [50, 90, 95, 99]
+
+def fmt_float_list(ctx, num=1):
+  """ Return a comma separated list of float formatters to the required number
+      of decimal places. For instance:
+
+        fmt_float_list(ctx.decimals=4, num=3) == "%.4f, %.4f, %.4f"
+  """
+  return ', '.join(["%%.%df" % ctx.decimals] * num)
+
+# Default values - see beginning of main() for how we detect number columns in
+# the input files:
+__HIST_COLUMNS = 1216
+__NON_HIST_COLUMNS = 3
+__TOTAL_COLUMNS = __HIST_COLUMNS + __NON_HIST_COLUMNS
+    
+def sequential_diffs(head_row, times, rws, hists):
+    """ Take the difference of sequential (in time) histograms with the same
+        r/w direction, returning a new array of differenced histograms.  """
+    result = np.empty(shape=(0, __HIST_COLUMNS))
+    result_times = np.empty(shape=(1, 0))
+    for i in range(8):
+        idx = np.where(rws == i)
+        diff = np.diff(np.append(head_row[i], hists[idx], axis=0), axis=0).astype(int)
+        result = np.append(diff, result, axis=0)
+        result_times = np.append(times[idx], result_times)
+    idx = np.argsort(result_times)
+    return result[idx]
+
+def read_chunk(head_row, rdr, sz):
+    """ Read the next chunk of size sz from the given reader, computing the
+        differences across neighboring histogram samples.
+    """
+    try:
+        """ StopIteration occurs when the pandas reader is empty, and AttributeError
+            occurs if rdr is None due to the file being empty. """
+        new_arr = rdr.read().values
+    except (StopIteration, AttributeError):
+        return None    
+
+    """ Extract array of just the times, and histograms matrix without times column.
+        Then, take the sequential difference of each of the rows in the histogram
+        matrix. This is necessary because fio outputs *cumulative* histograms as
+        opposed to histograms with counts just for a particular interval. """
+    times, rws, szs = new_arr[:,0], new_arr[:,1], new_arr[:,2]
+    hists = new_arr[:,__NON_HIST_COLUMNS:]
+    hists_diff   = sequential_diffs(head_row, times, rws, hists)
+    times = times.reshape((len(times),1))
+    arr = np.append(times, hists_diff, axis=1)
+
+    """ hists[-1] will be the row we need to start our differencing with the
+        next time we call read_chunk() on the same rdr """
+    return arr, hists[-1]
+
+def get_min(fps, arrs):
+    """ Find the file with the current first row with the smallest start time """
+    return min([fp for fp in fps if not arrs[fp] is None], key=lambda fp: arrs.get(fp)[0][0][0])
+
+def histogram_generator(ctx, fps, sz):
+    
+    """ head_row for a particular file keeps track of the last (cumulative)
+        histogram we read so that we have a reference point to subtract off
+        when computing sequential differences. """
+    head_row  = np.zeros(shape=(1, __HIST_COLUMNS))
+    head_rows = {fp: {i: head_row for i in range(8)} for fp in fps}
+
+    # Create a chunked pandas reader for each of the files:
+    rdrs = {}
+    for fp in fps:
+        try:
+            rdrs[fp] = pandas.read_csv(fp, dtype=int, header=None, chunksize=sz)
+        except ValueError as e:
+            if e.message == 'No columns to parse from file':
+                if not ctx.nowarn: sys.stderr.write("WARNING: Empty input file encountered.\n")
+                rdrs[fp] = None
+            else:
+                raise(e)
+
+    # Initial histograms and corresponding head_rows:
+    arrs = {fp: read_chunk(head_rows[fp], rdr, sz) for fp,rdr in rdrs.items()}
+    while True:
+
+        try:
+            """ ValueError occurs when nothing more to read """
+            fp = get_min(fps, arrs)
+        except ValueError:
+            return
+        arr, head_row = arrs[fp]
+        yield np.insert(arr[0], 1, fps.index(fp))
+        arrs[fp] = arr[1:], head_row
+        head_rows[fp] = head_row
+
+        if arrs[fp][0].shape[0] == 0:
+            arrs[fp] = read_chunk(head_rows[fp], rdrs[fp], sz)
+
+def _plat_idx_to_val(idx, edge=0.5, FIO_IO_U_PLAT_BITS=6, FIO_IO_U_PLAT_VAL=64):
+    """ Taken from fio's stat.c for calculating the latency value of a bin
+        from that bin's index.
+        
+            idx  : the value of the index into the histogram bins
+            edge : fractional value in the range [0,1]** indicating how far into
+            the bin we wish to compute the latency value of.
+        
+        ** edge = 0.0 and 1.0 computes the lower and upper latency bounds
+           respectively of the given bin index. """
+
+    # MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
+    # all bits of the sample as index
+    if (idx < (FIO_IO_U_PLAT_VAL << 1)):
+        return idx 
+
+    # Find the group and compute the minimum value of that group
+    error_bits = (idx >> FIO_IO_U_PLAT_BITS) - 1 
+    base = 1 << (error_bits + FIO_IO_U_PLAT_BITS)
+
+    # Find its bucket number of the group
+    k = idx % FIO_IO_U_PLAT_VAL
+
+    # Return the mean (if edge=0.5) of the range of the bucket
+    return base + ((k + edge) * (1 << error_bits))
+    
+def plat_idx_to_val_coarse(idx, coarseness, edge=0.5):
+    """ Converts the given *coarse* index into a non-coarse index as used by fio
+        in stat.h:plat_idx_to_val(), subsequently computing the appropriate
+        latency value for that bin.
+        """
+
+    # Multiply the index by the power of 2 coarseness to get the bin
+    # bin index with a max of 1536 bins (FIO_IO_U_PLAT_GROUP_NR = 24 in stat.h)
+    stride = 1 << coarseness
+    idx = idx * stride
+    lower = _plat_idx_to_val(idx, edge=0.0)
+    upper = _plat_idx_to_val(idx + stride, edge=1.0)
+    return lower + (upper - lower) * edge
+
+def print_all_stats(ctx, end, mn, ss_cnt, vs, ws, mx):
+    ps = weighted_percentile(percs, vs, ws)
+
+    avg = weighted_average(vs, ws)
+    values = [mn, avg] + list(ps) + [mx]
+    row = [end, ss_cnt] + map(lambda x: float(x) / ctx.divisor, values)
+    fmt = "%d, %d, %d, " + fmt_float_list(ctx, 5) + ", %d"
+    print (fmt % tuple(row))
+
+def update_extreme(val, fncn, new_val):
+    """ Calculate min / max in the presence of None values """
+    if val is None: return new_val
+    else: return fncn(val, new_val)
+
+# See beginning of main() for how bin_vals are computed
+bin_vals = []
+lower_bin_vals = [] # lower edge of each bin
+upper_bin_vals = [] # upper edge of each bin 
+
+def process_interval(ctx, samples, iStart, iEnd):
+    """ Construct the weighted histogram for the given interval by scanning
+        through all the histograms and figuring out which of their bins have
+        samples with latencies which overlap with the given interval
+        [iStart,iEnd].
+    """
+    
+    times, files, hists = samples[:,0], samples[:,1], samples[:,2:]
+    iHist = np.zeros(__HIST_COLUMNS)
+    ss_cnt = 0 # number of samples affecting this interval
+    mn_bin_val, mx_bin_val = None, None
+
+    for end_time,file,hist in zip(times,files,hists):
+            
+        # Only look at bins of the current histogram sample which
+        # started before the end of the current time interval [start,end]
+        start_times = (end_time - 0.5 * ctx.interval) - bin_vals / 1000.0
+        idx = np.where(start_times < iEnd)
+        s_ts, l_bvs, u_bvs, hs = start_times[idx], lower_bin_vals[idx], upper_bin_vals[idx], hist[idx]
+
+        # Increment current interval histogram by weighted values of future histogram:
+        ws = hs * weights(s_ts, end_time, iStart, iEnd)
+        iHist[idx] += ws
+    
+        # Update total number of samples affecting current interval histogram:
+        ss_cnt += np.sum(hs)
+        
+        # Update min and max bin values seen if necessary:
+        idx = np.where(hs != 0)[0]
+        if idx.size > 0:
+            mn_bin_val = update_extreme(mn_bin_val, min, l_bvs[max(0,           idx[0]  - 1)])
+            mx_bin_val = update_extreme(mx_bin_val, max, u_bvs[min(len(hs) - 1, idx[-1] + 1)])
+
+    if ss_cnt > 0: print_all_stats(ctx, iEnd, mn_bin_val, ss_cnt, bin_vals, iHist, mx_bin_val)
+
+def guess_max_from_bins(ctx, hist_cols):
+    """ Try to guess the GROUP_NR from given # of histogram
+        columns seen in an input file """
+    max_coarse = 8
+    if ctx.group_nr < 19 or ctx.group_nr > 26:
+        bins = [ctx.group_nr * (1 << 6)]
+    else:
+        bins = [1216,1280,1344,1408,1472,1536,1600,1664]
+    coarses = range(max_coarse + 1)
+    fncn = lambda z: list(map(lambda x: z/2**x if z % 2**x == 0 else -10, coarses))
+    
+    arr = np.transpose(list(map(fncn, bins)))
+    idx = np.where(arr == hist_cols)
+    if len(idx[1]) == 0:
+        table = repr(arr.astype(int)).replace('-10', 'N/A').replace('array','     ')
+        err("Unable to determine bin values from input clat_hist files. Namely \n"
+            "the first line of file '%s' " % ctx.FILE[0] + "has %d \n" % (__TOTAL_COLUMNS,) +
+            "columns of which we assume %d " % (hist_cols,) + "correspond to histogram bins. \n"
+            "This number needs to be equal to one of the following numbers:\n\n"
+            + table + "\n\n"
+            "Possible reasons and corresponding solutions:\n"
+            "  - Input file(s) does not contain histograms.\n"
+            "  - You recompiled fio with a different GROUP_NR. If so please specify this\n"
+            "    new GROUP_NR on the command line with --group_nr\n")
+        exit(1)
+    return bins[idx[1][0]]
+
+def main(ctx):
+
+    # Automatically detect how many columns are in the input files,
+    # calculate the corresponding 'coarseness' parameter used to generate
+    # those files, and calculate the appropriate bin latency values:
+    with open(ctx.FILE[0], 'r') as fp:
+        global bin_vals,lower_bin_vals,upper_bin_vals,__HIST_COLUMNS,__TOTAL_COLUMNS
+        __TOTAL_COLUMNS = len(fp.readline().split(','))
+        __HIST_COLUMNS = __TOTAL_COLUMNS - __NON_HIST_COLUMNS
+
+        max_cols = guess_max_from_bins(ctx, __HIST_COLUMNS)
+        coarseness = int(np.log2(float(max_cols) / __HIST_COLUMNS))
+        bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness), np.arange(__HIST_COLUMNS)), dtype=float)
+        lower_bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness, 0.0), np.arange(__HIST_COLUMNS)), dtype=float)
+        upper_bin_vals = np.array(map(lambda x: plat_idx_to_val_coarse(x, coarseness, 1.0), np.arange(__HIST_COLUMNS)), dtype=float)
+
+    fps = [open(f, 'r') for f in ctx.FILE]
+    gen = histogram_generator(ctx, fps, ctx.buff_size)
+
+    print(', '.join(columns))
+
+    try:
+        start, end = 0, ctx.interval
+        arr = np.empty(shape=(0,__TOTAL_COLUMNS - 1))
+        more_data = True
+        while more_data or len(arr) > 0:
+            
+            # Read up to ctx.max_latency (default 20 seconds) of data from end of current interval.
+            while len(arr) == 0 or arr[-1][0] < ctx.max_latency * 1000 + end:
+                try:
+                    new_arr = next(gen)
+                except StopIteration:
+                    more_data = False
+                    break
+                arr = np.append(arr, new_arr.reshape((1,__TOTAL_COLUMNS - 1)), axis=0)
+            arr = arr.astype(int)
+            
+            if arr.size > 0:
+                process_interval(ctx, arr, start, end)
+                
+                # Update arr to throw away samples we no longer need - samples which
+                # end before the start of the next interval, i.e. the end of the
+                # current interval:
+                idx = np.where(arr[:,0] > end)
+                arr = arr[idx]
+            
+            start += ctx.interval
+            end = start + ctx.interval
+    finally:
+        map(lambda f: f.close(), fps)
+
+
+if __name__ == '__main__':
+    import argparse
+    p = argparse.ArgumentParser()
+    arg = p.add_argument
+    arg("FILE", help='space separated list of latency log filenames', nargs='+')
+    arg('--buff_size',
+        default=10000,
+        type=int,
+        help='number of samples to buffer into numpy at a time')
+
+    arg('--max_latency',
+        default=20,
+        type=float,
+        help='number of seconds of data to process at a time')
+
+    arg('-i', '--interval',
+        default=1000,
+        type=int,
+        help='interval width (ms)')
+
+    arg('-d', '--divisor',
+        required=False,
+        type=int,
+        default=1,
+        help='divide the results by this value.')
+
+    arg('--decimals',
+        default=3,
+        type=int,
+        help='number of decimal places to print floats to')
+
+    arg('--nowarn',
+        dest='nowarn',
+        action='store_false',
+        default=True,
+        help='do not print any warning messages to stderr')
+
+    arg('--group_nr',
+        default=19,
+        type=int,
+        help='FIO_IO_U_PLAT_GROUP_NR as defined in stat.h')
+
+    main(p.parse_args())
+
diff --git a/tools/hist/half-bins.py b/tools/hist/half-bins.py
new file mode 100755
index 0000000..d592af0
--- /dev/null
+++ b/tools/hist/half-bins.py
@@ -0,0 +1,38 @@
+#!/usr/bin/env python2.7
+""" Cut the number bins in half in fio histogram output. Example usage:
+
+        $ half-bins.py -c 2 output_clat_hist.1.log > smaller_clat_hist.1.log
+
+    Which merges e.g. bins [0 .. 3], [4 .. 7], ..., [1212 .. 1215] resulting in
+    304 = 1216 / (2**2) merged bins per histogram sample.
+
+    @author Karl Cronburg <karl.cronburg@gmail.com>
+"""
+import sys
+
+def main(ctx):
+    stride = 1 << ctx.coarseness
+    with open(ctx.FILENAME, 'r') as fp:
+        for line in fp.readlines():
+            vals = line.split(', ')
+            sys.stdout.write("%s, %s, %s, " % tuple(vals[:3]))
+
+            hist = list(map(int, vals[3:]))
+            for i in range(0, len(hist) - stride, stride):
+                sys.stdout.write("%d, " % sum(hist[i : i + stride],))
+            sys.stdout.write("%d\n" % sum(hist[len(hist) - stride:]))
+
+if __name__ == '__main__':
+    import argparse
+    p = argparse.ArgumentParser()
+    arg = p.add_argument
+    arg( 'FILENAME', help='clat_hist file for which we will reduce'
+                         ' (by half or more) the number of bins.')
+    arg('-c', '--coarseness',
+       default=1,
+       type=int,
+       help='number of times to reduce number of bins by half, '
+            'e.g. coarseness of 4 merges each 2^4 = 16 consecutive '
+            'bins.')
+    main(p.parse_args())
+
