Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42673 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbeJ0AyP (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Oct 2018 20:54:15 -0400
Received: by mail-pl1-f195.google.com with SMTP id t6-v6so727908plo.9
        for <fio@vger.kernel.org>; Fri, 26 Oct 2018 09:16:36 -0700 (PDT)
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 4/7] unittests: add unittest suite for oslib/strlcat.c
Date: Fri, 26 Oct 2018 09:35:43 -0700
Message-Id: <1540571746-12885-5-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>

Add test cases for oslib/strlcat.c as an example of unittest.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile                  |    2 +
 unittests/oslib/strlcat.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c      |    1 +
 unittests/unittest.h      |    1 +
 4 files changed, 56 insertions(+), 0 deletions(-)
 create mode 100644 unittests/oslib/strlcat.c

diff --git a/Makefile b/Makefile
index abcfe4d..dd02612 100644
--- a/Makefile
+++ b/Makefile
@@ -304,8 +304,10 @@ ifdef CONFIG_HAVE_CUNIT
 UT_OBJS = unittests/unittest.o
 UT_OBJS += unittests/lib/memalign.o
 UT_OBJS += unittests/lib/strntol.o
+UT_OBJS += unittests/oslib/strlcat.o
 UT_TARGET_OBJS = lib/memalign.o
 UT_TARGET_OBJS += lib/strntol.o
+UT_TARGET_OBJS += oslib/strlcat.o
 UT_PROGS = unittests/unittest
 else
 UT_OBJS =
diff --git a/unittests/oslib/strlcat.c b/unittests/oslib/strlcat.c
new file mode 100644
index 0000000..8d35d41
--- /dev/null
+++ b/unittests/oslib/strlcat.c
@@ -0,0 +1,52 @@
+#include "../unittest.h"
+
+#ifndef CONFIG_STRLCAT
+#include "../../oslib/strlcat.h"
+#else
+#include <string.h>
+#endif
+
+static void test_strlcat_1(void)
+{
+	char dst[32];
+	char src[] = "test";
+	size_t ret;
+
+	dst[0] = '\0';
+	ret = strlcat(dst, src, sizeof(dst));
+
+	CU_ASSERT_EQUAL(strcmp(dst, "test"), 0);
+	CU_ASSERT_EQUAL(ret, 4); /* total length it tried to create */
+}
+
+static void test_strlcat_2(void)
+{
+	char dst[32];
+	char src[] = "test";
+	size_t ret;
+
+	dst[0] = '\0';
+	ret = strlcat(dst, src, strlen(dst));
+
+	CU_ASSERT_EQUAL(strcmp(dst, ""), 0);
+	CU_ASSERT_EQUAL(ret, 4); /* total length it tried to create */
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "strlcat/1",
+		.fn	= test_strlcat_1,
+	},
+	{
+		.name	= "strlcat/2",
+		.fn	= test_strlcat_2,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_oslib_strlcat(void)
+{
+	return fio_unittest_add_suite("oslib/strlcat.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index dc627b4..20f9205 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -60,6 +60,7 @@ int main(void)
 
 	fio_unittest_register(fio_unittest_lib_memalign);
 	fio_unittest_register(fio_unittest_lib_strntol);
+	fio_unittest_register(fio_unittest_oslib_strlcat);
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index e0121ec..f45e193 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -20,5 +20,6 @@ CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 
 CU_ErrorCode fio_unittest_lib_memalign(void);
 CU_ErrorCode fio_unittest_lib_strntol(void);
+CU_ErrorCode fio_unittest_oslib_strlcat(void);
 
 #endif
-- 
1.7.1


