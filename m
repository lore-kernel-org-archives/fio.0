Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3508 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbeH3IPr (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Aug 2018 04:15:47 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 4/5] zbd: Fix zbd_zone_idx()
Date: Thu, 30 Aug 2018 13:15:30 +0900
Message-Id: <20180830041531.20963-5-damien.lemoal@wdc.com>
In-Reply-To: <20180830041531.20963-1-damien.lemoal@wdc.com>
References: <20180830041531.20963-1-damien.lemoal@wdc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>

For a zone size that is not a power of 2 number of sectors,
f->zbd_info->zone_size_log2 is set to -1. So use bit shift in
zbd_zone_idx() only if zone_size_log2 is not negative.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index e98c5a50..3aea8052 100644
--- a/zbd.c
+++ b/zbd.c
@@ -31,7 +31,7 @@ static uint32_t zbd_zone_idx(const struct fio_file *f, uint64_t offset)
 {
 	uint32_t zone_idx;
 
-	if (f->zbd_info->zone_size_log2)
+	if (f->zbd_info->zone_size_log2 > 0)
 		zone_idx = offset >> f->zbd_info->zone_size_log2;
 	else
 		zone_idx = (offset >> 9) / f->zbd_info->zone_size;
-- 
2.17.1


