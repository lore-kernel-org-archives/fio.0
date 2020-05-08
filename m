Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:22452 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgEHH4t (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 May 2020 03:56:49 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 4/7] zbd: Optimize zbd_file_reset()
Date: Fri,  8 May 2020 16:56:42 +0900
Message-Id: <20200508075645.543890-5-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

For a job not writing, a device zones will not be reset by executing
zbc_file_reset() so there is no need to scan all zones of the job
operating range. Avoid this overhead by returning early for jobs that
are not writing.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/zbd.c b/zbd.c
index c30454b9..a64fd0c7 100644
--- a/zbd.c
+++ b/zbd.c
@@ -743,8 +743,7 @@ static int zbd_reset_zones(struct thread_data *td, struct fio_file *f,
 
 			reset_wp = z->wp != z->start;
 		} else {
-			reset_wp = (td->o.td_ddir & TD_DDIR_WRITE) &&
-					z->wp % min_bs != 0;
+			reset_wp = z->wp % min_bs != 0;
 		}
 		if (reset_wp) {
 			dprint(FD_ZBD, "%s: resetting zone %u\n",
@@ -856,7 +855,7 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	struct fio_zone_info *zb, *ze;
 	uint32_t zone_idx_e;
 
-	if (!f->zbd_info)
+	if (!f->zbd_info || !td_write(td))
 		return;
 
 	zb = &f->zbd_info->zone_info[zbd_zone_idx(f, f->file_offset)];
@@ -869,7 +868,6 @@ void zbd_file_reset(struct thread_data *td, struct fio_file *f)
 	 * writing data, which causes data loss.
 	 */
 	zbd_reset_zones(td, f, zb, ze, td->o.verify != VERIFY_NONE &&
-			(td->o.td_ddir & TD_DDIR_WRITE) &&
 			td->runstate != TD_VERIFYING);
 	zbd_reset_write_cnt(td, f);
 }
-- 
2.25.4


