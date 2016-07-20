Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55807 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbcGTMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 Jul 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bPqAW-0007ro-Ck
	for fio@vger.kernel.org; Wed, 20 Jul 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160720120002.501402C29E7@kernel.dk>
Date: Wed, 20 Jul 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e4d03925dca33524be25d883febf9d3b83155a9f:

  plot: indicate that the pattern is a glob (2016-07-17 09:03:48 +0100)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to eec97b935abb714bf498c96a8f18ec1104c75fd4:

  Add missing header inclusion for Android from 1c764dbe (2016-07-19 16:20:02 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (8):
      Fix wrong cpuio option name in documentation
      Add CPU affinity support for DragonFlyBSD
      Make I/O priority option generic for non-Linux environment [1/2]
      Make I/O priority option generic for non-Linux environment [2/2]
      Add ioprio_set() support for DragonFlyBSD
      Change ARCH_X86_64_h to ARCH_X86_64_H
      Add os/os-linux-syscall.h to separate syscall NR from arch headers
      Add missing header inclusion for Android from 1c764dbe

 HOWTO                 |   5 +-
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
 arch/arch-x86_64.h    |  34 +------
 fio.1                 |   2 +-
 options.c             |  28 +++--
 os/os-android.h       |   8 ++
 os/os-dragonfly.h     | 138 ++++++++++++++++++++++++-
 os/os-linux-syscall.h | 277 ++++++++++++++++++++++++++++++++++++++++++++++++++
 os/os-linux.h         |   8 ++
 20 files changed, 452 insertions(+), 260 deletions(-)
 create mode 100644 os/os-linux-syscall.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a50f93e..ab25cb2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -749,7 +749,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 
 			cpuio	Doesn't transfer any data, but burns CPU
 				cycles according to the cpuload= and
-				cpucycle= options. Setting cpuload=85
+				cpuchunks= options. Setting cpuload=85
 				will cause that job to do nothing but burn
 				85% of the CPU. In case of SMP machines,
 				use numjobs=<no_of_cpu> to get desired CPU
@@ -1064,7 +1064,8 @@ nice=int	Run the job with the given nice value. See man nice(2).
 
 prio=int	Set the io priority value of this job. Linux limits us to
 		a positive value between 0 and 7, with 0 being the highest.
-		See man ionice(1).
+		See man ionice(1). Refer to an appropriate manpage for
+		other operating systems since meaning of priority may differ.
 
 prioclass=int	Set the io priority class. See man ionice(1).
 
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
index 21da412..e686d10 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,5 +1,5 @@
-#ifndef ARCH_X86_64_h
-#define ARCH_X86_64_h
+#ifndef ARCH_X86_64_H
+#define ARCH_X86_64_H
 
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
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
diff --git a/fio.1 b/fio.1
index 353f8ff..e89c3d1 100644
--- a/fio.1
+++ b/fio.1
@@ -654,7 +654,7 @@ and send/receive. This ioengine defines engine specific options.
 .TP
 .B cpuio
 Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR and
-\fBcpucycles\fR parameters.
+\fBcpuchunks\fR parameters.
 .TP
 .B guasi
 The GUASI I/O engine is the Generic Userspace Asynchronous Syscall Interface
diff --git a/options.c b/options.c
index 5199823..4723e41 100644
--- a/options.c
+++ b/options.c
@@ -3012,36 +3012,42 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ioprio),
 		.help	= "Set job IO priority value",
-		.minval	= 0,
-		.maxval	= 7,
+		.minval	= IOPRIO_MIN_PRIO,
+		.maxval	= IOPRIO_MAX_PRIO,
 		.interval = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
