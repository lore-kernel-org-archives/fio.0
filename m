Return-Path: <fio-owner@vger.kernel.org>
Received: from srv.wefi.net ([80.66.32.76]:39303 "EHLO srv.wefi.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755630Ab0IAWRx (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Sep 2010 18:17:53 -0400
Received: from [10.0.0.2] (88-117-97-177.adsl.highway.telekom.at [88.117.97.177])
	by srv.wefi.net (Postfix) with ESMTP id D7E261D8744
	for <fio@vger.kernel.org>; Wed,  1 Sep 2010 23:46:34 +0200 (CEST)
Subject: How to measure IOPS
From: Werner Fischer <devlists@wefi.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 23:46:34 +0200
Message-ID: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I'm new to fio and I try to measure IOPS, especially write IOPS for a
device. I have a Western Digital WD5002ABYS-01B1B0 as /dev/sdd - details
see http://www.wdc.com/en/products/products.asp?driveid=489

I try to run
   fio --filename=/dev/sdd --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=64 --runtime=10 --group_reporting --name=file1
(taken from http://kb.fusionio.com/KB/a29/verifying-linux-system-performance.aspx)

In this way, fio reports 140 IOPS (with disk cache being off of course):

[root@iotest ~]# hdparm -W0 /dev/sdd

/dev/sdd:
 setting drive write-caching to 0 (off)
[root@iotest ~]# fio --filename=/dev/sdd --direct=1 --rw=randwrite --bs=4k --size=5G --numjobs=64 --runtime=10 --group_reporting --name=file1
file1: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
...
file1: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
Starting 64 processes
Jobs: 1 (f=1): [_______________________________________Ew_______________________] [1.9% done] [0K/547K /s] [0/133 iops] [eta 10m:19s]  s]
file1: (groupid=0, jobs=64): err= 0: pid=5894
  write: io=5,876KB, bw=564KB/s, iops=140, runt= 10420msec
    clat (msec): min=6, max=517, avg=461.75, stdev= 5.53
    bw (KB/s) : min=    7, max=   52, per=1.42%, avg= 8.00, stdev= 0.05
  cpu          : usr=0.02%, sys=0.00%, ctx=1485, majf=0, minf=1333
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued r/w: total=0/1469, short=0/0

     lat (msec): 10=0.27%, 20=0.14%, 50=0.68%, 100=1.36%, 250=4.63%
     lat (msec): 500=82.98%, 750=9.94%

Run status group 0 (all jobs):
  WRITE: io=5,876KB, aggrb=563KB/s, minb=577KB/s, maxb=577KB/s, mint=10420msec, maxt=10420msec

Disk stats (read/write):
  sdd: ios=0/1467, merge=0/1, ticks=0/651445, in_queue=651760, util=99.16%
[root@iotest ~]# 


In the past I simply used dd to get a number for the IO latency, which I
then computed to IOPS (again disk cache is off):

[root@iotest ~]# dd if=/dev/zero of=/dev/sdd bs=512 count=1000 oflag=direct
1000+0 records in
1000+0 records out
512000 bytes (512 kB) copied, 8.34006 seconds, 61.4 kB/s
[root@iotest ~]# dd if=/dev/zero of=/dev/sdd bs=4k count=1000 oflag=direct
1000+0 records in
1000+0 records out
4096000 bytes (4.1 MB) copied, 8.34434 seconds, 491 kB/s
[root@iotest ~]#

This means 8.3ms for a single access -> 1/0.0083s = 120,5 IOPS

fio reports me 140 IOPS (nearly 20% more), which would mean 7.14ms for a
single access (which is less than WD states for their read seek time)


Can you give me a hint what fio parameters you would suggest to measure IOPS?
Are the 140 IOPS too high for a 7.200k drive like the one I have?

Thanks and best regards,
Werner


PS: I'm using fio 1.41 under CentOS 5 (64 Bit)
-- 
: Werner Fischer


