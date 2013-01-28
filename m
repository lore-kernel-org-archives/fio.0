Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:53298 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab3A1Xcv convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 28 Jan 2013 18:32:51 -0500
Received: from vmwexceht01-prd.hq.netapp.com (vmwexceht01-prd.hq.netapp.com [10.106.76.239])
	by smtp2.corp.netapp.com (8.13.1/8.13.1/NTAP-1.6) with ESMTP id r0SNWoth013937
	for <fio@vger.kernel.org>; Mon, 28 Jan 2013 15:32:50 -0800 (PST)
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Group reporting with latency and IOPS
Date: Mon, 28 Jan 2013 23:32:49 +0000
Message-ID: <843E15216120C047928F6879B0E2D9240F6D006F@SACEXCMBX02-PRD.hq.netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I just need a help to make sure I understood correctly the report (see below --Output). 

Trying to generate 80% Read and 20% Write - 8KB block size

Reads
IOPS: 15330
Latency: (clat) 628usecs - 0.628ms

Writes
IOPS: 3827
Latency: (clat) 577usecs - 0.577ms

Am I doing the correct analysis?

One question is: Is it possible to have global IOPS and latency?

All the best

neto


-- Config file (Windows)

[workload]
bs=8k
ioengine=windowsaio
iodepth=4
size=10g
numjobs=3
direct=1
runtime=30
filename=\\.\PhysicalDrive1
filename=\\.\PhysicalDrive2
filename=\\.\PhysicalDrive3
filename=\\.\PhysicalDrive5
filename=\\.\PhysicalDrive6
filename=\\.\PhysicalDrive7
rw=randrw
rwmixread=80
rwmixwrite=20
thread
group_reporting


-- Output

workload: (groupid=0, jobs=3): err= 0: pid=2096: Mon Jan 28 18:23:32 2013
  read : io=3594.7MB, bw=122645KB/s, iops=15330 , runt= 30008msec
    slat (usec): min=2 , max=2263 , avg= 5.92, stdev= 4.05
    clat (usec): min=128 , max=51478 , avg=628.97, stdev=789.58
     lat (usec): min=134 , max=51482 , avg=634.89, stdev=789.56
    clat percentiles (usec):
     |  1.00th=[  169],  5.00th=[  185], 10.00th=[  195], 20.00th=[  213],
     | 30.00th=[  237], 40.00th=[  306], 50.00th=[  572], 60.00th=[  756],
     | 70.00th=[  796], 80.00th=[  868], 90.00th=[  988], 95.00th=[ 1224],
     | 99.00th=[ 2640], 99.50th=[ 4832], 99.90th=[13376], 99.95th=[15040],
     | 99.99th=[15936]
    bw (KB/s)  : min=17280, max=48528, per=33.37%, avg=40921.04, stdev=6090.31
  write: io=918768KB, bw=30617KB/s, iops=3827 , runt= 30008msec
    slat (usec): min=3 , max=2260 , avg= 7.34, stdev= 6.94
    clat (usec): min=262 , max=19853 , avg=577.21, stdev=629.07
     lat (usec): min=271 , max=19862 , avg=584.54, stdev=629.35
    clat percentiles (usec):
     |  1.00th=[  338],  5.00th=[  378], 10.00th=[  402], 20.00th=[  434],
     | 30.00th=[  458], 40.00th=[  482], 50.00th=[  502], 60.00th=[  532],
     | 70.00th=[  564], 80.00th=[  620], 90.00th=[  732], 95.00th=[  812],
     | 99.00th=[ 1304], 99.50th=[ 2768], 99.90th=[12224], 99.95th=[15168],
     | 99.99th=[15680]
    bw (KB/s)  : min= 4080, max=12368, per=33.36%, avg=10213.68, stdev=1566.17
    lat (usec) : 250=26.81%, 500=21.78%, 750=16.54%, 1000=26.96%
    lat (msec) : 2=6.67%, 4=0.69%, 10=0.37%, 20=0.18%, 50=0.01%
    lat (msec) : 100=0.01%
  cpu          : usr=3.33%, sys=16.67%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=460040/w=114846/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=3594.7MB, aggrb=122644KB/s, minb=122644KB/s, maxb=122644KB/s, mint=3
0008msec, maxt=30008msec
  WRITE: io=918768KB, aggrb=30617KB/s, minb=30617KB/s, maxb=30617KB/s, mint=3000
8msec, maxt=30008msec






