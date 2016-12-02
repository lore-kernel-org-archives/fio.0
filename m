Return-Path: <fio-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:38798 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751577AbcLCAAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Dec 2016 19:00:08 -0500
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] mmap engine: remove unused variable mmap_map_mask
Date: Fri,  2 Dec 2016 16:59:38 -0700
Message-Id: <1480723178-14499-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, jens.axboe@oracle.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>

The global variable 'mmap_map_mask' was introduced in this commit:

commit ac8931124126 ("mmap engine: allow large files on 32-bit archs")

and was used in fio_mmapio_prep() to calculate f->mmap_off.  This usage was
removed in this commit:

commit ff455a04f4e7 ("mmap engine: fix for large files on 32-bit archs")

but the definition and setup code for 'mmap_map_mask' were left intact.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 engines/mmap.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

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
 
-- 
2.7.4

