Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D9DECAAD5
	for <fio@archiver.kernel.org>; Wed, 31 Aug 2022 12:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiHaMAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 31 Aug 2022 08:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiHaMAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 31 Aug 2022 08:00:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4963A13D0F
        for <fio@vger.kernel.org>; Wed, 31 Aug 2022 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=c7dagpofTZbbYrG5mRWSO372KZy5Itv1tbrdQsBCNLU=; b=LDd8weF3LrxdFQ4iQbxtzU6lby
        LExilT/GhXiS91yX8yzvVyE+645Y24DVN22NUOXrCVQ7oyFwR1DShHpsDoaClOJVrv/8pIFxW1nMM
        SlpJQSmu1wxJG48k9nTs2N1ceeT/GWqTNdddqli7QKwz0g2p/qpNAo0E+hcszF2oEBsWYCoxxW3aA
        m9tjDk1HNoqvdCv9pja9wBKWQnCUrgH3jEPmZryehXE/9QgtjE1HXl3akU6mHyt2tURiDOwEqydxe
        AwT7l5obuPOf/8c419eJQoLaVGHkAGOdduPq11cWD9UMgti90ZNHN6cBJxnHoU8OSxVzKvE4TLmye
        VcUfjYAg==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTMO5-0054FU-Nn
        for fio@vger.kernel.org; Wed, 31 Aug 2022 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id E866C1BC0157; Wed, 31 Aug 2022 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220831120001.E866C1BC0157@kernel.dk>
Date:   Wed, 31 Aug 2022 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit b68ba328173f5a4714d888f6ce80fd24a4e4c504:

  test: get 32-bit Ubuntu 22.04 build working (2022-08-29 16:42:18 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c9be6f0007ab79e3f83952c650af8e7a0c324953:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-08-30 18:19:30 -0600)

----------------------------------------------------------------
Bart Van Assche (4):
      Remove two casts from os-linux.h
      Linux: Use the byte order functions from <asm/byteorder.h>
      Split os-android.h
      Merge os-android.h into os-linux.h

Jens Axboe (3):
      backend: revert bad memory leak fix
      Fio 3.32
      Merge branch 'master' of https://github.com/bvanassche/fio

Vincent Fu (1):
      test: add tests for lfsr and norandommap

 FIO-VERSION-GEN    |   2 +-
 backend.c          |   5 -
 os/os-android.h    | 342 -----------------------------------------------------
 os/os-ashmem.h     |  84 +++++++++++++
 os/os-linux.h      |  14 ++-
 os/os.h            |   4 +-
 t/jobs/t0021.fio   |  15 +++
 t/jobs/t0022.fio   |  13 ++
 t/run-fio-tests.py |  55 ++++++++-
 9 files changed, 180 insertions(+), 354 deletions(-)
 delete mode 100644 os/os-android.h
 create mode 100644 os/os-ashmem.h
 create mode 100644 t/jobs/t0021.fio
 create mode 100644 t/jobs/t0022.fio

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 72630dd0..db073818 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.31
+DEF_VER=fio-3.32
 
 LF='
 '
