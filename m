Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53120 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbbF3MAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 30 Jun 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z9uCq-0005Rm-Pl
	for fio@vger.kernel.org; Tue, 30 Jun 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150630120001.BBE972C006D@kernel.dk>
Date: Tue, 30 Jun 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6b2db5c151bf676960046cd1dd2919be7cf30048:

  Fio 2.2.9 (2015-06-25 11:13:19 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 94815a5c8366a9290167e8539f29994c2d43d15c:

  configure: fixup clang stupidity (2015-06-29 20:46:31 -0600)

----------------------------------------------------------------
Alireza Haghdoost (1):
      Use _Static_assert() if available

Jens Axboe (4):
      workqueue: make it work on platforms without __sync_fetch_and_add()
      Kill duplicate __sync_fetch_and_add()
      t/stest: shrink test size from 128MB
      configure: fixup clang stupidity

 compiler/compiler.h |  8 ++++++++
 configure           | 36 +++++++++++++++++++++++++++++++++++-
 t/stest.c           |  2 +-
 workqueue.c         | 22 ++++++++++++++++++++++
 workqueue.h         |  1 +
 5 files changed, 67 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/compiler/compiler.h b/compiler/compiler.h
index 40e857c..a6a7432 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -1,5 +1,6 @@
 #ifndef FIO_COMPILER_H
 #define FIO_COMPILER_H
+#include <assert.h>
 
 #if __GNUC__ >= 4
 #include "compiler-gcc4.h"
@@ -33,6 +34,11 @@
 	1; \
 })
 
+
+#if defined(CONFIG_STATIC_ASSERT)
+#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
+
+#else
 #ifndef __compiletime_error
 #define __compiletime_error(message)
 #endif
@@ -56,3 +62,5 @@
 	_compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
 
 #endif
+
+#endif
diff --git a/configure b/configure
index e459d63..a3f83d3 100755
--- a/configure
+++ b/configure
@@ -547,7 +547,7 @@ fi
 echo "Solaris AIO support           $solaris_aio"
 
 ##########################################
-# __sync_fetch_and_and test
+# __sync_fetch_and_add test
 sfaa="no"
 cat > $TMPC << EOF
 static int sfaa(int *ptr)
@@ -1492,6 +1492,37 @@ if compile_prog "" "" "getmntinfo"; then
 fi
 echo "getmntinfo                    $getmntinfo"
 
+##########################################
+# Check whether we have _Static_assert
+static_assert="no"
+cat > $TMPC << EOF
+#include <assert.h>
+#include <stdlib.h>
+#undef offsetof
+#ifdef __compiler_offsetof
+#define offsetof(TYPE,MEMBER) __compiler_offsetof(TYPE,MEMBER)
+#else
+#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
+#endif
+
+#define container_of(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+	(type *)( (char *)__mptr - offsetof(type,member) );})
+
+struct foo {
+  int a, b;
+};
+
+int main(int argc, char **argv)
+{
+  _Static_assert(offsetof(struct foo, a) == 0 , "Check");
+  return 0 ;
+}
+EOF
+if compile_prog "" "" "static_assert"; then
+    static_assert="yes"
+fi
+echo "Static Assert                 $static_assert"
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1671,6 +1702,9 @@ fi
 if test "$getmntinfo" = "yes" ; then
   output_sym "CONFIG_GETMNTINFO"
 fi
+if test "$static_assert" = "yes" ; then
+  output_sym "CONFIG_STATIC_ASSERT"
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/t/stest.c b/t/stest.c
index efb256e..fb51989 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -30,7 +30,7 @@ static int do_rand_allocs(void)
 		srand(MAGIC1);
 #endif
 		nr = total = 0;
-		while (total < 128*1024*1024UL) {
+		while (total < 120*1024*1024UL) {
 			size = 8 * sizeof(struct elem) + (int) (999.0 * (rand() / (RAND_MAX + 1.0)));
 			e = smalloc(size);
 			if (!e) {
diff --git a/workqueue.c b/workqueue.c
index b9a967f..0a6cd20 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -197,6 +197,7 @@ err:
 	return 1;
 }
 
+#ifdef CONFIG_SFAA
 static void sum_val(uint64_t *dst, uint64_t *src)
 {
 	if (*src) {
@@ -204,15 +205,34 @@ static void sum_val(uint64_t *dst, uint64_t *src)
 		*src = 0;
 	}
 }
+#else
+static void sum_val(uint64_t *dst, uint64_t *src)
+{
+	if (*src) {
+		*dst += *src;
+		*src = 0;
+	}
+}
+#endif
 
 static void sum_ddir(struct thread_data *dst, struct thread_data *src,
 		     enum fio_ddir ddir)
 {
+#ifndef CONFIG_SFAA
+	pthread_mutex_lock(&dst->io_wq.stat_lock);
+	pthread_mutex_lock(&src->io_wq.stat_lock);
+#endif
+
 	sum_val(&dst->io_bytes[ddir], &src->io_bytes[ddir]);
 	sum_val(&dst->io_blocks[ddir], &src->io_blocks[ddir]);
 	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
 	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
 	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
+
+#ifndef CONFIG_SFAA
+	pthread_mutex_unlock(&src->io_wq.stat_lock);
+	pthread_mutex_unlock(&dst->io_wq.stat_lock);
+#endif
 }
 
 static void update_accounting(struct submit_worker *sw)
@@ -355,6 +375,7 @@ void workqueue_exit(struct workqueue *wq)
 	free(wq->workers);
 	pthread_mutex_destroy(&wq->flush_lock);
 	pthread_cond_destroy(&wq->flush_cond);
+	pthread_mutex_destroy(&wq->stat_lock);
 }
 
 static int start_worker(struct workqueue *wq, unsigned int index)
@@ -393,6 +414,7 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 	wq->next_free_worker = 0;
 	pthread_cond_init(&wq->flush_cond, NULL);
 	pthread_mutex_init(&wq->flush_lock, NULL);
+	pthread_mutex_init(&wq->stat_lock, NULL);
 
 	wq->workers = calloc(wq->max_workers, sizeof(struct submit_worker));
 
diff --git a/workqueue.h b/workqueue.h
index 5d47a5e..4e92449 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -17,6 +17,7 @@ struct workqueue {
 
 	pthread_cond_t flush_cond;
 	pthread_mutex_t flush_lock;
+	pthread_mutex_t stat_lock;
 	volatile int wake_idle;
 };
 
