Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [three fio patches 3/3] smalloc: allocate pool-> members from shared memory
Date: Wed, 28 Aug 2019 13:48:42 -0400
Message-Id: <20190828174842.25423-4-vincentfu@gmail.com>
In-Reply-To: <20190828174842.25423-1-vincentfu@gmail.com>
References: <20190828174842.25423-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

If one process is making smalloc calls and another process is making
sfree calls, pool->free_blocks and pool->next_non_full will not be
synchronized because the two processes each have independent, local
copies of the variables.

This patch allocates space for the two variables from shared storage so
that separate processes will be modifying quantities stored at the same
locations.

This issue was discovered on the server side running a client/server job
with --status-interval=1. Such a job encountered an OOM error when only
~50 objects were allocated from the smalloc pool.

Also change the calculation of free_blocks in add_pool() to use
SMALLOC_BPI instead of SMALLOC_BPB. These two constants are
coincidentally the same on Linux and Windows but SMALLOC_BPI is the
correct one to use. free_blocks is the number of available blocks of
size SMALLOC_BPB. It is the product of the number of unsigned integers
in the bitmap (bitmap_blocks) and the number of bits per unsigned
integer (SMALLOC_BPI).
---
 smalloc.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/smalloc.c b/smalloc.c
index 125e07bf..ccd73122 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -35,9 +35,9 @@ struct pool {
 	struct fio_sem *lock;			/* protects this pool */
 	void *map;				/* map of blocks */
 	unsigned int *bitmap;			/* blocks free/busy map */
-	size_t free_blocks;		/* free blocks */
+	size_t *free_blocks;			/* free blocks */
 	size_t nr_blocks;			/* total blocks */
-	size_t next_non_full;
+	size_t *next_non_full;
 	size_t mmap_size;
 };
 
@@ -170,10 +170,9 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 	alloc_size = (alloc_size + SMALLOC_BPL - 1) & ~(SMALLOC_BPL - 1);
 	bitmap_blocks = alloc_size / SMALLOC_BPL;
 	alloc_size += bitmap_blocks * sizeof(unsigned int);
+	alloc_size += 2 * sizeof(size_t);
 	pool->mmap_size = alloc_size;
-
 	pool->nr_blocks = bitmap_blocks;
-	pool->free_blocks = bitmap_blocks * SMALLOC_BPB;
 
 	mmap_flags = OS_MAP_ANON;
 #ifdef CONFIG_ESX
@@ -189,6 +188,11 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->map = ptr;
 	pool->bitmap = (unsigned int *)((char *) ptr + (pool->nr_blocks * SMALLOC_BPL));
 	memset(pool->bitmap, 0, bitmap_blocks * sizeof(unsigned int));
+	pool->free_blocks = (size_t *) (pool->bitmap + bitmap_blocks);
+	pool->next_non_full = pool->free_blocks + 1;
+
+	*(pool->free_blocks) = bitmap_blocks * SMALLOC_BPI;
+	*(pool->next_non_full) = 0;
 
 	pool->lock = fio_sem_init(FIO_SEM_UNLOCKED);
 	if (!pool->lock)
@@ -309,9 +313,9 @@ static void sfree_pool(struct pool *pool, void *ptr)
 
 	fio_sem_down(pool->lock);
 	clear_blocks(pool, i, idx, size_to_blocks(hdr->size));
-	if (i < pool->next_non_full)
-		pool->next_non_full = i;
-	pool->free_blocks += size_to_blocks(hdr->size);
+	if (i < *(pool->next_non_full))
+		*(pool->next_non_full) = i;
+	*(pool->free_blocks) += size_to_blocks(hdr->size);
 	fio_sem_up(pool->lock);
 }
 
@@ -342,9 +346,9 @@ static unsigned int find_best_index(struct pool *pool)
 {
 	unsigned int i;
 
-	assert(pool->free_blocks);
+	assert(*(pool->free_blocks));
 
-	for (i = pool->next_non_full; pool->bitmap[i] == -1U; i++) {
+	for (i = *(pool->next_non_full); pool->bitmap[i] == -1U; i++) {
 		if (i == pool->nr_blocks - 1) {
 			unsigned int j;
 
@@ -368,14 +372,14 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 	fio_sem_down(pool->lock);
 
 	nr_blocks = size_to_blocks(size);
-	if (nr_blocks > pool->free_blocks)
+	if (nr_blocks > *(pool->free_blocks))
 		goto fail;
 
-	pool->next_non_full = find_best_index(pool);
+	*(pool->next_non_full) = find_best_index(pool);
 
 	last_idx = 0;
 	offset = -1U;
-	i = pool->next_non_full;
+	i = *(pool->next_non_full);
 	while (i < pool->nr_blocks) {
 		unsigned int idx;
 
@@ -405,7 +409,7 @@ static void *__smalloc_pool(struct pool *pool, size_t size)
 	}
 
 	if (i < pool->nr_blocks) {
-		pool->free_blocks -= nr_blocks;
+		*(pool->free_blocks) -= nr_blocks;
 		ret = pool->map + offset;
 	}
 fail:
@@ -496,9 +500,9 @@ void smalloc_debug(size_t size)
 			(unsigned long) alloc_blocks);
 	for (i = 0; i < nr_pools; i++) {
 		log_err("smalloc: pool %u, free/total blocks %u/%u\n", i,
-			(unsigned int) (mp[i].free_blocks),
+			(unsigned int) *(mp[i].free_blocks),
 			(unsigned int) (mp[i].nr_blocks*sizeof(unsigned int)*8));
-		if (size && mp[i].free_blocks >= alloc_blocks) {
+		if (size && *(mp[i].free_blocks) >= alloc_blocks) {
 			void *ptr = smalloc_pool(&mp[i], size);
 			if (ptr) {
 				sfree(ptr);
@@ -507,7 +511,7 @@ void smalloc_debug(size_t size)
 			} else {
 				log_err("smalloc: smalloc_pool %u failed\n", i);
 				log_err("smalloc: next_non_full=%u, nr_blocks=%u\n",
-					(unsigned int) mp[i].next_non_full, (unsigned int) mp[i].nr_blocks);
+					(unsigned int) *(mp[i].next_non_full), (unsigned int) mp[i].nr_blocks);
 				smalloc_print_bitmap(&mp[i]);
 			}
 		}
-- 
2.17.1


