Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:42448 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753399Ab3CNF6P (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Mar 2013 01:58:15 -0400
Received: From
	localhost.localdomain ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Thu, 14 Mar 2013 16:58:12 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Thu, 14 Mar 2013 16:57:39 +1100
Subject: [PATCH 2/4] configure: compile-time word size detection
Message-Id: <1363240661-4499-3-git-send-email-aaronc@cse.unsw.edu.au>
In-Reply-To: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
References: <1363240661-4499-1-git-send-email-aaronc@cse.unsw.edu.au>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Signed-off-by: Aaron Carroll <aaronc@cse.unsw.edu.au>
---
 configure |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 1fa9b63..84c6af2 100755
--- a/configure
+++ b/configure
@@ -348,16 +348,20 @@ echo
 # check for wordsize
 wordsize="0"
 cat > $TMPC <<EOF
-#include <stdio.h>
+#include <limits.h>
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 int main(void)
 {
-  unsigned int wsize = sizeof(long) * 8;
-  printf("%d\n", wsize);
+  BUILD_BUG_ON(sizeof(long)*CHAR_BIT != WORDSIZE);
   return 0;
 }
 EOF
-if compile_prog "" "" "wordsize"; then
-  wordsize=`$TMPE`
+if compile_prog "-DWORDSIZE=32" "" "wordsize"; then
+  wordsize="32"
+elif compile_prog "-DWORDSIZE=64" "" "wordsize"; then
+  wordsize="64"
+else
+  fatal "Unknown wordsize"
 fi
 echo "Wordsize                      $wordsize"
 
-- 
1.7.0.4

