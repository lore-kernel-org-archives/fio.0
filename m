Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 6/7] Restore type checking in calc_thread_status()
Date: Wed, 14 Aug 2019 13:10:11 -0700
Message-Id: <20190814201012.253060-7-bvanassche@acm.org>
In-Reply-To: <20190814201012.253060-1-bvanassche@acm.org>
References: <20190814201012.253060-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

Due to a previous patch it is no longer necessary to hide the type of
accesses to the 'rate' and 'iops' members in struct jobs_eta.

This patch reverts commit df0ca15ce2ff ("eta: Fix compiler warning").

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 eta.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/eta.c b/eta.c
index 5900bc0fd919..286b45ee3837 100644
--- a/eta.c
+++ b/eta.c
@@ -392,9 +392,6 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
 	static struct timespec rate_prev_time, disp_prev_time;
 
-	void *je_rate = (void *) je->rate;
-	void *je_iops = (void *) je->iops;
-
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
@@ -510,7 +507,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
-				je_rate);
+				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
 		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
@@ -522,8 +519,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && !eta_time_within_slack(disp_time))
 		return false;
 
-	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je_rate);
-	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je_iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
-- 
2.22.0.rc1


