Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 7/7] Add os/os-linux-syscall.h to separate syscall NR from arch headers
Date: Wed, 20 Jul 2016 01:33:47 +0900
Message-Id: <1468946027-22580-7-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Linux syscall NR should be defined under os/ with ifdef(arch)
switch rather than arch/ where headers are included not only by
Linux but also all other supported OS that don't need these NR.
(It'll get worse and worse if someone wants to add something
similar under arch/ for other supported OS)

Not sure if you like the way I separated these by adding
os/os-linux-syscall.h, but doing something like
 #if FIO_OS is (Linux or Android)
 ...
 #endif
in arch/arch-*.h doesn't work because arch headers are to be
included prior to os/os-*.h.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 arch/arch-aarch64.h   |   5 -
 arch/arch-alpha.h     |  15 ---
 arch/arch-arm.h       |  22 ----
 arch/arch-hppa.h      |  15 ---
 arch/arch-ia64.h      |  22 ----
 arch/arch-mips.h      |  15 ---
 arch/arch-ppc.h       |  15 ---
 arch/arch-s390.h      |  22 ----
 arch/arch-sh.h        |  15 ---
 arch/arch-sparc.h     |  22 ----
 arch/arch-sparc64.h   |  22 ----
 arch/arch-x86.h       |  22 ----
 arch/arch-x86_64.h    |  30 ------
 os/os-linux-syscall.h | 277 ++++++++++++++++++++++++++++++++++++++++++++++++++
 os/os-linux.h         |   1 +
 15 files changed, 278 insertions(+), 242 deletions(-)
 create mode 100644 os/os-linux-syscall.h

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index a6cfaf2..2a86cc5 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -8,11 +8,6 @@
 
 #define FIO_ARCH	(arch_aarch64)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		30
-#define __NR_ioprio_get		31
-#endif
-
 #define nop		do { __asm__ __volatile__ ("yield"); } while (0)
 #define read_barrier()	do { __sync_synchronize(); } while (0)
 #define write_barrier()	do { __sync_synchronize(); } while (0)
diff --git a/arch/arch-alpha.h b/arch/arch-alpha.h
index c0f784f..9318e15 100644
--- a/arch/arch-alpha.h
+++ b/arch/arch-alpha.h
@@ -3,21 +3,6 @@
 
 #define FIO_ARCH	(arch_alpha)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		442
-#define __NR_ioprio_get		443
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		413
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		468
-#define __NR_sys_tee		470
-#define __NR_sys_vmsplice	471
-#endif
-
 #define nop			do { } while (0)
 #define read_barrier()		__asm__ __volatile__("mb": : :"memory")
 #define write_barrier()		__asm__ __volatile__("wmb": : :"memory")
diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 57d9488..31671fd 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -3,28 +3,6 @@
 
 #define FIO_ARCH	(arch_arm)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		314
-#define __NR_ioprio_get		315
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		270
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		340
-#define __NR_sys_tee		342
-#define __NR_sys_vmsplice	343
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		392
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		393
-#endif
-
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
 	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
diff --git a/arch/arch-hppa.h b/arch/arch-hppa.h
index c1c079e..eb4fc33 100644
--- a/arch/arch-hppa.h
+++ b/arch/arch-hppa.h
@@ -3,21 +3,6 @@
 
 #define FIO_ARCH	(arch_hppa)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		267
-#define __NR_ioprio_get		268
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		236
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		291
-#define __NR_sys_tee		293
-#define __NR_sys_vmsplice	294
-#endif
-
 #define nop	do { } while (0)
 
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
diff --git a/arch/arch-ia64.h b/arch/arch-ia64.h
index 7cdeefc..53c049f 100644
--- a/arch/arch-ia64.h
+++ b/arch/arch-ia64.h
@@ -3,28 +3,6 @@
 
 #define FIO_ARCH	(arch_ia64)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		1274
-#define __NR_ioprio_get		1275
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		1234
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		1297
-#define __NR_sys_tee		1301
-#define __NR_sys_vmsplice	1302
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		1348
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		1349
-#endif
-
 #define nop		asm volatile ("hint @pause" ::: "memory");
 #define read_barrier()	asm volatile ("mf" ::: "memory")
 #define write_barrier()	asm volatile ("mf" ::: "memory")
diff --git a/arch/arch-mips.h b/arch/arch-mips.h
index 0b781d1..6f157fb 100644
--- a/arch/arch-mips.h
+++ b/arch/arch-mips.h
@@ -3,21 +3,6 @@
 
 #define FIO_ARCH	(arch_mips)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		314
