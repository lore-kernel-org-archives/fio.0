Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH 2/6] configure: Use x86 instead of i386 for $cpu for IA32
Date: Mon, 13 Feb 2017 19:24:15 +0000
Message-ID: <DF4PR84MB01697A35FA0838226A39B300AB590@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170213163239.46188-1-tkusumi@tuxera.com>
 <20170213163239.46188-2-tkusumi@tuxera.com>
In-Reply-To: <20170213163239.46188-2-tkusumi@tuxera.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "kusumi.tomohiro@gmail.com" <kusumi.tomohiro@gmail.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of kusumi.tomohiro@gmail.com
> Sent: Monday, February 13, 2017 10:33 AM
> To: axboe@kernel.dk; fio@vger.kernel.org
> Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
> Subject: [PATCH 2/6] configure: Use x86 instead of i386 for $cpu for IA32
>=20
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>=20
> fio internally uses "x86" for any sort of IA32, so use x86 for $cpu
> as well which gets printed on ./configure.

That's the gcc cpu_type, and derives from  the __i386__  macro value
that configure is checking for. All the other architectures stay with
the cpu_type name at this level.

>  # grep i386 . -rI
>  ./arch/arch.h:#if defined(__i386__)
>  ./configure:elif check_define __i386__ ; then
>  ./configure:  cpu=3D"i386"
>  ./configure:  i386|i486|i586|i686|i86pc|BePC)
>  ./configure:    cpu=3D"i386"
>  ./crc/sha1.c:#if defined(__i386__) || defined(__x86_64__)
>  ./crc/xxhash.c:#if defined(__ARM_FEATURE_UNALIGNED) ||
> defined(__i386) || defined(_M_IX86) || defined(__x86_64__) ||
> defined(_M_X64)

That search points out crc/xxhash.c is missing the trailing __ on the
__i386__ macro, which seems like a bug.

The search should have also found this in arch/arch-x86.h:
    #define FIO_ARCH        (arch_i386)

and an enum arch/arch.h:
    enum {
      arch_i386,

I think they would also need to be changed, if the change is made.
FIO_ARCH is used by gfio in the Architecture box.

---
Robert Elliott, HPE Persistent Memory





