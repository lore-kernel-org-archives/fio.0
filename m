Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 12/13] Separate io_u from ioengine [2/3] - move io_u functions
Date: Tue, 28 Mar 2017 23:03:00 +0300
Message-Id: <20170328200301.8622-12-tkusumi@tuxera.com>
In-Reply-To: <20170328200301.8622-1-tkusumi@tuxera.com>
References: <20170328200301.8622-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Move io_u functions from ioengines.c to io_u.c whose prototypes
are now located in io_u.h after the previous commit.

Prior to the previous commit, ioengine.h originally separated io_u
related function prototypes and ioengine related function prototypes
(by comment) based on whether they invoke struct ioengine_ops member
functions or not. Prototypes for these two functions have existed
in io_u side, thus they should be moved to io_u.c respectively.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 io_u.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ioengines.c | 58 ----------------------------------------------------------
 2 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/io_u.c b/io_u.c
index c6d814b..363bfe1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2087,3 +2087,61 @@ void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
 	io_u->buf_filled_len = 0;
 	fill_io_buffer(td, io_u->buf, min_write, max_bs);
 }
+
+static int do_sync_file_range(const struct thread_data *td,
+			      struct fio_file *f)
+{
+	off64_t offset, nbytes;
+
+	offset = f->first_write;
+	nbytes = f->last_write - f->first_write;
+
+	if (!nbytes)
+		return 0;
+
+	return sync_file_range(f->fd, offset, nbytes, td->o.sync_file_range);
+}
+
+int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
+{
+	int ret;
+
+	if (io_u->ddir == DDIR_SYNC) {
+		ret = fsync(io_u->file->fd);
+	} else if (io_u->ddir == DDIR_DATASYNC) {
+#ifdef CONFIG_FDATASYNC
+		ret = fdatasync(io_u->file->fd);
+#else
+		ret = io_u->xfer_buflen;
+		io_u->error = EINVAL;
+#endif
+	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE)
+		ret = do_sync_file_range(td, io_u->file);
+	else {
+		ret = io_u->xfer_buflen;
+		io_u->error = EINVAL;
+	}
+
+	if (ret < 0)
+		io_u->error = errno;
+
+	return ret;
+}
+
+int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
+{
+#ifndef FIO_HAVE_TRIM
+	io_u->error = EINVAL;
+	return 0;
+#else
+	struct fio_file *f = io_u->file;
+	int ret;
+
+	ret = os_trim(f->fd, io_u->offset, io_u->xfer_buflen);
+	if (!ret)
+		return io_u->xfer_buflen;
+
+	io_u->error = ret;
+	return 0;
+#endif
+}
diff --git a/ioengines.c b/ioengines.c
index c773f2e..c90a2ca 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -556,64 +556,6 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 	return td->io_ops->get_file_size(td, f);
 }
 
-static int do_sync_file_range(const struct thread_data *td,
-			      struct fio_file *f)
-{
-	off64_t offset, nbytes;
-
-	offset = f->first_write;
-	nbytes = f->last_write - f->first_write;
-
-	if (!nbytes)
-		return 0;
-
-	return sync_file_range(f->fd, offset, nbytes, td->o.sync_file_range);
-}
-
-int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
-{
-	int ret;
-
-	if (io_u->ddir == DDIR_SYNC) {
-		ret = fsync(io_u->file->fd);
-	} else if (io_u->ddir == DDIR_DATASYNC) {
-#ifdef CONFIG_FDATASYNC
-		ret = fdatasync(io_u->file->fd);
-#else
-		ret = io_u->xfer_buflen;
-		io_u->error = EINVAL;
-#endif
-	} else if (io_u->ddir == DDIR_SYNC_FILE_RANGE)
-		ret = do_sync_file_range(td, io_u->file);
-	else {
-		ret = io_u->xfer_buflen;
-		io_u->error = EINVAL;
-	}
-
-	if (ret < 0)
-		io_u->error = errno;
-
-	return ret;
-}
-
-int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
-{
-#ifndef FIO_HAVE_TRIM
-	io_u->error = EINVAL;
-	return 0;
-#else
-	struct fio_file *f = io_u->file;
-	int ret;
-
-	ret = os_trim(f->fd, io_u->offset, io_u->xfer_buflen);
-	if (!ret)
-		return io_u->xfer_buflen;
-
-	io_u->error = ret;
-	return 0;
-#endif
-}
-
 int fio_show_ioengine_help(const char *engine)
 {
 	struct flist_head *entry;
-- 
2.9.3


