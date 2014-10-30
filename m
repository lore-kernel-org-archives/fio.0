Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbaJ3MAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 30 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XjoOb-0008Te-9C
	for fio@vger.kernel.org; Thu, 30 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141030120003.DF4F440162@lyth.info>
Date: Thu, 30 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8859391bb7d77680ede51b46e770237abae566dc:

  engines/glusterfs_async: cleanups (2014-10-28 20:48:33 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a1f871c72971efe84cd42670d5df4c4dc56dbd3f:

  engines: rename option specific pad from 'td' to 'pad' (2014-10-29 08:30:07 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      engines/glusterfs_async: remove no-op prep function
      Merge branch 'fix-rbd-options-parse' of https://github.com/ketor/fio
      Merge branch 'optimize-busy-poll' of https://github.com/ketor/fio
      engines/rbd: sort IO by start time before waiting on it
      engines: rename option specific pad from 'td' to 'pad'

Ketor Meng (2):
      fix rbd_option parse error
      use io_complete var to avoid the rbd_aio_is_complete lock and context switch

 engines/cpu.c             |    2 +-
 engines/e4defrag.c        |    2 +-
 engines/gfapi.h           |    2 +-
 engines/glusterfs_async.c |   11 ---
 engines/libaio.c          |    2 +-
 engines/rbd.c             |  212 ++++++++++++++++++++++++++++-----------------
 6 files changed, 138 insertions(+), 93 deletions(-)

---

Diff of recent changes:

diff --git a/engines/cpu.c b/engines/cpu.c
index 85598ef..7e4d737 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -8,7 +8,7 @@
 #include "../fio.h"
 
 struct cpu_options {
-	struct thread_data *td;
+	void *pad;
 	unsigned int cpuload;
 	unsigned int cpucycle;
 	unsigned int exit_io_done;
diff --git a/engines/e4defrag.c b/engines/e4defrag.c
index 3599ab8..6854070 100644
--- a/engines/e4defrag.c
+++ b/engines/e4defrag.c
@@ -36,7 +36,7 @@ struct e4defrag_data {
 };
 
 struct e4defrag_options {
-	struct thread_data *td;
+	void *pad;
 	unsigned int inplace;
 	char * donor_name;
 };
diff --git a/engines/gfapi.h b/engines/gfapi.h
index 0da471c..1028431 100644
--- a/engines/gfapi.h
+++ b/engines/gfapi.h
@@ -2,7 +2,7 @@
 #include "../fio.h"
 
 struct gf_options {
-	struct thread_data *td;
+	void *pad;
 	char *gf_vol;
 	char *gf_brick;
 };
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index d9d6693..95ca84e 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -159,22 +159,11 @@ int fio_gf_async_setup(struct thread_data *td)
 	return r;
 }
 
-static int fio_gf_async_prep(struct thread_data *td, struct io_u *io_u)
-{
-	dprint(FD_FILE, "%s\n", __FUNCTION__);
-
-	if (!ddir_rw(io_u->ddir))
-		return 0;
-
-	return 0;
-}
-
 static struct ioengine_ops ioengine = {
 	.name = "gfapi_async",
 	.version = FIO_IOOPS_VERSION,
 	.init = fio_gf_async_setup,
 	.cleanup = fio_gf_cleanup,
-	.prep = fio_gf_async_prep,
 	.queue = fio_gf_async_queue,
 	.open_file = fio_gf_open_file,
 	.close_file = fio_gf_close_file,
diff --git a/engines/libaio.c b/engines/libaio.c
index f7e2f89..d4f4830 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -37,7 +37,7 @@ struct libaio_data {
 };
 
 struct libaio_options {
-	struct thread_data *td;
+	void *pad;
 	unsigned int userspace_reap;
 };
 
diff --git a/engines/rbd.c b/engines/rbd.c
index cf7be0a..3688577 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -13,6 +13,7 @@ struct fio_rbd_iou {
 	struct io_u *io_u;
 	rbd_completion_t completion;
 	int io_seen;
+	int io_complete;
 };
 
 struct rbd_data {
@@ -20,9 +21,11 @@ struct rbd_data {
 	rados_ioctx_t io_ctx;
 	rbd_image_t image;
 	struct io_u **aio_events;
+	struct io_u **sort_events;
 };
 
 struct rbd_options {
+	void *pad;
 	char *rbd_name;
 	char *pool_name;
 	char *client_name;
@@ -62,7 +65,7 @@ static struct fio_option options[] = {
 		.lname		= "Busy poll",
 		.type		= FIO_OPT_BOOL,
 		.help		= "Busy poll for completions instead of sleeping",
-		.off1		= offsetof(struct rbd_options, client_name),
+		.off1		= offsetof(struct rbd_options, busy_poll),
 		.def		= "0",
 		.category	= FIO_OPT_C_ENGINE,
 		.group		= FIO_OPT_G_RBD,
@@ -75,67 +78,64 @@ static struct fio_option options[] = {
 static int _fio_setup_rbd_data(struct thread_data *td,
 			       struct rbd_data **rbd_data_ptr)
 {
-	struct rbd_data *rbd_data;
+	struct rbd_data *rbd;
 
 	if (td->io_ops->data)
 		return 0;
 
-	rbd_data = malloc(sizeof(struct rbd_data));
-	if (!rbd_data)
+	rbd = calloc(1, sizeof(struct rbd_data));
+	if (!rbd)
 		goto failed;
 
-	memset(rbd_data, 0, sizeof(struct rbd_data));
-
-	rbd_data->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
-	if (!rbd_data->aio_events)
+	rbd->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!rbd->aio_events)
 		goto failed;
 
-	memset(rbd_data->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
-
-	*rbd_data_ptr = rbd_data;
+	rbd->sort_events = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!rbd->sort_events)
+		goto failed;
 
+	*rbd_data_ptr = rbd;
 	return 0;
 
 failed:
-	if (rbd_data)
-		free(rbd_data);
+	if (rbd)
+		free(rbd);
 	return 1;
 
 }
 
 static int _fio_rbd_connect(struct thread_data *td)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 	struct rbd_options *o = td->eo;
 	int r;
 
-	r = rados_create(&rbd_data->cluster, o->client_name);
+	r = rados_create(&rbd->cluster, o->client_name);
 	if (r < 0) {
 		log_err("rados_create failed.\n");
 		goto failed_early;
 	}
 
-	r = rados_conf_read_file(rbd_data->cluster, NULL);
+	r = rados_conf_read_file(rbd->cluster, NULL);
 	if (r < 0) {
 		log_err("rados_conf_read_file failed.\n");
 		goto failed_early;
 	}
 
-	r = rados_connect(rbd_data->cluster);
+	r = rados_connect(rbd->cluster);
 	if (r < 0) {
 		log_err("rados_connect failed.\n");
 		goto failed_shutdown;
 	}
 
-	r = rados_ioctx_create(rbd_data->cluster, o->pool_name,
-			       &rbd_data->io_ctx);
+	r = rados_ioctx_create(rbd->cluster, o->pool_name, &rbd->io_ctx);
 	if (r < 0) {
 		log_err("rados_ioctx_create failed.\n");
 		goto failed_shutdown;
 	}
 
-	r = rbd_open(rbd_data->io_ctx, o->rbd_name, &rbd_data->image,
-		     NULL /*snap */ );
+	r = rbd_open(rbd->io_ctx, o->rbd_name, &rbd->image, NULL /*snap */ );
 	if (r < 0) {
 		log_err("rbd_open failed.\n");
 		goto failed_open;
@@ -143,34 +143,34 @@ static int _fio_rbd_connect(struct thread_data *td)
 	return 0;
 
 failed_open:
-	rados_ioctx_destroy(rbd_data->io_ctx);
-	rbd_data->io_ctx = NULL;
+	rados_ioctx_destroy(rbd->io_ctx);
+	rbd->io_ctx = NULL;
 failed_shutdown:
-	rados_shutdown(rbd_data->cluster);
-	rbd_data->cluster = NULL;
+	rados_shutdown(rbd->cluster);
+	rbd->cluster = NULL;
 failed_early:
 	return 1;
 }
 
-static void _fio_rbd_disconnect(struct rbd_data *rbd_data)
+static void _fio_rbd_disconnect(struct rbd_data *rbd)
 {
-	if (!rbd_data)
+	if (!rbd)
 		return;
 
 	/* shutdown everything */
-	if (rbd_data->image) {
-		rbd_close(rbd_data->image);
-		rbd_data->image = NULL;
+	if (rbd->image) {
+		rbd_close(rbd->image);
+		rbd->image = NULL;
 	}
 
-	if (rbd_data->io_ctx) {
-		rados_ioctx_destroy(rbd_data->io_ctx);
-		rbd_data->io_ctx = NULL;
+	if (rbd->io_ctx) {
+		rados_ioctx_destroy(rbd->io_ctx);
+		rbd->io_ctx = NULL;
 	}
 
-	if (rbd_data->cluster) {
-		rados_shutdown(rbd_data->cluster);
-		rbd_data->cluster = NULL;
+	if (rbd->cluster) {
+		rados_shutdown(rbd->cluster);
+		rbd->cluster = NULL;
 	}
 }
 
@@ -185,6 +185,8 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 	 * a specific error. So we have to assume that it can't do
 	 * partial completions.
 	 */
+	fri->io_complete = 1;
+	
 	ret = rbd_aio_get_return_value(fri->completion);
 	if (ret < 0) {
 		io_u->error = ret;
@@ -195,20 +197,19 @@ static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 
 static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 
-	return rbd_data->aio_events[event];
+	return rbd->aio_events[event];
 }
 
-static inline int fri_check_complete(struct rbd_data *rbd_data,
-				     struct io_u *io_u,
+static inline int fri_check_complete(struct rbd_data *rbd, struct io_u *io_u,
 				     unsigned int *events)
 {
 	struct fio_rbd_iou *fri = io_u->engine_data;
 
-	if (rbd_aio_is_complete(fri->completion)) {
+	if (fri->io_complete) {
 		fri->io_seen = 1;
-		rbd_data->aio_events[*events] = io_u;
+		rbd->aio_events[*events] = io_u;
 		(*events)++;
 
 		rbd_aio_release(fri->completion);
@@ -218,32 +219,88 @@ static inline int fri_check_complete(struct rbd_data *rbd_data,
 	return 0;
 }
 
+static inline int rbd_io_u_seen(struct io_u *io_u)
+{
+	struct fio_rbd_iou *fri = io_u->engine_data;
+
+	return fri->io_seen;
+}
+
+static void rbd_io_u_wait_complete(struct io_u *io_u)
+{
+	struct fio_rbd_iou *fri = io_u->engine_data;
+
+	rbd_aio_wait_for_complete(fri->completion);
+}
+
+static int rbd_io_u_cmp(const void *p1, const void *p2)
+{
+	const struct io_u **a = (const struct io_u **) p1;
+	const struct io_u **b = (const struct io_u **) p2;
+	uint64_t at, bt;
+
+	at = utime_since_now(&(*a)->start_time);
+	bt = utime_since_now(&(*b)->start_time);
+
+	if (at < bt)
+		return -1;
+	else if (at == bt)
+		return 0;
+	else
+		return 1;
+}
+
 static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 			   unsigned int min_evts, int wait)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 	unsigned int this_events = 0;
 	struct io_u *io_u;
-	int i;
+	int i, sidx;
 
+	sidx = 0;
 	io_u_qiter(&td->io_u_all, io_u, i) {
-		struct fio_rbd_iou *fri = io_u->engine_data;
-
 		if (!(io_u->flags & IO_U_F_FLIGHT))
 			continue;
-		if (fri->io_seen)
+		if (rbd_io_u_seen(io_u))
 			continue;
 
-		if (fri_check_complete(rbd_data, io_u, events))
+		if (fri_check_complete(rbd, io_u, events))
 			this_events++;
-		else if (wait) {
-			rbd_aio_wait_for_complete(fri->completion);
+		else if (wait)
+			rbd->sort_events[sidx++] = io_u;
+	}
+
+	if (!wait || !sidx)
+		return this_events;
 
-			if (fri_check_complete(rbd_data, io_u, events))
-				this_events++;
+	/*
+	 * Sort events, oldest issue first, then wait on as many as we
+	 * need in order of age. If we have enough events, stop waiting,
+	 * and just check if any of the older ones are done.
+	 */
+	if (sidx > 1)
+		qsort(rbd->sort_events, sidx, sizeof(struct io_u *), rbd_io_u_cmp);
+
+	for (i = 0; i < sidx; i++) {
+		io_u = rbd->sort_events[i];
+
+		if (fri_check_complete(rbd, io_u, events)) {
+			this_events++;
+			continue;
 		}
+
+		/*
+		 * Stop waiting when we have enough, but continue checking
+		 * all pending IOs if they are complete.
+		 */
 		if (*events >= min_evts)
-			break;
+			continue;
+
+		rbd_io_u_wait_complete(io_u);
+
+		if (fri_check_complete(rbd, io_u, events))
+			this_events++;
 	}
 
 	return this_events;
@@ -275,13 +332,14 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 	struct fio_rbd_iou *fri = io_u->engine_data;
 	int r = -1;
 
 	fio_ro_check(td, io_u);
 
 	fri->io_seen = 0;
+	fri->io_complete = 0;
 
 	r = rbd_aio_create_completion(fri, _fio_rbd_finish_aiocb,
 						&fri->completion);
@@ -291,32 +349,30 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_WRITE) {
-		r = rbd_aio_write(rbd_data->image, io_u->offset,
-				  io_u->xfer_buflen, io_u->xfer_buf,
-				  fri->completion);
+		r = rbd_aio_write(rbd->image, io_u->offset, io_u->xfer_buflen,
+					 io_u->xfer_buf, fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
 			goto failed_comp;
 		}
 
 	} else if (io_u->ddir == DDIR_READ) {
-		r = rbd_aio_read(rbd_data->image, io_u->offset,
-				 io_u->xfer_buflen, io_u->xfer_buf,
-				 fri->completion);
+		r = rbd_aio_read(rbd->image, io_u->offset, io_u->xfer_buflen,
+					io_u->xfer_buf, fri->completion);
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
 			goto failed_comp;
 		}
 	} else if (io_u->ddir == DDIR_TRIM) {
-		r = rbd_aio_discard(rbd_data->image, io_u->offset,
-				 io_u->xfer_buflen, fri->completion);
+		r = rbd_aio_discard(rbd->image, io_u->offset,
+					io_u->xfer_buflen, fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_discard failed.\n");
 			goto failed_comp;
 		}
 	} else if (io_u->ddir == DDIR_SYNC) {
-		r = rbd_aio_flush(rbd_data->image, fri->completion);
+		r = rbd_aio_flush(rbd->image, fri->completion);
 		if (r < 0) {
 			log_err("rbd_flush failed.\n");
 			goto failed_comp;
@@ -354,35 +410,35 @@ failed:
 
 static void fio_rbd_cleanup(struct thread_data *td)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 
-	if (rbd_data) {
-		_fio_rbd_disconnect(rbd_data);
-		free(rbd_data->aio_events);
-		free(rbd_data);
+	if (rbd) {
+		_fio_rbd_disconnect(rbd);
+		free(rbd->aio_events);
+		free(rbd->sort_events);
+		free(rbd);
 	}
-
 }
 
 static int fio_rbd_setup(struct thread_data *td)
 {
-	int r = 0;
 	rbd_image_info_t info;
 	struct fio_file *f;
-	struct rbd_data *rbd_data = NULL;
+	struct rbd_data *rbd = NULL;
 	int major, minor, extra;
+	int r;
 
 	/* log version of librbd. No cluster connection required. */
 	rbd_version(&major, &minor, &extra);
 	log_info("rbd engine: RBD version: %d.%d.%d\n", major, minor, extra);
 
 	/* allocate engine specific structure to deal with librbd. */
-	r = _fio_setup_rbd_data(td, &rbd_data);
+	r = _fio_setup_rbd_data(td, &rbd);
 	if (r) {
 		log_err("fio_setup_rbd_data failed.\n");
 		goto cleanup;
 	}
-	td->io_ops->data = rbd_data;
+	td->io_ops->data = rbd;
 
 	/* librbd does not allow us to run first in the main thread and later
 	 * in a fork child. It needs to be the same process context all the
@@ -401,7 +457,7 @@ static int fio_rbd_setup(struct thread_data *td)
 	}
 
 	/* get size of the RADOS block device */
-	r = rbd_stat(rbd_data->image, &info, sizeof(info));
+	r = rbd_stat(rbd->image, &info, sizeof(info));
 	if (r < 0) {
 		log_err("rbd_status failed.\n");
 		goto disconnect;
@@ -423,11 +479,11 @@ static int fio_rbd_setup(struct thread_data *td)
 	/* disconnect, then we were only connected to determine
 	 * the size of the RBD.
 	 */
-	_fio_rbd_disconnect(rbd_data);
+	_fio_rbd_disconnect(rbd);
 	return 0;
 
 disconnect:
-	_fio_rbd_disconnect(rbd_data);
+	_fio_rbd_disconnect(rbd);
 cleanup:
 	fio_rbd_cleanup(td);
 	return r;
@@ -441,9 +497,9 @@ static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 {
 #if defined(CONFIG_RBD_INVAL)
-	struct rbd_data *rbd_data = td->io_ops->data;
+	struct rbd_data *rbd = td->io_ops->data;
 
-	return rbd_invalidate_cache(rbd_data->image);
+	return rbd_invalidate_cache(rbd->image);
 #else
 	return 0;
 #endif
