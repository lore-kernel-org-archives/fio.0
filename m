Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:35608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbeHRPHj (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 18 Aug 2018 11:07:39 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fqztr-0006my-It
        for fio@vger.kernel.org; Sat, 18 Aug 2018 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180818120002.93DD92C2FEA@kernel.dk>
Date: Sat, 18 Aug 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9ee669faa39003c2317e5df892314bcfcee069e3:

  configure: avoid pkg-config usage for http engine (2018-08-16 18:58:27 +0200)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c44d2c6e97245bf68a57f9860a1c92c7bc065f82:

  Move steady state unit test to t/ (2018-08-17 19:39:07 -0600)

----------------------------------------------------------------
Ga��tan Bossu (1):
      Add support for DDN's Infinite Memory Engine

Jens Axboe (7):
      Merge branch 'master' of https://github.com/kelleymh/fio
      Merge branch 'ime-support' of https://github.com/DDNStorage/fio-public into ddn-ime
      engines/ime: various code and style cleanups
      Sync man page with fio for IME
      Merge branch 'ddn-ime'
      Merge branch 'master' of https://github.com/kelleymh/fio
      Move steady state unit test to t/

Michael Kelley (3):
      Reimplement axmap_next_free() to prevent distribution skew
      Add tests specifically for axmap_next_free()
      Remove unused code in lib/axmap.c

Tomohiro Kusumi (1):
      http: fix compile-time warnings

 HOWTO                                  |  16 +
 Makefile                               |   3 +
 configure                              |  29 ++
 engines/http.c                         |   4 +-
 engines/ime.c                          | 899 +++++++++++++++++++++++++++++++++
 examples/ime.fio                       |  51 ++
 fio.1                                  |  14 +
 lib/axmap.c                            | 189 ++++---
 lib/axmap.h                            |   1 -
 options.c                              |  11 +
 t/axmap.c                              | 162 +++++-
 {unit_tests => t}/steadystate_tests.py |   0
 12 files changed, 1272 insertions(+), 107 deletions(-)
 create mode 100644 engines/ime.c
 create mode 100644 examples/ime.fio
 rename {unit_tests => t}/steadystate_tests.py (100%)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 743144f..ff7aa09 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1901,6 +1901,22 @@ I/O engine
 			mounted with DAX on a persistent memory device through the PMDK
 			libpmem library.
 
+		**ime_psync**
+			Synchronous read and write using DDN's Infinite Memory Engine (IME).
+			This engine is very basic and issues calls to IME whenever an IO is
+			queued.
+
+		**ime_psyncv**
+			Synchronous read and write using DDN's Infinite Memory Engine (IME).
+			This engine uses iovecs and will try to stack as much IOs as possible
+			(if the IOs are "contiguous" and the IO depth is not exceeded)
+			before issuing a call to IME.
+
+		**ime_aio**
+			Asynchronous read and write using DDN's Infinite Memory Engine (IME).
+			This engine will try to stack as much IOs as possible by creating
+			requests for IME. FIO will then decide when to commit these requests.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index b981b45..e8e15fe 100644
--- a/Makefile
+++ b/Makefile
@@ -145,6 +145,9 @@ endif
 ifdef CONFIG_LIBPMEM
   SOURCE += engines/libpmem.c
 endif
+ifdef CONFIG_IME
+  SOURCE += engines/ime.c
+endif
 
 ifeq ($(CONFIG_TARGET_OS), Linux)
   SOURCE += diskutil.c fifo.c blktrace.c cgroup.c trim.c engines/sg.c \
diff --git a/configure b/configure
index a03f7fa..fb8b243 100755
--- a/configure
+++ b/configure
@@ -202,6 +202,8 @@ for opt do
   ;;
   --disable-native) disable_native="yes"
   ;;
+  --with-ime=*) ime_path="$optarg"
+  ;;
   --help)
     show_help="yes"
     ;;
@@ -233,6 +235,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-optimizations Don't enable compiler optimizations"
   echo "--enable-cuda           Enable GPUDirect RDMA support"
   echo "--disable-native        Don't build for native host"
+  echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   exit $exit_val
 fi
 
@@ -1963,6 +1966,29 @@ print_config "PMDK dev-dax engine" "$devdax"
 print_config "PMDK libpmem engine" "$pmem"
 
 ##########################################
+# Check whether we support DDN's IME
+if test "$libime" != "yes" ; then
+  libime="no"
+fi
+cat > $TMPC << EOF
+#include <ime_native.h>
+int main(int argc, char **argv)
+{
+  int rc;
+  ime_native_init();
+  rc = ime_native_finalize();
+  return 0;
+}
+EOF
+if compile_prog "-I${ime_path}/include" "-L${ime_path}/lib -lim_client" "libime"; then
+  libime="yes"
+  CFLAGS="-I${ime_path}/include $CFLAGS"
+  LDFLAGS="-Wl,-rpath ${ime_path}/lib -L${ime_path}/lib $LDFLAGS"
+  LIBS="-lim_client $LIBS"
+fi
+print_config "DDN's Infinite Memory Engine" "$libime"
+
+##########################################
 # Check if we have lex/yacc available
 yacc="no"
 yacc_is_bison="no"
@@ -2455,6 +2481,9 @@ fi
 if test "$pmem" = "yes" ; then
   output_sym "CONFIG_LIBPMEM"
 fi
+if test "$libime" = "yes" ; then
+  output_sym "CONFIG_IME"
+fi
 if test "$arith" = "yes" ; then
   output_sym "CONFIG_ARITHMETIC"
   if test "$yacc_is_bison" = "yes" ; then
diff --git a/engines/http.c b/engines/http.c
index cb66ebe..93fcd0d 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -546,7 +546,7 @@ static enum fio_q_status fio_http_queue(struct thread_data *td,
 	} else if (io_u->ddir == DDIR_TRIM) {
 		curl_easy_setopt(http->curl, CURLOPT_HTTPGET, 1L);
 		curl_easy_setopt(http->curl, CURLOPT_CUSTOMREQUEST, "DELETE");
-		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, 0);
+		curl_easy_setopt(http->curl, CURLOPT_INFILESIZE_LARGE, (curl_off_t)0);
 		curl_easy_setopt(http->curl, CURLOPT_READDATA, NULL);
 		curl_easy_setopt(http->curl, CURLOPT_WRITEDATA, NULL);
 		res = curl_easy_perform(http->curl);
@@ -608,7 +608,7 @@ static int fio_http_setup(struct thread_data *td)
 	}
 	curl_easy_setopt(http->curl, CURLOPT_READFUNCTION, _http_read);
 	curl_easy_setopt(http->curl, CURLOPT_WRITEFUNCTION, _http_write);
