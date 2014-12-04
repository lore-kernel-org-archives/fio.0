Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:32895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaLDNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 4 Dec 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XwW0q-00067F-D8
	for fio@vger.kernel.org; Thu, 04 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141204130002.ED281401DC@lyth.info>
Date: Thu,  4 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0c87ac2ac5df7e20b8c8d9cfc46b7667deeef683:

  fio: remove deprecated --latency-log from manpage (2014-12-02 13:54:32 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d1af28949be138e55dd061132318dfc240758b4c:

  Use specified buffer_pattern (if given) for all io_u fills (2014-12-03 19:55:33 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Fix a few spelling errors
      Remove 'td' parameter from fill_pattern()
      Use specified buffer_pattern (if given) for all io_u fills

 HOWTO            |    9 ++++++---
 examples/rbd.fio |    4 ++--
 fio.1            |   11 +++++++----
 io_u.c           |   13 ++++++++-----
 lib/rand.c       |   40 +++++++++++++++++++++++++++++++++++++---
 lib/rand.h       |    3 ++-
 verify.c         |   34 ++--------------------------------
 7 files changed, 64 insertions(+), 50 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c73b9ec..57d3fb7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -594,9 +594,12 @@ scramble_buffers=bool	If refill_buffers is too costly and the target is
 buffer_compress_percentage=int	If this is set, then fio will attempt to
 		provide IO buffer content (on WRITEs) that compress to
 		the specified level. Fio does this by providing a mix of
-		random data and zeroes. Note that this is per block size
-		unit, for file/disk wide compression level that matches
-		this setting, you'll also want to set refill_buffers.
+		random data and a fixed pattern. The fixed pattern is either
+		zeroes, or the pattern specified by buffer_pattern. If the
+		pattern option is used, it might skew the compression ratio
+		slightly. Note that this is per block size unit, for file/disk
+		wide compression level that matches this setting, you'll also
+		want to set refill_buffers.
 
 buffer_compress_chunk=int	See buffer_compress_percentage. This
 		setting allows fio to manage how big the ranges of random
diff --git a/examples/rbd.fio b/examples/rbd.fio
index fcb494a..9d73ca1 100644
--- a/examples/rbd.fio
+++ b/examples/rbd.fio
@@ -1,9 +1,9 @@
 ######################################################################
 # Example test for the RBD engine.
 # 
-# Runs a 4k random write test agains a RBD via librbd  
+# Runs a 4k random write test against a RBD via librbd
 #
-# NOTE: Make sure you have either a RBD named 'fio_test' or change 
+# NOTE: Make sure you have either a RBD named 'fio_test' or change
 #       the rbdname parameter.
 ######################################################################
 [global]
diff --git a/fio.1 b/fio.1
index fa2ac70..c3193a2 100644
--- a/fio.1
+++ b/fio.1
@@ -476,9 +476,12 @@ of blocks. Default: true.
 .BI buffer_compress_percentage \fR=\fPint
 If this is set, then fio will attempt to provide IO buffer content (on WRITEs)
 that compress to the specified level. Fio does this by providing a mix of
-random data and zeroes. Note that this is per block size unit, for file/disk
-wide compression level that matches this setting, you'll also want to set
-\fBrefill_buffers\fR.
+random data and a fixed pattern. The fixed pattern is either zeroes, or the
+pattern specified by \fBbuffer_pattern\fR. If the pattern option is used, it
+might skew the compression ratio slightly. Note that this is per block size
+unit, for file/disk wide compression level that matches this setting. Note
+that this is per block size unit, for file/disk wide compression level that
+matches this setting, you'll also want to set refill_buffers.
 .TP
 .BI buffer_compress_chunk \fR=\fPint
 See \fBbuffer_compress_percentage\fR. This setting allows fio to manage how
@@ -946,7 +949,7 @@ comma delimited list of numbers, A-B ranges, or 'all'.
 .BI startdelay \fR=\fPirange
 Delay start of job for the specified number of seconds. Supports all time
 suffixes to allow specification of hours, minutes, seconds and
-milliseconds - seconds are the default if a unit is ommited.
+milliseconds - seconds are the default if a unit is omitted.
 Can be given as a range which causes each thread to choose randomly out of the
 range.
 .TP
diff --git a/io_u.c b/io_u.c
index 33c82f2..f135908 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1859,9 +1859,9 @@ static void save_buf_state(struct thread_data *td, struct frand_state *rs)
 void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		    unsigned int max_bs)
 {
-	if (td->o.buffer_pattern_bytes)
-		fill_buffer_pattern(td, buf, max_bs);
-	else if (!td->o.zero_buffers) {
+	struct thread_options *o = &td->o;
+
+	if (o->compress_percentage) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
 		unsigned int left = max_bs;
@@ -1879,7 +1879,8 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 					seg = min_write;
 
 				fill_random_buf_percentage(rs, buf, perc, seg,
-								min_write);
+					min_write, o->buffer_pattern,
+						   o->buffer_pattern_bytes);
 			} else
 				fill_random_buf(rs, buf, min_write);
 
@@ -1887,7 +1888,9 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 			left -= min_write;
 			save_buf_state(td, rs);
 		} while (left);
