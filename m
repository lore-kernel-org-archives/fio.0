Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 08/11] configure: Check gfio test result via return value (not printf)
Date: Mon,  1 May 2017 21:48:17 +0300
Message-Id: <20170501184820.31025-8-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Test code compiled by compile_prog() mostly return 0 on success
whether binaries are executed or not. This one actually runs and
the result can be checked without printf.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/configure b/configure
index d434815..5d8a9bd 100755
--- a/configure
+++ b/configure
@@ -1273,7 +1273,7 @@ int main(void)
   gdk_threads_enter();
   gdk_threads_leave();
 
-  printf("%d", GTK_CHECK_VERSION(2, 18, 0));
+  return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
 GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
@@ -1289,8 +1289,8 @@ if test "$?" != "0" ; then
   exit 1
 fi
 if compile_prog "$GTK_CFLAGS" "$GTK_LIBS" "gfio" ; then
-  r=$($TMPE)
-  if test "$r" != "0" ; then
+  $TMPE
+  if test "$?" = "0" ; then
     gfio="yes"
     GFIO_LIBS="$LIBS $GTK_LIBS"
     CFLAGS="$CFLAGS $GTK_CFLAGS"
-- 
2.9.3


