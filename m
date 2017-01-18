Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/5] Rename FIO_TYPE_BD to FIO_TYPE_BLOCK
Date: Thu, 19 Jan 2017 02:38:23 +0900
Message-Id: <1484761107-21387-1-git-send-email-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Since character device is FIO_TYPE_CHAR, BLOCK (or BLK) makes
better sense for block device.

This may break external ioengines on compile-time, but ioengines
usually don't refer to file type which are regfile/blk/chr/pipe
(which I believe makes sense to commit this change as there's
been changes that break not only api but also abi).

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 backend.c         |  2 +-
 engines/binject.c |  2 +-
 engines/mmap.c    |  2 +-
 engines/sg.c      |  8 ++++----
 file.h            |  2 +-
 filesetup.c       | 10 +++++-----
 ioengines.c       |  4 ++--
 7 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/backend.c b/backend.c
index a46101c..4570d8d 100644
--- a/backend.c
+++ b/backend.c
@@ -2055,7 +2055,7 @@ static bool check_mount_writes(struct thread_data *td)
 		return false;
 
 	for_each_file(td, f, i) {
-		if (f->filetype != FIO_TYPE_BD)
+		if (f->filetype != FIO_TYPE_BLOCK)
 			continue;
 		if (device_is_mounted(f->file_name))
 			goto mounted;
diff --git a/engines/binject.c b/engines/binject.c
index 7d20a3f..932534a 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -351,7 +351,7 @@ static int fio_binject_open_file(struct thread_data *td, struct fio_file *f)
 	if (ret)
 		return 1;
 
-	if (f->filetype != FIO_TYPE_BD) {
+	if (f->filetype != FIO_TYPE_BLOCK) {
 		log_err("fio: binject only works with block devices\n");
 		goto err_close;
 	}
diff --git a/engines/mmap.c b/engines/mmap.c
index 99e1d6a..bc038f4 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -67,7 +67,7 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	}
 
 #ifdef FIO_MADV_FREE
-	if (f->filetype == FIO_TYPE_BD)
+	if (f->filetype == FIO_TYPE_BLOCK)
 		(void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
 #endif
 
diff --git a/engines/sg.c b/engines/sg.c
index 3f7d911..2148e87 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -252,7 +252,7 @@ static int fio_sgio_doio(struct thread_data *td, struct io_u *io_u, int do_sync)
 	struct fio_file *f = io_u->file;
 	int ret;
 
-	if (f->filetype == FIO_TYPE_BD) {
+	if (f->filetype == FIO_TYPE_BLOCK) {
 		ret = fio_sgio_ioctl_doio(td, f, io_u);
 		td->error = io_u->error;
 	} else {
@@ -504,7 +504,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 	unsigned int bs = 0;
 	unsigned long long max_lba = 0;
 
-	if (f->filetype == FIO_TYPE_BD) {
+	if (f->filetype == FIO_TYPE_BLOCK) {
 		if (ioctl(f->fd, BLKSSZGET, &bs) < 0) {
 			td_verror(td, errno, "ioctl");
 			return 1;
@@ -537,7 +537,7 @@ static int fio_sgio_type_check(struct thread_data *td, struct fio_file *f)
 			MAX_10B_LBA, max_lba);
 	}
 
-	if (f->filetype == FIO_TYPE_BD) {
+	if (f->filetype == FIO_TYPE_BLOCK) {
 		td->io_ops->getevents = NULL;
 		td->io_ops->event = NULL;
 	}
@@ -789,7 +789,7 @@ static int fio_sgio_get_file_size(struct thread_data *td, struct fio_file *f)
 	if (fio_file_size_known(f))
 		return 0;
 
-	if (f->filetype != FIO_TYPE_BD && f->filetype != FIO_TYPE_CHAR) {
+	if (f->filetype != FIO_TYPE_BLOCK && f->filetype != FIO_TYPE_CHAR) {
 		td_verror(td, EINVAL, "wrong file type");
 		log_err("ioengine sg only works on block or character devices\n");
 		return 1;
diff --git a/file.h b/file.h
index 6f34dd5..ac00ff8 100644
--- a/file.h
+++ b/file.h
@@ -15,7 +15,7 @@
  */
 enum fio_filetype {
 	FIO_TYPE_FILE = 1,		/* plain file */
-	FIO_TYPE_BD,			/* block device */
+	FIO_TYPE_BLOCK,			/* block device */
 	FIO_TYPE_CHAR,			/* character device */
 	FIO_TYPE_PIPE,			/* pipe */
 };
diff --git a/filesetup.c b/filesetup.c
index ef94bd2..eb28826 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -370,7 +370,7 @@ static int get_file_size(struct thread_data *td, struct fio_file *f)
 
 	if (f->filetype == FIO_TYPE_FILE)
 		ret = file_size(td, f);
-	else if (f->filetype == FIO_TYPE_BD)
+	else if (f->filetype == FIO_TYPE_BLOCK)
 		ret = bdev_size(td, f);
 	else if (f->filetype == FIO_TYPE_CHAR)
 		ret = char_size(td, f);
@@ -420,7 +420,7 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
 		if (ret)
 			errval = ret;
-	} else if (f->filetype == FIO_TYPE_BD) {
+	} else if (f->filetype == FIO_TYPE_BLOCK) {
 		int retry_count = 0;
 
 		ret = blockdev_invalidate_cache(f);
@@ -709,7 +709,7 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 		struct stat sb;
 		char buf[256];
 
-		if (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_CHAR) {
+		if (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_CHAR) {
 			if (f->real_file_size != -1ULL)
 				ret += f->real_file_size;
 			continue;
@@ -1228,12 +1228,12 @@ static void get_file_type(struct fio_file *f)
 	/* \\.\ is the device namespace in Windows, where every file is
 	 * a block device */
 	if (strncmp(f->file_name, "\\\\.\\", 4) == 0)
-		f->filetype = FIO_TYPE_BD;
+		f->filetype = FIO_TYPE_BLOCK;
 #endif
 
 	if (!stat(f->file_name, &sb)) {
 		if (S_ISBLK(sb.st_mode))
-			f->filetype = FIO_TYPE_BD;
+			f->filetype = FIO_TYPE_BLOCK;
 		else if (S_ISCHR(sb.st_mode))
 			f->filetype = FIO_TYPE_CHAR;
 		else if (S_ISFIFO(sb.st_mode))
diff --git a/ioengines.c b/ioengines.c
index a1f8756..315432d 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -449,7 +449,7 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 		goto err;
 
 	if (td->o.fadvise_hint != F_ADV_NONE &&
-	    (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
+	    (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_FILE)) {
 		int flags;
 
 		if (td->o.fadvise_hint == F_ADV_TYPE) {
@@ -474,7 +474,7 @@ int td_io_open_file(struct thread_data *td, struct fio_file *f)
 	}
 #ifdef FIO_HAVE_STREAMID
 	if (td->o.fadvise_stream &&
-	    (f->filetype == FIO_TYPE_BD || f->filetype == FIO_TYPE_FILE)) {
+	    (f->filetype == FIO_TYPE_BLOCK || f->filetype == FIO_TYPE_FILE)) {
 		off_t stream = td->o.fadvise_stream;
 
 		if (posix_fadvise(f->fd, stream, f->io_size, POSIX_FADV_STREAMID) < 0) {
-- 
2.5.5


