Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5793C4167D
	for <fio@archiver.kernel.org>; Thu, 17 Nov 2022 22:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbiKQWGg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 17 Nov 2022 17:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241143AbiKQWGL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Nov 2022 17:06:11 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1C423162
        for <fio@vger.kernel.org>; Thu, 17 Nov 2022 14:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Cc:To:From:content-disposition;
        bh=n+Wyam5Q9ZkDieYbrMY4BLjg+xjB5Erden1j1eBKGfY=; b=iKRnxmIO2XBTGlaBE2rg9Tp6na
        PZPg0LTlTNU9RZ0CKBgvbVXJsUXiiKGkZWHIoBZEdG3fEw4sGGmkkvKmbo71veg+28a/UA5lcXQTq
        76mjGbqynNwcgBPZNgT3O992V8Ths2+E+PCBMRyfB8nHhTeyLK+cTHmBVoPBwhe10dXpY9ybyOQh9
        EIfWBhSYdCYzcEJDP5QNxgA8L8Hr9RO3RydxthosZnK3t+5EzPGCuo+C3VE7klprNWHH6VRUnMFlS
        E9945qcLX6Q2St00y2RHk+39/XfsbDw5c+PlkKQsHOLqoP7nqKmx8ZFrDToEVrCAbPgE+sbjuvb1G
        +5YnkM6A==;
Received: from cgy1-donard.priv.deltatee.com ([172.16.1.31])
        by ale.deltatee.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-004pDB-Ig; Thu, 17 Nov 2022 15:05:30 -0700
Received: from gunthorp by cgy1-donard.priv.deltatee.com with local (Exim 4.94.2)
        (envelope-from <gunthorp@deltatee.com>)
        id 1ovn0i-000Ljk-0R; Thu, 17 Nov 2022 15:05:28 -0700
From:   Logan Gunthorpe <logang@deltatee.com>
To:     fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vincent Fu <vincentfu@gmail.com>
Cc:     David Sloan <David.Sloan@eideticom.com>,
        Stephen Bates <sbates@raithlin.com>,
        Logan Gunthorpe <logang@deltatee.com>
Date:   Thu, 17 Nov 2022 15:05:20 -0700
Message-Id: <20221117220523.83501-3-logang@deltatee.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117220523.83501-1-logang@deltatee.com>
References: <20221117220523.83501-1-logang@deltatee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 172.16.1.31
X-SA-Exim-Rcpt-To: fio@vger.kernel.org, axboe@kernel.dk, vincentfu@gmail.com, David.Sloan@eideticom.com, sbates@raithlin.com, logang@deltatee.com
X-SA-Exim-Mail-From: gunthorp@deltatee.com
Subject: [PATCH v2 2/5] lib/pattern: Support NULL output buffer in parse_and_fill_pattern()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Support passing a NULL output buffer to parse_and_fill_pattern().
Each formatting function simply needs to avoid accessing the buffer
when it is NULL. This allows calculating the required size of the
buffer before one might be allocated.

This will be useful in a subsequent patch for dynamically allocating
the pattern buffers.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
---
 lib/pattern.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/lib/pattern.c b/lib/pattern.c
index d8203630d3ed..70d0313d237e 100644
--- a/lib/pattern.c
+++ b/lib/pattern.c
@@ -51,9 +51,17 @@ static const char *parse_file(const char *beg, char *out,
 	if (fd < 0)
 		goto err_free_out;
 
-	count = read(fd, out, out_len);
-	if (count == -1)
-		goto err_free_close_out;
+	if (out) {
+		count = read(fd, out, out_len);
+		if (count == -1)
+			goto err_free_close_out;
+	} else {
+		count = lseek(fd, 0, SEEK_END);
+		if (count == -1)
+			goto err_free_close_out;
+		if (count >= out_len)
+			count = out_len;
+	}
 
 	*filled = count;
 	close(fd);
@@ -100,7 +108,8 @@ static const char *parse_string(const char *beg, char *out,
 	if (end - beg > out_len)
 		return NULL;
 
-	memcpy(out, beg, end - beg);
+	if (out)
+		memcpy(out, beg, end - beg);
 	*filled = end - beg;
 
 	/* Catch up quote */
@@ -156,12 +165,14 @@ static const char *parse_number(const char *beg, char *out,
 		i = 0;
 		if (!lval) {
 			num    = 0;
-			out[i] = 0x00;
+			if (out)
+				out[i] = 0x00;
 			i      = 1;
 		} else {
 			val = (unsigned int)lval;
 			for (; val && out_len; out_len--, i++, val >>= 8)
-				out[i] = val & 0xff;
+				if (out)
+					out[i] = val & 0xff;
 			if (val)
 				return NULL;
 		}
@@ -183,7 +194,8 @@ static const char *parse_number(const char *beg, char *out,
 			const char *fmt;
 
 			fmt = (num & 1 ? "%1hhx" : "%2hhx");
-			sscanf(beg, fmt, &out[i]);
+			if (out)
+				sscanf(beg, fmt, &out[i]);
 			if (num & 1) {
 				num++;
 				beg--;
@@ -251,7 +263,8 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
 	if (f->desc->len > out_len)
 		return NULL;
 
-	memset(out, '\0', f->desc->len);
+	if (out)
+		memset(out, '\0', f->desc->len);
 	*filled = f->desc->len;
 
 	return in + len;
@@ -262,7 +275,9 @@ static const char *parse_format(const char *in, char *out, unsigned int parsed,
  *                            numbers and pattern formats.
  * @in - string input
  * @in_len - size of the input string
- * @out - output buffer where parsed result will be put
+ * @out - output buffer where parsed result will be put, may be NULL
+ *	  in which case this function just calculates the required
+ *	  length of the buffer
  * @out_len - lengths of the output buffer
  * @fmt_desc - array of pattern format descriptors [input]
  * @fmt - array of pattern formats [output]
@@ -314,7 +329,7 @@ int parse_and_fill_pattern(const char *in, unsigned int in_len,
 	const char *beg, *end, *out_beg = out;
 	unsigned int total = 0, fmt_rem = 0;
 
-	if (!in || !in_len || !out || !out_len)
+	if (!in || !in_len || !out_len)
 		return -EINVAL;
 	if (fmt_sz_out)
 		fmt_rem = *fmt_sz_out;
-- 
2.30.2

