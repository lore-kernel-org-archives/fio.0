Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f178.google.com ([209.85.220.178]:44360 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEUIb0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 21 May 2014 04:31:26 -0400
Received: by mail-vc0-f178.google.com with SMTP id hq16so2109478vcb.9
        for <fio@vger.kernel.org>; Wed, 21 May 2014 01:31:25 -0700 (PDT)
From: Haomai Wang <haomaiwang@gmail.com>
Subject: [PATCH] Make rbd engine use aio flush
Date: Wed, 21 May 2014 16:30:55 +0800
Message-Id: <1400661055-1452-1-git-send-email-haomaiwang@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Haomai Wang <haomaiwang@gmail.com>

The fio's option "fsync" can make rbd engine issue sync request. In practice,
we would like to use aio_rbd_flush to make it non-block. So it will be more
reliable to use fio to evaluate actual io scene like qemu.

Signed-off-by: Haomai Wang <haomaiwang@gmail.com>
---
 engines/rbd.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/engines/rbd.c b/engines/rbd.c
index d006123..32ce60c 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -195,6 +195,23 @@ static void _fio_rbd_finish_read_aiocb(rbd_completion_t comp, void *data)
 	return;
 }
 
+static void _fio_rbd_finish_sync_aiocb(rbd_completion_t comp, void *data)
+{
+	struct io_u *io_u = (struct io_u *)data;
+	struct fio_rbd_iou *fio_rbd_iou =
+	    (struct fio_rbd_iou *)io_u->engine_data;
+
+	fio_rbd_iou->io_complete = 1;
+
+	/* if sync needs to be verified - we should not release comp here
+	   without fetching the result */
+	rbd_aio_release(comp);
+
+	/* TODO handle error */
+
+	return;
+}
+
 static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 {
 	struct rbd_data *rbd_data = td->io_ops->data;
@@ -281,13 +298,22 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 	} else if (io_u->ddir == DDIR_SYNC) {
-		r = rbd_flush(rbd_data->image);
+		r = rbd_aio_create_completion(io_u,
+					      (rbd_callback_t)
+					      _fio_rbd_finish_sync_aiocb,
+					      &comp);
+		if (r < 0) {
+			log_err
+			    ("rbd_aio_create_completion for DDIR_SYNC failed.\n");
+			goto failed;
+		}
+
+		r = rbd_aio_flush(rbd_data->image, comp);
 		if (r < 0) {
 			log_err("rbd_flush failed.\n");
 			goto failed;
 		}
 
-		return FIO_Q_COMPLETED;
 	} else {
 		dprint(FD_IO, "%s: Warning: unhandled ddir: %d\n", __func__,
 		       io_u->ddir);
-- 
1.8.5.2 (Apple Git-48)

