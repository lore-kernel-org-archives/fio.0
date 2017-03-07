Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 04/17] Avoid irrelevant "offset extend ends" error message for chrdev
Date: Tue,  7 Mar 2017 22:12:55 +0200
Message-Id: <20170307201308.66814-5-tkusumi@tuxera.com>
In-Reply-To: <20170307201308.66814-1-tkusumi@tuxera.com>
References: <20170307201308.66814-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit expands 957c81b9 to chrdev as well when char_size()
is configured (i.e. FIO_HAVE_CHARDEV_SIZE disabled) to just return
0 with ->real_file_size set to -1.

Platforms without FIO_HAVE_CHARDEV_SIZE enabled basically means
block devices are blkdev as a file type, so having this change
or not most likely makes no difference. If an I/O engine needs
to use chrdev (e.g. sgio) it usually has its own .get_file_size.

Also add a dprint(FD_FILE) message since ->file_offset is normally
0 at this point regardless of offset option value, despite having
a conditional to check this against ->real_file_size.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 793b08d..edc56a3 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -377,12 +377,8 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else {
-		f->real_file_size = -1;
-		log_info("%s: failed to get file size of %s\n", td->o.name,
-					f->file_name);
-		return 1; /* avoid offset extends end error message */
-	}
+	else
+		f->real_file_size = -1ULL;
 
 	/*
 	 * Leave ->real_file_size with 0 since it could be expectation
@@ -392,10 +388,22 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		return ret;
 
 	/*
+	 * If ->real_file_size is -1, a conditional for the message
+	 * "offset extends end" is always true, but it makes no sense,
+	 * so just return the same value here.
+	 */
+	if (f->real_file_size == -1ULL) {
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1;
+	}
+
+	if (td->o.start_offset && f->file_offset == 0)
+		dprint(FD_FILE, "offset of file %s not initialized yet\n",
+					f->file_name);
+	/*
 	 * ->file_offset normally hasn't been initialized yet, so this
-	 * is basically always false unless ->real_file_size is -1, but
-	 * if ->real_file_size is -1 this message doesn't make sense.
-	 * As a result, this message is basically useless.
+	 * is basically always false.
 	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
-- 
2.9.3


