Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdINMAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 14 Sep 2017 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dsSoO-0006kN-7H
        for fio@vger.kernel.org; Thu, 14 Sep 2017 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170914120002.2CC882C0128@kernel.dk>
Date: Thu, 14 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 956e60eade2bddb8aadfb54b58030e0b88fd03b2:

  io_u: fix trimming of mixed block size randommap (2017-09-12 14:02:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b599759ba565e7f2f573af364e6da4fe6d556a90:

  Add support for doing total latency percentiles (2017-09-13 22:07:31 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      time: ensure that offload mode switches parent out of ramp
      time: use bool for ramp time
      init: fixup_options() cleanup
      Add support for doing total latency percentiles

 HOWTO            | 10 +++++++++-
 cconv.c          |  2 ++
 client.c         |  3 ++-
 fio.1            |  8 +++++++-
 fio.h            |  2 +-
 gclient.c        |  6 +++++-
 init.c           | 35 +++++++++++++++++++++++++----------
 options.c        | 12 ++++++++++++
 server.c         |  3 ++-
 server.h         |  2 +-
 stat.c           | 22 ++++++++++++++--------
 stat.h           |  3 ++-
 thread_options.h |  3 ++-
 time.c           | 19 ++++++++++++++-----
 14 files changed, 98 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 2a70b7c..bfaa054 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2860,7 +2860,15 @@ Measurements and reporting
 
 .. option:: clat_percentiles=bool
 
-	Enable the reporting of percentiles of completion latencies.
+	Enable the reporting of percentiles of completion latencies.  This
+	option is mutually exclusive with :option:`lat_percentiles`.
+
+.. option:: lat_percentiles=bool
+
+	Enable the reporting of percentiles of IO latencies. This is similar
+	to :option:`clat_percentiles`, except that this includes the
+	submission latency. This option is mutually exclusive with
+	:option:`clat_percentiles`.
 
 .. option:: percentile_list=float_list
 
diff --git a/cconv.c b/cconv.c
index ac58705..f809fd5 100644
--- a/cconv.c
+++ b/cconv.c
@@ -267,6 +267,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->trim_batch = le32_to_cpu(top->trim_batch);
 	o->trim_zero = le32_to_cpu(top->trim_zero);
 	o->clat_percentiles = le32_to_cpu(top->clat_percentiles);
+	o->lat_percentiles = le32_to_cpu(top->lat_percentiles);
 	o->percentile_precision = le32_to_cpu(top->percentile_precision);
 	o->continue_on_error = le32_to_cpu(top->continue_on_error);
 	o->cgroup_weight = le32_to_cpu(top->cgroup_weight);
@@ -454,6 +455,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->trim_batch = cpu_to_le32(o->trim_batch);
 	top->trim_zero = cpu_to_le32(o->trim_zero);
 	top->clat_percentiles = cpu_to_le32(o->clat_percentiles);
+	top->lat_percentiles = cpu_to_le32(o->lat_percentiles);
 	top->percentile_precision = cpu_to_le32(o->percentile_precision);
 	top->continue_on_error = cpu_to_le32(o->continue_on_error);
 	top->cgroup_weight = cpu_to_le32(o->cgroup_weight);
diff --git a/client.c b/client.c
index 281d853..09e810a 100644
--- a/client.c
+++ b/client.c
@@ -893,7 +893,8 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->ctx		= le64_to_cpu(src->ctx);
 	dst->minf		= le64_to_cpu(src->minf);
 	dst->majf		= le64_to_cpu(src->majf);
-	dst->clat_percentiles	= le64_to_cpu(src->clat_percentiles);
+	dst->clat_percentiles	= le32_to_cpu(src->clat_percentiles);
+	dst->lat_percentiles	= le32_to_cpu(src->lat_percentiles);
 	dst->percentile_precision = le64_to_cpu(src->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
diff --git a/fio.1 b/fio.1
index 97133da..63e1c2e 100644
--- a/fio.1
+++ b/fio.1
@@ -2543,7 +2543,13 @@ Disable measurements of throughput/bandwidth numbers. See
 \fBdisable_lat\fR.
 .TP
 .BI clat_percentiles \fR=\fPbool
-Enable the reporting of percentiles of completion latencies.
+Enable the reporting of percentiles of completion latencies. This option is
+mutually exclusive with \fBlat_percentiles\fR.
+.TP
+.BI lat_percentiles \fR=\fPbool
+Enable the reporting of percentiles of IO latencies. This is similar to
+\fBclat_percentiles\fR, except that this includes the submission latency.
+This option is mutually exclusive with \fBclat_percentiles\fR.
 .TP
 .BI percentile_list \fR=\fPfloat_list
 Overwrite the default list of percentiles for completion latencies and the
diff --git a/fio.h b/fio.h
index da950ef..8814d84 100644
--- a/fio.h
+++ b/fio.h
@@ -335,7 +335,7 @@ struct thread_data {
 	struct timespec terminate_time;
 	unsigned int ts_cache_nr;
 	unsigned int ts_cache_mask;
-	unsigned int ramp_time_over;
+	bool ramp_time_over;
 
 	/*
 	 * Time since last latency_window was started
diff --git a/gclient.c b/gclient.c
index 4eb99a0..43c8a08 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1127,7 +1127,11 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 		base = "nsec";
         }
 
-	sprintf(tmp, "Completion percentiles (%s)", base);
+	if (ts->clat_percentiles)
+		sprintf(tmp, "Completion percentiles (%s)", base);
+	else
+		sprintf(tmp, "Latency percentiles (%s)", base);
+
 	tree_view = gfio_output_clat_percentiles(ovals, plist, len, base, scale_down);
 	ge->clat_graph = setup_clat_graph(tmp, ovals, plist, len, 700.0, 300.0);
 
diff --git a/init.c b/init.c
index cf5c646..6ac5212 100644
--- a/init.c
+++ b/init.c
@@ -837,7 +837,7 @@ static int fixup_options(struct thread_data *td)
 	 * Windows doesn't support O_DIRECT or O_SYNC with the _open interface,
 	 * so fail if we're passed those flags
 	 */
-	if (td_ioengine_flagged(td, FIO_SYNCIO) && (td->o.odirect || td->o.sync_io)) {
+	if (td_ioengine_flagged(td, FIO_SYNCIO) && (o->odirect || o->sync_io)) {
 		log_err("fio: Windows does not support direct or non-buffered io with"
 				" the synchronous ioengines. Use the 'windowsaio' ioengine"
 				" with 'direct=1' and 'iodepth=1' instead.\n");
@@ -863,8 +863,8 @@ static int fixup_options(struct thread_data *td)
 	 * Using a non-uniform random distribution excludes usage of
 	 * a random map
 	 */
-	if (td->o.random_distribution != FIO_RAND_DIST_RANDOM)
-		td->o.norandommap = 1;
+	if (o->random_distribution != FIO_RAND_DIST_RANDOM)
+		o->norandommap = 1;
 
 	/*
 	 * If size is set but less than the min block size, complain
@@ -878,16 +878,16 @@ static int fixup_options(struct thread_data *td)
 	/*
 	 * O_ATOMIC implies O_DIRECT
 	 */
-	if (td->o.oatomic)
-		td->o.odirect = 1;
+	if (o->oatomic)
+		o->odirect = 1;
 
 	/*
 	 * If randseed is set, that overrides randrepeat
 	 */
-	if (fio_option_is_set(&td->o, rand_seed))
-		td->o.rand_repeatable = 0;
+	if (fio_option_is_set(o, rand_seed))
+		o->rand_repeatable = 0;
 
-	if (td_ioengine_flagged(td, FIO_NOEXTEND) && td->o.file_append) {
+	if (td_ioengine_flagged(td, FIO_NOEXTEND) && o->file_append) {
 		log_err("fio: can't append/extent with IO engine %s\n", td->io_ops->name);
 		ret = 1;
 	}
@@ -902,10 +902,24 @@ static int fixup_options(struct thread_data *td)
 	if (!td->loops)
 		td->loops = 1;
 
-	if (td->o.block_error_hist && td->o.nr_files != 1) {
+	if (o->block_error_hist && o->nr_files != 1) {
 		log_err("fio: block error histogram only available "
 			"with a single file per job, but %d files "
-			"provided\n", td->o.nr_files);
+			"provided\n", o->nr_files);
+		ret = 1;
+	}
+
+	if (fio_option_is_set(o, clat_percentiles) &&
+	    !fio_option_is_set(o, lat_percentiles)) {
+		o->lat_percentiles = !o->clat_percentiles;
+	} else if (fio_option_is_set(o, lat_percentiles) &&
+		   !fio_option_is_set(o, clat_percentiles)) {
+		o->clat_percentiles = !o->lat_percentiles;
+	} else if (fio_option_is_set(o, lat_percentiles) &&
+		   fio_option_is_set(o, clat_percentiles) &&
+		   o->lat_percentiles && o->clat_percentiles) {
+		log_err("fio: lat_percentiles and clat_percentiles are "
+			"mutually exclusive\n");
 		ret = 1;
 	}
 
@@ -1401,6 +1415,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
 
 	td->ts.clat_percentiles = o->clat_percentiles;
+	td->ts.lat_percentiles = o->lat_percentiles;
 	td->ts.percentile_precision = o->percentile_precision;
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
 
diff --git a/options.c b/options.c
index 54fa4ee..5c1abe9 100644
--- a/options.c
+++ b/options.c
@@ -4076,6 +4076,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, clat_percentiles),
 		.help	= "Enable the reporting of completion latency percentiles",
 		.def	= "1",
+		.inverse = "lat_percentiles",
+		.category = FIO_OPT_C_STAT,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "lat_percentiles",
+		.lname	= "IO latency percentiles",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, lat_percentiles),
+		.help	= "Enable the reporting of IO latency percentiles",
+		.def	= "0",
+		.inverse = "clat_percentiles",
 		.category = FIO_OPT_C_STAT,
 		.group	= FIO_OPT_G_INVALID,
 	},
diff --git a/server.c b/server.c
index 2c08c3e..0469cea 100644
--- a/server.c
+++ b/server.c
@@ -1484,7 +1484,8 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.ctx		= cpu_to_le64(ts->ctx);
 	p.ts.minf		= cpu_to_le64(ts->minf);
 	p.ts.majf		= cpu_to_le64(ts->majf);
-	p.ts.clat_percentiles	= cpu_to_le64(ts->clat_percentiles);
+	p.ts.clat_percentiles	= cpu_to_le32(ts->clat_percentiles);
+	p.ts.lat_percentiles	= cpu_to_le32(ts->lat_percentiles);
 	p.ts.percentile_precision = cpu_to_le64(ts->percentile_precision);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++) {
diff --git a/server.h b/server.h
index f63a518..ba3abfe 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 65,
+	FIO_SERVER_VER			= 66,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 63353cc..9828d15 100644
--- a/stat.c
+++ b/stat.c
@@ -200,12 +200,13 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
  */
 static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 				  fio_fp64_t *plist, unsigned int precision,
-				  struct buf_output *out)
+				  bool is_clat, struct buf_output *out)
 {
 	unsigned int divisor, len, i, j = 0;
 	unsigned long long minv, maxv;
 	unsigned long long *ovals;
 	int is_last, per_line, scale_down, time_width;
+	const char *pre = is_clat ? "clat" : " lat";
 	char fmt[32];
 
 	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
@@ -219,15 +220,15 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 	if (minv > 2000000 && maxv > 99999999ULL) {
 		scale_down = 2;
 		divisor = 1000000;
-		log_buf(out, "    clat percentiles (msec):\n     |");
+		log_buf(out, "    %s percentiles (msec):\n     |", pre);
 	} else if (minv > 2000 && maxv > 99999) {
 		scale_down = 1;
 		divisor = 1000;
-		log_buf(out, "    clat percentiles (usec):\n     |");
+		log_buf(out, "    %s percentiles (usec):\n     |", pre);
 	} else {
 		scale_down = 0;
 		divisor = 1;
-		log_buf(out, "    clat percentiles (nsec):\n     |");
+		log_buf(out, "    %s percentiles (nsec):\n     |", pre);
 	}
 
 
@@ -457,11 +458,12 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
 		display_lat(" lat", min, max, mean, dev, out);
 
-	if (ts->clat_percentiles) {
+	if (ts->clat_percentiles || ts->lat_percentiles) {
 		show_clat_percentiles(ts->io_u_plat[ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list,
-					ts->percentile_precision, out);
+					ts->percentile_precision,
+					ts->clat_percentiles, out);
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
@@ -896,7 +898,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	else
 		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
-	if (ts->clat_percentiles) {
+	if (ts->clat_percentiles || ts->lat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
@@ -1011,7 +1013,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(tmp_object, "mean", mean);
 	json_object_add_value_float(tmp_object, "stddev", dev);
 
-	if (ts->clat_percentiles) {
+	if (ts->clat_percentiles || ts->lat_percentiles) {
 		len = calc_clat_percentiles(ts->io_u_plat[ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
@@ -1645,6 +1647,7 @@ void __show_run_stats(void)
 		ts = &threadstats[j];
 
 		ts->clat_percentiles = td->o.clat_percentiles;
+		ts->lat_percentiles = td->o.lat_percentiles;
 		ts->percentile_precision = td->o.percentile_precision;
 		memcpy(ts->percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
 		opt_lists[j] = &td->opt_list;
@@ -2437,6 +2440,9 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
 			       offset);
 
+	if (ts->lat_percentiles)
+		add_clat_percentile_sample(ts, nsec, ddir);
+
 	td_io_u_unlock(td);
 }
 
diff --git a/stat.h b/stat.h
index 132dee3..848331b 100644
--- a/stat.h
+++ b/stat.h
@@ -172,7 +172,8 @@ struct thread_stat {
 	/*
 	 * IO depth and latency stats
 	 */
-	uint64_t clat_percentiles;
+	uint32_t clat_percentiles;
+	uint32_t lat_percentiles;
 	uint64_t percentile_precision;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
diff --git a/thread_options.h b/thread_options.h
index fd6576e..1813cdc 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -240,6 +240,7 @@ struct thread_options {
 	unsigned int trim_zero;
 	unsigned long long trim_backlog;
 	unsigned int clat_percentiles;
+	unsigned int lat_percentiles;
 	unsigned int percentile_precision;	/* digits after decimal for percentiles */
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
@@ -343,7 +344,7 @@ struct thread_options_pack {
 	uint32_t iodepth_batch_complete_min;
 	uint32_t iodepth_batch_complete_max;
 	uint32_t serialize_overlap;
-	uint32_t pad3;
+	uint32_t lat_percentiles;
 
 	uint64_t size;
 	uint64_t io_size;
diff --git a/time.c b/time.c
index 0798419..c887682 100644
--- a/time.c
+++ b/time.c
@@ -97,16 +97,17 @@ bool in_ramp_time(struct thread_data *td)
 	return td->o.ramp_time && !td->ramp_time_over;
 }
 
-static void parent_update_ramp(struct thread_data *td)
+static bool parent_update_ramp(struct thread_data *td)
 {
 	struct thread_data *parent = td->parent;
 
 	if (!parent || parent->ramp_time_over)
-		return;
+		return false;
 
 	reset_all_stats(parent);
-	parent->ramp_time_over = 1;
+	parent->ramp_time_over = true;
 	td_set_runstate(parent, TD_RAMP);
+	return true;
 }
 
 bool ramp_time_over(struct thread_data *td)
@@ -115,10 +116,18 @@ bool ramp_time_over(struct thread_data *td)
 		return true;
 
 	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
-		td->ramp_time_over = 1;
+		td->ramp_time_over = true;
 		reset_all_stats(td);
 		td_set_runstate(td, TD_RAMP);
-		parent_update_ramp(td);
+
+		/*
+		 * If we have a parent, the parent isn't doing IO. Hence
+		 * the parent never enters do_io(), which will switch us
+		 * from RAMP -> RUNNING. Do this manually here.
+		 */
+		if (parent_update_ramp(td))
+			td_set_runstate(td, TD_RUNNING);
+
 		return true;
 	}
 
