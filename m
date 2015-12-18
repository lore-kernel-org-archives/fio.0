Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33922 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbbLRNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a9udm-0000cB-LB
	for fio@vger.kernel.org; Fri, 18 Dec 2015 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151218130002.12B222C0EAA@kernel.dk>
Date: Fri, 18 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dde7b2361bf5b052a9c5c727bb2b062c604c7d42:

  gclient: don't free pdu on iolog return (2015-12-16 15:05:54 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dfc8e76c8d438da9861acfcdc96c46afe4339148:

  server: code cleanups (2015-12-17 15:23:48 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      Ensure that command line options also end up in json output
      client/server: various bug fixes
      Fix compile warning for !zlib
      client/server: transparent handling of storing compressed logs
      configure: fix zlib typo
      server: remove leftover debug statement
      server: code cleanups

 client.c  |  65 +++++++++++++++++++++++++----
 client.h  |   3 --
 gclient.c |   6 ---
 iolog.c   |  31 ++++++++++----
 iolog.h   |   9 ++++
 options.c |   9 ++--
 parse.c   |  44 ++++++++++++--------
 parse.h   |   2 +-
 server.c  | 139 ++++++++++++++++++++++++++++++++++++++++++++------------------
 server.h  |   5 +++
 10 files changed, 227 insertions(+), 86 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index f4b95d3..27a764d 100644
--- a/client.c
+++ b/client.c
@@ -70,6 +70,8 @@ static int error_clients;
 #define FIO_CLIENT_HASH_MASK	(FIO_CLIENT_HASH_SZ - 1)
 static struct flist_head client_hash[FIO_CLIENT_HASH_SZ];
 
+static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *, bool *);
+
 static void fio_client_add_hash(struct fio_client *client)
 {
 	int bucket = hash_long(client->fd, FIO_CLIENT_HASH_BITS);
@@ -1224,6 +1226,46 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 	fio_client_dec_jobs_eta(eta, client->ops->eta);
 }
 
+void fio_client_handle_iolog(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct cmd_iolog_pdu *pdu;
+	bool store_direct;
+
+	pdu = convert_iolog(cmd, &store_direct);
+	if (!pdu)
+		return;
+
+	if (store_direct) {
+		ssize_t ret;
+		size_t sz;
+		int fd;
+
+		fd = open((const char *) pdu->name,
+				O_WRONLY | O_CREAT | O_TRUNC, 0644);
+		if (fd < 0) {
+			perror("open log");
+			return;
+		}
+		sz = cmd->pdu_len - sizeof(*pdu);
+		ret = write(fd, pdu->samples, sz);
+		if (ret != sz)
+			log_err("fio: short write on compressed log\n");
+		close(fd);
+	} else {
+		FILE *f;
+
+		f = fopen((const char *) pdu->name, "w");
+		if (!f) {
+			perror("fopen log");
+			return;
+		}
+
+		flush_samples(f, pdu->samples,
+				pdu->nr_samples * sizeof(struct io_sample));
+		fclose(f);
+	}
+}
+
 static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_probe_reply_pdu *probe = (struct cmd_probe_reply_pdu *) cmd->payload;
@@ -1364,27 +1406,36 @@ err:
  * This has been compressed on the server side, since it can be big.
  * Uncompress here.
  */
