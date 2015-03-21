Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbbCUMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 21 Mar 2015 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YZI4U-0006z2-8u
	for fio@vger.kernel.org; Sat, 21 Mar 2015 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150321120003.48EB440191@lyth.info>
Date: Sat, 21 Mar 2015 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6fb1bda0d0b61e2433f9ef34b4b979b2642d8706:

  io_u_queue: add debug assert check on adding too many elements (2015-03-19 22:25:35 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dac499a01d1958781e526df982d78d733f19c527:

  Cpu clock does not wrap if there is no CPU clock (2015-03-20 10:29:29 -0600)

----------------------------------------------------------------
Akash Verma (1):
      Cpu clock does not wrap if there is no CPU clock

 gettime.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index d1c8eb9..180aa5f 100644
--- a/gettime.c
+++ b/gettime.c
@@ -13,7 +13,8 @@
 #include "hash.h"
 #include "os/os.h"
 
-#if defined(ARCH_HAVE_CPU_CLOCK) && !defined(ARCH_CPU_CLOCK_CYCLES_PER_USEC)
+#if defined(ARCH_HAVE_CPU_CLOCK)
+#ifndef ARCH_CPU_CLOCK_CYCLES_PER_USEC
 static unsigned long cycles_per_usec;
 static unsigned long inv_cycles_per_usec;
 static uint64_t max_cycles_for_mult;
@@ -21,6 +22,7 @@ static uint64_t max_cycles_for_mult;
 #ifdef ARCH_CPU_CLOCK_WRAPS
 static unsigned long long cycles_start, cycles_wrap;
 #endif
+#endif
 int tsc_reliable = 0;
 
 struct tv_valid {
