Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 07/11] configure: Add void* cast to avoid bogus warning
Date: Mon,  1 May 2017 21:48:16 +0300
Message-Id: <20170501184820.31025-7-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This warning has nothing to do with what the code is trying to test.
This test code should keep it volatile, so cast to void* to silence
a warning on discarding volatile.

--
 # uname
 Linux
 # grep memset config.log -A2 | head -3
 /tmp/fio-conf-15226-60011-1419.c:6:10: warning: passing argument 1 of 'memset' discards 'volatile' qualifier from pointer target type [-Wdiscarded-qualifiers]
    memset(&cid, 0, sizeof(cid));
           ^

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure b/configure
index 0aaa3f8..d434815 100755
--- a/configure
+++ b/configure
@@ -938,7 +938,7 @@ cat > $TMPC << EOF
 int main(int argc, char **argv)
 {
   volatile clockid_t cid;
-  memset(&cid, 0, sizeof(cid));
+  memset((void*)&cid, 0, sizeof(cid));
   return 0;
 }
 EOF
-- 
2.9.3


