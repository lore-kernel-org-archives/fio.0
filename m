Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:49251 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754075AbdFWW2I (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 18:28:08 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 1/4] stat: Print one-line iops stat
Date: Sat, 24 Jun 2017 00:27:35 +0200
Message-Id: <20170623222738.5146-2-aherrmann@suse.com>
In-Reply-To: <20170623222738.5146-1-aherrmann@suse.com>
References: <20170623222738.5146-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

This adds basic iops statistics (likewise to what we already have for
bandwidth) to normal and json fio output. Example for normal output:

   bw (  KiB/s): min=42192, max=162068, per=0.10%, avg=93236.21, stdev=22180.02
   iops : min=21090, max=81020, avg=46606.84, stdev=11088.40
    lat (usec) : 2=55.13%, 4=21.11%, 10=0.36%, 20=0.03%, 50=23.14%

Added handling for iops_stat to client/server and bump server version.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 client.c |  1 +
 init.c   |  1 +
 server.c |  1 +
 server.h |  2 +-
 stat.c   | 16 ++++++++++++++++
 5 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/client.c b/client.c
index 7a986aae..4da4a275 100644
--- a/client.c
+++ b/client.c
@@ -885,6 +885,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		convert_io_stat(&dst->slat_stat[i], &src->slat_stat[i]);
 		convert_io_stat(&dst->lat_stat[i], &src->lat_stat[i]);
 		convert_io_stat(&dst->bw_stat[i], &src->bw_stat[i]);
+		convert_io_stat(&dst->iops_stat[i], &src->iops_stat[i]);
 	}
 
 	dst->usr_time		= le64_to_cpu(src->usr_time);
diff --git a/init.c b/init.c
index 2b7768ab..b8e97f09 100644
--- a/init.c
+++ b/init.c
@@ -1364,6 +1364,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td->ts.slat_stat[i].min_val = ULONG_MAX;
 		td->ts.lat_stat[i].min_val = ULONG_MAX;
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
+		td->ts.iops_stat[i].min_val = ULONG_MAX;
 	}
 	td->ddir_seq_nr = o->ddir_seq_nr;
 
diff --git a/server.c b/server.c
index 8b36e383..e66a5f04 100644
--- a/server.c
+++ b/server.c
@@ -1474,6 +1474,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		convert_io_stat(&p.ts.slat_stat[i], &ts->slat_stat[i]);
 		convert_io_stat(&p.ts.lat_stat[i], &ts->lat_stat[i]);
 		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
+		convert_io_stat(&p.ts.iops_stat[i], &ts->iops_stat[i]);
 	}
 
 	p.ts.usr_time		= cpu_to_le64(ts->usr_time);
diff --git a/server.h b/server.h
index 7f235f3d..f63a5185 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 64,
+	FIO_SERVER_VER			= 65,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 50426509..d519ee9e 100644
--- a/stat.c
+++ b/stat.c
@@ -499,6 +499,10 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
 			bw_str, min, max, p_of_agg, mean, dev);
 	}
+	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
+			"stdev=%5.02f\n", min, max, mean, dev);
+	}
 }
 
 static int show_lat(double *io_u_lat, int nr, const char **ranges,
@@ -1047,6 +1051,15 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
 	json_object_add_value_float(dir_object, "bw_mean", mean);
 	json_object_add_value_float(dir_object, "bw_dev", dev);
+
+	if (!calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		min = max = 0;
+		mean = dev = 0.0;
+	}
+	json_object_add_value_int(dir_object, "iops_min", min);
+	json_object_add_value_int(dir_object, "iops_max", max);
+	json_object_add_value_float(dir_object, "iops_mean", mean);
+	json_object_add_value_float(dir_object, "iops_stddev", dev);
 }
 
 static void show_thread_status_terse_v2(struct thread_stat *ts,
@@ -1507,6 +1520,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
@@ -1517,6 +1531,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
@@ -1598,6 +1613,7 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->clat_stat[j].min_val = -1UL;
 		ts->slat_stat[j].min_val = -1UL;
 		ts->bw_stat[j].min_val = -1UL;
+		ts->iops_stat[j].min_val = -1UL;
 	}
 	ts->groupid = -1;
 }
-- 
2.12.0

