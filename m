Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 03/11] configure: Use single square brackets (POSIX)
Date: Mon,  1 May 2017 21:48:12 +0300
Message-Id: <20170501184820.31025-3-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Avoid "if [[...]]" format which seems to be bash extension.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 9bcdb63..09c5f60 100755
--- a/configure
+++ b/configure
@@ -1710,7 +1710,7 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "s390_z196_facilities"; then
   $TMPE
-  if [[ $? -eq 0 ]]; then
+  if [ $? -eq 0 ]; then
   	s390_z196_facilities="yes"
   fi
 fi
-- 
2.9.3


