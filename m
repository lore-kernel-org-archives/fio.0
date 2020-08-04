Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54645 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728867AbgHDBig (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Aug 2020 21:38:36 -0400
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v3 1/4] configure: improve libzbc version check
Date: Tue,  4 Aug 2020 10:38:25 +0900
Message-Id: <20200804013828.1569-2-dmitry.fomichev@wdc.com>
In-Reply-To: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
References: <20200804013828.1569-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Sitsofe Wheeler <sitsofe@gmail.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>

Avoid parsing pkg-config output and just use --atleast-version to
check if libzbc is present and has an up to date version.

Currently, support for libzbc ioengine is always included if libzbc is
found at the build system. Add the option to disable libzbc ioengine
support even if libzbc is found. This can be useful for
cross-compilation.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 configure | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/configure b/configure
index 5925e94f..81fd32bb 100755
--- a/configure
+++ b/configure
@@ -152,6 +152,7 @@ march_set="no"
 libiscsi="no"
 libnbd="no"
 libaio_uring="no"
+libzbc=""
 dynamic_engines="no"
 prefix=/usr/local
 
@@ -213,6 +214,8 @@ for opt do
   ;;
   --enable-libnbd) libnbd="yes"
   ;;
+  --disable-libzbc) libzbc="no"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --enable-libaio-uring) libaio_uring="yes"
@@ -256,6 +259,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
+  echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
   echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
@@ -2454,9 +2458,6 @@ fi
 
 ##########################################
 # libzbc probe
-if test "$libzbc" != "yes" ; then
-  libzbc="no"
-fi
 cat > $TMPC << EOF
 #include <libzbc/zbc.h>
 int main(int argc, char **argv)
@@ -2466,19 +2467,21 @@ int main(int argc, char **argv)
   return zbc_open("foo=bar", O_RDONLY, &dev);
 }
 EOF
-if compile_prog "" "-lzbc" "libzbc"; then
-  libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
-  if test "$libzbcvermaj" -ge "5" ; then
-    libzbc="yes"
+if test "$libzbc" != "no" ; then
+  if compile_prog "" "-lzbc" "libzbc"; then
+    minimum_libzbc=5
+    if $(pkg-config --atleast-version=$minimum_libzbc libzbc); then
+      libzbc="yes"
+    else
+      print_config "libzbc engine" "libzbc version $minimum_libzbc or above required"
+      libzbc="no"
+    fi
   else
-    print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
+    if test "$libzbc" = "yes" ; then
+      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
+    fi
     libzbc="no"
   fi
-else
-  if test "$libzbc" = "yes" ; then
-      feature_not_found "libzbc" "libzbc or libzbc/zbc.h"
-  fi
-  libzbc="no"
 fi
 print_config "libzbc engine" "$libzbc"
 
-- 
2.21.0


