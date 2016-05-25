Return-Path: <martin.steigerwald@teamix.de>
From: Martin Steigerwald <ms@teamix.de>
Subject: Re: fiologparser.py
Date: Wed, 25 May 2016 09:20:35 +0200
Message-ID: <4305498.706Km7Gau8@merkaba>
In-Reply-To: <1549707390.65536830.1464103326492.JavaMail.zimbra@redhat.com>
References: <12634496.Be1YEipj88@merkaba> <196b983d-e6e1-2c2d-299e-de3b9cc742ff@gmail.com> <1549707390.65536830.1464103326492.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
To: Ben England <bengland@redhat.com>
Cc: Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, Mark Nelson <mnelson@redhat.com>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

=EF=BB=BFOn Dienstag, 24. Mai 2016 11:22:06 CEST Ben England wrote:
>=20
--=20
Martin Steigerwald  | Trainer

teamix GmbH
S=C3=BCdwestpark 43
90449 N=C3=BCrnberg

Tel.:  +49 911 30999 55 | Fax: +49 911 30999 99
mail: martin.steigerwald@teamix.de | web:  http://www.teamix.de | blog: htt=
p://blog.teamix.de

Amtsgericht N=C3=BCrnberg, HRB 18320 | Gesch=C3=A4ftsf=C3=BChrer: Oliver K=
=C3=BCgow, Richard M=C3=BCller

teamix Support Hotline: +49 911 30999-112
=20
 Flexibilit=C3=A4t im Haus =E2=80=93 Sicherheit im Kopf, testen Sie jetzt 3=
0 Tage kostenfrei unsere Cloud Backup L=C3=B6sung FlexVault: www.teamix.de/=
cloud-backup=20

----- Original Message -----
>=20
> > From: "Mark Nelson" <mark.a.nelson@gmail.com>
> > To: "Ben England" <bengland@redhat.com>, "Martin Steigerwald"
> > <ms@teamix.de> Cc: fio@vger.kernel.org, "Mark Nelson"
> > <mnelson@redhat.com>, "Jens Axboe" <axboe@kernel.dk> Sent: Tuesday, May
> > 24, 2016 10:04:14 AM
> > Subject: Re: fiologparser.py
> >=20
> > Let's see if we can remove the numpy and scipy dependencies.  It looks
> > like we are just using it for min/average/median/max/percentile
> > calculations.  It would be nice if users didn't need anything other tha=
n
> > argparse.
>=20
> Just curious, why is scipy a problem?  Is it because CBT isn't a package =
so
> you don't get dependencies handled when you install it?  You are correct,
> it's easy to remove the dependencies, I just didn't know it was causing
> problems for people.  You can get percentiles from just sorting the sampl=
e
> values and indexing into the array at the appropriate offset, I was just
> trying to re-use existing classes.

There is a very clear reason and that is:

After this operation, 37.9 MB of additional disk space will be used.

Yes, thats right, that is the size of the python-scipy package in Debian=20
Unstable.

So I am glad to intend to remove the dependency, as I really would like to=
=20
move fiologparser to /usr/bin, but that means currently python-scipy would=
=20
need to become a hard dependency and I am probably not going to do that.

So for fiologparser to move into a more promiment location, I=C2=B4d need i=
t to be=20
free of that dependency.

Thank you,

