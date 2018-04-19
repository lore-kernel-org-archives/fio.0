Return-Path: <fio-owner@vger.kernel.org>
Received: from m13-224.163.com ([220.181.13.224]:48242 "EHLO m13-224.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752241AbeDSDXt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Apr 2018 23:23:49 -0400
Date: Thu, 19 Apr 2018 11:08:36 +0800
From: "shadow_lin" <shadow_lin@163.com>
Message-ID: <954d5ac.792464.162dbe00ee5.Coremail.shadow_lin@163.com>
Subject: how to understand latency when rate is set?
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi list,
    I am using rate parameter to limit ecah job's speed.
    The fio setting is:
[4m]
description="4m-seq-write"
direct=1
ioengine=libaio
directory=data
numjobs=60
iodepth=4
group_reporting
rw=write
bs=4M
size=150G
rate=10M

The result is:
4m: (groupid=0, jobs=60): err= 0: pid=6421: Mon Apr 16 03:01:29 2018
  Description : ["ceph rbd 4m-seq-write"]
  write: io=9000.0GB, bw=614407KB/s, iops=150, runt=15359834msec
    slat (usec): min=118, max=2339.4K, avg=736.32, stdev=13419.04
    clat (msec): min=84, max=20170, avg=258.32, stdev=133.97
     lat (msec): min=84, max=20171, avg=259.06, stdev=135.98
    clat percentiles (msec):
     | 1.00th=[ 122], 5.00th=[ 167], 10.00th=[ 176], 20.00th=[ 190],
     | 30.00th=[ 206], 40.00th=[ 223], 50.00th=[ 239], 60.00th=[ 258],
     | 70.00th=[ 281], 80.00th=[ 314], 90.00th=[ 367], 95.00th=[ 416],
     | 99.00th=[ 529], 99.50th=[ 586], 99.90th=[ 791], 99.95th=[ 1004],
     | 99.99th=[ 1958]
    bw (KB /s): min= 204, max=72624, per=1.79%, avg=10979.20, stdev=5690.79
    lat (msec) : 100=0.11%, 250=56.13%, 500=42.24%, 750=1.40%, 1000=0.07%
    lat (msec) : 2000=0.04%, >=2000=0.01%
  cpu : usr=0.08%, sys=0.03%, ctx=4263613, majf=0, minf=570
  IO depths : 1=84.9%, 2=9.7%, 4=5.4%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued : total=r=0/w=2304000/d=0, short=r=0/w=0/d=0
Run status group 0 (all jobs):
  WRITE: io=9000.0GB, aggrb=614406KB/s, minb=614406KB/s, maxb=614406KB/s, mint=15359834msec, maxt=15359834msec
Disk stats (read/write):
  rbd0: ios=0/2305605, merge=0/6913029, ticks=0/594137632, in_queue=594308692, util=100.00%

Then I did the same test without rate paramter
[4m]
description="4m-seq-write"
direct=1
ioengine=libaio
directory=data
numjobs=60
iodepth=4
group_reporting
rw=write
bs=4M
size=150G

The  result is:
4m: (groupid=0, jobs=60): err= 0: pid=30154: Tue Apr 17 03:13:55 2018
  Description : ["ceph rbd 4m-seq-write"]
  write: io=9000.0GB, bw=1048.1MB/s, iops=262, runt=8785724msec
    slat (usec): min=113, max=16389K, avg=159607.76, stdev=284760.52
    clat (msec): min=139, max=33403, avg=748.97, stdev=548.35
     lat (msec): min=148, max=33842, avg=908.58, stdev=671.56
    clat percentiles (msec):
     | 1.00th=[ 212], 5.00th=[ 265], 10.00th=[ 306], 20.00th=[ 371],
     | 30.00th=[ 429], 40.00th=[ 498], 50.00th=[ 578], 60.00th=[ 685],
     | 70.00th=[ 840], 80.00th=[ 1057], 90.00th=[ 1434], 95.00th=[ 1778],
     | 99.00th=[ 2540], 99.50th=[ 2835], 99.90th=[ 3589], 99.95th=[ 3916],
     | 99.99th=[ 5997]
    bw (KB /s): min= 135, max=103595, per=1.90%, avg=20420.87, stdev=11560.88
    lat (msec) : 250=3.56%, 500=36.90%, 750=24.35%, 1000=12.77%, 2000=19.23%
    lat (msec) : >=2000=3.19%
  cpu : usr=0.24%, sys=0.08%, ctx=3888021, majf=0, minf=509
  IO depths : 1=0.1%, 2=0.1%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued : total=r=0/w=2304000/d=0, short=r=0/w=0/d=0
Run status group 0 (all jobs):
  WRITE: io=9000.0GB, aggrb=1048.1MB/s, minb=1048.1MB/s, maxb=1048.1MB/s, mint=8785724msec, maxt=8785724msec
Disk stats (read/write):
  rbd0: ios=0/2304660, merge=0/6912635, ticks=0/1107332792, in_queue=1107640692, util=100.00%


The bandwith of the second test is much higher than the first one which is expected, but the latency info is confusing.I was thinking with the same job number and io depth but higher bandwith the latency should be much lower.
The first test with rate to limit the speed shows the avg latency is 259.06ms
The second test without rate to limit the speed shows the avg latency is 908.58ms.

Use 4M/latency*job_number*io_depth to calculate the bandwith.
The second test can match the formula, but the first test is way off from the formula, I think it is because the method to calculate the latency is different.

How should I understand the latency stats with rate parameters?

Thanks.


2018-04-19
shadow_lin 
