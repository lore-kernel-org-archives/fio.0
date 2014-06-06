Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:49123 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFFW3W (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 Jun 2014 18:29:22 -0400
Received: by mail-oa0-f73.google.com with SMTP id g18so741651oah.2
        for <fio@vger.kernel.org>; Fri, 06 Jun 2014 15:29:22 -0700 (PDT)
From: Doug Kwan <dougkwan@google.com>
Subject: [PATCH] Add aarch64 support.
Date: Fri,  6 Jun 2014 15:29:11 -0700
Message-Id: <1402093751-32175-1-git-send-email-dougkwan@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Doug Kwan <dougkwan@google.com>

This patch adds support for aarch64 for fio.  This is tested by building
FIO on an aarch64 Ubuntu system and running some samepls.

Signed-off-by: Doug Kwan <dougkwan@google.com>
---
 arch/arch-aarch64.h | 35 +++++++++++++++++++++++++++++++++++
 arch/arch.h         |  3 +++
 2 files changed, 38 insertions(+)
 create mode 100644 arch/arch-aarch64.h

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
new file mode 100644
index 0000000..a6cfaf2
--- /dev/null
+++ b/arch/arch-aarch64.h
@@ -0,0 +1,35 @@
+#ifndef ARCH_AARCH64_H
+#define ARCH_AARCH64_H
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#define FIO_ARCH	(arch_aarch64)
+
+#ifndef __NR_ioprio_set
+#define __NR_ioprio_set		30
+#define __NR_ioprio_get		31
+#endif
+
+#define nop		do { __asm__ __volatile__ ("yield"); } while (0)
+#define read_barrier()	do { __sync_synchronize(); } while (0)
+#define write_barrier()	do { __sync_synchronize(); } while (0)
+
+static inline int arch_ffz(unsigned long bitmask)
+{
+	unsigned long count, reversed_bits;
+	if (~bitmask == 0)	/* ffz() in lib/ffz.h does this. */
+		return 63;
+
+	__asm__ __volatile__ ("rbit %1, %2\n"
+			      "clz %0, %1\n" : 
+			      "=r"(count), "=&r"(reversed_bits) :
+			      "r"(~bitmask));
+	return count;
+}
+
+#define ARCH_HAVE_FFZ
+
+#endif
diff --git a/arch/arch.h b/arch/arch.h
index 31d96d4..0075f73 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -14,6 +14,7 @@ enum {
 	arch_sh,
 	arch_hppa,
 	arch_mips,
+	arch_aarch64,
 
 	arch_generic,
 
@@ -53,6 +54,8 @@ extern unsigned long arch_flags;
 #include "arch-sh.h"
 #elif defined(__hppa__)
 #include "arch-hppa.h"
+#elif defined(__aarch64__)
+#include "arch-aarch64.h"
 #else
 #warning "Unknown architecture, attempting to use generic model."
 #include "arch-generic.h"
-- 
2.0.0.526.g5318336

