Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/2] Add os_trim() support for FreeBSD
Date: Thu, 14 Jul 2016 21:27:43 +0900
Message-Id: <1468499263-6328-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1468499263-6328-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1468499263-6328-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

It has the same interface as Linux kernel with a different ioctl name.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile        |  1 +
 os/os-freebsd.h | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/Makefile b/Makefile
index a9cd151..b54f7e9 100644
--- a/Makefile
+++ b/Makefile
@@ -145,6 +145,7 @@ ifeq ($(CONFIG_TARGET_OS), SunOS)
   CPPFLAGS += -D__EXTENSIONS__
 endif
 ifeq ($(CONFIG_TARGET_OS), FreeBSD)
+  SOURCE += trim.c
   LIBS	 += -lpthread -lrt
   LDFLAGS += -rdynamic
 endif
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index fa00bb8..ac408c9 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -19,6 +19,7 @@
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_FS_STAT
+#define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
 
@@ -114,6 +115,20 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
+static inline int os_trim(int fd, unsigned long long start,
+			  unsigned long long len)
+{
+	off_t range[2];
+
+	range[0] = start;
+	range[1] = len;
+
+	if (!ioctl(fd, DIOCGDELETE, range))
+		return 0;
+
+	return errno;
+}
+
 #ifdef MADV_FREE
 #define FIO_MADV_FREE	MADV_FREE
 #endif
-- 
2.5.5


