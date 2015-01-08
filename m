Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: Non-uniform randomness with drifting
Date: Thu, 8 Jan 2015 20:14:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A72B720@G9W0745.americas.hpqcorp.net>
References: <54ADC21F.10207@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295A7299C7@G9W0745.americas.hpqcorp.net>
 <CAB-428nTgzsdZEqX03dsrr-1PgCH3X1YgJByXVT3tjn8QtgzFg@mail.gmail.com>
In-Reply-To: <CAB-428nTgzsdZEqX03dsrr-1PgCH3X1YgJByXVT3tjn8QtgzFg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Alireza Haghdoost [mailto:haghdoost@gmail.com]
> Sent: Thursday, 08 January, 2015 1:01 PM
> To: Elliott, Robert (Server Storage)
> Cc: Jens Axboe; fio@vger.kernel.org
> Subject: Re: Non-uniform randomness with drifting
>=20
> On Thu, Jan 8, 2015 at 10:59 AM, Elliott, Robert (Server Storage)
> <Elliott@hp.com> wrote:
> > The new random_drift feature changes spatial locality over time (where
> > time means % of data that has been accessed), so it provides some
> > correlation control, but doesn't provide full temporal locality
> > control.
>=20
> Just to clarify, the temporal locality control that you are referring
> to is more like burst control. You are not interested in a fixed IO
> generation rate and interested to have dynamic IO rate changes. Is=20
> that correct ?

Yes. That kind of temporal locality is necessary for write buffer/caches
that sit between a fast interface and a slow interface, where the buffer
is continuously destaged.  Assuming the long-term input rate matches the
output/destage rate (otherwise the buffer will inevitably become full),
the required buffer size to maintain maximum bandwidth depends on the
length of the bursts between the idles.

A simple fixed rate generator has uses too, but it often leads to overloadi=
ng
the system or settling at less than the maximum possible rate.  That's how=
=20
the SPC-1 benchmarks are designed; find the heaviest workload for which the
system maintains the targeted latency (fio's latency_target=3D option).