-static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
+static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
+					   bool *store_direct)
 {
 	struct cmd_iolog_pdu *pdu = (struct cmd_iolog_pdu *) cmd->payload;
 	struct cmd_iolog_pdu *ret;
 	uint64_t i;
+	int compressed;
 	void *samples;
 
+	*store_direct = false;
+
 	/*
 	 * Convert if compressed and we support it. If it's not
 	 * compressed, we need not do anything.
 	 */
-	if (le32_to_cpu(pdu->compressed)) {
+	compressed = le32_to_cpu(pdu->compressed);
+	if (compressed == XMIT_COMPRESSED) {
 #ifndef CONFIG_ZLIB
 		log_err("fio: server sent compressed data by mistake\n");
 		return NULL;
 #endif
 		ret = convert_iolog_gz(cmd, pdu);
+		printf("compressed iolog, %p\n", ret);
 		if (!ret) {
 			log_err("fio: failed decompressing log\n");
 			return NULL;
 		}
+	} else if (compressed == STORE_COMPRESSED) {
+		*store_direct = true;
+		ret = pdu;
 	} else
 		ret = pdu;
 
@@ -1394,6 +1445,9 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
 
+	if (*store_direct)
+		return ret;
+
 	samples = &ret->samples[0];
 	for (i = 0; i < ret->nr_samples; i++) {
 		struct io_sample *s;
@@ -1550,12 +1604,7 @@ int fio_handle_client(struct fio_client *client)
 		break;
 		}
 	case FIO_NET_CMD_IOLOG:
-		if (ops->iolog) {
-			struct cmd_iolog_pdu *pdu;
-
-			pdu = convert_iolog(cmd);
-			ops->iolog(client, pdu);
-		}
+		fio_client_handle_iolog(client, cmd);
 		break;
 	case FIO_NET_CMD_UPDATE_JOB:
 		ops->update_job(client, cmd);
diff --git a/client.h b/client.h
index 035e606..7fe09d1 100644
--- a/client.h
+++ b/client.h
@@ -76,12 +76,10 @@ struct fio_client {
 	unsigned int nr_files;
 };
 
-struct cmd_iolog_pdu;
 typedef void (client_cmd_op)(struct fio_client *, struct fio_net_cmd *);
 typedef void (client_eta_op)(struct jobs_eta *je);
 typedef void (client_timed_out_op)(struct fio_client *);
 typedef void (client_jobs_eta_op)(struct fio_client *client, struct jobs_eta *je);
-typedef void (client_iolog_op)(struct fio_client *client, struct cmd_iolog_pdu *);
 
 struct client_ops {
 	client_cmd_op		*text;
@@ -98,7 +96,6 @@ struct client_ops {
 	client_cmd_op		*stop;
 	client_cmd_op		*start;
 	client_cmd_op		*job_start;
-	client_iolog_op		*iolog;
 	client_timed_out_op	*removed;
 
 	unsigned int eta_msec;
diff --git a/gclient.c b/gclient.c
index 949ad42..9c32474 100644
--- a/gclient.c
+++ b/gclient.c
@@ -693,11 +693,6 @@ static void gfio_client_job_start(struct fio_client *client, struct fio_net_cmd
 	gdk_threads_leave();
 }
 
-static void gfio_client_iolog(struct fio_client *client, struct cmd_iolog_pdu *pdu)
-{
-	printf("got iolog: name=%s, type=%u, entries=%lu\n", pdu->name, pdu->log_type, (unsigned long) pdu->nr_samples);
-}
-
 static void gfio_add_total_depths_tree(GtkListStore *model,
 				       struct thread_stat *ts, unsigned int len)
 {
@@ -1393,7 +1388,6 @@ struct client_ops gfio_client_ops = {
 	.stop			= gfio_client_stop,
 	.start			= gfio_client_start,
 	.job_start		= gfio_client_job_start,
-	.iolog			= gfio_client_iolog,
 	.removed		= gfio_client_removed,
 	.eta_msec		= FIO_CLIENT_DEF_ETA_MSEC,
 	.stay_connected		= 1,
diff --git a/iolog.c b/iolog.c
index d4a1017..feda9ed 100644
--- a/iolog.c
+++ b/iolog.c
@@ -634,7 +634,7 @@ void free_log(struct io_log *log)
 	free(log);
 }
 
-static void flush_samples(FILE *f, void *samples, uint64_t sample_size)
+void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 {
 	struct io_sample *s;
 	int log_offset;
@@ -682,13 +682,6 @@ struct iolog_flush_data {
 	uint64_t nr_samples;
 };
 
-struct iolog_compress {
-	struct flist_head list;
-	void *buf;
-	size_t len;
-	unsigned int seq;
-};
-
 #define GZ_CHUNK	131072
 
 static struct iolog_compress *get_new_chunk(unsigned int seq)
@@ -984,7 +977,7 @@ static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 	} else
 		fio_lock_file(log->filename);
 
-	if (td->client_type == FIO_CLIENT_TYPE_GUI)
+	if (td->client_type == FIO_CLIENT_TYPE_GUI || is_backend)
 		fio_send_iolog(td, log, log->filename);
 	else
 		flush_log(log, !td->o.per_job_logs);
@@ -994,6 +987,26 @@ static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 	return 0;
 }
 
+size_t log_chunk_sizes(struct io_log *log)
+{
+	struct flist_head *entry;
+	size_t ret;
+
+	if (flist_empty(&log->chunk_list))
+		return 0;
+
+	ret = 0;
+	pthread_mutex_lock(&log->chunk_lock);
+	flist_for_each(entry, &log->chunk_list) {
+		struct iolog_compress *c;
+
+		c = flist_entry(entry, struct iolog_compress, list);
+		ret += c->len;
+	}
+	pthread_mutex_unlock(&log->chunk_lock);
+	return ret;
+}
+
 #ifdef CONFIG_ZLIB
 
 static void drop_data_unlock(struct iolog_flush_data *data)
diff --git a/iolog.h b/iolog.h
index b99329a..297daf5 100644
--- a/iolog.h
+++ b/iolog.h
@@ -186,6 +186,7 @@ extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
 extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
+extern size_t log_chunk_sizes(struct io_log *);
 
 #ifdef CONFIG_ZLIB
 extern int iolog_file_inflate(const char *);
@@ -207,6 +208,7 @@ struct log_params {
 extern void finalize_logs(struct thread_data *td);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, int);
+extern void flush_samples(FILE *, void *, uint64_t);
 extern void free_log(struct io_log *);
 extern void fio_writeout_logs(struct thread_data *);
 extern int iolog_flush(struct io_log *, int);
@@ -217,4 +219,11 @@ static inline void init_ipo(struct io_piece *ipo)
 	INIT_FLIST_HEAD(&ipo->trim_list);
 }
 
+struct iolog_compress {
+	struct flist_head list;
+	void *buf;
+	size_t len;
+	unsigned int seq;
+};
+
 #endif
diff --git a/options.c b/options.c
index 964e263..45726aa 100644
--- a/options.c
+++ b/options.c
@@ -536,6 +536,7 @@ static int str_verify_cpus_allowed_cb(void *data, const char *input)
 	return set_cpus_allowed(td, &td->o.verify_cpumask, input);
 }
 
+#ifdef CONFIG_ZLIB
 static int str_log_cpus_allowed_cb(void *data, const char *input)
 {
 	struct thread_data *td = data;
@@ -545,8 +546,9 @@ static int str_log_cpus_allowed_cb(void *data, const char *input)
 
 	return set_cpus_allowed(td, &td->o.log_gz_cpumask, input);
 }
+#endif /* CONFIG_ZLIB */
 
-#endif
+#endif /* FIO_HAVE_CPU_AFFINITY */
 
 #ifdef CONFIG_LIBNUMA
 static int str_numa_cpunodes_cb(void *data, char *input)
@@ -4143,7 +4145,7 @@ int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 {
 	int ret;
 
-	ret = parse_cmd_option(opt, val, fio_options, td);
+	ret = parse_cmd_option(opt, val, fio_options, td, &td->opt_list);
 	if (!ret) {
 		struct fio_option *o;
 
@@ -4158,7 +4160,8 @@ int fio_cmd_option_parse(struct thread_data *td, const char *opt, char *val)
 int fio_cmd_ioengine_option_parse(struct thread_data *td, const char *opt,
 				char *val)
 {
-	return parse_cmd_option(opt, val, td->io_ops->options, td->eo);
+	return parse_cmd_option(opt, val, td->io_ops->options, td->eo,
+					&td->opt_list);
 }
 
 void fio_fill_default_options(struct thread_data *td)
diff --git a/parse.c b/parse.c
index 0ef00b8..ac1bee9 100644
--- a/parse.c
+++ b/parse.c
@@ -960,8 +960,27 @@ void sort_options(char **opts, struct fio_option *options, int num_opts)
 	__fio_options = NULL;
 }
 
+static void add_to_dump_list(struct fio_option *o, struct flist_head *dump_list,
+			     const char *post)
+{
+	struct print_option *p;
+
+	if (!dump_list)
+		return;
+
+	p = malloc(sizeof(*p));
+	p->name = strdup(o->name);
+	if (post)
+		p->value = strdup(post);
+	else
+		p->value = NULL;
+
+	flist_add_tail(&p->list, dump_list);
+}
+
 int parse_cmd_option(const char *opt, const char *val,
-		     struct fio_option *options, void *data)
+		     struct fio_option *options, void *data,
+		     struct flist_head *dump_list)
 {
 	struct fio_option *o;
 
@@ -971,11 +990,13 @@ int parse_cmd_option(const char *opt, const char *val,
 		return 1;
 	}
 
-	if (!handle_option(o, val, data))
-		return 0;
+	if (handle_option(o, val, data)) {
+		log_err("fio: failed parsing %s=%s\n", opt, val);
+		return 1;
+	}
 
-	log_err("fio: failed parsing %s=%s\n", opt, val);
-	return 1;
+	add_to_dump_list(o, dump_list, val);
+	return 0;
 }
 
 int parse_option(char *opt, const char *input,
@@ -1006,18 +1027,7 @@ int parse_option(char *opt, const char *input,
 		return 1;
 	}
 
-	if (dump_list) {
-		struct print_option *p = malloc(sizeof(*p));
-
-		p->name = strdup((*o)->name);
-		if (post)
-			p->value = strdup(post);
-		else
-			p->value = NULL;
-
-		flist_add_tail(&p->list, dump_list);
-	}
-
+	add_to_dump_list(*o, dump_list, post);
 	return 0;
 }
 
diff --git a/parse.h b/parse.h
index 1882810..3ba8047 100644
--- a/parse.h
+++ b/parse.h
@@ -82,7 +82,7 @@ typedef int (str_cb_fn)(void *, char *);
 
 extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, struct flist_head *);
 extern void sort_options(char **, struct fio_option *, int);
-extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, void *);
+extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, void *, struct flist_head *);
 extern int show_cmd_help(struct fio_option *, const char *);
 extern void fill_default_options(void *, struct fio_option *);
 extern void option_init(struct fio_option *);
