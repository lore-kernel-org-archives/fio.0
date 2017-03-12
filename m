Return-Path: <fio-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36432 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933837AbdCLRQZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 12 Mar 2017 13:16:25 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Only enable arm64 CRC32 acceleration if the required header files are there
Date: Sun, 12 Mar 2017 13:16:12 -0400
Message-Id: <20170312171612.32247-1-tytso@mit.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: wei.xiao@arm.com, axboe@fb.com, Theodore Ts'o <tytso@mit.edu>

If the necessary header files are missing, then fio will bomb out when
building on arm64.  So disable the hardware acceleration option in
that case, since it's only performance improvement and not a
functional regression to turn it off.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 configure | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/configure b/configure
index d0c2173f..fa6f8acb 100755
--- a/configure
+++ b/configure
@@ -1807,6 +1807,10 @@ echo "bool                          $have_bool"
 march_armv8_a_crc_crypto="no"
 if test "$cpu" = "arm64" ; then
   cat > $TMPC <<EOF
+#include <sys/auxv.h>
+#include <arm_acle.h>
+#include <arm_neon.h>
+
 int main(void)
 {
   return 0;
-- 
2.11.0.rc0.7.gbe5a750

