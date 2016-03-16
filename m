Return-Path: <lftan.linux@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56E85B38.9010904@kernel.dk>
References: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
	<56E85B38.9010904@kernel.dk>
Date: Wed, 16 Mar 2016 19:18:40 +0800
Message-ID: <CAFiDJ58k7KMZKxqE0OpKq0ckdfoEthKrYyPH3DGvW+S577xG5Q@mail.gmail.com>
Subject: Re: fio with polling mode
From: Ley Foon Tan <lftan.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Mar 16, 2016 at 2:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 03/15/2016 04:20 AM, Ley Foon Tan wrote:
>>
>> Hi
>>
>> In the kernel v4.4 above, we can use polling mode for the NVMe data
>> transfer with command below:
>>
>> echo 1 > /sys/block/nvme0n1/queue/io_poll
>>
>> We can see NVMe throughput increase with polling mode with dd command.
>> Can we run fio with polling mode as well? If yes, what are the correct
>> fio parameters/arguments should we use?
>
>
> direct=1, and use one of the sync IO engines (psync would be a good one). And enable io_poll like you did above, then fio should be in polled mode.
>
> --
> Jens Axboe
Hi Jens

I have tried fio with direct=1 and ioengine=psync. But the results
almost the same (low throughput). Below is example command for
sequential write.
With your experiences, any clue where is the bottleneck for low
throughput (based on fio output). Note, kernel v4.4 and ARM platform.


# fio --filename=/dev/nvme0n1 --rw=write --direct=1 --blocksize=128k
--size=500M --iodepth=64 --group_reporting --name=myjob
--ioengine=psync
myjob: (g=0): rw=write, bs=128K-128K/128K-128K, ioengine=psync, iodepth=64
fio 2.0.5
Starting 1 process
Jobs: 1 (f=1)
myjob: (groupid=0, jobs=1): err= 0: pid=1139
  write: io=512000KB, bw=314110KB/s, iops=2453 , runt=  1630msec
    clat (usec): min=379 , max=694 , avg=395.20, stdev=11.90
     lat (usec): min=384 , max=702 , avg=402.65, stdev=12.35
    clat percentiles (usec):
     |  1.00th=[  382],  5.00th=[  394], 10.00th=[  394], 20.00th=[  394],
     | 30.00th=[  394], 40.00th=[  394], 50.00th=[  394], 60.00th=[  394],
     | 70.00th=[  394], 80.00th=[  394], 90.00th=[  398], 95.00th=[  402],
     | 99.00th=[  410], 99.50th=[  422], 99.90th=[  644]
    bw (KB/s)  : min=314112, max=314624, per=100.00%, avg=314368.00,
stdev=256.00
    lat (usec) : 500=99.78%, 750=0.22%
  cpu          : usr=3.07%, sys=33.76%, ctx=4001, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=512080/w=0/d=0, short=r=4000/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=512000KB, aggrb=314110KB/s, minb=321649KB/s,
maxb=321649KB/s, mint=1630msec, maxt=1630msec

Disk stats (read/write):
  nvme0n1: ios=62/7962, merge=0/0, ticks=0/2020, in_queue=2020, util=58.76%

# echo 1 > /sys/block/nvme0n1/queue/io_poll

# fio --filename=/dev/nvme0n1 --rw=write --direct=1 --blocksize=128k
--size=500M --iodepth=64 --group_reporting --name=myjob
--ioengine=psync
myjob: (g=0): rw=write, bs=128K-128K/128K-128K, ioengine=psync, iodepth=64
fio 2.0.5
Starting 1 process
Jobs: 1 (f=1)
myjob: (groupid=0, jobs=1): err= 0: pid=1152
  write: io=512000KB, bw=319600KB/s, iops=2496 , runt=  1602msec
    clat (usec): min=368 , max=6292 , avg=389.23, stdev=140.91
     lat (usec): min=373 , max=6299 , avg=396.41, stdev=140.94
    clat percentiles (usec):
     |  1.00th=[  370],  5.00th=[  374], 10.00th=[  382], 20.00th=[  382],
     | 30.00th=[  386], 40.00th=[  386], 50.00th=[  386], 60.00th=[  386],
     | 70.00th=[  386], 80.00th=[  386], 90.00th=[  386], 95.00th=[  394],
     | 99.00th=[  406], 99.50th=[  414], 99.90th=[ 1880]
    bw (KB/s)  : min=317696, max=323328, per=99.99%, avg=319573.33,
stdev=3251.64
    lat (usec) : 500=99.65%, 750=0.20%, 1000=0.03%
    lat (msec) : 2=0.05%, 4=0.03%, 10=0.05%
  cpu          : usr=1.87%, sys=98.06%, ctx=18, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=512080/w=0/d=0, short=r=4000/w=0/d=0

Run status group 0 (all jobs):
  WRITE: io=512000KB, aggrb=319600KB/s, minb=327270KB/s,
maxb=327270KB/s, mint=1602msec, maxt=1602msec

Disk stats (read/write):
  nvme0n1: ios=62/6878, merge=0/0, ticks=10/1740, in_queue=1750, util=58.94%



Thanks.

