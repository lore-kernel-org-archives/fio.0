Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:58011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaJ1MAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 28 Oct 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Xj5RV-0001wK-3l
	for fio@vger.kernel.org; Tue, 28 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141028120003.B8B21401E4@lyth.info>
Date: Tue, 28 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ec803e97e616d8a410d760368c478b683625842a:

  Loop Iteration Offset Bug (2014-10-24 14:47:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d8b64af2a1688c3c3d218cba0faad57a3ba050e8:

  rbd: various fixes and cleanups (2014-10-27 10:53:52 -0600)

----------------------------------------------------------------
Gwendal Grignou (1):
      fio: Fix padding properly

Jens Axboe (1):
      rbd: various fixes and cleanups

 engines/rbd.c |  232 ++++++++++++++++++++++++++++++---------------------------
 libfio.c      |    2 +
 stat.h        |    9 ++-
 3 files changed, 129 insertions(+), 114 deletions(-)

---

Diff of recent changes:

diff --git a/engines/rbd.c b/engines/rbd.c
index 6fe87b8..5160c32 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -11,7 +11,9 @@
 
 struct fio_rbd_iou {
 	struct io_u *io_u;
+	rbd_completion_t completion;
 	int io_complete;
+	int io_seen;
 };
 
 struct rbd_data {
@@ -30,35 +32,35 @@ struct rbd_options {
 
 static struct fio_option options[] = {
 	{
-	 .name     = "rbdname",
-	 .lname    = "rbd engine rbdname",
-	 .type     = FIO_OPT_STR_STORE,
-	 .help     = "RBD name for RBD engine",
-	 .off1     = offsetof(struct rbd_options, rbd_name),
-	 .category = FIO_OPT_C_ENGINE,
-	 .group    = FIO_OPT_G_RBD,
-	 },
+		.name		= "rbdname",
+		.lname		= "rbd engine rbdname",
+		.type		= FIO_OPT_STR_STORE,
+		.help		= "RBD name for RBD engine",
+		.off1		= offsetof(struct rbd_options, rbd_name),
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
+	},
 	{
-	 .name     = "pool",
-	 .lname    = "rbd engine pool",
-	 .type     = FIO_OPT_STR_STORE,
-	 .help     = "Name of the pool hosting the RBD for the RBD engine",
-	 .off1     = offsetof(struct rbd_options, pool_name),
-	 .category = FIO_OPT_C_ENGINE,
-	 .group    = FIO_OPT_G_RBD,
-	 },
+		.name     = "pool",
+		.lname    = "rbd engine pool",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Name of the pool hosting the RBD for the RBD engine",
+		.off1     = offsetof(struct rbd_options, pool_name),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
 	{
-	 .name     = "clientname",
-	 .lname    = "rbd engine clientname",
-	 .type     = FIO_OPT_STR_STORE,
-	 .help     = "Name of the ceph client to access the RBD for the RBD engine",
-	 .off1     = offsetof(struct rbd_options, client_name),
-	 .category = FIO_OPT_C_ENGINE,
-	 .group    = FIO_OPT_G_RBD,
-	 },
+		.name     = "clientname",
+		.lname    = "rbd engine clientname",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "Name of the ceph client to access the RBD for the RBD engine",
+		.off1     = offsetof(struct rbd_options, client_name),
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_RBD,
+	},
 	{
-	 .name = NULL,
-	 },
+		.name = NULL,
+	},
 };
 
 static int _fio_setup_rbd_data(struct thread_data *td,
@@ -163,92 +165,99 @@ static void _fio_rbd_disconnect(struct rbd_data *rbd_data)
 	}
 }
 
-static void _fio_rbd_finish_write_aiocb(rbd_completion_t comp, void *data)
+static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 {
-	struct io_u *io_u = (struct io_u *)data;
-	struct fio_rbd_iou *fio_rbd_iou =
-	    (struct fio_rbd_iou *)io_u->engine_data;
+	struct io_u *io_u = data;
+	struct fio_rbd_iou *fri = io_u->engine_data;
+	ssize_t ret;
 
-	fio_rbd_iou->io_complete = 1;
+	fri->io_complete = 1;
 
-	/* if write needs to be verified - we should not release comp here
-	   without fetching the result */
+	/*
+	 * Looks like return value is 0 for success, or < 0 for
+	 * a specific error. So we have to assume that it can't do
+	 * partial completions.
+	 */
+	ret = rbd_aio_get_return_value(fri->completion);
+	if (ret < 0) {
+		io_u->error = ret;
+		io_u->resid = io_u->xfer_buflen;
+	} else
+		io_u->error = 0;
+}
 
