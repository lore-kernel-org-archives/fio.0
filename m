Return-Path: <axboe@kernel.dk>
Message-ID: <544BF808.2090800@kernel.dk>
Date: Sat, 25 Oct 2014 13:20:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz> <544B1D50.4010101@kernel.dk> <544B2C19.7070009@catalyst.net.nz>
In-Reply-To: <544B2C19.7070009@catalyst.net.nz>
Content-Type: multipart/mixed;
 boundary="------------020604040901090709030109"
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------020604040901090709030109
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 10/24/2014 10:50 PM, Mark Kirkwood wrote:
> On 25/10/14 16:47, Jens Axboe wrote:
>>
>> Since you're running rbd tests... Mind giving this patch a go? I don't
>> have an easy way to test it myself. It has nothing to do with this
>> issue, it's just a potentially faster way to do the rbd completions.
>>
> 
> Sure - but note I'm testing this on my i7 workstation (4x osd's running
> on 2x Crucial M550) so not exactly server grade :-)
> 
> With that in mind, I'm seeing slightly *slower* performance with the
> patch applied: e.g: for 128k blocks - 2 runs, 1 uncached and the next
> cached.

Yeah, that doesn't look good. Mind trying this one out? I wonder if we
doubly wait on them - or perhaps rbd_aio_wait_for_complete() isn't
working correctly. If you try this one, we should know more...

Goal is, I want to get rid of that usleep() in getevents.

-- 
Jens Axboe


--------------020604040901090709030109
Content-Type: text/x-patch;
 name="rbd-comp-v3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rbd-comp-v3.patch"

diff --git a/engines/rbd.c b/engines/rbd.c
index 6fe87b8d010c..2353b1f11caf 100644
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
@@ -221,34 +223,69 @@ static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 	return rbd_data->aio_events[event];
 }
 
-static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
-			     unsigned int max, const struct timespec *t)
+static inline int fri_check_complete(struct rbd_data *rbd_data,
+				     struct io_u *io_u,
+				     unsigned int *events)
+{
+	struct fio_rbd_iou *fri = io_u->engine_data;
+
+	if (fri->io_complete) {
+		fri->io_complete = 0;
+		fri->io_seen = 1;
+		rbd_data->aio_events[*events] = io_u;
+		(*events)++;
+		return 1;
+	}
+
+	return 0;
+}
+
+static int rbd_iter_events(struct thread_data *td, unsigned int *events,
+			   unsigned int min_evts, int wait)
 {
 	struct rbd_data *rbd_data = td->io_ops->data;
-	unsigned int events = 0;
+	unsigned int this_events = 0;
 	struct io_u *io_u;
 	int i;
-	struct fio_rbd_iou *fov;
 
-	do {
-		io_u_qiter(&td->io_u_all, io_u, i) {
-			if (!(io_u->flags & IO_U_F_FLIGHT))
-				continue;
+	io_u_qiter(&td->io_u_all, io_u, i) {
+		struct fio_rbd_iou *fri = io_u->engine_data;
 
-			fov = (struct fio_rbd_iou *)io_u->engine_data;
+		if (!(io_u->flags & IO_U_F_FLIGHT))
+			continue;
+		if (fri->io_seen)
+			continue;
 
-			if (fov->io_complete) {
-				fov->io_complete = 0;
-				rbd_data->aio_events[events] = io_u;
-				events++;
-			}
+		if (fri_check_complete(rbd_data, io_u, events))
+			this_events++;
+		else if (wait) {
+			rbd_aio_wait_for_complete(fri->completion);
 
+			if (fri_check_complete(rbd_data, io_u, events))
+				this_events++;
 		}
-		if (events < min)
-			usleep(100);
-		else
+		if (*events >= min_evts)
+			break;
+	}
+
+	return this_events;
+}
+
+static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
+			     unsigned int max, const struct timespec *t)
+{
+	unsigned int this_events, events = 0;
+	int wait = 0;
+
+	do {
+		this_events = rbd_iter_events(td, &events, min, wait);
+
+		if (events >= min)
 			break;
+		if (this_events)
+			continue;
 
+		wait = 1;
 	} while (1);
 
 	return events;
@@ -258,7 +295,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
 	int r = -1;
 	struct rbd_data *rbd_data = td->io_ops->data;
-	rbd_completion_t comp;
+	struct fio_rbd_iou *fri = io_u->engine_data;
 
 	fio_ro_check(td, io_u);
 
@@ -266,7 +303,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		r = rbd_aio_create_completion(io_u,
 					      (rbd_callback_t)
 					      _fio_rbd_finish_write_aiocb,
-					      &comp);
+					      &fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_WRITE failed.\n");
@@ -274,7 +311,8 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_write(rbd_data->image, io_u->offset,
-				  io_u->xfer_buflen, io_u->xfer_buf, comp);
+				  io_u->xfer_buflen, io_u->xfer_buf,
+				  fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
 			goto failed;
@@ -284,7 +322,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		r = rbd_aio_create_completion(io_u,
 					      (rbd_callback_t)
 					      _fio_rbd_finish_read_aiocb,
-					      &comp);
+					      &fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_READ failed.\n");
@@ -292,7 +330,8 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_read(rbd_data->image, io_u->offset,
-				 io_u->xfer_buflen, io_u->xfer_buf, comp);
+				 io_u->xfer_buflen, io_u->xfer_buf,
+				 fri->completion);
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
@@ -303,14 +342,14 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		r = rbd_aio_create_completion(io_u,
 					      (rbd_callback_t)
 					      _fio_rbd_finish_sync_aiocb,
-					      &comp);
+					      &fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_SYNC failed.\n");
 			goto failed;
 		}
 
-		r = rbd_aio_flush(rbd_data->image, comp);
+		r = rbd_aio_flush(rbd_data->image, fri->completion);
 		if (r < 0) {
 			log_err("rbd_flush failed.\n");
 			goto failed;
@@ -439,22 +478,21 @@ static int fio_rbd_invalidate(struct thread_data *td, struct fio_file *f)
 
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
 

--------------020604040901090709030109--