+#else
+	{
+		.name	= "prio",
+		.lname	= "I/O nice priority",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support IO priorities",
+	},
+#endif
+#ifdef FIO_HAVE_IOPRIO_CLASS
+#ifndef FIO_HAVE_IOPRIO
+#error "FIO_HAVE_IOPRIO_CLASS requires FIO_HAVE_IOPRIO"
+#endif
 	{
 		.name	= "prioclass",
 		.lname	= "I/O nice priority class",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(ioprio_class),
 		.help	= "Set job IO priority class",
-		.minval	= 0,
-		.maxval	= 3,
+		.minval	= IOPRIO_MIN_PRIO_CLASS,
+		.maxval	= IOPRIO_MAX_PRIO_CLASS,
 		.interval = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_CRED,
 	},
 #else
 	{
-		.name	= "prio",
-		.lname	= "I/O nice priority",
-		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support IO priorities",
-	},
-	{
 		.name	= "prioclass",
 		.lname	= "I/O nice priority class",
 		.type	= FIO_OPT_UNSUPPORTED,
-		.help	= "Your platform does not support IO priorities",
+		.help	= "Your platform does not support IO priority classes",
 	},
 #endif
 	{
diff --git a/os/os-android.h b/os/os-android.h
index 1699539..cdae703 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -16,12 +16,14 @@
 #include <linux/major.h>
 #include <asm/byteorder.h>
 
+#include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
 
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_IOPRIO
+#define FIO_HAVE_IOPRIO_CLASS
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
@@ -140,6 +142,12 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_MIN_PRIO		0	/* highest priority */
+#define IOPRIO_MAX_PRIO		7	/* lowest priority */
+
+#define IOPRIO_MIN_PRIO_CLASS	0
+#define IOPRIO_MAX_PRIO_CLASS	3
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	/*
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index d776d1f..187330b 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -10,6 +10,8 @@
 #include <sys/statvfs.h>
 #include <sys/diskslice.h>
 #include <sys/ioctl_compat.h>
+#include <sys/usched.h>
+#include <sys/resource.h>
 
 #include "../file.h"
 
@@ -20,8 +22,8 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
-
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#define FIO_HAVE_CPU_AFFINITY
+#define FIO_HAVE_IOPRIO
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -33,7 +35,139 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
+/* This is supposed to equal (sizeof(cpumask_t)*8) */
+#define FIO_MAX_CPUS	SMP_MAXCPU
+
 typedef off_t off64_t;
+typedef cpumask_t os_cpu_mask_t;
+
+/*
+ * These macros are copied from sys/cpu/x86_64/include/types.h.
+ * It's okay to copy from arch dependent header because x86_64 is the only
+ * supported arch, and no other arch is going to be supported any time soon.
+ *
+ * These are supposed to be able to be included from userspace by defining
+ * _KERNEL_STRUCTURES, however this scheme is badly broken that enabling it
+ * causes compile-time conflicts with other headers. Although the current
+ * upstream code no longer requires _KERNEL_STRUCTURES, they should be kept
+ * here for compatibility with older versions.
+ */
+#ifndef CPUMASK_SIMPLE
+#define CPUMASK_SIMPLE(cpu)		((uint64_t)1 << (cpu))
+#define CPUMASK_TESTBIT(val, i)		((val).ary[((i) >> 6) & 3] & \
+					 CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_ORBIT(mask, i)		((mask).ary[((i) >> 6) & 3] |= \
+					 CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_NANDBIT(mask, i)	((mask).ary[((i) >> 6) & 3] &= \
+					 ~CPUMASK_SIMPLE((i) & 63))
+#define CPUMASK_ASSZERO(mask)		do {				\
+					(mask).ary[0] = 0;		\
+					(mask).ary[1] = 0;		\
+					(mask).ary[2] = 0;		\
+					(mask).ary[3] = 0;		\
+					} while(0)
+#endif
+
+/*
+ * Define USCHED_GET_CPUMASK as the macro didn't exist until release 4.5.
+ * usched_set(2) returns EINVAL if the kernel doesn't support it, though
+ * fio_getaffinity() returns void.
+ *
+ * Also note usched_set(2) works only for the current thread regardless of
+ * the command type. It doesn't work against another thread regardless of
+ * a caller's privilege. A caller would generally specify 0 for pid for the
+ * current thread though that's the only choice. See BUGS in usched_set(2).
+ */
+#ifndef USCHED_GET_CPUMASK
+#define USCHED_GET_CPUMASK	5
+#endif
+
+static inline int fio_cpuset_init(os_cpu_mask_t *mask)
+{
+	CPUMASK_ASSZERO(*mask);
+	return 0;
+}
+
+static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
+{
+	return 0;
+}
+
+static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
+{
+	CPUMASK_NANDBIT(*mask, cpu);
+}
+
+static inline void fio_cpu_set(os_cpu_mask_t *mask, int cpu)
+{
+	CPUMASK_ORBIT(*mask, cpu);
+}
+
+static inline int fio_cpu_isset(os_cpu_mask_t *mask, int cpu)
+{
+	if (CPUMASK_TESTBIT(*mask, cpu))
+		return 1;
+
+	return 0;
+}
+
+static inline int fio_cpu_count(os_cpu_mask_t *mask)
+{
+	int i, n = 0;
+
+	for (i = 0; i < FIO_MAX_CPUS; i++)
+		if (CPUMASK_TESTBIT(*mask, i))
+			n++;
+
+	return n;
+}
+
+static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
+{
+	int i, firstcall = 1;
+
+	/* 0 for the current thread, see BUGS in usched_set(2) */
+	pid = 0;
+
+	for (i = 0; i < FIO_MAX_CPUS; i++) {
+		if (!CPUMASK_TESTBIT(mask, i))
+			continue;
+		if (firstcall) {
+			if (usched_set(pid, USCHED_SET_CPU, &i, sizeof(int)))
+				return -1;
+			firstcall = 0;
+		} else {
+			if (usched_set(pid, USCHED_ADD_CPU, &i, sizeof(int)))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+{
+	/* 0 for the current thread, see BUGS in usched_set(2) */
+	pid = 0;
+
+	usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask));
+}
+
+/* fio code is Linux based, so rename macros to Linux style */
+#define IOPRIO_WHO_PROCESS	PRIO_PROCESS
+#define IOPRIO_WHO_PGRP		PRIO_PGRP
+#define IOPRIO_WHO_USER		PRIO_USER
+
+#define IOPRIO_MIN_PRIO		1	/* lowest priority */
+#define IOPRIO_MAX_PRIO		10	/* highest priority */
+
+/*
+ * Prototypes declared in sys/sys/resource.h are preventing from defining
+ * ioprio_set() with 4 arguments, so define fio's ioprio_set() as a macro.
+ * Note that there is no idea of class within ioprio_set(2) unlike Linux.
+ */
+#define ioprio_set(which, who, ioprio_class, ioprio)	\
+	ioprio_set(which, who, ioprio)
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
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
index b36d33c..06235ab 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -18,6 +18,7 @@
 #include <linux/major.h>
 #include <byteswap.h>
 
+#include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
 
@@ -25,6 +26,7 @@
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_SGIO
 #define FIO_HAVE_IOPRIO
+#define FIO_HAVE_IOPRIO_CLASS
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
@@ -96,6 +98,12 @@ enum {
 #define IOPRIO_BITS		16
 #define IOPRIO_CLASS_SHIFT	13
 
+#define IOPRIO_MIN_PRIO		0	/* highest priority */
+#define IOPRIO_MAX_PRIO		7	/* lowest priority */
+
+#define IOPRIO_MIN_PRIO_CLASS	0
+#define IOPRIO_MAX_PRIO_CLASS	3
+
 static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
 {
 	/*
