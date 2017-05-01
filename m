Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40427 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164890AbdEAMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 1 May 2017 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d59zq-0003YO-8i
        for fio@vger.kernel.org; Mon, 01 May 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170501120001.C37462C1712@kernel.dk>
Date: Mon,  1 May 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4bd2c8b9251a2c88f44ad52168252ce2de660bf7:

  configure: fix broken test for cuda (2017-04-26 15:24:36 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to adcedfb85288e86c9e70a9003485c89fa47722ce:

  Drop triple X for cpu affinity for OpenBSD (2017-04-30 16:51:21 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'fix-348' of https://github.com/omor1/fio
      Merge branch 'zero_ioengine_flags' of https://github.com/sitsofe/fio

Omri Mor (3):
      os/os-android.h: fix broken shmget() due to ndk-r15
      os/os-android.h: use byte swap intrinsics if available
      os/os-linux.h: fix broken byte swap intrinsics

Sitsofe Wheeler (1):
      fio.h: zero old flag bits when setting new ioengine flags

Tomohiro Kusumi (6):
      Fix "cast from pointer to integer of different size" warning on OpenBSD
      Fix "C99 inline functions are not supported" warning on OpenBSD
      Fix "'RB_ROOT' undeclared" error on OpenBSD
      Turn off lex by default on OpenBSD
      Implement shm_attach_to_open_removed() for OpenBSD
      Drop triple X for cpu affinity for OpenBSD

 configure       |  3 ++-
 fio.h           |  3 ++-
 iolog.c         |  2 +-
 os/os-android.h | 30 ++++++++++++++++++++++--------
 os/os-linux.h   | 25 +++++++++++++------------
 os/os-netbsd.h  |  2 +-
 os/os-openbsd.h | 29 ++++++++++++++++++++++++++---
 t/dedupe.c      |  2 +-
 8 files changed, 68 insertions(+), 28 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 83a6702..bcb898a 100755
--- a/configure
+++ b/configure
@@ -257,8 +257,9 @@ fi
 # cross-compiling to one of these OSes then you'll need to specify
 # the correct CPU with the --cpu option.
 case $targetos in
-AIX)
+AIX|OpenBSD)
   # Unless explicitly enabled, turn off lex.
+  # OpenBSD will hit syntax error when enabled.
   if test -z "$disable_lex" ; then
     disable_lex="yes"
   else
diff --git a/fio.h b/fio.h
index 6b2b669..e11a039 100644
--- a/fio.h
+++ b/fio.h
@@ -596,7 +596,8 @@ static inline enum fio_ioengine_flags td_ioengine_flags(struct thread_data *td)
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
 {
-	td->flags |= (td->io_ops->flags << TD_ENG_FLAG_SHIFT);
+	td->flags = (~(TD_ENG_FLAG_MASK << TD_ENG_FLAG_SHIFT) & td->flags) |
+		    (td->io_ops->flags << TD_ENG_FLAG_SHIFT);
 }
 
 static inline bool td_ioengine_flagged(struct thread_data *td,
diff --git a/iolog.c b/iolog.c
index 2e8da13..31d674c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -696,7 +696,7 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
+unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
 		unsigned int *io_u_plat_last)
 {
 	unsigned long sum;
diff --git a/os/os-android.h b/os/os-android.h
index b59fac1..ba599dd 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -20,6 +20,10 @@
 #include "binject.h"
 #include "../file.h"
 
+#ifndef __has_builtin         // Optional of course.
+  #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
+#endif
+
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_IOSCHED_SWITCH
 #define FIO_HAVE_IOPRIO
@@ -84,14 +88,14 @@ static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
 static inline int shmget (key_t __key, size_t __size, int __shmflg)
 {
 	int fd,ret;
-	char key[11];
-	
+	char keybuf[11];
+
 	fd = open(ASHMEM_DEVICE, O_RDWR);
 	if (fd < 0)
 		return fd;
 
-	sprintf(key,"%d",__key);
-	ret = ioctl(fd, ASHMEM_SET_NAME, key);
+	sprintf(keybuf,"%d",__key);
+	ret = ioctl(fd, ASHMEM_SET_NAME, keybuf);
 	if (ret < 0)
 		goto error;
 
@@ -100,7 +104,7 @@ static inline int shmget (key_t __key, size_t __size, int __shmflg)
 		goto error;
 
 	return fd;
-	
+
 error:
 	close(fd);
 	return ret;
@@ -219,9 +223,19 @@ static inline long os_random_long(os_random_state_t *rs)
 #define FIO_O_NOATIME	0
 #endif
 
-#define fio_swap16(x)	__bswap_16(x)
-#define fio_swap32(x)	__bswap_32(x)
-#define fio_swap64(x)	__bswap_64(x)
+/* Check for GCC or Clang byte swap intrinsics */
+#if (__has_builtin(__builtin_bswap16) && __has_builtin(__builtin_bswap32) \
+     && __has_builtin(__builtin_bswap64)) || (__GNUC__ > 4 \
+     || (__GNUC__ == 4 && __GNUC_MINOR__ >= 8)) /* fio_swapN */
+#define fio_swap16(x)	__builtin_bswap16(x)
+#define fio_swap32(x)	__builtin_bswap32(x)
+#define fio_swap64(x)	__builtin_bswap64(x)
+#else
+#include <byteswap.h>
+#define fio_swap16(x)	bswap_16(x)
+#define fio_swap32(x)	bswap_32(x)
+#define fio_swap64(x)	bswap_64(x)
+#endif /* fio_swapN */
 
 #define CACHE_LINE_FILE	\
 	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
diff --git a/os/os-linux.h b/os/os-linux.h
index 7b328dc..911f7e7 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -16,12 +16,15 @@
 #include <linux/unistd.h>
 #include <linux/raw.h>
 #include <linux/major.h>
-#include <byteswap.h>
 
 #include "./os-linux-syscall.h"
 #include "binject.h"
 #include "../file.h"
 
+#ifndef __has_builtin         // Optional of course.
+  #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
+#endif
+
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_DISK_UTIL
 #define FIO_HAVE_SGIO
@@ -219,21 +222,19 @@ static inline int fio_lookup_raw(dev_t dev, int *majdev, int *mindev)
 #define FIO_MADV_FREE	MADV_REMOVE
 #endif
 
-#if defined(__builtin_bswap16)
+/* Check for GCC or Clang byte swap intrinsics */
+#if (__has_builtin(__builtin_bswap16) && __has_builtin(__builtin_bswap32) \
+     && __has_builtin(__builtin_bswap64)) || (__GNUC__ > 4 \
+     || (__GNUC__ == 4 && __GNUC_MINOR__ >= 8)) /* fio_swapN */
 #define fio_swap16(x)	__builtin_bswap16(x)
