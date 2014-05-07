Return-Path: <fio-owner@vger.kernel.org>
Received: from blu0-omc1-s36.blu0.hotmail.com ([65.55.116.47]:28097 "EHLO
	blu0-omc1-s36.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbaEGHu5 (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 7 May 2014 03:50:57 -0400
Message-ID: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl>
Date: Wed, 7 May 2014 09:45:49 +0200
From: Kim Holmebakken <kim.holmebakken@hotmail.com>
MIME-Version: 1.0
Subject: Fio giving iops results that are equal to RAM speeds
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hey,

Im currently working on a bachelor thesis where I need to measure iops 
on my storage solution.

I have set up a "frontend" server(ubuntu server 13.10) which has zfs on 
linux running, and is connected to an iSCSI RAID(SAN).

When I use this command:

fio --directory=/pool  --size=128M --direct=0 --fallocate=none 
--rw=randrw --refill_buffers --norandommap --randrepeat=0 
--ioengine=sync --bs=4k --rwmixread=100 --iodepth=16 --numjobs=16 
--runtime=60 --group_reporting --name=4krandreadtest

I get:

4krandreadtest: (groupid=0, jobs=16): err= 0: pid=4101
   read : io=2048.0MB, bw=2158.7MB/s, iops=552463 , runt=   949msec
     clat (usec): min=4 , max=23125 , avg=26.15, stdev=346.02
      lat (usec): min=4 , max=23125 , avg=26.28, stdev=346.07
     clat percentiles (usec):
      |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    8],
      | 30.00th=[    9], 40.00th=[    9], 50.00th=[    9], 60.00th=[   10],
      | 70.00th=[   11], 80.00th=[   12], 90.00th=[   16], 95.00th=[   19],
      | 99.00th=[   35], 99.50th=[  133], 99.90th=[ 5664], 99.95th=[ 8160],
      | 99.99th=[14528]
     bw (KB/s)  : min=114424, max=159840, per=6.09%, avg=134474.12, 
stdev=13435.6
7
     lat (usec) : 10=51.38%, 20=44.19%, 50=3.71%, 100=0.15%, 250=0.19%
     lat (usec) : 500=0.06%, 750=0.03%, 1000=0.02%
     lat (msec) : 2=0.05%, 4=0.08%, 10=0.12%, 20=0.03%, 50=0.01%
   cpu          : usr=5.76%, sys=37.95%, ctx=5049, majf=0, minf=409
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%

  read : io=2048.0MB, bw=2158.7MB/s, iops=552463 , runt=   949msec
     clat (usec): min=4 , max=23125 , avg=26.15, stdev=346.02
      lat (usec): min=4 , max=23125 , avg=26.28, stdev=346.07
     clat percentiles (usec):
      |  1.00th=[    5],  5.00th=[    5], 10.00th=[    6], 20.00th=[    8],
      | 30.00th=[    9], 40.00th=[    9], 50.00th=[    9], 60.00th=[   10],
      | 70.00th=[   11], 80.00th=[   12], 90.00th=[   16], 95.00th=[   19],
      | 99.00th=[   35], 99.50th=[  133], 99.90th=[ 5664], 99.95th=[ 8160],
      | 99.99th=[14528]
     bw (KB/s)  : min=114424, max=159840, per=6.09%, avg=134474.12, 
stdev=13435.6
7
     lat (usec) : 10=51.38%, 20=44.19%, 50=3.71%, 100=0.15%, 250=0.19%
     lat (usec) : 500=0.06%, 750=0.03%, 1000=0.02%
     lat (msec) : 2=0.05%, 4=0.08%, 10=0.12%, 20=0.03%, 50=0.01%
   cpu          : usr=5.76%, sys=37.95%, ctx=5049, majf=0, minf=409
   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
 >=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
 >=64=0.0%
      issued    : total=r=524288/w=0/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
    READ: io=2048.0MB, aggrb=2158.7MB/s, minb=2158.7MB/s, 
maxb=2158.7MB/s, mint=9
49msec, maxt=949msec

These values are extremly high and I suspect that these are the RAM 
speed being returned to me.

Is there anyway to get a more realistic result?

Thanks in advance,
Kim Holmebakken