-	} else
+	} else if (o->buffer_pattern_bytes)
+		fill_buffer_pattern(td, buf, max_bs);
+	else
 		memset(buf, 0, max_bs);
 }
 
diff --git a/lib/rand.c b/lib/rand.c
index a79fb9c..e5332bf 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -34,6 +34,7 @@
 */
 
 #include <string.h>
+#include <assert.h>
 #include "rand.h"
 #include "../hash.h"
 
@@ -90,15 +91,45 @@ unsigned long fill_random_buf(struct frand_state *fs, void *buf,
 	return r;
 }
 
+void fill_pattern(void *p, unsigned int len, char *pattern,
+		  unsigned int pattern_bytes)
+{
+	switch (pattern_bytes) {
+	case 0:
+		assert(0);
+		break;
+	case 1:
+		memset(p, pattern[0], len);
+		break;
+	default: {
+		unsigned int i = 0, size = 0;
+		unsigned char *b = p;
+
+		while (i < len) {
+			size = pattern_bytes;
+			if (size > (len - i))
+				size = len - i;
+			memcpy(b+i, pattern, size);
+			i += size;
+		}
+		break;
+		}
+	}
+}
+
 unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 					 unsigned int percentage,
-					 unsigned int segment, unsigned int len)
+					 unsigned int segment, unsigned int len,
+					 char *pattern, unsigned int pbytes)
 {
 	unsigned long r = __rand(fs);
 	unsigned int this_len;
 
 	if (percentage == 100) {
-		memset(buf, 0, len);
+		if (pbytes)
+			fill_pattern(buf, len, pattern, pbytes);
+		else
+			memset(buf, 0, len);
 		return 0;
 	}
 
@@ -124,7 +155,10 @@ unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 		if (this_len > len)
 			this_len = len;
 
-		memset(buf, 0, this_len);
+		if (pbytes)
+			fill_pattern(buf, this_len, pattern, pbytes);
+		else
+			memset(buf, 0, this_len);
 		len -= this_len;
 		buf += this_len;
 	}
diff --git a/lib/rand.h b/lib/rand.h
index 8c35ab1..803bea4 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -30,6 +30,7 @@ extern void init_rand(struct frand_state *);
 extern void init_rand_seed(struct frand_state *, unsigned int seed);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
 extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
-extern unsigned long fill_random_buf_percentage(struct frand_state *, void *buf, unsigned int percentage, unsigned int segment, unsigned int len);
+extern unsigned long fill_random_buf_percentage(struct frand_state *, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
+extern void fill_pattern(void *p, unsigned int len, char *pattern, unsigned int pattern_bytes);
 
 #endif
diff --git a/verify.c b/verify.c
index f05e85d..c1791fc 100644
--- a/verify.c
+++ b/verify.c
@@ -29,39 +29,9 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len);
 
-static void fill_pattern(struct thread_data *td, void *p, unsigned int len,
-			 char *pattern, unsigned int pattern_bytes)
-{
-	switch (pattern_bytes) {
-	case 0:
-		assert(0);
-		break;
-	case 1:
-		dprint(FD_VERIFY, "fill verify pattern b=0 len=%u\n", len);
-		memset(p, pattern[0], len);
-		break;
-	default: {
-		unsigned int i = 0, size = 0;
-		unsigned char *b = p;
-
-		dprint(FD_VERIFY, "fill verify pattern b=%d len=%u\n",
-					pattern_bytes, len);
-
-		while (i < len) {
-			size = pattern_bytes;
-			if (size > (len - i))
-				size = len - i;
-			memcpy(b+i, pattern, size);
-			i += size;
-		}
-		break;
-		}
-	}
-}
-
 void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 {
-	fill_pattern(td, p, len, td->o.buffer_pattern, td->o.buffer_pattern_bytes);
+	fill_pattern(p, len, td->o.buffer_pattern, td->o.buffer_pattern_bytes);
 }
 
 void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
@@ -83,7 +53,7 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	fill_pattern(td, p, len, td->o.verify_pattern, td->o.verify_pattern_bytes);
+	fill_pattern(p, len, td->o.verify_pattern, td->o.verify_pattern_bytes);
 
 	io_u->buf_filled_len = len;
 }
