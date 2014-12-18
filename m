Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaLRNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 18 Dec 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y1agY-0007N9-E8
	for fio@vger.kernel.org; Thu, 18 Dec 2014 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141218130003.469904018F@lyth.info>
Date: Thu, 18 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d5e16441bd7727f3e1b90708f957d42a7e47121d:

  gettime: cleanup for FIO_DEBUG_TIME (2014-12-16 23:03:54 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1d31d1bcffe0b282aaadca12dc83d2dd671b84f2:

  parse: remove the arithmetic parser checking (2014-12-17 13:27:32 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      stat: always show disk util in terse v3/v4
      gettime: offset CPU cycle counter by initial value
      gettime: fix compile warning for !ARCH_HAVE_CPU_CLOCK
      Fio 2.2.0
      parse: remove the arithmetic parser checking

 FIO-VERSION-GEN        |    2 +-
 gettime.c              |   28 +++++++++++++++----------
 os/windows/install.wxs |    2 +-
 parse.c                |   53 +-----------------------------------------------
 stat.c                 |    3 +--
 5 files changed, 21 insertions(+), 67 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index e2052c4..f0a0a45 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.14
+DEF_VER=fio-2.2.0
 
 LF='
 '
diff --git a/gettime.c b/gettime.c
index 7e3e2e5..172b478 100644
--- a/gettime.c
+++ b/gettime.c
@@ -17,6 +17,7 @@
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
 static uint64_t max_cycles_for_mult;
+static unsigned long long cycles_start, cycles_wrap;
 #endif
 int tsc_reliable = 0;
 
@@ -25,11 +26,13 @@ struct tv_valid {
 	int last_tv_valid;
 	int warned;
 };
+#ifdef ARCH_HAVE_CPU_CLOCK
 #ifdef CONFIG_TLS_THREAD
 static __thread struct tv_valid static_tv_valid;
 #else
 static pthread_key_t tv_tls_key;
 #endif
+#endif
 
 enum fio_cs fio_clock_source = FIO_PREFERRED_CLOCK_SOURCE;
 int fio_clock_source_set = 0;
@@ -136,14 +139,6 @@ static int fill_clock_gettime(struct timespec *ts)
 
 static void __fio_gettime(struct timeval *tp)
 {
-	struct tv_valid *tv;
-
-#ifdef CONFIG_TLS_THREAD
-	tv = &static_tv_valid;
-#else
-	tv = pthread_getspecific(tv_tls_key);
-#endif
-
 	switch (fio_clock_source) {
 #ifdef CONFIG_GETTIMEOFDAY
 	case CS_GTOD:
@@ -167,14 +162,23 @@ static void __fio_gettime(struct timeval *tp)
 #ifdef ARCH_HAVE_CPU_CLOCK
 	case CS_CPUCLOCK: {
 		uint64_t usecs, t;
+		struct tv_valid *tv;
+
+#ifdef CONFIG_TLS_THREAD
+		tv = &static_tv_valid;
+#else
+		tv = pthread_getspecific(tv_tls_key);
+#endif
 
 		t = get_cpu_clock();
-		if (t < tv->last_cycles && tv->last_tv_valid &&
-		    !tv->warned) {
-			log_err("fio: CPU clock going back in time\n");
+		if (t < cycles_start && !cycles_wrap)
+			cycles_wrap = 1;
+		else if (cycles_wrap && t >= cycles_start && !tv->warned) {
+			log_err("fio: double CPU clock wrap\n");
 			tv->warned = 1;
 		}
 
+		t -= cycles_start;
 		tv->last_cycles = t;
 		tv->last_tv_valid = 1;
 #ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
@@ -299,6 +303,8 @@ static int calibrate_cpu_clock(void)
 	inv_cycles_per_usec = 16777216UL / cycles_per_usec;
 	max_cycles_for_mult = ~0ULL / inv_cycles_per_usec;
 	dprint(FD_TIME, "inv_cycles_per_usec=%lu\n", inv_cycles_per_usec);
+	cycles_start = get_cpu_clock();
+	dprint(FD_TIME, "cycles_start=%llu\n", cycles_start);
 	return 0;
 }
 #else
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 3e15676..26be597 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.14">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.2.0">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/parse.c b/parse.c
index ae87b1e..e70ed20 100644
--- a/parse.c
+++ b/parse.c
@@ -272,53 +272,6 @@ extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
 					  double *dval, double implied_units,
 					  int is_time);
 
-#ifdef CONFIG_ARITHMETIC
-/*
- * These two verification functions are just to gain confidence that
- * the arithmetic processing code is always getting the same answer as the
- * original number parsing code.  Once sufficiently sure that the arithmetic
- * code is always getting the right answers, these can be removed.
- */
-static void verify_exp_parser_float(const char *str, double implied_units, int is_time)
-{
-	long long ival;
-	double dval, tmpval;
-
-	if (sscanf(str, "%lf", &tmpval) != 1)
-		return;
-
-	if (evaluate_arithmetic_expression(str, &ival, &dval, implied_units, is_time) != 0) {
-		log_info("Arithmetic failed on '%s'\n", str);
-		return;
-	}
-	if (dval != tmpval) {
-		log_info("Arithmetic failed on: '%s' got %lf, expected %lf\n",
-				str, dval, tmpval);
-	}
-}
-
-static void verify_exp_parser_decimal(const char *str, long long val, int kilo, int is_seconds,
-				      int is_time)
-{
-	int rc;
-	long long ival;
-	double dval;
-	double implied_units = 1.0;
-
-	if (is_seconds)
-		implied_units = 1000000.0;
-
-	rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units, is_time);
-	if (!rc) {
-		if (ival != val)
-			log_info("Arithmetic failed on '%s', expected %lld, got %lld\n",
-				str, val, ival);
-	} else {
-		log_info("Arithmetic failed on '%s'\n", str);
-	}
-}
-#endif
-
 /*
  * Convert string into a floating number. Return 1 for success and 0 otherwise.
  */
@@ -335,8 +288,6 @@ int str_to_float(const char *str, double *val, int is_time)
 			*val = dval;
 			return 1;
 		}
-	} else {
-		verify_exp_parser_float(str, 1.0, is_time);
 	}
 #endif
 	return 1 == sscanf(str, "%lf", val);
@@ -395,9 +346,7 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 			*val *= mult;
 	} else
 		*val *= get_mult_time(str, len, is_seconds);
-#ifdef CONFIG_ARITHMETIC
-	verify_exp_parser_decimal(str, *val, kilo, is_seconds, is_time);
-#endif
+
 	return 0;
 }
 
diff --git a/stat.c b/stat.c
index 9d816d4..bae3338 100644
--- a/stat.c
+++ b/stat.c
@@ -896,8 +896,7 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 		log_info(";%3.2f%%", io_u_lat_m[i]);
 
 	/* disk util stats, if any */
-	if (is_backend)
-		show_disk_util(1, NULL);
+	show_disk_util(1, NULL);
 
 	/* Additional output if continue_on_error set - default off*/
 	if (ts->continue_on_error)
