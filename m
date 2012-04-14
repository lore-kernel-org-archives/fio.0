Return-Path: <dkukawka@suse.de>
Message-ID: <4F891D18.5020202@suse.de>
Date: Sat, 14 Apr 2012 08:45:44 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20120406040004.1BF99484001@kernel.dk> <4F7E713E.7030300@suse.de> <4F7EF043.9000305@kernel.dk> <4F7F2A75.6030508@suse.de> <4F7F2B97.7000703@kernel.dk>
In-Reply-To: <4F7F2B97.7000703@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig16CABA25A5B840028E92121C"
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig16CABA25A5B840028E92121C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 06.04.2012 19:44, schrieb Jens Axboe:
> On 2012-04-06 11:40, Danny Kukawka wrote:
>> Am 06.04.2012 15:31, schrieb Jens Axboe:
>>> On 2012-04-05 22:29, Danny Kukawka wrote:
>>>> Am 06.04.2012 06:00, schrieb Jens Axboe:
>>>>> The following changes since commit 885ac623a4f154007efa49266bb381bc=
bc60f1e6:
>>>>>
>>>>>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>>>>>
>>>>> are available in the git repository at:
>>>>>   git://git.kernel.dk/fio.git master
>>>>>
>>>>> Jens Axboe (1):
>>>>>       group reporting: fix bad values of min/max
>>>>
>>>> Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't=

>>>> work for me.
>>>>
>>>> fio --name=3Dfio1-write-4m-rbd --direct=3D1 --size=3D50g --group_rep=
orting
>>>> --bs=3D4m --rw=3Dwrite --iodepth=3D128 --ioengine=3Dlibaio --filenam=
e=3D/dev/rbd0
>>>>
>>>> still prints:
>>>>
>>>> READ: io=3D65260MB, aggrb=3D111334KB/s, minb=3D114006KB/s, maxb=3D11=
4006KB/s,
>>>> mint=3D600232msec, maxt=3D600232msec
>>>
>>> Since that's still off by 1.024, are you absolutely sure you are runn=
ing
>>> the right version of fio?
>=20
>> I used git snapshot with latest commit
>> ddb754dbb54a8174080f753c85ff56a7ffca3957, but I can recheck if needed.=

>=20
> Yes, please re-check, it should not be happening and I don't see it
> here.
>=20

I checked again with 8423bd1106a0 and I still see the same problem:

fio --name=3Dfio1-write-4m-rbd --direct=3D1 --size=3D50g --group_reportin=
g
    --bs=3D4m --rw=3Dwrite --iodepth=3D128 --ioengine=3Dlibaio
    --filename=3D$TEST_TARGET --output=3D$DIR/fio1-write-4m-rbd

Run status group 0 (all jobs):
  WRITE: io=3D51200MB, aggrb=3D20080KB/s, minb=3D20080KB/s, maxb=3D20080K=
B/s,
mint=3D2610946msec, maxt=3D2610946msec

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enig16CABA25A5B840028E92121C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk+JHR4ACgkQ9DHLX79LmTKc9QQAqzOeTgXBdgWWxm3yx+vUCOF3
Jy1RSTQtOv7oqKs9A8Mm0NhcnKMq/IR9HpaZHXToR3Zww+H2dJ50KAbcIx+atdqH
zD1pVsZ3450SsB/YmikcV3PQtvMPf9rQdpXChNHVO47bq8igsA8Fu98tjW2+PmDB
OkS+78gx8YgnDwQWIR0=
=sYZs
-----END PGP SIGNATURE-----

--------------enig16CABA25A5B840028E92121C--


