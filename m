Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 4/7] Always set ->real_file_size to -1 when failed to get file size
Date: Tue, 14 Feb 2017 17:19:45 +0200
Message-Id: <20170214151948.16460-5-tkusumi@tuxera.com>
In-Reply-To: <20170214151948.16460-1-tkusumi@tuxera.com>
References: <20170214151948.16460-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

In some cases it's set to -1, but on others it's not,
while the existing code (e.g. get_fs_free_counts(), setup_files(), etc)
seem to expect ->real_file_size to be -1 in case of any error.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index eb28826..3fa8b32 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -375,10 +375,12 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
 	else
-		f->real_file_size = -1;
+		f->real_file_size = -1ULL;
 
-	if (ret)
+	if (ret) {
+		f->real_file_size = -1ULL;
 		return ret;
+	}
 
 	if (f->file_offset > f->real_file_size) {
 		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
-- 
2.9.3


