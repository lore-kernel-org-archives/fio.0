Return-Path: <rebecca@bluestop.org>
From: Rebecca Cran <rebecca@bluestop.org>
Subject: [PATCH] Add support for the CPU clock (System Timer) on Aarch64.
Date: Wed,  1 Mar 2017 21:43:11 +0000
Message-Id: <1488404591-9441-1-git-send-email-rebecca@bluestop.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: Rebecca Cran <rebecca@bluestop.org>
List-ID: <fio@vger.kernel.org>

---
 arch/arch-aarch64.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arch-aarch64.h b/arch/arch-aarch64.h
index 0912a86..3b6082e 100644
--- a/arch/arch-aarch64.h
+++ b/arch/arch-aarch64.h
@@ -25,7 +25,16 @@ static inline int arch_ffz(unsigned long bitmask)
 	return count;
 }
 
+static inline unsigned long long get_cpu_clock(void)
+{
+        unsigned long long ret;
+
+	__asm__ __volatile__("mrs %0, cntvct_el0" : "=r" (ret));
+        return ret;
+}
+
 #define ARCH_HAVE_FFZ
+#define ARCH_HAVE_CPU_CLOCK
 
 #ifdef ARCH_HAVE_CRC_CRYPTO
 #define ARCH_HAVE_ARM64_CRC_CRYPTO
-- 
2.1.4


