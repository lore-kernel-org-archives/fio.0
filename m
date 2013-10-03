Return-Path: <fio-owner@vger.kernel.org>
Received: from mailout.micron.com ([137.201.242.129]:20244 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab3JCVjn convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 3 Oct 2013 17:39:43 -0400
From: "Jeffrey Mcvay (jmcvay)" <jmcvay@micron.com>
Subject: RE: precondition ssd drives w/ fio
Date: Thu, 3 Oct 2013 21:39:32 +0000
Message-ID: <C8CA972100601A41AE302914E9CE1946C5BC2E64@NTXBOIMBX03.micron.com>
References: <CAAAK+WW66DdYt2JEG+2K42vWzczn38xtnh5WK-1x97zFbdkyqg@mail.gmail.com>
 <20131003204206.GA28048@highx.de>
 <CAAAK+WXf8okat6b91cxMZfYfSA5hEtH6et9pV_Eb=NPddOLVpA@mail.gmail.com>
In-Reply-To: <CAAAK+WXf8okat6b91cxMZfYfSA5hEtH6et9pV_Eb=NPddOLVpA@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>, Juergen Salk <juergen.salk@gmx.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>


> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Brian L.
> Sent: Thursday, October 03, 2013 2:09 PM
> To: Juergen Salk; fio@vger.kernel.org
> Subject: Re: precondition ssd drives w/ fio
>=20
> Thank you all for the response.  I found ssd-steadystate.fio in the
> tarball.
>=20
> Brian
>=20
> Brian L.
>=20
>=20
> On Thu, Oct 3, 2013 at 1:42 PM, Juergen Salk <juergen.salk@gmx.de>
> wrote:
> > * Brian L. <brianclam@gmail.com> [131003 12:31]:
> >
> >> For benchmarking SSD drives, I was told that we should precondition
> >> our drives to get more accurate real world reading.
> >>
> >> I was wondering if anyone is using fio itself to precondition ssd
> >> drives or use a different script to populate random data on the
> >> drives?
> >
> > Yes I did. The fio source tarball comes with a number of sample
> > job files including `ssd-steadystate.fio=EF=BF=BD, which might be
> > useful for preconditioning of ssd devices.
> >
> > Regards,
> >
> > Juergen
> >
> > --
> > GPG A997BA7A | 87FC DA31 5F00 C885 0DC3  E28F BD0D 4B33 A997 BA7A
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Brian,

Check the SNIA standard for how to test SSD performance.

There are quite likely more elegant solutions, but I use the jobfile below.=
  It is run sequential workloads of 100% write, 100% read, 100% write, and =
finally 100% read. The purpose of the reads is to force any existing bad or=
 marginal blocks out of the user pool. This will precondition the drive. Pl=
ease be aware that using numjobs > 1 is may not be a sequential workload.=20

To measure steady state values takes a little more effort. I use the write_=
bw_log feature, run for several hours, and use statistical  analysis to fin=
d the mean and standard deviation in the target time frame.=20

Cheers,
Jeff

[global]
thread
group_reporting=3D1
direct=3D1
norandommap=3D1
randrepeat=3D0
refill_buffers
ioengine=3D${IOENGINE}
filename=3D${FILENAME}

log_avg_msec=3D1000

[128kB_SeqWr_1x8_1stPass]
write_bw_log=3D128kB_SeqWr_1x8_1stPass
bs=3D128k
rw=3Dwrite
numjobs=3D1
iodepth=3D8

[128kB_SeqRd_1x8_1ndPass]
stonewall
write_bw_log=3D128kB_SeqRd_1x8_1ndPass
bs=3D128k
rw=3Dread
numjobs=3D1
iodepth=3D8


[128kB_SeqWr_1x8_2ndPass]
stonewall
write_bw_log=3D128kB_SeqWr_1x8_2ndPass
bs=3D128k
rw=3Dwrite
numjobs=3D1
iodepth=3D8

[128kB_SeqRd_1x8_2ndPass]
stonewall
write_bw_log=3D128kB_SeqRd_1x8_2ndPass
bs=3D128k
rw=3Dread
numjobs=3D1
iodepth=3D8
