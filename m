Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53970 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbeIHQpu (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 8 Sep 2018 12:45:50 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fybuT-0000b1-TB
        for fio@vger.kernel.org; Sat, 08 Sep 2018 12:00:17 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180908120001.E229F2C00A8@kernel.dk>
Date: Sat,  8 Sep 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bb661c4027e5a0482b9fcc1c1b4e7e918650ee72:

  Fio 3.9 (2018-09-06 09:07:55 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2eca48926723d3ebe8f43d4999302fb826f4a250:

  client: cleanup output types (2018-09-07 15:59:51 -0600)

----------------------------------------------------------------
Jens Axboe (9):
      Collect startup output before logging it
      client: use temp buffer for client text output
      log: use __log_buf() if we know buf != NULL
      init: use __log_buf() if we know buf != NULL
      log: remember to free output buffer when done
      Revert "client: respect terse output on client <--> backend relationship"
      client: use temp buffer for single output flush for json/disk util
      client: switch to per-client buffer
      client: cleanup output types

 backend.c | 16 +++++++-----
 client.c  | 90 +++++++++++++++++++++++++++++++++++----------------------------
 client.h  |  2 ++
 init.c    | 12 ++++++---
 stat.c    |  2 --
 5 files changed, 70 insertions(+), 52 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 8fec1ce..bb8bd13 100644
--- a/backend.c
+++ b/backend.c
@@ -2213,18 +2213,22 @@ static void run_threads(struct sk_out *sk_out)
 	}
 
 	if (output_format & FIO_OUTPUT_NORMAL) {
-		log_info("Starting ");
+		struct buf_output out;
+
+		buf_output_init(&out);
+		__log_buf(&out, "Starting ");
 		if (nr_thread)
-			log_info("%d thread%s", nr_thread,
+			__log_buf(&out, "%d thread%s", nr_thread,
 						nr_thread > 1 ? "s" : "");
 		if (nr_process) {
 			if (nr_thread)
-				log_info(" and ");
-			log_info("%d process%s", nr_process,
+				__log_buf(&out, " and ");
+			__log_buf(&out, "%d process%s", nr_process,
 						nr_process > 1 ? "es" : "");
 		}
-		log_info("\n");
-		log_info_flush();
+		__log_buf(&out, "\n");
+		log_info_buf(out.buf, out.buflen);
+		buf_output_free(&out);
 	}
 
 	todo = thread_number;
diff --git a/client.c b/client.c
index 31c7c64..3248906 100644
--- a/client.c
+++ b/client.c
@@ -198,14 +198,23 @@ static void fio_client_json_init(void)
 
 static void fio_client_json_fini(void)
 {
-	if (!(output_format & FIO_OUTPUT_JSON))
+	struct buf_output out;
+
+	if (!root)
 		return;
 
-	log_info("\n");
-	json_print_object(root, NULL);
-	log_info("\n");
+	buf_output_init(&out);
+
+	__log_buf(&out, "\n");
+	json_print_object(root, &out);
+	__log_buf(&out, "\n");
+	log_info_buf(out.buf, out.buflen);
+
+	buf_output_free(&out);
+
 	json_free_object(root);
 	root = NULL;
+	job_opt_object = NULL;
 	clients_array = NULL;
 	du_array = NULL;
 }
@@ -233,6 +242,9 @@ void fio_put_client(struct fio_client *client)
 	if (--client->refs)
 		return;
 
+	log_info_buf(client->buf.buf, client->buf.buflen);
+	buf_output_free(&client->buf);
+
 	free(client->hostname);
 	if (client->argv)
 		free(client->argv);
@@ -351,9 +363,7 @@ void fio_client_add_cmd_option(void *cookie, const char *opt)
 	}
 }
 
-struct fio_client *fio_client_add_explicit(struct client_ops *ops,
-					   const char *hostname, int type,
-					   int port)
+static struct fio_client *get_new_client(void)
 {
 	struct fio_client *client;
 
@@ -366,6 +376,19 @@ struct fio_client *fio_client_add_explicit(struct client_ops *ops,
 	INIT_FLIST_HEAD(&client->eta_list);
 	INIT_FLIST_HEAD(&client->cmd_list);
 
+	buf_output_init(&client->buf);
+
+	return client;
+}
+
+struct fio_client *fio_client_add_explicit(struct client_ops *ops,
+					   const char *hostname, int type,
+					   int port)
+{
+	struct fio_client *client;
+
+	client = get_new_client();
+
 	client->hostname = strdup(hostname);
 
 	if (type == Fio_client_socket)
@@ -441,14 +464,7 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
 		}
 	}
 
-	client = malloc(sizeof(*client));
-	memset(client, 0, sizeof(*client));
-
-	INIT_FLIST_HEAD(&client->list);
-	INIT_FLIST_HEAD(&client->hash_list);
-	INIT_FLIST_HEAD(&client->arg_list);
-	INIT_FLIST_HEAD(&client->eta_list);
-	INIT_FLIST_HEAD(&client->cmd_list);
+	client = get_new_client();
 
 	if (fio_server_parse_string(hostname, &client->hostname,
 					&client->is_sock, &client->port,
@@ -1059,13 +1075,10 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct flist_head *opt_list = NULL;
 	struct json_object *tsobj;
 
-	if (output_format & FIO_OUTPUT_TERSE)
-		return;
-
 	if (client->opt_lists && p->ts.thread_number <= client->jobs)
 		opt_list = &client->opt_lists[p->ts.thread_number - 1];
 
-	tsobj = show_thread_status(&p->ts, &p->rs, opt_list, NULL);
+	tsobj = show_thread_status(&p->ts, &p->rs, opt_list, &client->buf);
 	client->did_stat = true;
 	if (tsobj) {
 		json_object_add_client_info(tsobj, client);
@@ -1086,7 +1099,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		tsobj = show_thread_status(&client_ts, &client_gs, NULL, NULL);
+		tsobj = show_thread_status(&client_ts, &client_gs, NULL, &client->buf);
 		if (tsobj) {
 			json_object_add_client_info(tsobj, client);
 			json_array_add_value_object(clients_array, tsobj);
@@ -1098,11 +1111,8 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
 
-	if (output_format & FIO_OUTPUT_TERSE)
-		return;
-
 	if (output_format & FIO_OUTPUT_NORMAL)
-		show_group_stats(gs, NULL);
+		show_group_stats(gs, &client->buf);
 }
 
 static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
@@ -1144,13 +1154,17 @@ static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd)
 	const char *buf = (const char *) pdu->buf;
 	const char *name;
 	int fio_unused ret;
+	struct buf_output out;
+
+	buf_output_init(&out);
 
 	name = client->name ? client->name : client->hostname;
 
 	if (!client->skip_newline && !(output_format & FIO_OUTPUT_TERSE))
-		fprintf(f_out, "<%s> ", name);
-	ret = fwrite(buf, pdu->buf_len, 1, f_out);
-	fflush(f_out);
+		__log_buf(&out, "<%s> ", name);
+	__log_buf(&out, "%s", buf);
+	log_info_buf(out.buf, out.buflen);
+	buf_output_free(&out);
 	client->skip_newline = strchr(buf, '\n') == NULL;
 }
 
@@ -1191,23 +1205,21 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
 
-	if (output_format & FIO_OUTPUT_TERSE)
-		return;
-
-	if (!client->disk_stats_shown) {
+	if (!client->disk_stats_shown)
 		client->disk_stats_shown = true;
-		if (!(output_format & FIO_OUTPUT_JSON))
-			log_info("\nDisk stats (read/write):\n");
-	}
 
 	if (output_format & FIO_OUTPUT_JSON) {
 		struct json_object *duobj;
+
 		json_array_add_disk_util(&du->dus, &du->agg, du_array);
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
+	} else if (output_format & FIO_OUTPUT_TERSE)
+		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
+	else if (output_format & FIO_OUTPUT_NORMAL) {
+		__log_buf(&client->buf, "\nDisk stats (read/write):\n");
+		print_disk_util(&du->dus, &du->agg, 0, &client->buf);
 	}
-	if (output_format & FIO_OUTPUT_NORMAL)
-		print_disk_util(&du->dus, &du->agg, 0, NULL);
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
@@ -1465,9 +1477,6 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	const char *os, *arch;
 	char bit[16];
 
-	if (output_format & FIO_OUTPUT_TERSE)
-		return;
-
 	os = fio_get_os_string(probe->os);
 	if (!os)
 		os = "unknown";
@@ -1479,10 +1488,11 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	sprintf(bit, "%d-bit", probe->bpp * 8);
 	probe->flags = le64_to_cpu(probe->flags);
 
-	if (!(output_format & FIO_OUTPUT_JSON))
+	if (output_format & FIO_OUTPUT_NORMAL) {
 		log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
 			probe->hostname, probe->bigendian, bit, os, arch,
 			probe->fio_version, (unsigned long) probe->flags);
+	}
 
 	if (!client->name)
 		client->name = strdup((char *) probe->hostname);
diff --git a/client.h b/client.h
index a597449..8033325 100644
--- a/client.h
+++ b/client.h
@@ -74,6 +74,8 @@ struct fio_client {
 
 	struct client_file *files;
 	unsigned int nr_files;
+
+	struct buf_output buf;
 };
 
 typedef void (client_cmd_op)(struct fio_client *, struct fio_net_cmd *);
diff --git a/init.c b/init.c
index 09f58a3..c235b05 100644
--- a/init.c
+++ b/init.c
@@ -1681,6 +1681,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 				char *c1, *c2, *c3, *c4;
 				char *c5 = NULL, *c6 = NULL;
 				int i2p = is_power_of_2(o->kb_base);
+				struct buf_output out;
 
 				c1 = num2str(o->min_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
 				c2 = num2str(o->max_bs[DDIR_READ], o->sig_figs, 1, i2p, N2S_BYTE);
@@ -1692,19 +1693,22 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 					c6 = num2str(o->max_bs[DDIR_TRIM], o->sig_figs, 1, i2p, N2S_BYTE);
 				}
 
-				log_info("%s: (g=%d): rw=%s, ", td->o.name,
+				buf_output_init(&out);
+				__log_buf(&out, "%s: (g=%d): rw=%s, ", td->o.name,
 							td->groupid,
 							ddir_str(o->td_ddir));
 
 				if (o->bs_is_seq_rand)
-					log_info("bs=(R) %s-%s, (W) %s-%s, bs_is_seq_rand, ",
+					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, bs_is_seq_rand, ",
 							c1, c2, c3, c4);
 				else
-					log_info("bs=(R) %s-%s, (W) %s-%s, (T) %s-%s, ",
+					__log_buf(&out, "bs=(R) %s-%s, (W) %s-%s, (T) %s-%s, ",
 							c1, c2, c3, c4, c5, c6);
 
-				log_info("ioengine=%s, iodepth=%u\n",
+				__log_buf(&out, "ioengine=%s, iodepth=%u\n",
 						td->io_ops->name, o->iodepth);
+				log_info_buf(out.buf, out.buflen);
+				buf_output_free(&out);
 
 				free(c1);
 				free(c2);
diff --git a/stat.c b/stat.c
index 1a9c553..5fca998 100644
--- a/stat.c
+++ b/stat.c
@@ -1928,8 +1928,6 @@ void __show_run_stats(void)
 		if (is_backend) {
 			fio_server_send_job_options(opt_lists[i], i);
 			fio_server_send_ts(ts, rs);
-			if (output_format & FIO_OUTPUT_TERSE)
-				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
 		} else {
 			if (output_format & FIO_OUTPUT_TERSE)
 				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);

