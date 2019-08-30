Return-Path: <prvs=138d395aa=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix job zone size initialization
Date: Fri, 30 Aug 2019 10:45:03 +0900
Message-Id: <20190830014503.32691-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For a job accessing a zoned block device, the zone size is automatically
initialized to the device zone size. However, since zone information for
a zoned block device is parsed once only for the first job
initialization of a multi job workload, only the first job has its
zonesize option intialized, causing problem if the zoneskip option is
also used (assert exit).

Fix this by always initializing a job zonesize option using the job
file zbd information when verifying the job ZBD related sizes and
offsets.

Fixes: 4d37720ae029 ("zbd: Add support for zoneskip option")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/zbd.c b/zbd.c
index fb81b532..0a573692 100644
--- a/zbd.c
+++ b/zbd.c
@@ -120,6 +120,15 @@ static bool zbd_verify_sizes(void)
 			if (!zbd_is_seq_job(f))
 				continue;
 
+			if (!td->o.zone_size) {
+				td->o.zone_size = f->zbd_info->zone_size;
+				if (!td->o.zone_size) {
+					log_err("%s: invalid 0 zone size\n",
+						f->file_name);
+					return false;
+				}
+			}
+
 			if (td->o.zone_skip &&
 			    (td->o.zone_skip < td->o.zone_size ||
 			     td->o.zone_skip % td->o.zone_size)) {
-- 
2.21.0


