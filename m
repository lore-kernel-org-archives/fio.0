Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932972AbbLPNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a9Bgf-0005ZD-Hb
	for fio@vger.kernel.org; Wed, 16 Dec 2015 13:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151216130001.A102D2C0178@kernel.dk>
Date: Wed, 16 Dec 2015 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1246147d5402d46ecb098dc06c9b31bf6810800c:

  Fio 2.2.13 (2015-12-14 14:53:35 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bc0fec0e12f19dd424f4bf83cfca89d434184c8d:

  client/server: ensure we don't overrun memory for long option values (2015-12-15 21:02:51 -0700)

----------------------------------------------------------------
Jens Axboe (20):
      server: rewrite message handling
      server: make the io log transmit use the new infrastructure
      server: cleanup and proper error returns
      Fixup and improve per-thread data
      server: comment sk_entry struct and remove hole
      server: ensure each connection sets up its own sk_out
      server: comments, and clear sk_out->sk when we close the 'sk'
      server: cleanup exported functions
      server: don't pass sk_out into accept loop
      server: create sk_out_key earlier
      client: make SEND_ETA timeout non-fatal
      server: bump listen() backlog
      Merge branch 'server'
      Rework 'dump_cmdline'
      First stab at adding job options to json output
      stat: work around 'numjobs' oddity in dumping job output
      client: cleanup json output
      client/server: pass back job options to client
      client: fix segfault for !json output
      client/server: ensure we don't overrun memory for long option values

 backend.c     |  55 ++++--
 client.c      | 109 ++++++++++-
 client.h      |   3 +
 fio.h         |  13 +-
 init.c        |  86 ++++++++-
 iolog.c       |  10 +-
 iolog.h       |   2 +-
 options.c     |   7 +-
 parse.c       |  17 +-
 parse.h       |   8 +-
 rate-submit.c |   5 +-
 rate-submit.h |   2 +-
 server.c      | 567 ++++++++++++++++++++++++++++++++++++++++++++++------------
 server.h      |  44 ++---
 stat.c        |  55 +++++-
 stat.h        |   2 +-
 workqueue.c   |  14 +-
 workqueue.h   |   3 +-
 18 files changed, 786 insertions(+), 216 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index c8554bc..c9875f4 100644
--- a/backend.c
+++ b/backend.c
@@ -1358,19 +1358,29 @@ static uint64_t do_dry_run(struct thread_data *td)
 	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
 }
 
+struct fork_data {
+	struct thread_data *td;
+	struct sk_out *sk_out;
+};
+
 /*
  * Entry point for the thread based jobs. The process based jobs end up
  * here as well, after a little setup.
  */
 static void *thread_main(void *data)
 {
+	struct fork_data *fd = data;
 	unsigned long long elapsed_us[DDIR_RWDIR_CNT] = { 0, };
-	struct thread_data *td = data;
+	struct thread_data *td = fd->td;
 	struct thread_options *o = &td->o;
+	struct sk_out *sk_out = fd->sk_out;
 	pthread_condattr_t attr;
 	int clear_state;
 	int ret;
 
+	sk_out_assign(sk_out);
+	free(fd);
+
 	if (!o->use_thread) {
 		setsid();
 		td->pid = getpid();
@@ -1550,12 +1560,12 @@ static void *thread_main(void *data)
 			goto err;
 	}
 
-	if (iolog_compress_init(td))
+	if (iolog_compress_init(td, sk_out))
 		goto err;
 
 	fio_verify_init(td);
 
-	if (rate_submit_init(td))
+	if (rate_submit_init(td, sk_out))
 		goto err;
 
 	fio_gettime(&td->epoch, NULL);
@@ -1702,6 +1712,7 @@ err:
 	 */
 	check_update_rusage(td);
 
+	sk_out_drop();
 	return (void *) (uintptr_t) td->error;
 }
 
@@ -1710,9 +1721,9 @@ err:
  * We cannot pass the td data into a forked process, so attach the td and
  * pass it to the thread worker.
  */
-static int fork_main(int shmid, int offset)
+static int fork_main(struct sk_out *sk_out, int shmid, int offset)
 {
-	struct thread_data *td;
+	struct fork_data *fd;
 	void *data, *ret;
 
 #if !defined(__hpux) && !defined(CONFIG_NO_SHM)
@@ -1730,8 +1741,10 @@ static int fork_main(int shmid, int offset)
 	data = threads;
 #endif
 
-	td = data + offset * sizeof(struct thread_data);
-	ret = thread_main(td);
+	fd = calloc(1, sizeof(*fd));
+	fd->td = data + offset * sizeof(struct thread_data);
+	fd->sk_out = sk_out;
+	ret = thread_main(fd);
 	shmdt(data);
 	return (int) (uintptr_t) ret;
 }
@@ -1956,7 +1969,7 @@ mounted:
 /*
  * Main function for kicking off and reaping jobs, as needed.
  */
-static void run_threads(void)
+static void run_threads(struct sk_out *sk_out)
 {
 	struct thread_data *td;
 	unsigned int i, todo, nr_running, m_rate, t_rate, nr_started;
@@ -2090,14 +2103,20 @@ reap:
 			nr_started++;
 
 			if (td->o.use_thread) {
+				struct fork_data *fd;
 				int ret;
 
+				fd = calloc(1, sizeof(*fd));
+				fd->td = td;
+				fd->sk_out = sk_out;
+
 				dprint(FD_PROCESS, "will pthread_create\n");
 				ret = pthread_create(&td->thread, NULL,
-							thread_main, td);
+							thread_main, fd);
 				if (ret) {
 					log_err("pthread_create: %s\n",
 							strerror(ret));
+					free(fd);
 					nr_started--;
 					break;
 				}
@@ -2110,7 +2129,7 @@ reap:
 				dprint(FD_PROCESS, "will fork\n");
 				pid = fork();
 				if (!pid) {
-					int ret = fork_main(shm_id, i);
+					int ret = fork_main(sk_out, shm_id, i);
 
 					_exit(ret);
 				} else if (i == fio_debug_jobno)
@@ -2220,11 +2239,10 @@ static void free_disk_util(void)
 
 static void *helper_thread_main(void *data)
 {
-	struct backend_data *d = data;
+	struct sk_out *sk_out = data;
 	int ret = 0;
 
-	if (d)
-		pthread_setspecific(d->key, d->ptr);
+	sk_out_assign(sk_out);
 
 	fio_mutex_up(startup_mutex);
 
@@ -2256,10 +2274,11 @@ static void *helper_thread_main(void *data)
 			print_thread_status();
 	}
 
+	sk_out_drop();
 	return NULL;
 }
 
