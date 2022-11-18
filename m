Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137BCC4332F
	for <fio@archiver.kernel.org>; Fri, 18 Nov 2022 23:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiKRX2s (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 18 Nov 2022 18:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235739AbiKRX2M (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 18 Nov 2022 18:28:12 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626A6C0511
        for <fio@vger.kernel.org>; Fri, 18 Nov 2022 15:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=+zqVHAMtQhRZahC/Qm9BoJdkcdkNgIdP3ax8HGD2bdo=; b=kLR/CE3RM+bdif0EjkjkorbETR
        Vp9S6MCMlaVYBCEaOp8+bbXNQiIYdxLFiLP88wnAonFzRjmHYQpQbagN5o+1y0z20tg1Khqhyn9Vd
        ej81CzKhvpk3ZXDfx5t365GQ0IoEj94/TzzBUayZLYi2DIencXIa7NwESqPs6v0jVQFzdDwdd42Aw
        qTD7F98K3m/6QDPa1V8ImsSDt7KnibNS1ZVa6l80E7saiXepk8r7aRNLjbpqzlwAmrkJz2hXg75Ju
        GLAW//feA4wJBdMzGTjncf/Zdj0gNzRaCLreqpYopWsAUjAK+QBf1spneHfD+4qLd4Ly6Asp3vWML
        aExynJ9A==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAaZ-005chu-Jv; Fri, 18 Nov 2022 16:16:06 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1owAaZ-000MLX-7T; Fri, 18 Nov 2022 16:16:03 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Fri, 18 Nov 2022 16:15:59 -0700
Message-Id: <20221118231601.85837-5-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221118231601.85837-1-logang@deltatee.com>
References: <20221118231601.85837-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v3 4/6] options: Support arbitrarily long pattern buffers
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Dynamically allocate the pattern buffer to remove the 512B length
restriction. To accomplish this, store a pointer instead of a fixed
block of memory for the buffers in the thread_options structure.
Then introduce and use the function parse_and_fill_pattern_alloc()
which will calculate the approprite size of the buffer and allocate
it before filling it.

The buffers will be freed, along with a number of string buffers
in free_thread_options_to_cpu(). They will also be reallocated (if
necessary) when receiving them over the wire with
convert_thread_options_to_cpu().

This allows for specifying real world compressible data (eg. The
Calgary Corpus) for the buffer_pattern option.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 cconv.c          | 11 ++++++++++
 lib/pattern.c    | 52 +++++++++++++++++++++++++++++++++++++++++++-----
 lib/pattern.h    | 21 ++++++++++++++-----
 options.c        | 10 +++++-----
 stat.h           |  1 -
 thread_options.h |  4 ++--
 6 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/cconv.c b/cconv.c
index bb1af4970e97..d755844f51b0 100644
--- a/cconv.c
+++ b/cconv.c
@@ -48,6 +48,9 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->profile);
 	free(o->cgroup);
 
+	free(o->verify_pattern);
+	free(o->buffer_pattern);
+
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		free(o->bssplit[i]);
 		free(o->zone_split[i]);
@@ -185,6 +188,10 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	    thread_options_pack_size(o) > top_sz)
 		return -EINVAL;
 
+	o->verify_pattern = realloc(o->verify_pattern,
+				    o->verify_pattern_bytes);
+	o->buffer_pattern = realloc(o->buffer_pattern,
+				    o->buffer_pattern_bytes);
 	memcpy(o->verify_pattern, top->patterns, o->verify_pattern_bytes);
 	memcpy(o->buffer_pattern, &top->patterns[o->verify_pattern_bytes],
 	       o->buffer_pattern_bytes);
@@ -651,8 +658,10 @@ int fio_test_cconv(struct thread_options *__o)
 	int ret;
 
 	o1.verify_pattern_bytes = 61;
+	o1.verify_pattern = malloc(o1.verify_pattern_bytes);
 	memset(o1.verify_pattern, 'V', o1.verify_pattern_bytes);
 	o1.buffer_pattern_bytes = 15;
+	o1.buffer_pattern = malloc(o1.buffer_pattern_bytes);
 	memset(o1.buffer_pattern, 'B', o1.buffer_pattern_bytes);
 
 	top_sz = thread_options_pack_size(&o1);
@@ -672,5 +681,7 @@ out:
 	free_thread_options_to_cpu(&o2);
 	free(top2);
 	free(top1);
+	free(o1.buffer_pattern);
+	free(o1.verify_pattern);
 	return ret;
 }
diff --git a/lib/pattern.c b/lib/pattern.c
index d324263c2b34..1ae05758f768 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -327,11 +327,11 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  *
  * Returns number of bytes filled or err < 0 in case of failure.
  */
-int parse_and_fill_pattern(const char *in, unsigned int in_len,
-			   char *out, unsigned int out_len,
-			   const struct pattern_fmt_desc *fmt_desc,
-			   struct pattern_fmt *fmt,
-			   unsigned int *fmt_sz_out)
+static int parse_and_fill_pattern(const char *in, unsigned int in_len,
+				  char *out, unsigned int out_len,
+				  const struct pattern_fmt_desc *fmt_desc,
+				  struct pattern_fmt *fmt,
+				  unsigned int *fmt_sz_out)
 {
 	const char *beg, *end, *out_beg = out;
 	unsigned int total = 0, fmt_rem = 0;
@@ -392,6 +392,48 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 	return total;
 }
 
