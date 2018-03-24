Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52506 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751861AbeCXMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 24 Mar 2018 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1ezhqD-0005Ab-2K
        for fio@vger.kernel.org; Sat, 24 Mar 2018 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180324120001.C596B2C00CF@kernel.dk>
Date: Sat, 24 Mar 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 87c6f22bf24da4679849ccf778451b8432c2b368:

  server: use scalloc() for sk_out allocation (2018-03-22 11:29:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b348b7c7a1a6278d793698fc23993620ae9c588a:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-03-23 09:58:51 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      smalloc: Remove Valgrind instrumentation
      Merge branch 'master' of https://github.com/bvanassche/fio

 smalloc.c | 34 ++--------------------------------
 1 file changed, 2 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 7b1690a..a2ad25a 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -5,13 +5,6 @@
 #include <sys/mman.h>
 #include <assert.h>
 #include <string.h>
-#ifdef CONFIG_VALGRIND_DEV
-#include <valgrind/valgrind.h>
-#else
-#define RUNNING_ON_VALGRIND 0
-#define VALGRIND_MALLOCLIKE_BLOCK(addr, size, rzB, is_zeroed) do { } while (0)
-#define VALGRIND_FREELIKE_BLOCK(addr, rzB) do { } while (0)
-#endif
 
 #include "fio.h"
 #include "fio_sem.h"
@@ -48,12 +41,6 @@ struct pool {
 	size_t mmap_size;
 };
 
-#ifdef SMALLOC_REDZONE
-#define REDZONE_SIZE sizeof(unsigned int)
-#else
-#define REDZONE_SIZE 0
-#endif
-
 struct block_hdr {
 	size_t size;
 #ifdef SMALLOC_REDZONE
@@ -263,10 +250,6 @@ static void fill_redzone(struct block_hdr *hdr)
 {
 	unsigned int *postred = postred_ptr(hdr);
 
-	/* Let Valgrind fill the red zones. */
-	if (RUNNING_ON_VALGRIND)
-		return;
-
 	hdr->prered = SMALLOC_PRE_RED;
 	*postred = SMALLOC_POST_RED;
 }
@@ -275,10 +258,6 @@ static void sfree_check_redzone(struct block_hdr *hdr)
 {
 	unsigned int *postred = postred_ptr(hdr);
 
-	/* Let Valgrind check the red zones. */
-	if (RUNNING_ON_VALGRIND)
-		return;
-
 	if (hdr->prered != SMALLOC_PRE_RED) {
 		log_err("smalloc pre redzone destroyed!\n"
 			" ptr=%p, prered=%x, expected %x\n",
@@ -346,7 +325,6 @@ void sfree(void *ptr)
 	}
 
 	if (pool) {
-		VALGRIND_FREELIKE_BLOCK(ptr, REDZONE_SIZE);
 		sfree_pool(pool, ptr);
 		return;
 	}
@@ -437,7 +415,7 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 	return ptr;
 }
 
-static void *__smalloc(size_t size, bool is_zeroed)
+void *smalloc(size_t size)
 {
 	unsigned int i, end_pool;
 
@@ -453,9 +431,6 @@ static void *__smalloc(size_t size, bool is_zeroed)
 
 			if (ptr) {
 				last_pool = i;
-				VALGRIND_MALLOCLIKE_BLOCK(ptr, size,
-							  REDZONE_SIZE,
-							  is_zeroed);
 				return ptr;
 			}
 		}
@@ -473,14 +448,9 @@ static void *__smalloc(size_t size, bool is_zeroed)
 	return NULL;
 }
 
-void *smalloc(size_t size)
-{
-	return __smalloc(size, false);
-}
-
 void *scalloc(size_t nmemb, size_t size)
 {
-	return __smalloc(nmemb * size, true);
+	return smalloc(nmemb * size);
 }
 
 char *smalloc_strdup(const char *str)
