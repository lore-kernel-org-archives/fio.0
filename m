Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:34459 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3ERB2y (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 17 May 2013 21:28:54 -0400
Received: from /spool/local
	by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ecomar@uk.ibm.com>;
	Sat, 18 May 2013 02:25:11 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 755EF2190056
	for <fio@vger.kernel.org>; Sat, 18 May 2013 02:31:41 +0100 (BST)
Received: from d06av09.portsmouth.uk.ibm.com (d06av09.portsmouth.uk.ibm.com [9.149.37.250])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r4I1Seo249414282
	for <fio@vger.kernel.org>; Sat, 18 May 2013 01:28:40 GMT
Received: from d06av09.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r4I1SoAX024750
	for <fio@vger.kernel.org>; Fri, 17 May 2013 19:28:50 -0600
Received: from d06ml005.portsmouth.uk.ibm.com (d06ml005.portsmouth.uk.ibm.com [9.149.76.131])
	by d06av09.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVin) with ESMTP id r4I1SoLe024747
	for <fio@vger.kernel.org>; Fri, 17 May 2013 19:28:50 -0600
MIME-Version: 1.0
Subject: output - aggregate read bandwitdh 
From: Edoardo Comar <ECOMAR@uk.ibm.com>
Message-ID: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com>
Date: Sat, 18 May 2013 02:28:39 +0100
Content-Type: text/plain; charset="US-ASCII"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I have a problem with fio built today from GIT
running the jobfile below, the aggregate bandwidth for 'read' output by 
the latest fio is excessive
while it seems reasonable with an older fio version.

fio-2.0.13              READ: io=51500KB, aggrb=857KB/s,

fio-2.1-6-g4d01         READ: io=31057MB, aggrb=530017KB/s,


You should easily reproduce this with the data below.
I have reproduced it on my laptop (RHEL 6.4) as well as on other RHEL 
systems.
on my laptop 
  READ: io=13028KB, aggrb=216KB/s,
or
   READ: io=33204MB, aggrb=566519KB/s,

running the same configuration 

I believe this to be a bug.

=========================================
# less four-threads-randio-016.fio 
[global]
size=256m
directory=/mnt/vda2/tmp
invalidate=1
runtime=60
time_based
ramp_time=5
clat_percentiles=0
direct=1

[bgwriter]
rw=randwrite
iodepth=32
ioengine=libaio

[queryA]
rw=randread
ioengine=mmap
thinktime=3

[queryB]
rw=randread
ioengine=mmap
thinktime=5

[bgupdater]
rw=randrw
ioengine=libaio
iodepth=16
size=64m
thinktime=5


# ./fio-2.0.13 four-threads-randio-016.fio
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.0.13
Starting 4 processes
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)
Jobs: 2 (f=2): [w_Em] [52.8% done] [1188K/1828K/0K /s] [297 /457 /0  iops] 
[eta 00m:59s]
bgwriter: (groupid=0, jobs=1): err= 0: pid=3996: Sat May 18 02:10:35 2013
  write: io=89096KB, bw=1482.4KB/s, iops=370 , runt= 60104msec
    slat (usec): min=9 , max=142732 , avg=57.41, stdev=1503.15
    clat (msec): min=1 , max=1157 , avg=86.33, stdev=108.57
     lat (msec): min=1 , max=1157 , avg=86.39, stdev=108.59
    bw (KB/s)  : min=    0, max= 3065, per=68.91%, avg=1485.70, 
