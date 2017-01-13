Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdAMNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Jan 2017 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cS1Se-0006g5-2f
        for fio@vger.kernel.org; Fri, 13 Jan 2017 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170113130002.6E3AF2C0093@kernel.dk>
Date: Fri, 13 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0cbb3f53ebeec45478c7b361c2a84092da93e4a8:

  pmemblk: Clarify fsize is in MiB not MB (2017-01-11 21:00:01 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bc0c01e5d03d27e80d2a3b85ab21714bb6f32a19:

  Support zlib in the Windows build (enabled latency histogram logging) (2017-01-11 21:03:23 -0700)

----------------------------------------------------------------
Rebecca Cran (1):
      Support zlib in the Windows build (enabled latency histogram logging)

 configure | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index d768e9d..d0c2173 100755
--- a/configure
+++ b/configure
@@ -281,8 +281,18 @@ CYGWIN*)
   if test -z "$CC" ; then
     if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
       CC="i686-w64-mingw32-gcc"
+      if test -e "../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
+        echo "Building with zlib support"
+        output_sym "CONFIG_ZLIB"
+        echo "LIBS=../zlib/contrib/vstudio/vc14/x86/ZlibStatReleaseWithoutAsm/zlibstat.lib" >> $config_host_mak
+      fi
     else
       CC="x86_64-w64-mingw32-gcc"
+      if test -e "../zlib/contrib/vstudio/vc14/x64/ZlibStatReleaseWithoutAsm/zlibstat.lib"; then
+        echo "Building with zlib support"
+        output_sym "CONFIG_ZLIB"
+        echo "LIBS=../zlib/contrib/vstudio/vc14/x64/ZlibStatReleaseWithoutAsm/zlibstat.lib" >> $config_host_mak
+      fi
     fi
   fi
   output_sym "CONFIG_LITTLE_ENDIAN"
@@ -306,7 +316,8 @@ CYGWIN*)
   output_sym "CONFIG_TLS_THREAD"
   output_sym "CONFIG_IPV6"
   echo "CC=$CC" >> $config_host_mak
-  echo "BUILD_CFLAGS=$CFLAGS -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
+  echo "BUILD_CFLAGS=$CFLAGS -I../zlib -include config-host.h -D_GNU_SOURCE" >> $config_host_mak
+
   exit 0
   ;;
 esac
