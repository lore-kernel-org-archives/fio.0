Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55326 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdCNMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Mar 2017 08:00:11 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cnl7Z-0003uK-Rt
        for fio@vger.kernel.org; Tue, 14 Mar 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170314120002.339232C1B31@kernel.dk>
Date: Tue, 14 Mar 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e9bd687d147d5aee710d56854524bbada5a34650:

  Makefile: make test target use thread (2017-03-12 21:04:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1df28a3960734e1e00cb2e5fe0e261fcba30f7c7:

  Conditionally enable FIO_HAVE_PSHARED_MUTEX on FreeBSD (2017-03-13 12:54:18 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      rbd: don't log version to stdout

Tomohiro Kusumi (7):
      Make check_mount_writes() test appropriate device types
      HOWTO: Add note/exception on allow_mounted_write=
      Minor fixup for page cache invalidation debug prints
      Use ENOTSUP if OS doesn't support blkdev page cache invalidation
      Fix errval variable to be positive errno value
      manpage: Add URL links to HOWTO/README
      Conditionally enable FIO_HAVE_PSHARED_MUTEX on FreeBSD

 HOWTO             |  3 ++-
 backend.c         |  8 ++++++++
 engines/rbd.c     |  5 -----
 filesetup.c       | 20 ++++++++++++++------
 fio.1             |  9 ++++++++-
 os/os-aix.h       |  2 +-
 os/os-dragonfly.h |  2 +-
 os/os-freebsd.h   |  6 +++++-
 os/os-hpux.h      |  2 +-
 os/os-mac.h       |  2 +-
 os/os-netbsd.h    |  2 +-
 os/os-openbsd.h   |  2 +-
 os/os-solaris.h   |  2 +-
 os/os-windows.h   |  4 +---
 14 files changed, 45 insertions(+), 24 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c2c6509..e376ea5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -886,7 +886,8 @@ Target file/device
 	If this isn't set, fio will abort jobs that are destructive (e.g. that write)
 	to what appears to be a mounted device or partition. This should help catch
 	creating inadvertently destructive tests, not realizing that the test will
-	destroy data on the mounted file system. Default: false.
+	destroy data on the mounted file system. Note that some platforms don't allow
+	writing against a mounted device regardless of this option. Default: false.
 
 .. option:: pre_read=bool
 
diff --git a/backend.c b/backend.c
index 2e8a994..b61de7c 100644
--- a/backend.c
+++ b/backend.c
@@ -2056,8 +2056,16 @@ static bool check_mount_writes(struct thread_data *td)
 	if (!td_write(td) || td->o.allow_mounted_write)
 		return false;
 
+	/*
+	 * If FIO_HAVE_CHARDEV_SIZE is defined, it's likely that chrdevs
+	 * are mkfs'd and mounted.
+	 */
 	for_each_file(td, f, i) {
+#ifdef FIO_HAVE_CHARDEV_SIZE
+		if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR)
+#else
 		if (f->filetype != FIO_TYPE_BLOCK)
+#endif
 			continue;
 		if (device_is_mounted(f->file_name))
 			goto mounted;
diff --git a/engines/rbd.c b/engines/rbd.c
index 62f0b2e..829e41a 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -566,13 +566,8 @@ static int fio_rbd_setup(struct thread_data *td)
 	rbd_image_info_t info;
 	struct fio_file *f;
 	struct rbd_data *rbd = NULL;
-	int major, minor, extra;
 	int r;
 
-	/* log version of librbd. No cluster connection required. */
-	rbd_version(&major, &minor, &extra);
-	log_info("rbd engine: RBD version: %d.%d.%d\n", major, minor, extra);
-
 	/* allocate engine specific structure to deal with librbd. */
 	r = _fio_setup_rbd_data(td, &rbd);
 	if (r) {
diff --git a/filesetup.c b/filesetup.c
index 4d0b127..f2e47b1 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -442,20 +442,22 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	if (len == -1ULL || off == -1ULL)
 		return 0;
 
-	dprint(FD_IO, "invalidate cache %s: %llu/%llu\n", f->file_name, off,
-								len);
-
 	if (td->io_ops->invalidate) {
+		dprint(FD_IO, "invalidate %s cache %s\n", td->io_ops->name,
+			f->file_name);
 		ret = td->io_ops->invalidate(td, f);
 		if (ret < 0)
-			errval = ret;
+			errval = -ret;
 	} else if (f->filetype == FIO_TYPE_FILE) {
+		dprint(FD_IO, "declare unneeded cache %s: %llu/%llu\n",
+			f->file_name, off, len);
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
 		if (ret)
 			errval = ret;
 	} else if (f->filetype == FIO_TYPE_BLOCK) {
 		int retry_count = 0;
 
+		dprint(FD_IO, "drop page cache %s\n", f->file_name);
 		ret = blockdev_invalidate_cache(f);
 		while (ret < 0 && errno == EAGAIN && retry_count++ < 25) {
 			/*
@@ -477,8 +479,13 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		}
 		if (ret < 0)
 			errval = errno;
-	} else if (f->filetype == FIO_TYPE_CHAR || f->filetype == FIO_TYPE_PIPE)
+		else if (ret) /* probably not supported */
+			errval = ret;
+	} else if (f->filetype == FIO_TYPE_CHAR ||
+		   f->filetype == FIO_TYPE_PIPE) {
+		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
 		ret = 0;
+	}
 
 	/*
 	 * Cache flushing isn't a fatal condition, and we know it will
@@ -487,7 +494,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	 * continue on our way.
 	 */
 	if (errval)
-		log_info("fio: cache invalidation of %s failed: %s\n", f->file_name, strerror(errval));
+		log_info("fio: cache invalidation of %s failed: %s\n",
+			 f->file_name, strerror(errval));
 
 	return 0;
 
diff --git a/fio.1 b/fio.1
index cc68dee..3348513 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "December 2016" "User Manual"
+.TH fio 1 "March 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -2584,3 +2584,10 @@ See \fBREADME\fR.
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
 Sample jobfiles are available in the \fBexamples\fR directory.
+.br
+These are typically located under /usr/share/doc/fio.
+
+\fBHOWTO\fR:  http://git.kernel.dk/?p=fio.git;a=blob_plain;f=HOWTO
+.br
+\fBREADME\fR: http://git.kernel.dk/?p=fio.git;a=blob_plain;f=README
+.br
diff --git a/os/os-aix.h b/os/os-aix.h
index 3d67765..bdc190a 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -23,7 +23,7 @@
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index 97452ca..8a116e6 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -184,7 +184,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index 9d1af3b..3d7dbe6 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -24,6 +24,10 @@
 #define FIO_HAVE_CPU_AFFINITY
 #define FIO_HAVE_SHM_ATTACH_REMOVED
 
+#if _POSIX_THREAD_PROCESS_SHARED > 0
+#define FIO_HAVE_PSHARED_MUTEX
+#endif
+
 #define OS_MAP_ANON		MAP_ANON
 
 #define fio_swap16(x)	bswap16(x)
@@ -82,7 +86,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 82acd11..1707ddd 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -44,7 +44,7 @@ typedef struct aiocb64 os_aiocb_t;
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
diff --git a/os/os-mac.h b/os/os-mac.h
index 0903a6f..7de36ea 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -77,7 +77,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 2133d7a..e6ba508 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -54,7 +54,7 @@ static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index 3b19483..7def432 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -53,7 +53,7 @@ static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return EINVAL;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 5b78cc2..73ad84a 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -61,7 +61,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	return 0;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
diff --git a/os/os-windows.h b/os/os-windows.h
index 616ad43..0c8c42d 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -152,9 +152,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
 static inline int blockdev_invalidate_cache(struct fio_file *f)
 {
-	/* There's no way to invalidate the cache in Windows
-	 * so just pretend to succeed */
-	return 0;
+	return ENOTSUP;
 }
 
 static inline unsigned long long os_phys_mem(void)