diff --git a/server.c b/server.c
index f11e972..f53e2c8 100644
--- a/server.c
+++ b/server.c
@@ -37,6 +37,7 @@ enum {
 	SK_F_COPY	= 2,
 	SK_F_SIMPLE	= 4,
 	SK_F_VEC	= 8,
+	SK_F_INLINE	= 16,
 };
 
 struct sk_entry {
@@ -54,9 +55,10 @@ struct sk_out {
 				 * protected by below ->lock */
 
 	int sk;			/* socket fd to talk to client */
-	struct fio_mutex *lock;	/* protects ref and below list */
+	struct fio_mutex lock;	/* protects ref and below list */
 	struct flist_head list;	/* list of pending transmit work */
-	struct fio_mutex *wait;	/* wake backend when items added to list */
+	struct fio_mutex wait;	/* wake backend when items added to list */
+	struct fio_mutex xmit;	/* held while sending data */
 };
 
 static char *fio_server_arg;
@@ -116,12 +118,12 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 
 static void sk_lock(struct sk_out *sk_out)
 {
-	fio_mutex_down(sk_out->lock);
+	fio_mutex_down(&sk_out->lock);
 }
 
 static void sk_unlock(struct sk_out *sk_out)
 {
-	fio_mutex_up(sk_out->lock);
+	fio_mutex_up(&sk_out->lock);
 }
 
 void sk_out_assign(struct sk_out *sk_out)
@@ -137,8 +139,9 @@ void sk_out_assign(struct sk_out *sk_out)
 
 static void sk_out_free(struct sk_out *sk_out)
 {
-	fio_mutex_remove(sk_out->lock);
-	fio_mutex_remove(sk_out->wait);
+	__fio_mutex_remove(&sk_out->lock);
+	__fio_mutex_remove(&sk_out->wait);
+	__fio_mutex_remove(&sk_out->xmit);
 	sfree(sk_out);
 }
 
@@ -517,8 +520,9 @@ int fio_net_send_cmd(int fd, uint16_t opcode, const void *buf, off_t size,
 	return ret;
 }
 
-static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf, off_t size,
-					 uint64_t *tagptr, int flags)
+static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf,
+					 size_t size, uint64_t *tagptr,
+					 int flags)
 {
 	struct sk_entry *entry;
 
@@ -530,22 +534,28 @@ static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf, off_t size,
 		memcpy(entry->buf, buf, size);
 	} else
 		entry->buf = buf;
