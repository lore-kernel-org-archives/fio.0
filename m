Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35272 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756075AbdC2MAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 29 Mar 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1ctCGo-00063h-Mu
        for fio@vger.kernel.org; Wed, 29 Mar 2017 12:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170329120003.476F32C294A@kernel.dk>
Date: Wed, 29 Mar 2017 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f678f8d2aa7f6972b18e368fe42f7bc48134e66c:

  configure: add a --disable-rdma flag to control rdma deps (2017-03-21 07:20:32 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 618ee94c319c46c670d29c7cf71538ca2ace13b7:

  Separate io_u from ioengine [3/3] - rename ioengine.h to ioengines.h (2017-03-28 15:14:20 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (12):
      Fix return value of make_filename() when no filename_format
      Test malloc result when allocation size is tunable
      Don't malloc more than necessary on extending/prereading file
      HOWTO: Mention niche detail of range format options
      Drop redundant "ignore invalidate option" message from 21c1b29e
      Ignore pre-read for FIO_NOIO td
      Don't proceed with error set when failed to pre-read files/devices
      Ignore pre-read for character devices
      Drop prototype of unused function td_io_sync()
      Separate io_u from ioengine [1/3] - add io_u.h
      Separate io_u from ioengine [2/3] - move io_u functions
      Separate io_u from ioengine [3/3] - rename ioengine.h to ioengines.h

 HOWTO                |  2 ++
 filesetup.c          | 35 +++++++++++++++-----
 fio.h                |  3 +-
 init.c               |  7 ++--
 io_u.c               | 58 +++++++++++++++++++++++++++++++++
 ioengine.h => io_u.h | 86 ++-----------------------------------------------
 ioengines.c          | 58 ---------------------------------
 ioengines.h          | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 iolog.h              |  2 +-
 rate-submit.c        |  2 +-
 10 files changed, 185 insertions(+), 158 deletions(-)
 rename ioengine.h => io_u.h (52%)
 create mode 100644 ioengines.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index cae95b7..80b9e75 100644
--- a/HOWTO
+++ b/HOWTO
@@ -543,6 +543,8 @@ Parameter types
 
 	If the option accepts an upper and lower range, use a colon ':' or
 	minus '-' to separate such values. See :ref:`irange <irange>`.
+	If the lower value specified happens to be larger than the upper value,
+	two values are swapped.
 
 .. _bool:
 
diff --git a/filesetup.c b/filesetup.c
index bcf95bd..612e794 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -159,11 +159,18 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		}
 	}
 
-	b = malloc(td->o.max_bs[DDIR_WRITE]);
-
 	left = f->real_file_size;
