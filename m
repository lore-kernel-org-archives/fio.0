Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/9] Make lib/pattern.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:21 +0300
Message-Id: <20170414210626.32763-5-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

lib/pattern.c not having dependency on fio.h enables it to be
a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under lib/ directory do things this way.

This requires the previous commit.

--
 # cat ./test6.c
 #include <stdio.h>
 #include "lib/pattern.h"
 int main(void) {
         /* just to see if it compiles */
         paste_format_inplace(NULL, 0, NULL, 0, NULL);
         return 0;
 }
 # gcc -Wall -g ./test6.c ./lib/pattern.c ./lib/strntol.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/pattern.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/pattern.c b/lib/pattern.c
index b8ae809..0aeb935 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -1,6 +1,13 @@
-#include "fio.h"
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <errno.h>
+#include <assert.h>
+
 #include "strntol.h"
 #include "pattern.h"
+#include "../minmax.h"
 #include "../oslib/strcasestr.h"
 
 /**
-- 
2.9.3


