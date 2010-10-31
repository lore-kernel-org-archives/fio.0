Return-Path: <czoffoli@xmerlin.org>
MIME-Version: 1.0
From: Christian Zoffoli <czoffoli@xmerlin.org>
Date: Sun, 31 Oct 2010 06:38:51 -0600
Subject: Re: fio: first direct IO errored
Message-ID: <4CCD635B.8090600@xmerlin.org>
References: <4CCC1540.6090405@xmerlin.org> <4CCCCC11.7010203@fusionio.com>
 <4CCD5D6A.4000103@xmerlin.org> <4CCD60F0.4020608@fusionio.com>
In-Reply-To: <4CCD60F0.4020608@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

Il 31/10/2010 13:28, Jens Axboe ha scritto:
[cut]
> The exposed hw block size is 4096 bytes, so that is also the mimimum
> size at which you can issue unbuffered IO. Your test will work if you
> change the bs=3D1k to bs=3D4k.
>=20

yes, the tests works fine with bs=3D4k but I need to test also bs=3D1k and
bs=3D512 to compare them with the other tests.

I'll try to recreate the raid with different parameters.

Thank you very much for your help.

Best regards,
Christian

