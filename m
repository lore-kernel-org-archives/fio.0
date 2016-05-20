Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:40129 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbcETMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 May 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1b3j63-0001yv-Ur
	for fio@vger.kernel.org; Fri, 20 May 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160520120002.49CE42C00E8@kernel.dk>
Date: Fri, 20 May 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e391c70489d9f63612bce419d7fa0df5d15abf16:

  filesetup: align a size given as a percentage to the block size (2016-05-18 15:06:05 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6fa3ad511a61666b492ed8126330db9f876359bc:

  iolog: fix duplicate handling of compression end (2016-05-19 15:49:57 -0600)

----------------------------------------------------------------
Jens Axboe (13):
      flist: add flist_last_entry()
      backend: only do forceful timeout exit if the job isn't actively finishing
      backend: mark the thread as finishing, when we are out of the IO loop
      backend: dump state of stuck thread
      iolog: switch to list based scheme
      iolog: don't quiesce on completion
      backend: move iolog compression init before CPU affinity settings
      iolog: fix missing new-line in inflate debug statement
      iolog: memset() zstream at init time
      iolog: sum last chunk length to total
      iolog: more compression debugging/fixes
      iolog: fix bug with ret != Z_STREAM_END
      iolog: fix duplicate handling of compression end

 backend.c |  19 ++++++--
 flist.h   |   3 ++
 iolog.c   | 154 ++++++++++++++++++++++++++++++++++++++++++++++++++------------
 iolog.h   |  25 +++++++---
 server.c  | 139 ++++++++++++++++++++++++++++++++++++--------------------
 stat.c    | 137 +++++++++++++++++++++++++++++++++++++------------------
 6 files changed, 342 insertions(+), 135 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 7de6f65..f830040 100644
--- a/backend.c
+++ b/backend.c
@@ -1472,6 +1472,14 @@ static void *thread_main(void *data)
 	}
 
 	/*
+	 * Do this early, we don't want the compress threads to be limited
+	 * to the same CPUs as the IO workers. So do this before we set
+	 * any potential CPU affinity
+	 */
+	if (iolog_compress_init(td, sk_out))
+		goto err;
+
+	/*
 	 * If we have a gettimeofday() thread, make sure we exclude that
 	 * thread from this job
 	 */
@@ -1605,9 +1613,6 @@ static void *thread_main(void *data)
 			goto err;
 	}
 
-	if (iolog_compress_init(td, sk_out))
-		goto err;
-
 	fio_verify_init(td);
 
 	if (rate_submit_init(td, sk_out))
@@ -1705,6 +1710,8 @@ static void *thread_main(void *data)
 			break;
 	}
 
+	td_set_runstate(td, TD_FINISHING);
+
 	update_rusage_stat(td);
 	td->ts.total_run_time = mtime_since_now(&td->epoch);
 	td->ts.io_bytes[DDIR_READ] = td->io_bytes[DDIR_READ];