-static int create_helper_thread(struct backend_data *data)
+static int create_helper_thread(struct sk_out *sk_out)
 {
 	int ret;
 
@@ -2268,7 +2287,7 @@ static int create_helper_thread(struct backend_data *data)
 	pthread_cond_init(&helper_cond, NULL);
 	pthread_mutex_init(&helper_lock, NULL);
 
-	ret = pthread_create(&helper_thread, NULL, helper_thread_main, data);
+	ret = pthread_create(&helper_thread, NULL, helper_thread_main, sk_out);
 	if (ret) {
 		log_err("Can't create helper thread: %s\n", strerror(ret));
 		return 1;
@@ -2280,7 +2299,7 @@ static int create_helper_thread(struct backend_data *data)
 	return 0;
 }
 
-int fio_backend(struct backend_data *data)
+int fio_backend(struct sk_out *sk_out)
 {
 	struct thread_data *td;
 	int i;
@@ -2310,12 +2329,12 @@ int fio_backend(struct backend_data *data)
 
 	set_genesis_time();
 	stat_init();
-	create_helper_thread(data);
+	create_helper_thread(sk_out);
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	INIT_FLIST_HEAD(cgroup_list);
 
-	run_threads();
+	run_threads(sk_out);
 
 	wait_for_helper_thread_exit();
 
diff --git a/client.c b/client.c
index 2cba8a0..637cd3f 100644
--- a/client.c
+++ b/client.c
@@ -59,6 +59,7 @@ int sum_stat_clients;
 
 static int sum_stat_nr;
 static struct json_object *root = NULL;
+static struct json_object *job_opt_object = NULL;
 static struct json_array *clients_array = NULL;
 static struct json_array *du_array = NULL;
 
@@ -117,10 +118,23 @@ static int read_data(int fd, void *data, size_t size)
 
 static void fio_client_json_init(void)
 {
+	char time_buf[32];
+	time_t time_p;
+
 	if (!(output_format & FIO_OUTPUT_JSON))
 		return;
+
+	time(&time_p);
+	os_ctime_r((const time_t *) &time_p, time_buf, sizeof(time_buf));
+	time_buf[strlen(time_buf) - 1] = '\0';
+
 	root = json_create_object();
 	json_object_add_value_string(root, "fio version", fio_version_string);
+	json_object_add_value_int(root, "timestamp", time_p);
+	json_object_add_value_string(root, "time", time_buf);
+
+	job_opt_object = json_create_object();
+	json_object_add_value_object(root, "global options", job_opt_object);
 	clients_array = json_create_array();
 	json_object_add_value_array(root, "client_stats", clients_array);
 	du_array = json_create_array();
@@ -131,6 +145,8 @@ static void fio_client_json_fini(void)
 {
 	if (!(output_format & FIO_OUTPUT_JSON))
 		return;
+
+	log_info("\n");
 	json_print_object(root, NULL);
 	log_info("\n");
 	json_free_object(root);
@@ -174,6 +190,8 @@ void fio_put_client(struct fio_client *client)
 	}
 	if (client->files)
 		free(client->files);
+	if (client->opt_lists)
+		free(client->opt_lists);
 
 	if (!client->did_stat)
 		sum_stat_clients--;
@@ -934,9 +952,13 @@ static void json_object_add_client_info(struct json_object *obj,
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
+	struct flist_head *opt_list = NULL;
 	struct json_object *tsobj;
 
-	tsobj = show_thread_status(&p->ts, &p->rs, NULL);
+	if (client->opt_lists && p->ts.thread_number <= client->jobs)
+		opt_list = &client->opt_lists[p->ts.thread_number - 1];
+
+	tsobj = show_thread_status(&p->ts, &p->rs, opt_list, NULL);
 	client->did_stat = 1;
 	if (tsobj) {
 		json_object_add_client_info(tsobj, client);
@@ -956,7 +978,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		tsobj = show_thread_status(&client_ts, &client_gs, NULL);
+		tsobj = show_thread_status(&client_ts, &client_gs, NULL, NULL);
 		if (tsobj) {
 			json_object_add_client_info(tsobj, client);
 			json_array_add_value_object(clients_array, tsobj);
@@ -968,7 +990,41 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
 
-	show_group_stats(gs, NULL);
+	if (output_format & FIO_OUTPUT_NORMAL)
+		show_group_stats(gs, NULL);
+}
+
+static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
+{
+	struct cmd_job_option *pdu = (struct cmd_job_option *) cmd->payload;
+	struct print_option *p;
+
+	if (!job_opt_object)
+		return;
+
+	pdu->global = le16_to_cpu(pdu->global);
+	pdu->truncated = le16_to_cpu(pdu->truncated);
+	pdu->groupid = le32_to_cpu(pdu->groupid);
+
+	p = malloc(sizeof(*p));
+	p->name = strdup((char *) pdu->name);
+	if (pdu->value[0] != '\0')
+		p->value = strdup((char *) pdu->value);
+	else
+		p->value = NULL;
+
+	if (pdu->global) {
+		const char *pos = "";
+
+		if (p->value)
+			pos = p->value;
+
+		json_object_add_value_string(job_opt_object, p->name, pos);
+	} else if (client->opt_lists) {
+		struct flist_head *opt_list = &client->opt_lists[pdu->groupid];
+
+		flist_add_tail(&p->list, opt_list);
+	}
 }
 
 static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -1159,6 +1215,7 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	client->eta_in_flight = NULL;
 	flist_del_init(&client->eta_list);
+	client->eta_timeouts = 0;
 
 	if (client->ops->jobs_eta)
 		client->ops->jobs_eta(client, je);
@@ -1200,6 +1257,17 @@ static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd)
 	client->jobs = le32_to_cpu(pdu->jobs);
 	client->nr_stat = le32_to_cpu(pdu->stat_outputs);
 
+	if (client->jobs) {
+		int i;
+
+		if (client->opt_lists)
+			free(client->opt_lists);
+
+		client->opt_lists = malloc(client->jobs * sizeof(struct flist_head));
+		for (i = 0; i < client->jobs; i++)
+			INIT_FLIST_HEAD(&client->opt_lists[i]);
+	}
+
 	sum_stat_clients += client->nr_stat;
 }
 
@@ -1512,6 +1580,10 @@ int fio_handle_client(struct fio_client *client)
 		send_file(client, pdu, cmd->tag);
 		break;
 		}
+	case FIO_NET_CMD_JOB_OPT: {
+		handle_job_opt(client, cmd);
+		break;
+	}
 	default:
 		log_err("fio: unknown client op: %s\n", fio_server_op(cmd->opcode));
 		break;
@@ -1588,6 +1660,34 @@ static void request_client_etas(struct client_ops *ops)
 	dprint(FD_NET, "client: requested eta tag %p\n", eta);
 }
 
+/*
+ * A single SEND_ETA timeout isn't fatal. Attempt to recover.
+ */
+static int handle_cmd_timeout(struct fio_client *client,
+			      struct fio_net_cmd_reply *reply)
+{
+	if (reply->opcode != FIO_NET_CMD_SEND_ETA)
+		return 1;
+
+	log_info("client <%s>: timeout on SEND_ETA\n", client->hostname);
+	flist_del(&reply->list);
+	free(reply);
+
+	flist_del_init(&client->eta_list);
+	if (client->eta_in_flight) {
+		fio_client_dec_jobs_eta(client->eta_in_flight, client->ops->eta);
+		client->eta_in_flight = NULL;
+	}
+
+	/*
+	 * If we fail 5 in a row, give up...
+	 */
+	if (client->eta_timeouts++ > 5)
+		return 1;
+
+	return 0;
+}
+
 static int client_check_cmd_timeout(struct fio_client *client,
 				    struct timeval *now)
 {
@@ -1601,6 +1701,9 @@ static int client_check_cmd_timeout(struct fio_client *client,
 		if (mtime_since(&reply->tv, now) < FIO_NET_CLIENT_TIMEOUT)
 			continue;
 
+		if (!handle_cmd_timeout(client, reply))
+			continue;
+
 		log_err("fio: client %s, timeout on cmd %s\n", client->hostname,
 						fio_server_op(reply->opcode));
 		flist_del(&reply->list);
diff --git a/client.h b/client.h
index cfb0b4d..035e606 100644
--- a/client.h
+++ b/client.h
@@ -41,6 +41,8 @@ struct fio_client {
 
 	char *name;
 
+	struct flist_head *opt_lists;
+
 	int state;
 
 	int skip_newline;
@@ -60,6 +62,7 @@ struct fio_client {
 
 	struct flist_head eta_list;
 	struct client_eta *eta_in_flight;
+	unsigned int eta_timeouts;
 
 	struct flist_head cmd_list;
 
diff --git a/fio.h b/fio.h
index 63778b6..ddc29db 100644
--- a/fio.h
+++ b/fio.h
@@ -111,16 +111,16 @@ enum {
  * Per-thread/process specific data. Only used for the network client
  * for now.
  */
-struct backend_data {
-	pthread_key_t key;
-	void *ptr;
-};
+struct sk_out;
+void sk_out_assign(struct sk_out *);
+void sk_out_drop(void);
 
 /*
  * This describes a single thread/process executing a fio job.
  */
 struct thread_data {
 	struct thread_options o;
+	struct flist_head opt_list;
 	unsigned long flags;
 	void *eo;
 	char verror[FIO_VERROR_SIZE];
@@ -477,10 +477,10 @@ extern int __must_check fio_init_options(void);
 extern int __must_check parse_options(int, char **);
 extern int parse_jobs_ini(char *, int, int, int);
 extern int parse_cmd_line(int, char **, int);
-extern int fio_backend(struct backend_data *);
+extern int fio_backend(struct sk_out *);
 extern void reset_fio_state(void);
 extern void clear_io_state(struct thread_data *, int);
-extern int fio_options_parse(struct thread_data *, char **, int, int);
+extern int fio_options_parse(struct thread_data *, char **, int);
 extern void fio_keywords_init(void);
 extern void fio_keywords_exit(void);
 extern int fio_cmd_option_parse(struct thread_data *, const char *, char *);
@@ -499,6 +499,7 @@ extern int parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
 extern int fio_set_fd_nonblocking(int, const char *);
 extern void sig_show_status(int sig);
+extern struct thread_data *get_global_options(void);
 
 extern uintptr_t page_mask;
 extern uintptr_t page_size;
diff --git a/init.c b/init.c
index 63ba324..8773138 100644
--- a/init.c
+++ b/init.c
@@ -385,6 +385,68 @@ static void set_cmd_options(struct thread_data *td)
 		o->timeout = def_timeout;
 }
 
+static void dump_print_option(struct print_option *p)
+{
+	const char *delim;
+
+	if (!strcmp("description", p->name))
+		delim = "\"";
+	else
+		delim = "";
+
+	log_info("--%s%s", p->name, p->value ? "" : " ");
+	if (p->value)
+		log_info("=%s%s%s ", delim, p->value, delim);
+}
+
+static void dump_opt_list(struct thread_data *td)
+{
+	struct flist_head *entry;
+	struct print_option *p;
+
+	if (flist_empty(&td->opt_list))
+		return;
+
+	flist_for_each(entry, &td->opt_list) {
+		p = flist_entry(entry, struct print_option, list);
+		dump_print_option(p);
+	}
+}
+
+static void fio_dump_options_free(struct thread_data *td)
+{
+	while (!flist_empty(&td->opt_list)) {
+		struct print_option *p;
+
+		p = flist_first_entry(&td->opt_list, struct print_option, list);
+		flist_del_init(&p->list);
+		free(p->name);
+		free(p->value);
+		free(p);
+	}
+}
+
+static void copy_opt_list(struct thread_data *dst, struct thread_data *src)
+{
+	struct flist_head *entry;
+
+	if (flist_empty(&src->opt_list))
+		return;
+
+	flist_for_each(entry, &src->opt_list) {
+		struct print_option *srcp, *dstp;
+
+		srcp = flist_entry(entry, struct print_option, list);
+		dstp = malloc(sizeof(*dstp));
+		dstp->name = strdup(srcp->name);
+		if (srcp->value)
+			dstp->value = strdup(srcp->value);
+		else
+			dstp->value = NULL;
+		flist_add_tail(&dstp->list, &dst->opt_list);
+	}
+}
+
 /*
  * Return a free job structure.
  */
@@ -410,6 +472,10 @@ static struct thread_data *get_new_job(int global, struct thread_data *parent,
 	td = &threads[thread_number++];
 	*td = *parent;
 
+	INIT_FLIST_HEAD(&td->opt_list);
+	if (parent != &def_thread)
+		copy_opt_list(td, parent);
+
 	td->io_ops = NULL;
 	if (!preserve_eo)
 		td->eo = NULL;
@@ -446,6 +512,7 @@ static void put_job(struct thread_data *td)
 		log_info("fio: %s\n", td->verror);
 
 	fio_options_free(td);
+	fio_dump_options_free(td);
 	if (td->io_ops)
 		free_ioengine(td);
 
@@ -1444,9 +1511,9 @@ void add_job_opts(const char **o, int client_type)
 			td = get_new_job(0, td_parent, 0, jobname);
 		}
 		if (in_global)
-			fio_options_parse(td_parent, (char **) &o[i], 1, 0);
+			fio_options_parse(td_parent, (char **) &o[i], 1);
 		else
-			fio_options_parse(td, (char **) &o[i], 1, 0);
+			fio_options_parse(td, (char **) &o[i], 1);
 		i++;
 	}
 
@@ -1686,10 +1753,13 @@ int __parse_jobs_ini(struct thread_data *td,
 			goto out;
 		}
 
-		ret = fio_options_parse(td, opts, num_opts, dump_cmdline);
-		if (!ret)
+		ret = fio_options_parse(td, opts, num_opts);
+		if (!ret) {
+			if (dump_cmdline)
+				dump_opt_list(td);
+
 			ret = add_job(td, name, 0, 0, type);
-		else {
+		} else {
 			log_err("fio: job %s dropped\n", name);
 			put_job(td);
 		}
@@ -1727,6 +1797,7 @@ int parse_jobs_ini(char *file, int is_buf, int stonewall_flag, int type)
 static int fill_def_thread(void)
 {
 	memset(&def_thread, 0, sizeof(def_thread));
+	INIT_FLIST_HEAD(&def_thread.opt_list);
 
 	fio_getaffinity(getpid(), &def_thread.o.cpumask);
 	def_thread.o.error_dump = 1;
@@ -2585,3 +2656,8 @@ void options_default_fill(struct thread_options *o)
 {
 	memcpy(o, &def_thread.o, sizeof(*o));
 }
+
+struct thread_data *get_global_options(void)
+{
+	return &def_thread;
+}
diff --git a/iolog.c b/iolog.c
index e674171..d4a1017 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1133,15 +1133,15 @@ static int gz_init_worker(struct submit_worker *sw)
 static struct workqueue_ops log_compress_wq_ops = {
 	.fn		= gz_work,
 	.init_worker_fn	= gz_init_worker,
-	.nice	= 1,
+	.nice		= 1,
 };
 
-int iolog_compress_init(struct thread_data *td)
+int iolog_compress_init(struct thread_data *td, struct sk_out *sk_out)
 {
 	if (!(td->flags & TD_F_COMPRESS_LOG))
 		return 0;
 
-	workqueue_init(td, &td->log_compress_wq, &log_compress_wq_ops, 1);
+	workqueue_init(td, &td->log_compress_wq, &log_compress_wq_ops, 1, sk_out);
 	return 0;
 }
 
@@ -1164,6 +1164,8 @@ int iolog_flush(struct io_log *log, int wait)
 {
 	struct iolog_flush_data *data;
 
+	io_u_quiesce(log->td);
+
 	data = malloc(sizeof(*data));
 	if (!data)
 		return 1;
@@ -1205,7 +1207,7 @@ int iolog_flush(struct io_log *log, int wait)
 	return 1;
 }
 
-int iolog_compress_init(struct thread_data *td)
+int iolog_compress_init(struct thread_data *td, struct sk_out *sk_out)
 {
 	return 0;
 }
diff --git a/iolog.h b/iolog.h
index 6f027ca..b99329a 100644
--- a/iolog.h
+++ b/iolog.h
@@ -184,7 +184,7 @@ extern void trim_io_piece(struct thread_data *, const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
-extern int iolog_compress_init(struct thread_data *);
+extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 
 #ifdef CONFIG_ZLIB
diff --git a/options.c b/options.c
index 46d5fb9..964e263 100644
--- a/options.c
+++ b/options.c
@@ -4079,8 +4079,7 @@ static void show_closest_option(const char *opt)
 	free(name);
 }
 
-int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
-			int dump_cmdline)
+int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 {
 	int i, ret, unknown;
 	char **opts_copy;
@@ -4091,7 +4090,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 	for (ret = 0, i = 0, unknown = 0; i < num_opts; i++) {
 		struct fio_option *o;
 		int newret = parse_option(opts_copy[i], opts[i], fio_options,
-						&o, td, dump_cmdline);
+						&o, td, &td->opt_list);
 
 		if (!newret && o)
 			fio_option_mark_set(&td->o, o);
@@ -4124,7 +4123,7 @@ int fio_options_parse(struct thread_data *td, char **opts, int num_opts,
 			if (td->eo)
 				newret = parse_option(opts_copy[i], opts[i],
 						      td->io_ops->options, &o,
-						      td->eo, dump_cmdline);
+						      td->eo, &td->opt_list);
 
 			ret |= newret;
 			if (!o) {
diff --git a/parse.c b/parse.c
index e330dea..df42e22 100644
--- a/parse.c
+++ b/parse.c
@@ -978,7 +978,7 @@ int parse_cmd_option(const char *opt, const char *val,
 
 int parse_option(char *opt, const char *input,
 		 struct fio_option *options, struct fio_option **o, void *data,
-		 int dump_cmdline)
+		 struct flist_head *dump_list)
 {
 	char *post;
 
@@ -1004,17 +1004,16 @@ int parse_option(char *opt, const char *input,
 		return 1;
 	}
 
-	if (dump_cmdline) {
-		const char *delim;
+	if (dump_list) {
+		struct print_option *p = malloc(sizeof(*p));
 
-		if (!strcmp("description", (*o)->name))
-			delim = "\"";
+		p->name = strdup((*o)->name);
+		if (post)
+			p->value = strdup(post);
 		else
-			delim = "";
+			p->value = NULL;
 
-		log_info("--%s%s", (*o)->name, post ? "" : " ");
-		if (post)
-			log_info("=%s%s%s ", delim, post, delim);
+		flist_add_tail(&p->list, dump_list);
 	}
 
 	return 0;
diff --git a/parse.h b/parse.h
index 0a813b0..1882810 100644
--- a/parse.h
+++ b/parse.h
@@ -80,7 +80,7 @@ struct fio_option {
 
 typedef int (str_cb_fn)(void *, char *);
 
-extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, int);
+extern int parse_option(char *, const char *, struct fio_option *, struct fio_option **, void *, struct flist_head *);
 extern void sort_options(char **, struct fio_option *, int);
 extern int parse_cmd_option(const char *t, const char *l, struct fio_option *, void *);
 extern int show_cmd_help(struct fio_option *, const char *);
@@ -124,4 +124,10 @@ static inline int parse_is_percent(unsigned long long val)
 	return val <= -1ULL && val >= (-1ULL - 100ULL);
 }
 
+struct print_option {
+	struct flist_head list;
+	char *name;
+	char *value;
+};
+
 #endif
diff --git a/rate-submit.c b/rate-submit.c
index 39b552d..92cb622 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -7,6 +7,7 @@
 #include "fio.h"
 #include "ioengine.h"
 #include "lib/getrusage.h"
+#include "rate-submit.h"
 
 static int io_workqueue_fn(struct submit_worker *sw,
 			   struct workqueue_work *work)
@@ -235,12 +236,12 @@ static struct workqueue_ops rated_wq_ops = {
 	.exit_worker_fn		= io_workqueue_exit_worker_fn,
 };
 
-int rate_submit_init(struct thread_data *td)
+int rate_submit_init(struct thread_data *td, struct sk_out *sk_out)
 {
 	if (td->o.io_submit_mode != IO_MODE_OFFLOAD)
 		return 0;
 
-	return workqueue_init(td, &td->io_wq, &rated_wq_ops, td->o.iodepth);
+	return workqueue_init(td, &td->io_wq, &rated_wq_ops, td->o.iodepth, sk_out);
 }
 
 void rate_submit_exit(struct thread_data *td)
diff --git a/rate-submit.h b/rate-submit.h
index b4ca129..19fde3a 100644
--- a/rate-submit.h
+++ b/rate-submit.h
@@ -1,7 +1,7 @@
 #ifndef FIO_RATE_SUBMIT
 #define FIO_RATE_SUBMIT
 
-int rate_submit_init(struct thread_data *);
+int rate_submit_init(struct thread_data *, struct sk_out *);
 void rate_submit_exit(struct thread_data *);
 
 #endif
diff --git a/server.c b/server.c
index 27ea282..f11e972 100644
--- a/server.c
+++ b/server.c
@@ -32,7 +32,33 @@ int fio_net_port = FIO_NET_PORT;
 
 int exit_backend = 0;
 
-static int server_fd = -1;
+enum {
+	SK_F_FREE	= 1,
+	SK_F_COPY	= 2,
+	SK_F_SIMPLE	= 4,
+	SK_F_VEC	= 8,
+};
+
+struct sk_entry {
+	struct flist_head list;	/* link on sk_out->list */
+	int flags;		/* SK_F_* */
+	int opcode;		/* Actual command fields */
+	void *buf;
+	off_t size;
+	uint64_t *tagptr;
+	struct flist_head next;	/* Other sk_entry's, if linked command */
+};
+
+struct sk_out {
+	unsigned int refs;	/* frees sk_out when it drops to zero.
+				 * protected by below ->lock */
+
+	int sk;			/* socket fd to talk to client */
+	struct fio_mutex *lock;	/* protects ref and below list */
+	struct flist_head list;	/* list of pending transmit work */
+	struct fio_mutex *wait;	/* wake backend when items added to list */
+};
+
 static char *fio_server_arg;
 static char *bind_sock;
 static struct sockaddr_in saddr_in;
@@ -46,6 +72,8 @@ static unsigned int has_zlib = 0;
 static unsigned int use_zlib;
 static char me[128];
 
+static pthread_key_t sk_out_key;
+
 struct fio_fork_item {
 	struct flist_head list;
 	int exitval;
@@ -86,6 +114,82 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"SENDFILE",
 };
 
+static void sk_lock(struct sk_out *sk_out)
+{
+	fio_mutex_down(sk_out->lock);
+}
+
+static void sk_unlock(struct sk_out *sk_out)
+{
+	fio_mutex_up(sk_out->lock);
+}
+
+void sk_out_assign(struct sk_out *sk_out)
+{
+	if (!sk_out)
+		return;
+
+	sk_lock(sk_out);
+	sk_out->refs++;
+	sk_unlock(sk_out);
+	pthread_setspecific(sk_out_key, sk_out);
+}
+
+static void sk_out_free(struct sk_out *sk_out)
+{
+	fio_mutex_remove(sk_out->lock);
+	fio_mutex_remove(sk_out->wait);
+	sfree(sk_out);
+}
+
+static int __sk_out_drop(struct sk_out *sk_out)
+{
+	if (sk_out) {
+		int refs;
+
+		sk_lock(sk_out);
+		refs = --sk_out->refs;
+		sk_unlock(sk_out);
+
+		if (!refs) {
+			sk_out_free(sk_out);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+void sk_out_drop(void)
+{
+	struct sk_out *sk_out;
+
+	sk_out = pthread_getspecific(sk_out_key);
+	if (!__sk_out_drop(sk_out))
+		pthread_setspecific(sk_out_key, NULL);
+}
+
+static void __fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
+			       uint32_t pdu_len, uint64_t tag)
+{
+	memset(cmd, 0, sizeof(*cmd));
+
+	cmd->version	= __cpu_to_le16(FIO_SERVER_VER);
+	cmd->opcode	= cpu_to_le16(opcode);
+	cmd->tag	= cpu_to_le64(tag);
+	cmd->pdu_len	= cpu_to_le32(pdu_len);
+}
+
+
+static void fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
+			     const void *pdu, uint32_t pdu_len, uint64_t tag)
+{
+	__fio_init_net_cmd(cmd, opcode, pdu_len, tag);
+
+	if (pdu)
+		memcpy(&cmd->payload, pdu, pdu_len);
+}
+
 const char *fio_server_op(unsigned int op)
 {
 	static char buf[32];
@@ -142,13 +246,10 @@ static int fio_sendv_data(int sk, struct iovec *iov, int count)
 	if (!total_len)
 		return 0;
 
-	if (errno)
-		return -errno;
-
 	return 1;
 }
 
-int fio_send_data(int sk, const void *p, unsigned int len)
+static int fio_send_data(int sk, const void *p, unsigned int len)
 {
 	struct iovec iov = { .iov_base = (void *) p, .iov_len = len };
 
@@ -157,7 +258,7 @@ int fio_send_data(int sk, const void *p, unsigned int len)
 	return fio_sendv_data(sk, &iov, 1);
 }
 
-int fio_recv_data(int sk, void *p, unsigned int len)
+static int fio_recv_data(int sk, void *p, unsigned int len)
 {
 	do {
 		int ret = recv(sk, p, len, MSG_WAITALL);
@@ -349,7 +450,7 @@ static void free_reply(uint64_t tag)
 	free(reply);
 }
 
-void fio_net_cmd_crc_pdu(struct fio_net_cmd *cmd, const void *pdu)
+static void fio_net_cmd_crc_pdu(struct fio_net_cmd *cmd, const void *pdu)
 {
 	uint32_t pdu_len;
 
@@ -359,7 +460,7 @@ void fio_net_cmd_crc_pdu(struct fio_net_cmd *cmd, const void *pdu)
 	cmd->pdu_crc16 = __cpu_to_le16(fio_crc16(pdu, pdu_len));
 }
 
-void fio_net_cmd_crc(struct fio_net_cmd *cmd)
+static void fio_net_cmd_crc(struct fio_net_cmd *cmd)
 {
 	fio_net_cmd_crc_pdu(cmd, cmd->payload);
 }
@@ -416,6 +517,47 @@ int fio_net_send_cmd(int fd, uint16_t opcode, const void *buf, off_t size,
 	return ret;
 }
 
+static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf, off_t size,
+					 uint64_t *tagptr, int flags)
+{
+	struct sk_entry *entry;
+
+	entry = smalloc(sizeof(*entry));
+	INIT_FLIST_HEAD(&entry->next);
+	entry->opcode = opcode;
+	if (flags & SK_F_COPY) {
+		entry->buf = smalloc(size);
+		memcpy(entry->buf, buf, size);
+	} else
+		entry->buf = buf;
+	entry->size = size;
+	entry->tagptr = tagptr;
+	entry->flags = flags;
+
+	return entry;
+}
+
+static void fio_net_queue_entry(struct sk_entry *entry)
+{
+	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
+
+	sk_lock(sk_out);
+	flist_add_tail(&entry->list, &sk_out->list);
+	sk_unlock(sk_out);
+
+	fio_mutex_up(sk_out->wait);
+}
+
+static int fio_net_queue_cmd(uint16_t opcode, void *buf, off_t size,
+			     uint64_t *tagptr, int flags)
+{
+	struct sk_entry *entry;
+
+	entry = fio_net_prep_cmd(opcode, buf, size, tagptr, flags);
+	fio_net_queue_entry(entry);
+	return 0;
+}
+
 static int fio_net_send_simple_stack_cmd(int sk, uint16_t opcode, uint64_t tag)
 {
 	struct fio_net_cmd cmd;
@@ -452,6 +594,13 @@ int fio_net_send_simple_cmd(int sk, uint16_t opcode, uint64_t tag,
 	return 0;
 }
 
+static int fio_net_queue_quit(void)
+{
+	dprint(FD_NET, "server: sending quit\n");
+
+	return fio_net_queue_cmd(FIO_NET_CMD_QUIT, NULL, 0, 0, SK_F_SIMPLE);
+}
+
 int fio_net_send_quit(int sk)
 {
 	dprint(FD_NET, "server: sending quit\n");
@@ -459,8 +608,7 @@ int fio_net_send_quit(int sk)
 	return fio_net_send_simple_cmd(sk, FIO_NET_CMD_QUIT, 0, NULL);
 }
 
-static int fio_net_send_ack(int sk, struct fio_net_cmd *cmd, int error,
-			    int signal)
+static int fio_net_send_ack(struct fio_net_cmd *cmd, int error, int signal)
 {
 	struct cmd_end_pdu epdu;
 	uint64_t tag = 0;
@@ -470,13 +618,13 @@ static int fio_net_send_ack(int sk, struct fio_net_cmd *cmd, int error,
 
 	epdu.error = __cpu_to_le32(error);
 	epdu.signal = __cpu_to_le32(signal);
-	return fio_net_send_cmd(sk, FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, NULL);
+	return fio_net_queue_cmd(FIO_NET_CMD_STOP, &epdu, sizeof(epdu), &tag, SK_F_COPY);
 }
 
-int fio_net_send_stop(int sk, int error, int signal)
+static int fio_net_queue_stop(int error, int signal)
 {
 	dprint(FD_NET, "server: sending stop (%d, %d)\n", error, signal);
-	return fio_net_send_ack(sk, NULL, error, signal);
+	return fio_net_send_ack(NULL, error, signal);
 }
 
 static void fio_server_add_fork_item(pid_t pid, struct flist_head *list)
@@ -527,20 +675,23 @@ static void fio_server_check_fork_item(struct fio_fork_item *ffi)
 	}
 }
 
-static void fio_server_fork_item_done(struct fio_fork_item *ffi)
+static void fio_server_fork_item_done(struct fio_fork_item *ffi, bool stop)
 {
 	dprint(FD_NET, "pid %u exited, sig=%u, exitval=%d\n", (int) ffi->pid, ffi->signal, ffi->exitval);
 
 	/*
 	 * Fold STOP and QUIT...
 	 */
-	fio_net_send_stop(server_fd, ffi->exitval, ffi->signal);
-	fio_net_send_quit(server_fd);
+	if (stop) {
+		fio_net_queue_stop(ffi->exitval, ffi->signal);
+		fio_net_queue_quit();
+	}
+
 	flist_del(&ffi->list);
 	free(ffi);
 }
 
-static void fio_server_check_fork_items(struct flist_head *list)
+static void fio_server_check_fork_items(struct flist_head *list, bool stop)
 {
 	struct flist_head *entry, *tmp;
 	struct fio_fork_item *ffi;
@@ -551,18 +702,18 @@ static void fio_server_check_fork_items(struct flist_head *list)
 		fio_server_check_fork_item(ffi);
 
 		if (ffi->exited)
-			fio_server_fork_item_done(ffi);
+			fio_server_fork_item_done(ffi, stop);
 	}
 }
 
 static void fio_server_check_jobs(struct flist_head *job_list)
 {
-	fio_server_check_fork_items(job_list);
+	fio_server_check_fork_items(job_list, true);
 }
 
 static void fio_server_check_conns(struct flist_head *conn_list)
 {
-	fio_server_check_fork_items(conn_list);
+	fio_server_check_fork_items(conn_list, false);
 }
 
 static int handle_load_file_cmd(struct fio_net_cmd *cmd)
@@ -577,17 +728,18 @@ static int handle_load_file_cmd(struct fio_net_cmd *cmd)
 	pdu->client_type = le16_to_cpu(pdu->client_type);
 
 	if (parse_jobs_ini(file_name, 0, 0, pdu->client_type)) {
-		fio_net_send_quit(server_fd);
+		fio_net_queue_quit();
 		return -1;
 	}
 
 	spdu.jobs = cpu_to_le32(thread_number);
 	spdu.stat_outputs = cpu_to_le32(stat_number);
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, SK_F_COPY);
 	return 0;
 }
 
-static int handle_run_cmd(struct flist_head *job_list, struct fio_net_cmd *cmd)
+static int handle_run_cmd(struct sk_out *sk_out, struct flist_head *job_list,
+			  struct fio_net_cmd *cmd)
 {
 	pid_t pid;
 	int ret;
@@ -601,7 +753,7 @@ static int handle_run_cmd(struct flist_head *job_list, struct fio_net_cmd *cmd)
 		return 0;
 	}
 
-	ret = fio_backend(NULL);
+	ret = fio_backend(sk_out);
 	free_threads_shm();
 	_exit(ret);
 }
@@ -616,13 +768,14 @@ static int handle_job_cmd(struct fio_net_cmd *cmd)
 	pdu->client_type = le32_to_cpu(pdu->client_type);
 
 	if (parse_jobs_ini(buf, 1, 0, pdu->client_type)) {
-		fio_net_send_quit(server_fd);
+		fio_net_queue_quit();
 		return -1;
 	}
 
 	spdu.jobs = cpu_to_le32(thread_number);
 	spdu.stat_outputs = cpu_to_le32(stat_number);
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, NULL);
+
+	fio_net_queue_cmd(FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, SK_F_COPY);
 	return 0;
 }
 
@@ -653,7 +806,7 @@ static int handle_jobline_cmd(struct fio_net_cmd *cmd)
 	}
 
 	if (parse_cmd_line(clp->lines, argv, clp->client_type)) {
-		fio_net_send_quit(server_fd);
+		fio_net_queue_quit();
 		free(argv);
 		return -1;
 	}
@@ -662,7 +815,8 @@ static int handle_jobline_cmd(struct fio_net_cmd *cmd)
 
 	spdu.jobs = cpu_to_le32(thread_number);
 	spdu.stat_outputs = cpu_to_le32(stat_number);
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, NULL);
+
+	fio_net_queue_cmd(FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, SK_F_COPY);
 	return 0;
 }
 
@@ -699,7 +853,7 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 		use_zlib = 0;
 	}
 
