Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 3/4] Null terminate before (or after) strncpy(3)
Date: Sat, 30 Jul 2016 00:05:59 +0900
Message-Id: <1469804760-17333-3-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469804760-17333-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

These three strncpy() calls copy at most sizeof(buffer)-1 bytes,
but buffer isn't explicitly 0 cleared, so 0 terminate the last byte.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 diskutil.c  |    2 ++
 ioengines.c |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/diskutil.c b/diskutil.c
index 294d2d3..a1077d4 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -179,6 +179,7 @@ static int get_device_numbers(char *file_name, int *maj, int *min)
 		/*
 		 * must be a file, open "." in that path
 		 */
+		tempname[PATH_MAX - 1] = '\0';
 		strncpy(tempname, file_name, PATH_MAX - 1);
 		p = dirname(tempname);
 		if (stat(p, &st)) {
@@ -426,6 +427,7 @@ static struct disk_util *__init_per_file_disk_util(struct thread_data *td,
 			log_err("unknown sysfs layout\n");
 			return NULL;
 		}
+		tmp[PATH_MAX - 1] = '\0';
 		strncpy(tmp, p, PATH_MAX - 1);
 		sprintf(path, "%s", tmp);
 	}
diff --git a/ioengines.c b/ioengines.c
index 918b50a..f7b5ed6 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -130,6 +130,7 @@ struct ioengine_ops *load_ioengine(struct thread_data *td, const char *name)
 
 	dprint(FD_IO, "load ioengine %s\n", name);
 
+	engine[sizeof(engine) - 1] = '\0';
 	strncpy(engine, name, sizeof(engine) - 1);
 
 	/*
-- 
1.7.1


