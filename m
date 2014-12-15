Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaLONAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Dec 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y0VFt-0001Jf-2h
	for fio@vger.kernel.org; Mon, 15 Dec 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141215130003.0F8F5401D9@lyth.info>
Date: Mon, 15 Dec 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 70034d87976e9175054b8c5d7b32f28be638570f:

  eta.c: check malloc return code (2014-12-12 21:50:30 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 03a32636475b2efeb9ac3694c36fbe45b187d32a:

  file: move mmap related data to engines/mmap.c where it belongs (2014-12-14 19:17:27 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Fix read/write mix and different levels of randomness
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      file: move mmap related data to engines/mmap.c where it belongs

 engines/mmap.c |  105 +++++++++++++++++++++++++++++++++++++++++++-------------
 file.h         |   11 +++---
 filesetup.c    |   19 +++++-----
 io_u.c         |   24 ++++++-------
 4 files changed, 107 insertions(+), 52 deletions(-)

---

Diff of recent changes:

diff --git a/engines/mmap.c b/engines/mmap.c
index 8c04a19..29ac5db 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -22,9 +22,16 @@
 static unsigned long mmap_map_size;
 static unsigned long mmap_map_mask;
 
+struct fio_mmap_data {
+	void *mmap_ptr;
+	size_t mmap_sz;
+	off_t mmap_off;
+};
+
 static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			 size_t length, off_t off)
 {
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
 	int flags = 0;
 
 	if (td_rw(td))
@@ -37,28 +44,28 @@ static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 	} else
 		flags = PROT_READ;
 
-	f->mmap_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
-	if (f->mmap_ptr == MAP_FAILED) {
-		f->mmap_ptr = NULL;
+	fmd->mmap_ptr = mmap(NULL, length, flags, MAP_SHARED, f->fd, off);
+	if (fmd->mmap_ptr == MAP_FAILED) {
+		fmd->mmap_ptr = NULL;
 		td_verror(td, errno, "mmap");
 		goto err;
 	}
 
 	if (!td_random(td)) {
-		if (posix_madvise(f->mmap_ptr, length, POSIX_MADV_SEQUENTIAL) < 0) {
+		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_SEQUENTIAL) < 0) {
 			td_verror(td, errno, "madvise");
 			goto err;
 		}
 	} else {
-		if (posix_madvise(f->mmap_ptr, length, POSIX_MADV_RANDOM) < 0) {
+		if (posix_madvise(fmd->mmap_ptr, length, POSIX_MADV_RANDOM) < 0) {
 			td_verror(td, errno, "madvise");
 			goto err;
 		}
 	}
 
 err:
-	if (td->error && f->mmap_ptr)
-		munmap(f->mmap_ptr, length);
+	if (td->error && fmd->mmap_ptr)
+		munmap(fmd->mmap_ptr, length);
 
 	return td->error;
 }
@@ -69,19 +76,20 @@ err:
 static int fio_mmapio_prep_limited(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
 
 	if (io_u->buflen > mmap_map_size) {
 		log_err("fio: bs too big for mmap engine\n");
 		return EIO;
 	}
 
-	f->mmap_sz = mmap_map_size;
-	if (f->mmap_sz  > f->io_size)
-		f->mmap_sz = f->io_size;
+	fmd->mmap_sz = mmap_map_size;
+	if (fmd->mmap_sz  > f->io_size)
+		fmd->mmap_sz = f->io_size;
 
-	f->mmap_off = io_u->offset;
+	fmd->mmap_off = io_u->offset;
 
-	return fio_mmap_file(td, f, f->mmap_sz, f->mmap_off);
+	return fio_mmap_file(td, f, fmd->mmap_sz, fmd->mmap_off);
 }
 
 /*
@@ -90,15 +98,16 @@ static int fio_mmapio_prep_limited(struct thread_data *td, struct io_u *io_u)
 static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
 	int ret;
 
 	if (fio_file_partial_mmap(f))
 		return EINVAL;
 
-	f->mmap_sz = f->io_size;
-	f->mmap_off = 0;
+	fmd->mmap_sz = f->io_size;
+	fmd->mmap_off = 0;
 
-	ret = fio_mmap_file(td, f, f->mmap_sz, f->mmap_off);
+	ret = fio_mmap_file(td, f, fmd->mmap_sz, fmd->mmap_off);
 	if (ret)
 		fio_file_set_partial_mmap(f);
 
@@ -108,22 +117,23 @@ static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
 	int ret;
 
 	/*
 	 * It fits within existing mapping, use it
 	 */
-	if (io_u->offset >= f->mmap_off &&
-	    io_u->offset + io_u->buflen < f->mmap_off + f->mmap_sz)
+	if (io_u->offset >= fmd->mmap_off &&
+	    io_u->offset + io_u->buflen < fmd->mmap_off + fmd->mmap_sz)
 		goto done;
 
 	/*
 	 * unmap any existing mapping
 	 */
-	if (f->mmap_ptr) {
-		if (munmap(f->mmap_ptr, f->mmap_sz) < 0)
+	if (fmd->mmap_ptr) {
+		if (munmap(fmd->mmap_ptr, fmd->mmap_sz) < 0)
 			return errno;
-		f->mmap_ptr = NULL;
+		fmd->mmap_ptr = NULL;
 	}
 
 	if (fio_mmapio_prep_full(td, io_u)) {
@@ -134,7 +144,7 @@ static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 	}
 
 done:
-	io_u->mmap_data = f->mmap_ptr + io_u->offset - f->mmap_off -
+	io_u->mmap_data = fmd->mmap_ptr + io_u->offset - fmd->mmap_off -
 				f->file_offset;
 	return 0;
 }
@@ -142,6 +152,7 @@ done:
 static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
 
 	fio_ro_check(td, io_u);
 
@@ -150,7 +161,7 @@ static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 	else if (io_u->ddir == DDIR_WRITE)
 		memcpy(io_u->mmap_data, io_u->xfer_buf, io_u->xfer_buflen);
 	else if (ddir_sync(io_u->ddir)) {
-		if (msync(f->mmap_ptr, f->mmap_sz, MS_SYNC)) {
+		if (msync(fmd->mmap_ptr, fmd->mmap_sz, MS_SYNC)) {
 			io_u->error = errno;
 			td_verror(td, io_u->error, "msync");
 		}
@@ -205,14 +216,60 @@ static int fio_mmapio_init(struct thread_data *td)
 	return 0;
 }
 
+static int fio_mmapio_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_mmap_data *fmd;
+	int ret;
+
+	ret = generic_open_file(td, f);
+	if (ret)
+		return ret;
+
+	fmd = calloc(1, sizeof(*fmd));
+	if (!fmd) {
+		int fio_unused ret;
+		ret = generic_close_file(td, f);
+		return 1;
+	}
+
+	f->engine_data = (uintptr_t) fmd;
+	return 0;
+}
+
+static int fio_mmapio_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_mmap_data *fmd;
+
+	fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	f->engine_data = 0;
+	free(fmd);
+
+	return generic_close_file(td, f);
+}
+
+static int fio_mmapio_invalidate(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	int ret;
+
+	ret = posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, POSIX_MADV_DONTNEED);
+#ifdef FIO_MADV_FREE
+	if (f->filetype == FIO_TYPE_BD)
+		(void) posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, FIO_MADV_FREE);
+#endif
+
+	return ret;
+}
+
 static struct ioengine_ops ioengine = {
 	.name		= "mmap",
 	.version	= FIO_IOOPS_VERSION,
 	.init		= fio_mmapio_init,
 	.prep		= fio_mmapio_prep,
 	.queue		= fio_mmapio_queue,
-	.open_file	= generic_open_file,
-	.close_file	= generic_close_file,
+	.open_file	= fio_mmapio_open_file,
+	.close_file	= fio_mmapio_close_file,
+	.invalidate	= fio_mmapio_invalidate,
 	.get_file_size	= generic_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
 };