+/**
+ * parse_and_fill_pattern_alloc() - Parses combined input, which consists of
+ *				    strings, numbers and pattern formats and
+ *				    allocates a buffer for the result.
+ *
+ * @in - string input
+ * @in_len - size of the input string
+ * @out - pointer to the output buffer pointer, this will be set to the newly
+ *        allocated pattern buffer which must be freed by the caller
+ * @fmt_desc - array of pattern format descriptors [input]
+ * @fmt - array of pattern formats [output]
+ * @fmt_sz - pointer where the size of pattern formats array stored [input],
+ *           after successful parsing this pointer will contain the number
+ *           of parsed formats if any [output].
+ *
+ * See documentation on parse_and_fill_pattern() above for a description
+ * of the functionality.
+ *
+ * Returns number of bytes filled or err < 0 in case of failure.
+ */
+int parse_and_fill_pattern_alloc(const char *in, unsigned int in_len,
+		char **out, const struct pattern_fmt_desc *fmt_desc,
+		struct pattern_fmt *fmt, unsigned int *fmt_sz_out)
+{
+	int count;
+
+	count = parse_and_fill_pattern(in, in_len, NULL, MAX_PATTERN_SIZE,
+				       fmt_desc, fmt, fmt_sz_out);
+	if (count < 0)
+		return count;
+
+	*out = malloc(count);
+	count = parse_and_fill_pattern(in, in_len, *out, count, fmt_desc,
+				       fmt, fmt_sz_out);
+	if (count < 0) {
+		free(*out);
+		*out = NULL;
+	}
+
+	return count;
+}
+
 /**
  * dup_pattern() - Duplicates part of the pattern all over the buffer.
  *
diff --git a/lib/pattern.h b/lib/pattern.h
index a6d9d6b4275c..7123b42d6747 100644
--- a/lib/pattern.h
+++ b/lib/pattern.h
@@ -1,6 +1,19 @@
 #ifndef FIO_PARSE_PATTERN_H
 #define FIO_PARSE_PATTERN_H
 
+/*
+ * The pattern is dynamically allocated, but that doesn't mean there
+ * are not limits. The network protocol has a limit of
+ * FIO_SERVER_MAX_CMD_MB and potentially two patterns must fit in there.
+ * There's also a need to verify the incoming data from the network and
+ * this provides a sensible check.
+ *
+ * 128MiB is an arbitrary limit that meets these criteria. The patterns
+ * tend to be truncated at the IO size anyway and IO sizes that large
+ * aren't terribly practical.
+ */
+#define MAX_PATTERN_SIZE	(128 << 20)
+
 /**
  * Pattern format description. The input for 'parse_pattern'.
  * Describes format with its name and callback, which should
@@ -21,11 +34,9 @@ struct pattern_fmt {
 	const struct pattern_fmt_desc *desc;
 };
 
-int parse_and_fill_pattern(const char *in, unsigned int in_len,
-			   char *out, unsigned int out_len,
-			   const struct pattern_fmt_desc *fmt_desc,
-			   struct pattern_fmt *fmt,
-			   unsigned int *fmt_sz_out);
+int parse_and_fill_pattern_alloc(const char *in, unsigned int in_len,
+		char **out, const struct pattern_fmt_desc *fmt_desc,
+		struct pattern_fmt *fmt, unsigned int *fmt_sz_out);
 
 int paste_format_inplace(char *pattern, unsigned int pattern_len,
 			 struct pattern_fmt *fmt, unsigned int fmt_sz,
diff --git a/options.c b/options.c
index 9e4d8cd1a92d..49612345b365 100644
--- a/options.c
+++ b/options.c
@@ -1488,8 +1488,8 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 	int ret;
 
 	/* FIXME: for now buffer pattern does not support formats */
-	ret = parse_and_fill_pattern(input, strlen(input), td->o.buffer_pattern,
-				     MAX_PATTERN_SIZE, NULL, NULL, NULL);
+	ret = parse_and_fill_pattern_alloc(input, strlen(input),
+				&td->o.buffer_pattern, NULL, NULL, NULL);
 	if (ret < 0)
 		return 1;
 
@@ -1537,9 +1537,9 @@ static int str_verify_pattern_cb(void *data, const char *input)
 	int ret;
 
 	td->o.verify_fmt_sz = FIO_ARRAY_SIZE(td->o.verify_fmt);
-	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
-				     MAX_PATTERN_SIZE, fmt_desc,
-				     td->o.verify_fmt, &td->o.verify_fmt_sz);
+	ret = parse_and_fill_pattern_alloc(input, strlen(input),
+			&td->o.verify_pattern, fmt_desc, td->o.verify_fmt,
+			&td->o.verify_fmt_sz);
 	if (ret < 0)
 		return 1;
 
diff --git a/stat.h b/stat.h
index 4c3bf71f3b92..8ceabc48c7e0 100644
--- a/stat.h
+++ b/stat.h
@@ -142,7 +142,6 @@ enum block_info_state {
 	BLOCK_STATE_COUNT,
 };
 
-#define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
 #define FIO_JOBDESC_SIZE	256
 #define FIO_VERROR_SIZE		128
diff --git a/thread_options.h b/thread_options.h
index d2897ac274bf..74e7ea45868b 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -144,7 +144,7 @@ struct thread_options {
 	unsigned int do_verify;
 	unsigned int verify_interval;
 	unsigned int verify_offset;
-	char verify_pattern[MAX_PATTERN_SIZE];
+	char *verify_pattern;
 	unsigned int verify_pattern_bytes;
 	struct pattern_fmt verify_fmt[8];
 	unsigned int verify_fmt_sz;
@@ -256,7 +256,7 @@ struct thread_options {
 	unsigned int zero_buffers;
 	unsigned int refill_buffers;
 	unsigned int scramble_buffers;
-	char buffer_pattern[MAX_PATTERN_SIZE];
+	char *buffer_pattern;
 	unsigned int buffer_pattern_bytes;
 	unsigned int compress_percentage;
 	unsigned int compress_chunk;
-- 
2.30.2

