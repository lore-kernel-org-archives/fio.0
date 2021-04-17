Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235901AbhDQMA4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Apr 2021 08:00:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8243C061574
        for <fio@vger.kernel.org>; Sat, 17 Apr 2021 05:00:27 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lXjcK-00BDxX-IK
        for fio@vger.kernel.org; Sat, 17 Apr 2021 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210417120001.D13651BC014A@kernel.dk>
Date: Sat, 17 Apr 2021 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5561e9dddca8479f182f0269a760dcabe7ff59ad:

  engines: add engine for file delete (2021-04-16 05:56:19 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5592e99219864e21b425cfc66fa05ece5b514259:

  backend: fix switch_ioscheduler() (2021-04-16 10:25:24 -0600)

----------------------------------------------------------------
Damien Le Moal (1):
      backend: fix switch_ioscheduler()

 backend.c | 59 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 fio.1     |  3 ++-
 2 files changed, 52 insertions(+), 10 deletions(-)

---

Diff of recent changes:

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
index c59a8002..18dc156a 100644
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

