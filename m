Return-Path: <fio-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:48668 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhDNLLS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Apr 2021 07:11:18 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] backend: fix switch_ioscheduler()
Date: Wed, 14 Apr 2021 20:10:56 +0900
Message-Id: <20210414111056.213360-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

If the first file specified for a job is not a block device file, the
ioscheduler option cannot be used. Trying to use this option can cause a
crash as that file du (struct disk_util) field is NULL. Prevent such
crash and signal the error by testing the file type, allowing only files
with the type FIO_TYPE_BLOCK to proceed with switching the IO scheduler.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 backend.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/backend.c b/backend.c
index 52b4ca7e..18372a92 100644
--- a/backend.c
+++ b/backend.c
@@ -1356,6 +1356,12 @@ static int switch_ioscheduler(struct thread_data *td)
 		return 0;
 
 	assert(td->files && td->files[0]);
+	if (td->files[0]->filetype != FIO_TYPE_BLOCK) {
+		log_err("fio: cannot switch IO scheduler with file %s\n",
+			td->files[0]->file_name);
+		return -1;
+	}
+
 	sprintf(tmp, "%s/queue/scheduler", td->files[0]->du->sysfs_root);
 
 	f = fopen(tmp, "r+");
-- 
2.30.2