-	return fio_net_send_cmd(server_fd, FIO_NET_CMD_PROBE, &probe, sizeof(probe), &tag, NULL);
+	return fio_net_queue_cmd(FIO_NET_CMD_PROBE, &probe, sizeof(probe), &tag, SK_F_COPY);
 }
 
 static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
@@ -742,18 +896,17 @@ static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
 		je->unit_base		= cpu_to_le32(je->unit_base);
 	}
 
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_ETA, je, size, &tag, NULL);
-	free(je);
+	fio_net_queue_cmd(FIO_NET_CMD_ETA, je, size, &tag, SK_F_FREE);
 	return 0;
 }
 
-static int send_update_job_reply(int fd, uint64_t __tag, int error)
+static int send_update_job_reply(uint64_t __tag, int error)
 {
 	uint64_t tag = __tag;
 	uint32_t pdu_error;
 
 	pdu_error = __cpu_to_le32(error);
-	return fio_net_send_cmd(fd, FIO_NET_CMD_UPDATE_JOB, &pdu_error, sizeof(pdu_error), &tag, NULL);
+	return fio_net_queue_cmd(FIO_NET_CMD_UPDATE_JOB, &pdu_error, sizeof(pdu_error), &tag, SK_F_COPY);
 }
 
 static int handle_update_job_cmd(struct fio_net_cmd *cmd)
