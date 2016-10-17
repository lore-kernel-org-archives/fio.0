Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/4] Add FIO_HAVE_FS_STAT/get_fs_free_size() support for NetBSD
Date: Mon, 17 Oct 2016 23:17:38 +0900
Message-Id: <1476713861-8325-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

This commit is NetBSD version of 60f840a8 in 2015.
This is the same as 60f840a8, as it uses POSIX statvfs.

(Note that the function was renamed with _free in c08ad04c)

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-netbsd.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 4b0269e..4c629dd 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -6,6 +6,7 @@
 #include <errno.h>
 #include <lwp.h>
 #include <sys/param.h>
+#include <sys/statvfs.h>
 /* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
 #define	rb_node	_rb_node
 #include <sys/sysctl.h>
@@ -19,6 +20,7 @@
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -55,6 +57,19 @@ static inline int gettid(void)
 	return (int) _lwp_self();
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


