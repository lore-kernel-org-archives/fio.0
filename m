Return-Path: <josef@toxicpanda.com>
Return-Path: <josef@toxicpanda.com>
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 1/2] use mkdir instead of mkdirat
Date: Wed, 11 Oct 2017 16:15:18 -0400
Message-Id: <1507752919-14323-1-git-send-email-josef@toxicpanda.com>
To: axboe@kernel.dk, fio@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

Windows doesn't have a way to do mkdirat, so convert to mkdir instead.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 filesetup.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index b390caa29526..0dd3809baf5f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1523,43 +1523,36 @@ bool exists_and_not_regfile(const char *filename)
 	return true;
 }
 
-static void create_work_dirs(struct thread_data *td, const char *fname)
+static int create_work_dirs(struct thread_data *td, const char *fname)
 {
 	char path[PATH_MAX];
 	char *start, *end;
-	int dirfd;
-	bool need_close = true;
 
 	if (td->o.directory) {
-		dirfd = open(td->o.directory, O_DIRECTORY | O_RDONLY);
-		if (dirfd < 0) {
-			log_err("fio: failed to open dir (%s): %d\n",
-				td->o.directory, errno);
-			assert(0);
-		}
+		snprintf(path, PATH_MAX, "%s%c%s", td->o.directory,
+			 FIO_OS_PATH_SEPARATOR, fname);
+		start = strstr(path, fname);
 	} else {
-		dirfd = AT_FDCWD;
-		need_close = false;
+		snprintf(path, PATH_MAX, "%s", fname);
+		start = path;
 	}
 
-	memcpy(path, fname, PATH_MAX);
-	start = end = path;
+	end = start;
 	while ((end = strchr(end, FIO_OS_PATH_SEPARATOR)) != NULL) {
 		if (end == start)
 			break;
 		*end = '\0';
 		errno = 0;
-		if (mkdirat(dirfd, start, 0600) && errno != EEXIST) {
+		if (mkdir(path, 0600) && errno != EEXIST) {
 			log_err("fio: failed to create dir (%s): %d\n",
 				start, errno);
-			assert(0);
+			return 1;
 		}
 		*end = FIO_OS_PATH_SEPARATOR;
 		end++;
 	}
-	if (need_close)
-		close(dirfd);
 	td->flags |= TD_F_DIRS_CREATED;
+	return 0;
 }
 
 int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
@@ -1578,8 +1571,9 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	sprintf(file_name + len, "%s", fname);
 
 	if (strchr(fname, FIO_OS_PATH_SEPARATOR) &&
-	    !(td->flags & TD_F_DIRS_CREATED))
-		create_work_dirs(td, fname);
+	    !(td->flags & TD_F_DIRS_CREATED) &&
+	    create_work_dirs(td, fname))
+		return 1;
 
 	/* clean cloned siblings using existing files */
 	if (numjob && is_already_allocated(file_name) &&
-- 
2.7.4


