Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 3/7] Drop conditional declaration of disk_list
Date: Tue, 14 Feb 2017 17:19:44 +0200
Message-Id: <20170214151948.16460-4-tkusumi@tuxera.com>
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

disk_list is used unconditionally whether it's Linux or not,
so leave the one in libfio.c, and remove the one in diskutil.c.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 diskutil.c | 2 --
 libfio.c   | 5 -----
 2 files changed, 7 deletions(-)

diff --git a/diskutil.c b/diskutil.c
index c3bcec9..dca3748 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -18,8 +18,6 @@ static struct disk_util *last_du;
 
 static struct fio_mutex *disk_util_mutex;
 
-FLIST_HEAD(disk_list);
-
 static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 		int majdev, int mindev, char *path);
 
diff --git a/libfio.c b/libfio.c
index 7e0d32c..4b53c92 100644
--- a/libfio.c
+++ b/libfio.c
@@ -36,12 +36,7 @@
 #include "helper_thread.h"
 #include "filehash.h"
 
-/*
- * Just expose an empty list, if the OS does not support disk util stats
- */
-#ifndef FIO_HAVE_DISK_UTIL
 FLIST_HEAD(disk_list);
-#endif
 
 unsigned long arch_flags = 0;
 
-- 
2.9.3


