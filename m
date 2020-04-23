Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
Date: Fri, 24 Apr 2020 00:38:34 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] zbd: don't lock zones outside working area
Message-ID: <20200423213834.GA22728@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com
List-ID: <fio@vger.kernel.org>

Currently threads tap into each other zones even if their working areas
as defined by [f->file_offset, f->file_offset + f->io_size) don't intersect.

This should remove unnecessary quiescing in iodepth > 1 workloads.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
---

 file.h |    3 +++
 zbd.c  |   42 ++++++++++++++++++++++++++++++++----------
 2 files changed, 35 insertions(+), 10 deletions(-)

--- a/file.h
+++ b/file.h
@@ -104,6 +104,9 @@ struct fio_file {
 	 * Zoned block device information. See also zonemode=zbd.
 	 */
 	struct zoned_block_device_info *zbd_info;
+	/* zonemode=zbd working area */
+	uint32_t min_zone;	/* inclusive */
+	uint32_t max_zone;	/* exclusive */
 
 	/*
 	 * Track last end and last start of IO for a given data direction
--- a/zbd.c
+++ b/zbd.c
@@ -156,8 +156,14 @@ static bool zbd_zone_full(const struct fio_file *f, struct fio_zone_info *z,
 		z->wp + required > z->start + f->zbd_info->zone_size;
 }
 
-static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
+static void zone_lock(struct thread_data *td, struct fio_file *f, struct fio_zone_info *z)
 {
+	struct zoned_block_device_info *zbd = f->zbd_info;
+	uint32_t nz = z - zbd->zone_info;
+
+	/* Thread should never lock zones outside its working area. */
+	assert(f->min_zone <= nz && nz < f->max_zone);
+
 	/*
 	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
 	 * is changed or when io_u completes and zbd_put_io() executed.
@@ -289,6 +295,9 @@ static bool zbd_verify_sizes(void)
 					 (unsigned long long) new_end - f->file_offset);
 				f->io_size = new_end - f->file_offset;
 			}
+
+			f->min_zone = zbd_zone_idx(f, f->file_offset);
+			f->max_zone = zbd_zone_idx(f, f->file_offset + f->io_size);
 		}
 	}
 
@@ -332,6 +341,17 @@ static int ilog2(uint64_t i)
 	return log;
 }
 
+static uint32_t clamp_u32(uint32_t x, uint32_t min, uint32_t max)
+{
+	if (x < min) {
+		return min;
+	} else if (x > max) {
+		return max;
+	} else {
+		return x;
+	}
+}
+
 /*
  * Initialize f->zbd_info for devices that are not zoned block devices. This
  * allows to execute a ZBD workload against a non-ZBD device.
@@ -735,7 +755,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 		if (!zbd_zone_swr(z))
 			continue;
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (all_zones) {
 			unsigned int i;
 
@@ -958,7 +978,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 						      struct io_u *io_u)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
@@ -975,6 +995,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
+	zone_idx = clamp_u32(zone_idx, f->min_zone, f->max_zone - 1);
 	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
 
@@ -989,7 +1010,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		if (td->o.max_open_zones == 0)
 			goto examine_zone;
@@ -1015,8 +1036,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 			if (tmp_idx >= f->zbd_info->num_open_zones)
 				tmp_idx = 0;
 			tmpz = f->zbd_info->open_zones[tmp_idx];
-
-			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {
+			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
 				open_zone_idx = tmp_idx;
 				goto found_candidate_zone;
 			}
@@ -1061,11 +1081,11 @@ examine_zone:
 		z++;
 		if (!is_valid_offset(f, z->start)) {
 			/* Wrap-around. */
-			zone_idx = zbd_zone_idx(f, f->file_offset);
+			zone_idx = f->min_zone;
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
 		assert(is_valid_offset(f, z->start));
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (z->open)
 			continue;
 		if (zbd_open_zone(td, io_u, zone_idx))
@@ -1078,12 +1098,14 @@ examine_zone:
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
 		zone_idx = f->zbd_info->open_zones[i];
+		if (!(f->min_zone <= zone_idx && zone_idx < f->max_zone))
+			continue;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		pthread_mutex_unlock(&z->mutex);
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1409,7 +1431,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	zone_lock(td, zb);
+	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:

