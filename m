Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 4/7] Use ENOTSUP if OS doesn't support blkdev page cache invalidation
Date: Mon, 13 Mar 2017 20:15:00 +0200
Message-Id: <20170313181503.33322-4-tkusumi@tuxera.com>
In-Reply-To: <20170313181503.33322-1-tkusumi@tuxera.com>
References: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

The return value of blockdev_invalidate_cache() has been platform
dependent (some pretend success, others return EINVAL) while Linux
is the only one actually supports this via Linux specific ioctl.

This commit makes all the rest return a consistent value ENOTSUP,
so __file_invalidate_cache() prints a blkdev invalidation failure
message that is consistent and makes sense.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c       | 5 ++++-
 os/os-aix.h       | 2 +-
 os/os-dragonfly.h | 2 +-
 os/os-freebsd.h   | 2 +-
 os/os-hpux.h      | 2 +-
 os/os-mac.h       | 2 +-
 os/os-netbsd.h    | 2 +-
 os/os-openbsd.h   | 2 +-
 os/os-solaris.h   | 2 +-
 os/os-windows.h   | 4 +---
 10 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 085d0c8..b04fb3e 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -479,6 +479,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		}
 		if (ret < 0)
 			errval = errno;
+		else if (ret) /* probably not supported */
+			errval = ret;
 	} else if (f->filetype == FIO_TYPE_CHAR ||
 		   f->filetype == FIO_TYPE_PIPE) {
 		dprint(FD_IO, "invalidate not supported %s\n", f->file_name);
@@ -492,7 +494,8 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	 * continue on our way.
 	 */
 	if (errval)
-		log_info("fio: cache invalidation of %s failed: %s\n", f->file_name, strerror(errval));
+		log_info("fio: cache invalidation of %s failed: %s\n",
+			 f->file_name, strerror(errval));
 
 	return 0;
 
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
index 9d1af3b..c7863b5 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -82,7 +82,7 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 
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
-- 
2.9.3