@@ -767,13 +920,13 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 	dprint(FD_NET, "server: updating options for job %u\n", tnumber);
 
 	if (!tnumber || tnumber > thread_number) {
-		send_update_job_reply(server_fd, cmd->tag, ENODEV);
+		send_update_job_reply(cmd->tag, ENODEV);
 		return 0;
 	}
 
 	td = &threads[tnumber - 1];
 	convert_thread_options_to_cpu(&td->o, &pdu->top);
-	send_update_job_reply(server_fd, cmd->tag, 0);
+	send_update_job_reply(cmd->tag, 0);
 	return 0;
 }
 
@@ -792,17 +945,16 @@ static int handle_trigger_cmd(struct fio_net_cmd *cmd)
 		struct all_io_list state;
 
 		state.threads = cpu_to_le64((uint64_t) 0);
-		fio_net_send_cmd(server_fd, FIO_NET_CMD_VTRIGGER, &state, sizeof(state), NULL, NULL);
-	} else {
-		fio_net_send_cmd(server_fd, FIO_NET_CMD_VTRIGGER, rep, sz, NULL, NULL);
-		free(rep);
-	}
+		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, &state, sizeof(state), NULL, SK_F_COPY);
+	} else
+		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE);
 
 	exec_trigger(buf);
 	return 0;
 }
 
