Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f68.google.com ([209.85.217.68]:41744 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727885AbeITB5p (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Sep 2018 21:57:45 -0400
Received: by mail-vs1-f68.google.com with SMTP id u18-v6so2213358vsu.8
        for <fio@vger.kernel.org>; Wed, 19 Sep 2018 13:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <1769401537372008@iva3-a2a8aac410a1.qloud-c.yandex.net>
 <CALjAwxgPhfxnP68u7xdwXwkw-ZL3Tmrf20MD=n=WBy+Jd_-ESQ@mail.gmail.com> <2474471537386145@iva4-f779e14fe728.qloud-c.yandex.net>
In-Reply-To: <2474471537386145@iva4-f779e14fe728.qloud-c.yandex.net>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 19 Sep 2018 21:17:45 +0100
Message-ID: <CALjAwxgonrMeAm-CZ0ahWfBxw9sui8Ai9f62R6xtuBcyxNEV+A@mail.gmail.com>
Subject: Re: Fio O_SYNC and libaio on 4.15 kernel doesn't flush data
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: zakharov.a.g@yandex.ru
Cc: fio <fio@vger.kernel.org>

Hi,

I also don't understand why enabling O_SYNC would make things faster
but the fact you can change your kernel version and see different
behaviour really does point to a change in the kernel rather than an
issue in fio. You might find that a blktrace while fio is running
gives some insight into what is happening. The only other thing to be
weary of is if you aren't resetting the cache between runs (later runs
may be changing their behaviour based on the cache's state). You might
find the bcache folks (their mailing list details are on
http://vger.kernel.org/vger-lists.html#linux-bcache ) provide more
assistance than we can but if you get to the bottom of this do let us
know the outcome!

On Wed, 19 Sep 2018 at 20:42, =D0=97=D0=B0=D1=85=D0=B0=D1=80=D0=BE=D0=B2 =
=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B5=D0=B9 <zakharov.a.g@yandex.ru> wrote:
>
> Thanks for the answer and sorry for this mess.
>
> Here is an example with 4.15 kernel:
> ~# uname -r
> 4.15.0-34-generic
>
> Bcache is in writeback mode.
> ~# cat /sys/class/block/bcache11/bcache/cache_mode
> writethrough [writeback] writearound none
>
> First test, libaio and sync=3D0:
> fio --name=3Dtest --iodepth=3D1 --numjobs=3D1 --direct=3D1 --filename=3D/=
dev/bcache11 --filesize=3D1G --blocksize=3D4k --rw=3Drandwrite --sync=3D0 -=
-ioengine=3Dlibaio
> test: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D1
> fio-2.2.10
> Starting 1 process
> Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/61234KB/0KB /s] [0/15.4K/0 iop=
s] [eta 00m:00s]
>
> iostat -xt 1 result while testing:
> 09/19/18 21:52:26
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.22    0.00    1.35    0.00    0.00   98.43
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdv               0.00     0.00    0.00    1.00     0.00     4.00     8.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> bcache11          0.00     0.00    0.00 15894.00     0.00 63576.00     8.=
00 3098732.18    0.03    0.00    0.03   0.03  52.40
>
>
> Second test with libaio and sync=3D1:
> fio --name=3Dtest --iodepth=3D1 --numjobs=3D1 --direct=3D1 --filename=3D/=
dev/bcache11 --filesize=3D1G --blocksize=3D4k --rw=3Drandwrite --sync=3D1 -=
-ioengine=3Dlibaio
> test: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D1
> fio-2.2.10
> Starting 1 process
> Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/88123KB/0KB /s] [0/22.3K/0 iop=
s] [eta 00m:00s]
>
> iostat while testing:
> 09/19/18 21:54:17
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.19    0.00    1.16    0.00    0.00   98.65
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdv               0.00     0.00    0.00    1.00     0.00     4.00     8.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> bcache11          0.00     0.00    0.00 22118.00     0.00 88472.00     8.=
00 1014565.97    0.04    0.00    0.04   0.01  16.40
>
>
> Third test with fsync=3D1 and libaio:
> fio --name=3Dtest --iodepth=3D1 --numjobs=3D1 --direct=3D1 --filename=3D/=
dev/bcache11 --filesize=3D1G --blocksize=3D4k --rw=3Drandwrite --fsync=3D1 =
--ioengine=3Dlibaio
> test: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dlibaio,=
 iodepth=3D1
> fio-2.2.10
> Starting 1 process
> Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/21280KB/0KB /s] [0/5320/0 iops=
] [eta 00m:00s]
>
> iostat:
>   09/19/18 21:56:52
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.19    0.00    0.91    1.38    0.00   97.52
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdv               0.00     0.00    0.00 5959.00     0.00     4.00     0.0=
0     0.00    0.09    0.00    0.09   0.00   0.00
> nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.0=
0     0.00    0.00    0.00    0.00   0.00   0.00
> bcache11          0.00     0.00    0.00 11915.00     0.00 23832.00     4.=
00 1548362.98    0.06    0.00    0.06   0.02  23.20
>
>
> Fourth test with sync=3D1 and posixaio:
> fio --name=3Dtest --iodepth=3D1 --numjobs=3D1 --direct=3D1 --filename=3D/=
dev/bcache11 --filesize=3D1G --blocksize=3D4k --rw=3Drandwrite --sync=3D1 -=
-ioengine=3Dposixaio
> test: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dposixai=
o, iodepth=3D1
> fio-2.2.10
> Starting 1 process
> Jobs: 1 (f=3D1): [w(1)] [100.0% done] [0KB/27080KB/0KB /s] [0/6770/0 iops=
] [eta 00m:00s]
>
> iostat:
> 09/19/18 21:59:50
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.09    0.00    0.56    2.26    0.00   97.08
>
> Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-s=
z avgqu-sz   await r_await w_await  svctm  %util
> sdv               0.00     0.00    0.00 6605.00     0.00     4.00     0.0=
0     0.00    0.09    0.00    0.09   0.00   0.00
> nvme0c33n1        0.00     1.00    2.00    3.00     8.00    12.50     8.2=
0     0.00    0.00    0.00    0.00   0.00   0.00
> bcache11          0.00     0.00    0.00 13208.00     0.00 26416.00     4.=
00 838177.72    0.07    0.00    0.07   0.01  11.60
>
>
> Results of last two test are understandable: we see write request and flu=
sh request on caching device and flush request on backing device per one fi=
o write request. Fio iops are about 6K, because of slow backing device.
> But results of first two tests look a bit wierd to me: test with sync=3D1=
 shows more iops then test with sync=3D0. And there're no flush requests, w=
hen sync=3D1.
> I've tried to figure out if fio opens file with O_SYNC by running it in s=
trace:
> strace -e 'open' fio --name=3Dtest --iodepth=3D1 --numjobs=3D1 --direct=
=3D1 --filename=3D/dev/bcache11 --filesize=3D1G --blocksize=3D4k --rw=3Dran=
dwrite --sync=3D1 --ioengine=3Dlibaio
> And i found that it is ok:
> open("/dev/bcache11", O_RDWR|O_SYNC|O_DIRECT|O_NOATIME) =3D 3
>
> This behaviour is not reproducable on 4.4 kernel, which is a default for =
ubuntu 16.04 (that's why i mentioned 4.4 kernel).
> Btw, avgqu-sz show too high values for bcache, even if no operations are =
in progress.
>
> I can add full fio results, or make any additional tests or provide any o=
ther info if it helps.

--=20
Sitsofe | http://sucs.org/~sits/

