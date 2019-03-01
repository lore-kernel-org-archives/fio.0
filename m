Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfCANAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Mar 2019 08:00:16 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gzhlv-0004Os-My
        for fio@vger.kernel.org; Fri, 01 Mar 2019 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190301130001.BE42D2C008C@kernel.dk>
Date: Fri,  1 Mar 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 66a8a1bf98d714e013ee329dc975f3b6b552de6d:

  engines/sg: kill dead function (2019-02-24 08:13:39 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7508b3948a216106196cec33a3a707d6f32d84a8:

  engines/sg: ensure we flag EIO on the right io_u (2019-02-28 10:08:08 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      engines/sg: ensure we complete the right command for sync IO
      engines/sg: ensure we flag EIO on the right io_u

 engines/sg.c | 43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/engines/sg.c b/engines/sg.c
index bf437c8d..c46b9aba 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -424,7 +424,8 @@ static enum fio_q_status fio_sgio_ioctl_doio(struct thread_data *td,
 	return FIO_Q_COMPLETED;
 }
 
-static enum fio_q_status fio_sgio_rw_doio(struct fio_file *f,
+static enum fio_q_status fio_sgio_rw_doio(struct thread_data *td,
+					  struct fio_file *f,
 					  struct io_u *io_u, int do_sync)
 {
 	struct sg_io_hdr *hdr = &io_u->hdr;
@@ -435,13 +436,32 @@ static enum fio_q_status fio_sgio_rw_doio(struct fio_file *f,
 		return ret;
 
 	if (do_sync) {
-		ret = read(f->fd, hdr, sizeof(*hdr));
-		if (ret < 0)
-			return ret;
+		/*
+		 * We can't just read back the first command that completes
+		 * and assume it's the one we need, it could be any command
+		 * that is inflight.
+		 */
+		do {
+			struct io_u *__io_u;
 
-		/* record if an io error occurred */
-		if (hdr->info & SG_INFO_CHECK)
-			io_u->error = EIO;
+			ret = read(f->fd, hdr, sizeof(*hdr));
+			if (ret < 0)
+				return ret;
+
+			__io_u = hdr->usr_ptr;
+
+			/* record if an io error occurred */
+			if (hdr->info & SG_INFO_CHECK)
+				__io_u->error = EIO;
+
+			if (__io_u == io_u)
+				break;
+
+			if (io_u_sync_complete(td, __io_u)) {
+				ret = -1;
+				break;
+			}
+		} while (1);
 
 		return FIO_Q_COMPLETED;
 	}
@@ -457,10 +477,11 @@ static enum fio_q_status fio_sgio_doio(struct thread_data *td,
 
 	if (f->filetype == FIO_TYPE_BLOCK) {
 		ret = fio_sgio_ioctl_doio(td, f, io_u);
-		td_verror(td, io_u->error, __func__);
+		if (io_u->error)
+			td_verror(td, io_u->error, __func__);
 	} else {
-		ret = fio_sgio_rw_doio(f, io_u, do_sync);
-		if (do_sync)
+		ret = fio_sgio_rw_doio(td, f, io_u, do_sync);
+		if (io_u->error && do_sync)
 			td_verror(td, io_u->error, __func__);
 	}
 
@@ -678,7 +699,7 @@ static int fio_sgio_commit(struct thread_data *td)
 
 	sd->current_queue = -1;
 
-	ret = fio_sgio_rw_doio(io_u->file, io_u, 0);
+	ret = fio_sgio_rw_doio(td, io_u->file, io_u, 0);
 
 	if (ret < 0 || hdr->status) {
 		int error;

