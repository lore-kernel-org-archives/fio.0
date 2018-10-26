Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 2/7] unittests: add unittest suite for lib/memalign.c
Date: Fri, 26 Oct 2018 09:35:41 -0700
Message-Id: <1540571746-12885-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Add test cases for lib/memalign.c as an example of unittest.

A workaround code to emulate smalloc()/sfree() was needed since
3114b675fd("fio: enable cross-thread overlap checking with processes")
introduced dependency on smalloc()/sfree() which has dependency
on fio code.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 Makefile                 |    3 ++-
 unittests/lib/memalign.c |   27 +++++++++++++++++++++++++++
 unittests/unittest.c     |   14 ++++++++++++--
 unittests/unittest.h     |    8 ++++++++
 4 files changed, 49 insertions(+), 3 deletions(-)
 create mode 100644 unittests/lib/memalign.c

diff --git a/Makefile b/Makefile
index 461d784..9f27ff1 100644
--- a/Makefile
+++ b/Makefile
@@ -302,7 +302,8 @@ PROGS += $(T_PROGS)
 
 ifdef CONFIG_HAVE_CUNIT
 UT_OBJS = unittests/unittest.o
-UT_TARGET_OBJS =
+UT_OBJS += unittests/lib/memalign.o
+UT_TARGET_OBJS = lib/memalign.o
 UT_PROGS = unittests/unittest
 else
 UT_OBJS =
diff --git a/unittests/lib/memalign.c b/unittests/lib/memalign.c
new file mode 100644
index 0000000..854c274
--- /dev/null
+++ b/unittests/lib/memalign.c
@@ -0,0 +1,27 @@
+#include "../unittest.h"
+
+#include "../../lib/memalign.h"
+
+static void test_memalign_1(void)
+{
+	size_t align = 4096;
+	void *p = fio_memalign(align, 1234, false);
+
+	if (p)
+		CU_ASSERT_EQUAL(((int)(uintptr_t)p) & (align - 1), 0);
+}
+
+static struct fio_unittest_entry tests[] = {
+	{
+		.name	= "memalign/1",
+		.fn	= test_memalign_1,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+CU_ErrorCode fio_unittest_lib_memalign(void)
+{
+	return fio_unittest_add_suite("lib/memalign.c", NULL, NULL, tests);
+}
diff --git a/unittests/unittest.c b/unittests/unittest.c
index bc75bb6..204897a 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -8,6 +8,17 @@
 
 #include "./unittest.h"
 
+/* XXX workaround lib/memalign.c's dependency on smalloc.c */
+void *smalloc(size_t size)
+{
+	return malloc(size);
+}
+
+void sfree(void *ptr)
+{
+	free(ptr);
+}
+
 CU_ErrorCode fio_unittest_add_suite(const char *name, CU_InitializeFunc initfn,
 	CU_CleanupFunc cleanfn, struct fio_unittest_entry *tvec)
 {
@@ -47,8 +58,7 @@ int main(void)
 		exit(1);
 	}
 
-	/* Register unittest suites. */
-	fio_unittest_register(NULL); /* prevent unused warning */
+	fio_unittest_register(fio_unittest_lib_memalign);
 
 	CU_basic_set_mode(CU_BRM_VERBOSE);
 	CU_basic_run_tests();
diff --git a/unittests/unittest.h b/unittests/unittest.h
index 4ac6366..5d170af 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -1,6 +1,8 @@
 #ifndef FIO_UNITTEST_H
 #define FIO_UNITTEST_H
 
+#include <sys/types.h>
+
 #include <CUnit/CUnit.h>
 #include <CUnit/Basic.h>
 
@@ -9,7 +11,13 @@ struct fio_unittest_entry {
 	CU_TestFunc fn;
 };
 
+/* XXX workaround lib/memalign.c's dependency on smalloc.c */
+void *smalloc(size_t);
+void sfree(void*);
+
 CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 	CU_CleanupFunc, struct fio_unittest_entry*);
 
+CU_ErrorCode fio_unittest_lib_memalign(void);
+
 #endif
-- 
1.7.1


