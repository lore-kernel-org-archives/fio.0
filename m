Return-Path: <dkukawka@suse.de>
MIME-Version: 1.0
From: Danny Kukawka <dkukawka@suse.de>
Date: Thu, 5 Apr 2012 22:29:50 -0600
Subject: Re: Recent changes
Message-ID: <4F7E713E.7030300@suse.de>
References: <20120406040004.1BF99484001@kernel.dk>
In-Reply-To: <20120406040004.1BF99484001@kernel.dk>
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig57BA52A679D75CEC828A5C70"
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

--------------enig57BA52A679D75CEC828A5C70
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 06.04.2012 06:00, schrieb Jens Axboe:
> The following changes since commit 885ac623a4f154007efa49266bb381bcbc60=
f1e6:
>=20
>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>=20
> are available in the git repository at:
>   git://git.kernel.dk/fio.git master
>=20
> Jens Axboe (1):
>       group reporting: fix bad values of min/max

Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't
work for me.

fio --name=3Dfio1-write-4m-rbd --direct=3D1 --size=3D50g --group_reportin=
g
--bs=3D4m --rw=3Dwrite --iodepth=3D128 --ioengine=3Dlibaio --filename=3D/=
dev/rbd0

still prints:

READ: io=3D65260MB, aggrb=3D111334KB/s, minb=3D114006KB/s, maxb=3D114006K=
B/s,
mint=3D600232msec, maxt=3D600232msec

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enig57BA52A679D75CEC828A5C70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk9+cUgACgkQ9DHLX79LmTLvggP+IiXRZRZw8HpOQ933hAjTKTwh
SYkbSGOMzBNj2d3BDgWlXxkTvZZiXRkNlFIin+NO6/+d6b51J1qVsmvJM78Tibi7
QgFVyVTrRGTtywARNziYnWzUlMxdYDPE9AQMdTNVtITDVP/Kj6Eja8MgwBYw7GK2
6ePCh+YWDwZ3r9IeMTQ=
=2mUu
-----END PGP SIGNATURE-----

--------------enig57BA52A679D75CEC828A5C70--


