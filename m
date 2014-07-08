Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39803 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaGHMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 8 Jul 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X4U46-0006ZP-I8
	for fio@vger.kernel.org; Tue, 08 Jul 2014 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140708120002.D2329400C1@lyth.info>
Date: Tue,  8 Jul 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f302710c4b7dd09fa6beb61a983345b2eda2b8d4:

  iolog: fix bug when decompressing chunks with different sequence numbers (2014-07-03 21:57:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6899b6cb0d996c530e42195cfc29e8e0b02aeae3:

  mutex: move pthread_cond_signal() outside of lock (2014-07-08 09:46:37 +0200)

----------------------------------------------------------------
Jens Axboe (3):
      Add some new code comments on the log compress/decompress
      tp: move pthread_cond_signal() outside of lock
      mutex: move pthread_cond_signal() outside of lock

 iolog.c  |   66 +++++++++++++++++++++++++++++++++++++++++++++++++-------------
 lib/tp.c |   15 +++++++++++---
 mutex.c  |    7 ++++++-
 3 files changed, 70 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index 29997ce..5eca53b 100644
--- a/iolog.c
+++ b/iolog.c
@@ -691,6 +691,10 @@ static int z_stream_init(z_stream *stream, int gz_hdr)
 	stream->opaque = Z_NULL;
 	stream->next_in = Z_NULL;
 
+	/*
+	 * zlib magic - add 32 for auto-detection of gz header or not,
+	 * if we decide to store files in a gzip friendly format.
+	 */
 	if (gz_hdr)
 		wbits += 32;
 
@@ -700,7 +704,7 @@ static int z_stream_init(z_stream *stream, int gz_hdr)
 	return 0;
 }
 
