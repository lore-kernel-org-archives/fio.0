Return-Path: <ykorman@gmail.com>
Return-Path: <ykorman@gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH v2 2/4] configure/Makefile: engine LIBS consistency
Date: Fri,  3 Jul 2020 15:38:41 +0300
Message-Id: <e63db7a6b9814b2696d3266b51e020734dc0d625.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
To: axboe@kernel.dk
Cc: Yigal Korman <ykorman@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Some engines were adding their LIBS in the Makefile and some were
declaring them in the configure script.
This is inconsistent and confusing and prevents easy bulk changes to the
engines.

Signed-off-by: Yigal Korman <ykorman@gmail.com>
---
 Makefile  | 14 ++++++++++++++
 configure | 12 ------------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 99e96635..629d8993 100644
--- a/Makefile
+++ b/Makefile
@@ -79,9 +79,15 @@ ifdef CONFIG_32BIT
 endif
 ifdef CONFIG_LIBAIO
   SOURCE += engines/libaio.c
+  ifdef CONFIG_LIBAIO_URING
+    LIBS += -luring
+  else
+    LIBS += -laio
+  endif
 endif
 ifdef CONFIG_RDMA
   SOURCE += engines/rdma.c
+  LIBS += -libverbs -lrdmacm
 endif
 ifdef CONFIG_POSIXAIO
   SOURCE += engines/posixaio.c
@@ -106,12 +112,15 @@ ifdef CONFIG_WINDOWSAIO
 endif
 ifdef CONFIG_RADOS
   SOURCE += engines/rados.c
+  LIBS += -lrados
 endif
 ifdef CONFIG_RBD
   SOURCE += engines/rbd.c
+  LIBS += -lrbd -lrados
 endif
 ifdef CONFIG_HTTP
   SOURCE += engines/http.c
+  LIBS += -lcurl -lssl -lcrypto
 endif
 SOURCE += oslib/asprintf.c
 ifndef CONFIG_STRSEP
@@ -139,6 +148,7 @@ ifdef CONFIG_GFAPI
   SOURCE += engines/glusterfs.c
   SOURCE += engines/glusterfs_sync.c
   SOURCE += engines/glusterfs_async.c
+  LIBS += -lgfapi -lglusterfs
   ifdef CONFIG_GF_FADVISE
     CFLAGS := "-DGFAPI_USE_FADVISE" $(CFLAGS)
   endif
@@ -150,18 +160,22 @@ ifdef CONFIG_MTD
 endif
 ifdef CONFIG_PMEMBLK
   SOURCE += engines/pmemblk.c
+  LIBS += -lpmemblk
 endif
 ifdef CONFIG_LINUX_DEVDAX
   SOURCE += engines/dev-dax.c
+  LIBS += -lpmem
 endif
 ifdef CONFIG_LIBPMEM
   SOURCE += engines/libpmem.c
+  LIBS += -lpmem
 endif
 ifdef CONFIG_IME
   SOURCE += engines/ime.c
 endif
 ifdef CONFIG_LIBZBC
   SOURCE += engines/libzbc.c
+  LIBS += -lzbc
 endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
diff --git a/configure b/configure
index 63b30555..5d475bf3 100755
--- a/configure
+++ b/configure
@@ -605,11 +605,9 @@ int main(void)
 EOF
   if test "$libaio_uring" = "yes" && compile_prog "" "-luring" "libaio io_uring" ; then
     libaio=yes
-    LIBS="-luring $LIBS"
   elif compile_prog "" "-laio" "libaio" ; then
     libaio=yes
     libaio_uring=no
-    LIBS="-laio $LIBS"
   else
     if test "$libaio" = "yes" ; then
       feature_not_found "linux AIO" "libaio-dev or libaio-devel"
@@ -859,7 +857,6 @@ int main(int argc, char **argv)
 EOF
 if test "$disable_rdma" != "yes" && compile_prog "" "-libverbs" "libverbs" ; then
     libverbs="yes"
-    LIBS="-libverbs $LIBS"
 fi
 print_config "libverbs" "$libverbs"
 
@@ -879,7 +876,6 @@ int main(int argc, char **argv)
 EOF
 if test "$disable_rdma" != "yes" && compile_prog "" "-lrdmacm" "rdma"; then
     rdmacm="yes"
-    LIBS="-lrdmacm $LIBS"
 fi
 print_config "rdmacm" "$rdmacm"
 
@@ -1770,10 +1766,8 @@ if test "$disable_http" != "yes"; then
   if compile_prog "" "$HTTP_LIBS" "curl-new-ssl"; then
     output_sym "CONFIG_HAVE_OPAQUE_HMAC_CTX"
     http="yes"
-    LIBS="$HTTP_LIBS $LIBS"
   elif mv $TMPC2 $TMPC && compile_prog "" "$HTTP_LIBS" "curl-old-ssl"; then
     http="yes"
-    LIBS="$HTTP_LIBS $LIBS"
   fi
 fi
 print_config "http engine" "$http"
@@ -1802,7 +1796,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_rados" != "yes"  && compile_prog "" "-lrados" "rados"; then
-  LIBS="-lrados $LIBS"
   rados="yes"
 fi
 print_config "Rados engine" "$rados"
@@ -1833,7 +1826,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_rbd" != "yes"  && compile_prog "" "-lrbd -lrados" "rbd"; then
-  LIBS="-lrbd -lrados $LIBS"
   rbd="yes"
 fi
 print_config "Rados Block Device engine" "$rbd"
@@ -1924,7 +1916,6 @@ int main(int argc, char **argv)
 }
 EOF
 if test "$disable_gfapi" != "yes"  && compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
-  LIBS="-lgfapi -lglusterfs $LIBS"
   gfapi="yes"
 fi
 print_config "Gluster API engine" "$gfapi"
@@ -2086,7 +2077,6 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "-lpmem" "libpmem"; then
   libpmem="yes"
-  LIBS="-lpmem $LIBS"
 fi
 print_config "libpmem" "$libpmem"
 
@@ -2108,7 +2098,6 @@ int main(int argc, char **argv)
 EOF
   if compile_prog "" "-lpmemblk" "libpmemblk"; then
     libpmemblk="yes"
-    LIBS="-lpmemblk $LIBS"
   fi
 fi
 print_config "libpmemblk" "$libpmemblk"
@@ -2432,7 +2421,6 @@ if compile_prog "" "-lzbc" "libzbc"; then
   libzbcvermaj=$(pkg-config --modversion libzbc | sed 's/\.[0-9]*\.[0-9]*//')
   if test "$libzbcvermaj" -ge "5" ; then
     libzbc="yes"
-    LIBS="-lzbc $LIBS"
   else
     print_config "libzbc engine" "Unsupported libzbc version (version 5 or above required)"
     libzbc="no"
-- 
2.17.1


