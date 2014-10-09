Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaJIMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 9 Oct 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XcCO5-0000pU-7O
	for fio@vger.kernel.org; Thu, 09 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141009120003.293FE401E8@lyth.info>
Date: Thu,  9 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c05da82c1a427ce535af0c1b3e7a795330cf5061:

  gfio: remove warning on g_type_init() being deprecated (2014-10-07 20:46:26 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c5dd6d8975fc36da778d08c21d3e051add6d3030:

  net: use SIGTERM for terminate (2014-10-08 14:14:05 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Add support for --remote-config
      client: remember to zero pad filename
      Fix potential segfault on ENOENT on job file
      net: use SIGTERM for terminate

 README        |    9 ++++++
 client.c      |   85 +++++++++++++++++++++++++++++++++++++++++++++------------
 client.h      |   13 ++++++---
 engines/net.c |    2 +-
 fio.1         |    8 ++++++
 gfio.c        |    2 +-
 init.c        |   22 +++++++++++++--
 server.c      |   27 ++++++++++++++++++
 server.h      |   16 ++++++-----
 9 files changed, 152 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index e378d3b..0917544 100644
--- a/README
+++ b/README
@@ -173,6 +173,7 @@ $ fio
 	--max-jobs		Maximum number of threads/processes to support
 	--server=args		Start backend server. See Client/Server section.
 	--client=host		Connect to specified backend.
+	--remote-config=file	Tell fio server to load this local file
 	--idle-prof=option	Report cpu idleness on a system or percpu basis
 				(option=system,percpu) or run unit work
 				calibration only (option=calibrate).
@@ -305,6 +306,14 @@ Fio can connect to multiple servers this way:
 
 fio --client=<server1> <job file(s)> --client=<server2> <job file(s)>
 
+If the job file is located on the fio server, then you can tell the server
+to load a local file as well. This is done by using --remote-config:
+
+fio --client=server --remote-config /path/to/file.fio
+
+Then the fio serer will open this local (to the server) job file instead
+of being passed one from the client.
+
 
 Platforms
 ---------
diff --git a/client.c b/client.c
index 1dded09..66f982c 100644
--- a/client.c
+++ b/client.c
@@ -141,10 +141,13 @@ void fio_put_client(struct fio_client *client)
 		free(client->argv);
 	if (client->name)
 		free(client->name);
-	while (client->nr_ini_file)
-		free(client->ini_file[--client->nr_ini_file]);
-	if (client->ini_file)
-		free(client->ini_file);
+	while (client->nr_files) {
+		struct client_file *cf = &client->files[--client->nr_files];
+
+		free(cf->file);
+	}
+	if (client->files)
+		free(client->files);
 
 	if (!client->did_stat)
 		sum_stat_clients -= client->nr_stat;
@@ -262,17 +265,26 @@ err:
 	return NULL;
 }
 
-void fio_client_add_ini_file(void *cookie, const char *ini_file)
+int fio_client_add_ini_file(void *cookie, const char *ini_file, int remote)
 {
 	struct fio_client *client = cookie;
+	struct client_file *cf;
 	size_t new_size;
+	void *new_files;
 
 	dprint(FD_NET, "client <%s>: add ini %s\n", client->hostname, ini_file);
 
-	new_size = (client->nr_ini_file + 1) * sizeof(char *);
-	client->ini_file = realloc(client->ini_file, new_size);
-	client->ini_file[client->nr_ini_file] = strdup(ini_file);
-	client->nr_ini_file++;
+	new_size = (client->nr_files + 1) * sizeof(struct client_file);
+	new_files = realloc(client->files, new_size);
+	if (!new_files)
+		return 1;
+
+	client->files = new_files;
+	cf = &client->files[client->nr_files];
+	cf->file = strdup(ini_file);
+	cf->remote = remote;
+	client->nr_files++;
+	return 0;
 }
 
 int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
@@ -599,11 +611,34 @@ int fio_start_all_clients(void)
 	return flist_empty(&client_list);
 }
 
