Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/7] unittests: add unittest suite for lib/strntol.c
Date: Fri, 26 Oct 2018 09:35:42 -0700
Message-Id: <1540571746-12885-4-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Add test cases for lib/strntol.c as an example of unittest.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile                |    2 +
 unittests/lib/strntol.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c    |    1 +
 unittests/unittest.h    |    1 +
 4 files changed, 63 insertions(+), 0 deletions(-)
 create mode 100644 unittests/lib/strntol.c

diff --git a/Makefile b/Makefile
index 9f27ff1..abcfe4d 100644
--- a/Makefile
+++ b/Makefile
@@ -303,7 +303,9 @@ PROGS += $(T_PROGS)
 ifdef CONFIG_HAVE_CUNIT
 UT_OBJS = unittests/unittest.o
 UT_OBJS += unittests/lib/memalign.o
+UT_OBJS += unittests/lib/strntol.o
 UT_TARGET_OBJS = lib/memalign.o
+UT_TARGET_OBJS += lib/strntol.o
 UT_PROGS = unittests/unittest
 else
 UT_OBJS =
diff --git a/unittests/lib/strntol.c b/unittests/lib/strntol.c
new file mode 100644
index 0000000..14adde2
--- /dev/null
+++ b/unittests/lib/strntol.c
@@ -0,0 +1,59 @@
+#include "../unittest.h"
+
+#include "../../lib/strntol.h"
+
+static void test_strntol_1(void)
+{
+	char s[] = "12345";
+	char *endp = NULL;
+	long ret = strntol(s, strlen(s), &endp, 10);
+
+	CU_ASSERT_EQUAL(ret, 12345);
+	CU_ASSERT_NOT_EQUAL(endp, NULL);
+	CU_ASSERT_EQUAL(*endp, '\0');
+}
+
+static void test_strntol_2(void)
+{
+	char s[] = "     12345";
+	char *endp = NULL;
+	long ret = strntol(s, strlen(s), &endp, 10);
+
+	CU_ASSERT_EQUAL(ret, 12345);
+	CU_ASSERT_NOT_EQUAL(endp, NULL);
+	CU_ASSERT_EQUAL(*endp, '\0');
+}
+
+static void test_strntol_3(void)
+{
+	char s[] = "0x12345";
+	char *endp = NULL;
+	long ret = strntol(s, strlen(s), &endp, 16);
+
+	CU_ASSERT_EQUAL(ret, 0x12345);
+	CU_ASSERT_NOT_EQUAL(endp, NULL);
+	CU_ASSERT_EQUAL(*endp, '\0');
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "strntol/1",
+		.fn	= test_strntol_1,
+	},
+	{
+		.name	= "strntol/2",
+		.fn	= test_strntol_2,
+	},
+	{
+		.name	= "strntol/3",
+		.fn	= test_strntol_3,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_lib_strntol(void)
+{
+	return fio_unittest_add_suite("lib/strntol.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index 204897a..dc627b4 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -59,6 +59,7 @@ int main(void)
 	}
 
 	fio_unittest_register(fio_unittest_lib_memalign);
+	fio_unittest_register(fio_unittest_lib_strntol);
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index 5d170af..e0121ec 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -19,5 +19,6 @@ CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 	CU_CleanupFunc, struct fio_unittest_entry*);
 
 CU_ErrorCode fio_unittest_lib_memalign(void);
+CU_ErrorCode fio_unittest_lib_strntol(void);
 
 #endif
-- 
1.7.1


