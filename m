Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/9] Make lib/zipf.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:23 +0300
Message-Id: <20170414210626.32763-7-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

lib/zipf.c not having dependency on fio header (log.h) enables it
to be a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under lib/ directory do things this way.

lib/zipf.c doesn't use log.h (log(3) is apparently from -lm).

This requires the previous commit.

--
 # cat ./test8.c
 #include <stdio.h>
 #include "lib/zipf.h"
 int main(void) {
         /* just to see if it compiles */
         zipf_init(NULL, 0, 0, 0);
         return 0;
 }
 # gcc -Wall -g -lm -DBITS_PER_LONG=64 ./test8.c ./lib/zipf.c ./lib/rand.c ./lib/pattern.c ./lib/strntol.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/zipf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/zipf.c b/lib/zipf.c
index 681df70..3d535c7 100644
--- a/lib/zipf.c
+++ b/lib/zipf.c
@@ -6,7 +6,6 @@
 #include <sys/types.h>
 #include <fcntl.h>
 #include "ieee754.h"
-#include "../log.h"
 #include "zipf.h"
 #include "../minmax.h"
 #include "../hash.h"
-- 
2.9.3


