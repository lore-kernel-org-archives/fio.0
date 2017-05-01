Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 04/11] configure: Use compile_exec_prog() for s390_z196_facilities
Date: Mon,  1 May 2017 21:48:13 +0300
Message-Id: <20170501184820.31025-4-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The existing compile_prog() for s390_z196_facilities can be replaced
with compile_exec_prog() since what this does is

 if (s390_z196_facilities test code compiles)
     if (s390_z196_facilities test code returns 0)
         s390_z196_facilities = "yes";

and this is what compile_exec_prog() does too.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/configure b/configure
index 09c5f60..0b72f45 100755
--- a/configure
+++ b/configure
@@ -1708,11 +1708,8 @@ int main(int argc, char **argv)
       return -1;
 }
 EOF
-if compile_prog "" "" "s390_z196_facilities"; then
-  $TMPE
-  if [ $? -eq 0 ]; then
-  	s390_z196_facilities="yes"
-  fi
+if compile_exec_prog "" "" "s390_z196_facilities"; then
+  s390_z196_facilities="yes"
 fi
 echo "s390_z196_facilities          $s390_z196_facilities"
 
-- 
2.9.3


