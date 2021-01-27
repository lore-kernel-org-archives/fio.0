Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 10/38] zbd: do not lock conventional zones on I/O adjustment
Date: Wed, 27 Jan 2021 13:19:17 +0900
Message-Id: <20210127041945.36909-11-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When a random workload runs against write pointer zones, I/Os are
adjusted to meet write pointer restrictions. During read, I/O offsets
are adjusted to point to zones with data to read and during write, I/O
offsets are adjusted to be at write pointers of open zones.

However, when a random workload runs in a range that contains both
write pointer zones and conventional zones, I/Os to write pointer
zones can potentially be adjusted to conventional zones. The functions
zbd_find_zone() and zbd_convert_to_open_zone() search for zones
regardless of their type, and therefore they may return conventional
zones. These functions lock the found zone to guard its open status
and write pointer position, but this lock is meaningless for
conventional zones. This unwanted lock of conventional zones has been
observed to cause a deadlock.

Furthermore, zbd_convert_to_open_zone() may add the found conventional
zone to the array of open zones. However, conventional zones should
never be added to the array of open zones as conventional zones never
take the "implicit open" condition and not counted as part of the
device open zone management.

To avoid the deadlock, modify zbd_find_zone() not to lock zone when it
checks conventional zone without write pointer. To avoid the deadlock
and the conventional zone open, modify zbd_convert_to_open_zone() to
ignore conventional zones.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/zbd.c b/zbd.c
index 1ac1357b..a14e4a38 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1033,7 +1033,8 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
- * necessary. This algorithm can only work correctly if all write pointers are
+ * necessary. The open zone is searched across sequential zones.
+ * This algorithm can only work correctly if all write pointers are
  * a multiple of the fio block size. The caller must neither hold z->mutex
  * nor f->zbd_info->mutex. Returns with z->mutex held upon success.
  */
@@ -1159,7 +1160,8 @@ open_other_zone:
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
 		zone_idx++;
-		zone_unlock(z);
+		if (z->has_wp)
+			zone_unlock(z);
 		z++;
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
@@ -1167,6 +1169,8 @@ open_other_zone:
 			z = get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
+		if (!z->has_wp)
+			continue;
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
@@ -1202,6 +1206,7 @@ out:
 	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
 	       zone_idx);
 	io_u->offset = z->start;
+	assert(z->has_wp);
 	assert(z->cond != ZBD_ZONE_COND_OFFLINE);
 	return z;
 }
@@ -1228,12 +1233,12 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 }
 
 /*
- * Find another zone for which @io_u fits below the write pointer. Start
- * searching in zones @zb + 1 .. @zl and continue searching in zones
- * @zf .. @zb - 1.
+ * Find another zone for which @io_u fits in the readable data in the zone.
+ * Search in zones @zb + 1 .. @zl. For random workload, also search in zones
+ * @zb - 1 .. @zf.
  *
- * Either returns NULL or returns a zone pointer and holds the mutex for that
- * zone.
+ * Either returns NULL or returns a zone pointer. When the zone has write
+ * pointer, hold the mutex for the zone.
  */
 static struct fio_zone_info *
 zbd_find_zone(struct thread_data *td, struct io_u *io_u,
@@ -1250,19 +1255,23 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	 */
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, f, z1);
+			if (z1->has_wp)
+				zone_lock(td, f, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
-			zone_unlock(z1);
+			if (z1->has_wp)
+				zone_unlock(z1);
 		} else if (!td_random(td)) {
 			break;
 		}
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != ZBD_ZONE_COND_OFFLINE) {
-			zone_lock(td, f, z2);
+			if (z2->has_wp)
+				zone_lock(td, f, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
-			zone_unlock(z2);
+			if (z2->has_wp)
+				zone_unlock(z2);
 		}
 	}
 	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
-- 
2.28.0


