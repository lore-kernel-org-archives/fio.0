Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34124 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbeAYNAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Jan 2018 08:00:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eeh8T-0007IM-QB
        for fio@vger.kernel.org; Thu, 25 Jan 2018 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180125130002.463D02C0116@kernel.dk>
Date: Thu, 25 Jan 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ca65714c48bcd4fc601e3c04163e2422352be9ca:

  null: drop unneeded casts from void* to non-void* (2018-01-16 08:32:39 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ea93f982e728343f823c2cf63b4674a104575bf:

  Switch last_was_sync and terminate to bool and pack better (2018-01-24 20:22:50 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Add suppor for logging fsync (and friends) latencies
      Switch last_was_sync and terminate to bool and pack better

 fio.h    |   4 +-
 io_u.c   |  18 +++++--
 libfio.c |   4 +-
 server.h |   2 +-
 stat.c   | 175 ++++++++++++++++++++++++++++++++++++++++++---------------------
 stat.h   |   4 ++
 6 files changed, 140 insertions(+), 67 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index 334f203..85546c5 100644
--- a/fio.h
+++ b/fio.h
@@ -228,9 +228,9 @@ struct thread_data {
 	pid_t pid;
 	char *orig_buffer;
 	size_t orig_buffer_size;
-	volatile int terminate;
 	volatile int runstate;
-	unsigned int last_was_sync;
+	volatile bool terminate;
+	bool last_was_sync;
 	enum fio_ddir last_ddir;
 
 	int mmapfd;
diff --git a/io_u.c b/io_u.c
index 1d6872e..404c75b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1921,7 +1921,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 		if (no_reduce && per_unit_log(td->iops_log))
 			add_iops_sample(td, io_u, bytes);
-	}
+	} else if (ddir_sync(idx) && !td->o.disable_clat)
+		add_sync_clat_sample(&td->ts, llnsec);
 
 	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
 		uint32_t *info = io_u_block_info(td, io_u);
@@ -1959,6 +1960,12 @@ static void file_log_write_comp(const struct thread_data *td, struct fio_file *f
 		f->last_write_idx = 0;
 }
 
+static bool should_account(struct thread_data *td)
+{
+	return ramp_time_over(td) && (td->runstate == TD_RUNNING ||
+					   td->runstate == TD_VERIFYING);
+}
+
 static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			 struct io_completion_data *icd)
 {
@@ -1987,15 +1994,17 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	}
 
 	if (ddir_sync(ddir)) {
-		td->last_was_sync = 1;
+		td->last_was_sync = true;
 		if (f) {
 			f->first_write = -1ULL;
 			f->last_write = -1ULL;
 		}
+		if (should_account(td))
+			account_io_completion(td, io_u, icd, ddir, io_u->buflen);
 		return;
 	}
 
-	td->last_was_sync = 0;
+	td->last_was_sync = false;
 	td->last_ddir = ddir;
 
 	if (!io_u->error && ddir_rw(ddir)) {
@@ -2013,8 +2022,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		if (ddir == DDIR_WRITE)
 			file_log_write_comp(td, f, io_u->offset, bytes);
 
-		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
-					   td->runstate == TD_VERIFYING))
+		if (should_account(td))
 			account_io_completion(td, io_u, icd, ddir, bytes);
 
 		icd->bytes_done[ddir] += bytes;
diff --git a/libfio.c b/libfio.c
index 74de735..80159b4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -98,7 +98,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 
 	td->zone_bytes = 0;
 
-	td->last_was_sync = 0;
+	td->last_was_sync = false;
 	td->rwmix_issues = 0;
 
 	/*
@@ -230,7 +230,7 @@ void fio_mark_td_terminate(struct thread_data *td)
 {
 	fio_gettime(&td->terminate_time, NULL);
 	write_barrier();
-	td->terminate = 1;
+	td->terminate = true;
 }
 
 void fio_terminate_threads(unsigned int group_id)
diff --git a/server.h b/server.h
index 1a9b650..cabd447 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 69,
+	FIO_SERVER_VER			= 70,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 80f804a..3a014d6 100644
--- a/stat.c
+++ b/stat.c
@@ -200,18 +200,17 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long n
  */
 static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
 				  fio_fp64_t *plist, unsigned int precision,
