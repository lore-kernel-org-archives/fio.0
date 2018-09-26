Return-Path: <prvs=800592d6e=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] zbd: Remove unused function and variable
Date: Wed, 26 Sep 2018 15:42:26 +0900
Message-Id: <20180926064226.2590-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

check_swd() was defined to nothing. Remove it.
additionally, the variable ret in zbd_reset_zonei() is unused and not
necessary. Remove it too.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 31 ++-----------------------------
 1 file changed, 2 insertions(+), 29 deletions(-)

diff --git a/zbd.c b/zbd.c
index 9c3092ab..9c525875 100644
--- a/zbd.c
+++ b/zbd.c
@@ -620,12 +620,10 @@ static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
 static int zbd_reset_zone(struct thread_data *td, const struct fio_file *f,
 			  struct fio_zone_info *z)
 {
-	int ret;
-
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
 		zbd_zone_nr(f->zbd_info, z));
-	ret = zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
-	return ret;
+
+	return zbd_reset_range(td, f, z->start, (z+1)->start - z->start);
 }
 
 /*
@@ -728,29 +726,6 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-/* Check whether the value of zbd_info.sectors_with_data is correct. */
-static void check_swd(const struct thread_data *td, const struct fio_file *f)
-{
-#if 0
-	struct fio_zone_info *zb, *ze, *z;
-	uint64_t swd;
-
-	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
-						  f->io_size)];
-	swd = 0;
-	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		swd += z->wp - z->start;
-	}
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	assert(f->zbd_info->sectors_with_data == swd);
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-	for (z = zb; z < ze; z++)
-		pthread_mutex_unlock(&z->mutex);
-#endif
-}
-
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
@@ -1227,7 +1202,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			check_swd(td, f);
 			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
@@ -1248,7 +1222,6 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
-			check_swd(td, f);
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
-- 
2.17.1


