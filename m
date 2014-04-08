Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:33047 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaDHPwv (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Apr 2014 11:52:51 -0400
Received: from /spool/local
	by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Tue, 8 Apr 2014 16:52:49 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 80FFC219005F
	for <fio@vger.kernel.org>; Tue,  8 Apr 2014 16:52:41 +0100 (BST)
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by b06cxnps4076.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s38FqbLJ61931694
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 15:52:37 GMT
Received: from d06av04.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s38FqlP4028699
	for <fio@vger.kernel.org>; Tue, 8 Apr 2014 09:52:47 -0600
Message-Id: <20140408155246.067812443@linux.vnet.ibm.com>
Date: Tue, 08 Apr 2014 17:52:00 +0200
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 1/2] [PATCH] fio: fix s390 time accounting
References: <20140408155159.696154675@linux.vnet.ibm.com>
Content-Disposition: inline; filename=fix-time-accounting-s390.patch
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

The current timer implementation could cause time warps on s390 which ends up
as time bound jobs that would never end, because they always reset themself to
the old time.

When touching this code anyway, we also change it to use the faster stckf
and avoid the calibration as we can control the result to be usecs.
This also eliminates a few calculations cycle->usec in the hot path for the
timer.

In case other architectures have similar improved timers that might not be
usec based, but nsec based or such a thing any architecture can set
ARCH_CPU_CLOCK_CYCLES_PER_USEC to an appropriate per-arch value.
This leaves the infrastructure open for others and the compiler will throw
our division by 1 away anyway.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 arch/arch-s390.h |   13 +++++++++----
 gettime.c        |   14 +++++++++++---
 2 files changed, 20 insertions(+), 7 deletions(-)

[diff]


Index: fio/arch/arch-s390.h
===================================================================
--- fio.orig/arch/arch-s390.h
+++ fio/arch/arch-s390.h
@@ -22,14 +22,21 @@
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 
+/*
+ * Fio needs monotonic (never lower), but not strict monotonic (never the same)
+ * so store clock fast is enough
+ */
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long long clk;
 
-	__asm__ __volatile__("stck %0" : "=Q" (clk) : : "cc");
-	return clk;
+	__asm__ __volatile__("stckf %0" : "=Q" (clk) : : "cc");
+	return clk>>12;
 }
 
+#define ARCH_CPU_CLOCK_CYCLES_PER_USEC 1
+#define ARCH_HAVE_CPU_CLOCK
+
 #define ARCH_HAVE_INIT
 extern int tsc_reliable;
 static inline int arch_init(char *envp[])
@@ -38,6 +45,4 @@ static inline int arch_init(char *envp[]
 	return 0;
 }
 
-#define ARCH_HAVE_CPU_CLOCK
-
 #endif
Index: fio/gettime.c
===================================================================
--- fio.orig/gettime.c
+++ fio/gettime.c
@@ -13,7 +13,7 @@
 #include "hash.h"
 #include "os/os.h"
 
-#ifdef ARCH_HAVE_CPU_CLOCK
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
 #endif
@@ -177,7 +177,11 @@ static void *__fio_gettime(struct timeva
 		} else if (tv)
 			tv->last_cycles = t;
 
+#ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
+		usecs = t / ARCH_CPU_CLOCK_CYCLES_PER_USEC;
+#else
 		usecs = (t * inv_cycles_per_usec) / 16777216UL;
+#endif
 		tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
 		break;
@@ -229,7 +233,7 @@ void fio_gettime(struct timeval *tp, voi
 	}
 }
 
-#ifdef ARCH_HAVE_CPU_CLOCK
+#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
 static unsigned long get_cycles_per_usec(void)
 {
 	struct timeval s, e;
@@ -318,9 +322,13 @@ static int calibrate_cpu_clock(void)
 #else
 static int calibrate_cpu_clock(void)
 {
+#ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
+	return 0;
+#else
 	return 1;
-}
 #endif
+}
+#endif // ARCH_HAVE_CPU_CLOCK
 
 #ifndef CONFIG_TLS_THREAD
 void fio_local_clock_init(int is_thread)

