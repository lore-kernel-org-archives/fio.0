Return-Path: <prvs=587eb1fc6=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH 12/15] zbd: count sectors with data for write pointer zones
Date: Sat, 21 Nov 2020 11:45:29 +0900
Message-Id: <20201121024532.16834-13-dmitry.fomichev@wdc.com>
In-Reply-To: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
References: <20201121024532.16834-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

ZBD fio code tracks 'sectors with data' for two different purposes.
The first one is to process zone_reset_threshold. When the ratio of
sectors with data in zones with write pointer goes beyond the specified
number, zone reset is triggered. The second purpose is to control the
direction of the first I/O of random mixed read/write workloads. If all
write pointer zones in the I/O range are reset at the beginning of such
a workload, fio has no data to read and will immediately end the run of
the test section. To avoid this, fio checks 'sectors with data' and if
it is zero (i.e. it is the very first I/O), it modifies the direction
of that I/O from read to write.

Currently, when the workload range includes both conventional and
sequential zones, all sectors in conventional zones are counted as
'sectors with data' along with sectors in sequential zones.
This leads to incorrect handling  of 'zone_reset_threshold' option -
zone reset timing of sequential zones is affected by the amount of
data read from or written to conventional zones. To avoid this,
conventional zones should be excluded from 'sectors with data'
calculation.

On the other hand, if the sectors of conventional zones were excluded
from the sectors with data, it could result in the wrong initial I/O
direction for random workloads. When the zones in I/O region are all
conventional, 'sectors with data' would always be zero. Because of
this, read operations are always changed to writes and reads are never
performed.

To avoid this contradiction, introduce another counter,
'wp_sector_with_data'. It works similar to the existing
'sectors_with_data', but it counts data sectors only in write pointer
zones. Use this newly introduced count for zone_reset_threshold checks
and keep on using the original count for the initial random I/O
direction determination.

When counting sectors with data, lock only write pointer zones, no need
to lock conventional zones.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 25 ++++++++++++++++++-------
 zbd.h |  3 +++
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/zbd.c b/zbd.c
index a99b6b2f..f513295a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -734,9 +734,10 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 {
 	uint64_t offset = z->start;
 	uint64_t length = (z+1)->start - offset;
+	uint64_t data_in_zone = z->wp - z->start;
 	int ret = 0;
 
-	if (z->wp == z->start)
+	if (!data_in_zone)
 		return 0;
 
 	assert(is_valid_offset(f, offset + length - 1));
@@ -755,7 +756,8 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	}
 
 	pthread_mutex_lock(&f->zbd_info->mutex);
-	f->zbd_info->sectors_with_data -= z->wp - z->start;
+	f->zbd_info->sectors_with_data -= data_in_zone;
+	f->zbd_info->wp_sectors_with_data -= data_in_zone;
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	z->wp = z->start;
 	z->verify_block = 0;
@@ -887,25 +889,32 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
 {
 	struct fio_zone_info *zb, *ze, *z;
 	uint64_t swd = 0;
+	uint64_t wp_swd = 0;
 
 	zb = get_zone(f, f->min_zone);
 	ze = get_zone(f, f->max_zone);
 	for (z = zb; z < ze; z++) {
-		pthread_mutex_lock(&z->mutex);
+		if (z->has_wp) {
+			pthread_mutex_lock(&z->mutex);
+			wp_swd += z->wp - z->start;
+		}
 		swd += z->wp - z->start;
 	}
 	pthread_mutex_lock(&f->zbd_info->mutex);
 	switch (a) {
 	case CHECK_SWD:
 		assert(f->zbd_info->sectors_with_data == swd);
+		assert(f->zbd_info->wp_sectors_with_data == wp_swd);
 		break;
 	case SET_SWD:
 		f->zbd_info->sectors_with_data = swd;
+		f->zbd_info->wp_sectors_with_data = wp_swd;
 		break;
 	}
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 	for (z = zb; z < ze; z++)
-		zone_unlock(z);
+		if (z->has_wp)
+			zone_unlock(z);
 
 	return swd;
 }
@@ -916,7 +925,7 @@ static uint64_t zbd_process_swd(const struct fio_file *f, enum swd_action a)
  */
 static const bool enable_check_swd = false;
 
-/* Check whether the value of zbd_info.sectors_with_data is correct. */
+/* Check whether the values of zbd_info.*sectors_with_data are correct. */
 static void zbd_check_swd(const struct fio_file *f)
 {
 	if (!enable_check_swd)
@@ -1347,8 +1356,10 @@ static void zbd_queue_io(struct thread_data *td, struct io_u *io_u, int q,
 		 * z->wp > zone_end means that one or more I/O errors
 		 * have occurred.
 		 */
-		if (z->wp <= zone_end)
+		if (z->wp <= zone_end) {
 			zbd_info->sectors_with_data += zone_end - z->wp;
+			zbd_info->wp_sectors_with_data += zone_end - z->wp;
+		}
 		pthread_mutex_unlock(&zbd_info->mutex);
 		z->wp = zone_end;
 		break;
@@ -1650,7 +1661,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-			if (f->zbd_info->sectors_with_data >=
+			if (f->zbd_info->wp_sectors_with_data >=
 			    f->io_size * td->o.zrt.u.f &&
 			    zbd_dec_and_reset_write_cnt(td, f)) {
 				zb->reset_zone = 1;
diff --git a/zbd.h b/zbd.h
index 059a9f9e..cc3ab624 100644
--- a/zbd.h
+++ b/zbd.h
@@ -55,6 +55,8 @@ struct fio_zone_info {
  *		num_open_zones).
  * @zone_size: size of a single zone in bytes.
  * @sectors_with_data: total size of data in all zones in units of 512 bytes
+ * @wp_sectors_with_data: total size of data in zones with write pointers in
+ *                        units of 512 bytes
  * @zone_size_log2: log2 of the zone size in bytes if it is a power of 2 or 0
  *		if the zone size is not a power of 2.
  * @nr_zones: number of zones
@@ -75,6 +77,7 @@ struct zoned_block_device_info {
 	pthread_mutex_t		mutex;
 	uint64_t		zone_size;
 	uint64_t		sectors_with_data;
+	uint64_t		wp_sectors_with_data;
 	uint32_t		zone_size_log2;
 	uint32_t		nr_zones;
 	uint32_t		refcount;
-- 
2.21.0


