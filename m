Return-Path: <fio-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:32067 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752403AbdHQSiC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Aug 2017 14:38:02 -0400
From: "Gruher, Joseph R" <joseph.r.gruher@intel.com>
Subject: IOPS Log Incorrect?
Date: Thu, 17 Aug 2017 18:38:00 +0000
Message-ID: <DE927C68B458BE418D582EC97927A9287FCAD035@ORSMSX113.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi, I'm using FIO 3.0 on Ubuntu 16.10 with 4.12.7 kernel (also reproduced problem with default 4.8.0-59 kernel). I'm running a 4KB random IO pattern against an Intel P3700 400GB NVMe SSD. I'm trying to view the IOPS/BW over time using the write_bw_log and write_iops_log parameters. FIO is writing the logs but the values in the logs don't align with the summary for the run.  Here's a simple example.  Notice FIO reports 398K IOPS for the run overall, but the IOPS log file shows 383K for the first entry and then values around 56K for the rest of the run, so one or the other must be incorrect (presumably the log file).  The bandwidth log has a similar issue.


root@nvmfjt01:/home/nvmf/jrg9/chandler# cat 4k-rr-01.ini
[global]
bs=4k
rw=randread
numjobs=1
iodepth=128
ioengine=libaio
direct=1
runtime=30
write_iops_log=joe2
log_avg_msec=5000
[job00]
filename=/dev/nvme0n1


root@nvmfjt01:/home/nvmf/jrg9/chandler# fio 4k-rr-01.ini
job00: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=128
fio-3.0
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=1595MiB/s,w=0KiB/s][r=408k,w=0 IOPS][eta 00m:00s]
job00: (groupid=0, jobs=1): err= 0: pid=2767: Thu Aug 17 10:34:09 2017
read: IOPS=398k, BW=1555MiB/s (1630MB/s)(45.6GiB/30001msec)
slat (nsec): min=824, max=117534, avg=1682.36, stdev=1290.45
clat (usec): min=96, max=2899, avg=319.29, stdev=69.36
lat (usec): min=97, max=2900, avg=321.08, stdev=69.39
clat percentiles (usec):
| 1.00th=[ 221], 5.00th=[ 243], 10.00th=[ 255], 20.00th=[ 269],
| 30.00th=[ 281], 40.00th=[ 289], 50.00th=[ 302], 60.00th=[ 318],
| 70.00th=[ 334], 80.00th=[ 363], 90.00th=[ 412], 95.00th=[ 453],
| 99.00th=[ 562], 99.50th=[ 611], 99.90th=[ 725], 99.95th=[ 775],
| 99.99th=[ 906]
bw ( MiB/s): min= 1081, max= 1594, per=99.96%, avg=1554.11, stdev=68.33, samples=59
iops : min=56293, max=383046, avg=65603.75, stdev=54419.77, samples=36
lat (usec) : 100=0.01%, 250=7.73%, 500=89.82%, 750=2.38%, 1000=0.07%
lat (msec) : 2=0.01%, 4=0.01%
cpu : usr=32.51%, sys=67.50%, ctx=105, majf=0, minf=153
IO depths : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
issued rwt: total=11941208,0,0, short=0,0,0, dropped=0,0,0
latency : target=0, window=0, percentile=100.00%, depth=128
Run status group 0 (all jobs):
READ: bw=1555MiB/s (1630MB/s), 1555MiB/s-1555MiB/s (1630MB/s-1630MB/s), io=45.6GiB (48.9GB), run=30001-30001msec
Disk stats (read/write):
nvme0n1: ios=11890654/0, merge=0/0, ticks=1923076/0, in_queue=1925204, util=99.69%


root@nvmfjt01:/home/nvmf/jrg9/chandler# cat joe2_iops.1.log
5000, 383046, 0, 0
10640, 56412, 0, 0
15576, 56410, 0, 0
20511, 56425, 0, 0
25446, 56394, 0, 0
30040, 57131, 0, 0


root@nvmfjt01:/home/nvmf/jrg9/chandler# fio --version
fio-3.0


root@nvmfjt01:/home/nvmf/jrg9/chandler# uname -a
Linux nvmfjt01 4.12.7-041207-generic #201708160856 SMP Wed Aug 16 12:59:25 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

