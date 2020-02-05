Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48588 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbgBENAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Feb 2020 08:00:15 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izKHu-0007HZ-4x
        for fio@vger.kernel.org; Wed, 05 Feb 2020 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200205130002.3E8491BC017F@kernel.dk>
Date: Wed,  5 Feb 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ab45cf076766ce1ed49d28380c059343305cde4a:

  Merge branch 'stat-averaging-interval-start-fix' of https://github.com/maciejsszmigiero/fio (2020-01-28 14:15:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f4cd67d8dc96ca947b294f6a5c9fdced2b64215d:

  Merge branch 'latency-rebase-again' of https://github.com/vincentkfu/fio (2020-02-04 10:05:09 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'filestat2' of https://github.com/kusumi/fio
      Merge branch 'latency-rebase-again' of https://github.com/vincentkfu/fio

Tomohiro Kusumi (1):
      engines/filestat: change "lstat" bool option to "stat_type" str option

Vincent Fu (10):
      fio: groundwork for adding slat, lat percentiles
      fio: report percentiles for slat, clat, lat
      gfio: display slat, clat, and lat percentiles
      docs: updates for slat, clat, lat percentile reporting
      stat: make priority summary statistics consistent with percentiles
      fio: better distinguish between high and low priority
      stat: fix high/low prio unified rw bug
      t/latency_percentiles: test latency percentile reporting
      t/run-fio-tests: add latency_percentiles.py
      t/run-fio-tests: increase time allowed for tests to pass

 HOWTO                    |   30 +-
 cconv.c                  |    2 +
 client.c                 |   14 +-
 engines/filestat.c       |   53 +-
 fio.1                    |   28 +-
 gclient.c                |   27 +-
 init.c                   |   19 +-
 options.c                |   31 +-
 server.c                 |   14 +-
 server.h                 |    2 +-
 stat.c                   |  440 +++++++--------
 stat.h                   |   22 +-
 t/latency_percentiles.py | 1324 ++++++++++++++++++++++++++++++++++++++++++++++
 t/run-fio-tests.py       |   14 +-
 thread_options.h         |   11 +-
 15 files changed, 1672 insertions(+), 359 deletions(-)
 create mode 100755 t/latency_percentiles.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f19f9226..430c7b62 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2261,9 +2261,10 @@ with the caveat that when used on the command line, they must come after the
 	multiple paths exist between the client and the server or in certain loopback
 	configurations.
 
-.. option:: lstat=bool : [filestat]
+.. option:: stat_type=str : [filestat]
 
-	Use lstat(2) to measure lookup/getattr performance. Default is 0.
+	Specify stat system call type to measure lookup/getattr performance.
+	Default is **stat** for :manpage:`stat(2)`.
 
 .. option:: readfua=bool : [sg]
 
@@ -3346,27 +3347,28 @@ Measurements and reporting
 	Disable measurements of throughput/bandwidth numbers. See
 	:option:`disable_lat`.
 
+.. option:: slat_percentiles=bool
+
+	Report submission latency percentiles. Submission latency is not recorded
+	for synchronous ioengines.
+
 .. option:: clat_percentiles=bool
 
-	Enable the reporting of percentiles of completion latencies.  This
-	option is mutually exclusive with :option:`lat_percentiles`.
+	Report completion latency percentiles.
 
 .. option:: lat_percentiles=bool
 
-	Enable the reporting of percentiles of I/O latencies. This is similar
-	to :option:`clat_percentiles`, except that this includes the
-	submission latency. This option is mutually exclusive with
-	:option:`clat_percentiles`.
+	Report total latency percentiles. Total latency is the sum of submission
+	latency and completion latency.
 
 .. option:: percentile_list=float_list
 
-	Overwrite the default list of percentiles for completion latencies and
-	the block error histogram.  Each number is a floating number in the
-	range (0,100], and the maximum length of the list is 20. Use ``:`` to
-	separate the numbers, and list the numbers in ascending order. For
+	Overwrite the default list of percentiles for latencies and the block error
+	histogram.  Each number is a floating point number in the range (0,100], and
+	the maximum length of the list is 20. Use ``:`` to separate the numbers. For
 	example, ``--percentile_list=99.5:99.9`` will cause fio to report the
-	values of completion latency below which 99.5% and 99.9% of the observed
-	latencies fell, respectively.
+	latency durations below which 99.5% and 99.9% of the observed latencies fell,
+	respectively.
 
 .. option:: significant_figures=int
 
diff --git a/cconv.c b/cconv.c
index 04854b0e..48218dc4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -271,6 +271,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->trim_zero = le32_to_cpu(top->trim_zero);
 	o->clat_percentiles = le32_to_cpu(top->clat_percentiles);
 	o->lat_percentiles = le32_to_cpu(top->lat_percentiles);
+	o->slat_percentiles = le32_to_cpu(top->slat_percentiles);
 	o->percentile_precision = le32_to_cpu(top->percentile_precision);
 	o->sig_figs = le32_to_cpu(top->sig_figs);
 	o->continue_on_error = le32_to_cpu(top->continue_on_error);
@@ -469,6 +470,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->trim_zero = cpu_to_le32(o->trim_zero);
 	top->clat_percentiles = cpu_to_le32(o->clat_percentiles);
 	top->lat_percentiles = cpu_to_le32(o->lat_percentiles);
+	top->slat_percentiles = cpu_to_le32(o->slat_percentiles);
 	top->percentile_precision = cpu_to_le32(o->percentile_precision);
 	top->sig_figs = cpu_to_le32(o->sig_figs);
 	top->continue_on_error = cpu_to_le32(o->continue_on_error);
diff --git a/client.c b/client.c
index 4aed39e7..b7575596 100644
--- a/client.c
+++ b/client.c
@@ -944,7 +944,7 @@ static void convert_io_stat(struct io_stat *dst, struct io_stat *src)
 
 static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 {
-	int i, j;
+	int i, j, k;
 
 	dst->error		= le32_to_cpu(src->error);
 	dst->thread_number	= le32_to_cpu(src->thread_number);
@@ -969,6 +969,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->majf		= le64_to_cpu(src->majf);
 	dst->clat_percentiles	= le32_to_cpu(src->clat_percentiles);
 	dst->lat_percentiles	= le32_to_cpu(src->lat_percentiles);
+	dst->slat_percentiles	= le32_to_cpu(src->slat_percentiles);
 	dst->percentile_precision = le64_to_cpu(src->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
@@ -991,9 +992,10 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		dst->io_u_lat_m[i]	= le64_to_cpu(src->io_u_lat_m[i]);
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++)
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
-			dst->io_u_plat[i][j] = le64_to_cpu(src->io_u_plat[i][j]);
+	for (i = 0; i < FIO_LAT_CNT; i++)
+		for (j = 0; j < DDIR_RWDIR_CNT; j++)
+			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+				dst->io_u_plat[i][j][k] = le64_to_cpu(src->io_u_plat[i][j][k]);
 
 	for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 		dst->io_u_sync_plat[j] = le64_to_cpu(src->io_u_sync_plat[j]);
@@ -1035,10 +1037,10 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
 			dst->io_u_plat_high_prio[i][j] = le64_to_cpu(src->io_u_plat_high_prio[i][j]);
-			dst->io_u_plat_prio[i][j] = le64_to_cpu(src->io_u_plat_prio[i][j]);
+			dst->io_u_plat_low_prio[i][j] = le64_to_cpu(src->io_u_plat_low_prio[i][j]);
 		}
 		convert_io_stat(&dst->clat_high_prio_stat[i], &src->clat_high_prio_stat[i]);
-		convert_io_stat(&dst->clat_prio_stat[i], &src->clat_prio_stat[i]);
+		convert_io_stat(&dst->clat_low_prio_stat[i], &src->clat_low_prio_stat[i]);
 	}
 
 	dst->ss_dur		= le64_to_cpu(src->ss_dur);
