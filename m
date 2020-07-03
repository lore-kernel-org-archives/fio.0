Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgGCMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Jul 2020 08:00:08 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDEFC08C5C1
        for <fio@vger.kernel.org>; Fri,  3 Jul 2020 05:00:08 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrKMQ-0000x7-2l
        for fio@vger.kernel.org; Fri, 03 Jul 2020 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200703120001.EC0EE1BC01BD@kernel.dk>
Date: Fri,  3 Jul 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 797ef7b209d7423f34dfe513beeede21d2efddc4:

  Merge branch 'pmemblk' of https://github.com/bvanassche/fio (2020-06-28 07:08:36 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5144df064b2fc011615868e59083cfc1786bd073:

  Merge branch 'num2str' of https://github.com/bvanassche/fio (2020-07-02 18:08:14 -0600)

----------------------------------------------------------------
Bart Van Assche (5):
      num2str(): Use asprintf() instead of malloc()
      num2str(): Remove the fmt[] array
      num2str(): Fix overflow handling
      Add a num2str() unit test
      num2str(): Add the E (exa) prefix

Jens Axboe (1):
      Merge branch 'num2str' of https://github.com/bvanassche/fio

 Makefile                |  2 ++
 lib/num2str.c           | 31 ++++++++++++++---------------
 unittests/lib/num2str.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c    |  1 +
 unittests/unittest.h    |  1 +
 5 files changed, 72 insertions(+), 16 deletions(-)
 create mode 100644 unittests/lib/num2str.c

---

Diff of recent changes:

diff --git a/Makefile b/Makefile
index 7eb5e899..99e96635 100644
--- a/Makefile
+++ b/Makefile
@@ -337,12 +337,14 @@ PROGS += $(T_PROGS)
 ifdef CONFIG_HAVE_CUNIT
 UT_OBJS = unittests/unittest.o
 UT_OBJS += unittests/lib/memalign.o
+UT_OBJS += unittests/lib/num2str.o
 UT_OBJS += unittests/lib/strntol.o
 UT_OBJS += unittests/oslib/strlcat.o
 UT_OBJS += unittests/oslib/strndup.o
 UT_OBJS += unittests/oslib/strcasestr.o
 UT_OBJS += unittests/oslib/strsep.o
 UT_TARGET_OBJS = lib/memalign.o
+UT_TARGET_OBJS += lib/num2str.o
 UT_TARGET_OBJS += lib/strntol.o
 UT_TARGET_OBJS += oslib/strlcat.o
 UT_TARGET_OBJS += oslib/strndup.o
diff --git a/lib/num2str.c b/lib/num2str.c
index 1abe22f3..726f1c44 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -4,6 +4,7 @@
 #include <string.h>
 
 #include "../compiler/compiler.h"
+#include "../oslib/asprintf.h"
 #include "num2str.h"
 
 #define ARRAY_SIZE(x)    (sizeof((x)) / (sizeof((x)[0])))
@@ -19,8 +20,8 @@
  */
 char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 {
-	const char *sistr[] = { "", "k", "M", "G", "T", "P" };
-	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi" };
+	const char *sistr[] = { "", "k", "M", "G", "T", "P", "E" };
+	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi", "Ei" };
 	const char **unitprefix;
 	static const char *const unitstr[] = {
 		[N2S_NONE]	= "",
@@ -33,16 +34,12 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 	const unsigned int thousand = pow2 ? 1024 : 1000;
 	unsigned int modulo;
 	int post_index, carry = 0;
-	char tmp[32], fmt[32];
+	char tmp[32];
 	char *buf;
 
 	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
 	assert(units < ARRAY_SIZE(unitstr));
 
-	buf = malloc(128);
-	if (!buf)
-		return NULL;
-
 	if (pow2)
 		unitprefix = iecstr;
 	else
@@ -83,16 +80,17 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, enum n2s_unit units)
 		post_index++;
 	}
 
