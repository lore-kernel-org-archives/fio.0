Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33266 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030256AbbCLVFe (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 12 Mar 2015 17:05:34 -0400
Received: by widfb4 with SMTP id fb4so7291577wid.0
        for <fio@vger.kernel.org>; Thu, 12 Mar 2015 14:05:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4471f819ae264ec8bcb6bb1684effd53@keskonrix.itsystems.ch>
References: <4471f819ae264ec8bcb6bb1684effd53@keskonrix.itsystems.ch>
Date: Thu, 12 Mar 2015 14:05:32 -0700
Message-ID: <CAF+0mv=oyOj1hsjQeTW3VGt=zoK4-bu9od=xcZSJ6+guUevZSg@mail.gmail.com>
Subject: Re: fio always writes null bytes whatever I do
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Urs Schaltegger <urs.schaltegger@itsystems.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Mar 12, 2015 at 7:32 AM, Urs Schaltegger
<urs.schaltegger@itsystems.ch> wrote:
> fio always writes null bytes whatever I do. I need random data to avoid interference of deduplication solutions (within SSDs or using ZFS).
>
> Windows 8.1 Enterprise x64
>
> fio-2.2.6 (also tried 2.2.0/2.2.1/2.2.3)
>
> fio --section=fiorandom --runtime=60 <FIOFile>
>
> <FIOFile>:
>
> [global]
> ioengine=windowsaio
> thread
> group_reporting
> time_based
> clocksource=clock_gettime
> direct=1
> refill_buffers
> size=1g
> [fiorandom]
> readwrite=randwrite
> numjobs=4
> iodepth=1
> blocksize=8k
> directory=D\:\

Confirmed here as well...

matt@matt-work:~$ fio --name=test --filename=/tmp/fio.temp.file
--size=1g --rw=write --refill_buffers
test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=sync, iodepth=1
fio-2.2.6
Starting 1 process
test: Laying out IO file(s) (1 file(s) / 1024MB)
Jobs: 1 (f=1): [W(1)] [-.-% done] [0KB/289.7MB/0KB /s] [0/74.0K/0
iops] [eta 00m:00s]
test: (groupid=0, jobs=1): err= 0: pid=7629: Thu Mar 12 14:02:39 2015
  write: io=1024.0MB, bw=537456KB/s, iops=134363, runt=  1951msec
    clat (usec): min=1, max=7014, avg= 7.03, stdev=198.60
     lat (usec): min=1, max=7014, avg= 7.07, stdev=198.60
    clat percentiles (usec):
     |  1.00th=[    1],  5.00th=[    1], 10.00th=[    1], 20.00th=[    1],
     | 30.00th=[    1], 40.00th=[    1], 50.00th=[    1], 60.00th=[    1],
     | 70.00th=[    2], 80.00th=[    2], 90.00th=[    2], 95.00th=[    2],
     | 99.00th=[    3], 99.50th=[    4], 99.90th=[   19], 99.95th=[ 6944],
     | 99.99th=[ 6944]
    bw (KB  /s): min=294634, max=1233526, per=100.00%, avg=608053.33,
stdev=541675.65
    lat (usec) : 2=69.53%, 4=29.89%, 10=0.35%, 20=0.14%, 50=0.01%
    lat (msec) : 10=0.08%
  cpu          : usr=5.33%, sys=18.45%, ctx=222, majf=0, minf=8
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued    : total=r=0/w=262144/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: io=1024.0MB, aggrb=537455KB/s, minb=537455KB/s,
maxb=537455KB/s, mint=1951msec, maxt=1951msec

Disk stats (read/write):
  sda: ios=0/897, merge=0/7, ticks=0/230372, in_queue=250416, util=87.64%
matt@matt-work:~$ hexdump /tmp/fio.temp.file
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
40000000
