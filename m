Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64759 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbaKSWuD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Nov 2014 17:50:03 -0500
Received: by mail-wg0-f54.google.com with SMTP id y10so2154585wgg.13
        for <fio@vger.kernel.org>; Wed, 19 Nov 2014 14:50:02 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 19 Nov 2014 16:50:02 -0600
Message-ID: <CAMrbZ2A7BwQZ3eho_9ErQAd_gNp+njQvg63CANPUOYz68w9a4g@mail.gmail.com>
Subject: question on sg ioengine
From: Zhe Zhang <zzxuanyuan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I run into this problem probably because I did not understand the
command correctly.

But my test.fio configured as follow:
[global]
bs=4k
ba=512b
direct=1
number_ios=400
rw=write:2k
ioengine=sg
iodepth=2
iodepth_batch=2
write_bw_log=test
write_lat_log=test
write_iops_log=test
[/dev/sdb]

and the result looks like this:
/dev/sdb: (groupid=0, jobs=1): err= 0: pid=7783: Mon Nov 17 15:26:30 2014
  write: io=1600.0KB, bw=6584.4KB/s, iops=1646, runt=   243msec
    clat (usec): min=153, max=14926, avg=602.43, stdev=1165.02
     lat (usec): min=153, max=14926, avg=602.91, stdev=1165.03
    clat percentiles (usec):
     |  1.00th=[  163],  5.00th=[  193], 10.00th=[  253], 20.00th=[  290],
     | 30.00th=[  322], 40.00th=[  354], 50.00th=[  394], 60.00th=[  446],
     | 70.00th=[  482], 80.00th=[  532], 90.00th=[  708], 95.00th=[ 1048],
     | 99.00th=[ 6624], 99.50th=[ 7776], 99.90th=[14912], 99.95th=[14912],
     | 99.99th=[14912]
    lat (usec) : 250=9.25%, 500=66.00%, 750=15.00%, 1000=3.50%
    lat (msec) : 2=3.50%, 4=0.75%, 10=1.75%, 20=0.25%
  cpu          : usr=1.65%, sys=1.65%, ctx=402, majf=0, minf=36
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=400/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=2

Run status group 0 (all jobs):
  WRITE: io=1600KB, aggrb=6584KB/s, minb=6584KB/s, maxb=6584KB/s,
mint=243msec, maxt=243msec

Disk stats (read/write):
  sdb: ios=84/0, merge=0/0, ticks=92/0, in_queue=92, util=36.95%

RUN FINISHED; exit value 0; real time: 600ms; user: 40ms; system: 60ms

I darker my disk utilization here. My question is why there is no
write went tot the disk and where does those 84 reads come from?
Because in test.fio, I only issue writes to the disk /dev/sdb

Thanks!
