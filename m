Return-Path: <axboe@kernel.dk>
Message-ID: <5395D939.5010506@kernel.dk>
Date: Mon, 09 Jun 2014 09:56:41 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: two jobs sometimes ignore time_based=1
References: <20140603210141.GA29246@padd.com>
In-Reply-To: <20140603210141.GA29246@padd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Pete Wyckoff <pw@padd.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-06-03 15:01, Pete Wyckoff wrote:
> Running fio-2.1.9-1-g0aa0 (with one trivial build patch)
> built on debian sid, deployed on centos 6.5.
>
> No command line args, just this one jobfile:
>
>      [global]
>      filename=test/mnt/80g
>      readwrite=randwrite
>      fallocate=none
>      blocksize=32k
>      ioengine=libaio
>      direct=1
>      time_based=1
>
>      [big-random]
>      description=Big random writes, 32k, 80 GB
>      filesize=80g
>      iodepth=8
>      runtime=10
>      write_bw_log=big-random
>      write_lat_log=big-random
>
>      [small-hotspot]
>      description=Small hotspot, 32k, 500 MB
>      filesize=500m
>      iodepth=32
>      runtime=10
>      write_bw_log=small-hotspot
>      write_lat_log=small-hotspot
>
> I want it two run the two jobs concurrently, both exiting after
> 10 seconds regardless of the data volumes written.  The filename
> does not exist when I start fio.
>
> Most of the time it just works, and produces output like this:
>
> unix$ rm test/mnt/80g ; ./fio-2.1.9 jobfile
> big-random: (g=0): rw=randwrite, bs=32K-32K/32K-32K/32K-32K, ioengine=libaio, iodepth=8
> small-hotspot: (g=0): rw=randwrite, bs=32K-32K/32K-32K/32K-32K, ioengine=libaio, iodepth=32
> fio-2.1.9-1-g0aa0
> Starting 2 processes
> big-random: Laying out IO file(s) (1 file(s) / 81920MB)
> small-hotspot: Laying out IO file(s) (1 file(s) / 500MB)
> Jobs: 2 (f=2): [ww] [30.0% done] [0KB/82560KB/0KB /s] [0/2580/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [40.0% done] [0KB/144.4MB/0KB /s] [0/4618/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [50.0% done] [0KB/135.1MB/0KB /s] [0/4351/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [60.0% done] [0KB/162.3MB/0KB /s] [0/5193/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [70.0% done] [0KB/164.4MB/0KB /s] [0/5259/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [80.0% done] [0KB/165.3MB/0KB /s] [0/5288/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [90.0% done] [0KB/100.8MB/0KB /s] [0/3224/0 iops] [eta 00m:0Jobs: 2 (f=2): [ww] [100.0% done] [0KB/26880KB/0KB /s] [0/840/0 iops] [eta 00m:00s]
> big-random: (groupid=0, jobs=1): err= 0: pid=9572: Tue Jun  3 13:55:49 2014
>
> But sometimes it doesn't stop both jobs at 10 seconds.  It seems the
> first one keeps going.
>
> Jobs: 2 (f=2): [ww] [30.0% done] [0KB/158.7MB/0KB /s] [0/5058/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [40.0% done] [0KB/140.6MB/0KB /s] [0/4496/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [50.0% done] [0KB/121.9MB/0KB /s] [0/3900/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [60.0% done] [0KB/165.1MB/0KB /s] [0/5309/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [70.0% done] [0KB/130.3MB/0KB /s] [0/4160/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [80.0% done] [0KB/96480KB/0KB /s] [0/3015/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [90.0% done] [0KB/119.1MB/0KB /s] [0/3839/0 iops] [eta 00m:0
> Jobs: 2 (f=2): [ww] [0.3% done] [0KB/72352KB/0KB /s] [0/2261/0 iops] [eta 55m:26
> Jobs: 1 (f=1): [w_] [57.9% done] [0KB/73536KB/0KB /s] [0/2298/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [63.2% done] [0KB/84384KB/0KB /s] [0/2637/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [68.4% done] [0KB/86208KB/0KB /s] [0/2694/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [73.7% done] [0KB/57446KB/0KB /s] [0/1795/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [78.9% done] [0KB/50432KB/0KB /s] [0/1576/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [84.2% done] [0KB/85600KB/0KB /s] [0/2675/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [89.5% done] [0KB/80480KB/0KB /s] [0/2515/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [94.7% done] [0KB/84192KB/0KB /s] [0/2631/0 iops] [eta 00m:0
> Jobs: 1 (f=1): [w_] [100.0% done] [0KB/85888KB/0KB /s] [0/2684/0 iops] [eta 00m:
> Jobs: 1 (f=1): [w_] [1.1% done] [0KB/53728KB/0KB /s] [0/1679/0 iops] [eta 28m:44
> Jobs: 1 (f=1): [w_] [1.2% done] [0KB/53162KB/0KB /s] [0/1661/0 iops] [eta 28m:35
> Jobs: 1 (f=1): [w_] [1.3% done] [0KB/59908KB/0KB /s] [0/1872/0 iops] [eta 28m:16
> Jobs: 1 (f=1): [w_] [1.3% done] [0KB/37280KB/0KB /s] [0/1165/0 iops] [eta 28m:32
> Jobs: 1 (f=1): [w_] [1.4% done] [0KB/31488KB/0KB /s] [0/984/0 iops] [eta 28m:55s
> Jobs: 1 (f=1): [w_] [1.4% done] [0KB/37888KB/0KB /s] [0/1184/0 iops] [eta 29m:08
> Jobs: 1 (f=1): [w_] [1.5% done] [0KB/51200KB/0KB /s] [0/1600/0 iops] [eta 29m:02
> Jobs: 1 (f=1): [w_] [1.5% done] [0KB/40631KB/0KB /s] [0/1269/0 iops] [eta 29m:10...
>
> There's the first 10 sec chunk with both jobs.  Then a second 10
> sec in there with just job#1, then another half hour of only job#1.
> Looking at the ETAs and average throughput, that's about as long
> as it would take to fill the entire 80 GB disk.
>
> Could it be that fio gets confused about time_based=1, and
> tries to run to completion?  But only sometimes.  This often
> works and I use it for regular testing (at longer runs, like
> 600 sec).

I'll take a look at this, I'm pretty sure it's a recent regression. If 
you were so inclined, would be great if you could check if 2.1.8 or 
2.1.7 were affected and bisect your way to it...

-- 
Jens Axboe


