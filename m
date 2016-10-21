Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:35410 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751226AbcJUBas (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Oct 2016 21:30:48 -0400
Received: by mail-vk0-f48.google.com with SMTP id q126so97961828vkd.2
        for <fio@vger.kernel.org>; Thu, 20 Oct 2016 18:30:48 -0700 (PDT)
MIME-Version: 1.0
From: Tarek <cashew250@gmail.com>
Date: Thu, 20 Oct 2016 20:30:47 -0500
Message-ID: <CAOHuL9gEd8VoDuyirSosdTwyQETskOgTvCyEGEPJoDEQS+9K=A@mail.gmail.com>
Subject: Results too good to be true?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

10 NVME Intel DC P3600 spec'd at 450K Random Read 32QD 4 Jobs
I ran 128QD, 3 Jobs each and got aggregate total of  iops=7039.3K!
That's more than
the spec (granted they didn't spec it for 128QD). Results below and
Fio File below that
can you take a look if I am overlooking something?


drive 0: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 1: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 2: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 3: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 4: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 5: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 6: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 7: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 8: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
drive 9: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
...
fio-2.14-28-ga4f5
Starting 30 threads

drive 0: (groupid=0, jobs=30): err= 0: pid=2870: Tue Oct 18 14:36:51 2016
  Description  : [Random Read 4k]
  read : io=193340GB, bw=27497MB/s, iops=7039.3K, runt=7200002msec
    slat (usec): min=1, max=1241, avg= 3.34, stdev= 1.64
    clat (usec): min=7, max=16392, avg=541.66, stdev=114.47
     lat (usec): min=12, max=16400, avg=545.08, stdev=115.13
    clat percentiles (usec):
     |  1.00th=[  422],  5.00th=[  430], 10.00th=[  434], 20.00th=[  438],
     | 30.00th=[  446], 40.00th=[  450], 50.00th=[  458], 60.00th=[  474],
     | 70.00th=[  580], 80.00th=[  628], 90.00th=[  724], 95.00th=[  908],
     | 99.00th=[ 1144], 99.50th=[ 1160], 99.90th=[ 1192], 99.95th=[ 1192],
     | 99.99th=[ 1224]
    bw (KB  /s): min=128156, max=1204116, per=3.34%, avg=940697.47,
stdev=228474.07
    lat (usec) : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%, 250=0.01%
    lat (usec) : 500=1.15%, 750=5.80%, 1000=6.74%
    lat (msec) : 2=1.57%, 4=0.01%, 10=0.01%, 20=0.01%
  cpu          : usr=18.80%, sys=81.16%, ctx=266866, majf=0, minf=3870
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=6.8%
     submit    : 0=0.0%, 4=6.8%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=6.8%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued    : total=r=50682806502/w=0/d=0, short=r=0/w=0/d=0,
drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=128

Run status group 0 (all jobs):
   READ: io=193340GB, aggrb=27497MB/s, minb=27497MB/s, maxb=27497MB/s,
mint=7200002msec, maxt=7200002msec

Disk stats (read/write):
  nvme0n1: ios=5453031496/0, merge=0/0, ticks=68612904/0,
in_queue=73342188, util=100.00%
  nvme1n1: ios=3872659581/0, merge=0/0, ticks=35416720/0,
in_queue=35720896, util=100.00%
  nvme2n1: ios=5592193351/0, merge=0/0, ticks=94606636/0,
in_queue=99357220, util=100.00%
  nvme3n1: ios=5380090604/0, merge=0/0, ticks=64613672/0,
in_queue=67967852, util=100.00%
  nvme4n1: ios=4872206852/0, merge=0/0, ticks=51991836/0,
in_queue=52827480, util=100.00%
  nvme5n1: ios=4116490779/0, merge=0/0, ticks=38468504/0,
in_queue=39090732, util=100.00%
  nvme6n1: ios=5402454695/0, merge=0/0, ticks=63680560/0,
in_queue=65725200, util=100.00%
  nvme7n1: ios=5516467576/0, merge=0/0, ticks=71340304/0,
in_queue=73265860, util=100.00%
  nvme8n1: ios=5735385261/0, merge=0/0, ticks=117401000/0,
in_queue=122921512, util=100.00%
  nvme9n1: ios=4740320643/0, merge=0/0, ticks=46065084/0,
in_queue=47110532, util=100.00%

----------------------------------------------------------------------------------------------
Fio File

[global]
description=Random Read 4k
thread
ioengine=libaio
direct=1
buffered=0
log_avg_msec=1000
group_reporting=1
size=100%
blocksize=4K
time_based
runtime=7200
log_avg_msec=1000
per_job_logs=1
iodepth=128
numjobs = 3
norandommap
refill_buffers
write_bw_log=/var/log/SSD/ssd-random_100R_0W_4k_QD128_JOB30_bandwidth
write_iops_log=/var/log/SSD/ssd-random_100R_0W_4k_QD128_JOB30_iops
rw=randread

[drive 0]
filename=/dev/nvme0n1

[drive 1]
filename=/dev/nvme1n1

[drive 2]
filename=/dev/nvme2n1

[drive 3]
filename=/dev/nvme3n1

[drive 4]
filename=/dev/nvme4n1

[drive 5]
filename=/dev/nvme5n1

[drive 6]
filename=/dev/nvme6n1

[drive 7]
filename=/dev/nvme7n1

[drive 8]
filename=/dev/nvme8n1

[drive 9]
filename=/dev/nvme9n1
