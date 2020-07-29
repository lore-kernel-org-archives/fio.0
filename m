Return-Path: <prvs=47212d7a9=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 1/4] configure: improve libzbc version check
Date: Thu, 30 Jul 2020 06:04:12 +0900
Message-Id: <20200729210415.4166-2-dmitry.fomichev@wdc.com>
In-Reply-To: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

Avoid parsing pkg-config output and just use --atleast-version to
check if libzbc is present and has an up to date version.

Currently, support for libzbc ioengine is always included if libzbc is
found at the build system. Add the option to disable libzbc ioengine
support even if libzbc is found. This can be useful for
cross-compilation.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 configure | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/configure b/configure
index 5925e94f..9a5f35f2 100755
--- a/configure
+++ b/configure
@@ -213,6 +213,8 @@ for opt do
   ;;
   --enable-libnbd) libnbd="yes"
   ;;
+  --disable-libzbc) libzbc="no"
+  ;;
   --disable-tcmalloc) disable_tcmalloc="yes"
   ;;
   --enable-libaio-uring) libaio_uring="yes"
@@ -256,6 +258,7 @@ if test "$show_help" = "yes" ; then
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
   echo "--enable-libnbd         Enable libnbd (NBD engine) support"
+  echo "--disable-libzbc        Disable libzbc even if found"
   echo "--disable-tcmalloc	Disable tcmalloc support"
   echo "--enable-libaio-uring   Enable libaio emulated over io_uring"
   echo "--dynamic-libengines	Lib-based ioengines as dynamic libraries"
@@ -2454,9 +2457,6 @@ fi
 
 ##########################################
 # libzbc probe
-if test "$libzbc" != "yes" ; then
-  libzbc="no"
-fi
 cat > $TMPC << EOF
 #include <libzbc/zbc.h>
 int main(int argc, char **argv)
@@ -2466,19 +2466,21 @@ int main(int argc, char **argv)
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


