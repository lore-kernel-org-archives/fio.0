Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.ujep.cz ([195.113.141.246]:47423 "EHLO smtp.ujep.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbZJSKOS (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 19 Oct 2009 06:14:18 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp.ujep.cz (Postfix) with ESMTP id 598A4A0000AF
	for <fio@vger.kernel.org>; Mon, 19 Oct 2009 11:47:48 +0200 (CEST)
Received: from smtp.ujep.cz ([127.0.0.1])
	by localhost (smtp.ujep.cz [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YSKgHxIHvHKm for <fio@vger.kernel.org>;
	Mon, 19 Oct 2009 11:47:39 +0200 (CEST)
Received: from norraena.ujep.cz (norraena.ujep.cz [195.113.136.29])
	by smtp.ujep.cz (Postfix) with ESMTP id BEDC3A000095
	for <fio@vger.kernel.org>; Mon, 19 Oct 2009 11:47:39 +0200 (CEST)
Date: Mon, 19 Oct 2009 11:46:48 +0200 (CEST)
From: Polish <pavel.polacek@ujep.cz>
Subject: odd final report
Message-ID: <alpine.DEB.1.10.0910191129100.11404@q4.ujep.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

 	Hi all,

   I think that fio don't create correct final report with big files ( long 
time job ). I have tried standard iometer-file-access-server with two different 
sizes (16GB and 58GB). During benchmark fio returns same iops 
performance, but final reports differ. Below is test with raid6 and 
raid10 configuration, odd is both.

   Linux machine - dom0 of testing xencitrix server
#uname -a
Linux citron2 2.6.18-128.1.6.el5.xs5.5.0.496.1012xen #1 SMP Fri May 29 
07:35:00 EDT 2009 i686 i686 i386 GNU/Linux

   Fio version
I have tested on two versions : 1.31 and 1.34.2


   RAID6 CONFIGURATION

   Performance during benchmark process
[root@citron2 raid6]# /root/fio --output 
/root/single_raid6_15rpm_15x_fc_druhy /root/iometer-file-access-server
Starting 1 process
Jobs: 1 (f=1): [m] [2.0% done] [32M/8,061K /s] [3K/748 iops] [eta 
21m:22s]]
Jobs: 1 (f=1): [m] [4.0% done] [23M/6,081K /s] [2K/507 iops] [eta 26m:26s]
Jobs: 1 (f=1): [m] [10.0% done] [23M/5,251K /s] [2K/578 iops] [eta 
28m:55s]
Jobs: 1 (f=1): [m] [15.2% done] [23M/5,327K /s] [2K/572 iops] [eta 
28m:27s]
Jobs: 1 (f=1): [m] [26.2% done] [24M/6,159K /s] [2K/589 iops] [eta 
26m:03s]
Jobs: 1 (f=1): [m] [33.8% done] [21M/5,220K /s] [2K/599 iops] [eta 
24m:00s]
Jobs: 1 (f=1): [m] [40.0% done] [18M/5,213K /s] [2K/570 iops] [eta 
22m:11s]
Jobs: 1 (f=1): [m] [54.7% done] [16M/5,181K /s] [2K/638 iops] [eta 
17m:34s]
Jobs: 1 (f=1): [m] [68.3% done] [16M/4,021K /s] [2K/564 iops] [eta 
12m:53s]
Jobs: 1 (f=1): [m] [77.8% done] [16M/3,712K /s] [2K/574 iops] [eta 
09m:22s]
Jobs: 1 (f=1): [m] [90.6% done] [14M/3,711K /s] [2K/627 iops] [eta 
04m:10s]
Jobs: 1 (f=1): [m] [97.1% done] [12M/3,341K /s] [2K/609 iops] [eta 
01m:20s]
Jobs: 1 (f=1): [m] [99.5% done] [12M/3,223K /s] [2K/575 iops] [eta 
00m:13s]
Jobs: 1 (f=1): [m] [100.0% done] [13M/3,489K /s] [2K/622 iops] [eta 
00m:00s]


   CONFIGURATION OF JOB

vi /root/iometer-file-access-server
# This job file tries to mimic the Intel IOMeter File Server Access 
Pattern
[global]
description=Emulation of Intel IOmeter File Server Access Pattern

[iometer]
bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
rw=randrw
rwmixread=80
direct=1
size=58g
ioengine=libaio
# IOMeter defines the server loads as the following:
# iodepth=1     Linear
# iodepth=4     Very Light
# iodepth=8     Light
# iodepth=64    Moderate
# iodepth=256   Heavy
iodepth=64


   RESULT WITH 60GB iometer file

less /root/single_raid6_15rpm_15x_fc_druhy
iometer: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=libaio, iodepth=64
iometer: (groupid=0, jobs=1): err= 0: pid=31246
   Description  : [Emulation of Intel IOmeter File Server Access Pattern]
   read : io=2,435MB, bw=17,697KB/s, iops=757, runt=2747922msec
     slat (usec): min=3, max=17,011, avg=10.81, stdev=28.38
     clat (usec): min=163, max=371K, avg=26898.29, stdev=21238.03
     bw (KB/s) : min=10069, max=45530, per=100.07%, avg=17709.91, 
stdev=4099.04
   write: io=3,709MB, bw=4,435KB/s, iops=581, runt=2747922msec
     slat (usec): min=4, max=17,413, avg=10.90, stdev=35.09
     clat (usec): min=56, max=117K, avg=2650.21, stdev=2161.00
     bw (KB/s) : min= 2098, max=13994, per=100.10%, avg=4438.49, 
stdev=1075.34
   cpu          : usr=0.14%, sys=0.40%, ctx=7472872, majf=0, minf=74370
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
>=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, 
>=64=0.0%
      issued r/w: total=6375892/1596949, short=0/0
      lat (usec): 100=0.01%, 250=0.01%, 500=0.11%, 750=0.94%, 1000=1.44%
      lat (msec): 2=6.81%, 4=8.56%, 10=16.93%, 20=24.08%, 50=31.05%
      lat (msec): 100=9.15%, 250=0.91%, 500=0.01%

Run status group 0 (all jobs):
    READ: io=47,491MB, aggrb=17,697KB/s, minb=18,122KB/s, maxb=18,122KB/s, 
mint=2747922msec, maxt=2747922msec
   WRITE: io=11,901MB, aggrb=4,434KB/s, minb=4,541KB/s, maxb=4,541KB/s, 
mint=2747922msec, maxt=2747922msec

Disk stats (read/write):
   sdb: ios=6384913/1600300, merge=34909/9275, ticks=171751890/4226470, 
in_queue=175980330, util=100.00%


   RESULT WITH 16GB iometer file

less raid6_15rpm_15x_fc.txt
iometer: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=libaio, iodepth=64
iometer: Laying out IO file(s) (1 file(s) / 16384MiB)
iometer: (groupid=0, jobs=1): err= 0: pid=28886
   Description  : [Emulation of Intel IOmeter File Server Access Pattern]
   read : io=13,096MiB, bw=16,212KiB/s, iops=2,121, runt=827148msec
     slat (usec): min=3, max=120K, avg=30.15, stdev=499.25
     clat (usec): min=264, max=1,664K, avg=28762.65, stdev=28831.93
     bw (KiB/s) : min=  120, max=39461, per=100.22%, avg=16248.38, 
stdev=4143.11
   write: io=3,289MiB, bw=4,071KiB/s, iops=531, runt=827148msec
     slat (usec): min=3, max=166K, avg=30.39, stdev=531.82
     clat (usec): min=384, max=1,659K, avg=5256.33, stdev=15408.85
     bw (KiB/s) : min=    0, max= 9089, per=100.35%, avg=4085.26, 
stdev=1064.40
   cpu          : usr=0.41%, sys=1.21%, ctx=2044095, majf=0, minf=547225
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
>=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, 
>=64=0.0%
      issued r/w: total=1754990/439732, short=0/0
      lat (usec): 500=0.01%, 750=0.24%, 1000=0.80%
      lat (msec): 2=5.94%, 4=8.23%, 10=18.60%, 20=25.19%, 50=29.41%
      lat (msec): 100=9.30%, 250=2.18%, 500=0.09%, 750=0.01%, 1000=0.01%
      lat (msec): 2000=0.01%

Run status group 0 (all jobs):
    READ: io=13,096MiB, aggrb=16,212KiB/s, minb=16,212KiB/s, 
maxb=16,212KiB/s, mint=827148msec, maxt=827148msec
   WRITE: io=3,289MiB, aggrb=4,071KiB/s, minb=4,071KiB/s, maxb=4,071KiB/s, 
mint=827148msec, maxt=827148msec

Disk stats (read/write):
   sdb: ios=1764382/440805, merge=9374/2590, ticks=46590230/1716300, 
in_queue=48308070, util=97.74%

=======================================================================
   RAID10 CONFIGURATION

   Performance during benchmark process
[root@citron2 raid10]# /root/fio --output 
/root/single_raid10_15rpm_12x_fc_druhy /root/iometer-file-access-server
Starting 1 process
Jobs: 1 (f=1): [m] [24.8% done] [24M/6,314K /s] [3K/647 iops] [eta 
26m:41s]
Jobs: 1 (f=1): [m] [38.2% done] [22M/5,538K /s] [3K/615 iops] [eta 
21m:58s]
Jobs: 1 (f=1): [m] [46.1% done] [22M/4,993K /s] [3K/634 iops] [eta 
19m:25s]
Jobs: 1 (f=1): [m] [60.4% done] [19M/5,137K /s] [3K/680 iops] [eta 
14m:47s]
Jobs: 1 (f=1): [m] [75.7% done] [17M/4,400K /s] [3K/677 iops] [eta 
09m:31s]
Jobs: 1 (f=1): [m] [85.1% done] [16M/3,726K /s] [3K/671 iops] [eta 
06m:03s]
Jobs: 1 (f=1): [m] [91.1% done] [15M/4,016K /s] [3K/670 iops] [eta 
03m:40s]
Jobs: 1 (f=1): [m] [98.0% done] [14M/4,064K /s] [3K/687 iops] [eta 
00m:50s]
Jobs: 1 (f=1): [m] [100.0% done] [15M/3,738K /s] [3K/691 iops] [eta 
00m:00s]
[root@citron2 raid10]#

iometer-file-access-server job is same as raid6

   RESULT WITH 60GB iometer file
less /root/single_raid10_15rpm_12x_fc_druhy
iometer: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=libaio, iodepth=64
iometer: (groupid=0, jobs=1): err= 0: pid=27814
   Description  : [Emulation of Intel IOmeter File Server Access Pattern]
   read : io=49,177MiB, bw=19,630KiB/s, iops=897, runt=2565301msec
     slat (usec): min=3, max=95,831, avg=19.44, stdev=267.96
     clat (msec): min=1, max=1,191, avg=21.86, stdev=12.56
     bw (KiB/s) : min=  152, max=36934, per=100.09%, avg=19648.17, 
stdev=4825.58
   write: io=12,263MiB, bw=4,895KiB/s, iops=643, runt=2565301msec
     slat (usec): min=3, max=30,301, avg=20.26, stdev=271.12
     clat (usec): min=469, max=913K, avg=11948.71, stdev=8064.82
     bw (KiB/s) : min=    0, max= 9988, per=100.15%, avg=4902.23, 
stdev=1265.52
   cpu          : usr=0.17%, sys=0.42%, ctx=7620229, majf=0, minf=88443
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
>=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, 
>=64=0.0%
      issued r/w: total=6598405/1650818, short=0/0
      lat (usec): 500=0.01%, 750=0.01%, 1000=0.01%
      lat (msec): 2=0.01%, 4=0.03%, 10=3.85%, 20=63.26%, 50=30.73%
      lat (msec): 100=1.88%, 250=0.23%, 500=0.01%, 1000=0.01%, 2000=0.01%

Run status group 0 (all jobs):
    READ: io=49,177MiB, aggrb=19,630KiB/s, minb=19,630KiB/s, 
maxb=19,630KiB/s, mint=2565301msec, maxt=2565301msec
   WRITE: io=12,263MiB, aggrb=4,895KiB/s, minb=4,895KiB/s, maxb=4,895KiB/s, 
mint=2565301msec, maxt=2565301msec

Disk stats (read/write):
   sdc: ios=6657530/1663473, merge=1497/343, ticks=141489010/18977040, 
in_queue=160467640, util=100.00%


   RESULT WITH ONLY 16GB iometer file
less raid10_15rpm_12x_fc
iometer: (g=0): rw=randrw, bs=512-64K/512-64K, ioengine=libaio, iodepth=64
iometer: Laying out IO file(s) (1 file(s) / 16384MiB)
iometer: (groupid=0, jobs=1): err= 0: pid=29216
   Description  : [Emulation of Intel IOmeter File Server Access Pattern]
   read : io=13,099MiB, bw=23,390KiB/s, iops=3,057, runt=573459msec
     slat (usec): min=3, max=227K, avg=18.17, stdev=329.23
     clat (usec): min=563, max=851K, avg=17958.05, stdev=10426.78
     bw (KiB/s) : min=  341, max=43373, per=100.11%, avg=23415.84, 
stdev=6330.41
   write: io=3,285MiB, bw=5,866KiB/s, iops=766, runt=573459msec
     slat (usec): min=3, max=74,959, avg=18.41, stdev=258.32
     clat (msec): min=1, max=849, avg=11.72, stdev= 7.84
     bw (KiB/s) : min=    0, max=12033, per=100.10%, avg=5871.97, 
stdev=1649.99
   cpu          : usr=0.53%, sys=1.45%, ctx=1968308, majf=0, minf=11306
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, 
>=64=100.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, 
>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.1%, 
>=64=0.0%
      issued r/w: total=1753376/439635, short=0/0
      lat (usec): 750=0.01%, 1000=0.01%
      lat (msec): 2=0.01%, 4=0.04%, 10=6.25%, 20=74.67%, 50=18.12%
      lat (msec): 100=0.74%, 250=0.17%, 500=0.01%, 750=0.01%, 1000=0.01%

Run status group 0 (all jobs):
    READ: io=13,099MiB, aggrb=23,390KiB/s, minb=23,390KiB/s, 
maxb=23,390KiB/s, mint=573459msec, maxt=573459msec
   WRITE: io=3,285MiB, aggrb=5,866KiB/s, minb=5,866KiB/s, maxb=5,866KiB/s, 
mint=573459msec, maxt=573459msec

Disk stats (read/write):
   sdc: ios=1768762/443009, merge=336/72, ticks=30834630/4993050, 
in_queue=35829210, util=100.00%


 	Best regards  Polish
