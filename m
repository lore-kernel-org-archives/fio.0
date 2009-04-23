Return-Path: <fio-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:41309 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753037AbZDWLoz (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 23 Apr 2009 07:44:55 -0400
From: Kedar Sovani <kedars@marvell.com>
Subject: [PATCH] fio: Include support for ARM.
Date: Thu, 23 Apr 2009 17:08:14 +0530
Message-Id: <1240486694-30324-1-git-send-email-kedars@marvell.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@suse.de, Kedar Sovani <kedars@marvell.com>

Resending to the new list.
Assembly instructions picked from include/asm-arm/system.h

Please consider for inclusion.

Signed-off-by: Kedar Sovani <kedars@marvell.com>
diff -urp fio.orig/arch/arch.h fio/arch/arch.h
--- fio.orig/arch/arch.h	2008-11-18 13:22:55.000000000 -0500
+++ fio/arch/arch.h	2009-04-23 13:37:46.000000000 -0400
@@ -10,6 +10,7 @@ enum {
 	arch_alpha,
 	arch_sparc,
 	arch_sparc64,
+	arch_arm,
 };
 
 #if defined(__i386__)
@@ -28,6 +29,8 @@ enum {
 #include "arch-sparc.h"
 #elif defined(__sparc64__)
 #include "arch-sparc64.h"
+#elif defined(__arm__)
+#include "arch-arm.h"
 #else
 #error "Unsupported arch"
 #endif
diff -Nurp fio.orig/arch/arch-arm.h fio/arch/arch-arm.h
--- fio.orig/arch/arch-arm.h	1969-12-31 19:00:00.000000000 -0500
+++ fio/arch/arch-arm.h	2009-04-23 14:20:32.000000000 -0400
@@ -0,0 +1,27 @@
+#ifndef ARCH_ARM_H
+#define ARCH_ARM_H
+
+#define ARCH	(arch_arm)
+
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
+#if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) || defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__)
+#define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
+#define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
+#define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
+#endif
+
+#endif
