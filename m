Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54584 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbeDDMAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 4 Apr 2018 08:00:17 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1f3h5M-0001aH-V3
        for fio@vger.kernel.org; Wed, 04 Apr 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180404120002.0DAF32C00D1@kernel.dk>
Date: Wed,  4 Apr 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit cefd2a94b408b9c3be0300edb1270a546e7f09fe:

  Merge branch 'aarch64-crc32c' of https://github.com/sitsofe/fio (2018-03-30 10:16:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 196ce5d5ff76af30cf93fd24240f12d8c4d24381:

  Merge branch 'fixbug_glfs' of https://github.com/simon-rock/fio (2018-04-03 08:19:38 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fixbug_glfs' of https://github.com/simon-rock/fio

simon (1):
      glusterfs: always allocate io_u->engine_data

 engines/glusterfs_async.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 97271d6..eb8df45 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -70,20 +70,17 @@ static void fio_gf_io_u_free(struct thread_data *td, struct io_u *io_u)
 
 static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
+    struct fio_gf_iou *io;
 	dprint(FD_FILE, "%s\n", __FUNCTION__);
-
-	if (!io_u->engine_data) {
-		struct fio_gf_iou *io;
-
-		io = malloc(sizeof(struct fio_gf_iou));
-		if (!io) {
-			td_verror(td, errno, "malloc");
-			return 1;
-		}
-		io->io_complete = 0;
-		io->io_u = io_u;
-		io_u->engine_data = io;
-	}
+    
+    io = malloc(sizeof(struct fio_gf_iou));
+    if (!io) {
+        td_verror(td, errno, "malloc");
+        return 1;
+    }
+    io->io_complete = 0;
+    io->io_u = io_u;
+    io_u->engine_data = io;
 	return 0;
 }
 
