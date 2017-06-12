Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:43249 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932162AbdFLPwt (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Mon, 12 Jun 2017 11:52:49 -0400
Date: Mon, 12 Jun 2017 17:52:11 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v2 2/2] stat: Print number of samples in bw and iops
 statistics
Message-ID: <20170612155211.GJ15590@suselix.suse.de>
References: <20170612154853.GH15590@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170612154853.GH15590@suselix.suse.de>
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
 stat.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/stat.c b/stat.c
index f39014e..b809129 100644
--- a/stat.c
+++ b/stat.c
@@ -467,12 +467,15 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
-			bw_str, min, max, p_of_agg, mean, dev);
+		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, "
+			"avg=%5.02f, stdev=%5.02f, samples=%5lu\n",
+			bw_str, min, max, p_of_agg, mean, dev,
+			(&ts->bw_stat[ddir])->samples);
 	}
 	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
-		log_buf(out, "   iops : min=%5lu, max=%5lu, avg=%5.02f, stdev=%5.02f\n",
-			min, max, mean, dev);
+		log_buf(out, "   iops        : min=%5lu, max=%5lu, "
+			"avg=%5.02f, stdev=%5.02f, samples=%5lu\n",
+			min, max, mean, dev, (&ts->iops_stat[ddir])->samples);
 	}
 }
 
@@ -1012,6 +1015,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(dir_object, "bw_agg", p_of_agg);
 	json_object_add_value_float(dir_object, "bw_mean", mean);
 	json_object_add_value_float(dir_object, "bw_dev", dev);
+	json_object_add_value_int(dir_object, "bw_samples",
+				(&ts->bw_stat[ddir])->samples);
 
 	if (!calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
 		min = max = 0;
@@ -1021,6 +1026,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_int(dir_object, "iops_max", max);
 	json_object_add_value_float(dir_object, "iops_mean", mean);
 	json_object_add_value_float(dir_object, "iops_stddev", dev);
+	json_object_add_value_int(dir_object, "iops_samples",
+				(&ts->iops_stat[ddir])->samples);
 }
 
 static void show_thread_status_terse_v2(struct thread_stat *ts,
-- 
2.7.4

