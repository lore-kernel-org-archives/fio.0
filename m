Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 04/15] Add FIO_HAVE_BLKDEV_INVALIDATE_CACHE to selectively support pagecache invalidation
Date: Wed, 27 Jul 2016 22:37:09 +0900
Message-Id: <1469626640-13335-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Most kernels either don't provide a way to invalidate the cache
or don't need to provide one as "block device" no longer exist
as a file type after being replaced by character device.
Linux (incl Android) is the only supported OS that actually does
something via ioctl.

This commit adds FIO_HAVE_BLKDEV_INVALIDATE_CACHE. If this macro
is undefined, cache invalidation for block device isn't supported.
Only Linux supports it as mentioned above. It's better to do this
like other OS specific features, because having blockdev_invalidate_cache()
implementation which only pretends as if it has invalidated cache
(by returning either 0 or EINVAL) could be misleading for users.

The drawback is this commit requires users to fix config files
(remove invalidate=) in order to use them on other platforms
that were portable till then.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 HOWTO             | 2 +-
 fio.1             | 1 +
 options.c         | 9 +++++++++
 os/os-aix.h       | 5 -----
 os/os-android.h   | 1 +
 os/os-dragonfly.h | 5 -----
 os/os-freebsd.h   | 5 -----
 os/os-hpux.h      | 5 -----
 os/os-linux.h     | 1 +
 os/os-mac.h       | 5 -----
 os/os-netbsd.h    | 5 -----
 os/os-openbsd.h   | 5 -----
 os/os-solaris.h   | 5 -----
 os/os-windows.h   | 7 -------
 os/os.h           | 7 +++++++
 15 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/HOWTO b/HOWTO
index ab25cb2..ca114a4 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1211,7 +1211,7 @@ ramp_time=time	If set, fio will run the specified workload for this amount
 		or runtime is specified.
 
 invalidate=bool	Invalidate the buffer/page cache parts for this file prior
-		to starting io. Defaults to true.
+		to starting io. Defaults to true. Only supported on Linux.
 
 sync=bool	Use sync io for buffered writes. For the majority of the
 		io engines, this means using O_SYNC.
diff --git a/fio.1 b/fio.1
index e89c3d1..ac8e205 100644
--- a/fio.1
+++ b/fio.1
@@ -1138,6 +1138,7 @@ increase the total runtime if a special timeout or runtime is specified.
 .TP
 .BI invalidate \fR=\fPbool
 Invalidate buffer-cache for the file prior to starting I/O.  Default: true.
+Only supported on Linux.
 .TP
 .BI sync \fR=\fPbool
 Use synchronous I/O for buffered writes.  For the majority of I/O engines,
diff --git a/options.c b/options.c
index 4461643..df28a19 100644
--- a/options.c
+++ b/options.c
@@ -3214,6 +3214,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_LATPROF,
 	},
+#ifdef FIO_HAVE_BLKDEV_INVALIDATE_CACHE
 	{
 		.name	= "invalidate",
 		.lname	= "Cache invalidate",
@@ -3224,6 +3225,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_TYPE,
 	},
