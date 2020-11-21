Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 03/15] zbd: add get_zone() helper function
Date: Sat, 21 Nov 2020 11:45:20 +0900
Message-Id: <20201121024532.16834-4-dmitry.fomichev@wdc.com>
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The following pattern is widely used in zbd.c -

zone = &f->zbd_info->zone_info[zone_idx] .

For the sake of code clarity, wrap this construct into an inline
helper. No change in functionality.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/zbd.c b/zbd.c
index 841427e7..be3b554d 100644
--- a/zbd.c
+++ b/zbd.c
@@ -204,6 +204,12 @@ static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
 	return (uint64_t)(offset - f->file_offset) < f->io_size;
 }
 
+static inline struct fio_zone_info *get_zone(const struct fio_file *f,
+					     unsigned int zone_nr)
+{
+	return &f->zbd_info->zone_info[zone_nr];
+}
+
 /* Verify whether direct I/O is used for all host-managed zoned drives. */
 static bool zbd_using_direct_io(void)
 {
@@ -286,7 +292,7 @@ static bool zbd_verify_sizes(void)
 			}
 
 			zone_idx = zbd_zone_idx(f, f->file_offset);
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 			if ((f->file_offset != z->start) &&
 			    (td->o.td_ddir != TD_DDIR_READ)) {
 				new_offset = zbd_zone_end(z);
@@ -302,7 +308,7 @@ static bool zbd_verify_sizes(void)
 				f->file_offset = new_offset;
 			}
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 			new_end = z->start;
 			if ((td->o.td_ddir != TD_DDIR_READ) &&
 			    (f->file_offset + f->io_size != new_end)) {
@@ -769,7 +775,7 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 		sizeof(f->zbd_info->open_zones[0]));
 	f->zbd_info->num_open_zones--;
 	td->num_open_zones--;
-	f->zbd_info->zone_info[zone_idx].open = 0;
+	get_zone(f, zone_idx)->open = 0;
 }
 
 /*
@@ -869,8 +875,8 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
 
-	zb = &f->zbd_info->zone_info[f->min_zone];
-	ze = &f->zbd_info->zone_info[f->max_zone];
+	zb = get_zone(f, f->min_zone);
+	ze = get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
 		swd += z->wp - z->start;
@@ -925,8 +931,8 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	if (!f->zbd_info || !td_write(td))
 		return;
 
-	zb = &f->zbd_info->zone_info[f->min_zone];
-	ze = &f->zbd_info->zone_info[f->max_zone];
+	zb = get_zone(f, f->min_zone);
+	ze = get_zone(f, f->max_zone);
 	zbd_init_swd(f);
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -966,7 +972,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
+	struct fio_zone_info *z = get_zone(f, zone_idx);
 	bool res = true;
 
 	if (z->cond == ZBD_ZONE_COND_OFFLINE)
@@ -1059,7 +1065,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	for (;;) {
 		uint32_t tmp_idx;
 
-		z = &f->zbd_info->zone_info[zone_idx];
+		z = get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1147,7 +1153,7 @@ open_other_zone:
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx = f->min_zone;
-			z = &f->zbd_info->zone_info[zone_idx];
+			z = get_zone(f, zone_idx);
 		}
 		assert(is_valid_offset(f, z->start));
 		zone_lock(td, f, z);
@@ -1168,7 +1174,7 @@ open_other_zone:
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		pthread_mutex_unlock(&z->mutex);
 
-		z = &f->zbd_info->zone_info[zone_idx];
+		z = get_zone(f, zone_idx);
 
 		zone_lock(td, f, z);
 		if (z->wp + min_bs <= zbd_zone_capacity_end(z))
@@ -1224,8 +1230,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
 	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z1, *z2;
-	const struct fio_zone_info *const zf =
-		&f->zbd_info->zone_info[f->min_zone];
+	const struct fio_zone_info *const zf = get_zone(f, f->min_zone);
 
 	/*
 	 * Skip to the next non-empty zone in case of sequential I/O and to
@@ -1298,7 +1303,7 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z = &zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
 	if (!zbd_zone_swr(z))
 		return;
@@ -1359,7 +1364,7 @@ static void zbd_put_io(struct thread_data *td, const struct io_u *io_u)
 
 	zone_idx = zbd_zone_idx(f, io_u->offset);
 	assert(zone_idx < zbd_info->nr_zones);
-	z = &zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
 	if (!zbd_zone_swr(z))
 		return;
@@ -1415,7 +1420,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 	assert(td->o.zone_size);
 
 	zone_idx = zbd_zone_idx(f, f->last_pos[ddir]);
-	z = &f->zbd_info->zone_info[zone_idx];
+	z = get_zone(f, zone_idx);
 
 	/*
 	 * When the zone capacity is smaller than the zone size and the I/O is
@@ -1523,7 +1528,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	assert(is_valid_offset(f, io_u->offset));
 	assert(io_u->buflen);
 	zone_idx_b = zbd_zone_idx(f, io_u->offset);
-	zb = &f->zbd_info->zone_info[zone_idx_b];
+	zb = get_zone(f, zone_idx_b);
 	orig_zb = zb;
 
 	/* Accept the I/O offset for conventional zones. */
@@ -1559,7 +1564,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		if (range < min_bs ||
 		    ((!td_random(td)) && (io_u->offset + min_bs > zb->wp))) {
 			pthread_mutex_unlock(&zb->mutex);
-			zl = &f->zbd_info->zone_info[f->max_zone];
+			zl = get_zone(f, f->max_zone);
 			zb = zbd_find_zone(td, io_u, zb, zl);
 			if (!zb) {
 				dprint(FD_ZBD,
-- 
2.21.0


