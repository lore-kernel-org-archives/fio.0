Return-Path: <daniel.gollub@t-online.de>
Date: Thu, 13 Feb 2014 07:13:57 +0100
From: Daniel Gollub <daniel.gollub@t-online.de>
Subject: Re: [PATCH] Fix g++ warning about void* used in arithmetic
Message-ID: <20140213071357.36e92383@marvin>
In-Reply-To: <52FC45E9.3090101@kernel.dk>
References: <1392229542-14083-1-git-send-email-d.gollub@telekom.de>
	<52FC45E9.3090101@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Daniel Gollub <d.gollub@telekom.de>
List-ID: <fio@vger.kernel.org>

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

