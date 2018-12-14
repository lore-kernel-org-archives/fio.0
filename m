Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58896 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbeLNNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Dec 2018 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXn4W-0006Mu-IV
        for fio@vger.kernel.org; Fri, 14 Dec 2018 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181214130002.438CD2C0053@kernel.dk>
Date: Fri, 14 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 702906e9e3e03e9836421d5e5b5eaae3cd99d398:

  engines/libaio: remove features deprecated from old interface (2018-12-12 22:02:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 771c99012e26af0dc2a0b7e0762e5097534144bd:

  engines/aioring: enable IOCTX_FLAG_SQPOLL (2018-12-13 13:52:35 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      engines/aioring: various updates and fixes
      io_u: ensure buflen is capped at maxbs
      engines/aioring: enable IOCTX_FLAG_SQPOLL

 engines/aioring.c | 157 +++++++++++++++++++++++++++++++++---------------------
 io_u.c            |   6 ++-
 2 files changed, 100 insertions(+), 63 deletions(-)

---

Diff of recent changes:

diff --git a/engines/aioring.c b/engines/aioring.c
index 1598cc12..cb13b415 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -1,7 +1,9 @@
 /*
  * aioring engine
  *
- * IO engine using the new native Linux libaio ring interface
+ * IO engine using the new native Linux libaio ring interface. See:
+ *
+ * http://git.kernel.dk/cgit/linux-block/log/?h=aio-poll
  *
  */
 #include <stdlib.h>
@@ -40,6 +42,10 @@
 #ifndef IOCTX_FLAG_SQWQ
 #define IOCTX_FLAG_SQWQ		(1 << 4)
 #endif
+#ifndef IOCTX_FLAG_SQPOLL
+#define IOCTX_FLAG_SQPOLL	(1 << 5)
+#endif
+
 
 /*
  * io_ring_enter(2) flags
@@ -100,8 +106,22 @@ struct aioring_options {
 	void *pad;
 	unsigned int hipri;
 	unsigned int fixedbufs;
+	unsigned int sqthread;
+	unsigned int sqthread_set;
+	unsigned int sqthread_poll;
+	unsigned int sqwq;
 };
 
+static int fio_aioring_sqthread_cb(void *data,
+				   unsigned long long *val)
+{
+	struct aioring_options *o = data;
+
+	o->sqthread = *val;
+	o->sqthread_set = 1;
+	return 0;
+}
+
 static struct fio_option options[] = {
 	{
 		.name	= "hipri",
@@ -121,22 +141,43 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	= FIO_OPT_G_LIBAIO,
 	},
+	{
+		.name	= "sqthread",
+		.lname	= "Use kernel SQ thread on this CPU",
+		.type	= FIO_OPT_INT,
+		.cb	= fio_aioring_sqthread_cb,
+		.help	= "Offload submission to kernel thread",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= "sqthread_poll",
+		.lname	= "Kernel SQ thread should poll",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct aioring_options, sqthread_poll),
+		.help	= "Used with sqthread, enables kernel side polling",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
+	{
+		.name	= "sqwq",
+		.lname	= "Offload submission to kernel workqueue",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct aioring_options, sqwq),
+		.help	= "Offload submission to kernel workqueue",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_LIBAIO,
+	},
 	{
 		.name	= NULL,
 	},
 };
 
-static int fio_aioring_commit(struct thread_data *td);
-
 static int io_ring_enter(io_context_t ctx, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
-#ifdef __NR_sys_io_ring_enter
 	return syscall(__NR_sys_io_ring_enter, ctx, to_submit, min_complete,
 			flags);
-#else
-	return -1;
-#endif
 }
 
 static int fio_aioring_prep(struct thread_data *td, struct io_u *io_u)
@@ -228,6 +269,7 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 {
 	struct aioring_data *ld = td->io_ops_data;
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
+	struct aioring_options *o = td->eo;
 	struct aio_cq_ring *ring = ld->cq_ring;
 	int r, events = 0;
 
@@ -239,13 +281,15 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 			continue;
 		}
 
-		r = io_ring_enter(ld->aio_ctx, 0, actual_min,
-					IORING_FLAG_GETEVENTS);
-		if (r < 0) {
-			if (errno == EAGAIN)
-				continue;
-			perror("ring enter");
-			break;
+		if (!o->sqthread_poll) {
+			r = io_ring_enter(ld->aio_ctx, 0, actual_min,
+						IORING_FLAG_GETEVENTS);
+			if (r < 0) {
+				if (errno == EAGAIN)
+					continue;
+				td_verror(td, errno, "io_ring_enter get");
+				break;
+			}
 		}
 	} while (events < min);
 
@@ -264,20 +308,6 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
-	/*
-	 * fsync is tricky, since it can fail and we need to do it
-	 * serialized with other io. the reason is that linux doesn't
-	 * support aio fsync yet. So return busy for the case where we
-	 * have pending io, to let fio complete those first.
-	 */
-	if (ddir_sync(io_u->ddir)) {
-		if (ld->queued)
-			return FIO_Q_BUSY;
-
-		do_io_u_sync(td, io_u);
-		return FIO_Q_COMPLETED;
-	}
-
 	if (io_u->ddir == DDIR_TRIM) {
 		if (ld->queued)
 			return FIO_Q_BUSY;
@@ -330,55 +360,45 @@ static void fio_aioring_queued(struct thread_data *td, int start, int nr)
 static int fio_aioring_commit(struct thread_data *td)
 {
 	struct aioring_data *ld = td->io_ops_data;
+	struct aioring_options *o = td->eo;
 	int ret;
 
 	if (!ld->queued)
 		return 0;
 
+	/* Nothing to do */
+	if (o->sqthread_poll) {
+		ld->queued = 0;
+		return 0;
+	}
+
 	do {
 		int start = ld->sq_ring->head;
 		long nr = ld->queued;
 
 		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_SUBMIT |
 						IORING_FLAG_GETEVENTS);
-		if (ret == -1)
-			perror("io_ring_enter");
 		if (ret > 0) {
 			fio_aioring_queued(td, start, ret);
 			io_u_mark_submit(td, ret);
 
 			ld->queued -= ret;
 			ret = 0;
-		} else if (ret == -EINTR || !ret) {
-			if (!ret)
-				io_u_mark_submit(td, ret);
+		} else if (!ret) {
+			io_u_mark_submit(td, ret);
 			continue;
-		} else if (ret == -EAGAIN) {
-			/*
-			 * If we get EAGAIN, we should break out without
-			 * error and let the upper layer reap some
-			 * events for us. If we have no queued IO, we
-			 * must loop here. If we loop for more than 30s,
-			 * just error out, something must be buggy in the
-			 * IO path.
-			 */
-			if (ld->queued) {
-				ret = 0;
-				break;
+		} else {
+			if (errno == EAGAIN) {
+				ret = fio_aioring_cqring_reap(td, 0, ld->queued);
+				if (ret)
+					continue;
+				/* Shouldn't happen */
+				usleep(1);
+				continue;
 			}
-			usleep(1);
-			continue;
-		} else if (ret == -ENOMEM) {
-			/*
-			 * If we get -ENOMEM, reap events if we can. If
-			 * we cannot, treat it as a fatal event since there's
-			 * nothing we can do about it.
-			 */
-			if (ld->queued)
-				ret = 0;
-			break;
-		} else
+			td_verror(td, errno, "io_ring_enter sumit");
 			break;
+		}
 	} while (ld->queued);
 
 	return ret;
@@ -404,6 +424,9 @@ static void fio_aioring_cleanup(struct thread_data *td)
 	struct aioring_data *ld = td->io_ops_data;
 
 	if (ld) {
+		/* Bump depth to match init depth */
+		td->o.iodepth++;
+
 		/*
 		 * Work-around to avoid huge RCU stalls at exit time. If we
 		 * don't do this here, then it'll be torn down by exit_aio().
@@ -423,7 +446,6 @@ static void fio_aioring_cleanup(struct thread_data *td)
 
 static int fio_aioring_queue_init(struct thread_data *td)
 {
-#ifdef __NR_sys_io_setup2
 	struct aioring_data *ld = td->io_ops_data;
 	struct aioring_options *o = td->eo;
 	int flags = IOCTX_FLAG_SCQRING;
@@ -431,6 +453,14 @@ static int fio_aioring_queue_init(struct thread_data *td)
 
 	if (o->hipri)
 		flags |= IOCTX_FLAG_IOPOLL;
+	if (o->sqthread_set) {
+		ld->sq_ring->sq_thread_cpu = o->sqthread;
+		flags |= IOCTX_FLAG_SQTHREAD;
+		if (o->sqthread_poll)
+			flags |= IOCTX_FLAG_SQPOLL;
+	} else if (o->sqwq)
+		flags |= IOCTX_FLAG_SQWQ;
+
 	if (o->fixedbufs) {
 		struct rlimit rlim = {
 			.rlim_cur = RLIM_INFINITY,
@@ -443,9 +473,6 @@ static int fio_aioring_queue_init(struct thread_data *td)
 
 	return syscall(__NR_sys_io_setup2, depth, flags,
 			ld->sq_ring, ld->cq_ring, &ld->aio_ctx);
-#else
-	return -1;
-#endif
 }
 
 static int fio_aioring_post_init(struct thread_data *td)
@@ -476,13 +503,21 @@ static int fio_aioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
+	/* Adjust depth back again */
+	td->o.iodepth--;
 	return 0;
 }
 
 static int fio_aioring_init(struct thread_data *td)
 {
+	struct aioring_options *o = td->eo;
 	struct aioring_data *ld;
 
+	if (o->sqthread_set && o->sqwq) {
+		log_err("fio: aioring sqthread and sqwq are mutually exclusive\n");
+		return 1;
+	}
+
 	/* ring needs an extra entry, add one to achieve QD set */
 	td->o.iodepth++;
 
diff --git a/io_u.c b/io_u.c
index 1604ff84..bee99c37 100644
--- a/io_u.c
+++ b/io_u.c
@@ -570,8 +570,10 @@ static unsigned long long get_next_buflen(struct thread_data *td, struct io_u *i
 		power_2 = is_power_of_2(minbs);
 		if (!td->o.bs_unaligned && power_2)
 			buflen &= ~(minbs - 1);
-		else if (!td->o.bs_unaligned && !power_2) 
-			buflen -= buflen % minbs; 
+		else if (!td->o.bs_unaligned && !power_2)
+			buflen -= buflen % minbs;
+		if (buflen > maxbs)
+			buflen = maxbs;
 	} while (!io_u_fits(td, io_u, buflen));
 
 	return buflen;

