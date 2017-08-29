Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] change os_trim() prototype not to use int fd
Date: Wed, 30 Aug 2017 00:12:16 +0300
Message-Id: <20170829211216.42347-7-tkusumi@tuxera.com>
In-Reply-To: <20170829211216.42347-1-tkusumi@tuxera.com>
References: <20170829211216.42347-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is the same as the previous commit. The offset and length are
universal regardless of platforms, but int fd is not, thus it should
take struct fio_file*.

In fact, other fd related functions under os/ don't take int fd for
portability even if some of them work fine with int fd at the moment.

(OS headers basically (should)have no dependencies on fio functions
and structures, but struct fio_file is the only exception.)

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c            | 2 +-
 os/os-android.h   | 4 ++--
 os/os-dragonfly.h | 4 ++--
 os/os-freebsd.h   | 4 ++--
 os/os-linux.h     | 4 ++--
 5 files changed, 9 insertions(+), 9 deletions(-)

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
-- 
2.9.5


