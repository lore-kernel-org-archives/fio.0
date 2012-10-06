Return-Path: <jmcvay@micron.com>
From: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Subject: RE: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme
 latencies
Date: Sat, 6 Oct 2012 00:25:30 +0000
Message-ID: <C8CA972100601A41AE302914E9CE194655F9DEF4@NTXBOIMBX03.micron.com>
References: <C8CA972100601A41AE302914E9CE194655F89024@NTXBOIMBX03.micron.com>
 <50605FEF.5020103@cran.org.uk>
 <C8CA972100601A41AE302914E9CE194655F9BAB5@NTXBOIMBX03.micron.com>
 <50632E0D.4090003@cran.org.uk> <506693F8.3010903@kernel.dk>
 <5066FBC0.5040508@cran.org.uk>
 <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk>
In-Reply-To: <DD67A461-16D4-496A-BA7C-4F91F07A0B5D@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Bruce Cran <bruce@cran.org.uk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Saturday, September 29, 2012 7:22 AM
> To: Bruce Cran
> Cc: Jeffrey McVay (jmcvay); fio@vger.kernel.org
> Subject: Re: FIO 2.0.9 for Windows Server 2008 RC1 SP2 reports extreme
> latencies
>=20
> On 29/09/2012, at 15.46, Bruce Cran <bruce@cran.org.uk> wrote:
>=20
> > On 29/09/2012 07:23, Jens Axboe wrote:
> >> On 2012-09-26 18:32, Bruce Cran wrote:
> >>> On 26/09/2012 17:30, Jeffrey McVay (jmcvay) wrote:
> >>>> Any updates? Is there anything I can do to help? I have a personal
> >>>> goal to convert our IOMeter testing to FIO.
> >>> Sorry, I've not had any time to work on this yet - I'll work on it
> today.
> >> Any news on this? What is the issue?
> >
> > I've not found the problem yet, but I'm also seeing an assertion
> failure (io_u->flags & IO_U_F_FLIGHT)
>=20
> That'd usually an OS or fio engine bug, it's a symptom of double
> completions.

Anything new on this issue? There is a reviewer using FIO on Windows to mea=
sure latency values. I am concerned that they may publish inaccurate data.


