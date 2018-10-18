Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] fio: reset more counters when ramp time has elapsed
Date: Thu, 18 Oct 2018 16:15:41 -0400
Message-Id: <20181018201541.4970-1-vincentfu@gmail.com>
To: axboe@kernel.dk, vincentfu@gmail.com, fio@vger.kernel.org
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
 libfio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/libfio.c b/libfio.c
index 674bc1dc..7490a4c9 100644
--- a/libfio.c
+++ b/libfio.c
@@ -133,6 +133,7 @@ void reset_all_stats(struct thread_data *td)
 	int i;
 
 	reset_io_counters(td, 1);
+	reset_io_stats(td);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		td->io_bytes[i] = 0;
-- 
2.17.1


