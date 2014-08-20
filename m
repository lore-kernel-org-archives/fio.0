Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaHTMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 20 Aug 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XK4Ye-0002MT-L8
	for fio@vger.kernel.org; Wed, 20 Aug 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140820120003.4C6F8401D1@lyth.info>
Date: Wed, 20 Aug 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit b74e419ec6152ae2dd4b9f36c2559961f4fab5cf:

  Update libhdfs engine documention and options (2014-08-14 11:45:16 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 35af10e11a470a33fe8e9d839bd15b86d97ec1f6:

  Update io engine version (2014-08-19 15:16:29 -0500)

----------------------------------------------------------------
Castor Fu (1):
      Add unlink hook to ioengine API, gluster ioengine

Jens Axboe (1):
      Update io engine version

rootfs (1):
      fix re-open failure issue when using gluster ioengine

 engines/gfapi.h           |    1 +
 engines/glusterfs.c       |   25 +++++++++++++++++++++----
 engines/glusterfs_async.c |    1 +
 engines/glusterfs_sync.c  |    1 +
 examples/gfapi.fio        |   16 ++++++++++++++++
 filesetup.c               |   11 ++++++++---
 ioengine.h                |    4 +++-
 ioengines.c               |    8 ++++++++
 iolog.c                   |    2 +-
 9 files changed, 60 insertions(+), 9 deletions(-)
 create mode 100644 examples/gfapi.fio

---

Diff of recent changes:

diff --git a/engines/gfapi.h b/engines/gfapi.h
index c79838b..0da471c 100644
--- a/engines/gfapi.h
+++ b/engines/gfapi.h
@@ -19,3 +19,4 @@ extern void fio_gf_cleanup(struct thread_data *td);
 extern int fio_gf_get_file_size(struct thread_data *td, struct fio_file *f);
 extern int fio_gf_open_file(struct thread_data *td, struct fio_file *f);
 extern int fio_gf_close_file(struct thread_data *td, struct fio_file *f);
+extern int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f);
diff --git a/engines/glusterfs.c b/engines/glusterfs.c
index 52006b0..507cd25 100644
--- a/engines/glusterfs.c
+++ b/engines/glusterfs.c
@@ -223,10 +223,10 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 					free(b);
 				glfs_lseek(g->fd, 0, SEEK_SET);
 
