Return-Path: <fio-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:48367 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgHUGhn (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Aug 2020 02:37:43 -0400
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 2/7] oslib/linux-blkzoned: Allow reset zone before file set up
Date: Fri, 21 Aug 2020 15:37:34 +0900
Message-Id: <20200821063739.390353-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
References: <20200821063739.390353-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To reset zones before file set up completion, modify the helper function
blkzoned_reset_wp() to work even when fio_file struct does not have valid
file descriptor yet. If the file descriptor is not available, open and
close the reset target file within the function. Otherwise use the
available descriptor to avoid file open/close overhead.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 oslib/linux-blkzoned.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/oslib/linux-blkzoned.c b/oslib/linux-blkzoned.c
index 6fe78b9c..0a8a577a 100644
--- a/oslib/linux-blkzoned.c
+++ b/oslib/linux-blkzoned.c
@@ -222,9 +222,21 @@ int blkzoned_reset_wp(struct thread_data *td, struct fio_file *f,
 		.sector         = offset >> 9,
 		.nr_sectors     = length >> 9,
 	};
+	int fd, ret = 0;
+
+	/* If the file is not yet opened, open it for this function. */
+	fd = f->fd;
+	if (fd < 0) {
+		fd = open(f->file_name, O_RDWR | O_LARGEFILE);
+		if (fd < 0)
+			return -errno;
+	}
 
-	if (ioctl(f->fd, BLKRESETZONE, &zr) < 0)
-		return -errno;
+	if (ioctl(fd, BLKRESETZONE, &zr) < 0)
+		ret = -errno;
 
-	return 0;
+	if (f->fd < 0)
+		close(fd);
+
+	return ret;
 }
-- 
2.26.2


