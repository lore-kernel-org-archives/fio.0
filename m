Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 3/5] Drop circular dependency in log.c and lib/output_buffer.c
Date: Tue, 23 May 2017 21:44:47 +0300
Message-Id: <20170523184449.48134-4-tkusumi@tuxera.com>
In-Reply-To: <20170523184449.48134-1-tkusumi@tuxera.com>
References: <20170523184449.48134-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Two files log.c and lib/output_buffer.c have dependency on each other,
i.e. log.c is using buf_output_add() in lib/output_buffer.c, while
lib/output_buffer.c is using log_info_buf() in log.c.

This commit removes this dependency from lib/output_buffer.c by
dropping log_info_buf() call from a library function buf_output_flush(),
and then as a result rename buf_output_flush() to buf_output_clear()
since it's no longer flusing anything. log_info_buf() is now called
independently by __show_run_stats() which was the only caller of
buf_output_flush().

log_info_buf() returning 0 on !len is necessary to keep this commit
without making functional difference. dprint()/log_info() basically
never pass NULL or "" to log_info_buf(), but __show_run_stats() would
pass NULL with length 0 for unused output modes which then needs to
be avoided as a special case.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 lib/output_buffer.c | 8 +-------
 lib/output_buffer.h | 2 +-
 log.c               | 6 ++++++
 stat.c              | 6 ++++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/lib/output_buffer.c b/lib/output_buffer.c
index c1fdfc9..313536d 100644
--- a/lib/output_buffer.c
+++ b/lib/output_buffer.c
@@ -3,7 +3,6 @@
 #include <stdlib.h>
 
 #include "output_buffer.h"
-#include "../log.h"
 #include "../minmax.h"
 
 #define BUF_INC	1024
@@ -41,15 +40,10 @@ size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
 	return len;
 }
 
-size_t buf_output_flush(struct buf_output *out)
+void buf_output_clear(struct buf_output *out)
 {
-	size_t ret = 0;
-
 	if (out->buflen) {
-		ret = log_info_buf(out->buf, out->buflen);
 		memset(out->buf, 0, out->max_buflen);
 		out->buflen = 0;
 	}
-
-	return ret;
 }
diff --git a/lib/output_buffer.h b/lib/output_buffer.h
index 396002f..15ee005 100644
--- a/lib/output_buffer.h
+++ b/lib/output_buffer.h
@@ -12,6 +12,6 @@ struct buf_output {
 void buf_output_init(struct buf_output *out);
 void buf_output_free(struct buf_output *out);
 size_t buf_output_add(struct buf_output *out, const char *buf, size_t len);
-size_t buf_output_flush(struct buf_output *out);
+void buf_output_clear(struct buf_output *out);
 
 #endif
diff --git a/log.c b/log.c
index 4eb4af5..172f153 100644
--- a/log.c
+++ b/log.c
@@ -8,6 +8,12 @@
 
 size_t log_info_buf(const char *buf, size_t len)
 {
+	/*
+	 * buf could be NULL (not just "").
+	 */
+	if (!buf)
+		return 0;
+
 	if (is_backend) {
 		size_t ret = fio_server_text_output(FIO_LOG_INFO, buf, len);
 		if (ret != -1)
diff --git a/stat.c b/stat.c
index 5b48413..1f124a8 100644
--- a/stat.c
+++ b/stat.c
@@ -1825,8 +1825,10 @@ void __show_run_stats(void)
 	}
 
 	for (i = 0; i < FIO_OUTPUT_NR; i++) {
-		buf_output_flush(&output[i]);
-		buf_output_free(&output[i]);
+		struct buf_output *out = &output[i];
+		log_info_buf(out->buf, out->buflen);
+		buf_output_clear(out);
+		buf_output_free(out);
 	}
 
 	log_info_flush();
-- 
2.9.4


