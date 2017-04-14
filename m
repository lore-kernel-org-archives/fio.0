Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 9/9] Make oslib/linux-dev-lookup.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:26 +0300
Message-Id: <20170414210626.32763-10-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It needs to include linux-dev-lookup.h from local directory where
linux-dev-lookup.c is also located, to be able to use this as
a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under oslib/ directory do things this way.

It also doesn't need to include os/os.h as it has no dependency.

--
 # cat ./test10.c
 #include <stdio.h>
 #include "oslib/linux-dev-lookup.h"
 int main(void) {
         /* just to see if it compiles */
         blktrace_lookup_device(NULL, NULL, 0, 0);
         return 0;
 }
 # gcc -Wall -g ./test10.c oslib/linux-dev-lookup.c

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 oslib/linux-dev-lookup.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 2bbd14a..5fbccd3 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -5,8 +5,7 @@
 #include <stdio.h>
 #include <unistd.h>
 
-#include "../os/os.h"
-#include "oslib/linux-dev-lookup.h"
+#include "linux-dev-lookup.h"
 
 int blktrace_lookup_device(const char *redirect, char *path, unsigned int maj,
 			   unsigned int min)
-- 
2.9.3


