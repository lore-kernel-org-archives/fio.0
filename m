Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53450 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZUZD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 26 Jun 2012 16:25:03 -0400
Message-ID: <4FEA1A99.7070801@kernel.dk>
Date: Tue, 26 Jun 2012 16:24:57 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio 2.0.8 fails to build on mipsel
References: <201206261245.30704.ms@teamix.de> <20120626201336.GC3429@marvin>
In-Reply-To: <20120626201336.GC3429@marvin>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sven Hoexter <sven@timegate.de>
Cc: Martin Steigerwald <ms@teamix.de>, fio@vger.kernel.org

On 2012-06-26 16:13, Sven Hoexter wrote:
> On Tue, Jun 26, 2012 at 12:45:30PM +0200, Martin Steigerwald wrote:
>=20
> Hi,
>=20
>> Building fails on mipsel due to=EF=BF=BD:
>=20
>>     CC server.o
>> server.c: In function 'handle_probe_cmd':
>> server.c:411:15: error: 'arch_mips' undeclared (first use in this functi=
on)
>> server.c:411:15: note: each undeclared identifier is reported only once =
for each function it appears in
>> make[1]: *** [server.o] Error 1
>> make[1]: Leaving directory `/build/buildd-fio_2.0.8-1-mipsel-9VXitB/fio-=
2.0.8'
>> make: *** [build-stamp] Error 2
>=20
>=20
> Adding arch_mips to the enum list at the top of arch/arch.h fixes the
> build issue, but I've no idea if that's the correct fix, regarding endian=
ess
> issue etc. Tested on mipsel only, though the build failure happens
> on mips and mipsel.

It is the right fix, it just needs to have some value. Added.

--=20
Jens Axboe



