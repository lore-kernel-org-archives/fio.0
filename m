Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59190 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206AbaLENAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 5 Dec 2014 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XwsUP-0002OP-6A
	for fio@vger.kernel.org; Fri, 05 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141205130003.CDB7A40162@lyth.info>
Date: Fri,  5 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d1af28949be138e55dd061132318dfc240758b4c:

  Use specified buffer_pattern (if given) for all io_u fills (2014-12-03 19:55:33 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7fa085eaed61cf6ffe26a010d5b115cd1c84867c:

  verify: cleanup (2014-12-04 16:49:53 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Don't clear 'refill_buffers' unconditionally for pattern fill
      Use specified compression/pattern for verify buffers too
      verify: cleanup

 lib/rand.c |   30 ++++++++++++++++++++----------
 lib/rand.h |    1 +
 options.c  |    3 ++-
 verify.c   |   27 +++++++++++++++++++++------
 4 files changed, 44 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/lib/rand.c b/lib/rand.c
index e5332bf..618a2f0 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -117,12 +117,11 @@ void fill_pattern(void *p, unsigned int len, char *pattern,
 	}
 }
 
-unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
-					 unsigned int percentage,
-					 unsigned int segment, unsigned int len,
-					 char *pattern, unsigned int pbytes)
+void __fill_random_buf_percentage(unsigned long seed, void *buf,
+				  unsigned int percentage,
+				  unsigned int segment, unsigned int len,
+				  char *pattern, unsigned int pbytes)
 {
-	unsigned long r = __rand(fs);
 	unsigned int this_len;
 
 	if (percentage == 100) {
@@ -130,15 +129,12 @@ unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 			fill_pattern(buf, len, pattern, pbytes);
 		else
 			memset(buf, 0, len);
-		return 0;
+		return;
 	}
 
 	if (segment > len)
 		segment = len;
 
-	if (sizeof(int) != sizeof(long *))
-		r *= (unsigned long) __rand(fs);
-
 	while (len) {
 		/*
 		 * Fill random chunk
@@ -147,7 +143,7 @@ unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 		if (this_len > len)
 			this_len = len;
 
-		__fill_random_buf(buf, this_len, r);
+		__fill_random_buf(buf, this_len, seed);
 
 		len -= this_len;
 		buf += this_len;
@@ -159,9 +155,23 @@ unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 			fill_pattern(buf, this_len, pattern, pbytes);
 		else
 			memset(buf, 0, this_len);
+
 		len -= this_len;
 		buf += this_len;
 	}
+}
+
+unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
+					 unsigned int percentage,
+					 unsigned int segment, unsigned int len,
+					 char *pattern, unsigned int pbytes)
+{
+	unsigned long r = __rand(fs);
+
+	if (sizeof(int) != sizeof(long *))
+		r *= (unsigned long) __rand(fs);
 
+	__fill_random_buf_percentage(r, buf, percentage, segment, len,
+					pattern, pbytes);
 	return r;
 }
diff --git a/lib/rand.h b/lib/rand.h
index 803bea4..089837d 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -30,6 +30,7 @@ extern void init_rand(struct frand_state *);
 extern void init_rand_seed(struct frand_state *, unsigned int seed);
 extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
 extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
+extern void __fill_random_buf_percentage(unsigned long, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
 extern unsigned long fill_random_buf_percentage(struct frand_state *, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
 extern void fill_pattern(void *p, unsigned int len, char *pattern, unsigned int pattern_bytes);
 
diff --git a/options.c b/options.c
index 23469d8..c3c6292 100644
--- a/options.c
+++ b/options.c
@@ -1031,7 +1031,8 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 				&td->o.buffer_pattern_bytes);
 
 	if (!ret && td->o.buffer_pattern_bytes) {
-		td->o.refill_buffers = 0;
+		if (!td->o.compress_percentage)
+			td->o.refill_buffers = 0;
 		td->o.scramble_buffers = 0;
 		td->o.zero_buffers = 0;
 	} else {
diff --git a/verify.c b/verify.c
index c1791fc..d1a1266 100644
--- a/verify.c
+++ b/verify.c
@@ -34,27 +34,42 @@ void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 	fill_pattern(p, len, td->o.buffer_pattern, td->o.buffer_pattern_bytes);
 }
 
+void __fill_buffer(struct thread_options *o, unsigned long seed, void *p,
+		   unsigned int len)
+{
+	__fill_random_buf_percentage(seed, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
+}
+
+unsigned long fill_buffer(struct thread_data *td, void *p, unsigned int len)
+{
+	struct frand_state *fs = &td->verify_state;
+	struct thread_options *o = &td->o;
+
+	return fill_random_buf_percentage(fs, p, o->compress_percentage, len, len, o->buffer_pattern, o->buffer_pattern_bytes);
+}
+
 void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 			 struct io_u *io_u, unsigned long seed, int use_seed)
 {
-	if (!td->o.verify_pattern_bytes) {
+	struct thread_options *o = &td->o;
+
+	if (!o->verify_pattern_bytes) {
 		dprint(FD_VERIFY, "fill random bytes len=%u\n", len);
 
 		if (use_seed)
-			__fill_random_buf(p, len, seed);
+			__fill_buffer(o, seed, p, len);
 		else
-			io_u->rand_seed = fill_random_buf(&td->verify_state, p, len);
+			io_u->rand_seed = fill_buffer(td, p, len);
 		return;
 	}
 
 	if (io_u->buf_filled_len >= len) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
-			td->o.verify_pattern_bytes, len);
+			o->verify_pattern_bytes, len);
 		return;
 	}
 
-	fill_pattern(p, len, td->o.verify_pattern, td->o.verify_pattern_bytes);
-
+	fill_pattern(p, len, o->verify_pattern, o->verify_pattern_bytes);
 	io_u->buf_filled_len = len;
 }
 
