Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48435 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbFLMAK (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Jun 2015 08:00:10 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z3Nd3-0006VV-0b
	for fio@vger.kernel.org; Fri, 12 Jun 2015 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150612120002.47D3E2C21E7@kernel.dk>
Date: Fri, 12 Jun 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7a717ac6e6f154deebfe2af75a82ca0a76025453:

  Fix compiler warning (2015-06-10 08:45:36 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c08ad04c17e63c275ff477b21460ed6fa3b493f9:

  Rename get_fs_size() to get_fs_free_size() (2015-06-11 20:15:54 +0900)

----------------------------------------------------------------
Tomohiro Kusumi (3):
      Add header include for DragonFlyBSD
      Add get_fs_size() support for BSDs
      Rename get_fs_size() to get_fs_free_size()

 filesetup.c       |  2 +-
 os/os-android.h   |  2 +-
 os/os-dragonfly.h | 16 ++++++++++++++++
 os/os-freebsd.h   | 15 +++++++++++++++
 os/os-linux.h     |  2 +-
 os/os.h           |  2 +-
 6 files changed, 35 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/filesetup.c b/filesetup.c
index 51efdf7..212a126 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -732,7 +732,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		fm = flist_entry(n, struct fio_mount, list);
 		flist_del(&fm->list);
 
-		sz = get_fs_size(fm->base);
+		sz = get_fs_free_size(fm->base);
 		if (sz && sz != -1ULL)
 			ret += sz;
 
diff --git a/os/os-android.h b/os/os-android.h
index b4f4f13..1699539 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -238,7 +238,7 @@ static inline int arch_cache_line_size(void)
 		return atoi(size);
 }
 
-static inline unsigned long long get_fs_size(const char *path)
+static inline unsigned long long get_fs_free_size(const char *path)
 {
 	unsigned long long ret;
 	struct statfs s;
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index bc855ba..2a2b198 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -4,8 +4,10 @@
 #define	FIO_OS	os_dragonfly
 
 #include <errno.h>
+#include <unistd.h>
 #include <sys/param.h>
 #include <sys/sysctl.h>
+#include <sys/statvfs.h>
 
 #include "../file.h"
 
@@ -13,6 +15,7 @@
 #define FIO_USE_GENERIC_BDEV_SIZE
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
 #undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
@@ -49,6 +52,19 @@ static inline int gettid(void)
 	return (int) lwp_gettid();
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
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 22765ce..fa00bb8 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -10,6 +10,7 @@
 #include <sys/socket.h>
 #include <sys/param.h>
 #include <sys/cpuset.h>
+#include <sys/statvfs.h>
 
 #include "../file.h"
 
@@ -17,6 +18,7 @@
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_CHARDEV_SIZE
+#define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CPU_AFFINITY
 
@@ -99,6 +101,19 @@ static inline int gettid(void)
 	return (int) lwpid;
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
diff --git a/os/os-linux.h b/os/os-linux.h
index b786393..9e708f0 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -247,7 +247,7 @@ static inline int arch_cache_line_size(void)
 		return atoi(size);
 }
 
-static inline unsigned long long get_fs_size(const char *path)
+static inline unsigned long long get_fs_free_size(const char *path)
 {
 	unsigned long long ret;
 	struct statfs s;
diff --git a/os/os.h b/os/os.h
index 250b71f..f809a36 100644
--- a/os/os.h
+++ b/os/os.h
@@ -332,7 +332,7 @@ static inline int init_random_state(struct thread_data *td, unsigned long *rand_
 #endif
 
 #ifndef FIO_HAVE_FS_STAT
-static inline unsigned long long get_fs_size(const char *path)
+static inline unsigned long long get_fs_free_size(const char *path)
 {
 	return 0;
 }
