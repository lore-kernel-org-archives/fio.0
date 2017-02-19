Return-Path: <tkusumi@tuxera.com>
From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: [PATCH 2/6] Avoid irrelevant "offset extend ends" error message
Date: Sun, 19 Feb 2017 20:22:19 +0200
Message-ID: <20170219182223.120559-2-tkusumi@tuxera.com>
In-Reply-To: <20170219182223.120559-1-tkusumi@tuxera.com>
References: <20170219182223.120559-1-tkusumi@tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

When ->real_file_size is -1 due to unsupported file type/etc,
"if (f->file_offset > f->real_file_size)" conditional is always true
(unless ->file_offset is also negative which is an another problem),
and results in irrelevant error message. To avoid this, just return
1 without showing the irrelevant error message and then return 1.

It's still possible that char_size() returns with ->real_file_size
set to -1 (though platform dependent), and the irrelevant error
message be shown.

Also this message itself isn't likely to show any relevant info
due to the timing it's been called as mentioned in a comment.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/filesetup.c b/filesetup.c
index 74551a4..3217e4f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -374,12 +374,22 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
-	else
+	else {
 		f->real_file_size = -1;
+		log_info("%s: failed to get file size of %s\n", td->o.name,
+					f->file_name);
+		return 1; /* avoid offset extends end error message */
+	}
 
 	if (ret)
 		return ret;
 
+	/*
+	 * ->file_offset normally hasn't been initialized yet, so this
+	 * is basically always false unless ->real_file_size is -1, but
+	 * if ->real_file_size is -1 this message doesn't make sense.
+	 * As a result, this message is basically useless.
+	 */
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
 					(unsigned long long) f->file_offset,
-- 
2.9.3


