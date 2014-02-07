Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47994 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaBGNAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 7 Feb 2014 08:00:04 -0500
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WBl2J-0000Mz-KS
	for fio@vger.kernel.org; Fri, 07 Feb 2014 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140207130003.0EC9C458D2@strynoevaenget.dk>
Date: Fri,  7 Feb 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 78a6469cfc9094763320e61c60f9aaef0ece9689:

  More precise fix for verify_backlog verification failure (2014-02-05 13:15:22 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f940128526dbe468a1951cce10c2fe5dbd23875f:

  verify: always log IO in the order they are issued (2014-02-06 12:17:37 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      verify: always log IO in the order they are issued

 backend.c  |    8 ++++----
 io_u.c     |   21 ++++++++++-----------
 ioengine.h |    4 +++-
 iolog.c    |    3 +++
 iolog.h    |    1 +
 verify.c   |   17 +++++++++++++++++
 6 files changed, 38 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 62fa17c..501c59a 100644
--- a/backend.c
+++ b/backend.c
@@ -725,14 +725,14 @@ static uint64_t do_io(struct thread_data *td)
 			td_set_runstate(td, TD_RUNNING);
 
 		/*
-		 * Verify_backlog disabled: We need to log rand seed before the
-		 * actual IO to be able to replay it correctly in the verify phase.
+		 * Always log IO before it's issued, so we know the specific
+		 * order of it. The logged unit will track when the IO has
+		 * completed.
 		 */
 		if (td_write(td) && io_u->ddir == DDIR_WRITE &&
 		    td->o.do_verify &&
 		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify &&
-		    !(td->flags & TD_F_VER_BACKLOG))
+		    !td->o.experimental_verify)
 			log_io_piece(td, io_u);
 
 		ret = td_io_queue(td, io_u);
diff --git a/io_u.c b/io_u.c
index 4264cd5..64ff73c 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1285,6 +1285,7 @@ again:
 		io_u->acct_ddir = -1;
 		td->cur_depth++;
 		io_u->flags |= IO_U_F_IN_CUR_DEPTH;
+		io_u->ipo = NULL;
 	} else if (td->o.verify_async) {
 		/*
 		 * We ran out, wait for async verify threads to finish and
@@ -1568,6 +1569,15 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	td_io_u_lock(td);
 	assert(io_u->flags & IO_U_F_FLIGHT);
 	io_u->flags &= ~(IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
+
+	/*
+	 * Mark IO ok to verify
+	 */
+	if (io_u->ipo) {
+		io_u->ipo->flags &= ~IP_F_IN_FLIGHT;
+		write_barrier();
+	}
+
 	td_io_u_unlock(td);
 
 	if (ddir_sync(io_u->ddir)) {
@@ -1623,17 +1633,6 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 					 utime_since_now(&td->start));
 		}
 
-		/*
-		 * Verify_backlog enable: We need to log the write job after
-		 * finishing it to prevent verifying before finish writing.
-		 */
-		if (td_write(td) && idx == DDIR_WRITE &&
-		    td->o.do_verify &&
-		    td->o.verify != VERIFY_NONE &&
-		    !td->o.experimental_verify &&
-		    (td->flags & TD_F_VER_BACKLOG))
-			log_io_piece(td, io_u);
-
 		icd->bytes_done[idx] += bytes;
 
 		if (io_u->end_io) {
diff --git a/ioengine.h b/ioengine.h
index 0756bc7..19ed10b 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	16
+#define FIO_IOOPS_VERSION	17
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -71,6 +71,8 @@ struct io_u {
 	 */
 	unsigned long buf_filled_len;
 
+	struct io_piece *ipo;
+
 	union {
 #ifdef CONFIG_LIBAIO
 		struct iocb iocb;
diff --git a/iolog.c b/iolog.c
index 017b235..5fd9416 100644
--- a/iolog.c
+++ b/iolog.c
@@ -189,6 +189,9 @@ void log_io_piece(struct thread_data *td, struct io_u *io_u)
 	ipo->offset = io_u->offset;
 	ipo->len = io_u->buflen;
 	ipo->numberio = io_u->numberio;
+	ipo->flags = IP_F_IN_FLIGHT;
+
+	io_u->ipo = ipo;
 
 	if (io_u_should_trim(td, io_u)) {
 		flist_add_tail(&ipo->trim_list, &td->trim_list);
diff --git a/iolog.h b/iolog.h
index 321576d..3ec48f2 100644
--- a/iolog.h
+++ b/iolog.h
@@ -67,6 +67,7 @@ enum {
 	IP_F_ONRB	= 1,
 	IP_F_ONLIST	= 2,
 	IP_F_TRIMMED	= 4,
+	IP_F_IN_FLIGHT	= 8,
 };
 
 /*
diff --git a/verify.c b/verify.c
index 90cd093..9373122 100644
--- a/verify.c
+++ b/verify.c
@@ -1022,11 +1022,27 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		struct rb_node *n = rb_first(&td->io_hist_tree);
 
 		ipo = rb_entry(n, struct io_piece, rb_node);
+
+		/*
+		 * Ensure that the associated IO has completed
+		 */
+		read_barrier();
+		if (ipo->flags & IP_F_IN_FLIGHT)
+			goto nothing;
+
 		rb_erase(n, &td->io_hist_tree);
 		assert(ipo->flags & IP_F_ONRB);
 		ipo->flags &= ~IP_F_ONRB;
 	} else if (!flist_empty(&td->io_hist_list)) {
 		ipo = flist_entry(td->io_hist_list.next, struct io_piece, list);
+
+		/*
+		 * Ensure that the associated IO has completed
+		 */
+		read_barrier();
+		if (ipo->flags & IP_F_IN_FLIGHT)
+			goto nothing;
+
 		flist_del(&ipo->list);
 		assert(ipo->flags & IP_F_ONLIST);
 		ipo->flags &= ~IP_F_ONLIST;
@@ -1072,6 +1088,7 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		return 0;
 	}
 
+nothing:
 	dprint(FD_VERIFY, "get_next_verify: empty\n");
 	return 1;
 }
