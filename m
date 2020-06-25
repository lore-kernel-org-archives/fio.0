Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 2/4] libaio: support for Zone Append command
Date: Thu, 25 Jun 2020 23:08:50 +0530
Message-Id: <1593106733-19596-3-git-send-email-krish.reddy@samsung.com>
In-Reply-To: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174129epcas5p304bf58bb381b4b0c39e0ff91b50a23a9@epcas5p3.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

The zone append command uses the write path with offset as
start of the zone. Upon successful completion, multiple of
sectors relative to the zone's start offset, where the data
has been placed is returned.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 engines/libaio.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/engines/libaio.c b/engines/libaio.c
index 398fdf9..4ffe831 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -123,7 +123,13 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (io_u->ddir == DDIR_WRITE) {
-		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if ((td->o.zone_mode == ZONE_MODE_ZBD) && td->o.zone_append) {
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->zone_start_offset);
+		}
+		else
+			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+		if (td->o.zone_append)
+			iocb->aio_rw_flags |= RWF_ZONE_APPEND;
 		if (o->nowait)
 			iocb->aio_rw_flags |= RWF_NOWAIT;
 	} else if (ddir_sync(io_u->ddir))
@@ -228,6 +234,18 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 		} else {
 			r = io_getevents(ld->aio_ctx, actual_min,
 				max, ld->aio_events + events, lt);
+			if (td->o.zone_mode == ZONE_MODE_ZBD) {
+				struct io_event *ev;
+				struct io_u *io_u;
+				for (unsigned event = 0; event < r; event++) {
+					ev = ld->aio_events + event;
+					io_u = container_of(ev->obj, struct io_u, iocb);
+					if (td->o.zone_append
+					    && td->o.do_verify && td->o.verify
+					    && (io_u->ddir == DDIR_WRITE))
+						io_u->ipo->offset = io_u->zone_start_offset + (ev->res2 << 9);
+				}
+			}
 		}
 		if (r > 0)
 			events += r;
-- 
2.7.4


