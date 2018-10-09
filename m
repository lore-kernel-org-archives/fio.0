Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44474 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbeJITQy (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Oct 2018 15:16:54 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g9qgS-0004JO-1F
        for fio@vger.kernel.org; Tue, 09 Oct 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181009120001.ABCCE2C088D@kernel.dk>
Date: Tue,  9 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5857e8e0f53e81bd7096209fe5cabf91ce74b853:

  Merge branch 'patch-1' of https://github.com/joaomlneto/fio (2018-10-05 19:11:19 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ee6ce26c029dbdb62184d2f011fdab61d3429d82:

  options: kill 'use_os_rand' (2018-10-08 13:43:23 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Remove old OS dependent (unused) random code
      options: kill 'use_os_rand'

 options.c         |  8 --------
 os/os-aix.h       |  1 -
 os/os-android.h   | 17 -----------------
 os/os-dragonfly.h |  1 -
 os/os-freebsd.h   |  1 -
 os/os-hpux.h      |  1 -
 os/os-linux.h     | 15 ---------------
 os/os-mac.h       |  1 -
 os/os-netbsd.h    |  1 -
 os/os-openbsd.h   |  1 -
 os/os-solaris.h   | 16 ----------------
 os/os-windows.h   |  1 -
 os/os.h           | 17 -----------------
 thread_options.h  |  6 ++----
 14 files changed, 2 insertions(+), 85 deletions(-)

---

Diff of recent changes:

diff --git a/options.c b/options.c
index 66fb580..98187de 100644
--- a/options.c
+++ b/options.c
@@ -2203,14 +2203,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RANDOM,
 	},
 	{
-		.name	= "use_os_rand",
-		.lname	= "Use OS random",
-		.type	= FIO_OPT_DEPRECATED,
-		.off1	= offsetof(struct thread_options, dep_use_os_rand),
-		.category = FIO_OPT_C_IO,
-		.group	= FIO_OPT_G_RANDOM,
-	},
-	{
 		.name	= "norandommap",
 		.lname	= "No randommap",
 		.type	= FIO_OPT_STR_SET,
diff --git a/os/os-aix.h b/os/os-aix.h
index e204d6f..1aab96e 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -11,7 +11,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 
 #define OS_MAP_ANON		MAP_ANON
diff --git a/os/os-android.h b/os/os-android.h
index 1483275..3c05077 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -201,23 +201,6 @@ static inline unsigned long long os_phys_mem(void)
 	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
-typedef struct { unsigned short r[3]; } os_random_state_t;
-
-static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
-{
-	rs->r[0] = seed & 0xffff;
-	seed >>= 16;
-	rs->r[1] = seed & 0xffff;
-	seed >>= 16;
-	rs->r[2] = seed & 0xffff;
-	seed48(rs->r);
-}
-
-static inline long os_random_long(os_random_state_t *rs)
-{
-	return nrand48(rs->r);
-}
-
 #ifdef O_NOATIME
 #define FIO_O_NOATIME	O_NOATIME
 #else
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index e80ad8c..eb92521 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -25,7 +25,6 @@
 #include "../lib/types.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_TRIM
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 97bc8ae..789da17 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -16,7 +16,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_FS_STAT
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 515a525..c1dafe4 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -20,7 +20,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_CHARDEV_SIZE
 
diff --git a/os/os-linux.h b/os/os-linux.h
index 6b63d12..ba58bf7 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -60,8 +60,6 @@
 
 typedef cpu_set_t os_cpu_mask_t;
 
-typedef struct drand48_data os_random_state_t;
-
 #ifdef CONFIG_3ARG_AFFINITY
 #define fio_setaffinity(pid, cpumask)		\
 	sched_setaffinity((pid), sizeof(cpumask), &(cpumask))
@@ -170,19 +168,6 @@ static inline unsigned long long os_phys_mem(void)
 	return (unsigned long long) pages * (unsigned long long) pagesize;
 }
 
-static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
-{
-	srand48_r(seed, rs);
-}
-
-static inline long os_random_long(os_random_state_t *rs)
-{
-	long val;
-
-	lrand48_r(rs, &val);
-	return val;
-}
-
 static inline int fio_lookup_raw(dev_t dev, int *majdev, int *mindev)
 {
 	struct raw_config_request rq;
diff --git a/os/os-mac.h b/os/os-mac.h
index 92a60ee..0b9c870 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -16,7 +16,6 @@
 
 #include "../file.h"
 
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_CHARDEV_SIZE
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 682a11c..c06261d 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -21,7 +21,6 @@
 #include "../file.h"
 
 #define FIO_HAVE_ODIRECT
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index b4c02c9..70f58b4 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -20,7 +20,6 @@
 
 #include "../file.h"
 
-#define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 2425ab9..1a411af 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -47,7 +47,6 @@ struct solaris_rand_seed {
 #define FIO_OS_HAS_CTIME_R
 
 typedef psetid_t os_cpu_mask_t;
-typedef struct solaris_rand_seed os_random_state_t;
 
 static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 {
@@ -92,21 +91,6 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
-static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
-{
-	rs->r[0] = seed & 0xffff;
-	seed >>= 16;
-	rs->r[1] = seed & 0xffff;
-	seed >>= 16;
-	rs->r[2] = seed & 0xffff;
-	seed48(rs->r);
-}
-
-static inline long os_random_long(os_random_state_t *rs)
-{
-	return nrand48(rs->r);
-}
-
 #define FIO_OS_DIRECTIO
 extern int directio(int, int);
 static inline int fio_set_odirect(struct fio_file *f)
diff --git a/os/os-windows.h b/os/os-windows.h
index aad446e..ef955dc 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -35,7 +35,6 @@ int rand_r(unsigned *);
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_CHARDEV_SIZE
 #define FIO_HAVE_GETTID
-#define FIO_USE_GENERIC_RAND
 
 #define FIO_PREFERRED_ENGINE		"windowsaio"
 #define FIO_PREFERRED_CLOCK_SOURCE	CS_CGETTIME
diff --git a/os/os.h b/os/os.h
index becc410..0b182c4 100644
--- a/os/os.h
+++ b/os/os.h
@@ -298,23 +298,6 @@ static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 }
 #endif
 
-#ifdef FIO_USE_GENERIC_RAND
-typedef unsigned int os_random_state_t;
-
-static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
-{
-	srand(seed);
-}
-
-static inline long os_random_long(os_random_state_t *rs)
-{
-	long val;
-
-	val = rand_r(rs);
-	return val;
-}
-#endif
-
 #ifdef FIO_USE_GENERIC_INIT_RANDOM_STATE
 static inline int init_random_seeds(unsigned long *rand_seeds, int size)
 {
diff --git a/thread_options.h b/thread_options.h
index 4f791cf..14c6969 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -140,7 +140,6 @@ struct thread_options {
 	unsigned int rand_repeatable;
 	unsigned int allrand_repeatable;
 	unsigned long long rand_seed;
-	unsigned int dep_use_os_rand;
 	unsigned int log_avg_msec;
 	unsigned int log_hist_msec;
 	unsigned int log_hist_coarseness;
@@ -173,7 +172,6 @@ struct thread_options {
 
 	unsigned int hugepage_size;
 	unsigned long long rw_min_bs;
-	unsigned int pad2;
 	unsigned int thinktime;
 	unsigned int thinktime_spin;
 	unsigned int thinktime_blocks;
@@ -430,8 +428,8 @@ struct thread_options_pack {
 	uint32_t override_sync;
 	uint32_t rand_repeatable;
 	uint32_t allrand_repeatable;
+	uint32_t pad;
 	uint64_t rand_seed;
-	uint32_t dep_use_os_rand;
 	uint32_t log_avg_msec;
 	uint32_t log_hist_msec;
 	uint32_t log_hist_coarseness;
@@ -572,7 +570,7 @@ struct thread_options_pack {
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
 	uint32_t rate_process;
 	uint32_t rate_ign_think;
-	uint32_t pad;
+	uint32_t pad3;
 
 	uint8_t ioscheduler[FIO_TOP_STR_MAX];
 