-#else
-#define fio_swap16(x)	__bswap_16(x)
-#endif
-#if defined(__builtin_bswap32)
 #define fio_swap32(x)	__builtin_bswap32(x)
-#else
-#define fio_swap32(x)	__bswap_32(x)
-#endif
-#if defined(__builtin_bswap64)
 #define fio_swap64(x)	__builtin_bswap64(x)
 #else
-#define fio_swap64(x)	__bswap_64(x)
-#endif
+#include <byteswap.h>
+#define fio_swap16(x)	bswap_16(x)
+#define fio_swap32(x)	bswap_32(x)
+#define fio_swap64(x)	bswap_64(x)
+#endif /* fio_swapN */
 
 #define CACHE_LINE_FILE	\
 	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index e6ba508..7be02a7 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -25,7 +25,7 @@
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
 
 #define OS_MAP_ANON		MAP_ANON
 
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 7def432..d874ee2 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -9,6 +9,7 @@
 #include <sys/ioctl.h>
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
+#include <sys/utsname.h>
 /* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
 #undef RB_BLACK
@@ -24,7 +25,7 @@
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
 
 #define OS_MAP_ANON		MAP_ANON
 
@@ -68,7 +69,7 @@ static inline unsigned long long os_phys_mem(void)
 
 static inline int gettid(void)
 {
-	return (int) pthread_self();
+	return (int)(intptr_t) pthread_self();
 }
 
 static inline unsigned long long get_fs_free_size(const char *path)
@@ -90,9 +91,31 @@ static inline unsigned long long get_fs_free_size(const char *path)
 
 static inline int shm_attach_to_open_removed(void)
 {
+	struct utsname uts;
+	int major, minor;
+
+	if (uname(&uts) == -1)
+		return 0;
+
 	/*
-	 * XXX: Return 1 if >= OpenBSD 5.1 according to 97900ebf.
+	 * Return 1 if >= OpenBSD 5.1 according to 97900ebf,
+	 * assuming both major/minor versions are < 10.
 	 */
+	if (uts.release[0] > '9' || uts.release[0] < '0')
+		return 0;
+	if (uts.release[1] != '.')
+		return 0;
+	if (uts.release[2] > '9' || uts.release[2] < '0')
+		return 0;
+
+	major = uts.release[0] - '0';
+	minor = uts.release[2] - '0';
+
+	if (major > 5)
+		return 1;
+	if (major == 5 && minor >= 1)
+		return 1;
+
 	return 0;
 }
 
diff --git a/t/dedupe.c b/t/dedupe.c
index c0e9a69..1f172a2 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -14,7 +14,6 @@
 #include <fcntl.h>
 #include <string.h>
 
-#include "../lib/rbtree.h"
 #include "../flist.h"
 #include "../log.h"
 #include "../mutex.h"
@@ -25,6 +24,7 @@
 #include "../os/os.h"
 #include "../gettime.h"
 #include "../fio_time.h"
+#include "../lib/rbtree.h"
 
 #include "../lib/bloom.h"
 #include "debug.h"
