Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:46828 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729885AbfINMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Sep 2019 08:00:05 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i96ii-00018M-By
        for fio@vger.kernel.org; Sat, 14 Sep 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190914120001.B78992C0099@kernel.dk>
Date: Sat, 14 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4c29a34fcc8cae333ec8b7af7657495745153b44:

  Merge branch 'ioring_add_sync_file_range' of https://github.com/anarazel/fio (2019-09-12 14:24:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae3ae8367271e6df7be5eae37c15c00e6c2dc76e:

  Merge branch 'fio_reset_sqe' of https://github.com/anarazel/fio (2019-09-13 14:56:16 -0600)

----------------------------------------------------------------
Andres Freund (1):
      engines/io_uring: Fully clear out previous SQE contents.

Jens Axboe (1):
      Merge branch 'fio_reset_sqe' of https://github.com/anarazel/fio

 engines/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 53cb60c5..e5edfcd2 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -152,15 +152,16 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 	struct io_uring_sqe *sqe;
 
 	sqe = &ld->sqes[io_u->index];
+
+	/* zero out fields not used in this submission */
+	memset(sqe, 0, sizeof(*sqe));
+
 	if (o->registerfiles) {
 		sqe->fd = f->engine_pos;
 		sqe->flags = IOSQE_FIXED_FILE;
 	} else {
 		sqe->fd = f->fd;
-		sqe->flags = 0;
 	}
-	sqe->ioprio = 0;
-	sqe->buf_index = 0;
 
 	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
 		if (o->fixedbufs) {
@@ -187,7 +188,6 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->sync_range_flags = td->o.sync_file_range;
 			sqe->opcode = IORING_OP_SYNC_FILE_RANGE;
 		} else {
-			sqe->fsync_flags = 0;
 			if (io_u->ddir == DDIR_DATASYNC)
 				sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
 			sqe->opcode = IORING_OP_FSYNC;

