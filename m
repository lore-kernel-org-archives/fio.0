Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40685 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbIEMAR (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 5 Sep 2015 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZYC8k-00042M-D0
	for fio@vger.kernel.org; Sat, 05 Sep 2015 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150905120001.622212C005B@kernel.dk>
Date: Sat,  5 Sep 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c6d140fb8c0cf58d61bbd42ea5382f42d3b8fa20:

  Fix aux_path for verify state saving (2015-08-21 11:09:03 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 61b9861d45dcd6be23c527861b32aa36bcd1b682:

  use 'lib/pattern' to parse patterns and paste formats into buffers (2015-09-04 13:33:09 -0600)

----------------------------------------------------------------
Andrey Kuzmin (1):
      backend: fix comparison of 'ret' pointer

Ken Raeburn (1):
      Retry bdev cache invalidation for EAGAIN errors

Roman Pen (6):
      lib/strntol: add 'strntol' function
      lib/pattern: add set of functions to parse combined pattern input
      replace 'fill_pattern' with 'cpy_pattern' from 'lib/pattern.c'
      verify: use 'cmp_pattern' from 'lib/pattern.c' to compare pattern and buffer
      add FIELD_SIZE macro to calculate the size of the specified field
      use 'lib/pattern' to parse patterns and paste formats into buffers

 HOWTO            |  20 ++-
 Makefile         |   9 +-
 backend.c        |   2 +-
 filesetup.c      |  12 ++
 fio.h            |   3 +-
 lib/pattern.c    | 464 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/pattern.h    |  47 ++++++
 lib/rand.c       |  31 +---
 lib/rand.h       |   1 -
 lib/strntol.c    |  31 ++++
 lib/strntol.h    |   6 +
 options.c        | 166 ++++----------------
 thread_options.h |   3 +
 verify.c         |  62 +++++---
 verify.h         |   5 +
 15 files changed, 669 insertions(+), 193 deletions(-)
 create mode 100644 lib/pattern.c
 create mode 100644 lib/pattern.h
 create mode 100644 lib/strntol.c
 create mode 100644 lib/strntol.h

---

Diff of recent changes:

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
diff --git a/Makefile b/Makefile
index 24663a4..296655b 100644
--- a/Makefile
+++ b/Makefile
@@ -39,11 +39,11 @@ endif
 SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		lib/rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
-		lib/num2str.c lib/ieee754.c engines/cpu.c \
+		lib/num2str.c lib/ieee754.c lib/strntol.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		memalign.c server.c client.c iolog.c backend.c libfio.c flow.c \
-		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
-		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
+		cconv.c lib/prio_tree.c lib/zipf.c lib/axmap.c lib/pattern.c \
+		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c json.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c \
@@ -198,7 +198,8 @@ T_IEEE_OBJS += lib/ieee754.o
 T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
-T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o lib/gauss.o t/genzipf.o
+T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o \
+		lib/strntol.o lib/gauss.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
diff --git a/backend.c b/backend.c
index d41c742..dec0d55 100644
--- a/backend.c
+++ b/backend.c
@@ -540,7 +540,7 @@ sync_done:
 			*ret = ret2;
 		break;
 	default:
-		assert(ret < 0);
+		assert(*ret < 0);
 		td_verror(td, -(*ret), "td_io_queue");
 		break;
 	}
diff --git a/filesetup.c b/filesetup.c
index 881aeee..e1dedcd 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -413,7 +413,19 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 	else if (f->filetype == FIO_TYPE_FILE)
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
 	else if (f->filetype == FIO_TYPE_BD) {
+		int retry_count = 0;
+
 		ret = blockdev_invalidate_cache(f);
+		while (ret < 0 && errno == EAGAIN && retry_count++ < 25) {
+			/*
+			 * Linux multipath devices reject ioctl while
+			 * the maps are being updated. That window can
+			 * last tens of milliseconds; we'll try up to
+			 * a quarter of a second.
+			 */
+			usleep(10000);
+			ret = blockdev_invalidate_cache(f);
+		}
 		if (ret < 0 && errno == EACCES && geteuid()) {
 			if (!root_warn) {
 				log_err("fio: only root may flush block "
diff --git a/fio.h b/fio.h
index 53d8256..a00e8f2 100644
--- a/fio.h
+++ b/fio.h
@@ -668,7 +668,8 @@ extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
 #ifdef FIO_INTERNAL
-#define ARRAY_SIZE(x) (sizeof((x)) / (sizeof((x)[0])))
+#define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
+#define FIELD_SIZE(s, f) (sizeof(((typeof(s))0)->f))
 #endif
 
 enum {
diff --git a/lib/pattern.c b/lib/pattern.c
new file mode 100644
index 0000000..6cb5995
--- /dev/null
+++ b/lib/pattern.c
@@ -0,0 +1,464 @@
+#include "fio.h"
+#include "strntol.h"
+#include "pattern.h"
+
+/**
+ * parse_string() - parses string in double quotes, like "abc"
+ * @beg - string input
+ * @out - output buffer where parsed number should be put
+ * @out_len - length of the output buffer
+ * @filled - pointer where number of bytes successfully
+ *           parsed will be put
+ *
+ * Returns the end pointer where parsing has been stopped.
+ * In case of parsing error or lack of bytes in output buffer
+ * NULL will be returned.
+ */
+static const char *parse_string(const char *beg, char *out,
+				unsigned int out_len,
+				unsigned int *filled)
+{
+	const char *end;
+
+	if (!out_len)
+		return NULL;
+
+	assert(*beg == '"');
+	beg++;
+	end = strchr(beg, '"');
+	if (!end)
+		return NULL;
+	if (end - beg > out_len)
+		return NULL;
+
+	memcpy(out, beg, end - beg);
+	*filled = end - beg;
+
+	/* Catch up quote */
+	return end + 1;
+}
+
+/**
+ * parse_number() - parses numbers
+ * @beg - string input
+ * @out - output buffer where parsed number should be put
+ * @out_len - length of the output buffer
+ * @filled - pointer where number of bytes successfully
+ *           parsed will be put
+ *
+ * Supports decimals in the range [INT_MIN, INT_MAX] and
+ * hexidecimals of any size, which should be started with
+ * prefix 0x or 0X.
+ *
+ * Returns the end pointer where parsing has been stopped.
+ * In case of parsing error or lack of bytes in output buffer
+ * NULL will be returned.
+ */
+static const char *parse_number(const char *beg, char *out,
+				unsigned int out_len,
+				unsigned int *filled)
+{
+	const char *end;
+	unsigned int val;
+	long lval;
+	int num, i;
+
+	if (!out_len)
+		return NULL;
+
+	num = 0;
+	sscanf(beg, "0%*[xX]%*[0-9a-fA-F]%n", &num);
+	if (num == 0) {
+		/* Here we are trying to parse decimal */
+
+		char *_end;
+
+		/* Looking ahead */
+		_end = strcasestr(beg, "0x");
+		if (_end)
+			num = _end - beg;
+		if (num)
+			lval = strntol(beg, num, &_end, 10);
+		else
+			lval = strtol(beg, &_end, 10);
+		if (beg == _end || lval > INT_MAX || lval < INT_MIN)
+			return NULL;
+		end = _end;
+		i = 0;
+		if (!lval) {
+			num    = 0;
+			out[i] = 0x00;
+			i      = 1;
+		} else {
+			val = (unsigned int)lval;
+			for (; val && out_len; out_len--, i++, val >>= 8)
+				out[i] = val & 0xff;
+			if (val)
+				return NULL;
+		}
+	} else {
+		assert(num > 2);
+
+		/* Catch up 0x prefix */
+		num -= 2;
+		beg += 2;
+
+		/* Look back, handle this combined string: 0xff0x14 */
+		if (beg[num] && !strncasecmp(&beg[num - 1], "0x", 2))
+			num--;
+
+		end  = beg + num;
+
+		for (i = 0; num && out_len;
+		     out_len--, i++, num -= 2, beg += 2) {
+			const char *fmt;
+
+			fmt = (num & 1 ? "%1hhx" : "%2hhx");
+			sscanf(beg, fmt, &out[i]);
+			if (num & 1) {
+				num++;
+				beg--;
+			}
+		}
+		if (num)
+			return NULL;
+	}
+
+	*filled = i;
+	return end;
+
+}
+
+/**
+ * parse_format() - parses formats, like %o, etc
+ * @in - string input
+ * @out - output buffer where space for format should be reserved
+ * @parsed - number of bytes which were already parsed so far
+ * @out_len - length of the output buffer
+ * @fmt_desc - format descritor array, what we expect to find
+ * @fmt_desc_sz - size of the format descritor array
+ * @fmt - format array, the output
+ * @fmt_sz - size of format array
+ *
+ * This function tries to find formats, e.g.:
+ *   %o - offset of the block
+ *
+ * In case of successfull parsing it fills the format param
+ * with proper offset and the size of the expected value, which
+ * should be pasted into buffer using the format 'func' callback.
+ *
+ * Returns the end pointer where parsing has been stopped.
+ * In case of parsing error or lack of bytes in output buffer
+ * NULL will be returned.
+ */
+static const char *parse_format(const char *in, char *out, unsigned int parsed,
+				unsigned int out_len, unsigned int *filled,
+				const struct pattern_fmt_desc *fmt_desc,
+				unsigned int fmt_desc_sz,
+				struct pattern_fmt *fmt, unsigned int fmt_sz)
+{
+	int i;
+	struct pattern_fmt *f = NULL;
+	unsigned int len = 0;
+
+	if (!out_len || !fmt_desc || !fmt_desc_sz || !fmt || !fmt_sz)
+		return NULL;
+
+	assert(*in == '%');
+
+	for (i = 0; i < fmt_desc_sz; i++) {
+		const struct pattern_fmt_desc *desc;
+
+		desc = &fmt_desc[i];
+		len  = strlen(desc->fmt);
+		if (0 == strncmp(in, desc->fmt, len)) {
+			fmt->desc = desc;
+			fmt->off  = parsed;
+			f = fmt;
+			break;
+		}
+	}
+
+	if (!f)
+		return NULL;
+	if (f->desc->len > out_len)
+		return NULL;
+
+	memset(out, '\0', f->desc->len);
+	*filled = f->desc->len;
+
+	return in + len;
+}
+
+/**
+ * parse_and_fill_pattern() - Parses combined input, which consists of strings,
+ *                            numbers and pattern formats.
+ * @in - string input
+ * @in_len - size of the input string
+ * @out - output buffer where parsed result will be put
+ * @out_len - lengths of the output buffer
+ * @fmt_desc - array of pattern format descriptors [input]
+ * @fmt_desc_sz - size of the format descriptor array
+ * @fmt - array of pattern formats [output]
+ * @fmt_sz - pointer where the size of pattern formats array stored [input],
+ *           after successfull parsing this pointer will contain the number
+ *           of parsed formats if any [output].
+ *
+ * strings:
+ *   bytes sequence in double quotes, e.g. "123".
+ *   NOTE: there is no way to escape quote, so "123\"abc" does not work.
+ *
+ * numbers:
+ *   hexidecimal - sequence of hex bytes starting from 0x or 0X prefix,
+ *                 e.g. 0xff12ceff1100ff
+ *   decimal     - decimal number in range [INT_MIN, INT_MAX]
+ *
+ * formats:
+ *   %o - offset of block, reserved 8 bytes.
+ *
+ * Explicit examples of combined string:
+ * #1                  #2                 #3        #4
+ *    in="abcd"          in=-1024           in=66     in=0xFF0X1
+ *   out=61 62 63 64    out=00 fc ff ff    out=42    out=ff 01
+ *
+ * #5                                #6
+ *    in=%o                            in="123"0xFFeeCC
+ *   out=00 00 00 00 00 00 00 00      out=31 32 33 ff ec cc
+ *
+ * #7
+ *   in=-100xab"1"%o"2"
+ *  out=f6 ff ff ff ab 31 00 00 00 00 00 00 00 00 32
+ *
+ * #9
+ *    in=%o0xdeadbeef%o
+ *   out=00 00 00 00 00 00 00 00 de ad be ef 00 00 00 00 00 00 00 00
+ *
+ * #10
+ *    in=0xfefefefefefefefefefefefefefefefefefefefefe
+ *   out=fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
+ *
+ * Returns number of bytes filled or err < 0 in case of failure.
+ */
+int parse_and_fill_pattern(const char *in, unsigned int in_len,
+			   char *out, unsigned int out_len,
+			   const struct pattern_fmt_desc *fmt_desc,
+			   unsigned int fmt_desc_sz,
+			   struct pattern_fmt *fmt,
+			   unsigned int *fmt_sz_out)
+{
+	const char *beg, *end, *out_beg = out;
+	unsigned int total = 0, fmt_rem = 0;
+
+	if (!in || !in_len || !out || !out_len)
+		return -EINVAL;
+	if (fmt_sz_out)
+		fmt_rem = *fmt_sz_out;
+
+	beg = in;
+	do {
+		unsigned int filled;
+		int parsed_fmt;
+
+		filled     = 0;
+		parsed_fmt = 0;
+
+		switch (*beg) {
+		case '"':
+			end = parse_string(beg, out, out_len, &filled);
+			break;
+		case '%':
+			end = parse_format(beg, out, out - out_beg, out_len,
+					   &filled, fmt_desc, fmt_desc_sz,
+					   fmt, fmt_rem);
+			parsed_fmt = 1;
+			break;
+		default:
+			end = parse_number(beg, out, out_len, &filled);
+			break;
+		}
+
+		if (!end)
+			return -EINVAL;
+
+		if (parsed_fmt) {
+			assert(fmt_rem);
+			fmt_rem--;
+			fmt++;
+		}
+
+		assert(end - beg <= in_len);
+		in_len -= end - beg;
+		beg     = end;
+
+		assert(filled);
+		assert(filled <= out_len);
+		out_len -= filled;
+		out     += filled;
+		total   += filled;
+
+	} while (in_len);
+
+	if (fmt_sz_out)
+		*fmt_sz_out -= fmt_rem;
+	return total;
+}
+
+/**
+ * dup_pattern() - Duplicates part of the pattern all over the buffer.
+ *
+ * Returns 0 in case of success or errno < 0 in case of failure.
+ */
+static int dup_pattern(char *out, unsigned int out_len, unsigned int pattern_len)
+{
+	unsigned int left, len, off;
+
+	if (out_len <= pattern_len)
+		/* Normal case */
+		return 0;
+
+	off  = pattern_len;
+	left = (out_len - off);
+	len  = min(left, off);
+
+	/* Duplicate leftover */
+	while (left) {
+		memcpy(out + off, out, len);
+		left -= len;
+		off <<= 1;
+		len   = min(left, off);
+	}
+
+	return 0;
+}
+
+/**
+ * cpy_pattern() - Copies pattern to the buffer.
+ *
+ * Function copies pattern along the whole buffer.
+ *
+ * Returns 0 in case of success or errno < 0 in case of failure.
+ */
+int cpy_pattern(const char *pattern, unsigned int pattern_len,
+		char *out, unsigned int out_len)
+{
+	unsigned int len;
+
+	if (!pattern || !pattern_len || !out || !out_len)
+		return -EINVAL;
+
+	/* Copy pattern */
+	len = min(pattern_len, out_len);
+	memcpy(out, pattern, len);
+
+	/* Spread filled chunk all over the buffer */
+	return dup_pattern(out, out_len, pattern_len);
+}
+
+/**
+ * cmp_pattern() - Compares pattern and buffer.
+ *
+ * For the sake of performance this function avoids any loops.
+ * Firstly it tries to compare the buffer itself, checking that
+ * buffer consists of repeating patterns along the buffer size.
+ *
+ * If the difference is not found then the function tries to compare
+ * buffer and pattern.
+ *
+ * Returns 0 in case of success or errno < 0 in case of failure.
+ */
+int cmp_pattern(const char *pattern, unsigned int pattern_size,
+		unsigned int off, const char *buf, unsigned int len)
+{
+	int rc;
+	unsigned int size;
+
+	/* Find the difference in buffer */
+	if (len > pattern_size) {
+		rc = memcmp(buf, buf + pattern_size, len - pattern_size);
+		if (rc)
+			return -EILSEQ;
+	}
+	/* Compare second part of the pattern with buffer */
+	if (off) {
+		size = min(len, pattern_size - off);
+		rc = memcmp(buf, pattern + off, size);
+		if (rc)
+			return -EILSEQ;
+		buf += size;
+		len -= size;
+	}
+	/* Compare first part of the pattern or the whole pattern
+	 * with buffer */
+	if (len) {
+		size = min(len, (off ? off : pattern_size));
+		rc = memcmp(buf, pattern, size);
+		if (rc)
+			return -EILSEQ;
+	}
+
+	return 0;
+}
+
+/**
+ * paste_format_inplace() - Pastes parsed formats to the pattern.
+ *
+ * This function pastes formats to the pattern. If @fmt_sz is 0
+ * function does nothing and pattern buffer is left untouched.
+ *
+ * Returns 0 in case of success or errno < 0 in case of failure.
+ */
+int paste_format_inplace(char *pattern, unsigned int pattern_len,
+			 struct pattern_fmt *fmt, unsigned int fmt_sz,
+			 void *priv)
+{
+	int i, rc;
+	unsigned int len;
+
+	if (!pattern || !pattern_len || !fmt)
+		return -EINVAL;
+
+	/* Paste formats for first pattern chunk */
+	for (i = 0; i < fmt_sz; i++) {
+		struct pattern_fmt *f;
+
+		f = &fmt[i];
+		if (pattern_len <= f->off)
+			break;
+		len = min(pattern_len - f->off, f->desc->len);
+		rc  = f->desc->paste(pattern + f->off, len, priv);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+/**
+ * paste_format() - Pastes parsed formats to the buffer.
+ *
+ * This function copies pattern to the buffer, pastes format
+ * into it and then duplicates pattern all over the buffer size.
+ *
+ * Returns 0 in case of success or errno < 0 in case of failure.
+ */
+int paste_format(const char *pattern, unsigned int pattern_len,
+		 struct pattern_fmt *fmt, unsigned int fmt_sz,
+		 char *out, unsigned int out_len, void *priv)
+{
+	int rc;
+	unsigned int len;
+
+	if (!pattern || !pattern_len || !out || !out_len)
+		return -EINVAL;
+
+	/* Copy pattern */
+	len = min(pattern_len, out_len);
+	memcpy(out, pattern, len);
+
+	rc = paste_format_inplace(out, len, fmt, fmt_sz, priv);
+	if (rc)
+		return rc;
+
+	/* Spread filled chunk all over the buffer */
+	return dup_pattern(out, out_len, pattern_len);
+}
diff --git a/lib/pattern.h b/lib/pattern.h
new file mode 100644
index 0000000..9f937f0
--- /dev/null
+++ b/lib/pattern.h
@@ -0,0 +1,47 @@
+#ifndef FIO_PARSE_PATTERN_H
+#define FIO_PARSE_PATTERN_H
+
+struct pattern_fmt;
+
+/**
+ * Pattern format description. The input for 'parse_pattern'.
+ * Describes format with its name and callback, which should
+ * be called to paste something inside the buffer.
+ */
+struct pattern_fmt_desc {
+	const char  *fmt;
+	unsigned int len;
+	int (*paste)(char *buf, unsigned int len, void *priv);
+};
+
+/**
+ * Pattern format. The output of 'parse_pattern'.
+ * Describes the exact position inside the xbuffer.
+ */
+struct pattern_fmt {
+	unsigned int off;
+	const struct pattern_fmt_desc *desc;
+};
+
+int parse_and_fill_pattern(const char *in, unsigned int in_len,
+			   char *out, unsigned int out_len,
+			   const struct pattern_fmt_desc *fmt_desc,
+			   unsigned int fmt_desc_sz,
+			   struct pattern_fmt *fmt,
+			   unsigned int *fmt_sz_out);
+
+int paste_format_inplace(char *pattern, unsigned int pattern_len,
+			 struct pattern_fmt *fmt, unsigned int fmt_sz,
+			 void *priv);
+
+int paste_format(const char *pattern, unsigned int pattern_len,
+		 struct pattern_fmt *fmt, unsigned int fmt_sz,
+		 char *out, unsigned int out_len, void *priv);
+
+int cpy_pattern(const char *pattern, unsigned int pattern_len,
+		char *out, unsigned int out_len);
+
+int cmp_pattern(const char *pattern, unsigned int pattern_size,
+		unsigned int off, const char *buf, unsigned int len);
+
+#endif
diff --git a/lib/rand.c b/lib/rand.c
index 2e4c66e..1b661a8 100644
--- a/lib/rand.c
+++ b/lib/rand.c
@@ -36,6 +36,7 @@
 #include <string.h>
 #include <assert.h>
 #include "rand.h"
+#include "lib/pattern.h"
 #include "../hash.h"
 
 int arch_random;
@@ -134,32 +135,6 @@ unsigned long fill_random_buf(struct frand_state *fs, void *buf,
 	return r;
 }
 
-void fill_pattern(void *p, unsigned int len, char *pattern,
-		  unsigned int pattern_bytes)
-{
-	switch (pattern_bytes) {
-	case 0:
-		assert(0);
-		break;
-	case 1:
-		memset(p, pattern[0], len);
-		break;
-	default: {
-		unsigned int i = 0, size = 0;
-		unsigned char *b = p;
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
 void __fill_random_buf_percentage(unsigned long seed, void *buf,
 				  unsigned int percentage,
 				  unsigned int segment, unsigned int len,
@@ -169,7 +144,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 
 	if (percentage == 100) {
 		if (pbytes)
-			fill_pattern(buf, len, pattern, pbytes);
+			(void)cpy_pattern(pattern, pbytes, buf, len);
 		else
 			memset(buf, 0, len);
 		return;
@@ -199,7 +174,7 @@ void __fill_random_buf_percentage(unsigned long seed, void *buf,
 			this_len = len;
 
 		if (pbytes)
-			fill_pattern(buf, this_len, pattern, pbytes);
+			(void)cpy_pattern(pattern, pbytes, buf, this_len);
 		else
 			memset(buf, 0, this_len);
 
diff --git a/lib/rand.h b/lib/rand.h
index cab9158..b99f618 100644
--- a/lib/rand.h
+++ b/lib/rand.h
@@ -110,6 +110,5 @@ extern void __fill_random_buf(void *buf, unsigned int len, unsigned long seed);
 extern unsigned long fill_random_buf(struct frand_state *, void *buf, unsigned int len);
 extern void __fill_random_buf_percentage(unsigned long, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
 extern unsigned long fill_random_buf_percentage(struct frand_state *, void *, unsigned int, unsigned int, unsigned int, char *, unsigned int);
-extern void fill_pattern(void *p, unsigned int len, char *pattern, unsigned int pattern_bytes);
 
 #endif
diff --git a/lib/strntol.c b/lib/strntol.c
new file mode 100644
index 0000000..713f63b
--- /dev/null
+++ b/lib/strntol.c
@@ -0,0 +1,31 @@
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+
+long strntol(const char *str, size_t sz, char **end, int base)
+{
+	/* Expect that digit representation of LONG_MAX/MIN
+	 * not greater than this buffer */
+	char buf[24];
+	long ret;
+	const char *beg = str;
+
+	/* Catch up leading spaces */
+	for (; beg && sz && *beg == ' '; beg++, sz--)
+		;
+
+	if (!sz || sz >= sizeof(buf)) {
+		if (end)
+			*end = (char *)str;
+		return 0;
+	}
+
+	memcpy(buf, beg, sz);
+	buf[sz] = '\0';
+	ret = strtol(buf, end, base);
+	if (ret == LONG_MIN || ret == LONG_MAX)
+		return ret;
+	if (end)
+		*end = (char *)str + (*end - buf);
+	return ret;
+}
diff --git a/lib/strntol.h b/lib/strntol.h
new file mode 100644
index 0000000..68f5d1b
--- /dev/null
+++ b/lib/strntol.h
@@ -0,0 +1,6 @@
+#ifndef FIO_STRNTOL_H
+#define FIO_STRNTOL_H
+
+long strntol(const char *str, size_t sz, char **end, int base);
+
+#endif
diff --git a/options.c b/options.c
index e040495..fab4675 100644
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
index 7608caf..227d220 100644
--- a/verify.c
+++ b/verify.c
@@ -13,6 +13,7 @@
 #include "trim.h"
 #include "lib/rand.h"
 #include "lib/hweight.h"
+#include "lib/pattern.h"
 
 #include "crc/md5.h"
 #include "crc/crc64.h"
@@ -35,7 +36,7 @@ static void __fill_hdr(struct verify_header *hdr, int verify_type, uint32_t len,
 
 void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len)
 {
-	fill_pattern(p, len, td->o.buffer_pattern, td->o.buffer_pattern_bytes);
+	(void)cpy_pattern(td->o.buffer_pattern, td->o.buffer_pattern_bytes, p, len);
 }
 
 void __fill_buffer(struct thread_options *o, unsigned long seed, void *p,
@@ -67,13 +68,17 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
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
 
-	fill_pattern(p, len, o->verify_pattern, o->verify_pattern_bytes);
+	(void)paste_format(td->o.verify_pattern, td->o.verify_pattern_bytes,
+			   td->o.verify_fmt, td->o.verify_fmt_sz,
+			   p, len, io_u);
 	io_u->buf_filled_len = len;
 }
 
@@ -358,33 +363,34 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	struct io_u *io_u = vc->io_u;
 	char *buf, *pattern;
 	unsigned int header_size = __hdr_size(td->o.verify);
-	unsigned int len, mod, i, size, pattern_size;
+	unsigned int len, mod, i, pattern_size;
+	int rc;
 
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
-
-	for (i = 0; i < len; i += size) {
-		size = pattern_size - mod;
-		if (size > (len - i))
-			size = len - i;
-		if (memcmp(buf + i, pattern + mod, size))
-			/* Let the slow compare find the first mismatch byte. */
-			break;
-		mod = 0;
-	}
+	mod = (get_hdr_inc(td, io_u) * vc->hdr_num + header_size) % pattern_size;
 
-	for (; i < len; i++) {
+	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
+	if (!rc)
+		return 0;
+
+	/* Slow path, compare each byte */
+	for (i = 0; i < len; i++) {
 		if (buf[i] != pattern[mod]) {
 			unsigned int bits;
 
 			bits = hweight8(buf[i] ^ pattern[mod]);
-			log_err("fio: got pattern %x, wanted %x. Bad bits %d\n",
-				buf[i], pattern[mod], bits);
+			log_err("fio: got pattern '%02x', wanted '%02x'. Bad bits %d\n",
+				(unsigned char)buf[i],
+				(unsigned char)pattern[mod],
+				bits);
 			log_err("fio: bad pattern block offset %u\n", i);
 			dump_verify_buffers(hdr, vc);
 			return EILSEQ;
@@ -394,7 +400,9 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 			mod = 0;
 	}
 
-	return 0;
+	/* Unreachable line */
+	assert(0);
+	return EILSEQ;
 }
 
 static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
@@ -1323,6 +1331,18 @@ void verify_async_exit(struct thread_data *td)
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
index 8305eeb..74cad85 100644
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
