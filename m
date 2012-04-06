Return-Path: <dkukawka@suse.de>
Message-ID: <4F7F2A75.6030508@suse.de>
Date: Fri, 06 Apr 2012 19:40:05 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20120406040004.1BF99484001@kernel.dk> <4F7E713E.7030300@suse.de> <4F7EF043.9000305@kernel.dk>
In-Reply-To: <4F7EF043.9000305@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA631CD6A27DBC7DEE6985E49"
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA631CD6A27DBC7DEE6985E49
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 06.04.2012 15:31, schrieb Jens Axboe:
> On 2012-04-05 22:29, Danny Kukawka wrote:
>> Am 06.04.2012 06:00, schrieb Jens Axboe:
>>> The following changes since commit 885ac623a4f154007efa49266bb381bcbc=
60f1e6:
>>>
>>>   iolog: remove assert in io_u overlap (2012-04-04 14:11:58 -0600)
>>>
>>> are available in the git repository at:
>>>   git://git.kernel.dk/fio.git master
>>>
>>> Jens Axboe (1):
>>>       group reporting: fix bad values of min/max
>>
>> Should this fix also the minb/maxb and mint/maxt ? If so, it doesn't
>> work for me.
>>
>> fio --name=3Dfio1-write-4m-rbd --direct=3D1 --size=3D50g --group_repor=
ting
>> --bs=3D4m --rw=3Dwrite --iodepth=3D128 --ioengine=3Dlibaio --filename=3D=
/dev/rbd0
>>
>> still prints:
>>
>> READ: io=3D65260MB, aggrb=3D111334KB/s, minb=3D114006KB/s, maxb=3D1140=
06KB/s,
>> mint=3D600232msec, maxt=3D600232msec
>=20
> Since that's still off by 1.024, are you absolutely sure you are runnin=
g
> the right version of fio?

I used git snapshot with latest commit
ddb754dbb54a8174080f753c85ff56a7ffca3957, but I can recheck if needed.

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enigA631CD6A27DBC7DEE6985E49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk9/Ko8ACgkQ9DHLX79LmTL1ggP/QEp1K5o6Q0QDEGlCbf22y1Kz
4O5VgzxhG4o13GmRGbcZVIkjBwNJfkBfcZJApbHrk2dmxh2LeBgOXbJ2LXO5pw5Q
BG8mDE6x+CMtKDbm0NXJM2fqDDr+E5DAGG5A3viPFN7n2WuRjQZ8pYWTaJ5IpqCK
VhIlIttCaXcmF02C9o0=
=2P4w
-----END PGP SIGNATURE-----

--------------enigA631CD6A27DBC7DEE6985E49--


