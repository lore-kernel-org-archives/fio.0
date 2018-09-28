Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 5/6] zbd: Restore zbd_check_swd()
Date: Fri, 28 Sep 2018 14:51:32 -0700
Message-Id: <20180928215133.35222-6-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

A recent patch removed the check_swd() function. Restore it since this function
is useful when debugging fio. Rename the function into zbd_check_swd(). Insert
the calls to these function where no locks are held to avoid triggering a
deadlock. See also commit d60be7d51cbb ("zbd: Remove unused function and
variable").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/zbd.c b/zbd.c
index aa08b8111534..7728f71d25a5 100644
--- a/zbd.c
+++ b/zbd.c
@@ -726,6 +726,28 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
+/* Check whether the value of zbd_info.sectors_with_data is correct. */
+static void zbd_check_swd(const struct fio_file *f)
+{
+#if 0
+	struct fio_zone_info *zb, *ze, *z;
+	uint64_t swd = 0;
+
+	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
+	ze = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset +
+						  f->io_size)];
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
@@ -1077,6 +1099,8 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 	}
 unlock:
 	pthread_mutex_unlock(&z->mutex);
+
+	zbd_check_swd(io_u->file);
 }
 
 bool zbd_unaligned_write(int error_code)
@@ -1129,6 +1153,8 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	    io_u->ddir == DDIR_READ && td->o.read_beyond_wp)
 		return io_u_accept;
 
+	zbd_check_swd(f);
+
 	pthread_mutex_lock(&zb->mutex);
 	switch (io_u->ddir) {
 	case DDIR_READ:
-- 
2.19.0.605.g01d371f741-goog