+static int __fio_client_send_remote_ini(struct fio_client *client,
+					const char *filename)
+{
+	struct cmd_load_file_pdu *pdu;
+	size_t p_size;
+	int ret;
+
+	dprint(FD_NET, "send remote ini %s to %s\n", filename, client->hostname);
+
+	p_size = sizeof(*pdu) + strlen(filename) + 1;
+	pdu = malloc(p_size);
+	memset(pdu, 0, p_size);
+	pdu->name_len = strlen(filename);
+	strcpy((char *) pdu->file, filename);
+	pdu->client_type = cpu_to_le16((uint16_t) client->type);
+
+	client->sent_job = 1;
+	ret = fio_net_send_cmd(client->fd, FIO_NET_CMD_LOAD_FILE, pdu, p_size,NULL, NULL);
+	free(pdu);
+	return ret;
+}
+
 /*
  * Send file contents to server backend. We could use sendfile(), but to remain
  * more portable lets just read/write the darn thing.
  */
-static int __fio_client_send_ini(struct fio_client *client, const char *filename)
+static int __fio_client_send_local_ini(struct fio_client *client,
+				       const char *filename)
 {
 	struct cmd_job_pdu *pdu;
 	size_t p_size;
@@ -668,17 +703,28 @@ static int __fio_client_send_ini(struct fio_client *client, const char *filename
 	return ret;
 }
 
-int fio_client_send_ini(struct fio_client *client, const char *filename)
+int fio_client_send_ini(struct fio_client *client, const char *filename,
+			int remote)
 {
 	int ret;
 
-	ret = __fio_client_send_ini(client, filename);
+	if (!remote)
+		ret = __fio_client_send_local_ini(client, filename);
+	else
+		ret = __fio_client_send_remote_ini(client, filename);
+
 	if (!ret)
 		client->sent_job = 1;
 
 	return ret;
 }
 
+static int fio_client_send_cf(struct fio_client *client,
+			      struct client_file *cf)
+{
+	return fio_client_send_ini(client, cf->file, cf->remote);
+}
+
 int fio_clients_send_ini(const char *filename)
 {
 	struct fio_client *client;
@@ -687,18 +733,23 @@ int fio_clients_send_ini(const char *filename)
 	flist_for_each_safe(entry, tmp, &client_list) {
 		client = flist_entry(entry, struct fio_client, list);
 
-		if (client->nr_ini_file) {
+		if (client->nr_files) {
 			int i;
 
-			for (i = 0; i < client->nr_ini_file; i++) {
-				const char *ini = client->ini_file[i];
+			for (i = 0; i < client->nr_files; i++) {
+				struct client_file *cf;
 
-				if (fio_client_send_ini(client, ini)) {
+				cf = &client->files[i];
+
+				if (fio_client_send_cf(client, cf)) {
 					remove_client(client);
 					break;
 				}
 			}
-		} else if (!filename || fio_client_send_ini(client, filename))
+		}
+		if (client->sent_job)
+			continue;
+		if (!filename || fio_client_send_ini(client, filename, 0))
 			remove_client(client);
 	}
 
diff --git a/client.h b/client.h
index c8ff23e..d632f46 100644
--- a/client.h
+++ b/client.h
@@ -20,6 +20,11 @@ enum {
 	Client_exited		= 5,
 };
 
+struct client_file {
+	char *file;
+	int remote;
+};
+
 struct fio_client {
 	struct flist_head list;
 	struct flist_head hash_list;
@@ -64,8 +69,8 @@ struct fio_client {
 	struct client_ops *ops;
 	void *client_data;
 
-	char **ini_file;
-	unsigned int nr_ini_file;
+	struct client_file *files;
+	unsigned int nr_files;
 };
 
 struct cmd_iolog_pdu;
@@ -119,13 +124,13 @@ extern int fio_client_connect(struct fio_client *);
 extern int fio_clients_connect(void);
 extern int fio_start_client(struct fio_client *);
 extern int fio_start_all_clients(void);
-extern int fio_client_send_ini(struct fio_client *, const char *);
 extern int fio_clients_send_ini(const char *);
+extern int fio_client_send_ini(struct fio_client *, const char *, int);
 extern int fio_handle_clients(struct client_ops *);
 extern int fio_client_add(struct client_ops *, const char *, void **);
 extern struct fio_client *fio_client_add_explicit(struct client_ops *, const char *, int, int);
 extern void fio_client_add_cmd_option(void *, const char *);
-extern void fio_client_add_ini_file(void *, const char *);
+extern int fio_client_add_ini_file(void *, const char *, int);
 extern int fio_client_terminate(struct fio_client *);
 extern void fio_clients_terminate(void);
 extern struct fio_client *fio_get_client(struct fio_client *);
diff --git a/engines/net.c b/engines/net.c
index 8087207..1d89db1 100644
--- a/engines/net.c
+++ b/engines/net.c
@@ -1213,7 +1213,7 @@ static int fio_netio_setup(struct thread_data *td)
 
 static void fio_netio_terminate(struct thread_data *td)
 {
-	kill(td->pid, SIGUSR2);
+	kill(td->pid, SIGTERM);
 }
 
 #ifdef CONFIG_LINUX_SPLICE
diff --git a/fio.1 b/fio.1
index b4dec91..91c3074 100644
--- a/fio.1
+++ b/fio.1
@@ -1848,6 +1848,14 @@ does on the server side, to allow IP/hostname/socket and port strings.
 You can connect to multiple clients as well, to do that you could run:
 
 fio \-\-client=server2 \-\-client=server2 <job file(s)>
+
+If the job file is located on the fio server, then you can tell the server
+to load a local file as well. This is done by using \-\-remote-config:
+
+fio \-\-client=server \-\-remote-config /path/to/file.fio
+
+Then the fio serer will open this local (to the server) job file instead
+of being passed one from the client.
 .SH AUTHORS
 
 .B fio
diff --git a/gfio.c b/gfio.c
index 0e22cba..42d536e 100644
--- a/gfio.c
+++ b/gfio.c
@@ -449,7 +449,7 @@ static int send_job_file(struct gui_entry *ge)
 		free(gco);
 	}
 
-	ret = fio_client_send_ini(gc->client, ge->job_file);
+	ret = fio_client_send_ini(gc->client, ge->job_file, 0);
 	if (!ret)
 		return 0;
 
diff --git a/init.c b/init.c
index 861b1f5..1768478 100644
--- a/init.c
+++ b/init.c
@@ -217,6 +217,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'C',
 	},
 	{
+		.name		= (char *) "remote-config",
+		.has_arg	= required_argument,
+		.val		= 'R',
+	},
+	{
 		.name		= (char *) "cpuclock-test",
 		.has_arg	= no_argument,
 		.val		= 'T',
@@ -1424,7 +1429,11 @@ int __parse_jobs_ini(struct thread_data *td,
 			f = fopen(file, "r");
 
 		if (!f) {
-			perror("fopen job file");
+			int __err = errno;
+
+			log_err("fio: unable to open '%s' job file\n", file);
+			if (td)
+				td_verror(td, __err, "job file open");
 			return 1;
 		}
 	}
@@ -1683,6 +1692,7 @@ static void usage(const char *name)
 	printf("  --server=args\t\tStart a backend fio server\n");
 	printf("  --daemonize=pidfile\tBackground fio server, write pid to file\n");
 	printf("  --client=hostname\tTalk to remote backend fio server at hostname\n");
+	printf("  --remote-config=file\tTell fio server to load this local job file\n");
 	printf("  --idle-prof=option\tReport cpu idleness on a system or percpu basis\n"
 		"\t\t\t(option=system,percpu) or run unit work\n"
 		"\t\t\tcalibration only (option=calibrate)\n");
@@ -2174,10 +2184,18 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				    !strncmp(argv[optind], "-", 1))
 					break;
 
-				fio_client_add_ini_file(cur_client, argv[optind]);
+				if (fio_client_add_ini_file(cur_client, argv[optind], 0))
+					break;
 				optind++;
 			}
 			break;
+		case 'R':
+			did_arg = 1;
+			if (fio_client_add_ini_file(cur_client, optarg, 1)) {
+				do_exit++;
+				exit_val = 1;
+			}
+			break;
 		case 'T':
 			did_arg = 1;
 			do_exit++;
diff --git a/server.c b/server.c
index 36713ee..fa029ca 100644
--- a/server.c
+++ b/server.c
@@ -69,6 +69,8 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"ADD_JOB",
 	"CMD_RUN",
 	"CMD_IOLOG",
+	"CMD_UPDATE_JOB",
+	"CMD_LOAD_FILE",
 };
 
 const char *fio_server_op(unsigned int op)
@@ -550,6 +552,28 @@ static void fio_server_check_conns(struct flist_head *conn_list)
 	fio_server_check_fork_items(conn_list);
 }
 
