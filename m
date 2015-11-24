Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbbKXNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 Nov 2015 08:00:04 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a1DCV-0004GJ-9A
	for fio@vger.kernel.org; Tue, 24 Nov 2015 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151124130002.70B152C00ED@kernel.dk>
Date: Tue, 24 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 13aa415afc8d0a2ad0de2d6c17d6bca2d16f00c7:

  gettime: get rid of the (unecessary) 10x scaling factor (2015-11-20 17:26:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4b157ac6446364e5eecdcdbf75fc1a814489a343:

  A few min/max cleanups (2015-11-23 15:04:56 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      io_u: properly split buffer prep for compression
      options: set 'refill_buffers' for compress_percentage != 0
      A few min/max cleanups

 backend.c |  2 +-
 init.c    | 13 +++++++++----
 io_u.c    | 24 +++++++++++++-----------
 log.c     |  3 +--
 minmax.h  |  5 +++++
 5 files changed, 29 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index aa94acf..1560749 100644
--- a/backend.c
+++ b/backend.c
@@ -448,7 +448,7 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time)
 	 * if the queue is full, we MUST reap at least 1 event
 	 */
 	min_evts = min(td->o.iodepth_batch_complete_min, td->cur_depth);
-    if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
+	if ((full && !min_evts) || !td->o.iodepth_batch_complete_min)
 		min_evts = 1;
 
 	if (time && (__should_check_rate(td, DDIR_READ) ||
diff --git a/init.c b/init.c
index af35ee6..b7945cf 100644
--- a/init.c
+++ b/init.c
@@ -737,11 +737,16 @@ static int fixup_options(struct thread_data *td)
 
 	/*
 	 * For fully compressible data, just zero them at init time.
-	 * It's faster than repeatedly filling it.
+	 * It's faster than repeatedly filling it. For non-zero
+	 * compression, we should have refill_buffers set. Set it, unless
+	 * the job file already changed it.
 	 */
-	if (td->o.compress_percentage == 100) {
-		td->o.zero_buffers = 1;
-		td->o.compress_percentage = 0;
+	if (o->compress_percentage) {
+		if (o->compress_percentage == 100) {
+			o->zero_buffers = 1;
+			o->compress_percentage = 0;
+		} else if (!fio_option_is_set(o, refill_buffers))
+			o->refill_buffers = 1;
 	}
 
 	/*
diff --git a/io_u.c b/io_u.c
index 6b6b47d..dd4502f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -13,6 +13,7 @@
 #include "lib/axmap.h"
 #include "err.h"
 #include "lib/pow2.h"
+#include "minmax.h"
 
 struct io_completion_data {
 	int nr;				/* input */
@@ -1919,6 +1920,7 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
 		unsigned int left = max_bs;
+		unsigned int this_write;
 
 		do {
 			rs = get_buf_state(td);
@@ -1926,20 +1928,20 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 			min_write = min(min_write, left);
 
 			if (perc) {
-				unsigned int seg = min_write;
+				this_write = min_not_zero(min_write,
+							td->o.compress_chunk);
 
-				seg = min(min_write, td->o.compress_chunk);
-				if (!seg)
-					seg = min_write;
-
-				fill_random_buf_percentage(rs, buf, perc, seg,
-					min_write, o->buffer_pattern,
-						   o->buffer_pattern_bytes);
-			} else
+				fill_random_buf_percentage(rs, buf, perc,
+					this_write, this_write,
+					o->buffer_pattern,
+					o->buffer_pattern_bytes);
+			} else {
 				fill_random_buf(rs, buf, min_write);
+				this_write = min_write;
+			}
 
-			buf += min_write;
-			left -= min_write;
+			buf += this_write;
+			left -= this_write;
 			save_buf_state(td, rs);
 		} while (left);
 	} else if (o->buffer_pattern_bytes)
diff --git a/log.c b/log.c
index 8d511b5..d508267 100644
--- a/log.c
+++ b/log.c
@@ -59,9 +59,8 @@ size_t __log_buf(struct buf_output *buf, const char *format, ...)
 	va_start(args, format);
 	len = vsnprintf(buffer, sizeof(buffer), format, args);
 	va_end(args);
-	len = min(len, sizeof(buffer) - 1);
 
-	return buf_output_add(buf, buffer, len);
+	return buf_output_add(buf, buffer, min(len, sizeof(buffer) - 1));
 }
 
 int log_info_flush(void)
diff --git a/minmax.h b/minmax.h
index 97957c8..afc78f0 100644
--- a/minmax.h
+++ b/minmax.h
@@ -17,4 +17,9 @@
 	_x > _y ? _x : _y; })
 #endif
 
+#define min_not_zero(x, y) ({		\
+	typeof(x) __x = (x);		\
+	typeof(y) __y = (y);		\
+	__x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
+
 #endif