-				  bool is_clat, struct buf_output *out)
+				  const char *pre, struct buf_output *out)
 {
 	unsigned int divisor, len, i, j = 0;
 	unsigned long long minv, maxv;
 	unsigned long long *ovals;
 	int per_line, scale_down, time_width;
-	const char *pre = is_clat ? "clat" : " lat";
 	bool is_last;
 	char fmt[32];
 
 	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
-	if (!len)
+	if (!len || !ovals)
 		goto out;
 
 	/*
@@ -419,13 +418,26 @@ static void display_lat(const char *name, unsigned long long min,
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
-	const char *str[] = { " read", "write", " trim" };
+	const char *str[] = { " read", "write", " trim", "sync" };
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
 	char *io_p, *bw_p, *bw_p_alt, *iops_p;
 	int i2p;
 
+	if (ddir_sync(ddir)) {
+		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
+			log_buf(out, "  %s:\n", "fsync/fdatasync/sync_file_range");
+			display_lat(str[ddir], min, max, mean, dev, out);
+			show_clat_percentiles(ts->io_u_sync_plat,
+						ts->sync_stat.samples,
+						ts->percentile_list,
+						ts->percentile_precision,
+						str[ddir], out);
+		}
+		return;
+	}
+
 	assert(ddir_rw(ddir));
 
 	if (!ts->runtime[ddir])
@@ -460,6 +472,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		display_lat(" lat", min, max, mean, dev, out);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
+		const char *name = ts->clat_percentiles ? "clat" : " lat";
 		uint64_t samples;
 
 		if (ts->clat_percentiles)
@@ -470,8 +483,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		show_clat_percentiles(ts->io_u_plat[ddir],
 					samples,
 					ts->percentile_list,
-					ts->percentile_precision,
-					ts->clat_percentiles, out);
+					ts->percentile_precision, name, out);
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
@@ -803,6 +815,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 	show_latencies(ts, out);
 
+	if (ts->sync_stat.samples)
+		show_ddir_status(rs, ts, DDIR_SYNC, out);
+
 	runtime = ts->total_run_time;
 	if (runtime) {
 		double runt = (double) runtime;
@@ -968,12 +983,12 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	double mean, dev, iops;
 	unsigned int len;
 	int i;
-	const char *ddirname[] = {"read", "write", "trim"};
+	const char *ddirname[] = { "read", "write", "trim", "sync" };
 	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object = NULL;
 	char buf[120];
 	double p_of_agg = 100.0;
 
-	assert(ddir_rw(ddir));
+	assert(ddir_rw(ddir) || ddir_sync(ddir));
 
 	if (ts->unified_rw_rep && ddir != DDIR_READ)
 		return;
@@ -982,54 +997,76 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_object(parent,
 		ts->unified_rw_rep ? "mixed" : ddirname[ddir], dir_object);
 
-	bw_bytes = 0;
-	bw = 0;
-	iops = 0.0;
-	if (ts->runtime[ddir]) {
-		uint64_t runt = ts->runtime[ddir];
+	if (ddir_rw(ddir)) {
+		bw_bytes = 0;
+		bw = 0;
+		iops = 0.0;
+		if (ts->runtime[ddir]) {
+			uint64_t runt = ts->runtime[ddir];
 
-		bw_bytes = ((1000 * ts->io_bytes[ddir]) / runt); /* Bytes/s */
-		bw = bw_bytes / 1024; /* KiB/s */
-		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
-	}
+			bw_bytes = ((1000 * ts->io_bytes[ddir]) / runt); /* Bytes/s */
+			bw = bw_bytes / 1024; /* KiB/s */
+			iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
+		}
 
