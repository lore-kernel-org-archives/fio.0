Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39025 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730650AbfJDGYZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Oct 2019 02:24:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so5574366wrj.6
        for <fio@vger.kernel.org>; Thu, 03 Oct 2019 23:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV_H3EcY70W+=Q_oZX+skVMQ_q+O1LqocC8kUhfdvoos3g@mail.gmail.com>
In-Reply-To: <CABO+gV_H3EcY70W+=Q_oZX+skVMQ_q+O1LqocC8kUhfdvoos3g@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 4 Oct 2019 07:24:54 +0100
Message-ID: <CALjAwxgSSdcH7MWCa89okeVNfsrzWiaT-xbqQHmQ_s1sRLtafQ@mail.gmail.com>
Subject: Re: IO Depth measurement
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Elliott Balsley <elliott@altsystems.com>
Cc: fio <fio@vger.kernel.org>

On Thu, 3 Oct 2019 at 19:35, Elliott Balsley <elliott@altsystems.com> wrote:
>
> Hello.  I've read through the docs, but I don't understand the
> difference in output between IO depth and IO submit.  In this example,
> I set iodepth=2, but it's showing 100% use depth of 1.  And 100% of

iodepth values greater than 1 only have an impact if you're using an
asynchronous ioengine* (i.e. submission and waiting completion can be
separate steps) so that you can have multiple I/Os in flight at once
(see the sentence that begins Note in documentation for iodepth -
https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-iodepth
). In your output we can see you have "ioengine=psync" which is
synchronous. Getting ahead of ourselves note that very recent ZFS only
support direct I/O by falling back to buffered I/O
(https://github.com/zfsonlinux/zfs/commit/5c6223ed5a7d51fd19b0c1a71784034202dd069
) so if you're using libaio with ZFS I wouldn't be sure that the
submission wouldn't go synchronous in the kernel.

* See the docs for details.

> submits are between 4 to 8.  I'd appreciate if someone can explain

Note the ranges for submit complete are subtly different to to for
depth i.e. that's 100% 1-4 for submit (see the IO submit and IO depths
sections of https://fio.readthedocs.io/en/latest/fio_man.html#interpreting-the-output
).

> what this means.  If it matters, I'm reading from a ZFS filesystem,
> and data is cached in ARC, hence the high speeds.
>
> fio --name=larry --rw=read --bs=1M --size=5000M --directory=/all24
> --nrfiles=10 --end_fsync=1 --numjobs=20 --group_reporting --iodepth=2
> larry: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
> (T) 1024KiB-1024KiB, ioengine=psync, iodepth=2
> ...
> fio-3.5
> Starting 20 processes
> Jobs: 11 (f=110):
> [_(1),R(2),_(1),R(1),_(1),R(1),_(1),R(1),_(1),R(4),_(1),R(1),_(1),R(1),_(2)][70.0%][r=14.3GiB/s,w=0KiBJobs:
> 1 (f=10): [_(10),E(1),R(1),_(8)][100.0%][r=13.0GiB/s,w=0KiB/s][r=13.4k,w=0
> IOPS][eta 00m:00s]
> larry: (groupid=0, jobs=20): err= 0: pid=70097: Thu Oct  3 10:34:31 2019
>    read: IOPS=14.2k, BW=13.9GiB/s (14.9GB/s)(97.7GiB/7020msec)
>     clat (usec): min=343, max=5832, avg=1204.12, stdev=542.72
>      lat (usec): min=343, max=5832, avg=1204.38, stdev=542.85
>     clat percentiles (usec):
>      |  1.00th=[  433],  5.00th=[  502], 10.00th=[  578], 20.00th=[  750],
>      | 30.00th=[  922], 40.00th=[ 1029], 50.00th=[ 1074], 60.00th=[ 1106],
>      | 70.00th=[ 1401], 80.00th=[ 1811], 90.00th=[ 2057], 95.00th=[ 2147],
>      | 99.00th=[ 2606], 99.50th=[ 2802], 99.90th=[ 3261], 99.95th=[ 3523],
>      | 99.99th=[ 4555]
>    bw (  KiB/s): min=469835, max=1684183, per=5.45%, avg=794410.57,
> stdev=293137.66, samples=230
>    iops        : min=  458, max= 1644, avg=775.34, stdev=286.24, samples=230
>   lat (usec)   : 500=4.99%, 750=15.08%, 1000=16.16%
>   lat (msec)   : 2=50.54%, 4=13.21%, 10=0.03%
>   cpu          : usr=0.41%, sys=99.55%, ctx=2364, majf=0, minf=5120
>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      issued rwts: total=100000,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=2
>
> Run status group 0 (all jobs):
>    READ: bw=13.9GiB/s (14.9GB/s), 13.9GiB/s-13.9GiB/s
> (14.9GB/s-14.9GB/s), io=97.7GiB (105GB), run=7020-7020msec
> fio --name=larry --rw=read --bs=1M --size=5000M --directory=/all24

-- 
Sitsofe | http://sucs.org/~sits/

