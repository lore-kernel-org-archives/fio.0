Return-Path: <prvs=8148fed87=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH 1/4] zbd: Add min_bytes argument to zbd_find_zone()
Date: Tue,  6 Jul 2021 09:59:23 +0900
Message-Id: <20210706005926.303890-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
References: <20210706005926.303890-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

The helper function zbd_find_zone() finds a zone with at least
min_bs[DDIR_READ] bytes readable before the zone write pointer. This
patch generalizes this function to allow finding a non-empty zone. To do
so, add the min_bytes argument to specify the minimum readable data of a
zone to filter the search. Specifying 1 to min_bytes then become
equivalent to finding a non-empty zone.

This change will allow to reuse this function to find a suitable zone
for trim I/O.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/zbd.c b/zbd.c
index 04c68dea..f10b3267 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1413,18 +1413,16 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 }
 
 /*
- * Find another zone for which @io_u fits in the readable data in the zone.
- * Search in zones @zb + 1 .. @zl. For random workload, also search in zones
- * @zb - 1 .. @zf.
+ * Find another zone which has @min_bytes readable data. Search in zones
+ * @zb + 1 .. @zl. For random workload, also search in zones @zb - 1 .. @zf.
  *
  * Either returns NULL or returns a zone pointer. When the zone has write
  * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
-zbd_find_zone(struct thread_data *td, struct io_u *io_u,
+zbd_find_zone(struct thread_data *td, struct io_u *io_u, uint32_t min_bytes,
 	      struct fio_zone_info *zb, struct fio_zone_info *zl)
 {
-	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
 	const struct fio_zone_info *const zf = get_zone(f, f->min_zone);
@@ -1437,7 +1435,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
 			if (z1->has_wp)
 				zone_lock(td, f, z1);
-			if (z1->start + min_bs <= z1->wp)
+			if (z1->start + min_bytes <= z1->wp)
 				return z1;
 			if (z1->has_wp)
 				zone_unlock(z1);
@@ -1448,14 +1446,14 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
 			if (z2->has_wp)
 				zone_lock(td, f, z2);
-			if (z2->start + min_bs <= z2->wp)
+			if (z2->start + min_bytes <= z2->wp)
 				return z2;
 			if (z2->has_wp)
 				zone_unlock(z2);
 		}
 	}
-	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
-	       f->file_name);
+	dprint(FD_ZBD, "%s: no zone has %d bytes readable data\n",
+	       f->file_name, min_bytes);
 	return NULL;
 }
 
@@ -1784,7 +1782,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			zone_unlock(zb);
 			zl = get_zone(f, f->max_zone);
-			zb = zbd_find_zone(td, io_u, zb, zl);
+			zb = zbd_find_zone(td, io_u, min_bs, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
 				       "%s: zbd_find_zone(%lld, %llu) failed\n",
-- 
2.31.1


