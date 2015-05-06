Return-Path: <Alexey.Skidanov@sandisk.com>
From: Alexey Skidanov <Alexey.Skidanov@sandisk.com>
Subject: RE: FIO on ARM
Date: Wed, 6 May 2015 15:52:57 +0000
Message-ID: <CF2184B79FF73642B463E092E85766BF04A86063@SACMBXIP01.sdcorp.global.sandisk.com>
References: <CF2184B79FF73642B463E092E85766BF04A85605@SACMBXIP01.sdcorp.global.sandisk.com>
 <5548E60E.4010301@kernel.dk>
In-Reply-To: <5548E60E.4010301@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Return-Path: Alexey.Skidanov@sandisk.com
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Alex Lemberg <Alex.Lemberg@sandisk.com>
List-ID: <fio@vger.kernel.org>


> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, May 05, 2015 6:47 PM
> To: Alexey Skidanov; fio@vger.kernel.org
> Cc: Alex Lemberg
> Subject: Re: FIO on ARM
>=20
> On 05/05/2015 03:02 AM, Alexey Skidanov wrote:
> > Hi,
> >
> > I would like to run FIO on an ARM based board. I have cloned the git
> repository by git clone git://git.kernel.dk/fio.git and cross compiled th=
e
> sources (exactly as it explained in the README file). After that, I have =
created
> a simple job file test.fio:
> >
> > [global]
> > bs=3D512k
> > iodepth=3D4
> > size=3D1g
> > direct=3D1
> > runtime=3D60
> > directory=3D ...
> > filename=3D ...
> > ioengine=3Dlibaio
> >
> > [seq-read]
> > rw=3Dread
> > stonewall
> >
> > [rand-read]
> > rw=3Drandread
> > stonewall
> >
> > [seq-write]
> > rw=3Dwrite
> > stonewall
> >
> > [rand-write]
> > rw=3Drandwrite
> > stonewall
> >
> > Running fio test.fio I get the following error:
> >
> > fio: engine libaio not loadable
> > fio: failed to load engine libaio
> > fio: file:ioengines.c:99, func=3Ddlopen, error=3Dlibaio: cannot open sh=
ared
> object file: No such file or directory
> >
> > The config.log file contains the following error:
> >
> > Compiling test case libaio
> > arm-linux-gnueabihf-gcc -D_GNU_SOURCE -include config-host.h -o
> /tmp/fio-conf--17007-.exe /tmp/fio-conf--17007-.c -laio
> > /usr/lib/gcc/arm-linux-gnueabihf/4.6/../../../../arm-linux-gnueabihf/bi=
n/ld:
> cannot find -laio
> > collect2: ld returned 1 exit status
> >
> > The make printouts contain the following lines :
> > FIO_VERSION =3D fio-2.2.7-29-g020d5
> > Running configure for you...
> > Operating system              Linux
> > CPU                           arm
> > Big endian                    no
> > Compiler                      arm-linux-gnueabihf-gcc
> > Cross compile                 yes
> > ...
> > Linux AIO support             no
> > ...
> >
> > Since libaio-dev exists only for amd and i386 platforms, the fio couldn=
't be
> statically linked with aio. Thus, I need to download the libaio sources, =
compile
> them and install the libaio.so on the target.
>=20
> That seems like a distro issue, there's absolutely no reason why
> libaio-dev(el) should not be available on arm based distro.
> Additionally, fio dynamically links with libaio, it's not a static link.
>=20
> --
> Jens Axboe

I configured the APT with additional architecture (armhf) and updated repos=
itories list for this architecture , downloaded the libaio-dev and cross co=
mpiled the FIO. The make  printouts are with  AIO support:

FIO_VERSION =3D fio-2.2.7-29-g020d5
Running configure for you...
Operating system              Linux
CPU                           arm
Big endian                    no
Compiler                      arm-linux-gnueabihf-gcc
Cross compile                 yes
...
Linux AIO support             yes


Now it runs on ARM.

Thanks,
Alexey

