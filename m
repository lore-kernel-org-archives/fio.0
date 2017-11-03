Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/3] solaris: add get_fs_free_size() implementation
Date: Fri,  3 Nov 2017 18:46:03 +0200
Message-Id: <20171103164603.31819-4-tkusumi@tuxera.com>
In-Reply-To: <20171103164603.31819-1-tkusumi@tuxera.com>
References: <20171103164603.31819-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Copied from os/os-freebsd.h. POSIX statvfs works on Solaris
(actually compiled/tested on illumos) as well.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 os/os-solaris.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/os/os-solaris.h b/os/os-solaris.h
index 644807c..2f13723 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -12,6 +12,7 @@
 #include <sys/mman.h>
 #include <sys/dkio.h>
 #include <sys/byteorder.h>
+#include <sys/statvfs.h>
 #include <pthread.h>
 
 #include "../file.h"
@@ -19,6 +20,7 @@
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_USE_GENERIC_BDEV_SIZE
+#define FIO_HAVE_FS_STAT
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 
@@ -76,6 +78,19 @@ static inline unsigned long long os_phys_mem(void)
 	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
+static inline unsigned long long get_fs_free_size(const char *path)
+{
+	unsigned long long ret;
+	struct statvfs s;
+
+	if (statvfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_frsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
+}
+
 static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
 {
 	rs->r[0] = seed & 0xffff;
-- 
2.9.5


