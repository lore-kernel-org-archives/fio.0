Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58452 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbeCHNAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Mar 2018 08:00:09 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1etv9U-0001Dk-Gr
        for fio@vger.kernel.org; Thu, 08 Mar 2018 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180308130001.D73A42C1D65@kernel.dk>
Date: Thu,  8 Mar 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 674456bf7d0f775f774c8097c8bcb98b48cccc51:

  Reduce LOG_MSEC_SLACK (2018-03-06 17:53:20 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 582e2fd9acae207400bed4226ceda4ee02464136:

  Merge branch 'disable_opt' of https://github.com/sitsofe/fio (2018-03-07 10:22:28 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      configure: don't override march if already set
      Merge branch 'disable_opt' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      configure: make --disable-optimizations disable march=native
      appveyor: disable setting compiler march

 appveyor.yml |  2 +-
 configure    | 10 +++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/appveyor.yml b/appveyor.yml
index c6c3689..09ebccf 100644
--- a/appveyor.yml
+++ b/appveyor.yml
@@ -17,7 +17,7 @@ install:
   - SET PATH=%CYG_ROOT%\bin;%PATH% #��NB: Changed env variables persist to later sections
 
 build_script:
-  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
+  - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && ./configure --disable-native --extra-cflags=\"-Werror\" ${CONFIGURE_OPTIONS} && make.exe'
 
 after_build:
   - cd os\windows && dobuild.cmd %PLATFORM%
diff --git a/configure b/configure
index 589ff3f..aefd5bb 100755
--- a/configure
+++ b/configure
@@ -1,7 +1,7 @@
 #!/bin/sh
 #
 # Fio configure script. Heavily influenced by the manual qemu configure
-# script. Sad this this is easier than autoconf and enemies.
+# script. Sad this is easier than autoconf and enemies.
 #
 
 # set temporary file name
@@ -146,6 +146,7 @@ pmem="no"
 disable_lex=""
 disable_pmem="no"
 disable_native="no"
+march_set="no"
 prefix=/usr/local
 
 # parse options
@@ -2065,6 +2066,7 @@ EOF
   if compile_prog "-march=armv8-a+crc+crypto" "" ""; then
     march_armv8_a_crc_crypto="yes"
     CFLAGS="$CFLAGS -march=armv8-a+crc+crypto -DARCH_HAVE_CRC_CRYPTO"
+    march_set="yes"
   fi
 fi
 print_config "march_armv8_a_crc_crypto" "$march_armv8_a_crc_crypto"
@@ -2112,7 +2114,8 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-if test "$disable_native" = "no" && compile_prog "-march=native" "" "march=native"; then
+if test "$disable_native" = "no" && test "$disable_opt" != "yes" && \
+   compile_prog "-march=native" "" "march=native"; then
   build_native="yes"
 fi
 print_config "Build march=native" "$build_native"
@@ -2287,6 +2290,7 @@ fi
 if test "$s390_z196_facilities" = "yes" ; then
   output_sym "CONFIG_S390_Z196_FACILITIES"
   CFLAGS="$CFLAGS -march=z9-109"
+  march_set="yes"
 fi
 if test "$gfapi" = "yes" ; then
   output_sym "CONFIG_GFAPI"
@@ -2360,7 +2364,7 @@ fi
 if test "$mkdir_two" = "yes" ; then
   output_sym "CONFIG_HAVE_MKDIR_TWO"
 fi
-if test "$build_native" = "yes" ; then
+if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
 
