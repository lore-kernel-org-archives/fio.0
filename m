Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:29980 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JDURE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 4 Oct 2013 16:17:04 -0400
From: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
Subject: RE: precondition ssd drives w/ fio
Date: Fri, 4 Oct 2013 20:16:52 +0000
Message-ID: <C8CA972100601A41AE302914E9CE1946C5BC3059@NTXBOIMBX03.micron.com>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
 <20131003204206.GA28048@highx.de>
 <CAAAK+WXf8okat6b91cxMZfYfSA5hEtH6et9pV_Eb=NPddOLVpA@mail.gmail.com>
 <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com>
 <CAAAK+WWaEisodD-b0pFegk=1mw6LYVf3pSLyo31Qe9wCOkjssw@mail.gmail.com>
In-Reply-To: <CAAAK+WWaEisodD-b0pFegk=1mw6LYVf3pSLyo31Qe9wCOkjssw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>
Cc: Juergen Salk <juergen.salk@gmx.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: Brian L. [mailto:brianclam@gmail.com]
> Sent: Friday, October 04, 2013 11:23 AM
> To: Jeffrey Mcvay (jmcvay)
> Cc: Juergen Salk; fio@vger.kernel.org
> Subject: Re: precondition ssd drives w/ fio
>=20
> On Thu, Oct 3, 2013 at 2:39 PM, Jeffrey Mcvay (jmcvay)
> <jmcvay@micron.com> wrote:
> >
> >> -----Original Message-----
> >> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org]
> On
> >> Behalf Of Brian L.
> >> Sent: Thursday, October 03, 2013 2:09 PM
> >> To: Juergen Salk; fio@vger.kernel.org
> >> Subject: Re: precondition ssd drives w/ fio
> >>
> >> Thank you all for the response.  I found ssd-steadystate.fio in the
> >> tarball.
> >>
> >> Brian
> >>
> >> Brian L.
> >>
> >>
> >> On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de>
> >> wrote:
> >> > * Brian L. <brianclam@gmail.com> [131003 12:31]:
> >> >
> >> >> For benchmarking SSD drives, I was told that we should
> precondition
> >> >> our drives to get more accurate real world reading.
> >> >>
> >> >> I was wondering if anyone is using fio itself to precondition ssd
> >> >> drives or use a different script to populate random data on the
> >> >> drives?
> >> >
> >> > Yes I did. The fio source tarball comes with a number of sample
> >> > job files including `ssd-steadystate.fio=EF=BF=BD, which might be
> >> > useful for preconditioning of ssd devices.
> >> >
> >> > Regards,
> >> >
> >> > Juergen
> >> >
> >> > --
> >> > GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe fio" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > Brian,
> >
> > Check the SNIA standard for how to test SSD performance.
> >
> > There are quite likely more elegant solutions, but I use the jobfile
> below.  It is run sequential workloads of 100% write, 100% read, 100%
> write, and finally 100% read. The purpose of the reads is to force any
> existing bad or marginal blocks out of the user pool. This will
> precondition the drive. Please be aware that using numjobs > 1 is may
> not be a sequential workload.
> >
> > To measure steady state values takes a little more effort. I use the
> write_bw_log feature, run for several hours, and use statistical
> analysis to find the mean and standard deviation in the target time
> frame.
> >
> > Cheers,
> > Jeff
> >
> > [global]
> > thread
> > group_reporting=3D1
> > direct=3D1
> > norandommap=3D1
> > randrepeat=3D0
> > refill_buffers
> > ioengine=3D${IOENGINE}
> > filename=3D${FILENAME}
> >
> > log_avg_msec=3D1000
> >
> > [128kB_SeqWr_1x8_1stPass]
> > write_bw_log=3D128kB_SeqWr_1x8_1stPass
> > bs=3D128k
> > rw=3Dwrite
> > numjobs=3D1
> > iodepth=3D8
> >
> > [128kB_SeqRd_1x8_1ndPass]
> > stonewall
> > write_bw_log=3D128kB_SeqRd_1x8_1ndPass
> > bs=3D128k
> > rw=3Dread
> > numjobs=3D1
> > iodepth=3D8
> >
> >
> > [128kB_SeqWr_1x8_2ndPass]
> > stonewall
> > write_bw_log=3D128kB_SeqWr_1x8_2ndPass
> > bs=3D128k
> > rw=3Dwrite
> > numjobs=3D1
> > iodepth=3D8
> >
> > [128kB_SeqRd_1x8_2ndPass]
> > stonewall
> > write_bw_log=3D128kB_SeqRd_1x8_2ndPass
> > bs=3D128k
> > rw=3Dread
> > numjobs=3D1
> > iodepth=3D8
>=20
>=20
> thanks Jeffrey,
>=20
> I think I am going to use your FIO template since the example
> ssd-steadystate.fio (in the tarball) takes about 24 hr to run for each
> drive because section [random-write-steady] runs over the entire
> drive.   The drives I am testing range from 200GB up to 800GB.
>=20
> That is way too long for me as I have 16 drives!  I have been testing
> the drives at different rw profiles (also different blocksize and diff
> iodepth at times).
>=20
> I usually limit my run to size=3D10GB since I have so many drives that I
> need to run against different profiles, blocksize, etc...  What is the
> size (in GB) / time limit that that you guys generally run against
> each drive for good results?
>=20
>=20
>=20
> =3D=3D=3D
> ssd-steadystate.fio template below
> =3D=3D=3D
>=20
> [global]
> ioengine=3Dlibaio
> direct=3D1
> group_reporting=3D1
> #filename=3D/dev/fioa
> filename=3D${mydisk}
>=20
> [sequential-fill]
> description=3DSequential fill phase
> rw=3Dwrite
> iodepth=3D16
> bs=3D1M
>=20
> [random-write-steady]
> stonewall
> description=3DRandom write steady state phase
> rw=3Drandwrite
> bs=3D4K
> iodepth=3D32
> numjobs=3D4
> #
> # might need to fix var below
> #
> write_bw_log=3D${mydisk}-steady-state

To truly profile an SSD you have to use the entire drive. If you restrict t=
he size written to a fraction of the drive an SSD will use the remainder as=
 increased overprovision to reduce write amplification and performance.=20

Also, most SSD's will not access NAND for reads to LBAs not already written=
. When you measure a read to an unwritten LBA you actual measure the speed =
at which the SSD can create 0's and ship them back.

To get to your question on how long to run a random workload before measuri=
ng performance refer to the image at the link below.

http://www.ssdperformanceblog.com/wp-content/uploads/2010/07/SSDstates.png

Prior to section A the drive was preconditioned with 2 sequential fills.=20

Section A: This the performance seen before background reclamation starts. =
The drive is writing to NAND blocks that are already erases.=20
Section B: Reclamation starts. This is the lowest performance seen by an SS=
D. The drive is moving user data to free blocks for erase. This is also the=
 time of maximum write amplification rate.=20
Section C: The drive has reached steady state operation. Background reclama=
tion is still running, but at a lower rate. This is due to more user data b=
eing invalidated and less user data movement required to free a block for e=
rase. The rate of write amplification will also be consistent and overall w=
rite amplification will trend to this value over time.

How long you need to run a random workload to reach steady state depends on=
 the SSD. The best method graph the data and look for the steady state perf=
ormance. A more statistical approach is to measure the mean performance ove=
r some unit of time and compare this to several such samples. When mean per=
formance samples reach an acceptable minimum level of variance, your done.

Cheers,
Jeff
