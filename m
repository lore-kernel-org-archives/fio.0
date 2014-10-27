Return-Path: <axboe@kernel.dk>
Message-ID: <544E6A8D.1040608@kernel.dk>
Date: Mon, 27 Oct 2014 09:53:49 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk> <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk> <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk> <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com> <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com> <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
In-Reply-To: <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080301040401040103060605"
To: Ketor D <d.ketor@gmail.com>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080301040401040103060605
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/27/2014 09:45 AM, Ketor D wrote:
> The return code is 0 if success.I mod the code a bit and then run fio very well.
> I think if you fix this bug, the path will be nearly pefect!!
> 
> ret = rbd_aio_get_return_value(fri->completion);
> //printf("ret=%ld\n", ret);
> //if (ret != (int) io_u->xfer_buflen) {
> if (ret != 0) {
> if (ret >= 0) {
> io_u->resid = io_u->xfer_buflen - ret;
> io_u->error = 0;
> } else
> io_u->error = ret;
> }

Weird, so it does not do partial completions I assume. Modified -v8 to
take that into account, hopefully this just works out-of-the-box.

What does the performance numbers look like for your sync test with this?

-- 
Jens Axboe


--------------080301040401040103060605
Content-Type: text/x-patch;
 name="rbd-comp-v8.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rbd-comp-v8.patch"

diff --git a/engines/rbd.c b/engines/rbd.c
index 6fe87b8d010c..5160c32aedb0 100644
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
 

--------------080301040401040103060605--

