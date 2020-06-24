Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390682AbgFXMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Jun 2020 08:00:21 -0400
Received: from casper.infradead.org (unknown [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF8DC061573
        for <fio@vger.kernel.org>; Wed, 24 Jun 2020 05:00:20 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jo44S-0002Bo-F0
        for fio@vger.kernel.org; Wed, 24 Jun 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200624120002.1992A1BC0177@kernel.dk>
Date: Wed, 24 Jun 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 653241de1eb5b9abe21cb6feb036df202d388c68:

  Merge branch 'atomics' of https://github.com/bvanassche/fio (2020-06-21 20:48:05 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c7f72c4bdb3586025cc7c5da707e69cc7a1baf07:

  Merge branch 'master' of https://github.com/safl/fio (2020-06-23 12:41:35 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      compiler/compiler.h: minimum GCC version is 4.9
      oslib/linux-blkzoned: fix bogus poiter alignment warning
      compiler/compiler.h: include clang 6.0 and above
      Merge branch 'master' of https://github.com/safl/fio

Simon A. F. Lund (1):
      Changed signedness of seqlock.sequence fixing comparison-warning

 compiler/compiler.h    | 4 ++--
 lib/seqlock.h          | 2 +-
 oslib/linux-blkzoned.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index ddfbcc12..8eba2929 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -2,10 +2,10 @@
 #define FIO_COMPILER_H
 
 /* IWYU pragma: begin_exports */
-#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 1)
+#if __GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 9) || __clang_major__ >= 6
 #include "compiler-gcc4.h"
 #else
-#error Compiler too old, need at least gcc 4.1.0
+#error Compiler too old, need at least gcc 4.9
 #endif
 /* IWYU pragma: end_exports */
 
diff --git a/lib/seqlock.h b/lib/seqlock.h
index afa9fd31..56f3e37d 100644
--- a/lib/seqlock.h
+++ b/lib/seqlock.h
@@ -5,7 +5,7 @@
 #include "../arch/arch.h"
 
 struct seqlock {
-	volatile int sequence;
+	volatile unsigned int sequence;
 };
 
 static inline void seqlock_init(struct seqlock *s)
diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 61ea3a53..1cf06363 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -143,7 +143,7 @@ int blkzoned_report_zones(struct thread_data *td, struct fio_file *f,
 	}
 
 	nr_zones = hdr->nr_zones;
-	blkz = &hdr->zones[0];
+	blkz = (void *) hdr + sizeof(*hdr);
 	z = &zones[0];
 	for (i = 0; i < nr_zones; i++, z++, blkz++) {
 		z->start = blkz->start << 9;