-static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
+static int handle_command(struct sk_out *sk_out, struct flist_head *job_list,
+			  struct fio_net_cmd *cmd)
 {
 	int ret;
 
@@ -813,7 +965,8 @@ static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 	switch (cmd->opcode) {
 	case FIO_NET_CMD_QUIT:
 		fio_terminate_threads(TERMINATE_ALL);
-		return -1;
+		ret = 0;
+		break;
 	case FIO_NET_CMD_EXIT:
 		exit_backend = 1;
 		return -1;
@@ -833,7 +986,7 @@ static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 		ret = handle_send_eta_cmd(cmd);
 		break;
 	case FIO_NET_CMD_RUN:
-		ret = handle_run_cmd(job_list, cmd);
+		ret = handle_run_cmd(sk_out, job_list, cmd);
 		break;
 	case FIO_NET_CMD_UPDATE_JOB:
 		ret = handle_update_job_cmd(cmd);
@@ -875,19 +1028,135 @@ static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 	return ret;
 }
 
-static int handle_connection(int sk)
+/*
+ * Send a command with a separate PDU, not inlined in the command
+ */
+static int fio_send_cmd_ext_pdu(int sk, uint16_t opcode, const void *buf,
+				off_t size, uint64_t tag, uint32_t flags)
+{
+	struct fio_net_cmd cmd;
+	struct iovec iov[2];
+
+	iov[0].iov_base = (void *) &cmd;
+	iov[0].iov_len = sizeof(cmd);
+	iov[1].iov_base = (void *) buf;
+	iov[1].iov_len = size;
+
+	__fio_init_net_cmd(&cmd, opcode, size, tag);
+	cmd.flags = __cpu_to_le32(flags);
+	fio_net_cmd_crc_pdu(&cmd, buf);
+
+	return fio_sendv_data(sk, iov, 2);
+}
+
+static void finish_entry(struct sk_entry *entry)
+{
+	if (entry->flags & SK_F_FREE)
+		free(entry->buf);
+	else if (entry->flags & SK_F_COPY)
+		sfree(entry->buf);
+
+	sfree(entry);
+}
+
+static void entry_set_flags_tag(struct sk_entry *entry, struct flist_head *list,
+				unsigned int *flags, uint64_t *tag)
+{
+	if (!flist_empty(list))
+		*flags = FIO_NET_CMD_F_MORE;
+	else
+		*flags = 0;
+
+	if (entry->tagptr)
+		*tag = *entry->tagptr;
+	else
+		*tag = 0;
+}
+
+static int send_vec_entry(struct sk_out *sk_out, struct sk_entry *first)
+{
+	unsigned int flags;
+	uint64_t tag;
+	int ret;
+
+	entry_set_flags_tag(first, &first->next, &flags, &tag);
+
+	ret = fio_send_cmd_ext_pdu(sk_out->sk, first->opcode, first->buf, first->size, tag, flags);
+
+	while (!flist_empty(&first->next)) {
+		struct sk_entry *next;
+
+		next = flist_first_entry(&first->next, struct sk_entry, list);
+		flist_del_init(&next->list);
+
+		entry_set_flags_tag(next, &first->next, &flags, &tag);
+
+		ret += fio_send_cmd_ext_pdu(sk_out->sk, next->opcode, next->buf, next->size, tag, flags);
+		finish_entry(next);
+	}
+
+	return ret;
+}
+
+static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry)
+{
+	int ret;
+
+	if (entry->flags & SK_F_VEC)
+		ret = send_vec_entry(sk_out, entry);
+	if (entry->flags & SK_F_SIMPLE) {
+		uint64_t tag = 0;
+
+		if (entry->tagptr)
+			tag = *entry->tagptr;
+
+		ret = fio_net_send_simple_cmd(sk_out->sk, entry->opcode, tag, NULL);
+	} else
+		ret = fio_net_send_cmd(sk_out->sk, entry->opcode, entry->buf, entry->size, entry->tagptr, NULL);
+
+	if (ret)
+		log_err("fio: failed handling cmd %s\n", fio_server_op(entry->opcode));
+
+	finish_entry(entry);
+	return ret;
+}
+
+static int handle_xmits(struct sk_out *sk_out)
+{
+	struct sk_entry *entry;
+	FLIST_HEAD(list);
+	int ret = 0;
+
+	sk_lock(sk_out);
+	if (flist_empty(&sk_out->list)) {
+		sk_unlock(sk_out);
+		return 0;
+	}
+
+	flist_splice_init(&sk_out->list, &list);
+	sk_unlock(sk_out);
+
+	while (!flist_empty(&list)) {
+		entry = flist_entry(list.next, struct sk_entry, list);
+		flist_del(&entry->list);
+		ret += handle_sk_entry(sk_out, entry);
+	}
+
+	return ret;
+}
+
+static int handle_connection(struct sk_out *sk_out)
 {
 	struct fio_net_cmd *cmd = NULL;
 	FLIST_HEAD(job_list);
 	int ret = 0;
 
 	reset_fio_state();
-	server_fd = sk;
 
 	/* read forever */
 	while (!exit_backend) {
 		struct pollfd pfd = {
-			.fd	= sk,
+			.fd	= sk_out->sk,
 			.events	= POLLIN,
 		};
 
@@ -898,7 +1167,9 @@ static int handle_connection(int sk)
 			if (!flist_empty(&job_list))
 				timeout = 100;
 
-			ret = poll(&pfd, 1, timeout);
+			handle_xmits(sk_out);
+
+			ret = poll(&pfd, 1, 0);
 			if (ret < 0) {
 				if (errno == EINTR)
 					break;
@@ -906,6 +1177,7 @@ static int handle_connection(int sk)
 				break;
 			} else if (!ret) {
 				fio_server_check_jobs(&job_list);
+				fio_mutex_down_timeout(sk_out->wait, timeout);
 				continue;
 			}
 
@@ -922,13 +1194,13 @@ static int handle_connection(int sk)
 		if (ret < 0)
 			break;
 
-		cmd = fio_net_recv_cmd(sk);
+		cmd = fio_net_recv_cmd(sk_out->sk);
 		if (!cmd) {
 			ret = -1;
 			break;
 		}
 
-		ret = handle_command(&job_list, cmd);
+		ret = handle_command(sk_out, &job_list, cmd);
 		if (ret)
 			break;
 
@@ -939,39 +1211,47 @@ static int handle_connection(int sk)
 	if (cmd)
 		free(cmd);
 
-	close(sk);
+	handle_xmits(sk_out);
+
+	close(sk_out->sk);
+	sk_out->sk = -1;
+	__sk_out_drop(sk_out);
 	_exit(ret);
 }
 
 /* get the address on this host bound by the input socket, 
  * whether it is ipv6 or ipv4 */
 
-int get_my_addr_str( int sk )
+static int get_my_addr_str(int sk)
 {
-	int ret; 
-	struct sockaddr * sockaddr_p;
-	struct sockaddr_in myaddr4 = {0};
-	struct sockaddr_in6 myaddr6 = {0};
-	char * net_addr;
-	socklen_t len = use_ipv6 ? sizeof(myaddr6) : sizeof(myaddr4);
+	struct sockaddr_in6 myaddr6 = { 0, };
+	struct sockaddr_in myaddr4 = { 0, };
+	struct sockaddr *sockaddr_p;
+	char *net_addr;
+	socklen_t len;
+	int ret;
 
-	if (use_ipv6)
+	if (use_ipv6) {
+		len = sizeof(myaddr6);
 		sockaddr_p = (struct sockaddr * )&myaddr6;
-	else
+		net_addr = (char * )&myaddr6.sin6_addr;
+	} else {
+		len = sizeof(myaddr4);
 		sockaddr_p = (struct sockaddr * )&myaddr4;
+		net_addr = (char * )&myaddr4.sin_addr;
+	}
+
 	ret = getsockname(sk, sockaddr_p, &len);
 	if (ret) {
 		log_err("fio: getsockaddr: %s\n", strerror(errno));
 		return -1;
 	}
-	if (use_ipv6)
-		net_addr = (char * )&myaddr6.sin6_addr;
-	else
-		net_addr = (char * )&myaddr4.sin_addr;
-	if (NULL == inet_ntop(use_ipv6?AF_INET6:AF_INET, net_addr, client_sockaddr_str, INET6_ADDRSTRLEN-1)) {
+
+	if (!inet_ntop(use_ipv6?AF_INET6:AF_INET, net_addr, client_sockaddr_str, INET6_ADDRSTRLEN - 1)) {
 		log_err("inet_ntop: failed to convert addr to string\n");
 		return -1;
 	}
+
 	dprint(FD_NET, "fio server bound to addr %s\n", client_sockaddr_str);
 	return 0;
 }
@@ -990,6 +1270,7 @@ static int accept_loop(int listen_sk)
 	fio_set_fd_nonblocking(listen_sk, "server");
 
 	while (!exit_backend) {
+		struct sk_out *sk_out;
 		const char *from;
 		char buf[64];
 		pid_t pid;
@@ -1039,6 +1320,12 @@ static int accept_loop(int listen_sk)
 
 		dprint(FD_NET, "server: connect from %s\n", from);
 
+		sk_out = smalloc(sizeof(*sk_out));
+		sk_out->sk = sk;
+		INIT_FLIST_HEAD(&sk_out->list);
+		sk_out->lock = fio_mutex_init(FIO_MUTEX_UNLOCKED);
+		sk_out->wait = fio_mutex_init(FIO_MUTEX_LOCKED);
+
 		pid = fork();
 		if (pid) {
 			close(sk);
@@ -1046,9 +1333,15 @@ static int accept_loop(int listen_sk)
 			continue;
 		}
 
-		/* exits */
-		get_my_addr_str(sk); /* if error, it's already logged, non-fatal */
-		handle_connection(sk);
+		/* if error, it's already logged, non-fatal */
+		get_my_addr_str(sk);
+
+		/*
+		 * Assign sk_out here, it'll be dropped in handle_connection()
+		 * since that function calls _exit() when done
+		 */
+		sk_out_assign(sk_out);
+		handle_connection(sk_out);
 	}
 
 	return exitval;
@@ -1056,11 +1349,12 @@ static int accept_loop(int listen_sk)
 
 int fio_server_text_output(int level, const char *buf, size_t len)
 {
+	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
 	struct cmd_text_pdu *pdu;
 	unsigned int tlen;
 	struct timeval tv;
 
-	if (server_fd == -1)
+	if (!sk_out || sk_out->sk == -1)
 		return -1;
 
 	tlen = sizeof(*pdu) + len;
@@ -1075,7 +1369,7 @@ int fio_server_text_output(int level, const char *buf, size_t len)
 
 	memcpy(pdu->buf, buf, len);
 
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_TEXT, pdu, tlen, NULL, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_TEXT, pdu, tlen, NULL, SK_F_COPY);
 	free(pdu);
 	return len;
 }
@@ -1205,7 +1499,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	convert_gs(&p.rs, rs);
 
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_TS, &p, sizeof(p), NULL, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
 }
 
 void fio_server_send_gs(struct group_run_stats *rs)
