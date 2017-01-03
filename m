Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33979 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932930AbdACIeQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Jan 2017 03:34:16 -0500
Received: by mail-io0-f177.google.com with SMTP id p42so426193016ioo.1
        for <fio@vger.kernel.org>; Tue, 03 Jan 2017 00:34:15 -0800 (PST)
MIME-Version: 1.0
From: qingwei wei <tchengwee@gmail.com>
Date: Tue, 3 Jan 2017 16:34:14 +0800
Message-ID: <CAGjEAhuE=fPszaVnHbYZewSXHPEmLkYgmOj0eS-=EJp+CdQRJw@mail.gmail.com>
Subject: Fio engine gfapi question
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am using fio to test gluster performance using gfapi engine. My
gluster server configuration is as follow:

Volume Name: test12bgf1
Type: Distribute
Volume ID: 9cf4ed03-2759-4370-bcee-43881a96a597
Status: Started
Number of Bricks: 12
Transport-type: tcp
Bricks:
Brick1: 192.168.99.11:/data/ssd/test12bgf11
Brick2: 192.168.99.11:/data/ssd/test12bgf12
Brick3: 192.168.99.11:/data/ssd/test12bgf13
Brick4: 192.168.99.11:/data/ssd/test12bgf14
Brick5: 192.168.99.11:/data/ssd/test12bgf15
Brick6: 192.168.99.11:/data/ssd/test12bgf16
Brick7: 192.168.99.11:/data/ssd/test12bgf17
Brick8: 192.168.99.11:/data/ssd/test12bgf18
Brick9: 192.168.99.11:/data/ssd/test12bgf19
Brick10: 192.168.99.11:/data/ssd/test12bgf110
Brick11: 192.168.99.11:/data/ssd/test12bgf111
Brick12: 192.168.99.11:/data/ssd/test12bgf112
Options Reconfigured:
performance.stat-prefetch: off
features.shard-block-size: 16MB
features.shard: on
nfs.disable: true
performance.quick-read: off
performance.io-cache: off
performance.read-ahead: off
performance.readdir-ahead: on

This is s setup without any replication. I did some fio test and found
that the write latency is much better compare to read latency.

write latency for the test below is 64.32 us

[root@supermicro fioResults]# fio -group_reporting -ioengine gfapi
-fallocate none -direct 1 -size 1g -filesize 1g -nrfiles 1 -openfiles
1 -bs 4k -numjobs 1 -iodepth 1  -name test -rw randwrite -volume
test12bgf1 -brick 192.168.99.11 -ramp_time 5 -runtime 600
test: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=gfapi, iodepth=1
fio-2.15-69-g104e
Starting 1 process
Jobs: 1 (f=0): [f(1)] [100.0% done] [0KB/13057KB/0KB /s] [0/3264/0
iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=3445: Tue Jan  3 16:30:35 2017
  write: io=748976KB, bw=60183KB/s, iops=15045, runt= 12445msec
    clat (usec): min=14, max=3279, avg=63.95, stdev=13.13
     lat (usec): min=14, max=3279, avg=64.32, stdev=13.13
    clat percentiles (usec):
     |  1.00th=[   50],  5.00th=[   54], 10.00th=[   56], 20.00th=[   58],
     | 30.00th=[   60], 40.00th=[   62], 50.00th=[   63], 60.00th=[   65],
     | 70.00th=[   67], 80.00th=[   69], 90.00th=[   73], 95.00th=[   76],
     | 99.00th=[   84], 99.50th=[   87], 99.90th=[   94], 99.95th=[   98],
     | 99.99th=[  106]
    lat (usec) : 20=0.09%, 50=0.74%, 100=99.13%, 250=0.03%, 500=0.01%
    lat (msec) : 2=0.01%, 4=0.01%
  cpu          : usr=84.35%, sys=15.36%, ctx=8421, majf=0, minf=11
  IO depths    : 1=140.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=187244/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=748976KB, aggrb=60182KB/s, minb=60182KB/s, maxb=60182KB/s,
mint=12445msec, maxt=12445msec

write latency for the test below is 334.82 us

[root@supermicro fioResults]# fio -group_reporting -ioengine gfapi
-fallocate none -direct 1 -size 1g -filesize 1g -nrfiles 1 -openfiles
1 -bs 4k -numjobs 1 -iodepth 1  -name test -rw randread -volume
test12bgf1 -brick 192.168.99.11 -ramp_time 5 -runtime 600
test: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=gfapi, iodepth=1
fio-2.15-69-g104e
Starting 1 process
Jobs: 1 (f=0): [f(1)] [100.0% done] [2626KB/0KB/0KB /s] [656/0/0 iops]
[eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=3506: Tue Jan  3 16:33:17 2017
  read : io=990236KB, bw=11869KB/s, iops=2967, runt= 83429msec
    clat (usec): min=225, max=2153, avg=334.48, stdev=34.85
     lat (usec): min=226, max=2153, avg=334.82, stdev=34.85
    clat percentiles (usec):
     |  1.00th=[  262],  5.00th=[  282], 10.00th=[  294], 20.00th=[  310],
     | 30.00th=[  318], 40.00th=[  322], 50.00th=[  330], 60.00th=[  338],
     | 70.00th=[  354], 80.00th=[  366], 90.00th=[  378], 95.00th=[  394],
     | 99.00th=[  422], 99.50th=[  430], 99.90th=[  470], 99.95th=[  502],
     | 99.99th=[  556]
    lat (usec) : 250=0.18%, 500=99.77%, 750=0.05%, 1000=0.01%
    lat (msec) : 2=0.01%, 4=0.01%
  cpu          : usr=14.25%, sys=3.59%, ctx=252187, majf=0, minf=8
  IO depths    : 1=105.9%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=247559/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: io=990236KB, aggrb=11869KB/s, minb=11869KB/s, maxb=11869KB/s,
mint=83429msec, maxt=83429msec

So is this because FIO gfapi write immediately return after data is
written to local socket buffer?

Regards,

Cw