+
 	entry->size = size;
 	entry->tagptr = tagptr;
 	entry->flags = flags;
-
 	return entry;
 }
 
+static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry);
+
 static void fio_net_queue_entry(struct sk_entry *entry)
 {
 	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
 
-	sk_lock(sk_out);
-	flist_add_tail(&entry->list, &sk_out->list);
-	sk_unlock(sk_out);
+	if (entry->flags & SK_F_INLINE)
+		handle_sk_entry(sk_out, entry);
+	else {
+		sk_lock(sk_out);
+		flist_add_tail(&entry->list, &sk_out->list);
+		sk_unlock(sk_out);
 
-	fio_mutex_up(sk_out->wait);
+		fio_mutex_up(&sk_out->wait);
+	}
 }
 
 static int fio_net_queue_cmd(uint16_t opcode, void *buf, off_t size,
@@ -1102,17 +1112,24 @@ static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry)
 {
 	int ret;
 
+	fio_mutex_down(&sk_out->xmit);
+
 	if (entry->flags & SK_F_VEC)
 		ret = send_vec_entry(sk_out, entry);
-	if (entry->flags & SK_F_SIMPLE) {
+	else if (entry->flags & SK_F_SIMPLE) {
 		uint64_t tag = 0;
 
 		if (entry->tagptr)
 			tag = *entry->tagptr;
 
-		ret = fio_net_send_simple_cmd(sk_out->sk, entry->opcode, tag, NULL);
-	} else
-		ret = fio_net_send_cmd(sk_out->sk, entry->opcode, entry->buf, entry->size, entry->tagptr, NULL);
+		ret = fio_net_send_simple_cmd(sk_out->sk, entry->opcode, tag,
+						NULL);
+	} else {
+		ret = fio_net_send_cmd(sk_out->sk, entry->opcode, entry->buf,
+					entry->size, entry->tagptr, NULL);
+	}
+
+	fio_mutex_up(&sk_out->xmit);
 
 	if (ret)
 		log_err("fio: failed handling cmd %s\n", fio_server_op(entry->opcode));
@@ -1177,7 +1194,7 @@ static int handle_connection(struct sk_out *sk_out)
 				break;
 			} else if (!ret) {
 				fio_server_check_jobs(&job_list);
-				fio_mutex_down_timeout(sk_out->wait, timeout);
+				fio_mutex_down_timeout(&sk_out->wait, timeout);
 				continue;
 			}
 
