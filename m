Return-Path: <axboe@kernel.dk>
Date: Sat, 7 Nov 2015 17:34:48 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Increasing startup time
Message-ID: <20151108003448.GD9335@kernel.dk>
References: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
 <20151108002911.GB9335@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151108002911.GB9335@kernel.dk>
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Sat, Nov 07 2015, Jens Axboe wrote:
> On Thu, Nov 05 2015, Matthew Eaton wrote:
> > I noticed during testing recent fio releases it seemed bit laggy to
> > start, so I tried some tests and it seems fio has been increasingly
> > taking longer to start for some reason.  Don't know if this is
> > expected or if something is wrong?
> 
> Try the below.

Committed, with a fixup to still clear the actual bitmap. Should work
faster for you than even the earlier versions you tested.


commit 9c3e13e3314da394698ca32f21cc46d46b7cfe47
Author: Jens Axboe <axboe@fb.com>
Date:   Sat Nov 7 17:33:38 2015 -0700

    smalloc: only clear the bitmap, not the whole pool
    
    This reduces startup time, and the memset() isn't useful nor
    needed on the full range.
    
    Signed-off-by: Jens Axboe <axboe@fb.com>

diff --git a/smalloc.c b/smalloc.c
index 8412e7518464..5047cda5e343 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -213,9 +213,9 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 	if (ptr == MAP_FAILED)
 		goto out_fail;
 
-	memset(ptr, 0, alloc_size);
 	pool->map = ptr;
 	pool->bitmap = (void *) ptr + (pool->nr_blocks * SMALLOC_BPL);
+	memset(pool->bitmap, 0, bitmap_blocks * sizeof(unsigned int));
 
 	pool->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
 	if (!pool->lock)

-- 
Jens Axboe


