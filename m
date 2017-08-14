Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 3/3] man: update description of normal output latencies
Date: Mon, 14 Aug 2017 14:59:44 -0400
Message-Id: <1502737184-25885-4-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
References: <1502737184-25885-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: vincentfu@gmail.com, Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

1) Describe lat (min, max, avg, stddev) line
2) Use IO latencies description for lat (nsec/usec/msec) lines
3) Fix IO latency description
---
 fio.1 | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fio.1 b/fio.1
index 74eae8a..31d0a3b 100644
--- a/fio.1
+++ b/fio.1
@@ -2793,9 +2793,9 @@ group) the output looks like:
 		     | 99.99th=[78119]
 		   bw (  KiB/s): min=  532, max=  686, per=0.10%, avg=622.87, stdev=24.82, samples=  100
 		   iops        : min=   76, max=   98, avg=88.98, stdev= 3.54, samples=  100
-		    lat (usec) : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
-		    lat (msec) : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
-		    lat (msec) : 100=0.65%
+		  lat (usec)   : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+		  lat (msec)   : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+		  lat (msec)   : 100=0.65%
 		  cpu          : usr=0.27%, sys=0.18%, ctx=12072, majf=0, minf=21
 		  IO depths    : 1=85.0%, 2=13.1%, 4=1.8%, 8=0.1%, 16=0.0%, 32=0.0%, >=64=0.0%
 		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
@@ -2836,6 +2836,10 @@ usually be equal (or very close) to 0, as the time from submit to
 complete is basically just CPU time (I/O has already been done, see slat
 explanation).
 .TP
+.B lat
+Total latency. Same names as slat and clat, this denotes the time from
+when fio created the I/O unit to completion of the I/O operation.
+.TP
 .B bw
 Bandwidth statistics based on samples. Same names as the xlat stats,
 but also includes the number of samples taken (\fIsamples\fR) and an
@@ -2847,6 +2851,14 @@ are then competing for disk access.
 .B iops
 IOPS statistics based on samples. Same names as \fBbw\fR.
 .TP
+.B lat (nsec/usec/msec)
+The distribution of I/O completion latencies. This is the time from when
+I/O leaves fio and when it gets completed. Unlike the separate
+read/write/trim sections above, the data here and in the remaining
+sections apply to all I/Os for the reporting group. 250=0.04% means that
+0.04% of the I/Os completed in under 250us. 500=64.11% means that 64.11%
+of the I/Os required 250 to 499us for completion.
+.TP
 .B cpu
 CPU usage. User and system time, along with the number of context
 switches this thread went through, usage of system and user time, and
@@ -2877,12 +2889,10 @@ Like the above \fBsubmit\fR number, but for completions instead.
 The number of \fBread/write/trim\fR requests issued, and how many of them were
 short or dropped.
 .TP
-.B IO latencies
-The distribution of I/O completion latencies. This is the time from when
-I/O leaves fio and when it gets completed. The numbers follow the same
-pattern as the I/O \fBdepths\fR, meaning that 2=1.6% means that 1.6% of the
-I/O completed within 2 msecs, 20=12.8% means that 12.8% of the I/O took
-more than 10 msecs, but less than (or equal to) 20 msecs.
+.B IO latency
+These values are for \fBlatency-target\fR and related options. When
+these options are engaged, this section describes the I/O depth required
+to meet the specified latency target.
 .RE
 .P
 After each client has been listed, the group statistics are printed. They
-- 
2.7.4