-#define __NR_ioprio_get		315
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		215
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		263
-#define __NR_sys_tee		265
-#define __NR_sys_vmsplice	266
-#endif
-
 #define read_barrier()		__asm__ __volatile__("": : :"memory")
 #define write_barrier()		__asm__ __volatile__("": : :"memory")
 #define nop			__asm__ __volatile__("": : :"memory")
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 161c39c..4a8aa97 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -8,21 +8,6 @@
 
 #define FIO_ARCH	(arch_ppc)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		273
-#define __NR_ioprio_get		274
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		233
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		283
-#define __NR_sys_tee		284
-#define __NR_sys_vmsplice	285
-#endif
-
 #define nop	do { } while (0)
 
 #ifdef __powerpc64__
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 71beb7d..2e84bf8 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -3,28 +3,6 @@
 
 #define FIO_ARCH	(arch_s390)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		282
-#define __NR_ioprio_get		283
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		253
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		306
-#define __NR_sys_tee		308
-#define __NR_sys_vmsplice	309
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		376
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		377
-#endif
-
 #define nop		asm volatile("nop" : : : "memory")
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
diff --git a/arch/arch-sh.h b/arch/arch-sh.h
index 9acbbbe..58ff226 100644
--- a/arch/arch-sh.h
+++ b/arch/arch-sh.h
@@ -5,21 +5,6 @@
 
 #define FIO_ARCH	(arch_sh)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set	288
-#define __NR_ioprio_get	289
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64	250
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		313
-#define __NR_sys_tee		315
-#define __NR_sys_vmsplice	316
-#endif
-
 #define nop             __asm__ __volatile__ ("nop": : :"memory")
 
 #define mb()								\
diff --git a/arch/arch-sparc.h b/arch/arch-sparc.h
index d0df883..f82a1f2 100644
--- a/arch/arch-sparc.h
+++ b/arch/arch-sparc.h
@@ -3,28 +3,6 @@
 
 #define FIO_ARCH	(arch_sparc)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		196
-#define __NR_ioprio_get		218
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		209
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		232
-#define __NR_sys_tee		280
-#define __NR_sys_vmsplice	25
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		358
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		359
-#endif
-
 #define nop	do { } while (0)
 
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
diff --git a/arch/arch-sparc64.h b/arch/arch-sparc64.h
index 5c4e649..80c697b 100644
--- a/arch/arch-sparc64.h
+++ b/arch/arch-sparc64.h
@@ -3,28 +3,6 @@
 
 #define FIO_ARCH	(arch_sparc64)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		196
-#define __NR_ioprio_get		218
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		209
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		232
-#define __NR_sys_tee		280
-#define __NR_sys_vmsplice	25
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		358
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		359
-#endif
-
 #define nop	do { } while (0)
 
 #define membar_safe(type) \
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index 9471a89..d3b8985 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -14,28 +14,6 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 
 #define FIO_ARCH	(arch_i386)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		289
-#define __NR_ioprio_get		290
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		250
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		313
-#define __NR_sys_tee		315
-#define __NR_sys_vmsplice	316
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		378
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		379
-#endif
-
 #define	FIO_HUGE_PAGE		4194304
 
 #define nop		__asm__ __volatile__("rep;nop": : :"memory")
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index a0e8c03..e686d10 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -14,36 +14,6 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 
 #define FIO_ARCH	(arch_x86_64)
 
-#ifndef __NR_ioprio_set
-#define __NR_ioprio_set		251
-#define __NR_ioprio_get		252
-#endif
-
-#ifndef __NR_fadvise64
-#define __NR_fadvise64		221
-#endif
-
-#ifndef __NR_sys_splice
-#define __NR_sys_splice		275
-#define __NR_sys_tee		276
-#define __NR_sys_vmsplice	278
-#endif
-
-#ifndef __NR_shmget
-#define __NR_shmget		 29
-#define __NR_shmat		 30
-#define __NR_shmctl		 31
-#define __NR_shmdt		 67
-#endif
-
-#ifndef __NR_preadv2
-#define __NR_preadv2		327
-#endif
-#ifndef __NR_pwritev2
-#define __NR_pwritev2		328
-#endif
-
-
 #define	FIO_HUGE_PAGE		2097152
 
 #define nop		__asm__ __volatile__("rep;nop": : :"memory")
