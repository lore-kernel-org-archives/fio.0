Return-Path: <prvs=7737e5e80=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 5/5] zbd: Use bytes unit
Date: Thu, 30 Aug 2018 13:15:31 +0900
Message-Id: <20180830041531.20963-6-damien.lemoal@wdc.com>
In-Reply-To: <20180830041531.20963-1-damien.lemoal@wdc.com>
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Simplify zbd.c code by using byte unit for the zone information values
instead of 512B sector count. Doing so, many 9 bits shifts operation
are removed and code readability improved.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 120 +++++++++++++++++++++++++++++-----------------------------
 1 file changed, 59 insertions(+), 61 deletions(-)

diff --git a/zbd.c b/zbd.c
index 3aea8052..3d0054aa 100644
--- a/zbd.c
+++ b/zbd.c
@@ -34,7 +34,7 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 	if (f->zbd_info->zone_size_log2 > 0)
 		zone_idx = offset >> f->zbd_info->zone_size_log2;
 	else
-		zone_idx = (offset >> 9) / f->zbd_info->zone_size;
+		zone_idx = offset / f->zbd_info->zone_size;
 
 	return min(zone_idx, f->zbd_info->nr_zones);
 }
@@ -53,7 +53,7 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 	assert((required & 511) == 0);
 
 	return z->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
-		z->wp + (required >> 9) > z->start + f->zbd_info->zone_size;
+		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
 static bool is_valid_offset(const struct fio_file *f, uint64_t offset)
@@ -121,8 +121,8 @@ static bool zbd_verify_sizes(void)
 				continue;
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
-			if (f->file_offset != (z->start << 9)) {
-				new_offset = (z+1)->start << 9;
+			if (f->file_offset != z->start) {
+				new_offset = (z+1)->start;
 				if (new_offset >= f->file_offset + f->io_size) {
 					log_info("%s: io_size must be at least one zone\n",
 						 f->file_name);
@@ -136,7 +136,7 @@ static bool zbd_verify_sizes(void)
 			}
 			zone_idx = zbd_zone_idx(f, f->file_offset + f->io_size);
 			z = &f->zbd_info->zone_info[zone_idx];
-			new_end = z->start << 9;
+			new_end = z->start;
 			if (f->file_offset + f->io_size != new_end) {
 				if (new_end <= f->file_offset) {
 					log_info("%s: io_size must be at least one zone\n",
@@ -168,10 +168,10 @@ static bool zbd_verify_bs(void)
 			zone_size = f->zbd_info->zone_size;
 			for (k = 0; k < ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
-				    (zone_size << 9) % td->o.bs[k] != 0) {
+				    zone_size % td->o.bs[k] != 0) {
 					log_info("%s: block size %llu is not a divisor of the zone size %d\n",
 						 f->file_name, td->o.bs[k],
-						 zone_size << 9);
+						 zone_size);
 					return false;
 				}
 			}
@@ -273,9 +273,9 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	pthread_mutexattr_t attr;
 	int i;
 
-	zone_size = td->o.zone_size >> 9;
+	zone_size = td->o.zone_size;
 	assert(zone_size);
-	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
 	if (!zbd_info)
@@ -300,7 +300,7 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) + 9 : -1;
+		ilog2(zone_size) : -1;
 	f->zbd_info->nr_zones = nr_zones;
 	pthread_mutexattr_destroy(&attr);
 	return 0;
@@ -351,20 +351,20 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		goto close;
 	}
 	z = (void *)(hdr + 1);
-	zone_size = z->len;
-	nr_zones = ((f->real_file_size >> 9) + zone_size - 1) / zone_size;
+	zone_size = z->len << 9;
+	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 
 	if (td->o.zone_size == 0) {
-		td->o.zone_size = zone_size << 9;
-	} else if (td->o.zone_size != zone_size << 9) {
+		td->o.zone_size = zone_size;
+	} else if (td->o.zone_size != zone_size) {
 		log_info("fio: %s job parameter zonesize %lld does not match disk zone size %ld.\n",
-			 f->file_name, td->o.zone_size, zone_size << 9);
+			 f->file_name, td->o.zone_size, zone_size);
 		ret = -EINVAL;
 		goto close;
 	}
 
 	dprint(FD_ZBD, "Device %s has %d zones of size %lu KB\n", f->file_name,
-	       nr_zones, zone_size / 2);
+	       nr_zones, zone_size / 1024);
 
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -378,18 +378,18 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		z = (void *)(hdr + 1);
 		for (i = 0; i < hdr->nr_zones; i++, j++, z++, p++) {
 			pthread_mutex_init(&p->mutex, &attr);
-			p->start = z->start;
+			p->start = z->start << 9;
 			switch (z->cond) {
 			case BLK_ZONE_COND_NOT_WP:
-				p->wp = z->start;
+				p->wp = p->start;
 				break;
 			case BLK_ZONE_COND_FULL:
-				p->wp = z->start + zone_size;
+				p->wp = p->start + zone_size;
 				break;
 			default:
 				assert(z->start <= z->wp);
-				assert(z->wp <= z->start + zone_size);
-				p->wp = z->wp;
+				assert(z->wp <= z->start + (zone_size >> 9));
+				p->wp = z->wp << 9;
 				break;
 			}
 			p->type = z->type;
@@ -413,12 +413,12 @@ static int parse_zone_info(struct thread_data *td, struct fio_file *f)
 		}
 	}
 	/* a sentinel */
