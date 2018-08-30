Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3508 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbeH3IPq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Aug 2018 04:15:46 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 3/5] zbd: Do not read offline zones
Date: Thu, 30 Aug 2018 13:15:29 +0900
Message-Id: <20180830041531.20963-4-damien.lemoal@wdc.com>
In-Reply-To: <20180830041531.20963-1-damien.lemoal@wdc.com>
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>

For an I/O trying to read an offline zone, another zone must be chosen
using zbd_find_zone(). However, in zbd_adjust_block(), the variable
range is set to 0 for an offline zone, which in the case of a random
read pattern causes evaluation of the first if condition of the
DDIR_READ case to true, resulting in the use of the offline zone.

Fix this simply by setting range to -1 so that the first if statement is
false and zbd_find_zone() executed.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 19511454..e98c5a50 100644
--- a/zbd.c
+++ b/zbd.c
@@ -1157,7 +1157,7 @@ enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u)
 		 * hit the medium.
 		 */
 		range = zb->cond != BLK_ZONE_COND_OFFLINE ?
-			((zb->wp - zb->start) << 9) - io_u->buflen : 0;
+			((zb->wp - zb->start) << 9) - io_u->buflen : -1;
 		if (td_random(td) && range >= 0) {
 			io_u->offset = (zb->start << 9) +
 				((io_u->offset - (zb->start << 9)) %
-- 
2.17.1


