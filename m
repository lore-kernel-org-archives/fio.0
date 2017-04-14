Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/9] Make lib/mountcheck.c a stand-alone library
Date: Sat, 15 Apr 2017 00:06:24 +0300
Message-Id: <20170414210626.32763-8-tkusumi@tuxera.com>
In-Reply-To: <20170414210626.32763-1-tkusumi@tuxera.com>
References: <20170414210626.32763-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

It needs to include mountcheck.h from local directory where
mountcheck.c is also located, to be able to use this as
a stand-alone library, which is useful for debugging purpose.
In fact, most of the files under lib/ directory do things this way.

--
 # cat ./test11.c
 #include <stdio.h>
 #include "lib/mountcheck.h"
 int main(int argc, char **argv) {
         printf("%d\n", device_is_mounted(argv[1]));
         return 0;
 }

--
 # uname
 Linux
 # gcc -Wall -g -DCONFIG_GETMNTENT ./test11.c ./lib/mountcheck.c
 # ./a.out /dev/sda1
 1

--
 # uname
 DragonFly
 # gcc -Wall -g -DCONFIG_GETMNTINFO ./test11.c ./lib/mountcheck.c
 # ./a.out /dev/da0s1a
 1

--
 # uname
 NetBSD
 # gcc -Wall -g -DCONFIG_GETMNTINFO_STATVFS ./test11.c ./lib/mountcheck.c
 # ./a.out /dev/sd0a
 1

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/mountcheck.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/mountcheck.c b/lib/mountcheck.c
index 0aec744..2fb6fe7 100644
--- a/lib/mountcheck.c
+++ b/lib/mountcheck.c
@@ -4,7 +4,7 @@
 #ifdef CONFIG_GETMNTENT
 #include <mntent.h>
 
-#include "lib/mountcheck.h"
+#include "mountcheck.h"
 
 #define MTAB	"/etc/mtab"
 
-- 
2.9.3


