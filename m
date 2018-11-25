Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f171.google.com ([209.85.166.171]:54465 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727245AbeKYQ04 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 25 Nov 2018 11:26:56 -0500
Received: by mail-it1-f171.google.com with SMTP id a205-v6so23617437itd.4
        for <fio@vger.kernel.org>; Sat, 24 Nov 2018 21:36:39 -0800 (PST)
MIME-Version: 1.0
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Sun, 25 Nov 2018 11:06:38 +0530
Message-ID: <CAFF4W0Uxs5eFvTH=Se3C9y80-3pDskX8jt9vv+mDG_PjjZMsfA@mail.gmail.com>
Subject: Re changing filename format.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello,

I am trying to changing filename format, so run the below command to test it

fio --name=job --size=10m --numjobs=3
--filename_format=$jobname.$jobnum.$filenum

job: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
4096B-4096B, ioengine=psync, iodepth=1
...
fio-3.12-17-g0fcbc0
Starting 3 processes
job: Laying out IO file (1 file / 10MiB)
fio: pid=0, err=21/file:filesetup.c:138, func=unlink, error=Is a directory
job: Laying out IO file (1 file / 10MiB)
fio: pid=0, err=21/file:filesetup.c:138, func=unlink, error=Is a directory
job: Laying out IO file (1 file / 10MiB)
fio: pid=0, err=21/file:filesetup.c:138, func=unlink, error=Is a directory

Run status group 0 (all jobs):

Got the above error, how to change the format of a file?

Then tired set the filename format like below and test works.
fio --name=job --size=10m --numjobs=3 --filename_format=test.$jobnum.$filenum
...
fio-3.12-17-g0fcbc0
Starting 3 processes
job: Laying out IO file (1 file / 10MiB)

job: (groupid=0, jobs=1): err= 0: pid=5117: Sun Nov 25 11:03:27 2018
  read: IOPS=29.1k, BW=114MiB/s (119MB/s)(10.0MiB/88msec)
    clat (nsec): min=1092, max=24776k, avg=32878.38, stdev=646198.51
     lat (nsec): min=1153, max=24777k, avg=33010.36, stdev=646198.32
    clat percentiles (nsec):
     |  1.00th=[    1144],  5.00th=[    1448], 10.00th=[    1464],
     | 20.00th=[    1512], 30.00th=[    1608], 40.00th=[    2064],
     | 50.00th=[    2576], 60.00th=[    2896], 70.00th=[    2960],
     | 80.00th=[    3024], 90.00th=[    3216], 95.00th=[    3664],
     | 99.00th=[  411648], 99.50th=[  493568], 99.90th=[12124160],
     | 99.95th=[13041664], 99.99th=[24772608]
  lat (usec)   : 2=38.67%, 4=57.11%, 10=1.45%, 20=0.94%, 50=0.12%
  lat (usec)   : 100=0.08%, 250=0.08%, 500=1.09%, 750=0.31%
  lat (msec)   : 20=0.12%, 50=0.04%
  cpu          : usr=11.49%, sys=4.60%, ctx=43, majf=0, minf=13
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=2560,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=114MiB/s (119MB/s), 114MiB/s-114MiB/s (119MB/s-119MB/s),
io=10.0MiB (10.5MB), run=88-88msec

Disk stats (read/write):
  sda: ios=31/0, merge=0/0, ticks=44/0, in_queue=48, util=30.14%

There is only one file has created --> test. .

3 process has run, why it not create 3 files?.

Thanks and Regards,
Mohan

