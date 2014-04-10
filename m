Return-Path: <fio-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:56197 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030786AbaDJNKG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Apr 2014 09:10:06 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <fio@vger.kernel.org> from <ehrhardt@linux.vnet.ibm.com>;
	Thu, 10 Apr 2014 14:10:05 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp03.portsmouth.uk.ibm.com (Postfix) with ESMTP id A4DF91B0806B
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 14:10:01 +0100 (BST)
Received: from d06av10.portsmouth.uk.ibm.com (d06av10.portsmouth.uk.ibm.com [9.149.37.251])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s3AD9vY962849224
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 13:09:57 GMT
Received: from d06av10.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av10.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s3ADA15a021341
	for <fio@vger.kernel.org>; Thu, 10 Apr 2014 07:10:01 -0600
Message-Id: <20140410131000.557506615@linux.vnet.ibm.com>
Date: Thu, 10 Apr 2014 15:09:47 +0200
From: ehrhardt@linux.vnet.ibm.com
Subject: [patch 1/1] [PATCH] fio: fix s390 timing for older machines/binutils
References: <20140410130946.570253556@linux.vnet.ibm.com>
Content-Disposition: inline; filename=fix-s390stck-for-older-systems.patch
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Older gcc/binutils or one with very low default march will refuse to use stckf.
On top of that machines older than a z196 don not even have the store clock
fast facility.

To fix all of those issues, check for the facilities in configure step and make
the usage of stckf and a matching march dependent to it.

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
---

[diffstat]
 arch/arch-s390.h |   12 ++++++++----
 configure        |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 4 deletions(-)

[diff]
--- a/arch/arch-s390.h
+++ b/arch/arch-s390.h
@@ -22,15 +22,19 @@
 #define read_barrier()	asm volatile("bcr 15,0" : : : "memory")
 #define write_barrier()	asm volatile("bcr 15,0" : : : "memory")
 
-/*
- * Fio needs monotonic (never lower), but not strict monotonic (never the same)
- * so store clock fast is enough
- */
 static inline unsigned long long get_cpu_clock(void)
 {
 	unsigned long long clk;
 
+#ifdef CONFIG_S390_Z196_FACILITIES
+	/*
+	 * Fio needs monotonic (never lower), but not strict monotonic (never
+	 * the same) so store clock fast is enough.
+	 */
 	__asm__ __volatile__("stckf %0" : "=Q" (clk) : : "cc");
+#else
+	__asm__ __volatile__("stck %0" : "=Q" (clk) : : "cc");
+#endif
 	return clk>>12;
 }
 
--- a/configure
+++ b/configure
@@ -1181,6 +1181,36 @@ if compile_prog "" "" "setvbuf"; then
 fi
 echo "setvbuf                       $setvbuf"
 
+##########################################
+# Check if we support stckf on s390
+s390_z196_facilities="no"
+cat > $TMPC << EOF
+#define STFLE_BITS_Z196 45 /* various z196 facilities ... */
+int main(int argc, char **argv)
+{
+    /* We want just 1 double word to be returned.  */
+    register unsigned long reg0 asm("0") = 0;
+    unsigned long stfle_bits;
+    asm volatile(".machine push"        "\n\t"
+                 ".machine \"z9-109\""  "\n\t"
+                 "stfle %0"             "\n\t"
+                 ".machine pop"         "\n"
+                 : "=QS" (stfle_bits), "+d" (reg0)
+                 : : "cc");
+
+    if ((stfle_bits & (1UL << (63 - STFLE_BITS_Z196))) != 0)
+      return 0;
+    else
+      return -1;
+}
+EOF
+if compile_prog "" "" "s390_z196_facilities"; then
+  $TMPE
+  if [[ $? -eq 0 ]]; then
+  	s390_z196_facilities="yes"
+  fi
+fi
+echo "s390_z196_facilities          $s390_z196_facilities"
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1311,6 +1341,10 @@ fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
+if test "$s390_z196_facilities" = "yes" ; then
+  output_sym "CONFIG_S390_Z196_FACILITIES"
+  CFLAGS="$CFLAGS -march=z9-109"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak

