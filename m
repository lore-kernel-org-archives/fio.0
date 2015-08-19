Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37094 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbbHSKdU (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 19 Aug 2015 06:33:20 -0400
Received: by wibhh20 with SMTP id hh20so4048729wib.0
        for <fio@vger.kernel.org>; Wed, 19 Aug 2015 03:33:19 -0700 (PDT)
From: Roman Pen <r.peniaev@gmail.com>
Subject: [RFC 1/6] lib/strntol: add 'strntol' function
Date: Wed, 19 Aug 2015 12:33:06 +0200
Message-Id: <1439980391-2311-2-git-send-email-r.peniaev@gmail.com>
In-Reply-To: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
References: <1439980391-2311-1-git-send-email-r.peniaev@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: Roman Pen <r.peniaev@gmail.com>, fio@vger.kernel.org

In future patches I will need it.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 Makefile      |  2 +-
 lib/strntol.c | 31 +++++++++++++++++++++++++++++++
 lib/strntol.h |  6 ++++++
 3 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 lib/strntol.c
 create mode 100644 lib/strntol.h

diff --git a/Makefile b/Makefile
index 24663a4..fe0da43 100644
--- a/Makefile
+++ b/Makefile
@@ -39,7 +39,7 @@ endif
 SOURCE :=	gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		eta.c verify.c memory.c io_u.c parse.c mutex.c options.c \
 		lib/rbtree.c smalloc.c filehash.c profile.c debug.c lib/rand.c \
-		lib/num2str.c lib/ieee754.c engines/cpu.c \
+		lib/num2str.c lib/ieee754.c lib/strntol.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
 		memalign.c server.c client.c iolog.c backend.c libfio.c flow.c \
 		cconv.c lib/prio_tree.c json.c lib/zipf.c lib/axmap.c \
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
-- 
2.4.4

