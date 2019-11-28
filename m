Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57394 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbfK1NAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Nov 2019 08:00:17 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iaJP6-00020r-B1
        for fio@vger.kernel.org; Thu, 28 Nov 2019 13:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191128130002.715601BC016B@kernel.dk>
Date: Thu, 28 Nov 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b4d867339d3e89ca54104df104f830aa374e31c0:

  Merge branch 'fallocate-truncate' of https://github.com/tripped/fio (2019-11-26 11:57:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bef74db41fb5a1607fd55cb86544165fc08acac1:

  Merge branch 'engine-rados-fix-first' of https://github.com/aclamk/fio (2019-11-27 10:23:12 -0700)

----------------------------------------------------------------
Adam Kupczyk (1):
      engines/rados: fix error with getting last instead of first element from list

Jens Axboe (1):
      Merge branch 'engine-rados-fix-first' of https://github.com/aclamk/fio

 engines/rados.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/engines/rados.c b/engines/rados.c
index cde538b9..30fcebb5 100644
--- a/engines/rados.c
+++ b/engines/rados.c
@@ -342,7 +342,7 @@ int fio_rados_getevents(struct thread_data *td, unsigned int min,
 		}
 		assert(!flist_empty(&rados->completed_operations));
 		
-		fri = flist_last_entry(&rados->completed_operations, struct fio_rados_iou, list);
+		fri = flist_first_entry(&rados->completed_operations, struct fio_rados_iou, list);
 		assert(fri->completion);
 		assert(rados_aio_is_complete(fri->completion));
 		if (fri->write_op != NULL) {

