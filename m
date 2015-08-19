Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33768 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbbHSKdY (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:24 -0400
Received: by wijp15 with SMTP id p15so122794558wij.0
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:23 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 6/6] use 'lib/pattern' to parse patterns and paste formats into buffers
Date: Wed, 19 Aug 2015 12:33:11 +0200
Message-Id: <1439980391-2311-7-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

Switch to new 'lib/pattern' helpers.

Now 'buffer_pattern' and 'verify_pattern' options support combined input
and strings like:

 buffer_pattern="1234"0xface"5678"
 verify_pattern=0xface"1234"-12+14

can be specified.

Also, 'verify_pattern' supports '%o' format, which means that buffer will
be patched on each iteration with real 'block offset' number.

So, f.e. 'verify_pattern' such combined input is valid:

 verify_pattern=%o

 or

 verify_pattern=%o"123"%o

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 HOWTO            |  20 ++++++-
 options.c        | 166 +++++++++++--------------------------------------------
 thread_options.h |   3 +
 verify.c         |  29 ++++++++--
 verify.h         |   5 ++
 5 files changed, 81 insertions(+), 142 deletions(-)

diff --git a/HOWTO b/HOWTO
index b61a638..cee505f 100644
--- a/HOWTO
+++ b/HOWTO
@@ -623,7 +623,16 @@ buffer_pattern=str	If set, fio will fill the io buffers with this
 		the other options related to buffer contents. The setting can
 		be any pattern of bytes, and can be prefixed with 0x for hex
 		values. It may also be a string, where the string must then
-		be wrapped with "".
+		be wrapped with "", e.g.:
+
+		buffer_pattern="abcd"
+		  or
+		buffer_pattern=-12
+		  or
+		buffer_pattern=0xdeadface
+
+		Also you can combine everything together in any order:
+		buffer_pattern=0xdeadface"abcd"-12
 
 dedupe_percentage=int	If set, fio will generate this percentage of
 		identical buffers when writing. These buffers will be
@@ -1324,7 +1333,14 @@ verify_pattern=str	If set, fio will fill the io buffers with this
 		buffer at the time(it can be either a decimal or a hex number).
 		The verify_pattern if larger than a 32-bit quantity has to
 		be a hex number that starts with either "0x" or "0X". Use
-		with verify=meta.
+		with verify=meta. Also, verify_pattern supports %o format,
+		which means that for each block offset will be written and
+		then verifyied back, e.g.:
+
+		verify_pattern=%o
+
+		Or use combination of everything:
+		verify_pattern=0xff%o"abcd"-12
 
 verify_fatal=bool	Normally fio will keep checking the entire contents
 		before quitting on a block verification failure. If this
diff --git a/options.c b/options.c
index ed5d37e..635fde7 100644
--- a/options.c
+++ b/options.c
@@ -14,12 +14,21 @@
 #include "verify.h"
 #include "parse.h"
 #include "lib/fls.h"
+#include "lib/pattern.h"
 #include "options.h"
 
 #include "crc/crc32c.h"
 
 char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
+struct pattern_fmt_desc fmt_desc[] = {
+	{
+		.fmt   = "%o",
+		.len   = FIELD_SIZE(struct io_u *, offset),
+		.paste = paste_blockoff
+	}
+};
+
 /*
  * Check if mmap/mmaphuge has a :/foo/bar/file at the end. If so, return that.
  */
@@ -36,26 +45,6 @@ static char *get_opt_postfix(const char *str)
 	return strdup(p);
 }
 
-static int converthexchartoint(char a)
-{
-	int base;
-
-	switch (a) {
-	case '0'...'9':
-		base = '0';
-		break;
-	case 'A'...'F':
-		base = 'A' - 10;
-		break;
-	case 'a'...'f':
-		base = 'a' - 10;
-		break;
-	default:
-		base = 0;
-	}
-	return a - base;
-}
-
 static int bs_cmp(const void *p1, const void *p2)
 {
 	const struct bssplit *bsp1 = p1;
@@ -914,124 +903,25 @@ static int str_opendir_cb(void *data, const char fio_unused *str)
 	return add_dir_files(td, td->o.opendir);
 }
 
