Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] smalloc: allocate struct pool array from shared memory
Date: Tue,  3 Sep 2019 13:44:44 -0400
Message-Id: <20190903174445.1212-2-vincentfu@gmail.com>
In-Reply-To: <20190903174445.1212-1-vincentfu@gmail.com>
References: <20190903174445.1212-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

If one process is making smalloc calls and another process is making
sfree calls, pool->free_blocks and pool->next_non_full will not be
synchronized because the two processes each have independent, local
copies of the variables.

This patch allocates space for the array of struct pool instances from
shared storage so that separate processes will be modifying quantities
stored at the same locations.

This issue was discovered on the server side running a client/server job
with --status-interval=1. Such a job encountered an OOM error when only
~50 objects were allocated from the smalloc pool.
---
 smalloc.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/smalloc.c b/smalloc.c
index 125e07bf..39bf47a5 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -54,7 +54,7 @@ struct block_hdr {
  */
 static const bool enable_smalloc_debug = false;
 
-static struct pool mp[MAX_POOLS];
+static struct pool *mp;
 static unsigned int nr_pools;
 static unsigned int last_pool;
 
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
-- 
2.17.1