-struct flush_chunk_iter {
+struct inflate_chunk_iter {
 	unsigned int seq;
 	void *buf;
 	size_t buf_size;
@@ -709,7 +713,7 @@ struct flush_chunk_iter {
 };
 
 static void finish_chunk(z_stream *stream, FILE *f,
-			 struct flush_chunk_iter *iter)
+			 struct inflate_chunk_iter *iter)
 {
 	int ret;
 
@@ -723,8 +727,12 @@ static void finish_chunk(z_stream *stream, FILE *f,
 	iter->buf_size = iter->buf_used = 0;
 }
 
-static size_t flush_chunk(struct iolog_compress *ic, int gz_hdr, FILE *f,
-			  z_stream *stream, struct flush_chunk_iter *iter)
+/*
+ * Iterative chunk inflation. Handles cases where we cross into a new
+ * sequence, doing flush finish of previous chunk if needed.
+ */
+static size_t inflate_chunk(struct iolog_compress *ic, int gz_hdr, FILE *f,
+			    z_stream *stream, struct inflate_chunk_iter *iter)
 {
 	if (ic->seq != iter->seq) {
 		if (iter->seq)
@@ -770,9 +778,13 @@ static size_t flush_chunk(struct iolog_compress *ic, int gz_hdr, FILE *f,
 	return (void *) stream->next_in - ic->buf;
 }
 
-static void flush_gz_chunks(struct io_log *log, FILE *f)
+/*
+ * Inflate stored compressed chunks, or write them directly to the log
+ * file if so instructed.
+ */
+static void inflate_gz_chunks(struct io_log *log, FILE *f)
 {
-	struct flush_chunk_iter iter = { .chunk_sz = log->log_gz, };
+	struct inflate_chunk_iter iter = { .chunk_sz = log->log_gz, };
 	z_stream stream;
 
 	while (!flist_empty(&log->chunk_list)) {
@@ -781,10 +793,14 @@ static void flush_gz_chunks(struct io_log *log, FILE *f)
 		ic = flist_first_entry(&log->chunk_list, struct iolog_compress, list);
 		flist_del(&ic->list);
 
-		if (log->log_gz_store)
-			fwrite(ic->buf, ic->len, 1, f);
-		else
-			flush_chunk(ic, log->log_gz_store, f, &stream, &iter);
+		if (log->log_gz_store) {
+			size_t ret;
+
+			ret = fwrite(ic->buf, ic->len, 1, f);
+			if (ret != 1 || ferror(f))
+				log_err("fio: error writing compressed log\n");
+		} else
+			inflate_chunk(ic, log->log_gz_store, f, &stream, &iter);
 
 		free_chunk(ic);
 	}
@@ -795,9 +811,14 @@ static void flush_gz_chunks(struct io_log *log, FILE *f)
 	}
 }
 
+/*
+ * Open compressed log file and decompress the stored chunks and
+ * write them to stdout. The chunks are stored sequentially in the
+ * file, so we iterate over them and do them one-by-one.
+ */
 int iolog_file_inflate(const char *file)
 {
-	struct flush_chunk_iter iter = { .chunk_sz = 64 * 1024 * 1024, };
+	struct inflate_chunk_iter iter = { .chunk_sz = 64 * 1024 * 1024, };
 	struct iolog_compress ic;
 	z_stream stream;
 	struct stat sb;
@@ -835,11 +856,17 @@ int iolog_file_inflate(const char *file)
 
 	fclose(f);
 
+	/*
+	 * Each chunk will return Z_STREAM_END. We don't know how many
+	 * chunks are in the file, so we just keep looping and incrementing
+	 * the sequence number until we have consumed the whole compressed
+	 * file.
+	 */
 	total = ic.len;
 	do {
 		size_t ret;
 
-		ret = flush_chunk(&ic,  1, stdout, &stream, &iter);
+		ret = inflate_chunk(&ic,  1, stdout, &stream, &iter);
 		total -= ret;
 		if (!total)
 			break;
@@ -860,7 +887,7 @@ int iolog_file_inflate(const char *file)
 
 #else
 
-static void flush_gz_chunks(struct io_log *log, FILE *f)
+static void inflate_gz_chunks(struct io_log *log, FILE *f)
 {
 }
 
@@ -879,7 +906,7 @@ void flush_log(struct io_log *log)
 
 	buf = set_file_buffer(f);
 
-	flush_gz_chunks(log, f);
+	inflate_gz_chunks(log, f);
 
 	flush_samples(f, log->log, log->nr_samples * log_entry_sz(log));
 
@@ -910,6 +937,11 @@ static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 
 #ifdef CONFIG_ZLIB
 
+/*
+ * Invoked from our compress helper thread, when logging would have exceeded
+ * the specified memory limitation. Compresses the previously stored
+ * entries.
+ */
 static int gz_work(struct tp_work *work)
 {
 	struct iolog_flush_data *data;
@@ -992,6 +1024,12 @@ static int gz_work(struct tp_work *work)
 	return 0;
 }
 
+/*
+ * Queue work item to compress the existing log entries. We copy the
+ * samples, and reset the log sample count to 0 (so the logging will
+ * continue to use the memory associated with the log). If called with
+ * wait == 1, will not return until the log compression has completed.
+ */
 int iolog_flush(struct io_log *log, int wait)
 {
 	struct tp_data *tdat = log->td->tp_data;
diff --git a/lib/tp.c b/lib/tp.c
index 5111910..386e31a 100644
--- a/lib/tp.c
+++ b/lib/tp.c
@@ -1,3 +1,10 @@
+/*
+ * Basic workqueue like code, that sets up a thread and allows async
+ * processing of some sort. Could be extended to allow for multiple
+ * worker threads. But right now fio associates one of this per IO
+ * thread, so should be enough to have just a single thread doing the
+ * work.
+ */
 #include <stdio.h>
 #include <stdlib.h>
 #include <stdarg.h>
@@ -56,8 +63,9 @@ void tp_queue_work(struct tp_data *tdat, struct tp_work *work)
 
 	pthread_mutex_lock(&tdat->lock);
 	flist_add_tail(&work->list, &tdat->work);
-	pthread_cond_signal(&tdat->cv);
 	pthread_mutex_unlock(&tdat->lock);
+
+	pthread_cond_signal(&tdat->cv);
 }
 
 void tp_init(struct tp_data **tdatp)
@@ -87,11 +95,12 @@ void tp_exit(struct tp_data **tdatp)
 	if (!tdat)
 		return;
 
-	tdat->thread_exit = 1;
 	pthread_mutex_lock(&tdat->lock);
-	pthread_cond_signal(&tdat->cv);
+	tdat->thread_exit = 1;
 	pthread_mutex_unlock(&tdat->lock);
 
+	pthread_cond_signal(&tdat->cv);
+
 	pthread_join(tdat->thread, &ret);
 
 	sfree(tdat);
diff --git a/mutex.c b/mutex.c
index 9d10c2c..9ee3bd8 100644
--- a/mutex.c
+++ b/mutex.c
@@ -162,14 +162,19 @@ void fio_mutex_down(struct fio_mutex *mutex)
 
 void fio_mutex_up(struct fio_mutex *mutex)
 {
+	int do_wake = 0;
+
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 
 	pthread_mutex_lock(&mutex->lock);
 	read_barrier();
 	if (!mutex->value && mutex->waiters)
-		pthread_cond_signal(&mutex->cond);
+		do_wake = 1;
 	mutex->value++;
 	pthread_mutex_unlock(&mutex->lock);
+
+	if (do_wake)
+		pthread_cond_signal(&mutex->cond);
 }
 
 void fio_rwlock_write(struct fio_rwlock *lock)
