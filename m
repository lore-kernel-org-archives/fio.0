Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45325 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbaFPFi3 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 16 Jun 2014 01:38:29 -0400
Received: by mail-pd0-f181.google.com with SMTP id v10so3156537pde.12
        for <fio@vger.kernel.org>; Sun, 15 Jun 2014 22:38:28 -0700 (PDT)
From: Sumanth K <linuxuser1990@gmail.com>
Subject: [PATCH] fio: Eliminate compilation warning in ppc
Date: Mon, 16 Jun 2014 11:08:16 +0530
Message-Id: <1402897096-10997-1-git-send-email-linuxuser1990@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Sumanth K <sumantk2@linux.vnet.ibm.com>

From: Sumanth K <sumantk2@linux.vnet.ibm.com>

Eliminate compilation warning : 'atb_clocktest' defined but
not used. Function is declared as static in header file. So compiler will
know if they used or not. Just eliminate the warning by #if 0 /unless we do
use it.

Signed-off-by: Sumanth K <sumantk2@linux.vnet.ibm.com>
---
 arch/arch-ppc.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 0f043bc..d4a080c 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -82,6 +82,7 @@ static inline unsigned long long get_cpu_clock(void)
 	return ret;
 }
 
+#if 0
 static void atb_child(void)
 {
 	arch_flags |= ARCH_FLAG_1;
@@ -106,6 +107,7 @@ static void atb_clocktest(void)
 			arch_flags |= ARCH_FLAG_1;
 	}
 }
+#endif
 
 #define ARCH_HAVE_INIT
 extern int tsc_reliable;
-- 
1.8.3.1

