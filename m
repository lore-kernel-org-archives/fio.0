Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/2] configure: Use single square brackets (POSIX)
Date: Tue, 23 May 2017 21:43:57 +0300
Message-Id: <20170523184358.48088-2-tkusumi@tuxera.com>
In-Reply-To: <20170523184358.48088-1-tkusumi@tuxera.com>
References: <20170523184358.48088-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Avoid "if [[...]]" format which seems to be bash extension.
The script uses "if [...]" except for this one.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 0327578..9ac9701 100755
--- a/configure
+++ b/configure
@@ -1682,7 +1682,7 @@ int main(int argc, char **argv)
 EOF
 if compile_prog "" "" "s390_z196_facilities"; then
   $TMPE
-  if [[ $? -eq 0 ]]; then
+  if [ $? -eq 0 ]; then
   	s390_z196_facilities="yes"
   fi
 fi
-- 
2.9.4


