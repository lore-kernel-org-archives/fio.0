Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.stepping-stone.ch ([194.176.109.206]:56927 "EHLO
	mail.stepping-stone.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaFZMaj (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 26 Jun 2014 08:30:39 -0400
From: =?UTF-8?q?Tiziano=20M=C3=BCller?= 
	<tiziano.mueller@stepping-stone.ch>
Subject: [PATCH] Add configure flags for gfapi and rbd
Date: Thu, 26 Jun 2014 14:20:20 +0200
Message-Id: <1403785220-30665-1-git-send-email-tiziano.mueller@stepping-stone.ch>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: =?UTF-8?q?Tiziano=20M=C3=BCller?= <tiziano.mueller@stepping-stone.ch>

Add --disable-{gfapi,rbd} to disable gfapi/rbd support even if available.
---
 configure | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 0e861ee..f1e116e 100755
--- a/configure
+++ b/configure
@@ -156,6 +156,10 @@ for opt do
   ;;
   --disable-numa) disable_numa="yes"
   ;;
+  --disable-rbd) disable_rbd="yes"
+  ;;
+  --disable-gfapi) disable_gfapi="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -1146,7 +1150,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lrbd -lrados" "rbd"; then
+if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
   LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
@@ -1183,7 +1187,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
+if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
   LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
-- 
1.9.2

