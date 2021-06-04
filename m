Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhFDMCF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Jun 2021 08:02:05 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369CEC06174A
        for <fio@vger.kernel.org>; Fri,  4 Jun 2021 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lp8UZ-003QcF-KJ
        for fio@vger.kernel.org; Fri, 04 Jun 2021 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210604120002.3925C1BC016C@kernel.dk>
Date: Fri,  4 Jun 2021 06:00:02 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 575686bb85fa36f326524c505e83c54abc0d2f2b:

  zbd: add a new --ignore_zone_limits option (2021-05-27 16:04:58 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d7a28031718d281f1b9ea593c8a3f395761510ca:

  Merge branch 'fix/928' of https://github.com/larsks/fio (2021-06-03 09:01:52 -0600)

----------------------------------------------------------------
Erwan Velu (3):
      ci: Installing missing toolchain
      ci: Reporting installed msys2 packages
      Makefile: Avoid using built-in stpcpy during clang build

Jens Axboe (2):
      Merge branch 'evelu-test' of https://github.com/ErwanAliasr1/fio
      Merge branch 'fix/928' of https://github.com/larsks/fio

Lars Kellogg-Stedman (1):
      fix fio2gnuplot to work with new logging format

 Makefile               | 5 +++++
 ci/appveyor-install.sh | 2 ++
 tools/plot/fio2gnuplot | 2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index ef317373..f57569d5 100644
--- a/Makefile
+++ b/Makefile
@@ -40,6 +40,11 @@ ifdef CONFIG_PDB
   LDFLAGS += -fuse-ld=lld $(LINK_PDBFILE)
 endif
 
+# If clang, do not use builtin stpcpy as it breaks the build
+ifeq ($(CC),clang)
+  FIO_CFLAGS += -fno-builtin-stpcpy
+endif
+
 ifdef CONFIG_GFIO
   PROGS += gfio
 endif
diff --git a/ci/appveyor-install.sh b/ci/appveyor-install.sh
index c73e4cb5..3137f39e 100755
--- a/ci/appveyor-install.sh
+++ b/ci/appveyor-install.sh
@@ -31,7 +31,9 @@ case "${DISTRO}" in
         pacman.exe --noconfirm -S \
             mingw-w64-${PACKAGE_ARCH}-clang \
             mingw-w64-${PACKAGE_ARCH}-cunit \
+            mingw-w64-${PACKAGE_ARCH}-toolchain \
             mingw-w64-${PACKAGE_ARCH}-lld
+        pacman.exe -Q # List installed packages
         ;;
 esac
 
diff --git a/tools/plot/fio2gnuplot b/tools/plot/fio2gnuplot
index 78ee82fb..d2dc81df 100755
--- a/tools/plot/fio2gnuplot
+++ b/tools/plot/fio2gnuplot
@@ -198,7 +198,7 @@ def compute_temp_file(fio_data_file,disk_perf,gnuplot_output_dir, min_time, max_
 			# Index will be used to remember what file was featuring what value
 			index=index+1
 
-			time, perf, x, block_size = line[1]
+			time, perf, x, block_size = line[1][:4]
 			if (blk_size == 0):
 				try:
 					blk_size=int(block_size)