@@ -1215,7 +1509,48 @@ void fio_server_send_gs(struct group_run_stats *rs)
 	dprint(FD_NET, "server sending group run stats\n");
 
 	convert_gs(&gs, rs);
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_GS, &gs, sizeof(gs), NULL, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_GS, &gs, sizeof(gs), NULL, SK_F_COPY);
+}
+
+void fio_server_send_job_options(struct flist_head *opt_list,
+				 unsigned int groupid)
+{
+	struct cmd_job_option pdu;
+	struct flist_head *entry;
+
+	if (flist_empty(opt_list))
+		return;
+
+	flist_for_each(entry, opt_list) {
+		struct print_option *p;
+		size_t len;
+
+		p = flist_entry(entry, struct print_option, list);
+		memset(&pdu, 0, sizeof(pdu));
+
+		if (groupid == -1U) {
+			pdu.global = __cpu_to_le16(1);
+			pdu.groupid = 0;
+		} else {
+			pdu.global = 0;
+			pdu.groupid = cpu_to_le32(groupid);
+		}
+		len = strlen(p->name);
+		if (len >= sizeof(pdu.name)) {
+			len = sizeof(pdu.name) - 1;
+			pdu.truncated = __cpu_to_le16(1);
+		}
+		memcpy(pdu.name, p->name, len);
+		if (p->value) {
+			len = strlen(p->value);
+			if (len >= sizeof(pdu.value)) {
+				len = sizeof(pdu.value) - 1;
+				pdu.truncated = __cpu_to_le16(1);
+			}
+			memcpy(pdu.value, p->value, len);
+		}
+		fio_net_queue_cmd(FIO_NET_CMD_JOB_OPT, &pdu, sizeof(pdu), NULL, SK_F_COPY);
+	}
 }
 
 static void convert_agg(struct disk_util_agg *dst, struct disk_util_agg *src)
@@ -1270,35 +1605,15 @@ void fio_server_send_du(void)
 		convert_dus(&pdu.dus, &du->dus);
 		convert_agg(&pdu.agg, &du->agg);
 
-		fio_net_send_cmd(server_fd, FIO_NET_CMD_DU, &pdu, sizeof(pdu), NULL, NULL);
+		fio_net_queue_cmd(FIO_NET_CMD_DU, &pdu, sizeof(pdu), NULL, SK_F_COPY);
 	}
 }
 
