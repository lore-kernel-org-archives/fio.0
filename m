Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51814DF53
	for <fio@vger.kernel.org>; Sat, 23 Mar 2024 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711195212; cv=none; b=nO9HXK0w1gQoDBxWyXpVrkjsi+hSnNwO18NS49kOIhPaNTmhSkayJhY5PlYSfyMliC1pXwb8s6IOUZ9/C357zaXfL1VHeVB+loBN5NzStaqlW/NJAJsMpkE2oOuNHRKe3WU2hYnnF41ce1EyR8TyImV5Hqh4G5+UXzrlrdsOT20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711195212; c=relaxed/simple;
	bh=A8PTsbKNLdw6WlRCvWOgfj5wnkXMN9hgxO4hun7X+Ks=;
	h=Subject:From:To:Message-Id:Date; b=PLmnLoRMzm/x3rwKGNw29yBqhm+FZv9F+7jfehXPdKcUY05waWJpkmORFrY/BAd8/atgvtgVxUuM/UKYVwLWUQlXN7AhV5VwOd1Ea277AqAdbiuR981BnzGMg9ep16hUJjZyOLEcH+352K3bs3jFL8UMXrJ32mIEtMCOvW2F/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vkIoV1Qs; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vkIoV1Qs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=tYyvjiLxnZfkgqkahYp9C1DzaEtXdms/hTSnkFQguOY=; b=vkIoV1QsqWuLYqFukmBi+5fuBN
	ownG/dWDh2X9e0eUWMpd80WlrFDybGHcIp1egqAl3wdFnIz1gQSHqETICOtFHBRYXpk1Ndn42Uz5e
	jiP89RCSd5bbL1kLGxrbj8UGwVZpQ+n0WJ58Bc3cczL4AqZaXMLR2/Tj/XWTULaEpt0S6YkogER2+
	wO3+LG4WB2Smf2yPZYNs3KFOsOK6qgVYS+tathosF1HmhcHSs40xTwrWCzPvNmxKOUTM/gu7K0LbR
	EoxuTDNG0OxCTnED0GEK3nZtQwJgkSXGJp2/yZx4dOfuUDeIrf10MaRAC4IOn1zRJCSE8IJ5dvTJY
	8uA9eeWg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ro02e-0000000BhsZ-21ib
	for fio@vger.kernel.org;
	Sat, 23 Mar 2024 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 9AE3C1BC0139; Sat, 23 Mar 2024 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20240323120001.9AE3C1BC0139@kernel.dk>
