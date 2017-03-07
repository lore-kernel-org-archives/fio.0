Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 03/17] configure: Align help messages
Date: Tue,  7 Mar 2017 22:12:54 +0200
Message-Id: <20170307201308.66814-4-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/configure b/configure
index 15b87fa..8124467 100755
--- a/configure
+++ b/configure
@@ -195,21 +195,21 @@ for opt do
 done
 
 if test "$show_help" = "yes" ; then
-  echo "--prefix=              Use this directory as installation prefix"
-  echo "--cpu=                 Specify target CPU if auto-detect fails"
-  echo "--cc=                  Specify compiler to use"
-  echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
-  echo "--build-32bit-win      Enable 32-bit build on Windows"
-  echo "--build-static         Build a static fio"
-  echo "--esx                  Configure build options for esx"
-  echo "--enable-gfio          Enable building of gtk gfio"
-  echo "--disable-numa         Disable libnuma even if found"
-  echo "--disable-gfapi        Disable gfapi"
-  echo "--enable-libhdfs       Enable hdfs support"
-  echo "--disable-lex          Disable use of lex/yacc for math"
-  echo "--disable-pmem         Disable pmem based engines even if found"
-  echo "--enable-lex           Enable use of lex/yacc for math"
-  echo "--disable-shm          Disable SHM support"
+  echo "--prefix=               Use this directory as installation prefix"
+  echo "--cpu=                  Specify target CPU if auto-detect fails"
+  echo "--cc=                   Specify compiler to use"
+  echo "--extra-cflags=         Specify extra CFLAGS to pass to compiler"
+  echo "--build-32bit-win       Enable 32-bit build on Windows"
+  echo "--build-static          Build a static fio"
+  echo "--esx                   Configure build options for esx"
+  echo "--enable-gfio           Enable building of gtk gfio"
+  echo "--disable-numa          Disable libnuma even if found"
+  echo "--disable-gfapi         Disable gfapi"
+  echo "--enable-libhdfs        Enable hdfs support"
+  echo "--disable-lex           Disable use of lex/yacc for math"
+  echo "--disable-pmem          Disable pmem based engines even if found"
+  echo "--enable-lex            Enable use of lex/yacc for math"
+  echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   exit $exit_val
 fi
-- 
2.9.3


