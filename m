Return-Path: <sven@timegate.de>
Date: Tue, 26 Jun 2012 22:13:36 +0200
From: Sven Hoexter <sven@timegate.de>
Subject: Re: fio 2.0.8 fails to build on mipsel
Message-ID: <20120626201336.GC3429@marvin>
References: <201206261245.30704.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <201206261245.30704.ms@teamix.de>
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Tue, Jun 26, 2012 at 12:45:30PM +0200, Martin Steigerwald wrote:

Hi,

> Building fails on mipsel due to=EF=BF=BD:

>     CC server.o
> server.c: In function 'handle_probe_cmd':
> server.c:411:15: error: 'arch_mips' undeclared (first use in this functio=
n)
> server.c:411:15: note: each undeclared identifier is reported only once f=
or each function it appears in
> make[1]: *** [server.o] Error 1
> make[1]: Leaving directory `/build/buildd-fio_2.0.8-1-mipsel-9VXitB/fio-2=
.0.8'
> make: *** [build-stamp] Error 2


Adding arch_mips to the enum list at the top of arch/arch.h fixes the
build issue, but I've no idea if that's the correct fix, regarding endianess
issue etc. Tested on mipsel only, though the build failure happens
on mips and mipsel.

Sven
--=20
And I don't know much, but I do know this:
With a golden heart comes a rebel fist.
     [ Streetlight Manifesto - Here's To Life ]

