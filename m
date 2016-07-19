Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 6/7] Change ARCH_X86_64_h to ARCH_X86_64_H
Date: Wed, 20 Jul 2016 01:33:46 +0900
Message-Id: <1468946027-22580-6-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 arch/arch-x86_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 21da412..a0e8c03 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -1,5 +1,5 @@
-#ifndef ARCH_X86_64_h
-#define ARCH_X86_64_h
+#ifndef ARCH_X86_64_H
+#define ARCH_X86_64_H
 
 static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 			    unsigned int *ecx, unsigned int *edx)
-- 
2.5.5


