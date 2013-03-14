Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:42449 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837Ab3CNF6P (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Mar 2013 01:58:15 -0400
Received: From
	localhost.localdomain ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Thu, 14 Mar 2013 16:58:12 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 16:57:40 +1100
Subject: [PATCH 3/4] configure: endianness check for cross compile
Message-Id: <1363240661-4499-4-git-send-email-aaronc@cse.unsw.edu.au>
In-Reply-To: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
References: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

 - Add a cross compile check: assume yes if we can't run a test binary
 - If cross compiling, revert to a compile-time endianess check. This tries
   a few possible ways to detect big endian, but otherwise assumes little. We
   rely on the run-time check to save us if the build-time check is wrong.

Signed-off-by: Aaron Carroll <aaronc@cse.unsw.edu.au>
---
 configure |   40 +++++++++++++++++++++++++++++++++++++---
 1 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 84c6af2..965623d 100755
--- a/configure
+++ b/configure
@@ -323,9 +323,26 @@ fi
 cc="${CC-${cross_prefix}gcc}"
 
 ##########################################
+# check cross compile
+
+cross_compile="no"
+cat > $TMPC <<EOF
+int main(void)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "cross"; then
+  $TMPE 2>/dev/null || cross_compile="yes"
+else
+  fatal "compile test failed"
+fi
+
+##########################################
 # check endianness
 bigendian="no"
-cat > $TMPC <<EOF
+if test "$cross_compile" = "no" ; then
+  cat > $TMPC <<EOF
 #include <inttypes.h>
 int main(void)
 {
@@ -333,8 +350,24 @@ int main(void)
   return (*((uint8_t*)(&i))) == 0x67;
 }
 EOF
-if compile_prog "" "" "endian"; then
-  $TMPE && bigendian="yes"
+  if compile_prog "" "" "endian"; then
+    $TMPE && bigendian="yes"
+  fi
+else
+  # If we're cross compiling, try our best to work it out and rely on the
+  # run-time check to fail if we get it wrong.
+  cat > $TMPC <<EOF
+#include <endian.h>
+int main(void)
+{
+#if __BYTE_ORDER != __BIG_ENDIAN
+# error "Unknown endianness"
+#endif
+}
+EOF
+  compile_prog "" "" "endian" && bigendian="yes"
+  check_define "__ARMEB__" && bigendian="yes"
+  check_define "__MIPSEB__" && bigendian="yes"
 fi
 
 
@@ -342,6 +375,7 @@ echo "Operating system              $targetos"
 echo "CPU                           $cpu"
 echo "Big endian                    $bigendian"
 echo "Compiler                      $cc"
+echo "Cross compile                 $cross_compile"
 echo
 
 ##########################################
-- 
1.7.0.4

