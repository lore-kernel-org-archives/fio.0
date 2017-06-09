Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:44798 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdFIPxN (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Fri, 9 Jun 2017 11:53:13 -0400
Date: Fri, 9 Jun 2017 17:52:40 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH 2/2] stat: Print number of samples in bw and iops stats
Message-ID: <20170609155240.GC11503@suselix.suse.de>
References: <20170609154716.GA11503@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20170609154716.GA11503@suselix.suse.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org


This adds the actual number of samples used for calculation of bw and
iops stats in normal fio output, e.g.

   bw (  MiB/s): min=  120, max= 3304, per=0.10%, avg=2659.34, stdev=1085.25, samples=  109
   iops        : min=102776, max=830416, avg=675639.05, stdev=280619.99, samples=   21

Note: This example was created using options
"--write_bw_log=... --log_avg_msec=100 --runtime=11s" (ie. no iops log
written). That is why number of samples differs for iops and bw.

Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
---
 stat.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/stat.c b/stat.c
index 1e23681..aa9c8ce 100644
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
 
-- 
2.7.4