-	zbd_info->zone_info[nr_zones].start = start_sector;
+	zbd_info->zone_info[nr_zones].start = start_sector << 9;
 
 	f->zbd_info = zbd_info;
 	f->zbd_info->zone_size = zone_size;
 	f->zbd_info->zone_size_log2 = is_power_of_2(zone_size) ?
-		ilog2(zone_size) + 9 : -1;
+		ilog2(zone_size) : -1;
 	f->zbd_info->nr_zones = nr_zones;
 	zbd_info = NULL;
 	ret = 0;
@@ -556,18 +556,18 @@ int zbd_init(struct thread_data *td)
  * Returns 0 upon success and a negative error code upon failure.
  */
 static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
-			   uint64_t sector, uint64_t nr_sectors)
+			   uint64_t offset, uint64_t length)
 {
 	struct blk_zone_range zr = {
-		.sector         = sector,
-		.nr_sectors     = nr_sectors,
+		.sector         = offset >> 9,
+		.nr_sectors     = length >> 9,
 	};
 	uint32_t zone_idx_b, zone_idx_e;
 	struct fio_zone_info *zb, *ze, *z;
 	int ret = 0;
 
 	assert(f->fd != -1);
-	assert(is_valid_offset(f, ((sector + nr_sectors) << 9) - 1));
+	assert(is_valid_offset(f, offset + length - 1));
 	switch (f->zbd_info->model) {
 	case ZBD_DM_HOST_AWARE:
 	case ZBD_DM_HOST_MANAGED:
@@ -583,9 +583,9 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 		break;
 	}
 
-	zone_idx_b = zbd_zone_idx(f, sector << 9);
+	zone_idx_b = zbd_zone_idx(f, offset);
 	zb = &f->zbd_info->zone_info[zone_idx_b];
-	zone_idx_e = zbd_zone_idx(f, (sector + nr_sectors) << 9);
+	zone_idx_e = zbd_zone_idx(f, offset + length);
 	ze = &f->zbd_info->zone_info[zone_idx_e];
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
@@ -635,7 +635,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const ze, bool all_zones)
 {
 	struct fio_zone_info *z, *start_z = ze;
-	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE] >> 9;
+	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 	bool reset_wp;
 	int res = 0;
 
@@ -921,7 +921,7 @@ struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	/* Both z->mutex and f->zbd_info->mutex are held. */
 
 examine_zone:
