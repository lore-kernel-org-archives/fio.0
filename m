Return-Path: <axboe@kernel.dk>
Message-ID: <544FCDBD.7070106@kernel.dk>
Date: Tue, 28 Oct 2014 11:09:17 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio rbd completions (Was: fio rbd hang for block sizes > 1M)
References: <5449BBB3.7090109@catalyst.net.nz> <544B1D50.4010101@kernel.dk> <544B2C19.7070009@catalyst.net.nz> <544BF808.2090800@kernel.dk> <544C2371.1020403@catalyst.net.nz> <544E547C.30009@kernel.dk> <CAM9_UU9j2erdGT5kqKi_+5z5ERFMPO1hHwMk8kaFjLkGm-zp-g@mail.gmail.com> <544E6330.1000202@kernel.dk> <544E63EA.1010204@kernel.dk> <CAM9_UU-35i9uRu9EDQSM-b7CjmxrKYV2Gz8ocrykOYk+2q++hw@mail.gmail.com> <544E6691.106@kernel.dk> <CAM9_UU9_ZHtwv=31DyxkAmog7XJbthiRXi5n+Y0Cfxj4qm3bGQ@mail.gmail.com> <544E6A8D.1040608@kernel.dk> <CAM9_UU8x2uZZUWaPPoy+LHmUhC_3sqKZ9GPsEqDwKUkprg4kdQ@mail.gmail.com> <544EC05D.7040807@catalyst.net.nz> <544EC7F1.6010900@kernel.dk> <544ED37D.6060800@catalyst.net.nz> <CAM9_UU8MHdj+mjAWBziETxPDnwTt0JBuHrQp2Fu9YtF=msae3w@mail.gmail.com> <79432849-2F58-4738-82E1-E4D8AB10A6AE@kernel.dk> <CAM9_UU9G5vQ68UxMakte-Wb5B9_KBo24ov7=hNHpYqEtko2nQg@mail.gmail.com> <544FB2F2.2060703@kernel.dk> <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com>
In-Reply-To: <CAM9_UU_o8kS1wJnDKTvd8+qkm9=93yfW3THr_8ni8C+5=TH6tg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010504000009050707080709"
To: Ketor D <d.ketor@gmail.com>
Cc: Mark Kirkwood <mark.kirkwood@catalyst.net.nz>, Mark Nelson <mark.nelson@inktank.com>, Mark Nelson <mark.a.nelson@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "xan.peng" <xanpeng@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010504000009050707080709
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-10-28 09:49, Ketor D wrote:
> Cannot get the new commited code from github now.
> When I get the newest code, I will test.

So here's another idea, applies on top of current -git. Basically it 
makes rbd wait for the oldest event, not just the first one in the array 
of all ios. This is the saner thing to do, as hopefully the oldest event 
will be the one to complete first. At least it has a much higher chance 
of being the right thing to do, than just waiting on a random event.

Completely untested, so you might have to fiddle a bit with it to ensure 
that it actually works...

-- 
Jens Axboe


--------------010504000009050707080709
Content-Type: text/x-patch;
 name="rbd-time-sort.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rbd-time-sort.patch"

diff --git a/engines/rbd.c b/engines/rbd.c
index cf7be0acd1e3..f3129044c430 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -20,6 +20,7 @@ struct rbd_data {
 	rados_ioctx_t io_ctx;
 	rbd_image_t image;
 	struct io_u **aio_events;
+	struct io_u **sort_events;
 };
 
 struct rbd_options {
@@ -80,20 +81,19 @@ static int _fio_setup_rbd_data(struct thread_data *td,
 	if (td->io_ops->data)
 		return 0;
 
-	rbd_data = malloc(sizeof(struct rbd_data));
+	rbd_data = calloc(1, sizeof(struct rbd_data));
 	if (!rbd_data)
 		goto failed;
 
-	memset(rbd_data, 0, sizeof(struct rbd_data));
-
-	rbd_data->aio_events = malloc(td->o.iodepth * sizeof(struct io_u *));
+	rbd_data->aio_events = calloc(td->o.iodepth, sizeof(struct io_u *));
 	if (!rbd_data->aio_events)
 		goto failed;
 
-	memset(rbd_data->aio_events, 0, td->o.iodepth * sizeof(struct io_u *));
+	rbd_data->sort_events = calloc(td->o.iodepth, sizeof(struct io_u *));
+	if (!rbd_data->sort_events)
+		goto failed;
 
 	*rbd_data_ptr = rbd_data;
-
 	return 0;
 
 failed:
@@ -218,14 +218,32 @@ static inline int fri_check_complete(struct rbd_data *rbd_data,
 	return 0;
 }
 
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
 	struct rbd_data *rbd_data = td->io_ops->data;
 	unsigned int this_events = 0;
 	struct io_u *io_u;
-	int i;
+	int i, sort_idx;
 
+	sort_idx = 0;
 	io_u_qiter(&td->io_u_all, io_u, i) {
 		struct fio_rbd_iou *fri = io_u->engine_data;
 
@@ -236,16 +254,39 @@ static int rbd_iter_events(struct thread_data *td, unsigned int *events,
 
 		if (fri_check_complete(rbd_data, io_u, events))
 			this_events++;
-		else if (wait) {
-			rbd_aio_wait_for_complete(fri->completion);
+		else if (wait)
+			rbd_data->sort_events[sort_idx++] = io_u;
 
-			if (fri_check_complete(rbd_data, io_u, events))
-				this_events++;
-		}
 		if (*events >= min_evts)
 			break;
 	}
 
+	if (!wait || !sort_idx)
+		return this_events;
+
+	qsort(rbd_data->sort_events, sort_idx, sizeof(struct io_u *), rbd_io_u_cmp);
+	for (i = 0; i < sort_idx; i++) {
+		struct fio_rbd_iou *fri;
+
+		io_u = rbd_data->sort_events[i];
+		fri = io_u->engine_data;
+
+		if (fri_check_complete(rbd_data, io_u, events)) {
+			this_events++;
+			continue;
+		}
+		if (!wait)
+			continue;
+
+		rbd_aio_wait_for_complete(fri->completion);
+
+		if (fri_check_complete(rbd_data, io_u, events))
+			this_events++;
+
+		if (wait && *events >= min_evts)
+			wait = 0;
+	}
+
 	return this_events;
 }
 
@@ -359,6 +400,7 @@ static void fio_rbd_cleanup(struct thread_data *td)
 	if (rbd_data) {
 		_fio_rbd_disconnect(rbd_data);
 		free(rbd_data->aio_events);
+		free(rbd_data->sort_events);
 		free(rbd_data);
 	}
 

--------------010504000009050707080709--

