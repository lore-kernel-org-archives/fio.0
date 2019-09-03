Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] smalloc: use SMALLOC_BPI instead of SMALLOC_BPB in add_pool()
Date: Tue,  3 Sep 2019 13:44:45 -0400
Message-Id: <20190903174445.1212-3-vincentfu@gmail.com>
In-Reply-To: <20190903174445.1212-1-vincentfu@gmail.com>
References: <20190903174445.1212-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Change the calculation of free_blocks in add_pool() to use SMALLOC_BPI
instead of SMALLOC_BPB. These two constants are coincidentally the same
on Linux and Windows but SMALLOC_BPI is the correct one to use.
free_blocks is the number of available blocks of size SMALLOC_BPB. It is
the product of the number of unsigned integers in the bitmap
(bitmap_blocks) and the number of bits per unsigned integer
(SMALLOC_BPI).
---
 smalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/smalloc.c b/smalloc.c
index 39bf47a5..fa00f0ee 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -173,7 +173,7 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 	pool->mmap_size = alloc_size;
 
 	pool->nr_blocks = bitmap_blocks;
-	pool->free_blocks = bitmap_blocks * SMALLOC_BPB;
+	pool->free_blocks = bitmap_blocks * SMALLOC_BPI;
 
 	mmap_flags = OS_MAP_ANON;
 #ifdef CONFIG_ESX
-- 
2.17.1


