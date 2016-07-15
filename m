Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47514 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565AbcGOMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 15 Jul 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bO1ml-0002Hh-2v
	for fio@vger.kernel.org; Fri, 15 Jul 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160715120001.90B1F2C29E7@kernel.dk>
Date: Fri, 15 Jul 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 883e4841d5466955ad464ee3a6b37e009cfa80ef:

  Merge branch 'fix_verify' of https://github.com/charles-jacobsen/fio (2016-07-13 09:13:46 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 45213f1b15f820e6791118b7200a1185e2af7d87:

  pthread: bump min stack size (2016-07-14 10:36:12 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      pthread: bump min stack size

Tomohiro Kusumi (2):
      Add os_trim() support for DragonFlyBSD
      Add os_trim() support for FreeBSD

 Makefile          |  2 ++
 gettime-thread.c  |  2 +-
 os/os-dragonfly.h | 16 ++++++++++++++++
 os/os-freebsd.h   | 15 +++++++++++++++
 verify.c          |  2 +-
 5 files changed, 35 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index c617d6f..b54f7e9 100644
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
@@ -157,6 +158,7 @@ ifeq ($(CONFIG_TARGET_OS), NetBSD)
   LDFLAGS += -rdynamic
 endif
 ifeq ($(CONFIG_TARGET_OS), DragonFly)
+  SOURCE += trim.c
   LIBS	 += -lpthread -lrt
   LDFLAGS += -rdynamic
 endif
diff --git a/gettime-thread.c b/gettime-thread.c
index 6dc1486..19541b4 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -71,7 +71,7 @@ int fio_start_gtod_thread(void)
 		return 1;
 
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
+	pthread_attr_setstacksize(&attr, 2 * PTHREAD_STACK_MIN);
 	ret = pthread_create(&gtod_thread, &attr, gtod_thread_main, mutex);
 	pthread_attr_destroy(&attr);
 	if (ret) {
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index b67c660..d776d1f 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -9,6 +9,7 @@
 #include <sys/sysctl.h>
 #include <sys/statvfs.h>
 #include <sys/diskslice.h>
+#include <sys/ioctl_compat.h>
 
 #include "../file.h"
 
@@ -16,6 +17,7 @@
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
+#define FIO_HAVE_TRIM
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
 
@@ -84,6 +86,20 @@ static inline unsigned long long get_fs_free_size(const char *path)
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
+	if (!ioctl(fd, IOCTLTRIM, range))
+		return 0;
+
+	return errno;
+}
+
 #ifdef MADV_FREE
 #define FIO_MADV_FREE	MADV_FREE
 #endif
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
diff --git a/verify.c b/verify.c
index 58f37ae..9a96fbb 100644
--- a/verify.c
+++ b/verify.c
@@ -1290,7 +1290,7 @@ int verify_async_init(struct thread_data *td)
 	pthread_attr_t attr;
 
 	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
+	pthread_attr_setstacksize(&attr, 2 * PTHREAD_STACK_MIN);
 
 	td->verify_thread_exit = 0;
 
