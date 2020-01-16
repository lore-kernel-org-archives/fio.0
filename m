Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f176.google.com ([209.85.167.176]:34053 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbgAPQMz (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Jan 2020 11:12:55 -0500
Received: by mail-oi1-f176.google.com with SMTP id l136so19346813oig.1
        for <fio@vger.kernel.org>; Thu, 16 Jan 2020 08:12:54 -0800 (PST)
MIME-Version: 1.0
References: <CAHEKYV6AqY=u=PZ2EAxLwM2a3TL6ByAwTRyURA=9CA1dAtwLbw@mail.gmail.com>
 <MWHPR11MB16790DF710A8EA7EB9118C37A9370@MWHPR11MB1679.namprd11.prod.outlook.com>
 <CANvN+ekCr5CxPe1pcVwc7MQG+MoUPK=YVpfcGT1Hn=4H1JQOqA@mail.gmail.com>
 <CAHEKYV6tMRCyhWnT9D+LaZ_U7j=wRLcMMU4yjBv1Te72FUYBag@mail.gmail.com>
 <CANvN+enS9cZpJrnvL=Z-X-cYHO4eGdfaG9aR5NQQ-KJUTM9Zug@mail.gmail.com>
 <CAHEKYV5L0wz0AKvuc9=zDYN0ug-dQYwTf7aGzE16Yu0S9Hi3Fg@mail.gmail.com> <CANvN+emieOE7jBdmTwaB+j-jrpyn4mjnO7+iUDD9bYBQJ18Szw@mail.gmail.com>
In-Reply-To: <CANvN+emieOE7jBdmTwaB+j-jrpyn4mjnO7+iUDD9bYBQJ18Szw@mail.gmail.com>
From: Mauricio Tavares <raubvogel@gmail.com>
Date: Thu, 16 Jan 2020 11:12:42 -0500
Message-ID: <CAHEKYV4qoGxYQ=NMsidt23c3O4YePrpcYXFimu04wjE4-2LWyg@mail.gmail.com>
Subject: Re: CPUs, threads, and speed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Thu, Jan 16, 2020 at 2:00 AM Andrey Kuzmin <andrey.v.kuzmin@gmail.com> w=
rote:
>
> On Wed, Jan 15, 2020 at 11:36 PM Mauricio Tavares <raubvogel@gmail.com> w=
rote:
> >
> > On Wed, Jan 15, 2020 at 2:00 PM Andrey Kuzmin <andrey.v.kuzmin@gmail.co=
m> wrote:
> > >
> > > On Wed, Jan 15, 2020 at 9:29 PM Mauricio Tavares <raubvogel@gmail.com=
> wrote:
> > > >
> > > > On Wed, Jan 15, 2020 at 1:04 PM Andrey Kuzmin <andrey.v.kuzmin@gmai=
l.com> wrote:
> > > > >
> > > > > On Wed, Jan 15, 2020 at 8:29 PM Gruher, Joseph R
> > > > > <joseph.r.gruher@intel.com> wrote:
> > > > > >
> > > > > > > -----Original Message-----
> > > > > > > From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> O=
n Behalf Of
> > > > > > > Mauricio Tavares
> > > > > > > Sent: Wednesday, January 15, 2020 7:51 AM
> > > > > > > To: fio@vger.kernel.org
> > > > > > > Subject: CPUs, threads, and speed
> > > > > > >
> > > > > > > Let's say I have a config file to preload drive that looks li=
ke this (stolen from
> > > > > > > https://github.com/intel/fiovisualizer/blob/master/Workloads/=
Precondition/fill
> > > > > > > _4KRandom_NVMe.ini)
> > > > > > >
> > > > > > > [global]
> > > > > > > name=3D4k random write 4 ios in the queue in 32 queues
> > > > > > > filename=3D/dev/nvme0n1
> > > > > > > ioengine=3Dlibaio
> > > > > > > direct=3D1
> > > > > > > bs=3D4k
> > > > > > > rw=3Drandwrite
> > > > > > > iodepth=3D4
> > > > > > > numjobs=3D32
> > > > > > > buffered=3D0
> > > > > > > size=3D100%
> > > > > > > loops=3D2
> > > > > > > randrepeat=3D0
> > > > > > > norandommap
> > > > > > > refill_buffers
> > > > > > >
> > > > > > > [job1]
> > > > > > >
> > > > > > > That is taking a ton of time, like days to go. Is there anyth=
ing I can do to speed it
> > > > > > > up?
> > > > > >
> > > > > > When you say preload, do you just want to write in the full cap=
acity of the drive?
> > > > >
> > > > > I believe that preload here means what in SSD world is called dri=
ve
> > > > > preconditioning. It means bringing a fresh drive into steady mode
> > > > > where it gives you the true performance in production over months=
 of
> > > > > use rather than the unrealistic fresh drive random write IOPS.
> > > > >
> > > > > > A sequential workload with larger blocks will be faster,
> > > > >
> > > > > No, you cannot get the job done by sequential writes since it doe=
sn't
> > > > > populate FTL translation tables like random writes do.
> > > > >
> > > > > As to taking a ton, the rule of thumb is to give the SSD 2xcapaci=
ty
> > > > > worth of random writes. At today speeds, that should take just a
> > > > > couple of hours.
> > > > >
> > > >       When you say 2xcapacity worth of random writes, do you mean j=
ust
> > > > setting size=3D200%?
> > >
> > > Right.
> > >
> >       Then I wonder what I am doing wrong now. I changed the config fil=
e to
> >
> > [root@testbox tests]# cat preload.conf
> > [global]
> > name=3D4k random write 4 ios in the queue in 32 queues
> > ioengine=3Dlibaio
> > direct=3D1
> > bs=3D4k
> > rw=3Drandwrite
> > iodepth=3D4
> > numjobs=3D32
> > buffered=3D0
> > size=3D200%
> > loops=3D2
> > random_generator=3Dtausworthe64
> > thread=3D1
> >
> > [job1]
> > filename=3D/dev/nvme0n1
> > [root@testbox tests]#
> >
> > but when I run it, now it spits out much larger eta times:
> >
> > Jobs: 32 (f=3D32): [w(32)][0.0%][w=3D382MiB/s][w=3D97.7k IOPS][eta
> > 16580099d:14h:55m:27s]]
>
>  Size is set on per thread basis, so you're doing 32x200%x2 loops=3D128
> drive capacities here.
>
> Also, using 32 threads doesn't improve anything. 2 (and even one)
> threads with qd=3D128 will push the drive
> to its limits.
>
     Update: so I redid the config file a bit to pass some of the
arguments from command line, and cut down number of jobs and loops.
And I ran it again, this time sequential write to the drive I have not
touched to see how fast it was going to go. My eta is still
astronomical:

[root@testbox tests]# cat preload_fio.conf
[global]
name=3D4k random
ioengine=3D${ioengine}
direct=3D1
bs=3D${bs_size}
rw=3D${iotype}
iodepth=3D4
numjobs=3D1
buffered=3D0
size=3D200%
loops=3D1

[job1]
filename=3D${devicename}
[root@testbox tests]# devicename=3D/dev/nvme1n1 ioengine=3Dlibaio
iotype=3Dwrite bs_size=3D128k ~/dev/fio/fio ./preload_fio.conf
job1: (g=3D0): rw=3Dwrite, bs=3D(R) 128KiB-128KiB, (W) 128KiB-128KiB, (T)
128KiB-128KiB, ioengine=3Dlibaio, iodepth=3D4
fio-3.17-68-g3f1e
Starting 1 process
Jobs: 1 (f=3D1): [W(1)][0.0%][w=3D1906MiB/s][w=3D15.2k IOPS][eta 108616d:00=
h:00m:24s]

> Regards,
> Andrey
> >
> > Compare with what I was getting with size=3D100%
> >
> >  Jobs: 32 (f=3D32): [w(32)][10.8%][w=3D301MiB/s][w=3D77.0k IOPS][eta 06=
d:13h:56m:51s]]
> >
> > > Regards,
> > > Andrey
> > > >
> > > > > Regards,
> > > > > Andrey
> > > > >
> > > > > > like:
> > > > > >
> > > > > > [global]
> > > > > > ioengine=3Dlibaio
> > > > > > thread=3D1
> > > > > > direct=3D1
> > > > > > bs=3D128k
> > > > > > rw=3Dwrite
> > > > > > numjobs=3D1
> > > > > > iodepth=3D128
> > > > > > size=3D100%
> > > > > > loops=3D2
> > > > > > [job00]
> > > > > > filename=3D/dev/nvme0n1
> > > > > >
> > > > > > Or if you have a use case where you specifically want to write =
it in with 4K blocks, you could probably increase your queue depth way beyo=
nd 4 and see improvement in performance, and you probably don't want to spe=
cify norandommap if you're trying to hit every block on the device.
> > > > > >
> > > > > > -Joe

