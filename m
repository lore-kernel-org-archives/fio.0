Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62141 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2BGC6v (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Feb 2012 21:58:51 -0500
Received: by qcqw6 with SMTP id w6so3805001qcq.19
        for <fio@vger.kernel.org>; Mon, 06 Feb 2012 18:58:50 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Mon, 6 Feb 2012 18:58:30 -0800
Message-ID: <CAAUT-yMQ5MpMCT0JBvSgeD73aTfyNuekATtJ4XsPjka5_ZX_1w@mail.gmail.com>
Subject: [PATCH] Enable completion latency stat collection on verify
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

A patch last year
(http://git.kernel.dk/?p=fio.git;a=commit;f=io_u.c;h=c8eeb9df1f52f28567a5937e141decc6a26ec30b)
changed the behavior of verify loads so they stopped printing
completion latency stats.  (A verify load in this case includes both
rw=*write with verify and do_verify=1 and rw=*read with verify.)

Is there any particular reason that an io_u which is going to be
verified shouldn't have its latency statistics recorded?

This patch re-enables the clat recording.

An example demonstrating the issue here:

$ ./fio --name=test --size=1m --bs=4k --verify=meta --rw=write
test: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 2.0.2
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1MB)

test: (groupid=0, jobs=1): err= 0: pid=27535
  read : io=1024.0KB, bw=1000.0MB/s, iops=256000 , runt=     1msec
    clat percentiles (usec):
     |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
     | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
     | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
     | 99.00th=[    0], 99.50th=[    0], 99.90th=[    0]
  write: io=1024.0KB, bw=341333KB/s, iops=85333 , runt=     3msec
    clat (usec): min=2 , max=13 , avg= 3.30, stdev= 0.78
     lat (usec): min=2 , max=14 , avg= 3.52, stdev= 0.84
    clat percentiles (usec):
     |  1.00th=[    2],  5.00th=[    3], 10.00th=[    3], 20.00th=[    3],
     | 30.00th=[    3], 40.00th=[    3], 50.00th=[    3], 60.00th=[    3],
     | 70.00th=[    3], 80.00th=[    4], 90.00th=[    4], 95.00th=[    4],
     | 99.00th=[    4], 99.50th=[    4], 99.90th=[   13]
    lat (usec) : 4=35.55%, 10=14.26%, 20=0.20%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=46
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=256/w=256/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=1024KB, aggrb=1000.0MB/s, minb=1024.0MB/s,
maxb=1024.0MB/s, mint=1msec, maxt=1msec
  WRITE: io=1024KB, aggrb=341333KB/s, minb=349525KB/s,
maxb=349525KB/s, mint=3msec, maxt=3msec

Note that no clat line is reported for reads and no clat percentiles
are listed.  If a read-only load is then executed, it has the same
thing.

$ ./fio --name=test --size=1m --bs=4k --verify=meta --rw=read
test: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 2.0.2
Starting 1 process

test: (groupid=0, jobs=1): err= 0: pid=31694
  read : io=1024.0KB, bw=13653KB/s, iops=3413 , runt=    75msec
    clat percentiles (usec):
     |  1.00th=[    0],  5.00th=[    0], 10.00th=[    0], 20.00th=[    0],
     | 30.00th=[    0], 40.00th=[    0], 50.00th=[    0], 60.00th=[    0],
     | 70.00th=[    0], 80.00th=[    0], 90.00th=[    0], 95.00th=[    0],
     | 99.00th=[    0], 99.50th=[    0], 99.90th=[    0]
  cpu          : usr=0.00%, sys=0.00%, ctx=15, majf=0, minf=36
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=256/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=1024KB, aggrb=13653KB/s, minb=13981KB/s, maxb=13981KB/s,
mint=75msec, maxt=75msec


---
diff --git a/io_u.c b/io_u.c
index 54f8685..6ceca45 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1369,7 +1369,8 @@ static void io_completed(struct thread_data *td,
struct io_u *io_u,
 			}
 		}

-		if (ramp_time_over(td) && td->runstate == TD_RUNNING) {
+		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
+					   td->runstate == TD_VERIFYING)) {
 			account_io_completion(td, io_u, icd, idx, bytes);

 			if (__should_check_rate(td, idx)) {
---