@@ -1323,8 +1340,9 @@ static int accept_loop(int listen_sk)
 		sk_out = smalloc(sizeof(*sk_out));
 		sk_out->sk = sk;
 		INIT_FLIST_HEAD(&sk_out->list);
-		sk_out->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
-		sk_out->wait = fio_mutex_init(FIO_MUTEX_LOCKED);
+		__fio_mutex_init(&sk_out->lock, FIO_MUTEX_UNLOCKED);
+		__fio_mutex_init(&sk_out->wait, FIO_MUTEX_LOCKED);
+		__fio_mutex_init(&sk_out->xmit, FIO_MUTEX_UNLOCKED);
 
 		pid = fork();
 		if (pid) {
@@ -1609,7 +1627,7 @@ void fio_server_send_du(void)
 	}
 }
 
-static int fio_send_iolog_gz(struct sk_entry *first, struct io_log *log)
+static int fio_append_iolog_gz(struct sk_entry *first, struct io_log *log)
 {
 	int ret = 0;
 #ifdef CONFIG_ZLIB
@@ -1649,7 +1667,8 @@ static int fio_send_iolog_gz(struct sk_entry *first, struct io_log *log)
 		this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream.avail_out;
 
 		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
-						NULL, SK_F_FREE | SK_F_VEC);
+						NULL, SK_F_VEC | SK_F_INLINE | SK_F_FREE);
+		out_pdu = NULL;
 		flist_add_tail(&entry->list, &first->next);
 	} while (stream.avail_in);
 
@@ -1661,6 +1680,36 @@ err:
 	return ret;
 }
 
