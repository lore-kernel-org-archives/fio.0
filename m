Return-Path: <prvs=35814f3ae=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix potential zone lock deadlock
Date: Mon,  6 Apr 2020 19:51:32 +0900
Message-Id: <20200406105132.1291382-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Commit b27aef6abfba ("zbd: use zone_lock to lock a zone") to fix
potential deadlocks with zonemode=zbd  zone locking was incomplete.
The execution of the zone lock stress test t/zbd test case 48 still
sometimes lead to deadlocks (a large number of repeated execution is
sometimes needed).

The remaining deadlock pattern identified with the repeated execution
of this test is due to the concurrent execution of jobs doing random
async writes to zones. In such case, any of the job may trigger an all
zone reset through the path get_next_rand_block() -> fio_file_reset()
while async writes are still inflight. The fix for this is to use the
zone_lock() function instead of directly calling pthread_mutex_lock()i
to ensure that no async IO is inflight for a zone that is part of a
reset range.

Suggested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 60 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/zbd.c b/zbd.c
index 0dd5a619..d12d6a7a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -58,6 +58,24 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
+static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
+{
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&z->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&z->mutex);
+	}
+}
+
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
 {
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
@@ -716,18 +734,18 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		if (z->type == BLK_ZONE_TYPE_SEQWRITE_REQ) {
-			reset_wp = all_zones ? z->wp != z->start :
-					(td->o.td_ddir & TD_DDIR_WRITE) &&
-					z->wp % min_bs != 0;
-			if (reset_wp) {
-				dprint(FD_ZBD, "%s: resetting zone %u\n",
-				       f->file_name,
-				       zbd_zone_nr(f->zbd_info, z));
-				if (zbd_reset_zone(td, f, z) < 0)
-					res = 1;
-			}
+		if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+			continue;
+		zone_lock(td, z);
+		reset_wp = all_zones ? z->wp != z->start :
+				(td->o.td_ddir & TD_DDIR_WRITE) &&
+				z->wp % min_bs != 0;
+		if (reset_wp) {
+			dprint(FD_ZBD, "%s: resetting zone %u\n",
+			       f->file_name,
+			       zbd_zone_nr(f->zbd_info, z));
+			if (zbd_reset_zone(td, f, z) < 0)
+				res = 1;
 		}
 		pthread_mutex_unlock(&z->mutex);
 	}
@@ -927,24 +945,6 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
-static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
-{
-	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
-	 */
-	if (pthread_mutex_trylock(&z->mutex) != 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&z->mutex);
-	}
-}
-
 /* Anything goes as long as it is not a constant. */
 static uint32_t pick_random_zone_idx(const struct fio_file *f,
 				     const struct io_u *io_u)
-- 
2.25.1


