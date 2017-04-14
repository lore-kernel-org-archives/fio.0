Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/9] Make lib/rand.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:22 +0300
Message-Id: <20170414210626.32763-6-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It needs to include pattern.h from local directory where rand.c
is also located, to be able to use this as a stand-alone library,
which is useful for debugging purpose. In fact, most of the files
under lib/ directory do things this way.

--
 # cat ./test7.c
 #include <stdio.h>
 #include "lib/rand.h"
 int main(void) {
         /* just to see if it compiles */
         init_rand(NULL, 0);
         return 0;
 }
 # gcc -Wall -g -DBITS_PER_LONG=64 ./test7.c ./lib/rand.c ./lib/pattern.c ./lib/strntol.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/rand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rand.c b/lib/rand.c
index 9c3e0d6..3f60a67 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -36,7 +36,7 @@
 #include <string.h>
 #include <assert.h>
 #include "rand.h"
-#include "lib/pattern.h"
+#include "pattern.h"
 #include "../hash.h"
 
 int arch_random;
-- 
2.9.3