diff --git a/engines/filestat.c b/engines/filestat.c
index 6c87c4c2..68a340bd 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -19,17 +19,39 @@ struct fc_data {
 
 struct filestat_options {
 	void *pad;
-	unsigned int lstat;
+	unsigned int stat_type;
+};
+
+enum {
+	FIO_FILESTAT_STAT	= 1,
+	FIO_FILESTAT_LSTAT	= 2,
+	/*FIO_FILESTAT_STATX	= 3,*/
 };
 
 static struct fio_option options[] = {
 	{
-		.name	= "lstat",
-		.lname	= "lstat",
-		.type	= FIO_OPT_BOOL,
-		.off1	= offsetof(struct filestat_options, lstat),
-		.help	= "Use lstat(2) to measure lookup/getattr performance",
-		.def	= "0",
+		.name	= "stat_type",
+		.lname	= "stat_type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct filestat_options, stat_type),
+		.help	= "Specify stat system call type to measure lookup/getattr performance",
+		.def	= "stat",
+		.posval = {
+			  { .ival = "stat",
+			    .oval = FIO_FILESTAT_STAT,
+			    .help = "Use stat(2)",
+			  },
+			  { .ival = "lstat",
+			    .oval = FIO_FILESTAT_LSTAT,
+			    .help = "Use lstat(2)",
+			  },
+			  /*
+			  { .ival = "statx",
+			    .oval = FIO_FILESTAT_STATX,
+			    .help = "Use statx(2)",
+			  },
+			  */
+		},
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_FILESTAT,
 	},
@@ -60,17 +82,24 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 	if (do_lat)
 		fio_gettime(&start, NULL);
 
-	if (o->lstat)
-		ret = lstat(f->file_name, &statbuf);
-	else
+	switch (o->stat_type){
+	case FIO_FILESTAT_STAT:
 		ret = stat(f->file_name, &statbuf);
+		break;
+	case FIO_FILESTAT_LSTAT:
+		ret = lstat(f->file_name, &statbuf);
+		break;
+	default:
+		ret = -1;
+		break;
+	}
 
 	if (ret == -1) {
 		char buf[FIO_VERROR_SIZE];
 		int e = errno;
 
-		snprintf(buf, sizeof(buf), "%sstat(%s)",
-			o->lstat ? "l" : "", f->file_name);
+		snprintf(buf, sizeof(buf), "stat(%s) type=%u", f->file_name,
+			o->stat_type);
 		td_verror(td, e, buf);
 		return 1;
 	}
diff --git a/fio.1 b/fio.1
index a58632b4..1db12c2f 100644
--- a/fio.1
+++ b/fio.1
@@ -2032,8 +2032,9 @@ on the client site it will be used in the rdma_resolve_add()
 function. This can be useful when multiple paths exist between the
 client and the server or in certain loopback configurations.
 .TP
-.BI (filestat)lstat \fR=\fPbool
-Use \fBlstat\fR\|(2) to measure lookup/getattr performance. Default: 0.
+.BI (filestat)stat_type \fR=\fPstr
+Specify stat system call type to measure lookup/getattr performance.
+Default is \fBstat\fR for \fBstat\fR\|(2).
 .TP
 .BI (sg)readfua \fR=\fPbool
 With readfua option set to 1, read operations include the force
@@ -3000,23 +3001,24 @@ Disable measurements of submission latency numbers. See
 Disable measurements of throughput/bandwidth numbers. See
 \fBdisable_lat\fR.
 .TP
+.BI slat_percentiles \fR=\fPbool
+Report submission latency percentiles. Submission latency is not recorded
+for synchronous ioengines.
+.TP
 .BI clat_percentiles \fR=\fPbool
-Enable the reporting of percentiles of completion latencies. This option is
-mutually exclusive with \fBlat_percentiles\fR.
+Report completion latency percentiles.
 .TP
 .BI lat_percentiles \fR=\fPbool
-Enable the reporting of percentiles of I/O latencies. This is similar to
-\fBclat_percentiles\fR, except that this includes the submission latency.
-This option is mutually exclusive with \fBclat_percentiles\fR.
+Report total latency percentiles. Total latency is the sum of submission
+latency and completion latency.
 .TP
 .BI percentile_list \fR=\fPfloat_list
-Overwrite the default list of percentiles for completion latencies and the
-block error histogram. Each number is a floating number in the range
+Overwrite the default list of percentiles for latencies and the
+block error histogram. Each number is a floating point number in the range
 (0,100], and the maximum length of the list is 20. Use ':' to separate the
-numbers, and list the numbers in ascending order. For example,
-`\-\-percentile_list=99.5:99.9' will cause fio to report the values of
-completion latency below which 99.5% and 99.9% of the observed latencies
-fell, respectively.
+numbers. For example, `\-\-percentile_list=99.5:99.9' will cause fio to
+report the latency durations below which 99.5% and 99.9% of the observed
+latencies fell, respectively.
 .TP
 .BI significant_figures \fR=\fPint
 If using \fB\-\-output\-format\fR of `normal', set the significant figures
diff --git a/gclient.c b/gclient.c
index d8dc62d2..d2044f32 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1097,10 +1097,9 @@ static struct graph *setup_clat_graph(char *title, unsigned long long *ovals,
 
 static void gfio_show_clat_percentiles(struct gfio_client *gc,
 				       GtkWidget *vbox, struct thread_stat *ts,
-				       int ddir)
+				       int ddir, uint64_t *io_u_plat,
+				       unsigned long long nr, const char *type)
 {
-	uint64_t *io_u_plat = ts->io_u_plat[ddir];
-	unsigned long long nr = ts->clat_stat[ddir].samples;
 	fio_fp64_t *plist = ts->percentile_list;
 	unsigned int len, scale_down;
 	unsigned long long *ovals, minv, maxv;
@@ -1128,10 +1127,7 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 		base = "nsec";
         }
 
-	if (ts->clat_percentiles)
-		sprintf(tmp, "Completion percentiles (%s)", base);
-	else
-		sprintf(tmp, "Latency percentiles (%s)", base);
+	sprintf(tmp, "%s latency percentiles (%s)", type, base);
 
 	tree_view = gfio_output_clat_percentiles(ovals, plist, len, base, scale_down);
 	ge->clat_graph = setup_clat_graph(tmp, ovals, plist, len, 700.0, 300.0);
@@ -1285,8 +1281,21 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 			gfio_show_lat(vbox, "Total latency", min[2], max[2], mean[2], dev[2]);
 	}
 
-	if (ts->clat_percentiles)
-		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir);
+	if (ts->slat_percentiles && flags & GFIO_SLAT)
+		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+				ts->io_u_plat[FIO_SLAT][ddir],
+				ts->slat_stat[ddir].samples,
+				"Submission");
+	if (ts->clat_percentiles && flags & GFIO_CLAT)
+		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+				ts->io_u_plat[FIO_CLAT][ddir],
+				ts->clat_stat[ddir].samples,
+				"Completion");
+	if (ts->lat_percentiles && flags & GFIO_LAT)
+		gfio_show_clat_percentiles(gc, main_vbox, ts, ddir,
+				ts->io_u_plat[FIO_LAT][ddir],
+				ts->lat_stat[ddir].samples,
+				"Total");
 
 	free(io_p);
 	free(bw_p);
diff --git a/init.c b/init.c
index dca44bca..b5315334 100644
--- a/init.c
+++ b/init.c
@@ -944,24 +944,12 @@ static int fixup_options(struct thread_data *td)
 		ret |= 1;
 	}
 
-	if (fio_option_is_set(o, clat_percentiles) &&
-	    !fio_option_is_set(o, lat_percentiles)) {
-		o->lat_percentiles = !o->clat_percentiles;
-	} else if (fio_option_is_set(o, lat_percentiles) &&
-		   !fio_option_is_set(o, clat_percentiles)) {
-		o->clat_percentiles = !o->lat_percentiles;
-	} else if (fio_option_is_set(o, lat_percentiles) &&
-		   fio_option_is_set(o, clat_percentiles) &&
-		   o->lat_percentiles && o->clat_percentiles) {
-		log_err("fio: lat_percentiles and clat_percentiles are "
-			"mutually exclusive\n");
-		ret |= 1;
-	}
-
 	if (o->disable_lat)
 		o->lat_percentiles = 0;
 	if (o->disable_clat)
 		o->clat_percentiles = 0;
+	if (o->disable_slat)
+		o->slat_percentiles = 0;
 
 	/*
 	 * Fix these up to be nsec internally
@@ -1509,6 +1497,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 
 	td->ts.clat_percentiles = o->clat_percentiles;
 	td->ts.lat_percentiles = o->lat_percentiles;
+	td->ts.slat_percentiles = o->slat_percentiles;
 	td->ts.percentile_precision = o->percentile_precision;
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
 	td->ts.sig_figs = o->sig_figs;
@@ -1520,7 +1509,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
 		td->ts.iops_stat[i].min_val = ULONG_MAX;
 		td->ts.clat_high_prio_stat[i].min_val = ULONG_MAX;
-		td->ts.clat_prio_stat[i].min_val = ULONG_MAX;
+		td->ts.clat_low_prio_stat[i].min_val = ULONG_MAX;
 	}
 	td->ts.sync_stat.min_val = ULONG_MAX;
 	td->ddir_seq_nr = o->ddir_seq_nr;
diff --git a/options.c b/options.c
index 287f0435..4714a3a1 100644
--- a/options.c
+++ b/options.c
@@ -1408,13 +1408,20 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	struct thread_data *td = cb_data_to_td(data);
 	int val = *il;
 
-	td->o.disable_lat = !!val;
-	td->o.disable_clat = !!val;
-	td->o.disable_slat = !!val;
-	td->o.disable_bw = !!val;
-	td->o.clat_percentiles = !val;
-	if (val)
+	/*
+	 * Only modfiy options if gtod_reduce==1
+	 * Otherwise leave settings alone.
+	 */
+	if (val) {
+		td->o.disable_lat = 1;
+		td->o.disable_clat = 1;
+		td->o.disable_slat = 1;
+		td->o.disable_bw = 1;
+		td->o.clat_percentiles = 0;
+		td->o.lat_percentiles = 0;
+		td->o.slat_percentiles = 0;
 		td->ts_cache_mask = 63;
+	}
 
 	return 0;
 }
@@ -4312,7 +4319,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, clat_percentiles),
 		.help	= "Enable the reporting of completion latency percentiles",
 		.def	= "1",
-		.inverse = "lat_percentiles",
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -4323,7 +4329,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, lat_percentiles),
 		.help	= "Enable the reporting of IO latency percentiles",
 		.def	= "0",
-		.inverse = "clat_percentiles",
+		.category = FIO_OPT_C_STAT,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "slat_percentiles",
+		.lname	= "Submission latency percentiles",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, slat_percentiles),
+		.help	= "Enable the reporting of submission latency percentiles",
+		.def	= "0",
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
 	},
diff --git a/server.c b/server.c
index a5af5e74..248a2d44 100644
--- a/server.c
+++ b/server.c
@@ -1463,7 +1463,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 {
 	struct cmd_ts_pdu p;
-	int i, j;
+	int i, j, k;
 	void *ss_buf;
 	uint64_t *ss_iops, *ss_bw;
 
@@ -1499,6 +1499,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.majf		= cpu_to_le64(ts->majf);
 	p.ts.clat_percentiles	= cpu_to_le32(ts->clat_percentiles);
 	p.ts.lat_percentiles	= cpu_to_le32(ts->lat_percentiles);
+	p.ts.slat_percentiles	= cpu_to_le32(ts->slat_percentiles);
 	p.ts.percentile_precision = cpu_to_le64(ts->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
@@ -1521,9 +1522,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		p.ts.io_u_lat_m[i]	= cpu_to_le64(ts->io_u_lat_m[i]);
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++)
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
-			p.ts.io_u_plat[i][j] = cpu_to_le64(ts->io_u_plat[i][j]);
+	for (i = 0; i < FIO_LAT_CNT; i++)
+		for (j = 0; j < DDIR_RWDIR_CNT; j++)
+			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+				p.ts.io_u_plat[i][j][k] = cpu_to_le64(ts->io_u_plat[i][j][k]);
 
 	for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 		p.ts.io_u_sync_plat[j] = cpu_to_le64(ts->io_u_sync_plat[j]);
@@ -1577,10 +1579,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
 			p.ts.io_u_plat_high_prio[i][j] = cpu_to_le64(ts->io_u_plat_high_prio[i][j]);
-			p.ts.io_u_plat_prio[i][j] = cpu_to_le64(ts->io_u_plat_prio[i][j]);
+			p.ts.io_u_plat_low_prio[i][j] = cpu_to_le64(ts->io_u_plat_low_prio[i][j]);
 		}
 		convert_io_stat(&p.ts.clat_high_prio_stat[i], &ts->clat_high_prio_stat[i]);
-		convert_io_stat(&p.ts.clat_prio_stat[i], &ts->clat_prio_stat[i]);
+		convert_io_stat(&p.ts.clat_low_prio_stat[i], &ts->clat_low_prio_stat[i]);
 	}
 
 	convert_gs(&p.rs, rs);
diff --git a/server.h b/server.h
index 6ac75366..279b6917 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 81,
+	FIO_SERVER_VER			= 82,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index cc1c360e..69d57b69 100644
--- a/stat.c
+++ b/stat.c
@@ -483,26 +483,38 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
 	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev))
-		display_lat("prio_clat", min, max, mean, dev, out);
+		display_lat(ts->lat_percentiles ? "prio_lat" : "prio_clat",
+				min, max, mean, dev, out);
+
+	if (ts->slat_percentiles && ts->slat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts->io_u_plat[FIO_SLAT][ddir],
+					ts->slat_stat[ddir].samples,
+					ts->percentile_list,
+					ts->percentile_precision, "slat", out);
+	if (ts->clat_percentiles && ts->clat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts->io_u_plat[FIO_CLAT][ddir],
+					ts->clat_stat[ddir].samples,
+					ts->percentile_list,
+					ts->percentile_precision, "clat", out);
+	if (ts->lat_percentiles && ts->lat_stat[ddir].samples > 0)
+		show_clat_percentiles(ts->io_u_plat[FIO_LAT][ddir],
+					ts->lat_stat[ddir].samples,
+					ts->percentile_list,
+					ts->percentile_precision, "lat", out);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
-		const char *name = ts->clat_percentiles ? "clat" : " lat";
+		const char *name = ts->lat_percentiles ? "lat" : "clat";
 		char prio_name[32];
 		uint64_t samples;
 
-		if (ts->clat_percentiles)
-			samples = ts->clat_stat[ddir].samples;
-		else
+		if (ts->lat_percentiles)
 			samples = ts->lat_stat[ddir].samples;
-
-		show_clat_percentiles(ts->io_u_plat[ddir],
-					samples,
-					ts->percentile_list,
-					ts->percentile_precision, name, out);
+		else
+			samples = ts->clat_stat[ddir].samples;
 
 		/* Only print this if some high and low priority stats were collected */
 		if (ts->clat_high_prio_stat[ddir].samples > 0 &&
-			ts->clat_prio_stat[ddir].samples > 0)
+			ts->clat_low_prio_stat[ddir].samples > 0)
 		{
 			sprintf(prio_name, "high prio (%.2f%%) %s",
 					100. * (double) ts->clat_high_prio_stat[ddir].samples / (double) samples,
@@ -513,14 +525,15 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 						ts->percentile_precision, prio_name, out);
 
 			sprintf(prio_name, "low prio (%.2f%%) %s",
-					100. * (double) ts->clat_prio_stat[ddir].samples / (double) samples,
+					100. * (double) ts->clat_low_prio_stat[ddir].samples / (double) samples,
 					name);
-			show_clat_percentiles(ts->io_u_plat_prio[ddir],
-						ts->clat_prio_stat[ddir].samples,
+			show_clat_percentiles(ts->io_u_plat_low_prio[ddir],
+						ts->clat_low_prio_stat[ddir].samples,
 						ts->percentile_list,
 						ts->percentile_precision, prio_name, out);
 		}
 	}
+
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
 		const char *bw_str;
@@ -1170,12 +1183,17 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	else
 		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
-	if (ts->clat_percentiles || ts->lat_percentiles) {
-		len = calc_clat_percentiles(ts->io_u_plat[ddir],
+	if (ts->lat_percentiles)
+		len = calc_clat_percentiles(ts->io_u_plat[FIO_LAT][ddir],
+					ts->lat_stat[ddir].samples,
+					ts->percentile_list, &ovals, &maxv,
+					&minv);
+	else if (ts->clat_percentiles)
+		len = calc_clat_percentiles(ts->io_u_plat[FIO_CLAT][ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
 					&minv);
-	} else
+	else
 		len = 0;
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
@@ -1221,18 +1239,63 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	}
 }
 
+static struct json_object *add_ddir_lat_json(struct thread_stat *ts, uint32_t percentiles,
+		struct io_stat *lat_stat, uint64_t *io_u_plat)
+{
+	char buf[120];
+	double mean, dev;
+	unsigned int i, len;
+	struct json_object *lat_object, *percentile_object, *clat_bins_object;
+	unsigned long long min, max, maxv, minv, *ovals = NULL;
+
+	if (!calc_lat(lat_stat, &min, &max, &mean, &dev)) {
+		min = max = 0;
+		mean = dev = 0.0;
+	}
+	lat_object = json_create_object();
+	json_object_add_value_int(lat_object, "min", min);
+	json_object_add_value_int(lat_object, "max", max);
+	json_object_add_value_float(lat_object, "mean", mean);
+	json_object_add_value_float(lat_object, "stddev", dev);
+	json_object_add_value_int(lat_object, "N", lat_stat->samples);
+
+	if (percentiles && lat_stat->samples) {
+		len = calc_clat_percentiles(io_u_plat, lat_stat->samples,
+				ts->percentile_list, &ovals, &maxv, &minv);
+
+		if (len > FIO_IO_U_LIST_MAX_LEN)
+			len = FIO_IO_U_LIST_MAX_LEN;
+
+		percentile_object = json_create_object();
+		json_object_add_value_object(lat_object, "percentile", percentile_object);
+		for (i = 0; i < len; i++) {
+			snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
+			json_object_add_value_int(percentile_object, buf, ovals[i]);
+		}
+		free(ovals);
+
+		if (output_format & FIO_OUTPUT_JSON_PLUS) {
+			clat_bins_object = json_create_object();
+			json_object_add_value_object(lat_object, "bins", clat_bins_object);
+
+			for(i = 0; i < FIO_IO_U_PLAT_NR; i++)
+				if (io_u_plat[i]) {
+					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
+					json_object_add_value_int(clat_bins_object, buf, io_u_plat[i]);
+				}
+		}
+	}
+
+	return lat_object;
+}
+
 static void add_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, int ddir, struct json_object *parent)
 {
-	unsigned long long min, max, minv, maxv;
+	unsigned long long min, max;
 	unsigned long long bw_bytes, bw;
-	unsigned long long *ovals = NULL;
 	double mean, dev, iops;
-	unsigned int len;
-	int i;
-	struct json_object *dir_object, *tmp_object, *percentile_object = NULL,
-		*clat_bins_object = NULL;
-	char buf[120];
+	struct json_object *dir_object, *tmp_object;
 	double p_of_agg = 100.0;
 
 	assert(ddir_rw(ddir) || ddir_sync(ddir));
@@ -1266,222 +1329,47 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
 		json_object_add_value_int(dir_object, "drop_ios", ts->drop_io_u[ddir]);
 
-		if (!calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev)) {
-			min = max = 0;
-			mean = dev = 0.0;
-		}
-		tmp_object = json_create_object();
+		tmp_object = add_ddir_lat_json(ts, ts->slat_percentiles,
+				&ts->slat_stat[ddir], ts->io_u_plat[FIO_SLAT][ddir]);
 		json_object_add_value_object(dir_object, "slat_ns", tmp_object);
-		json_object_add_value_int(tmp_object, "min", min);
-		json_object_add_value_int(tmp_object, "max", max);
-		json_object_add_value_float(tmp_object, "mean", mean);
-		json_object_add_value_float(tmp_object, "stddev", dev);
-
-		if (!calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev)) {
-			min = max = 0;
-			mean = dev = 0.0;
-		}
-		tmp_object = json_create_object();
+
+		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles,
+				&ts->clat_stat[ddir], ts->io_u_plat[FIO_CLAT][ddir]);
 		json_object_add_value_object(dir_object, "clat_ns", tmp_object);
-		json_object_add_value_int(tmp_object, "min", min);
-		json_object_add_value_int(tmp_object, "max", max);
-		json_object_add_value_float(tmp_object, "mean", mean);
-		json_object_add_value_float(tmp_object, "stddev", dev);
-	} else {
-		if (!calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
-			min = max = 0;
-			mean = dev = 0.0;
-		}
 
-		tmp_object = json_create_object();
+		tmp_object = add_ddir_lat_json(ts, ts->lat_percentiles,
+				&ts->lat_stat[ddir], ts->io_u_plat[FIO_LAT][ddir]);
 		json_object_add_value_object(dir_object, "lat_ns", tmp_object);
+	} else {
 		json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[DDIR_SYNC]);
-		json_object_add_value_int(tmp_object, "min", min);
-		json_object_add_value_int(tmp_object, "max", max);
-		json_object_add_value_float(tmp_object, "mean", mean);
-		json_object_add_value_float(tmp_object, "stddev", dev);
-	}
-
-	if (ts->clat_percentiles || ts->lat_percentiles) {
-		if (ddir_rw(ddir)) {
-			uint64_t samples;
-
-			if (ts->clat_percentiles)
-				samples = ts->clat_stat[ddir].samples;
-			else
-				samples = ts->lat_stat[ddir].samples;
-
-			len = calc_clat_percentiles(ts->io_u_plat[ddir],
-					samples, ts->percentile_list, &ovals,
-					&maxv, &minv);
-		} else {
-			len = calc_clat_percentiles(ts->io_u_sync_plat,
-					ts->sync_stat.samples,
-					ts->percentile_list, &ovals, &maxv,
-					&minv);
-		}
-
-		if (len > FIO_IO_U_LIST_MAX_LEN)
-			len = FIO_IO_U_LIST_MAX_LEN;
-	} else
-		len = 0;
-
-	if (ts->clat_percentiles) {
-		percentile_object = json_create_object();
-		json_object_add_value_object(tmp_object, "percentile", percentile_object);
-		for (i = 0; i < len; i++) {
-			snprintf(buf, sizeof(buf), "%f",
-				 ts->percentile_list[i].u.f);
-			json_object_add_value_int(percentile_object, buf,
-						  ovals[i]);
-		}
-	}
-
-	free(ovals);
-
-	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->clat_percentiles) {
-		clat_bins_object = json_create_object();
-		json_object_add_value_object(tmp_object, "bins",
-					     clat_bins_object);
-
-		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-			if (ddir_rw(ddir)) {
-				if (ts->io_u_plat[ddir][i]) {
-					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
-					json_object_add_value_int(clat_bins_object, buf, ts->io_u_plat[ddir][i]);
-				}
-			} else {
-				if (ts->io_u_sync_plat[i]) {
-					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
-					json_object_add_value_int(clat_bins_object, buf, ts->io_u_sync_plat[i]);
-				}
-			}
-		}
+		tmp_object = add_ddir_lat_json(ts, ts->lat_percentiles | ts->clat_percentiles,
+				&ts->sync_stat, ts->io_u_sync_plat);
+		json_object_add_value_object(dir_object, "lat_ns", tmp_object);
 	}
 
+	if (!ddir_rw(ddir))
+		return;
 
 	/* Only print PRIO latencies if some high priority samples were gathered */
 	if (ts->clat_high_prio_stat[ddir].samples > 0) {
-		/* START OF HIGH PRIO CLAT */
-	    if (!calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
-			min = max = 0;
-			mean = dev = 0.0;
-		}
-		tmp_object = json_create_object();
-		json_object_add_value_object(dir_object, "clat_prio",
-				tmp_object);
-		json_object_add_value_int(tmp_object, "samples",
-				ts->clat_high_prio_stat[ddir].samples);
-		json_object_add_value_int(tmp_object, "min", min);
-		json_object_add_value_int(tmp_object, "max", max);
-		json_object_add_value_float(tmp_object, "mean", mean);
-		json_object_add_value_float(tmp_object, "stddev", dev);
-
-		if (ts->clat_percentiles) {
-			len = calc_clat_percentiles(ts->io_u_plat_high_prio[ddir],
-						ts->clat_high_prio_stat[ddir].samples,
-						ts->percentile_list, &ovals, &maxv,
-						&minv);
-		} else
-			len = 0;
-
-		percentile_object = json_create_object();
-		json_object_add_value_object(tmp_object, "percentile", percentile_object);
-		for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
-			if (i >= len) {
-				json_object_add_value_int(percentile_object, "0.00", 0);
-				continue;
-			}
-			snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
-			json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
-		}
-
-		if (output_format & FIO_OUTPUT_JSON_PLUS) {
-			clat_bins_object = json_create_object();
-			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
-			for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-				snprintf(buf, sizeof(buf), "%d", i);
-				json_object_add_value_int(clat_bins_object, (const char *)buf,
-						ts->io_u_plat_high_prio[ddir][i]);
-			}
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS",
-					FIO_IO_U_PLAT_BITS);
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL",
-					FIO_IO_U_PLAT_VAL);
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR",
-					FIO_IO_U_PLAT_NR);
-		}
-		/* END OF HIGH PRIO CLAT */
-
-		/* START OF PRIO CLAT */
-	    if (!calc_lat(&ts->clat_prio_stat[ddir], &min, &max, &mean, &dev)) {
-			min = max = 0;
-			mean = dev = 0.0;
-		}
-		tmp_object = json_create_object();
-		json_object_add_value_object(dir_object, "clat_low_prio",
-				tmp_object);
-		json_object_add_value_int(tmp_object, "samples",
-				ts->clat_prio_stat[ddir].samples);
-		json_object_add_value_int(tmp_object, "min", min);
-		json_object_add_value_int(tmp_object, "max", max);
-		json_object_add_value_float(tmp_object, "mean", mean);
-		json_object_add_value_float(tmp_object, "stddev", dev);
-
-		if (ts->clat_percentiles) {
-			len = calc_clat_percentiles(ts->io_u_plat_prio[ddir],
-						ts->clat_prio_stat[ddir].samples,
-						ts->percentile_list, &ovals, &maxv,
-						&minv);
-		} else
-			len = 0;
-
-		percentile_object = json_create_object();
-		json_object_add_value_object(tmp_object, "percentile", percentile_object);
-		for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
-			if (i >= len) {
-				json_object_add_value_int(percentile_object, "0.00", 0);
-				continue;
-			}
-			snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
-			json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
-		}
+		const char *high, *low;
 
-		if (output_format & FIO_OUTPUT_JSON_PLUS) {
-			clat_bins_object = json_create_object();
-			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
-			for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-				snprintf(buf, sizeof(buf), "%d", i);
-				json_object_add_value_int(clat_bins_object, (const char *)buf,
-						ts->io_u_plat_prio[ddir][i]);
-			}
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS",
-					FIO_IO_U_PLAT_BITS);
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL",
-					FIO_IO_U_PLAT_VAL);
-			json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR",
-					FIO_IO_U_PLAT_NR);
+		if (ts->lat_percentiles) {
+			high = "lat_high_prio";
+			low = "lat_low_prio";
+		} else {
+			high = "clat_high_prio";
+			low = "clat_low_prio";
 		}
-		/* END OF PRIO CLAT */
-	}
 
-	if (!ddir_rw(ddir))
-		return;
+		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
+				&ts->clat_high_prio_stat[ddir], ts->io_u_plat_high_prio[ddir]);
+		json_object_add_value_object(dir_object, high, tmp_object);
 
-	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {
-		min = max = 0;
-		mean = dev = 0.0;
+		tmp_object = add_ddir_lat_json(ts, ts->clat_percentiles | ts->lat_percentiles,
+				&ts->clat_low_prio_stat[ddir], ts->io_u_plat_low_prio[ddir]);
+		json_object_add_value_object(dir_object, low, tmp_object);
 	}
-	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "lat_ns", tmp_object);
-	json_object_add_value_int(tmp_object, "min", min);
-	json_object_add_value_int(tmp_object, "max", max);
-	json_object_add_value_float(tmp_object, "mean", mean);
-	json_object_add_value_float(tmp_object, "stddev", dev);
-	if (ts->lat_percentiles)
-		json_object_add_value_object(tmp_object, "percentile", percentile_object);
-	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
-		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		if (rs->agg[ddir]) {
@@ -1493,6 +1381,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		min = max = 0;
 		p_of_agg = mean = dev = 0.0;
 	}
+
 	json_object_add_value_int(dir_object, "bw_min", min);
 	json_object_add_value_int(dir_object, "bw_max", max);
 	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
@@ -1981,13 +1870,13 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		      bool first)
 {
-	int l, k;
+	int k, l, m;
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!dst->unified_rw_rep) {
 			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
 			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
-			sum_stat(&dst->clat_prio_stat[l], &src->clat_prio_stat[l], first, false);
+			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], first, false);
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
@@ -1999,8 +1888,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 				dst->runtime[l] = src->runtime[l];
 		} else {
 			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
-			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
-			sum_stat(&dst->clat_prio_stat[l], &src->clat_prio_stat[l], first, false);
+			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], first, false);
+			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], first, false);
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
@@ -2039,9 +1928,6 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 
-	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
-		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
-
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		if (!dst->unified_rw_rep) {
 			dst->total_io_u[k] += src->total_io_u[k];
@@ -2056,18 +1942,25 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 
 	dst->total_io_u[DDIR_SYNC] += src->total_io_u[DDIR_SYNC];
 
-	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
-		int m;
+	for (k = 0; k < FIO_LAT_CNT; k++)
+		for (l = 0; l < DDIR_RWDIR_CNT; l++)
+			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
+				if (!dst->unified_rw_rep)
+					dst->io_u_plat[k][l][m] += src->io_u_plat[k][l][m];
+				else
+					dst->io_u_plat[k][0][m] += src->io_u_plat[k][l][m];
 
+	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
+
+	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
 			if (!dst->unified_rw_rep) {
-				dst->io_u_plat[k][m] += src->io_u_plat[k][m];
 				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_prio[k][m] += src->io_u_plat_prio[k][m];
+				dst->io_u_plat_low_prio[k][m] += src->io_u_plat_low_prio[k][m];
 			} else {
-				dst->io_u_plat[0][m] += src->io_u_plat[k][m];
 				dst->io_u_plat_high_prio[0][m] += src->io_u_plat_high_prio[k][m];
-				dst->io_u_plat_prio[0][m] += src->io_u_plat_prio[k][m];
+				dst->io_u_plat_low_prio[0][m] += src->io_u_plat_low_prio[k][m];
 			}
 
 		}
@@ -2103,7 +1996,7 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->bw_stat[j].min_val = -1UL;
 		ts->iops_stat[j].min_val = -1UL;
 		ts->clat_high_prio_stat[j].min_val = -1UL;
-		ts->clat_prio_stat[j].min_val = -1UL;
+		ts->clat_low_prio_stat[j].min_val = -1UL;
 	}
 	ts->sync_stat.min_val = -1UL;
 	ts->groupid = -1;
@@ -2173,6 +2066,7 @@ void __show_run_stats(void)
 
 		ts->clat_percentiles = td->o.clat_percentiles;
 		ts->lat_percentiles = td->o.lat_percentiles;
+		ts->slat_percentiles = td->o.slat_percentiles;
 		ts->percentile_precision = td->o.percentile_precision;
 		memcpy(ts->percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
 		opt_lists[j] = &td->opt_list;
@@ -2728,11 +2622,11 @@ static inline void reset_io_stat(struct io_stat *ios)
 void reset_io_stats(struct thread_data *td)
 {
 	struct thread_stat *ts = &td->ts;
-	int i, j;
+	int i, j, k;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		reset_io_stat(&ts->clat_high_prio_stat[i]);
-		reset_io_stat(&ts->clat_prio_stat[i]);
+		reset_io_stat(&ts->clat_low_prio_stat[i]);
 		reset_io_stat(&ts->clat_stat[i]);
 		reset_io_stat(&ts->slat_stat[i]);
 		reset_io_stat(&ts->lat_stat[i]);
@@ -2746,14 +2640,18 @@ void reset_io_stats(struct thread_data *td)
 		ts->drop_io_u[i] = 0;
 
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
-			ts->io_u_plat[i][j] = 0;
 			ts->io_u_plat_high_prio[i][j] = 0;
-			ts->io_u_plat_prio[i][j] = 0;
+			ts->io_u_plat_low_prio[i][j] = 0;
 			if (!i)
 				ts->io_u_sync_plat[j] = 0;
 		}
 	}
 
+	for (i = 0; i < FIO_LAT_CNT; i++)
+		for (j = 0; j < DDIR_RWDIR_CNT; j++)
+			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+				ts->io_u_plat[i][j][k] = 0;
+
 	ts->total_io_u[DDIR_SYNC] = 0;
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
@@ -2892,19 +2790,27 @@ void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
 	add_stat_sample(&ts->sync_stat, nsec);
 }
 
-static void add_clat_percentile_sample(struct thread_stat *ts,
-				unsigned long long nsec, enum fio_ddir ddir, uint8_t priority_bit)
+static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
+				unsigned long long nsec, enum fio_ddir ddir, enum fio_lat lat)
 {
 	unsigned int idx = plat_val_to_idx(nsec);
 	assert(idx < FIO_IO_U_PLAT_NR);
 
-	ts->io_u_plat[ddir][idx]++;
+	ts->io_u_plat[lat][ddir][idx]++;
+}
 
-	if (!priority_bit) {
-		ts->io_u_plat_prio[ddir][idx]++;
-	} else {
+static void add_lat_percentile_sample(struct thread_stat *ts,
+				unsigned long long nsec, enum fio_ddir ddir, uint8_t priority_bit,
+				enum fio_lat lat)
+{
+	unsigned int idx = plat_val_to_idx(nsec);
+
+	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
+
+	if (!priority_bit)
+		ts->io_u_plat_low_prio[ddir][idx]++;
+	else
 		ts->io_u_plat_high_prio[ddir][idx]++;
-	}
 }
 
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
@@ -2921,10 +2827,11 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
-	if (priority_bit) {
-		add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
-	} else {
-		add_stat_sample(&ts->clat_prio_stat[ddir], nsec);
+	if (!ts->lat_percentiles) {
+		if (priority_bit)
+			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
+		else
+			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
 	}
 
 	if (td->clat_log)
@@ -2932,7 +2839,10 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			       offset, priority_bit);
 
 	if (ts->clat_percentiles) {
-		add_clat_percentile_sample(ts, nsec, ddir, priority_bit);
+		if (ts->lat_percentiles)
+			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
+		else
+			add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_CLAT);
 	}
 
 	if (iolog && iolog->hist_msec) {
@@ -2955,7 +2865,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			 * located in iolog.c after printing this sample to the
 			 * log file.
 			 */
-			io_u_plat = (uint64_t *) td->ts.io_u_plat[ddir];
+			io_u_plat = (uint64_t *) td->ts.io_u_plat[FIO_CLAT][ddir];
 			dst = malloc(sizeof(struct io_u_plat_entry));
 			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(uint64_t));
@@ -2978,7 +2888,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-			unsigned long usec, unsigned long long bs, uint64_t offset,
+			unsigned long long nsec, unsigned long long bs, uint64_t offset,
 			uint8_t priority_bit)
 {
 	const bool needs_lock = td_async_processing(td);
@@ -2990,12 +2900,15 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (needs_lock)
 		__td_io_u_lock(td);
 
-	add_stat_sample(&ts->slat_stat[ddir], usec);
+	add_stat_sample(&ts->slat_stat[ddir], nsec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, sample_val(usec), ddir, bs, offset,
+		add_log_sample(td, td->slat_log, sample_val(nsec), ddir, bs, offset,
 			priority_bit);
 
+	if (ts->slat_percentiles)
+		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
+
 	if (needs_lock)
 		__td_io_u_unlock(td);
 }
@@ -3019,9 +2932,14 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset, priority_bit);
 
-	if (ts->lat_percentiles)
-		add_clat_percentile_sample(ts, nsec, ddir, priority_bit);
+	if (ts->lat_percentiles) {
+		add_lat_percentile_sample(ts, nsec, ddir, priority_bit, FIO_LAT);
+		if (priority_bit)
+			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
+		else
+			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
 
+	}
 	if (needs_lock)
 		__td_io_u_unlock(td);
 }
diff --git a/stat.h b/stat.h
index 9320c6bd..0d141666 100644
--- a/stat.h
+++ b/stat.h
@@ -37,7 +37,7 @@ struct group_run_stats {
 					list of percentiles */
 
 /*
- * Aggregate clat samples to report percentile(s) of them.
+ * Aggregate latency samples for reporting percentile(s).
  *
  * EXECUTIVE SUMMARY
  *
@@ -58,7 +58,7 @@ struct group_run_stats {
  *
  * DETAILS
  *
- * Suppose the clat varies from 0 to 999 (usec), the straightforward
+ * Suppose the lat varies from 0 to 999 (usec), the straightforward
  * method is to keep an array of (999 + 1) buckets, in which a counter
  * keeps the count of samples which fall in the bucket, e.g.,
  * {[0],[1],...,[999]}. However this consumes a huge amount of space,
@@ -147,6 +147,14 @@ enum block_info_state {
 #define FIO_JOBDESC_SIZE	256
 #define FIO_VERROR_SIZE		128
 
+enum fio_lat {
+	FIO_SLAT = 0,
+	FIO_CLAT,
+	FIO_LAT,
+
+	FIO_LAT_CNT = 3,
+};
+
 struct thread_stat {
 	char name[FIO_JOBNAME_SIZE];
 	char verror[FIO_VERROR_SIZE];
@@ -181,6 +189,8 @@ struct thread_stat {
 	 */
 	uint32_t clat_percentiles;
 	uint32_t lat_percentiles;
+	uint32_t slat_percentiles;
+	uint32_t pad;
 	uint64_t percentile_precision;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
@@ -190,7 +200,7 @@ struct thread_stat {
 	uint64_t io_u_lat_n[FIO_IO_U_LAT_N_NR];
 	uint64_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	uint64_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	uint64_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint64_t io_u_plat[FIO_LAT_CNT][DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
 	uint64_t io_u_sync_plat[FIO_IO_U_PLAT_NR];
 
 	uint64_t total_io_u[DDIR_RWDIR_SYNC_CNT];
@@ -240,9 +250,9 @@ struct thread_stat {
 	fio_fp64_t ss_criterion;
 
 	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribute__((aligned(8)));;
-	uint64_t io_u_plat_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
 	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));
-	struct io_stat clat_prio_stat[DDIR_RWDIR_CNT];
+	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
 
 	union {
 		uint64_t *ss_iops_data;
@@ -331,7 +341,7 @@ extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long lo
 				unsigned long long, uint64_t, uint8_t);
 extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
 				unsigned long long, uint64_t, uint8_t);
-extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
+extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
 				unsigned long long, uint64_t, uint8_t);
 extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long bs,
 				uint8_t priority_bit);
diff --git a/t/latency_percentiles.py b/t/latency_percentiles.py
new file mode 100755
index 00000000..0c8d0c19
--- /dev/null
+++ b/t/latency_percentiles.py
@@ -0,0 +1,1324 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Copyright (c) 2020 Western Digital Corporation or its affiliates.
+#
+"""
+# latency_percentiles.py
+#
+# Test the code that produces latency percentiles
+# This is mostly to test the code changes to allow reporting
+# of slat, clat, and lat percentiles
+#
+# USAGE
+# python3 latency-tests.py [-f fio-path] [-a artifact-root] [--debug]
+#
+#
+# Test scenarios:
+#
+# - DONE json
+#   unified rw reporting
+#   compare with latency log
+#   try various combinations of the ?lat_percentile options
+#   null, aio
+#   r, w, t
+# - DONE json+
+#   check presence of latency bins
+#   if the json percentiles match those from the raw data
+#   then the latency bin values and counts are probably ok
+# - DONE terse
+#   produce both terse, JSON output and confirm that they match
+#   lat only; both lat and clat
+# - DONE sync_lat
+#   confirm that sync_lat data appears
+# - MANUAL TESTING normal output:
+#       null ioengine
+#           enable all, but only clat and lat appear
+#           enable subset of latency types
+#           read, write, trim, unified
+#       libaio ioengine
+#           enable all latency types
+#           enable subset of latency types
+#           read, write, trim, unified
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=null --slat_percentiles=1 --clat_percentiles=1 --lat_percentiles=1
+# echo confirm that clat and lat percentiles appear
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=null --slat_percentiles=0 --clat_percentiles=0 --lat_percentiles=1
+# echo confirm that only lat percentiles appear
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=null --slat_percentiles=0 --clat_percentiles=1 --lat_percentiles=0
+# echo confirm that only clat percentiles appear
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=libaio --slat_percentiles=1 --clat_percentiles=1 --lat_percentiles=1
+# echo confirm that slat, clat, lat percentiles appear
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=libaio --slat_percentiles=0 --clat_percentiles=1 --lat_percentiles=1
+# echo confirm that clat and lat percentiles appear
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=libaio -rw=randrw
+# echo confirm that clat percentiles appear for reads and writes
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=libaio --slat_percentiles=1 --clat_percentiles=0 --lat_percentiles=0 --rw=randrw
+# echo confirm that slat percentiles appear for both reads and writes
+# ./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=libaio --slat_percentiles=1 --clat_percentiles=1 --lat_percentiles=1 \
+#       --rw=randrw --unified_rw_reporting=1
+# echo confirm that slat, clat, and lat percentiles appear for 'mixed' IOs
+#./fio/fio --name=test --randrepeat=0 --norandommap --time_based --runtime=2s --size=512M \
+#       --ioengine=null --slat_percentiles=1 --clat_percentiles=1 --lat_percentiles=1 \
+#       --rw=randrw --fsync=32
+# echo confirm that fsync latencies appear
+"""
+
+import os
+import csv
+import sys
+import json
+import math
+import time
+import argparse
+import platform
+import subprocess
+from pathlib import Path
+
+
+class FioLatTest():
+    """fio latency percentile test."""
+
+    def __init__(self, artifact_root, test_options, debug):
+        """
+        artifact_root   root directory for artifacts (subdirectory will be created under here)
+        test            test specification
+        """
+        self.artifact_root = artifact_root
+        self.test_options = test_options
+        self.debug = debug
+        self.filename = None
+        self.json_data = None
+        self.terse_data = None
+
+        self.test_dir = os.path.join(self.artifact_root,
+                                     "{:03d}".format(self.test_options['test_id']))
+        if not os.path.exists(self.test_dir):
+            os.mkdir(self.test_dir)
+
+        self.filename = "latency{:03d}".format(self.test_options['test_id'])
+
+    def run_fio(self, fio_path):
+        """Run a test."""
+
+        fio_args = [
+            "--name=latency",
+            "--randrepeat=0",
+            "--norandommap",
+            "--time_based",
+            "--size=16M",
+            "--rwmixread=50",
+            "--group_reporting=1",
+            "--write_lat_log={0}".format(self.filename),
+            "--output={0}.out".format(self.filename),
+            "--ioengine={ioengine}".format(**self.test_options),
+            "--rw={rw}".format(**self.test_options),
+            "--runtime={runtime}".format(**self.test_options),
+            "--output-format={output-format}".format(**self.test_options),
+        ]
+        for opt in ['slat_percentiles', 'clat_percentiles', 'lat_percentiles',
+                    'unified_rw_reporting', 'fsync', 'fdatasync', 'numjobs', 'cmdprio_percentage']:
+            if opt in self.test_options:
+                option = '--{0}={{{0}}}'.format(opt)
+                fio_args.append(option.format(**self.test_options))
+
+        command = [fio_path] + fio_args
+        with open(os.path.join(self.test_dir, "{0}.command".format(self.filename)), "w+") as \
+                command_file:
+            command_file.write("%s\n" % command)
+
+        passed = True
+        stdout_file = open(os.path.join(self.test_dir, "{0}.stdout".format(self.filename)), "w+")
+        stderr_file = open(os.path.join(self.test_dir, "{0}.stderr".format(self.filename)), "w+")
+        exitcode_file = open(os.path.join(self.test_dir,
+                                          "{0}.exitcode".format(self.filename)), "w+")
+        try:
+            proc = None
+            # Avoid using subprocess.run() here because when a timeout occurs,
+            # fio will be stopped with SIGKILL. This does not give fio a
+            # chance to clean up and means that child processes may continue
+            # running and submitting IO.
+            proc = subprocess.Popen(command,
+                                    stdout=stdout_file,
+                                    stderr=stderr_file,
+                                    cwd=self.test_dir,
+                                    universal_newlines=True)
+            proc.communicate(timeout=300)
+            exitcode_file.write('{0}\n'.format(proc.returncode))
+            passed &= (proc.returncode == 0)
+        except subprocess.TimeoutExpired:
+            proc.terminate()
+            proc.communicate()
+            assert proc.poll()
+            print("Timeout expired")
+            passed = False
+        except Exception:
+            if proc:
+                if not proc.poll():
+                    proc.terminate()
+                    proc.communicate()
+            print("Exception: %s" % sys.exc_info())
+            passed = False
+        finally:
+            stdout_file.close()
+            stderr_file.close()
+            exitcode_file.close()
+
+        if passed:
+            if 'json' in self.test_options['output-format']:
+                if not self.get_json():
+                    print('Unable to decode JSON data')
+                    passed = False
+            if 'terse' in self.test_options['output-format']:
+                if not self.get_terse():
+                    print('Unable to decode terse data')
+                    passed = False
+
+        return passed
+
+    def get_json(self):
+        """Convert fio JSON output into a python JSON object"""
+
+        filename = os.path.join(self.test_dir, "{0}.out".format(self.filename))
+        with open(filename, 'r') as file:
+            file_data = file.read()
+
+        #
+        # Sometimes fio informational messages are included at the top of the
+        # JSON output, especially under Windows. Try to decode output as JSON
+        # data, lopping off up to the first four lines
+        #
+        lines = file_data.splitlines()
+        for i in range(5):
+            file_data = '\n'.join(lines[i:])
+            try:
+                self.json_data = json.loads(file_data)
+            except json.JSONDecodeError:
+                continue
+            else:
+                return True
+
+        return False
+
+    def get_terse(self):
+        """Read fio output and return terse format data."""
+
+        filename = os.path.join(self.test_dir, "{0}.out".format(self.filename))
+        with open(filename, 'r') as file:
+            file_data = file.read()
+
+        #
+        # Read the first few lines and see if any of them begin with '3;fio-'
+        # If so, the line is probably terse output. Obviously, this only
+        # works for fio terse version 3 and it does not work for
+        # multi-line terse output
+        #
+        lines = file_data.splitlines()
+        for i in range(8):
+            file_data = lines[i]
+            if file_data.startswith('3;fio-'):
+                self.terse_data = file_data.split(';')
+                return True
+
+        return False
+
+    def check_latencies(self, jsondata, ddir, slat=True, clat=True, tlat=True, plus=False,
+                        unified=False):
+        """Check fio latency data.
+
+        ddir                data direction to check (0=read, 1=write, 2=trim)
+        slat                True if submission latency data available to check
+        clat                True if completion latency data available to check
+        tlat                True of total latency data available to check
+        plus                True if we actually have json+ format data where additional checks can
+                            be carried out
+        unified             True if fio is reporting unified r/w data
+        """
+
+        types = {
+            'slat': slat,
+            'clat': clat,
+            'lat': tlat
+        }
+
+        retval = True
+
+        for lat in ['slat', 'clat', 'lat']:
+            this_iter = True
+            if not types[lat]:
+                if 'percentile' in jsondata[lat+'_ns']:
+                    this_iter = False
+                    print('unexpected %s percentiles found' % lat)
+                else:
+                    print("%s percentiles skipped" % lat)
+                continue
+            else:
+                if 'percentile' not in jsondata[lat+'_ns']:
+                    this_iter = False
+                    print('%s percentiles not found in fio output' % lat)
+
+            #
+            # Check only for the presence/absence of json+
+            # latency bins. Future work can check the
+            # accurracy of the bin values and counts.
+            #
+            # Because the latency percentiles are based on
+            # the bins, we can be confident that the bin
+            # values and counts are correct if fio's
+            # latency percentiles match what we compute
+            # from the raw data.
+            #
+            if plus:
+                if 'bins' not in jsondata[lat+'_ns']:
+                    print('bins not found with json+ output format')
+                    this_iter = False
+                else:
+                    if not self.check_jsonplus(jsondata[lat+'_ns']):
+                        this_iter = False
+            else:
+                if 'bins' in jsondata[lat+'_ns']:
+                    print('json+ bins found with json output format')
+                    this_iter = False
+
+            latencies = []
+            for i in range(10):
+                lat_file = os.path.join(self.test_dir, "%s_%s.%s.log" % (self.filename, lat, i+1))
+                if not os.path.exists(lat_file):
+                    break
+                with open(lat_file, 'r', newline='') as file:
+                    reader = csv.reader(file)
+                    for line in reader:
+                        if unified or int(line[2]) == ddir:
+                            latencies.append(int(line[1]))
+
+            if int(jsondata['total_ios']) != len(latencies):
+                this_iter = False
+                print('%s: total_ios = %s, latencies logged = %d' % \
+                        (lat, jsondata['total_ios'], len(latencies)))
+            elif self.debug:
+                print("total_ios %s match latencies logged" % jsondata['total_ios'])
+
+            latencies.sort()
+            ptiles = jsondata[lat+'_ns']['percentile']
+
+            for percentile in ptiles.keys():
+                #
+                # numpy.percentile(latencies, float(percentile),
+                #       interpolation='higher')
+                # produces values that mostly match what fio reports
+                # however, in the tails of the distribution, the values produced
+                # by fio's and numpy.percentile's algorithms are occasionally off
+                # by one latency measurement. So instead of relying on the canned
+                # numpy.percentile routine, implement here fio's algorithm
+                #
+                rank = math.ceil(float(percentile)/100 * len(latencies))
+                if rank > 0:
+                    index = rank - 1
+                else:
+                    index = 0
+                value = latencies[int(index)]
+                fio_val = int(ptiles[percentile])
+                # The theory in stat.h says that the proportional error will be
+                # less than 1/128
+                if not self.similar(fio_val, value):
+                    delta = abs(fio_val - value) / value
+                    print("Error with %s %sth percentile: "
+                          "fio: %d, expected: %d, proportional delta: %f" %
+                          (lat, percentile, fio_val, value, delta))
+                    print("Rank: %d, index: %d" % (rank, index))
+                    this_iter = False
+                elif self.debug:
+                    print('%s %sth percentile values match: %d, %d' %
+                          (lat, percentile, fio_val, value))
+
+            if this_iter:
+                print("%s percentiles match" % lat)
+            else:
+                retval = False
+
+        return retval
+
+    @staticmethod
+    def check_empty(job):
+        """
+        Make sure JSON data is empty.
+
+        Some data structures should be empty. This function makes sure that they are.
+
+        job         JSON object that we need to check for emptiness
+        """
+
+        return job['total_ios'] == 0 and \
+                job['slat_ns']['N'] == 0 and \
+                job['clat_ns']['N'] == 0 and \
+                job['lat_ns']['N'] == 0
+
+    def check_nocmdprio_lat(self, job):
+        """
+        Make sure no high/low priority latencies appear.
+
+        job         JSON object to check
+        """
+
+        for ddir in ['read', 'write', 'trim']:
+            if ddir in job:
+                if 'lat_high_prio' in job[ddir] or 'lat_low_prio' in job[ddir] or \
+                    'clat_high_prio' in job[ddir] or 'clat_low_prio' in job[ddir]:
+                    print("Unexpected high/low priority latencies found in %s output" % ddir)
+                    return False
+
+        if self.debug:
+            print("No high/low priority latencies found")
+
+        return True
+
+    @staticmethod
+    def similar(approximation, actual):
+        """
+        Check whether the approximate values recorded by fio are within the theoretical bound.
+
+        Since it is impractical to store exact latency measurements for each and every IO, fio
+        groups similar latency measurements into variable-sized bins. The theory in stat.h says
+        that the proportional error will be less than 1/128. This function checks whether this
+        is true.
+
+        TODO This test will fail when comparing a value from the largest latency bin against its
+        actual measurement. Find some way to detect this and avoid failing.
+
+        approximation   value of the bin used by fio to store a given latency
+        actual          actual latency value
+        """
+        delta = abs(approximation - actual) / actual
+        return delta <= 1/128
+
+    def check_jsonplus(self, jsondata):
+        """Check consistency of json+ data
+
+        When we have json+ data we can check the min value, max value, and
+        sample size reported by fio
+
+        jsondata            json+ data that we need to check
+        """
+
+        retval = True
+
+        keys = [int(k) for k in jsondata['bins'].keys()]
+        values = [int(jsondata['bins'][k]) for k in jsondata['bins'].keys()]
+        smallest = min(keys)
+        biggest = max(keys)
+        sampsize = sum(values)
+
+        if not self.similar(jsondata['min'], smallest):
+            retval = False
+            print('reported min %d does not match json+ min %d' % (jsondata['min'], smallest))
+        elif self.debug:
+            print('json+ min values match: %d' % jsondata['min'])
+
+        if not self.similar(jsondata['max'], biggest):
+            retval = False
+            print('reported max %d does not match json+ max %d' % (jsondata['max'], biggest))
+        elif self.debug:
+            print('json+ max values match: %d' % jsondata['max'])
+
+        if sampsize != jsondata['N']:
+            retval = False
+            print('reported sample size %d does not match json+ total count %d' % \
+                    (jsondata['N'], sampsize))
+        elif self.debug:
+            print('json+ sample sizes match: %d' % sampsize)
+
+        return retval
+
+    def check_sync_lat(self, jsondata, plus=False):
+        """Check fsync latency percentile data.
+
+        All we can check is that some percentiles are reported, unless we have json+ data.
+        If we actually have json+ data then we can do more checking.
+
+        jsondata        JSON data for fsync operations
+        plus            True if we actually have json+ data
+        """
+        retval = True
+
+        if 'percentile' not in jsondata['lat_ns']:
+            print("Sync percentile data not found")
+            return False
+
+        if int(jsondata['total_ios']) != int(jsondata['lat_ns']['N']):
+            retval = False
+            print('Mismatch between total_ios and lat_ns sample size')
+        elif self.debug:
+            print('sync sample sizes match: %d' % jsondata['total_ios'])
+
+        if not plus:
+            if 'bins' in jsondata['lat_ns']:
+                print('Unexpected json+ bin data found')
+                return False
+
+        if not self.check_jsonplus(jsondata['lat_ns']):
+            retval = False
+
+        return retval
+
+    def check_terse(self, terse, jsondata):
+        """Compare terse latencies with JSON latencies.
+
+        terse           terse format data for checking
+        jsondata        JSON format data for checking
+        """
+
+        retval = True
+
+        for lat in terse:
+            split = lat.split('%')
+            pct = split[0]
+            terse_val = int(split[1][1:])
+            json_val = math.floor(jsondata[pct]/1000)
+            if terse_val != json_val:
+                retval = False
+                print('Mismatch with %sth percentile: json value=%d,%d terse value=%d' % \
+                        (pct, jsondata[pct], json_val, terse_val))
+            elif self.debug:
+                print('Terse %sth percentile matches JSON value: %d' % (pct, terse_val))
+
+        return retval
+
+    def check_prio_latencies(self, jsondata, clat=True, plus=False):
+        """Check consistency of high/low priority latencies.
+
+        clat                True if we should check clat data; other check lat data
+        plus                True if we have json+ format data where additional checks can
+                            be carried out
+        unified             True if fio is reporting unified r/w data
+        """
+
+        if clat:
+            high = 'clat_high_prio'
+            low = 'clat_low_prio'
+            combined = 'clat_ns'
+        else:
+            high = 'lat_high_prio'
+            low = 'lat_low_prio'
+            combined = 'lat_ns'
+
+        if not high in jsondata or not low in jsondata or not combined in jsondata:
+            print("Error identifying high/low priority latencies")
+            return False
+
+        if jsondata[high]['N'] + jsondata[low]['N'] != jsondata[combined]['N']:
+            print("High %d + low %d != combined sample size %d" % \
+                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
+            return False
+        elif self.debug:
+            print("High %d + low %d == combined sample size %d" % \
+                    (jsondata[high]['N'], jsondata[low]['N'], jsondata[combined]['N']))
+
+        if min(jsondata[high]['min'], jsondata[low]['min']) != jsondata[combined]['min']:
+            print("Min of high %d, low %d min latencies does not match min %d from combined data" % \
+                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
+            return False
+        elif self.debug:
+            print("Min of high %d, low %d min latencies matches min %d from combined data" % \
+                    (jsondata[high]['min'], jsondata[low]['min'], jsondata[combined]['min']))
+
+        if max(jsondata[high]['max'], jsondata[low]['max']) != jsondata[combined]['max']:
+            print("Max of high %d, low %d max latencies does not match max %d from combined data" % \
+                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
+            return False
+        elif self.debug:
+            print("Max of high %d, low %d max latencies matches max %d from combined data" % \
+                    (jsondata[high]['max'], jsondata[low]['max'], jsondata[combined]['max']))
+
+        weighted_avg = (jsondata[high]['mean'] * jsondata[high]['N'] + \
+                        jsondata[low]['mean'] * jsondata[low]['N']) / jsondata[combined]['N']
+        delta = abs(weighted_avg - jsondata[combined]['mean'])
+        if (delta / jsondata[combined]['mean']) > 0.0001:
+            print("Difference between weighted average %f of high, low means "
+                  "and actual mean %f exceeds 0.01%%" % (weighted_avg, jsondata[combined]['mean']))
+            return False
+        elif self.debug:
+            print("Weighted average %f of high, low means matches actual mean %f" % \
+                    (weighted_avg, jsondata[combined]['mean']))
+
+        if plus:
+            if not self.check_jsonplus(jsondata[high]):
+                return False
+            if not self.check_jsonplus(jsondata[low]):
+                return False
+
+            bins = {**jsondata[high]['bins'], **jsondata[low]['bins']}
+            for duration in bins.keys():
+                if duration in jsondata[high]['bins'] and duration in jsondata[low]['bins']:
+                    bins[duration] = jsondata[high]['bins'][duration] + \
+                            jsondata[low]['bins'][duration]
+
+            if len(bins) != len(jsondata[combined]['bins']):
+                print("Number of combined high/low bins does not match number of overall bins")
+                return False
+            elif self.debug:
+                print("Number of bins from merged high/low data matches number of overall bins")
+
+            for duration in bins.keys():
+                if bins[duration] != jsondata[combined]['bins'][duration]:
+                    print("Merged high/low count does not match overall count for duration %d" \
+                            % duration)
+                    return False
+
+        print("Merged high/low priority latency data match combined latency data")
+        return True
+
+    def check(self):
+        """Check test output."""
+
+        raise NotImplementedError()
+
+
+class Test001(FioLatTest):
+    """Test object for Test 1."""
+
+    def check(self):
+        """Check Test 1 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, slat=False)
+
+        return retval
+
+
+class Test002(FioLatTest):
+    """Test object for Test 2."""
+
+    def check(self):
+        """Check Test 2 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['read']):
+            print("Unexpected read data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['write'], 1, slat=False, clat=False)
+
+        return retval
+
+
+class Test003(FioLatTest):
+    """Test object for Test 3."""
+
+    def check(self):
+        """Check Test 3 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['read']):
+            print("Unexpected read data found in output")
+            retval = False
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['trim'], 2, slat=False, tlat=False)
+
+        return retval
+
+
+class Test004(FioLatTest):
+    """Test object for Tests 4, 13."""
+
+    def check(self):
+        """Check Test 4, 13 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, plus=True)
+
+        return retval
+
+
+class Test005(FioLatTest):
+    """Test object for Test 5."""
+
+    def check(self):
+        """Check Test 5 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['read']):
+            print("Unexpected read data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
+
+        return retval
+
+
+class Test006(FioLatTest):
+    """Test object for Test 6."""
+
+    def check(self):
+        """Check Test 6 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
+
+        return retval
+
+
+class Test007(FioLatTest):
+    """Test object for Test 7."""
+
+    def check(self):
+        """Check Test 7 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, clat=False, tlat=False, plus=True)
+        retval &= self.check_latencies(job['write'], 1, clat=False, tlat=False, plus=True)
+
+        return retval
+
+
+class Test008(FioLatTest):
+    """Test object for Tests 8, 14."""
+
+    def check(self):
+        """Check Test 8, 14 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if 'read' in job or 'write'in job or 'trim' in job:
+            print("Unexpected data direction found in fio output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['mixed'], 0, plus=True, unified=True)
+
+        return retval
+
+
+class Test009(FioLatTest):
+    """Test object for Test 9."""
+
+    def check(self):
+        """Check Test 9 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['read']):
+            print("Unexpected read data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_sync_lat(job['sync'], plus=True):
+            print("Error checking fsync latency data")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
+
+        return retval
+
+
+class Test010(FioLatTest):
+    """Test object for Test 10."""
+
+    def check(self):
+        """Check Test 10 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, plus=True)
+        retval &= self.check_latencies(job['write'], 1, plus=True)
+        retval &= self.check_terse(self.terse_data[17:34], job['read']['lat_ns']['percentile'])
+        retval &= self.check_terse(self.terse_data[58:75], job['write']['lat_ns']['percentile'])
+        # Terse data checking only works for default percentiles.
+        # This needs to be changed if something other than the default is ever used.
+
+        return retval
+
+
+class Test011(FioLatTest):
+    """Test object for Test 11."""
+
+    def check(self):
+        """Check Test 11 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+        if not self.check_nocmdprio_lat(job):
+            print("Unexpected high/low priority latencies found")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, slat=False, clat=False, plus=True)
+        retval &= self.check_latencies(job['write'], 1, slat=False, clat=False, plus=True)
+        retval &= self.check_terse(self.terse_data[17:34], job['read']['lat_ns']['percentile'])
+        retval &= self.check_terse(self.terse_data[58:75], job['write']['lat_ns']['percentile'])
+        # Terse data checking only works for default percentiles.
+        # This needs to be changed if something other than the default is ever used.
+
+        return retval
+
+
+class Test015(FioLatTest):
+    """Test object for Test 15."""
+
+    def check(self):
+        """Check Test 15 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, plus=True)
+        retval &= self.check_prio_latencies(job['read'], clat=False, plus=True)
+
+        return retval
+
+
+class Test016(FioLatTest):
+    """Test object for Test 16."""
+
+    def check(self):
+        """Check Test 16 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['read']):
+            print("Unexpected read data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+
+        retval &= self.check_latencies(job['write'], 1, slat=False, plus=True)
+        retval &= self.check_prio_latencies(job['write'], clat=False, plus=True)
+
+        return retval
+
+
+class Test017(FioLatTest):
+    """Test object for Test 17."""
+
+    def check(self):
+        """Check Test 17 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['write']):
+            print("Unexpected write data found in output")
+            retval = False
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, slat=False, tlat=False, plus=True)
+        retval &= self.check_prio_latencies(job['read'], plus=True)
+
+        return retval
+
+
+class Test018(FioLatTest):
+    """Test object for Test 18."""
+
+    def check(self):
+        """Check Test 18 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if not self.check_empty(job['trim']):
+            print("Unexpected trim data found in output")
+            retval = False
+
+        retval &= self.check_latencies(job['read'], 0, clat=False, tlat=False, plus=True)
+        retval &= self.check_latencies(job['write'], 1, clat=False, tlat=False, plus=True)
+
+        # We actually have json+ data but setting plus=False below avoids checking the
+        # json+ bins which did not exist for clat and lat because this job is run with
+        # clat_percentiles=0, lat_percentiles=0, However, we can still check the summary
+        # statistics
+        retval &= self.check_prio_latencies(job['write'], plus=False)
+        retval &= self.check_prio_latencies(job['read'], plus=False)
+
+        return retval
+
+
+class Test019(FioLatTest):
+    """Test object for Tests 19, 20."""
+
+    def check(self):
+        """Check Test 19, 20 output."""
+
+        job = self.json_data['jobs'][0]
+
+        retval = True
+        if 'read' in job or 'write'in job or 'trim' in job:
+            print("Unexpected data direction found in fio output")
+            retval = False
+
+        retval &= self.check_latencies(job['mixed'], 0, plus=True, unified=True)
+        retval &= self.check_prio_latencies(job['mixed'], clat=False, plus=True)
+
+        return retval
+
+
+def parse_args():
+    """Parse command-line arguments."""
+
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-f', '--fio', help='path to file executable (e.g., ./fio)')
+    parser.add_argument('-a', '--artifact-root', help='artifact root directory')
+    parser.add_argument('-d', '--debug', help='enable debug output', action='store_true')
+    parser.add_argument('-s', '--skip', nargs='+', type=int,
+                        help='list of test(s) to skip')
+    parser.add_argument('-o', '--run-only', nargs='+', type=int,
+                        help='list of test(s) to run, skipping all others')
+    args = parser.parse_args()
+
+    return args
+
+
+def main():
+    """Run tests of fio latency percentile reporting"""
+
+    args = parse_args()
+
+    artifact_root = args.artifact_root if args.artifact_root else \
+        "latency-test-{0}".format(time.strftime("%Y%m%d-%H%M%S"))
+    os.mkdir(artifact_root)
+    print("Artifact directory is %s" % artifact_root)
+
+    if args.fio:
+        fio = str(Path(args.fio).absolute())
+    else:
+        fio = 'fio'
+    print("fio path is %s" % fio)
+
+    if platform.system() == 'Linux':
+        aio = 'libaio'
+    elif platform.system() == 'Windows':
+        aio = 'windowsaio'
+    else:
+        aio = 'posixaio'
+
+    test_list = [
+        {
+            # randread, null
+            # enable slat, clat, lat
+            # only clat and lat will appear because
+            # because the null ioengine is syncrhonous
+            "test_id": 1,
+            "runtime": 2,
+            "output-format": "json",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": 'null',
+            'rw': 'randread',
+            "test_obj": Test001,
+        },
+        {
+            # randwrite, null
+            # enable lat only
+            "test_id": 2,
+            "runtime": 2,
+            "output-format": "json",
+            "slat_percentiles": 0,
+            "clat_percentiles": 0,
+            "lat_percentiles": 1,
+            "ioengine": 'null',
+            'rw': 'randwrite',
+            "test_obj": Test002,
+        },
+        {
+            # randtrim, null
+            # enable clat only
+            "test_id": 3,
+            "runtime": 2,
+            "output-format": "json",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 0,
+            "ioengine": 'null',
+            'rw': 'randtrim',
+            "test_obj": Test003,
+        },
+        {
+            # randread, aio
+            # enable slat, clat, lat
+            # all will appear because liaio is asynchronous
+            "test_id": 4,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randread',
+            "test_obj": Test004,
+        },
+        {
+            # randwrite, aio
+            # enable only clat, lat
+            "test_id": 5,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randwrite',
+            "test_obj": Test005,
+        },
+        {
+            # randread, aio
+            # by default only clat should appear
+            "test_id": 6,
+            "runtime": 5,
+            "output-format": "json+",
+            "ioengine": aio,
+            'rw': 'randread',
+            "test_obj": Test006,
+        },
+        {
+            # 50/50 r/w, aio
+            # enable only slat
+            "test_id": 7,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 0,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            "test_obj": Test007,
+        },
+        {
+            # 50/50 r/w, aio, unified_rw_reporting
+            # enable slat, clat, lat
+            "test_id": 8,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'unified_rw_reporting': 1,
+            "test_obj": Test008,
+        },
+        {
+            # randwrite, null
+            # enable slat, clat, lat
+            # fsync
+            "test_id": 9,
+            "runtime": 2,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": 'null',
+            'rw': 'randwrite',
+            'fsync': 32,
+            "test_obj": Test009,
+        },
+        {
+            # 50/50 r/w, aio
+            # enable slat, clat, lat
+            "test_id": 10,
+            "runtime": 5,
+            "output-format": "terse,json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            "test_obj": Test010,
+        },
+        {
+            # 50/50 r/w, aio
+            # enable only lat
+            "test_id": 11,
+            "runtime": 5,
+            "output-format": "terse,json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 0,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            "test_obj": Test011,
+        },
+        {
+            # randread, null
+            # enable slat, clat, lat
+            # only clat and lat will appear because
+            # because the null ioengine is syncrhonous
+            # same as Test 1 except
+            # numjobs = 4 to test sum_thread_stats() changes
+            "test_id": 12,
+            "runtime": 2,
+            "output-format": "json",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": 'null',
+            'rw': 'randread',
+            'numjobs': 4,
+            "test_obj": Test001,
+        },
+        {
+            # randread, aio
+            # enable slat, clat, lat
+            # all will appear because liaio is asynchronous
+            # same as Test 4 except
+            # numjobs = 4 to test sum_thread_stats() changes
+            "test_id": 13,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randread',
+            'numjobs': 4,
+            "test_obj": Test004,
+        },
+        {
+            # 50/50 r/w, aio, unified_rw_reporting
+            # enable slat, clat, lata
+            # same as Test 8 except
+            # numjobs = 4 to test sum_thread_stats() changes
+            "test_id": 14,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'unified_rw_reporting': 1,
+            'numjobs': 4,
+            "test_obj": Test008,
+        },
+        {
+            # randread, aio
+            # enable slat, clat, lat
+            # all will appear because liaio is asynchronous
+            # same as Test 4 except add cmdprio_percentage
+            "test_id": 15,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randread',
+            'cmdprio_percentage': 50,
+            "test_obj": Test015,
+        },
+        {
+            # randwrite, aio
+            # enable only clat, lat
+            # same as Test 5 except add cmdprio_percentage
+            "test_id": 16,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 0,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randwrite',
+            'cmdprio_percentage': 50,
+            "test_obj": Test016,
+        },
+        {
+            # randread, aio
+            # by default only clat should appear
+            # same as Test 6 except add cmdprio_percentage
+            "test_id": 17,
+            "runtime": 5,
+            "output-format": "json+",
+            "ioengine": aio,
+            'rw': 'randread',
+            'cmdprio_percentage': 50,
+            "test_obj": Test017,
+        },
+        {
+            # 50/50 r/w, aio
+            # enable only slat
+            # same as Test 7 except add cmdprio_percentage
+            "test_id": 18,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 0,
+            "lat_percentiles": 0,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'cmdprio_percentage': 50,
+            "test_obj": Test018,
+        },
+        {
+            # 50/50 r/w, aio, unified_rw_reporting
+            # enable slat, clat, lat
+            # same as Test 8 except add cmdprio_percentage
+            "test_id": 19,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'unified_rw_reporting': 1,
+            'cmdprio_percentage': 50,
+            "test_obj": Test019,
+        },
+        {
+            # 50/50 r/w, aio, unified_rw_reporting
+            # enable slat, clat, lat
+            # same as Test 19 except
+            # add numjobs = 4 to test sum_thread_stats() changes
+            "test_id": 20,
+            "runtime": 5,
+            "output-format": "json+",
+            "slat_percentiles": 1,
+            "clat_percentiles": 1,
+            "lat_percentiles": 1,
+            "ioengine": aio,
+            'rw': 'randrw',
+            'unified_rw_reporting': 1,
+            'cmdprio_percentage': 50,
+            'numjobs': 4,
+            "test_obj": Test019,
+        },
+    ]
+
+    passed = 0
+    failed = 0
+    skipped = 0
+
+    for test in test_list:
+        if (args.skip and test['test_id'] in args.skip) or \
+           (args.run_only and test['test_id'] not in args.run_only):
+            skipped = skipped + 1
+            outcome = 'SKIPPED (User request)'
+        elif platform.system() != 'Linux' and 'cmdprio_percentage' in test:
+            skipped = skipped + 1
+            outcome = 'SKIPPED (Linux required for cmdprio_percentage tests)'
+        else:
+            test_obj = test['test_obj'](artifact_root, test, args.debug)
+            status = test_obj.run_fio(fio)
+            if status:
+                status = test_obj.check()
+            if status:
+                passed = passed + 1
+                outcome = 'PASSED'
+            else:
+                failed = failed + 1
+                outcome = 'FAILED'
+
+        print("**********Test {0} {1}**********".format(test['test_id'], outcome))
+
+    print("{0} tests passed, {1} failed, {2} skipped".format(passed, failed, skipped))
+
+    sys.exit(failed)
+
+
+if __name__ == '__main__':
+    main()
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 3d236e37..003ff664 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -510,17 +510,17 @@ class Requirements(object):
 SUCCESS_DEFAULT = {
         'zero_return': True,
         'stderr_empty': True,
-        'timeout': 300,
+        'timeout': 600,
         }
 SUCCESS_NONZERO = {
         'zero_return': False,
         'stderr_empty': False,
-        'timeout': 300,
+        'timeout': 600,
         }
 SUCCESS_STDERR = {
         'zero_return': True,
         'stderr_empty': False,
-        'timeout': 300,
+        'timeout': 600,
         }
 TEST_LIST = [
         {
@@ -712,6 +712,14 @@ TEST_LIST = [
             'success':          SUCCESS_DEFAULT,
             'requirements':     [Requirements.unittests],
         },
+        {
+            'test_id':          1010,
+            'test_class':       FioExeTest,
+            'exe':              't/latency_percentiles.py',
+            'parameters':       ['-f', '{fio_path}'],
+            'success':          SUCCESS_DEFAULT,
+            'requirements':     [],
+        },
 ]
 
 
diff --git a/thread_options.h b/thread_options.h
index 4b131bda..c78ed43d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -250,6 +250,7 @@ struct thread_options {
 	unsigned int trim_zero;
 	unsigned long long trim_backlog;
 	unsigned int clat_percentiles;
+	unsigned int slat_percentiles;
 	unsigned int lat_percentiles;
 	unsigned int percentile_precision;	/* digits after decimal for percentiles */
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
@@ -370,7 +371,7 @@ struct thread_options_pack {
 	uint32_t iodepth_batch_complete_min;
 	uint32_t iodepth_batch_complete_max;
 	uint32_t serialize_overlap;
-	uint32_t lat_percentiles;
+	uint32_t pad;
 
 	uint64_t size;
 	uint64_t io_size;
@@ -430,7 +431,7 @@ struct thread_options_pack {
 	uint32_t override_sync;
 	uint32_t rand_repeatable;
 	uint32_t allrand_repeatable;
-	uint32_t pad;
+	uint32_t pad2;
 	uint64_t rand_seed;
 	uint32_t log_avg_msec;
 	uint32_t log_hist_msec;
@@ -464,7 +465,6 @@ struct thread_options_pack {
 
 	uint32_t hugepage_size;
 	uint64_t rw_min_bs;
-	uint32_t pad2;
 	uint32_t thinktime;
 	uint32_t thinktime_spin;
 	uint32_t thinktime_blocks;
@@ -539,7 +539,10 @@ struct thread_options_pack {
 	uint32_t trim_zero;
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
+	uint32_t lat_percentiles;
+	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad3;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -573,7 +576,6 @@ struct thread_options_pack {
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
 	uint32_t rate_process;
 	uint32_t rate_ign_think;
-	uint32_t pad3;
 
 	uint8_t ioscheduler[FIO_TOP_STR_MAX];
 
@@ -603,7 +605,6 @@ struct thread_options_pack {
 	uint32_t flow_sleep;
 
 	uint32_t offset_increment_percent;
-	uint32_t pad4;
 	uint64_t offset_increment;
 	uint64_t number_ios;
 

