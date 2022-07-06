Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC9CC43334
	for <fio@archiver.kernel.org>; Wed,  6 Jul 2022 12:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiGFMAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Jul 2022 08:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiGFMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Jul 2022 08:00:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B321EC56
        for <fio@vger.kernel.org>; Wed,  6 Jul 2022 05:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=LFHc7FFwMyGoX4vv0bkBeaTQa9HeKccAmBBcpMUmdCs=; b=G5v+LDbL5MVMi4ZDyr4vMUregt
        DrdSIqxcrw2AbNLeb6/SU8MbN3bWwUQltJlUjxiAL9sNKpvYtZLiBQTVEtQ2ZXp3tgRpOeLPflGGu
        BTCnhMSO3Z4R0QvsFfU+4ydqQdKaOA7w7AF1MiYHEwX8VX7vIVNnk/2XxXF2StOcBkWj//Dp+AVES
        ML79vo6Pb7tG9pwnz4TpUp8jGLplZ9nki/RItOVxv1pwYTK1TC/gq2OGD2ymcsXM1nRc3Ro6ZWp40
        U2Dy+ur9TJbgDKkwPULu2x5A6jYxpt7DEW7kyLOUvf5NpI/a52ZwgUOts7H7Ll4kURI/1VdXZhOoK
        Lp03VgDA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o93hL-001cnl-Vu
        for fio@vger.kernel.org; Wed, 06 Jul 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id EF1F71BC0157; Wed,  6 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220706120001.EF1F71BC0157@kernel.dk>
Date:   Wed,  6 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit dc4729e3ef6a9116d7cd30e96e4f5863883e5bd7:

  hash: cleanups (2022-07-01 15:03:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1eb5ca76ee17ff80dd06a0c2d22498ab720ec76f:

  configure: revert NFS configure change (2022-07-05 07:19:39 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      configure: revert NFS configure change

 configure | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 04a1d0e2..7965f0b0 100755
--- a/configure
+++ b/configure
@@ -245,7 +245,7 @@ for opt do
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
-  --disable-nfs) disable_nfs="yes"
+  --enable-libnfs) libnfs="yes"
   ;;
   --dynamic-libengines) dynamic_engines="yes"
   ;;
@@ -279,7 +279,6 @@ if test "$show_help" = "yes" ; then
   echo "--disable-rados         Disable Rados support even if found"
   echo "--disable-rbd           Disable Rados Block Device even if found"
   echo "--disable-http          Disable HTTP support even if found"
-  echo "--disable-nfs           Disable userspace NFS support even if found"
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
   echo "--enable-libnfs         Enable nfs support"
@@ -2314,15 +2313,17 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 
 ##########################################
 # Check if we have libnfs (for userspace nfs support).
-if test "$disable_nfs" != "yes"; then
+if test "$libnfs" = "yes" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
     libnfs_cflags=$(pkg-config --cflags libnfs)
-    libnfs_libs=$(pkg-config --libs libnfs)
+    # libnfs_libs=$(pkg-config --libs libnfs)
+    libnfs_libs=/usr/local/lib/libnfs.a
   else
     if test "$libnfs" = "yes" ; then
       echo "libnfs" "Install libnfs"
     fi
+    libnfs="no"
   fi
 fi
 print_config "NFS engine" "$libnfs"
