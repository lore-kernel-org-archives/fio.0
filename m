Return-Path: <fio-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:48054 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726025AbfLYIqB (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 Dec 2019 03:46:01 -0500
From: "yezhenyu (A)" <yezhenyu2@huawei.com>
Subject: [PATCH] io_uring: Enable io_uring ioengine on aarch64 arch
Message-ID: <4bb14ca8-2628-0f7d-0f1e-2f1c4a5bf1a8@huawei.com>
Date: Wed, 25 Dec 2019 16:45:57 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk
Cc: fio@vger.kernel.org

This patch enabled io_uring ioengine on aarch64 arch.


Signed-off-by: Zhenyu Ye <yezhenyu2@huawei.com>
---
 arch/arch-aarch64.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 2a86cc5a..de9b349b 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -8,6 +8,18 @@

 #define FIO_ARCH       (arch_aarch64)

+#define ARCH_HAVE_IOURING
+
+#ifndef __NR_sys_io_uring_setup
+#define __NR_sys_io_uring_setup                425
+#endif
+#ifndef __NR_sys_io_uring_enter
+#define __NR_sys_io_uring_enter                426
+#endif
+#ifndef __NR_sys_io_uring_register
+#define __NR_sys_io_uring_register     427
+#endif
+
 #define nop            do { __asm__ __volatile__ ("yield"); } while (0)
 #define read_barrier() do { __sync_synchronize(); } while (0)
 #define write_barrier()        do { __sync_synchronize(); } while (0)
-- 
2.19.1



