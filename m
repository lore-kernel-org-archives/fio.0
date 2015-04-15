Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 4/7] mtd: Add CONFIG_MTD to ./configure script
Date: Wed, 15 Apr 2015 10:41:32 -0700
Message-Id: <1429119695-22425-5-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

The CONFIG_MTD option will allow the mtd ioengine to be built. It
only works when the Linux MTD header is present.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 configure | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/configure b/configure
index 892335b..e1b218c 100755
--- a/configure
+++ b/configure
@@ -1369,6 +1369,23 @@ if test "$libhdfs" = "yes" ; then
 fi
 echo "HDFS engine                   $libhdfs"
 
+##########################################
+# Check whether we have MTD
+mtd="no"
+cat > $TMPC << EOF
+#include <mtd/mtd-user.h>
+#include <sys/ioctl.h>
+int main(int argc, char **argv)
+{
+  struct mtd_info_user info;
+  return ioctl(0, MEMGETINFO, &info);
+}
+EOF
+if compile_prog "" "" "mtd"; then
+  mtd="yes"
+fi
+echo "MTD                           $mtd"
+
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
@@ -1572,6 +1589,9 @@ if test "$libhdfs" = "yes" ; then
   echo "FIO_LIBHDFS_INCLUDE=$FIO_LIBHDFS_INCLUDE" >> $config_host_mak
   echo "FIO_LIBHDFS_LIB=$FIO_LIBHDFS_LIB" >> $config_host_mak
  fi
+if test "$mtd" = "yes" ; then
+  output_sym "CONFIG_MTD"
+fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
-- 
2.2.0.rc0.207.ga3a616c


