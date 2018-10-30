Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f180.google.com ([209.85.166.180]:35707 "EHLO
        mail-it1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbeJ3RIN (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 13:08:13 -0400
Received: by mail-it1-f180.google.com with SMTP id p64-v6so12693458itp.0
        for <fio@vger.kernel.org>; Tue, 30 Oct 2018 01:15:47 -0700 (PDT)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Tue, 30 Oct 2018 13:45:46 +0530
Message-ID: <CAFF4W0UYcVadXY=aNHbaT51s8NEb1z7CvNTXF0gGSF33sESDeQ@mail.gmail.com>
Subject: fio output not printing on the terminal when used fio cmd line
 options in client/server mode.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello,

I am testing fio client/server mode locally. Below are the steps I
have followed.

bash# fio --server
fio: server listening on 0.0.0.0,8765

bash# fio --client=localhost --name job1 --size 1M
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1

The output has stopped with one line as above and remaining outputs
are not printing.

But when I pass job file, complete output is printing.
bash# fio --client=0.0.0.0 /home/randread.fio

hostname=Mohan, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.16, flags=1
<Mohan> Bafjo: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K,
ioengine=psync, iodepth=1
<Mohan> Starting 1 process
Bafjo: (groupid=0, jobs=1): err= 0: pid=14048: Tue Oct 30 13:43:04 2018 00m:00s]
  read : io=10240KB, bw=3855.5KB/s, iops=963, runt=  2656msec
    clat (usec): min=129, max=106418, avg=1024.37, stdev=2361.84
     lat (usec): min=129, max=106419, avg=1025.20, stdev=2361.84
    clat percentiles (usec):
     |  1.00th=[  159],  5.00th=[  187], 10.00th=[  223], 20.00th=[  306],
     | 30.00th=[  394], 40.00th=[  556], 50.00th=[  748], 60.00th=[  988],
     | 70.00th=[ 1224], 80.00th=[ 1496], 90.00th=[ 1928], 95.00th=[ 2256],
     | 99.00th=[ 2736], 99.50th=[ 9536], 99.90th=[15040], 99.95th=[23424],
     | 99.99th=[105984]
    bw (KB  /s): min=   38, max=31751, per=100.00%, avg=8072.33, stdev=6448.75
    lat (usec) : 250=12.81%, 500=24.73%, 750=12.62%, 1000=10.47%
    lat (msec) : 2=30.55%, 4=7.89%, 10=0.55%, 20=0.31%, 50=0.04%
    lat (msec) : 250=0.04%
  cpu          : usr=1.92%, sys=5.88%, ctx=2564, majf=0, minf=78
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=2560/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=10240KB, aggrb=3855KB/s, minb=3855KB/s, maxb=3855KB/s,
mint=2656msec, maxt=2656msec

Disk stats (read/write):
  sda: ios=2518/3, merge=0/9, ticks=2472/44, in_queue=2516, util=90.09%
<Mohan>


Am I missing any options while passing parameters as command line options?

Thanks and Regards,
Mohan

