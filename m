Return-Path: <fio-owner@vger.kernel.org>
Received: from g2t2352.austin.hpe.com ([15.233.44.25]:26519 "EHLO
        g2t2352.austin.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932166AbeARXxw (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Jan 2018 18:53:52 -0500
Received: from g2t2360.austin.hpecorp.net (g2t2360.austin.hpecorp.net [16.196.225.135])
        by g2t2352.austin.hpe.com (Postfix) with ESMTP id 22D4362
        for <fio@vger.kernel.org>; Thu, 18 Jan 2018 23:53:52 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH 1/3] memcpytest: Add more sizes
Date: Thu, 18 Jan 2018 17:53:45 -0600
Message-Id: <20180118235347.30370-2-elliott@hpe.com>
In-Reply-To: <20180118235347.30370-1-elliott@hpe.com>
References: <20180118235347.30370-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

From: Robert Elliott <elliott@hpe.com>

Run memcpy tests over much larger sizes (L3 cache size and larger),
and reduce the number of iterations.
---
 lib/memcpy.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 78 insertions(+), 10 deletions(-)

diff --git a/lib/memcpy.c b/lib/memcpy.c
index 00e65aa7..a79d7c50 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -8,9 +8,17 @@
 #include "../gettime.h"
 #include "../fio.h"
 
-#define BUF_SIZE	32 * 1024 * 1024ULL
+/* largest last-level CPU cache size of an x86 in 2018 in bytes */
+#define LLC_SIZE	(45* 1024 * 1024ULL)
 
-#define NR_ITERS	64
+#define BUF_SIZE	(LLC_SIZE * 4ULL)
+
+/* alignment in bytes for the buffers.  Ensure that functions like
+ * libc memcpy can use most optimal paths (512 B for x86_64 AVX2).
+ */
+#define BUF_ALIGN	512
+
+#define NR_ITERS	8
 
 struct memcpy_test {
 	const char *name;
@@ -21,15 +29,27 @@ struct memcpy_test {
 
 static struct memcpy_test tests[] = {
 	{
-		.name		= "8 bytes",
+		.name		= "  4 bytes",
+		.size		= 4,
+	},
+	{
+		.name		= "  8 bytes",
 		.size		= 8,
 	},
 	{
-		.name		= "16 bytes",
+		.name		= " 16 bytes",
 		.size		= 16,
 	},
 	{
-		.name		= "96 bytes",
+		.name		= " 32 bytes",
+		.size		= 32,
+	},
+	{
+		.name		= " 64 bytes",
+		.size		= 64,
+	},
+	{
+		.name		= " 96 bytes",
 		.size		= 96,
 	},
 	{
@@ -45,25 +65,73 @@ static struct memcpy_test tests[] = {
 		.size		= 512,
 	},
 	{
-		.name		= "2048 bytes",
+		.name		= "  2 KiB",
 		.size		= 2048,
 	},
 	{
-		.name		= "8192 bytes",
+		.name		= "  4 KiB",
+		.size		= 4096,
+	},
+	{
+		.name		= "  8 KiB",
 		.size		= 8192,
 	},
 	{
-		.name		= "131072 bytes",
+		.name		= "128 KiB",
 		.size		= 131072,
 	},
 	{
-		.name		= "262144 bytes",
+		.name		= "256 KiB",
 		.size		= 262144,
 	},
 	{
-		.name		= "524288 bytes",
+		.name		= "512 KiB",
 		.size		= 524288,
 	},
+	{
+		.name		= "  8 MiB",
+		.size		= 8 * 1024 * 1024,
+	},
+	{
+		.name		= "6x 1.375 MiB",
+		.size		= 8650752,
+	},
+	{
+		.name		= "  9 MiB",
+		.size		= 9 * 1024 * 1024,
+	},
+	{
+		.name		= " 16 MiB",
+		.size		= 16 * 1024 * 1024,	/* 3/4 L3 size is 16.5 */
+	},
+	{
+		.name		= " 17 MiB",
+		.size		= 17 * 1024 * 1024,	/* 3/4 L3 size is 16.5 */
+	},
+	{
+		.name		= " 22 MiB",
+		.size		= 22 * 1024 * 1024,	/* L3 size */
+	},
+	{
+		.name		= " 32 MiB",
+		.size		= 32 * 1024 * 1024,	/* >L3 size */
+	},
+	{
+		.name		= " 40 MiB",
+		.size		= 40 * 1024 * 1024,
+	},
+	{
+		.name		= " 48 MiB",
+		.size		= 48 * 1024 * 1024,	/* larger than most L3 */
+	},
+	{
+		.name		= "128 MiB",
+		.size		= 128 * 1024 * 1024,	/* much larger than L3 */
+	},
+	{
+		.name		= "full buffer",
+		.size		= BUF_SIZE,
+	},
 	{
 		.name		= NULL,
 	},
-- 
2.14.3