-	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir]);
-	json_object_add_value_int(dir_object, "io_kbytes", ts->io_bytes[ddir] >> 10);
-	json_object_add_value_int(dir_object, "bw_bytes", bw_bytes);
-	json_object_add_value_int(dir_object, "bw", bw);
-	json_object_add_value_float(dir_object, "iops", iops);
-	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
-	json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
-	json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
-	json_object_add_value_int(dir_object, "drop_ios", ts->drop_io_u[ddir]);
+		json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir]);
+		json_object_add_value_int(dir_object, "io_kbytes", ts->io_bytes[ddir] >> 10);
+		json_object_add_value_int(dir_object, "bw_bytes", bw_bytes);
+		json_object_add_value_int(dir_object, "bw", bw);
+		json_object_add_value_float(dir_object, "iops", iops);
+		json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
+		json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
+		json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
+		json_object_add_value_int(dir_object, "drop_ios", ts->drop_io_u[ddir]);
+
+		if (!calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev)) {
+			min = max = 0;
+			mean = dev = 0.0;
+		}
+		tmp_object = json_create_object();
+		json_object_add_value_object(dir_object, "slat_ns", tmp_object);
+		json_object_add_value_int(tmp_object, "min", min);
+		json_object_add_value_int(tmp_object, "max", max);
+		json_object_add_value_float(tmp_object, "mean", mean);
+		json_object_add_value_float(tmp_object, "stddev", dev);
+
+		if (!calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev)) {
+			min = max = 0;
+			mean = dev = 0.0;
+		}
+		tmp_object = json_create_object();
+		json_object_add_value_object(dir_object, "clat_ns", tmp_object);
+		json_object_add_value_int(tmp_object, "min", min);
+		json_object_add_value_int(tmp_object, "max", max);
+		json_object_add_value_float(tmp_object, "mean", mean);
+		json_object_add_value_float(tmp_object, "stddev", dev);
+	} else {
+		if (!calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
+			min = max = 0;
+			mean = dev = 0.0;
+		}
 
-	if (!calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev)) {
-		min = max = 0;
-		mean = dev = 0.0;
+		tmp_object = json_create_object();
+		json_object_add_value_object(dir_object, "lat_ns", tmp_object);
+		json_object_add_value_int(tmp_object, "min", min);
+		json_object_add_value_int(tmp_object, "max", max);
+		json_object_add_value_float(tmp_object, "mean", mean);
+		json_object_add_value_float(tmp_object, "stddev", dev);
 	}
-	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "slat_ns", tmp_object);
-	json_object_add_value_int(tmp_object, "min", min);
-	json_object_add_value_int(tmp_object, "max", max);
-	json_object_add_value_float(tmp_object, "mean", mean);
-	json_object_add_value_float(tmp_object, "stddev", dev);
-
-	if (!calc_lat(&ts->clat_stat[ddir], &min, &max, &mean, &dev)) {
-		min = max = 0;
-		mean = dev = 0.0;
-	}
-	tmp_object = json_create_object();
-	json_object_add_value_object(dir_object, "clat_ns", tmp_object);
-	json_object_add_value_int(tmp_object, "min", min);
-	json_object_add_value_int(tmp_object, "max", max);
-	json_object_add_value_float(tmp_object, "mean", mean);
-	json_object_add_value_float(tmp_object, "stddev", dev);
 
 	if (ts->clat_percentiles || ts->lat_percentiles) {
-		len = calc_clat_percentiles(ts->io_u_plat[ddir],
+		if (ddir_rw(ddir)) {
+			len = calc_clat_percentiles(ts->io_u_plat[ddir],
 					ts->clat_stat[ddir].samples,
 					ts->percentile_list, &ovals, &maxv,
 					&minv);
+		} else {
+			len = calc_clat_percentiles(ts->io_u_sync_plat,
+					ts->sync_stat.samples,
+					ts->percentile_list, &ovals, &maxv,
+					&minv);
+		}
+
 		if (len > FIO_IO_U_LIST_MAX_LEN)
 			len = FIO_IO_U_LIST_MAX_LEN;
 	} else
@@ -1048,13 +1085,23 @@ static void add_ddir_status_json(struct thread_stat *ts,
 			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
-			if (ts->io_u_plat[ddir][i]) {
-				snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
-				json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+			if (ddir_rw(ddir)) {
+				if (ts->io_u_plat[ddir][i]) {
+					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
+					json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+				}
+			} else {
+				if (ts->io_u_sync_plat[i]) {
+					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
+					json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_sync_plat[i]);
+				}
 			}
 		}
 	}
 
