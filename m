Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37828 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750705AbdAWTkf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 14:40:35 -0500
Received: by mail-wm0-f49.google.com with SMTP id c206so173377457wme.0
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 11:40:35 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com>
Date: Mon, 23 Jan 2017 20:40:32 +0100
MIME-Version: 1.0
In-Reply-To: <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Am 23.01.2017 um 20:13 schrieb Sitsofe Wheeler:
> On 23 January 2017 at 18:33, Tobias Oberstein
> <tobias.oberstein@gmail.com> wrote:
>>
>> libaio is nowhere near what I get with engine=sync and high job counts. Mmh.
>> Plus the strange behavior.
>
> Have you tried batching the IOs and controlling how much are you
> reaping at any one time? See
> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth_batch_submit
> for some of the options for controlling this...
>

Thanks! Nice.

For libaio, and with all the hints applied (no 4k sectors yet), I get 
(4k randread)

Individual NVMes: iops=7350.4K
MD (RAID-0) over NVMes: iops=4112.8K

The going up and down of IOPS is gone.

It's becoming more apparent I'd say, that tthere is a MD bottleneck though.

Cheers,
/Tobias


oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ cat best_libaio.fio
# sudo sh -c 'echo "1048576" > /proc/sys/fs/aio-max-nr'

[global]
group_reporting
size=30G
ioengine=libaio
iodepth=32
iodepth_batch_submit=8
thread=1
direct=1
time_based=1
randrepeat=0
norandommap=1
disable_lat=1
bs=4k
runtime=30

[randread-individual-nvmes]
stonewall
filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1:/dev/nvme4n1:/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nvme8n1:/dev/nvme9n1:/dev/nvme10n1:/dev/nvme11n1:/dev/nvme12n1:/dev/nvme13n1:/dev/nvme14n1:/dev/nvme15n1
rw=randread
numjobs=128

[randread-md-over-nvmes]
stonewall
filename=/dev/md1
rw=randread
numjobs=128


oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$ sudo fio 
best_libaio.fio
randread-individual-nvmes: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, 
ioengine=libaio, iodepth=32
...
randread-md-over-nvmes: (g=1): rw=randread, bs=4K-4K/4K-4K/4K-4K, 
ioengine=libaio, iodepth=32
...
fio-2.1.11
Starting 256 threads
Jobs: 128 (f=128): [_(128),r(128)] [7.9% done] [16173MB/0KB/0KB /s] 
[4140K/0/0 iops] [eta 11m:51s]
randread-individual-nvmes: (groupid=0, jobs=128): err= 0: pid=6988: Mon 
Jan 23 20:37:30 2017
   read : io=861513MB, bw=28712MB/s, iops=7350.4K, runt= 30005msec
     slat (usec): min=1, max=179194, avg= 9.61, stdev=166.67
     clat (usec): min=8, max=174722, avg=543.86, stdev=736.75
     clat percentiles (usec):
      |  1.00th=[  117],  5.00th=[  139], 10.00th=[  153], 20.00th=[  175],
      | 30.00th=[  199], 40.00th=[  223], 50.00th=[  258], 60.00th=[  302],
      | 70.00th=[  394], 80.00th=[  636], 90.00th=[ 1480], 95.00th=[ 2192],
      | 99.00th=[ 3408], 99.50th=[ 3856], 99.90th=[ 4960], 99.95th=[ 5536],
      | 99.99th=[10048]
     bw (KB  /s): min=14992, max=432176, per=0.78%, avg=229721.98, 
