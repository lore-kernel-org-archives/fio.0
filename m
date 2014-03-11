Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: number_ios is checked on completion, not submission
Date: Tue, 11 Mar 2014 16:08:32 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net>
 <531F2D56.8080801@kernel.dk>
In-Reply-To: <531F2D56.8080801@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

That patch still exits after 5127 ios.

io_bytes_exceeded is called 5128 times, but it sees td->io_u_queued=3D0 eac=
h time.

keep_running makes it to the if (td->o.number_ios) branch one time, and see=
s number_ios set to 5127  and td->o.number_ios set to 5000 (causing it to r=
eturn 0 and trigger the end, after 5127 ios).

> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, 11 March, 2014 10:36 AM
> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
> Subject: Re: number_ios is checked on completion, not submission
>=20
> On 03/10/2014 03:12 PM, Elliott, Robert (Server Storage) wrote:
> > Since number_ios is checked in io_u.c account_io_completion() rather th=
an
> a submission function, fio actually runs the requested number of I/Os plu=
s
> iodepth - 1.
> >
> > Example: for a job specifying:
> > number_ios=3D5000
> > iodepth=3D128
> >
> > the results are:
> >    read : io=3D20000KB, bw=3D222222KB/s, iops=3D56966, runt=3D    90mse=
c
> >    IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.2%, 16=3D0.3%, 32=
=3D0.6%,
> >=3D64=3D98.8%
> >       issued    : total=3Dr=3D5127/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=
=3D0
> >
> > Should that just be documented as such, or should this logic be moved t=
o
> submission?
> > static void account_io_completion(struct thread_data *td, struct io_u
> *io_u,
> > ...
> >          if (td->o.number_ios && !--td->o.number_ios)
> >                  td->done =3D 1;
>=20
> Can you try the attached patch and see if that makes it behave more like
> expected?
>=20
> --
> Jens Axboe


