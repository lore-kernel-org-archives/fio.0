Return-Path: <axboe@kernel.dk>
Subject: Re: fio and total latency percentile
From: Jens Axboe <axboe@kernel.dk>
References: <53cbc635-d9a3-6ef3-3634-309db0fe03d5@intel.com>
 <0c340072-33cc-2171-c149-1ef0b8f94fce@kernel.dk>
Message-ID: <2fea8192-2373-a27e-c484-07fe5854aab7@kernel.dk>
Date: Wed, 13 Sep 2017 22:03:00 -0600
MIME-Version: 1.0
In-Reply-To: <0c340072-33cc-2171-c149-1ef0b8f94fce@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dave Jiang <dave.jiang@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
List-ID: <fio@vger.kernel.org>

On 09/13/2017 04:59 PM, Jens Axboe wrote:
> On 09/07/2017 01:59 PM, Dave Jiang wrote:
>> Jens,
>> fio can display completion latency percentages via the percentile_list
>> parameter. I can get p90 and p99 numbers for clat via
>> percentile_list=90:99. Is there a way to get the overall latency for
>> percentile? I'm interested in the total latency measurements for p90 and
>> p99 while doing some measurements on the persistent memory block driver
>> and playing around using DMA engines for transfer.
> 
> If I understand correctly, you are using an IO engine that is async, and
> you want the latency percentiles to reflect total IO time
> (submission+completion), not just completion time?
> 
> We can't currently do that, but it'd be trivial to do with an option of
> some sort. Currently the percentile enable option is clat_percentile,
> and it defaults to on. We could have a lat_percentile option that, if
> enabled, would change the reporting to being total IO time. IOW:
> 
> clat_percentile=1	Latency percentiles are completion latencies
> lat_percentile=1	Latency percentiles are total IO time
> 
> and have them be mutually exclusive.

Something like the below. Please try it out and see if it works for you.


diff --git a/HOWTO b/HOWTO
index 2a70b7c629b6..bfaa054a5de0 100644
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
index ac58705dabf4..f809fd519752 100644
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
index 281d853f14a7..09e810afc612 100644
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
index 97133dacbb84..63e1c2e585bd 100644
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
diff --git a/init.c b/init.c
index 834c868e33f0..6ac5212916b5 100644
--- a/init.c
+++ b/init.c
@@ -909,6 +909,20 @@ static int fixup_options(struct thread_data *td)
 		ret = 1;
 	}
 
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
+		ret = 1;
+	}
+
 	return ret;
 }
 
@@ -1401,6 +1415,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	td->mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
 
 	td->ts.clat_percentiles = o->clat_percentiles;
+	td->ts.lat_percentiles = o->lat_percentiles;
 	td->ts.percentile_precision = o->percentile_precision;
 	memcpy(td->ts.percentile_list, o->percentile_list, sizeof(o->percentile_list));
 
diff --git a/options.c b/options.c
index 54fa4eef7ac5..5c1abe91817d 100644
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
index 2c08c3e12b26..0469cea7221f 100644
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
index f63a5185d2a0..ba3abfeb3228 100644
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
index 63353cc0cd2b..9828d153de8f 100644
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
index 132dee3cd876..848331bb5e47 100644
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
index fd6576e252c7..1813cdc706a8 100644
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

-- 
Jens Axboe


