Return-Path: <prvs=470d1383e=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 2/3] zbd: simplify zone reset code
Date: Mon, 27 Jul 2020 12:16:37 +0900
Message-Id: <20200727031638.28264-3-dmitry.fomichev@wdc.com>
In-Reply-To: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
References: <20200727031638.28264-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

zbd_reset_range() function is only called once from zbd_reset_zone()
and it is always called for an individual zone, not a range.

Make zone reset flow simpler by moving all the code needed
to reset a single zone from zbd_reset_range() to zbd_reset_zone().
Therefore, zbd_reset_range() is now dropped.

No functional change.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 76 +++++++++++++++++++++--------------------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/zbd.c b/zbd.c
index 3eac5df3..f6ccf299 100644
--- a/zbd.c
+++ b/zbd.c
@@ -670,54 +670,6 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
 
-/**
- * zbd_reset_range - reset zones for a range of sectors
- * @td: FIO thread data.
- * @f: Fio file for which to reset zones
- * @sector: Starting sector in units of 512 bytes
- * @nr_sectors: Number of sectors in units of 512 bytes
- *
- * Returns 0 upon success and a negative error code upon failure.
- */
-static int zbd_reset_range(struct thread_data *td, struct fio_file *f,
-			   uint64_t offset, uint64_t length)
-{
-	uint32_t zone_idx_b, zone_idx_e;
-	struct fio_zone_info *zb, *ze, *z;
-	int ret = 0;
-
-	assert(is_valid_offset(f, offset + length - 1));
-
-	switch (f->zbd_info->model) {
-	case ZBD_HOST_AWARE:
-	case ZBD_HOST_MANAGED:
-		ret = zbd_reset_wp(td, f, offset, length);
-		if (ret < 0)
-			return ret;
-		break;
-	default:
-		break;
-	}
-
-	zone_idx_b = zbd_zone_idx(f, offset);
-	zb = &f->zbd_info->zone_info[zone_idx_b];
-	zone_idx_e = zbd_zone_idx(f, offset + length);
-	ze = &f->zbd_info->zone_info[zone_idx_e];
-	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		pthread_mutex_lock(&f->zbd_info->mutex);
-		f->zbd_info->sectors_with_data -= z->wp - z->start;
-		pthread_mutex_unlock(&f->zbd_info->mutex);
-		z->wp = z->start;
-		z->verify_block = 0;
-		pthread_mutex_unlock(&z->mutex);
-	}
-
-	td->ts.nr_zone_resets += ze - zb;
-
-	return ret;
-}
-
 static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
 				struct fio_zone_info *zone)
 {
@@ -735,10 +687,36 @@ static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
 static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 			  struct fio_zone_info *z)
 {
+	uint64_t offset = z->start;
+	uint64_t length = (z+1)->start - offset;
+	int ret = 0;
+
+	assert(is_valid_offset(f, offset + length - 1));
+
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, z));
+	switch (f->zbd_info->model) {
+	case ZBD_HOST_AWARE:
+	case ZBD_HOST_MANAGED:
+		ret = zbd_reset_wp(td, f, offset, length);
+		if (ret < 0)
+			return ret;
+		break;
+	default:
+		break;
+	}
 
-	return zbd_reset_range(td, f, z->start, zbd_zone_end(z) - z->start);
+	pthread_mutex_lock(&z->mutex);
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	f->zbd_info->sectors_with_data -= z->wp - z->start;
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	z->wp = z->start;
+	z->verify_block = 0;
+	pthread_mutex_unlock(&z->mutex);
+
+	td->ts.nr_zone_resets++;
+
+	return ret;
 }
 
 /* The caller must hold f->zbd_info->mutex */
-- 
2.21.0


