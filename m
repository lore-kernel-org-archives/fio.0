Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54902 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbfDBMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 Apr 2019 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hBI5L-0001QA-2O
        for fio@vger.kernel.org; Tue, 02 Apr 2019 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190402120001.A25772C0163@kernel.dk>
Date: Tue,  2 Apr 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bf14b39eb98873ebd61e78d37b51233d47ed8aef:

  stat: eliminate unneeded curly braces (2019-03-25 08:23:13 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ef32da643574162c2b1aae67af38ecffb43db036:

  Merge branch 'patch-1' of https://github.com/neheb/fio (2019-04-01 06:57:22 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'patch-1' of https://github.com/neheb/fio

Rosen Penev (1):
      arch: fix build breakage on armv6 again

 arch/arch-arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index fc1c4844..78cb2ebe 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -7,7 +7,7 @@
 	|| defined (__ARM_ARCH_5__) || defined (__ARM_ARCH_5T__) || defined (__ARM_ARCH_5E__)\
 	|| defined (__ARM_ARCH_5TE__) || defined (__ARM_ARCH_5TEJ__) \
 	|| defined(__ARM_ARCH_6__)  || defined(__ARM_ARCH_6J__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6ZK__) \
-	|| defined(__ARM_ARCH_6KZ__)
+	|| defined(__ARM_ARCH_6KZ__) || defined(__ARM_ARCH_6K__)
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
 #define write_barrier()	__asm__ __volatile__ ("" : : : "memory")

