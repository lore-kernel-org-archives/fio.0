Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45380 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeKPXMe (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Nov 2018 18:12:34 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gNdjL-0000Da-9F
        for fio@vger.kernel.org; Fri, 16 Nov 2018 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181116130002.5800B2C01D6@kernel.dk>
Date: Fri, 16 Nov 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 46ff70e8795e91acb2ffc041e6c1fdb4e157dff4:

  verify: add requested block information to failure trace (2018-11-06 21:30:32 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ee636f3fc5ddb9488c40aa2c6dd4168732e5b095:

  libaio: switch to newer libaio polled IO API (2018-11-15 20:31:35 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      workqueue: fix misleading comment
      workqueue: ensure we see deferred error for IOs
      backend: silence "No I/O performed by..." if jobs ends in error
      io_u: fall through to unlock path in case of error
      libaio: switch to newer libaio polled IO API

 backend.c        |  7 +++++--
 engines/libaio.c | 11 ++++++-----
 io_u.c           | 14 +++++++++-----
 rate-submit.c    | 11 +++++++++--
 workqueue.c      |  2 +-
 5 files changed, 30 insertions(+), 15 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index d6450ba..a92ec45 100644
--- a/backend.c
+++ b/backend.c
@@ -237,6 +237,9 @@ static void cleanup_pending_aio(struct thread_data *td)
 {
 	int r;
 
+	if (td->error)
+		return;
+
 	/*
 	 * get immediately available events, if any
 	 */
@@ -1866,8 +1869,8 @@ static void *thread_main(void *data)
 	 * then something went wrong unless FIO_NOIO or FIO_DISKLESSIO.
 	 * (Are we not missing other flags that can be ignored ?)
 	 */
-	if ((td->o.size || td->o.io_size) && !ddir_rw_sum(bytes_done) &&
-	    !did_some_io && !td->o.create_only &&
+	if (!td->error && (td->o.size || td->o.io_size) &&
+	    !ddir_rw_sum(bytes_done) && !did_some_io && !td->o.create_only &&
 	    !(td_ioengine_flagged(td, FIO_NOIO) ||
 	      td_ioengine_flagged(td, FIO_DISKLESSIO)))
 		log_err("%s: No I/O performed by %s, "
diff --git a/engines/libaio.c b/engines/libaio.c
index b241ed9..dc66462 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -13,8 +13,9 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 
-#define IOCB_CMD_PREAD_POLL 9
-#define IOCB_CMD_PWRITE_POLL 10
+#ifndef IOCB_FLAG_HIPRI
+#define IOCB_FLAG_HIPRI	(1 << 2)
+#endif
 
 static int fio_libaio_commit(struct thread_data *td);
 
@@ -57,7 +58,7 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "hipri",
-		.lname	= "RWF_HIPRI",
+		.lname	= "High Priority",
 		.type	= FIO_OPT_STR_SET,
 		.off1	= offsetof(struct libaio_options, hipri),
 		.help	= "Use polled IO completions",
@@ -86,11 +87,11 @@ static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 	if (io_u->ddir == DDIR_READ) {
 		io_prep_pread(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->hipri)
-			io_u->iocb.aio_lio_opcode = IOCB_CMD_PREAD_POLL;
+			io_u->iocb.u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (io_u->ddir == DDIR_WRITE) {
 		io_prep_pwrite(&io_u->iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
 		if (o->hipri)
-			io_u->iocb.aio_lio_opcode = IOCB_CMD_PWRITE_POLL;
+			io_u->iocb.u.c.flags |= IOCB_FLAG_HIPRI;
 	} else if (ddir_sync(io_u->ddir))
 		io_prep_fsync(&io_u->iocb, f->fd);
 
diff --git a/io_u.c b/io_u.c
index 56abe6f..1604ff8 100644
--- a/io_u.c
+++ b/io_u.c
@@ -604,7 +604,7 @@ static inline enum fio_ddir get_rand_ddir(struct thread_data *td)
 
 int io_u_quiesce(struct thread_data *td)
 {
-	int completed = 0;
+	int ret = 0, completed = 0;
 
 	/*
 	 * We are going to sleep, ensure that we flush anything pending as
@@ -619,17 +619,20 @@ int io_u_quiesce(struct thread_data *td)
 		td_io_commit(td);
 
 	while (td->io_u_in_flight) {
-		int ret;
-
 		ret = io_u_queued_complete(td, 1);
 		if (ret > 0)
 			completed += ret;
+		else if (ret < 0)
+			break;
 	}
 
 	if (td->flags & TD_F_REGROW_LOGS)
 		regrow_logs(td);
 
-	return completed;
+	if (completed)
+		return completed;
+
+	return ret;
 }
 
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
@@ -1556,7 +1559,8 @@ again:
 		assert(!(td->flags & TD_F_CHILD));
 		ret = pthread_cond_wait(&td->free_cond, &td->io_u_lock);
 		assert(ret == 0);
-		goto again;
+		if (!td->error)
+			goto again;
 	}
 
 	if (needs_lock)
diff --git a/rate-submit.c b/rate-submit.c
index e5c6204..b07a207 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -53,7 +53,7 @@ static int io_workqueue_fn(struct submit_worker *sw,
 	struct io_u *io_u = container_of(work, struct io_u, work);
 	const enum fio_ddir ddir = io_u->ddir;
 	struct thread_data *td = sw->priv;
-	int ret;
+	int ret, error;
 
 	if (td->o.serialize_overlap)
 		check_overlap(io_u);
@@ -71,12 +71,14 @@ static int io_workqueue_fn(struct submit_worker *sw,
 		ret = io_u_queued_complete(td, 1);
 		if (ret > 0)
 			td->cur_depth -= ret;
+		else if (ret < 0)
+			break;
 		io_u_clear(td, io_u, IO_U_F_FLIGHT);
 	} while (1);
 
 	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
 
-	io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
+	error = io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
 
 	if (ret == FIO_Q_COMPLETED)
 		td->cur_depth--;
@@ -93,6 +95,9 @@ static int io_workqueue_fn(struct submit_worker *sw,
 			td->cur_depth -= ret;
 	}
 
+	if (error || td->error)
+		pthread_cond_signal(&td->parent->free_cond);
+
 	return 0;
 }
 
@@ -100,6 +105,8 @@ static bool io_workqueue_pre_sleep_flush_fn(struct submit_worker *sw)
 {
 	struct thread_data *td = sw->priv;
 
+	if (td->error)
+		return false;
 	if (td->io_u_queued || td->cur_depth || td->io_u_in_flight)
 		return true;
 
diff --git a/workqueue.c b/workqueue.c
index 841dbb9..faed245 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -97,7 +97,7 @@ void workqueue_flush(struct workqueue *wq)
 }
 
 /*
- * Must be serialized by caller. Returns true for queued, false for busy.
+ * Must be serialized by caller.
  */
 void workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work)
 {

