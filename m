Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55186 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbeHJO37 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Aug 2018 10:29:59 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fo65d-00058k-Oc
        for fio@vger.kernel.org; Fri, 10 Aug 2018 12:00:21 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180810120001.C20E02C0311@kernel.dk>
Date: Fri, 10 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2ce58465415fc4d900c4dd89b86acbcaa51d9dfb:

  libpmem: fix type print (2018-08-07 08:09:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae48493039f833119126ef979dbe86aee2c05557:

  Merge branch 'realloc-io_u-buffers' of https://github.com/aclamk/fio (2018-08-09 09:31:26 -0600)

----------------------------------------------------------------
Adam Kupczyk (2):
      iolog replay: Treat 'open' on file that is scheduled to close as cancel of 'close' operation.
      iolog replay: Realloc io_u buffers to adapt to operation size.

Jens Axboe (1):
      Merge branch 'realloc-io_u-buffers' of https://github.com/aclamk/fio

Udit agarwal (1):
      xxhash: fix function definition and declaration mismatch

 backend.c    | 115 ++++++++++++++++++++++++++++++++++-------------------------
 crc/xxhash.h |   8 ++---
 filesetup.c  |   6 ++++
 ioengines.c  |  13 ++++---
 iolog.c      |  11 +++++-
 iolog.h      |   1 +
 6 files changed, 95 insertions(+), 59 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 4b4ecde..f6cfbdd 100644
--- a/backend.c
+++ b/backend.c
@@ -1201,19 +1201,10 @@ static void cleanup_io_u(struct thread_data *td)
 static int init_io_u(struct thread_data *td)
 {
 	struct io_u *io_u;
-	unsigned long long max_bs, min_write;
 	int cl_align, i, max_units;
-	int data_xfer = 1, err;
-	char *p;
+	int err;
 
 	max_units = td->o.iodepth;
-	max_bs = td_max_bs(td);
-	min_write = td->o.min_bs[DDIR_WRITE];
-	td->orig_buffer_size = (unsigned long long) max_bs
-					* (unsigned long long) max_units;
-
-	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
-		data_xfer = 0;
 
 	err = 0;
 	err += !io_u_rinit(&td->io_u_requeues, td->o.iodepth);
@@ -1225,6 +1216,70 @@ static int init_io_u(struct thread_data *td)
 		return 1;
 	}
 
+	cl_align = os_cache_line_size();
+
+	for (i = 0; i < max_units; i++) {
+		void *ptr;
+
+		if (td->terminate)
+			return 1;
+
+		ptr = fio_memalign(cl_align, sizeof(*io_u));
+		if (!ptr) {
+			log_err("fio: unable to allocate aligned memory\n");
+			break;
+		}
+
+		io_u = ptr;
+		memset(io_u, 0, sizeof(*io_u));
+		INIT_FLIST_HEAD(&io_u->verify_list);
+		dprint(FD_MEM, "io_u alloc %p, index %u\n", io_u, i);
+
+		io_u->index = i;
+		io_u->flags = IO_U_F_FREE;
+		io_u_qpush(&td->io_u_freelist, io_u);
+
+		/*
+		 * io_u never leaves this stack, used for iteration of all
+		 * io_u buffers.
+		 */
+		io_u_qpush(&td->io_u_all, io_u);
+
+		if (td->io_ops->io_u_init) {
+			int ret = td->io_ops->io_u_init(td, io_u);
+
+			if (ret) {
+				log_err("fio: failed to init engine data: %d\n", ret);
+				return 1;
+			}
+		}
+	}
+
+	init_io_u_buffers(td);
+
+	if (init_file_completion_logging(td, max_units))
+		return 1;
+
+	return 0;
+}
+
+int init_io_u_buffers(struct thread_data *td)
+{
+	struct io_u *io_u;
+	unsigned long long max_bs, min_write;
+	int i, max_units;
+	int data_xfer = 1;
+	char *p;
+
+	max_units = td->o.iodepth;
+	max_bs = td_max_bs(td);
+	min_write = td->o.min_bs[DDIR_WRITE];
+	td->orig_buffer_size = (unsigned long long) max_bs
+					* (unsigned long long) max_units;
+
+	if (td_ioengine_flagged(td, FIO_NOIO) || !(td_read(td) || td_write(td)))
+		data_xfer = 0;
+
 	/*
 	 * if we may later need to do address alignment, then add any
 	 * possible adjustment here so that we don't cause a buffer
@@ -1256,23 +1311,8 @@ static int init_io_u(struct thread_data *td)
 	else
 		p = td->orig_buffer;
 
-	cl_align = os_cache_line_size();
-
 	for (i = 0; i < max_units; i++) {
-		void *ptr;
-
-		if (td->terminate)
-			return 1;
-
-		ptr = fio_memalign(cl_align, sizeof(*io_u));
-		if (!ptr) {
-			log_err("fio: unable to allocate aligned memory\n");
-			break;
-		}
-
-		io_u = ptr;
-		memset(io_u, 0, sizeof(*io_u));
-		INIT_FLIST_HEAD(&io_u->verify_list);
+		io_u = td->io_u_all.io_us[i];
 		dprint(FD_MEM, "io_u alloc %p, index %u\n", io_u, i);
 
 		if (data_xfer) {
@@ -1289,32 +1329,9 @@ static int init_io_u(struct thread_data *td)
 				fill_verify_pattern(td, io_u->buf, max_bs, io_u, 0, 0);
 			}
 		}
-
-		io_u->index = i;
-		io_u->flags = IO_U_F_FREE;
-		io_u_qpush(&td->io_u_freelist, io_u);
-
-		/*
-		 * io_u never leaves this stack, used for iteration of all
-		 * io_u buffers.
-		 */
-		io_u_qpush(&td->io_u_all, io_u);
-
-		if (td->io_ops->io_u_init) {
-			int ret = td->io_ops->io_u_init(td, io_u);
-
-			if (ret) {
-				log_err("fio: failed to init engine data: %d\n", ret);
-				return 1;
-			}
-		}
-
 		p += max_bs;
 	}
 
