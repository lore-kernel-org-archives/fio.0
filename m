Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37560 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaLPNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Dec 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y0rjQ-0005wt-5K
	for fio@vger.kernel.org; Tue, 16 Dec 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141216130003.05AE240257@lyth.info>
Date: Tue, 16 Dec 2014 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 03a32636475b2efeb9ac3694c36fbe45b187d32a:

  file: move mmap related data to engines/mmap.c where it belongs (2014-12-14 19:17:27 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f893b76d5745811033f056ae4d4efe4f571452bd:

  backend: use monotonic clock for ETA, if we have it (2014-12-15 19:54:57 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Add helpers for getting/setting file engine data
      file: unionize lfsr/randommap
      backend: fix off-by-one in nsec calculation
      backend: use monotonic clock for ETA, if we have it

 backend.c           |   10 +++++++++-
 engines/binject.c   |   19 +++++++++----------
 engines/fusion-aw.c |   10 +++++-----
 engines/mmap.c      |   19 +++++++++----------
 file.h              |   17 +++++++++++++----
 filesetup.c         |   18 ++++++++++++------
 io_ddir.h           |    2 +-
 io_u.c              |    2 ++
 8 files changed, 60 insertions(+), 37 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 3424a09..3df0133 100644
--- a/backend.c
+++ b/backend.c
@@ -2104,12 +2104,20 @@ static void *helper_thread_main(void *data)
 		uint64_t sec = DISK_UTIL_MSEC / 1000;
 		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
 		struct timespec ts;
+
+#if defined(CONFIG_CLOCK_MONOTONIC)
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+		ts.tv_sec += sec;
+		ts.tv_nsec += nsec;
+#else
 		struct timeval tv;
 
 		gettimeofday(&tv, NULL);
 		ts.tv_sec = tv.tv_sec + sec;
 		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
-		if (ts.tv_nsec > 1000000000ULL) {
+#endif
+
+		if (ts.tv_nsec >= 1000000000ULL) {
 			ts.tv_nsec -= 1000000000ULL;
 			ts.tv_sec++;
 		}
diff --git a/engines/binject.c b/engines/binject.c
index c0baf9d..f8e83cd 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -62,14 +62,14 @@ static int pollin_events(struct pollfd *pfds, int fds)
 static unsigned int binject_read_commands(struct thread_data *td, void *p,
 					  int left, int *err)
 {
-	struct binject_file *bf;
 	struct fio_file *f;
 	int i, ret, events;
 
 one_more:
 	events = 0;
 	for_each_file(td, f, i) {
-		bf = (struct binject_file *) (uintptr_t) f->engine_data;
+		struct binject_file *bf = FILE_ENG_DATA(f);
+
 		ret = read(bf->fd, p, left * sizeof(struct b_user_cmd));
 		if (ret < 0) {
 			if (errno == EAGAIN)
@@ -99,13 +99,12 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 	void *buf = bd->cmds;
 	unsigned int i, events;
 	struct fio_file *f;
-	struct binject_file *bf;
 
 	/*
 	 * Fill in the file descriptors
 	 */
 	for_each_file(td, f, i) {
-		bf = (struct binject_file *) (uintptr_t) f->engine_data;
+		struct binject_file *bf = FILE_ENG_DATA(f);
 
 		/*
 		 * don't block for min events == 0
@@ -155,7 +154,7 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 
 	if (!min) {
 		for_each_file(td, f, i) {
-			bf = (struct binject_file *) (uintptr_t) f->engine_data;
+			struct binject_file *bf = FILE_ENG_DATA(f);
 
 			if (bd->fd_flags[i] == -1)
 				continue;
@@ -174,7 +173,7 @@ static int fio_binject_getevents(struct thread_data *td, unsigned int min,
 static int fio_binject_doio(struct thread_data *td, struct io_u *io_u)
 {
 	struct b_user_cmd *buc = &io_u->buc;
-	struct binject_file *bf = (struct binject_file *) (uintptr_t) io_u->file->engine_data;
+	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
 	int ret;
 
 	ret = write(bf->fd, buc, sizeof(*buc));
@@ -188,7 +187,7 @@ static int fio_binject_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct binject_data *bd = td->io_ops->data;
 	struct b_user_cmd *buc = &io_u->buc;
-	struct binject_file *bf = (struct binject_file *) (uintptr_t) io_u->file->engine_data;
+	struct binject_file *bf = FILE_ENG_DATA(io_u->file);
 
 	if (io_u->xfer_buflen & (bf->bs - 1)) {
 		log_err("read/write not sector aligned\n");
@@ -330,12 +329,12 @@ err_unmap:
 
 static int fio_binject_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct binject_file *bf = (struct binject_file *) (uintptr_t) f->engine_data;
+	struct binject_file *bf = FILE_ENG_DATA(f);
 
 	if (bf) {
 		binject_unmap_dev(td, bf);
 		free(bf);
-		f->engine_data = 0;
+		FILE_SET_ENG_DATA(f, NULL);
 		return generic_close_file(td, f);
 	}
 
@@ -364,7 +363,7 @@ static int fio_binject_open_file(struct thread_data *td, struct fio_file *f)
 	bf = malloc(sizeof(*bf));
 	bf->bs = bs;
 	bf->minor = bf->fd = -1;
-	f->engine_data = (uintptr_t) bf;
+	FILE_SET_ENG_DATA(f, bf);
 
 	if (binject_map_dev(td, bf, f->fd)) {
 err_close:
diff --git a/engines/fusion-aw.c b/engines/fusion-aw.c
index 23f623a..77844ff 100644
--- a/engines/fusion-aw.c
+++ b/engines/fusion-aw.c
@@ -36,8 +36,8 @@ struct fas_data {
 
 static int queue(struct thread_data *td, struct io_u *io_u)
 {
+	struct fas_data *d = FILE_ENG_DATA(io_u->file);
 	int rc;
-	struct fas_data *d = (struct fas_data *) io_u->file->engine_data;
 
 	if (io_u->ddir != DDIR_WRITE) {
 		td_vmsg(td, EINVAL, "only writes supported", "io_u->ddir");
@@ -94,7 +94,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 		goto error;
 	}
 	d->nvm_handle = -1;
-	f->engine_data = (uintptr_t) d;
+	FILE_SET_ENG_DATA(f, d);
 
 	rc = generic_open_file(td, f);
 
@@ -144,19 +144,19 @@ free_engine_data:
 	free(d);
 error:
 	f->fd = -1;
-	f->engine_data = 0;
+	FILE_SET_ENG_DATA(f, NULL);
 	goto out;
 }
 
 static int close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct fas_data *d = (struct fas_data *) f->engine_data;
+	struct fas_data *d = FILE_ENG_DATA(f);
 
 	if (d) {
 		if (d->nvm_handle != -1)
 			nvm_release_handle(d->nvm_handle);
 		free(d);
-		f->engine_data = 0;
+		FILE_SET_ENG_DATA(f, NULL);
 	}
 
 	return generic_close_file(td, f);
diff --git a/engines/mmap.c b/engines/mmap.c
index 29ac5db..6464cba 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -31,7 +31,7 @@ struct fio_mmap_data {
 static int fio_mmap_file(struct thread_data *td, struct fio_file *f,
 			 size_t length, off_t off)
 {
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 	int flags = 0;
 
 	if (td_rw(td))
@@ -76,7 +76,7 @@ err:
 static int fio_mmapio_prep_limited(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 
 	if (io_u->buflen > mmap_map_size) {
 		log_err("fio: bs too big for mmap engine\n");
@@ -98,7 +98,7 @@ static int fio_mmapio_prep_limited(struct thread_data *td, struct io_u *io_u)
 static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 	int ret;
 
 	if (fio_file_partial_mmap(f))
@@ -117,7 +117,7 @@ static int fio_mmapio_prep_full(struct thread_data *td, struct io_u *io_u)
 static int fio_mmapio_prep(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 	int ret;
 
 	/*
@@ -152,7 +152,7 @@ done:
 static int fio_mmapio_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 
 	fio_ro_check(td, io_u);
 
@@ -232,16 +232,15 @@ static int fio_mmapio_open_file(struct thread_data *td, struct fio_file *f)
 		return 1;
 	}
 
-	f->engine_data = (uintptr_t) fmd;
+	FILE_SET_ENG_DATA(f, fmd);
 	return 0;
 }
 
 static int fio_mmapio_close_file(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_mmap_data *fmd;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 
-	fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
-	f->engine_data = 0;
+	FILE_SET_ENG_DATA(f, NULL);
 	free(fmd);
 
 	return generic_close_file(td, f);
@@ -249,7 +248,7 @@ static int fio_mmapio_close_file(struct thread_data *td, struct fio_file *f)
 
 static int fio_mmapio_invalidate(struct thread_data *td, struct fio_file *f)
 {
-	struct fio_mmap_data *fmd = (struct fio_mmap_data *) (uintptr_t) f->engine_data;
+	struct fio_mmap_data *fmd = FILE_ENG_DATA(f);
 	int ret;
 
 	ret = posix_madvise(fmd->mmap_ptr, fmd->mmap_sz, POSIX_MADV_DONTNEED);
diff --git a/file.h b/file.h
index bfb571b..f7a1eae 100644
--- a/file.h
+++ b/file.h
@@ -27,6 +27,8 @@ enum fio_file_flags {
 	FIO_FILE_size_known	= 1 << 4,	/* size has been set */
 	FIO_FILE_hashed		= 1 << 5,	/* file is on hash */
 	FIO_FILE_partial_mmap	= 1 << 6,	/* can't do full mmap */
+	FIO_FILE_axmap		= 1 << 7,	/* uses axmap */
+	FIO_FILE_lfsr		= 1 << 8,	/* lfsr is used */
 };
 
 enum file_lock_mode {
@@ -107,11 +109,12 @@ struct fio_file {
 	};
 
 	/*
-	 * block map for random io
+	 * block map or LFSR for random io
 	 */
-	struct axmap *io_axmap;
-
-	struct fio_lfsr lfsr;
+	union {
+		struct axmap *io_axmap;
+		struct fio_lfsr lfsr;
+	};
 
 	/*
 	 * Used for zipf random distribution
@@ -124,6 +127,10 @@ struct fio_file {
 	struct disk_util *du;
 };
 
+#define FILE_ENG_DATA(f)	((void *) (uintptr_t) (f)->engine_data)
+#define FILE_SET_ENG_DATA(f, data)	\
+	((f)->engine_data = (uintptr_t) (data))
+
 struct file_name {
 	struct flist_head list;
 	char *filename;
@@ -150,6 +157,8 @@ FILE_FLAG_FNS(done);
 FILE_FLAG_FNS(size_known);
 FILE_FLAG_FNS(hashed);
 FILE_FLAG_FNS(partial_mmap);
+FILE_FLAG_FNS(axmap);
+FILE_FLAG_FNS(lfsr);
 #undef FILE_FLAG_FNS
 
 /*
diff --git a/filesetup.c b/filesetup.c
index c026048..0fb5589 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1044,12 +1044,16 @@ int init_random_map(struct thread_data *td)
 
 			seed = td->rand_seeds[FIO_RAND_BLOCK_OFF];
 
-			if (!lfsr_init(&f->lfsr, blocks, seed, 0))
+			if (!lfsr_init(&f->lfsr, blocks, seed, 0)) {
+				fio_file_set_lfsr(f);
 				continue;
+			}
 		} else if (!td->o.norandommap) {
 			f->io_axmap = axmap_new(blocks);
-			if (f->io_axmap)
+			if (f->io_axmap) {
+				fio_file_set_axmap(f);
 				continue;
+			}
 		} else if (td->o.norandommap)
 			continue;
 
@@ -1104,8 +1108,10 @@ void close_and_free_files(struct thread_data *td)
 
 		sfree(f->file_name);
 		f->file_name = NULL;
-		axmap_free(f->io_axmap);
-		f->io_axmap = NULL;
+		if (fio_file_axmap(f)) {
+			axmap_free(f->io_axmap);
+			f->io_axmap = NULL;
+		}
 		sfree(f);
 	}
 
@@ -1537,9 +1543,9 @@ void fio_file_reset(struct thread_data *td, struct fio_file *f)
 		f->last_start[i] = -1ULL;
 	}
 
-	if (f->io_axmap)
+	if (fio_file_axmap(f))
 		axmap_reset(f->io_axmap);
-	if (td->o.random_generator == FIO_RAND_GEN_LFSR)
+	else if (fio_file_lfsr(f))
 		lfsr_reset(&f->lfsr, td->rand_seeds[FIO_RAND_BLOCK_OFF]);
 }
 
diff --git a/io_ddir.h b/io_ddir.h
index 269768e..b16a6b9 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -42,7 +42,7 @@ enum td_ddir {
 #define td_trim(td)		((td)->o.td_ddir & TD_DDIR_TRIM)
 #define td_rw(td)		(((td)->o.td_ddir & TD_DDIR_RW) == TD_DDIR_RW)
 #define td_random(td)		((td)->o.td_ddir & TD_DDIR_RAND)
-#define file_randommap(td, f)	(!(td)->o.norandommap && (f)->io_axmap)
+#define file_randommap(td, f)	(!(td)->o.norandommap && fio_file_axmap((f)))
 
 static inline int ddir_sync(enum fio_ddir ddir)
 {
diff --git a/io_u.c b/io_u.c
index efbcea9..23a9e4a 100644
--- a/io_u.c
+++ b/io_u.c
@@ -100,6 +100,8 @@ static int __get_next_rand_offset(struct thread_data *td, struct fio_file *f,
 	} else {
 		uint64_t off = 0;
 
+		assert(fio_file_lfsr(f));
+
 		if (lfsr_next(&f->lfsr, &off))
 			return 1;
 