-	rbd_aio_release(comp);
-	/* TODO handle error */
+static struct io_u *fio_rbd_event(struct thread_data *td, int event)
+{
+	struct rbd_data *rbd_data = td->io_ops->data;
 
-	return;
+	return rbd_data->aio_events[event];
 }
 
-static void _fio_rbd_finish_read_aiocb(rbd_completion_t comp, void *data)
+static inline int fri_check_complete(struct rbd_data *rbd_data,
+				     struct io_u *io_u,
+				     unsigned int *events)
 {
-	struct io_u *io_u = (struct io_u *)data;
-	struct fio_rbd_iou *fio_rbd_iou =
-	    (struct fio_rbd_iou *)io_u->engine_data;
+	struct fio_rbd_iou *fri = io_u->engine_data;
 
-	fio_rbd_iou->io_complete = 1;
+	if (fri->io_complete) {
+		fri->io_complete = 0;
+		fri->io_seen = 1;
+		rbd_data->aio_events[*events] = io_u;
+		(*events)++;
 
-	/* if read needs to be verified - we should not release comp here
-	   without fetching the result */
-	rbd_aio_release(comp);
-
-	/* TODO handle error */
+		rbd_aio_release(fri->completion);
+		return 1;
+	}
 
-	return;
+	return 0;
 }
 
-static void _fio_rbd_finish_sync_aiocb(rbd_completion_t comp, void *data)
+static int rbd_iter_events(struct thread_data *td, unsigned int *events,
+			   unsigned int min_evts, int wait)
 {
-	struct io_u *io_u = (struct io_u *)data;
-	struct fio_rbd_iou *fio_rbd_iou =
-	    (struct fio_rbd_iou *)io_u->engine_data;
-
-	fio_rbd_iou->io_complete = 1;
+	struct rbd_data *rbd_data = td->io_ops->data;
+	unsigned int this_events = 0;
+	struct io_u *io_u;
+	int i;
 
-	/* if sync needs to be verified - we should not release comp here
-	   without fetching the result */
-	rbd_aio_release(comp);
+	io_u_qiter(&td->io_u_all, io_u, i) {
+		struct fio_rbd_iou *fri = io_u->engine_data;
 
-	/* TODO handle error */
+		if (!(io_u->flags & IO_U_F_FLIGHT))
+			continue;
+		if (fri->io_seen)
+			continue;
 
-	return;
-}
+		if (fri_check_complete(rbd_data, io_u, events))
+			this_events++;
+		else if (wait) {
+			rbd_aio_wait_for_complete(fri->completion);
 
-static struct io_u *fio_rbd_event(struct thread_data *td, int event)
-{
-	struct rbd_data *rbd_data = td->io_ops->data;
+			if (fri_check_complete(rbd_data, io_u, events))
+				this_events++;
+		}
+		if (*events >= min_evts)
+			break;
+	}
 
-	return rbd_data->aio_events[event];
+	return this_events;
 }
 
 static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 			     unsigned int max, const struct timespec *t)
 {
-	struct rbd_data *rbd_data = td->io_ops->data;
-	unsigned int events = 0;
-	struct io_u *io_u;
-	int i;
-	struct fio_rbd_iou *fov;
+	unsigned int this_events, events = 0;
+	int wait = 0;
 
 	do {
-		io_u_qiter(&td->io_u_all, io_u, i) {
-			if (!(io_u->flags & IO_U_F_FLIGHT))
-				continue;
+		this_events = rbd_iter_events(td, &events, min, wait);
 
-			fov = (struct fio_rbd_iou *)io_u->engine_data;
-
-			if (fov->io_complete) {
-				fov->io_complete = 0;
-				rbd_data->aio_events[events] = io_u;
-				events++;
-			}
-
-		}
-		if (events < min)
-			usleep(100);
-		else
+		if (events >= min)
 			break;
+		if (this_events)
+			continue;
 
+		wait = 1;
 	} while (1);
 
 	return events;
@@ -256,17 +265,18 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 
 static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
-	int r = -1;
 	struct rbd_data *rbd_data = td->io_ops->data;
-	rbd_completion_t comp;
+	struct fio_rbd_iou *fri = io_u->engine_data;
+	int r = -1;
 
 	fio_ro_check(td, io_u);
 
+	fri->io_complete = 0;
+	fri->io_seen = 0;
+
 	if (io_u->ddir == DDIR_WRITE) {
-		r = rbd_aio_create_completion(io_u,
-					      (rbd_callback_t)
-					      _fio_rbd_finish_write_aiocb,
-					      &comp);
+		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
+						&fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_WRITE failed.\n");
@@ -274,17 +284,17 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_write(rbd_data->image, io_u->offset,
-				  io_u->xfer_buflen, io_u->xfer_buf, comp);
+				  io_u->xfer_buflen, io_u->xfer_buf,
+				  fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
+			rbd_aio_release(fri->completion);
 			goto failed;
 		}
 
 	} else if (io_u->ddir == DDIR_READ) {
-		r = rbd_aio_create_completion(io_u,
-					      (rbd_callback_t)
-					      _fio_rbd_finish_read_aiocb,
-					      &comp);
+		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
+						&fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_READ failed.\n");
@@ -292,27 +302,28 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_read(rbd_data->image, io_u->offset,
-				 io_u->xfer_buflen, io_u->xfer_buf, comp);
+				 io_u->xfer_buflen, io_u->xfer_buf,
+				 fri->completion);
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
+			rbd_aio_release(fri->completion);
 			goto failed;
 		}
 
 	} else if (io_u->ddir == DDIR_SYNC) {
-		r = rbd_aio_create_completion(io_u,
-					      (rbd_callback_t)
-					      _fio_rbd_finish_sync_aiocb,
-					      &comp);
+		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
+						&fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_SYNC failed.\n");
 			goto failed;
 		}
 
