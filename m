Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55793 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbbLINAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Dec 2015 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a6eLj-0003mG-W4
	for fio@vger.kernel.org; Wed, 09 Dec 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151209130002.955D12C015D@kernel.dk>
Date: Wed,  9 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5bb79f69c2d9dc8542c25af96f040d1884230688:

  workqueue: remove knowledge of td queue state (2015-12-07 22:35:31 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c08f9fe23b0f257f914b2d9e0e4f1117418e5da6:

  options: add log_compression_cpus option (2015-12-08 15:45:12 -0700)

----------------------------------------------------------------
Jens Axboe (21):
      workqueue: move 'td' private data to the workqueue user
      workqueue: move init worker private code to the caller
      workqueue: move private exit code to caller
      workqueue: move private accounting to caller
      workqueue: move last bits of end accounting to caller
      backend: move rated submit code to its own file
      workqueue: add nice support
      iolog: replace tp usage with workqueue
      workqueue: ensure that workqueue_enqueue() can't fail
      workqueue/rate-submit: update comments
      iolog: reinstate log compression nice level
      rate-submit: clean up init/exit helpers
      workqueue: make workqueue_exit() safe for multiple exit calls
      iolog: remember to destroy cond/lock when done
      iolog: cleanup data wait
      iolog: fix build with zlib not being installed
      iolog: fix potential duplicate definition of compress init/exit
      iolog: cleanup log writing
      iolog: cleanup up data unref'ing
      options: check for dryrun in cpu mask setting
      options: add log_compression_cpus option

 HOWTO            |  14 ++--
 Makefile         |   2 +-
 backend.c        |  94 ++-------------------
 cconv.c          |   2 +
 fio.1            |  12 ++-
 fio.h            |   6 +-
 iolog.c          | 152 +++++++++++++++++++++------------
 iolog.h          |   2 +
 lib/tp.c         | 119 --------------------------
 lib/tp.h         |  33 --------
 options.c        |  27 ++++++
 rate-submit.c    | 252 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 rate-submit.h    |   7 ++
 server.h         |   2 +-
 thread_options.h |   2 +
 workqueue.c      | 205 ++++++++++----------------------------------
 workqueue.h      |  71 ++++++++++++++--
 17 files changed, 534 insertions(+), 468 deletions(-)
 delete mode 100644 lib/tp.c
 delete mode 100644 lib/tp.h
 create mode 100644 rate-submit.c
 create mode 100644 rate-submit.h

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index a534aa8..eb9c824 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1580,11 +1580,15 @@ log_compression=int	If this is set, fio will compress the IO logs as
 		in the specified log file. This feature depends on the
 		availability of zlib.
 
-log_store_compressed=bool	If set, and log_compression is also set,
-		fio will store the log files in a compressed format. They
-		can be decompressed with fio, using the --inflate-log
-		command line parameter. The files will be stored with a
-		.fz suffix.
+log_compression_cpus=str	Define the set of CPUs that are allowed to
+		handle online log compression for the IO jobs. This can
+		provide better isolation between performance sensitive jobs,
+		and background compression work.
+
+log_store_compressed=bool	If set, fio will store the log files in a
+		compressed format. They can be decompressed with fio, using
+		the --inflate-log command line parameter. The files will be
+		stored with a .fz suffix.
 
 block_error_percentiles=bool	If set, record errors in trim block-sized
 		units from writes and trims and output a histogram of
diff --git a/Makefile b/Makefile
index 102cc69..2ff88a1 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		workqueue.c
+		workqueue.c rate-submit.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/backend.c b/backend.c
index bc2e3eb..ae26120 100644
--- a/backend.c
+++ b/backend.c
@@ -54,9 +54,9 @@
 #include "lib/getrusage.h"
 #include "idletime.h"
 #include "err.h"
-#include "lib/tp.h"
 #include "workqueue.h"
 #include "lib/mountcheck.h"
+#include "rate-submit.h"
 
 static pthread_t helper_thread;
 static pthread_mutex_t helper_lock;
@@ -934,13 +934,10 @@ static uint64_t do_io(struct thread_data *td)
 			if (td->error)
 				break;
 
-			ret = workqueue_enqueue(&td->io_wq, &io_u->work);
-			if (ret)
-				ret = FIO_Q_QUEUED;
-			else
-				ret = FIO_Q_BUSY;
+			workqueue_enqueue(&td->io_wq, &io_u->work);
+			ret = FIO_Q_QUEUED;
 
-			if (ret == FIO_Q_QUEUED && ddir_rw(ddir)) {
+			if (ddir_rw(ddir)) {
 				td->io_issues[ddir]++;
 				td->io_issue_bytes[ddir] += blen;
 				td->rate_io_issue_bytes[ddir] += blen;
@@ -1361,75 +1358,6 @@ static uint64_t do_dry_run(struct thread_data *td)
 	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
-static void io_workqueue_fn(struct thread_data *td, struct workqueue_work *work)
-{
-	struct io_u *io_u = container_of(work, struct io_u, work);
-	const enum fio_ddir ddir = io_u->ddir;
-	int ret;
-
-	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
-
-	io_u_set(io_u, IO_U_F_NO_FILE_PUT);
-
-	td->cur_depth++;
-
-	do {
-		ret = td_io_queue(td, io_u);
-		if (ret != FIO_Q_BUSY)
-			break;
-		ret = io_u_queued_complete(td, 1);
-		if (ret > 0)
-			td->cur_depth -= ret;
-		io_u_clear(io_u, IO_U_F_FLIGHT);
-	} while (1);
-
-	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
-
-	io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
-
-	if (ret == FIO_Q_COMPLETED)
-		td->cur_depth--;
-	else if (ret == FIO_Q_QUEUED) {
-		unsigned int min_evts;
-
-		if (td->o.iodepth == 1)
-			min_evts = 1;
-		else
-			min_evts = 0;
-
-		ret = io_u_queued_complete(td, min_evts);
-		if (ret > 0)
-			td->cur_depth -= ret;
-	} else if (ret == FIO_Q_BUSY) {
-		ret = io_u_queued_complete(td, td->cur_depth);
-		if (ret > 0)
-			td->cur_depth -= ret;
-	}
-}
-
-static bool io_workqueue_pre_sleep_flush_fn(struct thread_data *td)
-{
-	if (td->io_u_queued || td->cur_depth || td->io_u_in_flight)
-		return true;
-
-	return false;
-}
-
-static void io_workqueue_pre_sleep_fn(struct thread_data *td)
-{
-	int ret;
-
-	ret = io_u_quiesce(td);
-	if (ret > 0)
-		td->cur_depth -= ret;
-}
-
-struct workqueue_ops rated_wq_ops = {
-	.fn			= io_workqueue_fn,
-	.pre_sleep_flush_fn	= io_workqueue_pre_sleep_flush_fn,
-	.pre_sleep_fn		= io_workqueue_pre_sleep_fn,
-};
-
 /*
  * Entry point for the thread based jobs. The process based jobs end up
  * here as well, after a little setup.
@@ -1622,13 +1550,12 @@ static void *thread_main(void *data)
 			goto err;
 	}
 
-	if (td->flags & TD_F_COMPRESS_LOG)
-		tp_init(&td->tp_data);
+	if (iolog_compress_init(td))
+		goto err;
 
 	fio_verify_init(td);
 
-	if ((o->io_submit_mode == IO_MODE_OFFLOAD) &&
-	    workqueue_init(td, &td->io_wq, &rated_wq_ops, td->o.iodepth))
+	if (rate_submit_init(td))
 		goto err;
 
 	fio_gettime(&td->epoch, NULL);
@@ -1726,11 +1653,8 @@ static void *thread_main(void *data)
 
 	fio_writeout_logs(td);
 
-	if (o->io_submit_mode == IO_MODE_OFFLOAD)
-		workqueue_exit(&td->io_wq);
-
-	if (td->flags & TD_F_COMPRESS_LOG)
-		tp_exit(&td->tp_data);
+	iolog_compress_exit(td);
+	rate_submit_exit(td);
 
 	if (o->exec_postrun)
 		exec_string(o, o->exec_postrun, (const char *)"postrun");
diff --git a/cconv.c b/cconv.c
index c309578..c0168c4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -261,6 +261,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
+	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
 }
 
@@ -482,6 +483,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
+	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
 
 }
diff --git a/fio.1 b/fio.1
index 3cc353a..eab20d7 100644
--- a/fio.1
+++ b/fio.1
@@ -1427,11 +1427,15 @@ most of the system memory. So pick your poison. The IO logs are saved
 normally at the end of a run, by decompressing the chunks and storing them
 in the specified log file. This feature depends on the availability of zlib.
 .TP
+.BI log_compression_cpus \fR=\fPstr
+Define the set of CPUs that are allowed to handle online log compression
+for the IO jobs. This can provide better isolation between performance
+sensitive jobs, and background compression work.
+.TP
 .BI log_store_compressed \fR=\fPbool
-If set, and \fBlog\fR_compression is also set, fio will store the log files in
-a compressed format. They can be decompressed with fio, using the
-\fB\-\-inflate-log\fR command line parameter. The files will be stored with a
-\fB\.fz\fR suffix.
+If set, fio will store the log files in a compressed format. They can be
+decompressed with fio, using the \fB\-\-inflate-log\fR command line parameter.
+The files will be stored with a \fB\.fz\fR suffix.
 .TP
 .BI block_error_percentiles \fR=\fPbool
 If set, record errors in trim block-sized units from writes and trims and output
diff --git a/fio.h b/fio.h
index 2e13b54..6f85266 100644
--- a/fio.h
+++ b/fio.h
@@ -129,7 +129,7 @@ struct thread_data {
 	struct io_log *bw_log;
 	struct io_log *iops_log;
 
-	struct tp_data *tp_data;
+	struct workqueue log_compress_wq;
 
 	struct thread_data *parent;
 
@@ -565,6 +565,10 @@ extern int is_blktrace(const char *, int *);
 extern int load_blktrace(struct thread_data *, const char *, int);
 #endif
 
+extern int io_queue_event(struct thread_data *td, struct io_u *io_u, int *ret,
+		   enum fio_ddir ddir, uint64_t *bytes_issued, int from_verify,
+		   struct timeval *comp_time);
+
 /*
  * Latency target helpers
  */
diff --git a/iolog.c b/iolog.c
index d7c8a45..27d00ff 100644
--- a/iolog.c
+++ b/iolog.c
@@ -18,7 +18,6 @@
 #include "verify.h"
 #include "trim.h"
 #include "filelock.h"
-#include "lib/tp.h"
 
 static const char iolog_ver2[] = "fio version 2 iolog";
 
@@ -672,7 +671,12 @@ static void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 #ifdef CONFIG_ZLIB
 
 struct iolog_flush_data {
-	struct tp_work work;
+	struct workqueue_work work;
+	pthread_mutex_t lock;
+	pthread_cond_t cv;
+	int wait;
+	volatile int done;
+	volatile int refs;
 	struct io_log *log;
 	void *samples;
 	uint64_t nr_samples;
@@ -971,7 +975,7 @@ void flush_log(struct io_log *log, int do_append)
 
 static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 {
-	if (td->tp_data)
+	if (td->flags & TD_F_COMPRESS_LOG)
 		iolog_flush(log, 1);
 
 	if (trylock) {
@@ -992,12 +996,26 @@ static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 
 #ifdef CONFIG_ZLIB
 
+static void drop_data_unlock(struct iolog_flush_data *data)
+{
+	int refs;
+
+	refs = --data->refs;
+	pthread_mutex_unlock(&data->lock);
+
+	if (!refs) {
+		free(data);
+		pthread_mutex_destroy(&data->lock);
+		pthread_cond_destroy(&data->cv);
+	}
+}
+
 /*
  * Invoked from our compress helper thread, when logging would have exceeded
  * the specified memory limitation. Compresses the previously stored
  * entries.
  */
-static int gz_work(struct tp_work *work)
+static int gz_work(struct submit_worker *sw, struct workqueue_work *work)
 {
 	struct iolog_flush_data *data;
 	struct iolog_compress *c;
@@ -1078,12 +1096,14 @@ static int gz_work(struct tp_work *work)
 
 	ret = 0;
 done:
-	if (work->wait) {
-		work->done = 1;
-		pthread_cond_signal(&work->cv);
+	if (data->wait) {
+		pthread_mutex_lock(&data->lock);
+		data->done = 1;
+		pthread_cond_signal(&data->cv);
+
+		drop_data_unlock(data);
 	} else
 		free(data);
-
 	return ret;
 err:
 	while (!flist_empty(&list)) {
@@ -1095,6 +1115,44 @@ err:
 	goto done;
 }
 
+static int gz_init_worker(struct submit_worker *sw)
+{
+	struct thread_data *td = sw->wq->td;
+
+	if (!fio_option_is_set(&td->o, log_gz_cpumask))
+		return 0;
+
+	if (fio_setaffinity(gettid(), td->o.log_gz_cpumask) == -1) {
+		log_err("gz: failed to set CPU affinity\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static struct workqueue_ops log_compress_wq_ops = {
+	.fn		= gz_work,
+	.init_worker_fn	= gz_init_worker,
+	.nice	= 1,
+};
+
+int iolog_compress_init(struct thread_data *td)
+{
+	if (!(td->flags & TD_F_COMPRESS_LOG))
+		return 0;
+
+	workqueue_init(td, &td->log_compress_wq, &log_compress_wq_ops, 1);
+	return 0;
+}
+
+void iolog_compress_exit(struct thread_data *td)
+{
+	if (!(td->flags & TD_F_COMPRESS_LOG))
+		return;
+
+	workqueue_exit(&td->log_compress_wq);
+}
+
 /*
  * Queue work item to compress the existing log entries. We copy the
  * samples, and reset the log sample count to 0 (so the logging will
@@ -1103,7 +1161,6 @@ err:
  */
 int iolog_flush(struct io_log *log, int wait)
 {
-	struct tp_data *tdat = log->td->tp_data;
 	struct iolog_flush_data *data;
 	size_t sample_size;
 
@@ -1122,25 +1179,24 @@ int iolog_flush(struct io_log *log, int wait)
 
 	memcpy(data->samples, log->log, sample_size);
 	data->nr_samples = log->nr_samples;
-	data->work.fn = gz_work;
 	log->nr_samples = 0;
 
-	if (wait) {
-		pthread_mutex_init(&data->work.lock, NULL);
-		pthread_cond_init(&data->work.cv, NULL);
-		data->work.wait = 1;
-	} else
-		data->work.wait = 0;
+	data->wait = wait;
+	if (data->wait) {
+		pthread_mutex_init(&data->lock, NULL);
+		pthread_cond_init(&data->cv, NULL);
+		data->done = 0;
+		data->refs = 2;
+	}
 
-	data->work.prio = 1;
-	tp_queue_work(tdat, &data->work);
+	workqueue_enqueue(&log->td->log_compress_wq, &data->work);
 
 	if (wait) {
-		pthread_mutex_lock(&data->work.lock);
-		while (!data->work.done)
-			pthread_cond_wait(&data->work.cv, &data->work.lock);
-		pthread_mutex_unlock(&data->work.lock);
-		free(data);
+		pthread_mutex_lock(&data->lock);
+		while (!data->done)
+			pthread_cond_wait(&data->cv, &data->lock);
+
+		drop_data_unlock(data);
 	}
 
 	return 0;
@@ -1153,56 +1209,48 @@ int iolog_flush(struct io_log *log, int wait)
 	return 1;
 }
 
+int iolog_compress_init(struct thread_data *td)
+{
+	return 0;
+}
+
+void iolog_compress_exit(struct thread_data *td)
+{
+}
+
 #endif
 
-static int write_iops_log(struct thread_data *td, int try)
+static int __write_log(struct thread_data *td, struct io_log *log, int try)
 {
-	struct io_log *log = td->iops_log;
+	if (log)
+		return finish_log(td, log, try);
 
-	if (!log)
-		return 0;
+	return 0;
+}
 
-	return finish_log(td, log, try);
+static int write_iops_log(struct thread_data *td, int try)
+{
+	return __write_log(td, td->iops_log, try);
 }
 
 static int write_slat_log(struct thread_data *td, int try)
 {
-	struct io_log *log = td->slat_log;
-
-	if (!log)
-		return 0;
-
-	return finish_log(td, log, try);
+	return __write_log(td, td->slat_log, try);
 }
 
 static int write_clat_log(struct thread_data *td, int try)
 {
-	struct io_log *log = td->clat_log;
-
-	if (!log)
-		return 0;
-
-	return finish_log(td, log, try);
+	return __write_log(td, td->clat_log, try);
 }
 
 static int write_lat_log(struct thread_data *td, int try)
 {
-	struct io_log *log = td->lat_log;
-
-	if (!log)
-		return 0;
-
-	return finish_log(td, log, try);
+	return __write_log(td, td->lat_log, try);
 }
 
 static int write_bandw_log(struct thread_data *td, int try)
 {
-	struct io_log *log = td->bw_log;
-
-	if (!log)
-		return 0;
-
-	return finish_log(td, log, try);
+	return __write_log(td, td->bw_log, try);
 }
 
 enum {
diff --git a/iolog.h b/iolog.h
index eb5fdf3..6f027ca 100644
--- a/iolog.h
+++ b/iolog.h
@@ -184,6 +184,8 @@ extern void trim_io_piece(struct thread_data *, const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
+extern int iolog_compress_init(struct thread_data *);
+extern void iolog_compress_exit(struct thread_data *);
 
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);
diff --git a/lib/tp.c b/lib/tp.c
deleted file mode 100644
index 7462f5b..0000000
--- a/lib/tp.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * Basic workqueue like code, that sets up a thread and allows async
- * processing of some sort. Could be extended to allow for multiple
- * worker threads. But right now fio associates one of this per IO
- * thread, so should be enough to have just a single thread doing the
- * work.
- */
-#include <stdio.h>
-#include <stdlib.h>
-#include <stdarg.h>
-#include <unistd.h>
-#include <errno.h>
-#include <pthread.h>
-#include <string.h>
-
-#include "../smalloc.h"
-#include "../log.h"
-#include "tp.h"
-
-static void tp_flush_work(struct flist_head *list)
-{
-	struct tp_work *work;
-
-	while (!flist_empty(list)) {
-		int prio;
-
-		work = flist_entry(list->next, struct tp_work, list);
-		flist_del(&work->list);
-
-		prio = work->prio;
-		if (nice(prio) < 0)
-			log_err("fio: nice %s\n", strerror(errno));
-
-		work->fn(work);
-
-		if (nice(prio) < 0)
-			log_err("fio: nice %s\n", strerror(errno));
-	}
-}
-
-static void *tp_thread(void *data)
-{
-	struct tp_data *tdat = data;
-	struct flist_head work_list;
-
-	INIT_FLIST_HEAD(&work_list);
-
-	while (1) {
-		pthread_mutex_lock(&tdat->lock);
-
-		if (!tdat->thread_exit && flist_empty(&tdat->work))
-			pthread_cond_wait(&tdat->cv, &tdat->lock);
-
-		if (!flist_empty(&tdat->work))
-			flist_splice_tail_init(&tdat->work, &work_list);
-
-		pthread_mutex_unlock(&tdat->lock);
-
-		if (flist_empty(&work_list)) {
-			if (tdat->thread_exit)
-				break;
-			continue;
-		}
-
-		tp_flush_work(&work_list);
-	}
-
-	return NULL;
-}
-
-void tp_queue_work(struct tp_data *tdat, struct tp_work *work)
-{
-	work->done = 0;
-
-	pthread_mutex_lock(&tdat->lock);
-	flist_add_tail(&work->list, &tdat->work);
-	pthread_mutex_unlock(&tdat->lock);
-
-	pthread_cond_signal(&tdat->cv);
-}
-
-void tp_init(struct tp_data **tdatp)
-{
-	struct tp_data *tdat;
-	int ret;
-
-	if (*tdatp)
-		return;
-
-	*tdatp = tdat = smalloc(sizeof(*tdat));
-	pthread_mutex_init(&tdat->lock, NULL);
-	INIT_FLIST_HEAD(&tdat->work);
-	pthread_cond_init(&tdat->cv, NULL);
-	pthread_cond_init(&tdat->sleep_cv, NULL);
-
-	ret = pthread_create(&tdat->thread, NULL, tp_thread, tdat);
-	if (ret)
-		log_err("fio: failed to create tp thread\n");
-}
-
-void tp_exit(struct tp_data **tdatp)
-{
-	struct tp_data *tdat = *tdatp;
-	void *ret;
-
-	if (!tdat)
-		return;
-
-	pthread_mutex_lock(&tdat->lock);
-	tdat->thread_exit = 1;
-	pthread_mutex_unlock(&tdat->lock);
-
-	pthread_cond_signal(&tdat->cv);
-
-	pthread_join(tdat->thread, &ret);
-
-	sfree(tdat);
-	*tdatp = NULL;
-}
diff --git a/lib/tp.h b/lib/tp.h
deleted file mode 100644
index 9147cc2..0000000
--- a/lib/tp.h
+++ /dev/null
@@ -1,33 +0,0 @@
-#ifndef FIO_TP_H
-#define FIO_TP_H
-
-#include "../flist.h"
-
-struct tp_work;
-typedef int (tp_work_fn)(struct tp_work *);
-
-struct tp_work {
-	struct flist_head list;
-	tp_work_fn *fn;
-	int wait;
-	int prio;
-	pthread_cond_t cv;
-	pthread_mutex_t lock;
-	volatile int done;
-};
-
-struct tp_data {
-	pthread_t thread;
-	pthread_cond_t cv;
-	pthread_mutex_t lock;
-	struct flist_head work;
-	volatile int thread_exit;
-	pthread_cond_t sleep_cv;
-	volatile int sleeping;
-};
-
-extern void tp_init(struct tp_data **);
-extern void tp_exit(struct tp_data **);
-extern void tp_queue_work(struct tp_data *, struct tp_work *);
-
-#endif
diff --git a/options.c b/options.c
index 1886b23..627029c 100644
--- a/options.c
+++ b/options.c
@@ -530,8 +530,22 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
 
+	if (parse_dryrun())
+		return 0;
+
 	return set_cpus_allowed(td, &td->o.verify_cpumask, input);
 }
+
+static int str_log_cpus_allowed_cb(void *data, const char *input)
+{
+	struct thread_data *td = data;
+
+	if (parse_dryrun())
+		return 0;
+
+	return set_cpus_allowed(td, &td->o.log_gz_cpumask, input);
+}
+
 #endif
 
 #ifdef CONFIG_LIBNUMA
@@ -3226,6 +3240,19 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_LOG,
 		.group	= FIO_OPT_G_INVALID,
 	},
+#ifdef FIO_HAVE_CPU_AFFINITY
+	{
+		.name	= "log_compression_cpus",
+		.lname	= "Log Compression CPUs",
+		.type	= FIO_OPT_STR,
+		.cb	= str_log_cpus_allowed_cb,
+		.off1	= td_var_offset(log_gz_cpumask),
+		.parent = "log_compression",
+		.help	= "Limit log compression to these CPUs",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+#endif
 	{
 		.name	= "log_store_compressed",
 		.lname	= "Log store compressed",
diff --git a/rate-submit.c b/rate-submit.c
new file mode 100644
index 0000000..39b552d
--- /dev/null
+++ b/rate-submit.c
@@ -0,0 +1,252 @@
+/*
+ * Rated submission helpers
+ *
+ * Copyright (C) 2015 Jens Axboe <axboe@kernel.dk>
+ *
+ */
+#include "fio.h"
+#include "ioengine.h"
+#include "lib/getrusage.h"
+
+static int io_workqueue_fn(struct submit_worker *sw,
+			   struct workqueue_work *work)
+{
+	struct io_u *io_u = container_of(work, struct io_u, work);
+	const enum fio_ddir ddir = io_u->ddir;
+	struct thread_data *td = sw->private;
+	int ret;
+
+	dprint(FD_RATE, "io_u %p queued by %u\n", io_u, gettid());
+
+	io_u_set(io_u, IO_U_F_NO_FILE_PUT);
+
+	td->cur_depth++;
+
+	do {
+		ret = td_io_queue(td, io_u);
+		if (ret != FIO_Q_BUSY)
+			break;
+		ret = io_u_queued_complete(td, 1);
+		if (ret > 0)
+			td->cur_depth -= ret;
+		io_u_clear(io_u, IO_U_F_FLIGHT);
+	} while (1);
+
+	dprint(FD_RATE, "io_u %p ret %d by %u\n", io_u, ret, gettid());
+
+	io_queue_event(td, io_u, &ret, ddir, NULL, 0, NULL);
+
+	if (ret == FIO_Q_COMPLETED)
+		td->cur_depth--;
+	else if (ret == FIO_Q_QUEUED) {
+		unsigned int min_evts;
+
+		if (td->o.iodepth == 1)
+			min_evts = 1;
+		else
+			min_evts = 0;
+
+		ret = io_u_queued_complete(td, min_evts);
+		if (ret > 0)
+			td->cur_depth -= ret;
+	} else if (ret == FIO_Q_BUSY) {
+		ret = io_u_queued_complete(td, td->cur_depth);
+		if (ret > 0)
+			td->cur_depth -= ret;
+	}
+
+	return 0;
+}
+
+static bool io_workqueue_pre_sleep_flush_fn(struct submit_worker *sw)
+{
+	struct thread_data *td = sw->private;
+
+	if (td->io_u_queued || td->cur_depth || td->io_u_in_flight)
+		return true;
+
+	return false;
+}
+
+static void io_workqueue_pre_sleep_fn(struct submit_worker *sw)
+{
+	struct thread_data *td = sw->private;
+	int ret;
+
+	ret = io_u_quiesce(td);
+	if (ret > 0)
+		td->cur_depth -= ret;
+}
+
+static int io_workqueue_alloc_fn(struct submit_worker *sw)
+{
+	struct thread_data *td;
+
+	td = calloc(1, sizeof(*td));
+	sw->private = td;
+	return 0;
+}
+
+static void io_workqueue_free_fn(struct submit_worker *sw)
+{
+	free(sw->private);
+	sw->private = NULL;
+}
+
+static int io_workqueue_init_worker_fn(struct submit_worker *sw)
+{
+	struct thread_data *parent = sw->wq->td;
+	struct thread_data *td = sw->private;
+	int fio_unused ret;
+
+	memcpy(&td->o, &parent->o, sizeof(td->o));
+	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
+	td->o.uid = td->o.gid = -1U;
+	dup_files(td, parent);
+	td->eo = parent->eo;
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
+	clear_io_state(td, 1);
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
+
+}
+
+static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
+					unsigned int *sum_cnt)
+{
+	struct thread_data *td = sw->private;
+
+	(*sum_cnt)++;
+	sum_thread_stats(&sw->wq->td->ts, &td->ts, *sum_cnt == 1);
+
+	fio_options_free(td);
+	close_and_free_files(td);
+	if (td->io_ops)
+		close_ioengine(td);
+	td_set_runstate(td, TD_EXITED);
+}
+
+#ifdef CONFIG_SFAA
+static void sum_val(uint64_t *dst, uint64_t *src)
+{
+	if (*src) {
+		__sync_fetch_and_add(dst, *src);
+		*src = 0;
+	}
+}
+#else
+static void sum_val(uint64_t *dst, uint64_t *src)
+{
+	if (*src) {
+		*dst += *src;
+		*src = 0;
+	}
+}
+#endif
+
+static void pthread_double_unlock(pthread_mutex_t *lock1,
+				  pthread_mutex_t *lock2)
+{
+#ifndef CONFIG_SFAA
+	pthread_mutex_unlock(lock1);
+	pthread_mutex_unlock(lock2);
+#endif
+}
+
+static void pthread_double_lock(pthread_mutex_t *lock1, pthread_mutex_t *lock2)
+{
+#ifndef CONFIG_SFAA
+	if (lock1 < lock2) {
+		pthread_mutex_lock(lock1);
+		pthread_mutex_lock(lock2);
+	} else {
+		pthread_mutex_lock(lock2);
+		pthread_mutex_lock(lock1);
+	}
+#endif
+}
+
+static void sum_ddir(struct thread_data *dst, struct thread_data *src,
+		     enum fio_ddir ddir)
+{
+	pthread_double_lock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
+
+	sum_val(&dst->io_bytes[ddir], &src->io_bytes[ddir]);
+	sum_val(&dst->io_blocks[ddir], &src->io_blocks[ddir]);
+	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
+	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
+	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
+
+	pthread_double_unlock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
+}
+
+static void io_workqueue_update_acct_fn(struct submit_worker *sw)
+{
+	struct thread_data *src = sw->private;
+	struct thread_data *dst = sw->wq->td;
+
+	if (td_read(src))
+		sum_ddir(dst, src, DDIR_READ);
+	if (td_write(src))
+		sum_ddir(dst, src, DDIR_WRITE);
+	if (td_trim(src))
+		sum_ddir(dst, src, DDIR_TRIM);
+
+}
+
+static struct workqueue_ops rated_wq_ops = {
+	.fn			= io_workqueue_fn,
+	.pre_sleep_flush_fn	= io_workqueue_pre_sleep_flush_fn,
+	.pre_sleep_fn		= io_workqueue_pre_sleep_fn,
+	.update_acct_fn		= io_workqueue_update_acct_fn,
+	.alloc_worker_fn	= io_workqueue_alloc_fn,
+	.free_worker_fn		= io_workqueue_free_fn,
+	.init_worker_fn		= io_workqueue_init_worker_fn,
+	.exit_worker_fn		= io_workqueue_exit_worker_fn,
+};
+
+int rate_submit_init(struct thread_data *td)
+{
+	if (td->o.io_submit_mode != IO_MODE_OFFLOAD)
+		return 0;
+
+	return workqueue_init(td, &td->io_wq, &rated_wq_ops, td->o.iodepth);
+}
+
+void rate_submit_exit(struct thread_data *td)
+{
+	if (td->o.io_submit_mode != IO_MODE_OFFLOAD)
+		return;
+
+	workqueue_exit(&td->io_wq);
+}
diff --git a/rate-submit.h b/rate-submit.h
new file mode 100644
index 0000000..b4ca129
--- /dev/null
+++ b/rate-submit.h
@@ -0,0 +1,7 @@
+#ifndef FIO_RATE_SUBMIT
+#define FIO_RATE_SUBMIT
+
+int rate_submit_init(struct thread_data *);
+void rate_submit_exit(struct thread_data *);
+
+#endif
diff --git a/server.h b/server.h
index 6709b5f..6370c50 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 48,
+	FIO_SERVER_VER			= 49,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 567df81..f9c1562 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -170,6 +170,7 @@ struct thread_options {
 	unsigned int numjobs;
 	os_cpu_mask_t cpumask;
 	os_cpu_mask_t verify_cpumask;
+	os_cpu_mask_t log_gz_cpumask;
 	unsigned int cpus_allowed_policy;
 	char *numa_cpunodes;
 	unsigned short numa_mem_mode;
@@ -415,6 +416,7 @@ struct thread_options_pack {
 	uint32_t numjobs;
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
+	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
diff --git a/workqueue.c b/workqueue.c
index 54761b0..5fd95b9 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -1,5 +1,5 @@
 /*
- * Rated submission helpers
+ * Generic workqueue offload mechanism
  *
  * Copyright (C) 2015 Jens Axboe <axboe@kernel.dk>
  *
@@ -9,19 +9,6 @@
 #include "fio.h"
 #include "flist.h"
 #include "workqueue.h"
-#include "lib/getrusage.h"
-
-struct submit_worker {
-	pthread_t thread;
-	pthread_mutex_t lock;
-	pthread_cond_t cond;
-	struct flist_head work_list;
-	unsigned int flags;
-	unsigned int index;
-	uint64_t seq;
-	struct workqueue *wq;
-	struct thread_data td;
-};
 
 enum {
 	SW_F_IDLE	= 1 << 0,
@@ -111,23 +98,20 @@ void workqueue_flush(struct workqueue *wq)
 /*
  * Must be serialized by caller. Returns true for queued, false for busy.
  */
-bool workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work)
+void workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work)
 {
 	struct submit_worker *sw;
 
 	sw = get_submit_worker(wq);
-	if (sw) {
-		pthread_mutex_lock(&sw->lock);
-		flist_add_tail(&work->list, &sw->work_list);
-		sw->seq = ++wq->work_seq;
-		sw->flags &= ~SW_F_IDLE;
-		pthread_mutex_unlock(&sw->lock);
+	assert(sw);
 
-		pthread_cond_signal(&sw->cond);
-		return true;
-	}
+	pthread_mutex_lock(&sw->lock);
+	flist_add_tail(&work->list, &sw->work_list);
+	sw->seq = ++wq->work_seq;
+	sw->flags &= ~SW_F_IDLE;
+	pthread_mutex_unlock(&sw->lock);
 
-	return false;
+	pthread_cond_signal(&sw->cond);
 }
 
 static void handle_list(struct submit_worker *sw, struct flist_head *list)
@@ -138,132 +122,27 @@ static void handle_list(struct submit_worker *sw, struct flist_head *list)
 	while (!flist_empty(list)) {
 		work = flist_first_entry(list, struct workqueue_work, list);
 		flist_del_init(&work->list);
-		wq->ops.fn(&sw->td, work);
-	}
-}
-
-static int init_submit_worker(struct submit_worker *sw)
-{
-	struct thread_data *parent = sw->wq->td;
-	struct thread_data *td = &sw->td;
-	int fio_unused ret;
-
-	memcpy(&td->o, &parent->o, sizeof(td->o));
-	memcpy(&td->ts, &parent->ts, sizeof(td->ts));
-	td->o.uid = td->o.gid = -1U;
-	dup_files(td, parent);
-	td->eo = parent->eo;
-	fio_options_mem_dupe(td);
-
-	if (ioengine_load(td))
-		goto err;
-
-	if (td->o.odirect)
-		td->io_ops->flags |= FIO_RAWIO;
-
-	td->pid = gettid();
-
-	INIT_FLIST_HEAD(&td->io_log_list);
-	INIT_FLIST_HEAD(&td->io_hist_list);
-	INIT_FLIST_HEAD(&td->verify_list);
-	INIT_FLIST_HEAD(&td->trim_list);
-	INIT_FLIST_HEAD(&td->next_rand_list);
-	td->io_hist_tree = RB_ROOT;
-
-	td->o.iodepth = 1;
-	if (td_io_init(td))
-		goto err_io_init;
-
-	fio_gettime(&td->epoch, NULL);
-	fio_getrusage(&td->ru_start);
-	clear_io_state(td, 1);
-
-	td_set_runstate(td, TD_RUNNING);
-	td->flags |= TD_F_CHILD;
-	td->parent = parent;
-	return 0;
-
-err_io_init:
-	close_ioengine(td);
-err:
-	return 1;
-}
-
-#ifdef CONFIG_SFAA
-static void sum_val(uint64_t *dst, uint64_t *src)
-{
-	if (*src) {
-		__sync_fetch_and_add(dst, *src);
-		*src = 0;
-	}
-}
-#else
-static void sum_val(uint64_t *dst, uint64_t *src)
-{
-	if (*src) {
-		*dst += *src;
-		*src = 0;
+		wq->ops.fn(sw, work);
 	}
 }
-#endif
-
-static void pthread_double_unlock(pthread_mutex_t *lock1,
-				  pthread_mutex_t *lock2)
-{
-#ifndef CONFIG_SFAA
-	pthread_mutex_unlock(lock1);
-	pthread_mutex_unlock(lock2);
-#endif
-}
-
-static void pthread_double_lock(pthread_mutex_t *lock1, pthread_mutex_t *lock2)
-{
-#ifndef CONFIG_SFAA
-	if (lock1 < lock2) {
-		pthread_mutex_lock(lock1);
-		pthread_mutex_lock(lock2);
-	} else {
-		pthread_mutex_lock(lock2);
-		pthread_mutex_lock(lock1);
-	}
-#endif
-}
-
-static void sum_ddir(struct thread_data *dst, struct thread_data *src,
-		     enum fio_ddir ddir)
-{
-	pthread_double_lock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
-
-	sum_val(&dst->io_bytes[ddir], &src->io_bytes[ddir]);
-	sum_val(&dst->io_blocks[ddir], &src->io_blocks[ddir]);
-	sum_val(&dst->this_io_blocks[ddir], &src->this_io_blocks[ddir]);
-	sum_val(&dst->this_io_bytes[ddir], &src->this_io_bytes[ddir]);
-	sum_val(&dst->bytes_done[ddir], &src->bytes_done[ddir]);
-
-	pthread_double_unlock(&dst->io_wq.stat_lock, &src->io_wq.stat_lock);
-}
-
-static void update_accounting(struct submit_worker *sw)
-{
-	struct thread_data *src = &sw->td;
-	struct thread_data *dst = sw->wq->td;
-
-	if (td_read(src))
-		sum_ddir(dst, src, DDIR_READ);
-	if (td_write(src))
-		sum_ddir(dst, src, DDIR_WRITE);
-	if (td_trim(src))
-		sum_ddir(dst, src, DDIR_TRIM);
-}
 
 static void *worker_thread(void *data)
 {
 	struct submit_worker *sw = data;
 	struct workqueue *wq = sw->wq;
-	unsigned int eflags = 0, ret;
+	unsigned int eflags = 0, ret = 0;
 	FLIST_HEAD(local_list);
 
-	ret = init_submit_worker(sw);
+	if (wq->ops.nice) {
+		if (nice(wq->ops.nice) < 0) {
+			log_err("workqueue: nice %s\n", strerror(errno));
+			ret = 1;
+		}
+	}
+
+	if (!ret)
+		ret = workqueue_init_worker(sw);
+
 	pthread_mutex_lock(&sw->lock);
 	sw->flags |= SW_F_RUNNING;
 	if (ret)
@@ -286,9 +165,9 @@ static void *worker_thread(void *data)
 				break;
 			}
 
-			if (workqueue_pre_sleep_check(wq)) {
+			if (workqueue_pre_sleep_check(sw)) {
 				pthread_mutex_unlock(&sw->lock);
-				workqueue_pre_sleep(wq);
+				workqueue_pre_sleep(sw);
 				pthread_mutex_lock(&sw->lock);
 			}
 
@@ -308,7 +187,9 @@ static void *worker_thread(void *data)
 				if (wq->wake_idle)
 					pthread_cond_signal(&wq->flush_cond);
 			}
-			update_accounting(sw);
+			if (wq->ops.update_acct_fn)
+				wq->ops.update_acct_fn(sw);
+
 			pthread_cond_wait(&sw->cond, &sw->lock);
 		} else {
 handle_work:
@@ -318,7 +199,8 @@ handle_work:
 		handle_list(sw, &local_list);
 	}
 
-	update_accounting(sw);
+	if (wq->ops.update_acct_fn)
+		wq->ops.update_acct_fn(sw);
 
 done:
 	pthread_mutex_lock(&sw->lock);
@@ -327,28 +209,23 @@ done:
 	return NULL;
 }
 
-static void free_worker(struct submit_worker *sw)
+static void free_worker(struct submit_worker *sw, unsigned int *sum_cnt)
 {
-	struct thread_data *td = &sw->td;
+	struct workqueue *wq = sw->wq;
 
-	fio_options_free(td);
-	close_and_free_files(td);
-	if (td->io_ops)
-		close_ioengine(td);
-	td_set_runstate(td, TD_EXITED);
+	workqueue_exit_worker(sw, sum_cnt);
 
 	pthread_cond_destroy(&sw->cond);
 	pthread_mutex_destroy(&sw->lock);
+
+	if (wq->ops.free_worker_fn)
+		wq->ops.free_worker_fn(sw);
 }
 
 static void shutdown_worker(struct submit_worker *sw, unsigned int *sum_cnt)
 {
-	struct thread_data *parent = sw->wq->td;
-
 	pthread_join(sw->thread, NULL);
-	(*sum_cnt)++;
-	sum_thread_stats(&parent->ts, &sw->td.ts, *sum_cnt == 1);
-	free_worker(sw);
+	free_worker(sw, sum_cnt);
 }
 
 void workqueue_exit(struct workqueue *wq)
@@ -357,6 +234,9 @@ void workqueue_exit(struct workqueue *wq)
 	struct submit_worker *sw;
 	int i;
 
+	if (!wq->workers)
+		return;
+
 	for (i = 0; i < wq->max_workers; i++) {
 		sw = &wq->workers[i];
 
@@ -381,6 +261,7 @@ void workqueue_exit(struct workqueue *wq)
 	} while (shutdown && shutdown != wq->max_workers);
 
 	free(wq->workers);
+	wq->workers = NULL;
 	pthread_mutex_destroy(&wq->flush_lock);
 	pthread_cond_destroy(&wq->flush_cond);
 	pthread_mutex_destroy(&wq->stat_lock);
@@ -397,6 +278,12 @@ static int start_worker(struct workqueue *wq, unsigned int index)
 	sw->wq = wq;
 	sw->index = index;
 
+	if (wq->ops.alloc_worker_fn) {
+		ret = wq->ops.alloc_worker_fn(sw);
+		if (ret)
+			return ret;
+	}
+
 	ret = pthread_create(&sw->thread, NULL, worker_thread, sw);
 	if (!ret) {
 		pthread_mutex_lock(&sw->lock);
@@ -405,7 +292,7 @@ static int start_worker(struct workqueue *wq, unsigned int index)
 		return 0;
 	}
 
-	free_worker(sw);
+	free_worker(sw, NULL);
 	return 1;
 }
 
diff --git a/workqueue.h b/workqueue.h
index 837b221..46a3979 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -7,14 +7,41 @@ struct workqueue_work {
 	struct flist_head list;
 };
 
-typedef void (workqueue_work_fn)(struct thread_data *, struct workqueue_work *);
-typedef bool (workqueue_pre_sleep_flush_fn)(struct thread_data *);
-typedef void (workqueue_pre_sleep_fn)(struct thread_data *);
+struct submit_worker {
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t cond;
+	struct flist_head work_list;
+	unsigned int flags;
+	unsigned int index;
+	uint64_t seq;
+	struct workqueue *wq;
+	void *private;
+};
+
+typedef int (workqueue_work_fn)(struct submit_worker *, struct workqueue_work *);
+typedef bool (workqueue_pre_sleep_flush_fn)(struct submit_worker *);
+typedef void (workqueue_pre_sleep_fn)(struct submit_worker *);
+typedef int (workqueue_alloc_worker_fn)(struct submit_worker *);
+typedef void (workqueue_free_worker_fn)(struct submit_worker *);
+typedef int (workqueue_init_worker_fn)(struct submit_worker *);
+typedef void (workqueue_exit_worker_fn)(struct submit_worker *, unsigned int *);
+typedef void (workqueue_update_acct_fn)(struct submit_worker *);
 
 struct workqueue_ops {
 	workqueue_work_fn *fn;
 	workqueue_pre_sleep_flush_fn *pre_sleep_flush_fn;
 	workqueue_pre_sleep_fn *pre_sleep_fn;
+
+	workqueue_update_acct_fn *update_acct_fn;
+
+	workqueue_alloc_worker_fn *alloc_worker_fn;
+	workqueue_free_worker_fn *free_worker_fn;
+
+	workqueue_init_worker_fn *init_worker_fn;
+	workqueue_exit_worker_fn *exit_worker_fn;
+
+	unsigned int nice;
 };
 
 struct workqueue {
@@ -36,21 +63,49 @@ struct workqueue {
 int workqueue_init(struct thread_data *td, struct workqueue *wq, struct workqueue_ops *ops, unsigned int max_workers);
 void workqueue_exit(struct workqueue *wq);
 
-bool workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work);
+void workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work);
 void workqueue_flush(struct workqueue *wq);
 
-static inline bool workqueue_pre_sleep_check(struct workqueue *wq)
+static inline bool workqueue_pre_sleep_check(struct submit_worker *sw)
 {
+	struct workqueue *wq = sw->wq;
+
 	if (!wq->ops.pre_sleep_flush_fn)
 		return false;
 
-	return wq->ops.pre_sleep_flush_fn(wq->td);
+	return wq->ops.pre_sleep_flush_fn(sw);
 }
 
-static inline void workqueue_pre_sleep(struct workqueue *wq)
+static inline void workqueue_pre_sleep(struct submit_worker *sw)
 {
+	struct workqueue *wq = sw->wq;
+
 	if (wq->ops.pre_sleep_fn)
-		wq->ops.pre_sleep_fn(wq->td);
+		wq->ops.pre_sleep_fn(sw);
+}
+
+static inline int workqueue_init_worker(struct submit_worker *sw)
+{
+	struct workqueue *wq = sw->wq;
+
+	if (!wq->ops.init_worker_fn)
+		return 0;
+
+	return wq->ops.init_worker_fn(sw);
 }
 
+static inline void workqueue_exit_worker(struct submit_worker *sw,
+					 unsigned int *sum_cnt)
+{
+	struct workqueue *wq = sw->wq;
+	unsigned int tmp = 1;
+
+	if (!wq->ops.exit_worker_fn)
+		return;
+
+	if (!sum_cnt)
+		sum_cnt = &tmp;
+
+	wq->ops.exit_worker_fn(sw, sum_cnt);
+}
 #endif
