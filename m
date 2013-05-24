Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48199 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3EXXh0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 May 2013 19:37:26 -0400
Received: by mail-ie0-f182.google.com with SMTP id a14so13818545iee.41
        for <fio@vger.kernel.org>; Fri, 24 May 2013 16:37:26 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 24 May 2013 17:37:25 -0600
Message-ID: <CAJLXCZRk37OM3bUwvXZBd5bRxRvBDVG9-ye2nZfgQqc565N_jA@mail.gmail.com>
Subject: Understanding ioengine=net output
From: Andrew Davidoff <davidoff@qedmf.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I have read the README, HOWTO, and what I could find on the net, and I
still have some questions about interpreting ioengine=net output,
namely regarding latency.

The documentation says that if pingpong is used:

"The submission and completion latencies then measure local time spent
sending or receiving, and the completion latency measures how long it
took for the other end to receive and send back."

But I'm having trouble parsing what that actually means. Can you
clarify? I am further confused by the output as I see no mention of
slat. Here's the output from the sending side:

netwrite: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=net, iodepth=1
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [W] [100.0% done] [0Kbit/84864Kbit/0Kbit /s] [0/2652/0
iops] [eta 00m:00s]
netwrite: (groupid=0, jobs=1): err= 0: pid=840: Fri May 24 23:02:21 2013
  write: io=131072KB, bw=85486Kbit/s, iops=2680, runt= 12266msec
    clat (usec): min=8, max=1185, avg=365.37, stdev=170.37
     lat (usec): min=10, max=1188, avg=368.28, stdev=170.27
    clat percentiles (usec):
     |  1.00th=[   10],  5.00th=[  123], 10.00th=[  127], 20.00th=[  251],
     | 30.00th=[  258], 40.00th=[  262], 50.00th=[  386], 60.00th=[  390],
     | 70.00th=[  402], 80.00th=[  516], 90.00th=[  540], 95.00th=[  652],
     | 99.00th=[  788], 99.50th=[  804], 99.90th=[ 1020], 99.95th=[ 1048],
     | 99.99th=[ 1064]
    bw (Kbit/s): min=82816, max=90944, per=100.00%, avg=85538.67, stdev=1763.95
    lat (usec) : 10=0.55%, 20=0.92%, 50=0.09%, 100=0.09%, 250=16.66%
    lat (usec) : 500=52.62%, 750=26.02%, 1000=2.64%
    lat (msec) : 2=0.10%
  cpu          : usr=0.98%, sys=5.54%, ctx=92847, majf=0, minf=492
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.3%, 4=99.7%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=32873/d=0, short=r=0/w=105/d=0

Run status group 0 (all jobs):
  WRITE: io=131072KB, aggrb=85480Kbit/s, minb=85480Kbit/s,
maxb=85480Kbit/s, mint=12266msec, maxt=12266msec


And here's the out put from the receiver:

netread: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=net, iodepth=1
fio-2.1
Starting 1 process
fio: waiting for connection
Jobs: 1 (f=1): [R] [100.0% done] [84896Kbit/0Kbit/0Kbit /s] [2653/0/0
iops] [eta 00m:00s]
netread: (groupid=0, jobs=1): err= 0: pid=11854: Fri May 24 23:02:21 2013
  read : io=131072KB, bw=85271Kbit/s, iops=2757, runt= 12297msec
    clat (usec): min=2, max=3240, avg=359.82, stdev=169.78
     lat (usec): min=3, max=3241, avg=360.80, stdev=169.78
    clat percentiles (usec):
     |  1.00th=[    8],  5.00th=[  126], 10.00th=[  131], 20.00th=[  255],
     | 30.00th=[  258], 40.00th=[  262], 50.00th=[  386], 60.00th=[  390],
     | 70.00th=[  394], 80.00th=[  524], 90.00th=[  532], 95.00th=[  652],
     | 99.00th=[  788], 99.50th=[  796], 99.90th=[  932], 99.95th=[ 1048],
     | 99.99th=[ 1112]
    bw (Kbit/s): min=    0, max=85952, per=100.00%, avg=81922.56, stdev=17087.41
    lat (usec) : 4=0.64%, 10=0.86%, 20=0.26%, 50=0.03%, 100=0.01%
    lat (usec) : 250=14.39%, 500=54.62%, 750=23.48%, 1000=2.25%
    lat (msec) : 2=0.08%, 4=0.01%
  cpu          : usr=0.65%, sys=4.47%, ctx=92832, majf=0, minf=32
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=3.3%, 4=96.7%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=33915/w=0/d=0, short=r=1147/w=0/d=0

Run status group 0 (all jobs):
   READ: io=131072KB, aggrb=85264Kbit/s, minb=85264Kbit/s,
maxb=85264Kbit/s, mint=12297msec, maxt=12297msec


So, a few questions about the latency numbers presented, since the
labels aren't matching up with the documentation:
* What is clat?
* What is lat?

Also, a more general question: is fio doing sync or async network I/O?

If it helps, both machines in this test are Ubuntu 10.04 with all
official updates, and I built fio from source.

I may also have some questions regarding test results with pingpong
vs. not, but understanding this output will determine that.

Thanks!
Andy
