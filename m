Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49670 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730630AbfKFNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Nov 2019 08:00:05 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSKup-00076M-HH
        for fio@vger.kernel.org; Wed, 06 Nov 2019 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191106130001.847DA2C00F5@kernel.dk>
Date: Wed,  6 Nov 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 35e3ade0fe63f5149e07024ee31a02ac14d2dde7:

  Merge branch 'master' of https://github.com/aphreet/fio (2019-11-03 06:35:44 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d5c4f97458d59689c3d1a13831519617d000fb19:

  arch-arm: Consider armv7ve arch as well (2019-11-05 06:41:55 -0700)

----------------------------------------------------------------
Khem Raj (1):
      arch-arm: Consider armv7ve arch as well

 arch/arch-arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index 78cb2ebe..b3567122 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -11,7 +11,7 @@
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
 #define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
-#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__)
+#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7VE__) || defined(__ARM_ARCH_8A__)
 #define	nop		__asm__ __volatile__ ("nop")
 #define read_barrier()	__sync_synchronize()
 #define write_barrier()	__sync_synchronize()

