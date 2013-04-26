Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34758
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385Ab3DZSRh (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 26 Apr 2013 14:17:37 -0400
Date: Fri, 26 Apr 2013 12:17:32 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: syscall problem on Android x86
Message-ID: <20130426181732.GZ9563@kernel.dk>
References: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <372C7AE269BA5E4D92B1082F530ED4B85069CD30@ORSMSX110.amr.corp.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Akers, Jason B" <jason.b.akers@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Apr 26 2013, Akers, Jason B wrote:
> Fio hangs when run on the Android x86 emulator.
> 
> Tracking through, I found that the last call made is shmget() (in init.c - setup_thread_area()).
> I believe that the hang is related to the fio syscall implementation for x86.
> 
> os-android.h defines shmget as: syscall(__NR_shmget, __key, __size, __shmflg);
> 
> In arch-x86.h __NR_shmget is defined to 29. This was added on April 11th (a415b2cc).
> 
> Looking deeper, I see that syscall 29 is actually mapped to pause(). (see SYSCALLS.TXT in bionic/libc) I confirmed that sys_pause() was being called by using a kernel breakpoint. This explains why fio hangs.
> 
> Now the question is: What to do about it?
> For some reason shmget is only exposed for Android ARM targets even though it is part of the kernel (system.map) for x86.
> 
> I see two options:
> 1. add shmget to SYSCALLS.TXT for x86 and recompile. Remove the hardcoded __NR_shmget from arch-x86.h and put a #error instead to warn others that a kernel patch is necessary for Android x86. 
> 
> 2. use a "blessed" shared memory allocation method for Android targets (like ashmem / mmap??) Not sure how difficult it would be to make this work with the existing FIO architecture.
> 
> Any other ideas / thoughts / feedback / suggestions are appreciated.

So sounds like you are catching the x86 definition of __NR_shmget which
is indeed 29, but you are building on Arm. That sounds pretty weird. The
below patch should wire up the right Arm syscalls, but I think you need
into why it's claiming to be x86 while it is in fact building for arm.


diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 7cd9502..8a7398e 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -18,6 +18,13 @@
 #define __NR_sys_vmsplice	343
 #endif
 
+#ifndef __NR_shmget
+#define __NR_shmat		305
+#define __NR_shmdt		306
+#define __NR_shmget		307
+#define __NR_shmctl		308
+#endif
+
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
 	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__)
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 49e64dd..ce2414d 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -30,9 +30,10 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 #endif
 
 #ifndef __NR_shmget
-#define __NR_shmget 29
-#define __NR_shmat 30
-#define __NR_shmctl 31
+#define __NR_shmget		 29
+#define __NR_shmat		 30
+#define __NR_shmctl		 31
+#define __NR_shmdt		 67
 #endif
 
 #define	FIO_HUGE_PAGE		4194304

-- 
Jens Axboe

