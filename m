Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:43200 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242074AbhIAGmv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 1 Sep 2021 02:42:51 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH V2] oslib: Fix blkzoned_get_max_open_zones()
Date: Wed,  1 Sep 2021 15:41:53 +0900
Message-Id: <20210901064153.312953-1-damien.lemoal@wdc.com>
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

Reported-by: Bao-Hua Li <baohua.li@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes from v1:
* Added missing reported-by tag

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


