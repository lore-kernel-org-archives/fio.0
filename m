Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35350 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752208AbdCAFkR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Mar 2017 00:40:17 -0500
Received: from localhost.localdomain (localhost [127.0.0.1])
        by smtp.gentoo.org (Postfix) with ESMTP id 356BB33BF43
        for <fio@vger.kernel.org>; Wed,  1 Mar 2017 05:31:02 +0000 (UTC)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] configure: add a --disable-rdma flag to control rdma deps
Date: Tue, 28 Feb 2017 22:30:58 -0700
Message-Id: <20170301053058.9758-1-vapier@gentoo.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 configure | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 15b87fac0e4c..187ac3583805 100755
--- a/configure
+++ b/configure
@@ -166,6 +166,8 @@ for opt do
   ;;
   --disable-numa) disable_numa="yes"
   ;;
+  --disable-rdma) disable_rdma="yes"
+  ;;
   --disable-rbd) disable_rbd="yes"
   ;;
   --disable-rbd-blkin) disable_rbd_blkin="yes"
@@ -204,6 +206,7 @@ if test "$show_help" = "yes" ; then
   echo "--esx                  Configure build options for esx"
   echo "--enable-gfio          Enable building of gtk gfio"
   echo "--disable-numa         Disable libnuma even if found"
+  echo "--disable-rdma         Disable RDMA support even if found"
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
   echo "--disable-lex          Disable use of lex/yacc for math"
@@ -642,7 +645,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-libverbs" "libverbs" ; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
     libverbs="yes"
     LIBS="-libverbs $LIBS"
 fi
@@ -660,7 +663,7 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if compile_prog "" "-lrdmacm" "rdma"; then
+if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
     LIBS="-lrdmacm $LIBS"
 fi
-- 
2.11.1

