Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32B7C00140
	for <fio@archiver.kernel.org>; Fri, 12 Aug 2022 12:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbiHLMAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Aug 2022 08:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHLMAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Aug 2022 08:00:11 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C86DAFAD7
        for <fio@vger.kernel.org>; Fri, 12 Aug 2022 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=FOCm+cP34amlpgmDQIqOR/05ABd6VRcuJ1fXBYCBDH8=; b=bjd9W3jfl/YvzubgCZ9IvTmKtT
        +wUjrEuYRws2kcHnPaxEz95rzjylzGMBHoP8ozqpfAmThwryrh23xb15KPewtfZs2LgSQWOFjOXKj
        FSRlKYXNV873JgeMN/2zhovd3iUglGnRYSkLp87WiTK1Ph/NB3PoPFkb8JAINf6jQu4LoSn+d9LAu
        //NR+Bngnl8VSMBSHBDAt7sJiiUfymz0hahCDellQrzQDD62gdrLJCE2IGl7rBl/rLgULaKRiBwPu
        1LFZt4WpHA2hT1J/dyOAJddqYUEQicLTK+EJXix7RrmuCv/qm33AwEmd+Ant1UJTmF28FKW5UvYOZ
        vGlpsT7w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oMTKe-001cIM-Of
        for fio@vger.kernel.org; Fri, 12 Aug 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4826A1BC0110; Fri, 12 Aug 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220812120002.4826A1BC0110@kernel.dk>
