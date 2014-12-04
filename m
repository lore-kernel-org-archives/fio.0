Return-Path: <axboe@kernel.dk>
Message-ID: <547FCA1C.1000808@kernel.dk>
Date: Wed, 03 Dec 2014 19:42:36 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Repeat given pattern with buffer_compress_percentage
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
In-Reply-To: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070408010300010009020902"
To: Karthick Srinivasachary <karthick@pernixdata.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070408010300010009020902
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/03/2014 11:48 AM, Karthick Srinivasachary wrote:
> Hi Folks,
>
> I have question. Any feedback appreciated..!
>
> With buffer_compress_percentage, fio writes random data + zeros.
>
> Is there a way to write random data + repeat_pattern (instead of
> zero's). Pattern can be any user given pattern.

We can just make it fill with buffer_pattern instead of zeroing. Given 
that the pattern is short enough, it should not skew the compression 
rate significantly.

OK, did a quick patch and ran a quick test, looks like it's still within 
half a percent.

Pull the latest -git, then apply the attached patch. That should do what 
you want. Please report back.

-- 
Jens Axboe


--------------070408010300010009020902
Content-Type: text/x-patch;
 name="refill-compress-pattern.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="refill-compress-pattern.patch"

diff --git a/init.c b/init.c
index 4f66759b59b5..82371044c1f5 100644
--- a/init.c
+++ b/init.c
@@ -724,7 +724,8 @@ static int fixup_options(struct thread_data *td)
 	if (td->o.compress_percentage == 100) {
 		td->o.zero_buffers = 1;
 		td->o.compress_percentage = 0;
-	}
+	} else if (td->o.compress_percentage)
+		td->o.refill_buffers = 1;
 
 	/*
 	 * Using a non-uniform random distribution excludes usage of
diff --git a/io_u.c b/io_u.c
index 33c82f2c4e9e..963e8cb764b9 100644
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
+	if (o->compress_percentage && !o->zero_buffers) {
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
+	} else if (o->buffer_pattern_bytes && !o->zero_buffers)
+		fill_buffer_pattern(td, buf, max_bs);
+	else
 		memset(buf, 0, max_bs);
 }
 
diff --git a/lib/rand.c b/lib/rand.c
index a79fb9c17c32..5235c7f5b3f2 100644
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
+		if (pattern)
+			fill_pattern(buf, len, pattern, pbytes);
+		else
+			memset(buf, 0, len);
 		return 0;
 	}
 
@@ -124,7 +155,10 @@ unsigned long fill_random_buf_percentage(struct frand_state *fs, void *buf,
 		if (this_len > len)
 			this_len = len;
 
-		memset(buf, 0, this_len);
+		if (pattern)
+			fill_pattern(buf, this_len, pattern, pbytes);
+		else
+			memset(buf, 0, this_len);
 		len -= this_len;
 		buf += this_len;
 	}
diff --git a/lib/rand.h b/lib/rand.h
index 8c35ab1fa263..803bea484757 100644
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
index c2b3c40edef8..c1791fc69743 100644
--- a/verify.c
+++ b/verify.c
@@ -29,36 +29,6 @@ static void populate_hdr(struct thread_data *td, struct io_u *io_u,
 			 struct verify_header *hdr, unsigned int header_num,
 			 unsigned int header_len);
 
-static void fill_pattern(void *p, unsigned int len, char *pattern,
-			 unsigned int pattern_bytes)
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
 	fill_pattern(p, len, td->o.buffer_pattern, td->o.buffer_pattern_bytes);

--------------070408010300010009020902--

