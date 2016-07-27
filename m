Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 15/15] Change arch_i386 to arch_x86
Date: Wed, 27 Jul 2016 22:37:20 +0900
Message-Id: <1469626640-13335-15-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

fio_arch_strings[arch_i386] is "x86" (not "i386"),
so change arch_i386 to arch_x86.

Other than arch_i386, "i386" is only used in __i386__.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 arch/arch-x86.h       | 2 +-
 arch/arch.h           | 2 +-
 os/os-linux-syscall.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arch-x86.h b/arch/arch-x86.h
index d3b8985..457b44c 100644
--- a/arch/arch-x86.h
+++ b/arch/arch-x86.h
@@ -12,7 +12,7 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 
 #include "arch-x86-common.h"
 
-#define FIO_ARCH	(arch_i386)
+#define FIO_ARCH	(arch_x86)
 
 #define	FIO_HUGE_PAGE		4194304
 
diff --git a/arch/arch.h b/arch/arch.h
index 043e283..00d247c 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -3,7 +3,7 @@
 
 enum {
 	arch_x86_64 = 1,
-	arch_i386,
+	arch_x86,
 	arch_ppc,
 	arch_ia64,
 	arch_s390,
diff --git a/os/os-linux-syscall.h b/os/os-linux-syscall.h
index 2de02f1..c399b2f 100644
--- a/os/os-linux-syscall.h
+++ b/os/os-linux-syscall.h
@@ -3,7 +3,7 @@
 
 #include "../arch/arch.h"
 
-/* Linux syscalls for i386 */
+/* Linux syscalls for x86 */
 #if defined(ARCH_X86_H)
 #ifndef __NR_ioprio_set
 #define __NR_ioprio_set		289
-- 
2.5.5


