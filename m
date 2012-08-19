Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59535 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2HSMjv (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 19 Aug 2012 08:39:51 -0400
Received: by bkwj10 with SMTP id j10so1651094bkw.19
        for <fio@vger.kernel.org>; Sun, 19 Aug 2012 05:39:49 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 19 Aug 2012 22:39:49 +1000
Message-ID: <CAHaS=Qz0FBWFh1o4avw5wTapGFTO8-argLW38mrdXHWLJ0-Ygg@mail.gmail.com>
Subject: Rate problems (Windows)
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm finding that the throughput is varying wildly during a run - more
than I think is probably normal. It happens regardless of whether I
limit by data rate or io rate, although I think it's worse when I
limit by io.

Here is a test job followed by the output. The io rate fluctuated
wildly - I watched it in the Windows Performance Monitor. The io rate
should be extremely easy to maintain. The "CR=80" looks suspicious -
why is there an 80 there when I requested 40?

BEGIN>>>
[streams]
sync=1
direct=1
bs=4k
thread
size=10M
nrfiles=1
rate_iops=40
rw=read
END>>>

BEGIN>>>
D:\>fio test.ini
streams: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=windowsaio, iodepth=1
fio-2.0.8-19-g9576
Starting 1 thread
Jobs: 1 (f=1), CR=80/0 IOPS: [R] [100.0% done] [160K/0K /s] [40 /0
iops] [eta 00m:00s]
streams: (groupid=0, jobs=1): err= 0: pid=4888: Sun Aug 19 22:32:01 2012
  read : io=10240KB, bw=163898 B/s, iops=40 , runt= 63977msec
    slat (usec): min=13 , max=106 , avg=23.81, stdev= 7.43
    clat (usec): min=214 , max=26940 , avg=688.03, stdev=1920.57
     lat (usec): min=248 , max=26986 , avg=711.84, stdev=1921.02
    clat percentiles (usec):
     |  1.00th=[  239],  5.00th=[  262], 10.00th=[  266], 20.00th=[  270],
     | 30.00th=[  274], 40.00th=[  278], 50.00th=[  282], 60.00th=[  286],
     | 70.00th=[  290], 80.00th=[  302], 90.00th=[  354], 95.00th=[ 4960],
     | 99.00th=[ 5088], 99.50th=[18048], 99.90th=[19328], 99.95th=[19328],
     | 99.99th=[27008]
    bw (KB/s)  : min=    3, max=  961, per=100.00%, avg=218.90, stdev=207.65
    lat (usec) : 250=1.80%, 500=89.80%, 750=2.23%
    lat (msec) : 10=5.39%, 20=0.74%, 50=0.04%
  cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=2560/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=10240KB, aggrb=160KB/s, minb=160KB/s, maxb=160KB/s,
mint=63977msec, maxt=63977msec

D:\>
END>>>

Windows 7 32-bit.

Greg.
