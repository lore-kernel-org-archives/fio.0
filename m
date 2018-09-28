Return-Path: <bvanassche@acm.org>
From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/6] zbd: Avoid duplicating the code for calculating the number of sectors with data
Date: Fri, 28 Sep 2018 14:51:33 -0700
Message-Id: <20180928215133.35222-7-bvanassche@acm.org>
In-Reply-To: <20180928215133.35222-1-bvanassche@acm.org>
References: <20180928215133.35222-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Introduce a new function process_swd() to avoid that almost identical code
occurs in check_swd() and zbd_file_reset(). Change the #if 0 / #endif pair
in check_swd() into if (false) to make sure that the compiler verifies the
syntactical correctness of that code.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 61 +++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 18 deletions(-)

diff --git a/zbd.c b/zbd.c
index 7728f71d25a5..8acda1f62f32 100644
--- a/zbd.c
+++ b/zbd.c
@@ -726,10 +726,14 @@ static bool zbd_dec_and_reset_write_cnt(const struct thread_data *td,
 	return write_cnt == 0;
 }
 
-/* Check whether the value of zbd_info.sectors_with_data is correct. */
-static void zbd_check_swd(const struct fio_file *f)
+enum swd_action {
+	CHECK_SWD,
+	SET_SWD,
+};
+
+/* Calculate the number of sectors with data (swd) and perform action 'a' */
+static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 {
-#if 0
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
 
@@ -741,18 +745,49 @@ static void zbd_check_swd(const struct fio_file *f)
 		swd += z->wp - z->start;
 	}
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	assert(f->zbd_info->sectors_with_data == swd);
+	switch (a) {
+	case CHECK_SWD:
+		assert(f->zbd_info->sectors_with_data == swd);
+		break;
+	case SET_SWD:
+		f->zbd_info->sectors_with_data = swd;
+		break;
+	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	for (z = zb; z < ze; z++)
 		pthread_mutex_unlock(&z->mutex);
-#endif
+
+	return swd;
+}
+
+/*
+ * The swd check is useful for debugging but takes too much time to leave
+ * it enabled all the time. Hence it is disabled by default.
+ */
+static const bool enable_check_swd = false;
+
+/* Check whether the value of zbd_info.sectors_with_data is correct. */
+static void zbd_check_swd(const struct fio_file *f)
+{
+	if (!enable_check_swd)
+		return;
+
+	zbd_process_swd(f, CHECK_SWD);
+}
+
+static void zbd_init_swd(struct fio_file *f)
+{
+	uint64_t swd;
+
+	swd = zbd_process_swd(f, SET_SWD);
+	dprint(FD_ZBD, "%s(%s): swd = %" PRIu64 "\n", __func__, f->file_name,
+	       swd);
 }
 
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_zone_info *zb, *ze, *z;
+	struct fio_zone_info *zb, *ze;
 	uint32_t zone_idx_e;
-	uint64_t swd = 0;
 
 	if (!f->zbd_info)
 		return;
@@ -760,17 +795,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
 	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
 	ze = &f->zbd_info->zone_info[zone_idx_e];
-	for (z = zb ; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
-		swd += z->wp - z->start;
-	}
-	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data = swd;
-	pthread_mutex_unlock(&f->zbd_info->mutex);
-	for (z = zb ; z < ze; z++)
-		pthread_mutex_unlock(&z->mutex);
-	dprint(FD_ZBD, "%s(%s): swd = %llu\n", __func__, f->file_name,
-		(unsigned long long) swd);
+	zbd_init_swd(f);
 	/*
 	 * If data verification is enabled reset the affected zones before
 	 * writing any data to avoid that a zone reset has to be issued while
-- 
2.19.0.605.g01d371f741-goog