-	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, _http_seek);
+	curl_easy_setopt(http->curl, CURLOPT_SEEKFUNCTION, &_http_seek);
 	if (o->user && o->pass) {
 		curl_easy_setopt(http->curl, CURLOPT_USERNAME, o->user);
 		curl_easy_setopt(http->curl, CURLOPT_PASSWORD, o->pass);
diff --git a/engines/ime.c b/engines/ime.c
new file mode 100644
index 0000000..4298402
--- /dev/null
+++ b/engines/ime.c
@@ -0,0 +1,899 @@
+/*
+ * FIO engines for DDN's Infinite Memory Engine.
+ * This file defines 3 engines: ime_psync, ime_psyncv, and ime_aio
+ *
+ * Copyright (C) 2018      DataDirect Networks. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License,
+ * version 2 as published by the Free Software Foundation..
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Some details about the new engines are given below:
+ *
+ *
+ * ime_psync:
+ * Most basic engine that issues calls to ime_native whenever an IO is queued.
+ *
+ * ime_psyncv:
+ * This engine tries to queue the IOs (by creating iovecs) if asked by FIO (via
+ * iodepth_batch). It refuses to queue when the iovecs can't be appended, and
+ * waits for FIO to issue a commit. After a call to commit and get_events, new
+ * IOs can be queued.
+ *
+ * ime_aio:
+ * This engine tries to queue the IOs (by creating iovecs) if asked by FIO (via
+ * iodepth_batch). When the iovecs can't be appended to the current request, a
+ * new request for IME is created. These requests will be issued to IME when
+ * commit is called. Contrary to ime_psyncv, there can be several requests at
+ * once. We don't need to wait for a request to terminate before creating a new
+ * one.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <errno.h>
+#include <linux/limits.h>
+#include <ime_native.h>
+
+#include "../fio.h"
+
+
+/**************************************************************
+ *              Types and constants definitions
+ *
+ **************************************************************/
+
+/* define constants for async IOs */
+#define FIO_IME_IN_PROGRESS -1
+#define FIO_IME_REQ_ERROR   -2
+
+/* This flag is used when some jobs were created using threads. In that
+   case, IME can't be finalized in the engine-specific cleanup function,
+   because other threads might still use IME. Instead, IME is finalized
+   in the destructor (see fio_ime_unregister), only when the flag
+   fio_ime_is_initialized is true (which means at least one thread has
+   initialized IME). */
+static bool fio_ime_is_initialized = false;
+
+struct imesio_req {
+	int 			fd;		/* File descriptor */
+	enum fio_ddir	ddir;	/* Type of IO (read or write) */
+	off_t			offset;	/* File offset */
+};
+struct imeaio_req {
+	struct ime_aiocb 	iocb;			/* IME aio request */
+	ssize_t      		status;			/* Status of the IME request */
+	enum fio_ddir		ddir;			/* Type of IO (read or write) */
+	pthread_cond_t		cond_endio;		/* Condition var to notify FIO */
+	pthread_mutex_t		status_mutex;	/* Mutex for cond_endio */
+};
+
+/* This structure will be used for 2 engines: ime_psyncv and ime_aio */
+struct ime_data {
+	union {
+		struct imeaio_req 	*aioreqs;	/* array of aio requests */
+		struct imesio_req	*sioreq;	/* pointer to the only syncio request */
+	};
+	struct iovec 	*iovecs;		/* array of queued iovecs */
+	struct io_u 	**io_us;		/* array of queued io_u pointers */
+	struct io_u 	**event_io_us;	/* array of the events retieved afer get_events*/
+	unsigned int 	queued;			/* iovecs/io_us in the queue */
+	unsigned int 	events;			/* number of committed iovecs/io_us */
+
+	/* variables used to implement a "ring" queue */
+	unsigned int depth;			/* max entries in the queue */
+	unsigned int head;			/* index used to append */
+	unsigned int tail;			/* index used to pop */
+	unsigned int cur_commit;	/* index of the first uncommitted req */
+
+	/* offset used by the last iovec (used to check if the iovecs can be appended)*/
+	unsigned long long	last_offset;
+
+	/* The variables below are used for aio only */
+	struct imeaio_req	*last_req; /* last request awaiting committing */
+};
+
+
+/**************************************************************
+ *         Private functions for queueing/unqueueing
+ *
+ **************************************************************/
+
+static void fio_ime_queue_incr (struct ime_data *ime_d)
+{
+	ime_d->head = (ime_d->head + 1) % ime_d->depth;
+	ime_d->queued++;
+}
+
+static void fio_ime_queue_red (struct ime_data *ime_d)
+{
+	ime_d->tail = (ime_d->tail + 1) % ime_d->depth;
+	ime_d->queued--;
+	ime_d->events--;
+}
+
+static void fio_ime_queue_commit (struct ime_data *ime_d, int iovcnt)
+{
+	ime_d->cur_commit = (ime_d->cur_commit + iovcnt) % ime_d->depth;
+	ime_d->events += iovcnt;
+}
+
+static void fio_ime_queue_reset (struct ime_data *ime_d)
+{
+	ime_d->head = 0;
+	ime_d->tail = 0;
+	ime_d->cur_commit = 0;
+	ime_d->queued = 0;
+	ime_d->events = 0;
+}
+
+/**************************************************************
+ *                   General IME functions
+ *             (needed for both sync and async IOs)
+ **************************************************************/
+
+static char *fio_set_ime_filename(char* filename)
+{
+	static __thread char ime_filename[PATH_MAX];
+	int ret;
+
+	ret = snprintf(ime_filename, PATH_MAX, "%s%s", DEFAULT_IME_FILE_PREFIX, filename);
+	if (ret < PATH_MAX)
+		return ime_filename;
+
+	return NULL;
+}
+
+static int fio_ime_get_file_size(struct thread_data *td, struct fio_file *f)
+{
+	struct stat buf;
+	int ret;
+	char *ime_filename;
+
+	dprint(FD_FILE, "get file size %s\n", f->file_name);
+
+	ime_filename = fio_set_ime_filename(f->file_name);
+	if (ime_filename == NULL)
+		return 1;
+	ret = ime_native_stat(ime_filename, &buf);
+	if (ret == -1) {
+		td_verror(td, errno, "fstat");
+		return 1;
+	}
+
+	f->real_file_size = buf.st_size;
+	return 0;
+}
+
+/* This functions mimics the generic_file_open function, but issues
+   IME native calls instead of POSIX calls. */
+static int fio_ime_open_file(struct thread_data *td, struct fio_file *f)
+{
+	int flags = 0;
+	int ret;
+	uint64_t desired_fs;
+	char *ime_filename;
+
+	dprint(FD_FILE, "fd open %s\n", f->file_name);
+
+	if (td_trim(td)) {
+		td_verror(td, EINVAL, "IME does not support TRIM operation");
+		return 1;
+	}
+
+	if (td->o.oatomic) {
+		td_verror(td, EINVAL, "IME does not support atomic IO");
+		return 1;
+	}
+	if (td->o.odirect)
+		flags |= O_DIRECT;
+	if (td->o.sync_io)
+		flags |= O_SYNC;
+	if (td->o.create_on_open && td->o.allow_create)
+		flags |= O_CREAT;
+
+	if (td_write(td)) {
+		if (!read_only)
+			flags |= O_RDWR;
+
+		if (td->o.allow_create)
+			flags |= O_CREAT;
+	} else if (td_read(td)) {
+		flags |= O_RDONLY;
+	} else {
+		/* We should never go here. */
+		td_verror(td, EINVAL, "Unsopported open mode");
+		return 1;
+	}
+
+	ime_filename = fio_set_ime_filename(f->file_name);
+	if (ime_filename == NULL)
+		return 1;
+	f->fd = ime_native_open(ime_filename, flags, 0600);
+	if (f->fd == -1) {
+		char buf[FIO_VERROR_SIZE];
+		int __e = errno;
+
+		snprintf(buf, sizeof(buf), "open(%s)", f->file_name);
+		td_verror(td, __e, buf);
+		return 1;
+	}
+
+	/* Now we need to make sure the real file size is sufficient for FIO
+	   to do its things. This is normally done before the file open function
+	   is called, but because FIO would use POSIX calls, we need to do it
+	   ourselves */
+	ret = fio_ime_get_file_size(td, f);
+	if (ret < 0) {
+		ime_native_close(f->fd);
+		td_verror(td, errno, "ime_get_file_size");
+		return 1;
+	}
+
+	desired_fs = f->io_size + f->file_offset;
+	if (td_write(td)) {
+		dprint(FD_FILE, "Laying out file %s%s\n",
+			DEFAULT_IME_FILE_PREFIX, f->file_name);
+		if (!td->o.create_on_open &&
+				f->real_file_size < desired_fs &&
+				ime_native_ftruncate(f->fd, desired_fs) < 0) {
+			ime_native_close(f->fd);
+			td_verror(td, errno, "ime_native_ftruncate");
+			return 1;
+		}
+		if (f->real_file_size < desired_fs)
+			f->real_file_size = desired_fs;
+	} else if (td_read(td) && f->real_file_size < desired_fs) {
+		ime_native_close(f->fd);
+		log_err("error: can't read %lu bytes from file with "
+						"%lu bytes\n", desired_fs, f->real_file_size);
+		return 1;
+	}
+
+	return 0;
+}
+
+static int fio_ime_close_file(struct thread_data fio_unused *td, struct fio_file *f)
+{
+	int ret = 0;
+
+	dprint(FD_FILE, "fd close %s\n", f->file_name);
+
+	if (ime_native_close(f->fd) < 0)
+		ret = errno;
+
+	f->fd = -1;
+	return ret;
+}
+
+static int fio_ime_unlink_file(struct thread_data *td, struct fio_file *f)
+{
+	char *ime_filename = fio_set_ime_filename(f->file_name);
+	int ret;
+
+	if (ime_filename == NULL)
+		return 1;
+
+	ret = unlink(ime_filename);
+	return ret < 0 ? errno : 0;
+}
+
+static struct io_u *fio_ime_event(struct thread_data *td, int event)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+
+	return ime_d->event_io_us[event];
+}
+
+/* Setup file used to replace get_file_sizes when settin up the file.
+   Instead we will set real_file_sie to 0 for each file. This way we
+   can avoid calling ime_native_init before the forks are created. */
+static int fio_ime_setup(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	for_each_file(td, f, i) {
+		dprint(FD_FILE, "setup: set file size to 0 for %p/%d/%s\n",
+			f, i, f->file_name);
+		f->real_file_size = 0;
+	}
+
+	return 0;
+}
+
+static int fio_ime_engine_init(struct thread_data *td)
+{
+	struct fio_file *f;
+	unsigned int i;
+
+	dprint(FD_IO, "ime engine init\n");
+	if (fio_ime_is_initialized && !td->o.use_thread) {
+		log_err("Warning: something might go wrong. Not all threads/forks were"
+				" created before the FIO jobs were initialized.\n");
+	}
+
+	ime_native_init();
+	fio_ime_is_initialized = true;
+
+	/* We have to temporarily set real_file_size so that
+	   FIO can initialize properly. It will be corrected
+	   on file open. */
+	for_each_file(td, f, i)
+		f->real_file_size = f->io_size + f->file_offset;
+
+	return 0;
+}
+
+static void fio_ime_engine_finalize(struct thread_data *td)
+{
+	/* Only finalize IME when using forks */
+	if (!td->o.use_thread) {
+		if (ime_native_finalize() < 0)
+			log_err("error in ime_native_finalize\n");
+		fio_ime_is_initialized = false;
+	}
+}
+
+
+/**************************************************************
+ *             Private functions for blocking IOs
+ *                     (without iovecs)
+ **************************************************************/
+
+/* Notice: this function comes from the sync engine */
+/* It is used by the commit function to return a proper code and fill
+   some attributes in the io_u used for the IO. */
+static int fio_ime_psync_end(struct thread_data *td, struct io_u *io_u, ssize_t ret)
+{
+	if (ret != (ssize_t) io_u->xfer_buflen) {
+		if (ret >= 0) {
+			io_u->resid = io_u->xfer_buflen - ret;
+			io_u->error = 0;
+			return FIO_Q_COMPLETED;
+		} else
+			io_u->error = errno;
+	}
+
+	if (io_u->error) {
+		io_u_log_error(td, io_u);
+		td_verror(td, io_u->error, "xfer");
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static enum fio_q_status fio_ime_psync_queue(struct thread_data *td,
+					   struct io_u *io_u)
+{
+	struct fio_file *f = io_u->file;
+	ssize_t ret;
+
+	fio_ro_check(td, io_u);
+
+	if (io_u->ddir == DDIR_READ)
+		ret = ime_native_pread(f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+	else if (io_u->ddir == DDIR_WRITE)
+		ret = ime_native_pwrite(f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
+	else if (io_u->ddir == DDIR_SYNC)
+		ret = ime_native_fsync(f->fd);
+	else {
+		ret = io_u->xfer_buflen;
+		io_u->error = EINVAL;
+	}
+
+	return fio_ime_psync_end(td, io_u, ret);
+}
+
+
+/**************************************************************
+ *             Private functions for blocking IOs
+ *                       (with iovecs)
+ **************************************************************/
+
+static bool fio_ime_psyncv_can_queue(struct ime_data *ime_d, struct io_u *io_u)
+{
+	/* We can only queue if:
+	  - There are no queued iovecs
+	  - Or if there is at least one:
+		 - There must be no event waiting for retrieval
+		 - The offsets must be contiguous
+		 - The ddir and fd must be the same */
+	return (ime_d->queued == 0 || (
+			ime_d->events == 0 &&
+			ime_d->last_offset == io_u->offset &&
+			ime_d->sioreq->ddir == io_u->ddir &&
+			ime_d->sioreq->fd == io_u->file->fd));
+}
+
+/* Before using this function, we should have already
+   ensured that the queue is not full */
+static void fio_ime_psyncv_enqueue(struct ime_data *ime_d, struct io_u *io_u)
+{
+	struct imesio_req *ioreq = ime_d->sioreq;
+	struct iovec *iov = &ime_d->iovecs[ime_d->head];
+
+	iov->iov_base = io_u->xfer_buf;
+	iov->iov_len = io_u->xfer_buflen;
+
+	if (ime_d->queued == 0) {
+		ioreq->offset = io_u->offset;
+		ioreq->ddir = io_u->ddir;
+		ioreq->fd = io_u->file->fd;
+	}
+
+	ime_d->io_us[ime_d->head] = io_u;
+	ime_d->last_offset = io_u->offset + io_u->xfer_buflen;
+	fio_ime_queue_incr(ime_d);
+}
+
+/* Tries to queue an IO. It will fail if the IO can't be appended to the
+   current request or if the current request has been committed but not
+   yet retrieved by get_events. */
+static enum fio_q_status fio_ime_psyncv_queue(struct thread_data *td,
+	struct io_u *io_u)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+
+	fio_ro_check(td, io_u);
+
+	if (ime_d->queued == ime_d->depth)
+		return FIO_Q_BUSY;
+
+	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		if (!fio_ime_psyncv_can_queue(ime_d, io_u))
+			return FIO_Q_BUSY;
+
+		dprint(FD_IO, "queue: ddir=%d at %u commit=%u queued=%u events=%u\n",
+			io_u->ddir, ime_d->head, ime_d->cur_commit,
+			ime_d->queued, ime_d->events);
+		fio_ime_psyncv_enqueue(ime_d, io_u);
+		return FIO_Q_QUEUED;
+	} else if (io_u->ddir == DDIR_SYNC) {
+		if (ime_native_fsync(io_u->file->fd) < 0) {
+			io_u->error = errno;
+			td_verror(td, io_u->error, "fsync");
+		}
+		return FIO_Q_COMPLETED;
+	} else {
+		io_u->error = EINVAL;
+		td_verror(td, io_u->error, "wrong ddir");
+		return FIO_Q_COMPLETED;
+	}
+}
+
+/* Notice: this function comes from the sync engine */
+/* It is used by the commit function to return a proper code and fill
+   some attributes in the io_us appended to the current request. */
+static int fio_ime_psyncv_end(struct thread_data *td, ssize_t bytes)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct io_u *io_u;
+	unsigned int i;
+	int err = errno;
+
+	for (i = 0; i < ime_d->queued; i++) {
+		io_u = ime_d->io_us[i];
+
+		if (bytes == -1)
+			io_u->error = err;
+		else {
+			unsigned int this_io;
+
+			this_io = bytes;
+			if (this_io > io_u->xfer_buflen)
+				this_io = io_u->xfer_buflen;
+
+			io_u->resid = io_u->xfer_buflen - this_io;
+			io_u->error = 0;
+			bytes -= this_io;
+		}
+	}
+
+	if (bytes == -1) {
+		td_verror(td, err, "xfer psyncv");
+		return -err;
+	}
+
+	return 0;
+}
+
+/* Commits the current request by calling ime_native (with one or several
+   iovecs). After this commit, the corresponding events (one per iovec)
+   can be retrieved by get_events. */
+static int fio_ime_psyncv_commit(struct thread_data *td)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct imesio_req *ioreq;
+	int ret = 0;
+
+	/* Exit if there are no (new) events to commit
+	   or if the previous committed event haven't been retrieved */
+	if (!ime_d->queued || ime_d->events)
+		return 0;
+
+	ioreq = ime_d->sioreq;
+	ime_d->events = ime_d->queued;
+	if (ioreq->ddir == DDIR_READ)
+		ret = ime_native_preadv(ioreq->fd, ime_d->iovecs, ime_d->queued, ioreq->offset);
+	else
+		ret = ime_native_pwritev(ioreq->fd, ime_d->iovecs, ime_d->queued, ioreq->offset);
+
+	dprint(FD_IO, "committed %d iovecs\n", ime_d->queued);
+
+	return fio_ime_psyncv_end(td, ret);
+}
+
+static int fio_ime_psyncv_getevents(struct thread_data *td, unsigned int min,
+				unsigned int max, const struct timespec *t)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct io_u *io_u;
+	int events = 0;
+	unsigned int count;
+
+	if (ime_d->events) {
+		for (count = 0; count < ime_d->events; count++) {
+			io_u = ime_d->io_us[count];
+			ime_d->event_io_us[events] = io_u;
+			events++;
+		}
+		fio_ime_queue_reset(ime_d);
+	}
+
+	dprint(FD_IO, "getevents(%u,%u) ret=%d queued=%u events=%u\n",
+		min, max, events, ime_d->queued, ime_d->events);
+	return events;
+}
+
+static int fio_ime_psyncv_init(struct thread_data *td)
+{
+	struct ime_data *ime_d;
+
+	if (fio_ime_engine_init(td) < 0)
+		return 1;
+
+	ime_d = calloc(1, sizeof(*ime_d));
+
+	ime_d->sioreq = malloc(sizeof(struct imesio_req));
+	ime_d->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
+	ime_d->io_us = malloc(2 * td->o.iodepth * sizeof(struct io_u *));
+	ime_d->event_io_us = ime_d->io_us + td->o.iodepth;
+
+	ime_d->depth = td->o.iodepth;
+
+	td->io_ops_data = ime_d;
+	return 0;
+}
+
+static void fio_ime_psyncv_clean(struct thread_data *td)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+
+	if (ime_d) {
+		free(ime_d->sioreq);
+		free(ime_d->iovecs);
+		free(ime_d->io_us);
+		free(ime_d);
+		td->io_ops_data = NULL;
+	}
+
+	fio_ime_engine_finalize(td);
+}
+
+
+/**************************************************************
+ *           Private functions for non-blocking IOs
+ *
+ **************************************************************/
+
+void fio_ime_aio_complete_cb  (struct ime_aiocb *aiocb, int err,
+							   ssize_t bytes)
+{
+	struct imeaio_req *ioreq = (struct imeaio_req *) aiocb->user_context;
+
+	pthread_mutex_lock(&ioreq->status_mutex);
+	ioreq->status = err == 0 ? bytes : FIO_IME_REQ_ERROR;
+	pthread_mutex_unlock(&ioreq->status_mutex);
+
+	pthread_cond_signal(&ioreq->cond_endio);
+}
+
+static bool fio_ime_aio_can_queue (struct ime_data *ime_d, struct io_u *io_u)
+{
+	/* So far we can queue in any case. */
+	return true;
+}
+static bool fio_ime_aio_can_append (struct ime_data *ime_d, struct io_u *io_u)
+{
+	/* We can only append if:
+		- The iovecs will be contiguous in the array
+		- There is already a queued iovec
+		- The offsets are contiguous
+		- The ddir and fs are the same */
+	return (ime_d->head != 0 &&
+			ime_d->queued - ime_d->events > 0 &&
+			ime_d->last_offset == io_u->offset &&
+			ime_d->last_req->ddir == io_u->ddir &&
+			ime_d->last_req->iocb.fd == io_u->file->fd);
+}
+
+/* Before using this function, we should have already
+   ensured that the queue is not full */
+static void fio_ime_aio_enqueue(struct ime_data *ime_d, struct io_u *io_u)
+{
+	struct imeaio_req *ioreq = &ime_d->aioreqs[ime_d->head];
+	struct ime_aiocb *iocb = &ioreq->iocb;
+	struct iovec *iov = &ime_d->iovecs[ime_d->head];
+
+	iov->iov_base = io_u->xfer_buf;
+	iov->iov_len = io_u->xfer_buflen;
+
+	if (fio_ime_aio_can_append(ime_d, io_u))
+		ime_d->last_req->iocb.iovcnt++;
+	else {
+		ioreq->status = FIO_IME_IN_PROGRESS;
+		ioreq->ddir = io_u->ddir;
+		ime_d->last_req = ioreq;
+
+		iocb->complete_cb = &fio_ime_aio_complete_cb;
+		iocb->fd = io_u->file->fd;
+		iocb->file_offset = io_u->offset;
+		iocb->iov = iov;
+		iocb->iovcnt = 1;
+		iocb->flags = 0;
+		iocb->user_context = (intptr_t) ioreq;
+	}
+
+	ime_d->io_us[ime_d->head] = io_u;
+	ime_d->last_offset = io_u->offset + io_u->xfer_buflen;
+	fio_ime_queue_incr(ime_d);
+}
+
+/* Tries to queue an IO. It will create a new request if the IO can't be
+   appended to the current request. It will fail if the queue can't contain
+   any more io_u/iovec. In this case, commit and then get_events need to be
+   called. */
+static enum fio_q_status fio_ime_aio_queue(struct thread_data *td,
+		struct io_u *io_u)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+
+	fio_ro_check(td, io_u);
+
+	dprint(FD_IO, "queue: ddir=%d at %u commit=%u queued=%u events=%u\n",
+		io_u->ddir, ime_d->head, ime_d->cur_commit,
+		ime_d->queued, ime_d->events);
+
+	if (ime_d->queued == ime_d->depth)
+		return FIO_Q_BUSY;
+
+	if (io_u->ddir == DDIR_READ || io_u->ddir == DDIR_WRITE) {
+		if (!fio_ime_aio_can_queue(ime_d, io_u))
+			return FIO_Q_BUSY;
+
+		fio_ime_aio_enqueue(ime_d, io_u);
+		return FIO_Q_QUEUED;
+	} else if (io_u->ddir == DDIR_SYNC) {
+		if (ime_native_fsync(io_u->file->fd) < 0) {
+			io_u->error = errno;
+			td_verror(td, io_u->error, "fsync");
+		}
+		return FIO_Q_COMPLETED;
+	} else {
+		io_u->error = EINVAL;
+		td_verror(td, io_u->error, "wrong ddir");
+		return FIO_Q_COMPLETED;
+	}
+}
+
+static int fio_ime_aio_commit(struct thread_data *td)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct imeaio_req *ioreq;
+	int ret = 0;
+
+	/* Loop while there are events to commit */
+	while (ime_d->queued - ime_d->events) {
+		ioreq = &ime_d->aioreqs[ime_d->cur_commit];
+		if (ioreq->ddir == DDIR_READ)
+			ret = ime_native_aio_read(&ioreq->iocb);
+		else
+			ret = ime_native_aio_write(&ioreq->iocb);
+
+		fio_ime_queue_commit(ime_d, ioreq->iocb.iovcnt);
+
+		/* fio needs a negative error code */
+		if (ret < 0) {
+			ioreq->status = FIO_IME_REQ_ERROR;
+			return -errno;
+		}
+
+		io_u_mark_submit(td, ioreq->iocb.iovcnt);
+		dprint(FD_IO, "committed %d iovecs commit=%u queued=%u events=%u\n",
+			ioreq->iocb.iovcnt, ime_d->cur_commit,
+			ime_d->queued, ime_d->events);
+	}
+
+	return 0;
+}
+
+static int fio_ime_aio_getevents(struct thread_data *td, unsigned int min,
+				unsigned int max, const struct timespec *t)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct imeaio_req *ioreq;
+	struct io_u *io_u;
+	int events = 0;
+	unsigned int count;
+	ssize_t bytes;
+
+	while (ime_d->events) {
+		ioreq = &ime_d->aioreqs[ime_d->tail];
+
+		/* Break if we already got events, and if we will
+		   exceed max if we append the next events */
+		if (events && events + ioreq->iocb.iovcnt > max)
+			break;
+
+		if (ioreq->status != FIO_IME_IN_PROGRESS) {
+
+			bytes = ioreq->status;
+			for (count = 0; count < ioreq->iocb.iovcnt; count++) {
+				io_u = ime_d->io_us[ime_d->tail];
+				ime_d->event_io_us[events] = io_u;
+				events++;
+				fio_ime_queue_red(ime_d);
+
+				if (ioreq->status == FIO_IME_REQ_ERROR)
+					io_u->error = EIO;
+				else {
+					io_u->resid = bytes > io_u->xfer_buflen ?
+									0 : io_u->xfer_buflen - bytes;
+					io_u->error = 0;
+					bytes -= io_u->xfer_buflen - io_u->resid;
+				}
+			}
+		} else {
+			pthread_mutex_lock(&ioreq->status_mutex);
+			while (ioreq->status == FIO_IME_IN_PROGRESS)
+				pthread_cond_wait(&ioreq->cond_endio, &ioreq->status_mutex);
+			pthread_mutex_unlock(&ioreq->status_mutex);
+		}
+
+	}
+
+	dprint(FD_IO, "getevents(%u,%u) ret=%d queued=%u events=%u\n", min, max,
+		events, ime_d->queued, ime_d->events);
+	return events;
+}
+
+static int fio_ime_aio_init(struct thread_data *td)
+{
+	struct ime_data *ime_d;
+	struct imeaio_req *ioreq;
+	unsigned int i;
+
+	if (fio_ime_engine_init(td) < 0)
+		return 1;
+
+	ime_d = calloc(1, sizeof(*ime_d));
+
+	ime_d->aioreqs = malloc(td->o.iodepth * sizeof(struct imeaio_req));
+	ime_d->iovecs = malloc(td->o.iodepth * sizeof(struct iovec));
+	ime_d->io_us = malloc(2 * td->o.iodepth * sizeof(struct io_u *));
+	ime_d->event_io_us = ime_d->io_us + td->o.iodepth;
+
+	ime_d->depth = td->o.iodepth;
+	for (i = 0; i < ime_d->depth; i++) {
+		ioreq = &ime_d->aioreqs[i];
+		pthread_cond_init(&ioreq->cond_endio, NULL);
+		pthread_mutex_init(&ioreq->status_mutex, NULL);
+	}
+
+	td->io_ops_data = ime_d;
+	return 0;
+}
+
+static void fio_ime_aio_clean(struct thread_data *td)
+{
+	struct ime_data *ime_d = td->io_ops_data;
+	struct imeaio_req *ioreq;
+	unsigned int i;
+
+	if (ime_d) {
+		for (i = 0; i < ime_d->depth; i++) {
+			ioreq = &ime_d->aioreqs[i];
+			pthread_cond_destroy(&ioreq->cond_endio);
+			pthread_mutex_destroy(&ioreq->status_mutex);
+		}
+		free(ime_d->aioreqs);
+		free(ime_d->iovecs);
+		free(ime_d->io_us);
+		free(ime_d);
+		td->io_ops_data = NULL;
+	}
+
+	fio_ime_engine_finalize(td);
+}
+
+
+/**************************************************************
+ *                   IO engines definitions
+ *
+ **************************************************************/
+
+/* The FIO_DISKLESSIO flag used for these engines is necessary to prevent
+   FIO from using POSIX calls. See fio_ime_open_file for more details. */
+
+static struct ioengine_ops ioengine_prw = {
+	.name		= "ime_psync",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= fio_ime_setup,
+	.init		= fio_ime_engine_init,
+	.cleanup	= fio_ime_engine_finalize,
+	.queue		= fio_ime_psync_queue,
+	.open_file	= fio_ime_open_file,
+	.close_file	= fio_ime_close_file,
+	.get_file_size	= fio_ime_get_file_size,
+	.unlink_file  	= fio_ime_unlink_file,
+	.flags	    	= FIO_SYNCIO | FIO_DISKLESSIO,
+};
+
+static struct ioengine_ops ioengine_pvrw = {
+	.name		= "ime_psyncv",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= fio_ime_setup,
+	.init		= fio_ime_psyncv_init,
+	.cleanup	= fio_ime_psyncv_clean,
+	.queue		= fio_ime_psyncv_queue,
+	.commit		= fio_ime_psyncv_commit,
+	.getevents	= fio_ime_psyncv_getevents,
+	.event		= fio_ime_event,
+	.open_file	= fio_ime_open_file,
+	.close_file	= fio_ime_close_file,
+	.get_file_size	= fio_ime_get_file_size,
+	.unlink_file  	= fio_ime_unlink_file,
+	.flags	    	= FIO_SYNCIO | FIO_DISKLESSIO,
+};
+
+static struct ioengine_ops ioengine_aio = {
+	.name		= "ime_aio",
+	.version	= FIO_IOOPS_VERSION,
+	.setup		= fio_ime_setup,
+	.init		= fio_ime_aio_init,
+	.cleanup	= fio_ime_aio_clean,
+	.queue		= fio_ime_aio_queue,
+	.commit		= fio_ime_aio_commit,
+	.getevents	= fio_ime_aio_getevents,
+	.event		= fio_ime_event,
+	.open_file	= fio_ime_open_file,
+	.close_file	= fio_ime_close_file,
+	.get_file_size	= fio_ime_get_file_size,
+	.unlink_file  	= fio_ime_unlink_file,
+	.flags       	= FIO_DISKLESSIO,
+};
+
+static void fio_init fio_ime_register(void)
+{
+	register_ioengine(&ioengine_prw);
+	register_ioengine(&ioengine_pvrw);
+	register_ioengine(&ioengine_aio);
+}
+
+static void fio_exit fio_ime_unregister(void)
+{
+	unregister_ioengine(&ioengine_prw);
+	unregister_ioengine(&ioengine_pvrw);
+	unregister_ioengine(&ioengine_aio);
+
+	if (fio_ime_is_initialized && ime_native_finalize() < 0)
+		log_err("Warning: IME did not finalize properly\n");
+}
diff --git a/examples/ime.fio b/examples/ime.fio
new file mode 100644
index 0000000..e97fd1d
--- /dev/null
+++ b/examples/ime.fio
@@ -0,0 +1,51 @@
+# This jobfile performs basic write+read operations using
+# DDN's Infinite Memory Engine.
+
+[global]
+
+# Use as much jobs as possible to maximize performance
+numjobs=8
+
+# The filename should be uniform so that "read" jobs can read what
+# the "write" jobs have written.
+filename_format=fio-test-ime.$jobnum.$filenum
+
+size=25g
+bs=128k
+
+# These settings are useful for the asynchronous ime_aio engine:
+# by setting the io depth to twice the size of a "batch", we can
+# queue IOs while other IOs are "in-flight".
+iodepth=32
+iodepth_batch=16
+iodepth_batch_complete=16
+
+[write-psync]
+stonewall
+rw=write
+ioengine=ime_psync
+
+[read-psync]
+stonewall
+rw=read
+ioengine=ime_psync
+
+[write-psyncv]
+stonewall
+rw=write
+ioengine=ime_psyncv
+
+[read-psyncv]
+stonewall
+rw=read
+ioengine=ime_psyncv
+
+[write-aio]
+stonewall
+rw=write
+ioengine=ime_aio
+
+[read-aio]
+stonewall
+rw=read
+ioengine=ime_aio
\ No newline at end of file
diff --git a/fio.1 b/fio.1
index 73a0422..cb4351f 100644
--- a/fio.1
+++ b/fio.1
@@ -1673,6 +1673,20 @@ done other than creating the file.
 Read and write using mmap I/O to a file on a filesystem
 mounted with DAX on a persistent memory device through the PMDK
 libpmem library.
