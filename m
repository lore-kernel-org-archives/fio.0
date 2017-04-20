Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:34760 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944516AbdDTMAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Apr 2017 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1d1Akl-0005H8-3I
        for fio@vger.kernel.org; Thu, 20 Apr 2017 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170420120002.3D5BD2C0098@kernel.dk>
Date: Thu, 20 Apr 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b94d4d75a2e474561dcda8ee852cd5e67dde884e:

  Merge branch 'pull-2' of https://github.com/dmonakhov/fio (2017-04-10 11:41:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d7658cedd1f31d1285f1f1e1cfe42fabb7cd6c8f:

  Return non-negtive error in order to print right error msg (2017-04-19 20:34:19 +0800)

----------------------------------------------------------------
mychoxin (1):
      Return non-negtive error in order to print right error msg

 engines/rbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 829e41a..7433879 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -290,7 +290,7 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 	 */
 	ret = rbd_aio_get_return_value(fri->completion);
 	if (ret < 0) {
-		io_u->error = ret;
+		io_u->error = -ret;
 		io_u->resid = io_u->xfer_buflen;
 	} else
 		io_u->error = 0;
@@ -524,7 +524,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 failed_comp:
 	rbd_aio_release(fri->completion);
 failed:
-	io_u->error = r;
+	io_u->error = -r;
 	td_verror(td, io_u->error, "xfer");
 	return FIO_Q_COMPLETED;
 }
