Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0169C433EF
	for <fio@archiver.kernel.org>; Sat, 23 Jul 2022 12:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiGWMAK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 23 Jul 2022 08:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGWMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 23 Jul 2022 08:00:09 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43495CF
        for <fio@vger.kernel.org>; Sat, 23 Jul 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=YLaMUKC6vPPl3rGcFIVxPYyQTb2j2yydyhtCmzyEjVo=; b=o+lw/Xox0YI8dSeFyFKdxgUM1X
        c1bPp9ljpPNnGyemfwmFfD1X4UUbi6CglEhfwD54vvnV0mjNt0ky7EmodYfu73TAfYAHCfx9thhEE
        cltJ3D3zYCHfL4VTxtNCdKjk+hXg2KZuDTmtbedXZzNEDJn0hPjV0T+8/RTP/j2s8cSWGBx5Qo1du
        tjB2BV4FGvZ1LiRPOqmgnRGrOLnfHlakSb2zsYsJzcgronWS/cbIyIyPNzj5tLKpMB19jhzL7J8nn
        0DpyRiR1OpjUU0+ZnjzjzEG2GnNoxWz8smc4wmrhrG0ayKTTkrozDtEwG2yPq0oD+wPerV54Me3wD
        ARve2oAw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oFDnf-0067fU-Sq
        for fio@vger.kernel.org; Sat, 23 Jul 2022 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 779E51BC0175; Sat, 23 Jul 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220723120001.779E51BC0175@kernel.dk>
Date:   Sat, 23 Jul 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 02a36caa69f5675f7144fbeddb7a32e1d35ce0c7:

  docs: clarify write_iolog description (2022-07-21 15:18:18 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dff32ddb97f2257975b6047474d665a5de7f7bbc:

  ci: install libnfs for linux and macos builds (2022-07-22 15:57:27 -0400)

----------------------------------------------------------------
Vincent Fu (3):
      configure: cleanups for nfs ioengine
      engines/nfs: remove commit hook
      ci: install libnfs for linux and macos builds

 ci/actions-install.sh |  3 ++-
 configure             | 16 +++++++---------
 engines/nfs.c         |  9 ---------
 options.c             |  2 +-
 4 files changed, 10 insertions(+), 20 deletions(-)

---

Diff of recent changes:

diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index ff514926..b5c4198f 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -26,6 +26,7 @@ DPKGCFG
         libibverbs-dev
         libnuma-dev
         librdmacm-dev
+	libnfs-dev
         valgrind
     )
     case "${CI_TARGET_ARCH}" in
@@ -78,7 +79,7 @@ install_macos() {
     #echo "Updating homebrew..."
     #brew update >/dev/null 2>&1
     echo "Installing packages..."
-    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit
+    HOMEBREW_NO_AUTO_UPDATE=1 brew install cunit libnfs
     pip3 install scipy six sphinx
 }
 
diff --git a/configure b/configure
index 7965f0b0..36450df8 100755
--- a/configure
+++ b/configure
@@ -170,7 +170,7 @@ disable_native="no"
 march_set="no"
 libiscsi="no"
 libnbd="no"
-libnfs="no"
+libnfs=""
 xnvme=""
 libzbc=""
 dfs=""
@@ -245,6 +245,8 @@ for opt do
   ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
+  --disable-libnfs) libnfs="no"
+  ;;
   --enable-libnfs) libnfs="yes"
   ;;
   --dynamic-libengines) dynamic_engines="yes"
@@ -282,6 +284,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-gfapi         Disable gfapi"
   echo "--enable-libhdfs        Enable hdfs support"
   echo "--enable-libnfs         Enable nfs support"
+  echo "--disable-libnfs        Disable nfs support"
   echo "--disable-lex           Disable use of lex/yacc for math"
   echo "--disable-pmem          Disable pmem based engines even if found"
   echo "--enable-lex            Enable use of lex/yacc for math"
@@ -2313,15 +2316,14 @@ print_config "DAOS File System (dfs) Engine" "$dfs"
 
 ##########################################
 # Check if we have libnfs (for userspace nfs support).
-if test "$libnfs" = "yes" ; then
+if test "$libnfs" != "no" ; then
   if $(pkg-config libnfs > /dev/null 2>&1); then
     libnfs="yes"
     libnfs_cflags=$(pkg-config --cflags libnfs)
-    # libnfs_libs=$(pkg-config --libs libnfs)
-    libnfs_libs=/usr/local/lib/libnfs.a
+    libnfs_libs=$(pkg-config --libs libnfs)
   else
     if test "$libnfs" = "yes" ; then
-      echo "libnfs" "Install libnfs"
+      feature_not_found "libnfs" "libnfs"
     fi
     libnfs="no"
   fi
@@ -3190,9 +3192,6 @@ fi
 if test "$dfs" = "yes" ; then
   output_sym "CONFIG_DFS"
 fi
-if test "$libnfs" = "yes" ; then
-  output_sym "CONFIG_NFS"
-fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
@@ -3234,7 +3233,6 @@ if test "$libnbd" = "yes" ; then
 fi
 if test "$libnfs" = "yes" ; then
   output_sym "CONFIG_LIBNFS"
-  echo "CONFIG_LIBNFS=m" >> $config_host_mak
   echo "LIBNFS_CFLAGS=$libnfs_cflags" >> $config_host_mak
   echo "LIBNFS_LIBS=$libnfs_libs" >> $config_host_mak
 fi
diff --git a/engines/nfs.c b/engines/nfs.c
index 21be8833..7031769d 100644
--- a/engines/nfs.c
+++ b/engines/nfs.c
@@ -279,14 +279,6 @@ static int fio_libnfs_close(struct thread_data *td, struct fio_file *f)
 	return ret;
 }
 
-/*
- * Hook for writing out outstanding data.
- */
-static int fio_libnfs_commit(struct thread_data *td) {
-	nfs_event_loop(td, true);
-	return 0;
-}
-
 struct ioengine_ops ioengine = {
 	.name		= "nfs",
 	.version	= FIO_IOOPS_VERSION,
@@ -297,7 +289,6 @@ struct ioengine_ops ioengine = {
 	.cleanup	= fio_libnfs_cleanup,
 	.open_file	= fio_libnfs_open,
 	.close_file	= fio_libnfs_close,
-	.commit     = fio_libnfs_commit,
 	.flags      = FIO_DISKLESSIO | FIO_NOEXTEND | FIO_NODISKUTIL,
 	.options	= options,
 	.option_struct_size	= sizeof(struct fio_libnfs_options),
diff --git a/options.c b/options.c
index 2b183c60..5d3daedf 100644
--- a/options.c
+++ b/options.c
@@ -2140,7 +2140,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .help = "DAOS File System (dfs) IO engine",
 			  },
 #endif
-#ifdef CONFIG_NFS
+#ifdef CONFIG_LIBNFS
 			  { .ival = "nfs",
 			    .help = "NFS IO engine",
 			  },
