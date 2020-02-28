Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34687 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgB1HOn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Feb 2020 02:14:43 -0500
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 3/6] zbd: use zone_lock to lock a zone
Date: Fri, 28 Feb 2020 16:12:45 +0900
Message-Id: <20200228071248.3981623-4-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>

commit 6f0c608564c3 ("zbd: Avoid async I/O multi-job workload deadlock")
introduced io_u_quiesce() when it failed to lock a zone to avoid deadlock.
This situation can happen on the other locking place like
zbd_convert_to_open_zone(). Thus, introduce common helper "zone_lock" to
lock a zone.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 zbd.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/zbd.c b/zbd.c
index 18a55ea46ef9..b2d9424972da 100644
--- a/zbd.c
+++ b/zbd.c
@@ -927,6 +927,24 @@ static void zbd_close_zone(struct thread_data *td, const struct fio_file *f,
 	f->zbd_info->zone_info[zone_idx].open = 0;
 }
 
+static void zone_lock(struct thread_data *td, struct fio_zone_info *z)
+{
+	/*
+	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
+	 * is changed or when io_u completes and zbd_put_io() executed.
+	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
+	 * other waiting for zone locks when building an io_u batch, first
+	 * only trylock the zone. If the zone is already locked by another job,
+	 * process the currently queued I/Os so that I/O progress is made and
+	 * zones unlocked.
+	 */
+	if (pthread_mutex_trylock(&z->mutex) != 0) {
+		if (!td_ioengine_flagged(td, FIO_SYNCIO))
+			io_u_quiesce(td);
+		pthread_mutex_lock(&z->mutex);
+	}
+}
+
 /*
  * Modify the offset of an I/O unit that does not refer to an open zone such
  * that it refers to an open zone. Close an open zone and open a new zone if
@@ -969,7 +987,7 @@ static struct fio_zone_info *zbd_convert_to_open_zone(struct thread_data *td,
 	for (;;) {
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		pthread_mutex_lock(&f->zbd_info->mutex);
 		if (td->o.max_open_zones == 0)
 			goto examine_zone;
@@ -1017,7 +1035,7 @@ examine_zone:
 			z = &f->zbd_info->zone_info[zone_idx];
 		}
 		assert(is_valid_offset(f, z->start));
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		if (z->open)
 			continue;
 		if (zbd_open_zone(td, io_u, zone_idx))
@@ -1035,7 +1053,7 @@ examine_zone:
 
 		z = &f->zbd_info->zone_info[zone_idx];
 
-		pthread_mutex_lock(&z->mutex);
+		zone_lock(td, z);
 		if (z->wp + min_bs <= (z+1)->start)
 			goto out;
 		pthread_mutex_lock(&f->zbd_info->mutex);
@@ -1321,20 +1339,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 
 	zbd_check_swd(f);
 
-	/*
-	 * Lock the io_u target zone. The zone will be unlocked if io_u offset
-	 * is changed or when io_u completes and zbd_put_io() executed.
-	 * To avoid multiple jobs doing asynchronous I/Os from deadlocking each
-	 * other waiting for zone locks when building an io_u batch, first
-	 * only trylock the zone. If the zone is already locked by another job,
-	 * process the currently queued I/Os so that I/O progress is made and
-	 * zones unlocked.
-	 */
-	if (pthread_mutex_trylock(&zb->mutex) != 0) {
-		if (!td_ioengine_flagged(td, FIO_SYNCIO))
-			io_u_quiesce(td);
-		pthread_mutex_lock(&zb->mutex);
-	}
+	zone_lock(td, zb);
 
 	switch (io_u->ddir) {
 	case DDIR_READ:
-- 
2.25.1


