Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 01/11] configure: Add <linux/blkzoned.h> test
Date: Fri, 24 Aug 2018 09:30:36 -0700
Message-Id: <20180824163046.12304-2-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Add a test for <linux/blkzoned.h> because that header file will be used
by the zoned block device code.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 configure | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/configure b/configure
index fb8b2433a7a7..ab89df7d57e0 100755
--- a/configure
+++ b/configure
@@ -2195,6 +2195,24 @@ if compile_prog "" "" "valgrind_dev"; then
 fi
 print_config "Valgrind headers" "$valgrind_dev"
 
+##########################################
+# <linux/blkzoned.h> probe
+if test "$linux_blkzoned" != "yes" ; then
+  linux_blkzoned="no"
+fi
+cat > $TMPC << EOF
+#include <linux/blkzoned.h>
+int main(int argc, char **argv)
+{
+  return 0;
+}
+EOF
+if compile_prog "" "" "linux_blkzoned"; then
+  linux_blkzoned="yes"
+fi
+print_config "Zoned block device support" "$linux_blkzoned"
+
+##########################################
 # check march=armv8-a+crc+crypto
 if test "$march_armv8_a_crc_crypto" != "yes" ; then
   march_armv8_a_crc_crypto="no"
@@ -2519,6 +2537,9 @@ fi
 if test "$valgrind_dev" = "yes"; then
   output_sym "CONFIG_VALGRIND_DEV"
 fi
+if test "$linux_blkzoned" = "yes" ; then
+  output_sym "CONFIG_LINUX_BLKZONED"
+fi
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel, some fio features depend on it."
   if test "$build_static" = "yes"; then
-- 
2.18.0


