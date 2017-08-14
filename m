Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 2/3] HOWTO: update and clarify description of latencies in normal output
Date: Mon, 14 Aug 2017 14:59:43 -0400
Message-Id: <1502737184-25885-3-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
References: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: vincentfu@gmail.com, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

1) Add a description for the lat (min, max, avg, stddev) line
2) Use the old 'IO latencies' description for the lat (nsec/usec/msec) section
3) Fix the description of the 'IO latency' section
---
 HOWTO | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index 57d4a39..6ecc0a6 100644
--- a/HOWTO
+++ b/HOWTO
@@ -3133,9 +3133,9 @@ group) the output looks like::
 	     | 99.99th=[78119]
 	   bw (  KiB/s): min=  532, max=  686, per=0.10%, avg=622.87, stdev=24.82, samples=  100
 	   iops        : min=   76, max=   98, avg=88.98, stdev= 3.54, samples=  100
-	    lat (usec) : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
-	    lat (msec) : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
-	    lat (msec) : 100=0.65%
+	  lat (usec)   : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+	  lat (msec)   : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+	  lat (msec)   : 100=0.65%
 	  cpu          : usr=0.27%, sys=0.18%, ctx=12072, majf=0, minf=21
 	  IO depths    : 1=85.0%, 2=13.1%, 4=1.8%, 8=0.1%, 16=0.0%, 32=0.0%, >=64=0.0%
 	     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
@@ -3174,6 +3174,10 @@ writes in the example above).  In the order listed, they denote:
 		complete is basically just CPU time (I/O has already been done, see slat
 		explanation).
 
+**lat**
+		Total latency. Same names as slat and clat, this denotes the time from
+		when fio created the I/O unit to completion of the I/O operation.
+
 **bw**
 		Bandwidth statistics based on samples. Same names as the xlat stats,
 		but also includes the number of samples taken (**samples**) and an
@@ -3185,6 +3189,14 @@ writes in the example above).  In the order listed, they denote:
 **iops**
 		IOPS statistics based on samples. Same names as bw.
 
+**lat (nsec/usec/msec)**
+		The distribution of I/O completion latencies. This is the time from when
+		I/O leaves fio and when it gets completed. Unlike the separate
+		read/write/trim sections above, the data here and in the remaining
+		sections apply to all I/Os for the reporting group. 250=0.04% means that
+		0.04% of the I/Os completed in under 250us. 500=64.11% means that 64.11%
+		of the I/Os required 250 to 499us for completion.
+
 **cpu**
 		CPU usage. User and system time, along with the number of context
 		switches this thread went through, usage of system and user time, and
@@ -3215,12 +3227,10 @@ writes in the example above).  In the order listed, they denote:
 		The number of read/write/trim requests issued, and how many of them were
 		short or dropped.
 
-**IO latencies**
-		The distribution of I/O completion latencies. This is the time from when
-		I/O leaves fio and when it gets completed.  The numbers follow the same
-		pattern as the I/O depths, meaning that 2=1.6% means that 1.6% of the
-		I/O completed within 2 msecs, 20=12.8% means that 12.8% of the I/O took
-		more than 10 msecs, but less than (or equal to) 20 msecs.
+**IO latency**
+		These values are for `--latency-target` and related options. When
+		these options are engaged, this section describes the I/O depth required
+		to meet the specified latency target.
 
 ..
 	Example output was based on the following:
-- 
2.7.4


