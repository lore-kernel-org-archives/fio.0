Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:51134 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3EQAA4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 May 2013 20:00:56 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ecomar@uk.ibm.com>;
	Fri, 17 May 2013 00:56:41 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7D7EB1B08061
	for <fio@vger.kernel.org>; Fri, 17 May 2013 01:00:52 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r4H00gdE45220006
	for <fio@vger.kernel.org>; Fri, 17 May 2013 00:00:42 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r4H00q9B012031
	for <fio@vger.kernel.org>; Thu, 16 May 2013 18:00:52 -0600
Received: from d06ml005.portsmouth.uk.ibm.com (d06ml005.portsmouth.uk.ibm.com [9.149.76.131])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id r4H00qWP012028
	for <fio@vger.kernel.org>; Thu, 16 May 2013 18:00:52 -0600
MIME-Version: 1.0
Subject: latency measurements when adding thinktime
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OF959B9513.E7C6D2A9-ON80257B6D.00837463-80257B6E.0000140D@uk.ibm.com>
Date: Fri, 17 May 2013 01:00:41 +0100
Content-Type: text/plain; charset="US-ASCII"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi
I am running a very simple randrw workload

if I uncomment the thinktime line, the latencies reported become much 
larger.
It doesn't make senes to me that a lower disk load results in higher 
latencies.

can anyone please tell me if I am wrongly interpreting the output ?
thanks!!

[global]
size=256m
directory=/mnt/vda2/tmp
invalidate=1
runtime=90
clat_percentiles=0
#thinktime=10000

[bgupdater]
rw=randrw
ioengine=libaio
direct=1
iodepth=16


without thinktime (high KB/s) - latency about 11ms (it's an ssd drive)

bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [2788KB/2836KB/0KB /s] [697/709/0 iops] 
[eta 00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=2827: Fri May 17 00:40:18 2013
  read : io=131220KB, bw=2718.5KB/s, iops=679, runt= 48270msec
    slat (usec): min=3, max=22626, avg=25.35, stdev=196.44
    clat (usec): min=68, max=42871, avg=11013.43, stdev=5577.65
     lat (usec): min=337, max=42898, avg=11039.70, stdev=5577.81
    bw (KB  /s): min= 2051, max= 3320, per=99.85%, avg=2713.95, 
stdev=273.34
  write: io=130924KB, bw=2712.4KB/s, iops=678, runt= 48270msec
    slat (usec): min=5, max=22547, avg=27.85, stdev=169.45
    clat (usec): min=792, max=40276, avg=12491.74, stdev=6069.90
     lat (usec): min=806, max=47342, avg=12520.54, stdev=6072.64
    bw (KB  /s): min= 2096, max= 3209, per=99.96%, avg=2710.88, 
stdev=210.73
    lat (usec) : 100=0.01%, 250=0.01%, 500=0.38%, 750=1.75%, 1000=0.50%
    lat (msec) : 2=1.03%, 4=1.02%, 10=46.23%, 20=39.03%, 50=10.06%
  cpu          : usr=1.50%, sys=5.51%, ctx=51567, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=32805/w=32731/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=131220KB, aggrb=2718KB/s, minb=2718KB/s, maxb=2718KB/s, 
mint=48270msec, maxt=48270msec
  WRITE: io=130924KB, aggrb=2712KB/s, minb=2712KB/s, maxb=2712KB/s, 
mint=48270msec, maxt=48270msec

Disk stats (read/write):
  vda: ios=32721/32686, merge=0/30, ticks=359611/407708, in_queue=767361, 
util=99.87%


re-runing after having introduced thinktime=10000
much lower bandwitdh, but 152ms latency !

bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1
Starting 1 process
Jobs: 1 (f=1): [m] [100.0% done] [200KB/192KB/0KB /s] [50/48/0 iops] [eta 
00m:00s]
bgupdater: (groupid=0, jobs=1): err= 0: pid=2833: Fri May 17 00:43:21 2013
  read : io=17768KB, bw=202135B/s, iops=49, runt= 90011msec
    slat (usec): min=6, max=166, avg=29.62, stdev=15.64
    clat (usec): min=632, max=157715, avg=152132.61, stdev=5965.84
     lat (usec): min=797, max=157744, avg=152163.37, stdev=5965.66
    bw (KB  /s): min=  102, max=  276, per=99.84%, avg=196.68, stdev=27.96
  write: io=17720KB, bw=201589B/s, iops=49, runt= 90011msec
    slat (usec): min=8, max=164, avg=34.02, stdev=16.60
    clat (msec): min=20, max=157, avg=152.23, stdev= 4.09
     lat (msec): min=20, max=157, avg=152.27, stdev= 4.09
    bw (KB  /s): min=  118, max=  291, per=100.00%, avg=196.23, 
stdev=27.95
    lat (usec) : 750=0.01%
    lat (msec) : 20=0.02%, 50=0.07%, 100=0.11%, 250=99.79%
  cpu          : usr=0.12%, sys=0.36%, ctx=8891, majf=0, minf=24
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=99.8%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4442/w=4430/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=17768KB, aggrb=197KB/s, minb=197KB/s, maxb=197KB/s, 
mint=90011msec, maxt=90011msec
  WRITE: io=17720KB, aggrb=196KB/s, minb=196KB/s, maxb=196KB/s, 
mint=90011msec, maxt=90011msec

Disk stats (read/write):
  vda: ios=4441/4488, merge=0/34, ticks=2965/8118, in_queue=11083, 
util=11.64%

--------------------------------------------------
regards,
Edoardo Comar
WebSphere Application Service Platform for Networks (ASPN)
ecomar@uk.ibm.com
+44 (0)1962 81 5576 
IBM UK Ltd, Hursley Park, SO21 2JN

Unless stated otherwise above:
IBM United Kingdom Limited - Registered in England and Wales with number 
741598. 
Registered office: PO Box 41, North Harbour, Portsmouth, Hampshire PO6 3AU

