Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33238 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbcHOMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2016 08:00:09 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1bZGYq-0003pT-Vl
	for fio@vger.kernel.org; Mon, 15 Aug 2016 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160815120002.54B602C12E0@kernel.dk>
Date: Mon, 15 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9973b0f961a57c19f885ffca05f86ae6ef85f8c7:

  iolog: silence warning on pointer cast on 32-bit compiles (2016-08-08 11:32:34 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 1651e4310feb3eab7c7c8cf0bd23d159cb410628:

  Only enable atomic io_u flag setting/clearing if we need it (2016-08-14 21:31:16 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Only enable atomic io_u flag setting/clearing if we need it

 backend.c     |  4 ++--
 fio.h         | 20 +++++++++++++++++++-
 io_u.c        | 20 ++++++++++----------
 ioengine.h    | 13 ++++---------
 ioengines.c   |  2 +-
 rate-submit.c |  4 ++--
 verify.c      |  8 ++++----
 7 files changed, 42 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 6bf5d67..c051c13 100644
--- a/backend.c
+++ b/backend.c
@@ -695,7 +695,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					continue;
 				} else if (io_u->ddir == DDIR_TRIM) {
 					io_u->ddir = DDIR_READ;
-					io_u_set(io_u, IO_U_F_TRIMMED);
+					io_u_set(td, io_u, IO_U_F_TRIMMED);
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
@@ -1432,7 +1432,7 @@ static uint64_t do_dry_run(struct thread_data *td)
 		if (IS_ERR_OR_NULL(io_u))
 			break;
 
-		io_u_set(io_u, IO_U_F_FLIGHT);
+		io_u_set(td, io_u, IO_U_F_FLIGHT);
 		io_u->error = 0;
 		io_u->resid = 0;
 		if (ddir_rw(acct_ddir(io_u)))
diff --git a/fio.h b/fio.h
index d929467..7f685ea 100644
--- a/fio.h
+++ b/fio.h
@@ -677,7 +677,7 @@ static inline unsigned int td_min_bs(struct thread_data *td)
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
 }
 
-static inline int td_async_processing(struct thread_data *td)
+static inline bool td_async_processing(struct thread_data *td)
 {
 	return (td->flags & TD_F_NEED_LOCK) != 0;
 }
@@ -704,6 +704,24 @@ static inline void td_io_u_free_notify(struct thread_data *td)
 		pthread_cond_signal(&td->free_cond);
 }
 
+static inline void td_flags_clear(struct thread_data *td, unsigned int *flags,
+				  unsigned int value)
+{
+	if (!td_async_processing(td))
+		*flags &= ~value;
+	else
+		__sync_fetch_and_and(flags, ~value);
+}
+
+static inline void td_flags_set(struct thread_data *td, unsigned int *flags,
+				unsigned int value)
+{
+	if (!td_async_processing(td))
+		*flags |= value;
+	else
+		__sync_fetch_and_or(flags, value);
+}
+
 extern const char *fio_get_arch_string(int);
 extern const char *fio_get_os_string(int);
 
diff --git a/io_u.c b/io_u.c
index c0790b2..34acc56 100644
--- a/io_u.c
+++ b/io_u.c
@@ -409,7 +409,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 				*is_random = 1;
 			} else {
 				*is_random = 0;
-				io_u_set(io_u, IO_U_F_BUSY_OK);
+				io_u_set(td, io_u, IO_U_F_BUSY_OK);
 				ret = get_next_seq_offset(td, f, ddir, &offset);
 				if (ret)
 					ret = get_next_rand_block(td, f, ddir, &b);
@@ -419,7 +419,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 			ret = get_next_seq_offset(td, f, ddir, &offset);
 		}
 	} else {
-		io_u_set(io_u, IO_U_F_BUSY_OK);
+		io_u_set(td, io_u, IO_U_F_BUSY_OK);
 		*is_random = 0;
 
 		if (td->o.rw_seq == RW_SEQ_SEQ) {
@@ -772,7 +772,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 	    td->o.barrier_blocks &&
 	   !(td->io_issues[DDIR_WRITE] % td->o.barrier_blocks) &&
 	     td->io_issues[DDIR_WRITE])
-		io_u_set(io_u, IO_U_F_BARRIER);
+		io_u_set(td, io_u, IO_U_F_BARRIER);
 }
 
 void put_file_log(struct thread_data *td, struct fio_file *f)
@@ -794,7 +794,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 		put_file_log(td, io_u->file);
 
 	io_u->file = NULL;
-	io_u_set(io_u, IO_U_F_FREE);
+	io_u_set(td, io_u, IO_U_F_FREE);
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
@@ -807,7 +807,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	io_u_clear(io_u, IO_U_F_FLIGHT);
+	io_u_clear(td, io_u, IO_U_F_FLIGHT);
 	put_io_u(td, io_u);
 }
 
@@ -823,11 +823,11 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 
 	td_io_u_lock(td);
 
