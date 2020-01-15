Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ot1-f45.google.com ([209.85.210.45]:40142 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgAOWjY (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jan 2020 17:39:24 -0500
Received: by mail-ot1-f45.google.com with SMTP id w21so17577458otj.7
        for <fio@vger.kernel.org>; Wed, 15 Jan 2020 14:39:24 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
 <DF4PR8401MB1241A17DB6202AC287E57DC8AB370@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <DF4PR8401MB1241A17DB6202AC287E57DC8AB370@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Wed, 15 Jan 2020 17:39:12 -0500
Message-ID: <CAHEKYV7CiYwpUJEjdyzczdbXC8rt+yiCXr6-BiLWy2EpuCaMEw@mail.gmail.com>
Subject: Re: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jan 15, 2020 at 4:33 PM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of
> > Mauricio Tavares
> > Sent: Wednesday, January 15, 2020 9:51 AM
> > Subject: CPUs, threads, and speed
> >
> ...
> > [global]
> > name=4k random write 4 ios in the queue in 32 queues
> > filename=/dev/nvme0n1
> > ioengine=libaio
> > direct=1
> > bs=4k
> > rw=randwrite
> > iodepth=4
> > numjobs=32
> > buffered=0
> > size=100%
> > loops=2
> > randrepeat=0
> > norandommap
> > refill_buffers
> >
> > [job1]
> >
> > That is taking a ton of time, like days to go. Is there anything I can
> > do to speed it up? For instance, what is the default value for
> > cpus_allowed (or cpumask)[2]? Is it all CPUs? If not what would I gain
> > by throwing more cpus at the problem?
> >
> > I also read[2] by default fio uses fork. What would I get by going to
> > threads?
>
> > Jobs: 32 (f=32): [w(32)][10.8%][w=301MiB/s][w=77.0k IOPS][eta 06d:13h:56m:51s]]
>
> 77 kIOPs for random writes isn't bad - check your drive data sheet.
> If the drive is 1 TB, it should take
>     1 TB / (77k * 4 KiB) = 3170 s = 52.8 minutes
> to write the whole drive.
>
      Since the drive is 4TB, we are talking about 3.5h to complete
the task, right?

> Best practice is to use all CPU cores, lock threads to cores, and
> be NUMA aware. If the device is attached to physical CPU 0 and that CPU
> has 12 cores known to linux as 0-11 (per "lscpu" or "numactl --hardware"),

I have two CPUs with 16 cores each; I thought that meant numjobs=32.
If Iw as wrong, I learned something new!

> try:
>   iodepth=16
>   numjobs=12
>   cpus_allowed=0-11
>   cpus_allowed_policy=split
>
> Based on these:
>   numjobs=32, size=100%, loops=2
> fio will run each job for that many bytes, so a 1 TB drive will result
> in IOs for 64 TB rather than 1 TB. That could easily result in the
> multi-day estimate.
>
      Let's see if I understand this: your 64TB number came from 32*1TB*1*2?

> Other nits:
> * thread - threading might be slightly more efficient than
>   spawning full processes
> * gtod_reduce=1 - precision latency measurements don't matter for this
> * refill_buffers - presuming you don't care about the data contents,
>   don't include this. zero_buffers is the simplest/fastest, unless you're
>   concerned that the device might do compression or zero detection
> * norandommap - if you want it to hit each LBA a precise number
>   of times, you can't include this; fio won't remember what it's
>   done. There is a lot of overhead in keeping track, though.
>

