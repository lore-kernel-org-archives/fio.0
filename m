Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 04/38] zbd: introduce zone_unlock()
Date: Wed, 27 Jan 2021 13:19:11 +0900
Message-Id: <20210127041945.36909-5-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

ZBD code already defines a helper function to lock a device zone,
zone_lock(). There is no zone_unlock() function though.

Wrap zone mutex unlock to zone_unlock() helper along with an assert
to make sure that the unlock is successful, i.e. that the function
is being called with the pointer to a locked zone.

Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/zbd.c b/zbd.c
index d69061ea..a834f94c 100644
--- a/zbd.c
+++ b/zbd.c
@@ -199,6 +199,14 @@ static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zon
 	}
 }
 
+static inline void zone_unlock(struct fio_zone_info *z)
+{
+	int ret;
+
+	ret = pthread_mutex_unlock(&z->mutex);
+	assert(!ret);
+}
+
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
 {
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
@@ -821,7 +829,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			if (zbd_reset_zone(td, f, z) < 0)
 				res = 1;
 		}
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 	}
 
 	return res;
@@ -892,7 +900,7 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	for (z = zb; z < ze; z++)
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 
 	return swd;
 }
@@ -1102,7 +1110,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 		return NULL;
 
 found_candidate_zone:
@@ -1111,7 +1119,7 @@ found_candidate_zone:
 			break;
 		zone_idx = new_zone_idx;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 	}
 
 	/* Both z->mutex and f->zbd_info->mutex are held. */
@@ -1148,7 +1156,7 @@ open_other_zone:
 	/* Zone 'z' is full, so try to open a new zone. */
 	for (i = f->io_size / f->zbd_info->zone_size; i > 0; i--) {
 		zone_idx++;
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 		z++;
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
@@ -1172,7 +1180,7 @@ open_other_zone:
 		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
 			continue;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 
 		z = get_zone(f, zone_idx);
 
@@ -1182,7 +1190,7 @@ open_other_zone:
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
-	pthread_mutex_unlock(&z->mutex);
+	zone_unlock(z);
 	dprint(FD_ZBD, "%s(%s): did not open another zone\n", __func__,
 	       f->file_name);
 	return NULL;
@@ -1203,7 +1211,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
 	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
 	}
@@ -1241,7 +1249,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 			zone_lock(td, f, z1);
 			if (z1->start + min_bs <= z1->wp)
 				return z1;
-			pthread_mutex_unlock(&z1->mutex);
+			zone_unlock(z1);
 		} else if (!td_random(td)) {
 			break;
 		}
@@ -1250,7 +1258,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 			zone_lock(td, f, z2);
 			if (z2->start + min_bs <= z2->wp)
 				return z2;
-			pthread_mutex_unlock(&z2->mutex);
+			zone_unlock(z2);
 		}
 	}
 	dprint(FD_ZBD, "%s: adjusting random read offset failed\n",
@@ -1342,7 +1350,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 unlock:
 	if (!success || q != FIO_Q_QUEUED) {
 		/* BUSY or COMPLETED: unlock the zone */
-		pthread_mutex_unlock(&z->mutex);
+		zone_unlock(z);
 		io_u->zbd_put_io = NULL;
 	}
 }
@@ -1357,7 +1365,6 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 	struct zoned_block_device_info *zbd_info = f->zbd_info;
 	struct fio_zone_info *z;
 	uint32_t zone_idx;
-	int ret;
 
 	if (!zbd_info)
 		return;
@@ -1375,8 +1382,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 
 	zbd_end_zone_io(td, io_u, z);
 
-	ret = pthread_mutex_unlock(&z->mutex);
-	assert(ret == 0);
+	zone_unlock(z);
 	zbd_check_swd(f);
 }
 
@@ -1551,7 +1557,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_READ:
 		if (td->runstate == TD_VERIFYING && td_write(td)) {
 			zb = zbd_replay_write_order(td, io_u, zb);
-			pthread_mutex_unlock(&zb->mutex);
+			zone_unlock(zb);
 			goto accept;
 		}
 		/*
@@ -1563,7 +1569,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->wp - zb->start : 0;
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
-			pthread_mutex_unlock(&zb->mutex);
+			zone_unlock(zb);
 			zl = get_zone(f, f->max_zone);
 			zb = zbd_find_zone(td, io_u, zb, zl);
 			if (!zb) {
@@ -1611,7 +1617,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (io_u->buflen > f->zbd_info->zone_size)
 			goto eof;
 		if (!zbd_open_zone(td, f, zone_idx_b)) {
-			pthread_mutex_unlock(&zb->mutex);
+			zone_unlock(zb);
 			zb = zbd_convert_to_open_zone(td, io_u);
 			if (!zb)
 				goto eof;
@@ -1699,7 +1705,7 @@ accept:
 
 eof:
 	if (zb)
-		pthread_mutex_unlock(&zb->mutex);
+		zone_unlock(zb);
 	return io_u_eof;
 }
 
-- 
2.28.0


