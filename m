Return-Path: <fio-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:43104 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0CUQTE convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 21 Mar 2010 12:19:04 -0400
Received: from [10.0.0.98] (ip-216-46-71-107.nyc.megapath.net [216.46.71.107])
	(user=dga2 mech=PLAIN (0 bits))
	by smtp.andrew.cmu.edu (8.14.3/8.14.3) with ESMTP id o2LGJ0x0022904
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Sun, 21 Mar 2010 12:19:01 -0400
From: David Andersen <dga@cs.cmu.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: in-progress patch for forcing incremental TSC updates
Date: Sun, 21 Mar 2010 12:18:59 -0400
Message-Id: <E947AD6A-030E-4625-AB78-FCA2F0CFE9FF@cs.cmu.edu>
Mime-Version: 1.0 (Apple Message framework v1077)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This isn't a fully integrated patch -- I apologize, but wanted to send it across and see if it was worth polishing further.  The rationale for this patch, on a single-core Atom processor with an Intel x25-m attached:

Mode         FIO IOPS
normal       29337
gtod_reduce  34186
FORCE_TSC    32351  <- this patch

vs the current git version.  The patch works by every 10ms calling a "real" gettime function, calculating the TSC clock rate during that period, and using the measured TSC clocks per microsecond to estimate the results for the next 10ms worth of gettime calls.

* Advantage:  Works decently even with a non-constant-rate TSC, as long as the frequency doesn't change too often.
* Disadvantage:  A context switch at the wrong time can slightly throw off the calibration, resulting in incremental timestamp values that are off by a few microseconds.

The patch isn't fully integrated into fio - I left a hook for a configuration variable to enable or disable it, but didn't yet add that into the config parser, etc.  And I've only tested it on Linux with glibc.  But if this seems useful to other people, I'm happy to clean it up a bit further.

To use the patch, compile with -DFORCE_TSC.  Patch adds file tsc.h, stolen from glibc.  If the patches don't come through properly on the mailing list, they can be grabbed at:
http://www.cs.cmu.edu/~dga/tsc.h
http://www.cs.cmu.edu/~gettime.patch

tsc.h:
----------------
/* TSC access for a few platforms, yoinked from glibc NPTL -- GPL'd. */

#ifdef i386
#define HP_TIMING_NOW(Var)      __asm__ __volatile__ ("rdtsc" : "=A" (Var))
#elif defined __x86_64__
# define HP_TIMING_NOW(Var) \
  ({ unsigned int _hi, _lo; \
  asm volatile ("rdtsc" : "=a" (_lo), "=d" (_hi)); \
  (Var) = ((unsigned long long int) _hi << 32) | _lo; })
#elif defined __ia64__
#define HP_TIMING_NOW(Var)      __asm__ __volatile__ ("mov %0=ar.itc" : "=r" (Var) : : "memory")
#else
#error "HP_TIMING_NOW missing"
#endif
----------------
gettime.c diff:

diff --git a/gettime.c b/gettime.c
index 8ec70b9..1e49df6 100644
--- a/gettime.c
+++ b/gettime.c
@@ -18,6 +18,14 @@ static struct timeval *fio_tv;
 int fio_gtod_offload = 0;
 int fio_gtod_cpu = -1;
 
+int tsc_incremental_update = 1; /* XXX, move to config */
+#ifdef FORCE_TSC
+static uint64_t ref_tsc = 0;
+static uint32_t tsc_cycles_per_micro = 0;
+static uint32_t tsc_increment_max = 0;
+#include "tsc.h"
+#endif
+
 #ifdef FIO_DEBUG_TIME
 
 #define HASH_BITS      8
@@ -109,6 +117,71 @@ static void fio_init gtod_init(void)
 
 #endif /* FIO_DEBUG_TIME */
 
+/* Returns 0 if it couldn't incrementally update, 1 if successful */
+#define UPDATE_NOT_NEEDED 0
+#define UPDATE_NEEDED 1
+
+#ifdef FORCE_TSC
+int tsc_incremental(struct timeval *tp) {
+       uint64_t new_tsc;
+       HP_TIMING_NOW(new_tsc);
+       /* Case 1:  We've never been called before */
+       if (!ref_tsc) { 
+               ref_tsc = new_tsc;
+               return UPDATE_NEEDED;
+       }
+       /* Case 2:  We've been called exactly once, but haven't figured out 
+        * the operating frequency.  We know that last_tv and ref_tsc are valid.
+        */
+       if (!tsc_cycles_per_micro || (new_tsc - ref_tsc) > tsc_increment_max) {
+               /* If the CPU has constant_tsc, you can avoid this.
+                * see glibc get_cpufreq().  Danger of this approach:
+                * It can be wrong if we get delayed between the rdtsc
+                * call and the gettimeofday call.  We potentially can
+                * be wrong if we mix and match results from
+                * gettimeofday and the clock_gettime if they use
+                * different clock sources.  In practice, it works
+                * pretty well, and is a lot cheaper than parsing the
+                * CPU frequency out of /proc. 
+                */
+               struct timeval tv_now;
+               gettimeofday(&tv_now, NULL);
+               int64_t micros_delta = 0;
+               micros_delta = (tv_now.tv_sec - last_tv.tv_sec) * 1000000;
+               micros_delta += (tv_now.tv_usec - last_tv.tv_usec);
+               int64_t cycles_delta = new_tsc - ref_tsc;
+               if (micros_delta > 0 && cycles_delta > 0) {
+                       tsc_cycles_per_micro = (cycles_delta / micros_delta);
+                       tsc_increment_max = tsc_cycles_per_micro * 10000; /* 10ms */
+                       ref_tsc = new_tsc;
+                       memcpy(tp, &tv_now, sizeof(tv_now));
+                       memcpy(&last_tv, &tv_now, sizeof(tv_now));
+                       return UPDATE_NOT_NEEDED;
+               } else {
+                       //fprintf(stderr, "No micros.  So sad.\n");
+                       /* Time went backwards... fallthrough and try again next time. */
+                       return UPDATE_NEEDED;
+               }
+       }
+       /* Case 3:  Normal operation, update based on TSC cycles */
+       int64_t tsc_delta = (new_tsc - ref_tsc);
+       if (tsc_delta < 0) {
+               /* When time goes backwards, punt to something trusted */
+               return UPDATE_NEEDED;
+       }
+       /* Note:  Not compat with the fio_tv method... */
+       uint32_t micro_delta = tsc_delta / tsc_cycles_per_micro;
+       tp->tv_sec = last_tv.tv_sec;
+       tp->tv_usec = last_tv.tv_usec + micro_delta;
+       while (tp->tv_usec > 1000000) {
+               tp->tv_usec -= 1000000;
+               tp->tv_sec += 1;
+       }
+       return UPDATE_NOT_NEEDED;
+}
+#endif
+
+
 #ifdef FIO_DEBUG_TIME
 void fio_gettime(struct timeval *tp, void *caller)
 #else
@@ -121,6 +194,14 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 
        gtod_log_caller(caller);
 #endif
+
+#ifdef FORCE_TSC
+       if (tsc_incremental_update && tsc_incremental(tp) == UPDATE_NOT_NEEDED) {
+               return;
+       }
+#endif
+
+
        if (fio_tv) {
                memcpy(tp, fio_tv, sizeof(*tp));
                return;