+	if (post_index >= ARRAY_SIZE(sistr))
+		post_index = 0;
+
 	/*
 	 * If no modulo, then we're done.
 	 */
 	if (modulo == -1U) {
 done:
-		if (post_index >= ARRAY_SIZE(sistr))
-			post_index = 0;
-
-		sprintf(buf, "%llu%s%s", (unsigned long long) num,
-			unitprefix[post_index], unitstr[units]);
+		if (asprintf(&buf, "%llu%s%s", (unsigned long long) num,
+			     unitprefix[post_index], unitstr[units]) < 0)
+			buf = NULL;
 		return buf;
 	}
 
@@ -111,10 +109,11 @@ done:
 	 */
 	assert(maxlen - strlen(tmp) - 1 > 0);
 	assert(modulo < thousand);
-	sprintf(fmt, "%%.%df", (int)(maxlen - strlen(tmp) - 1));
-	sprintf(tmp, fmt, (double)modulo / (double)thousand);
+	sprintf(tmp, "%.*f", (int)(maxlen - strlen(tmp) - 1),
+		(double)modulo / (double)thousand);
 
-	sprintf(buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
-			unitprefix[post_index], unitstr[units]);
+	if (asprintf(&buf, "%llu.%s%s%s", (unsigned long long) num, &tmp[2],
+		     unitprefix[post_index], unitstr[units]) < 0)
+		buf = NULL;
 	return buf;
 }
diff --git a/unittests/lib/num2str.c b/unittests/lib/num2str.c
new file mode 100644
index 00000000..a3492a8d
--- /dev/null
+++ b/unittests/lib/num2str.c
@@ -0,0 +1,53 @@
+#include <limits.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include "../../compiler/compiler.h"
+#include "../../lib/num2str.h"
+#include "../unittest.h"
+
+struct testcase {
+	uint64_t num;
+	int maxlen;
+	int base;
+	int pow2;
+	enum n2s_unit unit;
+	const char *expected;
+};
+
+static const struct testcase testcases[] = {
+	{ 1, 1, 1, 0, N2S_NONE, "1" },
+	{ UINT64_MAX, 99, 1, 0, N2S_NONE, "18446744073709551615" },
+	{ 18446744073709551, 2, 1, 0, N2S_NONE, "18P" },
+	{ 18446744073709551, 4, 1, 0, N2S_NONE, "18.4P" },
+	{ UINT64_MAX, 2, 1, 0, N2S_NONE, "18E" },
+	{ UINT64_MAX, 4, 1, 0, N2S_NONE, "18.4E" },
+};
+
+static void test_num2str(void)
+{
+	const struct testcase *p;
+	char *str;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(testcases); ++i) {
+		p = &testcases[i];
+		str = num2str(p->num, p->maxlen, p->base, p->pow2, p->unit);
+		CU_ASSERT_STRING_EQUAL(str, p->expected);
+		free(str);
+	}
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "num2str/1",
+		.fn	= test_num2str,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_lib_num2str(void)
+{
+	return fio_unittest_add_suite("lib/num2str.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index c37e1971..f490b485 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -48,6 +48,7 @@ int main(void)
 	}
 
 	fio_unittest_register(fio_unittest_lib_memalign);
+	fio_unittest_register(fio_unittest_lib_num2str);
 	fio_unittest_register(fio_unittest_lib_strntol);
 	fio_unittest_register(fio_unittest_oslib_strlcat);
 	fio_unittest_register(fio_unittest_oslib_strndup);
diff --git a/unittests/unittest.h b/unittests/unittest.h
index 786c1c97..ecb7d124 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -15,6 +15,7 @@ CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 	CU_CleanupFunc, struct fio_unittest_entry*);
 
 CU_ErrorCode fio_unittest_lib_memalign(void);
+CU_ErrorCode fio_unittest_lib_num2str(void);
 CU_ErrorCode fio_unittest_lib_strntol(void);
 CU_ErrorCode fio_unittest_oslib_strlcat(void);
 CU_ErrorCode fio_unittest_oslib_strndup(void);