stdev=44902.57
     lat (usec) : 10=0.01%, 50=0.01%, 100=0.10%, 250=48.21%, 500=27.38%
     lat (usec) : 750=6.48%, 1000=3.18%
     lat (msec) : 2=8.54%, 4=5.73%, 10=0.38%, 20=0.01%, 50=0.01%
     lat (msec) : 100=0.01%, 250=0.01%
   cpu          : usr=8.25%, sys=64.76%, ctx=57533651, majf=0, minf=4224
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=0.1%, 32=100.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=220547266/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32
randread-md-over-nvmes: (groupid=1, jobs=128): err= 0: pid=7138: Mon Jan 
23 20:37:30 2017
   read : io=482013MB, bw=16065MB/s, iops=4112.8K, runt= 30003msec
     slat (usec): min=1, max=48048, avg=29.39, stdev=36.10
     clat (usec): min=47, max=74459, avg=964.89, stdev=637.97
     clat percentiles (usec):
      |  1.00th=[  454],  5.00th=[  540], 10.00th=[  604], 20.00th=[  692],
      | 30.00th=[  764], 40.00th=[  828], 50.00th=[  876], 60.00th=[  924],
      | 70.00th=[  980], 80.00th=[ 1064], 90.00th=[ 1176], 95.00th=[ 1320],
      | 99.00th=[ 4768], 99.50th=[ 5536], 99.90th=[ 6432], 99.95th=[ 6752],
      | 99.99th=[ 7968]
     bw (KB  /s): min=14512, max=350248, per=0.78%, avg=128572.72, 
stdev=42938.35
     lat (usec) : 50=0.01%, 100=0.01%, 250=0.03%, 500=2.69%, 750=24.84%
     lat (usec) : 1000=45.08%
     lat (msec) : 2=24.43%, 4=1.40%, 10=1.51%, 20=0.01%, 50=0.01%
     lat (msec) : 100=0.01%
   cpu          : usr=4.98%, sys=94.81%, ctx=12736, majf=0, minf=3328
   IO depths    : 1=0.0%, 2=0.0%, 4=0.0%, 8=0.1%, 16=0.1%, 32=100.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=123395206/w=0/d=0, short=r=0/w=0/d=0
      latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
    READ: io=861513MB, aggrb=28712MB/s, minb=28712MB/s, maxb=28712MB/s, 
mint=30005msec, maxt=30005msec

Run status group 1 (all jobs):
    READ: io=482013MB, aggrb=16065MB/s, minb=16065MB/s, maxb=16065MB/s, 
mint=30003msec, maxt=30003msec

Disk stats (read/write):
   nvme0n1: ios=13713322/0, merge=0/0, ticks=2809744/0, 
in_queue=2867236, util=98.51%
   nvme1n1: ios=13713230/0, merge=0/0, ticks=11534416/0, 
in_queue=12284600, util=99.60%
   nvme2n1: ios=13713491/0, merge=0/0, ticks=9773908/0, 
in_queue=10359404, util=99.80%
   nvme3n1: ios=13713296/0, merge=0/0, ticks=6619552/0, 
in_queue=6803384, util=99.49%
   nvme4n1: ios=13713658/0, merge=0/0, ticks=6055532/0, 
in_queue=6533236, util=100.00%
   nvme5n1: ios=13713740/0, merge=0/0, ticks=2863528/0, 
in_queue=2931544, util=99.89%
   nvme6n1: ios=13713827/0, merge=0/0, ticks=2796528/0, 
in_queue=2859208, util=99.72%
   nvme7n1: ios=13713905/0, merge=0/0, ticks=2846160/0, 
in_queue=2904800, util=99.74%
   nvme8n1: ios=13713529/0, merge=0/0, ticks=7422588/0, 
in_queue=7582496, util=100.00%
   nvme9n1: ios=13713414/0, merge=0/0, ticks=13762972/0, 
in_queue=14664088, util=100.00%
   nvme10n1: ios=13714158/0, merge=0/0, ticks=6570356/0, 
in_queue=6735324, util=100.00%
   nvme11n1: ios=13714217/0, merge=0/0, ticks=4189764/0, 
in_queue=4519824, util=100.00%
   nvme12n1: ios=13714299/0, merge=0/0, ticks=7225476/0, 
in_queue=7393668, util=100.00%
   nvme13n1: ios=13714375/0, merge=0/0, ticks=4988804/0, 
in_queue=5267536, util=100.00%
   nvme14n1: ios=13714461/0, merge=0/0, ticks=7336928/0, 
in_queue=7502260, util=100.00%
   nvme15n1: ios=13713918/0, merge=0/0, ticks=11861500/0, 
in_queue=12202492, util=100.00%
   md1: ios=123098498/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
oberstet@svr-psql19:~/scm/parcit/RA/adr/system/docs$

