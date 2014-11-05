Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035AbaKENAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 5 Nov 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xm0Bw-0006yW-TP
	for fio@vger.kernel.org; Wed, 05 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141105130003.6BD9D4012D@lyth.info>
Date: Wed,  5 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d904145c8b93f35e8a71d12d29a96a11f96f75e1:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-10-30 17:16:32 -0600)

are available in the git repository at:


  git://git.kernel.dk/fio.git master

for you to fetch changes up to 239b2882f467676b232e9e20b72c287b77bd3daa:

  Add basic DragonFly support (2014-11-04 19:53:04 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Add basic DragonFly support

 Makefile          |    4 ++++
 libfio.c          |    1 +
 os/os-dragonfly.h |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 os/os.h           |    3 +++
 4 files changed, 69 insertions(+)
 create mode 100644 os/os-dragonfly.h

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 55a93fc..8a28f62 100644
--- a/Makefile
+++ b/Makefile
@@ -136,6 +136,10 @@ ifeq ($(CONFIG_TARGET_OS), NetBSD)
   LIBS	 += -lpthread -lrt
   LDFLAGS += -rdynamic
 endif
+ifeq ($(CONFIG_TARGET_OS), DragonFly)
+  LIBS	 += -lpthread -lrt
+  LDFLAGS += -rdynamic
+endif
 ifeq ($(CONFIG_TARGET_OS), AIX)
   LIBS	 += -lpthread -ldl -lrt
   CPPFLAGS += -D_LARGE_FILES -D__ppc__
diff --git a/libfio.c b/libfio.c
index 1abf39a..57ce725 100644
--- a/libfio.c
+++ b/libfio.c
@@ -58,6 +58,7 @@ static const char *fio_os_strings[os_nr] = {
 	"Solaris",
 	"Windows",
 	"Android",
+	"DragonFly",
 };
 
 static const char *fio_arch_strings[arch_nr] = {
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
new file mode 100644
index 0000000..cc3de31
--- /dev/null
+++ b/os/os-dragonfly.h
@@ -0,0 +1,61 @@
+#ifndef FIO_OS_DRAGONFLY_H
+#define FIO_OS_DRAGONFLY_H
+
+#define	FIO_OS	os_dragonfly
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
+#include "../file.h"
+
+#define FIO_HAVE_ODIRECT
+#define FIO_USE_GENERIC_BDEV_SIZE
+#define FIO_USE_GENERIC_RAND
+#define FIO_USE_GENERIC_INIT_RANDOM_STATE
+#define FIO_HAVE_GETTID
+
+#undef	FIO_HAVE_CPU_AFFINITY	/* XXX notyet */
+
+#define OS_MAP_ANON		MAP_ANON
+
+#ifndef PTHREAD_STACK_MIN
+#define PTHREAD_STACK_MIN 4096
+#endif
+
+#define fio_swap16(x)	bswap16(x)
+#define fio_swap32(x)	bswap32(x)
+#define fio_swap64(x)	bswap64(x)
+
+typedef off_t off64_t;
+
+static inline int blockdev_invalidate_cache(struct fio_file *f)
+{
+	return EINVAL;
+}
+
+static inline unsigned long long os_phys_mem(void)
+{
+	int mib[2] = { CTL_HW, HW_PHYSMEM };
+	uint64_t mem;
+	size_t len = sizeof(mem);
+
+	sysctl(mib, 2, &mem, &len, NULL, 0);
+	return mem;
+}
+
+static inline int gettid(void)
+{
+	return (int) lwp_gettid();
+}
+
+#ifdef MADV_FREE
+#define FIO_MADV_FREE	MADV_FREE
+#endif
+
+#endif
diff --git a/os/os.h b/os/os.h
index df706ab..7cb8121 100644
--- a/os/os.h
+++ b/os/os.h
@@ -21,6 +21,7 @@ enum {
 	os_solaris,
 	os_windows,
 	os_android,
+	os_dragonfly,
 
 	os_nr,
 };
@@ -45,6 +46,8 @@ enum {
 #include "os-hpux.h"
 #elif defined(WIN32)
 #include "os-windows.h"
+#elif defined (__DragonFly__)
+#include "os-dragonfly.h"
 #else
 #error "unsupported os"
 #endif
