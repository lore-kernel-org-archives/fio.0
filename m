Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f53.google.com ([209.85.217.53]:34232 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgAOTA4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jan 2020 14:00:56 -0500
Received: by mail-vs1-f53.google.com with SMTP id g15so11120124vsf.1
        for <fio@vger.kernel.org>; Wed, 15 Jan 2020 11:00:55 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
 <MWHPR11MB16790DF710A8EA7EB9118C37A9370@MWHPR11MB1679.namprd11.prod.outlook.com>
 <CANvN+ekCr5CxPe1pcVwc7MQG+MoUPK=YVpfcGT1Hn=4H1JQOqA@mail.gmail.com> <CAHEKYV6tMRCyhWnT9D+LaZ_U7j=wRLcMMU4yjBv1Te72FUYBag@mail.gmail.com>
In-Reply-To: <CAHEKYV6tMRCyhWnT9D+LaZ_U7j=wRLcMMU4yjBv1Te72FUYBag@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 15 Jan 2020 22:00:44 +0300
Message-ID: <CANvN+enS9cZpJrnvL=Z-X-cYHO4eGdfaG9aR5NQQ-KJUTM9Zug@mail.gmail.com>
Subject: Re: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Mauricio Tavares <raubvogel@gmail.com>
Cc: "Gruher, Joseph R" <joseph.r.gruher@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Wed, Jan 15, 2020 at 9:29 PM Mauricio Tavares <raubvogel@gmail.com> wrot=
e:
>
> On Wed, Jan 15, 2020 at 1:04 PM Andrey Kuzmin <andrey.v.kuzmin@gmail.com>=
 wrote:
> >
> > On Wed, Jan 15, 2020 at 8:29 PM Gruher, Joseph R
> > <joseph.r.gruher@intel.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Beha=
lf Of
> > > > Mauricio Tavares
> > > > Sent: Wednesday, January 15, 2020 7:51 AM
> > > > To: fio@vger.kernel.org
> > > > Subject: CPUs, threads, and speed
> > > >
> > > > Let's say I have a config file to preload drive that looks like thi=
s (stolen from
> > > > https://github.com/intel/fiovisualizer/blob/master/Workloads/Precon=
dition/fill
> > > > _4KRandom_NVMe.ini)
> > > >
> > > > [global]
> > > > name=3D4k random write 4 ios in the queue in 32 queues
> > > > filename=3D/dev/nvme0n1
> > > > ioengine=3Dlibaio
> > > > direct=3D1
> > > > bs=3D4k
> > > > rw=3Drandwrite
> > > > iodepth=3D4
> > > > numjobs=3D32
> > > > buffered=3D0
> > > > size=3D100%
> > > > loops=3D2
> > > > randrepeat=3D0
> > > > norandommap
> > > > refill_buffers
> > > >
> > > > [job1]
> > > >
> > > > That is taking a ton of time, like days to go. Is there anything I =
can do to speed it
> > > > up?
> > >
> > > When you say preload, do you just want to write in the full capacity =
of the drive?
> >
> > I believe that preload here means what in SSD world is called drive
> > preconditioning. It means bringing a fresh drive into steady mode
> > where it gives you the true performance in production over months of
> > use rather than the unrealistic fresh drive random write IOPS.
> >
> > > A sequential workload with larger blocks will be faster,
> >
> > No, you cannot get the job done by sequential writes since it doesn't
> > populate FTL translation tables like random writes do.
> >
> > As to taking a ton, the rule of thumb is to give the SSD 2xcapacity
> > worth of random writes. At today speeds, that should take just a
> > couple of hours.
> >
>       When you say 2xcapacity worth of random writes, do you mean just
> setting size=3D200%?

Right.

Regards,
Andrey
>
> > Regards,
> > Andrey
> >
> > > like:
> > >
> > > [global]
> > > ioengine=3Dlibaio
> > > thread=3D1
> > > direct=3D1
> > > bs=3D128k
> > > rw=3Dwrite
> > > numjobs=3D1
> > > iodepth=3D128
> > > size=3D100%
> > > loops=3D2
> > > [job00]
> > > filename=3D/dev/nvme0n1
> > >
> > > Or if you have a use case where you specifically want to write it in =
with 4K blocks, you could probably increase your queue depth way beyond 4 a=
nd see improvement in performance, and you probably don't want to specify n=
orandommap if you're trying to hit every block on the device.
> > >
> > > -Joe

