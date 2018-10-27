Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbeJ0UlD (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 27 Oct 2018 16:41:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gGNGN-0003VY-HS
        for fio@vger.kernel.org; Sat, 27 Oct 2018 12:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181027120001.7177D2C0024@kernel.dk>
Date: Sat, 27 Oct 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d7e92306bde2117702ed96b7c5647d9485869047:

  io_u: move trim error notification out-of-line (2018-10-24 05:00:53 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 199710f5822cf22bf76107f26993a9468f93a422:

  oslib: fix strlcat's incorrect copying (2018-10-26 10:24:28 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (7):
      unittests: add CUnit based unittest framework
      unittests: add unittest suite for lib/memalign.c
      unittests: add unittest suite for lib/strntol.c
      unittests: add unittest suite for oslib/strlcat.c
      unittests: add unittest suite for oslib/strndup.c
      lib: fix strntol's end pointer when str has leading spaces
      oslib: fix strlcat's incorrect copying

 .gitignore                |  1 +
 Makefile                  | 26 +++++++++++++++--
 configure                 | 26 +++++++++++++++++
 lib/strntol.c             |  2 +-
 oslib/strlcat.c           | 69 ++++++++++++++++++++++++++++++++-------------
 oslib/strlcat.h           |  2 +-
 unittests/lib/memalign.c  | 27 ++++++++++++++++++
 unittests/lib/strntol.c   | 59 +++++++++++++++++++++++++++++++++++++++
 unittests/oslib/strlcat.c | 52 ++++++++++++++++++++++++++++++++++
 unittests/oslib/strndup.c | 63 +++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.c      | 71 +++++++++++++++++++++++++++++++++++++++++++++++
 unittests/unittest.h      | 26 +++++++++++++++++
 12 files changed, 400 insertions(+), 24 deletions(-)
 create mode 100644 unittests/lib/memalign.c
 create mode 100644 unittests/lib/strntol.c
 create mode 100644 unittests/oslib/strlcat.c
 create mode 100644 unittests/oslib/strndup.c
 create mode 100644 unittests/unittest.c
 create mode 100644 unittests/unittest.h

---

Diff of recent changes:

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
index 4721b78..5ac568e 100644
--- a/Makefile
+++ b/Makefile
@@ -300,6 +300,23 @@ T_PROGS += $(T_VS_PROGS)
 
 PROGS += $(T_PROGS)
 
+ifdef CONFIG_HAVE_CUNIT
+UT_OBJS = unittests/unittest.o
+UT_OBJS += unittests/lib/memalign.o
+UT_OBJS += unittests/lib/strntol.o
+UT_OBJS += unittests/oslib/strlcat.o
+UT_OBJS += unittests/oslib/strndup.o
+UT_TARGET_OBJS = lib/memalign.o
+UT_TARGET_OBJS += lib/strntol.o
+UT_TARGET_OBJS += oslib/strlcat.o
+UT_TARGET_OBJS += oslib/strndup.o
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
@@ -326,7 +343,7 @@ mandir = $(prefix)/man
 sharedir = $(prefix)/share/fio
 endif
 
-all: $(PROGS) $(T_TEST_PROGS) $(SCRIPTS) FORCE
+all: $(PROGS) $(T_TEST_PROGS) $(UT_PROGS) $(SCRIPTS) FORCE
 
 .PHONY: all install clean test
 .PHONY: FORCE cscope
@@ -467,8 +484,13 @@ t/fio-verify-state: $(T_VS_OBJS)
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
diff --git a/lib/strntol.c b/lib/strntol.c
index f622c8d..c3a55a1 100644
--- a/lib/strntol.c
+++ b/lib/strntol.c
@@ -28,6 +28,6 @@ long strntol(const char *str, size_t sz, char **end, int base)
 	if (ret == LONG_MIN || ret == LONG_MAX)
 		return ret;
 	if (end)
-		*end = (char *)str + (*end - buf);
+		*end = (char *)beg + (*end - buf);
 	return ret;
 }
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
new file mode 100644
index 0000000..1166e6e
--- /dev/null
+++ b/unittests/unittest.c
@@ -0,0 +1,71 @@
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
+	fio_unittest_register(fio_unittest_lib_memalign);
+	fio_unittest_register(fio_unittest_lib_strntol);
+	fio_unittest_register(fio_unittest_oslib_strlcat);
+	fio_unittest_register(fio_unittest_oslib_strndup);
+
+	CU_basic_set_mode(CU_BRM_VERBOSE);
+	CU_basic_run_tests();
+	CU_cleanup_registry();
+
+	return CU_get_error();
+}
diff --git a/unittests/unittest.h b/unittests/unittest.h
new file mode 100644
index 0000000..d3e3822
--- /dev/null
+++ b/unittests/unittest.h
@@ -0,0 +1,26 @@
+#ifndef FIO_UNITTEST_H
+#define FIO_UNITTEST_H
+
+#include <sys/types.h>
+
+#include <CUnit/CUnit.h>
+#include <CUnit/Basic.h>
+
+struct fio_unittest_entry {
+	const char *name;
+	CU_TestFunc fn;
+};
+
+/* XXX workaround lib/memalign.c's dependency on smalloc.c */
+void *smalloc(size_t);
+void sfree(void*);
+
+CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
+	CU_CleanupFunc, struct fio_unittest_entry*);
+
+CU_ErrorCode fio_unittest_lib_memalign(void);
+CU_ErrorCode fio_unittest_lib_strntol(void);
+CU_ErrorCode fio_unittest_oslib_strlcat(void);
+CU_ErrorCode fio_unittest_oslib_strndup(void);
+
+#endif

