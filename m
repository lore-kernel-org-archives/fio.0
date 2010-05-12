Return-Path: <yamamoto@valinux.co.jp>
Subject: fio netbsd support
Mime-Version: 1.0
Content-Type: Multipart/Mixed; boundary="Boundary-20100512172604-0056001"
Message-Id: <20100512082913.AA9657191C@kuma.localdomain>
Date: Wed, 12 May 2010 17:29:13 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
To: jens.axboe@oracle.com
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--Boundary-20100512172604-0056001
Content-Type: Text/Plain; charset=us-ascii

hi,

the attached patch is for preliminary support for netbsd.

YAMAMOTO Takashi

Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>

--Boundary-20100512172604-0056001
Content-Type: Text/Plain; charset=us-ascii
Content-Disposition: attachment; filename="a.diff"

diff --git a/Makefile.NetBSD b/Makefile.NetBSD
new file mode 100644
index 0000000..2fb089e
--- /dev/null
+++ b/Makefile.NetBSD
@@ -0,0 +1,75 @@
+CC	= gcc
+DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
+OPTFLAGS= -O2 -g $(EXTFLAGS)
+CFLAGS	= -Wwrite-strings -Wall -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 $(OPTFLAGS) $(DEBUGFLAGS) -rdynamic
+PROGS	= fio
+SCRIPTS = fio_generate_plots
+OBJS = gettime.o fio.o ioengines.o init.o stat.o log.o time.o filesetup.o \
+	eta.o verify.o memory.o io_u.o parse.o mutex.o options.o \
+	rbtree.o smalloc.o filehash.o helpers.o profile.o debug.o
+
+OBJS += crc/crc7.o
+OBJS += crc/crc16.o
+OBJS += crc/crc32.o
+OBJS += crc/crc32c.o
+OBJS += crc/crc32c-intel.o
+OBJS += crc/crc64.o
+OBJS += crc/sha1.o
+OBJS += crc/sha256.o
+OBJS += crc/sha512.o
+OBJS += crc/md5.o
+
+OBJS += engines/cpu.o
+OBJS += engines/mmap.o
+OBJS += engines/posixaio.o
+OBJS += engines/sync.o
+OBJS += engines/null.o
+OBJS += engines/net.o
+
+SOURCE = eta.c filehash.c filesetup.c fio.c gettime.c init.c ioengines.c \
+	 io_u.c log.c memory.c mutex.c options.c parse.c rbtree.c smalloc.c \
+	 stat.c parse.c crc/*.c engines/cpu.c engines/mmap.c \
+	 engines/posixaio.c engines/sync.c engines/null.c engines/net.c \
+	 *.h arch/*.h compiler/*.h crc/*.h lib/*.h \
+	 os/indirect.h os/kcompat.h os/os-freebsd.h os/os.h os/syslet.h
+
+ifneq ($(findstring $(MAKEFLAGS),s),s)
+ifndef V
+	QUIET_CC	= @echo '   ' CC $@;
+	QUIET_DEP	= @echo '   ' DEP $@;
+endif
+endif
+
+INSTALL = install
+prefix = /usr/local
+bindir = $(prefix)/bin
+mandir = $(prefix)/man
+
+%.o: %.c
+	$(QUIET_CC)$(CC) -o $*.o -c $(CFLAGS) $<
+fio: $(OBJS)
+	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(EXTLIBS) -lpthread -lm -lrt
+
+depend:
+	$(QUIET_DEP)$(CC) -MM $(ALL_CFLAGS) $(SOURCE) 1> .depend
+
+$(PROGS): depend
+
+all: depend $(PROGS) $(SCRIPTS)
+
+clean:
+	-rm -f .depend cscope.out $(OBJS) $(PROGS) core.* core
+
+cscope:
+	@cscope -b
+
+install: $(PROGS) $(SCRIPTS)
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(PROGS) $(SCRIPTS) $(DESTDIR)$(bindir)
+	$(INSTALL) -m 755 -d $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 fio.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
+
+ifneq ($(wildcard .depend),)
+include .depend
+endif
diff --git a/mutex.c b/mutex.c
index e148430..abe073f 100644
--- a/mutex.c
+++ b/mutex.c
@@ -65,14 +65,18 @@ struct fio_mutex *fio_mutex_init(int value)
 		log_err("pthread_mutexattr_init: %s\n", strerror(ret));
 		goto err;
 	}
+#ifdef FIO_HAVE_PSHARED_MUTEX
 	ret = pthread_mutexattr_setpshared(&attr, mflag);
 	if (ret) {
 		log_err("pthread_mutexattr_setpshared: %s\n", strerror(ret));
 		goto err;
 	}
+#endif
 
 	pthread_condattr_init(&cond);
+#ifdef FIO_HAVE_PSHARED_MUTEX
 	pthread_condattr_setpshared(&cond, mflag);
+#endif
 	pthread_cond_init(&mutex->cond, &cond);
 
 	ret = pthread_mutex_init(&mutex->lock, &attr);
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 8d965aa..d1313e8 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -11,8 +11,6 @@
 
 #define OS_MAP_ANON		MAP_ANON
 
-typedef unsigned long os_cpu_mask_t;
-
 static inline int blockdev_invalidate_cache(int fd)
 {
 	return EINVAL;
diff --git a/os/os-mac.h b/os/os-mac.h
index be25458..1b786f8 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -18,7 +18,6 @@
 
 #define OS_MAP_ANON		MAP_ANON
 
-typedef unsigned long os_cpu_mask_t;
 typedef unsigned int clockid_t;
 typedef off_t off64_t;
 
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
new file mode 100644
index 0000000..70d2958
--- /dev/null
+++ b/os/os-netbsd.h
@@ -0,0 +1,50 @@
+#ifndef FIO_OS_NETBSD_H
+#define FIO_OS_NETBSD_H
+
+#include <errno.h>
+#include <sys/param.h>
+/* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
+#define	rb_node	_rb_node
+#include <sys/sysctl.h>
+#undef rb_node
+#undef rb_left
+#undef rb_right
+
+#define FIO_HAVE_POSIXAIO
+#define FIO_HAVE_FADVISE
+#define	fadvise	posix_fadvise	/* XXX NetBSD doesn't have fadvise */
+#define FIO_HAVE_ODIRECT
+#define FIO_HAVE_STRSEP
+#define FIO_HAVE_FDATASYNC
+#define FIO_USE_GENERIC_BDEV_SIZE
+#define FIO_USE_GENERIC_RAND
+
+#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+
+#define OS_MAP_ANON		MAP_ANON
+
+typedef off_t off64_t;
+
+static inline int blockdev_invalidate_cache(int fd)
+{
+	return EINVAL;
+}
+
+static inline unsigned long long os_phys_mem(void)
+{
+	int mib[2] = { CTL_HW, HW_PHYSMEM64 };
+	uint64_t mem;
+	size_t len = sizeof(mem);
+
+	sysctl(mib, 2, &mem, &len, NULL, 0);
+	return mem;
+}
+
+#ifdef MADV_FREE
+#define FIO_MADV_FREE	MADV_FREE
+#endif
+
+/* XXX NetBSD doesn't have getopt_long_only */
+#define	getopt_long_only	getopt_long
+
+#endif
diff --git a/os/os.h b/os/os.h
index d128f02..b7fce80 100644
--- a/os/os.h
+++ b/os/os.h
@@ -8,6 +8,8 @@
 #include "os-linux.h"
 #elif defined(__FreeBSD__)
 #include "os-freebsd.h"
+#elif defined(__NetBSD__)
+#include "os-netbsd.h"
 #elif defined(__sun__)
 #include "os-solaris.h"
 #elif defined(__APPLE__)
@@ -48,6 +50,7 @@
 #define fio_getaffinity(pid, mask)	do { } while (0)
 #define fio_cpu_clear(mask, cpu)	do { } while (0)
 #define fio_cpuset_exit(mask)		(-1)
+typedef unsigned long os_cpu_mask_t;
 #endif
 
 #ifndef FIO_HAVE_IOPRIO

--Boundary-20100512172604-0056001--


