Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53820 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbcICMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 3 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bg9cB-000176-W7
        for fio@vger.kernel.org; Sat, 03 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160903120002.1B01D2C1A70@kernel.dk>
Date: Sat,  3 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 32bc83ddb4adb6b19500f2f6acec8c591feaae26:

  jesd219: fix alignment (2016-08-29 15:43:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b678fac65b13dabd0f78ceb338547b9acb5a4f2d:

  server: bump version (2016-09-02 11:24:59 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'histogram-client-server' of https://github.com/cronburg/fio
      server: bump version

Karl Cronburg (1):
      Client / server code for handling histograms. The server:

 client.c |  63 ++++++++++++++++++++++++++++++++++++++--
 init.c   |   6 ++++
 iolog.c  |  15 ++++++----
 iolog.h  |  13 +++++++--
 server.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 server.h |   3 +-
 6 files changed, 189 insertions(+), 11 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 238c93f..3456665 100644
--- a/client.c
+++ b/client.c
@@ -1251,6 +1251,44 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 	fio_client_dec_jobs_eta(eta, client->ops->eta);
 }
 
+static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
+				      uint64_t sample_size)
+{
+	struct io_sample *s;
+	int log_offset;
+	uint64_t i, j, nr_samples;
+	struct io_u_plat_entry *entry;
+	unsigned int *io_u_plat;
+
+	int stride = 1 << hist_coarseness;
+
+	if (!sample_size)
+		return;
+
+	s = __get_sample(samples, 0, 0);
+	log_offset = (s->__ddir & LOG_OFFSET_SAMPLE_BIT) != 0;
+
+	nr_samples = sample_size / __log_entry_sz(log_offset);
+
+	for (i = 0; i < nr_samples; i++) {
+
+		s = (struct io_sample *)((char *)__get_sample(samples, log_offset, i) +
+			i * sizeof(struct io_u_plat_entry));
+
+		entry = s->plat_entry;
+		io_u_plat = entry->io_u_plat;
+
+		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
+						io_sample_ddir(s), s->bs);
+		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
+			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat, NULL));
+		}
+		fprintf(f, "%lu\n", (unsigned long)
+			hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat, NULL));
+
+	}
+}
+
 static int fio_client_handle_iolog(struct fio_client *client,
 				   struct fio_net_cmd *cmd)
 {
@@ -1294,8 +1332,13 @@ static int fio_client_handle_iolog(struct fio_client *client,
 			return 1;
 		}
 
-		flush_samples(f, pdu->samples,
-				pdu->nr_samples * sizeof(struct io_sample));
+		if (pdu->log_type == IO_LOG_TYPE_HIST) {
+			client_flush_hist_samples(f, pdu->log_hist_coarseness, pdu->samples,
+					   pdu->nr_samples * sizeof(struct io_sample));
+		} else {
+			flush_samples(f, pdu->samples,
+					pdu->nr_samples * sizeof(struct io_sample));
+		}
 		fclose(f);
 		return 0;
 	}
@@ -1395,7 +1438,11 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	 */
 	nr_samples = le64_to_cpu(pdu->nr_samples);
 
-	total = nr_samples * __log_entry_sz(le32_to_cpu(pdu->log_offset));
+	if (pdu->log_type == IO_LOG_TYPE_HIST)
+		total = nr_samples * (__log_entry_sz(le32_to_cpu(pdu->log_offset)) +
+					sizeof(struct io_u_plat_entry));
+	else
+		total = nr_samples * __log_entry_sz(le32_to_cpu(pdu->log_offset));
 	ret = malloc(total + sizeof(*pdu));
 	ret->nr_samples = nr_samples;
 
@@ -1478,6 +1525,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 	ret->log_type		= le32_to_cpu(ret->log_type);
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
+	ret->log_hist_coarseness = le32_to_cpu(ret->log_hist_coarseness);
 
 	if (*store_direct)
 		return ret;
@@ -1487,6 +1535,9 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		struct io_sample *s;
 
 		s = __get_sample(samples, ret->log_offset, i);
+		if (ret->log_type == IO_LOG_TYPE_HIST)
+			s = (struct io_sample *)((void *)s + sizeof(struct io_u_plat_entry) * i);
+
 		s->time		= le64_to_cpu(s->time);
 		s->val		= le64_to_cpu(s->val);
 		s->__ddir	= le32_to_cpu(s->__ddir);
