Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:54891 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdFWW2J (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 18:28:09 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 4/4] stat: Add iops stat and sample number information to terse format
Date: Sat, 24 Jun 2017 00:27:38 +0200
Message-Id: <20170623222738.5146-5-aherrmann@suse.com>
In-Reply-To: <20170623222738.5146-1-aherrmann@suse.com>
References: <20170623222738.5146-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

This is inserted beyond bandwidth information. It required creation
of a new terse version (v5).

Updated man page and HOWTO accordingly. Also added hints when fields
are specific to certain terse versions.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 HOWTO  | 19 +++++++++++++------
 fio.1  | 26 ++++++++++++++++++++------
 init.c |  3 +--
 stat.c | 30 ++++++++++++++++++++++--------
 4 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/HOWTO b/HOWTO
index 22c5a5b8..b2db69dc 100644
--- a/HOWTO
+++ b/HOWTO
@@ -127,7 +127,7 @@ Command line options
 
 .. option:: --terse-version=type
 
-	Set terse version output format (default 3, or 2 or 4).
+	Set terse version output format (default 3, or 2 or 4 or 5).
 
 .. option:: --version
 
@@ -3168,11 +3168,12 @@ first value is the version of the terse output format. If the output has to be
 changed for some reason, this number will be incremented by 1 to signify that
 change.
 
-Split up, the format is as follows:
+Split up, the format is as follows (comments in brackets denote when a
+field was introduced or whether its specific to some terse version):
 
     ::
 
-        terse version, fio version, jobname, groupid, error
+	terse version, fio version [v3], jobname, groupid, error
 
     READ status::
 
@@ -3181,7 +3182,8 @@ Split up, the format is as follows:
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
+	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+	IOPS [v5]: min, max, mean, stdev, number of samples
 
     WRITE status:
 
@@ -3192,7 +3194,12 @@ Split up, the format is as follows:
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
+	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+	IOPS [v5]: min, max, mean, stdev, number of samples
+
+    TRIM status [all but version 3]:
+
+	Fields are similar to READ/WRITE status.
 
     CPU usage::
 
@@ -3210,7 +3217,7 @@ Split up, the format is as follows:
 
         <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, 2000, >=2000
 
-    Disk utilization::
+    Disk utilization [v3]::
 
         Disk name, Read ios, write ios,
         Read merges, write merges,
diff --git a/fio.1 b/fio.1
index 96eceafb..6a6ea1b2 100644
--- a/fio.1
+++ b/fio.1
@@ -43,7 +43,7 @@ Deprecated, use \-\-output-format instead to select multiple formats.
 Display version information and exit.
 .TP
 .BI \-\-terse\-version \fR=\fPversion
-Set terse version output format (default 3, or 2 or 4)
+Set terse version output format (default 3, or 2, 4, 5)
 .TP
 .B \-\-help
 Display usage information and exit.
@@ -2161,10 +2161,11 @@ scripted use.
 A job description (if provided) follows on a new line.  Note that the first
 number in the line is the version number. If the output has to be changed
 for some reason, this number will be incremented by 1 to signify that
-change.  The fields are:
+change. Numbers in brackets (e.g. "[v3]") indicate which terse version
+introduced a field. The fields are:
 .P
 .RS
-.B terse version, fio version, jobname, groupid, error
+.B terse version, fio version [v3], jobname, groupid, error
 .P
 Read status:
 .RS
@@ -2188,7 +2189,11 @@ Total latency:
 .RE
 Bandwidth:
 .RS
-.B min, max, aggregate percentage of total, mean, standard deviation
+.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
+.RE
+IOPS [v5]:
+.RS
+.B min, max, mean, standard deviation, number of samples
 .RE
 .RE
 .P
@@ -2214,10 +2219,19 @@ Total latency:
 .RE
 Bandwidth:
 .RS
-.B min, max, aggregate percentage of total, mean, standard deviation
+.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
+.RE
+IOPS [v5]:
+.RS
+.B min, max, mean, standard deviation, number of samples
 .RE
 .RE
 .P
