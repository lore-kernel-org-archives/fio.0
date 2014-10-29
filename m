Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaJ2MAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 Oct 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XjRv3-0003HR-NZ
	for fio@vger.kernel.org; Wed, 29 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141029120003.7932D40440@lyth.info>
Date: Wed, 29 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d8b64af2a1688c3c3d218cba0faad57a3ba050e8:

  rbd: various fixes and cleanups (2014-10-27 10:53:52 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8859391bb7d77680ede51b46e770237abae566dc:

  engines/glusterfs_async: cleanups (2014-10-28 20:48:33 -0600)

----------------------------------------------------------------
Jens Axboe (6):
      engines/rbd: add support for rbd_invalidate_cache()
      engines/rbd: use rbd_aio_is_complete() and add TRIM support
      engines/rbd: remove unused rbd_options->td
      engines/rbd: add option to busy poll on event completion
      engines/glfs_async: add trim support
      engines/glusterfs_async: cleanups

 configure                 |   47 +++++++++++++++++-
 engines/glusterfs_async.c |   71 ++++++++++++---------------
 engines/rbd.c             |  119 +++++++++++++++++++++++----------------------
 3 files changed, 137 insertions(+), 100 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 58f02fa..de0fc89 100755
--- a/configure
+++ b/configure
@@ -1203,6 +1203,26 @@ fi
 echo "Rados Block Device engine     $rbd"
 
 ##########################################
+# check for rbd_invaidate_cache()
+rbd_inval="no"
+if test "$rbd" = "yes"; then
+cat > $TMPC << EOF
+#include <rbd/librbd.h>
+
+int main(int argc, char **argv)
+{
+  rbd_image_t image;
+
+  return rbd_invalidate_cache(image);
+}
+EOF
+if compile_prog "" "-lrbd -lrados" "rbd"; then
+  rbd_inval="yes"
+fi
+echo "rbd_invalidate_cache          $rbd_inval"
+fi
+
+##########################################
 # Check whether we have setvbuf
 setvbuf="no"
 cat > $TMPC << EOF
@@ -1241,6 +1261,7 @@ fi
 
 ##########################################
 # check for gfapi fadvise support
+if test "$gfapi" = "yes" ; then
 gf_fadvise="no"
 cat > $TMPC << EOF
 #include <glusterfs/api/glfs.h>
@@ -1253,11 +1274,29 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-
 if compile_prog "" "-lgfapi -lglusterfs" "gfapi"; then
   gf_fadvise="yes"
 fi
 echo "Gluster API use fadvise       $gf_fadvise"
+fi
+
+##########################################
+# check for gfapi trim support
+gf_trim="no"
+if test "$gfapi" = "yes" ; then
+cat > $TMPC << EOF
+#include <glusterfs/api/glfs.h>
+
+int main(int argc, char **argv)
+{
+  return glfs_discard_async(NULL, 0, 0);
+}
+EOF
+if compile_prog "" "-lgfapi -lglusterfs" "gf trim"; then
+  gf_trim="yes"
+fi
+echo "Gluster API trim support      $gf_trim"
+fi
 
 ##########################################
 # Check if we support stckf on s390
@@ -1489,6 +1528,9 @@ fi
 if test "$rbd" = "yes" ; then
   output_sym "CONFIG_RBD"
 fi
+if test "$rbd_inval" = "yes" ; then
+  output_sym "CONFIG_RBD_INVAL"
+fi
 if test "$setvbuf" = "yes" ; then
   output_sym "CONFIG_SETVBUF"
 fi
@@ -1502,6 +1544,9 @@ fi
 if test "$gf_fadvise" = "yes" ; then
   output_sym "CONFIG_GF_FADVISE"
 fi
+if test "$gf_trim" = "yes" ; then
+  output_sym "CONFIG_GF_TRIM"
+fi
 if test "$libhdfs" = "yes" ; then
   output_sym "CONFIG_LIBHDFS"
 fi
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index cf6ea70..d9d6693 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -10,11 +10,11 @@ struct fio_gf_iou {
 	struct io_u *io_u;
 	int io_complete;
 };
-static ulong cb_count = 0, issued = 0;
 
 static struct io_u *fio_gf_event(struct thread_data *td, int event)
 {
 	struct gf_data *gf_data = td->io_ops->data;
+
 	dprint(FD_IO, "%s\n", __FUNCTION__);
 	return gf_data->aio_events[event];
 }
@@ -25,18 +25,18 @@ static int fio_gf_getevents(struct thread_data *td, unsigned int min,
 	struct gf_data *g = td->io_ops->data;
 	unsigned int events = 0;
 	struct io_u *io_u;
-	int i = 0;
-	struct fio_gf_iou *io = NULL;
+	int i;
 
 	dprint(FD_IO, "%s\n", __FUNCTION__);
 	do {
 		io_u_qiter(&td->io_u_all, io_u, i) {
+			struct fio_gf_iou *io;
+
 			if (!(io_u->flags & IO_U_F_FLIGHT))
 				continue;
 
-			io = (struct fio_gf_iou *)io_u->engine_data;
-
-			if (io && io->io_complete) {
+			io = io_u->engine_data;
+			if (io->io_complete) {
 				io->io_complete = 0;
 				g->aio_events[events] = io_u;
 				events++;
@@ -61,22 +61,20 @@ static void fio_gf_io_u_free(struct thread_data *td, struct io_u *io_u)
 	struct fio_gf_iou *io = io_u->engine_data;
 
 	if (io) {
-		if (io->io_complete) {
+		if (io->io_complete)
 			log_err("incomplete IO found.\n");
-		}
 		io_u->engine_data = NULL;
 		free(io);
 	}
-	log_err("issued %lu finished %lu\n", issued, cb_count);
 }
 
 static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
 {
-	struct fio_gf_iou *io = NULL;
-
 	dprint(FD_FILE, "%s\n", __FUNCTION__);
 
 	if (!io_u->engine_data) {
+		struct fio_gf_iou *io;
+
 		io = malloc(sizeof(struct fio_gf_iou));
 		if (!io) {
 			td_verror(td, errno, "malloc");
@@ -91,48 +89,44 @@ static int fio_gf_io_u_init(struct thread_data *td, struct io_u *io_u)
 
 static void gf_async_cb(glfs_fd_t * fd, ssize_t ret, void *data)
 {
-	struct io_u *io_u = (struct io_u *)data;
-	struct fio_gf_iou *iou = (struct fio_gf_iou *)io_u->engine_data;
+	struct io_u *io_u = data;
+	struct fio_gf_iou *iou = io_u->engine_data;
 
 	dprint(FD_IO, "%s ret %lu\n", __FUNCTION__, ret);
 	iou->io_complete = 1;
-	cb_count++;
 }
 
 static int fio_gf_async_queue(struct thread_data fio_unused * td,
 			      struct io_u *io_u)
 {
 	struct gf_data *g = td->io_ops->data;
-	int r = 0;
+	int r;
 
-	dprint(FD_IO, "%s op %s\n", __FUNCTION__,
-	       io_u->ddir == DDIR_READ ? "read" : io_u->ddir ==
-	       DDIR_WRITE ? "write" : io_u->ddir ==
-	       DDIR_SYNC ? "sync" : "unknown");
+	dprint(FD_IO, "%s op %s\n", __FUNCTION__, io_ddir_name(io_u->ddir));
 
 	fio_ro_check(td, io_u);
 
 	if (io_u->ddir == DDIR_READ)
 		r = glfs_pread_async(g->fd, io_u->xfer_buf, io_u->xfer_buflen,
-				     io_u->offset, 0, gf_async_cb,
-				     (void *)io_u);
+				     io_u->offset, 0, gf_async_cb, io_u);
 	else if (io_u->ddir == DDIR_WRITE)
 		r = glfs_pwrite_async(g->fd, io_u->xfer_buf, io_u->xfer_buflen,
-				      io_u->offset, 0, gf_async_cb,
-				      (void *)io_u);
-	else if (io_u->ddir == DDIR_SYNC) {
-		r = glfs_fsync_async(g->fd, gf_async_cb, (void *)io_u);
-	} else {
-		log_err("unsupported operation.\n");
-		io_u->error = -EINVAL;
-		goto failed;
-	}
+				      io_u->offset, 0, gf_async_cb, io_u);
+#if defined(CONFIG_GF_TRIM)
+	else if (io_u->ddir == DDIR_TRIM)
+		r = glfs_discard_async(g->fd, io_u->offset, io_u->xfer_buflen,
+				       gf_async_cb, io_u);
+#endif
+	else if (io_u->ddir == DDIR_SYNC)
+		r = glfs_fsync_async(g->fd, gf_async_cb, io_u);
+	else
+		r = -EINVAL;
+
 	if (r) {
-		log_err("glfs failed.\n");
+		log_err("glfs queue failed.\n");
 		io_u->error = r;
 		goto failed;
 	}
-	issued++;
 	return FIO_Q_QUEUED;
 
 failed:
@@ -143,29 +137,26 @@ failed:
 
 int fio_gf_async_setup(struct thread_data *td)
 {
-	int r = 0;
-	struct gf_data *g = NULL;
+	struct gf_data *g;
+	int r;
 
 #if defined(NOT_YET)
 	log_err("the async interface is still very experimental...\n");
 #endif
 	r = fio_gf_setup(td);
-	if (r) {
+	if (r)
 		return r;
-	}
+
 	td->o.use_thread = 1;
 	g = td->io_ops->data;
-	g->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
+	g->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!g->aio_events) {
 		r = -ENOMEM;
 		fio_gf_cleanup(td);
 		return r;
 	}
 
-	memset(g->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
-
 	return r;
-
 }
 
 static int fio_gf_async_prep(struct thread_data *td, struct io_u *io_u)
diff --git a/engines/rbd.c b/engines/rbd.c
index 5160c32..cf7be0a 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -12,7 +12,6 @@
 struct fio_rbd_iou {
 	struct io_u *io_u;
 	rbd_completion_t completion;
-	int io_complete;
 	int io_seen;
 };
 
@@ -24,10 +23,10 @@ struct rbd_data {
 };
 
 struct rbd_options {
-	struct thread_data *td;
 	char *rbd_name;
 	char *pool_name;
 	char *client_name;
+	int busy_poll;
 };
 
 static struct fio_option options[] = {
@@ -41,22 +40,32 @@ static struct fio_option options[] = {
 		.group		= FIO_OPT_G_RBD,
 	},
 	{
-		.name     = "pool",
-		.lname    = "rbd engine pool",
-		.type     = FIO_OPT_STR_STORE,
-		.help     = "Name of the pool hosting the RBD for the RBD engine",
-		.off1     = offsetof(struct rbd_options, pool_name),
-		.category = FIO_OPT_C_ENGINE,
-		.group    = FIO_OPT_G_RBD,
+		.name		= "pool",
+		.lname		= "rbd engine pool",
+		.type		= FIO_OPT_STR_STORE,
+		.help		= "Name of the pool hosting the RBD for the RBD engine",
+		.off1		= offsetof(struct rbd_options, pool_name),
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
 	},
 	{
-		.name     = "clientname",
-		.lname    = "rbd engine clientname",
-		.type     = FIO_OPT_STR_STORE,
-		.help     = "Name of the ceph client to access the RBD for the RBD engine",
-		.off1     = offsetof(struct rbd_options, client_name),
-		.category = FIO_OPT_C_ENGINE,
-		.group    = FIO_OPT_G_RBD,
+		.name		= "clientname",
+		.lname		= "rbd engine clientname",
+		.type		= FIO_OPT_STR_STORE,
+		.help		= "Name of the ceph client to access the RBD for the RBD engine",
+		.off1		= offsetof(struct rbd_options, client_name),
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
+	},
+	{
+		.name		= "busy_poll",
+		.lname		= "Busy poll",
+		.type		= FIO_OPT_BOOL,
+		.help		= "Busy poll for completions instead of sleeping",
+		.off1		= offsetof(struct rbd_options, client_name),
+		.def		= "0",
+		.category	= FIO_OPT_C_ENGINE,
+		.group		= FIO_OPT_G_RBD,
 	},
 	{
 		.name = NULL,
@@ -100,7 +109,7 @@ static int _fio_rbd_connect(struct thread_data *td)
 	struct rbd_options *o = td->eo;
 	int r;
 
-	r = rados_create(&(rbd_data->cluster), o->client_name);
+	r = rados_create(&rbd_data->cluster, o->client_name);
 	if (r < 0) {
 		log_err("rados_create failed.\n");
 		goto failed_early;
@@ -119,13 +128,13 @@ static int _fio_rbd_connect(struct thread_data *td)
 	}
 
 	r = rados_ioctx_create(rbd_data->cluster, o->pool_name,
-			       &(rbd_data->io_ctx));
+			       &rbd_data->io_ctx);
 	if (r < 0) {
 		log_err("rados_ioctx_create failed.\n");
 		goto failed_shutdown;
 	}
 
-	r = rbd_open(rbd_data->io_ctx, o->rbd_name, &(rbd_data->image),
+	r = rbd_open(rbd_data->io_ctx, o->rbd_name, &rbd_data->image,
 		     NULL /*snap */ );
 	if (r < 0) {
 		log_err("rbd_open failed.\n");
@@ -167,12 +176,10 @@ static void _fio_rbd_disconnect(struct rbd_data *rbd_data)
 
 static void _fio_rbd_finish_aiocb(rbd_completion_t comp, void *data)
 {
-	struct io_u *io_u = data;
-	struct fio_rbd_iou *fri = io_u->engine_data;
+	struct fio_rbd_iou *fri = data;
+	struct io_u *io_u = fri->io_u;
 	ssize_t ret;
 
-	fri->io_complete = 1;
-
 	/*
 	 * Looks like return value is 0 for success, or < 0 for
 	 * a specific error. So we have to assume that it can't do
@@ -199,8 +206,7 @@ static inline int fri_check_complete(struct rbd_data *rbd_data,
 {
 	struct fio_rbd_iou *fri = io_u->engine_data;
 
-	if (fri->io_complete) {
-		fri->io_complete = 0;
+	if (rbd_aio_is_complete(fri->completion)) {
 		fri->io_seen = 1;
 		rbd_data->aio_events[*events] = io_u;
 		(*events)++;
@@ -247,6 +253,7 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 			     unsigned int max, const struct timespec *t)
 {
 	unsigned int this_events, events = 0;
+	struct rbd_options *o = td->eo;
 	int wait = 0;
 
 	do {
@@ -257,7 +264,10 @@ static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
 		if (this_events)
 			continue;
 
-		wait = 1;
+		if (!o->busy_poll)
+			wait = 1;
+		else
+			nop;
 	} while (1);
 
 	return events;
@@ -271,70 +281,55 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	fri->io_complete = 0;
 	fri->io_seen = 0;
 
-	if (io_u->ddir == DDIR_WRITE) {
-		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
+	r = rbd_aio_create_completion(fri, _fio_rbd_finish_aiocb,
 						&fri->completion);
-		if (r < 0) {
-			log_err
-			    ("rbd_aio_create_completion for DDIR_WRITE failed.\n");
-			goto failed;
-		}
+	if (r < 0) {
+		log_err("rbd_aio_create_completion failed.\n");
+		goto failed;
+	}
 
+	if (io_u->ddir == DDIR_WRITE) {
 		r = rbd_aio_write(rbd_data->image, io_u->offset,
 				  io_u->xfer_buflen, io_u->xfer_buf,
 				  fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
-			rbd_aio_release(fri->completion);
-			goto failed;
+			goto failed_comp;
 		}
 
 	} else if (io_u->ddir == DDIR_READ) {
-		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
-						&fri->completion);
-		if (r < 0) {
-			log_err
-			    ("rbd_aio_create_completion for DDIR_READ failed.\n");
-			goto failed;
-		}
-
 		r = rbd_aio_read(rbd_data->image, io_u->offset,
 				 io_u->xfer_buflen, io_u->xfer_buf,
 				 fri->completion);
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
-			rbd_aio_release(fri->completion);
-			goto failed;
+			goto failed_comp;
 		}
-
-	} else if (io_u->ddir == DDIR_SYNC) {
-		r = rbd_aio_create_completion(io_u, _fio_rbd_finish_aiocb,
-						&fri->completion);
+	} else if (io_u->ddir == DDIR_TRIM) {
+		r = rbd_aio_discard(rbd_data->image, io_u->offset,
+				 io_u->xfer_buflen, fri->completion);
 		if (r < 0) {
-			log_err
-			    ("rbd_aio_create_completion for DDIR_SYNC failed.\n");
-			goto failed;
+			log_err("rbd_aio_discard failed.\n");
+			goto failed_comp;
 		}
-
+	} else if (io_u->ddir == DDIR_SYNC) {
 		r = rbd_aio_flush(rbd_data->image, fri->completion);
 		if (r < 0) {
 			log_err("rbd_flush failed.\n");
-			rbd_aio_release(fri->completion);
-			goto failed;
+			goto failed_comp;
 		}
-
 	} else {
 		dprint(FD_IO, "%s: Warning: unhandled ddir: %d\n", __func__,
 		       io_u->ddir);
-		return FIO_Q_COMPLETED;
+		goto failed_comp;
 	}
 
 	return FIO_Q_QUEUED;
-
+failed_comp:
+	rbd_aio_release(fri->completion);
 failed:
 	io_u->error = r;
 	td_verror(td, io_u->error, "xfer");
@@ -445,7 +440,13 @@ static int fio_rbd_open(struct thread_data *td, struct fio_file *f)
 
 static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 {
+#if defined(CONFIG_RBD_INVAL)
+	struct rbd_data *rbd_data = td->io_ops->data;
+
+	return rbd_invalidate_cache(rbd_data->image);
+#else
 	return 0;
+#endif
 }
 
 static void fio_rbd_io_u_free(struct thread_data *td, struct io_u *io_u)