-		r = rbd_aio_flush(rbd_data->image, comp);
+		r = rbd_aio_flush(rbd_data->image, fri->completion);
 		if (r < 0) {
 			log_err("rbd_flush failed.\n");
+			rbd_aio_release(fri->completion);
 			goto failed;
 		}
 
@@ -344,7 +355,6 @@ static int fio_rbd_init(struct thread_data *td)
 
 failed:
 	return 1;
-
 }
 
 static void fio_rbd_cleanup(struct thread_data *td)
@@ -379,8 +389,9 @@ static int fio_rbd_setup(struct thread_data *td)
 	}
 	td->io_ops->data = rbd_data;
 
-	/* librbd does not allow us to run first in the main thread and later in a
-	 * fork child. It needs to be the same process context all the time. 
+	/* librbd does not allow us to run first in the main thread and later
+	 * in a fork child. It needs to be the same process context all the
+	 * time. 
 	 */
 	td->o.use_thread = 1;
 
@@ -439,22 +450,21 @@ static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 
 static void fio_rbd_io_u_free(struct thread_data *td, struct io_u *io_u)
 {
-	struct fio_rbd_iou *o = io_u->engine_data;
+	struct fio_rbd_iou *fri = io_u->engine_data;
 
-	if (o) {
+	if (fri) {
 		io_u->engine_data = NULL;
-		free(o);
+		free(fri);
 	}
 }
 
 static int fio_rbd_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
-	struct fio_rbd_iou *o;
+	struct fio_rbd_iou *fri;
 
-	o = malloc(sizeof(*o));
-	o->io_complete = 0;
-	o->io_u = io_u;
-	io_u->engine_data = o;
+	fri = calloc(1, sizeof(*fri));
+	fri->io_u = io_u;
+	io_u->engine_data = fri;
 	return 0;
 }
 
diff --git a/libfio.c b/libfio.c
index b823bd4..1abf39a 100644
--- a/libfio.c
+++ b/libfio.c
@@ -305,6 +305,8 @@ int initialize_fio(char *envp[])
 	 * access (ARM).
 	 */
 	compiletime_assert((offsetof(struct thread_stat, percentile_list) % 8) == 0, "stat percentile_list");
+	compiletime_assert((offsetof(struct thread_stat, total_run_time) % 8) == 0, "total_run_time");
+	compiletime_assert((offsetof(struct thread_stat, total_err_count) % 8) == 0, "total_err_count");
 	compiletime_assert((offsetof(struct thread_stat, latency_percentile) % 8) == 0, "stat latency_percentile");
 	compiletime_assert((offsetof(struct thread_options_pack, zipf_theta) % 8) == 0, "zipf_theta");
 	compiletime_assert((offsetof(struct thread_options_pack, pareto_h) % 8) == 0, "pareto_h");
diff --git a/stat.h b/stat.h
index 16b3d1a..8aefe03 100644
--- a/stat.h
+++ b/stat.h
@@ -158,6 +158,8 @@ struct thread_stat {
 	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
 	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint32_t pad;
+
 	uint64_t total_io_u[3];
 	uint64_t short_io_u[3];
 	uint64_t drop_io_u[3];
@@ -171,8 +173,10 @@ struct thread_stat {
 	/*
 	 * IO Error related stats
 	 */
-	uint16_t continue_on_error;
-	uint16_t filler[3];
+	union {
+		uint16_t continue_on_error;
+		uint64_t pad2;
+	};
 	uint64_t total_err_count;
 	uint32_t first_error;
 
@@ -181,7 +185,6 @@ struct thread_stat {
 
 	uint32_t latency_depth;
 	uint64_t latency_target;
-	uint32_t pad;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
 } __attribute__((packed));
