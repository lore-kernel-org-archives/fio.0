Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v2 1/1] fio: reset more counters when ramp time has elapsed
Date: Thu, 18 Oct 2018 16:42:54 -0400
Message-Id: <20181018204254.5350-2-vincentfu@gmail.com>
In-Reply-To: <20181018204254.5350-1-vincentfu@gmail.com>
References: <20181018204254.5350-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org, vincentfu@gmail.com
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Currently,

fio --name=test --ramp_time=2 --time_based=1 --runtime=2s --size=1M

will produce an output line like

  IO depths    : 1=184.7%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

184.7% appears because the denominator used in the IO depth calculation
is reset at the conclusion of ramp_time but the numerator is not.
Latency and other IO depth statistics also include data from IOs
completed during ramp time. This patch resets these counters when ramp
time is over.
---
 time.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/time.c b/time.c
index c8876829..19999699 100644
--- a/time.c
+++ b/time.c
@@ -118,6 +118,7 @@ bool ramp_time_over(struct thread_data *td)
 	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
 		td->ramp_time_over = true;
 		reset_all_stats(td);
+		reset_io_stats(td);
 		td_set_runstate(td, TD_RAMP);
 
 		/*
-- 
2.17.1


