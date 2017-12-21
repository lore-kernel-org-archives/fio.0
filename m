Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2352.austin.hpe.com ([15.233.44.25]:22177 "EHLO
        g2t2352.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755928AbdLUBMb (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 20 Dec 2017 20:12:31 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 0D757A3
        for <fio@vger.kernel.org>; Thu, 21 Dec 2017 01:12:31 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH] debug: make debug=io readable with multiple threads
Date: Wed, 20 Dec 2017 19:12:19 -0600
Message-Id: <20171221011219.780-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

When multiple threads are active, debug=io prints are unreadable as the output
is interleaved. Multiple log_info_buf() calls are used to construct each line,
but there is no mutual exclusion covering multiple calls.

Change the dprint call tree to construct the entire line before passing it to
log_info_buf(), rather than make several calls.

Other nits:
* print the thread ID rather than the process ID
* change offset and length from decimal to hex
* separate offset, length, ddir, and file with , rather than / since the
  filename on the same line likely has / of its own
* change "fill_io_u" to "fill" to match the others
* change "io complete" to "complete" to match the others
* change "->prep()=%d" to "prep: io_u %p: ret=%d" to resemble the others
* change offset/buflen in an error print to better resemble the normal prints
* add "file=" prefix for the filename
* check the calloc() return values inside the valist_to_buf functions

Old:
fill_io_u: io_u 0x7feeac010b80: off=720896/len=65536/ddir=1

io       50692io       50692//dev/dax0.0io       50692fill_io_u: io_u 0x7fee98010b80: off=196608/len=65536/ddir=1io       50692io       50692
io       50692->prep(0x7fef10010b80)=0
//dev/dax0.0//dev/dax1.0io       50692io       50692io       50692io       50692->prep(0x7feeec010b80)=0
io       50692prep: io_u 0x7feec4010b80: off=1966080/len=65536/ddir=1io       50692io complete: io_u 0x7feedc010b80: off=393216/len=65536/ddir=1io
50692io       50692prep: io_u 0x7feef4010b80: off=720896/len=65536/ddir=1io       50692io       50692
io       50692io       50692prep: io_u 0x7feef0010b80: off=851968/len=65536/ddir=1//dev/dax0.0io       50692//dev/dax0.0

//dev/dax0.0
io       50692io       50692//dev/dax0.0//dev/dax0.0io       50692

New:
io       71400 queue: io_u 0x7fd0f0010b80: off=0x2f0000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71395 fill: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71395 prep: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71395 prep: io_u 0x7fd0fc010b80: ret=0
io       71395 queue: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71430 complete: io_u 0x7fd05c010b80: off=0x180000,len=0x10000,ddir=1,file=/dev/dax1.0
io       71400 complete: io_u 0x7fd0f0010b80: off=0x2f0000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71430 fill: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
io       71400 fill: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71400 prep: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71400 prep: io_u 0x7fd0f0010b80: ret=0
io       71400 queue: io_u 0x7fd0f0010b80: off=0x300000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71430 prep: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
io       71395 complete: io_u 0x7fd0fc010b80: off=0x80000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71430 prep: io_u 0x7fd05c010b80: ret=0
io       71430 queue: io_u 0x7fd05c010b80: off=0x190000,len=0x10000,ddir=1,file=/dev/dax1.0
io       71421 complete: io_u 0x7fd090010b80: off=0x320000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71419 complete: io_u 0x7fd098010b80: off=0x320000,len=0x10000,ddir=1,file=/dev/dax0.0
io       71404 complete: io_u 0x7fd0d0010b80: off=0x0,len=0x10000,ddir=1,file=/dev/dax0.0
---
 debug.c     | 11 +----------
 io_u.c      |  9 ++++-----
 io_u.h      | 15 ++++++++++-----
 ioengines.c |  3 ++-
 log.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 log.h       |  1 +
 6 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/debug.c b/debug.c
index 013cd53c..2bee5078 100644
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
diff --git a/io_u.c b/io_u.c
index 42d98ebf..852b98e9 100644
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
index b228e2e8..da25efb9 100644
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
index cec0c760..fb475e97 100644
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
index 95351d57..291ff24a 100644
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
@@ -63,6 +92,31 @@ size_t log_valist(const char *fmt, va_list args)
 	return len;
 }
 
+/* add prefix for the specified type in front of the valist */
+void log_prevalist(int type, const char *fmt, va_list args)
+{
+	char pre[32];
+	char *buffer;
+	size_t len;
+	size_t prelen;
+	pid_t pid;
+
+	pid = gettid();
+	if (fio_debug_jobp && *fio_debug_jobp != -1U
+	    && pid != *fio_debug_jobp)
+		return;
+
+	prelen = snprintf(pre, sizeof pre, "%-8s %-5u ", debug_levels[type].name, (int) pid);
+	if (prelen < 0)
+		return;
+
+	len = prevalist_to_buf(&buffer, pre, prelen, fmt, args);
+	len = log_info_buf(buffer, len);
+	free(buffer);
+
+	return;
+}
+
 size_t log_info(const char *format, ...)
 {
 	va_list args;
diff --git a/log.h b/log.h
index 66546c44..8163f977 100644
--- a/log.h
+++ b/log.h
@@ -13,6 +13,7 @@ extern size_t log_err(const char *format, ...) __attribute__ ((__format__ (__pri
 extern size_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern size_t __log_buf(struct buf_output *, const char *format, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
 extern size_t log_valist(const char *str, va_list);
+extern void log_prevalist(int type, const char *str, va_list);
 extern size_t log_info_buf(const char *buf, size_t len);
 extern int log_info_flush(void);
 
-- 
2.14.3

