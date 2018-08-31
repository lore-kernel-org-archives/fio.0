Return-Path: <prvs=774163301=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3 3/3] zbd: Fix zbd_zone_idx()
Date: Fri, 31 Aug 2018 13:46:38 +0900
Message-Id: <20180831044638.22476-4-damien.lemoal@wdc.com>
In-Reply-To: <20180831044638.22476-1-damien.lemoal@wdc.com>
References: <20180831044638.22476-1-damien.lemoal@wdc.com>
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

For a zone size that is not a power of 2,
f->zbd_info->zone_size_log2 is set to -1. So use bit shift in
zbd_zone_idx() only if zone_size_log2 is not negative.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 zbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 93f14410..eb474f6e 100644
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


