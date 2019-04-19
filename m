Return-Path: <prvs=005c7cb4a=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] zbd: Fix zone report handling
Date: Fri, 19 Apr 2019 12:40:49 +0900
Message-Id: <20190419034049.10226-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

fio may be executed concurrently with a block device revalidation by
the kernel. Device revalidation may lead to the block device capacity
to be changed to a smaller value (device changed) or to even 0 in case
of revalidation failure. In such case, the BLKREPORTZONE ioctl
executed from read_zone_info() may report a success with an empty zone
report when the start sector for the report is above the new capacity
of the device. This leads to an infinite loop inside parse_zone_info()
and the fio run never terminating.

Fix this problem by returning -EIO from read_zone_info() thus
avoiding the infinite loop in parse_zone_info(). This change does not
affect the normal case with a stable device as read_zone_info() is
always called with a valid start sector that does not result in an
empty zone report.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 zbd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/zbd.c b/zbd.c
index 2da742b7..1c46b452 100644
--- a/zbd.c
+++ b/zbd.c
@@ -186,11 +186,14 @@ static bool zbd_verify_bs(void)
  * size of @buf.
  *
  * Returns 0 upon success and a negative error code upon failure.
+ * If the zone report is empty, always assume an error (device problem) and
+ * return -EIO.
  */
 static int read_zone_info(int fd, uint64_t start_sector,
 			  void *buf, unsigned int bufsz)
 {
 	struct blk_zone_report *hdr = buf;
+	int ret;
 
 	if (bufsz < sizeof(*hdr))
 		return -EINVAL;
@@ -199,7 +202,12 @@ static int read_zone_info(int fd, uint64_t start_sector,
 
 	hdr->nr_zones = (bufsz - sizeof(*hdr)) / sizeof(struct blk_zone);
 	hdr->sector = start_sector;
-	return ioctl(fd, BLKREPORTZONE, hdr) >= 0 ? 0 : -errno;
+	ret = ioctl(fd, BLKREPORTZONE, hdr);
+	if (ret)
+		return -errno;
+	if (!hdr->nr_zones)
+		return -EIO;
+	return 0;
 }
 
 /*
-- 
2.20.1


