Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:49956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfLZNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 26 Dec 2019 08:00:09 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ikSkK-000669-Mz
        for fio@vger.kernel.org; Thu, 26 Dec 2019 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191226130001.83A211BC016D@kernel.dk>
Date: Thu, 26 Dec 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b10b1e70afaff8c9b00005e9238f2ad347a9c00a:

  io_uring: add option for non-vectored read/write commands (2019-12-23 08:54:25 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to aae515f4e1cb0b3c003e127200d344d807032a79:

  io_uring: Enable io_uring ioengine on aarch64 arch (2019-12-25 08:02:57 -0700)

----------------------------------------------------------------
Zhenyu Ye (1):
      io_uring: Enable io_uring ioengine on aarch64 arch

 arch/arch-aarch64.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

---

Diff of recent changes:

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 2a86cc5a..de9b349b 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -8,6 +8,18 @@
 
 #define FIO_ARCH	(arch_aarch64)
 
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
 #define nop		do { __asm__ __volatile__ ("yield"); } while (0)
 #define read_barrier()	do { __sync_synchronize(); } while (0)
 #define write_barrier()	do { __sync_synchronize(); } while (0)

