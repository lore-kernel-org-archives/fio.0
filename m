Return-Path: <ms@teamix.de>
Date: Mon, 5 Aug 2013 16:40:42 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
Message-ID: <232124889.843394.1375713642725.JavaMail.zimbra@teamix.de>
In-Reply-To: <20130312121629.GO25165@kernel.dk>
References: <201303111622.57044.ms@teamix.de> <20130312121629.GO25165@kernel.dk>
Subject: Re: [PATCH] Make test for gnuplot work with empty strings.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, 700580@bugs.debian.org
List-ID: <fio@vger.kernel.org>

----- Urspr=C3=BCngliche Mail -----
> On Mon, Mar 11 2013, Martin Steigerwald wrote:
> > When I launch fio_generate_plots on a system where gnuplot is not insta=
lled
> > I
> > get this error :
> >=20
> > $ fio_generate_plots test
> > Making bw logs
> > /usr/bin/fio_generate_plots: 42: /usr/bin/fio_generate_plots: -: not fo=
und
> >=20
> > That's because the test checking whether gnuplot is installed is failin=
g
> > because of an empty variable :
> > GNUPLOT=3D$(which gnuplot)
> > if [ ! -x $GNUPLOT ]; then
> >         echo You need gnuplot installed to generate graphs
> >         exit 1
> > fi
> >=20
> > Indeed the command "test -x" is exiting with code 0.
> >=20
> > To correct this we should enclose the variable with quotes :
> > if [ ! -x "$GNUPLOT" ]; then
> >=20
> > Then the script is going into the test properly :
> > $ fio_generate_plots test
> > You need gnuplot installed to generate graphs
> >=20
> > I copied problem description by Herv=C3=A9 from the Debian bug report b=
elow.
> >=20
> > Fixes:
> > Bug#700580: /usr/bin/fio_generate_plots: -: not found
> > http://bugs.debian.org/700580
> >=20
> > Reported-By: Herv=C3=A9 Werner <hwerner@score-md.com>
> > Tested-By: Herv=C3=A9 Werner <hwerner@score-md.com>
> > Tested-By: Martin Steigerwald <ms@teamix.de>
> > ---
> >  fio_generate_plots |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fio_generate_plots b/fio_generate_plots
> > index 4285415..5e2febd 100755
> > --- a/fio_generate_plots
> > +++ b/fio_generate_plots
> > @@ -8,7 +8,7 @@ if [ "$1"x =3D "x" ]; then
> >  fi
> > =20
> >  GNUPLOT=3D$(which gnuplot)
> > -if [ ! -x $GNUPLOT ]; then
> > +if [ ! -x "$GNUPLOT" ]; then
> >  =09echo You need gnuplot installed to generate graphs
> >  =09exit 1
> >  fi
>=20
> Thanks, obviously correct :-)

Still it doesn't seem you applied it as of

428b4f6ba681dbb40c8e2213d0c6ae8f8049dcd5ESC

of git://git.kernel.dk/fio.git

Fixing locally in Debian package now.

Thaqnks,
--=20
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

