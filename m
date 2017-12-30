Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60634 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750759AbdL3NAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 30 Dec 2017 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1eVGkF-0001ZN-8L
        for fio@vger.kernel.org; Sat, 30 Dec 2017 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171230130001.C7D3F2C009D@kernel.dk>
Date: Sat, 30 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e38feac48ffb7a45c847cabd31ab5eab7fe05a4e:

  Merge branch 'master' of https://github.com/yashi/fio (2017-12-28 08:35:11 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to df4bf1178ed773986129da6038961388af926971:

  log: fix bad < 0 check for unsigned (2017-12-29 08:45:22 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      log: fix bad < 0 check for unsigned

Robert Elliott (1):
      debug: make debug=io readable with multiple threads

Tomohiro Kusumi (1):
      lib/memcpy: fix warning on FreeBSD

 debug.c     | 11 +----------
 fio_time.h  |  1 +
 io_u.c      |  9 ++++-----
 io_u.h      | 15 ++++++++++-----
 ioengines.c |  3 ++-
 log.c       | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 log.h       |  1 +
 7 files changed, 70 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/debug.c b/debug.c
index 013cd53..2bee507 100644
--- a/debug.c
+++ b/debug.c
@@ -7,20 +7,11 @@
 void __dprint(int type, const char *str, ...)
 {
 	va_list args;
-	pid_t pid;
 
 	assert(type < FD_DEBUG_MAX);
 
-	pid = getpid();
-	if (fio_debug_jobp && *fio_debug_jobp != -1U
-	    && pid != *fio_debug_jobp)
-		return;
-
-	log_info("%-8s ", debug_levels[type].name);
-	log_info("%-5u ", (int) pid);
-
 	va_start(args, str);
-	log_valist(str, args);
+	log_prevalist(type, str, args);
 	va_end(args);
 }
 #endif
diff --git a/fio_time.h b/fio_time.h
index ee8087e..8b4bb25 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -2,6 +2,7 @@
 #define FIO_TIME_H
 
 #include <time.h>
+#include <sys/time.h>
 #include "lib/types.h"
 
 struct thread_data;
diff --git a/io_u.c b/io_u.c
index 42d98eb..852b98e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -971,9 +971,8 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->offset + io_u->buflen > io_u->file->real_file_size) {
-		dprint(FD_IO, "io_u %p, offset + buflen exceeds file size\n",
-			io_u);
-		dprint(FD_IO, "  offset=%llu/buflen=%lu > %llu\n",
+		dprint(FD_IO, "io_u %p, off=0x%llx + len=0x%lx exceeds file size=0x%llx\n",
+			io_u,
 			(unsigned long long) io_u->offset, io_u->buflen,
 			(unsigned long long) io_u->file->real_file_size);
 		return 1;
@@ -986,7 +985,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		mark_random_map(td, io_u);
 
 out:
-	dprint_io_u(io_u, "fill_io_u");
+	dprint_io_u(io_u, "fill");
 	td->zone_bytes += io_u->buflen;
 	return 0;
 }
@@ -1939,7 +1938,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	enum fio_ddir ddir = io_u->ddir;
 	struct fio_file *f = io_u->file;
 
-	dprint_io_u(io_u, "io complete");
+	dprint_io_u(io_u, "complete");
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
 	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
diff --git a/io_u.h b/io_u.h
index b228e2e..da25efb 100644
--- a/io_u.h
+++ b/io_u.h
@@ -152,12 +152,17 @@ static inline void dprint_io_u(struct io_u *io_u, const char *p)
 {
 	struct fio_file *f = io_u->file;
 
-	dprint(FD_IO, "%s: io_u %p: off=%llu/len=%lu/ddir=%d", p, io_u,
-					(unsigned long long) io_u->offset,
-					io_u->buflen, io_u->ddir);
 	if (f)
-		dprint(FD_IO, "/%s", f->file_name);
-	dprint(FD_IO, "\n");
+		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d,file=%s\n",
+				p, io_u,
+				(unsigned long long) io_u->offset,
+				io_u->buflen, io_u->ddir,
+				f->file_name);
+	else
+		dprint(FD_IO, "%s: io_u %p: off=0x%llx,len=0x%lx,ddir=%d\n",
+				p, io_u,
+				(unsigned long long) io_u->offset,
+				io_u->buflen, io_u->ddir);
 }
 #else
 #define dprint_io_u(io_u, p)