diff --git a/backend.c b/backend.c
index 375a23e4..fe614f6e 100644
--- a/backend.c
+++ b/backend.c
@@ -2451,10 +2451,8 @@ reap:
 							strerror(ret));
 			} else {
 				pid_t pid;
-				struct fio_file **files;
 				void *eo;
 				dprint(FD_PROCESS, "will fork\n");
-				files = td->files;
 				eo = td->eo;
 				read_barrier();
 				pid = fork();
@@ -2465,9 +2463,6 @@ reap:
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
 					*fio_debug_jobp = pid;
-				// freeing previously allocated memory for files
-				// this memory freed MUST NOT be shared between processes, only the pointer itself may be shared within TD
-				free(files);
 				free(eo);
 				free(fd);
 				fd = NULL;
diff --git a/os/os-android.h b/os/os-android.h
deleted file mode 100644
index 34534239..00000000
--- a/os/os-android.h
+++ /dev/null
@@ -1,342 +0,0 @@
-#ifndef FIO_OS_ANDROID_H
-#define FIO_OS_ANDROID_H
-
-#define	FIO_OS	os_android
-
-#include <sys/ioctl.h>
-#include <sys/mman.h>
-#include <sys/uio.h>
-#include <sys/syscall.h>
-#include <sys/sysmacros.h>
-#include <sys/vfs.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sched.h>
-#include <linux/unistd.h>
-#include <linux/major.h>
-#include <asm/byteorder.h>
-
-#include "./os-linux-syscall.h"
-#include "../file.h"
-
-#ifndef __has_builtin         // Optional of course.
-  #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
-#endif
-
-#define FIO_HAVE_CPU_AFFINITY
-#define FIO_HAVE_DISK_UTIL
-#define FIO_HAVE_IOSCHED_SWITCH
-#define FIO_HAVE_IOPRIO
-#define FIO_HAVE_IOPRIO_CLASS
-#define FIO_HAVE_ODIRECT
-#define FIO_HAVE_HUGETLB
-#define FIO_HAVE_BLKTRACE
-#define FIO_HAVE_CL_SIZE
-#define FIO_HAVE_CGROUPS
-#define FIO_HAVE_FS_STAT
-#define FIO_HAVE_TRIM
-#define FIO_HAVE_GETTID
-#define FIO_USE_GENERIC_INIT_RANDOM_STATE
-#define FIO_HAVE_E4_ENG
-#define FIO_HAVE_BYTEORDER_FUNCS
-#define FIO_HAVE_MMAP_HUGE
-#define FIO_NO_HAVE_SHM_H
-
-#define OS_MAP_ANON		MAP_ANONYMOUS
-
-typedef cpu_set_t os_cpu_mask_t;
-
-#define fio_setaffinity(pid, cpumask)		\
-	sched_setaffinity((pid), sizeof(cpumask), &(cpumask))
-#define fio_getaffinity(pid, ptr)	\
-	sched_getaffinity((pid), sizeof(cpu_set_t), (ptr))
-
-#ifndef POSIX_MADV_DONTNEED
-#define posix_madvise   madvise
-#define POSIX_MADV_DONTNEED MADV_DONTNEED
-#define POSIX_MADV_SEQUENTIAL	MADV_SEQUENTIAL
-#define POSIX_MADV_RANDOM	MADV_RANDOM
-#endif
-
-#ifdef MADV_REMOVE
-#define FIO_MADV_FREE	MADV_REMOVE
-#endif
-#ifndef MAP_HUGETLB
-#define MAP_HUGETLB 0x40000 /* arch specific */
-#endif
-
-#ifdef CONFIG_PTHREAD_GETAFFINITY
-#define FIO_HAVE_GET_THREAD_AFFINITY
-#define fio_get_thread_affinity(mask)	\
-	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
-#endif
-
-#define fio_cpu_clear(mask, cpu)	CPU_CLR((cpu), (mask))
-#define fio_cpu_set(mask, cpu)		CPU_SET((cpu), (mask))
-#define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
-#define fio_cpu_count(mask)		CPU_COUNT((mask))
-
-static inline int fio_cpuset_init(os_cpu_mask_t *mask)
-{
-	CPU_ZERO(mask);
-	return 0;
-}
-
-static inline int fio_cpuset_exit(os_cpu_mask_t *mask)
-{
-	return 0;
-}
-
-#define FIO_MAX_CPUS			CPU_SETSIZE
-
-#ifndef CONFIG_NO_SHM
-/*
- * Bionic doesn't support SysV shared memory, so implement it using ashmem
- */
-#include <stdio.h>
-#include <linux/ashmem.h>
-#include <linux/shm.h>
-#include <android/api-level.h>
-#if __ANDROID_API__ >= __ANDROID_API_O__
-#include <android/sharedmem.h>
-#else
-#define ASHMEM_DEVICE	"/dev/ashmem"
-#endif
-#define shmid_ds shmid64_ds
-#define SHM_HUGETLB    04000
-
-static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
-{
-	int ret=0;
-	if (__cmd == IPC_RMID)
-	{
-		int length = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
-		struct ashmem_pin pin = {0 , length};
-		ret = ioctl(__shmid, ASHMEM_UNPIN, &pin);
-		close(__shmid);
-	}
-	return ret;
-}
-
-#if __ANDROID_API__ >= __ANDROID_API_O__
-static inline int shmget(key_t __key, size_t __size, int __shmflg)
-{
-	char keybuf[11];
-
-	sprintf(keybuf, "%d", __key);
-
-	return ASharedMemory_create(keybuf, __size + sizeof(uint64_t));
-}
-#else
-static inline int shmget(key_t __key, size_t __size, int __shmflg)
-{
-	int fd,ret;
-	char keybuf[11];
-
-	fd = open(ASHMEM_DEVICE, O_RDWR);
-	if (fd < 0)
-		return fd;
-
-	sprintf(keybuf,"%d",__key);
-	ret = ioctl(fd, ASHMEM_SET_NAME, keybuf);
-	if (ret < 0)
-		goto error;
-
-	/* Stores size in first 8 bytes, allocate extra space */
-	ret = ioctl(fd, ASHMEM_SET_SIZE, __size + sizeof(uint64_t));
-	if (ret < 0)
-		goto error;
-
-	return fd;
-
-error:
-	close(fd);
-	return ret;
-}
-#endif
-
-static inline void *shmat(int __shmid, const void *__shmaddr, int __shmflg)
-{
-	size_t size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
-	/* Needs to be 8-byte aligned to prevent SIGBUS on 32-bit ARM */
-	uint64_t *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
-	/* Save size at beginning of buffer, for use with munmap */
-	*ptr = size;
-	return ptr + 1;
-}
-
-static inline int shmdt (const void *__shmaddr)
-{
-	/* Find mmap size which we stored at the beginning of the buffer */
-	uint64_t *ptr = (uint64_t *)__shmaddr - 1;
-	size_t size = *ptr;
-	return munmap(ptr, size);
-}
-#endif
-
-#define SPLICE_DEF_SIZE	(64*1024)
-
-enum {
-	IOPRIO_CLASS_NONE,
-	IOPRIO_CLASS_RT,
-	IOPRIO_CLASS_BE,
-	IOPRIO_CLASS_IDLE,
-};
-
-enum {
-	IOPRIO_WHO_PROCESS = 1,
-	IOPRIO_WHO_PGRP,
-	IOPRIO_WHO_USER,
-};
-
-#define IOPRIO_BITS		16
-#define IOPRIO_CLASS_SHIFT	13
-
-#define IOPRIO_MIN_PRIO		0	/* highest priority */
-#define IOPRIO_MAX_PRIO		7	/* lowest priority */
-
-#define IOPRIO_MIN_PRIO_CLASS	0
-#define IOPRIO_MAX_PRIO_CLASS	3
-
-static inline int ioprio_value(int ioprio_class, int ioprio)
-{
-	/*
-	 * If no class is set, assume BE
-	 */
-        if (!ioprio_class)
-                ioprio_class = IOPRIO_CLASS_BE;
-
-	return (ioprio_class << IOPRIO_CLASS_SHIFT) | ioprio;
-}
-
-static inline bool ioprio_value_is_class_rt(unsigned int priority)
-{
-	return (priority >> IOPRIO_CLASS_SHIFT) == IOPRIO_CLASS_RT;
-}
-
-static inline int ioprio_set(int which, int who, int ioprio_class, int ioprio)
-{
-	return syscall(__NR_ioprio_set, which, who,
-		       ioprio_value(ioprio_class, ioprio));
-}
-
-#ifndef BLKGETSIZE64
-#define BLKGETSIZE64	_IOR(0x12,114,size_t)
-#endif
-
-#ifndef BLKFLSBUF
-#define BLKFLSBUF	_IO(0x12,97)
-#endif
-
-#ifndef BLKDISCARD
-#define BLKDISCARD	_IO(0x12,119)
-#endif
-
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return ioctl(f->fd, BLKFLSBUF);
-}
-
-static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
-{
-	if (!ioctl(f->fd, BLKGETSIZE64, bytes))
-		return 0;
-
-	return errno;
-}
-
-static inline unsigned long long os_phys_mem(void)
-{
-	long pagesize, pages;
-
-	pagesize = sysconf(_SC_PAGESIZE);
-	pages = sysconf(_SC_PHYS_PAGES);
-	if (pages == -1 || pagesize == -1)
-		return 0;
-
-	return (unsigned long long) pages * (unsigned long long) pagesize;
-}
-
-#ifdef O_NOATIME
-#define FIO_O_NOATIME	O_NOATIME
-#else
-#define FIO_O_NOATIME	0
-#endif
-
-/* Check for GCC or Clang byte swap intrinsics */
-#if (__has_builtin(__builtin_bswap16) && __has_builtin(__builtin_bswap32) \
-     && __has_builtin(__builtin_bswap64)) || (__GNUC__ > 4 \
-     || (__GNUC__ == 4 && __GNUC_MINOR__ >= 8)) /* fio_swapN */
-#define fio_swap16(x)	__builtin_bswap16(x)
-#define fio_swap32(x)	__builtin_bswap32(x)
-#define fio_swap64(x)	__builtin_bswap64(x)
-#else
-#include <byteswap.h>
-#define fio_swap16(x)	bswap_16(x)
-#define fio_swap32(x)	bswap_32(x)
-#define fio_swap64(x)	bswap_64(x)
-#endif /* fio_swapN */
-
-#define CACHE_LINE_FILE	\
-	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
-
-static inline int arch_cache_line_size(void)
-{
-	char size[32];
-	int fd, ret;
-
-	fd = open(CACHE_LINE_FILE, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	ret = read(fd, size, sizeof(size));
-
-	close(fd);
-
-	if (ret <= 0)
-		return -1;
-	else
-		return atoi(size);
-}
-
-static inline unsigned long long get_fs_free_size(const char *path)
-{
-	unsigned long long ret;
-	struct statfs s;
-
-	if (statfs(path, &s) < 0)
-		return -1ULL;
-
-	ret = s.f_bsize;
-	ret *= (unsigned long long) s.f_bfree;
-	return ret;
-}
-
-static inline int os_trim(struct fio_file *f, unsigned long long start,
-			  unsigned long long len)
-{
-	uint64_t range[2];
-
-	range[0] = start;
-	range[1] = len;
-
-	if (!ioctl(f->fd, BLKDISCARD, range))
-		return 0;
-
-	return errno;
-}
-
-#ifdef CONFIG_SCHED_IDLE
-static inline int fio_set_sched_idle(void)
-{
-        struct sched_param p = { .sched_priority = 0, };
-        return sched_setscheduler(gettid(), SCHED_IDLE, &p);
-}
-#endif
-
-#ifndef RWF_UNCACHED
-#define RWF_UNCACHED	0x00000040
-#endif
-
-#endif
diff --git a/os/os-ashmem.h b/os/os-ashmem.h
new file mode 100644
index 00000000..c34ff656
--- /dev/null
+++ b/os/os-ashmem.h
@@ -0,0 +1,84 @@
+#ifndef CONFIG_NO_SHM
+/*
+ * Bionic doesn't support SysV shared memory, so implement it using ashmem
+ */
+#include <stdio.h>
+#include <linux/ashmem.h>
+#include <linux/shm.h>
+#include <android/api-level.h>
+#if __ANDROID_API__ >= __ANDROID_API_O__
+#include <android/sharedmem.h>
+#else
+#define ASHMEM_DEVICE	"/dev/ashmem"
+#endif
+#define shmid_ds shmid64_ds
+#define SHM_HUGETLB    04000
+
+static inline int shmctl(int __shmid, int __cmd, struct shmid_ds *__buf)
+{
+	int ret=0;
+	if (__cmd == IPC_RMID)
+	{
+		int length = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
+		struct ashmem_pin pin = {0 , length};
+		ret = ioctl(__shmid, ASHMEM_UNPIN, &pin);
+		close(__shmid);
+	}
+	return ret;
+}
+
+#if __ANDROID_API__ >= __ANDROID_API_O__
+static inline int shmget(key_t __key, size_t __size, int __shmflg)
+{
+	char keybuf[11];
+
+	sprintf(keybuf, "%d", __key);
+
+	return ASharedMemory_create(keybuf, __size + sizeof(uint64_t));
+}
+#else
+static inline int shmget(key_t __key, size_t __size, int __shmflg)
+{
+	int fd,ret;
+	char keybuf[11];
+
+	fd = open(ASHMEM_DEVICE, O_RDWR);
+	if (fd < 0)
+		return fd;
+
+	sprintf(keybuf,"%d",__key);
+	ret = ioctl(fd, ASHMEM_SET_NAME, keybuf);
+	if (ret < 0)
+		goto error;
+
+	/* Stores size in first 8 bytes, allocate extra space */
+	ret = ioctl(fd, ASHMEM_SET_SIZE, __size + sizeof(uint64_t));
+	if (ret < 0)
+		goto error;
+
+	return fd;
+
+error:
+	close(fd);
+	return ret;
+}
+#endif
+
+static inline void *shmat(int __shmid, const void *__shmaddr, int __shmflg)
+{
+	size_t size = ioctl(__shmid, ASHMEM_GET_SIZE, NULL);
+	/* Needs to be 8-byte aligned to prevent SIGBUS on 32-bit ARM */
+	uint64_t *ptr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, __shmid, 0);
+	/* Save size at beginning of buffer, for use with munmap */
+	*ptr = size;
+	return ptr + 1;
+}
+
+static inline int shmdt (const void *__shmaddr)
+{
+	/* Find mmap size which we stored at the beginning of the buffer */
+	uint64_t *ptr = (uint64_t *)__shmaddr - 1;
+	size_t size = *ptr;
+	return munmap(ptr, size);
+}
+#endif
diff --git a/os/os-linux.h b/os/os-linux.h
index 3001140c..831f0ad0 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -1,7 +1,11 @@
 #ifndef FIO_OS_LINUX_H
 #define FIO_OS_LINUX_H
 
