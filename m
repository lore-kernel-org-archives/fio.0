Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/4] Add FIO_HAVE_FS_STAT/get_fs_free_size() support for OpenBSD
Date: Mon, 17 Oct 2016 23:17:39 +0900
Message-Id: <1476713861-8325-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

This commit is OpenBSD version of 60f840a8 in 2015.
This is the same as 60f840a8, as well as the previous commit
for NetBSD, as it uses POSIX statvfs.

Note that fio doesn't compile on OpenBSD 5.9 (hits lex error),
but this this commit should still be good since this function
alone compiles on OpenBSD.

(Note that the function was renamed with _free in c08ad04c)

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-openbsd.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index b1d8e83..2998510 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -5,6 +5,7 @@
 
 #include <errno.h>
 #include <sys/param.h>
+#include <sys/statvfs.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
 #undef RB_BLACK
@@ -17,6 +18,7 @@
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -53,6 +55,19 @@ static inline int gettid(void)
 	return (int) pthread_self();
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
 #ifdef MADV_FREE
 #define FIO_MADV_FREE	MADV_FREE
 #endif
-- 
1.7.1


