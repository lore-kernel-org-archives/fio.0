Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 2/7] configure: Use x86 instead of i386 for $cpu for IA32
Date: Tue, 14 Feb 2017 17:19:43 +0200
Message-Id: <20170214151948.16460-3-tkusumi@tuxera.com>
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

fio internally uses "x86" for any sort of IA32, so use x86 for $cpu
as well which gets printed on ./configure.

This change should have been a part of e12f4ede in 2016.

 # grep i386 . -rI
 ./arch/arch.h:#if defined(__i386__)
 ./configure:elif check_define __i386__ ; then
 ./configure:  cpu="i386"
 ./configure:  i386|i486|i586|i686|i86pc|BePC)
 ./configure:    cpu="i386"
 ./crc/sha1.c:#if defined(__i386__) || defined(__x86_64__)
 ./crc/xxhash.c:#if defined(__ARM_FEATURE_UNALIGNED) || defined(__i386) || defined(_M_IX86) || defined(__x86_64__) || defined(_M_X64)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index cba81af..3f5386f 100755
--- a/configure
+++ b/configure
@@ -377,7 +377,7 @@ case "$cpu" in
     cpu="$cpu"
   ;;
   i386|i486|i586|i686|i86pc|BePC)
-    cpu="i386"
+    cpu="x86"
   ;;
   x86_64|amd64)
     cpu="x86_64"
-- 
2.9.3


