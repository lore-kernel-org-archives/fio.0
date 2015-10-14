Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53652 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbbJNMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Oct 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZmKiz-00027r-0e
	for fio@vger.kernel.org; Wed, 14 Oct 2015 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151014120002.6F9AA2C0A2E@kernel.dk>
Date: Wed, 14 Oct 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 36a6ac702ab9f8321bd0d6e298348f4c65eb01ae:

  Fix Windows build by using lib/strcasestr.{c,h} (2015-10-08 12:58:06 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 20cf5aab85ddfa8f58a1638925ccdfe4d57f3f69:

  engines/rbd: potential re-use of active fio_rbd_iou (2015-10-13 15:40:47 -0400)

----------------------------------------------------------------
Jason Dillaman (1):
      engines/rbd: potential re-use of active fio_rbd_iou

 engines/rbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 3688577..2be9b55 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -185,14 +185,14 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 	 * a specific error. So we have to assume that it can't do
 	 * partial completions.
 	 */
-	fri->io_complete = 1;
-	
 	ret = rbd_aio_get_return_value(fri->completion);
 	if (ret < 0) {
 		io_u->error = ret;
 		io_u->resid = io_u->xfer_buflen;
 	} else
 		io_u->error = 0;
+
+	fri->io_complete = 1;
 }
 
 static struct io_u *fio_rbd_event(struct thread_data *td, int event)