@@ -1497,6 +1548,12 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 
 			so->offset = le64_to_cpu(so->offset);
 		}
+
+		if (ret->log_type == IO_LOG_TYPE_HIST) {
+			s->plat_entry = (struct io_u_plat_entry *)(((void *)s) + sizeof(*s));
+			s->plat_entry->list.next = NULL;
+			s->plat_entry->list.prev = NULL;
+		}
 	}
 
 	return ret;
diff --git a/init.c b/init.c
index 0221ab2..4b4a86a 100644
--- a/init.c
+++ b/init.c
@@ -1426,6 +1426,12 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	}
 
 	if (o->hist_log_file) {
+#ifndef CONFIG_ZLIB
+		if (td->client_type) {
+			log_err("fio: --write_hist_log requires zlib in client/server mode\n");
+			goto err;
+		}
+#endif
 		struct log_params p = {
 			.td = td,
 			.avg_msec = o->log_avg_msec,
diff --git a/iolog.c b/iolog.c
index d4213db..baa4b85 100644
--- a/iolog.c
+++ b/iolog.c
@@ -674,14 +674,19 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-static inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
+inline unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
 		unsigned int *io_u_plat_last)
 {
 	unsigned long sum;
 	int k;
 
-	for (k = sum = 0; k < stride; k++)
-		sum += io_u_plat[j + k] - io_u_plat_last[j + k];
+	if (io_u_plat_last) {
+		for (k = sum = 0; k < stride; k++)
+			sum += io_u_plat[j + k] - io_u_plat_last[j + k];
+	} else {
+		for (k = sum = 0; k < stride; k++)
+			sum += io_u_plat[j + k];
+	}
 
 	return sum;
 }
@@ -1062,9 +1067,9 @@ void flush_log(struct io_log *log, bool do_append)
 		
 		if (log == log->td->clat_hist_log)
 			flush_hist_samples(f, log->hist_coarseness, cur_log->log,
-			                   cur_log->nr_samples * log_entry_sz(log));
+			                   log_sample_sz(log, cur_log));
 		else
-			flush_samples(f, cur_log->log, cur_log->nr_samples * log_entry_sz(log));
+			flush_samples(f, cur_log->log, log_sample_sz(log, cur_log));
 		
 		sfree(cur_log);
 	}
diff --git a/iolog.h b/iolog.h
index ca344f1..de641d5 100644
--- a/iolog.h
+++ b/iolog.h
@@ -29,7 +29,10 @@ struct io_hist {
  */
 struct io_sample {
 	uint64_t time;
-	uint64_t val;
+	union {
+		uint64_t val;
+		struct io_u_plat_entry *plat_entry;
+	};
 	uint32_t __ddir;
 	uint32_t bs;
 };
@@ -117,7 +120,7 @@ struct io_log {
 	 */
 	struct io_hist hist_window[DDIR_RWDIR_CNT];
 	unsigned long hist_msec;
-	int hist_coarseness;
+	unsigned int hist_coarseness;
 
 	pthread_mutex_t chunk_lock;
 	unsigned int chunk_seq;
@@ -150,6 +153,11 @@ static inline size_t log_entry_sz(struct io_log *log)
 	return __log_entry_sz(log->log_offset);
 }
 
+static inline size_t log_sample_sz(struct io_log *log, struct io_logs *cur_log)
+{
+	return cur_log->nr_samples * log_entry_sz(log);
+}
+
 static inline struct io_sample *__get_sample(void *samples, int log_offset,
 					     uint64_t sample)
 {
@@ -259,6 +267,7 @@ extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, bool);
 extern void flush_samples(FILE *, void *, uint64_t);
+extern unsigned long hist_sum(int, int, unsigned int *, unsigned int *);
 extern void free_log(struct io_log *);
 extern void fio_writeout_logs(bool);
 extern void td_writeout_logs(struct thread_data *, bool);
diff --git a/server.c b/server.c
index 9f2220d..3862699 100644
--- a/server.c
+++ b/server.c
@@ -1654,6 +1654,102 @@ void fio_server_send_du(void)
 }
 
 #ifdef CONFIG_ZLIB
