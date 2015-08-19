Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33729 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbbHSKdV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:21 -0400
Received: by wijp15 with SMTP id p15so122793509wij.0
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:20 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 3/6] replace 'fill_pattern' with 'cpy_pattern' from 'lib/pattern.c'
Date: Wed, 19 Aug 2015 12:33:08 +0200
Message-Id: <1439980391-2311-4-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

All pattern helpers are now located inside 'lib/pattern.c',
and 'cpy_pattern' should be sligtly faster, since it does
copy doubling the size on every iteration.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 Makefile   |  3 ++-
 lib/rand.c | 31 +++----------------------------
 lib/rand.h |  1 -
 verify.c   |  5 +++--
 4 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/Makefile b/Makefile
index cb0a1b5..296655b 100644
--- a/Makefile
+++ b/Makefile
@@ -198,7 +198,8 @@ T_IEEE_OBJS += lib/ieee754.o
 T_IEEE_PROGS = t/ieee754
 
 T_ZIPF_OBS = t/genzipf.o
-T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/zipf.o lib/gauss.o t/genzipf.o
+T_ZIPF_OBJS += t/log.o lib/ieee754.o lib/rand.o lib/pattern.o lib/zipf.o \
+		lib/strntol.o lib/gauss.o t/genzipf.o
 T_ZIPF_PROGS = t/fio-genzipf
 
 T_AXMAP_OBJS = t/axmap.o
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
diff --git a/verify.c b/verify.c
index f833e85..668d933 100644
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
@@ -73,7 +74,7 @@ void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len,
 		return;
 	}
 
-	fill_pattern(p, len, o->verify_pattern, o->verify_pattern_bytes);
+	(void)cpy_pattern(td->o.verify_pattern, td->o.verify_pattern_bytes, p, len);
 	io_u->buf_filled_len = len;
 }
 
-- 
2.4.4

