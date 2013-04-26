Return-Path: <jason.b.akers@intel.com>
From: "Akers, Jason B" <jason.b.akers@intel.com>
Subject: RE: syscall problem on Android x86
Date: Fri, 26 Apr 2013 19:46:30 +0000
Message-ID: <372C7AE269BA5E4D92B1082F530ED4B85069CFEB@ORSMSX110.amr.corp.intel.com>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
 <20130426181732.GZ9563@kernel.dk>
In-Reply-To: <20130426181732.GZ9563@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Sorry for the confusion. I'm building for x86 Android, not arm.

The issue is that Android x86 does not define __NR_shmget. And the fact tha=
t it's hardcoded to 29 in arch-x86.h is causing problems. On x86 Android sy=
scall 29 is actually the sys_pause() function. Therefore, fio compiles but =
it just pauses when shmget() is called.

Thanks,
Jason Akers

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Friday, April 26, 2013 11:18 AM
To: Akers, Jason B
Cc: fio@vger.kernel.org
Subject: Re: syscall problem on Android x86

On Fri, Apr 26 2013, Akers, Jason B wrote:
> Fio hangs when run on the Android x86 emulator.
>=20
> Tracking through, I found that the last call made is shmget() (in init.c =
- setup_thread_area()).
> I believe that the hang is related to the fio syscall implementation for =
x86.
>=20
> os-android.h defines shmget as: syscall(__NR_shmget, __key, __size,=20
> __shmflg);
>=20
> In arch-x86.h __NR_shmget is defined to 29. This was added on April 11th =
(a415b2cc).
>=20
> Looking deeper, I see that syscall 29 is actually mapped to pause(). (see=
 SYSCALLS.TXT in bionic/libc) I confirmed that sys_pause() was being called=
 by using a kernel breakpoint. This explains why fio hangs.
>=20
> Now the question is: What to do about it?
> For some reason shmget is only exposed for Android ARM targets even thoug=
h it is part of the kernel (system.map) for x86.
>=20
> I see two options:
> 1. add shmget to SYSCALLS.TXT for x86 and recompile. Remove the hardcoded=
 __NR_shmget from arch-x86.h and put a #error instead to warn others that a=
 kernel patch is necessary for Android x86.=20
>=20
> 2. use a "blessed" shared memory allocation method for Android targets (l=
ike ashmem / mmap??) Not sure how difficult it would be to make this work w=
ith the existing FIO architecture.
>=20
> Any other ideas / thoughts / feedback / suggestions are appreciated.

So sounds like you are catching the x86 definition of __NR_shmget which is =
indeed 29, but you are building on Arm. That sounds pretty weird. The below=
 patch should wire up the right Arm syscalls, but I think you need into why=
 it's claiming to be x86 while it is in fact building for arm.


diff --git a/arch/arch-arm.h b/arch/arch-arm.h index 7cd9502..8a7398e 10064=
4
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	343
 #endif
=20
+#ifndef __NR_shmget
+#define __NR_shmat		305
+#define __NR_shmdt		306
+#define __NR_shmget		307
+#define __NR_shmctl		308
+#endif
+
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__AR=
M_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
 	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_=
ARCH_6Z__) || defined(__ARM_ARCH_6ZK__) diff --git a/arch/arch-x86.h b/arch=
/arch-x86.h index 49e64dd..ce2414d 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -30,9 +30,10 @@ static inline void do_cpuid(unsigned int *eax, unsigned =
int *ebx,  #endif
=20
 #ifndef __NR_shmget
-#define __NR_shmget 29
-#define __NR_shmat 30
-#define __NR_shmctl 31
+#define __NR_shmget		 29
+#define __NR_shmat		 30
+#define __NR_shmctl		 31
+#define __NR_shmdt		 67
 #endif
=20
 #define	FIO_HUGE_PAGE		4194304

--
Jens Axboe


