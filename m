Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaE3MAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 May 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WqLTh-0003UN-3u
	for fio@vger.kernel.org; Fri, 30 May 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140530120003.A865D400B9@lyth.info>
Date: Fri, 30 May 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d9b100fc117a963334fb71b8b662be90cd456068:

  Add ->invalidate() IO engine ops (2014-05-19 19:57:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 82340a9fb6da0c4cc6a213bfc575c69bfa702712:

  Make rbd engine use aio flush (2014-05-29 14:14:27 -0600)

----------------------------------------------------------------
Haomai Wang (1):
      Make rbd engine use aio flush

Rik Faith (1):
      ETA no longer works when -o specified

 engines/rbd.c |   30 ++++++++++++++++++++++++++++--
 init.c        |    2 +-
 2 files changed, 29 insertions(+), 3 deletions(-)

---

Diff of recent changes:

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
diff --git a/init.c b/init.c
index 4c5a8dd..a546861 100644
--- a/init.c
+++ b/init.c
@@ -1739,7 +1739,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			write_bw_log = 1;
 			break;
 		case 'o':
-			if (f_out)
+			if (f_out && f_out != stdout)
 				fclose(f_out);
 
 			f_out = fopen(optarg, "w+");
