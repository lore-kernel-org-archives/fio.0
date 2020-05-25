Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390201AbgEYMAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 May 2020 08:00:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23499C061A0E
        for <fio@vger.kernel.org>; Mon, 25 May 2020 05:00:10 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdBm2-0006Y0-Ch
        for fio@vger.kernel.org; Mon, 25 May 2020 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200525120002.1E5F31BC017F@kernel.dk>
Date: Mon, 25 May 2020 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d51e4ffa596b617cdb41680b31a4a3895a5307fc:

  Fio 3.20 (2020-05-23 11:14:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5df5882b267b1cc7d08f7e9038e6c1046d492936:

  Merge branch 'parse-and-fill-pattern' of https://github.com/bvanassche/fio (2020-05-24 12:03:56 -0600)

----------------------------------------------------------------
Bart Van Assche (3):
      Fix spelling in a source code comment
      Declare a static variable 'const'
      Do not read past the end of fmt_desc[]

Jens Axboe (1):
      Merge branch 'parse-and-fill-pattern' of https://github.com/bvanassche/fio

 lib/pattern.c | 13 ++++---------
 lib/pattern.h |  1 -
 options.c     |  9 +++++----
 3 files changed, 9 insertions(+), 14 deletions(-)

---

Diff of recent changes:

diff --git a/lib/pattern.c b/lib/pattern.c
index 2024f2e9..680a12be 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -204,8 +204,7 @@ static const char *parse_number(const char *beg, char *out,
  * @out - output buffer where space for format should be reserved
  * @parsed - number of bytes which were already parsed so far
  * @out_len - length of the output buffer
- * @fmt_desc - format descritor array, what we expect to find
- * @fmt_desc_sz - size of the format descritor array
+ * @fmt_desc - format descriptor array, what we expect to find
  * @fmt - format array, the output
  * @fmt_sz - size of format array
  *
@@ -223,19 +222,18 @@ static const char *parse_number(const char *beg, char *out,
 static const char *parse_format(const char *in, char *out, unsigned int parsed,
 				unsigned int out_len, unsigned int *filled,
 				const struct pattern_fmt_desc *fmt_desc,
-				unsigned int fmt_desc_sz,
 				struct pattern_fmt *fmt, unsigned int fmt_sz)
 {
 	int i;
 	struct pattern_fmt *f = NULL;
 	unsigned int len = 0;
 
-	if (!out_len || !fmt_desc || !fmt_desc_sz || !fmt || !fmt_sz)
+	if (!out_len || !fmt_desc || !fmt || !fmt_sz)
 		return NULL;
 
 	assert(*in == '%');
 
-	for (i = 0; i < fmt_desc_sz; i++) {
+	for (i = 0; fmt_desc[i].fmt; i++) {
 		const struct pattern_fmt_desc *desc;
 
 		desc = &fmt_desc[i];
@@ -267,7 +265,6 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  * @out - output buffer where parsed result will be put
  * @out_len - lengths of the output buffer
  * @fmt_desc - array of pattern format descriptors [input]
- * @fmt_desc_sz - size of the format descriptor array
  * @fmt - array of pattern formats [output]
  * @fmt_sz - pointer where the size of pattern formats array stored [input],
  *           after successfull parsing this pointer will contain the number
@@ -311,7 +308,6 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
 int parse_and_fill_pattern(const char *in, unsigned int in_len,
 			   char *out, unsigned int out_len,
 			   const struct pattern_fmt_desc *fmt_desc,
-			   unsigned int fmt_desc_sz,
 			   struct pattern_fmt *fmt,
 			   unsigned int *fmt_sz_out)
 {
@@ -340,8 +336,7 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 			break;
 		case '%':
 			end = parse_format(beg, out, out - out_beg, out_len,
-					   &filled, fmt_desc, fmt_desc_sz,
-					   fmt, fmt_rem);
+					   &filled, fmt_desc, fmt, fmt_rem);
 			parsed_fmt = 1;
 			break;
 		default:
diff --git a/lib/pattern.h b/lib/pattern.h
index 2d655ad0..a6d9d6b4 100644
--- a/lib/pattern.h
+++ b/lib/pattern.h
@@ -24,7 +24,6 @@ struct pattern_fmt {
 int parse_and_fill_pattern(const char *in, unsigned int in_len,
 			   char *out, unsigned int out_len,
 			   const struct pattern_fmt_desc *fmt_desc,
-			   unsigned int fmt_desc_sz,
 			   struct pattern_fmt *fmt,
 			   unsigned int *fmt_sz_out);
 
diff --git a/options.c b/options.c
index f2d98fa6..85a0f490 100644
--- a/options.c
+++ b/options.c
@@ -19,12 +19,13 @@ char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
 #define cb_data_to_td(data)	container_of(data, struct thread_data, o)
 
-static struct pattern_fmt_desc fmt_desc[] = {
+static const struct pattern_fmt_desc fmt_desc[] = {
 	{
 		.fmt   = "%o",
 		.len   = FIELD_SIZE(struct io_u *, offset),
 		.paste = paste_blockoff
-	}
+	},
+	{ }
 };
 
 /*
@@ -1339,7 +1340,7 @@ static int str_buffer_pattern_cb(void *data, const char *input)
 
 	/* FIXME: for now buffer pattern does not support formats */
 	ret = parse_and_fill_pattern(input, strlen(input), td->o.buffer_pattern,
-				     MAX_PATTERN_SIZE, NULL, 0, NULL, NULL);
+				     MAX_PATTERN_SIZE, NULL, NULL, NULL);
 	if (ret < 0)
 		return 1;
 
@@ -1388,7 +1389,7 @@ static int str_verify_pattern_cb(void *data, const char *input)
 
 	td->o.verify_fmt_sz = ARRAY_SIZE(td->o.verify_fmt);
 	ret = parse_and_fill_pattern(input, strlen(input), td->o.verify_pattern,
-				     MAX_PATTERN_SIZE, fmt_desc, sizeof(fmt_desc),
+				     MAX_PATTERN_SIZE, fmt_desc,
 				     td->o.verify_fmt, &td->o.verify_fmt_sz);
 	if (ret < 0)
 		return 1;

