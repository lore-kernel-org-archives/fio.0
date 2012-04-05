Return-Path: <dkukawka@suse.de>
Message-ID: <4F7DBA89.7080609@suse.de>
Date: Thu, 05 Apr 2012 17:30:17 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk> <4F7D5CF8.40703@suse.de> <4F7DAF3D.2050000@kernel.dk>
In-Reply-To: <4F7DAF3D.2050000@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8E7ABFCFE0369093DA6CA86C"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8E7ABFCFE0369093DA6CA86C
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 05.04.2012 16:42, schrieb Jens Axboe:
> On 2012-04-05 02:51, Danny Kukawka wrote:
>>>> 3) fio always reports minb =3D=3D maxb and aggrb < minb as you can s=
ee
>>>> above. From my understanding this would be false info.
>>>
>>> Yeah, it's a cosmetic thing. I've never really taken the time to look=
 at
>>> that...
>=20
>> It's not cosmetic if you need correct values for your tests ...
>=20
> Most people don't use the group reporting, but yes of course it should
> be correct. I have checked in a patch to correct it. The min/max group
> report bandwidth were off by 1.024, the aggregate was correct (and
> matched the "real" data output).
>=20
>>>> 4) If we define rw=3Drandrw, rwmixread=3D80, rwmixwrite=3D20 and the=
 verify
>>>> options, what does the READ process if there isn't enough data writt=
en
>>>> out yet? Which data does READ read and verify?
>>>
>>> If you have a split workload like that and are also doing verifies, t=
he
>>> read can be either a read verify or just an offset read. In the latte=
r
>>> case, it doesn't verify anything. It'll just read a block (or multipl=
e
>>> blocks) at some offset instead of writing it.
>=20
>> That would may explain the fio over-report in 1).
>=20
>> We create a new RBD on the cluster, mount it on the client and let fio=

>> start it's test on the RBD. The RBD is completely empty at this moment=
=2E
>> Not sure what happens if fio reads some random offset that may isn't
>> filled with data at this moment. Or is fio only reading from a prior
>> written block/offset?
>=20
> OK, if we back up a bit. If you have a workload that is rwmixread=3D50,=

> hence doing equal amount of random reads and writes. Then the job will
> read 50% of the disk, and write 50% of the disk. None of the read and
> write offsets will be the same. So if the drive is initially empty, you=

> are reading non-initialized data.
>=20
> Same thing is true for your workload. So some of the reads you see will=

> be the verifies, but some of them will also be for parts of the disk
> that you will then never write.

We solved it now by running an initial fio write over the full RBD
before running any verify tests:

 fio --name=3Dfill-rbd --filename=3D/dev/rbd1 --direct=3D1 --rw=3Dwrite \=

     --bs=3D4M --size=3D25g --ioengine=3Dlibaio --iodepth=3D128

Now we don't see problems with over-reporting fio anymore.

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enig8E7ABFCFE0369093DA6CA86C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk99uo8ACgkQ9DHLX79LmTIoCQP+LtQASab7xkTVaRAQ8KkcwrW5
IC3K8UMuCXUMK90dPDxclvX1QvoiL6o7zRjhYUbkUB5hpwYZiIhRMsa4F5bK3gzL
0Dcr4061QFzA/OFyiv2AqGmz1o4Ie325KK+BboYU2s5+QF+48jkmU0VRKme0uWJv
3aqHYMYJtoRbzgnGl6E=
=ukO0
-----END PGP SIGNATURE-----

--------------enig8E7ABFCFE0369093DA6CA86C--


