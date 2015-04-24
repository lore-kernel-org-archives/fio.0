Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50898 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbDXMAA (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Apr 2015 08:00:00 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YlcH1-0008GS-Sh
	for fio@vger.kernel.org; Fri, 24 Apr 2015 12:00:00 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150424120001.8118B2C01AD@kernel.dk>
Date: Fri, 24 Apr 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 8a16f59b66e5198050ec735998692ba9436a9884:

  blktrace: only probe and set depth if option isn't set (2015-04-22 19:54:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 36870c47801ca85d1a98c7ec47950b0aa360f865:

  Merge branch 'io-threads' (2015-04-23 11:13:27 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      Add ->bytes_done[] to struct thread_data
      backend: split queue io_u event handling into helper
      First cut at supporting IO offload
      libaio: don't call io_destroy(), let exit_aio() take care of it
      Add man page and HOWTO for io_submit_mode option
      Add sample job file for fixed submission rate
      Merge branch 'io-threads'

 HOWTO                              |  12 +
 Makefile                           |   2 +-
 backend.c                          | 326 ++++++++++++++-------------
 cconv.c                            |   2 +
 engines/libaio.c                   |   9 +-
 examples/fixed-rate-submission.fio |  10 +
 fio.1                              |  11 +
 fio.h                              |  61 +++--
 init.c                             |   3 +
 io_u.c                             | 113 ++++++----
 ioengine.h                         |  15 +-
 ioengines.c                        |  16 +-
 libfio.c                           |   1 +
 options.c                          |  20 ++
 stat.c                             |   6 +
 thread_options.h                   |   3 +-
 verify.c                           |   8 +-
 workqueue.c                        | 444 +++++++++++++++++++++++++++++++++++++
 workqueue.h                        |  29 +++
 19 files changed, 853 insertions(+), 238 deletions(-)
 create mode 100644 examples/fixed-rate-submission.fio
 create mode 100644 workqueue.c
 create mode 100644 workqueue.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 60eab24..bcc72b5 100644
--- a/HOWTO
+++ b/HOWTO
@@ -820,6 +820,18 @@ iodepth_low=int	The low water mark indicating when to start filling
 		after fio has filled the queue of 16 requests, it will let
 		the depth drain down to 4 before starting to fill it again.
 
+io_submit_mode=str	This option controls how fio submits the IO to
+		the IO engine. The default is 'inline', which means that the
+		fio job threads submit and reap IO directly. If set to
+		'offload', the job threads will offload IO submission to a
+		dedicated pool of IO threads. This requires some coordination
+		and thus has a bit of extra overhead, especially for lower
+		queue depth IO where it can increase latencies. The benefit
+		is that fio can manage submission rates independently of
+		the device completion rates. This avoids skewed latency
+		reporting if IO gets back up on the device side (the
+		coordinated omission problem).
+
 direct=bool	If value is true, use non-buffered io. This is usually
 		O_DIRECT. Note that ZFS on Solaris doesn't support direct io.
 		On Windows the synchronous ioengines don't support direct io.
diff --git a/Makefile b/Makefile
index 4202ed8..9b7f27a 100644
--- a/Makefile
+++ b/Makefile
@@ -36,7 +36,7 @@ SOURCE := gettime.c ioengines.c init.c stat.c log.c time.c filesetup.c \
 		lib/lfsr.c gettime-thread.c helpers.c lib/flist_sort.c \
 		lib/hweight.c lib/getrusage.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		lib/tp.c lib/bloom.c lib/gauss.c
+		lib/tp.c lib/bloom.c lib/gauss.c workqueue.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/backend.c b/backend.c
index 25479b4..65a3e18 100644
--- a/backend.c
+++ b/backend.c
@@ -54,6 +54,7 @@
 #include "idletime.h"
 #include "err.h"
 #include "lib/tp.h"
+#include "workqueue.h"
 
 static pthread_t helper_thread;
 static pthread_mutex_t helper_lock;
@@ -229,16 +230,15 @@ static int __check_min_rate(struct thread_data *td, struct timeval *now,
 	return 0;
 }
 
-static int check_min_rate(struct thread_data *td, struct timeval *now,
-			  uint64_t *bytes_done)
+static int check_min_rate(struct thread_data *td, struct timeval *now)
 {
 	int ret = 0;
 
-	if (bytes_done[DDIR_READ])
+	if (td->bytes_done[DDIR_READ])
 		ret |= __check_min_rate(td, now, DDIR_READ);
-	if (bytes_done[DDIR_WRITE])
+	if (td->bytes_done[DDIR_WRITE])
 		ret |= __check_min_rate(td, now, DDIR_WRITE);
-	if (bytes_done[DDIR_TRIM])
+	if (td->bytes_done[DDIR_TRIM])
 		ret |= __check_min_rate(td, now, DDIR_TRIM);
 
 	return ret;
@@ -255,7 +255,7 @@ static void cleanup_pending_aio(struct thread_data *td)
 	/*
 	 * get immediately available events, if any
 	 */
-	r = io_u_queued_complete(td, 0, NULL);
+	r = io_u_queued_complete(td, 0);
 	if (r < 0)
 		return;
 
@@ -276,7 +276,7 @@ static void cleanup_pending_aio(struct thread_data *td)
 	}
 
 	if (td->cur_depth)
-		r = io_u_queued_complete(td, td->cur_depth, NULL);
+		r = io_u_queued_complete(td, td->cur_depth);
 }
 
 /*
@@ -306,7 +306,7 @@ requeue:
 		put_io_u(td, io_u);
 		return 1;
 	} else if (ret == FIO_Q_QUEUED) {
-		if (io_u_queued_complete(td, 1, NULL) < 0)
+		if (io_u_queued_complete(td, 1) < 0)
 			return 1;
 	} else if (ret == FIO_Q_COMPLETED) {
 		if (io_u->error) {
@@ -314,7 +314,7 @@ requeue:
 			return 1;
 		}
 
-		if (io_u_sync_complete(td, io_u, NULL) < 0)
+		if (io_u_sync_complete(td, io_u) < 0)
 			return 1;
 	} else if (ret == FIO_Q_BUSY) {
 		if (td_io_commit(td))
@@ -418,8 +418,7 @@ static void check_update_rusage(struct thread_data *td)
 	}
 }
 
-static int wait_for_completions(struct thread_data *td, struct timeval *time,
-				uint64_t *bytes_done)
+static int wait_for_completions(struct thread_data *td, struct timeval *time)
 {
 	const int full = queue_full(td);
 	int min_evts = 0;
@@ -438,7 +437,7 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time,
 		fio_gettime(time, NULL);
 
 	do {
-		ret = io_u_queued_complete(td, min_evts, bytes_done);
+		ret = io_u_queued_complete(td, min_evts);
 		if (ret < 0)
 			break;
 	} while (full && (td->cur_depth > td->o.iodepth_low));
@@ -446,13 +445,99 @@ static int wait_for_completions(struct thread_data *td, struct timeval *time,
 	return ret;
 }
 
+int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
+		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
+		   struct timeval *comp_time)
+{
+	int ret2;
+
+	switch (*ret) {
+	case FIO_Q_COMPLETED:
+		if (io_u->error) {
+			*ret = -io_u->error;
+			clear_io_u(td, io_u);
+		} else if (io_u->resid) {
+			int bytes = io_u->xfer_buflen - io_u->resid;
+			struct fio_file *f = io_u->file;
+
+			if (bytes_issued)
+				*bytes_issued += bytes;
+
+			if (!from_verify)
+				trim_io_piece(td, io_u);
+
+			/*
+			 * zero read, fail
+			 */
+			if (!bytes) {
+				if (!from_verify)
+					unlog_io_piece(td, io_u);
+				td_verror(td, EIO, "full resid");
+				put_io_u(td, io_u);
+				break;
+			}
+
+			io_u->xfer_buflen = io_u->resid;
+			io_u->xfer_buf += bytes;
+			io_u->offset += bytes;
+
+			if (ddir_rw(io_u->ddir))
+				td->ts.short_io_u[io_u->ddir]++;
+
+			f = io_u->file;
+			if (io_u->offset == f->real_file_size)
+				goto sync_done;
+
+			requeue_io_u(td, &io_u);
+		} else {
+sync_done:
+			if (comp_time && (__should_check_rate(td, DDIR_READ) ||
+			    __should_check_rate(td, DDIR_WRITE) ||
+			    __should_check_rate(td, DDIR_TRIM)))
+				fio_gettime(comp_time, NULL);
+
+			*ret = io_u_sync_complete(td, io_u);
+			if (*ret < 0)
+				break;
+		}
+		return 0;
+	case FIO_Q_QUEUED:
+		/*
+		 * if the engine doesn't have a commit hook,
+		 * the io_u is really queued. if it does have such
+		 * a hook, it has to call io_u_queued() itself.
+		 */
+		if (td->io_ops->commit == NULL)
+			io_u_queued(td, io_u);
+		if (bytes_issued)
+			*bytes_issued += io_u->xfer_buflen;
+		break;
+	case FIO_Q_BUSY:
+		if (!from_verify)
+			unlog_io_piece(td, io_u);
+		requeue_io_u(td, &io_u);
+		ret2 = td_io_commit(td);
+		if (ret2 < 0)
+			*ret = ret2;
+		break;
+	default:
+		assert(ret < 0);
+		td_verror(td, -(*ret), "td_io_queue");
+		break;
+	}
+
+	if (break_on_this_error(td, ddir, ret))
+		return 1;
+
+	return 0;
+}
+
 /*
  * The main verify engine. Runs over the writes we previously submitted,
  * reads the blocks back in, and checks the crc/md5 of the data.
  */
 static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 {
-	uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
 	struct fio_file *f;
 	struct io_u *io_u;
 	int ret, min_events;
@@ -483,7 +568,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 	io_u = NULL;
 	while (!td->terminate) {
 		enum fio_ddir ddir;
-		int ret2, full;
+		int full;
 
 		update_tv_cache(td);
 		check_update_rusage(td);
@@ -514,7 +599,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 			}
 		} else {
-			if (ddir_rw_sum(bytes_done) + td->o.rw_min_bs > verify_bytes)
+			if (ddir_rw_sum(td->bytes_done) + td->o.rw_min_bs > verify_bytes)
 				break;
 
 			while ((io_u = get_io_u(td)) != NULL) {
@@ -539,7 +624,7 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 					continue;
 				} else if (io_u->ddir == DDIR_TRIM) {
 					io_u->ddir = DDIR_READ;
-					io_u->flags |= IO_U_F_TRIMMED;
+					io_u_set(io_u, IO_U_F_TRIMMED);
 					break;
 				} else if (io_u->ddir == DDIR_WRITE) {
 					io_u->ddir = DDIR_READ;
@@ -569,57 +654,8 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 			fio_gettime(&io_u->start_time, NULL);
 
 		ret = td_io_queue(td, io_u);
-		switch (ret) {
-		case FIO_Q_COMPLETED:
-			if (io_u->error) {
-				ret = -io_u->error;
-				clear_io_u(td, io_u);
-			} else if (io_u->resid) {
-				int bytes = io_u->xfer_buflen - io_u->resid;
-
-				/*
-				 * zero read, fail
-				 */
-				if (!bytes) {
-					td_verror(td, EIO, "full resid");
-					put_io_u(td, io_u);
-					break;
-				}
-
-				io_u->xfer_buflen = io_u->resid;
-				io_u->xfer_buf += bytes;
-				io_u->offset += bytes;
-
-				if (ddir_rw(io_u->ddir))
-					td->ts.short_io_u[io_u->ddir]++;
 
-				f = io_u->file;
-				if (io_u->offset == f->real_file_size)
-					goto sync_done;
-
-				requeue_io_u(td, &io_u);
-			} else {
-sync_done:
-				ret = io_u_sync_complete(td, io_u, bytes_done);
-				if (ret < 0)
-					break;
-			}
-			continue;
-		case FIO_Q_QUEUED:
-			break;
-		case FIO_Q_BUSY:
-			requeue_io_u(td, &io_u);
-			ret2 = td_io_commit(td);
-			if (ret2 < 0)
-				ret = ret2;
-			break;
-		default:
-			assert(ret < 0);
-			td_verror(td, -ret, "td_io_queue");
-			break;
-		}
-
-		if (break_on_this_error(td, ddir, &ret))
+		if (io_queue_event(td, io_u, &ret, ddir, NULL, 1, NULL))
 			break;
 
 		/*
@@ -630,7 +666,7 @@ sync_done:
 reap:
 		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
 		if (full || !td->o.iodepth_batch_complete)
-			ret = wait_for_completions(td, NULL, bytes_done);
+			ret = wait_for_completions(td, NULL);
 
 		if (ret < 0)
 			break;
@@ -642,7 +678,7 @@ reap:
 		min_events = td->cur_depth;
 
 		if (min_events)
-			ret = io_u_queued_complete(td, min_events, NULL);
+			ret = io_u_queued_complete(td, min_events);
 	} else
 		cleanup_pending_aio(td);
 
@@ -716,7 +752,6 @@ static int io_complete_bytes_exceeded(struct thread_data *td)
  */
 static uint64_t do_io(struct thread_data *td)
 {
-	uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
 	unsigned int i;
 	int ret = 0;
 	uint64_t total_bytes, bytes_issued = 0;
@@ -754,7 +789,7 @@ static uint64_t do_io(struct thread_data *td)
 		td->o.time_based) {
 		struct timeval comp_time;
 		struct io_u *io_u;
-		int ret2, full;
+		int full;
 		enum fio_ddir ddir;
 
 		check_update_rusage(td);
@@ -834,97 +869,35 @@ static uint64_t do_io(struct thread_data *td)
 		    !td->o.experimental_verify)
 			log_io_piece(td, io_u);
 
-		ret = td_io_queue(td, io_u);
-		switch (ret) {
-		case FIO_Q_COMPLETED:
-			if (io_u->error) {
-				ret = -io_u->error;
-				unlog_io_piece(td, io_u);
-				clear_io_u(td, io_u);
-			} else if (io_u->resid) {
-				int bytes = io_u->xfer_buflen - io_u->resid;
-				struct fio_file *f = io_u->file;
-
-				bytes_issued += bytes;
-
-				trim_io_piece(td, io_u);
-
-				/*
-				 * zero read, fail
-				 */
-				if (!bytes) {
-					unlog_io_piece(td, io_u);
-					td_verror(td, EIO, "full resid");
-					put_io_u(td, io_u);
-					break;
-				}
-
-				io_u->xfer_buflen = io_u->resid;
-				io_u->xfer_buf += bytes;
-				io_u->offset += bytes;
-
-				if (ddir_rw(io_u->ddir))
-					td->ts.short_io_u[io_u->ddir]++;
-
-				if (io_u->offset == f->real_file_size)
-					goto sync_done;
+		if (td->o.io_submit_mode == IO_MODE_OFFLOAD) {
+			if (td->error)
+				break;
+			ret = workqueue_enqueue(&td->io_wq, io_u);
+		} else {
+			ret = td_io_queue(td, io_u);
 
-				requeue_io_u(td, &io_u);
-			} else {
-sync_done:
-				if (__should_check_rate(td, DDIR_READ) ||
-				    __should_check_rate(td, DDIR_WRITE) ||
-				    __should_check_rate(td, DDIR_TRIM))
-					fio_gettime(&comp_time, NULL);
+			if (io_queue_event(td, io_u, &ret, ddir, &bytes_issued, 1, &comp_time))
+				break;
 
-				ret = io_u_sync_complete(td, io_u, bytes_done);
-				if (ret < 0)
-					break;
-				bytes_issued += io_u->xfer_buflen;
-			}
-			break;
-		case FIO_Q_QUEUED:
 			/*
-			 * if the engine doesn't have a commit hook,
-			 * the io_u is really queued. if it does have such
-			 * a hook, it has to call io_u_queued() itself.
+			 * See if we need to complete some commands. Note that
+			 * we can get BUSY even without IO queued, if the
+			 * system is resource starved.
 			 */
-			if (td->io_ops->commit == NULL)
-				io_u_queued(td, io_u);
-			bytes_issued += io_u->xfer_buflen;
-			break;
-		case FIO_Q_BUSY:
-			unlog_io_piece(td, io_u);
-			requeue_io_u(td, &io_u);
-			ret2 = td_io_commit(td);
-			if (ret2 < 0)
-				ret = ret2;
-			break;
-		default:
-			assert(ret < 0);
-			put_io_u(td, io_u);
-			break;
-		}
-
-		if (break_on_this_error(td, ddir, &ret))
-			break;
-
-		/*
-		 * See if we need to complete some commands. Note that we
-		 * can get BUSY even without IO queued, if the system is
-		 * resource starved.
-		 */
 reap:
-		full = queue_full(td) || (ret == FIO_Q_BUSY && td->cur_depth);
-		if (full || !td->o.iodepth_batch_complete)
-			ret = wait_for_completions(td, &comp_time, bytes_done);
+			full = queue_full(td) ||
+				(ret == FIO_Q_BUSY && td->cur_depth);
+			if (full || !td->o.iodepth_batch_complete)
+				ret = wait_for_completions(td, &comp_time);
+		}
 		if (ret < 0)
 			break;
-		if (!ddir_rw_sum(bytes_done) && !(td->io_ops->flags & FIO_NOIO))
+		if (!ddir_rw_sum(td->bytes_done) &&
+		    !(td->io_ops->flags & FIO_NOIO))
 			continue;
 
-		if (!in_ramp_time(td) && should_check_rate(td, bytes_done)) {
-			if (check_min_rate(td, &comp_time, bytes_done)) {
+		if (!in_ramp_time(td) && should_check_rate(td)) {
+			if (check_min_rate(td, &comp_time)) {
 				if (exitall_on_terminate)
 					fio_terminate_threads(td->groupid);
 				td_verror(td, EIO, "check_min_rate");
@@ -965,9 +938,14 @@ reap:
 	if (!td->error) {
 		struct fio_file *f;
 
-		i = td->cur_depth;
+		if (td->o.io_submit_mode == IO_MODE_OFFLOAD) {
+			workqueue_flush(&td->io_wq);
+			i = 0;
+		} else
+			i = td->cur_depth;
+
 		if (i) {
-			ret = io_u_queued_complete(td, i, bytes_done);
+			ret = io_u_queued_complete(td, i);
 			if (td->o.fill_device && td->error == ENOSPC)
 				td->error = 0;
 		}
@@ -992,7 +970,7 @@ reap:
 	if (!ddir_rw_sum(td->this_io_bytes))
 		td->done = 1;
 
-	return bytes_done[DDIR_WRITE] + bytes_done[DDIR_TRIM];
+	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
 static void cleanup_io_u(struct thread_data *td)
@@ -1262,8 +1240,6 @@ static int exec_string(struct thread_options *o, const char *string, const char
  */
 static uint64_t do_dry_run(struct thread_data *td)
 {
-	uint64_t bytes_done[DDIR_RWDIR_CNT] = { 0, 0, 0 };
-
 	td_set_runstate(td, TD_RUNNING);
 
 	while ((td->o.read_iolog_file && !flist_empty(&td->io_log_list)) ||
@@ -1278,7 +1254,7 @@ static uint64_t do_dry_run(struct thread_data *td)
 		if (!io_u)
 			break;
 
-		io_u->flags |= IO_U_F_FLIGHT;
+		io_u_set(io_u, IO_U_F_FLIGHT);
 		io_u->error = 0;
 		io_u->resid = 0;
 		if (ddir_rw(acct_ddir(io_u)))
@@ -1294,11 +1270,34 @@ static uint64_t do_dry_run(struct thread_data *td)
 		    !td->o.experimental_verify)
 			log_io_piece(td, io_u);
 
-		ret = io_u_sync_complete(td, io_u, bytes_done);
+		ret = io_u_sync_complete(td, io_u);
 		(void) ret;
 	}
 
-	return bytes_done[DDIR_WRITE] + bytes_done[DDIR_TRIM];
+	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
+}
+
+static void io_workqueue_fn(struct thread_data *td, struct io_u *io_u)
+{
+	const enum fio_ddir ddir = io_u->ddir;
+	int ret;
+
+	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
+
+	io_u_set(io_u, IO_U_F_NO_FILE_PUT);
+
+	td->cur_depth++;
+
+	ret = td_io_queue(td, io_u);
+
+	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
+
+	io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
+
+	if (ret == FIO_Q_QUEUED)
+		ret = io_u_queued_complete(td, 1);
+
+	td->cur_depth--;
 }
 
 /*
@@ -1498,6 +1497,10 @@ static void *thread_main(void *data)
 
 	fio_verify_init(td);
 
+	if ((o->io_submit_mode == IO_MODE_OFFLOAD) &&
+	    workqueue_init(td, &td->io_wq, io_workqueue_fn, td->o.iodepth))
+		goto err;
+
 	fio_gettime(&td->epoch, NULL);
 	fio_getrusage(&td->ru_start);
 	clear_state = 0;
@@ -1606,6 +1609,9 @@ static void *thread_main(void *data)
 
 	fio_writeout_logs(td);
 
+	if (o->io_submit_mode == IO_MODE_OFFLOAD)
+		workqueue_exit(&td->io_wq);
+
 	if (td->flags & TD_F_COMPRESS_LOG)
 		tp_exit(&td->tp_data);
 
diff --git a/cconv.c b/cconv.c
index 68f119f..976059c 100644
--- a/cconv.c
+++ b/cconv.c
@@ -116,6 +116,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	}
 
 	o->ratecycle = le32_to_cpu(top->ratecycle);
+	o->io_submit_mode = le32_to_cpu(top->io_submit_mode);
 	o->nr_files = le32_to_cpu(top->nr_files);
 	o->open_files = le32_to_cpu(top->open_files);
 	o->file_lock_mode = le32_to_cpu(top->file_lock_mode);
@@ -295,6 +296,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->fill_device = cpu_to_le32(o->fill_device);
 	top->file_append = cpu_to_le32(o->file_append);
 	top->ratecycle = cpu_to_le32(o->ratecycle);
+	top->io_submit_mode = cpu_to_le32(o->io_submit_mode);
 	top->nr_files = cpu_to_le32(o->nr_files);
 	top->open_files = cpu_to_le32(o->open_files);
 	top->file_lock_mode = cpu_to_le32(o->file_lock_mode);
diff --git a/engines/libaio.c b/engines/libaio.c
index d4f4830..8ba21f8 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -316,7 +316,14 @@ static void fio_libaio_cleanup(struct thread_data *td)
 	struct libaio_data *ld = td->io_ops->data;
 
 	if (ld) {
-		io_destroy(ld->aio_ctx);
+		/*
+		 * Work-around to avoid huge RCU stalls at exit time. If we
+		 * don't do this here, then it'll be torn down by exit_aio().
+		 * But for that case we can parallellize the freeing, thus
+		 * speeding it up a lot.
+		 */
+		if (!(td->flags & TD_F_CHILD))
+			io_destroy(ld->aio_ctx);
 		free(ld->aio_events);
 		free(ld->iocbs);
 		free(ld->io_us);
diff --git a/examples/fixed-rate-submission.fio b/examples/fixed-rate-submission.fio
new file mode 100644
index 0000000..076a868
--- /dev/null
+++ b/examples/fixed-rate-submission.fio
@@ -0,0 +1,10 @@
+[fixed-rate-submit]
+size=128m
+rw=read
+ioengine=libaio
+iodepth=32
+direct=1
+# by setting the submit mode to offload, we can guarantee a fixed rate of
+# submission regardless of what the device completion rate is.
+io_submit_mode=offload
+rate_iops=1000
diff --git a/fio.1 b/fio.1
index 81bcf06..a77c71c 100644
--- a/fio.1
+++ b/fio.1
@@ -694,6 +694,17 @@ cost of more retrieval system calls.
 Low watermark indicating when to start filling the queue again.  Default:
 \fBiodepth\fR. 
 .TP
+.BI io_submit_mode \fR=\fPstr
+This option controls how fio submits the IO to the IO engine. The default is
+\fBinline\fR, which means that the fio job threads submit and reap IO directly.
+If set to \fBoffload\fR, the job threads will offload IO submission to a
+dedicated pool of IO threads. This requires some coordination and thus has a
+bit of extra overhead, especially for lower queue depth IO where it can
+increase latencies. The benefit is that fio can manage submission rates
+independently of the device completion rates. This avoids skewed latency
+reporting if IO gets back up on the device side (the coordinated omission
+problem).
+.TP
 .BI direct \fR=\fPbool
 If true, use non-buffered I/O (usually O_DIRECT).  Default: false.
 .TP
diff --git a/fio.h b/fio.h
index 0fb86ea..a4637bb 100644
--- a/fio.h
+++ b/fio.h
@@ -40,6 +40,7 @@
 #include "stat.h"
 #include "flow.h"
 #include "io_u_queue.h"
+#include "workqueue.h"
 
 #ifdef CONFIG_SOLARISAIO
 #include <sys/asynch.h>
@@ -75,6 +76,8 @@ enum {
 	TD_F_NOIO		= 256,
 	TD_F_COMPRESS_LOG	= 512,
 	TD_F_VSTATE_SAVED	= 1024,
+	TD_F_NEED_LOCK		= 2048,
+	TD_F_CHILD		= 4096,
 };
 
 enum {
@@ -94,6 +97,11 @@ enum {
 	FIO_RAND_NR_OFFS,
 };
 
+enum {
+	IO_MODE_INLINE = 0,
+	IO_MODE_OFFLOAD,
+};
+
 /*
  * This describes a single thread/process executing a fio job.
  */
@@ -118,6 +126,8 @@ struct thread_data {
 
 	struct tp_data *tp_data;
 
+	struct thread_data *parent;
+
 	uint64_t stat_io_bytes[DDIR_RWDIR_CNT];
 	struct timeval bw_sample_time;
 
@@ -232,6 +242,11 @@ struct thread_data {
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
 	struct timeval lastrate[DDIR_RWDIR_CNT];
 
+	/*
+	 * Enforced rate submission/completion workqueue
+	 */
+	struct workqueue io_wq;
+
 	uint64_t total_io_size;
 	uint64_t fill_device_size;
 
@@ -248,10 +263,11 @@ struct thread_data {
 	uint64_t io_blocks[DDIR_RWDIR_CNT];
 	uint64_t this_io_blocks[DDIR_RWDIR_CNT];
 	uint64_t io_bytes[DDIR_RWDIR_CNT];
-	uint64_t io_skip_bytes;
 	uint64_t this_io_bytes[DDIR_RWDIR_CNT];
+	uint64_t io_skip_bytes;
 	uint64_t zone_bytes;
 	struct fio_mutex *mutex;
+	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
@@ -364,12 +380,23 @@ enum {
 	} while (0)
 
 
-#define td_clear_error(td)		\
-	(td)->error = 0;
-#define td_verror(td, err, func)	\
-	__td_verror((td), (err), strerror((err)), (func))
-#define td_vmsg(td, err, msg, func)	\
-	__td_verror((td), (err), (msg), (func))
+#define td_clear_error(td)		do {		\
+	(td)->error = 0;				\
+	if ((td)->parent)				\
+		(td)->parent->error = 0;		\
+} while (0)
+
+#define td_verror(td, err, func)	do {			\
+	__td_verror((td), (err), strerror((err)), (func));	\
+	if ((td)->parent)					\
+		__td_verror((td)->parent, (err), strerror((err)), (func)); \
+} while (0)
+
+#define td_vmsg(td, err, msg, func)	do {			\
+	__td_verror((td), (err), (msg), (func));		\
+	if ((td)->parent)					\
+		__td_verror((td)->parent, (err), (msg), (func));	\
+} while (0)
 
 #define __fio_stringify_1(x)	#x
 #define __fio_stringify(x)	__fio_stringify_1(x)
@@ -574,16 +601,15 @@ static inline int __should_check_rate(struct thread_data *td,
 	return 0;
 }
 
-static inline int should_check_rate(struct thread_data *td,
-				    uint64_t *bytes_done)
+static inline int should_check_rate(struct thread_data *td)
 {
 	int ret = 0;
 
-	if (bytes_done[DDIR_READ])
+	if (td->bytes_done[DDIR_READ])
 		ret |= __should_check_rate(td, DDIR_READ);
-	if (bytes_done[DDIR_WRITE])
+	if (td->bytes_done[DDIR_WRITE])
 		ret |= __should_check_rate(td, DDIR_WRITE);
-	if (bytes_done[DDIR_TRIM])
+	if (td->bytes_done[DDIR_TRIM])
 		ret |= __should_check_rate(td, DDIR_TRIM);
 
 	return ret;
@@ -610,25 +636,30 @@ static inline int is_power_of_2(uint64_t val)
 	return (val != 0 && ((val & (val - 1)) == 0));
 }
 
+static inline int td_async_processing(struct thread_data *td)
+{
+	return (td->flags & TD_F_NEED_LOCK) != 0;
+}
+
 /*
  * We currently only need to do locking if we have verifier threads
  * accessing our internal structures too
  */
 static inline void td_io_u_lock(struct thread_data *td)
 {
-	if (td->o.verify_async)
+	if (td_async_processing(td))
 		pthread_mutex_lock(&td->io_u_lock);
 }
 
 static inline void td_io_u_unlock(struct thread_data *td)
 {
-	if (td->o.verify_async)
+	if (td_async_processing(td))
 		pthread_mutex_unlock(&td->io_u_lock);
 }
 
 static inline void td_io_u_free_notify(struct thread_data *td)
 {
-	if (td->o.verify_async)
+	if (td_async_processing(td))
 		pthread_cond_signal(&td->free_cond);
 }
 
diff --git a/init.c b/init.c
index a126f79..1a5d4c9 100644
--- a/init.c
+++ b/init.c
@@ -956,6 +956,9 @@ static void init_flags(struct thread_data *td)
 		td->flags |= TD_F_SCRAMBLE_BUFFERS;
 	if (o->verify != VERIFY_NONE)
 		td->flags |= TD_F_VER_NONE;
+
+	if (o->verify_async || o->io_submit_mode == IO_MODE_OFFLOAD)
+		td->flags |= TD_F_NEED_LOCK;
 }
 
 static int setup_random_seeds(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index ebd75c1..ba3f7ca 100644
--- a/io_u.c
+++ b/io_u.c
@@ -326,7 +326,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 				*is_random = 1;
 			} else {
 				*is_random = 0;
-				io_u->flags |= IO_U_F_BUSY_OK;
+				io_u_set(io_u, IO_U_F_BUSY_OK);
 				ret = get_next_seq_offset(td, f, ddir, &offset);
 				if (ret)
 					ret = get_next_rand_block(td, f, ddir, &b);
@@ -336,7 +336,7 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 			ret = get_next_seq_offset(td, f, ddir, &offset);
 		}
 	} else {
-		io_u->flags |= IO_U_F_BUSY_OK;
+		io_u_set(io_u, IO_U_F_BUSY_OK);
 		*is_random = 0;
 
 		if (td->o.rw_seq == RW_SEQ_SEQ) {
@@ -552,7 +552,7 @@ void io_u_quiesce(struct thread_data *td)
 	while (td->io_u_in_flight) {
 		int fio_unused ret;
 
-		ret = io_u_queued_complete(td, 1, NULL);
+		ret = io_u_queued_complete(td, 1);
 	}
 }
 
@@ -591,7 +591,8 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	} else
 		usec = td->rate_pending_usleep[ddir];
 
-	io_u_quiesce(td);
+	if (td->o.io_submit_mode == IO_MODE_INLINE)
+		io_u_quiesce(td);
 
 	usec = usec_sleep(td, usec);
 
@@ -684,7 +685,7 @@ static void set_rw_ddir(struct thread_data *td, struct io_u *io_u)
 	    td->o.barrier_blocks &&
 	   !(td->io_issues[DDIR_WRITE] % td->o.barrier_blocks) &&
 	     td->io_issues[DDIR_WRITE])
-		io_u->flags |= IO_U_F_BARRIER;
+		io_u_set(io_u, IO_U_F_BARRIER);
 }
 
 void put_file_log(struct thread_data *td, struct fio_file *f)
@@ -697,16 +698,21 @@ void put_file_log(struct thread_data *td, struct fio_file *f)
 
 void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
+	if (td->parent)
+		td = td->parent;
+
 	td_io_u_lock(td);
 
 	if (io_u->file && !(io_u->flags & IO_U_F_NO_FILE_PUT))
 		put_file_log(td, io_u->file);
 
 	io_u->file = NULL;
-	io_u->flags |= IO_U_F_FREE;
+	io_u_set(io_u, IO_U_F_FREE);
 
-	if (io_u->flags & IO_U_F_IN_CUR_DEPTH)
+	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
+		assert(!(td->flags & TD_F_CHILD));
+	}
 	io_u_qpush(&td->io_u_freelist, io_u);
 	td_io_u_unlock(td);
 	td_io_u_free_notify(td);
@@ -714,7 +720,7 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
 {
-	io_u->flags &= ~IO_U_F_FLIGHT;
+	io_u_clear(io_u, IO_U_F_FLIGHT);
 	put_io_u(td, io_u);
 }
 
@@ -725,18 +731,24 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 
 	dprint(FD_IO, "requeue %p\n", __io_u);
 
+	if (td->parent)
+		td = td->parent;
+
 	td_io_u_lock(td);
 
-	__io_u->flags |= IO_U_F_FREE;
+	io_u_set(__io_u, IO_U_F_FREE);
 	if ((__io_u->flags & IO_U_F_FLIGHT) && ddir_rw(ddir))
 		td->io_issues[ddir]--;
 
-	__io_u->flags &= ~IO_U_F_FLIGHT;
-	if (__io_u->flags & IO_U_F_IN_CUR_DEPTH)
+	io_u_clear(__io_u, IO_U_F_FLIGHT);
+	if (__io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
+		assert(!(td->flags & TD_F_CHILD));
+	}
 
 	io_u_rpush(&td->io_u_requeues, __io_u);
 	td_io_u_unlock(td);
+	td_io_u_free_notify(td);
 	*io_u = NULL;
 }
 
@@ -1329,21 +1341,23 @@ again:
 
 	if (io_u) {
 		assert(io_u->flags & IO_U_F_FREE);
-		io_u->flags &= ~(IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
+		io_u_clear(io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
 				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
 				 IO_U_F_VER_LIST);
 
 		io_u->error = 0;
 		io_u->acct_ddir = -1;
 		td->cur_depth++;
-		io_u->flags |= IO_U_F_IN_CUR_DEPTH;
+		assert(!(td->flags & TD_F_CHILD));
+		io_u_set(io_u, IO_U_F_IN_CUR_DEPTH);
 		io_u->ipo = NULL;
-	} else if (td->o.verify_async) {
+	} else if (td_async_processing(td)) {
 		/*
 		 * We ran out, wait for async verify threads to finish and
 		 * return one
 		 */
-		pthread_cond_wait(&td->free_cond, &td->io_u_lock);
+		assert(!(td->flags & TD_F_CHILD));
+		assert(!pthread_cond_wait(&td->free_cond, &td->io_u_lock));
 		goto again;
 	}
 
@@ -1542,7 +1556,7 @@ err_put:
 	return ERR_PTR(ret);
 }
 
-void io_u_log_error(struct thread_data *td, struct io_u *io_u)
+static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 {
 	enum error_type_bit eb = td_error_type(io_u->ddir, io_u->error);
 
@@ -1560,6 +1574,13 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 		td_verror(td, io_u->error, "io_u error");
 }
 
+void io_u_log_error(struct thread_data *td, struct io_u *io_u)
+{
+	__io_u_log_error(td, io_u);
+	if (td->parent)
+		__io_u_log_error(td, io_u);
+}
+
 static inline int gtod_reduce(struct thread_data *td)
 {
 	return td->o.disable_clat && td->o.disable_lat && td->o.disable_slat
@@ -1570,9 +1591,10 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				  struct io_completion_data *icd,
 				  const enum fio_ddir idx, unsigned int bytes)
 {
+	const int no_reduce = !gtod_reduce(td);
 	unsigned long lusec = 0;
 
-	if (!gtod_reduce(td))
+	if (no_reduce)
 		lusec = utime_since(&io_u->issue_time, &icd->time);
 
 	if (!td->o.disable_lat) {
@@ -1601,10 +1623,13 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 		io_u_mark_latency(td, lusec);
 	}
 
+	if (td->parent)
+		td = td->parent;
+
 	if (!td->o.disable_bw)
 		add_bw_sample(td, idx, bytes, &icd->time);
 
-	if (!gtod_reduce(td))
+	if (no_reduce)
 		add_iops_sample(td, idx, bytes, &icd->time);
 
 	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
@@ -1625,6 +1650,7 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 {
 	uint64_t secs, remainder, bps, bytes;
 
+	assert(!(td->flags & TD_F_CHILD));
 	bytes = td->this_io_bytes[ddir];
 	bps = td->rate_bps[ddir];
 	secs = bytes / bps;
@@ -1641,9 +1667,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 
 	dprint_io_u(io_u, "io complete");
 
-	td_io_u_lock(td);
 	assert(io_u->flags & IO_U_F_FLIGHT);
-	io_u->flags &= ~(IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
+	io_u_clear(io_u, IO_U_F_FLIGHT | IO_U_F_BUSY_OK);
 
 	/*
 	 * Mark IO ok to verify
@@ -1660,8 +1685,6 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		}
 	}
 
-	td_io_u_unlock(td);
-
 	if (ddir_sync(ddir)) {
 		td->last_was_sync = 1;
 		if (f) {
@@ -1706,18 +1729,23 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 
 		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
 					   td->runstate == TD_VERIFYING)) {
+			struct thread_data *__td = td;
+
 			account_io_completion(td, io_u, icd, ddir, bytes);
 
-			if (__should_check_rate(td, ddir)) {
-				td->rate_pending_usleep[ddir] =
-					(usec_for_io(td, ddir) -
-					 utime_since_now(&td->start));
+			if (td->parent)
+				__td = td->parent;
+
+			if (__should_check_rate(__td, ddir)) {
+				__td->rate_pending_usleep[ddir] =
+					(usec_for_io(__td, ddir) -
+					 utime_since_now(&__td->start));
 			}
 			if (ddir != DDIR_TRIM &&
-			    __should_check_rate(td, oddir)) {
-				td->rate_pending_usleep[oddir] =
-					(usec_for_io(td, oddir) -
-					 utime_since_now(&td->start));
+			    __should_check_rate(__td, oddir)) {
+				__td->rate_pending_usleep[oddir] =
+					(usec_for_io(__td, oddir) -
+					 utime_since_now(&__td->start));
 			}
 		}
 
@@ -1785,10 +1813,10 @@ static void ios_completed(struct thread_data *td,
 /*
  * Complete a single io_u for the sync engines.
  */
-int io_u_sync_complete(struct thread_data *td, struct io_u *io_u,
-		       uint64_t *bytes)
+int io_u_sync_complete(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_completion_data icd;
+	int ddir;
 
 	init_icd(td, &icd, 1);
 	io_completed(td, &io_u, &icd);
@@ -1801,12 +1829,8 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u,
 		return -1;
 	}
 
-	if (bytes) {
-		int ddir;
-
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
-			bytes[ddir] += icd.bytes_done[ddir];
-	}
+	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return 0;
 }
@@ -1814,12 +1838,11 @@ int io_u_sync_complete(struct thread_data *td, struct io_u *io_u,
 /*
  * Called to complete min_events number of io for the async engines.
  */
-int io_u_queued_complete(struct thread_data *td, int min_evts,
-			 uint64_t *bytes)
+int io_u_queued_complete(struct thread_data *td, int min_evts)
 {
 	struct io_completion_data icd;
 	struct timespec *tvp = NULL;
-	int ret;
+	int ret, ddir;
 	struct timespec ts = { .tv_sec = 0, .tv_nsec = 0, };
 
 	dprint(FD_IO, "io_u_queued_completed: min=%d\n", min_evts);
@@ -1843,12 +1866,8 @@ int io_u_queued_complete(struct thread_data *td, int min_evts,
 		return -1;
 	}
 
-	if (bytes) {
-		int ddir;
-
-		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
-			bytes[ddir] += icd.bytes_done[ddir];
-	}
+	for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++)
+		td->bytes_done[ddir] += icd.bytes_done[ddir];
 
 	return 0;
 }
diff --git a/ioengine.h b/ioengine.h
index f9a0235..3d49993 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -119,6 +119,7 @@ struct io_u {
 		struct ibv_mr *mr;
 #endif
 		void *mmap_data;
+		uint64_t null;
 	};
 };
 
@@ -209,8 +210,8 @@ extern struct io_u *get_io_u(struct thread_data *);
 extern void put_io_u(struct thread_data *, struct io_u *);
 extern void clear_io_u(struct thread_data *, struct io_u *);
 extern void requeue_io_u(struct thread_data *, struct io_u **);
-extern int __must_check io_u_sync_complete(struct thread_data *, struct io_u *, uint64_t *);
-extern int __must_check io_u_queued_complete(struct thread_data *, int, uint64_t *);
+extern int __must_check io_u_sync_complete(struct thread_data *, struct io_u *);
+extern int __must_check io_u_queued_complete(struct thread_data *, int);
 extern void io_u_queued(struct thread_data *, struct io_u *);
 extern void io_u_quiesce(struct thread_data *);
 extern void io_u_log_error(struct thread_data *, struct io_u *);
@@ -251,4 +252,14 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
 	return io_u->ddir;
 }
 
+static inline void io_u_clear(struct io_u *io_u, unsigned int flags)
+{
+	__sync_fetch_and_and(&io_u->flags, ~flags);
+}
+
+static inline void io_u_set(struct io_u *io_u, unsigned int flags)
+{
+	__sync_fetch_and_or(&io_u->flags, flags);
+}
+
 #endif
diff --git a/ioengines.c b/ioengines.c
index b42e2c4..b724e0e 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -264,13 +264,15 @@ out:
 
 int td_io_queue(struct thread_data *td, struct io_u *io_u)
 {
+	const enum fio_ddir ddir = acct_ddir(io_u);
+	unsigned long buflen = io_u->xfer_buflen;
 	int ret;
 
 	dprint_io_u(io_u, "queue");
 	fio_ro_check(td, io_u);
 
 	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
-	io_u->flags |= IO_U_F_FLIGHT;
+	io_u_set(io_u, IO_U_F_FLIGHT);
 
 	assert(fio_file_open(io_u->file));
 
@@ -294,18 +296,18 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 					sizeof(struct timeval));
 	}
 
-	if (ddir_rw(acct_ddir(io_u))) {
-		td->io_issues[acct_ddir(io_u)]++;
-		td->io_issue_bytes[acct_ddir(io_u)] += io_u->xfer_buflen;
+	if (ddir_rw(ddir)) {
+		td->io_issues[ddir]++;
+		td->io_issue_bytes[ddir] += buflen;
 	}
 
 	ret = td->io_ops->queue(td, io_u);
 
 	unlock_file(td, io_u->file);
 
-	if (ret == FIO_Q_BUSY && ddir_rw(acct_ddir(io_u))) {
-		td->io_issues[acct_ddir(io_u)]--;
-		td->io_issue_bytes[acct_ddir(io_u)] -= io_u->xfer_buflen;
+	if (ret == FIO_Q_BUSY && ddir_rw(ddir)) {
+		td->io_issues[ddir]--;
+		td->io_issue_bytes[ddir] -= buflen;
 	}
 
 	/*
diff --git a/libfio.c b/libfio.c
index 57ce725..ed26114 100644
--- a/libfio.c
+++ b/libfio.c
@@ -88,6 +88,7 @@ static void reset_io_counters(struct thread_data *td)
 		td->this_io_blocks[ddir] = 0;
 		td->rate_bytes[ddir] = 0;
 		td->rate_blocks[ddir] = 0;
+		td->bytes_done[ddir] = 0;
 	}
 	td->zone_bytes = 0;
 
diff --git a/options.c b/options.c
index 5fbad31..3de1248 100644
--- a/options.c
+++ b/options.c
@@ -1623,6 +1623,26 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_BASIC,
 	},
 	{
+		.name	= "io_submit_mode",
+		.lname	= "IO submit mode",
+		.type	= FIO_OPT_STR,
+		.off1	= td_var_offset(io_submit_mode),
+		.help	= "How IO submissions and completions are done",
+		.def	= "inline",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+		.posval = {
+			  { .ival = "inline",
+			    .oval = IO_MODE_INLINE,
+			    .help = "Submit and complete IO inline",
+			  },
+			  { .ival = "offload",
+			    .oval = IO_MODE_OFFLOAD,
+			    .help = "Offload submit and complete to threads",
+			  },
+		},
+	},
+	{
 		.name	= "size",
 		.lname	= "Size",
 		.type	= FIO_OPT_STR_VAL,
diff --git a/stat.c b/stat.c
index e42edc9..d143d36 100644
--- a/stat.c
+++ b/stat.c
@@ -2009,6 +2009,8 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 	if (spent < td->o.bw_avg_time)
 		return;
 
+	td_io_u_lock(td);
+
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
@@ -2033,6 +2035,7 @@ void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
 	}
 
 	fio_gettime(&td->bw_sample_time, NULL);
+	td_io_u_unlock(td);
 }
 
 void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs,
@@ -2048,6 +2051,8 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 	if (spent < td->o.iops_avg_time)
 		return;
 
+	td_io_u_lock(td);
+
 	/*
 	 * Compute both read and write rates for the interval.
 	 */
@@ -2072,6 +2077,7 @@ void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, unsigned int bs
 	}
 
 	fio_gettime(&td->iops_sample_time, NULL);
+	td_io_u_unlock(td);
 }
 
 void stat_init(void)
diff --git a/thread_options.h b/thread_options.h
index 026b85b..aa7f3f2 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -223,6 +223,7 @@ struct thread_options {
 	unsigned int rate[DDIR_RWDIR_CNT];
 	unsigned int ratemin[DDIR_RWDIR_CNT];
 	unsigned int ratecycle;
+	unsigned int io_submit_mode;
 	unsigned int rate_iops[DDIR_RWDIR_CNT];
 	unsigned int rate_iops_min[DDIR_RWDIR_CNT];
 
@@ -452,6 +453,7 @@ struct thread_options_pack {
 	uint32_t rate[DDIR_RWDIR_CNT];
 	uint32_t ratemin[DDIR_RWDIR_CNT];
 	uint32_t ratecycle;
+	uint32_t io_submit_mode;
 	uint32_t rate_iops[DDIR_RWDIR_CNT];
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
 
@@ -489,7 +491,6 @@ struct thread_options_pack {
 
 	uint64_t latency_target;
 	uint64_t latency_window;
-	uint32_t pad3;
 	fio_fp64_t latency_percentile;
 
 	uint32_t block_error_hist;
diff --git a/verify.c b/verify.c
index b6793d7..aa178e9 100644
--- a/verify.c
+++ b/verify.c
@@ -656,7 +656,7 @@ int verify_io_u_async(struct thread_data *td, struct io_u **io_u_ptr)
 
 	if (io_u->flags & IO_U_F_IN_CUR_DEPTH) {
 		td->cur_depth--;
-		io_u->flags &= ~IO_U_F_IN_CUR_DEPTH;
+		io_u_clear(io_u, IO_U_F_IN_CUR_DEPTH);
 	}
 	flist_add_tail(&io_u->verify_list, &td->verify_list);
 	*io_u_ptr = NULL;
@@ -1105,10 +1105,10 @@ int get_next_verify(struct thread_data *td, struct io_u *io_u)
 		io_u->buflen = ipo->len;
 		io_u->numberio = ipo->numberio;
 		io_u->file = ipo->file;
-		io_u->flags |= IO_U_F_VER_LIST;
+		io_u_set(io_u, IO_U_F_VER_LIST);
 
 		if (ipo->flags & IP_F_TRIMMED)
-			io_u->flags |= IO_U_F_TRIMMED;
+			io_u_set(io_u, IO_U_F_TRIMMED);
 
 		if (!fio_file_open(io_u->file)) {
 			int r = td_io_open_file(td, io_u->file);
@@ -1192,7 +1192,7 @@ static void *verify_async_thread(void *data)
 			io_u = flist_first_entry(&list, struct io_u, verify_list);
 			flist_del_init(&io_u->verify_list);
 
-			io_u->flags |= IO_U_F_NO_FILE_PUT;
+			io_u_set(io_u, IO_U_F_NO_FILE_PUT);
 			ret = verify_io_u(td, &io_u);
 
 			put_io_u(td, io_u);
diff --git a/workqueue.c b/workqueue.c
new file mode 100644
index 0000000..92088ba
--- /dev/null
+++ b/workqueue.c
@@ -0,0 +1,444 @@
+/*
+ * Rated submission helpers
+ *
+ * Copyright (C) 2015 Jens Axboe <axboe@kernel.dk>
+ *
+ */
+#include <unistd.h>
+
+#include "fio.h"
+#include "ioengine.h"
+#include "flist.h"
+#include "workqueue.h"
+#include "lib/getrusage.h"
+
+struct submit_worker {
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t cond;
+	struct flist_head work_list;
+	unsigned int flags;
+	unsigned int index;
+	uint64_t seq;
+	struct workqueue *wq;
+	struct thread_data td;
+};
+
+enum {
+	SW_F_IDLE	= 1 << 0,
+	SW_F_RUNNING	= 1 << 1,
+	SW_F_EXIT	= 1 << 2,
+	SW_F_EXITED	= 1 << 3,
+	SW_F_ACCOUNTED	= 1 << 4,
+	SW_F_ERROR	= 1 << 5,
+};
+
+static struct submit_worker *__get_submit_worker(struct workqueue *wq,
+						 unsigned int start,
+						 unsigned int end,
+						 struct submit_worker **best)
+{
+	struct submit_worker *sw = NULL;
+
+	while (start <= end) {
+		sw = &wq->workers[start];
+		if (sw->flags & SW_F_IDLE)
+			return sw;
+		if (!(*best) || sw->seq < (*best)->seq)
+			*best = sw;
+		start++;
+	}
+
+	return NULL;
+}
+
+static struct submit_worker *get_submit_worker(struct workqueue *wq)
+{
+	unsigned int next = wq->next_free_worker;
+	struct submit_worker *sw, *best = NULL;
+
+	assert(next < wq->max_workers);
+
+	sw = __get_submit_worker(wq, next, wq->max_workers - 1, &best);
+	if (!sw && next)
+		sw = __get_submit_worker(wq, 0, next - 1, &best);
+
+	/*
+	 * No truly idle found, use best match
+	 */
+	if (!sw)
+		sw = best;
+
+	if (sw->index == wq->next_free_worker) {
+		if (sw->index + 1 < wq->max_workers)
+			wq->next_free_worker = sw->index + 1;
+		else
+			wq->next_free_worker = 0;
+	}
+
+	return sw;
+}
+
+static int all_sw_idle(struct workqueue *wq)
+{
+	int i;
+
+	for (i = 0; i < wq->max_workers; i++) {
+		struct submit_worker *sw = &wq->workers[i];
+
+		if (!(sw->flags & SW_F_IDLE))
+			return 0;
+	}
+
+	return 1;
+}
+
+/*
+ * Must be serialized wrt workqueue_enqueue() by caller
+ */
+void workqueue_flush(struct workqueue *wq)
+{
+	wq->wake_idle = 1;
+
+	while (!all_sw_idle(wq)) {
+		pthread_mutex_lock(&wq->flush_lock);
+		pthread_cond_wait(&wq->flush_cond, &wq->flush_lock);
+		pthread_mutex_unlock(&wq->flush_lock);
+	}
+
+	wq->wake_idle = 0;
+}
+
+/*
+ * Must be serialized by caller.
+ */
+int workqueue_enqueue(struct workqueue *wq, struct io_u *io_u)
+{
+	struct submit_worker *sw;
+
+	sw = get_submit_worker(wq);
+	if (sw) {
+		const enum fio_ddir ddir = acct_ddir(io_u);
+		struct thread_data *parent = wq->td;
+
+		if (ddir_rw(ddir)) {
+			parent->io_issues[ddir]++;
+			parent->io_issue_bytes[ddir] += io_u->xfer_buflen;
+		}
+
+		pthread_mutex_lock(&sw->lock);
+		flist_add_tail(&io_u->verify_list, &sw->work_list);
+		sw->seq = ++wq->work_seq;
+		sw->flags &= ~SW_F_IDLE;
+		pthread_mutex_unlock(&sw->lock);
+
+		pthread_cond_signal(&sw->cond);
+		return FIO_Q_QUEUED;
+	}
+
+	return FIO_Q_BUSY;
+}
+
+static void handle_list(struct submit_worker *sw, struct flist_head *list)
+{
+	struct workqueue *wq = sw->wq;
+	struct io_u *io_u;
+
+	while (!flist_empty(list)) {
+		io_u = flist_first_entry(list, struct io_u, verify_list);
+		flist_del_init(&io_u->verify_list);
+		wq->fn(&sw->td, io_u);
+	}
+}
+
+static int init_submit_worker(struct submit_worker *sw)
+{
+	struct thread_data *parent = sw->wq->td;
+	struct thread_data *td = &sw->td;
+	int fio_unused ret;
+
+	memcpy(&td->o, &parent->o, sizeof(td->o));
+	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
+	td->o.uid = td->o.gid = -1U;
+	dup_files(td, parent);
+	fio_options_mem_dupe(td);
+
+	if (ioengine_load(td))
+		goto err;
+
+	if (td->o.odirect)
+		td->io_ops->flags |= FIO_RAWIO;
+
+	td->pid = gettid();
+
+	INIT_FLIST_HEAD(&td->io_log_list);
+	INIT_FLIST_HEAD(&td->io_hist_list);
+	INIT_FLIST_HEAD(&td->verify_list);
+	INIT_FLIST_HEAD(&td->trim_list);
+	INIT_FLIST_HEAD(&td->next_rand_list);
+	td->io_hist_tree = RB_ROOT;
+
+	td->o.iodepth = 1;
+	if (td_io_init(td))
+		goto err_io_init;
+
+	fio_gettime(&td->epoch, NULL);
+	fio_getrusage(&td->ru_start);
+	clear_io_state(td);
+
+	td_set_runstate(td, TD_RUNNING);
+	td->flags |= TD_F_CHILD;
+	td->parent = parent;
+	return 0;
+
+err_io_init:
+	close_ioengine(td);
+err:
+	return 1;
+}
+
+static void sum_val(uint64_t *dst, uint64_t *src)
+{
+	if (*src) {
+		__sync_fetch_and_add(dst, *src);
+		*src = 0;
+	}
+}
+
+static void sum_ddir(struct thread_data *dst, struct thread_data *src,
+		     enum fio_ddir ddir)
+{
+	sum_val(&dst->io_bytes[ddir], &src->io_bytes[ddir]);
+	sum_val(&dst->io_blocks[ddir], &src->io_blocks[ddir]);
+	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
+	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
+	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
+}
+
+static void update_accounting(struct submit_worker *sw)
+{
+	struct thread_data *src = &sw->td;
+	struct thread_data *dst = sw->wq->td;
+
+	if (td_read(src))
+		sum_ddir(dst, src, DDIR_READ);
+	if (td_write(src))
+		sum_ddir(dst, src, DDIR_WRITE);
+	if (td_trim(src))
+		sum_ddir(dst, src, DDIR_TRIM);
+}
+
+static void *worker_thread(void *data)
+{
+	struct submit_worker *sw = data;
+	struct workqueue *wq = sw->wq;
+	struct thread_data *td = &sw->td;
+	unsigned int eflags = 0, ret;
+	FLIST_HEAD(local_list);
+
+	ret = init_submit_worker(sw);
+	pthread_mutex_lock(&sw->lock);
+	sw->flags |= SW_F_RUNNING;
+	if (ret)
+		sw->flags |= SW_F_ERROR;
+	pthread_mutex_unlock(&sw->lock);
+
+	pthread_mutex_lock(&wq->flush_lock);
+	pthread_cond_signal(&wq->flush_cond);
+	pthread_mutex_unlock(&wq->flush_lock);
+
+	if (sw->flags & SW_F_ERROR)
+		goto done;
+
+	while (1) {
+		pthread_mutex_lock(&sw->lock);
+
+		if (flist_empty(&sw->work_list)) {
+			if (sw->flags & SW_F_EXIT) {
+				pthread_mutex_unlock(&sw->lock);
+				break;
+			}
+
+			if (td->io_u_queued || td->cur_depth ||
+			    td->io_u_in_flight) {
+				pthread_mutex_unlock(&sw->lock);
+				io_u_quiesce(td);
+				pthread_mutex_lock(&sw->lock);
+			}
+
+			/*
+			 * We dropped and reaquired the lock, check
+			 * state again.
+			 */
+			if (!flist_empty(&sw->work_list))
+				goto handle_work;
+
+			if (sw->flags & SW_F_EXIT) {
+				pthread_mutex_unlock(&sw->lock);
+				break;
+			} else if (!(sw->flags & SW_F_IDLE)) {
+				sw->flags |= SW_F_IDLE;
+				wq->next_free_worker = sw->index;
+				if (wq->wake_idle)
+					pthread_cond_signal(&wq->flush_cond);
+			}
+			update_accounting(sw);
+			pthread_cond_wait(&sw->cond, &sw->lock);
+		} else {
+handle_work:
+			flist_splice_init(&sw->work_list, &local_list);
+		}
+		pthread_mutex_unlock(&sw->lock);
+		handle_list(sw, &local_list);
+	}
+
+	update_accounting(sw);
+
+done:
+	pthread_mutex_lock(&sw->lock);
+	sw->flags |= (SW_F_EXITED | eflags);
+	pthread_mutex_unlock(&sw->lock);
+	return NULL;
+}
+
+static void free_worker(struct submit_worker *sw)
+{
+	struct thread_data *td = &sw->td;
+
+	fio_options_free(td);
+	close_and_free_files(td);
+	if (td->io_ops)
+		close_ioengine(td);
+	td_set_runstate(td, TD_EXITED);
+
+	pthread_cond_destroy(&sw->cond);
+	pthread_mutex_destroy(&sw->lock);
+}
+
+static void shutdown_worker(struct submit_worker *sw, unsigned int *sum_cnt)
+{
+	struct thread_data *parent = sw->wq->td;
+
+	pthread_join(sw->thread, NULL);
+	(*sum_cnt)++;
+	sum_thread_stats(&parent->ts, &sw->td.ts, *sum_cnt);
+	free_worker(sw);
+}
+
+void workqueue_exit(struct workqueue *wq)
+{
+	unsigned int shutdown, sum_cnt = 0;
+	struct submit_worker *sw;
+	int i;
+
+	for (i = 0; i < wq->max_workers; i++) {
+		sw = &wq->workers[i];
+
+		pthread_mutex_lock(&sw->lock);
+		sw->flags |= SW_F_EXIT;
+		pthread_cond_signal(&sw->cond);
+		pthread_mutex_unlock(&sw->lock);
+	}
+
+	do {
+		shutdown = 0;
+		for (i = 0; i < wq->max_workers; i++) {
+			sw = &wq->workers[i];
+			if (sw->flags & SW_F_ACCOUNTED)
+				continue;
+			sw->flags |= SW_F_ACCOUNTED;
+			shutdown_worker(sw, &sum_cnt);
+			shutdown++;
+		}
+	} while (shutdown && shutdown != wq->max_workers);
+
+	free(wq->workers);
+	pthread_mutex_destroy(&wq->flush_lock);
+	pthread_cond_destroy(&wq->flush_cond);
+}
+
+static int start_worker(struct workqueue *wq, unsigned int index)
+{
+	struct submit_worker *sw = &wq->workers[index];
+	int ret;
+
+	INIT_FLIST_HEAD(&sw->work_list);
+	pthread_cond_init(&sw->cond, NULL);
+	pthread_mutex_init(&sw->lock, NULL);
+	sw->wq = wq;
+	sw->index = index;
+
+	ret = pthread_create(&sw->thread, NULL, worker_thread, sw);
+	if (!ret) {
+		pthread_mutex_lock(&sw->lock);
+		sw->flags = SW_F_IDLE;
+		pthread_mutex_unlock(&sw->lock);
+		return 0;
+	}
+
+	free_worker(sw);
+	return 1;
+}
+
+int workqueue_init(struct thread_data *td, struct workqueue *wq,
+		   workqueue_fn *fn, unsigned max_pending)
+{
+	unsigned int running;
+	int i, error;
+
+	wq->max_workers = max_pending;
+	wq->td = td;
+	wq->fn = fn;
+	wq->work_seq = 0;
+	wq->next_free_worker = 0;
+	pthread_cond_init(&wq->flush_cond, NULL);
+	pthread_mutex_init(&wq->flush_lock, NULL);
+
+	wq->workers = calloc(wq->max_workers, sizeof(struct submit_worker));
+
+	for (i = 0; i < wq->max_workers; i++)
+		if (start_worker(wq, i))
+			break;
+
+	wq->max_workers = i;
+	if (!wq->max_workers) {
+err:
+		log_err("Can't create rate workqueue\n");
+		td_verror(td, ESRCH, "workqueue_init");
+		workqueue_exit(wq);
+		return 1;
+	}
+
+	/*
+	 * Wait for them all to be started and initialized
+	 */
+	error = 0;
+	do {
+		struct submit_worker *sw;
+
+		running = 0;
+		pthread_mutex_lock(&wq->flush_lock);
+		for (i = 0; i < wq->max_workers; i++) {
+			sw = &wq->workers[i];
+			pthread_mutex_lock(&sw->lock);
+			if (sw->flags & SW_F_RUNNING)
+				running++;
+			if (sw->flags & SW_F_ERROR)
+				error++;
+			pthread_mutex_unlock(&sw->lock);
+		}
+
+		if (error || running == wq->max_workers) {
+			pthread_mutex_unlock(&wq->flush_lock);
+			break;
+		}
+
+		pthread_cond_wait(&wq->flush_cond, &wq->flush_lock);
+		pthread_mutex_unlock(&wq->flush_lock);
+	} while (1);
+
+	if (error)
+		goto err;
+
+	return 0;
+}
diff --git a/workqueue.h b/workqueue.h
new file mode 100644
index 0000000..5d47a5e
--- /dev/null
+++ b/workqueue.h
@@ -0,0 +1,29 @@
+#ifndef FIO_RATE_H
+#define FIO_RATE_H
+
+#include "flist.h"
+
+typedef void (workqueue_fn)(struct thread_data *, struct io_u *);
+
+struct workqueue {
+	unsigned int max_workers;
+
+	struct thread_data *td;
+	workqueue_fn *fn;
+
+	uint64_t work_seq;
+	struct submit_worker *workers;
+	unsigned int next_free_worker;
+
+	pthread_cond_t flush_cond;
+	pthread_mutex_t flush_lock;
+	volatile int wake_idle;
+};
+
+int workqueue_init(struct thread_data *td, struct workqueue *wq, workqueue_fn *fn, unsigned int max_workers);
+void workqueue_exit(struct workqueue *wq);
+
+int workqueue_enqueue(struct workqueue *wq, struct io_u *io_u);
+void workqueue_flush(struct workqueue *wq);
+
+#endif
