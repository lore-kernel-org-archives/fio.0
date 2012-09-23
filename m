Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34816 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2IWRt6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 23 Sep 2012 13:49:58 -0400
Received: by lbbgj3 with SMTP id gj3so5802182lbb.19
        for <fio@vger.kernel.org>; Sun, 23 Sep 2012 10:49:57 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] engine: fix error handling for e4defrag/falloc
Date: Sun, 23 Sep 2012 21:49:53 +0400
Message-Id: <1348422593-4712-1-git-send-email-dmonakhov@openvz.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, Dmitry Monakhov <dmonakhov@openvz.org>

At the time I've wrote this code i don't quite understand difference
between td->error and io_u->error. It is appeared that engine should
not have to explicitly assign td->error. Just initialize io_u->error and
backed will do proper handling.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 engines/e4defrag.c |   18 ++++++------------
 engines/falloc.c   |    5 +----
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 5affaa0..cc88493 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -141,16 +141,14 @@ static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
 	 * in order to satisfy strict read only access pattern
 	 */
 	if (io_u->ddir != DDIR_WRITE) {
-		io_u->error = errno;
+		io_u->error = EINVAL;
 		return FIO_Q_COMPLETED;
 	}
 
 	if (o->inplace) {
 		ret = fallocate(ed->donor_fd, 0, io_u->offset, io_u->xfer_buflen);
-		if (ret) {
-			io_u->error = errno;
+		if (ret)
 			goto out;
-		}
 	}
 
 	memset(&me, 0, sizeof(me));
@@ -175,16 +173,12 @@ static int fio_e4defrag_queue(struct thread_data *td, struct io_u *io_u)
 	}
 	if (ret)
 		io_u->error = errno;
-	
-	if (o->inplace) {
+
+	if (o->inplace)
 		ret = ftruncate(ed->donor_fd, 0);
-		if (ret)
-			io_u->error = errno;
-	}
 out:
-	if (io_u->error)
-		td_verror(td, errno, "xfer");
-
+	if (ret && !io_u->error)
+		io_u->error = errno;
 
 	return FIO_Q_COMPLETED;
 }
diff --git a/engines/falloc.c b/engines/falloc.c
index 4977d9e..bc5ebd7 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -86,11 +86,8 @@ static int fio_fallocate_queue(struct thread_data *td, struct io_u *io_u)
 
 	ret = fallocate(f->fd, flags, io_u->offset, io_u->xfer_buflen);
 
-	if (ret) {
+	if (ret)
 		io_u->error = errno;
-		if (io_u->error)
-			td_verror(td, io_u->error, "xfer");
-	}
 
 	if (io_u->file && ret == 0 && ddir_rw(io_u->ddir))
 		io_u->file->file_pos = io_u->offset + ret;
-- 
1.7.7.6

