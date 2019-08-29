Return-Path: <prvs=137559805=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/6] zbd: Cleanup zbd_init()
Date: Thu, 29 Aug 2019 16:21:30 +0900
Message-Id: <20190829072135.2872-2-damien.lemoal@wdc.com>
In-Reply-To: <20190829072135.2872-1-damien.lemoal@wdc.com>
References: <20190829072135.2872-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

For a job using a zoned device, the zonesize option must always specify
the device zone size. That is checked in the function parse_zone_info().
The zonesize checks in zbd_init() apply only to jobs running with
zonemode=zbd on a regular block device. So move these checks into
init_zone_info() which is used to emulate zone information for regular
block devices.

Fix t/zbd test #43 accordingly.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 t/zbd/test-zbd-support |  3 ++-
 zbd.c                  | 28 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index ed54a0aa..6eecce9f 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -707,8 +707,9 @@ test42() {
 	grep -q 'Specifying the zone size is mandatory for regular block devices with --zonemode=zbd'
 }
 
-# Check whether fio handles --zonesize=1 correctly.
+# Check whether fio handles --zonesize=1 correctly for regular block devices.
 test43() {
+    [ -n "$is_zbd" ] && return 0
     read_one_block --zonemode=zbd --zonesize=1 |
 	grep -q 'zone size must be at least 512 bytes for --zonemode=zbd'
 }
diff --git a/zbd.c b/zbd.c
index 2383c57d..09ddcca4 100644
--- a/zbd.c
+++ b/zbd.c
@@ -312,13 +312,23 @@ static int init_zone_info(struct thread_data *td, struct fio_file *f)
 {
 	uint32_t nr_zones;
 	struct fio_zone_info *p;
-	uint64_t zone_size;
+	uint64_t zone_size = td->o.zone_size;
 	struct zoned_block_device_info *zbd_info = NULL;
 	pthread_mutexattr_t attr;
 	int i;
 
-	zone_size = td->o.zone_size;
-	assert(zone_size);
+	if (zone_size == 0) {
+		log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
+			f->file_name);
+		return 1;
+	}
+
+	if (zone_size < 512) {
+		log_err("%s: zone size must be at least 512 bytes for --zonemode=zbd\n\n",
+			f->file_name);
+		return 1;
+	}
+
 	nr_zones = (f->real_file_size + zone_size - 1) / zone_size;
 	zbd_info = scalloc(1, sizeof(*zbd_info) +
 			   (nr_zones + 1) * sizeof(zbd_info->zone_info[0]));
@@ -561,18 +571,8 @@ int zbd_init(struct thread_data *td)
 	for_each_file(td, f, i) {
 		if (f->filetype != FIO_TYPE_BLOCK)
 			continue;
-		if (td->o.zone_size && td->o.zone_size < 512) {
-			log_err("%s: zone size must be at least 512 bytes for --zonemode=zbd\n\n",
-				f->file_name);
-			return 1;
-		}
-		if (td->o.zone_size == 0 &&
-		    get_zbd_model(f->file_name) == ZBD_DM_NONE) {
-			log_err("%s: Specifying the zone size is mandatory for regular block devices with --zonemode=zbd\n\n",
-				f->file_name);
+		if (zbd_init_zone_info(td, f))
 			return 1;
-		}
-		zbd_init_zone_info(td, f);
 	}
 
 	if (!zbd_using_direct_io()) {
-- 
2.21.0


