Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH] Revert "Avoid irrelevant "offset extend ends" error message for chrdev"
Date: Wed, 29 Nov 2017 11:29:22 +0200
Message-Id: <20171129092922.4109-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org, elliott@hpe.com
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

This reverts commit 0f34169ac64f009b193bed1c8fb6692844bf99c2.

> Commit 0f34169a broke it, moving a check from a non-character
> device path up a level to where it now triggers on a character
> device (for which the size is left set to -1ULL).
>
> This gets it working again:
>         git revert 0f34169a
>         make
>
> Tomohiro, could you help prepare a better fix?

Sorry, I'll just revert it at the moment.
---
 filesetup.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 4d29b70a..1d586b17 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -435,8 +435,12 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else
-		f->real_file_size = -1ULL;
+	else {
+		f->real_file_size = -1;
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1; /* avoid offset extends end error message */
+	}
 
 	/*
 	 * Leave ->real_file_size with 0 since it could be expectation
@@ -446,22 +450,10 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		return ret;
 
 	/*
-	 * If ->real_file_size is -1, a conditional for the message
-	 * "offset extends end" is always true, but it makes no sense,
-	 * so just return the same value here.
-	 */
-	if (f->real_file_size == -1ULL) {
-		log_info("%s: failed to get file size of %s\n", td->o.name,
-					f->file_name);
-		return 1;
-	}
-
-	if (td->o.start_offset && f->file_offset == 0)
-		dprint(FD_FILE, "offset of file %s not initialized yet\n",
-					f->file_name);
-	/*
 	 * ->file_offset normally hasn't been initialized yet, so this
-	 * is basically always false.
+	 * is basically always false unless ->real_file_size is -1, but
+	 * if ->real_file_size is -1 this message doesn't make sense.
+	 * As a result, this message is basically useless.
 	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
-- 
2.13.6


