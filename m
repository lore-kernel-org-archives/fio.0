Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:40440 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfIMMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Sep 2019 08:00:16 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1i8kFK-0003i7-Ur
        for fio@vger.kernel.org; Fri, 13 Sep 2019 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190913120001.EE4382C0093@kernel.dk>
Date: Fri, 13 Sep 2019 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 27f436d9f72a9d2d3da3adfdf712757152eab29e:

  engines/io_uring: use its own option group (2019-09-05 09:15:41 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4c29a34fcc8cae333ec8b7af7657495745153b44:

  Merge branch 'ioring_add_sync_file_range' of https://github.com/anarazel/fio (2019-09-12 14:24:23 -0600)

----------------------------------------------------------------
Andres Freund (2):
      engines/io_uring: Handle EINTR.
      engines/io_uring: Add support for sync_file_range.

Jens Axboe (3):
      engines/io_uring: fix crash with registerfiles=1
      Merge branch 'fix_iouring_eintr' of https://github.com/anarazel/fio
      Merge branch 'ioring_add_sync_file_range' of https://github.com/anarazel/fio

Vincent Fu (2):
      doc: clarify what --alloc-size does
      filesetup: honor the offset option

 HOWTO              |  4 ++--
 engines/io_uring.c | 25 +++++++++++++++++--------
 filesetup.c        |  2 +-
 fio.1              |  4 ++--
 4 files changed, 22 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 6b449e97..4fef1504 100644
--- a/HOWTO
+++ b/HOWTO
@@ -222,8 +222,8 @@ Command line options
 
 .. option:: --alloc-size=kb
 
-	Set the internal smalloc pool size to `kb` in KiB.  The
-	``--alloc-size`` switch allows one to use a larger pool size for smalloc.
+	Allocate additional internal smalloc pools of size `kb` in KiB.  The
+	``--alloc-size`` option increases shared memory set aside for use by fio.
 	If running large jobs with randommap enabled, fio can run out of memory.
 	Smalloc is an internal allocator for shared structures from a fixed size
 	memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 10cfe9f2..53cb60c5 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -181,10 +181,17 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		}
 		sqe->off = io_u->offset;
 	} else if (ddir_sync(io_u->ddir)) {
-		sqe->fsync_flags = 0;
-		if (io_u->ddir == DDIR_DATASYNC)
-			sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
-		sqe->opcode = IORING_OP_FSYNC;
+		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
+			sqe->off = f->first_write;
+			sqe->len = f->last_write - f->first_write;
+			sqe->sync_range_flags = td->o.sync_file_range;
+			sqe->opcode = IORING_OP_SYNC_FILE_RANGE;
+		} else {
+			sqe->fsync_flags = 0;
+			if (io_u->ddir == DDIR_DATASYNC)
+				sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
+			sqe->opcode = IORING_OP_FSYNC;
+		}
 	}
 
 	sqe->user_data = (unsigned long) io_u;
@@ -259,7 +266,7 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 			r = io_uring_enter(ld, 0, actual_min,
 						IORING_ENTER_GETEVENTS);
 			if (r < 0) {
-				if (errno == EAGAIN)
+				if (errno == EAGAIN || errno == EINTR)
 					continue;
 				td_verror(td, errno, "io_uring_enter");
 				break;
@@ -370,7 +377,7 @@ static int fio_ioring_commit(struct thread_data *td)
 			io_u_mark_submit(td, ret);
 			continue;
 		} else {
-			if (errno == EAGAIN) {
+			if (errno == EAGAIN || errno == EINTR) {
 				ret = fio_ioring_cqring_reap(td, 0, ld->queued);
 				if (ret)
 					continue;
@@ -555,6 +562,7 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
+	printf("files=%d\n", o->registerfiles);
 	if (o->registerfiles) {
 		err = fio_ioring_register_files(td);
 		if (err) {
@@ -613,7 +621,7 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
-	if (!o->registerfiles)
+	if (!ld || !o->registerfiles)
 		return generic_open_file(td, f);
 
 	f->fd = ld->fds[f->engine_pos];
@@ -622,9 +630,10 @@ static int fio_ioring_open_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_ioring_close_file(struct thread_data *td, struct fio_file *f)
 {
+	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 
-	if (!o->registerfiles)
+	if (!ld || !o->registerfiles)
 		return generic_close_file(td, f);
 
 	f->fd = -1;
diff --git a/filesetup.c b/filesetup.c
index 7904d187..b8d1d838 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1047,7 +1047,7 @@ int setup_files(struct thread_data *td)
 			 * doesn't divide nicely with the min blocksize,
 			 * make the first files bigger.
 			 */
-			f->io_size = fs;
+			f->io_size = fs - f->file_offset;
 			if (nr_fs_extra) {
 				nr_fs_extra--;
 				f->io_size += bs;
diff --git a/fio.1 b/fio.1
index e0283f7f..77a2d799 100644
--- a/fio.1
+++ b/fio.1
@@ -112,8 +112,8 @@ only applies to job sections. The reserved *global* section is always
 parsed and used.
 .TP
 .BI \-\-alloc\-size \fR=\fPkb
-Set the internal smalloc pool size to \fIkb\fR in KiB. The
-\fB\-\-alloc\-size\fR switch allows one to use a larger pool size for smalloc.
+Allocate additional internal smalloc pools of size \fIkb\fR in KiB. The
+\fB\-\-alloc\-size\fR option increases shared memory set aside for use by fio.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
 memory pool and can grow to 16 pools. The pool size defaults to 16MiB.

