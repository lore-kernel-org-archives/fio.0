Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 1/7] unittests: add CUnit based unittest framework
Date: Fri, 26 Oct 2018 09:35:40 -0700
Message-Id: <1540571746-12885-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1540571746-12885-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

CUnit is C version of *unit framework to help write test cases.
https://sourceforge.net/projects/cunit/

unittests/* are compiled only if CUnit exists, and detected on
build time in ./configure like any other build time detection,
by running a simple CUnit initialization code.

Some OS/distros have binary package for CUnit. In case of Fedora
and FreeBSD, they both install shared library (libcunit.so) and
CUnit headers required to compile fio's unittests.
 Fedora:
  # dnf install CUnit
 FreeBSD:
  # pkg install cunit

To build and install CUnit from upstream source, do below.
 # ./bootstrap && make && make install
Note that make install seems to install binaries and headers under
~/CUnitHome/ by default.

After applying actual test cases in the next few commits, running
./unittests/unittest will print results to stdout. These are
examples of test cases, and one can add more tests.

-- Example of unittest results
 # ./unittests/unittest

      CUnit - A unit testing framework for C - Version 2.1-3
      http://cunit.sourceforge.net/

 Suite: lib/memalign.c
   Test: memalign/1 ...passed
 Suite: lib/strntol.c
   Test: strntol/1 ...passed
   Test: strntol/2 ...FAILED
     1. unittests/lib/strntol.c:24  - CU_ASSERT_EQUAL(*endp,'\0')
   Test: strntol/3 ...passed
 Suite: oslib/strlcat.c
   Test: strlcat/1 ...passed
   Test: strlcat/2 ...FAILED
     1. unittests/oslib/strlcat.c:28  - CU_ASSERT_EQUAL(strcmp(dst, ""),0)
 Suite: oslib/strndup.c
   Test: strndup/1 ...passed
   Test: strndup/2 ...passed
   Test: strndup/3 ...passed

 Run Summary:    Type  Total    Ran Passed Failed Inactive
               suites      4      4    n/a      0        0
                tests      9      9      7      2        0
              asserts     18     18     16      2      n/a

 Elapsed time =    0.000 seconds

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 .gitignore           |    1 +
 Makefile             |   19 ++++++++++++++-
 configure            |   26 ++++++++++++++++++++++
 unittests/unittest.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.h |   15 +++++++++++++
 5 files changed, 117 insertions(+), 2 deletions(-)
 create mode 100644 unittests/unittest.c
 create mode 100644 unittests/unittest.h

diff --git a/.gitignore b/.gitignore
index 0c8cb7c..f86bec6 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,6 +18,7 @@
 /t/ieee754
 /t/lfsr-test
 /t/stest
+/unittests/unittest
 y.tab.*
 lex.yy.c
 *.un~
diff --git a/Makefile b/Makefile
index 4721b78..461d784 100644
--- a/Makefile
+++ b/Makefile
@@ -300,6 +300,16 @@ T_PROGS += $(T_VS_PROGS)
 
 PROGS += $(T_PROGS)
 
+ifdef CONFIG_HAVE_CUNIT
+UT_OBJS = unittests/unittest.o
+UT_TARGET_OBJS =
+UT_PROGS = unittests/unittest
+else
+UT_OBJS =
+UT_TARGET_OBJS =
+UT_PROGS =
+endif
+
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
 	QUIET_CC	= @echo '   ' CC $@;
@@ -326,7 +336,7 @@ mandir = $(prefix)/man
 sharedir = $(prefix)/share/fio
 endif
 
-all: $(PROGS) $(T_TEST_PROGS) $(SCRIPTS) FORCE
+all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) FORCE
 
 .PHONY: all install clean test
 .PHONY: FORCE cscope
@@ -467,8 +477,13 @@ t/fio-verify-state: $(T_VS_OBJS)
 t/time-test: $(T_TT_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_TT_OBJS) $(LIBS)
 
+ifdef CONFIG_HAVE_CUNIT
+unittests/unittest: $(UT_OBJS) $(UT_TARGET_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(UT_OBJS) $(UT_TARGET_OBJS) -lcunit
+endif
+
 clean: FORCE
-	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] profiles/*.[do] t/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(UT_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio unittests/unittest FIO-VERSION-FILE *.[do] lib/*.d oslib/*.[do] crc/*.d engines/*.[do] profiles/*.[do] t/*.[do] unittests/*.[do] unittests/*/*.[do] config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 	@rm -rf  doc/output
 
 distclean: clean FORCE