diff --git a/file.h b/file.h
index add7773..bfb571b 100644
--- a/file.h
+++ b/file.h
@@ -77,10 +77,6 @@ struct fio_file {
 	unsigned int major, minor;
 	int fileno;
 
-	void *mmap_ptr;
-	size_t mmap_sz;
-	off_t mmap_off;
-
 	/*
 	 * size of the file, offset into file, and io size from that offset
 	 */
@@ -88,8 +84,11 @@ struct fio_file {
 	uint64_t file_offset;
 	uint64_t io_size;
 
-	uint64_t last_pos;
-	uint64_t last_start;
+	/*
+	 * Track last end and last start of IO for a given data direction
+	 */
+	uint64_t last_pos[DDIR_RWDIR_CNT];
+	uint64_t last_start[DDIR_RWDIR_CNT];
 
 	uint64_t first_write;
 	uint64_t last_write;
diff --git a/filesetup.c b/filesetup.c
index cc6d440..c026048 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -400,15 +400,9 @@ static int __file_invalidate_cache(struct thread_data *td, struct fio_file *f,
 
 	if (td->io_ops->invalidate)
 		ret = td->io_ops->invalidate(td, f);
-	else if (f->mmap_ptr) {
-		ret = posix_madvise(f->mmap_ptr, f->mmap_sz, POSIX_MADV_DONTNEED);
-#ifdef FIO_MADV_FREE
-		if (f->filetype == FIO_TYPE_BD)
-			(void) posix_madvise(f->mmap_ptr, f->mmap_sz, FIO_MADV_FREE);
-#endif
-	} else if (f->filetype == FIO_TYPE_FILE) {
+	else if (f->filetype == FIO_TYPE_FILE)
 		ret = posix_fadvise(f->fd, off, len, POSIX_FADV_DONTNEED);
-	} else if (f->filetype == FIO_TYPE_BD) {
+	else if (f->filetype == FIO_TYPE_BD) {
 		ret = blockdev_invalidate_cache(f);
 		if (ret < 0 && errno == EACCES && geteuid()) {
 			if (!root_warn) {
@@ -1536,8 +1530,13 @@ void free_release_files(struct thread_data *td)
 
 void fio_file_reset(struct thread_data *td, struct fio_file *f)
 {
-	f->last_pos = f->file_offset;
-	f->last_start = -1ULL;
+	int i;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		f->last_pos[i] = f->file_offset;
+		f->last_start[i] = -1ULL;
+	}
+
 	if (f->io_axmap)
 		axmap_reset(f->io_axmap);
 	if (td->o.random_generator == FIO_RAND_GEN_LFSR)
diff --git a/io_u.c b/io_u.c
index f135908..efbcea9 100644
--- a/io_u.c
+++ b/io_u.c
@@ -249,7 +249,7 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 	}
 
 	dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
-			f->file_name, (unsigned long long) f->last_pos,
+			f->file_name, (unsigned long long) f->last_pos[ddir],
 			(unsigned long long) f->real_file_size);
 	return 1;
 }
@@ -261,17 +261,17 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 
 	assert(ddir_rw(ddir));
 
-	if (f->last_pos >= f->io_size + get_start_offset(td, f) &&
+	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
 	    o->time_based)
-		f->last_pos = f->last_pos - f->io_size;
+		f->last_pos[ddir] = f->last_pos[ddir] - f->io_size;
 
-	if (f->last_pos < f->real_file_size) {
+	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
-		if (f->last_pos == f->file_offset && o->ddir_seq_add < 0)
-			f->last_pos = f->real_file_size;
+		if (f->last_pos[ddir] == f->file_offset && o->ddir_seq_add < 0)
+			f->last_pos[ddir] = f->real_file_size;
 
-		pos = f->last_pos - f->file_offset;
+		pos = f->last_pos[ddir] - f->file_offset;
 		if (pos && o->ddir_seq_add) {
 			pos += o->ddir_seq_add;
 
@@ -330,8 +330,8 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 				*is_random = 0;
 			}
 		} else if (td->o.rw_seq == RW_SEQ_IDENT) {
-			if (f->last_start != -1ULL)
-				offset = f->last_start - f->file_offset;
+			if (f->last_start[ddir] != -1ULL)
+				offset = f->last_start[ddir] - f->file_offset;
 			else
 				offset = 0;
 			ret = 0;
@@ -743,7 +743,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		 */
 		if (f->file_offset >= f->real_file_size)
 			f->file_offset = f->real_file_size - f->file_offset;
-		f->last_pos = f->file_offset;
+		f->last_pos[io_u->ddir] = f->file_offset;
 		td->io_skip_bytes += td->o.zone_skip;
 	}
 
@@ -1471,8 +1471,8 @@ struct io_u *get_io_u(struct thread_data *td)
 			goto err_put;
 		}
 
-		f->last_start = io_u->offset;
-		f->last_pos = io_u->offset + io_u->buflen;
+		f->last_start[io_u->ddir] = io_u->offset;
+		f->last_pos[io_u->ddir] = io_u->offset + io_u->buflen;
 
 		if (io_u->ddir == DDIR_WRITE) {
 			if (td->flags & TD_F_REFILL_BUFFERS) {
