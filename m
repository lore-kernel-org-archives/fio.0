Return-Path: <prvs=8011d1e1c=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Restore check_swd()
Date: Thu, 27 Sep 2018 11:16:48 +0900
Message-Id: <20180927021648.28313-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

As check_swd() is useful for debugging, revert its removal done with
commit d60be7d51cbb ("zbd: Remove unused function and variable").

Fixes: d60be7d51cbb ("zbd: Remove unused function and variable")
Suggested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/zbd.c b/zbd.c
index 9c525875..0b7159a0 100644
--- a/zbd.c
+++ b/zbd.c
@@ -726,6 +726,32 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
+/*
+ * For debugging:
+ * Check whether the value of zbd_info.sectors_with_data is correct.
+ */
+static void check_swd(const struct thread_data *td, const struct fio_file *f)
+{
+#if 0
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t swd;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
+						  f->io_size)];
+	swd = 0;
+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);
+	assert(f->zbd_info->sectors_with_data == swd);
+	pthread_mutex_unlock(&f->zbd_info->mutex);
+	for (z = zb; z < ze; z++)
+		pthread_mutex_unlock(&z->mutex);
+#endif
+}
+
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze, *z;
@@ -1202,6 +1228,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
+			check_swd(td, f);
 			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
@@ -1222,6 +1249,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb->reset_zone = 0;
 			if (zbd_reset_zone(td, f, zb) < 0)
 				goto eof;
+			check_swd(td, f);
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
-- 
2.17.1


