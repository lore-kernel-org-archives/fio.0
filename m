Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:38480 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754663AbdFWRng (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 23 Jun 2017 13:43:36 -0400
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 2/4] stat: Print number of samples in bw and iops stats
Date: Fri, 23 Jun 2017 19:42:58 +0200
Message-Id: <20170623174300.7937-3-aherrmann@suse.com>
In-Reply-To: <20170623174300.7937-1-aherrmann@suse.com>
References: <20170623174300.7937-1-aherrmann@suse.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

This adds the actual number of samples for bw and iops stats printed
in normal and json fio output. Example for normal output:

   bw (  MiB/s): min=  120, max= 3304, per=0.10%, avg=2659.34, stdev=1085.25, samples=  109
   iops        : min=102776, max=830416, avg=675639.05, stdev=280619.99, samples=   21

Note: This example was created using options
"--write_bw_log=... --log_avg_msec=100 --runtime=11s" (ie. no iops log
written). That is why number of samples differs for IOPs and BW.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 stat.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/stat.c b/stat.c
index d519ee9e..369f9696 100644
--- a/stat.c
+++ b/stat.c
@@ -496,12 +496,15 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
-			bw_str, min, max, p_of_agg, mean, dev);
+		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
+			"avg=%5.02f, stdev=%5.02f, samples=%5lu\n",
+			bw_str, min, max, p_of_agg, mean, dev,
+			(&ts->bw_stat[ddir])->samples);
 	}
 	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
 		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
-			"stdev=%5.02f\n", min, max, mean, dev);
+			"stdev=%5.02f, samples=%5lu\n",
+			min, max, mean, dev, (&ts->iops_stat[ddir])->samples);
 	}
 }
 
@@ -1051,6 +1054,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
 	json_object_add_value_float(dir_object, "bw_mean", mean);
 	json_object_add_value_float(dir_object, "bw_dev", dev);
+	json_object_add_value_int(dir_object, "bw_samples",
+				(&ts->bw_stat[ddir])->samples);
 
 	if (!calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
 		min = max = 0;
@@ -1060,6 +1065,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(dir_object, "iops_max", max);
 	json_object_add_value_float(dir_object, "iops_mean", mean);
 	json_object_add_value_float(dir_object, "iops_stddev", dev);
+	json_object_add_value_int(dir_object, "iops_samples",
+				(&ts->iops_stat[ddir])->samples);
 }
 
 static void show_thread_status_terse_v2(struct thread_stat *ts,
-- 
2.12.0

