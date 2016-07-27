Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 01/15] Make return value type of fio_getaffinity() consistent
Date: Wed, 27 Jul 2016 22:37:06 +0900
Message-Id: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Return type of fio_getaffinity() isn't consistent among supported OS.
Windows and DragonFlyBSD return void while FreeBSD version is int.
The default version for those that don't support is do{}while(0).

Linux version is a macro for sched_getaffinity(2) which returns 0
on success and -1 otherwise, so others should basically follow that.

Note that I haven't compiled this on Windows, but it shouldn't fail.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 os/os-dragonfly.h | 10 ++++++----
 os/os-windows.h   |  5 ++++-
 os/os.h           |  6 +++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 187330b..d4a9579 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -70,8 +70,7 @@ typedef cpumask_t os_cpu_mask_t;
 
 /*
  * Define USCHED_GET_CPUMASK as the macro didn't exist until release 4.5.
- * usched_set(2) returns EINVAL if the kernel doesn't support it, though
- * fio_getaffinity() returns void.
+ * usched_set(2) returns EINVAL if the kernel doesn't support it.
  *
  * Also note usched_set(2) works only for the current thread regardless of
  * the command type. It doesn't work against another thread regardless of
@@ -145,12 +144,15 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t mask)
 	return 0;
 }
 
-static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 {
 	/* 0 for the current thread, see BUGS in usched_set(2) */
 	pid = 0;
 
-	usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask));
+	if (usched_set(pid, USCHED_GET_CPUMASK, mask, sizeof(*mask)))
+		return -1;
+
+	return 0;
 }
 
 /* fio code is Linux based, so rename macros to Linux style */
diff --git a/os/os-windows.h b/os/os-windows.h
index d049531..616ad43 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -193,7 +193,7 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 	return (bSuccess)? 0 : -1;
 }
 
-static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *mask)
 {
 	os_cpu_mask_t systemMask;
 
@@ -204,7 +204,10 @@ static inline void fio_getaffinity(int pid, os_cpu_mask_t *mask)
 		CloseHandle(h);
 	} else {
 		log_err("fio_getaffinity failed: failed to get handle for pid %d\n", pid);
+		return -1;
 	}
+
+	return 0;
 }
 
 static inline void fio_cpu_clear(os_cpu_mask_t *mask, int cpu)
diff --git a/os/os.h b/os/os.h
index 9877383..4f267c2 100644
--- a/os/os.h
+++ b/os/os.h
@@ -84,7 +84,6 @@ typedef struct aiocb os_aiocb_t;
 #endif
 
 #ifndef FIO_HAVE_CPU_AFFINITY
-#define fio_getaffinity(pid, mask)	do { } while (0)
 #define fio_cpu_clear(mask, cpu)	do { } while (0)
 typedef unsigned long os_cpu_mask_t;
 
@@ -93,6 +92,11 @@ static inline int fio_setaffinity(int pid, os_cpu_mask_t cpumask)
 	return 0;
 }
 
+static inline int fio_getaffinity(int pid, os_cpu_mask_t *cpumask)
+{
+	return -1;
+}
+
 static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
 {
 	return -1;
-- 
2.5.5


