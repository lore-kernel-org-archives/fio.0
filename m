Return-Path: <prvs=138d395aa=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Improve job zonesize initialization checks
Date: Fri, 30 Aug 2019 11:16:05 +0900
Message-Id: <20190830021605.1211-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For a multijob workload, each job may specify a zonesize option for
access to a zoned block device or regular device with zonemode=zbd.
In such case, make sure that the zone size value specified by each job
matches the device zone size.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/zbd.c b/zbd.c
index 0a573692..99310c49 100644
--- a/zbd.c
+++ b/zbd.c
@@ -127,6 +127,11 @@ static bool zbd_verify_sizes(void)
 						f->file_name);
 					return false;
 				}
+			} else if (td->o.zone_size != f->zbd_info->zone_size) {
+				log_err("%s: job parameter zonesize %llu does not match disk zone size %llu.\n",
+					f->file_name, (unsigned long long) td->o.zone_size,
+					(unsigned long long) f->zbd_info->zone_size);
+				return false;
 			}
 
 			if (td->o.zone_skip &&
-- 
2.21.0


