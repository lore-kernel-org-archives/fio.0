Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f169.google.com ([209.85.166.169]:34613 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbeJ3S16 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 14:27:58 -0400
Received: by mail-it1-f169.google.com with SMTP id e81-v6so12339767itc.1
        for <fio@vger.kernel.org>; Tue, 30 Oct 2018 02:35:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFF4W0Xr3qThNjeS6-M-SWGQ2hjhm5VOfCkaPsagzqhuwfucLA@mail.gmail.com>
References: <CAFF4W0Xr3qThNjeS6-M-SWGQ2hjhm5VOfCkaPsagzqhuwfucLA@mail.gmail.com>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Tue, 30 Oct 2018 15:05:14 +0530
Message-ID: <CAFF4W0VnnZYMGJcMKDrYQDO8JXEmJHAsZvg01anyCDuOrMpnQA@mail.gmail.com>
Subject: Re: --eta never option works on server but not on client.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hello all,

sorry its working fine, may be I haven't understood the options
completely at first.
increased --size to 30M, ETA never printed when used below command.

bash# docker run -v /home:/tmp/fio-data/ fio:5.0 --eta never --client
172.17.0.3 randread.fio
hostname=7e742f684ce7, be=0, 64-bit, os=Linux, arch=x86-64,
fio=fio-3.11-21-g307f, flags=1
<7e742f684ce7> Bafjo: (g=0): rw=randread, bs=(R) 4096B-4096B, (W)
4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
<7e742f684ce7> Starting 1 process
<7e742f684ce7>
Bafjo: (groupid=0, jobs=1): err= 0: pid=49: Tue Oct 30 09:30:34 2018
   read: IOPS=400, BW=1604KiB/s (1642kB/s)(100MiB/63846msec)
    clat (usec): min=119, max=328155, avg=2480.36, stdev=6322.22
     lat (usec): min=119, max=328156, avg=2481.27, stdev=6322.23
    clat percentiles (usec):
     |  1.00th=[   149],  5.00th=[   172], 10.00th=[   198], 20.00th=[   247],
     | 30.00th=[   289], 40.00th=[   326], 50.00th=[   371], 60.00th=[   424],
     | 70.00th=[   502], 80.00th=[  1729], 90.00th=[  9110], 95.00th=[ 12256],
     | 99.00th=[ 31065], 99.50th=[ 35390], 99.90th=[ 60031], 99.95th=[ 83362],
     | 99.99th=[141558]
   bw (  KiB/s): min=   12, max=34392, per=100.00%, avg=10980.17,
stdev=7198.55, samples=25600
   iops        : min=    1, max=    1, avg= 1.00, stdev= 0.00, samples=25600
  lat (usec)   : 250=20.77%, 500=49.26%, 750=7.01%, 1000=0.57%
  lat (msec)   : 2=3.00%, 4=1.14%, 10=9.72%, 20=6.91%, 50=1.49%
  lat (msec)   : 100=0.09%, 250=0.04%, 500=0.01%
  cpu          : usr=0.82%, sys=3.02%, ctx=25642, majf=0, minf=829
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=25600,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=1604KiB/s (1642kB/s), 1604KiB/s-1604KiB/s
(1642kB/s-1642kB/s), io=100MiB (105MB), run=63846-63846msec

Disk stats (read/write):
  sda: ios=25600/285, merge=0/297, ticks=61452/52884, in_queue=114304,
util=96.21%

Thanks and Regards,
Mohan

On 10/30/18, Mohanraj B <bmohanraj91@gmail.com> wrote:
> Hello,
>
> The option --eta never,always,auto is quiet confusing.
>
> When I started the server with the below command, there is no output
> display.
>
> bash# docker run fio-test:5.0 --eta never --server
>
> But the same option not works in client side.
>
> bash# docker run -v /home/:/tmp/fio-data/ fio-test:5.0 --eta never
> --client 172.17.0.3 randread.fio
> hostname=7e742f684ce7, be=0, 64-bit, os=Linux, arch=x86-64,
> fio=fio-3.11-21-g307f, flags=1
> <7e742f684ce7> Bafjo: (g=0): rw=randread, bs=(R) 4096B-4096B, (W)
> 4096B-4096B, (T) 4096B-4096B, ioengine=psync, iodepth=1
> <7e742f684ce7> Starting 1 process
> <7e742f684ce7> Bafjo: Laying out IO file (1 file / 10MiB)
> <7e742f684ce7>
> Bafjo: (groupid=0, jobs=1): err= 0: pid=17: Tue Oct 30 08:46:24 2018
>    read: IOPS=1037, BW=4151KiB/s (4250kB/s)(10.0MiB/2467msec)
>     clat (usec): min=132, max=2901, avg=953.17, stdev=636.69
>      lat (usec): min=132, max=2901, avg=953.81, stdev=636.71
>     clat percentiles (usec):
>      |  1.00th=[  176],  5.00th=[  225], 10.00th=[  269], 20.00th=[  359],
>      | 30.00th=[  457], 40.00th=[  594], 50.00th=[  791], 60.00th=[ 1020],
>      | 70.00th=[ 1254], 80.00th=[ 1516], 90.00th=[ 1942], 95.00th=[ 2212],
>      | 99.00th=[ 2573], 99.50th=[ 2671], 99.90th=[ 2802], 99.95th=[ 2835],
>      | 99.99th=[ 2900]
>    bw (  KiB/s): min= 1411, max=30846, per=100.00%, avg=7151.19,
> stdev=5345.75, samples=2560
>    iops        : min=    1, max=    1, avg= 1.00, stdev= 0.00, samples=2560
>   lat (usec)   : 250=8.09%, 500=25.62%, 750=14.84%, 1000=10.62%
>   lat (msec)   : 2=32.07%, 4=8.75%
>   cpu          : usr=2.03%, sys=4.95%, ctx=2565, majf=0, minf=101
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>>=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>>=64=0.0%
>      issued rwts: total=2560,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=1
>
> Run status group 0 (all jobs):
>    READ: bw=4151KiB/s (4250kB/s), 4151KiB/s-4151KiB/s
> (4250kB/s-4250kB/s), io=10.0MiB (10.5MB), run=2467-2467msec
>
> Disk stats (read/write):
>   sda: ios=2389/0, merge=0/0, ticks=2108/0, in_queue=2108, util=86.82%
>
>
> please let me know how to fix it.
>
> Thanks and Regards,
> Mohan
>

