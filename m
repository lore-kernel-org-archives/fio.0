Return-Path: <raeburn@permabit.com>
From: Ken Raeburn <raeburn@permabit.com>
Subject: [PATCH] Fix bugs in [v]snprintf usage.
References: <6eham0rdc3.fsf@just-testing.permabit.com>
	<6ea9rsrc7u.fsf@just-testing.permabit.com>
	<20130129091712.GD30188@kernel.dk>
	<6e622fr967.fsf@just-testing.permabit.com>
	<20130129211501.GK8800@kernel.dk>
	<6e1ud3r699.fsf@just-testing.permabit.com>
	<20130130115851.GX8800@kernel.dk>
Date: Wed, 30 Jan 2013 16:25:06 -0500
In-Reply-To: <20130130115851.GX8800@kernel.dk> (Jens Axboe's message of "Wed,
	30 Jan 2013 12:58:51 +0100")
Message-ID: <6esj5ipdn1.fsf_-_@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


When calling snprintf, supply the full buffer size instead of
(usually) one byte less.

When using the returned length from vsnprintf for logging, don't write
more than the actual buffer size (minus one for the trailing \0), in
case the formatted string was truncated.
---
 engines/falloc.c |    2 +-
 filesetup.c      |    4 ++--
 fio.h            |    2 +-
 init.c           |    2 +-
 iolog.c          |    2 +-
 log.c            |    4 ++++
 server.c         |    1 +
 stat.c           |    6 +++---
 t/log.c          |    2 ++
 9 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/engines/falloc.c b/engines/falloc.c
index 525a0aa..4654fe8 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -44,7 +44,7 @@ open_again:
 	if (f->fd == -1) {
 		char buf[FIO_VERROR_SIZE];
 		int __e = errno;
-		snprintf(buf, sizeof(buf) - 1, "open(%s)", f->file_name);
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
 		td_verror(td, __e, buf);
 	}
 
diff --git a/filesetup.c b/filesetup.c
index 6f0a876..5aadf12 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -563,7 +563,7 @@ open_again:
 		if (__e == EMFILE && file_close_shadow_fds(td))
 			goto open_again;
 
-		snprintf(buf, sizeof(buf) - 1, "open(%s)", f->file_name);
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
 
 		if (__e == EINVAL && (flags & OS_O_DIRECT)) {
 			log_err("fio: looks like your file system does not " \
@@ -1250,7 +1250,7 @@ static int recurse_dir(struct thread_data *td, const char *dirname)
 	if (!D) {
 		char buf[FIO_VERROR_SIZE];
 
-		snprintf(buf, FIO_VERROR_SIZE - 1, "opendir(%s)", dirname);
+		snprintf(buf, FIO_VERROR_SIZE, "opendir(%s)", dirname);
 		td_verror(td, errno, buf);
 		return 1;
 	}
diff --git a/fio.h b/fio.h
index 2fd354a..d18029a 100644
--- a/fio.h
+++ b/fio.h
@@ -568,7 +568,7 @@ enum {
 		int e = (err);						\
 		(td)->error = e;					\
 		if (!(td)->first_error)					\
-			snprintf(td->verror, sizeof(td->verror) - 1, "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));		\
+			snprintf(td->verror, sizeof(td->verror), "file:%s:%d, func=%s, error=%s", __FILE__, __LINE__, (func), (msg));		\
 	} while (0)
 
 
diff --git a/init.c b/init.c
index f0ad019..dfc5a8f 100644
--- a/init.c
+++ b/init.c
@@ -627,7 +627,7 @@ static char *to_kmg(unsigned int val)
 		p++;
 	} while (*p);
 
-	snprintf(buf, 31, "%u%c", val, *p);
+	snprintf(buf, 32, "%u%c", val, *p);
 	return buf;
 }
 
diff --git a/iolog.c b/iolog.c
index 12f09d0..e4c1fef 100644
--- a/iolog.c
+++ b/iolog.c
@@ -534,7 +534,7 @@ void finish_log_named(struct thread_data *td, struct io_log *log,
 {
 	char file_name[256], *p;
 
-	snprintf(file_name, 200, "%s_%s.log", prefix, postfix);
+	snprintf(file_name, sizeof(file_name), "%s_%s.log", prefix, postfix);
 	p = basename(file_name);
 	__finish_log(log, p);
 }
diff --git a/log.c b/log.c
index af974f8..08509b3 100644
--- a/log.c
+++ b/log.c
@@ -12,6 +12,7 @@ int log_valist(const char *str, va_list args)
 	size_t len;
 
 	len = vsnprintf(buffer, sizeof(buffer), str, args);
+	len = min(len, sizeof(buffer) - 1);
 
 	if (log_syslog)
 		syslog(LOG_INFO, "%s", buffer);
@@ -40,6 +41,7 @@ int log_local(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	if (log_syslog)
 		syslog(LOG_INFO, "%s", buffer);
@@ -58,6 +60,7 @@ int log_info(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	if (is_backend)
 		return fio_server_text_output(buffer, len);
@@ -77,6 +80,7 @@ int log_err(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	if (is_backend)
 		return fio_server_text_output(buffer, len);
diff --git a/server.c b/server.c
index 7ec8531..ad78572 100644
--- a/server.c
+++ b/server.c
@@ -811,6 +811,7 @@ int fio_server_log(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	return fio_server_text_output(buffer, len);
 }
diff --git a/stat.c b/stat.c
index 7e2feea..62eee9a 100644
--- a/stat.c
+++ b/stat.c
@@ -753,7 +753,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 			json_object_add_value_int(percentile_object, "0.00", 0);
 			continue;
 		}
-		snprintf(buf, sizeof(buf) - 1, "%2.2f", ts->percentile_list[i].u.f);
+		snprintf(buf, sizeof(buf), "%2.2f", ts->percentile_list[i].u.f);
 		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
 	}
 
@@ -959,9 +959,9 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	for (i = 0; i < 7; i++) {
 		char name[20];
 		if (i < 6)
-			snprintf(name, 19, "%d", 1 << i);
+			snprintf(name, 20, "%d", 1 << i);
 		else
-			snprintf(name, 19, ">=%d", 1 << i);
+			snprintf(name, 20, ">=%d", 1 << i);
 		json_object_add_value_float(tmp, (const char *)name, io_u_dist[i]);
 	}
 
diff --git a/t/log.c b/t/log.c
index ac02303..76ae68e 100644
--- a/t/log.c
+++ b/t/log.c
@@ -10,6 +10,7 @@ int log_err(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	return fwrite(buffer, len, 1, stderr);
 }
@@ -23,6 +24,7 @@ int log_info(const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
+	len = min(len, sizeof(buffer) - 1);
 
 	return fwrite(buffer, len, 1, stdout);
 }
-- 
1.7.9.5


