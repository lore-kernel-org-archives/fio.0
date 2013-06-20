Return-Path: <Konstantin.Ruvinsky@emc.com>
From: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Date: Thu, 20 Jun 2013 03:53:26 -0400
Subject: RE: meaning of err=84
Message-ID: <EEF9E3C12F20174DA289A981D6CCA6C832466198A4@MX44A.corp.emc.com>
References: <EEF9E3C12F20174DA289A981D6CCA6C8324642B5C2@MX44A.corp.emc.com>
 <20130620073314.GY21663@kernel.dk>
In-Reply-To: <20130620073314.GY21663@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


Thank you, Jens for the help.

I already found data corruption errors (CRC and magic headers) in fio outpu=
t.

Konstantin

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, June 20, 2013 10:33 AM
To: Ruvinsky, Konstantin
Cc: fio@vger.kernel.org
Subject: Re: meaning of err=3D84

On Fri, Jun 14 2013, Ruvinsky, Konstantin wrote:
> Hi,
>=20
> Running the following fio command in Red Hat 6.1
>=20
> fio --name=3Dmyjob --ioengine=3Dlibaio --rw=3Drandrw --bs=3D8k --numjobs=
=3D64=20
> --thread  --direct=3D1 --size=3D400m --directory=3D/mnt --rwmixread=3D50=
=20
> --rwmixwrite=3D50 --do_verify=3D1 --verify=3Dmd5 --verify_fatal=3D1
>=20
> I got the error message:
>=20
> myjob: (groupid=3D0, jobs=3D1): err=3D84 (file:io_u.c:1477, func=3Dio_u_q=
ueued_complete, error=3DInvalid or incomplete multibyte or wide            =
                       character): pid=3D29170: Thu Jun 13 11:56:04 2013
>=20
> fio returns 1280 (0x500)
>=20
> What is the meaning of this error message?

It means you got a verification failure, comparing the data read back to th=
e expected results.

--
Jens Axboe