+#else
+	{
+		.name	= "invalidate",
+		.lname	= "Cache invalidate",
+		.type	= FIO_OPT_UNSUPPORTED,
+		.help	= "Your platform does not support buffer/page cache invalidation",
+	},
+#endif
 	{
 		.name	= "sync",
 		.lname	= "Synchronous I/O",
diff --git a/os/os-aix.h b/os/os-aix.h
index 3d67765..ec9d4c2 100644
--- a/os/os-aix.h
+++ b/os/os-aix.h
@@ -21,11 +21,6 @@
 
 #define FIO_USE_GENERIC_SWAP
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	struct devinfo info;
diff --git a/os/os-android.h b/os/os-android.h
index cdae703..0650137 100644
--- a/os/os-android.h
+++ b/os/os-android.h
@@ -27,6 +27,7 @@
 #define FIO_HAVE_ODIRECT
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_BLKTRACE
+#define FIO_HAVE_BLKDEV_INVALIDATE_CACHE
 #define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CL_SIZE
 #define FIO_HAVE_FS_STAT
diff --git a/os/os-dragonfly.h b/os/os-dragonfly.h
index c799817..d2ec113 100644
--- a/os/os-dragonfly.h
+++ b/os/os-dragonfly.h
@@ -181,11 +181,6 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 	return blockdev_size(f, bytes);
 }
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	int mib[2] = { CTL_HW, HW_PHYSMEM };
diff --git a/os/os-freebsd.h b/os/os-freebsd.h
index ac408c9..4a345fb 100644
--- a/os/os-freebsd.h
+++ b/os/os-freebsd.h
@@ -79,11 +79,6 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 	return blockdev_size(f, bytes);
 }
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	int mib[2] = { CTL_HW, HW_PHYSMEM };
diff --git a/os/os-hpux.h b/os/os-hpux.h
index 82acd11..c1bc968 100644
--- a/os/os-hpux.h
+++ b/os/os-hpux.h
@@ -42,11 +42,6 @@
 #define FIO_OS_HAVE_AIOCB_TYPEDEF
 typedef struct aiocb64 os_aiocb_t;
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline int blockdev_size(struct fio_file *f, unsigned long long *bytes)
 {
 	disk_describe_type_ext_t dext;
diff --git a/os/os-linux.h b/os/os-linux.h
index 06235ab..129774a 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -32,6 +32,7 @@
 #define FIO_HAVE_HUGETLB
 #define FIO_HAVE_RAWBIND
 #define FIO_HAVE_BLKTRACE
+#define FIO_HAVE_BLKDEV_INVALIDATE_CACHE
 #define FIO_HAVE_PSHARED_MUTEX
 #define FIO_HAVE_CL_SIZE
 #define FIO_HAVE_CGROUPS
diff --git a/os/os-mac.h b/os/os-mac.h
index 76d388e..035bdc7 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -73,11 +73,6 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 	return 0;
 }
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	int mib[2] = { CTL_HW, HW_PHYSMEM };
diff --git a/os/os-netbsd.h b/os/os-netbsd.h
index 4b0269e..71dd683 100644
--- a/os/os-netbsd.h
+++ b/os/os-netbsd.h
@@ -35,11 +35,6 @@
 
 typedef off_t off64_t;
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	int mib[2] = { CTL_HW, HW_PHYSMEM64 };
diff --git a/os/os-openbsd.h b/os/os-openbsd.h
index b1d8e83..5f8a3eb 100644
--- a/os/os-openbsd.h
+++ b/os/os-openbsd.h
@@ -33,11 +33,6 @@
 
 typedef off_t off64_t;
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return EINVAL;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	int mib[2] = { CTL_HW, HW_PHYSMEM64 };
diff --git a/os/os-solaris.h b/os/os-solaris.h
index 5b78cc2..1ac0b2e 100644
--- a/os/os-solaris.h
+++ b/os/os-solaris.h
@@ -59,11 +59,6 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 	return 0;
 }
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	return 0;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	return 0;
diff --git a/os/os-windows.h b/os/os-windows.h
index 616ad43..b388bad 100644
--- a/os/os-windows.h
+++ b/os/os-windows.h
@@ -150,13 +150,6 @@ static inline int chardev_size(struct fio_file *f, unsigned long long *bytes)
 	return blockdev_size(f, bytes);
 }
 
-static inline int blockdev_invalidate_cache(struct fio_file *f)
-{
-	/* There's no way to invalidate the cache in Windows
-	 * so just pretend to succeed */
-	return 0;
-}
-
 static inline unsigned long long os_phys_mem(void)
 {
 	long pagesize, pages;
diff --git a/os/os.h b/os/os.h
index 4f267c2..b6fdfb2 100644
--- a/os/os.h
+++ b/os/os.h
@@ -265,6 +265,13 @@ static inline int load_blktrace(struct thread_data *td, const char *fname,
 }
 #endif
 
+#ifndef FIO_HAVE_BLKDEV_INVALIDATE_CACHE
+static inline int blockdev_invalidate_cache(struct fio_file *f)
+{
+	return 1; /* The caller cares if it's negative or not */
+}
+#endif
+
 #define FIO_DEF_CL_SIZE		128
 
 static inline int os_cache_line_size(void)
-- 
2.5.5


