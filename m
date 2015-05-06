Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36731 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbbEFMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 6 May 2015 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Ypxze-0002lT-If
	for fio@vger.kernel.org; Wed, 06 May 2015 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150506120001.DB1012C1077@kernel.dk>
Date: Wed,  6 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 95603b7470fac1917cb11bc686e60b4339f8a2fc:

  Fix Runtime, IOPS, bandwidth recorded incorrectly (2015-05-04 16:07:10 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 83b2850d223f2bb91783ac5a0fa657ea60d1eff7:

  libmtd: ->name and ->type_str can't be constant (2015-05-05 12:11:55 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      libmtd: ->name and ->type_str can't be constant

Milton Chiang (1):
      ARM: Use generic assembly nop and barrier code for armv8-a

 arch/arch-arm.h | 2 +-
 lib/libmtd.h    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-arm.h b/arch/arch-arm.h
index bab886e..93268d2 100644
--- a/arch/arch-arm.h
+++ b/arch/arch-arm.h
@@ -25,7 +25,7 @@
 #define nop             __asm__ __volatile__("mov\tr0,r0\t@ nop\n\t")
 #define read_barrier()	__asm__ __volatile__ ("" : : : "memory")
 #define write_barrier()	__asm__ __volatile__ ("" : : : "memory")
-#elif defined(__ARM_ARCH_7A__)
+#elif defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_8A__)
 #define	nop		__asm__ __volatile__ ("nop")
 #define read_barrier()	__sync_synchronize()
 #define write_barrier()	__sync_synchronize()
diff --git a/lib/libmtd.h b/lib/libmtd.h
index 33adc14..3625de5 100644
--- a/lib/libmtd.h
+++ b/lib/libmtd.h
@@ -78,8 +78,8 @@ struct mtd_dev_info
 	int major;
 	int minor;
 	int type;
-	const char type_str[MTD_TYPE_MAX + 1];
-	const char name[MTD_NAME_MAX + 1];
+	char type_str[MTD_TYPE_MAX + 1];
+	char name[MTD_NAME_MAX + 1];
 	long long size;
 	int eb_cnt;
 	int eb_size;
