Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbbKHNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 8 Nov 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZvPZk-0005D0-Rq
	for fio@vger.kernel.org; Sun, 08 Nov 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151108130002.536E42C00B0@kernel.dk>
Date: Sun,  8 Nov 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 513e37eeb01a3037763124869dfcdd6152d92ab8:

  Add latency bin output to the json output format (2015-11-06 08:46:44 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 9c3e13e3314da394698ca32f21cc46d46b7cfe47:

  smalloc: only clear the bitmap, not the whole pool (2015-11-07 17:33:38 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      smalloc: only clear the bitmap, not the whole pool

Martin Steigerwald (1):
      Fix spelling error in engines/rdma.c

 engines/rdma.c | 2 +-
 smalloc.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rdma.c b/engines/rdma.c
index 7eb0051..1006b7e 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -115,7 +115,7 @@ static struct fio_option options[] = {
 			  },
 			  { .ival = "recv",
 			    .oval = FIO_RDMA_CHA_RECV,
-			    .help = "Posted Recieve",
+			    .help = "Posted Receive",
 			  },
 		},
 		.category = FIO_OPT_C_ENGINE,
diff --git a/smalloc.c b/smalloc.c
index 8412e75..5047cda 100644
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
