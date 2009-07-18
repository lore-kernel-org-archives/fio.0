Return-Path: <richard@rsk.demon.co.uk>
Subject: Re: fio mmap writes much slower than default writes
From: Richard Kennedy <richard@rsk.demon.co.uk>
In-Reply-To: <20090718061819.GF4148@kernel.dk>
References: <1247751607.2689.63.camel@localhost.localdomain>
	 <20090718061819.GF4148@kernel.dk>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 14:58:27 +0100
Message-Id: <1247925507.2712.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sat, 2009-07-18 at 08:18 +0200, Jens Axboe wrote:
> On Thu, Jul 16 2009, Richard Kennedy wrote:
> > Running tests of fio write with sizes that are less than the write cache
> > size I'm seeing a big slow down when using mmap. I'm running the tests
> > on linux 2.6.31-rc* x86_64. 
> > 
> > Typical results with default writes :- 
> > 
> > fio size=300m rw=write 
> >   write: io=300MiB, bw=314MiB/s, iops=80,418, runt= 955msec
> > 
> > with mmap :- 
> > 
> > fio size=300m rw=write ioengine=mmap
> >  write: io=300MiB, bw=55,732KiB/s, iops=13,933, runt= 5512msec
> > 
> > 
> > Is this expected or is it indicative of a problem somewhere?
> 
> What does the full job file look like? Is the file cached, or are the
> faults reading in data?
> 
Hi Jens,
My machine has 3g of memory so it should all fit into cache.
here is the full output from the tests.

I get the same sort of results from 200m,300m,400m. I run each test 5
times and get average speeds of approx 300m on default writes & only 60m
on mmap. I use the same test harness for each test so they should be
comparable, but I'll re-check them to make sure.

Would oprofile tell us anything interesting?

Is there anything else you'd like to know?

regards
Richard


mmap
----------
f1: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=mmap, iodepth=1
f1: (groupid=0, jobs=1): err= 0: pid=3404
  write: io=300MiB, bw=55,732KiB/s, iops=13,933, runt=  5512msec
    clat (usec): min=0, max=0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=    0, max=62200, per=95.02%, avg=52957.91, stdev=18235.16
  cpu          : usr=8.86%, sys=17.64%, ctx=1540, majf=1, minf=76828
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/76800, short=0/0
     lat (usec): 10=67.71%, 20=29.46%, 50=1.01%, 100=0.02%, 250=0.04%
     lat (usec): 500=0.02%, 750=0.05%, 1000=0.06%
     lat (msec): 2=0.22%, 4=1.07%, 10=0.32%, 20=0.02%, 50=0.01%
     lat (msec): 100=0.01%

Run status group 0 (all jobs):
  WRITE: io=300MiB, aggrb=55,735KiB/s, minb=55,735KiB/s, maxb=55,735KiB/s, mint=5512msec, maxt=5512msec

Disk stats (read/write):
  dm-0: ios=3571/9894, merge=0/0, ticks=25884/31650, in_queue=511733, util=96.46%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=nan%
----------
default writes 
f1: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
f1: (groupid=0, jobs=1): err= 0: pid=5097
  write: io=300MiB, bw=314MiB/s, iops=80,418, runt=   955msec
    clat (usec): min=0, max=0, avg= 0.00, stdev= 0.00
    bw (KiB/s) : min=    0, max=359672, per=55.85%, avg=179836.00, stdev=254326.51
  cpu          : usr=9.54%, sys=88.89%, ctx=85, majf=0, minf=30
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/76800, short=0/0
     lat (usec): 10=93.05%, 20=6.76%, 50=0.15%, 100=0.02%, 250=0.02%
     lat (usec): 500=0.01%, 750=0.01%
     lat (msec): 4=0.01%

Run status group 0 (all jobs):
  WRITE: io=300MiB, aggrb=314MiB/s, minb=314MiB/s, maxb=314MiB/s, mint=955msec, maxt=955msec

Disk stats (read/write):
  dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
    sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=nan%





