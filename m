Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbbKGNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 7 Nov 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Zv36C-0004uL-Ls
	for fio@vger.kernel.org; Sat, 07 Nov 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151107130002.17DAB2C00B0@kernel.dk>
Date: Sat,  7 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0e0484c51ff9bae3ea5bcdf2a97b614e5a1a6612:

  Fio 2.2.11 (2015-11-05 09:05:15 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 513e37eeb01a3037763124869dfcdd6152d92ab8:

  Add latency bin output to the json output format (2015-11-06 08:46:44 -0700)

----------------------------------------------------------------
Vincent Fu (1):
      Add latency bin output to the json output format

 README |  2 +-
 fio.1  |  6 ++++--
 fio.h  |  4 +++-
 init.c |  4 +++-
 stat.c | 14 +++++++++++++-
 5 files changed, 24 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 9d0863d..5fa37f3 100644
--- a/README
+++ b/README
@@ -151,7 +151,7 @@ $ fio
 	--runtime		Runtime in seconds
 	--bandwidth-log		Generate per-job bandwidth logs
 	--minimal		Minimal (terse) output
-	--output-format=type	Output format (terse,json,normal)
+	--output-format=type	Output format (terse,json,json+,normal)
 	--terse-version=type	Terse version output format (default 3, or 2 or 4).
 	--version		Print version info and exit
 	--help			Print this page
diff --git a/fio.1 b/fio.1
index 3bd3318..140c9bb 100644
--- a/fio.1
+++ b/fio.1
@@ -21,8 +21,10 @@ list all available tracing options.
 Write output to \fIfilename\fR.
 .TP
 .BI \-\-output-format \fR=\fPformat
-Set the reporting format to \fInormal\fR, \fIterse\fR, or \fIjson\fR.
-Multiple formats can be selected, separate by a comma.
+Set the reporting format to \fInormal\fR, \fIterse\fR, \fIjson\fR, or
+\fIjson+\fR. Multiple formats can be selected, separate by a comma. \fIterse\fR
+is a CSV based format. \fIjson+\fR is like \fIjson\fR, except it adds a full
+dump of the latency buckets.
 .TP
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
diff --git a/fio.h b/fio.h
index 8daf975..5e8ac66 100644
--- a/fio.h
+++ b/fio.h
@@ -677,11 +677,13 @@ enum {
 	__FIO_OUTPUT_TERSE	= 0,
 	__FIO_OUTPUT_JSON	= 1,
 	__FIO_OUTPUT_NORMAL	= 2,
-	FIO_OUTPUT_NR		= 3,
+        __FIO_OUTPUT_JSON_PLUS  = 3,
+	FIO_OUTPUT_NR		= 4,
 
 	FIO_OUTPUT_TERSE	= 1U << __FIO_OUTPUT_TERSE,
 	FIO_OUTPUT_JSON		= 1U << __FIO_OUTPUT_JSON,
 	FIO_OUTPUT_NORMAL	= 1U << __FIO_OUTPUT_NORMAL,
+	FIO_OUTPUT_JSON_PLUS    = 1U << __FIO_OUTPUT_JSON_PLUS,
 };
 
 enum {
diff --git a/init.c b/init.c
index 4f5b7dc..e09872f 100644
--- a/init.c
+++ b/init.c
@@ -1766,7 +1766,7 @@ static void usage(const char *name)
 	printf("  --runtime\t\tRuntime in seconds\n");
 	printf("  --bandwidth-log\tGenerate per-job bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
-	printf("  --output-format=x\tOutput format (terse,json,normal)\n");
+	printf("  --output-format=x\tOutput format (terse,json,json+,normal)\n");
 	printf("  --terse-version=x\tSet terse version output format to 'x'\n");
 	printf("  --version\t\tPrint version info and exit\n");
 	printf("  --help\t\tPrint this page\n");
@@ -2024,6 +2024,8 @@ static int parse_output_format(const char *optarg)
 			output_format |= FIO_OUTPUT_TERSE;
 		else if (!strcmp(opt, "json"))
 			output_format |= FIO_OUTPUT_JSON;
+		else if (!strcmp(opt, "json+"))
+			output_format |= (FIO_OUTPUT_JSON | FIO_OUTPUT_JSON_PLUS);
 		else if (!strcmp(opt, "normal"))
 			output_format |= FIO_OUTPUT_NORMAL;
 		else {
diff --git a/stat.c b/stat.c
index 091d6fb..6ee02d3 100644
--- a/stat.c
+++ b/stat.c
@@ -832,7 +832,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	unsigned int len, minv, maxv;
 	int i;
 	const char *ddirname[] = {"read", "write", "trim"};
-	struct json_object *dir_object, *tmp_object, *percentile_object;
+	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object;
 	char buf[120];
 	double p_of_agg = 100.0;
 
@@ -903,6 +903,18 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
 	}
 
+	if (output_format & FIO_OUTPUT_JSON_PLUS) {
+		clat_bins_object = json_create_object();
+		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
+			snprintf(buf, sizeof(buf), "%d", i);
+			json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+		}
+		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_BITS", FIO_IO_U_PLAT_BITS);
+		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_VAL", FIO_IO_U_PLAT_VAL);
+		json_object_add_value_int(clat_bins_object, "FIO_IO_U_PLAT_NR", FIO_IO_U_PLAT_NR);
+	}
+
 	if (!calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev)) {
 		min = max = 0;
 		mean = dev = 0.0;