-static int pattern_cb(char *pattern, unsigned int max_size,
-		      const char *input, unsigned int *pattern_bytes)
-{
-	long off = 0;
-	int i = 0, j = 0, len, k, base = 10;
-	uint32_t pattern_length;
-	char *loc1, *loc2;
-
-	/*
-	 * Check if it's a string input
-	 */
-	loc1 = strchr(input, '\"');
-	if (loc1) {
-		do {
-			loc1++;
-			if (*loc1 == '\0' || *loc1 == '\"')
-				break;
-
-			pattern[i] = *loc1;
-			i++;
-		} while (i < max_size);
-
-		if (!i)
-			return 1;
-
-		goto fill;
-	}
-
-	/*
-	 * No string, find out if it's decimal or hexidecimal
-	 */
-	loc1 = strstr(input, "0x");
-	loc2 = strstr(input, "0X");
-	if (loc1 || loc2)
-		base = 16;
-	off = strtol(input, NULL, base);
-	if (off != LONG_MAX || errno != ERANGE) {
-		while (off) {
-			pattern[i] = off & 0xff;
-			off >>= 8;
-			i++;
-		}
-	} else {
-		len = strlen(input);
-		k = len - 1;
-		if (base == 16) {
-			if (loc1)
-				j = loc1 - input + 2;
-			else
-				j = loc2 - input + 2;
-		} else
-			return 1;
-		if (len - j < max_size * 2) {
-			while (k >= j) {
-				off = converthexchartoint(input[k--]);
-				if (k >= j)
-					off += (converthexchartoint(input[k--])
-						* 16);
-				pattern[i++] = (char) off;
-			}
-		}
-	}
-
-	/*
-	 * Fill the pattern all the way to the end. This greatly reduces
-	 * the number of memcpy's we have to do when verifying the IO.
-	 */
-fill:
-	pattern_length = i;
-	if (!i && !off)
-		i = 1;
-	while (i > 1 && i * 2 <= max_size) {
-		memcpy(&pattern[i], &pattern[0], i);
-		i *= 2;
-	}
-
-	/*
-	 * Fill remainder, if the pattern multiple ends up not being
-	 * max_size.
-	 */
-	while (i > 1 && i < max_size) {
-		unsigned int b = min(pattern_length, max_size - i);
-
-		memcpy(&pattern[i], &pattern[0], b);
-		i += b;
-	}
-
-	if (i == 1) {
-		/*
-		 * The code in verify_io_u_pattern assumes a single byte
-		 * pattern fills the whole verify pattern buffer.
-		 */
-		memset(pattern, pattern[0], max_size);
-	}
-
-	*pattern_bytes = i;
-	return 0;
-}
-
 static int str_buffer_pattern_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
 	int ret;
 
-	ret = pattern_cb(td->o.buffer_pattern, MAX_PATTERN_SIZE, input,
-				&td->o.buffer_pattern_bytes);
+	/* FIXME: for now buffer pattern does not support formats */
+	ret = parse_and_fill_pattern(input, strlen(input), td->o.buffer_pattern,
+				     MAX_PATTERN_SIZE, NULL, 0, NULL, NULL);
+	if (ret < 0)
+		return 1;
 
-	if (!ret && td->o.buffer_pattern_bytes) {
-		if (!td->o.compress_percentage)
-			td->o.refill_buffers = 0;
-		td->o.scramble_buffers = 0;
-		td->o.zero_buffers = 0;
-	} else {
-		log_err("fio: failed parsing pattern `%s`\n", input);
-		ret = 1;
-	}
+	assert(ret != 0);
+	td->o.buffer_pattern_bytes = ret;
+	if (!td->o.compress_percentage)
+		td->o.refill_buffers = 0;
+	td->o.scramble_buffers = 0;
+	td->o.zero_buffers = 0;
 
-	return ret;
+	return 0;
 }
 
 static int str_buffer_compress_cb(void *data, unsigned long long *il)
@@ -1058,16 +948,22 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	struct thread_data *td = data;
 	int ret;
 
