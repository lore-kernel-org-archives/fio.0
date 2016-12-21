Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60918 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755936AbcLUNAE (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 21 Dec 2016 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cJgV1-0004vZ-Vx
        for fio@vger.kernel.org; Wed, 21 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161221130002.70C372C0098@kernel.dk>
Date: Wed, 21 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4fc8c5adec635f3a0d7e6c666328e96f14a9f015:

  Fio 2.16 (2016-12-19 23:12:56 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3ee2a3c1ae52841ecb4926ab5748e6d856fd4b2c:

  fio: Add support for auto detect dev-dax and libpmemblk engines (2016-12-20 16:43:36 -0700)

----------------------------------------------------------------
Dave Jiang (1):
      fio: Add support for auto detect dev-dax and libpmemblk engines

Jens Axboe (1):
      Fix compile on OSX

 configure | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 os/os.h   |  1 +
 2 files changed, 47 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 03bed3b..fc15782 100755
--- a/configure
+++ b/configure
@@ -138,6 +138,7 @@ libhdfs="no"
 pmemblk="no"
 devdax="no"
 disable_lex=""
+disable_pmem="no"
 prefix=/usr/local
 
 # parse options
@@ -173,10 +174,6 @@ for opt do
   ;;
   --enable-libhdfs) libhdfs="yes"
   ;;
-  --enable-pmemblk) pmemblk="yes"
-  ;;
-  --enable-devdax) devdax="yes"
-  ;;
   --disable-lex) disable_lex="yes"
   ;;
   --enable-lex) disable_lex="no"
@@ -185,6 +182,8 @@ for opt do
   ;;
   --disable-optimizations) disable_opt="yes"
   ;;
+  --disable-pmem) disable_pmem="yes"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -207,9 +206,8 @@ if test "$show_help" = "yes" ; then
   echo "--disable-numa         Disable libnuma even if found"
   echo "--disable-gfapi        Disable gfapi"
   echo "--enable-libhdfs       Enable hdfs support"
-  echo "--enable-pmemblk       Enable NVML libpmemblk support"
-  echo "--enable-devdax        Enable NVM Device Dax support"
   echo "--disable-lex          Disable use of lex/yacc for math"
+  echo "--disable-pmem         Disable pmem based engines even if found"
   echo "--enable-lex           Enable use of lex/yacc for math"
   echo "--disable-shm          Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
@@ -1567,12 +1565,53 @@ fi
 echo "MTD                           $mtd"
 
 ##########################################
+# Check whether we have libpmem
+libpmem="no"
+cat > $TMPC << EOF
+#include <libpmem.h>
+int main(int argc, char **argv)
+{
+  int rc;
+  rc = pmem_is_pmem(0, 0);
+  return 0;
+}
+EOF
+if compile_prog "" "-lpmem" "libpmem"; then
+  libpmem="yes"
+fi
+echo "libpmem                       $libpmem"
+
+##########################################
+# Check whether we have libpmemblk
+libpmemblk="no"
+cat > $TMPC << EOF
+#include <libpmemblk.h>
+int main(int argc, char **argv)
+{
+  int rc;
+  rc = pmemblk_open("", 0);
+  return 0;
+}
+EOF
+if compile_prog "" "-lpmemblk -lpmem" "libpmemblk"; then
+  libpmemblk="yes"
+fi
+echo "libpmemblk                    $libpmemblk"
+
+if test "$libpmem" = "yes" && test "$disable_pmem" = "no"; then
+  devdax="yes"
+  if test "$libpmemblk" = "yes"; then
+    pmemblk="yes"
+  fi
+fi
+
+##########################################
 # Report whether pmemblk engine is enabled
 echo "NVML libpmemblk engine        $pmemblk"
 
 ##########################################
 # Report whether dev-dax engine is enabled
-echo "NVM Device Dax engine        $devdax"
+echo "NVML Device Dax engine        $devdax"
 
 # Check if we have lex/yacc available
 yacc="no"
diff --git a/os/os.h b/os/os.h
index 16bca68..4178e6f 100644
--- a/os/os.h
+++ b/os/os.h
@@ -81,6 +81,7 @@ typedef struct aiocb os_aiocb_t;
 #define POSIX_FADV_DONTNEED	(0)
 #define POSIX_FADV_SEQUENTIAL	(0)
 #define POSIX_FADV_RANDOM	(0)
+#define POSIX_FADV_NORMAL	(0)
 #endif
 
 #ifndef FIO_HAVE_CPU_AFFINITY
