Return-Path: <prvs=409fd062c=shinichiro.kawasaki@wdc.com>
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] zbd: Fix max_open_zones checks
Date: Wed, 27 May 2020 10:20:13 +0900
Message-Id: <20200527012013.87661-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

Commit 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
introduced job_max_open_zones option which limits the number of open
zones per job. It has similar role as max_open_zones option which limits
the number of open zones for all jobs. It was intended that these two
options both work, but the commit replaced some checks for max_open_zones
simply with checks for job_max_open_zones. Because of this, when
max_open_zones is set and job_max_open_zones is not set, fio fails to
limit the number of open zones. This resulted in test case #29 failure
of t/zbd/test-zbd-support script for regular null_blk devices.

To fix the failure, modify the checks to target both job_max_open_zones
and max_open_zones.

Fixes: 219c662d3b12 ("zbd: introduce per job maximum open zones limit")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/zbd.c b/zbd.c
index 72352db0..2a725c1f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -997,7 +997,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 	assert(is_valid_offset(f, io_u->offset));
 
-	if (td->o.job_max_open_zones) {
+	if (td->o.max_open_zones || td->o.job_max_open_zones) {
 		/*
 		 * This statement accesses f->zbd_info->open_zones[] on purpose
 		 * without locking.
@@ -1026,7 +1026,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 
 		zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (td->o.job_max_open_zones == 0)
+		if (td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
 			goto examine_zone;
 		if (f->zbd_info->num_open_zones == 0) {
 			pthread_mutex_unlock(&f->zbd_info->mutex);
@@ -1082,7 +1082,7 @@ examine_zone:
 	}
 	dprint(FD_ZBD, "%s(%s): closing zone %d\n", __func__, f->file_name,
 	       zone_idx);
-	if (td->o.job_max_open_zones)
+	if (td->o.max_open_zones || td->o.job_max_open_zones)
 		zbd_close_zone(td, f, open_zone_idx);
 	pthread_mutex_unlock(&f->zbd_info->mutex);
 
-- 
2.25.4


