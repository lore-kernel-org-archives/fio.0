Return-Path: <sebastian@skayser.de>
MIME-Version: 1.0
From: Sebastian Kayser <sebastian@skayser.de>
Date: Mon, 22 Nov 2010 08:06:28 -0700
Subject: Re: Inappropriate ioctl error on Solaris with direct=1
Message-ID: <20101122150628.GE28050@sebastiankayser.de>
References: <20101116131407.GY28050@sebastiankayser.de>
 <4CE3905E.7030709@fusionio.com>
In-Reply-To: <4CE3905E.7030709@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

* Jens Axboe <jaxboe@fusionio.com> wrote:
> On 2010-11-16 14:14, Sebastian Kayser wrote:
> > I would like to provide fio packages for Solaris 10 (via opencsw.org).
> > Building 1.44.2 worked fine, but when running fio with direct=3D1, it
> > fails with an ioctl error. Is this to be expected?
> >=20
> > [...]
> >=20
> > # truss -ftopen,ioctl fio --name=3Dtest --size=3D1g --rw=3Dwrite --file=
name=3Dfoo --runtime=3D60 --direct=3D1
> > ...
> > 2472:   ioctl(1, TCGETA, 0x08045814)                    =3D 0
> > test: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1
> > 2472:   open64("/tmp/.fio_mutex.psaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) =
=3D 8
> > 2472:   open64("/tmp/.fio_mutex.qsaa1e", O_RDWR|O_CREAT|O_EXCL, 0600) =
=3D 9
> > Starting 1 process
> > test: Laying out IO file(s) (1 file(s) / 1024MB)
> > 2472:   open64("foo", O_WRONLY|O_CREAT, 0644)           =3D 10
> > 2473:   open64("foo", O_RDWR|O_CREAT, 0600)             =3D 7
> > 2473:   ioctl(7, _ION('f', 76, 0), 0x00000001)          Err#25 ENOTTY
> > fio: pid=3D2473, err=3D25/file:ioengines.c:404, func=3Dfio_set_odirect,=
 error=3DInappropriate ioctl for device
>=20
> Not sure what the situation is on Solaris, but at least on Linux the
> file system has to support direct IO. What file system do you have on
> /tmp? Does it work if you place the files somewhere else?

The above test was carried out on ZFS. I now also tested on UFS where
direct=3D1 work just fine. Thanks for the pointer, will go out and look
into the ZFS + direct I/O details. Would it be asked too much to have
fio emit an error message hinting towards the "FS needs to be direct I/O
aware" caveat?

> > On a related note: do you guys have access to Solaris systems? If not, =
we
> > do happily provide access to our build farm (Solaris 8/9/10, x86/SPARC,
> > equipped with gcc3/4 and Sun Studio 11/12) for upstream mainainers [1].=
 So
> > just let me know, if this sounds beneficial to you.
>=20
> I used to have a small T2 box on my desk that could boot into Solaris,
> that's where I did the initial port and testing. But I don't anymore.
> But to be honest, I would rather rely on someone trusted to tell me that
> it works on platform XYZ, I just don't have the resources to run a full
> battery of tests on all the platforms that fio supports every time I do
> a release.

Understood. Feel free to let us know in case you find yourself in need
of Solaris access anyway.

Sebastian

