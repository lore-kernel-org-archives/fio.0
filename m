Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298D62EB5A1
	for <fio@vger.kernel.org>; Fri, 22 Aug 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755864016; cv=none; b=o84Z1mXWMzyJO12/TsElff9L/0VdZuiAanhfm8gBYF/Vu9LCfnz17Qyvdb/bAVCh92OFTdeL7MACSKYrrBO2/MchStm/XOSlG7AS0obKm+bmfX77CtNVJxNkewwAyzKR+05EkQgGWqa+gGJfoKbz8mCwBr5qSqR06WIHU922loM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755864016; c=relaxed/simple;
	bh=iaxq2U/bfhx0Q14SPHRp4a4IsyDaWhdWjZ8+DP7C/hA=;
	h=Subject:From:To:Message-Id:Date; b=Hgh8ifjjcprU55MhGGbRHaqKQIQHPsP2LiStUToceZGKtHEqP9g3rJhOb20+C8lRB/udyKfFpgRBVFa5qnmFLwDkq2jUpuWxr39O4z86WOQVb1jE3KeLF5qXbhiBYY5dqkd3KniHIg2dOftOjds1trrKNemypI1UAmOnecfOJEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DsLkK5X7; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DsLkK5X7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=CI6PCJupfPmW/Eo9S310JRPZV6Pjq/5xqUAY1hZSpSk=; b=DsLkK5X7QLGvfM4CekaDr/AOd1
	CRXci1HkJ1hjvazuZSHqrn/nif1Xx4Mu7xNg6LroYv1/piaY392fvcE/s7qWJvASz/hV/Uj4V2bch
	DT04aWD/XQLpwSKgbDJV663ASfkrB/hI/LAyhsnydAYsEZy7FtVPJJX5SgFPjD6IkUZj/VJTznWBL
	eMRscF2w5ACH0bTCC+jts9p8dRABGODpwjHTinbE+Z1h8rCc1tJ8nIQ0G2GEVwOAFuFVbyjI24m7H
	DWyRZt7ua/r0Eqh6yxEv5u9VuEw0TLcRx5Q/2jAD+RruFOArvkewMfP4J254HAUGUKqycj+B3ke8o
	JG8EeMRA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1upQRH-00000000to9-026u
	for fio@vger.kernel.org;
	Fri, 22 Aug 2025 12:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 600501BC0150; Fri, 22 Aug 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250822120001.600501BC0150@kernel.dk>
