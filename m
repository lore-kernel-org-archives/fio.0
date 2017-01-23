Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:35015 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750965AbdAWT0e (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 14:26:34 -0500
Received: by mail-wj0-f193.google.com with SMTP id i7so2725193wjf.2
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 11:26:33 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <88881B02-C9E2-4B72-B2ED-61B035DD9EAD@intel.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <c1d56766-ec23-dfc7-7684-c141846d12e6@gmail.com>
Date: Mon, 23 Jan 2017 20:26:31 +0100
MIME-Version: 1.0
In-Reply-To: <88881B02-C9E2-4B72-B2ED-61B035DD9EAD@intel.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Andrey,

Am 23.01.2017 um 20:10 schrieb Kudryavtsev, Andrey O:
> Tobias,
> I’d try 128 jobs, QD 32 and disable random map and latency measurements
>        randrepeat=0
>        norandommap

I had those already set ..

>        disable_	lat
>

This I hadn't set.

Using the settings you suggest on the MD over 16 NVMes, and after 
increasing to

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ cat 
/proc/sys/fs/aio-max-nr
1048576

I get iops=4082.2K, which is much closer to the 7 mio IOPS I get with 
engine=sync and jobs=2800.

Cheers,
/Tobias

PS: I am still working on your other hints .. so many tips. Thanks guys!




oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo fio 
postgresql_storage_workload.fio
randread: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
...
fio-2.1.11
Starting 128 threads
Jobs: 127 (f=0): [r(51),E(1),r(76)] [3.5% done] [15018MB/0KB/0KB /s] 
[3845K/0/0 iops] [eta 14m:11s]
randread: (groupid=0, jobs=128): err= 0: pid=5878: Mon Jan 23 20:25:01 2017
   read : io=478427MB, bw=15946MB/s, iops=4082.2K, runt= 30003msec
     slat (usec): min=1, max=47954, avg=29.39, stdev=34.90
     clat (usec): min=37, max=49119, avg=972.35, stdev=673.40
     clat percentiles (usec):
      |  1.00th=[  338],  5.00th=[  446], 10.00th=[  532], 20.00th=[  660],
      | 30.00th=[  756], 40.00th=[  836], 50.00th=[  892], 60.00th=[  956],
      | 70.00th=[ 1020], 80.00th=[ 1112], 90.00th=[ 1224], 95.00th=[ 1368],
      | 99.00th=[ 4832], 99.50th=[ 5664], 99.90th=[ 6816], 99.95th=[ 7328],
      | 99.99th=[ 8896]
     bw (KB  /s): min=14024, max=393664, per=0.78%, avg=127573.83, 
stdev=51679.15
     lat (usec) : 50=0.01%, 100=0.01%, 250=0.07%, 500=8.15%, 750=21.53%
     lat (usec) : 1000=37.36%
     lat (msec) : 2=29.83%, 4=1.53%, 10=1.53%, 20=0.01%, 50=0.01%
   cpu          : usr=5.34%, sys=94.48%, ctx=11411, majf=0, minf=4224
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=100.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=122477269/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
    READ: io=478427MB, aggrb=15946MB/s, minb=15946MB/s, maxb=15946MB/s, 
mint=30003msec, maxt=30003msec

Disk stats (read/write):
     md1: ios=121675684/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, 
aggrios=7654829/0, aggrmerge=0/0, aggrticks=985171/0, 
aggrin_queue=1037857, aggrutil=100.00%
   nvme15n1: ios=7650998/0, merge=0/0, ticks=938492/0, in_queue=968336, 
util=100.00%
   nvme6n1: ios=7655891/0, merge=0/0, ticks=1044320/0, in_queue=1074048, 
util=100.00%
   nvme9n1: ios=7654289/0, merge=0/0, ticks=954912/0, in_queue=1043060, 
util=100.00%
   nvme11n1: ios=7656494/0, merge=0/0, ticks=955896/0, in_queue=1050748, 
util=100.00%
   nvme2n1: ios=7656190/0, merge=0/0, ticks=998112/0, in_queue=1090236, 
util=100.00%
   nvme14n1: ios=7655685/0, merge=0/0, ticks=956648/0, in_queue=982168, 
util=100.00%
   nvme5n1: ios=7652531/0, merge=0/0, ticks=1040592/0, in_queue=1068920, 
util=100.00%
   nvme8n1: ios=7652934/0, merge=0/0, ticks=969800/0, in_queue=994468, 
util=100.00%
   nvme10n1: ios=7655795/0, merge=0/0, ticks=949068/0, in_queue=975252, 
util=100.00%
   nvme1n1: ios=7652373/0, merge=0/0, ticks=955772/0, in_queue=1040828, 
util=100.00%
   nvme13n1: ios=7654611/0, merge=0/0, ticks=965664/0, in_queue=1053560, 
util=100.00%
   nvme4n1: ios=7655941/0, merge=0/0, ticks=1001460/0, in_queue=1113764, 
util=100.00%
   nvme7n1: ios=7652420/0, merge=0/0, ticks=991072/0, in_queue=1018248, 
util=100.00%
   nvme0n1: ios=7656124/0, merge=0/0, ticks=1051448/0, in_queue=1083992, 
util=100.00%
   nvme12n1: ios=7656450/0, merge=0/0, ticks=1031252/0, 
in_queue=1064052, util=100.00%
   nvme3n1: ios=7658543/0, merge=0/0, ticks=958228/0, in_queue=984040, 
util=100.00%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ cat 
postgresql_storage_workload.fio
[global]
group_reporting
#filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1:/dev/nvme4n1:/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nvme8n1:/dev/nvme9n1:/dev/nvme10n1:/dev/nvme11n1:/dev/nvme12n1:/dev/nvme13n1:/dev/nvme14n1:/dev/nvme15n1
filename=/dev/md1
#filename=/data/test.dat
#filename=/dev/data/data
size=30G
#ioengine=sync
#iodepth=1
ioengine=libaio
iodepth=32
thread=1
direct=1
time_based=1
randrepeat=0
norandommap=1
disable_lat=1
#bs=8k
bs=4k
#ramp_time=0
runtime=30

[randread]
stonewall
rw=randread
numjobs=128

#[randwrite]
#stonewall
#rw=randwrite
#numjobs=32

#[randreadwrite7030]
#stonewall
#rw=randrw
#rwmixread=70
#numjobs=256

oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$

