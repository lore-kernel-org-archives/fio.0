Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbfIDMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Sep 2019 08:00:14 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i5TxO-0004lo-17
        for fio@vger.kernel.org; Wed, 04 Sep 2019 12:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190904120002.62C1F2C02C3@kernel.dk>
Date: Wed,  4 Sep 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 971d6a22bad5942234496683d89a2f8deed57172:

  zbd: Improve job zonesize initialization checks (2019-08-29 20:51:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4a479420d50eada0a7b9a972c529d75e2884732d:

  smalloc: use SMALLOC_BPI instead of SMALLOC_BPB in add_pool() (2019-09-03 12:32:01 -0600)

----------------------------------------------------------------
Vincent Fu (2):
      smalloc: allocate struct pool array from shared memory
      smalloc: use SMALLOC_BPI instead of SMALLOC_BPB in add_pool()

 smalloc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/smalloc.c b/smalloc.c
index 125e07bf..fa00f0ee 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -54,7 +54,7 @@ struct block_hdr {
  */
 static const bool enable_smalloc_debug = false;
 
-static struct pool mp[MAX_POOLS];
+static struct pool *mp;
 static unsigned int nr_pools;
 static unsigned int last_pool;
 
@@ -173,7 +173,7 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->mmap_size = alloc_size;
 
 	pool->nr_blocks = bitmap_blocks;
-	pool->free_blocks = bitmap_blocks * SMALLOC_BPB;
+	pool->free_blocks = bitmap_blocks * SMALLOC_BPI;
 
 	mmap_flags = OS_MAP_ANON;
 #ifdef CONFIG_ESX
@@ -208,6 +208,20 @@ void sinit(void)
 	bool ret;
 	int i;
 
+	/*
+	 * sinit() can be called more than once if alloc-size is
+	 * set. But we want to allocate space for the struct pool
+	 * instances only once.
+	 */
+	if (!mp) {
+		mp = (struct pool *) mmap(NULL,
+			MAX_POOLS * sizeof(struct pool),
+			PROT_READ | PROT_WRITE,
+			OS_MAP_ANON | MAP_SHARED, -1, 0);
+
+		assert(mp != MAP_FAILED);
+	}
+
 	for (i = 0; i < INITIAL_POOLS; i++) {
 		ret = add_pool(&mp[nr_pools], smalloc_pool_size);
 		if (!ret)
@@ -239,6 +253,8 @@ void scleanup(void)
 
 	for (i = 0; i < nr_pools; i++)
 		cleanup_pool(&mp[i]);
+
+	munmap(mp, MAX_POOLS * sizeof(struct pool));
 }
 
 #ifdef SMALLOC_REDZONE

