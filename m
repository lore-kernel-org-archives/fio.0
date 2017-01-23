Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36490 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750761AbdAWORo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 09:17:44 -0500
Received: by mail-wm0-f54.google.com with SMTP id c85so134726455wmi.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 06:17:43 -0800 (PST)
Subject: Re: hitting 2048 threads/jobs limit
References: <71c37fa9-61da-c3dc-fdc1-67d254845b46@gmail.com>
 <CANvN+ekk7A=ZQsgkeS0RWNVaJ7RfX8ALc7+UagobdhgUp9zqJw@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <dd66075f-864b-b193-66a6-29493c599df0@gmail.com>
Date: Mon, 23 Jan 2017 15:17:40 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+ekk7A=ZQsgkeS0RWNVaJ7RfX8ALc7+UagobdhgUp9zqJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, fio@vger.kernel.org

Hi Andrey,

thanks, got it .. FIO_MAX_JOB was bumped to 4096 like 4 months ago in 
this commit

https://github.com/axboe/fio/commit/cab2472e2e9e84877e65c6aa68b86899956c8a28

So I just needed to rebuild from source.

Now I can max out this box using 2800 threads at 4.7 mio 8kB random read 
IOPS =)

Awesome.

Cheers,
/Tobias


oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo 
/opt/fio/bin/fio postgresql_storage_workload.fio
randread: (g=0): rw=randread, bs=8192B-8192B,8192B-8192B,8192B-8192B, 
ioengine=sync, iodepth=1
...
fio-2.17-17-g9cf1
Starting 2800 threads
Jobs: 2736 (f=37103): 
[f(7),_(1),f(3),_(1),f(3),_(2),f(1),_(1),f(1),_(14),f(1),_(2),f(3),_(4),f(1),_(1),f(1),_(3),f(2),_(11),f(1),_(1),f(5),_(1),f(17),_(1),f(3),_(1),f(56),_(1),f(10),_(1),f(4),_(1),f(5),_(1),f(6),_(1),f(489),_(1),f(9),_(1),f(191),_(1),f(139),_(1),f(22),_(1),f(229),_(1),f(19),_(1),f(28),_(1),f(138),_(1),f(480),_(1),f(6),_(1),f(9),_(1),f(2),_(1),f(284),_(1),f(338),_(1),f(223)][100.0%][r=32.8GiB/s,w=0KiB/s][r=4297k,w=0 
IOPS][eta 00m:00s]
randread: (groupid=0, jobs=2800): err= 0: pid=99065: Mon Jan 23 15:16:24 
2017
    read: IOPS=4732k, BW=36.2GiB/s (38.8GB/s)(4332GiB/120007msec)
     clat (usec): min=43, max=26678, avg=583.62, stdev=572.89
      lat (usec): min=43, max=26678, avg=583.70, stdev=572.89
     clat percentiles (usec):
      |  1.00th=[  153],  5.00th=[  185], 10.00th=[  209], 20.00th=[  253],
      | 30.00th=[  302], 40.00th=[  354], 50.00th=[  418], 60.00th=[  502],
      | 70.00th=[  612], 80.00th=[  772], 90.00th=[ 1064], 95.00th=[ 1448],
      | 99.00th=[ 3152], 99.50th=[ 3984], 99.90th=[ 5856], 99.95th=[ 6688],
      | 99.99th=[ 8768]
     lat (usec) : 50=0.01%, 100=0.01%, 250=19.14%, 500=40.68%, 750=19.20%
     lat (usec) : 1000=9.54%
     lat (msec) : 2=8.76%, 4=2.19%, 10=0.48%, 20=0.01%, 50=0.01%
   cpu          : usr=0.45%, sys=3.68%, ctx=568493883, majf=0, minf=5598
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued rwt: total=567819066,0,0, short=0,0,0, dropped=0,0,0
      latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
    READ: bw=36.2GiB/s (38.8GB/s), 36.2GiB/s-36.2GiB/s 
(38.8GB/s-38.8GB/s), io=4332GiB (4652GB), run=120007-120007msec

Disk stats (read/write):
   nvme0n1: ios=35440924/0, merge=0/0, ticks=18474800/0, 
in_queue=18776444, util=99.79%
   nvme1n1: ios=35489875/0, merge=0/0, ticks=16143360/0, 
in_queue=16950032, util=100.00%
   nvme2n1: ios=35489702/0, merge=0/0, ticks=27449436/0, 
in_queue=28772208, util=100.00%
   nvme3n1: ios=35489494/0, merge=0/0, ticks=19419180/0, 
in_queue=19731140, util=99.71%
   nvme4n1: ios=35489290/0, merge=0/0, ticks=18055916/0, 
in_queue=19064904, util=100.00%
   nvme5n1: ios=35489126/0, merge=0/0, ticks=23692336/0, 
in_queue=24074852, util=99.79%
   nvme6n1: ios=35488938/0, merge=0/0, ticks=19653808/0, 
in_queue=19951296, util=99.67%
   nvme7n1: ios=35488789/0, merge=0/0, ticks=17548548/0, 
in_queue=17833728, util=99.70%
   nvme8n1: ios=35488597/0, merge=0/0, ticks=25328664/0, 
in_queue=25684916, util=99.69%
   nvme9n1: ios=35488409/0, merge=0/0, ticks=15241580/0, 
in_queue=15956076, util=100.00%
   nvme10n1: ios=35488240/0, merge=0/0, ticks=16489904/0, 
in_queue=16750844, util=99.82%
   nvme11n1: ios=35488059/0, merge=0/0, ticks=25966172/0, 
in_queue=27363044, util=100.00%
   nvme12n1: ios=35487878/0, merge=0/0, ticks=16283216/0, 
in_queue=16521860, util=99.78%
   nvme13n1: ios=35487713/0, merge=0/0, ticks=17994988/0, 
in_queue=18756864, util=100.00%
   nvme14n1: ios=35487556/0, merge=0/0, ticks=16564664/0, 
in_queue=16794600, util=99.90%
   nvme15n1: ios=35487377/0, merge=0/0, ticks=14727728/0, 
in_queue=14983204, util=99.85%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$

