Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/8] Make lib/memalign.c a stand-alone library
Date: Tue,  4 Apr 2017 23:22:15 +0300
Message-Id: <20170404202218.52260-5-tkusumi@tuxera.com>
In-Reply-To: <20170404202218.52260-1-tkusumi@tuxera.com>
References: <20170404202218.52260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

lib/memalign.c not having dependency on fio.h enables it to be
a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under lib/ directory do things this way.

(For lib/memalign.c, it was actually myself who introduced this
dependency as a part of changes made by 248c9436, so this commit
is partially reverting that)

--
 # cat ./test3.c
 #include <stdio.h>
 #include "lib/memalign.h"
 int main(void) {
         char *p = fio_memalign(4096, 1000000);
         printf("%p\n", p);
         fio_memfree(p, 1000000);
         return 0;
 }
 # gcc -Wall -g ./test3.c ./lib/memalign.c
 # ./a.out
 0x7fbb7bbbc000

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/memalign.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/memalign.c b/lib/memalign.c
index 1d1ba9b..137cc8e 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -3,7 +3,9 @@
 #include <inttypes.h>
 
 #include "memalign.h"
-#include "../fio.h"
+
+#define PTR_ALIGN(ptr, mask)   \
+	(char *)((uintptr_t)((ptr) + (mask)) & ~(mask))
 
 struct align_footer {
 	unsigned int offset;
-- 
2.9.3


