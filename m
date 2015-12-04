Return-Path: <zhong@linux.vnet.ibm.com>
Message-ID: <1449208206.30683.9.camel@TP420>
Subject: [RFC PATCH] powerpc: enable cpu clock for powerpc64
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Fri, 04 Dec 2015 13:50:06 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, zhong@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

This patch tries to enable cpu clock for powerpc64, the code is copied from 
mftb() in kernel source.

The two instructions after mfspr are added in the kernel to solve an erratum on 
Cell and fsl booke CPUs. On those CPUs, 64 bits mftb is not atomic, so it is 
possible that the low order 32 bits are already reset to 0x00000000 but the
high order bits are not yet incremented by one. 

Don't know how to tell whether it will be running on those CPUs or not, I just
keep the above fix for all ppc64 CPUs. Even if we have some method to check
whether we are on those CPUs or not at run time, I think the check won't cost
less than the two added instructions. Maybe we could use the similar fix up 
code kernel uses to dynamically patch the instructions with nops if not needed.
But that would add much more complexity. 

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 arch/arch-ppc.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index aed41f9..161c39c 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -67,6 +67,21 @@ static inline unsigned int mfspr(unsigned int reg)
 #define SPRN_ATBL  0x20E /* Alternate Time Base Lower */
 #define SPRN_ATBU  0x20F /* Alternate Time Base Upper */
 
+#ifdef __powerpc64__
+static inline unsigned long long get_cpu_clock(void)
+{
+	unsigned long long rval;
+
+	asm volatile(
+		"90:	mfspr %0, %1;\n"
+		"	cmpwi %0,0;\n"
+		"	beq-  90b;\n"
+	: "=r" (rval)
+	: "i" (SPRN_TBRL));
+
+	return rval;
+}
+#else
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned int tbl, tbu0, tbu1;
@@ -87,6 +102,7 @@ static inline unsigned long long get_cpu_clock(void)
 	ret = (((unsigned long long)tbu0) << 32) | tbl;
 	return ret;
 }
+#endif
 
 #if 0
 static void atb_child(void)
@@ -136,4 +152,12 @@ static inline int arch_init(char *envp[])
  * #define ARCH_HAVE_CPU_CLOCK
  */
 
+/*
+ * Let's have it defined for ppc64
+ */
+
+#ifdef __powerpc64__
+#define ARCH_HAVE_CPU_CLOCK
+#endif
+
 #endif



