Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:54788 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3LTHBA (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Dec 2013 02:01:00 -0500
Received: by mail-pa0-f67.google.com with SMTP id rd3so1059053pab.2
        for <fio@vger.kernel.org>; Thu, 19 Dec 2013 23:00:59 -0800 (PST)
From: castor.fu@egocast.org
Subject: [PATCH] Make configure tests pass pickier compiler options.
Date: Thu, 19 Dec 2013 23:00:46 -0800
Message-Id: <1387522846-37435-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>

From: Castor Fu <castor@alumni.caltech.edu>

Signed-off-by: Castor Fu <castor@alumni.caltech.edu>
---
 configure | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index 0f1acd0..2dda142 100755
--- a/configure
+++ b/configure
@@ -571,6 +571,7 @@ echo "rdmacm                        $rdmacm"
 linux_fallocate="no"
 cat > $TMPC << EOF
 #include <stdio.h>
+#include <fcntl.h>
 #include <linux/falloc.h>
 int main(int argc, char **argv)
 {
@@ -887,8 +888,7 @@ cat > $TMPC << EOF
 #include <string.h>
 int main(int argc, char **argv)
 {
-  strcasestr(NULL, NULL);
-  return 0;
+  return strcasestr(argv[0], argv[1]) != NULL;
 }
 EOF
 if compile_prog "" "" "strcasestr"; then
@@ -902,6 +902,7 @@ getopt_long_only="no"
 cat > $TMPC << EOF
 #include <unistd.h>
 #include <stdio.h>
+#include <getopt.h>
 int main(int argc, char **argv)
 {
   int c = getopt_long_only(argc, argv, NULL, NULL, NULL);
@@ -952,7 +953,7 @@ echo "socklen_t                     $socklen_t"
 tls_thread="no"
 cat > $TMPC << EOF
 #include <stdio.h>
-static int __thread ret;
+static __thread int ret;
 int main(int argc, char **argv)
 {
   return ret;
-- 
1.7.11.5

