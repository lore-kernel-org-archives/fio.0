Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49638 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdIOMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 15 Sep 2017 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dspI2-0002fV-9n
        for fio@vger.kernel.org; Fri, 15 Sep 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170915120002.6C3F12C0128@kernel.dk>
Date: Fri, 15 Sep 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b599759ba565e7f2f573af364e6da4fe6d556a90:

  Add support for doing total latency percentiles (2017-09-13 22:07:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9acb08a9957b1111a06fbca6af113fa0c98dbd7c:

  Merge branch 'doc-patches' of https://github.com/vincentkfu/fio (2017-09-14 11:37:34 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      stat: some bool conversions
      Merge branch 'doc-patches' of https://github.com/vincentkfu/fio

Vincent Fu (2):
      doc: provide more detail regarding the --status-interval option
      doc: provide some documentation for the json output format

 HOWTO  | 15 +++++++++++++--
 fio.1  | 12 ++++++++++--
 stat.c | 42 ++++++++++++++++++++++--------------------
 3 files changed, 45 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index bfaa054..8fad2ce 100644
--- a/HOWTO
+++ b/HOWTO
@@ -182,8 +182,10 @@ Command line options
 
 .. option:: --status-interval=time
 
-	Force full status dump every `time` period passed.  When the unit is
-	omitted, the value is interpreted in seconds.
+	Force a full status dump of cumulative (from job start) values at `time`
+	intervals. This option does *not* provide per-period measurements. So
+	values such as bandwidth are running averages. When the time unit is omitted,
+	`time` is interpreted in seconds.
 
 .. option:: --section=name
 
@@ -3389,6 +3391,15 @@ minimal output v3, separated by semicolons::
         terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_cla
 t_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
+JSON output
+------------
+
+The `json` output format is intended to be both human readable and convenient
+for automated parsing. For the most part its sections mirror those of the
+`normal` output. The `runtime` value is reported in msec and the `bw` value is
+reported in 1024 bytes per second units.
+
+
 JSON+ output
 ------------
 
diff --git a/fio.1 b/fio.1
index 63e1c2e..b943db2 100644
--- a/fio.1
+++ b/fio.1
@@ -84,8 +84,10 @@ Force a new line for every \fItime\fR period passed. When the unit is omitted,
 the value is interpreted in seconds.
 .TP
 .BI \-\-status\-interval \fR=\fPtime
-Force full status dump every \fItime\fR period passed. When the unit is omitted,
-the value is interpreted in seconds.
+Force a full status dump of cumulative (from job start) values at \fItime\fR
+intervals. This option does *not* provide per-period measurements. So
+values such as bandwidth are running averages. When the time unit is omitted,
+\fItime\fR is interpreted in seconds.
 .TP
 .BI \-\-section \fR=\fPname
 Only run specified section \fIname\fR in job file. Multiple sections can be specified.
@@ -3106,6 +3108,12 @@ minimal output v3, separated by semicolons:
 .nf
 		terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct1
 0;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 .fi
+.SH JSON OUTPUT
+The \fBjson\fR output format is intended to be both human readable and convenient
+for automated parsing. For the most part its sections mirror those of the
+\fBnormal\fR output. The \fBruntime\fR value is reported in msec and the \fBbw\fR value is
+reported in 1024 bytes per second units.
+.fi
 .SH JSON+ OUTPUT
 The \fBjson+\fR output format is identical to the \fBjson\fR output format except that it
 adds a full dump of the completion latency bins. Each \fBbins\fR object contains a
diff --git a/stat.c b/stat.c
index 9828d15..09afa5b 100644
--- a/stat.c
+++ b/stat.c
@@ -143,7 +143,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 	unsigned int len, i, j = 0;
 	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
-	int is_last;
+	bool is_last;
 
 	*minv = -1ULL;
 	*maxv = 0;
@@ -166,7 +166,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 	/*
 	 * Calculate bucket values, note down max and min values
 	 */
-	is_last = 0;
+	is_last = false;
 	for (i = 0; i < FIO_IO_U_PLAT_NR && !is_last; i++) {
 		sum += io_u_plat[i];
 		while (sum >= (plist[j].u.f / 100.0 * nr)) {
@@ -183,7 +183,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 			if (ovals[j] > *maxv)
 				*maxv = ovals[j];
 
-			is_last = (j == len - 1);
+			is_last = (j == len - 1) != 0;
 			if (is_last)
 				break;
 
@@ -205,8 +205,9 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 	unsigned int divisor, len, i, j = 0;
 	unsigned long long minv, maxv;
 	unsigned long long *ovals;
-	int is_last, per_line, scale_down, time_width;
+	int per_line, scale_down, time_width;
 	const char *pre = is_clat ? "clat" : " lat";
+	bool is_last;
 	char fmt[32];
 
 	len = calc_clat_percentiles(io_u_plat, nr, plist, &ovals, &maxv, &minv);
@@ -244,7 +245,7 @@ static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 			log_buf(out, "     |");
 
 		/* end of the list */
-		is_last = (j == len - 1);
+		is_last = (j == len - 1) != 0;
 
 		for (i = 0; i < scale_down; i++)
 			ovals[j] = (ovals[j] + 999) / 1000;
@@ -511,20 +512,21 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 }
 
-static int show_lat(double *io_u_lat, int nr, const char **ranges,
-		    const char *msg, struct buf_output *out)
+static bool show_lat(double *io_u_lat, int nr, const char **ranges,
+		     const char *msg, struct buf_output *out)
 {
-	int new_line = 1, i, line = 0, shown = 0;
+	bool new_line = true, shown = false;
+	int i, line = 0;
 
 	for (i = 0; i < nr; i++) {
 		if (io_u_lat[i] <= 0.0)
 			continue;
-		shown = 1;
+		shown = true;
 		if (new_line) {
 			if (line)
 				log_buf(out, "\n");
 			log_buf(out, "  lat (%s)   : ", msg);
-			new_line = 0;
+			new_line = false;
 			line = 0;
 		}
 		if (line)
@@ -532,13 +534,13 @@ static int show_lat(double *io_u_lat, int nr, const char **ranges,
 		log_buf(out, "%s%3.2f%%", ranges[i], io_u_lat[i]);
 		line++;
 		if (line == 5)
-			new_line = 1;
+			new_line = true;
 	}
 
 	if (shown)
 		log_buf(out, "\n");
 
-	return shown;
+	return true;
 }
 
 static void show_lat_n(double *io_u_lat_n, struct buf_output *out)
@@ -1590,8 +1592,8 @@ void __show_run_stats(void)
 	struct thread_data *td;
 	struct thread_stat *threadstats, *ts;
 	int i, j, k, nr_ts, last_ts, idx;
-	int kb_base_warned = 0;
-	int unit_base_warned = 0;
+	bool kb_base_warned = false;
+	bool unit_base_warned = false;
 	struct json_object *root = NULL;
 	struct json_array *array = NULL;
 	struct buf_output output[FIO_OUTPUT_NR];
@@ -1684,11 +1686,11 @@ void __show_run_stats(void)
 		} else if (ts->kb_base != td->o.kb_base && !kb_base_warned) {
 			log_info("fio: kb_base differs for jobs in group, using"
 				 " %u as the base\n", ts->kb_base);
-			kb_base_warned = 1;
+			kb_base_warned = true;
 		} else if (ts->unit_base != td->o.unit_base && !unit_base_warned) {
 			log_info("fio: unit_base differs for jobs in group, using"
 				 " %u as the base\n", ts->unit_base);
-			unit_base_warned = 1;
+			unit_base_warned = true;
 		}
 
 		ts->continue_on_error = td->o.continue_on_error;
@@ -1932,9 +1934,9 @@ void __show_running_run_stats(void)
 	fio_mutex_up(stat_mutex);
 }
 
-static int status_interval_init;
+static bool status_interval_init;
 static struct timespec status_time;
-static int status_file_disabled;
+static bool status_file_disabled;
 
 #define FIO_STATUS_FILE		"fio-dump-status"
 
@@ -1965,7 +1967,7 @@ static int check_status_file(void)
 		log_err("fio: failed to unlink %s: %s\n", fio_status_file_path,
 							strerror(errno));
 		log_err("fio: disabling status file updates\n");
-		status_file_disabled = 1;
+		status_file_disabled = true;
 	}
 
 	return 1;
@@ -1976,7 +1978,7 @@ void check_for_running_stats(void)
 	if (status_interval) {
 		if (!status_interval_init) {
 			fio_gettime(&status_time, NULL);
-			status_interval_init = 1;
+			status_interval_init = true;
 		} else if (mtime_since_now(&status_time) >= status_interval) {
 			show_running_run_stats();
 			fio_gettime(&status_time, NULL);
