Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 11/15] zbd: do not set zbd handlers for conventional zones
Date: Sat, 21 Nov 2020 11:45:28 +0900
Message-Id: <20201121024532.16834-12-dmitry.fomichev@wdc.com>
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

When zbd_adjust_block() modifies io_u to satisfy write pointer
restrictions, it may change the zone for the io_u. The function sets
pointers to zbd_queue_io() and zbd_put_io() handlers to io_u to
further process write pointer zones. However, when the I/O is
redirected to a conventional zone, these handlers should not
be set in io_u.

Skip setting the handlers when this function returns a conventional
zone. When zbd_adjust_block() can not find a zone to fit the I/O,
the existing code unlocks the zone pointer 'zb' used in the function.
This unlock should not be performed if 'zb' points to a conventional
zone upon return, skip it in this case.

These changes make the assert for 'zb' pointer near 'accept' label in
zbd_adjust_block() unnecessary. Replace it with assert for zb->has_wp,
since the zone at the step shall have write pointer.

Since zone locking functions (zone_lock(), zbd_queue_io() and
zbd_put_io()) are supposed to be called only for write pointer zones,
add assertions to zone_lock() and zone_unlock() to make sure this is
the case. This allows us to convert a few existing conditional checks
to assertions and therefore make zone type validation more strict.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/zbd.c b/zbd.c
index 3473be8d..a99b6b2f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -174,6 +174,8 @@ static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zon
 	/* A thread should never lock zones outside its working area. */
 	assert(f->min_zone <= nz && nz < f->max_zone);
 
+	assert(z->has_wp);
+
 	/*
 	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
 	 * is changed or when io_u completes and zbd_put_io() executed.
@@ -194,6 +196,7 @@ static inline void zone_unlock(struct fio_zone_info *z)
 {
 	int ret;
 
+	assert(z->has_wp);
 	ret = pthread_mutex_unlock(&z->mutex);
 	assert(!ret);
 }
@@ -1326,8 +1329,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 	assert(zone_idx < zbd_info->nr_zones);
 	z = get_zone(f, zone_idx);
 
-	if (!z->has_wp)
-		return;
+	assert(z->has_wp);
 
 	if (!success)
 		goto unlock;
@@ -1386,8 +1388,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	assert(zone_idx < zbd_info->nr_zones);
 	z = get_zone(f, zone_idx);
 
-	if (!z->has_wp)
-		return;
+	assert(z->has_wp);
 
 	dprint(FD_ZBD,
 	       "%s: terminate I/O (%lld, %llu) for zone %u\n",
@@ -1617,6 +1618,12 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			io_u->offset = zb->start +
 				((io_u->offset - orig_zb->start) %
 				 (range - io_u->buflen)) / min_bs * min_bs;
+		/*
+		 * When zbd_find_zone() returns a conventional zone,
+		 * we can simply accept the new i/o offset here.
+		 */
+		if (!zb->has_wp)
+			return io_u_accept;
 		/*
 		 * Make sure the I/O does not cross over the zone wp position.
 		 */
@@ -1713,7 +1720,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(false);
 
 accept:
-	assert(zb);
+	assert(zb->has_wp);
 	assert(zb->cond != ZBD_ZONE_COND_OFFLINE);
 	assert(!io_u->zbd_queue_io);
 	assert(!io_u->zbd_put_io);
@@ -1722,7 +1729,7 @@ accept:
 	return io_u_accept;
 
 eof:
-	if (zb)
+	if (zb && zb->has_wp)
 		zone_unlock(zb);
 	return io_u_eof;
 }
-- 
2.21.0


