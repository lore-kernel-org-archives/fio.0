Return-Path: <axboe@kernel.dk>
Message-ID: <544B1D50.4010101@kernel.dk>
Date: Fri, 24 Oct 2014 21:47:28 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd hang for block sizes > 1M
References: <5449BBB3.7090109@catalyst.net.nz> <5449E50E.7000808@kernel.dk> <5449EEF1.1060407@catalyst.net.nz> <544A51C7.40803@gmail.com> <544A5DA6.2010709@gmail.com> <544AD67D.4030603@catalyst.net.nz> <544AEAE7.6080603@redhat.com> <544AF0D2.1050405@catalyst.net.nz> <544B0C7F.4080109@catalyst.net.nz>
In-Reply-To: <544B0C7F.4080109@catalyst.net.nz>
Content-Type: multipart/mixed;
 boundary="------------000209070501000206020006"
To: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org
Cc: "d.gollub@telekom.de >> Daniel Gollub" <d.gollub@telekom.de>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000209070501000206020006
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-10-24 20:35, Mark Kirkwood wrote:
> Patched client machine *only* - re-running fio from there works fine
> with (default - i.e no [client' section at all) cache settings:
>
> $ fio read-test.fio
> rbd_thread: (g=0): rw=read, bs=4M-4M/4M-4M/4M-4M, ioengine=rbd, iodepth=32
> fio-2.1.13-88-gb2ee7
> Starting 1 process
> rbd engine: RBD version: 0.1.8
> Jobs: 1 (f=1): [R(1)] [75.0% done] [1165MB/0KB/0KB /s] [291/0/0 iops]
> [eta 00m:0Jobs: 1 (f=1): [R(1)] [83.3% done] [447.4MB/0KB/0KB /s]
> [111/0/0 iops] [eta 00m:Jobs: 1 (f=1): [R(1)] [100.0% done]
> [268.0MB/0KB/0KB /s] [67/0/0 iops] [eta 00m:Jobs: 1 (f=1): [R(1)]
> [100.0% done] [336.1MB/0KB/0KB /s] [84/0/0 iops] [eta 00m:00s]
> rbd_thread: (groupid=0, jobs=1): err= 0: pid=5980: Sat Oct 25 15:32:16 2014
>    read : io=4096.0MB, bw=623410KB/s, iops=152, runt=  6728msec
>      slat (usec): min=7, max=230691, avg=5664.46, stdev=14434.46
>      clat (msec): min=11, max=1589, avg=193.03, stdev=246.84
>       lat (msec): min=13, max=1606, avg=198.70, stdev=248.62
>      clat percentiles (msec):
>       |  1.00th=[   17],  5.00th=[   30], 10.00th=[   43], 20.00th=[   60],
>       | 30.00th=[   78], 40.00th=[   93], 50.00th=[  109], 60.00th=[  124],
>       | 70.00th=[  147], 80.00th=[  210], 90.00th=[  498], 95.00th=[  758],
>       | 99.00th=[ 1237], 99.50th=[ 1467], 99.90th=[ 1565], 99.95th=[ 1598],
>       | 99.99th=[ 1598]
>      bw (KB  /s): min=178086, max=1193644, per=100.00%, avg=637349.58,
> stdev=397329.85
>      lat (msec) : 20=2.15%, 50=12.11%, 100=30.08%, 250=38.09%, 500=7.62%
>      lat (msec) : 750=4.79%, 1000=2.64%, 2000=2.54%
>    cpu          : usr=1.69%, sys=0.28%, ctx=6234, majf=0, minf=78
>    IO depths    : 1=0.1%, 2=0.2%, 4=0.4%, 8=1.7%, 16=58.6%, 32=39.1%,
>  >=64=0.0%
>       submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>  >=64=0.0%
>       complete  : 0=0.0%, 4=94.3%, 8=5.0%, 16=0.4%, 32=0.3%, 64=0.0%,
>  >=64=0.0%
>       issued    : total=r=1024/w=0/d=0, short=r=0/w=0/d=0, drop=r=0/w=0/d=0
>       latency   : target=0, window=0, percentile=100.00%, depth=32
>
> Run status group 0 (all jobs):
>     READ: io=4096.0MB, aggrb=623410KB/s, minb=623410KB/s,
> maxb=623410KB/s, mint=6728msec, maxt=6728msec

Since you're running rbd tests... Mind giving this patch a go? I don't 
have an easy way to test it myself. It has nothing to do with this 
issue, it's just a potentially faster way to do the rbd completions.

-- 
Jens Axboe


--------------000209070501000206020006
Content-Type: text/x-patch;
 name="rbd-complete-v2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rbd-complete-v2.patch"

diff --git a/engines/rbd.c b/engines/rbd.c
index 6fe87b8d010c..6aa96a5ff550 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -11,6 +11,7 @@
 
 struct fio_rbd_iou {
 	struct io_u *io_u;
+	rbd_completion_t completion;
 	int io_complete;
 };
 
@@ -221,34 +222,66 @@ static struct io_u *fio_rbd_event(struct thread_data *td, int event)
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
+		if (!(io_u->flags & IO_U_F_FLIGHT))
+			continue;
 
-			fov = (struct fio_rbd_iou *)io_u->engine_data;
+		if (fri_check_complete(rbd_data, io_u, events))
+			this_events++;
+		else if (wait) {
+			struct fio_rbd_iou *fri = io_u->engine_data;
 
-			if (fov->io_complete) {
-				fov->io_complete = 0;
-				rbd_data->aio_events[events] = io_u;
-				events++;
-			}
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
@@ -258,7 +291,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 {
 	int r = -1;
 	struct rbd_data *rbd_data = td->io_ops->data;
-	rbd_completion_t comp;
+	struct fio_rbd_iou *fri = io_u->engine_data;
 
 	fio_ro_check(td, io_u);
 
@@ -266,7 +299,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		r = rbd_aio_create_completion(io_u,
 					      (rbd_callback_t)
 					      _fio_rbd_finish_write_aiocb,
-					      &comp);
+					      &fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_WRITE failed.\n");
@@ -274,7 +307,8 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_write(rbd_data->image, io_u->offset,
-				  io_u->xfer_buflen, io_u->xfer_buf, comp);
+				  io_u->xfer_buflen, io_u->xfer_buf,
+				  fri->completion);
 		if (r < 0) {
 			log_err("rbd_aio_write failed.\n");
 			goto failed;
@@ -284,7 +318,7 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		r = rbd_aio_create_completion(io_u,
 					      (rbd_callback_t)
 					      _fio_rbd_finish_read_aiocb,
-					      &comp);
+					      &fri->completion);
 		if (r < 0) {
 			log_err
 			    ("rbd_aio_create_completion for DDIR_READ failed.\n");
@@ -292,7 +326,8 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
 		}
 
 		r = rbd_aio_read(rbd_data->image, io_u->offset,
-				 io_u->xfer_buflen, io_u->xfer_buf, comp);
+				 io_u->xfer_buflen, io_u->xfer_buf,
+				 fri->completion);
 
 		if (r < 0) {
 			log_err("rbd_aio_read failed.\n");
@@ -303,14 +338,14 @@ static int fio_rbd_queue(struct thread_data *td, struct io_u *io_u)
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

--------------000209070501000206020006--

