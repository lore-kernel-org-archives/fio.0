Return-Path: <dave.jiang@intel.com>
Subject: [PATCH v2] fio: Add support for auto detect dev-dax and libpmemblk
 engines
From: Dave Jiang <dave.jiang@intel.com>
Date: Tue, 20 Dec 2016 16:31:45 -0700
Message-ID: <148227670571.11076.11558753006919597850.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: ross.zwisler@linux.intel.com, fio@vger.kernel.org, dan.j.williams@intel.com, elliott@hpe.com
List-ID: <fio@vger.kernel.org>

Added support code in configure to detect whether libpmem and libpmemblk
are installed. dev-dax engine is enabled if libpmem is installed.
pmemblk engine is installed if libpmem and libpmemblk are installed.
A --disable-pmem flag is added to explicitly disable the libpmem based
engines even if the libs are detected.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 configure |   53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

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


