Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42802 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaHSQ33 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Aug 2014 12:29:29 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so10318380pac.31
        for <fio@vger.kernel.org>; Tue, 19 Aug 2014 09:29:27 -0700 (PDT)
From: castor.fu@egocast.org
Subject: [PATCH] Add unlink hook to ioengine API, gluster ioengine
Date: Tue, 19 Aug 2014 09:28:53 -0700
Message-Id: <1408465733-3061-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>, Huamin Chen <hchen@redhat.com>

From: Castor Fu <castor@alumni.caltech.edu>

fio would just call unlink even with engines that are not using the
operating systems file namespace... This provides a hook to allow
overriding that, with a default handler, and implements it for the
gluster ioengine.

There are others which it'd probably make sense I'm sure.

Huamin Chen looked over my changes to the gluster code earlier...
>I like this unlink idea, it would be great if you can also make unlink optional (if my coding reading is correct). This looks a great pull request candidate to fio. Please ping Axboe after you are done. He is not actively watching pull requests.

>Please also feel free to augment gluster code and pull me for review if necessary. 

-castor


---
 engines/gfapi.h           |  1 +
 engines/glusterfs.c       | 23 ++++++++++++++++++++---
 engines/glusterfs_async.c |  1 +
 engines/glusterfs_sync.c  |  1 +
 filesetup.c               | 11 ++++++++---
 ioengine.h                |  2 ++
 ioengines.c               |  8 ++++++++
 iolog.c                   |  2 +-
 8 files changed, 42 insertions(+), 7 deletions(-)

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
index 52006b0..67bdded 100644
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
index ebe0ebe..a8af6b0 100644
--- a/ioengine.h
+++ b/ioengine.h
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
-- 
1.8.5.2 (Apple Git-48)