Date: Fri, 22 Aug 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 4b327db09de9651a70e9a603e36c44715bf43c8b:

  engines: make engines static-correct (2025-08-20 10:25:11 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ac2aa2ca02dec925fa05cb9e9d4a1cd25e78ae84:

  Kill of IO engine cancelation support (2025-08-21 16:23:59 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/libaio: enable libaio fsync
      backend: call IO engine post-init after file creation
      Kill of IO engine cancelation support

 backend.c                   | 52 ++++++---------------------------------------
 engines/libaio.c            | 22 -------------------
 engines/posixaio.c          | 13 ------------
 engines/skeleton_external.c | 10 ---------
 engines/solarisaio.c        |  7 ------
 ioengines.h                 |  3 +--
 6 files changed, 8 insertions(+), 99 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 858506c4..c8a64d38 100644
--- a/backend.c
+++ b/backend.c
@@ -222,39 +222,6 @@ static bool check_min_rate(struct thread_data *td, struct timespec *now)
 	return ret;
 }
 
-/*
- * When job exits, we can cancel the in-flight IO if we are using async
- * io. Attempt to do so.
- */
-static void cleanup_pending_aio(struct thread_data *td)
-{
-	int r;
-
-	/*
-	 * get immediately available events, if any
-	 */
-	r = io_u_queued_complete(td, 0);
-
-	/*
-	 * now cancel remaining active events
-	 */
-	if (td->io_ops->cancel) {
-		struct io_u *io_u;
-		int i;
-
-		io_u_qiter(&td->io_u_all, io_u, i) {
-			if (io_u->flags & IO_U_F_FLIGHT) {
-				r = td->io_ops->cancel(td, io_u);
-				if (!r)
-					put_io_u(td, io_u);
-			}
-		}
-	}
-
-	if (td->cur_depth)
-		r = io_u_queued_complete(td, td->cur_depth);
-}
-
 /*
  * Helper to handle the final sync of a file. Works just like the normal
  * io path, just does everything sync.
@@ -614,8 +581,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 {
 	struct fio_file *f;
 	struct io_u *io_u;
-	int ret, min_events;
 	unsigned int i;
+	int ret;
 
 	dprint(FD_VERIFY, "starting loop\n");
 
@@ -751,13 +718,8 @@ reap:
 
 	check_update_rusage(td);
 
-	if (!td->error) {
-		min_events = td->cur_depth;
-
-		if (min_events)
-			ret = io_u_queued_complete(td, min_events);
-	} else
-		cleanup_pending_aio(td);
+	if (td->cur_depth)
+		ret = io_u_queued_complete(td, td->cur_depth);
 
 	td_set_runstate(td, TD_RUNNING);
 
@@ -1313,7 +1275,7 @@ reap:
 	} else {
 		if (td->o.io_submit_mode == IO_MODE_OFFLOAD)
 			workqueue_flush(&td->io_wq);
-		cleanup_pending_aio(td);
+		ret = io_u_queued_complete(td, td->cur_depth);
 	}
 
 	/*
@@ -1953,9 +1915,6 @@ static void *thread_main(void *data)
 	if (init_io_u(td))
 		goto err;
 
-	if (td->io_ops->post_init && td->io_ops->post_init(td))
-		goto err;
-
 	if (o->verify_async && verify_async_init(td))
 		goto err;
 
@@ -1974,6 +1933,9 @@ static void *thread_main(void *data)
 	if (!o->create_serialize && setup_files(td))
 		goto err;
 
+	if (td->io_ops->post_init && td->io_ops->post_init(td))
+		goto err;
+
 	if (!init_random_map(td))
 		goto err;
 
diff --git a/engines/libaio.c b/engines/libaio.c
index aff4025e..0c207d60 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -274,20 +274,6 @@ static enum fio_q_status fio_libaio_queue(struct thread_data *td,
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
@@ -403,13 +389,6 @@ static int fio_libaio_commit(struct thread_data *td)
 	return ret;
 }
 
-static int fio_libaio_cancel(struct thread_data *td, struct io_u *io_u)
-{
-	struct libaio_data *ld = td->io_ops_data;
-
-	return io_cancel(ld->aio_ctx, &io_u->iocb, ld->aio_events);
-}
-
 static void fio_libaio_cleanup(struct thread_data *td)
 {
 	struct libaio_data *ld = td->io_ops_data;
@@ -484,7 +463,6 @@ FIO_STATIC struct ioengine_ops ioengine = {
 	.prep			= fio_libaio_prep,
 	.queue			= fio_libaio_queue,
 	.commit			= fio_libaio_commit,
-	.cancel			= fio_libaio_cancel,
 	.getevents		= fio_libaio_getevents,
 	.event			= fio_libaio_event,
 	.cleanup		= fio_libaio_cleanup,
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 0f4eea68..2d0ac9fc 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -27,18 +27,6 @@ static unsigned long long ts_utime_since_now(const struct timespec *start)
 	return utime_since(start, &now);
 }
 
-static int fio_posixaio_cancel(struct thread_data fio_unused *td,
-			       struct io_u *io_u)
-{
-	struct fio_file *f = io_u->file;
-	int r = aio_cancel(f->fd, &io_u->aiocb);
-
-	if (r == AIO_ALLDONE || r == AIO_CANCELED)
-		return 0;
-
-	return 1;
-}
-
 static int fio_posixaio_prep(struct thread_data fio_unused *td,
 			     struct io_u *io_u)
 {
@@ -212,7 +200,6 @@ static struct ioengine_ops ioengine = {
 	.init		= fio_posixaio_init,
 	.prep		= fio_posixaio_prep,
 	.queue		= fio_posixaio_queue,
-	.cancel		= fio_posixaio_cancel,
 	.getevents	= fio_posixaio_getevents,
 	.event		= fio_posixaio_event,
 	.cleanup	= fio_posixaio_cleanup,
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index cff83a10..f2b3fce9 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -71,15 +71,6 @@ static int fio_skeleton_getevents(struct thread_data *td, unsigned int min,
 	return 0;
 }
 
-/*
- * The ->cancel() hook attempts to cancel the io_u. Only relevant for
- * async io engines, and need not be supported.
- */
-static int fio_skeleton_cancel(struct thread_data *td, struct io_u *io_u)
-{
-	return 0;
-}
-
 /*
  * The ->queue() hook is responsible for initiating io on the io_u
  * being passed in. If the io engine is a synchronous one, io may complete
@@ -214,7 +205,6 @@ struct ioengine_ops ioengine = {
 	.init		= fio_skeleton_init,
 	.prep		= fio_skeleton_prep,
 	.queue		= fio_skeleton_queue,
-	.cancel		= fio_skeleton_cancel,
 	.getevents	= fio_skeleton_getevents,
 	.event		= fio_skeleton_event,
 	.cleanup	= fio_skeleton_cleanup,
diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index b2b47fed..e179c0a1 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -19,12 +19,6 @@ struct solarisaio_data {
 	unsigned int max_depth;
 };
 
-static int fio_solarisaio_cancel(struct thread_data fio_unused *td,
-			       struct io_u *io_u)
-{
-	return aiocancel(&io_u->resultp);
-}
-
 static int fio_solarisaio_prep(struct thread_data fio_unused *td,
 			    struct io_u *io_u)
 {
@@ -213,7 +207,6 @@ static struct ioengine_ops ioengine = {
 	.init		= fio_solarisaio_init,
 	.prep		= fio_solarisaio_prep,
 	.queue		= fio_solarisaio_queue,
-	.cancel		= fio_solarisaio_cancel,
 	.getevents	= fio_solarisaio_getevents,
 	.event		= fio_solarisaio_event,
 	.cleanup	= fio_solarisaio_cleanup,
diff --git a/ioengines.h b/ioengines.h
index afafeeb9..3d220a73 100644
--- a/ioengines.h
+++ b/ioengines.h
@@ -9,7 +9,7 @@
 #include "zbd_types.h"
 #include "dataplacement.h"
 
-#define FIO_IOOPS_VERSION	38
+#define FIO_IOOPS_VERSION	39
 
 #ifndef CONFIG_DYNAMIC_ENGINES
 #define FIO_STATIC	static
@@ -41,7 +41,6 @@ struct ioengine_ops {
 	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 	struct io_u *(*event)(struct thread_data *, int);
 	char *(*errdetails)(struct thread_data *, struct io_u *);
-	int (*cancel)(struct thread_data *, struct io_u *);
 	void (*cleanup)(struct thread_data *);
 	int (*open_file)(struct thread_data *, struct fio_file *);
 	int (*close_file)(struct thread_data *, struct fio_file *);
