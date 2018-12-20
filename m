Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729988AbeLTNAW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Dec 2018 08:00:22 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gZxw6-0007UD-BM
        for fio@vger.kernel.org; Thu, 20 Dec 2018 13:00:22 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181220130001.C6F962C004F@kernel.dk>
Date: Thu, 20 Dec 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5b8f19b7afe0cabc002c453a1a4abd7a494880bb:

  Fix 'min' latency times being 0 with ramp_time (2018-12-14 14:36:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d63a472d4b213533236ae9aab9cf9e0ec2854c31:

  engines/aio-ring: initialization error handling (2018-12-19 12:55:10 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/aio-ring: cleanup read/write prep
      engines/aio-ring: initialization error handling

 engines/aioring.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/engines/aioring.c b/engines/aioring.c
index 925b8862..59551f9c 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -197,26 +197,20 @@ static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
 
 	iocb = &ld->iocbs[io_u->index];
 
-	if (io_u->ddir == DDIR_READ) {
-		if (o->fixedbufs) {
-			iocb->aio_fildes = f->fd;
+	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		if (io_u->ddir == DDIR_READ)
 			iocb->aio_lio_opcode = IO_CMD_PREAD;
-			iocb->u.c.offset = io_u->offset;
-		} else {
-			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		}
-	} else if (io_u->ddir == DDIR_WRITE) {
-		if (o->fixedbufs) {
-			iocb->aio_fildes = f->fd;
+		else
 			iocb->aio_lio_opcode = IO_CMD_PWRITE;
-			iocb->u.c.offset = io_u->offset;
-		} else {
-			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
-			if (o->hipri)
-				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
-		}
+		iocb->aio_reqprio = 0;
+		iocb->aio_fildes = f->fd;
+		iocb->u.c.buf = io_u->xfer_buf;
+		iocb->u.c.nbytes = io_u->xfer_buflen;
+		iocb->u.c.offset = io_u->offset;
+		if (o->hipri)
+			iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		else
+			iocb->u.c.flags = 0;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 
@@ -521,13 +515,15 @@ static int fio_aioring_post_init(struct thread_data *td)
 	}
 
 	err = fio_aioring_queue_init(td);
+
+	/* Adjust depth back again */
+	td->o.iodepth--;
+
 	if (err) {
-		td_verror(td, -err, "io_queue_init");
+		td_verror(td, errno, "io_queue_init");
 		return 1;
 	}
 
-	/* Adjust depth back again */
-	td->o.iodepth--;
 	return 0;
 }
 