-	io_u_set(__io_u, IO_U_F_FREE);
+	io_u_set(td, __io_u, IO_U_F_FREE);
 	if ((__io_u->flags & IO_U_F_FLIGHT) && ddir_rw(ddir))
 		td->io_issues[ddir]--;
 
-	io_u_clear(__io_u, IO_U_F_FLIGHT);
+	io_u_clear(td, __io_u, IO_U_F_FLIGHT);
 	if (__io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
 		assert(!(td->flags & TD_F_CHILD));
@@ -1457,7 +1457,7 @@ again:
 
 	if (io_u) {
 		assert(io_u->flags & IO_U_F_FREE);
-		io_u_clear(io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
+		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
 				 IO_U_F_VER_LIST);
 
@@ -1465,7 +1465,7 @@ again:
 		io_u->acct_ddir = -1;
 		td->cur_depth++;
 		assert(!(td->flags & TD_F_CHILD));
-		io_u_set(io_u, IO_U_F_IN_CUR_DEPTH);
+		io_u_set(td, io_u, IO_U_F_IN_CUR_DEPTH);
 		io_u->ipo = NULL;
 	} else if (td_async_processing(td)) {
 		/*
@@ -1803,7 +1803,7 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 	dprint_io_u(io_u, "io complete");
 
 	assert(io_u->flags & IO_U_F_FLIGHT);
-	io_u_clear(io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
+	io_u_clear(td, io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
 
 	/*
 	 * Mark IO ok to verify
diff --git a/ioengine.h b/ioengine.h
index ceed329..08e8fab 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -257,14 +257,9 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	return io_u->ddir;
 }
 
-static inline void io_u_clear(struct io_u *io_u, unsigned int flags)
-{
-	__sync_fetch_and_and(&io_u->flags, ~flags);
-}
-
-static inline void io_u_set(struct io_u *io_u, unsigned int flags)
-{
-	__sync_fetch_and_or(&io_u->flags, flags);
-}
+#define io_u_clear(td, io_u, val)	\
+	td_flags_clear((td), &(io_u->flags), (val))
+#define io_u_set(td, io_u, val)		\
+	td_flags_set((td), &(io_u)->flags, (val))
 
 #endif
diff --git a/ioengines.c b/ioengines.c
index a06909e..1c7a93b 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -260,7 +260,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	fio_ro_check(td, io_u);
 
 	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
-	io_u_set(io_u, IO_U_F_FLIGHT);
+	io_u_set(td, io_u, IO_U_F_FLIGHT);
 
 	assert(fio_file_open(io_u->file));
 
diff --git a/rate-submit.c b/rate-submit.c
index 0c31f29..48b7a58 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -19,7 +19,7 @@ static int io_workqueue_fn(struct submit_worker *sw,
 
 	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
 
-	io_u_set(io_u, IO_U_F_NO_FILE_PUT);
+	io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
 
 	td->cur_depth++;
 
@@ -30,7 +30,7 @@ static int io_workqueue_fn(struct submit_worker *sw,
 		ret = io_u_queued_complete(td, 1);
 		if (ret > 0)
 			td->cur_depth -= ret;
-		io_u_clear(io_u, IO_U_F_FLIGHT);
+		io_u_clear(td, io_u, IO_U_F_FLIGHT);
 	} while (1);
 
 	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
diff --git a/verify.c b/verify.c
index 9a96fbb..40cfbab 100644
--- a/verify.c
+++ b/verify.c
@@ -651,7 +651,7 @@ int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
-		io_u_clear(io_u, IO_U_F_IN_CUR_DEPTH);
+		io_u_clear(td, io_u, IO_U_F_IN_CUR_DEPTH);
 	}
 	flist_add_tail(&io_u->verify_list, &td->verify_list);
 	*io_u_ptr = NULL;
@@ -1168,10 +1168,10 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		io_u->buflen = ipo->len;
 		io_u->numberio = ipo->numberio;
 		io_u->file = ipo->file;
-		io_u_set(io_u, IO_U_F_VER_LIST);
+		io_u_set(td, io_u, IO_U_F_VER_LIST);
 
 		if (ipo->flags & IP_F_TRIMMED)
-			io_u_set(io_u, IO_U_F_TRIMMED);
+			io_u_set(td, io_u, IO_U_F_TRIMMED);
 
 		if (!fio_file_open(io_u->file)) {
 			int r = td_io_open_file(td, io_u->file);
@@ -1255,7 +1255,7 @@ static void *verify_async_thread(void *data)
 			io_u = flist_first_entry(&list, struct io_u, verify_list);
 			flist_del_init(&io_u->verify_list);
 
-			io_u_set(io_u, IO_U_F_NO_FILE_PUT);
+			io_u_set(td, io_u, IO_U_F_NO_FILE_PUT);
 			ret = verify_io_u(td, &io_u);
 
 			put_io_u(td, io_u);
