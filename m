Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63285 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2BGCuz (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 6 Feb 2012 21:50:55 -0500
Received: by qadc10 with SMTP id c10so2520798qad.19
        for <fio@vger.kernel.org>; Mon, 06 Feb 2012 18:50:54 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Mon, 6 Feb 2012 18:50:34 -0800
Message-ID: <CAAUT-yNW0UEPqSFRwvEM68xx1+X6dnbmmHAvX8hcZJgHLTT5Qg@mail.gmail.com>
Subject: [PATCH] Optimize pattern verify
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Similar to the patch last week, this optimizes the pattern verify
operation to use optimized library calls like memcmp(), and only fall
back to byte-by-byte if there is a miscompare to locate it.

This uses the same premise that the pattern is repeated as many times
as possible to do large compares in a single call.  For single byte
pattern, the setup fills the pattern space, and verify assumes it is
full.

Tested by running a script which created an 8k file with 4k bs and,
one byte at a time, tried corrupting the pattern and running a read
pass and verified it still found miscompares across the whole range of
the pattern.  This was done with a pattern length of 1 and 3 bytes.

In performance tests, this was about 8 times more efficient on
verifies than without this patch.

diff --git a/options.c b/options.c
index 8fb93ca..c3fdb56 100644
--- a/options.c
+++ b/options.c
@@ -698,6 +698,14 @@ static int str_verify_pattern_cb(void *data,
const char *input)
 		memcpy(&td->o.verify_pattern[i], &td->o.verify_pattern[0], i);
 		i *= 2;
 	}
+	if (i == 1) {
+		/*
+		 * The code in verify_io_u_pattern assumes a single byte pattern
+		 * fills the whole verify pattern buffer.
+		 */
+		memset(td->o.verify_pattern, td->o.verify_pattern[0],
+		       MAX_PATTERN_SIZE);
+	}

 	td->o.verify_pattern_bytes = i;

diff --git a/verify.c b/verify.c
index 9ee3bc4..eb8eddc 100644
--- a/verify.c
+++ b/verify.c
@@ -322,14 +322,27 @@ static int verify_io_u_pattern(struct
verify_header *hdr, struct vcont *vc)
 	struct io_u *io_u = vc->io_u;
 	char *buf, *pattern;
 	unsigned int header_size = __hdr_size(td->o.verify);
-	unsigned int len, mod, i;
+	unsigned int len, mod, i, size, pattern_size;

 	pattern = td->o.verify_pattern;
+	pattern_size = td->o.verify_pattern_bytes;
+	if (pattern_size <= 1)
+		pattern_size = MAX_PATTERN_SIZE;
 	buf = (void *) hdr + header_size;
 	len = get_hdr_inc(td, io_u) - header_size;
-	mod = header_size % td->o.verify_pattern_bytes;
+	mod = header_size % pattern_size;
+
+	for (i = 0; i < len; i += size) {
+		size = pattern_size - mod;
+		if (size > (len - i))
+			size = len - i;
+		if (memcmp(buf + i, pattern + mod, size))
+			// Let the slow compare find the first mismatch byte.
+			break;
+		mod = 0;
+	}

-	for (i = 0; i < len; i++) {
+	for (; i < len; i++) {
 		if (buf[i] != pattern[mod]) {
 			unsigned int bits;

--
