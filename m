Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53998 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfAXNAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Jan 2019 08:00:21 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gmecG-0002U6-8b
        for fio@vger.kernel.org; Thu, 24 Jan 2019 13:00:20 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190124130001.E2F652C00C0@kernel.dk>
Date: Thu, 24 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2d644205f56953192d27ccbf193c899ae559fcb7:

  engines/io_uring: cleanup setrlimit() (2019-01-16 09:07:13 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63ed82548f4489b4c6d5df688f7405b9eb20ddc9:

  io_uring: system calls have been renumbered (2019-01-23 08:04:28 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: system calls have been renumbered

 arch/arch-x86-common.h | 11 +++++++++++
 arch/arch-x86.h        | 11 -----------
 arch/arch-x86_64.h     | 11 -----------
 3 files changed, 11 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86-common.h b/arch/arch-x86-common.h
index 5140f238..7c07a61c 100644
--- a/arch/arch-x86-common.h
+++ b/arch/arch-x86-common.h
@@ -3,6 +3,16 @@
 
 #include <string.h>
 
+#ifndef __NR_sys_io_uring_setup
+#define __NR_sys_io_uring_setup		425
+#endif
+#ifndef __NR_sys_io_uring_enter
+#define __NR_sys_io_uring_enter		426
+#endif
+#ifndef __NR_sys_io_uring_register
+#define __NR_sys_io_uring_register	427
+#endif
+
 static inline void cpuid(unsigned int op,
 			 unsigned int *eax, unsigned int *ebx,
 			 unsigned int *ecx, unsigned int *edx)
@@ -13,6 +23,7 @@ static inline void cpuid(unsigned int op,
 }
 
 #define ARCH_HAVE_INIT
+#define ARCH_HAVE_IOURING
 
 extern bool tsc_reliable;
 extern int arch_random;
diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index c1c866ea..c6bcb54c 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -1,16 +1,6 @@
 #ifndef ARCH_X86_H
 #define ARCH_X86_H
 
-#ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup		387
-#endif
-#ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter		388
-#endif
-#ifndef __NR_sys_io_uring_register
-#define __NR_sys_io_uring_register	389
-#endif
-
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
 {
@@ -46,6 +36,5 @@ static inline unsigned long long get_cpu_clock(void)
 
 #define ARCH_HAVE_FFZ
 #define ARCH_HAVE_CPU_CLOCK
-#define ARCH_HAVE_IOURING
 
 #endif
diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 0cd21b8f..25850f90 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,16 +1,6 @@
 #ifndef ARCH_X86_64_H
 #define ARCH_X86_64_H
 
-#ifndef __NR_sys_io_uring_setup
-#define __NR_sys_io_uring_setup		335
-#endif
-#ifndef __NR_sys_io_uring_enter
-#define __NR_sys_io_uring_enter		336
-#endif
-#ifndef __NR_sys_io_uring_register
-#define __NR_sys_io_uring_register	337
-#endif
-
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
 {
@@ -47,7 +37,6 @@ static inline unsigned long long get_cpu_clock(void)
 #define ARCH_HAVE_FFZ
 #define ARCH_HAVE_SSE4_2
 #define ARCH_HAVE_CPU_CLOCK
-#define ARCH_HAVE_IOURING
 
 #define RDRAND_LONG	".byte 0x48,0x0f,0xc7,0xf0"
 #define RDSEED_LONG	".byte 0x48,0x0f,0xc7,0xf8"

