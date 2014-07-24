Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbaGXMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 24 Jul 2014 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XAHgq-000688-7O
	for fio@vger.kernel.org; Thu, 24 Jul 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140724120003.29EFF40143@lyth.info>
Date: Thu, 24 Jul 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 7ffa8930764e6ccc5bf036fe4d73f1d7276453e5:

  verify: ensure that verify interval is smaller or equal to blocksize (2014-07-23 09:47:26 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5c57c084346fbfe6f3f45236c151ad1c83b6b398:

  null: add FIO_FAKEIO flag (2014-07-23 16:19:48 +0200)

----------------------------------------------------------------
Jens Axboe (2):
      verify: fix a bug with verify_async
      null: add FIO_FAKEIO flag

 engines/null.c |    4 +--
 io_u.c         |   89 +++++++++++++++++++++++++++++---------------------------
 io_u_queue.h   |    9 ++++--
 ioengine.h     |    5 ++--
 verify.c       |   26 ++++++++++++-----
 verify.h       |    4 +--
 6 files changed, 79 insertions(+), 58 deletions(-)

---

Diff of recent changes:

diff --git a/engines/null.c b/engines/null.c
index eb17b11..e7df6a1 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -119,7 +119,7 @@ static struct ioengine_ops ioengine = {
 	.init		= fio_null_init,
 	.cleanup	= fio_null_cleanup,
 	.open_file	= fio_null_open,
-	.flags		= FIO_DISKLESSIO,
+	.flags		= FIO_DISKLESSIO | FIO_FAKEIO,
 };
 
 static void fio_init fio_null_register(void)
@@ -152,7 +152,7 @@ void get_ioengine(struct ioengine_ops **ioengine_ptr)
 	ioengine->init           = fio_null_init;
 	ioengine->cleanup        = fio_null_cleanup;
 	ioengine->open_file      = fio_null_open;
-	ioengine->flags	         = FIO_DISKLESSIO;
+	ioengine->flags	         = FIO_DISKLESSIO | FIO_FAKEIO;
 }
 }
 #endif /* FIO_EXTERNAL_ENGINE */
diff --git a/io_u.c b/io_u.c
index 16b52d6..ba192a3 100644
--- a/io_u.c
+++ b/io_u.c
@@ -688,10 +688,10 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
 	td_io_u_lock(td);
 
-	if (io_u->file && !(io_u->flags & IO_U_F_FREE_DEF))
+	if (io_u->file && !(io_u->flags & IO_U_F_NO_FILE_PUT))
 		put_file_log(td, io_u->file);
+
 	io_u->file = NULL;
-	io_u->flags &= ~IO_U_F_FREE_DEF;
 	io_u->flags |= IO_U_F_FREE;
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH)
@@ -1313,9 +1313,9 @@ again:
 
 	if (io_u) {
 		assert(io_u->flags & IO_U_F_FREE);
-		io_u->flags &= ~(IO_U_F_FREE | IO_U_F_FREE_DEF);
-		io_u->flags &= ~(IO_U_F_TRIMMED | IO_U_F_BARRIER);
-		io_u->flags &= ~IO_U_F_VER_LIST;
+		io_u->flags &= ~(IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
+				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
+				 IO_U_F_VER_LIST);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
@@ -1607,10 +1607,12 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	return remainder * 1000000 / bps + secs * 1000000;
 }
 
