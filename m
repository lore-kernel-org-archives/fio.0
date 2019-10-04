Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:52759 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDVeV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Oct 2019 17:34:21 -0400
Received: by mail-wm1-f41.google.com with SMTP id r19so7161642wmh.2
        for <fio@vger.kernel.org>; Fri, 04 Oct 2019 14:34:19 -0700 (PDT)
MIME-Version: 1.0
References: <CABO+gV-AvdsAWe+0SZXga4iDZ-C8xR9MuHQhBzm7aBiuGid8pg@mail.gmail.com>
 <CALjAwxjpbpjv5OgvCUmxttNcXs2xtjUUrTyMdnac0ctmYwEiDA@mail.gmail.com>
 <CABO+gV-rjH3CJw6-G2Oj2DZ4xOb7v7VNx_aocqU3iwODZPvBtQ@mail.gmail.com> <CALjAwxhRz6OVURRTmTyUrnN+7pLy0SpC94NEE3izJyd2Gu3yfg@mail.gmail.com>
In-Reply-To: <CALjAwxhRz6OVURRTmTyUrnN+7pLy0SpC94NEE3izJyd2Gu3yfg@mail.gmail.com>
From: Elliott Balsley <elliott@altsystems.com>
Date: Fri, 4 Oct 2019 14:34:07 -0700
Message-ID: <CABO+gV8xNYo-aJ0hpr48z87tSxG7Yu6_HbmcRrZ+0AB969yyKQ@mail.gmail.com>
Subject: Re: How to cancel job
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

> This sounds unexpected. Are there easy reproduction steps for this? Is
> I/O definitely being processed by the lower levels of the kernel?

I'm not sure how to reproduce it reliably.  It seems to happen more
often with NFS, not local filesystems.  Here is an example where
Ctrl-C does nothing.  Then I ran "killall -9 fio" in another terminal"
and it took about 20 seconds before the disk activity actually stopped
in iostat.

$ fio --name=write --rw=write --bs=1M --size=100G --end_fsync=1
--filename_format=/mnt/rivendell/fio.\$jobnum.\$filenum
write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB,
(T) 1024KiB-1024KiB, ioengine=psync, iodepth=1
fio-3.1
Starting 1 process
write: Laying out IO file (1 file / 102400MiB)
fio: native_fallocate call failed: Operation not supported
^Cbs: 1 (f=1): [W(1)][14.3%][r=0KiB/s,w=1327MiB/s][r=0,w=1327 IOPS][eta 00m:42s]
fio: terminating on signal 2
Killed1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]

$ ps aux | grep fio
root     243211 36.0  0.0 931316  3068 ?        Ds   14:25   0:08 fio
--name=write --rw=write --bs=1M --size=100G --end_fsync=1
--filename_format=/mnt/rivendell/fio.$jobnum.$filenum
root     243238  0.0  0.0 112708   988 pts/0    S+   14:26   0:00 grep
--color=auto fio