+	bs = td->o.max_bs[DDIR_WRITE];
+	if (bs > left)
+		bs = left;
+
+	b = malloc(bs);
+	if (!b) {
+		td_verror(td, errno, "malloc");
+		goto err;
+	}
+
 	while (left && !td->terminate) {
-		bs = td->o.max_bs[DDIR_WRITE];
 		if (bs > left)
 			bs = left;
 
@@ -228,7 +235,11 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 	unsigned int bs;
 	char *b;
 
-	if (td_ioengine_flagged(td, FIO_PIPEIO))
+	if (td_ioengine_flagged(td, FIO_PIPEIO) ||
+	    td_ioengine_flagged(td, FIO_NOIO))
+		return 0;
+
+	if (f->filetype == FIO_TYPE_CHAR)
 		return 0;
 
 	if (!fio_file_open(f)) {
@@ -241,8 +252,17 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 
 	old_runstate = td_bump_runstate(td, TD_PRE_READING);
 
+	left = f->io_size;
 	bs = td->o.max_bs[DDIR_READ];
+	if (bs > left)
+		bs = left;
+
 	b = malloc(bs);
+	if (!b) {
+		td_verror(td, errno, "malloc");
+		ret = 1;
+		goto error;
+	}
 	memset(b, 0, bs);
 
 	if (lseek(f->fd, f->file_offset, SEEK_SET) < 0) {
@@ -252,8 +272,6 @@ static int pre_read_file(struct thread_data *td, struct fio_file *f)
 		goto error;
 	}
 
-	left = f->io_size;
-
 	while (left && !td->terminate) {
 		if (bs > left)
 			bs = left;
@@ -1104,10 +1122,11 @@ int pre_read_files(struct thread_data *td)
 	dprint(FD_FILE, "pre_read files\n");
 
 	for_each_file(td, f, i) {
-		pre_read_file(td, f);
+		if (pre_read_file(td, f))
+			return -1;
 	}
 
-	return 1;
+	return 0;
 }
 
 static int __init_rand_distribution(struct thread_data *td, struct fio_file *f)
diff --git a/fio.h b/fio.h
index 52a9b75..3955a81 100644
--- a/fio.h
+++ b/fio.h
@@ -25,7 +25,7 @@
 #include "debug.h"
 #include "file.h"
 #include "io_ddir.h"
-#include "ioengine.h"
+#include "ioengines.h"
 #include "iolog.h"
 #include "helpers.h"
 #include "options.h"
@@ -39,6 +39,7 @@
 #include "server.h"
 #include "stat.h"
 #include "flow.h"
+#include "io_u.h"
 #include "io_u_queue.h"
 #include "workqueue.h"
 #include "steadystate.h"
diff --git a/init.c b/init.c
index 4a72255..2f9433b 100644
--- a/init.c
+++ b/init.c
@@ -765,11 +765,8 @@ static int fixup_options(struct thread_data *td)
 	}
 
 	if (o->pre_read) {
-		if (o->invalidate_cache) {
-			log_info("fio: ignore invalidate option for %s\n",
-				 o->name);
+		if (o->invalidate_cache)
 			o->invalidate_cache = 0;
-		}
 		if (td_ioengine_flagged(td, FIO_PIPEIO)) {
 			log_info("fio: cannot pre-read files with an IO engine"
 				 " that isn't seekable. Pre-read disabled.\n");
@@ -1121,7 +1118,7 @@ static char *make_filename(char *buf, size_t buf_size,struct thread_options *o,
 
 	if (!o->filename_format || !strlen(o->filename_format)) {
 		sprintf(buf, "%s.%d.%d", jobname, jobnum, filenum);
-		return NULL;
+		return buf;
 	}
 
 	for (f = &fpre_keywords[0]; f->keyword; f++)
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
diff --git a/io_u.h b/io_u.h
new file mode 100644
index 0000000..155344d
--- /dev/null
+++ b/io_u.h
@@ -0,0 +1,179 @@
+#ifndef FIO_IO_U
+#define FIO_IO_U
+
+#include "compiler/compiler.h"
+#include "os/os.h"
+#include "log.h"
+#include "io_ddir.h"
+#include "debug.h"
+#include "file.h"
+#include "workqueue.h"
+
+#ifdef CONFIG_LIBAIO
+#include <libaio.h>
+#endif
+#ifdef CONFIG_GUASI
+#include <guasi.h>
+#endif
+
+enum {
+	IO_U_F_FREE		= 1 << 0,
+	IO_U_F_FLIGHT		= 1 << 1,
+	IO_U_F_NO_FILE_PUT	= 1 << 2,
+	IO_U_F_IN_CUR_DEPTH	= 1 << 3,
+	IO_U_F_BUSY_OK		= 1 << 4,
+	IO_U_F_TRIMMED		= 1 << 5,
+	IO_U_F_BARRIER		= 1 << 6,
+	IO_U_F_VER_LIST		= 1 << 7,
+};
+
+/*
+ * The io unit
+ */
+struct io_u {
+	struct timeval start_time;
+	struct timeval issue_time;
+
+	struct fio_file *file;
+	unsigned int flags;
+	enum fio_ddir ddir;
+
+	/*
+	 * For replay workloads, we may want to account as a different
+	 * IO type than what is being submitted.
+	 */
+	enum fio_ddir acct_ddir;
+
+	/*
+	 * Write generation
+	 */
+	unsigned short numberio;
+
+	/*
+	 * Allocated/set buffer and length
+	 */
+	unsigned long buflen;
+	unsigned long long offset;
+	void *buf;
+
+	/*
+	 * Initial seed for generating the buffer contents
+	 */
+	uint64_t rand_seed;
+
+	/*
+	 * IO engine state, may be different from above when we get
+	 * partial transfers / residual data counts
+	 */
+	void *xfer_buf;
+	unsigned long xfer_buflen;
+
+	/*
+	 * Parameter related to pre-filled buffers and
+	 * their size to handle variable block sizes.
+	 */
+	unsigned long buf_filled_len;
+
+	struct io_piece *ipo;
+
+	unsigned int resid;
+	unsigned int error;
+
+	/*
+	 * io engine private data
+	 */
+	union {
+		unsigned int index;
+		unsigned int seen;
+		void *engine_data;
+	};
+
+	union {
+		struct flist_head verify_list;
+		struct workqueue_work work;
+	};
+
+	/*
+	 * Callback for io completion
+	 */
+	int (*end_io)(struct thread_data *, struct io_u **);
+
+	union {
+#ifdef CONFIG_LIBAIO
+		struct iocb iocb;
+#endif
+#ifdef CONFIG_POSIXAIO
+		os_aiocb_t aiocb;
+#endif
+#ifdef FIO_HAVE_SGIO
+		struct sg_io_hdr hdr;
+#endif
+#ifdef CONFIG_GUASI
+		guasi_req_t greq;
+#endif
+#ifdef CONFIG_SOLARISAIO
+		aio_result_t resultp;
+#endif
+#ifdef FIO_HAVE_BINJECT
+		struct b_user_cmd buc;
+#endif
+#ifdef CONFIG_RDMA
+		struct ibv_mr *mr;
+#endif
+		void *mmap_data;
+	};
+};
+
+/*
+ * io unit handling
+ */
+extern struct io_u *__get_io_u(struct thread_data *);
+extern struct io_u *get_io_u(struct thread_data *);
+extern void put_io_u(struct thread_data *, struct io_u *);
+extern void clear_io_u(struct thread_data *, struct io_u *);
+extern void requeue_io_u(struct thread_data *, struct io_u **);
+extern int __must_check io_u_sync_complete(struct thread_data *, struct io_u *);
+extern int __must_check io_u_queued_complete(struct thread_data *, int);
+extern void io_u_queued(struct thread_data *, struct io_u *);
+extern int io_u_quiesce(struct thread_data *);
+extern void io_u_log_error(struct thread_data *, struct io_u *);
+extern void io_u_mark_depth(struct thread_data *, unsigned int);
+extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned int);
+extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
+void io_u_mark_complete(struct thread_data *, unsigned int);
+void io_u_mark_submit(struct thread_data *, unsigned int);
+bool queue_full(const struct thread_data *);
+
+int do_io_u_sync(const struct thread_data *, struct io_u *);
+int do_io_u_trim(const struct thread_data *, struct io_u *);
+
+#ifdef FIO_INC_DEBUG
+static inline void dprint_io_u(struct io_u *io_u, const char *p)
+{
+	struct fio_file *f = io_u->file;
+
+	dprint(FD_IO, "%s: io_u %p: off=%llu/len=%lu/ddir=%d", p, io_u,
+					(unsigned long long) io_u->offset,
+					io_u->buflen, io_u->ddir);
+	if (f)
+		dprint(FD_IO, "/%s", f->file_name);
+	dprint(FD_IO, "\n");
+}
+#else
+#define dprint_io_u(io_u, p)
+#endif
+
+static inline enum fio_ddir acct_ddir(struct io_u *io_u)
+{
+	if (io_u->acct_ddir != -1)
+		return io_u->acct_ddir;
+
+	return io_u->ddir;
+}
+
+#define io_u_clear(td, io_u, val)	\
+	td_flags_clear((td), &(io_u->flags), (val))
+#define io_u_set(td, io_u, val)		\
+	td_flags_set((td), &(io_u)->flags, (val))
+
+#endif
diff --git a/ioengine.h b/ioengine.h
deleted file mode 100644
index 7249df6..0000000
--- a/ioengine.h
+++ /dev/null
@@ -1,261 +0,0 @@
-#ifndef FIO_IOENGINE_H
-#define FIO_IOENGINE_H
-
-#include "compiler/compiler.h"
-#include "os/os.h"
-#include "log.h"
-#include "io_ddir.h"
-#include "debug.h"
-#include "file.h"
-#include "workqueue.h"
-
-#ifdef CONFIG_LIBAIO
-#include <libaio.h>
-#endif
-#ifdef CONFIG_GUASI
-#include <guasi.h>
-#endif
-
-#define FIO_IOOPS_VERSION	23
-
-enum {
-	IO_U_F_FREE		= 1 << 0,
-	IO_U_F_FLIGHT		= 1 << 1,
-	IO_U_F_NO_FILE_PUT	= 1 << 2,
-	IO_U_F_IN_CUR_DEPTH	= 1 << 3,
-	IO_U_F_BUSY_OK		= 1 << 4,
-	IO_U_F_TRIMMED		= 1 << 5,
-	IO_U_F_BARRIER		= 1 << 6,
-	IO_U_F_VER_LIST		= 1 << 7,
-};
-
-/*
- * The io unit
- */
-struct io_u {
-	struct timeval start_time;
-	struct timeval issue_time;
-
-	struct fio_file *file;
-	unsigned int flags;
-	enum fio_ddir ddir;
-
-	/*
-	 * For replay workloads, we may want to account as a different
-	 * IO type than what is being submitted.
-	 */
-	enum fio_ddir acct_ddir;
-
-	/*
-	 * Write generation
-	 */
-	unsigned short numberio;
-
-	/*
-	 * Allocated/set buffer and length
-	 */
-	unsigned long buflen;
-	unsigned long long offset;
-	void *buf;
-
-	/*
-	 * Initial seed for generating the buffer contents
-	 */
-	uint64_t rand_seed;
-
-	/*
-	 * IO engine state, may be different from above when we get
-	 * partial transfers / residual data counts
-	 */
-	void *xfer_buf;
-	unsigned long xfer_buflen;
-
-	/*
-	 * Parameter related to pre-filled buffers and
-	 * their size to handle variable block sizes.
-	 */
-	unsigned long buf_filled_len;
-
-	struct io_piece *ipo;
-
-	unsigned int resid;
-	unsigned int error;
-
-	/*
-	 * io engine private data
-	 */
-	union {
-		unsigned int index;
-		unsigned int seen;
-		void *engine_data;
-	};
-
-	union {
-		struct flist_head verify_list;
-		struct workqueue_work work;
-	};
-
-	/*
-	 * Callback for io completion
-	 */
-	int (*end_io)(struct thread_data *, struct io_u **);
-
-	union {
-#ifdef CONFIG_LIBAIO
-		struct iocb iocb;
-#endif
-#ifdef CONFIG_POSIXAIO
-		os_aiocb_t aiocb;
-#endif
-#ifdef FIO_HAVE_SGIO
-		struct sg_io_hdr hdr;
-#endif
-#ifdef CONFIG_GUASI
-		guasi_req_t greq;
-#endif
-#ifdef CONFIG_SOLARISAIO
-		aio_result_t resultp;
-#endif
-#ifdef FIO_HAVE_BINJECT
-		struct b_user_cmd buc;
-#endif
-#ifdef CONFIG_RDMA
-		struct ibv_mr *mr;
-#endif
-		void *mmap_data;
-	};
-};
-
-/*
- * io_ops->queue() return values
- */
-enum {
-	FIO_Q_COMPLETED	= 0,		/* completed sync */
-	FIO_Q_QUEUED	= 1,		/* queued, will complete async */
-	FIO_Q_BUSY	= 2,		/* no more room, call ->commit() */
-};
-
-struct ioengine_ops {
-	struct flist_head list;
-	const char *name;
-	int version;
-	int flags;
-	int (*setup)(struct thread_data *);
-	int (*init)(struct thread_data *);
-	int (*prep)(struct thread_data *, struct io_u *);
-	int (*queue)(struct thread_data *, struct io_u *);
-	int (*commit)(struct thread_data *);
-	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
-	struct io_u *(*event)(struct thread_data *, int);
-	char *(*errdetails)(struct io_u *);
-	int (*cancel)(struct thread_data *, struct io_u *);
-	void (*cleanup)(struct thread_data *);
-	int (*open_file)(struct thread_data *, struct fio_file *);
-	int (*close_file)(struct thread_data *, struct fio_file *);
-	int (*invalidate)(struct thread_data *, struct fio_file *);
-	int (*unlink_file)(struct thread_data *, struct fio_file *);
-	int (*get_file_size)(struct thread_data *, struct fio_file *);
-	void (*terminate)(struct thread_data *);
-	int (*iomem_alloc)(struct thread_data *, size_t);
-	void (*iomem_free)(struct thread_data *);
-	int (*io_u_init)(struct thread_data *, struct io_u *);
-	void (*io_u_free)(struct thread_data *, struct io_u *);
-	int option_struct_size;
-	struct fio_option *options;
-};
-
-enum fio_ioengine_flags {
-	FIO_SYNCIO	= 1 << 0,	/* io engine has synchronous ->queue */
-	FIO_RAWIO	= 1 << 1,	/* some sort of direct/raw io */
-	FIO_DISKLESSIO	= 1 << 2,	/* no disk involved */
-	FIO_NOEXTEND	= 1 << 3,	/* engine can't extend file */
-	FIO_NODISKUTIL  = 1 << 4,	/* diskutil can't handle filename */
-	FIO_UNIDIR	= 1 << 5,	/* engine is uni-directional */
-	FIO_NOIO	= 1 << 6,	/* thread does only pseudo IO */
-	FIO_PIPEIO	= 1 << 7,	/* input/output no seekable */
-	FIO_BARRIER	= 1 << 8,	/* engine supports barriers */
-	FIO_MEMALIGN	= 1 << 9,	/* engine wants aligned memory */
-	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
-	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
-};
-
-/*
- * External engine defined symbol to fill in the engine ops structure
- */
-typedef void (*get_ioengine_t)(struct ioengine_ops **);
-
-/*
- * io engine entry points
- */
-extern int __must_check td_io_init(struct thread_data *);
-extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
-extern int __must_check td_io_queue(struct thread_data *, struct io_u *);
-extern int __must_check td_io_sync(struct thread_data *, struct fio_file *);
-extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
-extern int __must_check td_io_commit(struct thread_data *);
-extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
-extern int td_io_close_file(struct thread_data *, struct fio_file *);
-extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
-extern int __must_check td_io_get_file_size(struct thread_data *, struct fio_file *);
-
-extern struct ioengine_ops *load_ioengine(struct thread_data *, const char *);
-extern void register_ioengine(struct ioengine_ops *);
-extern void unregister_ioengine(struct ioengine_ops *);
-extern void free_ioengine(struct thread_data *);
-extern void close_ioengine(struct thread_data *);
-
-extern int fio_show_ioengine_help(const char *engine);
-
-/*
- * io unit handling
- */
-extern struct io_u *__get_io_u(struct thread_data *);
-extern struct io_u *get_io_u(struct thread_data *);
-extern void put_io_u(struct thread_data *, struct io_u *);
-extern void clear_io_u(struct thread_data *, struct io_u *);
-extern void requeue_io_u(struct thread_data *, struct io_u **);
-extern int __must_check io_u_sync_complete(struct thread_data *, struct io_u *);
-extern int __must_check io_u_queued_complete(struct thread_data *, int);
-extern void io_u_queued(struct thread_data *, struct io_u *);
-extern int io_u_quiesce(struct thread_data *);
-extern void io_u_log_error(struct thread_data *, struct io_u *);
-extern void io_u_mark_depth(struct thread_data *, unsigned int);
-extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned int);
-extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
-void io_u_mark_complete(struct thread_data *, unsigned int);
-void io_u_mark_submit(struct thread_data *, unsigned int);
-bool queue_full(const struct thread_data *);
-
-int do_io_u_sync(const struct thread_data *, struct io_u *);
-int do_io_u_trim(const struct thread_data *, struct io_u *);
-
-#ifdef FIO_INC_DEBUG
-static inline void dprint_io_u(struct io_u *io_u, const char *p)
-{
-	struct fio_file *f = io_u->file;
-
-	dprint(FD_IO, "%s: io_u %p: off=%llu/len=%lu/ddir=%d", p, io_u,
-					(unsigned long long) io_u->offset,
-					io_u->buflen, io_u->ddir);
-	if (f)
-		dprint(FD_IO, "/%s", f->file_name);
-	dprint(FD_IO, "\n");
-}
-#else
-#define dprint_io_u(io_u, p)
-#endif
-
-static inline enum fio_ddir acct_ddir(struct io_u *io_u)
-{
-	if (io_u->acct_ddir != -1)
-		return io_u->acct_ddir;
-
-	return io_u->ddir;
-}
-
-#define io_u_clear(td, io_u, val)	\
-	td_flags_clear((td), &(io_u->flags), (val))
-#define io_u_set(td, io_u, val)		\
-	td_flags_set((td), &(io_u)->flags, (val))
-
-#endif
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
diff --git a/ioengines.h b/ioengines.h
new file mode 100644
index 0000000..f24f4df
--- /dev/null
+++ b/ioengines.h
@@ -0,0 +1,90 @@
+#ifndef FIO_IOENGINE_H
+#define FIO_IOENGINE_H
+
+#include "compiler/compiler.h"
+#include "os/os.h"
+#include "file.h"
+#include "io_u.h"
+
+#define FIO_IOOPS_VERSION	23
+
+/*
+ * io_ops->queue() return values
+ */
+enum {
+	FIO_Q_COMPLETED	= 0,		/* completed sync */
+	FIO_Q_QUEUED	= 1,		/* queued, will complete async */
+	FIO_Q_BUSY	= 2,		/* no more room, call ->commit() */
+};
+
+struct ioengine_ops {
+	struct flist_head list;
+	const char *name;
+	int version;
+	int flags;
+	int (*setup)(struct thread_data *);
+	int (*init)(struct thread_data *);
+	int (*prep)(struct thread_data *, struct io_u *);
+	int (*queue)(struct thread_data *, struct io_u *);
+	int (*commit)(struct thread_data *);
+	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
+	struct io_u *(*event)(struct thread_data *, int);
+	char *(*errdetails)(struct io_u *);
+	int (*cancel)(struct thread_data *, struct io_u *);
+	void (*cleanup)(struct thread_data *);
+	int (*open_file)(struct thread_data *, struct fio_file *);
+	int (*close_file)(struct thread_data *, struct fio_file *);
+	int (*invalidate)(struct thread_data *, struct fio_file *);
+	int (*unlink_file)(struct thread_data *, struct fio_file *);
+	int (*get_file_size)(struct thread_data *, struct fio_file *);
+	void (*terminate)(struct thread_data *);
+	int (*iomem_alloc)(struct thread_data *, size_t);
+	void (*iomem_free)(struct thread_data *);
+	int (*io_u_init)(struct thread_data *, struct io_u *);
+	void (*io_u_free)(struct thread_data *, struct io_u *);
+	int option_struct_size;
+	struct fio_option *options;
+};
+
+enum fio_ioengine_flags {
+	FIO_SYNCIO	= 1 << 0,	/* io engine has synchronous ->queue */
+	FIO_RAWIO	= 1 << 1,	/* some sort of direct/raw io */
+	FIO_DISKLESSIO	= 1 << 2,	/* no disk involved */
+	FIO_NOEXTEND	= 1 << 3,	/* engine can't extend file */
+	FIO_NODISKUTIL  = 1 << 4,	/* diskutil can't handle filename */
+	FIO_UNIDIR	= 1 << 5,	/* engine is uni-directional */
+	FIO_NOIO	= 1 << 6,	/* thread does only pseudo IO */
+	FIO_PIPEIO	= 1 << 7,	/* input/output no seekable */
+	FIO_BARRIER	= 1 << 8,	/* engine supports barriers */
+	FIO_MEMALIGN	= 1 << 9,	/* engine wants aligned memory */
+	FIO_BIT_BASED	= 1 << 10,	/* engine uses a bit base (e.g. uses Kbit as opposed to KB) */
+	FIO_FAKEIO	= 1 << 11,	/* engine pretends to do IO */
+};
+
+/*
+ * External engine defined symbol to fill in the engine ops structure
+ */
+typedef void (*get_ioengine_t)(struct ioengine_ops **);
+
+/*
+ * io engine entry points
+ */
+extern int __must_check td_io_init(struct thread_data *);
+extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
+extern int __must_check td_io_queue(struct thread_data *, struct io_u *);
+extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
+extern int __must_check td_io_commit(struct thread_data *);
+extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
+extern int td_io_close_file(struct thread_data *, struct fio_file *);
+extern int td_io_unlink_file(struct thread_data *, struct fio_file *);
+extern int __must_check td_io_get_file_size(struct thread_data *, struct fio_file *);
+
+extern struct ioengine_ops *load_ioengine(struct thread_data *, const char *);
+extern void register_ioengine(struct ioengine_ops *);
+extern void unregister_ioengine(struct ioengine_ops *);
+extern void free_ioengine(struct thread_data *);
+extern void close_ioengine(struct thread_data *);
+
+extern int fio_show_ioengine_help(const char *engine);
+
+#endif
diff --git a/iolog.h b/iolog.h
index 37f27bc..0733ad3 100644
--- a/iolog.h
+++ b/iolog.h
@@ -4,7 +4,7 @@
 #include "lib/rbtree.h"
 #include "lib/ieee754.h"
 #include "flist.h"
-#include "ioengine.h"
+#include "ioengines.h"
 
 /*
  * Use for maintaining statistics
diff --git a/rate-submit.c b/rate-submit.c
index 4738dc4..fdbece6 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -5,7 +5,7 @@
  *
  */
 #include "fio.h"
-#include "ioengine.h"
+#include "ioengines.h"
 #include "lib/getrusage.h"
 #include "rate-submit.h"
 
