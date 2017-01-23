Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/8] Add missing free(td->sysfs_root);
Date: Tue, 24 Jan 2017 00:13:09 +0900
Message-Id: <1485184391-11036-6-git-send-email-tkusumi@tuxera.com>
In-Reply-To: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
References: <1485184391-11036-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

->sysfs_root for td (not du) is always strdup'd.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 filesetup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/filesetup.c b/filesetup.c
index eb28826..4aaa903 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1208,6 +1208,7 @@ void close_and_free_files(struct thread_data *td)
 	td->o.filename = NULL;
 	free(td->files);
 	free(td->file_locks);
+	free(td->sysfs_root);
 	td->files_index = 0;
 	td->files = NULL;
 	td->file_locks = NULL;
-- 
2.5.5


