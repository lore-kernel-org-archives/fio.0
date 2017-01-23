Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 5/8] Remove unused disk_util's name field
Date: Tue, 24 Jan 2017 00:13:08 +0900
Message-Id: <1485184391-11036-5-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 diskutil.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/diskutil.h b/diskutil.h
index ff8a5b0..04fdde2 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -46,7 +46,6 @@ struct disk_util {
 	 */
 	struct flist_head slavelist;
 
-	char *name;
 	char *sysfs_root;
 	char path[PATH_MAX];
 	int major, minor;
-- 
2.5.5


