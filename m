Return-Path: <jason.b.akers@intel.com>
From: "Akers, Jason B" <jason.b.akers@intel.com>
Subject: RE: syscall problem on Android x86
Date: Fri, 26 Apr 2013 20:35:54 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B85069D109@ORSMSX110.amr.corp.intel.com>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <20130426181732.GZ9563@kernel.dk>
 <372C7AE269BA5E4D92B1082F530ED4B85069CFEB@ORSMSX110.amr.corp.intel.com>
 <20130426200429.GE9563@kernel.dk>
In-Reply-To: <20130426200429.GE9563@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Unfortunately android x86 doesn't have a syscall number for the shm* functi=
ons. They are not exposed by x86 bionic libc. So there's nothing to fill in=
 for a/b/c/d.

The only way I see to get syscall numbers is to patch x86 android libc and =
recompile. This should work for me today but, since the syscall numbers are=
 not standardized, it will not work for anyone with an unmodified libc.

So I propose something like:

#ifndef __NR_shmget
#if defined(__ANDROID__)
#error "__NR_shmget not defined. See bionic libc SYSCALLS.TXT for more info=
rmation."
#else
#define __NR_shmget		 29
#define __NR_shmat		 30
#define __NR_shmctl		 31
#define __NR_shmdt		 67
#endif
#endif

This will "break the build" for unmodified x86 android platforms, but I thi=
nk that's better than compiling and not working.

The other (probably better long-term) option is to use ashmem for allocatin=
g shared memory on android.

Jason Akers


-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behal=
f Of Jens Axboe
Sent: Friday, April 26, 2013 1:04 PM
To: Akers, Jason B
Cc: fio@vger.kernel.org
Subject: Re: syscall problem on Android x86

On Fri, Apr 26 2013, Akers, Jason B wrote:
> Hi Jens,
>=20
> Sorry for the confusion. I'm building for x86 Android, not arm.
>=20
> The issue is that Android x86 does not define __NR_shmget. And the=20
> fact that it's hardcoded to 29 in arch-x86.h is causing problems. On
> x86 Android syscall 29 is actually the sys_pause() function.
> Therefore, fio compiles but it just pauses when shmget() is called.

Ah I see, so android x86  You could hack around it a little bit. In arch-x8=
6.h, something ala:

#ifndef __NR_shmget
#if defined(__ANDROID__)
#define __NR_shmget		 a
#define __NR_shmat		 b
#define __NR_shmctl		 c
#define __NR_shmdt		 d
#else
#define __NR_shmget		 29
#define __NR_shmat		 30
#define __NR_shmctl		 31
#define __NR_shmdt		 67
#endif
#endif

with a/b/c/d being the right values for the android abi.

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body =
of a message to majordomo@vger.kernel.org More majordomo info at  http://vg=
er.kernel.org/majordomo-info.html

