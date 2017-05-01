Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 10/11] configure: Add missing $val != "yes" test to override compile_prog() result
Date: Mon,  1 May 2017 21:48:19 +0300
Message-Id: <20170501184820.31025-10-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since it's possible for some platforms to use statically configured
configurations (e.g. see around L350 for Cygwin), it should test if
the variable hasn't been set to "yes" before initializing the variable
with "no", so that compile_prog() result can be safely ignored when
the platform knows it's supported.

ca205a75 (configure: Make Cygwin take regular configure path) started
this due to a major change in the configuration path, which changed
Cygwin to take the normal path taken by all other platforms, and
these two were added after that change.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index fe3354e..ce46996 100755
--- a/configure
+++ b/configure
@@ -631,7 +631,9 @@ echo "POSIX AIO fsync               $posix_aio_fsync"
 
 ##########################################
 # POSIX pshared attribute probe
-posix_pshared="no"
+if test "$posix_pshared" != "yes" ; then
+  posix_pshared="no"
+fi
 cat > $TMPC <<EOF
 #include <unistd.h>
 int main(void)
@@ -2024,7 +2026,9 @@ echo "march_armv8_a_crc_crypto      $march_armv8_a_crc_crypto"
 
 ##########################################
 # cuda probe
-cuda="no"
+if test "$cuda" != "yes" ; then
+  cuda="no"
+fi
 cat > $TMPC << EOF
 #include <cuda.h>
 int main(int argc, char **argv)
-- 
2.9.3


