Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: lots of closes causing lots of invalidates while running
Date: Fri, 4 Jul 2014 21:26:08 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B86823@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402958B83482@G9W0745.americas.hpqcorp.net>
 <53B71A50.603@kernel.dk>
In-Reply-To: <53B71A50.603@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "dgilbert@interlog.com" <dgilbert@interlog.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Friday, 04 July, 2014 4:19 PM
> To: Elliott, Robert (Server Storage); fio@vger.kernel.org
> Cc: dgilbert@interlog.com
> Subject: Re: lots of closes causing lots of invalidates while running
>=20
> How big are the devices? Should only open/close once per reading it, but
> if it's scsi_debug and they are small, then that might explain it. If
> that's not the case, it's definitely a but and we'll need to look into it=
.
>=20

My original test was with 128 MiB. =20
Same result with 1 GiB.
Goes away with 2 GiB and 4 GiB.




