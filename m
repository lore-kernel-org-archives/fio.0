Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43158 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387393AbgAXNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Jan 2020 08:00:05 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iuyZA-0006bf-FF
        for fio@vger.kernel.org; Fri, 24 Jan 2020 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200124130001.B83FF1BC016A@kernel.dk>
Date: Fri, 24 Jan 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 4ee9c375b64de236356cc97843d84978edeba491:

  stat: ensure we align correctly (2020-01-22 19:53:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8178434ccba8e2d06684ce0c730b0eda571c5280:

  Merge branch 'filestat1' of https://github.com/kusumi/fio (2020-01-23 11:35:23 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'filestat1' of https://github.com/kusumi/fio

Tomohiro Kusumi (1):
      engines/filestat: add "lstat" option to use lstat(2)

 HOWTO              |  4 ++++
 engines/filestat.c | 33 +++++++++++++++++++++++++++++++--
 fio.1              |  3 +++
 optgroup.h         |  2 ++
 4 files changed, 40 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0a366168..f19f9226 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2261,6 +2261,10 @@ with the caveat that when used on the command line, they must come after the
 	multiple paths exist between the client and the server or in certain loopback
 	configurations.
 
+.. option:: lstat=bool : [filestat]
+
+	Use lstat(2) to measure lookup/getattr performance. Default is 0.
+
 .. option:: readfua=bool : [sg]
 
 	With readfua option set to 1, read operations include
diff --git a/engines/filestat.c b/engines/filestat.c
index 79525934..6c87c4c2 100644
--- a/engines/filestat.c
+++ b/engines/filestat.c
@@ -11,13 +11,36 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include "../fio.h"
+#include "../optgroup.h"
 
 struct fc_data {
 	enum fio_ddir stat_ddir;
 };
 
+struct filestat_options {
+	void *pad;
+	unsigned int lstat;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "lstat",
+		.lname	= "lstat",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct filestat_options, lstat),
+		.help	= "Use lstat(2) to measure lookup/getattr performance",
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_FILESTAT,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 static int stat_file(struct thread_data *td, struct fio_file *f)
 {
+	struct filestat_options *o = td->eo;
 	struct timespec start;
 	int do_lat = !td->o.disable_lat;
 	struct stat statbuf;
@@ -37,13 +60,17 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 	if (do_lat)
 		fio_gettime(&start, NULL);
 
-	ret = stat(f->file_name, &statbuf);
+	if (o->lstat)
+		ret = lstat(f->file_name, &statbuf);
+	else
+		ret = stat(f->file_name, &statbuf);
 
 	if (ret == -1) {
 		char buf[FIO_VERROR_SIZE];
 		int e = errno;
 
-		snprintf(buf, sizeof(buf), "stat(%s)", f->file_name);
+		snprintf(buf, sizeof(buf), "%sstat(%s)",
+			o->lstat ? "l" : "", f->file_name);
 		td_verror(td, e, buf);
 		return 1;
 	}
@@ -103,6 +130,8 @@ static struct ioengine_ops ioengine = {
 	.open_file	= stat_file,
 	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
 				FIO_NOSTATS | FIO_NOFILEHASH,
+	.options	= options,
+	.option_struct_size = sizeof(struct filestat_options),
 };
 
 static void fio_init fio_filestat_register(void)
diff --git a/fio.1 b/fio.1
index 05896e61..a58632b4 100644
--- a/fio.1
+++ b/fio.1
@@ -2032,6 +2032,9 @@ on the client site it will be used in the rdma_resolve_add()
 function. This can be useful when multiple paths exist between the
 client and the server or in certain loopback configurations.
 .TP
+.BI (filestat)lstat \fR=\fPbool
+Use \fBlstat\fR\|(2) to measure lookup/getattr performance. Default: 0.
+.TP
 .BI (sg)readfua \fR=\fPbool
 With readfua option set to 1, read operations include the force
 unit access (fua) flag. Default: 0.
diff --git a/optgroup.h b/optgroup.h
index 55ef5934..5789afd3 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -65,6 +65,7 @@ enum opt_category_group {
 	__FIO_OPT_G_ISCSI,
 	__FIO_OPT_G_NBD,
 	__FIO_OPT_G_IOURING,
+	__FIO_OPT_G_FILESTAT,
 	__FIO_OPT_G_NR,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
@@ -106,6 +107,7 @@ enum opt_category_group {
 	FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),
 	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
 	FIO_OPT_G_IOURING	= (1ULL << __FIO_OPT_G_IOURING),
+	FIO_OPT_G_FILESTAT	= (1ULL << __FIO_OPT_G_FILESTAT),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);

