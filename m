Return-Path: <fio-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:44505 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336Ab2KUHOP (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 21 Nov 2012 02:14:15 -0500
Received: From
	[10.13.1.8] ([203.143.161.65] == vampire.ertos.nicta.com.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By note With Smtp ;
	Wed, 21 Nov 2012 18:08:09 +1100 
From: Aaron Carroll <aaronc@cse.unsw.edu.au>
Date: Wed, 21 Nov 2012 18:07:51 +1100
Message-ID: <50AC7DC7.6040804@cse.unsw.edu.au>
MIME-Version: 1.0
Subject: FIO on Android
Content-Type: multipart/mixed;
 boundary="------------080402080200000605050902"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------080402080200000605050902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Attached is a patch to support Android.  It's implemented as a different OS, so 
most of the changes are in os/os-android.h

To build, do something like:

   make UNAME=Android 
CROSS_COMPILE=/path/to/android/toolchain/bin/arm-linux-androideabi-

Yes, it's pretty ugly all round, but fio isn't designed for cross compile and 
Android's libc is busted, so we have to make do.

Note that this is basically untested.  Works for a few basic tests but YMMV.  If 
someone wants to look at the splice build warning, that would be great.


Cheers,
   -- Aaron



  Makefile        |   10 ++-
  backend.c       |    2 +
  init.c          |    2 +
  memory.c        |    2 +
  os/os-android.h |  234 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
  os/os.h         |   16 ++++-
  6 files changed, 263 insertions(+), 3 deletions(-)



--------------080402080200000605050902
Content-Type: text/x-patch;
 name="fio-android.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-android.patch"

diff --git a/Makefile b/Makefile
index 8473238..b68ab06 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,5 @@
 ifneq ($(origin CC), environment)
-CC	= gcc
+CC	= $(CROSS_COMPILE)gcc
 endif
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 \
@@ -28,6 +28,14 @@ ifeq ($(UNAME), Linux)
   LIBS += -lpthread -ldl -lrt -laio
   LDFLAGS += -rdynamic
 endif
+ifeq ($(UNAME), Android)
+  SOURCE += diskutil.c fifo.c blktrace.c helpers.c trim.c \
+		engines/splice.c profiles/tiobench.c engines/falloc.c \
+		engines/e4defrag.c
+  LIBS += -ldl
+  LDFLAGS += -rdynamic
+  CPPFLAGS += -DFIO_NO_HAVE_SHM_H
+endif
 ifeq ($(UNAME), SunOS)
   SOURCE += fifo.c lib/strsep.c helpers.c engines/posixaio.c \
 		engines/solarisaio.c
diff --git a/backend.c b/backend.c
index b80c903..f901503 100644
--- a/backend.c
+++ b/backend.c
@@ -34,7 +34,9 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 #include <sys/ipc.h>
+#ifndef FIO_NO_HAVE_SHM_H
 #include <sys/shm.h>
+#endif
 #include <sys/mman.h>
 
 #include "fio.h"
diff --git a/init.c b/init.c
index 7021741..29a50f2 100644
--- a/init.c
+++ b/init.c
@@ -9,7 +9,9 @@
 #include <string.h>
 #include <errno.h>
 #include <sys/ipc.h>
+#ifndef FIO_NO_HAVE_SHM_H
 #include <sys/shm.h>
+#endif
 #include <sys/types.h>
 #include <sys/stat.h>
 
diff --git a/memory.c b/memory.c
index b4ee475..4a9dc4a 100644
--- a/memory.c
+++ b/memory.c
@@ -5,7 +5,9 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <unistd.h>
+#ifndef FIO_NO_HAVE_SHM_H
 #include <sys/shm.h>
+#endif
 #include <sys/mman.h>
 
 #include "fio.h"
diff --git a/os/os-android.h b/os/os-android.h
new file mode 100644
index 0000000..3da3953
--- /dev/null
+++ b/os/os-android.h
@@ -0,0 +1,234 @@
+#ifndef FIO_OS_ANDROID_H
+#define FIO_OS_ANDROID_H
+
+#define	FIO_OS	os_android
+
+#include <sys/ioctl.h>
+#include <sys/uio.h>
+#include <sys/syscall.h>
+#include <sys/vfs.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sched.h>
+#include <linux/unistd.h>
+#include <linux/major.h>
+#include <endian.h>
+
+#include "indirect.h"
+#include "binject.h"
+#include "../file.h"
+
+#define FIO_HAVE_DISK_UTIL
+#define FIO_HAVE_SPLICE
+#define FIO_HAVE_IOSCHED_SWITCH
+#define FIO_HAVE_ODIRECT
+#define FIO_HAVE_HUGETLB
+#define FIO_HAVE_BLKTRACE
+#define FIO_HAVE_STRSEP
+#define FIO_HAVE_POSIXAIO_FSYNC
+#define FIO_HAVE_PSHARED_MUTEX
+#define FIO_HAVE_CL_SIZE
+#define FIO_HAVE_FDATASYNC
+#define FIO_HAVE_FS_STAT
+#define FIO_HAVE_TRIM
+#define FIO_HAVE_CLOCK_MONOTONIC
+#define FIO_HAVE_GETTID
+#define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_E4_ENG
+#define FIO_HAVE_BYTEORDER_FUNCS
+
+#define OS_MAP_ANON		MAP_ANONYMOUS
+
+#define posix_madvise   madvise
+#define POSIX_MADV_DONTNEED MADV_DONTNEED
+#define POSIX_MADV_SEQUENTIAL	MADV_SEQUENTIAL
+#define POSIX_MADV_RANDOM	MADV_RANDOM
+#ifdef MADV_REMOVE
+#define FIO_MADV_FREE	MADV_REMOVE
+#endif
+
+
+/*
+ * The Android NDK doesn't currently export <sys/shm.h>, so define the
+ * necessary stuff here.
+ */
+
+#include <linux/shm.h>
+#define SHM_HUGETLB    04000
+
+static inline int shmctl (int __shmid, int __cmd, struct shmid_ds *__buf)
+{
+	return syscall(__NR_shmctl, __shmid, __cmd, __buf);
+}
+
+static inline int shmget (key_t __key, size_t __size, int __shmflg)
+{
+	return syscall(__NR_shmget, __key, __size, __shmflg);
+}
+
+static inline void *shmat (int __shmid, const void *__shmaddr, int __shmflg)
+{
+	return (void *)syscall(__NR_shmat, __shmid, __shmaddr, __shmflg);
+}
+
+static inline int shmdt (const void *__shmaddr)
+{
+	return syscall(__NR_shmctl, __shmaddr);
+}
+
+
+/*
+ * Just check for SPLICE_F_MOVE, if that isn't there, assume the others
+ * aren't either.
+ */
+#ifndef SPLICE_F_MOVE
+#define SPLICE_F_MOVE	(0x01)	/* move pages instead of copying */
+#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing (but */
+				 /* we may still block on the fd we splice */
+				 /* from/to, of course */
+#define SPLICE_F_MORE	(0x04)	/* expect more data */
+#define SPLICE_F_GIFT   (0x08)  /* pages passed in are a gift */
+
+static inline int splice(int fdin, loff_t *off_in, int fdout, loff_t *off_out,
+			 size_t len, unsigned int flags)
+{
+	return syscall(__NR_sys_splice, fdin, off_in, fdout, off_out, len, flags);
+}
+
+static inline int tee(int fdin, int fdout, size_t len, unsigned int flags)
+{
+	return syscall(__NR_sys_tee, fdin, fdout, len, flags);
+}
+
+static inline int vmsplice(int fd, const struct iovec *iov,
+			   unsigned long nr_segs, unsigned int flags)
+{
+	return syscall(__NR_sys_vmsplice, fd, iov, nr_segs, flags);
+}
+#endif
+
+#define SPLICE_DEF_SIZE	(64*1024)
+
+#ifndef BLKGETSIZE64
+#define BLKGETSIZE64	_IOR(0x12,114,size_t)
+#endif
+
+#ifndef BLKFLSBUF
+#define BLKFLSBUF	_IO(0x12,97)
+#endif
+
+#ifndef BLKDISCARD
+#define BLKDISCARD	_IO(0x12,119)
+#endif
+
+static inline int blockdev_invalidate_cache(struct fio_file *f)
+{
+	return ioctl(f->fd, BLKFLSBUF);
+}
+
+static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
+{
+	if (!ioctl(f->fd, BLKGETSIZE64, bytes))
+		return 0;
+
+	return errno;
+}
+
+static inline unsigned long long os_phys_mem(void)
+{
+	long pagesize, pages;
+
+	pagesize = sysconf(_SC_PAGESIZE);
+	pages = sysconf(_SC_PHYS_PAGES);
+	if (pages == -1 || pagesize == -1)
+		return 0;
+
+	return (unsigned long long) pages * (unsigned long long) pagesize;
+}
+
+typedef struct { unsigned short r[3]; } os_random_state_t;
+
+static inline void os_random_seed(unsigned long seed, os_random_state_t *rs)
+{
+	rs->r[0] = seed & 0xffff;
+	seed >>= 16;
+	rs->r[1] = seed & 0xffff;
+	seed >>= 16;
+	rs->r[2] = seed & 0xffff;
+	seed48(rs->r);
+}
+
+static inline long os_random_long(os_random_state_t *rs)
+{
+	return nrand48(rs->r);
+}
+
+#ifdef O_NOATIME
+#define FIO_O_NOATIME	O_NOATIME
+#else
+#define FIO_O_NOATIME	0
+#endif
+
+#if __BYTE_ORDER == __LITTLE_ENDIAN
+#define FIO_LITTLE_ENDIAN
+#elif __BYTE_ORDER == __BIG_ENDIAN
+#define FIO_BIG_ENDIAN
+#else
+#error "Unknown endianness"
+#endif
+
+#define fio_swap16(x)	__bswap_16(x)
+#define fio_swap32(x)	__bswap_32(x)
+#define fio_swap64(x)	__bswap_64(x)
+
+#define CACHE_LINE_FILE	\
+	"/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size"
+
+static inline int arch_cache_line_size(void)
+{
+	char size[32];
+	int fd, ret;
+
+	fd = open(CACHE_LINE_FILE, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	ret = read(fd, size, sizeof(size));
+
+	close(fd);
+
+	if (ret <= 0)
+		return -1;
+	else
+		return atoi(size);
+}
+
+static inline unsigned long long get_fs_size(const char *path)
+{
+	unsigned long long ret;
+	struct statfs s;
+
+	if (statfs(path, &s) < 0)
+		return -1ULL;
+
+	ret = s.f_bsize;
+	ret *= (unsigned long long) s.f_bfree;
+	return ret;
+}
+
+static inline int os_trim(int fd, unsigned long long start,
+			  unsigned long long len)
+{
+	uint64_t range[2];
+
+	range[0] = start;
+	range[1] = len;
+
+	if (!ioctl(fd, BLKDISCARD, range))
+		return 0;
+
+	return errno;
+}
+
+#endif
diff --git a/os/os.h b/os/os.h
index f783e92..e150284 100644
--- a/os/os.h
+++ b/os/os.h
@@ -17,11 +17,14 @@ enum {
 	os_netbsd,
 	os_solaris,
 	os_windows,
+	os_android,
 
 	os_nr,
 };
 
-#if defined(__linux__)
+#if defined(__ANDROID__)
+#include "os-android.h"
+#elif defined(__linux__)
 #include "os-linux.h"
 #elif defined(__FreeBSD__)
 #include "os-freebsd.h"
@@ -66,7 +69,14 @@ typedef struct aiocb os_aiocb_t;
 #endif
 
 #ifndef FIO_HAVE_FADVISE
-#define posix_fadvise(fd, off, len, advice)	(0)
+static inline int posix_fadvise(int fd, int off, int len, int advice)
+{
+	(void)fd;
+	(void)off;
+	(void)len;
+	(void)advice;
+	return 0;
+}
 
 #ifndef POSIX_FADV_DONTNEED
 #define POSIX_FADV_DONTNEED	(0)
@@ -171,6 +181,7 @@ static inline uint64_t fio_swap64(uint64_t val)
 }
 #endif
 
+#ifndef FIO_HAVE_BYTEORDER_FUNCS
 #ifdef FIO_LITTLE_ENDIAN
 #define __le16_to_cpu(x)		(x)
 #define __le32_to_cpu(x)		(x)
@@ -186,6 +197,7 @@ static inline uint64_t fio_swap64(uint64_t val)
 #define __cpu_to_le32(x)		fio_swap32(x)
 #define __cpu_to_le64(x)		fio_swap64(x)
 #endif
+#endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
 #define le16_to_cpu(val) ({			\
 	uint16_t *__val = &(val);		\

--------------080402080200000605050902--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


