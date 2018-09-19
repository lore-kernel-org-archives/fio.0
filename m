Return-Path: <fio-owner@vger.kernel.org>
Received: from forward4j.cmail.yandex.net ([5.255.227.22]:47511 "EHLO
        forward4j.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731211AbeITB3v (ORCPT
        <rfc822;fio@vger.kernel.org>); Wed, 19 Sep 2018 21:29:51 -0400
From: =?utf-8?B?0JfQsNGF0LDRgNC+0LIg0JDQu9C10LrRgdC10Lk=?= 
        <zakharov.a.g@yandex.ru>
In-Reply-To: <CALjAwxgPhfxnP68u7xdwXwkw-ZL3Tmrf20MD=n=WBy+Jd_-ESQ@mail.gmail.com>
References: <1769401537372008@iva3-a2a8aac410a1.qloud-c.yandex.net> <CALjAwxgPhfxnP68u7xdwXwkw-ZL3Tmrf20MD=n=WBy+Jd_-ESQ@mail.gmail.com>
Subject: Re: Fio O_SYNC and libaio on 4.15 kernel doesn't flush data
MIME-Version: 1.0
Date: Thu, 20 Sep 2018 02:42:25 +0700
Message-Id: <2474471537386145@iva4-f779e14fe728.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Thanks for the answer and sorry for this mess.

Here is an example with 4.15 kernel:
~# uname -r
4.15.0-34-generic

Bcache is in writeback mode.
~# cat /sys/class/block/bcache11/bcache/cache_mode 
writethrough [writeback] writearound none

First test, libaio and sync=0:
fio --name=test --iodepth=1 --numjobs=1 --direct=1 --filename=/dev/bcache11 --filesize=1G --blocksize=4k --rw=randwrite --sync=0 --ioengine=libaio
test: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.10
Starting 1 process
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/61234KB/0KB /s] [0/15.4K/0 iops] [eta 00m:00s]

iostat -xt 1 result while testing:
09/19/18 21:52:26
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.22    0.00    1.35    0.00    0.00   98.43

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdv               0.00     0.00    0.00    1.00     0.00     4.00     8.00     0.00    0.00    0.00    0.00   0.00   0.00
nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache11          0.00     0.00    0.00 15894.00     0.00 63576.00     8.00 3098732.18    0.03    0.00    0.03   0.03  52.40


Second test with libaio and sync=1:
fio --name=test --iodepth=1 --numjobs=1 --direct=1 --filename=/dev/bcache11 --filesize=1G --blocksize=4k --rw=randwrite --sync=1 --ioengine=libaio
test: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.10
Starting 1 process
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/88123KB/0KB /s] [0/22.3K/0 iops] [eta 00m:00s]

iostat while testing:
09/19/18 21:54:17
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.19    0.00    1.16    0.00    0.00   98.65

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdv               0.00     0.00    0.00    1.00     0.00     4.00     8.00     0.00    0.00    0.00    0.00   0.00   0.00
nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache11          0.00     0.00    0.00 22118.00     0.00 88472.00     8.00 1014565.97    0.04    0.00    0.04   0.01  16.40


Third test with fsync=1 and libaio:
fio --name=test --iodepth=1 --numjobs=1 --direct=1 --filename=/dev/bcache11 --filesize=1G --blocksize=4k --rw=randwrite --fsync=1 --ioengine=libaio
test: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.10
Starting 1 process
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/21280KB/0KB /s] [0/5320/0 iops] [eta 00m:00s]

iostat:
  09/19/18 21:56:52
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.19    0.00    0.91    1.38    0.00   97.52

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdv               0.00     0.00    0.00 5959.00     0.00     4.00     0.00     0.00    0.09    0.00    0.09   0.00   0.00
nvme0c33n1        0.00     0.00    2.00    0.00     8.00     0.00     8.00     0.00    0.00    0.00    0.00   0.00   0.00
bcache11          0.00     0.00    0.00 11915.00     0.00 23832.00     4.00 1548362.98    0.06    0.00    0.06   0.02  23.20


