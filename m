Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 8/8] smalloc: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:08:01 +0300
Message-Id: <20170623220801.38178-9-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 smalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/smalloc.c b/smalloc.c
index e48cfe8..cab7132 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -189,7 +189,7 @@ static bool add_pool(struct pool *pool, unsigned int alloc_size)
 		goto out_fail;
 
 	pool->map = ptr;
-	pool->bitmap = (void *) ptr + (pool->nr_blocks * SMALLOC_BPL);
+	pool->bitmap = (unsigned int *)((char *) ptr + (pool->nr_blocks * SMALLOC_BPL));
 	memset(pool->bitmap, 0, bitmap_blocks * sizeof(unsigned int));
 
 	pool->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
-- 
2.9.4


