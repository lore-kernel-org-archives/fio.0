Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:35210 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754209AbdFWRnh (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 13:43:37 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 4/4] stat: Add iops stat and sample number information to terse format
Date: Fri, 23 Jun 2017 19:43:00 +0200
Message-Id: <20170623174300.7937-5-aherrmann@suse.com>
In-Reply-To: <20170623174300.7937-1-aherrmann@suse.com>
References: <20170623174300.7937-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

This is inserted beyond bandwidth information. It required creation
of a new terse version (v5).

Updated man page and HOWTO accordingly.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 HOWTO  |  2 +-
 fio.1  |  2 +-
 init.c |  3 +--
 stat.c | 28 +++++++++++++++++++++-------
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/HOWTO b/HOWTO
index 22c5a5b8..1fd96efe 100644
--- a/HOWTO
+++ b/HOWTO
@@ -127,7 +127,7 @@ Command line options
 
 .. option:: --terse-version=type
 
-	Set terse version output format (default 3, or 2 or 4).
+	Set terse version output format (default 3, or 2 or 4 or 5).
 
 .. option:: --version
 
diff --git a/fio.1 b/fio.1
index 96eceafb..7fe175ee 100644
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
index 1201c35c..c8a1f8d8 100644
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
 	if (ver == 2 || ver == 4)
-		show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
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

