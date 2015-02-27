Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:55845 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbB0Ibr (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 27 Feb 2015 03:31:47 -0500
Received: from /spool/local
	by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Fri, 27 Feb 2015 08:31:44 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9A2B6219005F
	for <fio@vger.kernel.org>; Fri, 27 Feb 2015 08:31:34 +0000 (GMT)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t1R8Vfa17930284
	for <fio@vger.kernel.org>; Fri, 27 Feb 2015 08:31:41 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t1R8VfxC010597
	for <fio@vger.kernel.org>; Fri, 27 Feb 2015 01:31:41 -0700
Message-ID: <54F02B6C.8080506@linux.vnet.ibm.com>
Date: Fri, 27 Feb 2015 09:31:40 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: [PATCH] fio: fix cycles_start build issue
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Hi,
a recent checkout of fio-git revealed a build issue on s390.
For whatever reason my git send-email setup is broken so I paste it in 
the mail and hope it doesn't get mangled, let me know if that fails.

---

Subject: [PATCH] fio: fix cycles_start build issue

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

There is an issue introduced with "commit 73df3e07 gettime: offset CPU cycle
counter by initial value". For architectures which define
ARCH_CPU_CLOCK_CYCLES_PER_USEC (currently only s390) this causes a build 
error

gettime.c:174:11: error: ‘cycles_start’ undeclared (first use in this 
function)
    if (t < cycles_start && !cycles_wrap)

To make sure variables and code are only compiled in the same cases I 
added a
clock definition called ARCH_CPU_CLOCK_WRAPS. We could merge
ARCH_CPU_CLOCK_WRAPS and the existing ARCH_CPU_CLOCK_CYCLES_PER_USEC 
into one
if you prefer, so far nobody else uses it.

To avoid cluttering all architecture headers I enabled it by default in
arch-generic.h, so any arch not needing the wrap handling can undef
ARCH_CPU_CLOCK_WRAPS later in their headers.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
  arch/arch-generic.h |    1 +
  arch/arch-s390.h    |    1 +
  gettime.c           |    7 +++++++
  3 files changed, 9 insertions(+)

[diff]
diff --git a/arch/arch-generic.h b/arch/arch-generic.h
index a0b71f8..825a829 100644
--- a/arch/arch-generic.h
+++ b/arch/arch-generic.h
@@ -2,6 +2,7 @@
  #define ARCH_GENERIC_H

  #define FIO_ARCH	(arch_generic)
+#define ARCH_CPU_CLOCK_WRAPS

  #define nop			do { } while (0)
  #define read_barrier()		__asm__ __volatile__("": : :"memory")
diff --git a/arch/arch-s390.h b/arch/arch-s390.h
index 169282b..0c93424 100644
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -39,6 +39,7 @@ static inline unsigned long long get_cpu_clock(void)
  }

  #define ARCH_CPU_CLOCK_CYCLES_PER_USEC 1
+#undef ARCH_CPU_CLOCK_WRAPS
  #define ARCH_HAVE_CPU_CLOCK

  #define ARCH_HAVE_INIT
diff --git a/gettime.c b/gettime.c
index 6863ce3..29884a1 100644
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
@@ -179,6 +182,8 @@ static void __fio_gettime(struct timeval *tp)
  		}

  		t -= cycles_start;
+#endif
+
  		tv->last_cycles = t;
  		tv->last_tv_valid = 1;
  #ifdef ARCH_CPU_CLOCK_CYCLES_PER_USEC
@@ -311,8 +316,10 @@ static int calibrate_cpu_clock(void)
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

