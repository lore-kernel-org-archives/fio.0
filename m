Return-Path: <prvs=6542a1e1f=dmitry.fomichev@wdc.com>
From: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: [PATCH v4 18/38] zbd: handle conventional start zone in zbd_convert_to_open_zone()
Date: Wed, 27 Jan 2021 13:19:25 +0900
Message-Id: <20210127041945.36909-19-dmitry.fomichev@wdc.com>
In-Reply-To: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
References: <20210127041945.36909-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
Cc: Damien Le Moal <damien.lemoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Aravind Ramesh <aravind.ramesh@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, Niklas Cassel <niklas.cassel@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

At the beginning of zbd_convert_to_open_zone() function, a zone
is picked in semi-random manner to become a candidate zone for
redirecting the incoming write. In some circumstances, such as
unlimited MaxOpen or i/o range that spans the boundary between
conventional and sequential zones, a conventional zone may be
selected.

This may create problems in the subsequent for (;;) loop in the
same function. Failed assertions were observed during the execution
of newly introduced test #51 that showed that the code in that loop
was trying to lock and unlock conventional zones.

Check if the zone which has been initially picked is conventional.
If yes, force the zone selection to be re-tried until a sequential
zone is selected for further processing.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Reviewed-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 zbd.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/zbd.c b/zbd.c
index 634ee8f6..44ecb9e0 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1087,16 +1087,18 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		uint32_t tmp_idx;
 
 		z = get_zone(f, zone_idx);
-
-		zone_lock(td, f, z);
+		if (z->has_wp)
+			zone_lock(td, f, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
-		if (z->cond != ZBD_ZONE_COND_OFFLINE &&
-		    td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
-			goto examine_zone;
-		if (f->zbd_info->num_open_zones == 0) {
-			dprint(FD_ZBD, "%s(%s): no zones are open\n",
-			       __func__, f->file_name);
-			goto open_other_zone;
+		if (z->has_wp) {
+			if (z->cond != ZBD_ZONE_COND_OFFLINE &&
+			    td->o.max_open_zones == 0 && td->o.job_max_open_zones == 0)
+				goto examine_zone;
+			if (f->zbd_info->num_open_zones == 0) {
+				dprint(FD_ZBD, "%s(%s): no zones are open\n",
+				       __func__, f->file_name);
+				goto open_other_zone;
+			}
 		}
 
 		/*
@@ -1124,7 +1126,8 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 		dprint(FD_ZBD, "%s(%s): no candidate zone\n",
 			__func__, f->file_name);
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		zone_unlock(z);
+		if (z->has_wp)
+			zone_unlock(z);
 		return NULL;
 
 found_candidate_zone:
@@ -1133,7 +1136,8 @@ found_candidate_zone:
 			break;
 		zone_idx = new_zone_idx;
 		pthread_mutex_unlock(&f->zbd_info->mutex);
-		zone_unlock(z);
+		if (z->has_wp)
+			zone_unlock(z);
 	}
 
 	/* Both z->mutex and f->zbd_info->mutex are held. */
-- 
2.28.0


