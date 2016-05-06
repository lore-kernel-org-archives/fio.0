Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbcEFMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 6 May 2016 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ayeQN-0000Lb-QX
	for fio@vger.kernel.org; Fri, 06 May 2016 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160506120002.7C13F2C00D8@kernel.dk>
Date: Fri,  6 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2078c1369f993b4d760d3fe1f90cb6ffa4389fe5:

  hash: import Linux sparse hash fix (2016-05-03 13:56:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 604577f1329b617d724d6712868d344a5adf5251:

  libfio: clear iops/bw sample times on stats reset (2016-05-05 10:55:47 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      iolog: fix use-after-free of iolog_flush_data
      iolog: don't use the workqueue for sync work
      iolog: free memory on gz init failure
      iolog: add define for default number of log entries
      libfio: clear iops/bw sample times on stats reset

 iolog.c  | 77 +++++++++++++++++-----------------------------------------------
 iolog.h  |  2 ++
 libfio.c |  2 ++
 3 files changed, 24 insertions(+), 57 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index feda9ed..94d3f3c 100644
--- a/iolog.c
+++ b/iolog.c
@@ -576,7 +576,7 @@ void setup_log(struct io_log **log, struct log_params *p,
 
 	l = calloc(1, sizeof(*l));
 	l->nr_samples = 0;
-	l->max_samples = 1024;
+	l->max_samples = DEF_LOG_ENTRIES;
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
 	l->log_gz = p->log_gz;
@@ -672,11 +672,6 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 
 struct iolog_flush_data {
 	struct workqueue_work work;
-	pthread_mutex_t lock;
-	pthread_cond_t cv;
-	int wait;
-	volatile int done;
-	volatile int refs;
 	struct io_log *log;
 	void *samples;
 	uint64_t nr_samples;
@@ -1009,28 +1004,8 @@ size_t log_chunk_sizes(struct io_log *log)
 
 #ifdef CONFIG_ZLIB
 
-static void drop_data_unlock(struct iolog_flush_data *data)
+static int gz_work(struct iolog_flush_data *data)
 {
-	int refs;
-
-	refs = --data->refs;
-	pthread_mutex_unlock(&data->lock);
-
-	if (!refs) {
-		free(data);
-		pthread_mutex_destroy(&data->lock);
-		pthread_cond_destroy(&data->cv);
-	}
-}
-
-/*
- * Invoked from our compress helper thread, when logging would have exceeded
- * the specified memory limitation. Compresses the previously stored
- * entries.
- */
-static int gz_work(struct submit_worker *sw, struct workqueue_work *work)
-{
-	struct iolog_flush_data *data;
 	struct iolog_compress *c;
 	struct flist_head list;
 	unsigned int seq;
@@ -1040,8 +1015,6 @@ static int gz_work(struct submit_worker *sw, struct workqueue_work *work)
 
 	INIT_FLIST_HEAD(&list);
 
-	data = container_of(work, struct iolog_flush_data, work);
-
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
 	stream.opaque = Z_NULL;
@@ -1049,7 +1022,7 @@ static int gz_work(struct submit_worker *sw, struct workqueue_work *work)
 	ret = deflateInit(&stream, Z_DEFAULT_COMPRESSION);
 	if (ret != Z_OK) {
 		log_err("fio: failed to init gz stream\n");
-		return 0;
+		goto err;
 	}
 
 	seq = ++data->log->chunk_seq;
@@ -1109,14 +1082,7 @@ static int gz_work(struct submit_worker *sw, struct workqueue_work *work)
 
 	ret = 0;
 done:
-	if (data->wait) {
-		pthread_mutex_lock(&data->lock);
-		data->done = 1;
-		pthread_cond_signal(&data->cv);
-
-		drop_data_unlock(data);
-	} else
-		free(data);
+	free(data);
 	return ret;
 err:
 	while (!flist_empty(&list)) {
@@ -1128,6 +1094,16 @@ err:
 	goto done;
 }
 
+/*
+ * Invoked from our compress helper thread, when logging would have exceeded
+ * the specified memory limitation. Compresses the previously stored
+ * entries.
+ */
+static int gz_work_async(struct submit_worker *sw, struct workqueue_work *work)
+{
+	return gz_work(container_of(work, struct iolog_flush_data, work));
+}
+
 static int gz_init_worker(struct submit_worker *sw)
 {
 	struct thread_data *td = sw->wq->td;
@@ -1144,7 +1120,7 @@ static int gz_init_worker(struct submit_worker *sw)
 }
 
 static struct workqueue_ops log_compress_wq_ops = {
-	.fn		= gz_work,
+	.fn		= gz_work_async,
 	.init_worker_fn	= gz_init_worker,
 	.nice		= 1,
 };
@@ -1189,26 +1165,13 @@ int iolog_flush(struct io_log *log, int wait)
 	data->nr_samples = log->nr_samples;
 
 	log->nr_samples = 0;
-	log->max_samples = 128;
+	log->max_samples = DEF_LOG_ENTRIES;
 	log->log = malloc(log->max_samples * log_entry_sz(log));
 
-	data->wait = wait;
-	if (data->wait) {
-		pthread_mutex_init(&data->lock, NULL);
-		pthread_cond_init(&data->cv, NULL);
-		data->done = 0;
-		data->refs = 2;
-	}
-
-	workqueue_enqueue(&log->td->log_compress_wq, &data->work);
-
-	if (wait) {
-		pthread_mutex_lock(&data->lock);
-		while (!data->done)
-			pthread_cond_wait(&data->cv, &data->lock);
-
-		drop_data_unlock(data);
-	}
+	if (!wait)
+		workqueue_enqueue(&log->td->log_compress_wq, &data->work);
+	else
+		gz_work(data);
 
 	return 0;
 }
diff --git a/iolog.h b/iolog.h
index 297daf5..74f2170 100644
--- a/iolog.h
+++ b/iolog.h
@@ -41,6 +41,8 @@ enum {
 	IO_LOG_TYPE_IOPS,
 };
 
+#define DEF_LOG_ENTRIES		1024
+
 /*
  * Dynamically growing data sample log
  */
diff --git a/libfio.c b/libfio.c
index c626d15..b17f148 100644
--- a/libfio.c
+++ b/libfio.c
@@ -146,6 +146,8 @@ void reset_all_stats(struct thread_data *td)
 	fio_gettime(&tv, NULL);
 	memcpy(&td->epoch, &tv, sizeof(tv));
 	memcpy(&td->start, &tv, sizeof(tv));
+	memcpy(&td->iops_sample_time, &tv, sizeof(tv));
+	memcpy(&td->bw_sample_time, &tv, sizeof(tv));
 
 	lat_target_reset(td);
 	clear_rusage_stat(td);