+#ifdef __ANDROID__
+#define FIO_OS  os_android
+#else
 #define	FIO_OS	os_linux
+#endif
 
 #include <sys/ioctl.h>
 #include <sys/uio.h>
@@ -17,6 +21,11 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <scsi/sg.h>
+#include <asm/byteorder.h>
+#ifdef __ANDROID__
+#include "os-ashmem.h"
+#define FIO_NO_HAVE_SHM_H
+#endif
 
 #ifdef ARCH_HAVE_CRC_CRYPTO
 #include <sys/auxv.h>
@@ -50,6 +59,7 @@
 #define FIO_HAVE_TRIM
 #define FIO_HAVE_GETTID
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_BYTEORDER_FUNCS
 #define FIO_HAVE_PWRITEV2
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
@@ -81,8 +91,8 @@ typedef cpu_set_t os_cpu_mask_t;
 	pthread_getaffinity_np(pthread_self(), sizeof(mask), &(mask))
 #endif
 
-#define fio_cpu_clear(mask, cpu)	(void) CPU_CLR((cpu), (mask))
-#define fio_cpu_set(mask, cpu)		(void) CPU_SET((cpu), (mask))
+#define fio_cpu_clear(mask, cpu)	CPU_CLR((cpu), (mask))
+#define fio_cpu_set(mask, cpu)		CPU_SET((cpu), (mask))
 #define fio_cpu_isset(mask, cpu)	(CPU_ISSET((cpu), (mask)) != 0)
 #define fio_cpu_count(mask)		CPU_COUNT((mask))
 
