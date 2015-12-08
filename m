Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbbLHNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Dec 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a5wHk-0000io-4g
	for fio@vger.kernel.org; Mon, 07 Dec 2015 13:57:00 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151208130002.06E352C015D@kernel.dk>
Date: Tue,  8 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a6a3469ea8753a999b9bb9bea33299700d3094eb:

  workqueue: fix potential ABBA deadlock in stats summing (2015-12-04 13:15:36 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5bb79f69c2d9dc8542c25af96f040d1884230688:

  workqueue: remove knowledge of td queue state (2015-12-07 22:35:31 -0700)

----------------------------------------------------------------
Jens Axboe (13):
      crc/test: don't throw away results
      options: don't throw away bssplit() return value
      t/genzip: cast division to double
      init: have set_debug() check for NULL optarg
      workqueue: grab sw->lock for flag manipulation
      verify: fix header verification version check
      Fix stat summing for unified_rw_reporting
      Fix latency logging if disable_slat and disable_clat is set
      iolog: ensure we always store compressed, if log_store_compressed == 1
      workqueue: remove knowledge of io issue (and others) stats
      workqueue: don't use ioengine return codes
      workqueue: add a workqueue_work type
      workqueue: remove knowledge of td queue state

 backend.c   | 44 +++++++++++++++++++++++++++++++++++++++++---
 client.c    |  2 +-
 crc/test.c  | 12 ++++++------
 gclient.c   |  2 +-
 init.c      |  3 +++
 io_u.c      |  6 +++---
 ioengine.h  |  6 +++++-
 iolog.c     |  2 +-
 options.c   |  3 ++-
 stat.c      | 31 +++++++++++++++++++------------
 stat.h      |  2 +-
 t/genzipf.c |  2 +-
 verify.c    |  2 +-
 workqueue.c | 46 ++++++++++++++++------------------------------
 workqueue.h | 34 ++++++++++++++++++++++++++++++----
 15 files changed, 131 insertions(+), 66 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 10622ef..bc2e3eb 100644
--- a/backend.c
+++ b/backend.c
@@ -928,9 +928,23 @@ static uint64_t do_io(struct thread_data *td)
 			log_io_piece(td, io_u);
 
 		if (td->o.io_submit_mode == IO_MODE_OFFLOAD) {
+			const unsigned long blen = io_u->xfer_buflen;
+			const enum fio_ddir ddir = acct_ddir(io_u);
+
 			if (td->error)
 				break;
-			ret = workqueue_enqueue(&td->io_wq, io_u);
+
+			ret = workqueue_enqueue(&td->io_wq, &io_u->work);
+			if (ret)
+				ret = FIO_Q_QUEUED;
+			else
+				ret = FIO_Q_BUSY;
+
+			if (ret == FIO_Q_QUEUED && ddir_rw(ddir)) {
+				td->io_issues[ddir]++;
+				td->io_issue_bytes[ddir] += blen;
+				td->rate_io_issue_bytes[ddir] += blen;
+			}
 
 			if (should_check_rate(td))
 				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
@@ -1347,8 +1361,9 @@ static uint64_t do_dry_run(struct thread_data *td)
 	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
-static void io_workqueue_fn(struct thread_data *td, struct io_u *io_u)
+static void io_workqueue_fn(struct thread_data *td, struct workqueue_work *work)
 {
+	struct io_u *io_u = container_of(work, struct io_u, work);
 	const enum fio_ddir ddir = io_u->ddir;
 	int ret;
 
@@ -1392,6 +1407,29 @@ static void io_workqueue_fn(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
+static bool io_workqueue_pre_sleep_flush_fn(struct thread_data *td)
+{
+	if (td->io_u_queued || td->cur_depth || td->io_u_in_flight)
+		return true;
+
+	return false;
+}
+
+static void io_workqueue_pre_sleep_fn(struct thread_data *td)
+{
+	int ret;
+
+	ret = io_u_quiesce(td);
+	if (ret > 0)
+		td->cur_depth -= ret;
+}
+
+struct workqueue_ops rated_wq_ops = {
+	.fn			= io_workqueue_fn,
+	.pre_sleep_flush_fn	= io_workqueue_pre_sleep_flush_fn,
+	.pre_sleep_fn		= io_workqueue_pre_sleep_fn,
+};
+
 /*
  * Entry point for the thread based jobs. The process based jobs end up
  * here as well, after a little setup.
@@ -1590,7 +1628,7 @@ static void *thread_main(void *data)
 	fio_verify_init(td);
 
 	if ((o->io_submit_mode == IO_MODE_OFFLOAD) &&
-	    workqueue_init(td, &td->io_wq, io_workqueue_fn, td->o.iodepth))
+	    workqueue_init(td, &td->io_wq, &rated_wq_ops, td->o.iodepth))
 		goto err;
 
 	fio_gettime(&td->epoch, NULL);
diff --git a/client.c b/client.c
index db472c4..2cba8a0 100644
--- a/client.c
+++ b/client.c
@@ -946,7 +946,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	if (sum_stat_clients <= 1)
 		return;
 
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr);
+	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
 	sum_group_stats(&client_gs, &p->rs);
 
 	client_ts.members++;
diff --git a/crc/test.c b/crc/test.c
index 05ea73e..213b5d5 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -68,7 +68,7 @@ static void t_crc64(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc64(buf, size);
+		t->output += fio_crc64(buf, size);
 }
 
 static void t_crc32(struct test_type *t, void *buf, size_t size)
@@ -76,7 +76,7 @@ static void t_crc32(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc32(buf, size);
+		t->output += fio_crc32(buf, size);
 }
 
 static void t_crc32c(struct test_type *t, void *buf, size_t size)
@@ -84,7 +84,7 @@ static void t_crc32c(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc32c(buf, size);
+		t->output += fio_crc32c(buf, size);
 }
 
 static void t_crc16(struct test_type *t, void *buf, size_t size)
@@ -92,7 +92,7 @@ static void t_crc16(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc16(buf, size);
+		t->output += fio_crc16(buf, size);
 }
 
 static void t_crc7(struct test_type *t, void *buf, size_t size)
@@ -100,7 +100,7 @@ static void t_crc7(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		fio_crc7(buf, size);
+		t->output += fio_crc7(buf, size);
 }
 
 static void t_sha1(struct test_type *t, void *buf, size_t size)
@@ -148,7 +148,7 @@ static void t_murmur3(struct test_type *t, void *buf, size_t size)
 	int i;
 
 	for (i = 0; i < NR_CHUNKS; i++)
-		murmurhash3(buf, size, 0x8989);
+		t->output += murmurhash3(buf, size, 0x8989);
 }
 
 static void t_jhash(struct test_type *t, void *buf, size_t size)
diff --git a/gclient.c b/gclient.c
index d7d9616..17af38a 100644
--- a/gclient.c
+++ b/gclient.c
@@ -296,7 +296,7 @@ static void gfio_thread_status_op(struct fio_client *client,
 	if (sum_stat_clients == 1)
 		return;
 
-	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr);
+	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
 	sum_group_stats(&client_gs, &p->rs);
 
 	client_ts.members++;
diff --git a/init.c b/init.c
index 353cc2b..0100da2 100644
--- a/init.c
+++ b/init.c
@@ -1899,6 +1899,9 @@ static int set_debug(const char *string)
 	char *opt;
 	int i;
 
+	if (!string)
+		return 0;
+
 	if (!strcmp(string, "?") || !strcmp(string, "help")) {
 		log_info("fio: dumping debug options:");
 		for (i = 0; debug_levels[i].name; i++) {
diff --git a/io_u.c b/io_u.c
index f86367b..9628d5e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1559,7 +1559,7 @@ struct io_u *get_io_u(struct thread_data *td)
 out:
 	assert(io_u->file);
 	if (!td_io_prep(td, io_u)) {
-		if (!td->o.disable_slat)
+		if (!td->o.disable_lat)
 			fio_gettime(&io_u->start_time, NULL);
 		if (do_scramble)
 			small_content_scramble(io_u);
@@ -1605,8 +1605,8 @@ void io_u_log_error(struct thread_data *td, struct io_u *io_u)
 
 static inline bool gtod_reduce(struct thread_data *td)
 {
-	return td->o.disable_clat && td->o.disable_lat && td->o.disable_slat
-		&& td->o.disable_bw;
+	return (td->o.disable_clat && td->o.disable_slat && td->o.disable_bw)
+			|| td->o.gtod_reduce;
 }
 
 static void account_io_completion(struct thread_data *td, struct io_u *io_u,
diff --git a/ioengine.h b/ioengine.h
index 37f0336..6734c7b 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -7,6 +7,7 @@
 #include "io_ddir.h"
 #include "debug.h"
 #include "file.h"
+#include "workqueue.h"
 
 #ifdef CONFIG_LIBAIO
 #include <libaio.h>
@@ -89,7 +90,10 @@ struct io_u {
 		void *engine_data;
 	};
 
-	struct flist_head verify_list;
+	union {
+		struct flist_head verify_list;
+		struct workqueue_work work;
+	};
 
 	/*
 	 * Callback for io completion
diff --git a/iolog.c b/iolog.c
index 82b2b8a..d7c8a45 100644
--- a/iolog.c
+++ b/iolog.c
@@ -594,7 +594,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 
 	if (l->log_gz && !p->td)
 		l->log_gz = 0;
-	else if (l->log_gz) {
+	else if (l->log_gz || l->log_gz_store) {
 		pthread_mutex_init(&l->chunk_lock, NULL);
 		p->td->flags |= TD_F_COMPRESS_LOG;
 	}
diff --git a/options.c b/options.c
index a61606c..1886b23 100644
--- a/options.c
+++ b/options.c
@@ -204,7 +204,8 @@ static int str_bssplit_cb(void *data, const char *input)
 			ret = bssplit_ddir(&td->o, DDIR_TRIM, op);
 			free(op);
 		}
-		ret = bssplit_ddir(&td->o, DDIR_READ, str);
+		if (!ret)
+			ret = bssplit_ddir(&td->o, DDIR_READ, str);
 	}
 
 	free(p);
diff --git a/stat.c b/stat.c
index e5ec223..818756d 100644
--- a/stat.c
+++ b/stat.c
@@ -1253,7 +1253,7 @@ struct json_object *show_thread_status(struct thread_stat *ts,
 	return ret;
 }
 
-static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
+static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
 {
 	double mean, S;
 
@@ -1268,7 +1268,7 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
 	 * <http://en.wikipedia.org/wiki/Algorithms_for_calculating_variance
 	 *  #Parallel_algorithm>
 	 */
-	if (nr == 1) {
+	if (first) {
 		mean = src->mean.u.f;
 		S = src->S.u.f;
 	} else {
@@ -1312,31 +1312,38 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->unit_base = src->unit_base;
 }
 
-void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr)
+void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
+		      bool first)
 {
 	int l, k;
 
 	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
 		if (!dst->unified_rw_rep) {
-			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], nr);
-			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], nr);
-			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], nr);
-			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], nr);
+			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first);
+			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first);
+			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first);
+			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first);
 
 			dst->io_bytes[l] += src->io_bytes[l];
 
 			if (dst->runtime[l] < src->runtime[l])
 				dst->runtime[l] = src->runtime[l];
 		} else {
-			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], nr);
-			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], nr);
-			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], nr);
-			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], nr);
+			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first);
+			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first);
+			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first);
+			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first);
 
 			dst->io_bytes[0] += src->io_bytes[l];
 
 			if (dst->runtime[0] < src->runtime[l])
 				dst->runtime[0] = src->runtime[l];