+static int handle_load_file_cmd(struct fio_net_cmd *cmd)
+{
+	struct cmd_load_file_pdu *pdu = (struct cmd_load_file_pdu *) cmd->payload;
+	void *file_name = pdu->file;
+	struct cmd_start_pdu spdu;
+
+	dprint(FD_NET, "server: loading local file %s\n", (char *) file_name);
+
+	pdu->name_len = le16_to_cpu(pdu->name_len);
+	pdu->client_type = le16_to_cpu(pdu->client_type);
+
+	if (parse_jobs_ini(file_name, 0, 0, pdu->client_type)) {
+		fio_net_send_quit(server_fd);
+		return -1;
+	}
+
+	spdu.jobs = cpu_to_le32(thread_number);
+	spdu.stat_outputs = cpu_to_le32(stat_number);
+	fio_net_send_cmd(server_fd, FIO_NET_CMD_START, &spdu, sizeof(spdu), NULL, NULL);
+	return 0;
+}
+
 static int handle_run_cmd(struct flist_head *job_list, struct fio_net_cmd *cmd)
 {
 	pid_t pid;
@@ -747,6 +771,9 @@ static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 	case FIO_NET_CMD_EXIT:
 		exit_backend = 1;
 		return -1;
+	case FIO_NET_CMD_LOAD_FILE:
+		ret = handle_load_file_cmd(cmd);
+		break;
 	case FIO_NET_CMD_JOB:
 		ret = handle_job_cmd(cmd);
 		break;
diff --git a/server.h b/server.h
index 1b131b9..67ba38d 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 36,
+	FIO_SERVER_VER			= 37,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -61,7 +61,8 @@ enum {
 	FIO_NET_CMD_RUN			= 16,
 	FIO_NET_CMD_IOLOG		= 17,
 	FIO_NET_CMD_UPDATE_JOB		= 18,
-	FIO_NET_CMD_NR			= 19,
+	FIO_NET_CMD_LOAD_FILE		= 19,
+	FIO_NET_CMD_NR			= 20,
 
 	FIO_NET_CMD_F_MORE		= 1UL << 0,
 
@@ -76,6 +77,12 @@ enum {
 	FIO_PROBE_FLAG_ZLIB		= 1UL << 0,
 };
 
+struct cmd_load_file_pdu {
+	uint16_t name_len;
+	uint16_t client_type;
+	uint8_t file[];
+};
+
 struct cmd_ts_pdu {
 	struct thread_stat ts;
 	struct group_run_stats rs;
@@ -169,11 +176,6 @@ extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
 extern void fio_server_idle_loop(void);
 
-extern int fio_clients_connect(void);
-extern int fio_clients_send_ini(const char *);
-extern void fio_client_add_cmd_option(void *, const char *);
-extern void fio_client_add_ini_file(void *, const char *);
-
 extern int fio_recv_data(int sk, void *p, unsigned int len);
 extern int fio_send_data(int sk, const void *p, unsigned int len);
 extern void fio_net_cmd_crc(struct fio_net_cmd *);
