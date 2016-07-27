Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 02/15] Fix typos in log_err() message
Date: Wed, 27 Jul 2016 22:37:07 +0900
Message-Id: <1469626640-13335-2-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 filesetup.c | 2 +-
 init.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 012773b..d208a69 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -329,7 +329,7 @@ static int char_size(struct thread_data *td, struct fio_file *f)
 	int r;
 
 	if (td->io_ops->open_file(td, f)) {
-		log_err("fio: failed opening blockdev %s for size check\n",
+		log_err("fio: failed opening chardev %s for size check\n",
 			f->file_name);
 		return 1;
 	}
diff --git a/init.c b/init.c
index 065a71a..47519bf 100644
--- a/init.c
+++ b/init.c
@@ -860,7 +860,7 @@ static int fixup_options(struct thread_data *td)
 		td->loops = 1;
 
 	if (td->o.block_error_hist && td->o.nr_files != 1) {
-		log_err("fio: block error histogram only available with "
+		log_err("fio: block error histogram only available "
 			"with a single file per job, but %d files "
 			"provided\n", td->o.nr_files);
 		ret = 1;
-- 
2.5.5


