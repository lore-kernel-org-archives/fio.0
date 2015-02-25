Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58318 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbbBYN5v (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 25 Feb 2015 08:57:51 -0500
Received: by mail-qa0-f49.google.com with SMTP id w8so2729860qac.8
        for <fio@vger.kernel.org>; Wed, 25 Feb 2015 05:57:50 -0800 (PST)
From: Raphael Silva <rapphil@gmail.com>
Subject: [PATCH] Add missing pre-defined ARM arch compiler macro
Date: Wed, 25 Feb 2015 10:57:40 -0300
Message-Id: <1424872660-20240-1-git-send-email-raphael.philipe@ossystems.com.br>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Raphael Silva <raphael.philipe@ossystems.com.br>

Signed-off-by: Raphael Silva <raphael.philipe@ossystems.com.br>
---
 arch/arch-arm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 7cd9502..bab886e 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -19,7 +19,8 @@
 #endif
 
 #if defined (__ARM_ARCH_4__) || defined (__ARM_ARCH_4T__) \
-	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
+	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
+	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
 	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__)
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
-- 
2.3.0

