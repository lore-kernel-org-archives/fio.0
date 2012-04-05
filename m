Return-Path: <dkukawka@suse.de>
Message-ID: <4F7D5CF8.40703@suse.de>
Date: Thu, 05 Apr 2012 10:51:04 +0200
From: Danny Kukawka <dkukawka@suse.de>
MIME-Version: 1.0
Subject: Re: fio problems
References: <4F7BEC92.8000100@suse.de> <4F7CA5F1.2050309@kernel.dk>
In-Reply-To: <4F7CA5F1.2050309@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3DB94B694D576F344A86B9CD"
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3DB94B694D576F344A86B9CD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 04.04.2012 21:50, schrieb Jens Axboe:
> On 2012-04-04 00:39, Danny Kukawka wrote:
>> Hi,
>=20
>> we try to run fio against raw RBD devices on a ceph cluster. Here are
>> the parameter we use to run fio:
>=20
>> [test]
>> filename=3D/dev/rbd0
>> time_based
>> runtime=3D3h
>> rw=3Drandrw
>> rwmixread=3D80
>> rwmixwrite=3D20
>> blocksize_range=3D4k-1024k
>> ioengine=3Dlibaio
>> iodepth=3D64
>> direct=3D1
>> verify=3Dcrc32c-intel
>> verify_fatal=3D1
>> verify_async=3D16
>> lockfile=3Dexclusive
>=20
>> We see some problems:
>=20
>> 1) fio reports higher READ speeds than the used 1Gbit network interfac=
e
>> could provide (the interface isn't even working to capacity in this
>> situation). That happens if we use --rwmixread/rwmixwrite:
>=20
>>  READ: io=3D91560MB, aggrb=3D156206KB/s, minb=3D159955KB/s,
>>         maxb=3D159955KB/s, mint=3D600216msec, maxt=3D600216msec
>>  WRITE: io=3D22944MB, aggrb=3D39143KB/s, minb=3D40083KB/s, maxb=3D4008=
3KB/s,
>>         mint=3D600216msec, maxt=3D600216msec
>=20
> OK that's very odd. How are these numbers matching up with watching
> vmstat 1 while the job runs? I've never seen fio over-report before.

I will take a look at it and let you know.

>> 3) fio always reports minb =3D=3D maxb and aggrb < minb as you can see=

>> above. From my understanding this would be false info.
>=20
> Yeah, it's a cosmetic thing. I've never really taken the time to look a=
t
> that...

It's not cosmetic if you need correct values for your tests ...

>> 4) If we define rw=3Drandrw, rwmixread=3D80, rwmixwrite=3D20 and the v=
erify
>> options, what does the READ process if there isn't enough data written=

>> out yet? Which data does READ read and verify?
>=20
> If you have a split workload like that and are also doing verifies, the=

> read can be either a read verify or just an offset read. In the latter
> case, it doesn't verify anything. It'll just read a block (or multiple
> blocks) at some offset instead of writing it.

That would may explain the fio over-report in 1).

We create a new RBD on the cluster, mount it on the client and let fio
start it's test on the RBD. The RBD is completely empty at this moment.
Not sure what happens if fio reads some random offset that may isn't
filled with data at this moment. Or is fio only reading from a prior
written block/offset?

Danny
--=20
Danny Kukawka
 SUSE LINUX Products GmbH
  Maxfeldstrasse 5, D-90409 Nuremberg, Germany
  GF: Jeff Hawn,Jennifer Guild,Felix Imend=F6rffer,HRB16746 (AG N=FCrnber=
g)


--------------enig3DB94B694D576F344A86B9CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iJwEAQECAAYFAk99XPgACgkQ9DHLX79LmTLlEgQAkh7pEd7VbGkl+2rIlAfunLMY
GOvsi0L+m7jrFuNgkY08UtB+7RGamPmm6EF+OmehCyE+pNdaFWpixledxl6UxJdw
MjK5hEZZKPFvze26jdhK8HI1Y43cIdvb0hNOO2c/YLblf/GmmXE2CrZ/7qiFVWEq
wwgwvI6oXsf5XXGVIWI=
=f7Mn
-----END PGP SIGNATURE-----

--------------enig3DB94B694D576F344A86B9CD--


