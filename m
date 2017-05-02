Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750848AbdEBMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 2 May 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d5WTU-0001Fy-0T
        for fio@vger.kernel.org; Tue, 02 May 2017 12:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170502120001.9545D2C1712@kernel.dk>
Date: Tue,  2 May 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit adcedfb85288e86c9e70a9003485c89fa47722ce:

  Drop triple X for cpu affinity for OpenBSD (2017-04-30 16:51:21 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d418fa90f6daf75bb9336182f79c0b25aa6feecd:

  configure: Add missing $val != "yes" test to override compile_prog() result (2017-05-01 14:47:16 -0600)

----------------------------------------------------------------
Omri Mor (1):
      os/os-android.h: fix shared memory support

Tomohiro Kusumi (6):
      configure: output_sym CONFIG_GFIO
      configure: Add missing <string.h> to avoid bogus warning
      configure: Add void* cast to avoid bogus warning
      configure: Check gfio test result via return value (not printf)
      configure: Add missing ##########...
      configure: Add missing $val != "yes" test to override compile_prog() result

 configure       | 27 ++++++++++++++++-----------
 os/os-android.h |  6 +++---
 2 files changed, 19 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index bcb898a..21bcaf4 100755
--- a/configure
+++ b/configure
@@ -161,8 +161,7 @@ for opt do
   ;;
   --build-static) build_static="yes"
   ;;
-  --enable-gfio)
-  gfio_check="yes"
+  --enable-gfio) gfio_check="yes"
   ;;
   --disable-numa) disable_numa="yes"
   ;;
@@ -613,7 +612,9 @@ echo "POSIX AIO fsync               $posix_aio_fsync"
 
 ##########################################
 # POSIX pshared attribute probe
-posix_pshared="no"
+if test "$posix_pshared" != "yes" ; then
+  posix_pshared="no"
+fi
 cat > $TMPC <<EOF
 #include <unistd.h>
 int main(void)
@@ -905,10 +906,11 @@ if test "$clockid_t" != "yes" ; then
 fi
 cat > $TMPC << EOF
 #include <time.h>
+#include <string.h>
 int main(int argc, char **argv)
 {
   volatile clockid_t cid;
-  memset(&cid, 0, sizeof(cid));
+  memset((void*)&cid, 0, sizeof(cid));
   return 0;
 }
 EOF
@@ -1243,7 +1245,7 @@ int main(void)
   gdk_threads_enter();
   gdk_threads_leave();
 
-  printf("%d", GTK_CHECK_VERSION(2, 18, 0));
+  return GTK_CHECK_VERSION(2, 18, 0) ? 0 : 1; /* 0 on success */
 }
 EOF
 GTK_CFLAGS=$(pkg-config --cflags gtk+-2.0 gthread-2.0)
@@ -1259,8 +1261,8 @@ if test "$?" != "0" ; then
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
@@ -1279,6 +1281,7 @@ if test "$gfio_check" = "yes" ; then
   echo "gtk 2.18 or higher            $gfio"
 fi
 
+##########################################
 # Check whether we have getrusage(RUSAGE_THREAD)
 if test "$rusage_thread" != "yes" ; then
   rusage_thread="no"
@@ -1473,7 +1476,6 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-
   rados_t cluster;
   rados_ioctx_t io_ctx;
   const char pool[] = "rbd";
@@ -1591,6 +1593,7 @@ if compile_prog "" "" "setvbuf"; then
 fi
 echo "setvbuf                       $setvbuf"
 
+##########################################
 # check for gfapi
 if test "$gfapi" != "yes" ; then
   gfapi="no"
@@ -1600,7 +1603,6 @@ cat > $TMPC << EOF
 
 int main(int argc, char **argv)
 {
-
   glfs_t *g = glfs_new("foo");
 
   return 0;
@@ -1794,6 +1796,7 @@ echo "NVML pmemblk engine           $pmemblk"
 # Report whether dev-dax engine is enabled
 echo "NVML dev-dax engine           $devdax"
 
+##########################################
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
@@ -1996,7 +1999,9 @@ echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
 
 ##########################################
 # cuda probe
-cuda="no"
+if test "$cuda" != "yes" ; then
+  cuda="no"
+fi
 cat > $TMPC << EOF
 #include <cuda.h>
 int main(int argc, char **argv)
@@ -2126,7 +2131,7 @@ if test "$rusage_thread" = "yes" ; then
   output_sym "CONFIG_RUSAGE_THREAD"
 fi
 if test "$gfio" = "yes" ; then
-  echo "CONFIG_GFIO=y" >> $config_host_mak
+  output_sym "CONFIG_GFIO"
 fi
 if test "$esx" = "yes" ; then
   output_sym "CONFIG_ESX"
diff --git a/os/os-android.h b/os/os-android.h
index ba599dd..6c3e098 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -57,18 +57,17 @@
 #define MAP_HUGETLB 0x40000 /* arch specific */
 #endif
 
-
+#ifndef CONFIG_NO_SHM
 /*
  * The Android NDK doesn't currently export <sys/shm.h>, so define the
  * necessary stuff here.
  */
 
-#include <linux/shm.h>
+#include <sys/shm.h>
 #define SHM_HUGETLB    04000
 
 #include <stdio.h>
 #include <linux/ashmem.h>
-#include <sys/mman.h>
 
 #define ASHMEM_DEVICE	"/dev/ashmem"
 
@@ -126,6 +125,7 @@ static inline int shmdt (const void *__shmaddr)
 	size = *ptr;    //find mmap size which we stored at the beginning of the buffer
 	return munmap((void *)ptr, size + sizeof(size_t));
 }
+#endif
 
 #define SPLICE_DEF_SIZE	(64*1024)
 
