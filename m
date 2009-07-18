Return-Path: <richard@rsk.demon.co.uk>
Subject: Re: fio mmap writes much slower than default writes
From: Richard Kennedy <richard@rsk.demon.co.uk>
In-Reply-To: <20090718143955.GJ4148@kernel.dk>
References: <1247751607.2689.63.camel@localhost.localdomain>
	 <20090718061819.GF4148@kernel.dk>
	 <1247925507.2712.11.camel@localhost.localdomain>
	 <20090718143955.GJ4148@kernel.dk>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 15:50:32 +0100
Message-Id: <1247928632.2712.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sat, 2009-07-18 at 16:39 +0200, Jens Axboe wrote:
> On Sat, Jul 18 2009, Richard Kennedy wrote:
> > Disk stats (read/write):
> >   dm-0: ios=3571/9894, merge=0/0, ticks=25884/31650, in_queue=511733, util=96.46%, aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0, aggrutil=0.00%
> 
> If you look at the disk stats, it also shows a considerable amount of
> reads. So I'm guessing that you need pre_read=1 to get the same sort of
> results.
> 
thanks for that. Yes, pre_read is much better.

fio --name=f1 --rw=write --size=300m --pre_read=1
  write: io=300MiB, bw=274MiB/s, iops=70,265, runt=  1093msec

fio --name=f1 --rw=write --size=300m --pre_read=1 --ioengine=mmap
 write: io=300MiB, bw=391MiB/s, iops=100K, runt=   767msec

fio --name=f1 --rw=write --size=300m --ioengine=mmap
  write: io=300MiB, bw=30,837KiB/s, iops=7,709, runt=  9962msec

regards
Richard



