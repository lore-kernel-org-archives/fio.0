Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: [PATCH 13/15] Rename exists_and_not_file() to exists_and_not_regfile()
Date: Wed, 27 Jul 2016 22:37:18 +0900
Message-Id: <1469626640-13335-13-git-send-email-kusumi.tomohiro@gmail.com>
In-Reply-To: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
References: <1469626640-13335-1-git-send-email-kusumi.tomohiro@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
List-ID: <fio@vger.kernel.org>

Renaming makes the purpose of this function more clear IMO.

Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
---
 init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init.c b/init.c
index 82b21c7..f81db3c 100644
--- a/init.c
+++ b/init.c
@@ -904,7 +904,7 @@ static const char *get_engine_name(const char *str)
 	return p;
 }
 
-static int exists_and_not_file(const char *filename)
+static int exists_and_not_regfile(const char *filename)
 {
 	struct stat sb;
 
@@ -1347,7 +1347,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (!o->filename && !td->files_index && !o->read_iolog_file) {
 		file_alloced = 1;
 
-		if (o->nr_files == 1 && exists_and_not_file(jobname))
+		if (o->nr_files == 1 && exists_and_not_regfile(jobname))
 			add_file(td, jobname, job_add_num, 0);
 		else {
 			for (i = 0; i < o->nr_files; i++)
-- 
2.5.5


