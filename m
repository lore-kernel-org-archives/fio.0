Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f179.google.com ([209.85.216.179]:35066 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbbCSX1J (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Mar 2015 19:27:09 -0400
Received: by qcbkw5 with SMTP id kw5so80721790qcb.2
        for <fio@vger.kernel.org>; Thu, 19 Mar 2015 16:27:08 -0700 (PDT)
MIME-Version: 1.0
From: Akash Verma <akashv@google.com>
Date: Thu, 19 Mar 2015 16:26:48 -0700
Message-ID: <CAFFT=UnkLWJ2GjDMBg8ZvuFN05us8QbYLZHpn1BzWDaAjFob3w@mail.gmail.com>
Subject: [PATCH] In gettime.c, check for ARCH_CPU_CLOCK_WRAPS only ifdef ARCH_HAVE_CPU_CLOCK
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

This causes compiler warnings because of unused variables cycles_start
and cycles_wrap.

From 8dce1512a5adf39f30643085b11a0b94cecf6157 Mon Sep 17 00:00:00 2001
From: Akash Verma <akashv@google.com>
Date: Thu, 19 Mar 2015 16:19:25 -0700
Subject: [PATCH] Cpu clock does not wrap if there is no CPU clock

---
 gettime.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

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
-- 
2.2.0.rc0.207.ga3a616c