-	if ((z->wp << 9) + min_bs <= ((z+1)->start << 9)) {
+	if (z->wp + min_bs <= (z+1)->start) {
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		goto out;
 	}
@@ -938,12 +938,12 @@ examine_zone:
 		zone_idx++;
 		pthread_mutex_unlock(&z->mutex);
 		z++;
-		if (!is_valid_offset(f, z->start << 9)) {
+		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
 			zone_idx = zbd_zone_idx(f, f->file_offset);
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
-		assert(is_valid_offset(f, z->start << 9));
+		assert(is_valid_offset(f, z->start));
 		pthread_mutex_lock(&z->mutex);
 		if (z->open)
 			continue;
@@ -963,7 +963,7 @@ examine_zone:
 		z = &f->zbd_info->zone_info[zone_idx];
 
 		pthread_mutex_lock(&z->mutex);
-		if ((z->wp << 9) + min_bs <= ((z+1)->start << 9))
+		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
 	}
@@ -976,7 +976,7 @@ examine_zone:
 out:
 	dprint(FD_ZBD, "%s(%s): returning zone %d\n", __func__, f->file_name,
 	       zone_idx);
-	io_u->offset = z->start << 9;
+	io_u->offset = z->start;
 	return z;
 }
 
@@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	if (z->verify_block * min_bs >= f->zbd_info->zone_size)
 		log_err("%s: %d * %d >= %ld\n", f->file_name, z->verify_block,
 			min_bs, f->zbd_info->zone_size);
-	io_u->offset = (z->start << 9) + z->verify_block++ * min_bs;
+	io_u->offset = z->start + z->verify_block++ * min_bs;
 	return z;
 }
 
