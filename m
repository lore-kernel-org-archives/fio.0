Return-Path: <adobriyan@gmail.com>
Return-Path: <adobriyan@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 3/9] zbd: don't lock zones outside working area
Date: Tue,  5 May 2020 20:56:29 +0300
Message-Id: <20200505175634.2517-3-adobriyan@gmail.com>
In-Reply-To: <20200505175634.2517-1-adobriyan@gmail.com>
References: <20200505175634.2517-1-adobriyan@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, damien.lemoal@wdc.com, Alexey Dobriyan <adobriyan@gmail.com>
List-ID: <fio@vger.kernel.org>

Currently threads lock each other zones even if their working areas as
defined by [f->file_offset, f->file_offset + f->io_size) don't intersect.
This leads to unnecessary quiescing.

Patch clamps every zone to [->min_zone, ->max_zone) when doing search
for opened zone and more importantly adds an assert so that any
unnecessary zone locking becomes very visible.

Signed-off-by: Alexey Dobriyan (SK hynix) <adobriyan@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 file.h |  3 +++
 zbd.c  | 40 ++++++++++++++++++++++++++--------------
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/file.h b/file.h
index ae0e6fc8..375bbfd3 100644
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
diff --git a/zbd.c b/zbd.c
index 8dc3c397..76771f2e 100644
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
+	/* A thread should never lock zones outside its working area. */
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
 
@@ -730,7 +739,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 		if (!zbd_zone_swr(z))
 			continue;
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (all_zones) {
 			unsigned int i;
 
@@ -854,14 +863,12 @@ static void zbd_init_swd(struct fio_file *f)
 void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 {
 	struct fio_zone_info *zb, *ze;
-	uint32_t zone_idx_e;
 
 	if (!f->zbd_info)
 		return;
 
-	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
-	zone_idx_e = zbd_zone_idx(f, f->file_offset + f->io_size);
-	ze = &f->zbd_info->zone_info[zone_idx_e];
+	zb = &f->zbd_info->zone_info[f->min_zone];
+	ze = &f->zbd_info->zone_info[f->max_zone];
 	zbd_init_swd(f);
 	/*
 	 * If data verification is enabled reset the affected zones before
@@ -953,7 +960,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 						      struct io_u *io_u)
 {
 	const uint32_t min_bs = td->o.min_bs[io_u->ddir];
-	const struct fio_file *f = io_u->file;
+	struct fio_file *f = io_u->file;
 	struct fio_zone_info *z;
 	unsigned int open_zone_idx = -1;
 	uint32_t zone_idx, new_zone_idx;
@@ -970,6 +977,10 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	} else {
 		zone_idx = zbd_zone_idx(f, io_u->offset);
 	}
+	if (zone_idx < f->min_zone)
+		zone_idx = f->min_zone;
+	else if (zone_idx >= f->max_zone)
+		zone_idx = f->max_zone - 1;
 	dprint(FD_ZBD, "%s(%s): starting from zone %d (offset %lld, buflen %lld)\n",
 	       __func__, f->file_name, zone_idx, io_u->offset, io_u->buflen);
 
@@ -984,7 +995,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		if (td->o.max_open_zones == 0)
 			goto examine_zone;
@@ -1010,8 +1021,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 			if (tmp_idx >= f->zbd_info->num_open_zones)
 				tmp_idx = 0;
 			tmpz = f->zbd_info->open_zones[tmp_idx];
-
-			if (is_valid_offset(f, f->zbd_info->zone_info[tmpz].start)) {
+			if (f->min_zone <= tmpz && tmpz < f->max_zone) {
 				open_zone_idx = tmp_idx;
 				goto found_candidate_zone;
 			}
@@ -1056,11 +1066,11 @@ examine_zone:
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
@@ -1073,12 +1083,14 @@ examine_zone:
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	for (i = 0; i < f->zbd_info->num_open_zones; i++) {
 		zone_idx = f->zbd_info->open_zones[i];
+		if (zone_idx < f->min_zone || zone_idx >= f->max_zone)
+			continue;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 		pthread_mutex_unlock(&z->mutex);
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		zone_lock(td, z);
+		zone_lock(td, f, z);
 		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1404,7 +1416,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	zone_lock(td, zb);
+	zone_lock(td, f, zb);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-- 
2.26.2


