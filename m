Return-Path: <prvs=051d3e551=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] eta: Fix compiler warning
Date: Tue,  4 Jun 2019 16:07:32 +0900
Message-Id: <20190604070732.17952-2-damien.lemoal@wdc.com>
In-Reply-To: <20190604070732.17952-1-damien.lemoal@wdc.com>
References: <20190604070732.17952-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

gcc 9 complains about directly referencing pointer values in the packed
structure jobs_eta. E.g.:

warning: taking address of packed member of ‘struct jobs_eta’ may
result in an unaligned pointer value [-Waddress-of-packed-member]

Remove this by using a local void pointer for the rate and iops array
references that generate the warning.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 eta.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/eta.c b/eta.c
index b69dd194..647a1bdd 100644
--- a/eta.c
+++ b/eta.c
@@ -392,6 +392,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	static unsigned long long disp_io_iops[DDIR_RWDIR_CNT];
 	static struct timespec rate_prev_time, disp_prev_time;
 
+	void *je_rate = (void *) je->rate;
+	void *je_iops = (void *) je->iops;
+
 	if (!force) {
 		if (!(output_format & FIO_OUTPUT_NORMAL) &&
 		    f_out == stdout)
@@ -507,7 +510,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
-				je->rate);
+				je_rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
 		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
 		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
@@ -519,8 +522,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!force && !eta_time_within_slack(disp_time))
 		return false;
 
-	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
-	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
+	calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je_rate);
+	calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je_iops);
 
 	memcpy(&disp_prev_time, &now, sizeof(now));
 
-- 
2.21.0


