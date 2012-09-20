Return-Path: <rjevskiy@gmail.com>
Sender: Dmitry Monakhov <rjevskiy@gmail.com>
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] falloc: fix return value from queue
Date: Thu, 20 Sep 2012 15:37:16 +0400
Message-Id: <1348141037-16303-1-git-send-email-dmonakhov@openvz.org>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>
List-ID: <fio@vger.kernel.org>

Fix mistypo which causes internal assertation failure, this engine
will always return FIO_Q_COMPLETED

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 engines/falloc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/engines/falloc.c b/engines/falloc.c
index cbb30cb..4977d9e 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -91,8 +91,6 @@ static int fio_fallocate_queue(struct thread_data *td, struct io_u *io_u)
 		if (io_u->error)
 			td_verror(td, io_u->error, "xfer");
 	}
-	if (io_u->ddir == DDIR_TRIM && !ret)
-		return io_u->xfer_buflen;
 
 	if (io_u->file && ret == 0 && ddir_rw(io_u->ddir))
 		io_u->file->file_pos = io_u->offset + ret;
-- 
1.7.7.6