+.TP
+.B ime_psync
+Synchronous read and write using DDN's Infinite Memory Engine (IME). This
+engine is very basic and issues calls to IME whenever an IO is queued.
+.TP
+.B ime_psyncv
+Synchronous read and write using DDN's Infinite Memory Engine (IME). This
+engine uses iovecs and will try to stack as much IOs as possible (if the IOs
+are "contiguous" and the IO depth is not exceeded) before issuing a call to IME.
+.TP
+.B ime_aio
+Asynchronous read and write using DDN's Infinite Memory Engine (IME). This
+engine will try to stack as much IOs as possible by creating requests for IME.
+FIO will then decide when to commit these requests.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
diff --git a/lib/axmap.c b/lib/axmap.c
index 454af0b..923aae4 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -35,8 +35,6 @@
 #define BLOCKS_PER_UNIT		(1U << UNIT_SHIFT)
 #define BLOCKS_PER_UNIT_MASK	(BLOCKS_PER_UNIT - 1)
 
-#define firstfree_valid(b)	((b)->first_free != (uint64_t) -1)
-
 static const unsigned long bit_masks[] = {
 	0x0000000000000000, 0x0000000000000001, 0x0000000000000003, 0x0000000000000007,
 	0x000000000000000f, 0x000000000000001f, 0x000000000000003f, 0x000000000000007f,
@@ -68,7 +66,6 @@ struct axmap_level {
 struct axmap {
 	unsigned int nr_levels;
 	struct axmap_level *levels;
-	uint64_t first_free;
 	uint64_t nr_bits;
 };
 
@@ -89,8 +86,6 @@ void axmap_reset(struct axmap *axmap)
 
 		memset(al->map, 0, al->map_size * sizeof(unsigned long));
 	}
-
-	axmap->first_free = 0;
 }
 
 void axmap_free(struct axmap *axmap)
