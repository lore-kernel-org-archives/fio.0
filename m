Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 09/11] configure: Add missing ##########...
Date: Mon,  1 May 2017 21:48:18 +0300
Message-Id: <20170501184820.31025-9-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

And remove unneeded blank lines from embedded test C code.
Both are just for better readability.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 5d8a9bd..fe3354e 100755
--- a/configure
+++ b/configure
@@ -1309,6 +1309,7 @@ if test "$gfio_check" = "yes" ; then
   echo "gtk 2.18 or higher            $gfio"
 fi
 
+##########################################
 # Check whether we have getrusage(RUSAGE_THREAD)
 if test "$rusage_thread" != "yes" ; then
   rusage_thread="no"
@@ -1503,7 +1504,6 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-
   rados_t cluster;
   rados_ioctx_t io_ctx;
   const char pool[] = "rbd";
@@ -1621,6 +1621,7 @@ if compile_prog "" "" "setvbuf"; then
 fi
 echo "setvbuf                       $setvbuf"
 
+##########################################
 # check for gfapi
 if test "$gfapi" != "yes" ; then
   gfapi="no"
@@ -1630,7 +1631,6 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-
   glfs_t *g = glfs_new("foo");
 
   return 0;
@@ -1821,6 +1821,7 @@ echo "NVML pmemblk engine           $pmemblk"
 # Report whether dev-dax engine is enabled
 echo "NVML dev-dax engine           $devdax"
 
+##########################################
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
-- 
2.9.3


