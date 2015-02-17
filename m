Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: Bug#776701: ssd-test 1g file size too small
Date: Tue, 17 Feb 2015 08:53:03 +0100
Message-ID: <2317290.UB4oYTnqxD@merkaba>
In-Reply-To: <54E26953.9070001@kernel.dk>
References: <54CCD756.7000105@pocock.pro> <13200420.bigzCatb1k@merkaba> <54E26953.9070001@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Pocock <daniel@pocock.pro>, 776701@bugs.debian.org, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

=EF=BB=BFAm Montag, 16. Februar 2015, 15:04:03 schrieb Jens Axboe:
> On 02/04/2015 02:10 AM, Martin Steigerwald wrote:
> > Hello Daniel, hi Jens,
> >=20
> > Am Samstag, 31. Januar 2015, 14:23:34 schrieb Daniel Pocock:
> >> Package: fio
> >> Version: 2.1.11-2
> >> Severity: important
> >>=20
> >>=20
> >> In the ssd-test sample config:
> >>=20
> >> https://sources.debian.net/src/fio/2.1.11-2/examples/ssd-test.fio/
> >>=20
> >>=20
> >> The test size is 1GB, this line:
> >>=20
> >> size=3D1g
> >>=20
> >>=20
> >> There are SSDs that have 1g caches and this leads to unhelpful
> >> results.
> >>=20
> >> One user I discussed this with had to use a 10g test file to get
> >> consistent and meaningful results.
> >>=20
> >> Maybe bump the example to 10g or add a comment in front of that line.
> >=20
> > As the examples are taken from the upstream tarball, I suggest taking
> > this upstream. I put upstream in Cc, Jens, what do you think about
> > this?
> Sure, that sounds fine to me. 1G is tiny by todays standards, 10G would
> be a lot more reasonable. I'll commit that change.

Great. I think I will look into packaging latest fio upstream one of the=20
next weeks.

(sorry for long sig, can=C2=B4t disable it)

--=20
Martin Steigerwald  | Consultant / Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller


***Nicht verpassen: TechDemo Hochverf=C3=BCgbare Storage-Infrastruktur***
N=C3=BCrnberg 25.02.15 | M=C3=BCnchen 26.02.15 | Jetzt anmelden unter: www.=
teamix.de/techdemo


