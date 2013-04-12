Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47551 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3DLINt (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Apr 2013 04:13:49 -0400
Date: Fri, 12 Apr 2013 10:13:24 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unable to Configure latest build
Message-ID: <20130412081324.GL12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Apr 12 2013, Gavin Martin wrote:
> Hi Jens,
>=20
> I grabbed the 2.0.15 when it came out and it configured and compiled
> fine, but the latest one from today (12/04) displays errors when
> trying to configure.
>=20
> I'm not doing anything different to what I was doing for the previous
> builds.  Just running ./configure, below is the output from
> config.log;
>=20
> # FIO configure log Fri Apr 12 08:25:30 BST 2013
> # Configured with: './configure'
> #
> gcc -D_GNU_SOURCE -include config-host.h -c -o
> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not defi=
ned
> gcc -D_GNU_SOURCE -include config-host.h -c -o
> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> gcc -D_GNU_SOURCE -include config-host.h -c -o
> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not defined
> gcc -D_GNU_SOURCE -include config-host.h -c -o
> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> Compiling test case cross
> gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> Compiling test case endian
> gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> Compiling test case wordsize
> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D32 -o
> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> /tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
> /tmp/fio-conf-27676-20722-14401.c:5: error: size of array =EF=BF=BDtype n=
ame=EF=BF=BD
> is negative
> Compiling test case wordsize
> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D64 -o
> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> Compiling test case zlib
> gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> -lz
> /tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file or di=
rectory
> /tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
> /tmp/fio-conf-27676-20722-14401.c:4: error: =EF=BF=BDz_stream=EF=BF=BD un=
declared
> (first use in this function)
> /tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
> identifier is reported only once
> /tmp/fio-conf-27676-20722-14401.c:4: error: for each function it appears =
in.)
> /tmp/fio-conf-27676-20722-14401.c:4: error: expected =EF=BF=BD;=EF=BF=BD =
before =EF=BF=BDstream=EF=BF=BD
> /tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDstream=EF=BF=BD unde=
clared (first
> use in this function)
> /tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDZ_OK=EF=BF=BD undecl=
ared (first
> use in this function)
>=20
> This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
> I am doing something wrong, but it has worked on previous builds.

You need the zlib devel libraries installed, configure should have told
you that. Ala:

ERROR
ERROR: User requested feature zlib
ERROR: configure was not able to find it
ERROR
Configure failed, check config.log and/or the above output

Not sure what that package is called on SLES, but probably zlib-devel.

--=20
Jens Axboe