-/*
- * Send a command with a separate PDU, not inlined in the command
- */
-static int fio_send_cmd_ext_pdu(int sk, uint16_t opcode, const void *buf,
-				off_t size, uint64_t tag, uint32_t flags)
-{
-	struct fio_net_cmd cmd;
-	struct iovec iov[2];
-
-	iov[0].iov_base = (void *) &cmd;
-	iov[0].iov_len = sizeof(cmd);
-	iov[1].iov_base = (void *) buf;
-	iov[1].iov_len = size;
-
-	__fio_init_net_cmd(&cmd, opcode, size, tag);
-	cmd.flags = __cpu_to_le32(flags);
-	fio_net_cmd_crc_pdu(&cmd, buf);
-
-	return fio_sendv_data(sk, iov, 2);
-}
-
-static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
+static int fio_send_iolog_gz(struct sk_entry *first, struct io_log *log)
 {
 	int ret = 0;
 #ifdef CONFIG_ZLIB
+	struct sk_entry *entry;
 	z_stream stream;
 	void *out_pdu;
 
@@ -1322,7 +1637,7 @@ static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
 	stream.avail_in = log->nr_samples * log_entry_sz(log);
 
 	do {
-		unsigned int this_len, flags = 0;
+		unsigned int this_len;
 
 		stream.avail_out = FIO_SERVER_MAX_FRAGMENT_PDU;
 		stream.next_out = out_pdu;
@@ -1333,13 +1648,9 @@ static int fio_send_iolog_gz(struct cmd_iolog_pdu *pdu, struct io_log *log)
 
 		this_len = FIO_SERVER_MAX_FRAGMENT_PDU - stream.avail_out;
 
-		if (stream.avail_in)
-			flags = FIO_NET_CMD_F_MORE;
-
-		ret = fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG,
-					   out_pdu, this_len, 0, flags);
-		if (ret)
-			goto err_zlib;
+		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, out_pdu, this_len,
+						NULL, SK_F_FREE | SK_F_VEC);
+		flist_add_tail(&entry->list, &first->next);
 	} while (stream.avail_in);
 
 err_zlib:
@@ -1353,6 +1664,7 @@ err:
 int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 {
 	struct cmd_iolog_pdu pdu;
+	struct sk_entry *first;
 	int i, ret = 0;
 
 	pdu.nr_samples = cpu_to_le64(log->nr_samples);
@@ -1379,21 +1691,26 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 	}
 
 	/*
-	 * Send header first, it's not compressed.
+	 * Assemble header entry first
 	 */
-	ret = fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, &pdu,
-					sizeof(pdu), 0, FIO_NET_CMD_F_MORE);
-	if (ret)
-		return ret;
+	first = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, &pdu, sizeof(pdu), NULL, SK_F_COPY | SK_F_VEC);
 
 	/*
-	 * Now send actual log, compress if we can, otherwise just plain
+	 * Now append actual log entries. Compress if we can, otherwise just
+	 * plain text output.
 	 */
 	if (use_zlib)
-		return fio_send_iolog_gz(&pdu, log);
+		ret = fio_send_iolog_gz(first, log);
+	else {
+		struct sk_entry *entry;
 
-	return fio_send_cmd_ext_pdu(server_fd, FIO_NET_CMD_IOLOG, log->log,
-			log->nr_samples * log_entry_sz(log), 0, 0);
+		entry = fio_net_prep_cmd(FIO_NET_CMD_IOLOG, log->log,
+					log->nr_samples * log_entry_sz(log),
+					NULL, SK_F_FREE | SK_F_VEC);
+		flist_add_tail(&entry->list, &first->next);
+	}
+
+	return ret;
 }
 
 void fio_server_send_add_job(struct thread_data *td)