+static int fio_append_gz_chunks(struct sk_entry *first, struct io_log *log)
+{
+	struct sk_entry *entry;
+	struct flist_head *node;
+
+	pthread_mutex_lock(&log->chunk_lock);
+	flist_for_each(node, &log->chunk_list) {
+		struct iolog_compress *c;
+
+		c = flist_entry(node, struct iolog_compress, list);
+		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, c->buf, c->len,
+						NULL, SK_F_VEC | SK_F_INLINE);
+		flist_add_tail(&entry->list, &first->next);
+	}
+	pthread_mutex_unlock(&log->chunk_lock);
+
+	return 0;
+}
+
+static int fio_append_text_log(struct sk_entry *first, struct io_log *log)
+{
+	struct sk_entry *entry;
+	size_t size = log->nr_samples * log_entry_sz(log);
+
+	entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, log->log, size,
+					NULL, SK_F_VEC | SK_F_INLINE);
+	flist_add_tail(&entry->list, &first->next);
+	return 0;
+}
+
 int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 {
 	struct cmd_iolog_pdu pdu;
@@ -1670,11 +1719,21 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	pdu.nr_samples = cpu_to_le64(log->nr_samples);
 	pdu.thread_number = cpu_to_le32(td->thread_number);
 	pdu.log_type = cpu_to_le32(log->log_type);
-	pdu.compressed = cpu_to_le32(use_zlib);
+
+	if (!flist_empty(&log->chunk_list))
+		pdu.compressed = __cpu_to_le32(STORE_COMPRESSED);
+	else if (use_zlib)
+		pdu.compressed = __cpu_to_le32(XMIT_COMPRESSED);
+	else
+		pdu.compressed = 0;
 
 	strncpy((char *) pdu.name, name, FIO_NET_NAME_MAX);
 	pdu.name[FIO_NET_NAME_MAX - 1] = '\0';
 
+	/*
+	 * We can't do this for a pre-compressed log, but for that case,
+	 * log->nr_samples is zero anyway.
+	 */
 	for (i = 0; i < log->nr_samples; i++) {
 		struct io_sample *s = get_sample(log, i);
 
@@ -1693,23 +1752,22 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	/*
 	 * Assemble header entry first
 	 */
-	first = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, &pdu, sizeof(pdu), NULL, SK_F_COPY | SK_F_VEC);
+	first = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, &pdu, sizeof(pdu), NULL, SK_F_VEC | SK_F_INLINE | SK_F_COPY);
 
 	/*
-	 * Now append actual log entries. Compress if we can, otherwise just
-	 * plain text output.
+	 * Now append actual log entries. If log compression was enabled on
+	 * the job, just send out the compressed chunks directly. If we
+	 * have a plain log, compress if we can, then send. Otherwise, send
+	 * the plain text output.
 	 */
-	if (use_zlib)
-		ret = fio_send_iolog_gz(first, log);
-	else {
-		struct sk_entry *entry;
-
-		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, log->log,
-					log->nr_samples * log_entry_sz(log),
-					NULL, SK_F_FREE | SK_F_VEC);
-		flist_add_tail(&entry->list, &first->next);
-	}
+	if (!flist_empty(&log->chunk_list))
+		ret = fio_append_gz_chunks(first, log);
+	else if (use_zlib)
+		ret = fio_append_iolog_gz(first, log);
+	else
+		ret = fio_append_text_log(first, log);
 
+	fio_net_queue_entry(first);
 	return ret;
 }
 
@@ -1722,7 +1780,8 @@ void fio_server_send_add_job(struct thread_data *td)
 	pdu.groupid = cpu_to_le32(td->groupid);
 	convert_thread_options_to_net(&pdu.top, &td->o);
 
-	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL, SK_F_COPY);
+	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL,
+				SK_F_COPY);
 }
 
 void fio_server_send_start(struct thread_data *td)
@@ -1758,7 +1817,8 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	verify_state_gen_name((char *) out.path, sizeof(out.path), name, me,
 				threadnumber);
 	tag = (uint64_t) (uintptr_t) rep;
-	fio_net_queue_cmd(FIO_NET_CMD_SENDFILE, &out, sizeof(out), &tag, SK_F_COPY);
+	fio_net_queue_cmd(FIO_NET_CMD_SENDFILE, &out, sizeof(out), &tag,
+				SK_F_COPY);
 
 	/*
 	 * Wait for the backend to receive the reply
@@ -1769,7 +1829,8 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	}
 
 	if (rep->error) {
-		log_err("fio: failure on receiving state file: %s\n", strerror(rep->error));
+		log_err("fio: failure on receiving state file: %s\n",
+				strerror(rep->error));
 fail:
 		*datap = NULL;
 		sfree(rep);
diff --git a/server.h b/server.h
index dc4a419..5a59d07 100644
--- a/server.h
+++ b/server.h
@@ -172,6 +172,11 @@ struct cmd_text_pdu {
 	uint8_t buf[0];
 };
 
+enum {
+	XMIT_COMPRESSED		= 1U,
+	STORE_COMPRESSED	= 2U,
+};
+
 struct cmd_iolog_pdu {
 	uint64_t nr_samples;
 	uint32_t thread_number;
