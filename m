Return-Path: <prvs=50667a661=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 3/7] zbd: Initialize open zones list referring zone status at fio start
Date: Tue,  1 Sep 2020 17:20:02 +0900
Message-Id: <20200901082006.1476720-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
References: <20200901082006.1476720-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

When fio starts write workloads to zones with open status, fio does not
reflect the zone status to open zone list. This results in inconsistent
open zone accounting.

To avoid this inconsistency, initialize the open zone list referring the
zone status before workload start. If a zone in target range have open
status, call zbd_open_zone() function to build up the open zone list.
Since io_u is not available at that timing, make the function independent
from io_u. If the number of open zones exceeds maximum open zones limits,
reset the exceeding open zone by calling zbd_reset_zone().

Of note is that fio counts open zones within the write target range.
Open zones out of the range are not counted or checked.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/zbd.c b/zbd.c
index 8e94ee53..e8ecbb6f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -628,6 +628,11 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 	return ret;
 }
 
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
+			  uint32_t zone_idx);
+static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
+			  struct fio_zone_info *z);
+
 int zbd_setup_files(struct thread_data *td)
 {
 	struct fio_file *f;
@@ -651,6 +656,8 @@ int zbd_setup_files(struct thread_data *td)
 
 	for_each_file(td, f, i) {
 		struct zoned_block_device_info *zbd = f->zbd_info;
+		struct fio_zone_info *z;
+		int zi;
 
 		if (!zbd)
 			continue;
@@ -666,6 +673,23 @@ int zbd_setup_files(struct thread_data *td)
 			log_err("'max_open_zones' value is limited by %u\n", ZBD_MAX_OPEN_ZONES);
 			return 1;
 		}
+
+		for (zi = f->min_zone; zi < f->max_zone; zi++) {
+			z = &zbd->zone_info[zi];
+			if (z->cond != ZBD_ZONE_COND_IMP_OPEN &&
+			    z->cond != ZBD_ZONE_COND_EXP_OPEN)
+				continue;
+			if (zbd_open_zone(td, f, zi))
+				continue;
+			/*
+			 * If the number of open zones exceeds specified limits,
+			 * reset all extra open zones.
+			 */
+			if (zbd_reset_zone(td, f, z) < 0) {
+				log_err("Failed to reest zone %d\n", zi);
+				return 1;
+			}
+		}
 	}
 
 	return 0;
@@ -937,11 +961,10 @@ static bool is_zone_open(const struct thread_data *td, const struct fio_file *f,
  * was not yet open and opening a new zone would cause the zone limit to be
  * exceeded.
  */
-static bool zbd_open_zone(struct thread_data *td, const struct io_u *io_u,
+static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 			  uint32_t zone_idx)
 {
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
-	const struct fio_file *f = io_u->file;
 	struct fio_zone_info *z = &f->zbd_info->zone_info[zone_idx];
 	bool res = true;
 
@@ -1129,7 +1152,7 @@ open_other_zone:
 		zone_lock(td, f, z);
 		if (z->open)
 			continue;
-		if (zbd_open_zone(td, io_u, zone_idx))
+		if (zbd_open_zone(td, f, zone_idx))
 			goto out;
 	}
 
@@ -1172,7 +1195,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const struct fio_file *f = io_u->file;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
-	if (!zbd_open_zone(td, io_u, z - f->zbd_info->zone_info)) {
+	if (!zbd_open_zone(td, f, z - f->zbd_info->zone_info)) {
 		pthread_mutex_unlock(&z->mutex);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
@@ -1581,7 +1604,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 	case DDIR_WRITE:
 		if (io_u->buflen > f->zbd_info->zone_size)
 			goto eof;
-		if (!zbd_open_zone(td, io_u, zone_idx_b)) {
+		if (!zbd_open_zone(td, f, zone_idx_b)) {
 			pthread_mutex_unlock(&zb->mutex);
 			zb = zbd_convert_to_open_zone(td, io_u);
 			if (!zb)
-- 
2.26.2


