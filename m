Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 06/11] configure: Add missing <string.h> to avoid bogus warning
Date: Mon,  1 May 2017 21:48:15 +0300
Message-Id: <20170501184820.31025-6-tkusumi@tuxera.com>
In-Reply-To: <20170501184820.31025-1-tkusumi@tuxera.com>
References: <20170501184820.31025-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This warning has nothing to do with what the code is trying to test.
This isn't testing if memset(3) is available, so just silence the
warning by including an appropriate header.

--
 # uname
 Linux
 # grep memset config.log -A2 | head -3
 /tmp/fio-conf-23441-58170-6422.c:5:3: warning: implicit declaration of function 'memset' [-Wimplicit-function-declaration]
    memset(&cid, 0, sizeof(cid));
    ^~~~~~

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 configure | 1 +
 1 file changed, 1 insertion(+)

diff --git a/configure b/configure
index b2120ec..0aaa3f8 100755
--- a/configure
+++ b/configure
@@ -934,6 +934,7 @@ if test "$clockid_t" != "yes" ; then
 fi
 cat > $TMPC << EOF
 #include <time.h>
+#include <string.h>
 int main(int argc, char **argv)
 {
   volatile clockid_t cid;
-- 
2.9.3


