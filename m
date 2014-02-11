Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <52F95D7B.1000002@kernel.dk>
References: <20140206192135.GB3950@kernel.dk>
	<CAF+0mvnBvLVqijP+Atbh9SEjt0p6-e3hy4Q3QRMtb+swp72bTQ@mail.gmail.com>
	<20140209205744.GB2750@kernel.dk>
	<CAF+0mvk+h3Hb5-KyQr7fqfmrUN6V4-HvKx4M0AYHC6mTUQu0+Q@mail.gmail.com>
	<20140210221420.GD4096@kernel.dk>
	<CAF+0mvmhEBaYSmLh99MST9MCg3rHan339rQkQb2Nw3fvStUfTg@mail.gmail.com>
	<52F95D7B.1000002@kernel.dk>
Date: Mon, 10 Feb 2014 16:00:12 -0800
Message-ID: <CAF+0mvkg4sD4r75G6+warH0UtMOzYWm29-=MVQx5MDGiRk3sPA@mail.gmail.com>
Subject: Re: Fio 2.1.5 release upcoming
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 10, 2014 at 3:15 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> To be honest I'm not sure how to apply a patch.  Thus far I have only
>> used release versions of fio.  Do I need to get fio from git, apply
>> the patch, and then compile?
>
>
> The easiest would be:
>
> $ git clone git://git.kernel.dk/fio
>
> Then save the patch from mail in a file, eg /tmp/patch. Then do:
>
> $ cd fio
> $ patch -p1 --dry-run < /tmp/patch
>
> If the patch command spews any errors, the most likely explanation is that
> your mailer mangled it somehow. You can try and add -l and see if that makes
> patch happier, it'll ignore white space then.
>
> Assuming that worked, just do:
>
> $ ./configure
> $ make
>
> and re-run with ./fio and your job file.
>
> --
> Jens Axboe

Jens, thanks a lot for your help.  Here is the output from fio from
git + your patch.  Looks correct except that write io should be 1024
MB instead of 1000 MB?

job: (g=0): rw=write, bs=1M-1M/1M-1M/1M-1M, ioengine=sync, iodepth=1
fio-2.1.4-48-gea66
Starting 1 process
job: Laying out IO file(s) (50 file(s) / 1024MB)
Jobs: 1 (f=10)
job: (groupid=0, jobs=1): err= 0: pid=7286: Mon Feb 10 15:56:16 2014
  write: io=1000.0MB, bw=546425KB/s, iops=533, runt=  1874msec
    clat (usec): min=331, max=18665, avg=1845.86, stdev=3825.28
     lat (usec): min=342, max=18676, avg=1861.42, stdev=3825.89
    clat percentiles (usec):
     |  1.00th=[  338],  5.00th=[  346], 10.00th=[  354], 20.00th=[  378],
     | 30.00th=[  430], 40.00th=[  438], 50.00th=[  466], 60.00th=[  628],
     | 70.00th=[  652], 80.00th=[  668], 90.00th=[ 9152], 95.00th=[13120],
     | 99.00th=[14784], 99.50th=[15424], 99.90th=[18304], 99.95th=[18560],
     | 99.99th=[18560]
    bw (KB  /s): min=374784, max=999424, per=100.00%, avg=585045.33,
stdev=358875.60
    lat (usec) : 500=52.90%, 750=35.60%
    lat (msec) : 10=2.70%, 20=8.80%
  cpu          : usr=4.38%, sys=24.07%, ctx=250, majf=0, minf=33
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=1000/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=1000.0MB, aggrb=546424KB/s, minb=546424KB/s,
maxb=546424KB/s, mint=1874msec, maxt=1874msec

