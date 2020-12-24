Return-Path: <prvs=620a42eaa=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v2 02/36] zbd: use zbd_zone_nr() more actively in the code
Date: Thu, 24 Dec 2020 11:11:45 +0900
Message-Id: <20201224021219.189727-3-dmitry.fomichev@wdc.com>
In-Reply-To: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
References: <20201224021219.189727-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

The function zbd_zone_nr() is always called with the first argument
being f->zbd_info. If "f" is made the first argument instead, calls
of this function become more compact end easier to read.

Besides this change, convert several places in the code where the same
zone number calculation is open coded to zbd_zone_nr() calls.
This is a refactoring patch, no change in functionality.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 zbd.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/zbd.c b/zbd.c
index ad1ad1a9..841427e7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -694,10 +694,10 @@ int zbd_setup_files(struct thread_data *td)
 	return 0;
 }
 
-static unsigned int zbd_zone_nr(struct zoned_block_device_info *zbd_info,
-				struct fio_zone_info *zone)
+static inline unsigned int zbd_zone_nr(const struct fio_file *f,
+				       struct fio_zone_info *zone)
 {
-	return zone - zbd_info->zone_info;
+	return zone - f->zbd_info->zone_info;
 }
 
 /**
@@ -723,7 +723,7 @@ static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 	assert(is_valid_offset(f, offset + length - 1));
 
 	dprint(FD_ZBD, "%s: resetting wp of zone %u.\n", f->file_name,
-		zbd_zone_nr(f->zbd_info, z));
+		zbd_zone_nr(f, z));
 	switch (f->zbd_info->model) {
 	case ZBD_HOST_AWARE:
 	case ZBD_HOST_MANAGED:
@@ -793,9 +793,9 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	assert(min_bs);
 
 	dprint(FD_ZBD, "%s: examining zones %u .. %u\n", f->file_name,
-		zbd_zone_nr(f->zbd_info, zb), zbd_zone_nr(f->zbd_info, ze));
+		zbd_zone_nr(f, zb), zbd_zone_nr(f, ze));
 	for (z = zb; z < ze; z++) {
-		uint32_t nz = z - f->zbd_info->zone_info;
+		uint32_t nz = zbd_zone_nr(f, z);
 
 		if (!zbd_zone_swr(z))
 			continue;
@@ -811,8 +811,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
-			       f->file_name,
-			       zbd_zone_nr(f->zbd_info, z));
+			       f->file_name, zbd_zone_nr(f, z));
 			if (zbd_reset_zone(td, f, z) < 0)
 				res = 1;
 		}
@@ -1197,7 +1196,7 @@ static struct fio_zone_info *zbd_replay_write_order(struct thread_data *td,
 	const struct fio_file *f = io_u->file;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 
-	if (!zbd_open_zone(td, f, z - f->zbd_info->zone_info)) {
+	if (!zbd_open_zone(td, f, zbd_zone_nr(f, z))) {
 		pthread_mutex_unlock(&z->mutex);
 		z = zbd_convert_to_open_zone(td, io_u);
 		assert(z);
@@ -1271,7 +1270,7 @@ static void zbd_end_zone_io(struct thread_data *td, const struct io_u *io_u,
 	if (io_u->ddir == DDIR_WRITE &&
 	    io_u->offset + io_u->buflen >= zbd_zone_capacity_end(z)) {
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		zbd_close_zone(td, f, z - f->zbd_info->zone_info);
+		zbd_close_zone(td, f, zbd_zone_nr(f, z));
 		pthread_mutex_unlock(&f->zbd_info->mutex);
 	}
 }
@@ -1430,8 +1429,7 @@ void setup_zbd_zone_mode(struct thread_data *td, struct io_u *io_u)
 		       "%s: Jump from zone capacity limit to zone end:"
 		       " (%llu -> %llu) for zone %u (%llu)\n",
 		       f->file_name, (unsigned long long) f->last_pos[ddir],
-		       (unsigned long long) zbd_zone_end(z),
-		       zbd_zone_nr(f->zbd_info, z),
+		       (unsigned long long) zbd_zone_end(z), zone_idx,
 		       (unsigned long long) z->capacity);
 		td->io_skip_bytes += zbd_zone_end(z) - f->last_pos[ddir];
 		f->last_pos[ddir] = zbd_zone_end(z);
@@ -1612,7 +1610,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 			zb = zbd_convert_to_open_zone(td, io_u);
 			if (!zb)
 				goto eof;
-			zone_idx_b = zb - f->zbd_info->zone_info;
+			zone_idx_b = zbd_zone_nr(f, zb);
 		}
 		/* Check whether the zone reset threshold has been exceeded */
 		if (td->o.zrf.u.f) {
-- 
2.28.0