-static void io_completed(struct thread_data *td, struct io_u *io_u,
+static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			 struct io_completion_data *icd)
 {
-	struct fio_file *f;
+	struct io_u *io_u = *io_u_ptr;
+	enum fio_ddir ddir = io_u->ddir;
+	struct fio_file *f = io_u->file;
 
 	dprint_io_u(io_u, "io complete");
 
@@ -1635,9 +1637,8 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 
 	td_io_u_unlock(td);
 
-	if (ddir_sync(io_u->ddir)) {
+	if (ddir_sync(ddir)) {
 		td->last_was_sync = 1;
-		f = io_u->file;
 		if (f) {
 			f->first_write = -1ULL;
 			f->last_write = -1ULL;
@@ -1646,52 +1647,51 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 	}
 
 	td->last_was_sync = 0;
-	td->last_ddir = io_u->ddir;
+	td->last_ddir = ddir;
 
-	if (!io_u->error && ddir_rw(io_u->ddir)) {
+	if (!io_u->error && ddir_rw(ddir)) {
 		unsigned int bytes = io_u->buflen - io_u->resid;
-		const enum fio_ddir idx = io_u->ddir;
-		const enum fio_ddir odx = io_u->ddir ^ 1;
+		const enum fio_ddir oddir = ddir ^ 1;
 		int ret;
 
-		td->io_blocks[idx]++;
-		td->this_io_blocks[idx]++;
-		td->io_bytes[idx] += bytes;
+		td->io_blocks[ddir]++;
+		td->this_io_blocks[ddir]++;
+		td->io_bytes[ddir] += bytes;
 
 		if (!(io_u->flags & IO_U_F_VER_LIST))
-			td->this_io_bytes[idx] += bytes;
-
-		if (idx == DDIR_WRITE) {
-			f = io_u->file;
-			if (f) {
-				if (f->first_write == -1ULL ||
-				    io_u->offset < f->first_write)
-					f->first_write = io_u->offset;
-				if (f->last_write == -1ULL ||
-				    ((io_u->offset + bytes) > f->last_write))
-					f->last_write = io_u->offset + bytes;
-			}
+			td->this_io_bytes[ddir] += bytes;
+
+		if (ddir == DDIR_WRITE && f) {
+			if (f->first_write == -1ULL ||
+			    io_u->offset < f->first_write)
+				f->first_write = io_u->offset;
+			if (f->last_write == -1ULL ||
+			    ((io_u->offset + bytes) > f->last_write))
+				f->last_write = io_u->offset + bytes;
 		}
 
 		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
 					   td->runstate == TD_VERIFYING)) {
-			account_io_completion(td, io_u, icd, idx, bytes);
+			account_io_completion(td, io_u, icd, ddir, bytes);
 
-			if (__should_check_rate(td, idx)) {
-				td->rate_pending_usleep[idx] =
-					(usec_for_io(td, idx) -
+			if (__should_check_rate(td, ddir)) {
+				td->rate_pending_usleep[ddir] =
+					(usec_for_io(td, ddir) -
 					 utime_since_now(&td->start));
 			}
-			if (idx != DDIR_TRIM && __should_check_rate(td, odx))
-				td->rate_pending_usleep[odx] =
-					(usec_for_io(td, odx) -
+			if (ddir != DDIR_TRIM &&
+			    __should_check_rate(td, oddir)) {
+				td->rate_pending_usleep[oddir] =
+					(usec_for_io(td, oddir) -
 					 utime_since_now(&td->start));
+			}
 		}
 
-		icd->bytes_done[idx] += bytes;
+		icd->bytes_done[ddir] += bytes;
 
 		if (io_u->end_io) {
-			ret = io_u->end_io(td, io_u);
+			ret = io_u->end_io(td, io_u_ptr);
+			io_u = *io_u_ptr;
 			if (ret && !icd->error)
 				icd->error = ret;
 		}
@@ -1700,9 +1700,11 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		io_u_log_error(td, io_u);
 	}
 	if (icd->error) {
-		enum error_type_bit eb = td_error_type(io_u->ddir, icd->error);
+		enum error_type_bit eb = td_error_type(ddir, icd->error);
+
 		if (!td_non_fatal_error(td, eb, icd->error))
 			return;
+
 		/*
 		 * If there is a non_fatal error, then add to the error count
 		 * and clear all the errors.
@@ -1710,7 +1712,8 @@ static void io_completed(struct thread_data *td, struct io_u *io_u,
 		update_error_count(td, icd->error);
 		td_clear_error(td);
 		icd->error = 0;
-		io_u->error = 0;
+		if (io_u)
+			io_u->error = 0;
 	}
 }
 
@@ -1738,9 +1741,9 @@ static void ios_completed(struct thread_data *td,
 	for (i = 0; i < icd->nr; i++) {
 		io_u = td->io_ops->event(td, i);
 
-		io_completed(td, io_u, icd);
+		io_completed(td, &io_u, icd);
 
-		if (!(io_u->flags & IO_U_F_FREE_DEF))
+		if (io_u)
 			put_io_u(td, io_u);
 	}
 }
@@ -1754,9 +1757,9 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u,
 	struct io_completion_data icd;
 
 	init_icd(td, &icd, 1);
-	io_completed(td, io_u, &icd);
+	io_completed(td, &io_u, &icd);
 
-	if (!(io_u->flags & IO_U_F_FREE_DEF))
+	if (io_u)
 		put_io_u(td, io_u);
 
 	if (icd.error) {
diff --git a/io_u_queue.h b/io_u_queue.h
index 5b6cad0..b702b1f 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -12,8 +12,13 @@ struct io_u_queue {
 
 static inline struct io_u *io_u_qpop(struct io_u_queue *q)
 {
-	if (q->nr)
-		return q->io_us[--q->nr];
+	if (q->nr) {
+		const unsigned int next = --q->nr;
+		struct io_u *io_u = q->io_us[next];
+
+		q->io_us[next] = NULL;
+		return io_u;
+	}
 
 	return NULL;
 }
diff --git a/ioengine.h b/ioengine.h
index 37bf5fc..ebe0ebe 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -20,7 +20,7 @@
 enum {
 	IO_U_F_FREE		= 1 << 0,
 	IO_U_F_FLIGHT		= 1 << 1,
-	IO_U_F_FREE_DEF		= 1 << 2,
+	IO_U_F_NO_FILE_PUT	= 1 << 2,
 	IO_U_F_IN_CUR_DEPTH	= 1 << 3,
 	IO_U_F_BUSY_OK		= 1 << 4,
 	IO_U_F_TRIMMED		= 1 << 5,
@@ -90,7 +90,7 @@ struct io_u {
 	/*
 	 * Callback for io completion
 	 */
-	int (*end_io)(struct thread_data *, struct io_u *);
+	int (*end_io)(struct thread_data *, struct io_u **);
 
 	union {
 #ifdef CONFIG_LIBAIO
@@ -166,6 +166,7 @@ enum fio_ioengine_flags {
 	FIO_BARRIER	= 1 << 8,	/* engine supports barriers */
 	FIO_MEMALIGN	= 1 << 9,	/* engine wants aligned memory */
 	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
+	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
 };
 
 /*
diff --git a/verify.c b/verify.c
index 7c99e15..3d7c5de 100644
--- a/verify.c
+++ b/verify.c
@@ -656,19 +656,21 @@ static int verify_io_u_md5(struct verify_header *hdr, struct vcont *vc)
 /*
  * Push IO verification to a separate thread
  */
-int verify_io_u_async(struct thread_data *td, struct io_u *io_u)
+int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 {
-	if (io_u->file)
-		put_file_log(td, io_u->file);
+	struct io_u *io_u = *io_u_ptr;
 
 	pthread_mutex_lock(&td->io_u_lock);
 
+	if (io_u->file)
+		put_file_log(td, io_u->file);
+
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
 		io_u->flags &= ~IO_U_F_IN_CUR_DEPTH;
 	}
 	flist_add_tail(&io_u->verify_list, &td->verify_list);
-	io_u->flags |= IO_U_F_FREE_DEF;
+	*io_u_ptr = NULL;
 	pthread_mutex_unlock(&td->io_u_lock);
 
 	pthread_cond_signal(&td->verify_cond);
@@ -747,15 +749,23 @@ err:
 	return EILSEQ;
 }
 
-int verify_io_u(struct thread_data *td, struct io_u *io_u)
+int verify_io_u(struct thread_data *td, struct io_u **io_u_ptr)
 {
 	struct verify_header *hdr;
+	struct io_u *io_u = *io_u_ptr;
 	unsigned int header_size, hdr_inc, hdr_num = 0;
 	void *p;
 	int ret;
 
 	if (td->o.verify == VERIFY_NULL || io_u->ddir != DDIR_READ)
 		return 0;
+	/*
+	 * If the IO engine is faking IO (like null), then just pretend
+	 * we verified everything.
+	 */
+	if (td->io_ops->flags & FIO_FAKEIO)
+		return 0;
+
 	if (io_u->flags & IO_U_F_TRIMMED) {
 		ret = verify_trimmed_io_u(td, io_u);
 		goto done;
@@ -1188,9 +1198,11 @@ static void *verify_async_thread(void *data)
 
 		while (!flist_empty(&list)) {
 			io_u = flist_first_entry(&list, struct io_u, verify_list);
-			flist_del(&io_u->verify_list);
+			flist_del_init(&io_u->verify_list);
+
+			io_u->flags |= IO_U_F_NO_FILE_PUT;
+			ret = verify_io_u(td, &io_u);
 
-			ret = verify_io_u(td, io_u);
 			put_io_u(td, io_u);
 			if (!ret)
 				continue;
diff --git a/verify.h b/verify.h
index dba7743..bb3fd49 100644
--- a/verify.h
+++ b/verify.h
@@ -76,8 +76,8 @@ struct vhdr_xxhash {
  */
 extern void populate_verify_io_u(struct thread_data *, struct io_u *);
 extern int __must_check get_next_verify(struct thread_data *td, struct io_u *);
-extern int __must_check verify_io_u(struct thread_data *, struct io_u *);
-extern int verify_io_u_async(struct thread_data *, struct io_u *);
+extern int __must_check verify_io_u(struct thread_data *, struct io_u **);
+extern int verify_io_u_async(struct thread_data *, struct io_u **);
 extern void fill_verify_pattern(struct thread_data *td, void *p, unsigned int len, struct io_u *io_u, unsigned long seed, int use_seed);
 extern void fill_buffer_pattern(struct thread_data *td, void *p, unsigned int len);
 extern void fio_verify_init(struct thread_data *td);
