Return-Path: <fio-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:45248 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhDOCRT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Apr 2021 22:17:19 -0400
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2] backend: fix switch_ioscheduler()
Date: Thu, 15 Apr 2021 11:16:54 +0900
Message-Id: <20210415021654.232698-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>

The backend.c function switch_ioscheduler() suffers from several
problems:
1) This function only considers the first file of a job. For jobs using
   multiple files, the ioscheduler switch will done only for that file.
2) If the job file is a character device, a pipe or a regular file for
   which the hosting block device file cannot be determined (e.g. a
   remote file), thring to switch the IO scheduler causes a crash as the
   file disk_util field is NULL.
Fix both problems by introducing the helper function set_ioscheduler()
and changing switch_ioscheduler() to repeatdly call this helper for all
files of the job, ignoring character device files, pipe files and files
without a hosting device information.

Also update the man page to better explain when the ioscheduler option
applies.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---

Changes form v1:
* Introduce set_ioscheduler() helper
* Change switch_ioscheduler() to operate on all files of a job
* Ignore files that cannot be used to switch scheduler without reporting
  an error.

 backend.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++---------
 fio.1     |  3 ++-
 2 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/backend.c b/backend.c
index 52b4ca7e..399c299e 100644
--- a/backend.c
+++ b/backend.c
@@ -1341,22 +1341,19 @@ int init_io_u_buffers(struct thread_data *td)
 	return 0;
 }
 
+#ifdef FIO_HAVE_IOSCHED_SWITCH
 /*
- * This function is Linux specific.
+ * These functions are Linux specific.
  * FIO_HAVE_IOSCHED_SWITCH enabled currently means it's Linux.
  */
-static int switch_ioscheduler(struct thread_data *td)
+static int set_ioscheduler(struct thread_data *td, struct fio_file *file)
 {
-#ifdef FIO_HAVE_IOSCHED_SWITCH
 	char tmp[256], tmp2[128], *p;
 	FILE *f;
 	int ret;
 
-	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
-		return 0;
-
-	assert(td->files && td->files[0]);
-	sprintf(tmp, "%s/queue/scheduler", td->files[0]->du->sysfs_root);
+	assert(file->du && file->du->sysfs_root);
+	sprintf(tmp, "%s/queue/scheduler", file->du->sysfs_root);
 
 	f = fopen(tmp, "r+");
 	if (!f) {
@@ -1417,11 +1414,55 @@ static int switch_ioscheduler(struct thread_data *td)
 
 	fclose(f);
 	return 0;
+}
+
+static int switch_ioscheduler(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+	int ret = 0;
+
+	if (td_ioengine_flagged(td, FIO_DISKLESSIO))
+		return 0;
+
+	assert(td->files && td->files[0]);
+
+	for_each_file(td, f, i) {
+
+		/* Only consider regular files and block device files */
+		switch (f->filetype) {
+		case FIO_TYPE_FILE:
+		case FIO_TYPE_BLOCK:
+			/*
+			 * Make sure that the device hosting the file could
+			 * be determined.
+			 */
+			if (!f->du)
+				continue;
+			break;
+		case FIO_TYPE_CHAR:
+		case FIO_TYPE_PIPE:
+		default:
+			continue;
+		}
+
+		ret = set_ioscheduler(td, f);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #else
+
+static int switch_ioscheduler(struct thread_data *td)
+{
 	return 0;
-#endif
 }
 
+#endif /* FIO_HAVE_IOSCHED_SWITCH */
+
 static bool keep_running(struct thread_data *td)
 {
 	unsigned long long limit;
diff --git a/fio.1 b/fio.1
index f959e00d..8c46d5f0 100644
--- a/fio.1
+++ b/fio.1
@@ -690,7 +690,8 @@ of how that would work.
 .TP
 .BI ioscheduler \fR=\fPstr
 Attempt to switch the device hosting the file to the specified I/O scheduler
-before running.
+before running. If the file is a pipe, a character device file or if device
+hosting the file could not be determined, this option is ignored.
 .TP
 .BI create_serialize \fR=\fPbool
 If true, serialize the file creation for the jobs. This may be handy to
-- 
2.30.2


