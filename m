Return-Path: <axboe@kernel.dk>
Message-ID: <533ACDDC.6010002@kernel.dk>
Date: Tue, 01 Apr 2014 08:31:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Shared files with thread=1: func=xfer, err=Bad file descriptor
References: <CANvN+ekEmEeFeXZ_b7-51QpetdWx2nwJHwoEsbsiFTOcpYwizw@mail.gmail.com>
In-Reply-To: <CANvN+ekEmEeFeXZ_b7-51QpetdWx2nwJHwoEsbsiFTOcpYwizw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/31/2014 07:08 PM, Andrey Kuzmin wrote:
> The following simple setup
> ---
> [global]
> ioengine=psync
> direct=1
> sync=1
>
> [randrwrite]
> filename=/tmp/test.dat
> lockfile=exclusive
> filesize=1m
> ;
> thread=1
> numjobs=4
> runtime=10
> time_based=1
> ;
> rw=randwrite
> bs=4k
> ---
>
> runs fine with jobs being processes, and fails as follows with thread=1.
>
> randrwrite: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=psync, iodepth=1
> ...
> fio-2.1.6.1-23-g9f97
> Starting 4 threads
> fio: pid=10455, err=9/file:engines/sync.c:67, func=xfer, error=Bad
> file descriptor]
> fio: pid=10453, err=9/file:engines/sync.c:67, func=xfer, error=Bad
> file descriptor
> fio: pid=10454, err=9/file:engines/sync.c:67, func=xfer, error=Bad
> file descriptor
> Jobs: 1 (f=1): [wXXX] [100.0% done] [0KB/2372KB/0KB /s] [0/593/0 iops]
> [eta 00m:00s]
> randrwrite: (groupid=0, jobs=1): err= 0: pid=10452: Mon Mar 31 18:05:26 2014
>    write: io=14900KB, bw=1489.9KB/s, iops=372, runt= 10001msec
>      clat (usec): min=419, max=260739, avg=1546.00, stdev=4329.54
>       lat (usec): min=424, max=260744, avg=1551.95, stdev=4329.58
>      clat percentiles (usec):
>       |  1.00th=[  588],  5.00th=[  732], 10.00th=[  780], 20.00th=[  828],
>       | 30.00th=[  876], 40.00th=[  956], 50.00th=[ 1080], 60.00th=[ 1432],
>       | 70.00th=[ 2064], 80.00th=[ 2256], 90.00th=[ 2480], 95.00th=[ 2736],
>       | 99.00th=[ 3344], 99.50th=[ 3632], 99.90th=[ 4512], 99.95th=[23680],
>       | 99.99th=[261120]
>      bw (KB  /s): min=    5, max= 1099, per=22.09%, avg=519.90, stdev=359.34
>      lat (usec) : 500=0.19%, 750=6.42%, 1000=37.61%
>      lat (msec) : 2=23.68%, 4=31.81%, 10=0.24%, 50=0.03%, 500=0.03%
>    cpu          : usr=0.76%, sys=8.08%, ctx=8191, majf=0, minf=5
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=3725/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> randrwrite: (groupid=0, jobs=1): err= 9 (file:engines/sync.c:67,
> func=xfer, error=Bad file descriptor): pid=10453: Mon Mar 31 18:05:26
> 2014
>    write: io=3072.0KB, bw=581465B/s, iops=142, runt=  5410msec
>      clat (usec): min=587, max=33827, avg=1817.50, stdev=2464.14
>       lat (usec): min=593, max=33837, avg=1823.85, stdev=2464.47
>      clat percentiles (usec):
>       |  1.00th=[  804],  5.00th=[  876], 10.00th=[  932], 20.00th=[  988],
>       | 30.00th=[ 1048], 40.00th=[ 1096], 50.00th=[ 1208], 60.00th=[ 2024],
>       | 70.00th=[ 2224], 80.00th=[ 2352], 90.00th=[ 2576], 95.00th=[ 2896],
>       | 99.00th=[ 4080], 99.50th=[32640], 99.90th=[34048], 99.95th=[34048],
>       | 99.99th=[34048]
>      bw (KB  /s): min=  165, max= 1266, per=25.28%, avg=595.00, stdev=450.04
>      lat (usec) : 750=0.39%, 1000=22.76%
>      lat (msec) : 2=36.67%, 4=38.88%, 10=0.52%, 20=0.13%, 50=0.52%
>    cpu          : usr=0.15%, sys=5.69%, ctx=2288, majf=0, minf=0
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.1%, 4=99.9%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=769/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> randrwrite: (groupid=0, jobs=1): err= 9 (file:engines/sync.c:67,
> func=xfer, error=Bad file descriptor): pid=10454: Mon Mar 31 18:05:26
> 2014
>    write: io=2528.0KB, bw=478497B/s, iops=117, runt=  5410msec
>      clat (usec): min=299, max=33920, avg=2106.79, stdev=3775.38
>       lat (usec): min=303, max=33930, avg=2113.60, stdev=3775.68
>      clat percentiles (usec):
>       |  1.00th=[  564],  5.00th=[  820], 10.00th=[  932], 20.00th=[  996],
>       | 30.00th=[ 1064], 40.00th=[ 1160], 50.00th=[ 1256], 60.00th=[ 1976],
>       | 70.00th=[ 2224], 80.00th=[ 2384], 90.00th=[ 2672], 95.00th=[ 3056],
>       | 99.00th=[33024], 99.50th=[33024], 99.90th=[34048], 99.95th=[34048],
>       | 99.99th=[34048]
>      bw (KB  /s): min=   46, max=  728, per=18.61%, avg=438.17, stdev=265.37
>      lat (usec) : 500=0.16%, 750=3.63%, 1000=16.59%
>      lat (msec) : 2=39.81%, 4=37.28%, 10=0.63%, 20=0.32%, 50=1.42%
>    cpu          : usr=0.30%, sys=5.03%, ctx=2048, majf=0, minf=2
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.2%, 4=99.8%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=633/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
> randrwrite: (groupid=0, jobs=1): err= 9 (file:engines/sync.c:67,
> func=xfer, error=Bad file descriptor): pid=10455: Mon Mar 31 18:05:26
> 2014
>    write: io=3052.0KB, bw=583286B/s, iops=142, runt=  5358msec
>      clat (usec): min=541, max=24712, avg=1707.90, stdev=1533.18
>       lat (usec): min=547, max=24743, avg=1714.89, stdev=1533.64
>      clat percentiles (usec):
>       |  1.00th=[  796],  5.00th=[  876], 10.00th=[  908], 20.00th=[  980],
>       | 30.00th=[ 1048], 40.00th=[ 1128], 50.00th=[ 1240], 60.00th=[ 1736],
>       | 70.00th=[ 2224], 80.00th=[ 2384], 90.00th=[ 2640], 95.00th=[ 2896],
>       | 99.00th=[ 3280], 99.50th=[ 4640], 99.90th=[24704], 99.95th=[24704],
>       | 99.99th=[24704]
>      bw (KB  /s): min=  204, max= 1009, per=20.39%, avg=480.00, stdev=283.93
>      lat (usec) : 750=0.65%, 1000=22.12%
>      lat (msec) : 2=38.35%, 4=38.09%, 10=0.26%, 50=0.39%
>    cpu          : usr=0.37%, sys=5.45%, ctx=2261, majf=0, minf=5
>    IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       complete  : 0=0.1%, 4=99.9%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>       issued    : total=r=0/w=764/d=0, short=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    WRITE: io=23552KB, aggrb=2354KB/s, minb=467KB/s, maxb=1489KB/s,
> mint=5358msec, maxt=10001msec
>
> Disk stats (read/write):
>    sda: ios=0/13818, merge=0/2227, ticks=0/7428, in_queue=7260, util=72.37%
>
> Is file sharing with non-trivial lockfile= setting is expected to work
> with threads=1, or is it an unanticipated use case?

No, that's supposed to work. I think it's a race between shared files, 
and opening/closing of them when you have a timed based job. I'll take a 
look at it.

-- 
Jens Axboe


