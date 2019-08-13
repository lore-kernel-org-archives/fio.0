Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43239 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfHMCBz (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Aug 2019 22:01:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so41608830pld.10
        for <fio@vger.kernel.org>; Mon, 12 Aug 2019 19:01:55 -0700 (PDT)
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/5] Revert "eta: Fix compiler warning"
Date: Mon, 12 Aug 2019 19:01:35 -0700
Message-Id: <20190813020136.15798-5-bvanassche@acm.org>
In-Reply-To: <20190813020136.15798-1-bvanassche@acm.org>
References: <20190813020136.15798-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>

This reverts commit df0ca15ce2ffac0df3e9dcf4bfe4121333c4aa27. Due to
the previous patch it is no longer necessary to confuse the compiler
about accesses of the 'rate' and 'iops' members in struct jobs_eta.

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 eta.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/eta.c b/eta.c
index 99c537d189a3..77c3dd5f0453 100644
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
2.22.0


