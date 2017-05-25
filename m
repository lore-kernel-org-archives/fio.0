Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40526 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935583AbdEYMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 May 2017 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dDrR1-0002FI-5j
        for fio@vger.kernel.org; Thu, 25 May 2017 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170525120002.04F182C246B@kernel.dk>
Date: Thu, 25 May 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c78e8496d438982157657711fbff8bedb621c1c9:

  log: ensure we don't truncate the final '\0' in the log (2017-05-23 21:51:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8dd0eca30caeda7f62df4d09748286592956fcc5:

  lib/output_buffer: harden buf_output_free() and kill buf_output_clear() (2017-05-24 10:21:27 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      log: unify the logging handlers
      lib/output_buffer: harden buf_output_free() and kill buf_output_clear()

 lib/output_buffer.c |  9 +-----
 lib/output_buffer.h |  1 -
 log.c               | 91 ++++++++++++++++++++---------------------------------
 stat.c              |  2 +-
 4 files changed, 36 insertions(+), 67 deletions(-)

---

Diff of recent changes:

diff --git a/lib/output_buffer.c b/lib/output_buffer.c
index 313536d..f6c304b 100644
--- a/lib/output_buffer.c
+++ b/lib/output_buffer.c
@@ -17,6 +17,7 @@ void buf_output_init(struct buf_output *out)
 void buf_output_free(struct buf_output *out)
 {
 	free(out->buf);
+	buf_output_init(out);
 }
 
 size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
@@ -39,11 +40,3 @@ size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
 	out->buflen += len;
 	return len;
 }
-
-void buf_output_clear(struct buf_output *out)
-{
-	if (out->buflen) {
-		memset(out->buf, 0, out->max_buflen);
-		out->buflen = 0;
-	}
-}
diff --git a/lib/output_buffer.h b/lib/output_buffer.h
index 15ee005..a235af2 100644
--- a/lib/output_buffer.h
+++ b/lib/output_buffer.h
@@ -12,6 +12,5 @@ struct buf_output {
 void buf_output_init(struct buf_output *out);
 void buf_output_free(struct buf_output *out);
 size_t buf_output_add(struct buf_output *out, const char *buf, size_t len);
-void buf_output_clear(struct buf_output *out);
 
 #endif
diff --git a/log.c b/log.c
index c7856eb..95351d5 100644
--- a/log.c
+++ b/log.c
@@ -29,78 +29,66 @@ size_t log_info_buf(const char *buf, size_t len)
 		return fwrite(buf, len, 1, f_out);
 }
 
-size_t log_valist(const char *str, va_list args)
+static size_t valist_to_buf(char **buffer, const char *fmt, va_list src_args)
 {
 	size_t len, cur = LOG_START_SZ;
-	char *buffer;
+	va_list args;
 
 	do {
-		buffer = calloc(1, cur);
+		*buffer = calloc(1, cur);
+
+		va_copy(args, src_args);
+		len = vsnprintf(*buffer, cur, fmt, args);
+		va_end(args);
 
-		len = vsnprintf(buffer, cur, str, args);
 		if (len < cur)
 			break;
 
 		cur = len + 1;
-		free(buffer);
+		free(*buffer);
 	} while (1);
 
-	cur = log_info_buf(buffer, len);
-	free(buffer);
-
-	return cur;
+	return len;
 }
 
-size_t log_info(const char *format, ...)
+size_t log_valist(const char *fmt, va_list args)
 {
-	size_t len, cur = LOG_START_SZ;
 	char *buffer;
-	va_list args;
-
-	do {
-		buffer = calloc(1, cur);
+	size_t len;
 
-		va_start(args, format);
-		len = vsnprintf(buffer, cur, format, args);
-		va_end(args);
+	len = valist_to_buf(&buffer, fmt, args);
+	len = log_info_buf(buffer, len);
+	free(buffer);
 
-		if (len < cur)
-			break;
+	return len;
+}
 
-		cur = len + 1;
-		free(buffer);
-	} while (1);
+size_t log_info(const char *format, ...)
+{
+	va_list args;
+	size_t ret;
 
-	cur = log_info_buf(buffer, len);
-	free(buffer);
+	va_start(args, format);
+	ret = log_valist(format, args);
+	va_end(args);
 
-	return cur;
+	return ret;
 }
 
 size_t __log_buf(struct buf_output *buf, const char *format, ...)
 {
-	size_t len, cur = LOG_START_SZ;
 	char *buffer;
 	va_list args;
+	size_t len;
 
-	do {
-		buffer = calloc(1, cur);
-
-		va_start(args, format);
-		len = vsnprintf(buffer, cur, format, args);
-		va_end(args);
-
-		if (len < cur)
-			break;
-
-		cur = len + 1;
-		free(buffer);
-	} while (1);
+	va_start(args, format);
+	len = valist_to_buf(&buffer, format, args);
+	va_end(args);
 
-	cur = buf_output_add(buf, buffer, len);
+	len = buf_output_add(buf, buffer, len);
 	free(buffer);
 
-	return cur;
+	return len;
 }
 
 int log_info_flush(void)
@@ -113,24 +101,13 @@ int log_info_flush(void)
 
 size_t log_err(const char *format, ...)
 {
-	size_t ret, len, cur = LOG_START_SZ;
+	size_t ret, len;
 	char *buffer;
 	va_list args;
 
-	do {
-		buffer = calloc(1, cur);
-
-		va_start(args, format);
-		len = vsnprintf(buffer, cur, format, args);
-		va_end(args);
-
-		if (len < cur)
-			break;
-
-		cur = len + 1;
-		free(buffer);
-	} while (1);
-
+	va_start(args, format);
+	len = valist_to_buf(&buffer, format, args);
+	va_end(args);
 
 	if (is_backend) {
 		ret = fio_server_text_output(FIO_LOG_ERR, buffer, len);
diff --git a/stat.c b/stat.c
index 1f124a8..e433c6d 100644
--- a/stat.c
+++ b/stat.c
@@ -1826,8 +1826,8 @@ void __show_run_stats(void)
 
 	for (i = 0; i < FIO_OUTPUT_NR; i++) {
 		struct buf_output *out = &output[i];
+
 		log_info_buf(out->buf, out->buflen);
-		buf_output_clear(out);
 		buf_output_free(out);
 	}
 
