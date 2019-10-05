Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pg1-f173.google.com ([209.85.215.173]:38023 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbfJEQXD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 5 Oct 2019 12:23:03 -0400
Received: by mail-pg1-f173.google.com with SMTP id x10so5530948pgi.5
        for <fio@vger.kernel.org>; Sat, 05 Oct 2019 09:23:02 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] arch-arm: Consider armv7ve arch as well
Date: Sat,  5 Oct 2019 09:22:54 -0700
Message-Id: <20191005162254.1339794-1-raj.khem@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 arch/arch-arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 78cb2ebe..4f722967 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -11,7 +11,7 @@
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
 #define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
-#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__)
+#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__) || defined(__ARM_ARCH_7VE__)
 #define	nop		__asm__ __volatile__ ("nop")
 #define read_barrier()	__sync_synchronize()
 #define write_barrier()	__sync_synchronize()
-- 
2.23.0


