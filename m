Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46381 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbbCDNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Mar 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YT8uC-0007yT-No
	for fio@vger.kernel.org; Wed, 04 Mar 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150304130003.0C83E4018D@lyth.info>
Date: Wed,  4 Mar 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f52c9691bc8c285f3445235c69acdfd6de7f9b82:

  Fio 2.2.6 (2015-02-27 08:30:04 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 85492cb89e2421ae71d92b1c88e75efda3ee1f1b:

  smalloc: bump initial size to 8 pools (2015-03-03 15:13:17 -0700)

----------------------------------------------------------------
Christian Ehrhardt (1):
      fio: fix smalloc strdop allocation failure

Jens Axboe (1):
      smalloc: bump initial size to 8 pools

 smalloc.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 67cb7cc..b460d65 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -26,7 +26,7 @@
 #define SMALLOC_BPL	(SMALLOC_BPB * SMALLOC_BPI)
 
 #define INITIAL_SIZE	16*1024*1024	/* new pool size */
-#define MAX_POOLS	1		/* maximum number of pools to setup */
+#define MAX_POOLS	8		/* maximum number of pools to setup */
 
 #define SMALLOC_PRE_RED		0xdeadbeefU
 #define SMALLOC_POST_RED	0x5aa55aa5U
@@ -230,11 +230,21 @@ out_fail:
 
 void sinit(void)
 {
-	int ret;
+	int i, ret;
 
 	lock = fio_rwlock_init();
-	ret = add_pool(&mp[0], INITIAL_SIZE);
-	assert(!ret);
+
+	for (i = 0; i < MAX_POOLS; i++) {
+		ret = add_pool(&mp[i], INITIAL_SIZE);
+		if (ret)
+			break;
+	}
+
+	/*
+	 * If we added at least one pool, we should be OK for most
+	 * cases.
+	 */
+	assert(i);
 }
 
 static void cleanup_pool(struct pool *pool)
@@ -442,16 +452,17 @@ static void *smalloc_pool(struct pool *pool, size_t size)
 
 void *smalloc(size_t size)
 {
-	unsigned int i;
+	unsigned int i, end_pool;
 
 	if (size != (unsigned int) size)
 		return NULL;
 
 	global_write_lock();
 	i = last_pool;
+	end_pool = nr_pools;
 
 	do {
-		for (; i < nr_pools; i++) {
+		for (; i < end_pool; i++) {
 			void *ptr = smalloc_pool(&mp[i], size);
 
 			if (ptr) {
@@ -461,20 +472,14 @@ void *smalloc(size_t size)
 			}
 		}
 		if (last_pool) {
-			last_pool = 0;
+			end_pool = last_pool;
+			last_pool = i = 0;
 			continue;
 		}
 
-		if (nr_pools + 1 > MAX_POOLS)
-			break;
-		else {
-			i = nr_pools;
-			if (add_pool(&mp[nr_pools], size))
-				goto out;
-		}
+		break;
 	} while (1);
 
-out:
 	global_write_unlock();
 	return NULL;
 }
@@ -492,9 +497,10 @@ void *scalloc(size_t nmemb, size_t size)
 
 char *smalloc_strdup(const char *str)
 {
-	char *ptr;
+	char *ptr = NULL;
 
 	ptr = smalloc(strlen(str) + 1);
-	strcpy(ptr, str);
+	if (ptr)
+		strcpy(ptr, str);
 	return ptr;
 }
