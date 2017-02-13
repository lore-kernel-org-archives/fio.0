Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/6] configure: Drop default CONFIG_LITTLE_ENDIAN for Cygwin
Date: Mon, 13 Feb 2017 18:32:34 +0200
Message-Id: <20170213163239.46188-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It's a bit strange that Cygwin is assumed to be le by default when
no other platforms have such assumption even if they only target
a single or certain arch (e.g. non-Android Linux often runs on x86,
DragonFlyBSD only runs on x86, and so on..).

Endianness will be detected by pointer arithmetic anyway, and it's
better to rely on it to handle any sort of newly supported archs
in the future.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 1 -
 1 file changed, 1 deletion(-)

diff --git a/configure b/configure
index 4f17cf8..cba81af 100755
--- a/configure
+++ b/configure
@@ -306,7 +306,6 @@ CYGWIN*)
       fi
     fi
   fi
-  output_sym "CONFIG_LITTLE_ENDIAN"
   if test ! -z "$build_32bit_win" && test "$build_32bit_win" = "yes"; then
     output_sym "CONFIG_32BIT"
   else
-- 
2.9.3


