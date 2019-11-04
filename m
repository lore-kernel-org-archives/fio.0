Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49000 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfKDNAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 4 Nov 2019 08:00:07 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iRbxl-0007vm-MZ
        for fio@vger.kernel.org; Mon, 04 Nov 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191104130001.F0B522C0085@kernel.dk>
Date: Mon,  4 Nov 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f89cfed7d28f76e99ee7520d6d350b9847fab07c:

  engines/libaio.c: remove unused 'hipri' setting (2019-11-02 14:48:24 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 35e3ade0fe63f5149e07024ee31a02ac14d2dde7:

  Merge branch 'master' of https://github.com/aphreet/fio (2019-11-03 06:35:44 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'master' of https://github.com/aphreet/fio

Mikhail Malygin (1):
      Enable io_uring engine on powerpc arch

 arch/arch-ppc.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

---

Diff of recent changes:

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index 804d596a..46246bae 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -24,6 +24,18 @@
 #define PPC_CNTLZL "cntlzw"
 #endif
 
+#define ARCH_HAVE_IOURING
+
+#ifndef __NR_sys_io_uring_setup
+#define __NR_sys_io_uring_setup		425
+#endif
+#ifndef __NR_sys_io_uring_enter
+#define __NR_sys_io_uring_enter		426
+#endif
+#ifndef __NR_sys_io_uring_register
+#define __NR_sys_io_uring_register	427
+#endif
+
 static inline int __ilog2(unsigned long bitmask)
 {
 	int lz;