@@ -1405,14 +1722,16 @@ void fio_server_send_add_job(struct thread_data *td)
 	pdu.groupid = cpu_to_le32(td->groupid);
 	convert_thread_options_to_net(&pdu.top, &td->o);
 
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_ADD_JOB, &pdu, sizeof(pdu), NULL, SK_F_COPY);
 }
 
 void fio_server_send_start(struct thread_data *td)
 {
-	assert(server_fd != -1);
+	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
+
+	assert(sk_out->sk != -1);
 
-	fio_net_send_simple_cmd(server_fd, FIO_NET_CMD_SERVER_START, 0, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_SERVER_START, NULL, 0, 0, SK_F_SIMPLE);
 }
 
 int fio_server_get_verify_state(const char *name, int threadnumber,
@@ -1439,8 +1758,7 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	verify_state_gen_name((char *) out.path, sizeof(out.path), name, me,
 				threadnumber);
 	tag = (uint64_t) (uintptr_t) rep;
-	fio_net_send_cmd(server_fd, FIO_NET_CMD_SENDFILE, &out, sizeof(out),
-				&tag, NULL);
+	fio_net_queue_cmd(FIO_NET_CMD_SENDFILE, &out, sizeof(out), &tag, SK_F_COPY);
 
 	/*
 	 * Wait for the backend to receive the reply
@@ -1455,7 +1773,7 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 fail:
 		*datap = NULL;
 		sfree(rep);
-		fio_net_send_quit(server_fd);
+		fio_net_queue_quit();
 		return 1;
 	}
 
@@ -1612,7 +1930,7 @@ static int fio_init_server_connection(void)
 
 	log_info("fio: server listening on %s\n", bind_str);
 
-	if (listen(sk, 0) < 0) {
+	if (listen(sk, 4) < 0) {
 		log_err("fio: listen: %s\n", strerror(errno));
 		close(sk);
 		return -1;
@@ -1807,6 +2125,13 @@ static int fio_server(void)
 {
 	int sk, ret;
 
+	if (pthread_key_create(&sk_out_key, NULL)) {
+		log_err("fio: can't create sk_out backend key\n");
+		return -1;
+	}
+
+	pthread_setspecific(sk_out_key, NULL);
+
 	dprint(FD_NET, "starting server\n");
 
 	if (fio_handle_server_arg())
@@ -1834,8 +2159,12 @@ static int fio_server(void)
 
 void fio_server_got_signal(int signal)
 {
+	struct sk_out *sk_out = pthread_getspecific(sk_out_key);
+
+	assert(sk_out);
+
 	if (signal == SIGPIPE)
-		server_fd = -1;
+		sk_out->sk = -1;
 	else {
 		log_info("\nfio: terminating on signal %d\n", signal);
 		exit_backend = 1;
diff --git a/server.h b/server.h
index 6370c50..dc4a419 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 49,
+	FIO_SERVER_VER			= 50,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -64,7 +64,8 @@ enum {
 	FIO_NET_CMD_LOAD_FILE		= 19,
 	FIO_NET_CMD_VTRIGGER		= 20,
 	FIO_NET_CMD_SENDFILE		= 21,
-	FIO_NET_CMD_NR			= 22,
+	FIO_NET_CMD_JOB_OPT		= 22,
+	FIO_NET_CMD_NR			= 23,
 
 	FIO_NET_CMD_F_MORE		= 1UL << 0,
 
@@ -74,7 +75,7 @@ enum {
 
 	FIO_NET_NAME_MAX		= 256,
 
-	FIO_NET_CLIENT_TIMEOUT		= 30000,
+	FIO_NET_CLIENT_TIMEOUT		= 5000,
 
 	FIO_PROBE_FLAG_ZLIB		= 1UL << 0,
 };
@@ -181,6 +182,14 @@ struct cmd_iolog_pdu {
 	struct io_sample samples[0];
 };
 
+struct cmd_job_option {
+	uint16_t global;
+	uint16_t truncated;
+	uint32_t groupid;
+	uint8_t name[64];
+	uint8_t value[128];
+};
+
 extern int fio_start_server(char *);
 extern int fio_server_text_output(int, const char *, size_t);
 extern int fio_net_send_cmd(int, uint16_t, const void *, off_t, uint64_t *, struct flist_head *);
@@ -196,44 +205,17 @@ struct group_run_stats;
 extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
 extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
-extern void fio_server_idle_loop(void);
+extern void fio_server_send_job_options(struct flist_head *, unsigned int);
 extern int fio_server_get_verify_state(const char *, int, void **, int *);
 
-extern int fio_recv_data(int sk, void *p, unsigned int len);
-extern int fio_send_data(int sk, const void *p, unsigned int len);
-extern void fio_net_cmd_crc(struct fio_net_cmd *);
-extern void fio_net_cmd_crc_pdu(struct fio_net_cmd *, const void *);
 extern struct fio_net_cmd *fio_net_recv_cmd(int sk);
 
 extern int fio_send_iolog(struct thread_data *, struct io_log *, const char *);
 extern void fio_server_send_add_job(struct thread_data *);
 extern void fio_server_send_start(struct thread_data *);
-extern int fio_net_send_stop(int sk, int error, int signal);
 extern int fio_net_send_quit(int sk);
 
 extern int exit_backend;
 extern int fio_net_port;
 
-static inline void __fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
-				      uint32_t pdu_len, uint64_t tag)
-{
-	memset(cmd, 0, sizeof(*cmd));
-
-	cmd->version	= __cpu_to_le16(FIO_SERVER_VER);
-	cmd->opcode	= cpu_to_le16(opcode);
-	cmd->tag	= cpu_to_le64(tag);
-	cmd->pdu_len	= cpu_to_le32(pdu_len);
-}
-
-
-static inline void fio_init_net_cmd(struct fio_net_cmd *cmd, uint16_t opcode,
-				    const void *pdu, uint32_t pdu_len,
-				    uint64_t tag)
-{
-	__fio_init_net_cmd(cmd, opcode, pdu_len, tag);
-
-	if (pdu)
-		memcpy(&cmd->payload, pdu, pdu_len);
-}
-
 #endif
diff --git a/stat.c b/stat.c
index ca06617..a3bfe63 100644
--- a/stat.c
+++ b/stat.c
@@ -1086,8 +1086,34 @@ static void show_thread_status_terse_v3_v4(struct thread_stat *ts,
 	log_buf(out, "\n");
 }
 
+void json_add_job_opts(struct json_object *root, const char *name,
+		       struct flist_head *opt_list, bool num_jobs)
+{
+	struct json_object *dir_object;
+	struct flist_head *entry;
+	struct print_option *p;
+
+	if (flist_empty(opt_list))
+		return;
+
+	dir_object = json_create_object();
+	json_object_add_value_object(root, name, dir_object);
+
+	flist_for_each(entry, opt_list) {
+		const char *pos = "";
+
+		p = flist_entry(entry, struct print_option, list);
+		if (!num_jobs && !strcmp(p->name, "numjobs"))
+			continue;
+		if (p->value)
+			pos = p->value;
+		json_object_add_value_string(dir_object, p->name, pos);
+	}
+}
+
 static struct json_object *show_thread_status_json(struct thread_stat *ts,
-				    struct group_run_stats *rs)
+						   struct group_run_stats *rs,
+						   struct flist_head *opt_list)
 {
 	struct json_object *root, *tmp;
 	struct jobs_eta *je;
@@ -1110,6 +1136,9 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		json_object_add_value_int(root, "elapsed", je->elapsed_sec);
 	}
 
+	if (opt_list)
+		json_add_job_opts(root, "job options", opt_list, true);
+
 	add_ddir_status_json(ts, rs, DDIR_READ, root);
 	add_ddir_status_json(ts, rs, DDIR_WRITE, root);
 	add_ddir_status_json(ts, rs, DDIR_TRIM, root);
@@ -1239,6 +1268,7 @@ static void show_thread_status_terse(struct thread_stat *ts,
 
 struct json_object *show_thread_status(struct thread_stat *ts,
 				       struct group_run_stats *rs,
+				       struct flist_head *opt_list,
 				       struct buf_output *out)
 {
 	struct json_object *ret = NULL;
@@ -1246,7 +1276,7 @@ struct json_object *show_thread_status(struct thread_stat *ts,
 	if (output_format & FIO_OUTPUT_TERSE)
 		show_thread_status_terse(ts, rs,  out);
 	if (output_format & FIO_OUTPUT_JSON)
-		ret = show_thread_status_json(ts, rs);
+		ret = show_thread_status_json(ts, rs, opt_list);
 	if (output_format & FIO_OUTPUT_NORMAL)
 		show_thread_status_normal(ts, rs,  out);
 
@@ -1427,6 +1457,7 @@ void __show_run_stats(void)
 	struct json_object *root = NULL;
 	struct json_array *array = NULL;
 	struct buf_output output[FIO_OUTPUT_NR];
+	struct flist_head **opt_lists;
 
 	runstats = malloc(sizeof(struct group_run_stats) * (groupid + 1));
 
@@ -1452,9 +1483,12 @@ void __show_run_stats(void)
 	}
 
 	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
+	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
 
-	for (i = 0; i < nr_ts; i++)
+	for (i = 0; i < nr_ts; i++) {
 		init_thread_stat(&threadstats[i]);
+		opt_lists[i] = NULL;
+	}
 
 	j = 0;
 	last_ts = -1;
@@ -1473,6 +1507,7 @@ void __show_run_stats(void)
 		ts->clat_percentiles = td->o.clat_percentiles;
 		ts->percentile_precision = td->o.percentile_precision;
 		memcpy(ts->percentile_list, td->o.percentile_list, sizeof(td->o.percentile_list));
+		opt_lists[j] = &td->opt_list;
 
 		idx++;
 		ts->members++;
@@ -1596,6 +1631,7 @@ void __show_run_stats(void)
 	if (output_format & FIO_OUTPUT_NORMAL)
 		log_buf(&output[__FIO_OUTPUT_NORMAL], "\n");
 	if (output_format & FIO_OUTPUT_JSON) {
+		struct thread_data *global;
 		char time_buf[32];
 		time_t time_p;
 
@@ -1608,21 +1644,27 @@ void __show_run_stats(void)
 		json_object_add_value_string(root, "fio version", fio_version_string);
 		json_object_add_value_int(root, "timestamp", time_p);
 		json_object_add_value_string(root, "time", time_buf);
+		global = get_global_options();
+		json_add_job_opts(root, "global options", &global->opt_list, false);
 		array = json_create_array();
 		json_object_add_value_array(root, "jobs", array);
 	}
 
+	if (is_backend)
+		fio_server_send_job_options(&get_global_options()->opt_list, -1U);
+
 	for (i = 0; i < nr_ts; i++) {
 		ts = &threadstats[i];
 		rs = &runstats[ts->groupid];
 
-		if (is_backend)
+		if (is_backend) {
+			fio_server_send_job_options(opt_lists[i], i);
 			fio_server_send_ts(ts, rs);
-		else {
+		} else {
 			if (output_format & FIO_OUTPUT_TERSE)
 				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
 			if (output_format & FIO_OUTPUT_JSON) {
-				struct json_object *tmp = show_thread_status_json(ts, rs);
+				struct json_object *tmp = show_thread_status_json(ts, rs, opt_lists[i]);
 				json_array_add_value_object(array, tmp);
 			}
 			if (output_format & FIO_OUTPUT_NORMAL)
@@ -1665,6 +1707,7 @@ void __show_run_stats(void)
 	log_info_flush();
 	free(runstats);
 	free(threadstats);
+	free(opt_lists);
 }
 
 void show_run_stats(void)
diff --git a/stat.h b/stat.h
index dda88fc..9c3f192 100644
--- a/stat.h
+++ b/stat.h
@@ -247,7 +247,7 @@ extern struct jobs_eta *get_jobs_eta(bool force, size_t *size);
 extern void stat_init(void);
 extern void stat_exit(void);
 
-extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct buf_output *);
+extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct flist_head *, struct buf_output *);
 extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
 extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
diff --git a/workqueue.c b/workqueue.c
index 5fd95b9..6e67f3e 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -133,6 +133,8 @@ static void *worker_thread(void *data)
 	unsigned int eflags = 0, ret = 0;
 	FLIST_HEAD(local_list);
 
+	sk_out_assign(sw->sk_out);
+
 	if (wq->ops.nice) {
 		if (nice(wq->ops.nice) < 0) {
 			log_err("workqueue: nice %s\n", strerror(errno));
@@ -206,6 +208,7 @@ done:
 	pthread_mutex_lock(&sw->lock);
 	sw->flags |= (SW_F_EXITED | eflags);
 	pthread_mutex_unlock(&sw->lock);
+	sk_out_drop();
 	return NULL;
 }
 
@@ -267,7 +270,8 @@ void workqueue_exit(struct workqueue *wq)
 	pthread_mutex_destroy(&wq->stat_lock);
 }
 
-static int start_worker(struct workqueue *wq, unsigned int index)
+static int start_worker(struct workqueue *wq, unsigned int index,
+			struct sk_out *sk_out)
 {
 	struct submit_worker *sw = &wq->workers[index];
 	int ret;
@@ -277,6 +281,7 @@ static int start_worker(struct workqueue *wq, unsigned int index)
 	pthread_mutex_init(&sw->lock, NULL);
 	sw->wq = wq;
 	sw->index = index;
+	sw->sk_out = sk_out;
 
 	if (wq->ops.alloc_worker_fn) {
 		ret = wq->ops.alloc_worker_fn(sw);
@@ -297,12 +302,13 @@ static int start_worker(struct workqueue *wq, unsigned int index)
 }
 
 int workqueue_init(struct thread_data *td, struct workqueue *wq,
-		   struct workqueue_ops *ops, unsigned max_pending)
+		   struct workqueue_ops *ops, unsigned int max_workers,
+		   struct sk_out *sk_out)
 {
 	unsigned int running;
 	int i, error;
 
-	wq->max_workers = max_pending;
+	wq->max_workers = max_workers;
 	wq->td = td;
 	wq->ops = *ops;
 	wq->work_seq = 0;
@@ -314,7 +320,7 @@ int workqueue_init(struct thread_data *td, struct workqueue *wq,
 	wq->workers = calloc(wq->max_workers, sizeof(struct submit_worker));
 
 	for (i = 0; i < wq->max_workers; i++)
-		if (start_worker(wq, i))
+		if (start_worker(wq, i, sk_out))
 			break;
 
 	wq->max_workers = i;
diff --git a/workqueue.h b/workqueue.h
index 46a3979..1961b2a 100644
--- a/workqueue.h
+++ b/workqueue.h
@@ -17,6 +17,7 @@ struct submit_worker {
 	uint64_t seq;
 	struct workqueue *wq;
 	void *private;
+	struct sk_out *sk_out;
 };
 
 typedef int (workqueue_work_fn)(struct submit_worker *, struct workqueue_work *);
@@ -60,7 +61,7 @@ struct workqueue {
 	volatile int wake_idle;
 };
 
-int workqueue_init(struct thread_data *td, struct workqueue *wq, struct workqueue_ops *ops, unsigned int max_workers);
+int workqueue_init(struct thread_data *td, struct workqueue *wq, struct workqueue_ops *ops, unsigned int max_workers, struct sk_out *sk_out);
 void workqueue_exit(struct workqueue *wq);
 
 void workqueue_enqueue(struct workqueue *wq, struct workqueue_work *work);