-	ret = pattern_cb(td->o.verify_pattern, MAX_PATTERN_SIZE, input,
-				&td->o.verify_pattern_bytes);
+	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
+	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
+				     MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
+				     td->o.verify_fmt, &td->o.verify_fmt_sz);
+	if (ret < 0)
+		return 1;
 
+	assert(ret != 0);
+	td->o.verify_pattern_bytes = ret;
 	/*
 	 * VERIFY_META could already be set
 	 */
-	if (!ret && !fio_option_is_set(&td->o, verify))
+	if (!fio_option_is_set(&td->o, verify))
 		td->o.verify = VERIFY_PATTERN;
 
-	return ret;
+	return 0;
 }
 
 static int str_gtod_reduce_cb(void *data, int *il)
diff --git a/thread_options.h b/thread_options.h
index 6604a37..38936e9 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -7,6 +7,7 @@
 #include "stat.h"
 #include "gettime.h"
 #include "lib/ieee754.h"
+#include "lib/pattern.h"
 #include "td_error.h"
 
 /*
@@ -97,6 +98,8 @@ struct thread_options {
 	unsigned int verify_offset;
 	char verify_pattern[MAX_PATTERN_SIZE];
 	unsigned int verify_pattern_bytes;
+	struct pattern_fmt verify_fmt[8];
+	unsigned int verify_fmt_sz;
 	unsigned int verify_fatal;
 	unsigned int verify_dump;
 	unsigned int verify_async;
diff --git a/verify.c b/verify.c
index 984b272..a931834 100644
--- a/verify.c
+++ b/verify.c
@@ -68,13 +68,17 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	if (io_u->buf_filled_len >= len) {
+	/* Skip if we were here and we do not need to patch pattern
+	 * with format */
+	if (!td->o.verify_fmt_sz && io_u->buf_filled_len >= len) {
 		dprint(FD_VERIFY, "using already filled verify pattern b=%d len=%u\n",
 			o->verify_pattern_bytes, len);
 		return;
 	}
 
-	(void)cpy_pattern(td->o.verify_pattern, td->o.verify_pattern_bytes, p, len);
+	(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
+			   td->o.verify_fmt, td->o.verify_fmt_sz,
+			   p, len, io_u);
 	io_u->buf_filled_len = len;
 }
 
@@ -361,11 +365,14 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 
 	pattern = td->o.verify_pattern;
 	pattern_size = td->o.verify_pattern_bytes;
-	if (pattern_size <= 1)
-		pattern_size = MAX_PATTERN_SIZE;
+	assert(pattern_size != 0);
+
+	(void)paste_format_inplace(pattern, pattern_size,
+				   td->o.verify_fmt, td->o.verify_fmt_sz, io_u);
+
 	buf = (void *) hdr + header_size;
 	len = get_hdr_inc(td, io_u) - header_size;
-	mod = header_size % pattern_size;
+	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
 
 	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
 	if (!rc)
@@ -1321,6 +1328,18 @@ void verify_async_exit(struct thread_data *td)
 	td->verify_threads = NULL;
 }
 
+int paste_blockoff(char *buf, unsigned int len, void *priv)
+{
+	struct io_u *io = priv;
+	unsigned long long off;
+
+	typecheck(typeof(off), io->offset);
+	off = cpu_to_le64((uint64_t)io->offset);
+	len = min(len, (unsigned int)sizeof(off));
+	memcpy(buf, &off, len);
+	return 0;
+}
+
 struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 {
 	struct all_io_list *rep;
diff --git a/verify.h b/verify.h
index c37b1d5..ce4879d 100644
--- a/verify.h
+++ b/verify.h
@@ -89,6 +89,11 @@ extern void fio_verify_init(struct thread_data *td);
 extern int verify_async_init(struct thread_data *);
 extern void verify_async_exit(struct thread_data *);
 
+/*
+ * Callbacks for pasting formats in the pattern buffer
+ */
+extern int paste_blockoff(char *buf, unsigned int len, void *priv);
+
 struct thread_rand32_state {
 	uint32_t s[4];
 };
-- 
2.4.4

