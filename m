Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38644 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbeLBNAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 Dec 2018 08:00:12 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gTRM0-0000Et-Pa
        for fio@vger.kernel.org; Sun, 02 Dec 2018 13:00:08 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181202130002.853D22C01D6@kernel.dk>
Date: Sun,  2 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 68afa5b570a7e0dce0470817037f7828cf36cd2f:

  stat: assign for first stat iteration, don't sum (2018-11-30 14:44:25 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6f3a2c116481731abdf2fbed2d0f63cf4d3ddca2:

  engines/libaio: set IOCB_HIPRI if we are polling (2018-12-01 10:17:26 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      engines/libaio: set IOCB_HIPRI if we are polling

 engines/libaio.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/libaio.c b/engines/libaio.c
index 9c8a61b..a780b2b 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -130,15 +130,21 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 			iocb->aio_fildes = f->fd;
 			iocb->aio_lio_opcode = IO_CMD_PREAD;
 			iocb->u.c.offset = io_u->offset;
-		} else
+		} else {
 			io_prep_pread(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		}
 	} else if (io_u->ddir == DDIR_WRITE) {
 		if (o->fixedbufs) {
 			iocb->aio_fildes = f->fd;
 			iocb->aio_lio_opcode = IO_CMD_PWRITE;
 			iocb->u.c.offset = io_u->offset;
-		} else
+		} else {
 			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+			if (o->hipri)
+				iocb->u.c.flags |= IOCB_FLAG_HIPRI;
+		}
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(iocb, f->fd);
 

