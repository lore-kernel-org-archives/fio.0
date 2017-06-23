Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:49216 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754654AbdFWRng (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 13:43:36 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 3/4] stat: Merge show_thread_status_terse_* functions
Date: Fri, 23 Jun 2017 19:42:59 +0200
Message-Id: <20170623174300.7937-4-aherrmann@suse.com>
In-Reply-To: <20170623174300.7937-1-aherrmann@suse.com>
References: <20170623174300.7937-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

Merge show_thread_status_terse_v2 and show_thread_status_terse_v3_v4
into new function show_thread_status_terse_all.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 stat.c | 88 ++++++++++++------------------------------------------------------
 1 file changed, 15 insertions(+), 73 deletions(-)

diff --git a/stat.c b/stat.c
index 369f9696..1201c35c 100644
--- a/stat.c
+++ b/stat.c
@@ -1069,9 +1069,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 				(&ts->iops_stat[ddir])->samples);
 }
 
-static void show_thread_status_terse_v2(struct thread_stat *ts,
-					struct group_run_stats *rs,
-					struct buf_output *out)
+static void show_thread_status_terse_all(struct thread_stat *ts,
+					 struct group_run_stats *rs, int ver,
+					 struct buf_output *out)
 {
 	double io_u_dist[FIO_IO_U_MAP_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
@@ -1080,77 +1080,18 @@ static void show_thread_status_terse_v2(struct thread_stat *ts,
 	int i;
 
 	/* General Info */
-	log_buf(out, "2;%s;%d;%d", ts->name, ts->groupid, ts->error);
-	/* Log Read Status */
-	show_ddir_status_terse(ts, rs, DDIR_READ, out);
-	/* Log Write Status */
-	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
-	/* Log Trim Status */
-	show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
-
-	/* CPU Usage */
-	if (ts->total_run_time) {
-		double runt = (double) ts->total_run_time;
-
-		usr_cpu = (double) ts->usr_time * 100 / runt;
-		sys_cpu = (double) ts->sys_time * 100 / runt;
-	} else {
-		usr_cpu = 0;
-		sys_cpu = 0;
-	}
-
-	log_buf(out, ";%f%%;%f%%;%llu;%llu;%llu", usr_cpu, sys_cpu,
-						(unsigned long long) ts->ctx,
-						(unsigned long long) ts->majf,
-						(unsigned long long) ts->minf);
-
-	/* Calc % distribution of IO depths, usecond, msecond latency */
-	stat_calc_dist(ts->io_u_map, ddir_rw_sum(ts->total_io_u), io_u_dist);
-	stat_calc_lat_nu(ts, io_u_lat_u);
-	stat_calc_lat_m(ts, io_u_lat_m);
-
-	/* Only show fixed 7 I/O depth levels*/
-	log_buf(out, ";%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%;%3.1f%%",
-			io_u_dist[0], io_u_dist[1], io_u_dist[2], io_u_dist[3],
-			io_u_dist[4], io_u_dist[5], io_u_dist[6]);
-
-	/* Microsecond latency */
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		log_buf(out, ";%3.2f%%", io_u_lat_u[i]);
-	/* Millisecond latency */
-	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
-	/* Additional output if continue_on_error set - default off*/
-	if (ts->continue_on_error)
-		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
-	log_buf(out, "\n");
-
-	/* Additional output if description is set */
-	if (strlen(ts->description))
-		log_buf(out, ";%s", ts->description);
-
-	log_buf(out, "\n");
-}
-
-static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
-					   struct group_run_stats *rs, int ver,
-					   struct buf_output *out)
-{
-	double io_u_dist[FIO_IO_U_MAP_NR];
-	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
-	double io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	double usr_cpu, sys_cpu;
-	int i;
+	if (ver == 2)
+		log_buf(out, "2;%s;%d;%d", ts->name, ts->groupid, ts->error);
+	else
+		log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
+			ts->name, ts->groupid, ts->error);
 
-	/* General Info */
-	log_buf(out, "%d;%s;%s;%d;%d", ver, fio_version_string,
-					ts->name, ts->groupid, ts->error);
 	/* Log Read Status */
 	show_ddir_status_terse(ts, rs, DDIR_READ, out);
 	/* Log Write Status */
 	show_ddir_status_terse(ts, rs, DDIR_WRITE, out);
 	/* Log Trim Status */
-	if (ver == 4)
+	if (ver == 2 || ver == 4)
 		show_ddir_status_terse(ts, rs, DDIR_TRIM, out);
 
 	/* CPU Usage */
@@ -1187,11 +1128,14 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 		log_buf(out, ";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	show_disk_util(1, NULL, out);
+	if (ver >= 3)
+		show_disk_util(1, NULL, out);
 
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
 		log_buf(out, ";%llu;%d", (unsigned long long) ts->total_err_count, ts->first_error);
+	if (ver == 2)
+		log_buf(out, "\n");
 
 	/* Additional output if description is set */
 	if (strlen(ts->description))
@@ -1432,10 +1376,8 @@ static void show_thread_status_terse(struct thread_stat *ts,
 				     struct group_run_stats *rs,
 				     struct buf_output *out)
 {
-	if (terse_version == 2)
-		show_thread_status_terse_v2(ts, rs, out);
-	else if (terse_version == 3 || terse_version == 4)
-		show_thread_status_terse_v3_v4(ts, rs, terse_version, out);
+	if (terse_version >= 2 && terse_version <= 4)
+		show_thread_status_terse_all(ts, rs, terse_version, out);
 	else
 		log_err("fio: bad terse version!? %d\n", terse_version);
 }
-- 
2.12.0

