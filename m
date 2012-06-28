Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: fio 2.0.8 fails to build on mipsel
Date: Thu, 28 Jun 2012 15:20:01 +0200
References: <201206261245.30704.ms@teamix.de> <20120626201336.GC3429@marvin> <4FEA1A99.7070801@kernel.dk> (sfid-20120627_002033_329549_DF09A804)
In-Reply-To: <4FEA1A99.7070801@kernel.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Message-Id: <201206281520.01482.Martin@lichtvoll.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Sven Hoexter <sven@timegate.de>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Am Dienstag, 26. Juni 2012 schrieb Jens Axboe:
> On 2012-06-26 16:13, Sven Hoexter wrote:
> > On Tue, Jun 26, 2012 at 12:45:30PM +0200, Martin Steigerwald wrote:
> >=20
> > Hi,
> >=20
> >> Building fails on mipsel due to=B9:
> >>     CC server.o
> >>=20
> >> server.c: In function 'handle_probe_cmd':
> >> server.c:411:15: error: 'arch_mips' undeclared (first use in this
> >> function) server.c:411:15: note: each undeclared identifier is
> >> reported only once for each function it appears in make[1]: ***
> >> [server.o] Error 1
> >> make[1]: Leaving directory
> >> `/build/buildd-fio_2.0.8-1-mipsel-9VXitB/fio-2.0.8' make: ***
> >> [build-stamp] Error 2
> >=20
> > Adding arch_mips to the enum list at the top of arch/arch.h fixes the
> > build issue, but I've no idea if that's the correct fix, regarding
> > endianess issue etc. Tested on mipsel only, though the build failure
> > happens on mips and mipsel.
>=20
> It is the right fix, it just needs to have some value. Added.

fio 2.0.8-2 with a build fix for mips/mipsel made it to Debian unstable.

If desired by myself or someone else I may consider backporting it to=20
Squeeze after it has entered testing.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

