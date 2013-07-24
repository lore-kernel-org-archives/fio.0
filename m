Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:53363 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab3GXUWL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Jul 2013 16:22:11 -0400
Received: by mail-lb0-f180.google.com with SMTP id t13so862640lbd.11
        for <fio@vger.kernel.org>; Wed, 24 Jul 2013 13:22:09 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Jul 2013 13:22:09 -0700
Message-ID: <CAF+0mvm8_89BhXRcs46d-AzyGunuVy3E32dcYi=kGThQkhAgfg@mail.gmail.com>
Subject: Weird trim test results
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi guys,

I'm using this simple trim test on a raw SSD but getting very low
performance.  Bandwidth seems to be tied to the block size.  Am I
doing something wrong?

[trim]
rw=randtrim
bs=4k
ioengine=sync
filename=/dev/sdb
runtime=30

trim: (g=0): rw=randtrim, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [d] [100.0% done] [0KB/0KB/400KB /s] [0/0/100 iops] [eta 00m:00s]
trim: (groupid=0, jobs=1): err= 0: pid=4616: Wed Jul 24 12:54:10 2013
  trim: io=11996KB, bw=409408B/s, iops=99, runt= 30004msec
    clat (usec): min=4597, max=20401, avg=9999.91, stdev=431.52
     lat (usec): min=4597, max=20401, avg=10000.15, stdev=431.53
    clat percentiles (usec):
     |  1.00th=[ 8768],  5.00th=[ 9920], 10.00th=[10048], 20.00th=[10048],
     | 30.00th=[10048], 40.00th=[10048], 50.00th=[10048], 60.00th=[10048],
     | 70.00th=[10048], 80.00th=[10048], 90.00th=[10048], 95.00th=[10048],
     | 99.00th=[11328], 99.50th=[11328], 99.90th=[14912], 99.95th=[20096],
     | 99.99th=[20352]
    bw (KB  /s): min=  385, max=  401, per=100.00%, avg=399.76, stdev= 1.99
    lat (msec) : 10=84.06%, 20=15.87%, 50=0.07%
  cpu          : usr=0.11%, sys=0.12%, ctx=2999, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=0/d=2999, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   TRIM: io=11996KB, aggrb=399KB/s, minb=399KB/s, maxb=399KB/s,
mint=30004msec, maxt=30004msec

Disk stats (read/write):
  sdb: ios=84/2988, merge=0/0, ticks=4/29832, in_queue=29840, util=99.47%
