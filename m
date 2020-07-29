Return-Path: <prvs=47212d7a9=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 2/4] configure: check if pkg-config is installed
Date: Thu, 30 Jul 2020 06:04:13 +0900
Message-Id: <20200729210415.4166-3-dmitry.fomichev@wdc.com>
In-Reply-To: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
References: <20200729210415.4166-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

A few libraries need to be newer than a specific version in order to be
supported by fio and pkg-config utility is used to verify the versions
of the installed libraries. Since this step may fail because pkg-config
is not installed, verify pkg-config presence and warn the user if it
could not be found.

To avoid code duplication, add a common helper function to perform
these checks.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 configure | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/configure b/configure
index 9a5f35f2..01fa5d1c 100755
--- a/configure
+++ b/configure
@@ -133,6 +133,23 @@ output_sym() {
   echo "#define $1" >> $config_host_h
 }
 
+check_min_lib_version() {
+  local feature
+
+  if ${cross_prefix}pkg-config --atleast-version=$2 $1 > /dev/null 2>&1; then
+    return 0
+  fi
+  if ${cross_prefix}pkg-config --version > /dev/null 2>&1; then
+    feature=${3:=$1}
+    if test ${!feature} = "yes" ; then
+      feature_not_found "" "$1 >= $2"
+    fi
+  else
+    print_config "$1" "missing pkg-config, can't check library version"
+  fi
+  return 1
+}
+
 targetos=""
 cpu=""
 
@@ -1520,18 +1537,17 @@ if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
-  echo "GTK found, but need version 2.18 or higher"
-  gfio="no"
-else
+gfio="yes"
+if check_min_lib_version gtk+-2.0 2.18.0 "gfio"; then
   if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
-    gfio="yes"
     GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
   else
     echo "Please install gtk and gdk libraries"
     gfio="no"
   fi
+else
+  gfio="no"
 fi
 LDFLAGS=$ORG_LDFLAGS
 fi
@@ -2181,15 +2197,11 @@ print_config "DDN's Infinite Memory Engine" "$libime"
 ##########################################
 # Check if we have libiscsi
 if test "$libiscsi" != "no" ; then
-  minimum_libiscsi=1.9.0
-  if $(pkg-config --atleast-version=$minimum_libiscsi libiscsi); then
+  if check_min_lib_version libiscsi 1.9.0; then
     libiscsi="yes"
     libiscsi_cflags=$(pkg-config --cflags libiscsi)
     libiscsi_libs=$(pkg-config --libs libiscsi)
   else
-    if test "$libiscsi" = "yes" ; then
-      feature_not_found "libiscsi" "libiscsi >= $minimum_libiscsi"
-    fi
     libiscsi="no"
   fi
 fi
@@ -2198,15 +2210,11 @@ print_config "iscsi engine" "$libiscsi"
 ##########################################
 # Check if we have libnbd (for NBD support)
 if test "$libnbd" != "no" ; then
-  minimum_libnbd=0.9.8
-  if $(pkg-config --atleast-version=$minimum_libnbd libnbd); then
+  if check_min_lib_version libnbd 0.9.8; then
     libnbd="yes"
     libnbd_cflags=$(pkg-config --cflags libnbd)
     libnbd_libs=$(pkg-config --libs libnbd)
   else
-    if test "$libnbd" = "yes" ; then
-      feature_not_found "libnbd" "libnbd >= $minimum_libnbd"
-    fi
     libnbd="no"
   fi
 fi
@@ -2468,11 +2476,8 @@ int main(int argc, char **argv)
 EOF
 if test "$libzbc" != "no" ; then
   if compile_prog "" "-lzbc" "libzbc"; then
-    minimum_libzbc=5
-    if $(pkg-config --atleast-version=$minimum_libzbc libzbc); then
-      libzbc="yes"
-    else
-      print_config "libzbc engine" "libzbc version $minimum_libzbc or above required"
+    libzbc="yes"
+    if ! check_min_lib_version libzbc 5; then
       libzbc="no"
     fi
   else
-- 
2.21.0