Fourth test with sync=1 and posixaio:
fio --name=test --iodepth=1 --numjobs=1 --direct=1 --filename=/dev/bcache11 --filesize=1G --blocksize=4k --rw=randwrite --sync=1 --ioengine=posixaio                                    
test: (g=0): rw=randwrite, bs=4K-4K/4K-4K/4K-4K, ioengine=posixaio, iodepth=1
fio-2.2.10
Starting 1 process
Jobs: 1 (f=1): [w(1)] [100.0% done] [0KB/27080KB/0KB /s] [0/6770/0 iops] [eta 00m:00s]

iostat:
09/19/18 21:59:50
avg-cpu:  %user   %nice %system %iowait  %steal   %idle
           0.09    0.00    0.56    2.26    0.00   97.08

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sdv               0.00     0.00    0.00 6605.00     0.00     4.00     0.00     0.00    0.09    0.00    0.09   0.00   0.00
nvme0c33n1        0.00     1.00    2.00    3.00     8.00    12.50     8.20     0.00    0.00    0.00    0.00   0.00   0.00
bcache11          0.00     0.00    0.00 13208.00     0.00 26416.00     4.00 838177.72    0.07    0.00    0.07   0.01  11.60


Results of last two test are understandable: we see write request and flush request on caching device and flush request on backing device per one fio write request. Fio iops are about 6K, because of slow backing device.
But results of first two tests look a bit wierd to me: test with sync=1 shows more iops then test with sync=0. And there're no flush requests, when sync=1.
I've tried to figure out if fio opens file with O_SYNC by running it in strace:
strace -e 'open' fio --name=test --iodepth=1 --numjobs=1 --direct=1 --filename=/dev/bcache11 --filesize=1G --blocksize=4k --rw=randwrite --sync=1 --ioengine=libaio
And i found that it is ok:
open("/dev/bcache11", O_RDWR|O_SYNC|O_DIRECT|O_NOATIME) = 3

This behaviour is not reproducable on 4.4 kernel, which is a default for ubuntu 16.04 (that's why i mentioned 4.4 kernel).
Btw, avgqu-sz show too high values for bcache, even if no operations are in progress.

I can add full fio results, or make any additional tests or provide any other info if it helps.


20.09.2018, 01:48, "Sitsofe Wheeler" <sitsofe@gmail.com>:
> Hi,
>
> On Wed, 19 Sep 2018 at 16:56, Захаров Алексей <zakharov.a.g@yandex.ru> wrote:
>>  I'm testing bcache device in ubuntu 16.04 with 4.4 and 4.15 (hwe-edge) kernels and noticed some strange fio behaviour.
>>  When i run fio with --ioengine=libaio and --sync=1 options - it only works as expected on 4.4 kernel. There're additional flush "write" requests, also to backing device of bcache. If i run it on 4.15 - then iops on caching device are same as fio shows and there're no any io on backing device. But, if i set ioengine to posixaio or sync or even if i set --fsync=1 option, then it works as expected on 4.15 - i can see flush io's.
>>  It looks like O_SYNC doesn't work with 4.15 when fio runs with libaio.
>>  Kernel was installed from ubuntu repos, but libaio is used same as for 4.4 kernel and I assume that it is the root cause. But i can't find any proof of this guess.
>>
>>  Have any changes been done in kernel that affect O_SYNC or is it libaio(or fio) bug?
>>
>>  Used fio-2.2.10 and fio-3.9.
>>
>>  Hope for any help with understanding this behaviour.
>
> You didn't include the full job that you ran so it's going to be very
> hard for anyone here to say too much... If I understand what you're
> saying correctly:
>
> - You ran fio-2.2.10 on an Ubuntu 4.4 kernel with bcache and saw
> flushing of writes to the backing disk.
> - You ran fio-2.2.10 on an Ubuntu 4.10 kernel with bcache and and no
> flushing of write to the backing disk.
>
> Assuming that you haven't changed anything else doesn't that either
> suggest there's been a change in how bcache works (it can operate as
> a non-volatile write back cache so it doesn't have to flush to backing
> on a sync) or that there's an issue with the kernel? How would fio
> have known to change things between kernel versions? Another thing to
> check would be to see if you see flushes on non-bcache devices...
>
> --
> Sitsofe | http://sucs.org/~sits/

-- 
Regards,
Aleksei Zakharov


