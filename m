Return-Path: <erwan.velu@enovance.com>
Date: Thu, 13 Feb 2014 11:32:02 +0100 (CET)
From: Erwan Velu <erwan.velu@enovance.com>
Message-ID: <842615085.1431531.1392287522937.JavaMail.zimbra@enovance.com>
In-Reply-To: <20140213071357.36e92383@marvin>
References: <1392229542-14083-1-git-send-email-d.gollub@telekom.de> <52FC45E9.3090101@kernel.dk> <20140213071357.36e92383@marvin>
Subject: Re: [PATCH] Fix g++ warning about void* used in arithmetic
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Daniel Gollub <daniel.gollub@t-online.de>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

I'm interested in CEPH too. Can you tell us what is your plan with fio & CE=
PH ?

----- Mail original -----
De: "Daniel Gollub" <daniel.gollub@t-online.de>
=C3=80: "Jens Axboe" <axboe@kernel.dk>
Cc: fio@vger.kernel.org, "Daniel Gollub" <d.gollub@telekom.de>
Envoy=C3=A9: Jeudi 13 F=C3=A9vrier 2014 07:13:57
Objet: Re: [PATCH] Fix g++ warning about void* used in arithmetic

Hi Jens,

On Wed, 12 Feb 2014 21:11:21 -0700, Jens Axboe wrote:
> On 2014-02-12 11:25, Daniel Gollub wrote:
> > ../parse.h: In function =E2=80=98void* td_var(thread_options*, fio_opti=
on*,
> > unsigned int)=E2=80=99: ../parse.h:110:10: warning: pointer of type =E2=
=80=98void
> > *=E2=80=99 used in arithmetic [-Wpointer-arith] ../parse.h:112:9: warni=
ng:
> > pointer of type =E2=80=98void *=E2=80=99 used in arithmetic [-Wpointer-=
arith]
>=20
> I bet there are a lot of these, or other similar code that would
> prevent compiling with g++. I'm dubious of the value add here. Fio is
> written in C, after all.
>=20

I should have mentioned this in the commit message: this is required to
compile an external ionengine written in C++. I do not try to compile
entire fio with g++. If I include fio.h in the external ioengine,
parse.h gets included by fio.h or so and causes this g++ warning.

This was the last warning (which just got introduced 2 days
ago) when fio.h gets included by an external engine build with g++.

So the value here is to build external ioengines against libraries/APIs
which are only available in C++. In my case against an internal library
of CEPH.


--=20
Daniel Gollub
