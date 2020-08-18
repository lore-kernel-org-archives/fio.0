Return-Path: <prvs=492287be1=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH] zbd: remove reset_zone flag from fio_zone_info
Date: Tue, 18 Aug 2020 09:02:50 +0900
Message-Id: <20200818000250.20820-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The reset_zone flag that is defined in fio_zone_info structure is
only referenced in zbd_adjust_block() function. Convert this flag
to a local variable and save some room in zbd_info array which can
be pretty large when running fio against high capacity zoned devices.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 7 ++++---
 zbd.h | 2 --
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index 5af8af4a..a7a48d27 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1438,6 +1438,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	uint64_t new_len;
 	int64_t range;
+	bool reset_zone;
 
 	if (!f->zbd_info)
 		return io_u_accept;
@@ -1536,15 +1537,16 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zone_idx_b = zb - f->zbd_info->zone_info;
 		}
 		/* Check whether the zone reset threshold has been exceeded */
+		reset_zone = false;
 		if (td->o.zrf.u.f) {
 			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
-				zb->reset_zone = 1;
+				reset_zone = true;
 			}
 		}
 		/* Reset the zone pointer if necessary */
-		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
+		if (reset_zone || zbd_zone_full(f, zb, min_bs)) {
 			assert(td->o.verify == VERIFY_NONE);
 			/*
 			 * Since previous write requests may have been submitted
@@ -1554,7 +1556,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			 * zone reset.
 			 */
 			io_u_quiesce(td);
-			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
 
diff --git a/zbd.h b/zbd.h
index 021174c1..fe04d4ad 100644
--- a/zbd.h
+++ b/zbd.h
@@ -30,7 +30,6 @@ enum io_u_action {
  * @cond: zone state (BLK_ZONE_COND_*)
  * @open: whether or not this zone is currently open. Only relevant if
  *		max_open_zones > 0.
- * @reset_zone: whether or not this zone should be reset before writing to it
  */
 struct fio_zone_info {
 	pthread_mutex_t		mutex;
@@ -41,7 +40,6 @@ struct fio_zone_info {
 	enum zbd_zone_type	type:2;
 	enum zbd_zone_cond	cond:4;
 	unsigned int		open:1;
-	unsigned int		reset_zone:1;
 };
 
 /**
-- 
2.21.0