+	if (!ddir_rw(ddir))
+		return;
+
 	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {
 		min = max = 0;
 		mean = dev = 0.0;
@@ -1233,6 +1280,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
 	add_ddir_status_json(ts, rs, DDIR_TRIM, root);
+	add_ddir_status_json(ts, rs, DDIR_SYNC, root);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -1529,24 +1577,25 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		}
 	}
 
+	sum_stat(&dst->sync_stat, &src->sync_stat, first);
 	dst->usr_time += src->usr_time;
 	dst->sys_time += src->sys_time;
 	dst->ctx += src->ctx;
 	dst->majf += src->majf;
 	dst->minf += src->minf;
 
-	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
+	for (k = 0; k < FIO_IO_U_MAP_NR; k++) {
 		dst->io_u_map[k] += src->io_u_map[k];
-	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
 		dst->io_u_submit[k] += src->io_u_submit[k];
-	for (k = 0; k < FIO_IO_U_MAP_NR; k++)
 		dst->io_u_complete[k] += src->io_u_complete[k];
-	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++)
+	}
+	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++) {
 		dst->io_u_lat_n[k] += src->io_u_lat_n[k];
-	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++)
 		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
-	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
+	}
+	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
+		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
 
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		if (!dst->unified_rw_rep) {
@@ -2231,8 +2280,11 @@ void reset_io_stats(struct thread_data *td)
 		ts->short_io_u[i] = 0;
 		ts->drop_io_u[i] = 0;
 
-		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
 			ts->io_u_plat[i][j] = 0;
+			if (!i)
+				ts->io_u_sync_plat[j] = 0;
+		}
 	}
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
@@ -2357,6 +2409,15 @@ void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned int
 	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0);
 }
 
+void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
+{
+	unsigned int idx = plat_val_to_idx(nsec);
+	assert(idx < FIO_IO_U_PLAT_NR);
+
+	ts->io_u_sync_plat[idx]++;
+	add_stat_sample(&ts->sync_stat, nsec);
+}
+
 static void add_clat_percentile_sample(struct thread_stat *ts,
 				unsigned long long nsec, enum fio_ddir ddir)
 {
diff --git a/stat.h b/stat.h
index ba66c40..e32a21e 100644
--- a/stat.h
+++ b/stat.h
@@ -162,6 +162,7 @@ struct thread_stat {
 	struct io_stat clat_stat[DDIR_RWDIR_CNT]; /* completion latency */
 	struct io_stat slat_stat[DDIR_RWDIR_CNT]; /* submission latency */
 	struct io_stat lat_stat[DDIR_RWDIR_CNT]; /* total latency */
+	struct io_stat sync_stat;		/* fsync etc stats */
 	struct io_stat bw_stat[DDIR_RWDIR_CNT]; /* bandwidth stats */
 	struct io_stat iops_stat[DDIR_RWDIR_CNT]; /* IOPS stats */
 
@@ -188,6 +189,7 @@ struct thread_stat {
 	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint32_t io_u_sync_plat[FIO_IO_U_PLAT_NR];
 	uint32_t pad;
 
 	uint64_t total_io_u[DDIR_RWDIR_CNT];
@@ -318,6 +320,8 @@ extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
 				unsigned int, unsigned long long);
+extern void add_sync_clat_sample(struct thread_stat *ts,
+					unsigned long long nsec);
 extern int calc_log_samples(void);
 
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
