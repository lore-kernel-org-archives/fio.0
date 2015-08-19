Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33872 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbHSKdW (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:22 -0400
Received: by wicne3 with SMTP id ne3so122910476wic.1
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:21 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 4/6] verify: use 'cmp_pattern' from 'lib/pattern.c' to compare pattern and buffer
Date: Wed, 19 Aug 2015 12:33:09 +0200
Message-Id: <1439980391-2311-5-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

'cmp_pattern' function should be faster, since it does not use loops
and while doing 'memcmp' the same CPU cache line is used.

Keep in mind, that now single-byte pattern becomes the string of 512 bytes.
In that case this optimization will not work as expected, since 'memcmp'
will be called twice for the whole pattern, but in next patches this
behaviour will be avoided and single-byte pattern will stay single-byte
pattern without any attempt to duplicate it.

Also print buffer and pattern bytes as unsigned chars.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 verify.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/verify.c b/verify.c
index 668d933..984b272 100644
--- a/verify.c
+++ b/verify.c
@@ -356,7 +356,8 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	struct io_u *io_u = vc->io_u;
 	char *buf, *pattern;
 	unsigned int header_size = __hdr_size(td->o.verify);
-	unsigned int len, mod, i, size, pattern_size;
+	unsigned int len, mod, i, pattern_size;
+	int rc;
 
 	pattern = td->o.verify_pattern;
 	pattern_size = td->o.verify_pattern_bytes;
@@ -366,23 +367,20 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 	len = get_hdr_inc(td, io_u) - header_size;
 	mod = header_size % pattern_size;
 
-	for (i = 0; i < len; i += size) {
-		size = pattern_size - mod;
-		if (size > (len - i))
-			size = len - i;
-		if (memcmp(buf + i, pattern + mod, size))
-			/* Let the slow compare find the first mismatch byte. */
-			break;
-		mod = 0;
-	}
+	rc = cmp_pattern(pattern, pattern_size, mod, buf, len);
+	if (!rc)
+		return 0;
 
-	for (; i < len; i++) {
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
@@ -392,7 +390,9 @@ static int verify_io_u_pattern(struct verify_header *hdr, struct vcont *vc)
 			mod = 0;
 	}
 
-	return 0;
+	/* Unreachable line */
+	assert(0);
+	return EILSEQ;
 }
 
 static int verify_io_u_meta(struct verify_header *hdr, struct vcont *vc)
-- 
2.4.4