diff --git a/configure b/configure
index 5490e26..1f4e50b 100755
--- a/configure
+++ b/configure
@@ -2272,6 +2272,29 @@ if test "$disable_native" = "no" && test "$disable_opt" != "yes" && \
 fi
 print_config "Build march=native" "$build_native"
 
+##########################################
+# check for -lcunit
+if test "$cunit" != "yes" ; then
+  cunit="no"
+fi
+cat > $TMPC << EOF
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+int main(void)
+{
+  if (CU_initialize_registry() != CUE_SUCCESS)
+    return CU_get_error();
+  CU_basic_set_mode(CU_BRM_VERBOSE);
+  CU_basic_run_tests();
+  CU_cleanup_registry();
+  return CU_get_error();
+}
+EOF
+if compile_prog "" "-lcunit" "CUnit"; then
+  cunit="yes"
+fi
+print_config "CUnit" "$cunit"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -2537,6 +2560,9 @@ fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
+if test "$cunit" = "yes" ; then
+  output_sym "CONFIG_HAVE_CUNIT"
+fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "GFIO_LIBS+=$GFIO_LIBS" >> $config_host_mak
diff --git a/unittests/unittest.c b/unittests/unittest.c
new file mode 100644
index 0000000..bc75bb6
--- /dev/null
+++ b/unittests/unittest.c
@@ -0,0 +1,58 @@
+/*
+ * fio unittest
+ * Copyright (C) 2018 Tomohiro Kusumi <kusumi.tomohiro@osnexus.com>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "./unittest.h"
+
+CU_ErrorCode fio_unittest_add_suite(const char *name, CU_InitializeFunc initfn,
+	CU_CleanupFunc cleanfn, struct fio_unittest_entry *tvec)
+{
+	CU_pSuite pSuite;
+	struct fio_unittest_entry *t;
+
+	pSuite = CU_add_suite(name, initfn, cleanfn);
+	if (!pSuite) {
+		CU_cleanup_registry();
+		return CU_get_error();
+	}
+
+	t = tvec;
+	while (t && t->name) {
+		if (!CU_add_test(pSuite, t->name, t->fn)) {
+			CU_cleanup_registry();
+			return CU_get_error();
+		}
+		t++;
+	}
+
+	return CUE_SUCCESS;
+}
+
+static void fio_unittest_register(CU_ErrorCode (*fn)(void))
+{
+	if (fn && fn() != CUE_SUCCESS) {
+		fprintf(stderr, "%s\n", CU_get_error_msg());
+		exit(1);
+	}
+}
+
+int main(void)
+{
+	if (CU_initialize_registry() != CUE_SUCCESS) {
+		fprintf(stderr, "%s\n", CU_get_error_msg());
+		exit(1);
+	}
+
+	/* Register unittest suites. */
+	fio_unittest_register(NULL); /* prevent unused warning */
+
+	CU_basic_set_mode(CU_BRM_VERBOSE);
+	CU_basic_run_tests();
+	CU_cleanup_registry();
+
+	return CU_get_error();
+}
diff --git a/unittests/unittest.h b/unittests/unittest.h
new file mode 100644
index 0000000..4ac6366
--- /dev/null
+++ b/unittests/unittest.h
@@ -0,0 +1,15 @@
+#ifndef FIO_UNITTEST_H
+#define FIO_UNITTEST_H
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+struct fio_unittest_entry {
+	const char *name;
+	CU_TestFunc fn;
+};
+
+CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
+	CU_CleanupFunc, struct fio_unittest_entry*);
+
+#endif
-- 
1.7.1