@@ -1026,7 +1026,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 	for (z1 = zb + 1, z2 = zb - 1; z1 < zl || z2 >= zf; z1++, z2--) {
 		if (z1 < zl && z1->cond != BLK_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z1->mutex);
-			if (z1->start + (min_bs >> 9) <= z1->wp)
+			if (z1->start + min_bs <= z1->wp)
 				return z1;
 			pthread_mutex_unlock(&z1->mutex);
 		} else if (!td_random(td)) {
@@ -1035,7 +1035,7 @@ zbd_find_zone(struct thread_data *td, struct io_u *io_u,
 		if (td_random(td) && z2 >= zf &&
 		    z2->cond != BLK_ZONE_COND_OFFLINE) {
 			pthread_mutex_lock(&z2->mutex);
-			if (z2->start + (min_bs >> 9) <= z2->wp)
+			if (z2->start + min_bs <= z2->wp)
 				return z2;
 			pthread_mutex_unlock(&z2->mutex);
 		}
@@ -1066,7 +1066,7 @@ static void zbd_post_submit(const struct io_u *io_u, bool success)
 		return;
 
 	zone_idx = zbd_zone_idx(io_u->file, io_u->offset);
-	end = (io_u->offset + io_u->buflen) >> 9;
+	end = io_u->offset + io_u->buflen;
 	z = &zbd_info->zone_info[zone_idx];
 	assert(zone_idx < zbd_info->nr_zones);
 	if (z->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
@@ -1157,17 +1157,17 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * hit the medium.
 		 */
 		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
-			((zb->wp - zb->start) << 9) - io_u->buflen : -1;
+			zb->wp - zb->start - io_u->buflen : -1;
 		if (td_random(td) && range >= 0) {
-			io_u->offset = (zb->start << 9) +
-				((io_u->offset - (zb->start << 9)) %
+			io_u->offset = zb->start +
+				((io_u->offset - zb->start) %
 				 (range + 1)) / min_bs * min_bs;
-			assert(zb->start << 9 <= io_u->offset);
-			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
+			assert(zb->start <= io_u->offset);
+			assert(io_u->offset + io_u->buflen <= zb->wp);
 			goto accept;
 		}
 		if (zb->cond == BLK_ZONE_COND_OFFLINE ||
-		    (io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+		    io_u->offset + io_u->buflen > zb->wp) {
 			struct fio_zone_info *orig_zb = zb;
 
 			pthread_mutex_unlock(&zb->mutex);
@@ -1187,32 +1187,30 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			 * size. Handle this case here and also make sure that
 			 * the I/O does not the cross the zone wp.
 			 */
-			range = ((zb->wp - zb->start) << 9) / min_bs * min_bs;
+			range = (zb->wp - zb->start) / min_bs * min_bs;
 			if ((!td_random(td)) || range <= io_u->buflen) {
-				io_u->offset = zb->start << 9;
+				io_u->offset = zb->start;
 			} else {
-				zofst = ((io_u->offset - (orig_zb->start << 9)) %
+				zofst = ((io_u->offset - orig_zb->start) %
 					 range) / min_bs * min_bs;
 				if (zofst >= range)
 					io_u->offset =
-						((zb->wp << 9) / min_bs - 1) *
-						min_bs;
+						(zb->wp / min_bs - 1) * min_bs;
 				else
-					io_u->offset = (zb->start << 9) + zofst;
+					io_u->offset = zb->start + zofst;
 			}
 			new_len = min((unsigned long long)io_u->buflen,
-				      (unsigned long long)(zb->wp << 9) -
-				      io_u->offset);
+				      (unsigned long long)zb->wp - io_u->offset);
 			new_len = new_len / min_bs * min_bs;
 			if (new_len < io_u->buflen) {
 				io_u->buflen = new_len;
 				dprint(FD_IO, "Changed length from %u into %llu\n",
 				       orig_len, io_u->buflen);
 			}
-			assert(zb->start << 9 <= io_u->offset);
-			assert(io_u->offset + io_u->buflen <= zb->wp << 9);
+			assert(zb->start <= io_u->offset);
+			assert(io_u->offset + io_u->buflen <= zb->wp);
 		}
-		if ((io_u->offset + io_u->buflen) >> 9 > zb->wp) {
+		if (io_u->offset + io_u->buflen > zb->wp) {
 			dprint(FD_ZBD, "%s: %lld + %lld > %" PRIu64 "\n",
 			       f->file_name, io_u->offset, io_u->buflen,
 			       zb->wp);
@@ -1220,7 +1218,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		goto accept;
 	case DDIR_WRITE:
-		if (io_u->buflen > (f->zbd_info->zone_size << 9))
+		if (io_u->buflen > f->zbd_info->zone_size)
 			goto eof;
 		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
 			pthread_mutex_unlock(&zb->mutex);
@@ -1232,7 +1230,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
 			check_swd(td, f);
-			if ((f->zbd_info->sectors_with_data << 9) >=
+			if (f->zbd_info->sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone = 1;
@@ -1256,7 +1254,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Make writes occur at the write pointer */
 		assert(!zbd_zone_full(f, zb, min_bs));
-		io_u->offset = zb->wp << 9;
+		io_u->offset = zb->wp;
 		if (!is_valid_offset(f, io_u->offset)) {
 			dprint(FD_ZBD, "Dropped request with offset %llu\n",
 			       io_u->offset);
@@ -1268,7 +1266,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * small.
 		 */
 		new_len = min((unsigned long long)io_u->buflen,
-			      ((zb + 1)->start << 9) - io_u->offset);
+			      (zb + 1)->start - io_u->offset);
 		new_len = new_len / min_bs * min_bs;
 		if (new_len == io_u->buflen)
 			goto accept;
@@ -1279,7 +1277,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			goto accept;
 		}
 		log_err("Zone remainder %lld smaller than minimum block size %d\n",
-			(((zb + 1)->start << 9) - io_u->offset),
+			((zb + 1)->start - io_u->offset),
 			min_bs);
 		goto eof;
 	case DDIR_TRIM:
-- 
2.17.1