+
+static inline void __fio_net_prep_tail(z_stream *stream, void *out_pdu,
+					struct sk_entry **last_entry,
+					struct sk_entry *first)
+{
+	unsigned int this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream->avail_out;
+
+	*last_entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
+				 NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
+	flist_add_tail(&(*last_entry)->list, &first->next);
+
+}
+
+/*
+ * Deflates the next input given, creating as many new packets in the
+ * linked list as necessary.
+ */
+static int __deflate_pdu_buffer(void *next_in, unsigned int next_sz, void **out_pdu,
+				struct sk_entry **last_entry, z_stream *stream,
+				struct sk_entry *first)
+{
+	int ret;
+
+	stream->next_in = next_in;
+	stream->avail_in = next_sz;
+	do {
+		if (! stream->avail_out) {
+
+			__fio_net_prep_tail(stream, *out_pdu, last_entry, first);
+
+			*out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
+
+			stream->avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
+			stream->next_out = *out_pdu;
+		}
+
+		ret = deflate(stream, Z_BLOCK);
+
+		if (ret < 0) {
+			free(*out_pdu);
+			return 1;
+		}
+	} while (stream->avail_in);
+
+	return 0;
+}
+
+static int __fio_append_iolog_gz_hist(struct sk_entry *first, struct io_log *log,
+				      struct io_logs *cur_log, z_stream *stream)
+{
+	struct sk_entry *entry;
+	void *out_pdu;
+	int ret, i, j;
+	int sample_sz = log_entry_sz(log);
+
+	out_pdu = malloc(FIO_SERVER_MAX_FRAGMENT_PDU);
+	stream->avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
+	stream->next_out = out_pdu;
+
+	for (i = 0; i < cur_log->nr_samples; i++) {
+		struct io_sample *s;
+		struct io_u_plat_entry *cur_plat_entry, *prev_plat_entry;
+		unsigned int *cur_plat, *prev_plat;
+
+		s = get_sample(log, cur_log, i);
+		ret = __deflate_pdu_buffer(s, sample_sz, &out_pdu, &entry, stream, first);
+		if (ret)
+			return ret;
+
+		/* Do the subtraction on server side so that client doesn't have to
+		 * reconstruct our linked list from packets.
+		 */
+		cur_plat_entry  = s->plat_entry;
+		prev_plat_entry = flist_first_entry(&cur_plat_entry->list, struct io_u_plat_entry, list);
+		cur_plat  = cur_plat_entry->io_u_plat;
+		prev_plat = prev_plat_entry->io_u_plat;
+
+		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
+			cur_plat[j] -= prev_plat[j];
+		}
+
+		flist_del(&prev_plat_entry->list);
+		free(prev_plat_entry);
+
+		ret = __deflate_pdu_buffer(cur_plat_entry, sizeof(*cur_plat_entry),
+					   &out_pdu, &entry, stream, first);
+
+		if (ret)
+			return ret;
+	}
+
+	__fio_net_prep_tail(stream, out_pdu, &entry, first);
+
+	return 0;
+}
+
 static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 				 struct io_logs *cur_log, z_stream *stream)
 {
@@ -1661,6 +1757,9 @@ static int __fio_append_iolog_gz(struct sk_entry *first, struct io_log *log,
 	void *out_pdu;
 	int ret;
 
+	if (log->log_type == IO_LOG_TYPE_HIST)
+		return __fio_append_iolog_gz_hist(first, log, cur_log, stream);
+
 	stream->next_in = (void *) cur_log->log;
 	stream->avail_in = cur_log->nr_samples * log_entry_sz(log);
 
@@ -1805,6 +1904,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	pdu.nr_samples = cpu_to_le64(iolog_nr_samples(log));
 	pdu.thread_number = cpu_to_le32(td->thread_number);
 	pdu.log_type = cpu_to_le32(log->log_type);
+	pdu.log_hist_coarseness = cpu_to_le32(log->hist_coarseness);
 
 	if (!flist_empty(&log->chunk_list))
 		pdu.compressed = __cpu_to_le32(STORE_COMPRESSED);
diff --git a/server.h b/server.h
index fb384fb..6c572a1 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 56,
+	FIO_SERVER_VER			= 57,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -183,6 +183,7 @@ struct cmd_iolog_pdu {
 	uint32_t log_type;
 	uint32_t compressed;
 	uint32_t log_offset;
+	uint32_t log_hist_coarseness;
 	uint8_t name[FIO_NET_NAME_MAX];
 	struct io_sample samples[0];
 };