-				if (td->terminate) {
+				if (td->terminate && td->o.unlink) {
 					dprint(FD_FILE, "terminate unlink %s\n",
 					       f->file_name);
-					unlink(f->file_name);
+					glfs_unlink(g->fs, f->file_name);
 				} else if (td->o.create_fsync) {
 					if (glfs_fsync(g->fd) < 0) {
 						dprint(FD_FILE,
@@ -260,7 +260,7 @@ int fio_gf_open_file(struct thread_data *td, struct fio_file *f)
 	dprint(FD_FILE, "fio %p created %s\n", g->fs, f->file_name);
 	f->fd = -1;
 	f->shadow_fd = -1;
-
+	td->o.open_files ++;
 	return ret;
 }
 
@@ -274,6 +274,24 @@ int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 	if (g) {
 		if (g->fd && glfs_close(g->fd) < 0)
 			ret = errno;
+		g->fd = NULL;
+	}
+
+	return ret;
+}
+
+int fio_gf_unlink_file(struct thread_data *td, struct fio_file *f)
+{
+	int ret = 0;
+	struct gf_data *g = td->io_ops->data;
+
+	dprint(FD_FILE, "fd unlink %s\n", f->file_name);
+
+	if (g) {
+		if (g->fd && glfs_close(g->fd) < 0)
+			ret = errno;
+
+		glfs_unlink(g->fs, f->file_name);
 
 		if (g->fs)
 			glfs_fini(g->fs);
@@ -282,7 +300,6 @@ int fio_gf_close_file(struct thread_data *td, struct fio_file *f)
 		free(g);
 	}
 	td->io_ops->data = NULL;
-	f->engine_data = 0;
 
 	return ret;
 }
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 30f1719..7b0b30a 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -186,6 +186,7 @@ static struct ioengine_ops ioengine = {
 	.queue = fio_gf_async_queue,
 	.open_file = fio_gf_open_file,
 	.close_file = fio_gf_close_file,
+	.unlink_file = fio_gf_unlink_file,
 	.get_file_size = fio_gf_get_file_size,
 	.getevents = fio_gf_getevents,
 	.event = fio_gf_event,
diff --git a/engines/glusterfs_sync.c b/engines/glusterfs_sync.c
index 938baf4..235d74f 100644
--- a/engines/glusterfs_sync.c
+++ b/engines/glusterfs_sync.c
@@ -76,6 +76,7 @@ static struct ioengine_ops ioengine = {
 	.queue = fio_gf_queue,
 	.open_file = fio_gf_open_file,
 	.close_file = fio_gf_close_file,
+	.unlink_file = fio_gf_unlink_file,
 	.get_file_size = fio_gf_get_file_size,
 	.options = gfapi_options,
 	.option_struct_size = sizeof(struct gf_options),
diff --git a/examples/gfapi.fio b/examples/gfapi.fio
new file mode 100644
index 0000000..ccc8123
--- /dev/null
+++ b/examples/gfapi.fio
@@ -0,0 +1,16 @@
+# Test opening a file from multiple jobs.
+# Originally authored by Castor Fu
+[global]
+ioengine=gfapi
+volume=vol
+brick=localhost
+create_on_open=1
+rw=write
+
+[reopen_file_test]
+nrfiles=4
+filesize=16k
+size=64k
+openfiles=2
+rw=write
+filename_format=reopen_test.$filenum
diff --git a/filesetup.c b/filesetup.c
index 12a43b1..29a76c0 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -59,7 +59,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 
 	if (unlink_file || new_layout) {
 		dprint(FD_FILE, "layout unlink %s\n", f->file_name);
-		if ((unlink(f->file_name) < 0) && (errno != ENOENT)) {
+		if ((td_io_unlink_file(td, f) < 0) && (errno != ENOENT)) {
 			td_verror(td, errno, "unlink");
 			return 1;
 		}
@@ -172,7 +172,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 
 	if (td->terminate) {
 		dprint(FD_FILE, "terminate unlink %s\n", f->file_name);
-		unlink(f->file_name);
+		td_io_unlink_file(td, f);
 	} else if (td->o.create_fsync) {
 		if (fsync(f->fd) < 0) {
 			td_verror(td, errno, "fsync");
@@ -1100,6 +1100,11 @@ void close_and_free_files(struct thread_data *td)
 	dprint(FD_FILE, "close files\n");
 
 	for_each_file(td, f, i) {
+		if (td->o.unlink && f->filetype == FIO_TYPE_FILE) {
+			dprint(FD_FILE, "free unlink %s\n", f->file_name);
+			td_io_unlink_file(td, f);
+		}
+
 		if (fio_file_open(f))
 			td_io_close_file(td, f);
 
@@ -1107,7 +1112,7 @@ void close_and_free_files(struct thread_data *td)
 
 		if (td->o.unlink && f->filetype == FIO_TYPE_FILE) {
 			dprint(FD_FILE, "free unlink %s\n", f->file_name);
-			unlink(f->file_name);
+			td_io_unlink_file(td, f);
 		}
 
 		sfree(f->file_name);
diff --git a/ioengine.h b/ioengine.h
index ebe0ebe..108c97c 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	19
+#define FIO_IOOPS_VERSION	20
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -144,6 +144,7 @@ struct ioengine_ops {
 	int (*open_file)(struct thread_data *, struct fio_file *);
 	int (*close_file)(struct thread_data *, struct fio_file *);
 	int (*invalidate)(struct thread_data *, struct fio_file *);
+	int (*unlink_file)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
@@ -185,6 +186,7 @@ extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsi
 extern int __must_check td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
 extern int td_io_close_file(struct thread_data *, struct fio_file *);
+extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
 extern int __must_check td_io_get_file_size(struct thread_data *, struct fio_file *);
 
 extern struct ioengine_ops *load_ioengine(struct thread_data *, const char *);
diff --git a/ioengines.c b/ioengines.c
index 0f94d0d..3010f6c 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -506,6 +506,14 @@ int td_io_close_file(struct thread_data *td, struct fio_file *f)
 	return put_file(td, f);
 }
 
+int td_io_unlink_file(struct thread_data *td, struct fio_file *f)
+{
+	if (td->io_ops->unlink_file)
+		return td->io_ops->unlink_file(td, f);
+	else
+		return unlink(f->file_name);
+}
+
 int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 {
 	if (!td->io_ops->get_file_size)
diff --git a/iolog.c b/iolog.c
index 70ccfba..f9e835d 100644
--- a/iolog.c
+++ b/iolog.c
@@ -107,7 +107,7 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 		td_io_close_file(td, f);
 		break;
 	case FIO_LOG_UNLINK_FILE:
-		unlink(f->file_name);
+		td_io_unlink_file(td, f);
 		break;
 	default:
 		log_err("fio: bad file action %d\n", ipo->file_action);