-	if (init_file_completion_logging(td, max_units))
-		return 1;
-
 	return 0;
 }
 
diff --git a/crc/xxhash.h b/crc/xxhash.h
index 8850d20..934c555 100644
--- a/crc/xxhash.h
+++ b/crc/xxhash.h
@@ -107,9 +107,9 @@ XXH32() :
 // Advanced Hash Functions
 //****************************
 
-void*         XXH32_init   (unsigned int seed);
+void*         XXH32_init   (uint32_t seed);
 XXH_errorcode XXH32_update (void* state, const void* input, int len);
-unsigned int  XXH32_digest (void* state);
+uint32_t XXH32_digest (void* state);
 
 /*
 These functions calculate the xxhash of an input provided in several small packets,
@@ -135,7 +135,7 @@ Memory will be freed by XXH32_digest().
 
 
 int           XXH32_sizeofState(void);
-XXH_errorcode XXH32_resetState(void* state, unsigned int seed);
+XXH_errorcode XXH32_resetState(void* state, uint32_t seed);
 
 #define       XXH32_SIZEOFSTATE 48
 typedef struct { long long ll[(XXH32_SIZEOFSTATE+(sizeof(long long)-1))/sizeof(long long)]; } XXH32_stateSpace_t;
@@ -151,7 +151,7 @@ use the structure XXH32_stateSpace_t, which will ensure that memory space is lar
 */
 
 
-unsigned int XXH32_intermediateDigest (void* state);
+uint32_t XXH32_intermediateDigest (void* state);
 /*
 This function does the same as XXH32_digest(), generating a 32-bit hash,
 but preserve memory context.
diff --git a/filesetup.c b/filesetup.c
index accb67a..94a025e 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1675,6 +1675,11 @@ int put_file(struct thread_data *td, struct fio_file *f)
 	if (--f->references)
 		return 0;
 
+	disk_util_dec(f->du);
+
+	if (td->o.file_lock_mode != FILE_LOCK_NONE)
+		unlock_file_all(td, f);
+
 	if (should_fsync(td) && td->o.fsync_on_close) {
 		f_ret = fsync(f->fd);
 		if (f_ret < 0)
@@ -1688,6 +1693,7 @@ int put_file(struct thread_data *td, struct fio_file *f)
 		ret = f_ret;
 
 	td->nr_open_files--;
+	fio_file_clear_closing(f);
 	fio_file_clear_open(f);
 	assert(f->fd == -1);
 	return ret;
diff --git a/ioengines.c b/ioengines.c
index e5fbcd4..433da60 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -431,6 +431,14 @@ void td_io_commit(struct thread_data *td)
 
 int td_io_open_file(struct thread_data *td, struct fio_file *f)
 {
+	if (fio_file_closing(f)) {
+		/*
+		 * Open translates to undo closing.
+		 */
+		fio_file_clear_closing(f);
+		get_file(f);
+		return 0;
+	}
 	assert(!fio_file_open(f));
 	assert(f->fd == -1);
 	assert(td->io_ops->open_file);
@@ -540,11 +548,6 @@ int td_io_close_file(struct thread_data *td, struct fio_file *f)
 	 */
 	fio_file_set_closing(f);
 
-	disk_util_dec(f->du);
-
-	if (td->o.file_lock_mode != FILE_LOCK_NONE)
-		unlock_file_all(td, f);
-
 	return put_file(td, f);
 }
 
diff --git a/iolog.c b/iolog.c
index bd2a214..0f95c60 100644
--- a/iolog.c
+++ b/iolog.c
@@ -389,6 +389,7 @@ static bool read_iolog2(struct thread_data *td)
 	char *rfname, *fname, *act;
 	char *str, *p;
 	enum fio_ddir rw;
+	bool realloc = false;
 	int64_t items_to_fetch = 0;
 
 	if (td->o.read_iolog_chunked) {
@@ -501,8 +502,10 @@ static bool read_iolog2(struct thread_data *td)
 			ipo_bytes_align(td->o.replay_align, ipo);
 
 			ipo->len = bytes;
-			if (rw != DDIR_INVAL && bytes > td->o.max_bs[rw])
+			if (rw != DDIR_INVAL && bytes > td->o.max_bs[rw]) {
+				realloc = true;
 				td->o.max_bs[rw] = bytes;
+			}
 			ipo->fileno = fileno;
 			ipo->file_action = file_action;
 			td->o.size += bytes;
@@ -539,6 +542,12 @@ static bool read_iolog2(struct thread_data *td)
 			return false;
 		}
 		td->o.td_ddir = TD_DDIR_RW;
+		if (realloc && td->orig_buffer)
+		{
+			io_u_quiesce(td);
+			free_io_mem(td);
+			init_io_u_buffers(td);
+		}
 		return true;
 	}
 
diff --git a/iolog.h b/iolog.h
index 3b8c901..17be908 100644
--- a/iolog.h
+++ b/iolog.h
@@ -244,6 +244,7 @@ extern void write_iolog_close(struct thread_data *);
 extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 extern size_t log_chunk_sizes(struct io_log *);
+extern int init_io_u_buffers(struct thread_data *);
 
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);

