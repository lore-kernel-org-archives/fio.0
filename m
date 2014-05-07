Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37709 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaEGMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 7 May 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Wi0W4-0000KH-0Y
	for fio@vger.kernel.org; Wed, 07 May 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140507120002.A00E5400B9@lyth.info>
Date: Wed,  7 May 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 435228488ffd062f4eac710aaa862e04cd20dfee:

  Avoid buildenv conditional in thread_option struct (2014-05-01 11:21:56 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 890b665611751661aac1030603175bb7bbde34bc:

  verify: fix verification of uncompleted or errored ios (2014-05-06 19:06:51 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      verify: fix verification of uncompleted or errored ios

 backend.c |    6 ++++++
 io_u.c    |   11 +++++++++--
 iolog.c   |   27 +++++++++++++++++++++++++++
 iolog.h   |    2 ++
 4 files changed, 44 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 9deef28..d1d5571 100644
--- a/backend.c
+++ b/backend.c
@@ -780,16 +780,21 @@ static uint64_t do_io(struct thread_data *td)
 		case FIO_Q_COMPLETED:
 			if (io_u->error) {
 				ret = -io_u->error;
+				unlog_io_piece(td, io_u);
 				clear_io_u(td, io_u);
 			} else if (io_u->resid) {
 				int bytes = io_u->xfer_buflen - io_u->resid;
 				struct fio_file *f = io_u->file;
 
 				bytes_issued += bytes;
+
+				trim_io_piece(td, io_u);
+
 				/*
 				 * zero read, fail
 				 */
 				if (!bytes) {
+					unlog_io_piece(td, io_u);
 					td_verror(td, EIO, "full resid");
 					put_io_u(td, io_u);
 					break;
@@ -830,6 +835,7 @@ sync_done:
 			bytes_issued += io_u->xfer_buflen;
 			break;
 		case FIO_Q_BUSY:
+			unlog_io_piece(td, io_u);
 			requeue_io_u(td, &io_u);
 			ret2 = td_io_commit(td);
 			if (ret2 < 0)
diff --git a/io_u.c b/io_u.c
index 4b0b5a7..e132fd9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1622,8 +1622,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	 * Mark IO ok to verify
 	 */
 	if (io_u->ipo) {
-		io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
-		write_barrier();
+		/*
+		 * Remove errored entry from the verification list
+		 */
+		if (io_u->error)
+			unlog_io_piece(td, io_u);
+		else {
+			io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
+			write_barrier();
+		}
 	}
 
 	td_io_u_unlock(td);
diff --git a/iolog.c b/iolog.c
index f498959..cac1aba 100644
--- a/iolog.c
+++ b/iolog.c
@@ -268,6 +268,33 @@ restart:
 	td->io_hist_len++;
 }
 
+void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
+{
+	struct io_piece *ipo = io_u->ipo;
+
+	if (!ipo)
+		return;
+
+	if (ipo->flags & IP_F_ONRB)
+		rb_erase(&ipo->rb_node, &td->io_hist_tree);
+	else if (ipo->flags & IP_F_ONLIST)
+		flist_del(&ipo->list);
+
+	free(ipo);
+	io_u->ipo = NULL;
+	td->io_hist_len--;
+}
+
+void trim_io_piece(struct thread_data *td, struct io_u *io_u)
+{
+	struct io_piece *ipo = io_u->ipo;
+
+	if (!ipo)
+		return;
+
+	ipo->len = io_u->xfer_buflen - io_u->resid;
+}
+
 void write_iolog_close(struct thread_data *td)
 {
 	fflush(td->iolog_f);
diff --git a/iolog.h b/iolog.h
index 50d09e2..3af5668 100644
--- a/iolog.h
+++ b/iolog.h
@@ -110,6 +110,8 @@ extern void log_io_u(struct thread_data *, struct io_u *);
 extern void log_file(struct thread_data *, struct fio_file *, enum file_log_act);
 extern int __must_check init_iolog(struct thread_data *td);
 extern void log_io_piece(struct thread_data *, struct io_u *);
+extern void unlog_io_piece(struct thread_data *, struct io_u *);
+extern void trim_io_piece(struct thread_data *, struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
