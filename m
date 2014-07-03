Return-Path: <axboe@kernel.dk>
Message-ID: <53B5A375.2050408@kernel.dk>
Date: Thu, 03 Jul 2014 12:39:49 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: multiple block devices question
References: <CANyhEAuqB4Q2XphsGpn3FcGFhr02D2etUZBaD7j9w20Y44JXVg@mail.gmail.com>	<53B462A3.8050402@kernel.dk>	<CANyhEAvWNUonhYj1rpDP=o4g4199o1tZY-Oz=1qQJMFQEPpwGw@mail.gmail.com>	<x49k37uwbug.fsf@segfault.boston.devel.redhat.com> <CANyhEAvmuj9Lo2by0PbPYbdznYUssugK4=yii4J1KbkoyeENTA@mail.gmail.com>
In-Reply-To: <CANyhEAvmuj9Lo2by0PbPYbdznYUssugK4=yii4J1KbkoyeENTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Yuyang (Alex) Wang" <yyalex.wang@gmail.com>, Jeff Moyer <jmoyer@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/03/2014 12:22 PM, Yuyang (Alex) Wang wrote:
> hi Jeff,
> 
> iodepth doesn't seem to make difference - see output (this is with two
> raid array)
> 
> devices: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=libaio, iodepth=32
> fio-2.1.7
> Starting 1 process
> Jobs: 1 (f=1): [W] [100.0% done] [0KB/1227MB/0KB /s] [0/1227/0 iops]
> [eta 00m:00s]
> devices: (groupid=0, jobs=1): err= 0: pid=91658: Thu Jul  3 14:20:42 2014
>   write: io=41368MB, bw=1376.7MB/s, iops=1376, runt= 30050msec
>     slat (usec): min=104, max=8419, avg=328.49, stdev=63.54
>     clat (usec): min=4, max=114758, avg=22883.96, stdev=8585.56
>      lat (msec): min=2, max=115, avg=23.21, stdev= 8.58
>     clat percentiles (msec):
>      |  1.00th=[   11],  5.00th=[   12], 10.00th=[   12], 20.00th=[   21],
>      | 30.00th=[   23], 40.00th=[   23], 50.00th=[   23], 60.00th=[   25],
>      | 70.00th=[   25], 80.00th=[   26], 90.00th=[   28], 95.00th=[   35],
>      | 99.00th=[   61], 99.50th=[   68], 99.90th=[   80], 99.95th=[   89],
>      | 99.99th=[  110]
>     bw (MB  /s): min=  926, max= 2790, per=100.00%, avg=1376.74, stdev=420.52
>     lat (usec) : 10=0.01%
>     lat (msec) : 4=0.03%, 10=0.39%, 20=19.28%, 50=78.27%, 100=1.99%
>     lat (msec) : 250=0.04%
>   cpu          : usr=30.09%, sys=17.91%, ctx=19628, majf=0, minf=26
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued    : total=r=0/w=41368/d=0, short=r=0/w=0/d=0
>      latency   : target=0, window=0, percentile=100.00%, depth=32
> 
> Run status group 0 (all jobs):
>   WRITE: io=41368MB, aggrb=1376.7MB/s, minb=1376.7MB/s,
> maxb=1376.7MB/s, mint=30050msec, maxt=30050msec

Just tested on a box here, for comparison. It has 16 SCSI disks, each
does roughly 160MB/sec in bandwidth. Adding disks scales bw linearly for
me, no problems observed.

You're submission latency is fairly low, so it should not be a problem
with fio getting stuck in dm on submission. usr+sys is pretty high
though, for such a light workload.

-- 
Jens Axboe


