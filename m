Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 2/3] libaio: support for Zone Append command
Date: Tue, 28 Jul 2020 18:06:54 +0530
Message-Id: <20200728123655.30780-3-krish.reddy@samsung.com>
In-Reply-To: <20200728123655.30780-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20200728123655.30780-1-krish.reddy@samsung.com>
	<CGME20200728124026epcas5p131c8548df5b07dcdfa8e3bccbcc88f3d@epcas5p1.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

The zone append command uses the write path with offset as
start of the zone, when ZBD zone mode is enabled.
Upon successful completion, offset  of the location where
the data has been placed is returned in res2 field of the
io event. If data verification is enabled, the offset returned
is used for read and verify.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 engines/libaio.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index b909b79e..5c10f69d 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -12,6 +12,7 @@
 #include <sys/resource.h>
 
 #include "../fio.h"
+#include "../zbd.h"
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 #include "../lib/memalign.h"
@@ -123,7 +124,14 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if ((td->o.zone_mode == ZONE_MODE_ZBD) && td->o.zone_append && f->zbd_info->model != ZBD_NONE) {
+			unsigned long long zone_start_offset = io_u->offset & ~(f->zbd_info->zone_size - 1);
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, zone_start_offset);
+		}
+		else
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (td->o.zone_append)
+			iocb->aio_rw_flags |= RWF_APPEND;
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (ddir_sync(io_u->ddir))
@@ -229,9 +237,25 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 			r = io_getevents(ld->aio_ctx, actual_min,
 				max, ld->aio_events + events, lt);
 		}
-		if (r > 0)
+		if (r > 0) {
+			if ((td->o.zone_mode == ZONE_MODE_ZBD) && td->o.zone_append
+			    && td->o.do_verify && td->o.verify) {
+				struct io_event *ev;
+				struct io_u *io_u;
+				struct fio_file *f;
+				unsigned event;
+
+				for (event = 0; event < r; event++) {
+					ev = ld->aio_events + event;
+					io_u = container_of(ev->obj, struct io_u, iocb);
+					f = io_u->file;
+					if ((io_u->ddir == DDIR_WRITE)
+					    && (f->zbd_info->model != ZBD_NONE))
+						io_u->ipo->offset = ev->res2;
+				}
+			}
 			events += r;
-		else if ((min && r == 0) || r == -EAGAIN) {
+		} else if ((min && r == 0) || r == -EAGAIN) {
 			fio_libaio_commit(td);
 			if (actual_min)
 				usleep(10);
@@ -448,7 +472,7 @@ static int fio_libaio_init(struct thread_data *td)
 FIO_STATIC struct ioengine_ops ioengine = {
 	.name			= "libaio",
 	.version		= FIO_IOOPS_VERSION,
-	.flags			= FIO_ASYNCIO_SYNC_TRIM,
+	.flags			= FIO_ASYNCIO_SYNC_TRIM | FIO_ZONE_APPEND,
 	.init			= fio_libaio_init,
 	.post_init		= fio_libaio_post_init,
 	.prep			= fio_libaio_prep,
-- 
2.17.1