stdev=586.92
    lat (msec) : 2=0.27%, 4=4.81%, 10=12.00%, 20=13.52%, 50=21.67%
    lat (msec) : 100=18.53%, 250=21.81%, 500=6.29%, 750=1.08%, 1000=0.15%
    lat (msec) : 2000=0.01%
  cpu          : usr=0.39%, sys=1.48%, ctx=19840, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=108.5%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=22243/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=3997: Sat May 18 02:10:35 2013
  read : io=6744.0KB, bw=115045 B/s, iops=28 , runt= 60027msec
    clat (msec): min=1 , max=640 , avg=35.59, stdev=51.42
     lat (msec): min=1 , max=640 , avg=35.59, stdev=51.42
    bw (KB/s)  : min=    0, max=  261, per=13.19%, avg=113.07, stdev=49.88
    lat (msec) : 2=0.53%, 4=11.21%, 10=25.74%, 20=19.34%, 50=22.24%
    lat (msec) : 100=11.86%, 250=8.24%, 500=0.71%, 750=0.12%
  cpu          : usr=0.07%, sys=0.14%, ctx=1832, majf=1832, minf=28
  IO depths    : 1=108.7%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1686/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=3998: Sat May 18 02:10:35 2013
  read : io=4404.0KB, bw=75152 B/s, iops=18 , runt= 60007msec
    clat (msec): min=1 , max=868 , avg=54.49, stdev=73.56
     lat (msec): min=1 , max=868 , avg=54.49, stdev=73.56
    bw (KB/s)  : min=    0, max=  193, per=8.60%, avg=73.68, stdev=33.09
    lat (msec) : 2=0.27%, 4=5.90%, 10=19.07%, 20=14.99%, 50=25.79%
    lat (msec) : 100=16.62%, 250=14.62%, 500=2.45%, 750=0.18%, 1000=0.09%
  cpu          : usr=0.05%, sys=0.09%, ctx=1167, majf=1167, minf=28
  IO depths    : 1=106.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=1101/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=3999: Sat May 18 02:10:35 2013
  read : io=40352KB, bw=687677 B/s, iops=167 , runt= 60087msec
    slat (usec): min=4 , max=106229 , avg=56.91, stdev=1603.60
    clat (usec): min=83 , max=1022.8K, avg=29250.78, stdev=50020.33
     lat (usec): min=704 , max=1022.2K, avg=29311.02, stdev=50035.27
    bw (KB/s)  : min=    0, max= 1976, per=79.02%, avg=677.21, 
stdev=347.75
  write: io=40500KB, bw=690199 B/s, iops=168 , runt= 60087msec
    slat (usec): min=7 , max=166544 , avg=61.96, stdev=1985.57
    clat (msec): min=1 , max=1340 , avg=65.87, stdev=108.26
     lat (msec): min=1 , max=1340 , avg=65.94, stdev=108.29
    bw (KB/s)  : min=   68, max= 1384, per=31.81%, avg=685.93, 
stdev=321.85
    lat (usec) : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=2.53%, 4=11.45%, 10=24.13%, 20=17.43%, 50=18.92%
    lat (msec) : 100=11.95%, 250=10.65%, 500=2.35%, 750=0.42%, 1000=0.13%
    lat (msec) : 2000=0.08%
  cpu          : usr=0.59%, sys=1.87%, ctx=21168, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=107.9%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.1%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=10084/w=10114/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=51500KB, aggrb=857KB/s, minb=73KB/s, maxb=671KB/s, 
mint=60007msec, maxt=60087msec
  WRITE: io=129596KB, aggrb=2156KB/s, minb=674KB/s, maxb=1482KB/s, 
mint=60087msec, maxt=60104msec

Disk stats (read/write):
  vda: ios=13899/35117, merge=0/1319, ticks=441967/2796528, 
in_queue=3239663, util=99.93%


===============================================================
removing files 
# rm -rf /mnt/vda2/tmp/*

==============================================================
fio-2.1-6-g4d01

# ./fio four-threads-randio-016.fio
bgwriter: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=32
queryA: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
queryB: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=mmap, iodepth=1
bgupdater: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, 
iodepth=16
fio-2.1-6-g4d01
Starting 4 processes
bgwriter: Laying out IO file(s) (1 file(s) / 256MB)
queryA: Laying out IO file(s) (1 file(s) / 256MB)
queryB: Laying out IO file(s) (1 file(s) / 256MB)
bgupdater: Laying out IO file(s) (1 file(s) / 64MB)
Jobs: 4 (f=4): [wrrm] [100.0% done] [514.5MB/3052KB/0KB /s] [132K/763/0 
iops] [eta 00m:00s]
bgwriter: (groupid=0, jobs=1): err= 0: pid=3983: Sat May 18 02:06:43 2013
  write: io=176768KB, bw=2942.8KB/s, iops=735, runt= 60069msec
    slat (usec): min=5, max=104922, avg=33.86, stdev=1148.48
    clat (msec): min=1, max=515, avg=43.50, stdev=45.18
     lat (msec): min=1, max=515, avg=43.54, stdev=45.19
    bw (KB  /s): min=    0, max= 3304, per=98.86%, avg=2927.14, 
