Return-Path: <fio-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:45580 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbhIAGen (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 02:34:43 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] oslib: Fix blkzoned_get_max_open_zones()
Date: Wed,  1 Sep 2021 15:33:44 +0900
Message-Id: <20210901063344.312847-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

When the kernel does not have the sysfs atttribute file
queue/max_open_zones, blkzoned_get_max_open_zones() returns success
without initializing the max_open_zones value to 0 to indicate to the
caller (zbd_get_max_open_zones() in zbd.c) that the device limit is
unknown. If the max_open_zones variable in zbd_get_max_open_zones() is
not already 0 (depending on the memory status), the missing
initialization in blkzoned_get_max_open_zones() can cause errors or
misbehavior as an incorrect, random, limit may be used.

Fix this by always initializing max_open_zones to 0 when the
max_open_zones sysfs attribute file does not exist.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 oslib/linux-blkzoned.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 4e441d29..185bd501 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -169,8 +169,10 @@ int blkzoned_get_max_open_zones(struct thread_data *td, struct fio_file *f,
 		return -EIO;
 
 	max_open_str = blkzoned_get_sysfs_attr(f->file_name, "queue/max_open_zones");
-	if (!max_open_str)
+	if (!max_open_str) {
+		*max_open_zones = 0;
 		return 0;
+	}
 
 	dprint(FD_ZBD, "%s: max open zones supported by device: %s\n",
 	       f->file_name, max_open_str);
-- 
2.31.1


