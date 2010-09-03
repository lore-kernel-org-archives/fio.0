Return-Path: <fio-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:46596 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0ICOoA (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 Sep 2010 10:44:00 -0400
Received: from [10.0.0.3] (91-115-70-44.adsl.highway.telekom.at [91.115.70.44])
	by srv.wefi.net (Postfix) with ESMTP id D254E178337
	for <fio@vger.kernel.org>; Fri,  3 Sep 2010 16:43:57 +0200 (CEST)
Subject: Re: How to measure IOPS
From: Werner Fischer <devlists@wefi.net>
In-Reply-To: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
References: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Sep 2010 16:43:55 +0200
Message-ID: <1283525035.2074.6.camel@wfischer-t410-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Chris,

thanks for your valuable hint.

I have now tried with
    numjobs=1
    iodepth=1
    size= entire size of the drive
    bs=512 (as this is the block size on a HDD, but 4k gave nearly the same results)

I got (see also below):
    randread:  81 IOPS
    randwrite: 76 IOPS

Those numbers now match the range that I had expected.

[root@iotest ~]# fio --filename=/dev/sdd --direct=1 --rw=randread --bs=512 --size=500107862016 --runtime=300 --name=file1
file1: (g=0): rw=randread, bs=512-512/512-512, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [r] [100.0% done] [41K/0K /s] [81/0 iops] [eta 00m:00s]
file1: (groupid=0, jobs=1): err= 0: pid=16443
  read : io=12,435KB, bw=42,443B/s, iops=82, runt=300007msec
    clat (msec): min=1, max=22, avg=12.06, stdev= 3.59
    bw (KB/s) : min=   36, max=   47, per=99.97%, avg=40.99, stdev= 1.98
  cpu          : usr=0.07%, sys=0.55%, ctx=24897, majf=0, minf=3208
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=24870/0, short=0/0

     lat (msec): 2=0.02%, 4=0.81%, 10=28.56%, 20=69.47%, 50=1.14%

Run status group 0 (all jobs):
   READ: io=12,435KB, aggrb=41KB/s, minb=42KB/s, maxb=42KB/s, mint=300007msec, maxt=300007msec

Disk stats (read/write):
  sdd: ios=24858/0, merge=0/0, ticks=299591/0, in_queue=299588, util=100.00%
[root@iotest ~]# fio --filename=/dev/sdd --direct=1 --rw=randwrite --bs=512 --size=500107862016 --runtime=300 --name=file1
file1: (g=0): rw=randwrite, bs=512-512/512-512, ioengine=sync, iodepth=1
Starting 1 process
Jobs: 1 (f=1): [w] [100.0% done] [0K/39K /s] [0/76 iops] [eta 00m:00s]
file1: (groupid=0, jobs=1): err= 0: pid=16498
  write: io=11,560KB, bw=39,456B/s, iops=77, runt=300001msec
    clat (msec): min=1, max=23, avg=12.97, stdev= 3.52
    bw (KB/s) : min=   33, max=   43, per=100.14%, avg=38.05, stdev= 1.83
  cpu          : usr=0.06%, sys=0.53%, ctx=23146, majf=0, minf=2578
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/23119, short=0/0

     lat (msec): 2=0.01%, 4=0.13%, 10=20.87%, 20=76.63%, 50=2.37%

Run status group 0 (all jobs):
  WRITE: io=11,559KB, aggrb=38KB/s, minb=39KB/s, maxb=39KB/s, mint=300001msec, maxt=300001msec

Disk stats (read/write):
  sdd: ios=0/23110, merge=0/0, ticks=0/299565, in_queue=299560, util=100.00%
[root@iotest ~]# 


best regards,
Werner

PS @Chris: I discovered that your and my last message to you haven't
been sent to the list, now I write directly to the list. My first answer
to you was wrong, I only used 500MB (instead of 500GB) as size.

On Wed, 2010-09-01 at 22:08 -0600, Chris Worley wrote: 
> That looks good.  You can play with numjobs, ioengines, and iodepths
> (which I believe only applies to libaio) to find a maximum.
> 
> A valid seek time average should require numjobs and iodepth set to
> one, and, most importantly, the "size" be the entire drive.
> 
> Chris
>
> On Wed, 2010-09-01 at 23:46 +0200, Werner Fischer wrote: 
> > Can you give me a hint what fio parameters you would suggest to measure IOPS?
> > Are the 140 IOPS too high for a 7.200k drive like the one I have?