diff --git a/os/os.h b/os/os.h
index 810e6166..aba6813f 100644
--- a/os/os.h
+++ b/os/os.h
@@ -33,9 +33,7 @@ typedef enum {
 } cpu_features;
 
 /* IWYU pragma: begin_exports */
-#if defined(__ANDROID__)
-#include "os-android.h"
-#elif defined(__linux__)
+#if defined(__linux__)
 #include "os-linux.h"
 #elif defined(__FreeBSD__)
 #include "os-freebsd.h"
diff --git a/t/jobs/t0021.fio b/t/jobs/t0021.fio
new file mode 100644
index 00000000..47fbae71
--- /dev/null
+++ b/t/jobs/t0021.fio
@@ -0,0 +1,15 @@
+# make sure the lfsr random generator actually does touch all the offsets
+#
+# Expected result: offsets are not accessed sequentially and all offsets are touched
+# Buggy result: offsets are accessed sequentially and one or more offsets are missed
+# run with --debug=io or logging to see which offsets are read
+
+[test]
+ioengine=null
+filesize=1M
+rw=randread
+write_bw_log=test
+per_job_logs=0
+log_offset=1
+norandommap=1
+random_generator=lfsr
diff --git a/t/jobs/t0022.fio b/t/jobs/t0022.fio
new file mode 100644
index 00000000..2324571e
--- /dev/null
+++ b/t/jobs/t0022.fio
@@ -0,0 +1,13 @@
+# make sure that when we enable norandommap we touch some offsets more than once
+#
+# Expected result: at least one offset is touched more than once
+# Buggy result: each offset is touched only once
+
+[test]
+ioengine=null
+filesize=1M
+rw=randread
+write_bw_log=test
+per_job_logs=0
+log_offset=1
+norandommap=1
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 78f43521..47823761 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -576,7 +576,7 @@ class FioJobTest_t0019(FioJobTest):
 
 
 class FioJobTest_t0020(FioJobTest):