@@ -192,24 +187,6 @@ static bool axmap_handler_topdown(struct axmap *axmap, uint64_t bit_nr,
 	return false;
 }
 
-static bool axmap_clear_fn(struct axmap_level *al, unsigned long offset,
-			   unsigned int bit, void *unused)
-{
-	if (!(al->map[offset] & (1UL << bit)))
-		return true;
-
-	al->map[offset] &= ~(1UL << bit);
-	return false;
-}
-
-void axmap_clear(struct axmap *axmap, uint64_t bit_nr)
-{
-	axmap_handler(axmap, bit_nr, axmap_clear_fn, NULL);
-
-	if (bit_nr < axmap->first_free)
-		axmap->first_free = bit_nr;
-}
-
 struct axmap_set_data {
 	unsigned int nr_bits;
 	unsigned int set_bits;
@@ -262,10 +239,6 @@ static void __axmap_set(struct axmap *axmap, uint64_t bit_nr,
 {
 	unsigned int set_bits, nr_bits = data->nr_bits;
 
-	if (axmap->first_free >= bit_nr &&
-	    axmap->first_free < bit_nr + data->nr_bits)
-		axmap->first_free = -1ULL;
-
 	if (bit_nr > axmap->nr_bits)
 		return;
 	else if (bit_nr + nr_bits > axmap->nr_bits)
@@ -336,99 +309,119 @@ bool axmap_isset(struct axmap *axmap, uint64_t bit_nr)
 	return false;
 }
 
-static uint64_t axmap_find_first_free(struct axmap *axmap, unsigned int level,
-				       uint64_t index)
+/*
+ * Find the first free bit that is at least as large as bit_nr.  Return
+ * -1 if no free bit is found before the end of the map.
+ */
+static uint64_t axmap_find_first_free(struct axmap *axmap, uint64_t bit_nr)
 {
-	uint64_t ret = -1ULL;
-	unsigned long j;
 	int i;
+	unsigned long temp;
+	unsigned int bit;
+	uint64_t offset, base_index, index;
+	struct axmap_level *al;
 
-	/*
-	 * Start at the bottom, then converge towards first free bit at the top
-	 */
-	for (i = level; i >= 0; i--) {
-		struct axmap_level *al = &axmap->levels[i];
-
-		if (index >= al->map_size)
-			goto err;
-
-		for (j = index; j < al->map_size; j++) {
-			if (al->map[j] == -1UL)
-				continue;
+	index = 0;
+	for (i = axmap->nr_levels - 1; i >= 0; i--) {
+		al = &axmap->levels[i];
 
-			/*
-			 * First free bit here is our index into the first
-			 * free bit at the next higher level
-			 */
-			ret = index = (j << UNIT_SHIFT) + ffz(al->map[j]);
-			break;
+		/* Shift previously calculated index for next level */
+		index <<= UNIT_SHIFT;
+
+		/*
+		 * Start from an index that's at least as large as the
+		 * originally passed in bit number.
+		 */
+		base_index = bit_nr >> (UNIT_SHIFT * i);
+		if (index < base_index)
+			index = base_index;
+
+		/* Get the offset and bit for this level */
+		offset = index >> UNIT_SHIFT;
+		bit = index & BLOCKS_PER_UNIT_MASK;
+
+		/*
+		 * If the previous level had unused bits in its last
+		 * word, the offset could be bigger than the map at
+		 * this level. That means no free bits exist before the
+		 * end of the map, so return -1.
+		 */
+		if (offset >= al->map_size)
+			return -1ULL;
+
+		/* Check the first word starting with the specific bit */
+		temp = ~bit_masks[bit] & ~al->map[offset];
+		if (temp)
+			goto found;
+
+		/*
+		 * No free bit in the first word, so iterate
+		 * looking for a word with one or more free bits.
+		 */
+		for (offset++; offset < al->map_size; offset++) {
+			temp = ~al->map[offset];
+			if (temp)
+				goto found;
 		}
-	}
-
-	if (ret < axmap->nr_bits)
-		return ret;
-
-err:
-	return (uint64_t) -1ULL;
-}
-
-static uint64_t axmap_first_free(struct axmap *axmap)
-{
-	if (!firstfree_valid(axmap))
-		axmap->first_free = axmap_find_first_free(axmap, axmap->nr_levels - 1, 0);
-
-	return axmap->first_free;
-}
-
-struct axmap_next_free_data {
-	unsigned int level;
-	unsigned long offset;
-	uint64_t bit;
-};
 
-static bool axmap_next_free_fn(struct axmap_level *al, unsigned long offset,
-			       unsigned int bit, void *__data)
-{
-	struct axmap_next_free_data *data = __data;
-	uint64_t mask = ~bit_masks[(data->bit + 1) & BLOCKS_PER_UNIT_MASK];
-
-	if (!(mask & ~al->map[offset]))
-		return false;
+		/* Did not find a free bit */
+		return -1ULL;
 
-	if (al->map[offset] != -1UL) {
-		data->level = al->level;
-		data->offset = offset;
-		return true;
+found:
+		/* Compute the index of the free bit just found */
+		index = (offset << UNIT_SHIFT) + ffz(~temp);
 	}
 
-	data->bit = (data->bit + BLOCKS_PER_UNIT - 1) / BLOCKS_PER_UNIT;
-	return false;
+	/* If found an unused bit in the last word of level 0, return -1 */
+	if (index >= axmap->nr_bits)
+		return -1ULL;
+
+	return index;
 }
 
 /*
  * 'bit_nr' is already set. Find the next free bit after this one.
+ * Return -1 if no free bits found.
  */
 uint64_t axmap_next_free(struct axmap *axmap, uint64_t bit_nr)
 {
-	struct axmap_next_free_data data = { .level = -1U, .bit = bit_nr, };
 	uint64_t ret;
+	uint64_t next_bit = bit_nr + 1;
+	unsigned long temp;
+	uint64_t offset;
+	unsigned int bit;
 
-	if (firstfree_valid(axmap) && bit_nr < axmap->first_free)
-		return axmap->first_free;
+	if (bit_nr >= axmap->nr_bits)
+		return -1ULL;
 
-	if (!axmap_handler(axmap, bit_nr, axmap_next_free_fn, &data))
-		return axmap_first_free(axmap);
+	/* If at the end of the map, wrap-around */
+	if (next_bit == axmap->nr_bits)
+		next_bit = 0;
 
-	assert(data.level != -1U);
+	offset = next_bit >> UNIT_SHIFT;
+	bit = next_bit & BLOCKS_PER_UNIT_MASK;
 
 	/*
-	 * In the rare case that the map is unaligned, we might end up
-	 * finding an offset that's beyond the valid end. For that case,
-	 * find the first free one, the map is practically full.
+	 * As an optimization, do a quick check for a free bit
+	 * in the current word at level 0. If not found, do
+	 * a topdown search.
 	 */
-	ret = axmap_find_first_free(axmap, data.level, data.offset);
-	if (ret != -1ULL)
-		return ret;
+	temp = ~bit_masks[bit] & ~axmap->levels[0].map[offset];
+	if (temp) {
+		ret = (offset << UNIT_SHIFT) + ffz(~temp);
+
+		/* Might have found an unused bit at level 0 */
+		if (ret >= axmap->nr_bits)
+			ret = -1ULL;
+	} else
+		ret = axmap_find_first_free(axmap, next_bit);
 
-	return axmap_first_free(axmap);
+	/*
+	 * If there are no free bits starting at next_bit and going
+	 * to the end of the map, wrap around by searching again
+	 * starting at bit 0.
+	 */
+	if (ret == -1ULL && next_bit != 0)
+		ret = axmap_find_first_free(axmap, 0);
+	return ret;
 }
diff --git a/lib/axmap.h b/lib/axmap.h
index a7a6f94..55349d8 100644
--- a/lib/axmap.h
+++ b/lib/axmap.h
@@ -8,7 +8,6 @@ struct axmap;
 struct axmap *axmap_new(unsigned long nr_bits);
 void axmap_free(struct axmap *bm);
 
-void axmap_clear(struct axmap *axmap, uint64_t bit_nr);
 void axmap_set(struct axmap *axmap, uint64_t bit_nr);
 unsigned int axmap_set_nr(struct axmap *axmap, uint64_t bit_nr, unsigned int nr_bits);
 bool axmap_isset(struct axmap *axmap, uint64_t bit_nr);
diff --git a/options.c b/options.c
index 9ee1ba3..1c35acc 100644
--- a/options.c
+++ b/options.c
@@ -1845,6 +1845,17 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 
 #endif
+#ifdef CONFIG_IME
+			  { .ival = "ime_psync",
+			    .help = "DDN's IME synchronous IO engine",
+			  },
+			  { .ival = "ime_psyncv",
+			    .help = "DDN's IME synchronous IO engine using iovecs",
+			  },
+			  { .ival = "ime_aio",
+			    .help = "DDN's IME asynchronous IO engine",
+			  },
+#endif
 #ifdef CONFIG_LINUX_DEVDAX
 			  { .ival = "dev-dax",
 			    .help = "DAX Device based IO engine",
diff --git a/t/axmap.c b/t/axmap.c
index 1512737..1752439 100644
--- a/t/axmap.c
+++ b/t/axmap.c
@@ -9,8 +9,6 @@ static int test_regular(size_t size, int seed)
 {
 	struct fio_lfsr lfsr;
 	struct axmap *map;
-	size_t osize;
-	uint64_t ff;
 	int err;
 
 	printf("Using %llu entries...", (unsigned long long) size);
@@ -18,7 +16,6 @@ static int test_regular(size_t size, int seed)
 
 	lfsr_init(&lfsr, size, seed, seed & 0xF);
 	map = axmap_new(size);
-	osize = size;
 	err = 0;
 
 	while (size--) {
@@ -45,11 +42,154 @@ static int test_regular(size_t size, int seed)
 	if (err)
 		return err;
 
-	ff = axmap_next_free(map, osize);
-	if (ff != (uint64_t) -1ULL) {
-		printf("axmap_next_free broken: got %llu\n", (unsigned long long) ff);
+	printf("pass!\n");
+	axmap_free(map);
+	return 0;
+}
+
+static int check_next_free(struct axmap *map, uint64_t start, uint64_t expected)
+{
+
+	uint64_t ff;
+
+	ff = axmap_next_free(map, start);
+	if (ff != expected) {
+		printf("axmap_next_free broken: Expected %llu, got %llu\n",
+				(unsigned long long)expected, (unsigned long long) ff);
 		return 1;
 	}
+	return 0;
+}
+
+static int test_next_free(size_t size, int seed)
+{
+	struct fio_lfsr lfsr;
+	struct axmap *map;
+	size_t osize;
+	uint64_t ff, lastfree;
+	int err, i;
+
+	printf("Test next_free %llu entries...", (unsigned long long) size);
+	fflush(stdout);
+
+	map = axmap_new(size);
+	err = 0;
+
+
+	/* Empty map.  Next free after 0 should be 1. */
+	if (check_next_free(map, 0, 1))
+		err = 1;
+
+	/* Empty map.  Next free after 63 should be 64. */
+	if (check_next_free(map, 63, 64))
+		err = 1;
+
+	/* Empty map.  Next free after size - 2 should be size - 1 */
+	if (check_next_free(map, size - 2, size - 1))
+		err = 1;
+
+	/* Empty map.  Next free after size - 1 should be 0 */
+	if (check_next_free(map, size - 1, 0))
+		err = 1;
+
+	/* Empty map.  Next free after 63 should be 64. */
+	if (check_next_free(map, 63, 64))
+		err = 1;
+
+
+	/* Bit 63 set.  Next free after 62 should be 64. */
+	axmap_set(map, 63);
+	if (check_next_free(map, 62, 64))
+		err = 1;
+
+	/* Last bit set.  Next free after size - 2 should be 0. */
+	axmap_set(map, size - 1);
+	if (check_next_free(map, size - 2, 0))
+		err = 1;
+
+	/* Last bit set.  Next free after size - 1 should be 0. */
+	if (check_next_free(map, size - 1, 0))
+		err = 1;
+	
+	/* Last 64 bits set.  Next free after size - 66 or size - 65 should be 0. */
+	for (i=size - 65; i < size; i++)
+		axmap_set(map, i);
+	if (check_next_free(map, size - 66, 0))
+		err = 1;
+	if (check_next_free(map, size - 65, 0))
+		err = 1;
+	
+	/* Last 64 bits set.  Next free after size - 67 should be size - 66. */
+	if (check_next_free(map, size - 67, size - 66))
+		err = 1;
+
+	axmap_free(map);
+	
+	/* Start with a fresh map and mostly fill it up */
+	lfsr_init(&lfsr, size, seed, seed & 0xF);
+	map = axmap_new(size);
+	osize = size;
+
+	/* Leave 1 entry free */
+	size--;
+	while (size--) {
+		uint64_t val;
+
+		if (lfsr_next(&lfsr, &val)) {
+			printf("lfsr: short loop\n");
+			err = 1;
+			break;
+		}
+		if (axmap_isset(map, val)) {
+			printf("bit already set\n");
+			err = 1;
+			break;
+		}
+		axmap_set(map, val);
+		if (!axmap_isset(map, val)) {
+			printf("bit not set\n");
+			err = 1;
+			break;
+		}
+	}
+
+	/* Get last free bit */
+	lastfree = axmap_next_free(map, 0);
+	if (lastfree == -1ULL) {
+		printf("axmap_next_free broken: Couldn't find last free bit\n");
+		err = 1;
+	}
+
+	/* Start with last free bit and test wrap-around */
+	ff = axmap_next_free(map, lastfree);
+	if (ff != lastfree) {
+		printf("axmap_next_free broken: wrap-around test #1 failed\n");
+		err = 1;
+	}
+
+	/* Start with last bit and test wrap-around */
+	ff = axmap_next_free(map, osize - 1);
+	if (ff != lastfree) {
+		printf("axmap_next_free broken: wrap-around test #2 failed\n");
+		err = 1;
+	}
+
+	/* Set last free bit */
+	axmap_set(map, lastfree);
+	ff = axmap_next_free(map, 0);
+	if (ff != -1ULL) {
+		printf("axmap_next_free broken: Expected -1 from full map\n");
+		err = 1;
+	}
+
+	ff = axmap_next_free(map, osize);
+	if (ff != -1ULL) {
+		printf("axmap_next_free broken: Expected -1 from out of bounds request\n");
+		err = 1;
+	}
+
+	if (err)
+		return err;
 
 	printf("pass!\n");
 	axmap_free(map);
@@ -269,6 +409,16 @@ int main(int argc, char *argv[])
 		return 3;
 	if (test_overlap())
 		return 4;
+	if (test_next_free(size, seed))
+		return 5;
+
+	/* Test 3 levels, all full:  64*64*64 */
+	if (test_next_free(64*64*64, seed))
+		return 6;
+
+	/* Test 4 levels, with 2 inner levels not full */
+	if (test_next_free(((((64*64)-63)*64)-63)*64*12, seed))
+		return 7;
 
 	return 0;
 }
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
new file mode 100755
index 0000000..50254dc
--- /dev/null
+++ b/t/steadystate_tests.py
@@ -0,0 +1,226 @@
+#!/usr/bin/python2.7
+# Note: this script is python2 and python 3 compatible.
+#
+# steadystate_tests.py
+#
+# Test option parsing and functonality for fio's steady state detection feature.
+#
+# steadystate_tests.py --read file-for-read-testing --write file-for-write-testing ./fio
+#
+# REQUIREMENTS
+# Python 2.6+
+# SciPy
+#
+# KNOWN ISSUES
+# only option parsing and read tests are carried out
+# On Windows this script works under Cygwin but not from cmd.exe
+# On Windows I encounter frequent fio problems generating JSON output (nothing to decode)
+# min runtime:
+# if ss attained: min runtime = ss_dur + ss_ramp
+# if not attained: runtime = timeout
+
+from __future__ import absolute_import
+from __future__ import print_function
+import os
+import sys
+import json
+import uuid
+import pprint
+import argparse
+import subprocess
+from scipy import stats
+from six.moves import range
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('fio',
+                        help='path to fio executable')
+    parser.add_argument('--read',
+                        help='target for read testing')
+    parser.add_argument('--write',
+                        help='target for write testing')
+    args = parser.parse_args()
+
+    return args
+
+
+def check(data, iops, slope, pct, limit, dur, criterion):
+    measurement = 'iops' if iops else 'bw'
+    data = data[measurement]
+    mean = sum(data) / len(data)
+    if slope:
+        x = list(range(len(data)))
+        m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
+        m = abs(m)
+        if pct:
+            target = m / mean * 100
+            criterion = criterion[:-1]
+        else:
+            target = m
+    else:
+        maxdev = 0
+        for x in data:
+            maxdev = max(abs(mean-x), maxdev)
+        if pct:
+            target = maxdev / mean * 100
+            criterion = criterion[:-1]
+        else:
+            target = maxdev
+
+    criterion = float(criterion)
+    return (abs(target - criterion) / criterion < 0.005), target < limit, mean, target
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    pp = pprint.PrettyPrinter(indent=4)
+
+#
+# test option parsing
+#
+    parsing = [ { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10", "--ss_ramp=5"],
+                  'output': "set steady state IOPS threshold to 10.000000" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 10.000000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:.1%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 0.100000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:10%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 10.000000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:.1%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 0.100000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:12", "--ss_ramp=5"],
+                  'output': "set steady state BW threshold to 12" },
+              ]
+    for test in parsing:
+        output = subprocess.check_output([args.fio] + test['args'])
+        if test['output'] in output.decode():
+            print("PASSED '{0}' found with arguments {1}".format(test['output'], test['args']))
+        else:
+            print("FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args']))
+
+#
+# test some read workloads
+#
+# if ss active and attained,
+#   check that runtime is less than job time
+#   check criteria
+#   how to check ramp time?
+#
+# if ss inactive
+#   check that runtime is what was specified
+#
+    reads = [ {'s': True, 'timeout': 100, 'numjobs': 1, 'ss_dur': 5, 'ss_ramp': 3, 'iops': True, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+              {'s': False, 'timeout': 20, 'numjobs': 2},
+              {'s': True, 'timeout': 100, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 5, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+              {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+            ]
+
+    if args.read == None:
+        if os.name == 'posix':
+            args.read = '/dev/zero'
+            extra = [ "--size=134217728" ]  # 128 MiB
+        else:
+            print("ERROR: file for read testing must be specified on non-posix systems")
+            sys.exit(1)
+    else:
+        extra = []
+
+    jobnum = 0
+    for job in reads:
+
+        tf = uuid.uuid4().hex
+        parameters = [ "--name=job{0}".format(jobnum) ]
+        parameters.extend(extra)
+        parameters.extend([ "--thread",
+                            "--output-format=json",
+                            "--output={0}".format(tf),
+                            "--filename={0}".format(args.read),
+                            "--rw=randrw",
+                            "--rwmixread=100",
+                            "--stonewall",
+                            "--group_reporting",
+                            "--numjobs={0}".format(job['numjobs']),
+                            "--time_based",
+                            "--runtime={0}".format(job['timeout']) ])
+        if job['s']:
+           if job['iops']:
+               ss = 'iops'
+           else:
+               ss = 'bw'
+           if job['slope']:
+               ss += "_slope"
+           ss += ":" + str(job['ss_limit'])
+           if job['pct']:
+               ss += '%'
+           parameters.extend([ '--ss_dur={0}'.format(job['ss_dur']),
+                               '--ss={0}'.format(ss),
+                               '--ss_ramp={0}'.format(job['ss_ramp']) ])
+
+        output = subprocess.call([args.fio] + parameters)
+        with open(tf, 'r') as source:
+            jsondata = json.loads(source.read())
+        os.remove(tf)
+
+        for jsonjob in jsondata['jobs']:
+            line = "job {0}".format(jsonjob['job options']['name'])
+            if job['s']:
+                if jsonjob['steadystate']['attained'] == 1:
+                    # check runtime >= ss_dur + ss_ramp, check criterion, check criterion < limit
+                    mintime = (job['ss_dur'] + job['ss_ramp']) * 1000
+                    actual = jsonjob['read']['runtime']
+                    if mintime > actual:
+                        line = 'FAILED ' + line + ' ss attained, runtime {0} < ss_dur {1} + ss_ramp {2}'.format(actual, job['ss_dur'], job['ss_ramp'])
+                    else:
+                        line = line + ' ss attained, runtime {0} > ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
+                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
+                            iops=job['iops'],
+                            slope=job['slope'],
+                            pct=job['pct'],
+                            limit=job['ss_limit'],
+                            dur=job['ss_dur'],
+                            criterion=jsonjob['steadystate']['criterion'])
+                        if not objsame:
+                            line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                        else:
+                            if met:
+                                line = 'PASSED ' + line + ' target {0} < limit {1}'.format(target, job['ss_limit'])
+                            else:
+                                line = 'FAILED ' + line + ' target {0} < limit {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                else:
+                    # check runtime, confirm criterion calculation, and confirm that criterion was not met
+                    expected = job['timeout'] * 1000
+                    actual = jsonjob['read']['runtime']
+                    if abs(expected - actual) > 10:
+                        line = 'FAILED ' + line + ' ss not attained, expected runtime {0} != actual runtime {1}'.format(expected, actual)
+                    else:
+                        line = line + ' ss not attained, runtime {0} != ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
+                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
+                            iops=job['iops'],
+                            slope=job['slope'],
+                            pct=job['pct'],
+                            limit=job['ss_limit'],
+                            dur=job['ss_dur'],
+                            criterion=jsonjob['steadystate']['criterion'])
+                        if not objsame:
+                            if actual > (job['ss_dur'] + job['ss_ramp'])*1000:
+                                line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                            else:
+                                line = 'PASSED ' + line + ' fio criterion {0} == 0.0 since ss_dur + ss_ramp has not elapsed '.format(jsonjob['steadystate']['criterion'])
+                        else:
+                            if met:
+                                line = 'FAILED ' + line + ' target {0} < threshold {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                            else:
+                                line = 'PASSED ' + line + ' criterion {0} > threshold {1}'.format(target, job['ss_limit'])
+            else:
+                expected = job['timeout'] * 1000
+                actual = jsonjob['read']['runtime']
+                if abs(expected - actual) < 10:
+                    result = 'PASSED '
+                else:
+                    result = 'FAILED '
+                line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
+            print(line)
+            if 'steadystate' in jsonjob:
+                pp.pprint(jsonjob['steadystate'])
+        jobnum += 1
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
deleted file mode 100755
index 50254dc..0000000
--- a/unit_tests/steadystate_tests.py
+++ /dev/null
@@ -1,226 +0,0 @@
-#!/usr/bin/python2.7
-# Note: this script is python2 and python 3 compatible.
-#
-# steadystate_tests.py
-#
-# Test option parsing and functonality for fio's steady state detection feature.
-#
-# steadystate_tests.py --read file-for-read-testing --write file-for-write-testing ./fio
-#
-# REQUIREMENTS
-# Python 2.6+
-# SciPy
-#
-# KNOWN ISSUES
-# only option parsing and read tests are carried out
-# On Windows this script works under Cygwin but not from cmd.exe
-# On Windows I encounter frequent fio problems generating JSON output (nothing to decode)
-# min runtime:
-# if ss attained: min runtime = ss_dur + ss_ramp
-# if not attained: runtime = timeout
-
-from __future__ import absolute_import
-from __future__ import print_function
-import os
-import sys
-import json
-import uuid
-import pprint
-import argparse
-import subprocess
-from scipy import stats
-from six.moves import range
-
-def parse_args():
-    parser = argparse.ArgumentParser()
-    parser.add_argument('fio',
-                        help='path to fio executable')
-    parser.add_argument('--read',
-                        help='target for read testing')
-    parser.add_argument('--write',
-                        help='target for write testing')
-    args = parser.parse_args()
-
-    return args
-
-
-def check(data, iops, slope, pct, limit, dur, criterion):
-    measurement = 'iops' if iops else 'bw'
-    data = data[measurement]
-    mean = sum(data) / len(data)
-    if slope:
-        x = list(range(len(data)))
-        m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
-        m = abs(m)
-        if pct:
-            target = m / mean * 100
-            criterion = criterion[:-1]
-        else:
-            target = m
-    else:
-        maxdev = 0
-        for x in data:
-            maxdev = max(abs(mean-x), maxdev)
-        if pct:
-            target = maxdev / mean * 100
-            criterion = criterion[:-1]
-        else:
-            target = maxdev
-
-    criterion = float(criterion)
-    return (abs(target - criterion) / criterion < 0.005), target < limit, mean, target
-
-
-if __name__ == '__main__':
-    args = parse_args()
-
-    pp = pprint.PrettyPrinter(indent=4)
-
-#
-# test option parsing
-#
-    parsing = [ { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10", "--ss_ramp=5"],
-                  'output': "set steady state IOPS threshold to 10.000000" },
-                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10%", "--ss_ramp=5"],
-                  'output': "set steady state threshold to 10.000000%" },
-                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:.1%", "--ss_ramp=5"],
-                  'output': "set steady state threshold to 0.100000%" },
-                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:10%", "--ss_ramp=5"],
-                  'output': "set steady state threshold to 10.000000%" },
-                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:.1%", "--ss_ramp=5"],
-                  'output': "set steady state threshold to 0.100000%" },
-                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:12", "--ss_ramp=5"],
-                  'output': "set steady state BW threshold to 12" },
-              ]
-    for test in parsing:
-        output = subprocess.check_output([args.fio] + test['args'])
-        if test['output'] in output.decode():
-            print("PASSED '{0}' found with arguments {1}".format(test['output'], test['args']))
-        else:
-            print("FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args']))
-
-#
-# test some read workloads
-#
-# if ss active and attained,
-#   check that runtime is less than job time
-#   check criteria
-#   how to check ramp time?
-#
-# if ss inactive
-#   check that runtime is what was specified
-#
-    reads = [ {'s': True, 'timeout': 100, 'numjobs': 1, 'ss_dur': 5, 'ss_ramp': 3, 'iops': True, 'slope': True, 'ss_limit': 0.1, 'pct': True},
-              {'s': False, 'timeout': 20, 'numjobs': 2},
-              {'s': True, 'timeout': 100, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 5, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
-              {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
-            ]
-
-    if args.read == None:
-        if os.name == 'posix':
-            args.read = '/dev/zero'
-            extra = [ "--size=134217728" ]  # 128 MiB
-        else:
-            print("ERROR: file for read testing must be specified on non-posix systems")
-            sys.exit(1)
-    else:
-        extra = []
-
-    jobnum = 0
-    for job in reads:
-
-        tf = uuid.uuid4().hex
-        parameters = [ "--name=job{0}".format(jobnum) ]
-        parameters.extend(extra)
-        parameters.extend([ "--thread",
-                            "--output-format=json",
-                            "--output={0}".format(tf),
-                            "--filename={0}".format(args.read),
-                            "--rw=randrw",
-                            "--rwmixread=100",
-                            "--stonewall",
-                            "--group_reporting",
-                            "--numjobs={0}".format(job['numjobs']),
-                            "--time_based",
-                            "--runtime={0}".format(job['timeout']) ])
-        if job['s']:
-           if job['iops']:
-               ss = 'iops'
-           else:
-               ss = 'bw'
-           if job['slope']:
-               ss += "_slope"
-           ss += ":" + str(job['ss_limit'])
-           if job['pct']:
-               ss += '%'
-           parameters.extend([ '--ss_dur={0}'.format(job['ss_dur']),
-                               '--ss={0}'.format(ss),
-                               '--ss_ramp={0}'.format(job['ss_ramp']) ])
-
-        output = subprocess.call([args.fio] + parameters)
-        with open(tf, 'r') as source:
-            jsondata = json.loads(source.read())
-        os.remove(tf)
-
-        for jsonjob in jsondata['jobs']:
-            line = "job {0}".format(jsonjob['job options']['name'])
-            if job['s']:
-                if jsonjob['steadystate']['attained'] == 1:
-                    # check runtime >= ss_dur + ss_ramp, check criterion, check criterion < limit
-                    mintime = (job['ss_dur'] + job['ss_ramp']) * 1000
-                    actual = jsonjob['read']['runtime']
-                    if mintime > actual:
-                        line = 'FAILED ' + line + ' ss attained, runtime {0} < ss_dur {1} + ss_ramp {2}'.format(actual, job['ss_dur'], job['ss_ramp'])
-                    else:
-                        line = line + ' ss attained, runtime {0} > ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
-                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
-                            iops=job['iops'],
-                            slope=job['slope'],
-                            pct=job['pct'],
-                            limit=job['ss_limit'],
-                            dur=job['ss_dur'],
-                            criterion=jsonjob['steadystate']['criterion'])
-                        if not objsame:
-                            line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
-                        else:
-                            if met:
-                                line = 'PASSED ' + line + ' target {0} < limit {1}'.format(target, job['ss_limit'])
-                            else:
-                                line = 'FAILED ' + line + ' target {0} < limit {1} but fio reports ss not attained '.format(target, job['ss_limit'])
-                else:
-                    # check runtime, confirm criterion calculation, and confirm that criterion was not met
-                    expected = job['timeout'] * 1000
-                    actual = jsonjob['read']['runtime']
-                    if abs(expected - actual) > 10:
-                        line = 'FAILED ' + line + ' ss not attained, expected runtime {0} != actual runtime {1}'.format(expected, actual)
-                    else:
-                        line = line + ' ss not attained, runtime {0} != ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
-                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
-                            iops=job['iops'],
-                            slope=job['slope'],
-                            pct=job['pct'],
-                            limit=job['ss_limit'],
-                            dur=job['ss_dur'],
-                            criterion=jsonjob['steadystate']['criterion'])
-                        if not objsame:
-                            if actual > (job['ss_dur'] + job['ss_ramp'])*1000:
-                                line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
-                            else:
-                                line = 'PASSED ' + line + ' fio criterion {0} == 0.0 since ss_dur + ss_ramp has not elapsed '.format(jsonjob['steadystate']['criterion'])
-                        else:
-                            if met:
-                                line = 'FAILED ' + line + ' target {0} < threshold {1} but fio reports ss not attained '.format(target, job['ss_limit'])
-                            else:
-                                line = 'PASSED ' + line + ' criterion {0} > threshold {1}'.format(target, job['ss_limit'])
-            else:
-                expected = job['timeout'] * 1000
-                actual = jsonjob['read']['runtime']
-                if abs(expected - actual) < 10:
-                    result = 'PASSED '
-                else:
-                    result = 'FAILED '
-                line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
-            print(line)
-            if 'steadystate' in jsonjob:
-                pp.pprint(jsonjob['steadystate'])
-        jobnum += 1