+Trim status [all but version 3]:
+.RS
+Similar to Read/Write status but for trims.
+.RE
+.P
 CPU usage:
 .RS
 .B user, system, context switches, major page faults, minor page faults
@@ -2240,7 +2254,7 @@ Milliseconds:
 .RE
 .RE
 .P
-Disk utilization (1 for each disk used):
+Disk utilization (1 for each disk used) [v3]:
 .RS
 .B name, read ios, write ios, read merges, write merges, read ticks, write ticks, read in-queue time, write in-queue time, disk utilization percentage
 .RE
diff --git a/init.c b/init.c
index b8e97f09..2cf47d31 100644
--- a/init.c
+++ b/init.c
@@ -2404,8 +2404,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 		case 'V':
 			terse_version = atoi(optarg);
-			if (!(terse_version == 2 || terse_version == 3 ||
-			     terse_version == 4)) {
+			if (!(terse_version >= 2 && terse_version <= 5)) {
 				log_err("fio: bad terse version format\n");
 				exit_val = 1;
 				do_exit++;
diff --git a/stat.c b/stat.c
index 1201c35c..b3b2cb35 100644
--- a/stat.c
+++ b/stat.c
@@ -863,13 +863,13 @@ static void show_thread_status_normal(struct thread_stat *ts,
 
 static void show_ddir_status_terse(struct thread_stat *ts,
 				   struct group_run_stats *rs, int ddir,
-				   struct buf_output *out)
+				   int ver, struct buf_output *out)
 {
 	unsigned long long min, max, minv, maxv, bw, iops;
 	unsigned long long *ovals = NULL;
 	double mean, dev;
 	unsigned int len;
-	int i;
+	int i, bw_stat;
 
 	assert(ddir_rw(ddir));
 
@@ -919,7 +919,8 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	if (ovals)
 		free(ovals);
 
-	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
+	bw_stat = calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev);
+	if (bw_stat) {
 		double p_of_agg = 100.0;
 
 		if (rs->agg[ddir]) {
@@ -931,6 +932,19 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", min, max, p_of_agg, mean, dev);
 	} else
 		log_buf(out, ";%llu;%llu;%f%%;%f;%f", 0ULL, 0ULL, 0.0, 0.0, 0.0);
+
+	if (ver == 5) {
+		if (bw_stat)
+			log_buf(out, ";%lu", (&ts->bw_stat[ddir])->samples);
+		else
+			log_buf(out, ";%lu", 0UL);
+
+		if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev))
+			log_buf(out, ";%llu;%llu;%f;%f;%lu", min, max,
+				mean, dev, (&ts->iops_stat[ddir])->samples);
+		else
+			log_buf(out, ";%llu;%llu;%f;%f;%lu", 0ULL, 0ULL, 0.0, 0.0, 0UL);
+	}
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
@@ -1087,12 +1101,12 @@ static void show_thread_status_terse_all(struct thread_stat *ts,
 			ts->name, ts->groupid, ts->error);
 
 	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ, out);
+	show_ddir_status_terse(ts, rs, DDIR_READ, ver, out);
 	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
+	show_ddir_status_terse(ts, rs, DDIR_WRITE, ver, out);
 	/* Log Trim Status */
-	if (ver == 2 || ver == 4)
-		show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
+	if (ver == 2 || ver == 4 || ver == 5)
+		show_ddir_status_terse(ts, rs, DDIR_TRIM, ver, out);
 
 	/* CPU Usage */
 	if (ts->total_run_time) {
@@ -1376,7 +1390,7 @@ static void show_thread_status_terse(struct thread_stat *ts,
 				     struct group_run_stats *rs,
 				     struct buf_output *out)
 {
-	if (terse_version >= 2 && terse_version <= 4)
+	if (terse_version >= 2 && terse_version <= 5)
 		show_thread_status_terse_all(ts, rs, terse_version, out);
 	else
 		log_err("fio: bad terse version!? %d\n", terse_version);
-- 
2.12.0