-    """Test consists of fio test job t0020
+    """Test consists of fio test jobs t0020 and t0021
     Confirm that almost all offsets were touched non-sequentially"""
 
     def check_result(self):
@@ -614,6 +614,41 @@ class FioJobTest_t0020(FioJobTest):
                 self.failure_reason += " missing offset {0}".format(i*4096)
 
 
+class FioJobTest_t0022(FioJobTest):
+    """Test consists of fio test job t0022"""
+
+    def check_result(self):
+        super(FioJobTest_t0022, self).check_result()
+
+        bw_log_filename = os.path.join(self.test_dir, "test_bw.log")
+        file_data, success = self.get_file(bw_log_filename)
+        log_lines = file_data.split('\n')
+
+        filesize = 1024*1024
+        bs = 4096
+        seq_count = 0
+        offsets = set()
+
+        prev = int(log_lines[0].split(',')[4])
+        for line in log_lines[1:]:
+            offsets.add(prev/bs)
+            if len(line.strip()) == 0:
+                continue
+            cur = int(line.split(',')[4])
+            if cur - prev == bs:
+                seq_count += 1
+            prev = cur
+
+        # 10 is an arbitrary threshold
+        if seq_count > 10:
+            self.passed = False
+            self.failure_reason = "too many ({0}) consecutive offsets".format(seq_count)
+
+        if len(offsets) == filesize/bs:
+            self.passed = False
+            self.failure_reason += " no duplicate offsets found with norandommap=1".format(len(offsets))
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -973,6 +1008,24 @@ TEST_LIST = [
         'pre_success':      None,
         'requirements':     [],
     },
+    {
+        'test_id':          21,
+        'test_class':       FioJobTest_t0020,
+        'job':              't0021.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
+    {
+        'test_id':          22,
+        'test_class':       FioJobTest_t0022,
+        'job':              't0022.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
