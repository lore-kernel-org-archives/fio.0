Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbbAGNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y8qDV-0006Wp-Au
	for fio@vger.kernel.org; Wed, 07 Jan 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150107130003.4F24840192@lyth.info>
Date: Wed,  7 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c7b0978381243f25a06464cdbf57bb55a1dbaa33:

  server: use fio_gettime() for timeout variables (2015-01-05 13:51:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 35326842297205554a9005723309bed565594c8a:

  Adjust ctime_r buf down to 32 (2015-01-06 12:03:09 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      gettime: include min/max cycle counts for CPU clock
      Adjust ctime_r buf down to 32

Steve ODriscoll (1):
      Add timestamp to json output

 gettime.c |   14 +++++++++++---
 stat.c    |   13 +++++++++++--
 2 files changed, 22 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index 5ceb809..72968c5 100644
--- a/gettime.c
+++ b/gettime.c
@@ -254,7 +254,7 @@ static unsigned long get_cycles_per_usec(void)
 static int calibrate_cpu_clock(void)
 {
 	double delta, mean, S;
-	uint64_t avg, cycles[NR_TIME_ITERS];
+	uint64_t minc, maxc, avg, cycles[NR_TIME_ITERS];
 	int i, samples;
 
 	cycles[0] = get_cycles_per_usec();
@@ -277,10 +277,14 @@ static int calibrate_cpu_clock(void)
 
 	S = sqrt(S / (NR_TIME_ITERS - 1.0));
 
-	samples = avg = 0;
+	minc = -1ULL;
+	maxc = samples = avg = 0;
 	for (i = 0; i < NR_TIME_ITERS; i++) {
 		double this = cycles[i];
 
+		minc = min(cycles[i], minc);
+		maxc = max(cycles[i], maxc);
+
 		if ((fmax(this, mean) - fmin(this, mean)) > S)
 			continue;
 		samples++;
@@ -296,8 +300,12 @@ static int calibrate_cpu_clock(void)
 
 	avg /= samples;
 	avg = (avg + 5) / 10;
+	minc /= 10;
+	maxc /= 10;
 	dprint(FD_TIME, "avg: %llu\n", (unsigned long long) avg);
-	dprint(FD_TIME, "mean=%f, S=%f\n", mean, S);
+	dprint(FD_TIME, "min=%llu, max=%llu, mean=%f, S=%f\n",
+			(unsigned long long) minc,
+			(unsigned long long) maxc, mean, S);
 
 	cycles_per_usec = avg;
 	inv_cycles_per_usec = 16777216UL / cycles_per_usec;
diff --git a/stat.c b/stat.c
index bae3338..db4a387 100644
--- a/stat.c
+++ b/stat.c
@@ -504,7 +504,7 @@ static void show_thread_status_normal(struct thread_stat *ts,
 	unsigned long runtime;
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	time_t time_p;
-	char time_buf[64];
+	char time_buf[32];
 
 	if (!ddir_rw_sum(ts->io_bytes) && !ddir_rw_sum(ts->total_io_u))
 		return;
@@ -1189,7 +1189,6 @@ void __show_run_stats(void)
 	int unit_base_warned = 0;
 	struct json_object *root = NULL;
 	struct json_array *array = NULL;
-
 	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
 
 	for (i = 0; i < groupid + 1; i++)
@@ -1351,8 +1350,18 @@ void __show_run_stats(void)
 	if (output_format == FIO_OUTPUT_NORMAL)
 		log_info("\n");
 	else if (output_format == FIO_OUTPUT_JSON) {
+		char time_buf[32];
+		time_t time_p;
+
+		time(&time_p);
+		os_ctime_r((const time_t *) &time_p, time_buf,
+				sizeof(time_buf));
+		time_buf[strlen(time_buf) - 1] = '\0';
+
 		root = json_create_object();
 		json_object_add_value_string(root, "fio version", fio_version_string);
+		json_object_add_value_int(root, "timestamp", time_p);
+		json_object_add_value_string(root, "time", time_buf);
 		array = json_create_array();
 		json_object_add_value_array(root, "jobs", array);
 	}
