Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 7/7] oslib: fix strlcat's incorrect copying
Date: Fri, 26 Oct 2018 09:35:46 -0700
Message-Id: <1540571746-12885-8-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Fix unittests/oslib/strlcat.c test case failure.

oslib/strlcat.c implementation is incorrect for edge case inputs,
when (dsize-strlen(dst)-1 <= 0). The example below isn't supposed
to be copying anything, but the result is it does copy and
overruns the stack.

This commit replalces oslib/strlcat.c with the original implementation
under BSDL.

--
 # uname
 Linux
 # cat ./test0.c
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include "./oslib/strlcat.h"

 int main(void) {
         char *p, s[10] = "test";
         int size = 200;

         p = calloc(1, size);
         memset(p, 65, size - 1);

         printf("%lu %lu %s\n", sizeof(s), strlen(s), s);
         strlcat(s, p, strlen(s));
         printf("%lu %lu %s\n", sizeof(s), strlen(s), s);

         return 0;
 }
 # gcc -Wall -g ./test0.c ./oslib/strlcat.c
 # ./a.out
 10 4 test
 10 203 testAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
 Segmentation fault (core dumped)

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 oslib/strlcat.c |   69 +++++++++++++++++++++++++++++++++++++++----------------
 oslib/strlcat.h |    2 +-
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/oslib/strlcat.c b/oslib/strlcat.c
index 6c4c678..3e86eeb 100644
--- a/oslib/strlcat.c
+++ b/oslib/strlcat.c
@@ -1,28 +1,57 @@
 #ifndef CONFIG_STRLCAT
-
+/*
+ * Copyright (c) 1998, 2015 Todd C. Miller <Todd.Miller@courtesan.com>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <sys/types.h>
 #include <string.h>
 #include "strlcat.h"
 
-size_t strlcat(char *dst, const char *src, size_t size)
+/*
+ * Appends src to string dst of size dsize (unlike strncat, dsize is the
+ * full size of dst, not space left).  At most dsize-1 characters
+ * will be copied.  Always NUL terminates (unless dsize <= strlen(dst)).
+ * Returns strlen(src) + MIN(dsize, strlen(initial dst)).
+ * If retval >= dsize, truncation occurred.
+ */
+size_t
+strlcat(char *dst, const char *src, size_t dsize)
 {
-	size_t dstlen;
-	size_t srclen;
-
-	dstlen = strlen(dst);
-	size -= dstlen + 1;
-
-	/* return if no room */
-	if (!size)
-		return dstlen;
-
-	srclen = strlen(src);
-	if (srclen > size)
-		srclen = size;
-
-	memcpy(dst + dstlen, src, srclen);
-	dst[dstlen + srclen] = '\0';
-
-	return dstlen + srclen;
+	const char *odst = dst;
+	const char *osrc = src;
+	size_t n = dsize;
+	size_t dlen;
+
+	/* Find the end of dst and adjust bytes left but don't go past end. */
+	while (n-- != 0 && *dst != '\0')
+		dst++;
+	dlen = dst - odst;
+	n = dsize - dlen;
+
+	if (n-- == 0)
+		return(dlen + strlen(src));
+	while (*src != '\0') {
+		if (n != 0) {
+			*dst++ = *src;
+			n--;
+		}
+		src++;
+	}
+	*dst = '\0';
+
+	return(dlen + (src - osrc));	/* count does not include NUL */
 }
 
 #endif
diff --git a/oslib/strlcat.h b/oslib/strlcat.h
index f766392..85e4bda 100644
--- a/oslib/strlcat.h
+++ b/oslib/strlcat.h
@@ -5,7 +5,7 @@
 
 #include <stddef.h>
 
-size_t strlcat(char *dst, const char *src, size_t size);
+size_t strlcat(char *dst, const char *src, size_t dsize);
 
 #endif
 
-- 
1.7.1


