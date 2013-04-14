Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49487 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237Ab3DNLrx (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 14 Apr 2013 07:47:53 -0400
Date: Sun, 14 Apr 2013 13:47:23 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unable to Configure latest build
Message-ID: <20130414114723.GI12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <53b87397-46b4-49d7-bbb6-8637d83c1bb6@email.android.com>
 <CANUChTxpr+cAjzRQvbrJCrbT=h4Ui7UvJnXio6H_3EA7V46kxQ@mail.gmail.com>
 <08eca738-809f-412f-ba10-23df48aef950@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <08eca738-809f-412f-ba10-23df48aef950@email.android.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Gavin Martin <gavin_martin@xyratex.com>, fio@vger.kernel.org

On Sun, Apr 14 2013, Greg Freemyer wrote:
>=20
>=20
> Gavin Martin <gavin_martin@xyratex.com> wrote:
>=20
> >On 12 April 2013 11:55, Greg Freemyer <greg.freemyer@gmail.com> wrote:
> >>
> >>
> >> Gavin Martin <gavin_martin@xyratex.com> wrote:
> >>
> >>>Hi Jens,
> >>>
> >>>I grabbed the 2.0.15 when it came out and it configured and compiled
> >>>fine, but the latest one from today (12/04) displays errors when
> >>>trying to configure.
> >>>
> >>>I'm not doing anything different to what I was doing for the previous
> >>>builds.  Just running ./configure, below is the output from
> >>>config.log;
> >>>
> >>># FIO configure log Fri Apr 12 08:25:30 BST 2013
> >>># Configured with: './configure'
> >>>#
> >>>gcc -D_GNU_SOURCE -include config-host.h -c -o
> >>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >>>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not
> >>>defined
> >>>gcc -D_GNU_SOURCE -include config-host.h -c -o
> >>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >>>gcc -D_GNU_SOURCE -include config-host.h -c -o
> >>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >>>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not
> >>>defined
> >>>gcc -D_GNU_SOURCE -include config-host.h -c -o
> >>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >>>Compiling test case cross
> >>>gcc -D_GNU_SOURCE -include config-host.h -o
> >>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >>>Compiling test case endian
> >>>gcc -D_GNU_SOURCE -include config-host.h -o
> >>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >>>Compiling test case wordsize
> >>>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D32 -o
> >>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >>>/tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
> >>>/tmp/fio-conf-27676-20722-14401.c:5: error: size of array =EF=BF=BDtyp=
e name=EF=BF=BD
> >>>is negative
> >>>Compiling test case wordsize
> >>>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D64 -o
> >>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >>>Compiling test case zlib
> >>>gcc -D_GNU_SOURCE -include config-host.h -o
> >>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >>>-lz
> >>>/tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file
> >or
> >>>directory
> >>>/tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
> >>>/tmp/fio-conf-27676-20722-14401.c:4: error: =EF=BF=BDz_stream=EF=BF=BD=
 undeclared
> >>>(first use in this function)
> >>>/tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
> >>>identifier is reported only once
> >>>/tmp/fio-conf-27676-20722-14401.c:4: error: for each function it
> >>>appears in.)
> >>>/tmp/fio-conf-27676-20722-14401.c:4: error: expected =EF=BF=BD;=EF=BF=
=BD before
> >>>=EF=BF=BDstream=EF=BF=BD
> >>>/tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDstream=EF=BF=BD u=
ndeclared
> >(first
> >>>use in this function)
> >>>/tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDZ_OK=EF=BF=BD und=
eclared (first
> >>>use in this function)
> >>>
> >>>This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
> >>>I am doing something wrong, but it has worked on previous builds.
> >>>
> >>>Thanks,
> >>>Gavin
> >>
> >> Gavin,
> >>
> >> I have commit rights to the opensuse fio package in the benchmark
> >repo.
> >>
> >> V2.0.15 is already there.  There should be a sles rpm you can just
> >install.
> >>
> >> Do the fio builds from the opensuse benchmark repo not work for you?
> >>
> >> Why are you self compiling?
> >>
> >> Greg
> >> --
> >> Sent from my Android phone with K-9 Mail. Please excuse my brevity.
> >
> >Thanks Greg,
> >
> >Possibly because I didn't know of any other way, thanks for that.
> >
> >But also I was interested in giving gfio a try, and I don't think that
> >has been pre compiled by anybody yet, will probably be proven wrong
> >now!
> >
> >Regards,
> >Gavin
>=20
> I haven't followed the gfio possibilities.=20
>=20
> I gather it has a extra binary that can run on the server and a client ap=
p.
>=20
> From a packagers perspective, I would want the server side not to pull in=
 any gui requirements.

I think that is the right way to do it.

> Jens, what would you recommend in the way of packages:
>    Fio - cli only
>    Fio-gfio-server
>    Fio-gfio-client=20

I think you only need two packages - fio and gfio. Fio already supports
client/server through the cli, that part was done before gfio. gfio just
connects to the same server as the cli frontend. To run gfio, you need
gfio as the client and fio --server as the backend. So just the two
packages would make the most sense, and only the gfio package would have
gui dependencies (and depend on fio, too).

--=20
Jens Axboe

