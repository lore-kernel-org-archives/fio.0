Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/7] Make check_mount_writes() test appropriate device types
Date: Mon, 13 Mar 2017 20:14:57 +0200
Message-Id: <20170313181503.33322-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

There are platforms that use chrdev (instead of blkdev) for block
devices, thus check_mount_writes() needs to test an appropriate file
type(s) for potential mounted devices.

fio has had a macro FIO_HAVE_CHARDEV_SIZE basically for those using
chrdev for block devices, and this macro can be used here as well.

In FreeBSD and several others, blkdev is no longer used as a file type,
so it's safe to only test FIO_TYPE_CHAR if FIO_HAVE_CHARDEV_SIZE is
defined, but this commit leaves FIO_TYPE_BLOCK test since some
platforms may have/use both for block devices (not sure if exist).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/backend.c b/backend.c
index 2e8a994..b61de7c 100644
--- a/backend.c
+++ b/backend.c
@@ -2056,8 +2056,16 @@ static bool check_mount_writes(struct thread_data *td)
 	if (!td_write(td) || td->o.allow_mounted_write)
 		return false;
 
+	/*
+	 * If FIO_HAVE_CHARDEV_SIZE is defined, it's likely that chrdevs
+	 * are mkfs'd and mounted.
+	 */
 	for_each_file(td, f, i) {
+#ifdef FIO_HAVE_CHARDEV_SIZE
+		if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR)
+#else
 		if (f->filetype != FIO_TYPE_BLOCK)
+#endif
 			continue;
 		if (device_is_mounted(f->file_name))
 			goto mounted;
-- 
2.9.3


