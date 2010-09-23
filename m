Return-Path: <fio-owner@vger.kernel.org>
Received: from mailrelay1.uni-rostock.de ([139.30.8.201]:14670 "EHLO
	mailrelay1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IWMoM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Sep 2010 08:44:12 -0400
Message-ID: <4C9B4A53.1080302@uni-rostock.de>
Date: Thu, 23 Sep 2010 14:38:43 +0200
From: Nikolaus Jeremic <nikolaus.jeremic@uni-rostock.de>
MIME-Version: 1.0
Subject: fio causes segfault after particular of random writes
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

  Hello,

I am using  fio for benchmarking of SSDs and noticed that fio causes a 
segfault after writing about 260000 MB with block size of 4069 bytes at 
random in one job. Writing the same or just bigger amount of data 
sequentially in 1 MB blocks works well. The situation is reproducible 
with several fio versions, i.e. 1.34, 1.41, 1.43, 1.43.2 as of 09/16/2010.

My system runs Gentoo Linux with kernel version 2.6.35:

uname -ar:

Linux ava-srv1 2.6.35-gentoo-r8 #1 SMP Thu Sep 23 01:15:44 CEST 2010 x86_64 Intel(R) Xeon(R) CPU X5550 @ 2.67GHz GenuineIntel GNU/Linux


The kernel log says:

[40594.224072] fio[8194]: segfault at 60000008 ip 000000000040f010 sp 00007fff15d04540 error 6 in fio[400000+3d000]


Shell output:

fio ssd-test-half 2>&1>  ssd_raid0_half.txt
fio: pid=8194, got signal=11
fio: file hash not empty on exit



Content of 'ssd_raid0_half.txt':

ssd_raid0_rw: (g=0): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=31
ssd_raid0_rw: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=libaio, iodepth=31
Starting 2 processes

ssd_raid0_rw: (groupid=0, jobs=1): err= 0: pid=5614
   Description  : [SSD RAID0 random write test]
   write: io=152636MB, bw=14733KB/s, iops=3683 , runt=10608985msec
     slat (usec): min=0 , max=311 , avg=12.35, stdev= 6.25
     clat (usec): min=0 , max=516847 , avg=8401.34, stdev=23180.68
      lat (usec): min=0 , max=516861 , avg=8414.20, stdev=23181.16
     bw (KB/s) : min= 1565, max=94672, per=100.30%, avg=14776.62, stdev=7192.34
   cpu          : usr=1.71%, sys=5.54%, ctx=22398949, majf=0, minf=687154
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%,>=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%,>=64=0.0%
      issued r/w/d: total=0/39074846/0, short=0/0/0
      lat (usec): 2=0.01%, 20=0.01%, 50=0.01%, 100=0.02%, 250=0.30%
      lat (usec): 500=2.41%, 750=8.67%, 1000=11.26%
      lat (msec): 2=40.79%, 4=17.93%, 10=3.51%, 20=2.65%, 50=9.30%
      lat (msec): 100=1.06%, 250=2.05%, 500=0.05%, 750=0.01%
      errors    : total=0, first_error=0/<Success>
ssd_raid0_rw: (groupid=1, jobs=1): err= 0: pid=8194
   Description  : [SSD RAID0 random write test]
   cpu          : usr=0.00%, sys=0.00%, ctx=0, majf=0, minf=0
   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=100.0%, 32=0.0%,>=64=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,>=64=0.0%
      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,>=64=0.0%
      issued r/w/d: total=0/67108865/0, short=0/0/0
      lat (usec): 2=0.01%, 20=0.01%, 50=0.01%, 100=0.02%, 250=0.47%
      lat (usec): 500=2.42%, 750=7.34%, 1000=9.56%
      lat (msec): 2=34.94%, 4=17.15%, 10=3.67%, 20=3.17%, 50=14.54%
      lat (msec): 100=3.48%, 250=3.15%, 500=0.07%, 750=0.01%
      errors    : total=0, first_error=0/<Success>

Run status group 0 (all jobs):
   WRITE: io=152636MB, aggrb=14732KB/s, minb=15086KB/s, maxb=15086KB/s, mint=10608985msec, maxt=10608985msec

Run status group 1 (all jobs):

Disk stats (read/write):
   md9: ios=53/106183711, merge=0/0, ticks=0/0, in_queue=0, util=0.00%, aggrios=13/26545927, aggrmerge=0/0, aggrticks=2/308056055, aggrin_queue=308040475, aggrutil=0.00%
     sdh: ios=4/26554543, merge=0/0, ticks=0/206354320, in_queue=206338240, util=0.00%
     sdi: ios=14/26543759, merge=0/0, ticks=0/664104677, in_queue=664089630, util=0.00%
     sdj: ios=8/26540642, merge=0/0, ticks=0/206861870, in_queue=206846313, util=0.00%
     sdg: ios=29/26544767, merge=0/0, ticks=10/154903353, in_queue=154887717, util=0.00%


The corresponding job file contains:

[global]
name=ssd_raid0_rw
description=SSD RAID0 random write test
bs=4096
ioengine=libaio
iodepth=31
direct=1
continue_on_error=1
filename=/dev/md9

[rand-write1]
rw=randwrite
numjobs=1
norandommap
size=160050446336
stonewall
#write_iolog=io_patterns1.log
write_bw_log=bandwidth1
write_lat_log

[rand-write2]
rw=randwrite
numjobs=1
norandommap
size=320100892672
stonewall
#write_iolog=io_patterns2.log
write_bw_log=bandwidth2
write_lat_log


iostat -m (values were reset for md9 before starting the benchmark):

Linux 2.6.35-gentoo-r8 (ava-srv1) 	09/23/10 	_x86_64_	(16 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
            0.08    0.01    0.24    5.23    0.00   94.44

Device:            tps    MB_read/s    MB_wrtn/s    MB_read    MB_wrtn
sdb               0.77         0.00         0.06        106       2559
sdc               0.00         0.00         0.00          0          0
sdd               0.00         0.00         0.00          0          0
sde               0.00         0.00         0.00          0          0
sdf               0.00         0.00         0.00          0          0
sda               0.78         0.00         0.06        104       2559
md0              15.21         0.00         0.06        202       2529
md3               0.01         0.00         0.00          1          0
md2               0.01         0.00         0.00          1          0
md1               0.11         0.00         0.00          4         15
sdg             589.24         0.00         2.30          0     103919
sdh             589.46         0.00         2.30          0     103958
sdi             589.22         0.00         2.30          0     103915
sdj             589.15         0.00         2.30          0     103903
md9            2357.07         0.00         9.21          0     415696


The first job is done well, however  the second one causes the segfault. 
I would be glad if you could help me. Thank you.

Kind regards,
Nikolaus

-- 
Dipl.-Inf. Nikolaus Jeremic          nikolaus.jeremic@uni-rostock.de
Universitaet Rostock                 Tel:  (+49) 381 / 498 - 7633
Albert-Einstein-Str. 21	             Fax:  (+49) 381 / 498 - 7482
18051 Rostock, Germany               wwwava.informatik.uni-rostock.de

