Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33851 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbbHSKdV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:21 -0400
Received: by wicne3 with SMTP id ne3so122909833wic.1
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:19 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 2/6] lib/pattern: add set of functions to parse combined pattern input
Date: Wed, 19 Aug 2015 12:33:07 +0200
Message-Id: <1439980391-2311-3-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

The idea of this patch is to have several helpers to parse combined
pattern input, which can consists of strings, numbers and formats.

For example now pattern can be combined and look like this string:

 input : 0xdeadbeef"123"0xdeadface
 output: de ad be ef 31 32 33 de ad fa ce

  or

 input : -99"some string"0x66
 output: 9d ff ff ff 73 6f 6d 65 20 73 74 72 69 6e 67 66

  or with formats

 input : 0xdeadface0xffff%o
 output: de ad fa ce ff ff 00 00 00 00 00 00 00 00

 where %o - offset of the block, reserved 8 bytes

 Space for formats is reserved in output buffer.
 When buffer will be ready to be written to disk - 'paste' callback
 should be called for each pattern format. Each callback is responsible
 for writing data inside the reserved space in the output buffer.

Format array can be extended at any time, all you need is to provide
the name of the format and correct 'paste' callback.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 Makefile      |   4 +-
 lib/pattern.c | 464 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lib/pattern.h |  47 ++++++
 3 files changed, 513 insertions(+), 2 deletions(-)
 create mode 100644 lib/pattern.c
 create mode 100644 lib/pattern.h

diff --git a/Makefile b/Makefile
index fe0da43..cb0a1b5 100644
--- a/Makefile
+++ b/Makefile
@@ -42,8 +42,8 @@ SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/num2str.c lib/ieee754.c lib/strntol.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		memalign.c server.c client.c iolog.c backend.c libfio.c flow.c \
-		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
-		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
+		cconv.c lib/prio_tree.c lib/zipf.c lib/axmap.c lib/pattern.c \
+		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c json.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
 		lib/tp.c lib/bloom.c lib/gauss.c lib/mountcheck.c workqueue.c \
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
-- 
2.4.4

