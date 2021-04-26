Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhDZMBD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Apr 2021 08:01:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0B51C061574
        for <fio@vger.kernel.org>; Mon, 26 Apr 2021 05:00:19 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lazuI-005Znz-Sm
        for fio@vger.kernel.org; Mon, 26 Apr 2021 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210426120001.B4BEF1BC0168@kernel.dk>
Date: Mon, 26 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 14691a4df98b85621b07dd2bdc0f0a960acbb8ba:

  Merge branch 'gpspm-add-optional-use-rpma_conn_completion_wait-function' of https://github.com/ldorau/fio (2021-04-23 08:39:21 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 13169d44d3725847858a7c817965d2cac5abd8f8:

  Merge branch 'pthread_getaffinity_1' of https://github.com/kusumi/fio (2021-04-25 10:23:34 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'pthread_getaffinity_1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      gettime: Fix compilation on non-Linux with pthread_getaffinity_np()

 gettime.c         | 2 +-
 os/os-aix.h       | 6 ++++++
 os/os-android.h   | 6 ++++++
 os/os-dragonfly.h | 6 ++++++
 os/os-freebsd.h   | 6 ++++++
 os/os-hpux.h      | 7 +++++++
 os/os-linux.h     | 3 +++
 os/os-mac.h       | 6 ++++++
 os/os-netbsd.h    | 6 ++++++
 os/os-openbsd.h   | 6 ++++++
 os/os-solaris.h   | 6 ++++++
 11 files changed, 59 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/gettime.c b/gettime.c
index e3f483a7..099e9d9f 100644
--- a/gettime.c
+++ b/gettime.c
@@ -679,7 +679,7 @@ int fio_monotonic_clocktest(int debug)
 	unsigned int i;
 	os_cpu_mask_t mask;
 
-#ifdef CONFIG_PTHREAD_GETAFFINITY
+#ifdef FIO_HAVE_GET_THREAD_AFFINITY
 	fio_get_thread_affinity(mask);
 #else
 	memset(&mask, 0, sizeof(mask));
diff --git a/os/os-aix.h b/os/os-aix.h
index 1aab96e0..db99eef4 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -18,6 +18,12 @@
 
 #define FIO_USE_GENERIC_SWAP
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
 	return ENOTSUP;
diff --git a/os/os-android.h b/os/os-android.h
index 3c050776..3f1aa9d3 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -58,6 +58,12 @@
 #define MAP_HUGETLB 0x40000 /* arch specific */
 #endif
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 #ifndef CONFIG_NO_SHM
 /*
  * Bionic doesn't support SysV shared memeory, so implement it using ashmem
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 44bfcd5d..6e465894 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -92,6 +92,12 @@ typedef cpumask_t os_cpu_mask_t;
 /* No CPU_COUNT(), but use the default function defined in os/os.h */
 #define fio_cpu_count(mask)             CPU_COUNT((mask))
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
 	CPUMASK_ASSZERO(*mask);
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index b3addf98..1b24fa02 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -37,6 +37,12 @@ typedef cpuset_t os_cpu_mask_t;
 #define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
 #define fio_cpu_count(mask)		CPU_COUNT((mask))
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 static inline int fio_cpuset_init(os_cpu_mask_t *mask)
 {
         CPU_ZERO(mask);
diff --git a/os/os-hpux.h b/os/os-hpux.h
index c1dafe42..a80cb2bc 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -38,6 +38,13 @@
 #define FIO_USE_GENERIC_SWAP
 
 #define FIO_OS_HAVE_AIOCB_TYPEDEF
+
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 typedef struct aiocb64 os_aiocb_t;
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
diff --git a/os/os-linux.h b/os/os-linux.h
index ea8d7922..f7137abe 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -74,8 +74,11 @@ typedef cpu_set_t os_cpu_mask_t;
 	sched_getaffinity((pid), (ptr))
 #endif
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
 #define fio_get_thread_affinity(mask)	\
 	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
 
 #define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
 #define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
diff --git a/os/os-mac.h b/os/os-mac.h
index 683aab32..ec2cc1e5 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -27,6 +27,12 @@
 #define fio_swap32(x)	OSSwapInt32(x)
 #define fio_swap64(x)	OSSwapInt64(x)
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 #ifndef CONFIG_CLOCKID_T
 typedef unsigned int clockid_t;
 #endif
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index abc1d3cb..624c7fa5 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -35,6 +35,12 @@
 #define fio_swap32(x)	bswap32(x)
 #define fio_swap64(x)	bswap64(x)
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct disklabel dl;
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 994bf078..f1bad671 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -35,6 +35,12 @@
 #define fio_swap32(x)	swap32(x)
 #define fio_swap64(x)	swap64(x)
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct disklabel dl;
diff --git a/os/os-solaris.h b/os/os-solaris.h
index f1966f44..ea1f081c 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -46,6 +46,12 @@ struct solaris_rand_seed {
 #define os_ctime_r(x, y, z)     ctime_r((x), (y), (z))
 #define FIO_OS_HAS_CTIME_R
 
+#ifdef CONFIG_PTHREAD_GETAFFINITY
+#define FIO_HAVE_GET_THREAD_AFFINITY
+#define fio_get_thread_affinity(mask)	\
+	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
+#endif
+
 typedef psetid_t os_cpu_mask_t;
 
 static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)

