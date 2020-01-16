Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f42.google.com ([209.85.128.42]:36382 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbgAPAtS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jan 2020 19:49:18 -0500
Received: by mail-wm1-f42.google.com with SMTP id p17so2000491wma.1
        for <fio@vger.kernel.org>; Wed, 15 Jan 2020 16:49:17 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
 <DF4PR8401MB1241A17DB6202AC287E57DC8AB370@DF4PR8401MB1241.NAMPRD84.PROD.OUTLOOK.COM>
 <CAHEKYV7CiYwpUJEjdyzczdbXC8rt+yiCXr6-BiLWy2EpuCaMEw@mail.gmail.com>
In-Reply-To: <CAHEKYV7CiYwpUJEjdyzczdbXC8rt+yiCXr6-BiLWy2EpuCaMEw@mail.gmail.com>
From: Ming Lei <tom.leiming@gmail.com>
Date: Thu, 16 Jan 2020 08:49:05 +0800
Message-ID: <CACVXFVOLOvAxuLnSvL=AZRdkEXA4FBRnarMkzyBo7YfCiRc+Bw@mail.gmail.com>
Subject: Re: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: "Elliott, Robert (Servers)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Jan 16, 2020 at 8:15 AM Mauricio Tavares <raubvogel@gmail.com> wrote:
>
> On Wed, Jan 15, 2020 at 4:33 PM Elliott, Robert (Servers)
> <elliott@hpe.com> wrote:
> >
> >
> >
> > > -----Original Message-----
> > > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of
> > > Mauricio Tavares
> > > Sent: Wednesday, January 15, 2020 9:51 AM
> > > Subject: CPUs, threads, and speed
> > >
> > ...
> > > [global]
> > > name=4k random write 4 ios in the queue in 32 queues
> > > filename=/dev/nvme0n1
> > > ioengine=libaio
> > > direct=1
> > > bs=4k
> > > rw=randwrite
> > > iodepth=4
> > > numjobs=32
> > > buffered=0
> > > size=100%
> > > loops=2
> > > randrepeat=0
> > > norandommap
> > > refill_buffers
> > >
> > > [job1]
> > >
> > > That is taking a ton of time, like days to go. Is there anything I can
> > > do to speed it up? For instance, what is the default value for
> > > cpus_allowed (or cpumask)[2]? Is it all CPUs? If not what would I gain
> > > by throwing more cpus at the problem?
> > >
> > > I also read[2] by default fio uses fork. What would I get by going to
> > > threads?
> >
> > > Jobs: 32 (f=32): [w(32)][10.8%][w=301MiB/s][w=77.0k IOPS][eta 06d:13h:56m:51s]]
> >
> > 77 kIOPs for random writes isn't bad - check your drive data sheet.
> > If the drive is 1 TB, it should take
> >     1 TB / (77k * 4 KiB) = 3170 s = 52.8 minutes
> > to write the whole drive.
> >
>       Since the drive is 4TB, we are talking about 3.5h to complete
> the task, right?
>
> > Best practice is to use all CPU cores, lock threads to cores, and
> > be NUMA aware. If the device is attached to physical CPU 0 and that CPU
> > has 12 cores known to linux as 0-11 (per "lscpu" or "numactl --hardware"),
>
> I have two CPUs with 16 cores each; I thought that meant numjobs=32.
> If Iw as wrong, I learned something new!

Not sure 32 jobs is good, which will write the drive 32 times, and each job
runs the random write on the whole drive. Does that preconditioning need to
run random write over the drive so many times?

Thanks,
Ming Lei

