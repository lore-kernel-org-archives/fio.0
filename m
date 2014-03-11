Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: number_ios is checked on completion, not submission
Date: Tue, 11 Mar 2014 16:19:43 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029548C7BAC@G4W3202.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B4029548C76CF@G4W3202.americas.hpqcorp.net>
 <531F2D56.8080801@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B4029548C7B40@G4W3202.americas.hpqcorp.net>
 <531F3657.9030003@kernel.dk> <531F36C2.6060103@kernel.dk>
In-Reply-To: <531F36C2.6060103@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

That works.

  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.2%, 16=3D0.3%, 32=3D0.=
6%, >=3D64=3D98.7%
     issued    : total=3Dr=3D5000/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0


> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, 11 March, 2014 11:16 AM
> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
> Subject: Re: number_ios is checked on completion, not submission
>=20
> On 03/11/2014 10:14 AM, Jens Axboe wrote:
> > On 03/11/2014 10:08 AM, Elliott, Robert (Server Storage) wrote:
> >> That patch still exits after 5127 ios.
> >>
> >> io_bytes_exceeded is called 5128 times, but it sees td->io_u_queued=3D=
0
> >> each time.
> >
> > Can you check if ->cur_depth or ->io_u_in_flight catches it?
>=20
> It should, try this one.
>=20
> --
> Jens Axboe


