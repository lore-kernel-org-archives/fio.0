Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/3] solaris: #include <pthread.h>
Date: Fri,  3 Nov 2017 18:46:01 +0200
Message-Id: <20171103164603.31819-2-tkusumi@tuxera.com>
In-Reply-To: <20171103164603.31819-1-tkusumi@tuxera.com>
References: <20171103164603.31819-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

os/os-solaris.h header uses pthread, but doesn't include <pthread.h>
which should be to be able to include this header alone.
Needed for unittesting of OS specific stuff.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-solaris.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/os/os-solaris.h b/os/os-solaris.h
index 45268b2..a6cd376 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -12,6 +12,7 @@
 #include <sys/mman.h>
 #include <sys/dkio.h>
 #include <sys/byteorder.h>
+#include <pthread.h>
 
 #include "../file.h"
 
-- 
2.9.5


