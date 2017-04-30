Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/6] Fix "'RB_ROOT' undeclared" error on OpenBSD
Date: Sun, 30 Apr 2017 20:35:08 +0300
Message-Id: <20170430173511.44593-4-tkusumi@tuxera.com>
In-Reply-To: <20170430173511.44593-1-tkusumi@tuxera.com>
References: <20170430173511.44593-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

OpenBSD has below compiler error due to RB_ROOT name conflict between
lib/rbtree.h and OpenBSD header. os/os-{net,open}bsd.h actually have
had a workaround for this by undefing their RB_XXX macros (which fio
doesn't use) for possible conflicts, but then "lib/rbtree.h" needs
to be included after os/os.h which includes os/os-openbsd.h.

t/dedupe.c: In function 'main':
t/dedupe.c:583: error: 'RB_ROOT' undeclared (first use in this function)
t/dedupe.c:583: error: (Each undeclared identifier is reported only once
t/dedupe.c:583: error: for each function it appears in.)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 t/dedupe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/t/dedupe.c b/t/dedupe.c
index c0e9a69..1f172a2 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -14,7 +14,6 @@
 #include <fcntl.h>
 #include <string.h>
 
-#include "../lib/rbtree.h"
 #include "../flist.h"
 #include "../log.h"
 #include "../mutex.h"
@@ -25,6 +24,7 @@
 #include "../os/os.h"
 #include "../gettime.h"
 #include "../fio_time.h"
+#include "../lib/rbtree.h"
 
 #include "../lib/bloom.h"
 #include "debug.h"
-- 
2.9.3


