Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50475 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3CLMRD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 Mar 2013 08:17:03 -0400
Date: Tue, 12 Mar 2013 13:16:29 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Make test for gnuplot work with empty strings.
Message-ID: <20130312121629.GO25165@kernel.dk>
References: <201303111622.57044.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <201303111622.57044.ms@teamix.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org, 700580@bugs.debian.org

On Mon, Mar 11 2013, Martin Steigerwald wrote:
> When I launch fio_generate_plots on a system where gnuplot is not install=
ed I
> get this error :
>=20
> $ fio_generate_plots test
> Making bw logs
> /usr/bin/fio_generate_plots: 42: /usr/bin/fio_generate_plots: -: not found
>=20
> That's because the test checking whether gnuplot is installed is failing
> because of an empty variable :
> GNUPLOT=3D$(which gnuplot)
> if [ ! -x $GNUPLOT ]; then
>         echo You need gnuplot installed to generate graphs
>         exit 1
> fi
>=20
> Indeed the command "test -x" is exiting with code 0.
>=20
> To correct this we should enclose the variable with quotes :
> if [ ! -x "$GNUPLOT" ]; then
>=20
> Then the script is going into the test properly :
> $ fio_generate_plots test
> You need gnuplot installed to generate graphs
>=20
> I copied problem description by Herv=EF=BF=BD from the Debian bug report =
below.
>=20
> Fixes:
> Bug#700580: /usr/bin/fio_generate_plots: -: not found
> http://bugs.debian.org/700580
>=20
> Reported-By: Herv=EF=BF=BD Werner <hwerner@score-md.com>
> Tested-By: Herv=EF=BF=BD Werner <hwerner@score-md.com>
> Tested-By: Martin Steigerwald <ms@teamix.de>
> ---
>  fio_generate_plots |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fio_generate_plots b/fio_generate_plots
> index 4285415..5e2febd 100755
> --- a/fio_generate_plots
> +++ b/fio_generate_plots
> @@ -8,7 +8,7 @@ if [ "$1"x =3D "x" ]; then
>  fi
> =20
>  GNUPLOT=3D$(which gnuplot)
> -if [ ! -x $GNUPLOT ]; then
> +if [ ! -x "$GNUPLOT" ]; then
>  	echo You need gnuplot installed to generate graphs
>  	exit 1
>  fi

Thanks, obviously correct :-)

--=20
Jens Axboe