+
+			/*
+			 * We're summing to the same destination, so override
+			 * 'first' after the first iteration of the loop
+			 */
+			first = false;
 		}
 	}
 
@@ -1531,7 +1538,7 @@ void __show_run_stats(void)
 		for (k = 0; k < ts->nr_block_infos; k++)
 			ts->block_infos[k] = td->ts.block_infos[k];
 
-		sum_thread_stats(ts, &td->ts, idx);
+		sum_thread_stats(ts, &td->ts, idx == 1);
 	}
 
 	for (i = 0; i < nr_ts; i++) {
diff --git a/stat.h b/stat.h
index 0fc5533..33afd9b 100644
--- a/stat.h
+++ b/stat.h
@@ -256,7 +256,7 @@ extern void __show_run_stats(void);
 extern void __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
-extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr);
+extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, bool first);
 extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
diff --git a/t/genzipf.c b/t/genzipf.c
index ff0729e..d8253c3 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -227,7 +227,7 @@ static void output_normal(struct node *nodes, unsigned long nnodes,
 
 		if (percentage) {
 			if (total_vals >= blocks) {
-				double cs = i * block_size / (1024 * 1024);
+				double cs = (double) i * block_size / (1024.0 * 1024.0);
 				char p = 'M';
 
 				if (cs > 1024.0) {
diff --git a/verify.c b/verify.c
index 19bec75..268c060 100644
--- a/verify.c
+++ b/verify.c
@@ -1603,7 +1603,7 @@ int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s,
 	hdr->size = le64_to_cpu(hdr->size);
 	hdr->crc = le64_to_cpu(hdr->crc);
 
-	if (hdr->version != VSTATE_HDR_VERSION ||
+	if (hdr->version != VSTATE_HDR_VERSION &&
 	    hdr->version != VSTATE_HDR_VERSION_V1)
 		return 1;
 
diff --git a/workqueue.c b/workqueue.c
index 7cd83bf..54761b0 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -7,7 +7,6 @@
 #include <unistd.h>
 
 #include "fio.h"
-#include "ioengine.h"
 #include "flist.h"
 #include "workqueue.h"
 #include "lib/getrusage.h"
@@ -110,45 +109,36 @@ void workqueue_flush(struct workqueue *wq)
 }
 
 /*
- * Must be serialized by caller.
+ * Must be serialized by caller. Returns true for queued, false for busy.
  */
-int workqueue_enqueue(struct workqueue *wq, struct io_u *io_u)
+bool workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work)
 {
 	struct submit_worker *sw;
 
 	sw = get_submit_worker(wq);
 	if (sw) {
-		const enum fio_ddir ddir = acct_ddir(io_u);
-		struct thread_data *parent = wq->td;
-
-		if (ddir_rw(ddir)) {
-			parent->io_issues[ddir]++;
-			parent->io_issue_bytes[ddir] += io_u->xfer_buflen;
-			parent->rate_io_issue_bytes[ddir] += io_u->xfer_buflen;
-		}
-
 		pthread_mutex_lock(&sw->lock);
-		flist_add_tail(&io_u->verify_list, &sw->work_list);
+		flist_add_tail(&work->list, &sw->work_list);
 		sw->seq = ++wq->work_seq;
 		sw->flags &= ~SW_F_IDLE;
 		pthread_mutex_unlock(&sw->lock);
 
 		pthread_cond_signal(&sw->cond);
-		return FIO_Q_QUEUED;
+		return true;
 	}
 
-	return FIO_Q_BUSY;
+	return false;
 }
 
 static void handle_list(struct submit_worker *sw, struct flist_head *list)
 {
 	struct workqueue *wq = sw->wq;
-	struct io_u *io_u;
+	struct workqueue_work *work;
 
 	while (!flist_empty(list)) {
-		io_u = flist_first_entry(list, struct io_u, verify_list);
-		flist_del_init(&io_u->verify_list);
-		wq->fn(&sw->td, io_u);
+		work = flist_first_entry(list, struct workqueue_work, list);
+		flist_del_init(&work->list);
+		wq->ops.fn(&sw->td, work);
 	}
 }
 
@@ -270,7 +260,6 @@ static void *worker_thread(void *data)
 {
 	struct submit_worker *sw = data;
 	struct workqueue *wq = sw->wq;
-	struct thread_data *td = &sw->td;
 	unsigned int eflags = 0, ret;
 	FLIST_HEAD(local_list);
 
@@ -297,14 +286,9 @@ static void *worker_thread(void *data)
 				break;
 			}
 
-			if (td->io_u_queued || td->cur_depth ||
-			    td->io_u_in_flight) {
-				int ret;
-
+			if (workqueue_pre_sleep_check(wq)) {
 				pthread_mutex_unlock(&sw->lock);
-				ret = io_u_quiesce(td);
-				if (ret > 0)
-					td->cur_depth -= ret;
+				workqueue_pre_sleep(wq);
 				pthread_mutex_lock(&sw->lock);
 			}
 
@@ -363,7 +347,7 @@ static void shutdown_worker(struct submit_worker *sw, unsigned int *sum_cnt)
 
 	pthread_join(sw->thread, NULL);
 	(*sum_cnt)++;
-	sum_thread_stats(&parent->ts, &sw->td.ts, *sum_cnt);
+	sum_thread_stats(&parent->ts, &sw->td.ts, *sum_cnt == 1);
 	free_worker(sw);
 }
 
@@ -388,7 +372,9 @@ void workqueue_exit(struct workqueue *wq)
 			sw = &wq->workers[i];
 			if (sw->flags & SW_F_ACCOUNTED)
 				continue;
+			pthread_mutex_lock(&sw->lock);
 			sw->flags |= SW_F_ACCOUNTED;
+			pthread_mutex_unlock(&sw->lock);
 			shutdown_worker(sw, &sum_cnt);
 			shutdown++;
 		}
@@ -424,14 +410,14 @@ static int start_worker(struct workqueue *wq, unsigned int index)
 }
 
 int workqueue_init(struct thread_data *td, struct workqueue *wq,
-		   workqueue_fn *fn, unsigned max_pending)
+		   struct workqueue_ops *ops, unsigned max_pending)
 {
 	unsigned int running;
 	int i, error;
 
 	wq->max_workers = max_pending;
 	wq->td = td;
-	wq->fn = fn;
+	wq->ops = *ops;
 	wq->work_seq = 0;
 	wq->next_free_worker = 0;
 	pthread_cond_init(&wq->flush_cond, NULL);
diff --git a/workqueue.h b/workqueue.h
index 4e92449..837b221 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -3,13 +3,25 @@
 
 #include "flist.h"
 
-typedef void (workqueue_fn)(struct thread_data *, struct io_u *);
+struct workqueue_work {
+	struct flist_head list;
+};
+
+typedef void (workqueue_work_fn)(struct thread_data *, struct workqueue_work *);
+typedef bool (workqueue_pre_sleep_flush_fn)(struct thread_data *);
+typedef void (workqueue_pre_sleep_fn)(struct thread_data *);
+
+struct workqueue_ops {
+	workqueue_work_fn *fn;
+	workqueue_pre_sleep_flush_fn *pre_sleep_flush_fn;
+	workqueue_pre_sleep_fn *pre_sleep_fn;
+};
 
 struct workqueue {
 	unsigned int max_workers;
 
 	struct thread_data *td;
-	workqueue_fn *fn;
+	struct workqueue_ops ops;
 
 	uint64_t work_seq;
 	struct submit_worker *workers;
@@ -21,10 +33,24 @@ struct workqueue {
 	volatile int wake_idle;
 };
 
-int workqueue_init(struct thread_data *td, struct workqueue *wq, workqueue_fn *fn, unsigned int max_workers);
+int workqueue_init(struct thread_data *td, struct workqueue *wq, struct workqueue_ops *ops, unsigned int max_workers);
 void workqueue_exit(struct workqueue *wq);
 
-int workqueue_enqueue(struct workqueue *wq, struct io_u *io_u);
+bool workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work);
 void workqueue_flush(struct workqueue *wq);
 
+static inline bool workqueue_pre_sleep_check(struct workqueue *wq)
+{
+	if (!wq->ops.pre_sleep_flush_fn)
+		return false;
+
+	return wq->ops.pre_sleep_flush_fn(wq->td);
+}
+
+static inline void workqueue_pre_sleep(struct workqueue *wq)
+{
+	if (wq->ops.pre_sleep_fn)
+		wq->ops.pre_sleep_fn(wq->td);
+}
+
 #endif