Date: Sat, 23 Mar 2024 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 20f42c101f7876648705a4fb8a9e2a647dc936ce:

  t/run-fio-tests: restrict t0031 to Linux only (2024-03-21 08:36:14 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b03792ceb7ed00bd50db5b59486fab902295df8:

  Merge branch 'issue-1735' of https://github.com/yygcode/fio (2024-03-22 10:39:37 -0400)

----------------------------------------------------------------
Vincent Fu (4):
      engines/fileoperations: remove extra blank lines
      engines/fileoperations: use local var for ioengine data
      examples: fiograph plots for dir operation ioengines
      Merge branch 'issue-1735' of https://github.com/yygcode/fio

friendy-su (1):
      ioengines: implement dircreate, dirstat, dirdelete engines to fileoperations.c

yonggang.yyg (1):
      iolog: fix disk stats issue

 HOWTO.rst                       |  15 +++++
 engines/fileoperations.c        | 119 ++++++++++++++++++++++++++++++++++++++--
 examples/dircreate-ioengine.fio |  25 +++++++++
 examples/dircreate-ioengine.png | Bin 0 -> 42659 bytes
 examples/dirdelete-ioengine.fio |  18 ++++++
 examples/dirdelete-ioengine.png | Bin 0 -> 45530 bytes
 examples/dirstat-ioengine.fio   |  18 ++++++
 examples/dirstat-ioengine.png   | Bin 0 -> 33597 bytes
 fio.1                           |  15 +++++
 iolog.c                         |   2 +
 10 files changed, 206 insertions(+), 6 deletions(-)
 create mode 100644 examples/dircreate-ioengine.fio
 create mode 100644 examples/dircreate-ioengine.png
 create mode 100644 examples/dirdelete-ioengine.fio
 create mode 100644 examples/dirdelete-ioengine.png
 create mode 100644 examples/dirstat-ioengine.fio
 create mode 100644 examples/dirstat-ioengine.png

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 4c8ac331..fb067fe5 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2192,6 +2192,21 @@ I/O engine
 			and 'nrfiles', so that the files will be created.
 			This engine is to measure file delete.
 
+		**dircreate**
+			Simply create the directories and do no I/O to them.  You still need to
+			set  `filesize` so that all the accounting still occurs, but no
+			actual I/O will be done other than creating the directories.
+
+		**dirstat**
+			Simply do stat() and do no I/O to the directories. You need to set 'filesize'
+			and 'nrfiles', so that directories will be created.
+			This engine is to measure directory lookup and meta data access.
+
+		**dirdelete**
+			Simply delete the directories by rmdir() and do no I/O to them. You need to set 'filesize'
+			and 'nrfiles', so that the directories will be created.
+			This engine is to measure directory delete.
+
 		**libpmem**
 			Read and write using mmap I/O to a file on a filesystem
 			mounted with DAX on a persistent memory device through the PMDK
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index 1db60da1..c52f0900 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -1,8 +1,8 @@
 /*
- * fileoperations engine
+ * file/directory operations engine
  *
- * IO engine that doesn't do any IO, just operates files and tracks the latency
- * of the file operation.
+ * IO engine that doesn't do any IO, just operates files/directories
+ * and tracks the latency of the operation.
  */
 #include <stdio.h>
 #include <stdlib.h>
@@ -15,9 +15,15 @@
 #include "../optgroup.h"
 #include "../oslib/statx.h"
 
+enum fio_engine {
+	UNKNOWN_OP_ENGINE = 0,
+	FILE_OP_ENGINE = 1,
+	DIR_OP_ENGINE = 2,
+};
 
 struct fc_data {
 	enum fio_ddir stat_ddir;
+	enum fio_engine op_engine;
 };
 
 struct filestat_options {
@@ -61,11 +67,30 @@ static struct fio_option options[] = {
 	},
 };
 
+static int setup_dirs(struct thread_data *td)
+{
+	int ret = 0;
+	int i;
+	struct fio_file *f;
+
+	for_each_file(td, f, i) {
+		dprint(FD_FILE, "setup directory %s\n", f->file_name);
+		ret = fio_mkdir(f->file_name, 0700);
+		if ((ret && errno != EEXIST)) {
+			log_err("create directory %s failed with %d\n",
+				f->file_name, errno);
+			break;
+		}
+		ret = 0;
+	}
+	return ret;
+}
 
 static int open_file(struct thread_data *td, struct fio_file *f)
 {
 	struct timespec start;
 	int do_lat = !td->o.disable_lat;
+	struct fc_data *fcd = td->io_ops_data;
 
 	dprint(FD_FILE, "fd open %s\n", f->file_name);
 
@@ -81,7 +106,14 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 	if (do_lat)
 		fio_gettime(&start, NULL);
 
-	f->fd = open(f->file_name, O_CREAT|O_RDWR, 0600);
+	if (fcd->op_engine == FILE_OP_ENGINE)
+		f->fd = open(f->file_name, O_CREAT|O_RDWR, 0600);
+	else if (fcd->op_engine == DIR_OP_ENGINE)
+		f->fd = fio_mkdir(f->file_name, S_IFDIR);
+	else {
+		log_err("fio: unknown file/directory operation engine\n");
+		return 1;
+	}
 
 	if (f->fd == -1) {
 		char buf[FIO_VERROR_SIZE];
@@ -174,11 +206,11 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-
 static int delete_file(struct thread_data *td, struct fio_file *f)
 {
 	struct timespec start;
 	int do_lat = !td->o.disable_lat;
+	struct fc_data *fcd = td->io_ops_data;
 	int ret;
 
 	dprint(FD_FILE, "fd delete %s\n", f->file_name);
@@ -195,7 +227,14 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
 	if (do_lat)
 		fio_gettime(&start, NULL);
 
-	ret = unlink(f->file_name);
+	if (fcd->op_engine == FILE_OP_ENGINE)
+		ret = unlink(f->file_name);
+	else if (fcd->op_engine == DIR_OP_ENGINE)
+		ret = rmdir(f->file_name);
+	else {
+		log_err("fio: unknown file/directory operation engine\n");
+		return 1;
+	}
 
 	if (ret == -1) {
 		char buf[FIO_VERROR_SIZE];
@@ -250,6 +289,17 @@ static int init(struct thread_data *td)
 	else if (td_write(td))
 		data->stat_ddir = DDIR_WRITE;
 
+	data->op_engine = UNKNOWN_OP_ENGINE;
+
+	if (!strncmp(td->o.ioengine, "file", 4)) {
+		data->op_engine = FILE_OP_ENGINE;
+		dprint(FD_FILE, "Operate engine type: file\n");
+	}
+	if (!strncmp(td->o.ioengine, "dir", 3)) {
+		data->op_engine = DIR_OP_ENGINE;
+		dprint(FD_FILE, "Operate engine type: directory\n");
+	}
+
 	td->io_ops_data = data;
 	return 0;
 }
@@ -261,6 +311,12 @@ static void cleanup(struct thread_data *td)
 	free(data);
 }
 
+static int remove_dir(struct thread_data *td, struct fio_file *f)
+{
+	dprint(FD_FILE, "remove directory %s\n", f->file_name);
+	return rmdir(f->file_name);
+}
+
 static struct ioengine_ops ioengine_filecreate = {
 	.name		= "filecreate",
 	.version	= FIO_IOOPS_VERSION,
@@ -302,12 +358,60 @@ static struct ioengine_ops ioengine_filedelete = {
 				FIO_NOSTATS | FIO_NOFILEHASH,
 };
 
+static struct ioengine_ops ioengine_dircreate = {
+	.name		= "dircreate",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.get_file_size	= get_file_size,
+	.open_file	= open_file,
+	.close_file	= generic_close_file,
+	.unlink_file    = remove_dir,
+	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static struct ioengine_ops ioengine_dirstat = {
+	.name		= "dirstat",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= setup_dirs,
+	.init		= init,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.invalidate	= invalidate_do_nothing,
+	.get_file_size	= generic_get_file_size,
+	.open_file	= stat_file,
+	.unlink_file	= remove_dir,
+	.flags		=  FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+	.options	= options,
+	.option_struct_size = sizeof(struct filestat_options),
+};
+
+static struct ioengine_ops ioengine_dirdelete = {
+	.name		= "dirdelete",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= setup_dirs,
+	.init		= init,
+	.invalidate	= invalidate_do_nothing,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.get_file_size	= get_file_size,
+	.open_file	= delete_file,
+	.unlink_file	= remove_dir,
+	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
 
 static void fio_init fio_fileoperations_register(void)
 {
 	register_ioengine(&ioengine_filecreate);
 	register_ioengine(&ioengine_filestat);
 	register_ioengine(&ioengine_filedelete);
+	register_ioengine(&ioengine_dircreate);
+	register_ioengine(&ioengine_dirstat);
+	register_ioengine(&ioengine_dirdelete);
 }
 
 static void fio_exit fio_fileoperations_unregister(void)
@@ -315,4 +419,7 @@ static void fio_exit fio_fileoperations_unregister(void)
 	unregister_ioengine(&ioengine_filecreate);
 	unregister_ioengine(&ioengine_filestat);
 	unregister_ioengine(&ioengine_filedelete);
+	unregister_ioengine(&ioengine_dircreate);
+	unregister_ioengine(&ioengine_dirstat);
+	unregister_ioengine(&ioengine_dirdelete);
 }
diff --git a/examples/dircreate-ioengine.fio b/examples/dircreate-ioengine.fio
new file mode 100644
index 00000000..c89d9e4d
--- /dev/null
+++ b/examples/dircreate-ioengine.fio
@@ -0,0 +1,25 @@
+# Example dircreate job
+#
+# create_on_open is needed so that the open happens during the run and not the
+# setup.
+#
+# openfiles needs to be set so that you do not exceed the maximum allowed open
+# files.
+#
+# filesize needs to be set to a non zero value so fio will actually run, but the
+# IO will not really be done and the write latency numbers will only reflect the
+# open times.
+[global]
+create_on_open=1
+nrfiles=30
+ioengine=dircreate
+fallocate=none
+filesize=4k
+openfiles=1
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
diff --git a/examples/dircreate-ioengine.png b/examples/dircreate-ioengine.png
new file mode 100644
index 00000000..da1a8c40
Binary files /dev/null and b/examples/dircreate-ioengine.png differ
diff --git a/examples/dirdelete-ioengine.fio b/examples/dirdelete-ioengine.fio
new file mode 100644
index 00000000..4e5b1e2c
--- /dev/null
+++ b/examples/dirdelete-ioengine.fio
@@ -0,0 +1,18 @@
+# Example dirdelete job
+
+# 'filedelete' engine only do 'rmdir(dirname)'.
+# 'filesize' must be set, then directories will be created at setup stage.
+# 'unlink' is better set to 0, since the directory is deleted in measurement.
+# the options disabled completion latency output such as 'disable_clat' and 'gtod_reduce' must not set.
+[global]
+ioengine=dirdelete
+filesize=4k
+nrfiles=200
+unlink=0
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
diff --git a/examples/dirdelete-ioengine.png b/examples/dirdelete-ioengine.png
new file mode 100644
index 00000000..af246195
Binary files /dev/null and b/examples/dirdelete-ioengine.png differ
diff --git a/examples/dirstat-ioengine.fio b/examples/dirstat-ioengine.fio
new file mode 100644
index 00000000..1322dd28
--- /dev/null
+++ b/examples/dirstat-ioengine.fio
@@ -0,0 +1,18 @@
+# Example dirstat job
+
+# 'dirstat' engine only do 'stat(dirname)', file will not be open().
+# 'filesize' must be set, then files will be created at setup stage.
+
+[global]
+ioengine=dirstat
+numjobs=10
+filesize=4k
+nrfiles=5
+thread
+
+[t0]
+[t1]
+[t2]
+[t3]
+[t4]
+[t5]
diff --git a/examples/dirstat-ioengine.png b/examples/dirstat-ioengine.png
new file mode 100644
index 00000000..14b948ba
Binary files /dev/null and b/examples/dirstat-ioengine.png differ
diff --git a/fio.1 b/fio.1
index 09c6b621..63375c62 100644
--- a/fio.1
+++ b/fio.1
@@ -2004,6 +2004,21 @@ Simply delete files by unlink() and do no I/O to the file. You need to set 'file
 and 'nrfiles', so that files will be created.
 This engine is to measure file delete.
 .TP
+.B dircreate
+Simply create the directories and do no I/O to them.  You still need to set
+\fBfilesize\fR so that all the accounting still occurs, but no actual I/O will be
+done other than creating the directories.
+.TP
+.B dirstat
+Simply do stat() and do no I/O to the directory. You need to set 'filesize'
+and 'nrfiles', so that directories will be created.
+This engine is to measure directory lookup and meta data access.
+.TP
+.B dirdelete
+Simply delete directories by unlink() and do no I/O to the directory. You need to set 'filesize'
+and 'nrfiles', so that directories will be created.
+This engine is to measure directory delete.
+.TP
 .B libpmem
 Read and write using mmap I/O to a file on a filesystem
 mounted with DAX on a persistent memory device through the PMDK
diff --git a/iolog.c b/iolog.c
index 251e9d7f..96af4f33 100644
--- a/iolog.c
+++ b/iolog.c
@@ -814,6 +814,8 @@ bool init_iolog(struct thread_data *td)
 	if (!ret)
 		td_verror(td, EINVAL, "failed initializing iolog");
 
+	init_disk_util(td);
+
 	return ret;
 }
 
