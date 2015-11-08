Return-Path: <axboe@kernel.dk>
Date: Sat, 7 Nov 2015 17:29:11 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Increasing startup time
Message-ID: <20151108002911.GB9335@kernel.dk>
References: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mvkVOvpqUHRLO_mBXt7UFMFYJMQWH0Au1wssZHa5V=THVA@mail.gmail.com>
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Nov 05 2015, Matthew Eaton wrote:
> I noticed during testing recent fio releases it seemed bit laggy to
> start, so I tried some tests and it seems fio has been increasingly
> taking longer to start for some reason.  Don't know if this is
> expected or if something is wrong?

Try the below.


diff --git a/smalloc.c b/smalloc.c
index 8412e7518464..ce64d6b73df6 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -213,7 +213,6 @@ static int add_pool(struct pool *pool, unsigned int alloc_size)
 	if (ptr == MAP_FAILED)
 		goto out_fail;
 
-	memset(ptr, 0, alloc_size);
 	pool->map = ptr;
 	pool->bitmap = (void *) ptr + (pool->nr_blocks * SMALLOC_BPL);
 

-- 
Jens Axboe


