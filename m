Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/8] Fix bad pointer du->sysfs_root
Date: Tue, 24 Jan 2017 00:13:10 +0900
Message-Id: <1485184391-11036-7-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

There are two call paths for disk_util_add() (usually the second one)
which assigns ->sysfs_root for a newly allocated disk_util*, but both
temppath/foo are local char[] within their stack, so strdup/free it.

-> find_add_disk_slaves(...)
  -> __init_per_file_disk_util(..., temppath)
    -> disk_util_add(..., path)
      -> du->sysfs_root = path; /* == &temppath[0] */

-> init_per_file_disk_util(...)
  -> __init_per_file_disk_util(..., foo)
    -> disk_util_add(..., path)
      -> du->sysfs_root = path; /* == &foo[0] */

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 diskutil.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/diskutil.c b/diskutil.c
index 27ddb46..c34841a 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -37,6 +37,7 @@ static void disk_util_free(struct disk_util *du)
 	}
 
 	fio_mutex_remove(du->lock);
+	free(du->sysfs_root);
 	sfree(du);
 }
 
@@ -305,7 +306,7 @@ static struct disk_util *disk_util_add(struct thread_data *td, int majdev,
 		return NULL;
 	}
 	strncpy((char *) du->dus.name, basename(path), FIO_DU_NAME_SZ - 1);
-	du->sysfs_root = path;
+	du->sysfs_root = strdup(path);
 	du->major = majdev;
 	du->minor = mindev;
 	INIT_FLIST_HEAD(&du->slavelist);
-- 
2.5.5


