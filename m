Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60206 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751323AbdH3MAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Aug 2017 08:00:19 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dn1fP-0007oH-Bn
        for fio@vger.kernel.org; Wed, 30 Aug 2017 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170830120002.3F1BB2C0167@kernel.dk>
Date: Wed, 30 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a4befdc605bc253f258a99e9f0d037147775035e:

  Merge branch 'direct_layout_fix' of https://github.com/sitsofe/fio (2017-08-28 09:57:30 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 63463983ce10e9678c5ad309608630eea873b4df:

  Merge branch 'asmfix' of https://github.com/oohal/fio (2017-08-29 15:35:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'asmfix' of https://github.com/oohal/fio

Oliver O'Halloran (1):
      arch/ppc: Fix get_cpu_clock asm clobber list

Tomohiro Kusumi (6):
      cleanup NetBSD/OpenBSD header
      HOWTO: add OpenBSD to direct I/O unsupported platform
      add ifdef __sun__ for Solaris specific code
      filesetup: add non O_DIRECT direct I/O support for initial layout setup
      change fio_set_odirect() prototype not to use int fd
      change os_trim() prototype not to use int fd

 HOWTO             |  2 +-
 arch/arch-ppc.h   |  3 ++-
 file.h            |  1 +
 filesetup.c       | 31 +++++++++++++++++++++++++++++++
 fio.1             |  2 +-
 io_u.c            |  2 +-
 ioengines.c       | 22 ++--------------------
 os/os-android.h   |  4 ++--
 os/os-dragonfly.h |  4 ++--
 os/os-freebsd.h   |  4 ++--
 os/os-linux.h     |  4 ++--
 os/os-mac.h       |  4 ++--
 os/os-netbsd.h    |  6 ++----
 os/os-openbsd.h   |  6 ++----
 os/os-solaris.h   |  4 ++--
 15 files changed, 55 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index f36d4a7..3a720c3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -947,7 +947,7 @@ I/O type
 .. option:: direct=bool
 
 	If value is true, use non-buffered I/O. This is usually O_DIRECT. Note that
-	ZFS on Solaris doesn't support direct I/O.  On Windows the synchronous
+	OpenBSD and ZFS on Solaris don't support direct I/O.  On Windows the synchronous
 	ioengines don't support direct I/O.  Default: false.
 
 .. option:: atomic=bool
diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index ba452b1..804d596 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -62,7 +62,8 @@ static inline unsigned long long get_cpu_clock(void)
 		"	cmpwi %0,0;\n"
 		"	beq-  90b;\n"
 	: "=r" (rval)
-	: "i" (SPRN_TBRL));
+	: "i" (SPRN_TBRL)
+	: "cr0");
 
 	return rval;
 }
diff --git a/file.h b/file.h
index 84daa5f..ad8802d 100644
--- a/file.h
+++ b/file.h
@@ -211,5 +211,6 @@ extern void filesetup_mem_free(void);
 extern void fio_file_reset(struct thread_data *, struct fio_file *);
 extern bool fio_files_done(struct thread_data *);
 extern bool exists_and_not_regfile(const char *);
+extern int fio_set_directio(struct thread_data *, struct fio_file *);
 
 #endif
diff --git a/filesetup.c b/filesetup.c
index a6a94ee..c4240d2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -196,6 +196,9 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
+	if (td->o.odirect && !OS_O_DIRECT && fio_set_directio(td, f))
+		goto err;
+
 	left = f->real_file_size;
 	bs = td->o.max_bs[DDIR_WRITE];
 	if (bs > left)
@@ -1852,3 +1855,31 @@ void filesetup_mem_free(void)
 {
 	free_already_allocated();
 }
+
+/*
+ * This function is for platforms which support direct I/O but not O_DIRECT.
+ */
+int fio_set_directio(struct thread_data *td, struct fio_file *f)
+{
+#ifdef FIO_OS_DIRECTIO
+	int ret = fio_set_odirect(f);
+
+	if (ret) {
+		td_verror(td, ret, "fio_set_directio");
+#if defined(__sun__)
+		if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
+			log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
+		} else {
+			log_err("fio: the file system does not seem to support direct IO\n");
+		}
+#else
+		log_err("fio: the file system does not seem to support direct IO\n");
+#endif
+		return -1;
+	}
+
+	return 0;
+#else
+	return -1;
+#endif
+}
diff --git a/fio.1 b/fio.1
index b8b3da2..5b63dfd 100644
--- a/fio.1
+++ b/fio.1
@@ -717,7 +717,7 @@ read. The two zone options can be used to only do I/O on zones of a file.
 .TP
 .BI direct \fR=\fPbool
 If value is true, use non\-buffered I/O. This is usually O_DIRECT. Note that
-ZFS on Solaris doesn't support direct I/O. On Windows the synchronous
+OpenBSD and ZFS on Solaris don't support direct I/O. On Windows the synchronous
 ioengines don't support direct I/O. Default: false.
 .TP
 .BI atomic \fR=\fPbool
diff --git a/io_u.c b/io_u.c
index ed8e84a..db043e4 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2188,7 +2188,7 @@ int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
 	struct fio_file *f = io_u->file;
 	int ret;
 
-	ret = os_trim(f->fd, io_u->offset, io_u->xfer_buflen);
+	ret = os_trim(f, io_u->offset, io_u->xfer_buflen);
 	if (!ret)
 		return io_u->xfer_buflen;
 
diff --git a/ioengines.c b/ioengines.c
index 6e6e3de..919781c 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -495,26 +495,8 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	}
 #endif
 
