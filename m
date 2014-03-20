Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44051 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbaCTSAk (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Mar 2014 14:00:40 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so1282872pbb.36
        for <fio@vger.kernel.org>; Thu, 20 Mar 2014 11:00:39 -0700 (PDT)
From: castor.fu@egocast.org
Subject: [PATCH 2/2] Add unlink hook to ioengine API
Date: Thu, 20 Mar 2014 10:59:30 -0700
Message-Id: <1395338370-89038-3-git-send-email-castor.fu@egocast.org>
In-Reply-To: <1395338370-89038-1-git-send-email-castor.fu@egocast.org>
References: <c1160a632c8b42e28487bf5902346d7e@DB4PR03MB572.eurprd03.prod.outlook.com>
 <1395338370-89038-1-git-send-email-castor.fu@egocast.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Castor Fu <castor@alumni.caltech.edu>

From: Castor Fu <castor@alumni.caltech.edu>

---
 filesetup.c | 6 +++---
 ioengine.h  | 4 +++-
 ioengines.c | 8 ++++++++
 iolog.c     | 2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 033b119..eae1b99 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -58,7 +58,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 
 	if (unlink_file || new_layout) {
 		dprint(FD_FILE, "layout unlink %s\n", f->file_name);
-		if ((unlink(f->file_name) < 0) && (errno != ENOENT)) {
+		if ((td_io_unlink_file(td, f) < 0) && (errno != ENOENT)) {
 			td_verror(td, errno, "unlink");
 			return 1;
 		}
@@ -167,7 +167,7 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 
 	if (td->terminate) {
 		dprint(FD_FILE, "terminate unlink %s\n", f->file_name);
-		unlink(f->file_name);
+		td_io_unlink_file(td, f);
 	} else if (td->o.create_fsync) {
 		if (fsync(f->fd) < 0) {
 			td_verror(td, errno, "fsync");
@@ -1054,7 +1054,7 @@ void close_and_free_files(struct thread_data *td)
 	for_each_file(td, f, i) {
 		if (td->o.unlink && f->filetype == FIO_TYPE_FILE) {
 			dprint(FD_FILE, "free unlink %s\n", f->file_name);
-			unlink(f->file_name);
+			td_io_unlink_file(td, f);
 		}
 
 		if (fio_file_open(f))
diff --git a/ioengine.h b/ioengine.h
index 6e3c717..da9e904 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -15,7 +15,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	18
+#define FIO_IOOPS_VERSION	19
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -143,6 +143,7 @@ struct ioengine_ops {
 	void (*cleanup)(struct thread_data *);
 	int (*open_file)(struct thread_data *, struct fio_file *);
 	int (*close_file)(struct thread_data *, struct fio_file *);
+	int (*unlink_file)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
@@ -183,6 +184,7 @@ extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsi
 extern int __must_check td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
 extern int td_io_close_file(struct thread_data *, struct fio_file *);
+extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
 extern int __must_check td_io_get_file_size(struct thread_data *, struct fio_file *);
 
 extern struct ioengine_ops *load_ioengine(struct thread_data *, const char *);
diff --git a/ioengines.c b/ioengines.c
index 3c75fa6..0b4983f 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -503,6 +503,14 @@ int td_io_close_file(struct thread_data *td, struct fio_file *f)
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
index b8ee067..8d76fbf 100644
--- a/iolog.c
+++ b/iolog.c
@@ -96,7 +96,7 @@ static int ipo_special(struct thread_data *td, struct io_piece *ipo)
 		td_io_close_file(td, f);
 		break;
 	case FIO_LOG_UNLINK_FILE:
-		unlink(f->file_name);
+		td_io_unlink_file(td, f);
 		break;
 	default:
 		log_err("fio: bad file action %d\n", ipo->file_action);
-- 
1.7.11.5

