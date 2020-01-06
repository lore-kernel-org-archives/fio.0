Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41058 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgAFNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Jan 2020 08:00:05 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ioRzI-00025L-Q9
        for fio@vger.kernel.org; Mon, 06 Jan 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200106130002.22BC31BC0165@kernel.dk>
Date: Mon,  6 Jan 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fa6e7f4fb827adb124dbb97a7f72d64e76b2fe6a:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-04 20:22:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dbab52955aeb0b58cc88c8eff1b1c2239241f0bd:

  Merge branch 'memalign1' of https://github.com/kusumi/fio (2020-01-05 10:31:40 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'memalign1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      lib/memalign: remove smalloc()/sfree() dependency

 fio.h                    | 12 ++++++++++++
 lib/memalign.c           | 15 ++++-----------
 lib/memalign.h           |  7 +++++--
 t/dedupe.c               |  2 +-
 unittests/lib/memalign.c |  3 ++-
 unittests/unittest.c     | 11 -----------
 unittests/unittest.h     |  4 ----
 7 files changed, 24 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/fio.h b/fio.h
index e943ad16..6a5ead4d 100644
--- a/fio.h
+++ b/fio.h
@@ -36,6 +36,8 @@
 #include "lib/rand.h"
 #include "lib/rbtree.h"
 #include "lib/num2str.h"
+#include "lib/memalign.h"
+#include "smalloc.h"
 #include "client.h"
 #include "server.h"
 #include "stat.h"
@@ -856,4 +858,14 @@ extern void check_trigger_file(void);
 extern bool in_flight_overlap(struct io_u_queue *q, struct io_u *io_u);
 extern pthread_mutex_t overlap_check;
 
+static inline void *fio_memalign(size_t alignment, size_t size, bool shared)
+{
+	return __fio_memalign(alignment, size, shared ? smalloc : malloc);
+}
+
+static inline void fio_memfree(void *ptr, size_t size, bool shared)
+{
+	return __fio_memfree(ptr, size, shared ? sfree : free);
+}
+
 #endif
diff --git a/lib/memalign.c b/lib/memalign.c
index 537bb9fb..214a66fa 100644
--- a/lib/memalign.c
+++ b/lib/memalign.c
@@ -11,18 +11,14 @@ struct align_footer {
 	unsigned int offset;
 };
 
-void *fio_memalign(size_t alignment, size_t size, bool shared)
+void *__fio_memalign(size_t alignment, size_t size, malloc_fn fn)
 {
 	struct align_footer *f;
 	void *ptr, *ret = NULL;
 
 	assert(!(alignment & (alignment - 1)));
 
-	if (shared)
-		ptr = smalloc(size + alignment + sizeof(*f) - 1);
-	else
-		ptr = malloc(size + alignment + sizeof(*f) - 1);
-
+	ptr = fn(size + alignment + sizeof(*f) - 1);
 	if (ptr) {
 		ret = PTR_ALIGN(ptr, alignment - 1);
 		f = ret + size;
@@ -32,12 +28,9 @@ void *fio_memalign(size_t alignment, size_t size, bool shared)
 	return ret;
 }
 
-void fio_memfree(void *ptr, size_t size, bool shared)
+void __fio_memfree(void *ptr, size_t size, free_fn fn)
 {
 	struct align_footer *f = ptr + size;
 
-	if (shared)
-		sfree(ptr - f->offset);
-	else
-		free(ptr - f->offset);
+	fn(ptr - f->offset);
 }
diff --git a/lib/memalign.h b/lib/memalign.h
index d7030870..815e3aa2 100644
--- a/lib/memalign.h
+++ b/lib/memalign.h
@@ -4,7 +4,10 @@
 #include <inttypes.h>
 #include <stdbool.h>
 
-extern void *fio_memalign(size_t alignment, size_t size, bool shared);
-extern void fio_memfree(void *ptr, size_t size, bool shared);
+typedef void* (*malloc_fn)(size_t);
+typedef void (*free_fn)(void*);
+
+extern void *__fio_memalign(size_t alignment, size_t size, malloc_fn fn);
+extern void __fio_memfree(void *ptr, size_t size, free_fn fn);
 
 #endif
diff --git a/t/dedupe.c b/t/dedupe.c
index 2ef8dc53..68d31f19 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -10,13 +10,13 @@
 #include <unistd.h>
 #include <sys/stat.h>
 
+#include "../fio.h"
 #include "../flist.h"
 #include "../log.h"
 #include "../fio_sem.h"
 #include "../smalloc.h"
 #include "../minmax.h"
 #include "../crc/md5.h"
-#include "../lib/memalign.h"
 #include "../os/os.h"
 #include "../gettime.h"
 #include "../fio_time.h"
diff --git a/unittests/lib/memalign.c b/unittests/lib/memalign.c
index 854c2744..42a2e31a 100644
--- a/unittests/lib/memalign.c
+++ b/unittests/lib/memalign.c
@@ -1,3 +1,4 @@
+#include <stdlib.h>
 #include "../unittest.h"
 
 #include "../../lib/memalign.h"
@@ -5,7 +6,7 @@
 static void test_memalign_1(void)
 {
 	size_t align = 4096;
-	void *p = fio_memalign(align, 1234, false);
+	void *p = __fio_memalign(align, 1234, malloc);
 
 	if (p)
 		CU_ASSERT_EQUAL(((int)(uintptr_t)p) & (align - 1), 0);
diff --git a/unittests/unittest.c b/unittests/unittest.c
index 66789e4f..c37e1971 100644
--- a/unittests/unittest.c
+++ b/unittests/unittest.c
@@ -8,17 +8,6 @@
 
 #include "./unittest.h"
 
-/* XXX workaround lib/memalign.c's dependency on smalloc.c */
-void *smalloc(size_t size)
-{
-	return malloc(size);
-}
-
-void sfree(void *ptr)
-{
-	free(ptr);
-}
-
 CU_ErrorCode fio_unittest_add_suite(const char *name, CU_InitializeFunc initfn,
 	CU_CleanupFunc cleanfn, struct fio_unittest_entry *tvec)
 {
diff --git a/unittests/unittest.h b/unittests/unittest.h
index bbc49613..786c1c97 100644
--- a/unittests/unittest.h
+++ b/unittests/unittest.h
@@ -11,10 +11,6 @@ struct fio_unittest_entry {
 	CU_TestFunc fn;
 };
 
-/* XXX workaround lib/memalign.c's dependency on smalloc.c */
-void *smalloc(size_t);
-void sfree(void*);
-
 CU_ErrorCode fio_unittest_add_suite(const char*, CU_InitializeFunc,
 	CU_CleanupFunc, struct fio_unittest_entry*);
 