@@ -1813,8 +1820,9 @@ static int fork_main(struct sk_out *sk_out, int shmid, int offset)
 
 static void dump_td_info(struct thread_data *td)
 {
-	log_err("fio: job '%s' hasn't exited in %lu seconds, it appears to "
-		"be stuck. Doing forceful exit of this job.\n", td->o.name,
+	log_err("fio: job '%s' (state=%d) hasn't exited in %lu seconds, it "
+		"appears to be stuck. Doing forceful exit of this job.\n",
+			td->o.name, td->runstate,
 			(unsigned long) time_since_now(&td->terminate_time));
 }
 
@@ -1900,6 +1908,7 @@ static void reap_threads(unsigned int *nr_running, unsigned int *t_rate,
 		 * move on.
 		 */
 		if (td->terminate &&
+		    td->runstate < TD_FSYNCING &&
 		    time_since_now(&td->terminate_time) >= FIO_REAP_TIMEOUT) {
 			dump_td_info(td);
 			td_set_runstate(td, TD_REAPED);
diff --git a/flist.h b/flist.h
index d453e79..b4fe6e6 100644
--- a/flist.h
+++ b/flist.h
@@ -177,6 +177,9 @@ static inline void flist_splice_init(struct flist_head *list,
 #define flist_first_entry(ptr, type, member) \
 	flist_entry((ptr)->next, type, member)
 
+#define flist_last_entry(ptr, type, member) \
+	flist_entry((ptr)->prev, type, member)
+
 /**
  * flist_for_each	-	iterate over a list
  * @pos:	the &struct flist_head to use as a loop counter.
diff --git a/iolog.c b/iolog.c
index 71afe86..aec0881 100644
--- a/iolog.c
+++ b/iolog.c
@@ -20,6 +20,8 @@
 #include "filelock.h"
 #include "smalloc.h"
 
+static int iolog_flush(struct io_log *log);
+
 static const char iolog_ver2[] = "fio version 2 iolog";
 
 void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
@@ -575,8 +577,8 @@ void setup_log(struct io_log **log, struct log_params *p,
 {
 	struct io_log *l;
 
-	l = smalloc(sizeof(*l));
-	l->nr_samples = 0;
+	l = scalloc(1, sizeof(*l));
+	INIT_FLIST_HEAD(&l->io_logs);
 	l->log_type = p->log_type;
 	l->log_offset = p->log_offset;
 	l->log_gz = p->log_gz;
@@ -628,7 +630,14 @@ static void clear_file_buffer(void *buf)
 
 void free_log(struct io_log *log)
 {
-	free(log->log);
+	while (!flist_empty(&log->io_logs)) {
+		struct io_logs *cur_log;
+
+		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
+		flist_del_init(&cur_log->list);
+		free(cur_log->log);
+	}
+
 	free(log->filename);
 	sfree(log);
 }
@@ -673,7 +682,8 @@ struct iolog_flush_data {
 	struct workqueue_work work;
 	struct io_log *log;
 	void *samples;
-	uint64_t nr_samples;
+	uint32_t nr_samples;
+	bool free;
 };
 
 #define GZ_CHUNK	131072
@@ -700,6 +710,7 @@ static int z_stream_init(z_stream *stream, int gz_hdr)
 {
 	int wbits = 15;
 
+	memset(stream, 0, sizeof(*stream));
 	stream->zalloc = Z_NULL;
 	stream->zfree = Z_NULL;
 	stream->opaque = Z_NULL;
@@ -734,7 +745,8 @@ static void finish_chunk(z_stream *stream, FILE *f,
 
 	ret = inflateEnd(stream);
 	if (ret != Z_OK)
-		log_err("fio: failed to end log inflation (%d)\n", ret);
+		log_err("fio: failed to end log inflation seq %d (%d)\n",
+				iter->seq, ret);
 
 	flush_samples(f, iter->buf, iter->buf_used);
 	free(iter->buf);
@@ -751,7 +763,7 @@ static size_t inflate_chunk(struct iolog_compress *ic, int gz_hdr, FILE *f,
 {
 	size_t ret;
 
-	dprint(FD_COMPRESS, "inflate chunk size=%lu, seq=%u",
+	dprint(FD_COMPRESS, "inflate chunk size=%lu, seq=%u\n",
 				(unsigned long) ic->len, ic->seq);
 
 	if (ic->seq != iter->seq) {
@@ -798,7 +810,7 @@ static size_t inflate_chunk(struct iolog_compress *ic, int gz_hdr, FILE *f,
 
 	ret = (void *) stream->next_in - ic->buf;
 
-	dprint(FD_COMPRESS, "inflated to size=%lu\n", (unsigned long) ret);
+	dprint(FD_COMPRESS, "inflated to size=%lu\n", (unsigned long) iter->buf_size);
 
 	return ret;
 }
@@ -954,7 +966,13 @@ void flush_log(struct io_log *log, int do_append)
 
 	inflate_gz_chunks(log, f);
 
-	flush_samples(f, log->log, log->nr_samples * log_entry_sz(log));
+	while (!flist_empty(&log->io_logs)) {
+		struct io_logs *cur_log;
+
+		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
+		flist_del_init(&cur_log->list);
+		flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(log));
+	}
 
 	fclose(f);
 	clear_file_buffer(buf);
@@ -963,7 +981,7 @@ void flush_log(struct io_log *log, int do_append)
 static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 {
 	if (td->flags & TD_F_COMPRESS_LOG)
-		iolog_flush(log, 1);
+		iolog_flush(log);
 
 	if (trylock) {
 		if (fio_trylock_file(log->filename))
@@ -1005,7 +1023,7 @@ size_t log_chunk_sizes(struct io_log *log)
 
 static int gz_work(struct iolog_flush_data *data)
 {
-	struct iolog_compress *c;
+	struct iolog_compress *c = NULL;
 	struct flist_head list;
 	unsigned int seq;
 	z_stream stream;
@@ -1014,6 +1032,7 @@ static int gz_work(struct iolog_flush_data *data)
 
 	INIT_FLIST_HEAD(&list);
 
+	memset(&stream, 0, sizeof(stream));
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
 	stream.opaque = Z_NULL;
@@ -1029,9 +1048,12 @@ static int gz_work(struct iolog_flush_data *data)
 	stream.next_in = (void *) data->samples;
 	stream.avail_in = data->nr_samples * log_entry_sz(data->log);
 
-	dprint(FD_COMPRESS, "deflate input size=%lu, seq=%u\n",
-				(unsigned long) stream.avail_in, seq);
+	dprint(FD_COMPRESS, "deflate input size=%lu, seq=%u, log=%s\n",
+				(unsigned long) stream.avail_in, seq,
+				data->log->filename);
 	do {
+		if (c)
+			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
 		c = get_new_chunk(seq);
 		stream.avail_out = GZ_CHUNK;
 		stream.next_out = c->buf;
@@ -1051,9 +1073,26 @@ static int gz_work(struct iolog_flush_data *data)
 	stream.avail_out = GZ_CHUNK - c->len;
 
 	ret = deflate(&stream, Z_FINISH);
-	if (ret == Z_STREAM_END)
-		c->len = GZ_CHUNK - stream.avail_out;
-	else {
+	if (ret < 0) {
+		/*
+		 * Z_BUF_ERROR is special, it just means we need more
+		 * output space. We'll handle that below. Treat any other
+		 * error as fatal.
+		 */
+		if (ret != Z_BUF_ERROR) {
+			log_err("fio: deflate log (%d)\n", ret);
+			flist_del(&c->list);
+			free_chunk(c);
+			goto err;
+		}
+	}
+
+	total -= c->len;
+	c->len = GZ_CHUNK - stream.avail_out;
+	total += c->len;
+	dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
+
+	if (ret != Z_STREAM_END) {
 		do {
 			c = get_new_chunk(seq);
 			stream.avail_out = GZ_CHUNK;
@@ -1062,6 +1101,7 @@ static int gz_work(struct iolog_flush_data *data)
 			c->len = GZ_CHUNK - stream.avail_out;
 			total += c->len;
 			flist_add_tail(&c->list, &list);
+			dprint(FD_COMPRESS, "seq=%d, chunk=%lu\n", seq, c->len);
 		} while (ret != Z_STREAM_END);
 	}
 
@@ -1081,7 +1121,8 @@ static int gz_work(struct iolog_flush_data *data)
 
 	ret = 0;
 done:
-	free(data);
+	if (data->free)
+		free(data);
 	return ret;
 err:
 	while (!flist_empty(&list)) {
@@ -1145,39 +1186,69 @@ void iolog_compress_exit(struct thread_data *td)
  * Queue work item to compress the existing log entries. We reset the
  * current log to a small size, and reference the existing log in the
  * data that we queue for compression. Once compression has been done,
- * this old log is freed. If called with wait == 1, will not return until
- * the log compression has completed.
+ * this old log is freed. If called with finish == true, will not return
+ * until the log compression has completed, and will flush all previous
+ * logs too
  */
-int iolog_flush(struct io_log *log, int wait)
+static int iolog_flush(struct io_log *log)
 {
 	struct iolog_flush_data *data;
 
-	io_u_quiesce(log->td);
-
 	data = malloc(sizeof(*data));
 	if (!data)
 		return 1;
 
 	data->log = log;
+	data->free = false;
 
-	data->samples = log->log;
-	data->nr_samples = log->nr_samples;
+	while (!flist_empty(&log->io_logs)) {
+		struct io_logs *cur_log;
 
-	log->nr_samples = 0;
-	log->max_samples = DEF_LOG_ENTRIES;
-	log->log = malloc(log->max_samples * log_entry_sz(log));
+		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
+		flist_del_init(&cur_log->list);
+
+		data->samples = cur_log->log;
+		data->nr_samples = cur_log->nr_samples;
+
+		cur_log->nr_samples = 0;
+		cur_log->max_samples = 0;
+		cur_log->log = NULL;
 
-	if (!wait)
-		workqueue_enqueue(&log->td->log_compress_wq, &data->work);
-	else
 		gz_work(data);
+	}
 
+	free(data);
 	return 0;
 }
 
+int iolog_cur_flush(struct io_log *log, struct io_logs *cur_log)
+{
+	struct iolog_flush_data *data;
+
+	data = malloc(sizeof(*data));
+	if (!data)
+		return 1;
+
+	data->log = log;
+
+	data->samples = cur_log->log;
+	data->nr_samples = cur_log->nr_samples;
+	data->free = true;
+
+	cur_log->nr_samples = cur_log->max_samples = 0;
+	cur_log->log = NULL;
+
+	workqueue_enqueue(&log->td->log_compress_wq, &data->work);
+	return 0;
+}
 #else
 
-int iolog_flush(struct io_log *log, int wait)
+static int iolog_flush(struct io_log *log)
+{
+	return 1;
+}
+
+int iolog_cur_flush(struct io_log *log, struct io_logs *cur_log)
 {
 	return 1;
 }
@@ -1193,6 +1264,29 @@ void iolog_compress_exit(struct thread_data *td)
 
 #endif
 
+struct io_logs *iolog_cur_log(struct io_log *log)
+{
+	if (flist_empty(&log->io_logs))
+		return NULL;
+
+	return flist_last_entry(&log->io_logs, struct io_logs, list);
+}
+
+uint64_t iolog_nr_samples(struct io_log *iolog)
+{
+	struct flist_head *entry;
+	uint64_t ret = 0;
+
+	flist_for_each(entry, &iolog->io_logs) {
+		struct io_logs *cur_log;
+
+		cur_log = flist_entry(entry, struct io_logs, list);
+		ret += cur_log->nr_samples;
+	}
+
+	return ret;
+}
+
 static int __write_log(struct thread_data *td, struct io_log *log, int try)
 {
 	if (log)
diff --git a/iolog.h b/iolog.h
index 739a7c8..2b7813b 100644
--- a/iolog.h
+++ b/iolog.h
@@ -42,6 +42,16 @@ enum {
 };
 
 #define DEF_LOG_ENTRIES		1024
+#define MAX_LOG_ENTRIES		(1024 * DEF_LOG_ENTRIES)
+
+#define LOG_QUIESCE_SZ		(64 * 1024 * 1024)
+
+struct io_logs {
+	struct flist_head list;
+	uint64_t nr_samples;
+	uint64_t max_samples;
+	void *log;
+};
 
 /*
  * Dynamically growing data sample log
@@ -50,9 +60,8 @@ struct io_log {
 	/*
 	 * Entries already logged
 	 */
-	uint64_t nr_samples;
-	uint64_t max_samples;
-	void *log;
+	struct flist_head io_logs;
+	uint32_t cur_log_max;
 
 	unsigned int log_ddir_mask;
 
@@ -65,7 +74,7 @@ struct io_log {
 	/*
 	 * If we fail extending the log, stop collecting more entries.
 	 */
-	unsigned int disabled;
+	bool disabled;
 
 	/*
 	 * Log offsets
@@ -128,10 +137,14 @@ static inline struct io_sample *__get_sample(void *samples, int log_offset,
 	return (struct io_sample *) ((char *) samples + sample_offset);
 }
 
+struct io_logs *iolog_cur_log(struct io_log *);
+uint64_t iolog_nr_samples(struct io_log *);
+
 static inline struct io_sample *get_sample(struct io_log *iolog,
+					   struct io_logs *cur_log,
 					   uint64_t sample)
 {
-	return __get_sample(iolog->log, iolog->log_offset, sample);
+	return __get_sample(cur_log->log, iolog->log_offset, sample);
 }
 
 enum {
@@ -219,7 +232,7 @@ extern void flush_samples(FILE *, void *, uint64_t);
 extern void free_log(struct io_log *);
 extern void fio_writeout_logs(bool);
 extern void td_writeout_logs(struct thread_data *, bool);
-extern int iolog_flush(struct io_log *, int);
+extern int iolog_cur_flush(struct io_log *, struct io_logs *);
 
 static inline void init_ipo(struct io_piece *ipo)
 {
diff --git a/server.c b/server.c
index dcb7c2d..d36c511 100644
--- a/server.c
+++ b/server.c
@@ -1652,58 +1652,79 @@ void fio_server_send_du(void)
 	}
 }
 
-static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
-{
-	int ret = 0;
 #ifdef CONFIG_ZLIB
+static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
+				 struct io_logs *cur_log, z_stream *stream)
+{
 	struct sk_entry *entry;
-	z_stream stream;
 	void *out_pdu;
+	int ret;
 
-	/*
-	 * Dirty - since the log is potentially huge, compress it into
-	 * FIO_SERVER_MAX_FRAGMENT_PDU chunks and let the receiving
-	 * side defragment it.
-	 */
-	out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
-
-	stream.zalloc = Z_NULL;
-	stream.zfree = Z_NULL;
-	stream.opaque = Z_NULL;
-
-	if (deflateInit(&stream, Z_DEFAULT_COMPRESSION) != Z_OK) {
-		ret = 1;
-		goto err;
-	}
-
-	stream.next_in = (void *) log->log;
-	stream.avail_in = log->nr_samples * log_entry_sz(log);
+	stream->next_in = (void *) cur_log->log;
+	stream->avail_in = cur_log->nr_samples * log_entry_sz(log);
 
 	do {
 		unsigned int this_len;
 
-		stream.avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
-		stream.next_out = out_pdu;
-		ret = deflate(&stream, Z_FINISH);
+		/*
+		 * Dirty - since the log is potentially huge, compress it into
+		 * FIO_SERVER_MAX_FRAGMENT_PDU chunks and let the receiving
+		 * side defragment it.
+		 */
+		out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
+
+		stream->avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
+		stream->next_out = out_pdu;
+		ret = deflate(stream, Z_FINISH);
 		/* may be Z_OK, or Z_STREAM_END */
-		if (ret < 0)
-			goto err_zlib;
+		if (ret < 0) {
+			free(out_pdu);
+			return 1;
+		}
 
-		this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream.avail_out;
+		this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream->avail_out;
 
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
-						NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
-		out_pdu = NULL;
+					 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
 		flist_add_tail(&entry->list, &first->next);
-	} while (stream.avail_in);
+	} while (stream->avail_in);
+
+	return 0;
+}
+
+static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
+{
+	int ret = 0;
+	z_stream stream;
+
+	memset(&stream, 0, sizeof(stream));
+	stream.zalloc = Z_NULL;
+	stream.zfree = Z_NULL;
+	stream.opaque = Z_NULL;
+
+	if (deflateInit(&stream, Z_DEFAULT_COMPRESSION) != Z_OK)
+		return 1;
+
+	while (!flist_empty(&log->io_logs)) {
+		struct io_logs *cur_log;
+
+		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
+		flist_del_init(&cur_log->list);
+
+		ret = __fio_append_iolog_gz(first, log, cur_log, &stream);
+		if (ret)
+			break;
+	}
 
-err_zlib:
 	deflateEnd(&stream);
-err:
-	free(out_pdu);
-#endif
 	return ret;
 }
+#else
+static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
+{
+	return 1;
+}
+#endif
 
 static int fio_append_gz_chunks(struct sk_entry *first, struct io_log *log)
 {
@@ -1727,11 +1748,21 @@ static int fio_append_gz_chunks(struct sk_entry *first, struct io_log *log)
 static int fio_append_text_log(struct sk_entry *first, struct io_log *log)
 {
 	struct sk_entry *entry;
-	size_t size = log->nr_samples * log_entry_sz(log);
 
-	entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, log->log, size,
-					NULL, SK_F_VEC | SK_F_INLINE);
-	flist_add_tail(&entry->list, &first->next);
+	while (!flist_empty(&log->io_logs)) {
+		struct io_logs *cur_log;
+		size_t size;
+
+		cur_log = flist_first_entry(&log->io_logs, struct io_logs, list);
+		flist_del_init(&cur_log->list);
+
+		size = cur_log->nr_samples * log_entry_sz(log);
+
+		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, cur_log->log, size,
+						NULL, SK_F_VEC | SK_F_INLINE);
+		flist_add_tail(&entry->list, &first->next);
+	}
+
 	return 0;
 }
 
@@ -1739,9 +1770,10 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 {
 	struct cmd_iolog_pdu pdu;
 	struct sk_entry *first;
-	int i, ret = 0;
+	struct flist_head *entry;
+	int ret = 0;
 
-	pdu.nr_samples = cpu_to_le64(log->nr_samples);
+	pdu.nr_samples = cpu_to_le64(iolog_nr_samples(log));
 	pdu.thread_number = cpu_to_le32(td->thread_number);
 	pdu.log_type = cpu_to_le32(log->log_type);
 
@@ -1759,18 +1791,25 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	 * We can't do this for a pre-compressed log, but for that case,
 	 * log->nr_samples is zero anyway.
 	 */
-	for (i = 0; i < log->nr_samples; i++) {
-		struct io_sample *s = get_sample(log, i);
+	flist_for_each(entry, &log->io_logs) {
+		struct io_logs *cur_log;
+		int i;
 
-		s->time		= cpu_to_le64(s->time);
-		s->val		= cpu_to_le64(s->val);
-		s->__ddir	= cpu_to_le32(s->__ddir);
-		s->bs		= cpu_to_le32(s->bs);
+		cur_log = flist_entry(entry, struct io_logs, list);
 
-		if (log->log_offset) {
-			struct io_sample_offset *so = (void *) s;
+		for (i = 0; i < cur_log->nr_samples; i++) {
+			struct io_sample *s = get_sample(log, cur_log, i);
 
-			so->offset = cpu_to_le64(so->offset);
+			s->time		= cpu_to_le64(s->time);
+			s->val		= cpu_to_le64(s->val);
+			s->__ddir	= cpu_to_le32(s->__ddir);
+			s->bs		= cpu_to_le32(s->bs);
+
+			if (log->log_offset) {
+				struct io_sample_offset *so = (void *) s;
+
+				so->offset = cpu_to_le64(so->offset);
+			}
 		}
 	}
 
diff --git a/stat.c b/stat.c
index 4d87c29..5eb1aab 100644
--- a/stat.c
+++ b/stat.c
@@ -1849,66 +1849,115 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long data)
 	is->samples++;
 }
 
+/*
+ * Return a struct io_logs, which is added to the tail of the log
+ * list for 'iolog'.
+ */
+static struct io_logs *get_new_log(struct io_log *iolog)
+{
+	size_t new_size, new_samples;
+	struct io_logs *cur_log;
+
+	/*
+	 * Cap the size at MAX_LOG_ENTRIES, so we don't keep doubling
+	 * forever
+	 */
+	if (!iolog->cur_log_max)
+		new_samples = DEF_LOG_ENTRIES;
+	else {
+		new_samples = iolog->cur_log_max * 2;
+		if (new_samples > MAX_LOG_ENTRIES)
+			new_samples = MAX_LOG_ENTRIES;
+	}
+
+	new_size = new_samples * log_entry_sz(iolog);
+
+	cur_log = malloc(sizeof(*cur_log));
+	if (cur_log) {
+		INIT_FLIST_HEAD(&cur_log->list);
+		cur_log->log = malloc(new_size);
+		if (cur_log->log) {
+			cur_log->nr_samples = 0;
+			cur_log->max_samples = new_samples;
+			flist_add_tail(&cur_log->list, &iolog->io_logs);
+			iolog->cur_log_max = new_samples;
+			return cur_log;
+		}
+		free(cur_log);
+	}
+
+	return NULL;
+}
+
+static struct io_logs *get_cur_log(struct io_log *iolog)
+{
+	struct io_logs *cur_log;
+
+	cur_log = iolog_cur_log(iolog);
+	if (!cur_log) {
+		cur_log = get_new_log(iolog);
+		if (!cur_log)
+			return NULL;
+	}
+
+	if (cur_log->nr_samples < cur_log->max_samples)
+		return cur_log;
+
+	/*
+	 * No room for a new sample. If we're compressing on the fly, flush
+	 * out the current chunk
+	 */
+	if (iolog->log_gz) {
+		if (iolog_cur_flush(iolog, cur_log)) {
+			log_err("fio: failed flushing iolog! Will stop logging.\n");
+			return NULL;
+		}
+	}
+
+	/*
+	 * Get a new log array, and add to our list
+	 */
+	cur_log = get_new_log(iolog);
+	if (cur_log)
+		return cur_log;
+
+	log_err("fio: failed extending iolog! Will stop logging.\n");
+	return NULL;
+}
+
 static void __add_log_sample(struct io_log *iolog, unsigned long val,
 			     enum fio_ddir ddir, unsigned int bs,
 			     unsigned long t, uint64_t offset)
 {
-	uint64_t nr_samples = iolog->nr_samples;
-	struct io_sample *s;
+	struct io_logs *cur_log;
 
 	if (iolog->disabled)
 		return;
-
-	if (!iolog->nr_samples)
+	if (flist_empty(&iolog->io_logs))
 		iolog->avg_last = t;
 
-	if (iolog->nr_samples == iolog->max_samples) {
-		size_t new_size, new_samples;
-		void *new_log;
+	cur_log = get_cur_log(iolog);
+	if (cur_log) {
+		struct io_sample *s;
 
-		if (!iolog->max_samples)
-			new_samples = DEF_LOG_ENTRIES;
-		else
-			new_samples = iolog->max_samples * 2;
-
-		new_size = new_samples * log_entry_sz(iolog);
-
-		if (iolog->log_gz && (new_size > iolog->log_gz)) {
-			if (!iolog->log) {
-				iolog->log = malloc(new_size);
-				iolog->max_samples = new_samples;
-			} else if (iolog_flush(iolog, 0)) {
-				log_err("fio: failed flushing iolog! Will stop logging.\n");
-				iolog->disabled = 1;
-				return;
-			}
-			nr_samples = iolog->nr_samples;
-		} else {
-			new_log = realloc(iolog->log, new_size);
-			if (!new_log) {
-				log_err("fio: failed extending iolog! Will stop logging.\n");
-				iolog->disabled = 1;
-				return;
-			}
-			iolog->log = new_log;
-			iolog->max_samples = new_samples;
-		}
-	}
+		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
-	s = get_sample(iolog, nr_samples);
+		s->val = val;
+		s->time = t;
+		io_sample_set_ddir(iolog, s, ddir);
+		s->bs = bs;
 
-	s->val = val;
-	s->time = t;
-	io_sample_set_ddir(iolog, s, ddir);
-	s->bs = bs;
+		if (iolog->log_offset) {
+			struct io_sample_offset *so = (void *) s;
 
-	if (iolog->log_offset) {
-		struct io_sample_offset *so = (void *) s;
+			so->offset = offset;
+		}
 
-		so->offset = offset;
+		cur_log->nr_samples++;
+		return;
 	}
 
-	iolog->nr_samples++;
+	iolog->disabled = true;
 }
 
 static inline void reset_io_stat(struct io_stat *ios)
