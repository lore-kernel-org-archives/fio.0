Return-Path: <fio-owner@vger.kernel.org>
Received: from nat-pool-12-rdu.redhat.com ([66.187.233.206]:49069 "EHLO
	devel4.s390.bos.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755140Ab2L3WjS (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 30 Dec 2012 17:39:18 -0500
From: =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>
Subject: [PATCH] implement get_cpu_clock() for s390/s390x
Date: Sun, 30 Dec 2012 17:03:36 -0500
Message-Id: <1356905016-48651-1-git-send-email-dan@danny.cz>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: =?UTF-8?q?Dan=20Hor=C3=A1k?= <dan@danny.cz>

---
 arch/arch-s390.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index fe51791..bcd9163 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -22,4 +22,22 @@
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 
+static inline unsigned long long get_cpu_clock(void)
+{
+	unsigned long long clk;
+
+	__asm__ __volatile__("stck %0" : "=Q" (clk) : : "cc");
+	return clk;
+}
+
+#define ARCH_HAVE_INIT
+extern int tsc_reliable;
+static inline int arch_init(char *envp[])
+{
+	tsc_reliable = 1;
+	return 0;
+}
+
+#define ARCH_HAVE_CPU_CLOCK
+
 #endif
-- 
1.7.7.6

