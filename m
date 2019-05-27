Return-Path: <helmut@subdivi.de>
Date: Mon, 27 May 2019 21:32:57 +0200
From: Helmut Grohne <helmut@subdivi.de>
Subject: [PATCH 2/2] configure: check for gtk version using pkg-config
Message-ID: <20190527193257.GA15197@alf.mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Martin Steigerwald <Martin.Steigerwald@proact.de>, 929579@bugs.debian.org, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

The previous way of running a program was incompatible with cross
compilation. The program is still being compiled as a sanity check, but
no longer run.

Signed-off-by: Helmut Grohne <helmut@subdivi.de>
---
 configure | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/configure b/configure
index 82bd432e..383175ae 100755
--- a/configure
+++ b/configure
@@ -1356,19 +1356,18 @@ if test "$?" != "0" ; then
   echo "configure: gtk and gthread not found"
   exit 1
 fi
-if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
-  $TMPE
-  if test "$?" = "0" ; then
+if ! ${cross_prefix}pkg-config --atleast-version 2.18.0 gtk+-2.0; then
+  echo "GTK found, but need version 2.18 or higher"
+  gfio="no"
+else
+  if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
     gfio="yes"
     GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
   else
-    echo "GTK found, but need version 2.18 or higher"
+    echo "Please install gtk and gdk libraries"
     gfio="no"
   fi
-else
-  echo "Please install gtk and gdk libraries"
-  gfio="no"
 fi
 LDFLAGS=$ORG_LDFLAGS
 fi
-- 
2.20.1