diff --git a/os/os-linux-syscall.h b/os/os-linux-syscall.h
new file mode 100644
index 0000000..2de02f1
--- /dev/null
+++ b/os/os-linux-syscall.h
@@ -0,0 +1,277 @@
+#ifndef FIO_OS_LINUX_SYSCALL_H
+#define FIO_OS_LINUX_SYSCALL_H
+
+#include "../arch/arch.h"
+
+/* Linux syscalls for i386 */
+#if defined(ARCH_X86_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		289
+#define __NR_ioprio_get		290
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		250
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		313
+#define __NR_sys_tee		315
+#define __NR_sys_vmsplice	316
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		378
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		379
+#endif
+
+/* Linux syscalls for x86_64 */
+#elif defined(ARCH_X86_64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		251
+#define __NR_ioprio_get		252
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		221
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		275
+#define __NR_sys_tee		276
+#define __NR_sys_vmsplice	278
+#endif
+
+#ifndef __NR_shmget
+#define __NR_shmget		 29
+#define __NR_shmat		 30
+#define __NR_shmctl		 31
+#define __NR_shmdt		 67
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		327
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		328
+#endif
+
+/* Linux syscalls for ppc */
+#elif defined(ARCH_PPC_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		273
+#define __NR_ioprio_get		274
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		233
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		283
+#define __NR_sys_tee		284
+#define __NR_sys_vmsplice	285
+#endif
+
+/* Linux syscalls for ia64 */
+#elif defined(ARCH_IA64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		1274
+#define __NR_ioprio_get		1275
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		1234
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		1297
+#define __NR_sys_tee		1301
+#define __NR_sys_vmsplice	1302
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		1348
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		1349
+#endif
+
+/* Linux syscalls for alpha */
+#elif defined(ARCH_ALPHA_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		442
+#define __NR_ioprio_get		443
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		413
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		468
+#define __NR_sys_tee		470
+#define __NR_sys_vmsplice	471
+#endif
+
+/* Linux syscalls for s390 */
+#elif defined(ARCH_S390_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		282
+#define __NR_ioprio_get		283
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		253
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		306
+#define __NR_sys_tee		308
+#define __NR_sys_vmsplice	309
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		376
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		377
+#endif
+
+/* Linux syscalls for sparc */
+#elif defined(ARCH_SPARC_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		196
+#define __NR_ioprio_get		218
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		209
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		232
+#define __NR_sys_tee		280
+#define __NR_sys_vmsplice	25
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		358
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		359
+#endif
+
+/* Linux syscalls for sparc64 */
+#elif defined(ARCH_SPARC64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		196
+#define __NR_ioprio_get		218
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		209
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		232
+#define __NR_sys_tee		280
+#define __NR_sys_vmsplice	25
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		358
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		359
+#endif
+
+/* Linux syscalls for arm */
+#elif defined(ARCH_ARM_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		314
+#define __NR_ioprio_get		315
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		270
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		340
+#define __NR_sys_tee		342
+#define __NR_sys_vmsplice	343
+#endif
+
+#ifndef __NR_preadv2
+#define __NR_preadv2		392
+#endif
+#ifndef __NR_pwritev2
+#define __NR_pwritev2		393
+#endif
+
+/* Linux syscalls for mips */
+#elif defined(ARCH_MIPS64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		314
+#define __NR_ioprio_get		315
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		215
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		263
+#define __NR_sys_tee		265
+#define __NR_sys_vmsplice	266
+#endif
+
+/* Linux syscalls for sh */
+#elif defined(ARCH_SH_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		288
+#define __NR_ioprio_get		289
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		250
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		313
+#define __NR_sys_tee		315
+#define __NR_sys_vmsplice	316
+#endif
+
+/* Linux syscalls for hppa */
+#elif defined(ARCH_HPPA_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		267
+#define __NR_ioprio_get		268
+#endif
+
+#ifndef __NR_fadvise64
+#define __NR_fadvise64		236
+#endif
+
+#ifndef __NR_sys_splice
+#define __NR_sys_splice		291
+#define __NR_sys_tee		293
+#define __NR_sys_vmsplice	294
+#endif
+
+/* Linux syscalls for aarch64 */
+#elif defined(ARCH_AARCH64_H)
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		30
+#define __NR_ioprio_get		31
+#endif
+
+#else
+#warning "Unknown architecture"
+#endif
+
+#endif /* FIO_OS_LINUX_SYSCALL_H */
diff --git a/os/os-linux.h b/os/os-linux.h
index 937aade..06235ab 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -18,6 +18,7 @@
 #include <linux/major.h>
 #include <byteswap.h>
 
+#include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
 
-- 
2.5.5


