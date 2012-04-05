Return-Path: <dkukawka@suse.de>
Message-ID: <4F7D64D2.2040407@suse.de>
Date: Thu, 05 Apr 2012 11:24:34 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk> <4F7CABC5.7090109@kernel.dk>
In-Reply-To: <4F7CABC5.7090109@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig01A460EA572298CF76AD9F28"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig01A460EA572298CF76AD9F28
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 04.04.2012 22:15, schrieb Jens Axboe:
> On 2012-04-04 13:50, Jens Axboe wrote:
>>> 2) fio 2.0.6 and also the current git tends to fail with this error:
>=20
>>>    fio 2.0.6
>>>    Starting 1 process
>>>    fio: iolog.c:242: log_io_piece: Assertion `ipo->len =3D=3D __ipo->=
len'
>>>    failed.:08m:31s]
>=20
>>> It seems that we can prevent it when we use the --size parameter, but=
 we
>>> would like to prevent the usage of the parameter, if possible
>=20
>> Strangely, I had two reports of this today. Did a bit of digging, and
>> it's due to this commit:
>=20
>> commit c04e4661e4da3b6079f415897e4507cf8e610c54
>> Author: Daniel Ehrenberg <dehrenberg@google.com>
>> Date:   Fri Mar 16 18:54:15 2012 +0100
>=20
>>     time_based: Avoid restarting main I/O loop
>=20
>> I think what is going on here is that your job is time based, and when=

>> we fail getting a new offset, we clear the offset bitmap. But we could=

>> have verifies pending at this point, we'd need to prune this out as
>> well.
>=20
> Actually, since it happens so rarely, I think the better approach is
> just to ignore it. I've updated fio to reflect that.

Btw. I can suppress the error if I add --size with a high number e.g.
--size=3D1p.

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)




--------------enig01A460EA572298CF76AD9F28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk99ZNIACgkQ9DHLX79LmTIv1wP/YBclXMRSOOXWStdqQ4ILEhqh
PchPX9zESTNt/kuaufFN8+JHVqTcgButXKh08Tt5fXi/cF1HZQqLrT80mEqFSD8W
3MbgkF8cIOWDmKvv7KafZLbpsY0TGRes20PqH9lIxZACdL3KYeJMx5jGEXwLDzNL
V41mUs/rLiqR8SY8zJg=
=sRHT
-----END PGP SIGNATURE-----

--------------enig01A460EA572298CF76AD9F28--