diff --git a/ioengines.c b/ioengines.c
index cec0c76..fb475e9 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -224,7 +224,8 @@ int td_io_prep(struct thread_data *td, struct io_u *io_u)
 	if (td->io_ops->prep) {
 		int ret = td->io_ops->prep(td, io_u);
 
-		dprint(FD_IO, "->prep(%p)=%d\n", io_u, ret);
+		dprint(FD_IO, "prep: io_u %p: ret=%d\n", io_u, ret);
+
 		if (ret)
 			unlock_file(td, io_u->file);
 		return ret;
diff --git a/log.c b/log.c
index 95351d5..a327f6a 100644
--- a/log.c
+++ b/log.c
@@ -36,6 +36,8 @@ static size_t valist_to_buf(char **buffer, const char *fmt, va_list src_args)
 
 	do {
 		*buffer = calloc(1, cur);
+		if (!*buffer)
+			return 0;
 
 		va_copy(args, src_args);
 		len = vsnprintf(*buffer, cur, fmt, args);
@@ -51,6 +53,33 @@ static size_t valist_to_buf(char **buffer, const char *fmt, va_list src_args)
 	return len;
 }
 
+/* allocate buffer, fill with prefix string followed by vararg string */
+static size_t prevalist_to_buf(char **buffer, const char *pre, int prelen,
+		const char *fmt, va_list src_args)
+{
+	size_t len, cur = LOG_START_SZ;
+	va_list args;
+
+	do {
+		*buffer = calloc(1, cur);
+		if (!*buffer)
+			return 0;
+
+		va_copy(args, src_args);
+		memcpy(*buffer, pre, prelen);
+		len = prelen + vsnprintf(*buffer + prelen, cur - prelen, fmt, args);
+		va_end(args);
+
+		if (len < cur)
+			break;
+
+		cur = len + 1;
+		free(*buffer);
+	} while (1);
+
+	return len;
+}
+
 size_t log_valist(const char *fmt, va_list args)
 {
 	char *buffer;
@@ -63,6 +92,28 @@ size_t log_valist(const char *fmt, va_list args)
 	return len;
 }
 
+/* add prefix for the specified type in front of the valist */
+void log_prevalist(int type, const char *fmt, va_list args)
+{
+	char pre[32];
+	char *buffer;
+	size_t len;
+	int prelen;
+	pid_t pid;
+
+	pid = gettid();
+	if (fio_debug_jobp && *fio_debug_jobp != -1U
+	    && pid != *fio_debug_jobp)
+		return;
+
+	prelen = snprintf(pre, sizeof pre, "%-8s %-5u ", debug_levels[type].name, (int) pid);
+	if (prelen > 0) {
+		len = prevalist_to_buf(&buffer, pre, prelen, fmt, args);
+		len = log_info_buf(buffer, len);
+		free(buffer);
+	}
+}
+
 size_t log_info(const char *format, ...)
 {
 	va_list args;
diff --git a/log.h b/log.h
index 66546c4..8163f97 100644
--- a/log.h
+++ b/log.h
@@ -13,6 +13,7 @@ extern size_t log_err(const char *format, ...) __attribute__ ((__format__ (__pri
 extern size_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern size_t __log_buf(struct buf_output *, const char *format, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
 extern size_t log_valist(const char *str, va_list);
+extern void log_prevalist(int type, const char *str, va_list);
 extern size_t log_info_buf(const char *buf, size_t len);
 extern int log_info_flush(void);
 
