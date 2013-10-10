Return-Path: <Martin@lichtvoll.de>
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: new fio release?
Date: Thu, 10 Oct 2013 14:52:39 +0200
Message-ID: <1966329.flRkpdWWKZ@merkaba>
In-Reply-To: <1375438822.629.1381382622441.JavaMail.root@thomas-krenn.com>
References: <1375438822.629.1381382622441.JavaMail.root@thomas-krenn.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
To: Georg =?ISO-8859-1?Q?Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Am Donnerstag, 10. Oktober 2013, 07:23:42 schrieb Georg Sch=C3=B6nberge=
r:
> Hi Martin and Fio Users,

Hi Georg!

> > > > Georg is currently packaging fio 2.1.2 for Ubuntu Precise, whil=
e
> > > > I did
> > > > 2.1.1 for Debian a while ago.
> > > >=20
> > > > I already started packaging 2.1.2 for Debian as well and I thin=
k
> > > > I was
> > > > almost finished with it but I had:
> > > >=20
> > > > ms@mango:~/lokal/Debian/fio> lintian -IE
> > > > fio_2.1.2-1_amd64.changes
> > > > W: fio: script-with-language-extension usr/bin/fio2gnuplot.py
> > > > W: fio: binary-without-manpage usr/bin/fio2gnuplot.py
> > > > W: fio: binary-without-manpage usr/bin/genfio
> > > >=20
> > > > which as I looked are all fixed upstream already.
> > > >=20
> > > > Since it is difficult to rename a upstream file in debian
> > > > packaging
> > > > without repacking upstream tarball, I'd rather build next packa=
ge
> > > > from a
> > > > fio release with these issues fixed.
> > > >=20
> > > >=20
> > > > Can you do a fio 2.1.3 release?
> > >=20
> > > Yeah, it's about that time anyway, and the short list of changes
> > > between
> > > 2.1.2 to now seems to indicate a decent point to do a new release=
.
> >=20
> > I made a 2.1.3 fio package last week. Sven Hoexter already reviewed=

> > and
> > uploaded it, so it is available in Debian Unstable.
> >=20
> > I will consider a backport once this one enters testing.
> >=20
> > Thanks,
[=E2=80=A6]
> Do I have to consider special conditions if I rebuild Fio 2.1.3 and l=
ater on
> 2.1.4 under Ubuntu Precise?

I don=C2=B4t know. I never built a package for Ubuntu.

I suggest to just try it out :)

Ciao,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

