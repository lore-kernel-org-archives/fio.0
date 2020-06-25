Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 3/4] iouring: support for Zone Append command
Date: Thu, 25 Jun 2020 23:08:51 +0530
Message-Id: <1593106733-19596-4-git-send-email-krish.reddy@samsung.com>
In-Reply-To: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174131epcas5p36cf7cd413dcb698f117474df71e5648b@epcas5p3.samsung.com>
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
 engines/io_uring.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index cd0810f..cb7c5ba 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -251,7 +251,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 			sqe->ioprio = td->o.ioprio_class << 13;
 		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
-		sqe->off = io_u->offset;
+		if (td->o.zone_append && io_u->ddir == DDIR_WRITE)
+			sqe->rw_flags |= RWF_ZONE_APPEND;
+		if ((td->o.zone_mode == ZONE_MODE_ZBD)
+		     && td->o.zone_append && io_u->ddir == DDIR_WRITE) {
+			sqe->off = io_u->zone_start_offset;
+		} else
+			sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
 			sqe->off = f->first_write;
@@ -324,6 +330,21 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	ld->cq_ring_off = *ring->head;
 	do {
 		r = fio_ioring_cqring_reap(td, events, max);
+		if (td->o.zone_mode == ZONE_MODE_ZBD) {
+			struct io_uring_cqe *cqe;
+			struct io_u *io_u;
+			unsigned index;
+			for (unsigned event = 0; event < r; event++) {
+				index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
+
+				cqe = &ld->cq_ring.cqes[index];
+				io_u = (struct io_u *) (uintptr_t) cqe->user_data;
+
+				if (td->o.zone_append && td->o.do_verify
+				    && td->o.verify && (io_u->ddir == DDIR_WRITE))
+					io_u->ipo->offset = io_u->zone_start_offset + (cqe->flags << 9);
+			}
+		}
 		if (r) {
 			events += r;
 			if (actual_min != 0)
-- 
2.7.4


