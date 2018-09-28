Return-Path: <prvs=802d9959d=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix incorrect comments
Date: Fri, 28 Sep 2018 14:53:53 +0900
Message-Id: <20180928055353.30977-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

Commit ee3696bdfd84 ("zbd: Use bytes unit") changed the zone info
structure zone start and zone wp location unit to bytes. Reflect this
change in the fio_zone_info structure comments.

Fixes: ee3696bdfd84 ("zbd: Use bytes unit")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/zbd.h b/zbd.h
index d750b67e..33e6d8bd 100644
--- a/zbd.h
+++ b/zbd.h
@@ -31,8 +31,8 @@ enum io_u_action {
 
 /**
  * struct fio_zone_info - information about a single ZBD zone
- * @start: zone start in 512 byte units
- * @wp: zone write pointer location in 512 byte units
+ * @start: zone start location (bytes)
+ * @wp: zone write pointer location (bytes)
  * @verify_block: number of blocks that have been verified for this zone
  * @mutex: protects the modifiable members in this structure
  * @type: zone type (BLK_ZONE_TYPE_*)
-- 
2.17.1


