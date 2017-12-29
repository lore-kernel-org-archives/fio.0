Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH] lib/memcpy: fix warning on FreeBSD
Date: Fri, 29 Dec 2017 15:38:23 +0200
Message-Id: <20171229133823.13295-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Include struct timeval via sys/time.h.
http://pubs.opengroup.org/onlinepubs/009604499/basedefs/sys/time.h.html

--
In file included from lib/memcpy.c:7:
lib/../fio_time.h:14:45: warning: declaration of 'struct timeval' will not be visible outside of this function [-Wvisibility]
extern uint64_t mtime_since_tv(const struct timeval *, const struct timeval *);

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio_time.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fio_time.h b/fio_time.h
index ee8087e0..8b4bb255 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -2,6 +2,7 @@
 #define FIO_TIME_H
 
 #include <time.h>
+#include <sys/time.h>
 #include "lib/types.h"
 
 struct thread_data;
-- 
2.13.6


