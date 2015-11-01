Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:35009 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbbKANAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 1 Nov 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZssEv-0006i0-5F
	for fio@vger.kernel.org; Sun, 01 Nov 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151101130002.8B1592C00BE@kernel.dk>
Date: Sun,  1 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 125451c0455dfcfd11dbcf9570d23218ed4b8ad3:

  Bump the client ETA timeout from 5s to 30s (2015-10-30 11:52:23 +0900)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f6cbf8ac4f70c800bbbfc23c5dcf44ed619c0acc:

  output_buffer: only realloc once, and memset just what we need (2015-10-30 19:34:21 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      output_buffer: only realloc once, and memset just what we need

 lib/output_buffer.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/lib/output_buffer.c b/lib/output_buffer.c
index 03cd848..c1fdfc9 100644
--- a/lib/output_buffer.c
+++ b/lib/output_buffer.c
@@ -4,6 +4,7 @@
 
 #include "output_buffer.h"
 #include "../log.h"
+#include "../minmax.h"
 
 #define BUF_INC	1024
 
@@ -21,12 +22,18 @@ void buf_output_free(struct buf_output *out)
 
 size_t buf_output_add(struct buf_output *out, const char *buf, size_t len)
 {
-	while (out->max_buflen - out->buflen < len) {
+	if (out->max_buflen - out->buflen < len) {
+		size_t need = len - (out->max_buflen - out->buflen);
 		size_t old_max = out->max_buflen;
 
-		out->max_buflen += BUF_INC;
+		need = max((size_t) BUF_INC, need);
+		out->max_buflen += need;
 		out->buf = realloc(out->buf, out->max_buflen);
-		memset(&out->buf[old_max], 0, BUF_INC);
+
+		old_max = max(old_max, out->buflen + len);
+		if (old_max + need > out->max_buflen)
+			need = out->max_buflen - old_max;
+		memset(&out->buf[old_max], 0, need);
 	}
 
 	memcpy(&out->buf[out->buflen], buf, len);
