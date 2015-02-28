Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbB1NAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 28 Feb 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YRh00-0000Zr-Fc
	for fio@vger.kernel.org; Sat, 28 Feb 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150228130003.5AC5E40191@lyth.info>
Date: Sat, 28 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3d0e3417997d9caa27cf97462e15ba437d285d29:

  Fix segfault due to bad munmap() (2015-02-26 15:38:42 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f52c9691bc8c285f3445235c69acdfd6de7f9b82:

  Fio 2.2.6 (2015-02-27 08:30:04 -0700)

----------------------------------------------------------------
fio v2.2.6

----------------------------------------------------------------
Ben England (1):
      Patch to make per-thread IOPS more accurate

Christian Ehrhardt (1):
      fio: fix cycles_start build issue

Jens Axboe (1):
      Fio 2.2.6

 FIO-VERSION-GEN        |    2 +-
 arch/arch-s390.h       |    1 +
 arch/arch.h            |    2 ++
 gettime.c              |    6 ++++++
 os/windows/install.wxs |    2 +-
 stat.c                 |   11 ++++++-----
 6 files changed, 17 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index da75022..9ae7b7d 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.2.5
+DEF_VER=fio-2.2.6
 
 LF='
 '
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 169282b..cc7a1d1 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -40,6 +40,7 @@ static inline unsigned long long get_cpu_clock(void)
 
 #define ARCH_CPU_CLOCK_CYCLES_PER_USEC 1
 #define ARCH_HAVE_CPU_CLOCK
+#undef ARCH_CPU_CLOCK_WRAPS
 
 #define ARCH_HAVE_INIT
 extern int tsc_reliable;
diff --git a/arch/arch.h b/arch/arch.h
index 0075f73..5671b9a 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -30,6 +30,8 @@ enum {
 
 extern unsigned long arch_flags;
 
+#define ARCH_CPU_CLOCK_WRAPS
+
 #if defined(__i386__)
 #include "arch-x86.h"
 #elif defined(__x86_64__)
diff --git a/gettime.c b/gettime.c
index 6863ce3..d1c8eb9 100644
--- a/gettime.c
+++ b/gettime.c
@@ -17,6 +17,8 @@
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
 static uint64_t max_cycles_for_mult;
+#endif
+#ifdef ARCH_CPU_CLOCK_WRAPS
 static unsigned long long cycles_start, cycles_wrap;
 #endif
 int tsc_reliable = 0;
@@ -171,6 +173,7 @@ static void __fio_gettime(struct timeval *tp)
 #endif
 
 		t = get_cpu_clock();
+#ifdef ARCH_CPU_CLOCK_WRAPS
 		if (t < cycles_start && !cycles_wrap)
 			cycles_wrap = 1;
 		else if (cycles_wrap && t >= cycles_start && !tv->warned) {
@@ -179,6 +182,7 @@ static void __fio_gettime(struct timeval *tp)
 		}
 
 		t -= cycles_start;
+#endif
 		tv->last_cycles = t;
 		tv->last_tv_valid = 1;
 #ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
@@ -311,8 +315,10 @@ static int calibrate_cpu_clock(void)
 	inv_cycles_per_usec = 16777216UL / cycles_per_usec;
 	max_cycles_for_mult = ~0ULL / inv_cycles_per_usec;
 	dprint(FD_TIME, "inv_cycles_per_usec=%lu\n", inv_cycles_per_usec);
+#ifdef ARCH_CPU_CLOCK_WRAPS
 	cycles_start = get_cpu_clock();
 	dprint(FD_TIME, "cycles_start=%llu\n", cycles_start);
+#endif
 	return 0;
 }
 #else
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index f72dfb1..74f1d28 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.5">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.6">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/stat.c b/stat.c
index db4a387..85bd728 100644
--- a/stat.c
+++ b/stat.c
@@ -674,9 +674,9 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		struct group_run_stats *rs, int ddir, struct json_object *parent)
 {
 	unsigned long min, max;
-	unsigned long long bw, iops;
+	unsigned long long bw;
 	unsigned int *ovals = NULL;
-	double mean, dev;
+	double mean, dev, iops;
 	unsigned int len, minv, maxv;
 	int i;
 	const char *ddirname[] = {"read", "write", "trim"};
@@ -693,17 +693,18 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_object(parent,
 		ts->unified_rw_rep ? "mixed" : ddirname[ddir], dir_object);
 
-	iops = bw = 0;
+	bw = 0;
+	iops = 0.0;
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
 		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
-		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
+		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
 	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir] >> 10);
 	json_object_add_value_int(dir_object, "bw", bw);
-	json_object_add_value_int(dir_object, "iops", iops);
+	json_object_add_value_float(dir_object, "iops", iops);
 	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
 	json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[ddir]);
 	json_object_add_value_int(dir_object, "short_ios", ts->short_io_u[ddir]);
