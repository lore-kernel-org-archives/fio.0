Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54850 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751515AbcLFNAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Dec 2016 08:00:46 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cEFLn-000514-E5
        for fio@vger.kernel.org; Tue, 06 Dec 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161206130001.AA51C2C16A9@kernel.dk>
Date: Tue,  6 Dec 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 6be06c46544c19e513ff80e7b841b1de688ffc66:

  log: fix for crash with rate IO and logging (2016-12-01 21:23:47 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 487197d9e8f3aa0f135a6d88e5f222a1a930723a:

  mmap engine: remove unused variable mmap_map_mask (2016-12-05 09:48:08 -0700)

----------------------------------------------------------------
Ross Zwisler (1):
      mmap engine: remove unused variable mmap_map_mask

 engines/mmap.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/engines/mmap.c b/engines/mmap.c
index 14e4013..c479ed3 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -20,7 +20,6 @@
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
 
 static unsigned long mmap_map_size;
-static unsigned long mmap_map_mask;
 
 struct fio_mmap_data {
 	void *mmap_ptr;
@@ -72,7 +71,6 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 		(void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
 #endif
 
-
 err:
 	if (td->error && fmd->mmap_ptr)
 		munmap(fmd->mmap_ptr, length);
@@ -208,26 +206,15 @@ static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 static int fio_mmapio_init(struct thread_data *td)
 {
 	struct thread_options *o = &td->o;
-	unsigned long shift, mask;
 
-	if ((td->o.rw_min_bs & page_mask) &&
+	if ((o->rw_min_bs & page_mask) &&
 	    (o->odirect || o->fsync_blocks || o->fdatasync_blocks)) {
 		log_err("fio: mmap options dictate a minimum block size of "
 			"%llu bytes\n", (unsigned long long) page_size);
 		return 1;
 	}
 
-	mmap_map_size = MMAP_TOTAL_SZ / td->o.nr_files;
-	mask = mmap_map_size;
-	shift = 0;
-	do {
-		mask >>= 1;
-		if (!mask)
-			break;
-		shift++;
-	} while (1);
-
-	mmap_map_mask = 1UL << shift;
+	mmap_map_size = MMAP_TOTAL_SZ / o->nr_files;
 	return 0;
 }
 
