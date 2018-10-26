Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 5/7] unittests: add unittest suite for oslib/strndup.c
Date: Fri, 26 Oct 2018 09:35:44 -0700
Message-Id: <1540571746-12885-6-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Add test cases for oslib/strndup.c as an example of unittest.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile                  |    2 +
 unittests/oslib/strndup.c |   63 +++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c      |    1 +
 unittests/unittest.h      |    1 +
 4 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 unittests/oslib/strndup.c

diff --git a/Makefile b/Makefile
index dd02612..5ac568e 100644
--- a/Makefile
+++ b/Makefile
@@ -305,9 +305,11 @@ UT_OBJS = unittests/unittest.o
 UT_OBJS += unittests/lib/memalign.o
 UT_OBJS += unittests/lib/strntol.o
 UT_OBJS += unittests/oslib/strlcat.o
+UT_OBJS += unittests/oslib/strndup.o
 UT_TARGET_OBJS = lib/memalign.o
 UT_TARGET_OBJS += lib/strntol.o
 UT_TARGET_OBJS += oslib/strlcat.o
+UT_TARGET_OBJS += oslib/strndup.o
 UT_PROGS = unittests/unittest
 else
 UT_OBJS =
diff --git a/unittests/oslib/strndup.c b/unittests/oslib/strndup.c
new file mode 100644
index 0000000..2d1baf1
--- /dev/null
+++ b/unittests/oslib/strndup.c
@@ -0,0 +1,63 @@
+#include "../unittest.h"
+
+#ifndef CONFIG_HAVE_STRNDUP
+#include "../../oslib/strndup.h"
+#else
+#include <string.h>
+#endif
+
+static void test_strndup_1(void)
+{
+	char s[] = "test";
+	char *p = strndup(s, 3);
+
+	if (p) {
+		CU_ASSERT_EQUAL(strcmp(p, "tes"), 0);
+		CU_ASSERT_EQUAL(strlen(p), 3);
+	}
+}
+
+static void test_strndup_2(void)
+{
+	char s[] = "test";
+	char *p = strndup(s, 4);
+
+	if (p) {
+		CU_ASSERT_EQUAL(strcmp(p, s), 0);
+		CU_ASSERT_EQUAL(strlen(p), 4);
+	}
+}
+
+static void test_strndup_3(void)
+{
+	char s[] = "test";
+	char *p = strndup(s, 5);
+
+	if (p) {
+		CU_ASSERT_EQUAL(strcmp(p, s), 0);
+		CU_ASSERT_EQUAL(strlen(p), 4);
+	}
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "strndup/1",
+		.fn	= test_strndup_1,
+	},
+	{
+		.name	= "strndup/2",
+		.fn	= test_strndup_2,
+	},
+	{
+		.name	= "strndup/3",
+		.fn	= test_strndup_3,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_oslib_strndup(void)
+{
+	return fio_unittest_add_suite("oslib/strndup.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index 20f9205..1166e6e 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -61,6 +61,7 @@ int main(void)
 	fio_unittest_register(fio_unittest_lib_memalign);
 	fio_unittest_register(fio_unittest_lib_strntol);
 	fio_unittest_register(fio_unittest_oslib_strlcat);
+	fio_unittest_register(fio_unittest_oslib_strndup);
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index f45e193..d3e3822 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -21,5 +21,6 @@ CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 CU_ErrorCode fio_unittest_lib_memalign(void);
 CU_ErrorCode fio_unittest_lib_strntol(void);
 CU_ErrorCode fio_unittest_oslib_strlcat(void);
+CU_ErrorCode fio_unittest_oslib_strndup(void);
 
 #endif
-- 
1.7.1


