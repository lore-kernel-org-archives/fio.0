Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:58600 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692AbaFPPIP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Jun 2014 11:08:15 -0400
Received: by mail-yh0-f45.google.com with SMTP id t59so4375274yho.32
        for <fio@vger.kernel.org>; Mon, 16 Jun 2014 08:08:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN-=-wRVhkFHtW4BQb6DRBbaTpbogshXcdoPOyHuTCWKVkZECQ@mail.gmail.com>
References: <CAN-=-wRVhkFHtW4BQb6DRBbaTpbogshXcdoPOyHuTCWKVkZECQ@mail.gmail.com>
From: Devon Yablonski <dmyablonski@gmail.com>
Date: Mon, 16 Jun 2014 11:07:34 -0400
Message-ID: <CAN-=-wTR3wBt2C4xB7juWvBx1j0zm=PheiBR5DNSETkyVQS+zg@mail.gmail.com>
Subject: Re: Unexpected ramp_time behavior?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi, does anyone have any ideas about this ramp_time behavior?

On Tue, May 20, 2014 at 10:13 AM, Devon Yablonski <dmyablonski@gmail.com> wrote:
> Hi, I'm using fio 2.1.7 and I have the following fio configuration:
>
> #FIO CONFIGURATION
> [globals]
> name=fio_write
> rw=write
> size=5G
> ioengine=libaio
> direct=1
> unlink=0
> bs=4096
> iodepth=128
> scramble_buffers=1
> group_reporting
> gtod_reduce=0
> norandommap
> thread
> randrepeat=0
> ramp_time=0s
> random_generator=tausworthe
>
> [thread 0]
> filename=/dev/md0
>
> My result shows:
> /fio fioc.cfg
> fio_write: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
> fio-2.1.7
> Starting 1 thread
> Jobs: 1 (f=1): [W] [100.0% done] [0KB/799.8MB/0KB /s] [0/205K/0 iops]
> [eta 00m:00s]
> fio_write: (groupid=0, jobs=1): err= 0: pid=13889: Mon May 19 15:29:55 2014
>   write: io=5120.0MB, bw=821510KB/s, iops=205377, runt=  6382msec
> <snip>
> Run status group 0 (all jobs):
>   WRITE: io=5120.0MB, aggrb=821510KB/s, minb=821510KB/s,
> maxb=821510KB/s, mint=6382msec, maxt=6382msec
>
> Note that the runtime was about 6 seconds.
>
> If I change the ramp_time to 1s (ramp_time=1s) the test runs for 12-13
> seconds (about 2x) and writes much more data than size:
>
> fio_write: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
> fio-2.1.7
> Starting 1 thread
> Jobs: 1 (f=1): [W] [100.0% done] [0KB/626.1MB/0KB /s] [0/160K/0 iops]
> [eta 00m:00s]
> fio_write: (groupid=0, jobs=1): err= 0: pid=15860: Tue May 20 08:28:35 2014
>   write: io=9406.3MB, bw=717344KB/s, iops=179326, runt= 13427msec
> <snip>
> Run status group 0 (all jobs):
>   WRITE: io=9406.3MB, aggrb=717343KB/s, minb=717343KB/s,
> maxb=717343KB/s, mint=13427msec, maxt=13427msec
>
> The time remaining counts down to 0 and then the test keeps running -
> it seems like the test may be running a second iteration. What am I
> doing incorrectly?
>
> Thanks,
> Devon