-#ifdef FIO_OS_DIRECTIO
-	/*
-	 * Some OS's have a distinct call to mark the file non-buffered,
-	 * instead of using O_DIRECT (Solaris)
-	 */
-	if (td->o.odirect) {
-		int ret = fio_set_odirect(f->fd);
-
-		if (ret) {
-			td_verror(td, ret, "fio_set_odirect");
-			if (ret == ENOTTY) { /* ENOTTY suggests RAW device or ZFS */
-				log_err("fio: doing directIO to RAW devices or ZFS not supported\n");
-			} else {
-				log_err("fio: the file system does not seem to support direct IO\n");
-			}
-
-			goto err;
-		}
-	}
-#endif
+	if (td->o.odirect && !OS_O_DIRECT && fio_set_directio(td, f))
+		goto err;
 
 done:
 	log_file(td, f, FIO_LOG_OPEN_FILE);
diff --git a/os/os-android.h b/os/os-android.h
index b217daa..bb590e4 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -274,7 +274,7 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
-static inline int os_trim(int fd, unsigned long long start,
+static inline int os_trim(struct fio_file *f, unsigned long long start,
 			  unsigned long long len)
 {
 	uint64_t range[2];
@@ -282,7 +282,7 @@ static inline int os_trim(int fd, unsigned long long start,
 	range[0] = start;
 	range[1] = len;
 
-	if (!ioctl(fd, BLKDISCARD, range))
+	if (!ioctl(f->fd, BLKDISCARD, range))
 		return 0;
 
 	return errno;
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 8d15833..423b236 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -216,7 +216,7 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
-static inline int os_trim(int fd, unsigned long long start,
+static inline int os_trim(struct fio_file *f, unsigned long long start,
 			  unsigned long long len)
 {
 	off_t range[2];
@@ -224,7 +224,7 @@ static inline int os_trim(int fd, unsigned long long start,
 	range[0] = start;
 	range[1] = len;
 
-	if (!ioctl(fd, IOCTLTRIM, range))
+	if (!ioctl(f->fd, IOCTLTRIM, range))
 		return 0;
 
 	return errno;
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index e6da286..4a7cdeb 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -117,7 +117,7 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
-static inline int os_trim(int fd, unsigned long long start,
+static inline int os_trim(struct fio_file *f, unsigned long long start,
 			  unsigned long long len)
 {
 	off_t range[2];
@@ -125,7 +125,7 @@ static inline int os_trim(int fd, unsigned long long start,
 	range[0] = start;
 	range[1] = len;
 
-	if (!ioctl(fd, DIOCGDELETE, range))
+	if (!ioctl(f->fd, DIOCGDELETE, range))
 		return 0;
 
 	return errno;
diff --git a/os/os-linux.h b/os/os-linux.h
index e7d600d..1ad6ebd 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -281,7 +281,7 @@ static inline unsigned long long get_fs_free_size(const char *path)
 	return ret;
 }
 
-static inline int os_trim(int fd, unsigned long long start,
+static inline int os_trim(struct fio_file *f, unsigned long long start,
 			  unsigned long long len)
 {
 	uint64_t range[2];
@@ -289,7 +289,7 @@ static inline int os_trim(int fd, unsigned long long start,
 	range[0] = start;
 	range[1] = len;
 
-	if (!ioctl(fd, BLKDISCARD, range))
+	if (!ioctl(f->fd, BLKDISCARD, range))
 		return 0;
 
 	return errno;
diff --git a/os/os-mac.h b/os/os-mac.h
index a1536c7..92a60ee 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -41,9 +41,9 @@ typedef unsigned int clockid_t;
 #endif
 
 #define FIO_OS_DIRECTIO
-static inline int fio_set_odirect(int fd)
+static inline int fio_set_odirect(struct fio_file *f)
 {
-	if (fcntl(fd, F_NOCACHE, 1) == -1)
+	if (fcntl(f->fd, F_NOCACHE, 1) == -1)
 		return errno;
 	return 0;
 }
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index eac76cf..682a11c 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -11,9 +11,9 @@
 #include <sys/dkio.h>
 #include <sys/disklabel.h>
 #include <sys/endian.h>
-/* XXX hack to avoid confilcts between rbtree.h and <sys/rb.h> */
-#define	rb_node	_rb_node
 #include <sys/sysctl.h>
+
+/* XXX hack to avoid confilcts between rbtree.h and <sys/rbtree.h> */
 #undef rb_node
 #undef rb_left
 #undef rb_right
@@ -26,8 +26,6 @@
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 675bf89..b4c02c9 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -11,23 +11,21 @@
 #include <sys/disklabel.h>
 #include <sys/endian.h>
 #include <sys/utsname.h>
-/* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #include <sys/sysctl.h>
+
+/* XXX hack to avoid conflicts between rbtree.h and <sys/tree.h> */
 #undef RB_BLACK
 #undef RB_RED
 #undef RB_ROOT
 
 #include "../file.h"
 
-#undef  FIO_HAVE_ODIRECT
 #define FIO_USE_GENERIC_RAND
 #define FIO_USE_GENERIC_INIT_RANDOM_STATE
 #define FIO_HAVE_FS_STAT
 #define FIO_HAVE_GETTID
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
-#undef	FIO_HAVE_CPU_AFFINITY	/* doesn't exist */
-
 #define OS_MAP_ANON		MAP_ANON
 
 #ifndef PTHREAD_STACK_MIN
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 8f8f53b..6af25d2 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -85,9 +85,9 @@ static inline long os_random_long(os_random_state_t *rs)
 
 #define FIO_OS_DIRECTIO
 extern int directio(int, int);
-static inline int fio_set_odirect(int fd)
+static inline int fio_set_odirect(struct fio_file *f)
 {
-	if (directio(fd, DIRECTIO_ON) < 0)
+	if (directio(f->fd, DIRECTIO_ON) < 0)
 		return errno;
 
 	return 0;
