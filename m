Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36716
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751585Ab3DLHQ0 (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 03:16:26 -0400
Date: Fri, 12 Apr 2013 09:16:01 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Make FIO for Android
Message-ID: <20130412071601.GJ12244@kernel.dk>
References: <20130412055808.GE12244@kernel.dk>
 <CAKCZDg=sNxp+mAwTQfBthm-9n=kN2yKgWG52hmmaRBAr+K9fHA@mail.gmail.com>
 <20130412061806.GF12244@kernel.dk>
 <CAKCZDgkF-Pa=5Xzz-PSrFNTjrW-TY2FoQa2m0YpshtLa5SssOw@mail.gmail.com>
 <20130412063005.GG12244@kernel.dk>
 <CAKCZDg=yf2y6hiSoxEExkEo91txMn3HEp7TVovDAmVwJK_M6mw@mail.gmail.com>
 <20130412063851.GH12244@kernel.dk>
 <CAKCZDgkXzGvvdUaYqqR0-3zV==spgU=8QA757CfnRwFbdVj_JA@mail.gmail.com>
 <20130412070034.GI12244@kernel.dk>
 <CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKCZDgmS0mL=7Yiya2yWmfBY5EyE79kwQt66hSxfVOSwHWUCfA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Aaron Carroll <xaaronc@gmail.com>
Cc: "Krishnamurthy, Anush" <anush.krishnamurthy@intel.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 12 2013, Aaron Carroll wrote:
> On 12 April 2013 17:00, Jens Axboe <axboe@kernel.dk> wrote:
> > On Fri, Apr 12 2013, Aaron Carroll wrote:
> >> tuff
> >> > should be basic enough that it isn't a lot of trouble to carry it. At
> >> > least when we figure out why the Android NDK doesn't like the current
> >> > restraints :-)
> >>
> >> Digging around the GCC headers seems to have helped.  If you change
> >> the constraint on ebx to:
> >>         : "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
> >> then it builds.
> >
> > But it doesn't work, we lose the output :-)
> 
> Ahh, I missed some important stuff.  The ASM from cpuid.h looks like
> this on my Android/x86 GCC:
> 
> #define __cpuid(level, a, b, c, d)          \
>   __asm__ ("xchg{l}\t{%%}ebx, %1\n\t"           \
>        "cpuid\n\t"                  \
>        "xchg{l}\t{%%}ebx, %1\n\t"           \
>        : "=a" (a), "=r" (b), "=c" (c), "=d" (d) \
>        : "0" (level))
> 
> Hopefully someone who knows what they're doing can turn that into an fio fix :)

How about this?

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 78fd40c..179572d 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -3,15 +3,6 @@
 
 #include <string.h>
 
-static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
-			    unsigned int *ecx, unsigned int *edx)
-{
-	asm volatile("cpuid"
-		: "=a" (*eax), "=b" (*ebx), "=c" (*ecx), "=d" (*edx)
-		: "0" (*eax), "2" (*ecx)
-		: "memory");
-}
-
 static inline void cpuid(unsigned int op,
 			 unsigned int *eax, unsigned int *ebx,
 			 unsigned int *ecx, unsigned int *edx)
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 69cf60b..49e64dd 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -1,6 +1,15 @@
 #ifndef ARCH_X86_H
 #define ARCH_X86_H
 
+static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
+			    unsigned int *ecx, unsigned int *edx)
+{
+	asm volatile("xchgl %%ebx, %1\ncpuid\nxchgl %%ebx, %1"
+		: "=a" (*eax), "=r" (*ebx), "=c" (*ecx), "=d" (*edx)
+		: "0" (*eax)
+		: "memory");
+}
+
 #include "arch-x86-common.h"
 
 #define FIO_ARCH	(arch_i386)
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index cea0451..8bdf01e 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,6 +1,15 @@
 #ifndef ARCH_X86_64_h
 #define ARCH_X86_64_h
 
+static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
+			    unsigned int *ecx, unsigned int *edx)
+{
+	asm volatile("cpuid"
+		: "=a" (*eax), "=b" (*ebx), "=r" (*ecx), "=d" (*edx)
+		: "0" (*eax), "2" (*ecx)
+		: "memory");
+}
+
 #include "arch-x86-common.h"
 
 #define FIO_ARCH	(arch_x86_64)

> > Patch is garbled?
> 
> Ok, so gmail sucks for dev work.  Sorry.  The Android bit follows inline.
> 
> diff --git a/os/os-android.h b/os/os-android.h
> index b844982..df22333 100644
> --- a/os/os-android.h
> +++ b/os/os-android.h
> @@ -13,6 +13,7 @@
>  #include <sched.h>
>  #include <linux/unistd.h>
>  #include <linux/major.h>
> +#include <asm/byteorder.h>
> 
>  #include "binject.h"
>  #include "../file.h"

Applied! That just leaves the cgroup problems:

cgroup.c: In function 'find_cgroup_mnt':
cgroup.c:29:2: warning: implicit declaration of function 'setmntent'
[-Wimplicit-function-declaration]
cgroup.c:29:4: warning: assignment makes pointer from integer without a
cast [enabled by default]
cgroup.c:35:2: warning: implicit declaration of function 'getmntent_r'
[-Wimplicit-function-declaration]
cgroup.c:35:14: warning: assignment makes pointer from integer without a
cast [enabled by default]
cgroup.c:46:2: warning: implicit declaration of function 'endmntent'
[-Wimplicit-function-declaration]
cgroup.c: At top level:
cgroup.c:78:6: error: redefinition of 'cgroup_kill'
cgroup.h:24:20: note: previous definition of 'cgroup_kill' was here
cgroup.c:147:5: error: redefinition of 'cgroup_setup'
cgroup.h:13:19: note: previous definition of 'cgroup_setup' was here
cgroup.c:189:6: error: redefinition of 'cgroup_shutdown'
cgroup.h:20:20: note: previous definition of 'cgroup_shutdown' was here
make: *** [cgroup.o] Error 1

-- 
Jens Axboe