stdev=355.37
    lat (msec) : 2=0.37%, 4=5.84%, 10=15.68%, 20=17.56%, 50=29.64%
    lat (msec) : 100=20.39%, 250=10.19%, 500=0.40%, 750=0.01%
  cpu          : usr=0.35%, sys=1.49%, ctx=38606, majf=0, minf=21
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=108.4%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=0/w=44161/d=0, short=r=0/w=0/d=0
queryA: (groupid=0, jobs=1): err= 0: pid=3984: Sat May 18 02:06:43 2013
  read : io=17682MB, bw=301761KB/s, iops=75440, runt= 60001msec
    clat (usec): min=0, max=6221, avg= 4.31, stdev=72.40
     lat (usec): min=1, max=6222, avg= 5.38, stdev=76.02
    bw (KB  /s): min=    0, max=315120, per=56.49%, avg=299399.30, 
stdev=27955.81
    lat (usec) : 2=22.24%, 4=76.97%, 10=0.22%, 20=0.23%, 50=0.05%
    lat (usec) : 100=0.17%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.06%, 4=0.04%, 10=0.01%
  cpu          : usr=19.85%, sys=32.86%, ctx=24374, majf=0, minf=4634040
  IO depths    : 1=108.3%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=4526495/w=0/d=0, short=r=0/w=0/d=0
queryB: (groupid=0, jobs=1): err= 0: pid=3985: Sat May 18 02:06:43 2013
  read : io=13374MB, bw=228239KB/s, iops=57059, runt= 60002msec
    clat (usec): min=0, max=6019, avg= 3.57, stdev=69.08
     lat (usec): min=1, max=6020, avg= 4.65, stdev=73.08
    bw (KB  /s): min=    0, max=237544, per=42.73%, avg=226467.66, 
stdev=21075.51
    lat (usec) : 2=60.11%, 4=39.20%, 10=0.18%, 20=0.21%, 50=0.05%
    lat (usec) : 100=0.15%, 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
    lat (msec) : 2=0.05%, 4=0.04%, 10=0.01%
  cpu          : usr=17.12%, sys=35.60%, ctx=24353, majf=0, minf=3553602
  IO depths    : 1=108.4%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=3423692/w=0/d=0, short=r=0/w=0/d=0
bgupdater: (groupid=0, jobs=1): err= 0: pid=3986: Sat May 18 02:06:43 2013
  read : io=1356.0KB, bw=23141B/s, iops=5, runt= 60002msec
    slat (usec): min=6, max=59176, avg=392.16, stdev=3738.80
    clat (usec): min=3, max=353515, avg=46969.04, stdev=52753.16
     lat (msec): min=1, max=353, avg=47.40, stdev=52.55
    bw (KB  /s): min=    0, max=   86, per=0.00%, avg=24.35, stdev=17.97
  write: io=1132.0KB, bw=19318B/s, iops=4, runt= 60002msec
    slat (usec): min=10, max=62967, avg=617.02, stdev=4925.46
    clat (msec): min=2, max=992, avg=154.51, stdev=171.20
     lat (msec): min=2, max=992, avg=155.21, stdev=170.84
    bw (KB  /s): min=    4, max=   63, per=0.64%, avg=18.95, stdev=11.05
    lat (usec) : 4=0.32%, 1000=0.16%
    lat (msec) : 2=0.16%, 4=4.18%, 10=14.47%, 20=12.38%, 50=19.29%
    lat (msec) : 100=20.42%, 250=18.01%, 500=8.68%, 750=1.13%, 1000=0.80%
  cpu          : usr=0.01%, sys=0.04%, ctx=702, majf=0, minf=22
  IO depths    : 1=110.1%, 2=0.3%, 4=0.6%, 8=1.3%, 16=0.2%, 32=0.0%, 
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
     issued    : total=r=339/w=283/d=0, short=r=0/w=0/d=0

Run status group 0 (all jobs):
   READ: io=31057MB, aggrb=530017KB/s, minb=22KB/s, maxb=301761KB/s, 
mint=60001msec, maxt=60002msec
  WRITE: io=177900KB, aggrb=2961KB/s, minb=18KB/s, maxb=2942KB/s, 
mint=60002msec, maxt=60069msec

Disk stats (read/write):
  vda: ios=375/48235, merge=0/1782, ticks=17222/2117780, in_queue=2136170, 
util=99.91%

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

