Return-Path: <axboe@kernel.dk>
Subject: Re: IO mixed : 12% seqread, 8% seqwrite, 80% random (30% W, 70%R)
References: <HE1PR05MB17878EE04B3D85CD447FFBD7B1800@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enipwNVDS4QSsgh67FkpL-EoBsW0j0XRj5F2qSc7w+83A@mail.gmail.com>
 <HE1PR05MB1787EB4BBDE5DE3867EE47D5B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <CANvN+enHQqeXyimRCNnPS5Bp+hc+apVN5+-sKH8HLN=LhyeHHw@mail.gmail.com>
 <HE1PR05MB17875B7FE235655AB2A81519B1810@HE1PR05MB1787.eurprd05.prod.outlook.com>
 <56F4BB3E.6050205@kernel.dk>
 <HE1PR05MB178780CACBC2631A841BB3FDB1830@HE1PR05MB1787.eurprd05.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56F55429.1090506@kernel.dk>
Date: Fri, 25 Mar 2016 09:07:21 -0600
MIME-Version: 1.0
In-Reply-To: <HE1PR05MB178780CACBC2631A841BB3FDB1830@HE1PR05MB1787.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Thierry BERTAUD <tbertaud@conforama.fr>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/25/2016 12:33 AM, Thierry BERTAUD wrote:
> Hi Jens,
>
> Sorry my update lacked precision. I want to tell that the output of my command is not correct because the IO profile is the same at  70% randread and 30%randwrite (graph from SAN tools).
> I don't want to tell that the Andrey explanation is wrong.
>
> I tried this but it seems the problem is that i don't understand the documentation so it's why i don't have that i expect.
> # cat test.conf
> [global]
> ioengine=posixaio
> invalidate=0
> norandommap
> ramp_time=5
> iodepth=8
> runtime=60
> time_based
> direct=1
> numjobs=1
> group_reporting
> filesize=103M
> blocksize=8k
> #rw=randrw
> rwmixread=70
> percentage_random=12,8
>
> [hdisk2]
> stonewall
> filename=/dev/rhdisk2
> # ./fio test.conf
> hdisk2: (g=0): rw=read, bs=8K-8K/8K-8K/8K-8K, ioengine=posixaio, iodepth=8
> fio-2.3
> Starting 1 process
> Jobs: 1 (f=1): [R(1)] [100.0% done] [217.2MB/0KB/0KB /s] [27.8K/0/0 iops] [eta 00m:00s]
> hdisk2: (groupid=0, jobs=1): err= 0: pid=213240: Fri Mar 25 07:27:47 2016
>    read : io=12872MB, bw=219671KB/s, iops=27458, runt= 60001msec
>      slat (usec): min=14, max=9705, avg=28.74, stdev=34.99
>      clat (usec): min=2, max=10363, avg=221.22, stdev=48.30
>       lat (usec): min=144, max=10382, avg=249.52, stdev=50.07
>      clat percentiles (usec):
>       |  1.00th=[  149],  5.00th=[  165], 10.00th=[  175], 20.00th=[  189],
>       | 30.00th=[  201], 40.00th=[  211], 50.00th=[  221], 60.00th=[  231],
>       | 70.00th=[  241], 80.00th=[  251], 90.00th=[  266], 95.00th=[  282],
>       | 99.00th=[  310], 99.50th=[  326], 99.90th=[  362], 99.95th=[  386],
>       | 99.99th=[  466]
>      bw (KB  /s): min=    4, max=225344, per=99.17%, avg=217851.37, stdev=20237.94
>      lat (usec) : 4=0.01%, 10=0.01%, 50=0.01%, 100=0.01%, 250=78.56%
>      lat (usec) : 500=21.42%, 750=0.01%, 1000=0.01%
>      lat (msec) : 4=0.01%, 10=0.01%, 20=0.01%
>    cpu          : usr=8.22%, sys=28.38%, ctx=0, majf=0, minf=0
>    IO depths    : 1=0.1%, 2=0.2%, 4=68.4%, 8=37.6%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=99.5%, 8=0.5%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=1647553/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=8
>
> Run status group 0 (all jobs):
>     READ: io=12872MB, aggrb=219671KB/s, minb=219671KB/s, maxb=219671KB/s, mint=60001msec, maxt=60001msec

I added a small hack to the null IO engine, to show randomness and 
distribution. If I run your suggested job:

./fio --name=null --ioengine=null --rw=randrw  --size=10g --bs=4k 
--rwmixread=70 --percentage_random=12,8

I get:

READS: 69.96% (1834089)
	Seq: 88.00% (1613999)
	Rnd: 12.00% (220090)
WRITES: 30.04% (787351)
	Seq: 91.98% (724171)
	Rnd: 8.02% (63180)

which means that part is working as expected. But from your initial 
description, that's not what you want:

1. 12% seqread
2.  8% seqwrite
3. The rest 80% are random of this 30% (24% from total) is write and 70% 
(56% from total) reads.

which is 20% of the IO is sequential, and of that 20%, 40% are writes, 
60% are reads. 80% of the total IO are random, and within that split, 
you want a 70/30 read/write split.

Fio can't do a double split like that in a single job, but if you can 
tolerate mixing the 60/40 and 70/30 read/write between sequential and 
random, then you can make it work.

Or you can split it in two jobs, one doing the sequential part and the 
other the random. The you can use the flow parameters to pace them at 
20/80 ratios.

-- 
Jens Axboe


