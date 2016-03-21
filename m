Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:52343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbcCUMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 21 Mar 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1ahyVB-0004vH-En
	for fio@vger.kernel.org; Mon, 21 Mar 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160321120002.6B6192C0114@kernel.dk>
Date: Mon, 21 Mar 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 87a0ea3b58ef3d126148cb0279e015177ef9c62f:

  init: seed repeatable jobs differently (2016-03-18 09:07:16 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e91ba49acb8ff9f2e82046fec4f42b790e8644b1:

  gen-rand: fix dependency on strcasestr.o (2016-03-20 09:38:57 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      gen-rand: fix dependency on strcasestr.o

 Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index a2502dc..749a508 100644
--- a/Makefile
+++ b/Makefile
@@ -212,7 +212,8 @@ T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o t/arch.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
 T_GEN_RAND_OBJS = t/gen-rand.o
-T_GEN_RAND_OBJS += t/log.o t/debug.o lib/rand.o lib/pattern.o lib/strntol.o
+T_GEN_RAND_OBJS += t/log.o t/debug.o lib/rand.o lib/pattern.o lib/strntol.o \
+			oslib/strcasestr.o
 T_GEN_RAND_PROGS = t/gen-rand
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
