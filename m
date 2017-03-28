Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 13/13] Separate io_u from ioengine [3/3] - rename ioengine.h to ioengines.h
Date: Tue, 28 Mar 2017 23:03:01 +0300
Message-Id: <20170328200301.8622-13-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is based on the previous commits which added a new header
io_u.h and separated io_u related from ioengine.h and ioengines.c.

Since now that ioengine.h and ioengines.c are 1:1 in their contents
(i.e. prototypes and implementation), they should be based on the
same name as well.

This could possibly break outbox ioengines if they include ioengine.h,
but all the inbox ones just include fio.h (probably because that's
what engines/skeleton_external.c does), so the impact is probably
limited, and fio doesn't guarantee anything to outbox ones anyway.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.h                     | 2 +-
 ioengine.h => ioengines.h | 0
 iolog.h                   | 2 +-
 rate-submit.c             | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename ioengine.h => ioengines.h (100%)

diff --git a/fio.h b/fio.h
index 806f7ed..3955a81 100644
--- a/fio.h
+++ b/fio.h
@@ -25,7 +25,7 @@
 #include "debug.h"
 #include "file.h"
 #include "io_ddir.h"
-#include "ioengine.h"
+#include "ioengines.h"
 #include "iolog.h"
 #include "helpers.h"
 #include "options.h"
diff --git a/ioengine.h b/ioengines.h
similarity index 100%
rename from ioengine.h
rename to ioengines.h
diff --git a/iolog.h b/iolog.h
index 37f27bc..0733ad3 100644
--- a/iolog.h
+++ b/iolog.h
@@ -4,7 +4,7 @@
 #include "lib/rbtree.h"
 #include "lib/ieee754.h"
 #include "flist.h"
-#include "ioengine.h"
+#include "ioengines.h"
 
 /*
  * Use for maintaining statistics
diff --git a/rate-submit.c b/rate-submit.c
index 4738dc4..fdbece6 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -5,7 +5,7 @@
  *
  */
 #include "fio.h"
-#include "ioengine.h"
+#include "ioengines.h"
 #include "lib/getrusage.h"
 #include "rate-submit.h"
 
-- 
2.9.3