Date:   Fri, 12 Aug 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 9dc528b1638b625b5e167983a74de4e85c5859ea:

  lib/rand: get rid of unused MAX_SEED_BUCKETS (2022-08-10 09:51:49 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a7bcae0610d872951bc22dc310105c7ec1157af:

  Merge branch 's3_crypto' of github.com:hualongfeng/fio (2022-08-11 15:39:02 -0400)

----------------------------------------------------------------
Feng, Hualong (3):
      engines/http: Add storage class option for s3
      engines/http: Add s3 crypto options for s3
      doc: Add usage and example about s3 storage class and crypto

Friendy.Su@sony.com (1):
      ioengines: merge filecreate, filestat, filedelete engines to fileoperations.c

Vincent Fu (1):
      Merge branch 's3_crypto' of github.com:hualongfeng/fio

 HOWTO.rst                          |  14 ++
 Makefile                           |   2 +-
 engines/filecreate.c               | 118 --------------
 engines/filedelete.c               | 115 --------------
 engines/fileoperations.c           | 318 +++++++++++++++++++++++++++++++++++++
 engines/filestat.c                 | 190 ----------------------
 engines/http.c                     | 178 ++++++++++++++++++---
 examples/http-s3-crypto.fio        |  38 +++++
 examples/http-s3-storage-class.fio |  37 +++++
 fio.1                              |   9 ++
 10 files changed, 577 insertions(+), 442 deletions(-)
 delete mode 100644 engines/filecreate.c
 delete mode 100644 engines/filedelete.c
 create mode 100644 engines/fileoperations.c
 delete mode 100644 engines/filestat.c
 create mode 100644 examples/http-s3-crypto.fio
 create mode 100644 examples/http-s3-storage-class.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 104cce2d..05fc117f 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2692,6 +2692,20 @@ with the caveat that when used on the command line, they must come after the
 
 	The S3 key/access id.
 
+.. option:: http_s3_sse_customer_key=str : [http]
+
+        The encryption customer key in SSE server side.
+
+.. option:: http_s3_sse_customer_algorithm=str : [http]
+
+        The encryption customer algorithm in SSE server side.
+        Default is **AES256**
+
+.. option:: http_s3_storage_class=str : [http]
+
+        Which storage class to access. User-customizable settings.
+        Default is **STANDARD**
+
 .. option:: http_swift_auth_token=str : [http]
 
 	The Swift auth token. See the example configuration file on how
diff --git a/Makefile b/Makefile
index 188a74d7..634d2c93 100644
--- a/Makefile
+++ b/Makefile
@@ -56,7 +56,7 @@ SOURCE :=	$(sort $(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		pshared.c options.c \
 		smalloc.c filehash.c profile.c debug.c engines/cpu.c \
 		engines/mmap.c engines/sync.c engines/null.c engines/net.c \
-		engines/ftruncate.c engines/filecreate.c engines/filestat.c engines/filedelete.c \
+		engines/ftruncate.c engines/fileoperations.c \
 		engines/exec.c \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
diff --git a/engines/filecreate.c b/engines/filecreate.c
deleted file mode 100644
index 7884752d..00000000
--- a/engines/filecreate.c
+++ /dev/null
@@ -1,118 +0,0 @@
-/*
- * filecreate engine
- *
- * IO engine that doesn't do any IO, just creates files and tracks the latency
- * of the file creation.
- */
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include "../fio.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-static int open_file(struct thread_data *td, struct fio_file *f)
-{
-	struct timespec start;
-	int do_lat = !td->o.disable_lat;
-
-	dprint(FD_FILE, "fd open %s\n", f->file_name);
-
-	if (f->filetype != FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	f->fd = open(f->file_name, O_CREAT|O_RDWR, 0600);
-
-	if (f->fd == -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e = errno;
-
-		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data = td->io_ops_data;
-		uint64_t nsec;
-
-		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-static enum fio_q_status queue_io(struct thread_data *td,
-				  struct io_u fio_unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-/*
- * Ensure that we at least have a block size worth of IO to do for each
- * file. If the job file has td->o.size < nr_files * block_size, then
- * fio won't do anything.
- */
-static int get_file_size(struct thread_data *td, struct fio_file *f)
-{
-	f->real_file_size = td_min_bs(td);
-	return 0;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data = calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir = DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir = DDIR_WRITE;
-
-	td->io_ops_data = data;
-	return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data = td->io_ops_data;
-
-	free(data);
-}
-
-static struct ioengine_ops ioengine = {
-	.name		= "filecreate",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= init,
-	.cleanup	= cleanup,
-	.queue		= queue_io,
-	.get_file_size	= get_file_size,
-	.open_file	= open_file,
-	.close_file	= generic_close_file,
-	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-};
-
-static void fio_init fio_filecreate_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filecreate_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/engines/filedelete.c b/engines/filedelete.c
deleted file mode 100644
index df388ac9..00000000
--- a/engines/filedelete.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * file delete engine
- *
- * IO engine that doesn't do any IO, just delete files and track the latency
- * of the file deletion.
- */
-#include <stdio.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <unistd.h>
-#include "../fio.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-static int delete_file(struct thread_data *td, struct fio_file *f)
-{
-	struct timespec start;
-	int do_lat = !td->o.disable_lat;
-	int ret;
-
-	dprint(FD_FILE, "fd delete %s\n", f->file_name);
-
-	if (f->filetype != FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	ret = unlink(f->file_name);
-
-	if (ret == -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e = errno;
-
-		snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data = td->io_ops_data;
-		uint64_t nsec;
-
-		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-
-static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data = calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir = DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir = DDIR_WRITE;
-
-	td->io_ops_data = data;
-	return 0;
-}
-
-static int delete_invalidate(struct thread_data *td, struct fio_file *f)
-{
-    /* do nothing because file not opened */
-    return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data = td->io_ops_data;
-
-	free(data);
-}
-
-static struct ioengine_ops ioengine = {
-	.name		= "filedelete",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= init,
-	.invalidate	= delete_invalidate,
-	.cleanup	= cleanup,
-	.queue		= queue_io,
-	.get_file_size	= generic_get_file_size,
-	.open_file	= delete_file,
-	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-};
-
-static void fio_init fio_filedelete_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filedelete_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
new file mode 100644
index 00000000..1db60da1
--- /dev/null
+++ b/engines/fileoperations.c
@@ -0,0 +1,318 @@
+/*
+ * fileoperations engine
+ *
+ * IO engine that doesn't do any IO, just operates files and tracks the latency
+ * of the file operation.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "../fio.h"
+#include "../optgroup.h"
+#include "../oslib/statx.h"
+
+
+struct fc_data {
+	enum fio_ddir stat_ddir;
+};
+
+struct filestat_options {
+	void *pad;
+	unsigned int stat_type;
+};
+
+enum {
+	FIO_FILESTAT_STAT	= 1,
+	FIO_FILESTAT_LSTAT	= 2,
+	FIO_FILESTAT_STATX	= 3,
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "stat_type",
+		.lname	= "stat_type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct filestat_options, stat_type),
+		.help	= "Specify stat system call type to measure lookup/getattr performance",
+		.def	= "stat",
+		.posval = {
+			  { .ival = "stat",
+			    .oval = FIO_FILESTAT_STAT,
+			    .help = "Use stat(2)",
+			  },
+			  { .ival = "lstat",
+			    .oval = FIO_FILESTAT_LSTAT,
+			    .help = "Use lstat(2)",
+			  },
+			  { .ival = "statx",
+			    .oval = FIO_FILESTAT_STATX,
+			    .help = "Use statx(2) if exists",
+			  },
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_FILESTAT,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
+
+static int open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat = !td->o.disable_lat;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	f->fd = open(f->file_name, O_CREAT|O_RDWR, 0600);
+
+	if (f->fd == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data = td->io_ops_data;
+		uint64_t nsec;
+
+		nsec = ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+static int stat_file(struct thread_data *td, struct fio_file *f)
+{
+	struct filestat_options *o = td->eo;
+	struct timespec start;
+	int do_lat = !td->o.disable_lat;
+	struct stat statbuf;
+#ifndef WIN32
+	struct statx statxbuf;
+	char *abspath;
+#endif
+	int ret;
+
+	dprint(FD_FILE, "fd stat %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	switch (o->stat_type) {
+	case FIO_FILESTAT_STAT:
+		ret = stat(f->file_name, &statbuf);
+		break;
+	case FIO_FILESTAT_LSTAT:
+		ret = lstat(f->file_name, &statbuf);
+		break;
+	case FIO_FILESTAT_STATX:
+#ifndef WIN32
+		abspath = realpath(f->file_name, NULL);
+		if (abspath) {
+			ret = statx(-1, abspath, 0, STATX_ALL, &statxbuf);
+			free(abspath);
+		} else
+			ret = -1;
+#else
+		ret = -1;
+#endif
+		break;
+	default:
+		ret = -1;
+		break;
+	}
+
+	if (ret == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "stat(%s) type=%u", f->file_name,
+			o->stat_type);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data = td->io_ops_data;
+		uint64_t nsec;
+
+		nsec = ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+
+static int delete_file(struct thread_data *td, struct fio_file *f)
+{
+	struct timespec start;
+	int do_lat = !td->o.disable_lat;
+	int ret;
+
+	dprint(FD_FILE, "fd delete %s\n", f->file_name);
+
+	if (f->filetype != FIO_TYPE_FILE) {
+		log_err("fio: only files are supported\n");
+		return 1;
+	}
+	if (!strcmp(f->file_name, "-")) {
+		log_err("fio: can't read/write to stdin/out\n");
+		return 1;
+	}
+
+	if (do_lat)
+		fio_gettime(&start, NULL);
+
+	ret = unlink(f->file_name);
+
+	if (ret == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int e = errno;
+
+		snprintf(buf, sizeof(buf), "delete(%s)", f->file_name);
+		td_verror(td, e, buf);
+		return 1;
+	}
+
+	if (do_lat) {
+		struct fc_data *data = td->io_ops_data;
+		uint64_t nsec;
+
+		nsec = ntime_since_now(&start);
+		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
+	}
+
+	return 0;
+}
+
+static int invalidate_do_nothing(struct thread_data *td, struct fio_file *f)
+{
+	/* do nothing because file not opened */
+	return 0;
+}
+
+static enum fio_q_status queue_io(struct thread_data *td, struct io_u *io_u)
+{
+	return FIO_Q_COMPLETED;
+}
+
+/*
+ * Ensure that we at least have a block size worth of IO to do for each
+ * file. If the job file has td->o.size < nr_files * block_size, then
+ * fio won't do anything.
+ */
+static int get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	f->real_file_size = td_min_bs(td);
+	return 0;
+}
+
+static int init(struct thread_data *td)
+{
+	struct fc_data *data;
+
+	data = calloc(1, sizeof(*data));
+
+	if (td_read(td))
+		data->stat_ddir = DDIR_READ;
+	else if (td_write(td))
+		data->stat_ddir = DDIR_WRITE;
+
+	td->io_ops_data = data;
+	return 0;
+}
+
+static void cleanup(struct thread_data *td)
+{
+	struct fc_data *data = td->io_ops_data;
+
+	free(data);
+}
+
+static struct ioengine_ops ioengine_filecreate = {
+	.name		= "filecreate",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.get_file_size	= get_file_size,
+	.open_file	= open_file,
+	.close_file	= generic_close_file,
+	.flags		= FIO_DISKLESSIO | FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+static struct ioengine_ops ioengine_filestat = {
+	.name		= "filestat",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.invalidate	= invalidate_do_nothing,
+	.get_file_size	= generic_get_file_size,
+	.open_file	= stat_file,
+	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+	.options	= options,
+	.option_struct_size = sizeof(struct filestat_options),
+};
+
+static struct ioengine_ops ioengine_filedelete = {
+	.name		= "filedelete",
+	.version	= FIO_IOOPS_VERSION,
+	.init		= init,
+	.invalidate	= invalidate_do_nothing,
+	.cleanup	= cleanup,
+	.queue		= queue_io,
+	.get_file_size	= generic_get_file_size,
+	.open_file	= delete_file,
+	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
+				FIO_NOSTATS | FIO_NOFILEHASH,
+};
+
+
+static void fio_init fio_fileoperations_register(void)
+{
+	register_ioengine(&ioengine_filecreate);
+	register_ioengine(&ioengine_filestat);
+	register_ioengine(&ioengine_filedelete);
+}
+
+static void fio_exit fio_fileoperations_unregister(void)
+{
+	unregister_ioengine(&ioengine_filecreate);
+	unregister_ioengine(&ioengine_filestat);
+	unregister_ioengine(&ioengine_filedelete);
+}
diff --git a/engines/filestat.c b/engines/filestat.c
deleted file mode 100644
index e587eb54..00000000
--- a/engines/filestat.c
+++ /dev/null
@@ -1,190 +0,0 @@
-/*
- * filestat engine
- *
- * IO engine that doesn't do any IO, just stat files and tracks the latency
- * of the file stat.
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <fcntl.h>
-#include <errno.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <unistd.h>
-#include "../fio.h"
-#include "../optgroup.h"
-#include "../oslib/statx.h"
-
-struct fc_data {
-	enum fio_ddir stat_ddir;
-};
-
-struct filestat_options {
-	void *pad;
-	unsigned int stat_type;
-};
-
-enum {
-	FIO_FILESTAT_STAT	= 1,
-	FIO_FILESTAT_LSTAT	= 2,
-	FIO_FILESTAT_STATX	= 3,
-};
-
-static struct fio_option options[] = {
-	{
-		.name	= "stat_type",
-		.lname	= "stat_type",
-		.type	= FIO_OPT_STR,
-		.off1	= offsetof(struct filestat_options, stat_type),
-		.help	= "Specify stat system call type to measure lookup/getattr performance",
-		.def	= "stat",
-		.posval = {
-			  { .ival = "stat",
-			    .oval = FIO_FILESTAT_STAT,
-			    .help = "Use stat(2)",
-			  },
-			  { .ival = "lstat",
-			    .oval = FIO_FILESTAT_LSTAT,
-			    .help = "Use lstat(2)",
-			  },
-			  { .ival = "statx",
-			    .oval = FIO_FILESTAT_STATX,
-			    .help = "Use statx(2) if exists",
-			  },
-		},
-		.category = FIO_OPT_C_ENGINE,
-		.group	= FIO_OPT_G_FILESTAT,
-	},
-	{
-		.name	= NULL,
-	},
-};
-
-static int stat_file(struct thread_data *td, struct fio_file *f)
-{
-	struct filestat_options *o = td->eo;
-	struct timespec start;
-	int do_lat = !td->o.disable_lat;
-	struct stat statbuf;
-#ifndef WIN32
-	struct statx statxbuf;
-	char *abspath;
-#endif
-	int ret;
-
-	dprint(FD_FILE, "fd stat %s\n", f->file_name);
-
-	if (f->filetype != FIO_TYPE_FILE) {
-		log_err("fio: only files are supported\n");
-		return 1;
-	}
-	if (!strcmp(f->file_name, "-")) {
-		log_err("fio: can't read/write to stdin/out\n");
-		return 1;
-	}
-
-	if (do_lat)
-		fio_gettime(&start, NULL);
-
-	switch (o->stat_type){
-	case FIO_FILESTAT_STAT:
-		ret = stat(f->file_name, &statbuf);
-		break;
-	case FIO_FILESTAT_LSTAT:
-		ret = lstat(f->file_name, &statbuf);
-		break;
-	case FIO_FILESTAT_STATX:
-#ifndef WIN32
-		abspath = realpath(f->file_name, NULL);
-		if (abspath) {
-			ret = statx(-1, abspath, 0, STATX_ALL, &statxbuf);
-			free(abspath);
-		} else
-			ret = -1;
-#else
-		ret = -1;
-#endif
-		break;
-	default:
-		ret = -1;
-		break;
-	}
-
-	if (ret == -1) {
-		char buf[FIO_VERROR_SIZE];
-		int e = errno;
-
-		snprintf(buf, sizeof(buf), "stat(%s) type=%u", f->file_name,
-			o->stat_type);
-		td_verror(td, e, buf);
-		return 1;
-	}
-
-	if (do_lat) {
-		struct fc_data *data = td->io_ops_data;
-		uint64_t nsec;
-
-		nsec = ntime_since_now(&start);
-		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
-	}
-
-	return 0;
-}
-
-static enum fio_q_status queue_io(struct thread_data *td, struct io_u fio_unused *io_u)
-{
-	return FIO_Q_COMPLETED;
-}
-
-static int init(struct thread_data *td)
-{
-	struct fc_data *data;
-
-	data = calloc(1, sizeof(*data));
-
-	if (td_read(td))
-		data->stat_ddir = DDIR_READ;
-	else if (td_write(td))
-		data->stat_ddir = DDIR_WRITE;
-
-	td->io_ops_data = data;
-	return 0;
-}
-
-static void cleanup(struct thread_data *td)
-{
-	struct fc_data *data = td->io_ops_data;
-
-	free(data);
-}
-
-static int stat_invalidate(struct thread_data *td, struct fio_file *f)
-{
-	/* do nothing because file not opened */
-	return 0;
-}
-
-static struct ioengine_ops ioengine = {
-	.name		= "filestat",
-	.version	= FIO_IOOPS_VERSION,
-	.init		= init,
-	.cleanup	= cleanup,
-	.queue		= queue_io,
-	.invalidate	= stat_invalidate,
-	.get_file_size	= generic_get_file_size,
-	.open_file	= stat_file,
-	.flags		=  FIO_SYNCIO | FIO_FAKEIO |
-				FIO_NOSTATS | FIO_NOFILEHASH,
-	.options	= options,
-	.option_struct_size = sizeof(struct filestat_options),
-};
-
-static void fio_init fio_filestat_register(void)
-{
-	register_ioengine(&ioengine);
-}
-
-static void fio_exit fio_filestat_unregister(void)
-{
-	unregister_ioengine(&ioengine);
-}
diff --git a/engines/http.c b/engines/http.c
index 1de9e66c..56dc7d1b 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -57,6 +57,9 @@ struct http_options {
 	char *s3_key;
 	char *s3_keyid;
 	char *s3_region;
+	char *s3_sse_customer_key;
+	char *s3_sse_customer_algorithm;
+	char *s3_storage_class;
 	char *swift_auth_token;
 	int verbose;
 	unsigned int mode;
@@ -161,6 +164,36 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group    = FIO_OPT_G_HTTP,
 	},
+	{
+		.name     = "http_s3_sse_customer_key",
+		.lname    = "SSE Customer Key",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 SSE Customer Key",
+		.off1     = offsetof(struct http_options, s3_sse_customer_key),
+		.def	  = "",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3_sse_customer_algorithm",
+		.lname    = "SSE Customer Algorithm",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 SSE Customer Algorithm",
+		.off1     = offsetof(struct http_options, s3_sse_customer_algorithm),
+		.def	  = "AES256",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
+	{
+		.name     = "http_s3_storage_class",
+		.lname    = "S3 Storage class",
+		.type     = FIO_OPT_STR_STORE,
+		.help     = "S3 Storage Class",
+		.off1     = offsetof(struct http_options, s3_storage_class),
+		.def	  = "STANDARD",
+		.category = FIO_OPT_C_ENGINE,
+		.group    = FIO_OPT_G_HTTP,
+	},
 	{
 		.name     = "http_mode",
 		.lname    = "Request mode to use",
@@ -266,6 +299,54 @@ static char *_gen_hex_md5(const char *p, size_t len)
 	return _conv_hex(hash, MD5_DIGEST_LENGTH);
 }
 
+static char *_conv_base64_encode(const unsigned char *p, size_t len)
+{
+	char *r, *ret;
+	int i;
+	static const char sEncodingTable[] = {
+		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
+		'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
+		'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
+		'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
+		'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
+		'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
+		'w', 'x', 'y', 'z', '0', '1', '2', '3',
+		'4', '5', '6', '7', '8', '9', '+', '/'
+	};
+
+	size_t out_len = 4 * ((len + 2) / 3);
+	ret = r = malloc(out_len + 1);
+
+	for (i = 0; i < len - 2; i += 3) {
+		*r++ = sEncodingTable[(p[i] >> 2) & 0x3F];
+		*r++ = sEncodingTable[((p[i] & 0x3) << 4) | ((int) (p[i + 1] & 0xF0) >> 4)];
+		*r++ = sEncodingTable[((p[i + 1] & 0xF) << 2) | ((int) (p[i + 2] & 0xC0) >> 6)];
+		*r++ = sEncodingTable[p[i + 2] & 0x3F];
+	}
+
+	if (i < len) {
+		*r++ = sEncodingTable[(p[i] >> 2) & 0x3F];
+		if (i == (len - 1)) {
+			*r++ = sEncodingTable[((p[i] & 0x3) << 4)];
+			*r++ = '=';
+		} else {
+			*r++ = sEncodingTable[((p[i] & 0x3) << 4) | ((int) (p[i + 1] & 0xF0) >> 4)];
+			*r++ = sEncodingTable[((p[i + 1] & 0xF) << 2)];
+		}
+		*r++ = '=';
+	}
+
+	ret[out_len]=0;
+	return ret;
+}
+
+static char *_gen_base64_md5(const unsigned char *p, size_t len)
+{
+	unsigned char hash[MD5_DIGEST_LENGTH];
+	MD5((unsigned char*)p, len, hash);
+	return _conv_base64_encode(hash, MD5_DIGEST_LENGTH);
+}
+
 static void _hmac(unsigned char *md, void *key, int key_len, char *data) {
 #ifndef CONFIG_HAVE_OPAQUE_HMAC_CTX
 	HMAC_CTX _ctx;
@@ -335,8 +416,8 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	char date_iso[32];
 	char method[8];
 	char dkey[128];
-	char creq[512];
-	char sts[256];
+	char creq[4096];
+	char sts[512];
 	char s[512];
 	char *uri_encoded = NULL;
 	char *dsha = NULL;
@@ -345,6 +426,9 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	const char *service = "s3";
 	const char *aws = "aws4_request";
 	unsigned char md[SHA256_DIGEST_LENGTH];
+	unsigned char sse_key[33] = {0};
+	char *sse_key_base64 = NULL;
+	char *sse_key_md5_base64 = NULL;
 
 	time_t t = time(NULL);
 	struct tm *gtm = gmtime(&t);
@@ -353,6 +437,9 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	strftime (date_iso, sizeof(date_iso), "%Y%m%dT%H%M%SZ", gtm);
 	uri_encoded = _aws_uriencode(uri);
 
+	if (o->s3_sse_customer_key != NULL)
+		strncpy((char*)sse_key, o->s3_sse_customer_key, sizeof(sse_key) - 1);
+
 	if (op == DDIR_WRITE) {
 		dsha = _gen_hex_sha256(buf, len);
 		sprintf(method, "PUT");
@@ -366,22 +453,50 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	}
 
 	/* Create the canonical request first */
-	snprintf(creq, sizeof(creq),
-	"%s\n"
-	"%s\n"
-	"\n"
-	"host:%s\n"
-	"x-amz-content-sha256:%s\n"
-	"x-amz-date:%s\n"
-	"\n"
-	"host;x-amz-content-sha256;x-amz-date\n"
-	"%s"
-	, method
-	, uri_encoded, o->host, dsha, date_iso, dsha);
+	if (sse_key[0] != '\0') {
+		sse_key_base64 = _conv_base64_encode(sse_key, sizeof(sse_key) - 1);
+		sse_key_md5_base64 = _gen_base64_md5(sse_key, sizeof(sse_key) - 1);
+		snprintf(creq, sizeof(creq),
+			"%s\n"
+			"%s\n"
+			"\n"
+			"host:%s\n"
+			"x-amz-content-sha256:%s\n"
+			"x-amz-date:%s\n"
+			"x-amz-server-side-encryption-customer-algorithm:%s\n"
+			"x-amz-server-side-encryption-customer-key:%s\n"
+			"x-amz-server-side-encryption-customer-key-md5:%s\n"
+			"x-amz-storage-class:%s\n"
+			"\n"
+			"host;x-amz-content-sha256;x-amz-date;"
+			"x-amz-server-side-encryption-customer-algorithm;"
+			"x-amz-server-side-encryption-customer-key;"
+			"x-amz-server-side-encryption-customer-key-md5;"
+			"x-amz-storage-class\n"
+			"%s"
+			, method
+			, uri_encoded, o->host, dsha, date_iso
+			, o->s3_sse_customer_algorithm, sse_key_base64
+			, sse_key_md5_base64, o->s3_storage_class, dsha);
+	} else {
+		snprintf(creq, sizeof(creq),
+			"%s\n"
+			"%s\n"
+			"\n"
+			"host:%s\n"
+			"x-amz-content-sha256:%s\n"
+			"x-amz-date:%s\n"
+			"x-amz-storage-class:%s\n"
+			"\n"
+			"host;x-amz-content-sha256;x-amz-date;x-amz-storage-class\n"
+			"%s"
+			, method
+			, uri_encoded, o->host, dsha, date_iso, o->s3_storage_class, dsha);
+	}
 
 	csha = _gen_hex_sha256(creq, strlen(creq));
 	snprintf(sts, sizeof(sts), "AWS4-HMAC-SHA256\n%s\n%s/%s/%s/%s\n%s",
-		date_iso, date_short, o->s3_region, service, aws, csha);
+			date_iso, date_short, o->s3_region, service, aws, csha);
 
 	snprintf((char *)dkey, sizeof(dkey), "AWS4%s", o->s3_key);
 	_hmac(md, dkey, strlen(dkey), date_short);
@@ -401,9 +516,32 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	snprintf(s, sizeof(s), "x-amz-date: %s", date_iso);
 	slist = curl_slist_append(slist, s);
 
-	snprintf(s, sizeof(s), "Authorization: AWS4-HMAC-SHA256 Credential=%s/%s/%s/s3/aws4_request,"
-	"SignedHeaders=host;x-amz-content-sha256;x-amz-date,Signature=%s",
-	o->s3_keyid, date_short, o->s3_region, signature);
+	if (sse_key[0] != '\0') {
+		snprintf(s, sizeof(s), "x-amz-server-side-encryption-customer-algorithm: %s", o->s3_sse_customer_algorithm);
+		slist = curl_slist_append(slist, s);
+		snprintf(s, sizeof(s), "x-amz-server-side-encryption-customer-key: %s", sse_key_base64);
+		slist = curl_slist_append(slist, s);
+		snprintf(s, sizeof(s), "x-amz-server-side-encryption-customer-key-md5: %s", sse_key_md5_base64);
+		slist = curl_slist_append(slist, s);
+	}
+
+	snprintf(s, sizeof(s), "x-amz-storage-class: %s", o->s3_storage_class);
+	slist = curl_slist_append(slist, s);
+
+	if (sse_key[0] != '\0') {
+		snprintf(s, sizeof(s), "Authorization: AWS4-HMAC-SHA256 Credential=%s/%s/%s/s3/aws4_request,"
+			"SignedHeaders=host;x-amz-content-sha256;"
+			"x-amz-date;x-amz-server-side-encryption-customer-algorithm;"
+			"x-amz-server-side-encryption-customer-key;"
+			"x-amz-server-side-encryption-customer-key-md5;"
+			"x-amz-storage-class,"
+			"Signature=%s",
+		o->s3_keyid, date_short, o->s3_region, signature);
+	} else {
+		snprintf(s, sizeof(s), "Authorization: AWS4-HMAC-SHA256 Credential=%s/%s/%s/s3/aws4_request,"
+			"SignedHeaders=host;x-amz-content-sha256;x-amz-date;x-amz-storage-class,Signature=%s",
+			o->s3_keyid, date_short, o->s3_region, signature);
+	}
 	slist = curl_slist_append(slist, s);
 
 	curl_easy_setopt(curl, CURLOPT_HTTPHEADER, slist);
@@ -412,6 +550,10 @@ static void _add_aws_auth_header(CURL *curl, struct curl_slist *slist, struct ht
 	free(csha);
 	free(dsha);
 	free(signature);
+	if (sse_key_base64 != NULL) {
+		free(sse_key_base64);
+		free(sse_key_md5_base64);
+	}
 }
 
 static void _add_swift_header(CURL *curl, struct curl_slist *slist, struct http_options *o,
diff --git a/examples/http-s3-crypto.fio b/examples/http-s3-crypto.fio
new file mode 100644
index 00000000..2403746e
--- /dev/null
+++ b/examples/http-s3-crypto.fio
@@ -0,0 +1,38 @@
+# Example test for the HTTP engine's S3 support against Amazon AWS.
+# Obviously, you have to adjust the S3 credentials; for this example,
+# they're passed in via the environment.
+# And you can set the SSE Customer Key and Algorithm to test Server
+# Side Encryption.
+#
+
+[global]
+ioengine=http
+name=test
+direct=1
+filename=/larsmb-fio-test/object
+http_verbose=0
+https=on
+http_mode=s3
+http_s3_key=${S3_KEY}
+http_s3_keyid=${S3_ID}
+http_host=s3.eu-central-1.amazonaws.com
+http_s3_region=eu-central-1
+http_s3_sse_customer_key=${SSE_KEY}
+http_s3_sse_customer_algorithm=AES256
+group_reporting
+
+# With verify, this both writes and reads the object
+[create]
+rw=write
+bs=4k
+size=64k
+io_size=4k
+verify=sha256
+
+[trim]
+stonewall
+rw=trim
+bs=4k
+size=64k
+io_size=4k
+
diff --git a/examples/http-s3-storage-class.fio b/examples/http-s3-storage-class.fio
new file mode 100644
index 00000000..9ee23837
--- /dev/null
+++ b/examples/http-s3-storage-class.fio
@@ -0,0 +1,37 @@
+# Example test for the HTTP engine's S3 support against Amazon AWS.
+# Obviously, you have to adjust the S3 credentials; for this example,
+# they're passed in via the environment.
+# And here add storage class parameter, you can set normal test for
+# STANDARD and compression test for another storage class.
+#
+
+[global]
+ioengine=http
+name=test
+direct=1
+filename=/larsmb-fio-test/object
+http_verbose=0
+https=on
+http_mode=s3
+http_s3_key=${S3_KEY}
+http_s3_keyid=${S3_ID}
+http_host=s3.eu-central-1.amazonaws.com
+http_s3_region=eu-central-1
+http_s3_storage_class=${STORAGE_CLASS}
+group_reporting
+
+# With verify, this both writes and reads the object
+[create]
+rw=write
+bs=4k
+size=64k
+io_size=4k
+verify=sha256
+
+[trim]
+stonewall
+rw=trim
+bs=4k
+size=64k
+io_size=4k
+
diff --git a/fio.1 b/fio.1
index ce9bf3ef..6630525f 100644
--- a/fio.1
+++ b/fio.1
@@ -2308,6 +2308,15 @@ The S3 secret key.
 .BI (http)http_s3_keyid \fR=\fPstr
 The S3 key/access id.
 .TP
+.BI (http)http_s3_sse_customer_key \fR=\fPstr
+The encryption customer key in SSE server side.
+.TP
+.BI (http)http_s3_sse_customer_algorithm \fR=\fPstr
+The encryption customer algorithm in SSE server side. Default is \fBAES256\fR
+.TP
+.BI (http)http_s3_storage_class \fR=\fPstr
+Which storage class to access. User-customizable settings. Default is \fBSTANDARD\fR
+.TP
 .BI (http)http_swift_auth_token \fR=\fPstr
 The Swift auth token. See the example configuration file on how to
 retrieve this.
