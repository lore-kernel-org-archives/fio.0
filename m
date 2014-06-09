Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaFIMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 9 Jun 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WtyFB-0004Gc-2o
	for fio@vger.kernel.org; Mon, 09 Jun 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140609120002.E200240164@lyth.info>
Date: Mon,  9 Jun 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 290a9a2ae1778428123d4a6b10d4db7c18993b17:

  glusterfs: remove glfs-handles.h include (2014-06-03 08:36:20 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 78c8831e2ec211a293ccd8bd37c169719ca1ba4a:

  Add aarch64 support. (2014-06-08 21:17:49 -0600)

----------------------------------------------------------------
Doug Kwan (1):
      Add aarch64 support.

 arch/arch-aarch64.h |   35 +++++++++++++++++++++++++++++++++++
 arch/arch.h         |    3 +++
 2 files changed, 38 insertions(+)
 create mode 100644 arch/arch-aarch64.h

---

Diff of recent changes:

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
