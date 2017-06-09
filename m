Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:46736 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbdFIPvN (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 9 Jun 2017 11:51:13 -0400
Date: Fri, 9 Jun 2017 17:50:55 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 1/2] stat: Print one-line iops stat
Message-ID: <20170609155055.GB11503@suselix.suse.de>
References: <20170609154716.GA11503@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170609154716.GA11503@suselix.suse.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org


This adds basic iops statistics (likewise to what we already have for
bandwidth) in normal fio output, e.g.:

   bw (  KiB/s): min=42192, max=162068, per=0.10%, avg=93236.21, stdev=22180.02
   iops : min=21090, max=81020, avg=46606.84, stdev=11088.40
    lat (usec) : 2=55.13%, 4=21.11%, 10=0.36%, 20=0.03%, 50=23.14%

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 init.c   | 1 +
 server.c | 1 +
 stat.c   | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/init.c b/init.c
index 2b7768a..b8e97f0 100644
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
index 8a5e75d..ff0800c 100644
--- a/server.c
+++ b/server.c
@@ -1474,6 +1474,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		convert_io_stat(&p.ts.slat_stat[i], &ts->slat_stat[i]);
 		convert_io_stat(&p.ts.lat_stat[i], &ts->lat_stat[i]);
 		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
+		convert_io_stat(&p.ts.iops_stat[i], &ts->iops_stat[i]);
 	}
 
 	p.ts.usr_time		= cpu_to_le64(ts->usr_time);
diff --git a/stat.c b/stat.c
index fd3ad5a..1e23681 100644
--- a/stat.c
+++ b/stat.c
@@ -470,6 +470,10 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
 			bw_str, min, max, p_of_agg, mean, dev);
 	}
+	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
+		log_buf(out, "   iops : min=%5lu, max=%5lu, avg=%5.02f, stdev=%5.02f\n",
+			min, max, mean, dev);
+	}
 }
 
 static int show_lat(double *io_u_lat, int nr, const char **ranges,
@@ -1458,6 +1462,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
@@ -1468,6 +1473,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first);
 			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first);
 			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first);
+			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
@@ -1547,6 +1553,7 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->clat_stat[j].min_val = -1UL;
 		ts->slat_stat[j].min_val = -1UL;
 		ts->bw_stat[j].min_val = -1UL;
+		ts->iops_stat[j].min_val = -1UL;
 	}
 	ts->groupid = -1;
 }
-- 
2.7.4

