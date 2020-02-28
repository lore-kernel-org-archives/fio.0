Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34680 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgB1HOm (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Feb 2020 02:14:42 -0500
From: Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH 2/6] zbd: reset one zone at a time
Date: Fri, 28 Feb 2020 16:12:44 +0900
Message-Id: <20200228071248.3981623-3-naohiro.aota@wdc.com>
In-Reply-To: <20200228071248.3981623-1-naohiro.aota@wdc.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Naohiro Aota <naohiro.aota@wdc.com>

zbd_rest_zones() currently scans over device zones and try to reset as much
zones as possible at a time. However, this routine takes all the lock on
the range and causes a lot of lock contentions with other threads.

This commit change the behavior to hold the lock and examine one zone at a
time. While it will increase the number of ioctl() call when it need to
reset contiguous, the overhead of increased number of ioctl()s are anyway
amortized by device side's reset performance.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 zbd.c | 42 +++++++-----------------------------------
 1 file changed, 7 insertions(+), 35 deletions(-)

diff --git a/zbd.c b/zbd.c
index ddf1e6f3e008..18a55ea46ef9 100644
--- a/zbd.c
+++ b/zbd.c
@@ -707,7 +707,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 			   struct fio_zone_info *const zb,
 			   struct fio_zone_info *const ze, bool all_zones)
 {
-	struct fio_zone_info *z, *start_z = ze;
+	struct fio_zone_info *z;
 	const uint32_t min_bs = td->o.min_bs[DDIR_WRITE];
 	bool reset_wp;
 	int res = 0;
@@ -717,48 +717,20 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 	assert(f->fd != -1);
 	for (z = zb; z < ze; z++) {
 		pthread_mutex_lock(&z->mutex);
-		switch (z->type) {
-		case BLK_ZONE_TYPE_SEQWRITE_REQ:
+		if (z->type == BLK_ZONE_TYPE_SEQWRITE_REQ) {
 			reset_wp = all_zones ? z->wp != z->start :
 					(td->o.td_ddir & TD_DDIR_WRITE) &&
 					z->wp % min_bs != 0;
-			if (start_z == ze && reset_wp) {
-				start_z = z;
-			} else if (start_z < ze && !reset_wp) {
-				dprint(FD_ZBD,
-				       "%s: resetting zones %u .. %u\n",
+			if (reset_wp) {
+				dprint(FD_ZBD, "%s: resetting zone %u\n",
 				       f->file_name,
-					zbd_zone_nr(f->zbd_info, start_z),
-					zbd_zone_nr(f->zbd_info, z));
-				if (zbd_reset_range(td, f, start_z->start,
-						z->start - start_z->start) < 0)
+				       zbd_zone_nr(f->zbd_info, z));
+				if (zbd_reset_zone(td, f, z) < 0)
 					res = 1;
-				start_z = ze;
 			}
-			break;
-		default:
-			if (start_z == ze)
-				break;
-			dprint(FD_ZBD, "%s: resetting zones %u .. %u\n",
-			       f->file_name, zbd_zone_nr(f->zbd_info, start_z),
-			       zbd_zone_nr(f->zbd_info, z));
-			if (zbd_reset_range(td, f, start_z->start,
-					    z->start - start_z->start) < 0)
-				res = 1;
-			start_z = ze;
-			break;
 		}
-	}
-	if (start_z < ze) {
-		dprint(FD_ZBD, "%s: resetting zones %u .. %u\n", f->file_name,
-			zbd_zone_nr(f->zbd_info, start_z),
-			zbd_zone_nr(f->zbd_info, z));
-		if (zbd_reset_range(td, f, start_z->start,
-				    z->start - start_z->start) < 0)
-			res = 1;
-	}
-	for (z = zb; z < ze; z++)
 		pthread_mutex_unlock(&z->mutex);
+	}
 
 	return res;
 }
-- 
2.25.1


