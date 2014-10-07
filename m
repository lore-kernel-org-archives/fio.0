Return-Path: <axboe@kernel.dk>
Message-ID: <543462BE.3000101@kernel.dk>
Date: Tue, 07 Oct 2014 16:01:34 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <54345B52.7060306@kernel.dk>
In-Reply-To: <54345B52.7060306@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------080608080105070300030904"
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080608080105070300030904
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 10/07/2014 03:29 PM, Jens Axboe wrote:
> On 10/07/2014 11:38 AM, Neto, Antonio Jose Rodrigues wrote:
>> Hi All,
>>
>> This is neto from Brazil
>>
>> How are you?
>>
>> One small suggestion:
>>
>> Running Client and Server architecture on FIO, we need to have all config
>> files "locally" to run it.
>>
>>
>> Nossa Senhora:tools neto$ ls
>> 151 152 fio
>>
>>
>>
>> Nossa Senhora:tools neto$ ./fio --client 10.61.109.151 151 --client
>> 10.61.109.152 152
>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
>> flags=1
>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
>> flags=1
>> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
>> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
>> iodepth=1
>> ioengine=libaio, iodepth=1
>>
>> If we are doing a test in an HPC environment with hundred of files,
>> wouldn't be easier to try to point to a single location for the file and
>> access it remotely (we won't need to copy it locally).
>>
>>
>> For example:
>>
>> ./fio --client 10.61.109.151 --remote-config /root/fio/151 --client
>> 10.61.109.152 --remote-config /root/fio/152
>>
>>
>> Thoughts?
> 
> That's a good idea, would not be hard to insert that step of having the
> remote fio server load a local config file. I'll look into that.

Totally untested, but the below is a start. On the client side, you'd do:

fio --client=server-hostname --remote-config /some/path/to/file

and then the server should attempt to open that. Needs a bit of error
handling, but the concept should be there.

-- 
Jens Axboe


--------------080608080105070300030904
Content-Type: text/x-patch;
 name="net-remote-config.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="net-remote-config.patch"

diff --git a/client.c b/client.c
index 1dded0966cf9..757ead356c39 100644
--- a/client.c
+++ b/client.c
@@ -262,17 +262,24 @@ err:
 	return NULL;
 }
 
-void fio_client_add_ini_file(void *cookie, const char *ini_file)
+void fio_client_add_ini_file(void *cookie, const char *ini_file, int remote)
 {
 	struct fio_client *client = cookie;
 	size_t new_size;
 
 	dprint(FD_NET, "client <%s>: add ini %s\n", client->hostname, ini_file);
 
-	new_size = (client->nr_ini_file + 1) * sizeof(char *);
-	client->ini_file = realloc(client->ini_file, new_size);
-	client->ini_file[client->nr_ini_file] = strdup(ini_file);
-	client->nr_ini_file++;
+	if (!remote) {
+		new_size = (client->nr_ini_file + 1) * sizeof(char *);
+		client->ini_file = realloc(client->ini_file, new_size);
+		client->ini_file[client->nr_ini_file] = strdup(ini_file);
+		client->nr_ini_file++;
+	} else {
+		new_size = (client->nr_remote_file + 1) * sizeof(char *);
+		client->remote_file = realloc(client->remote_file, new_size);
+		client->remote_file[client->nr_remote_file] = strdup(ini_file);
+		client->nr_remote_file++;
+	}
 }
 
 int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
@@ -599,11 +606,33 @@ int fio_start_all_clients(void)
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
+	p_size = sizeof(*pdu) + strlen(filename);
+	pdu = malloc(p_size);
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
@@ -668,11 +697,16 @@ static int __fio_client_send_ini(struct fio_client *client, const char *filename
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
 
@@ -685,20 +719,29 @@ int fio_clients_send_ini(const char *filename)
 	struct flist_head *entry, *tmp;
 
 	flist_for_each_safe(entry, tmp, &client_list) {
+		int i;
+
 		client = flist_entry(entry, struct fio_client, list);
 
 		if (client->nr_ini_file) {
-			int i;
-
 			for (i = 0; i < client->nr_ini_file; i++) {
 				const char *ini = client->ini_file[i];
 
-				if (fio_client_send_ini(client, ini)) {
+				if (fio_client_send_ini(client, ini, 0)) {
+					remove_client(client);
+					break;
+				}
+			}
+		} else if (client->nr_remote_file) {
+			for (i = 0; i < client->nr_remote_file; i++) {
+				const char *ini = client->remote_file[i];
+
+				if (fio_client_send_ini(client, ini, 1)) {
 					remove_client(client);
 					break;
 				}
 			}
-		} else if (!filename || fio_client_send_ini(client, filename))
+		} else if (!filename || fio_client_send_ini(client, filename, 0))
 			remove_client(client);
 	}
 
diff --git a/client.h b/client.h
index c8ff23ecdd68..89a0783d8d57 100644
--- a/client.h
+++ b/client.h
@@ -66,6 +66,9 @@ struct fio_client {
 
 	char **ini_file;
 	unsigned int nr_ini_file;
+
+	char **remote_file;
+	unsigned int nr_remote_file;
 };
 
 struct cmd_iolog_pdu;
@@ -119,13 +122,13 @@ extern int fio_client_connect(struct fio_client *);
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
+extern void fio_client_add_ini_file(void *, const char *, int);
 extern int fio_client_terminate(struct fio_client *);
 extern void fio_clients_terminate(void);
 extern struct fio_client *fio_get_client(struct fio_client *);
diff --git a/init.c b/init.c
index 861b1f5fd0f4..e3ce4702c743 100644
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
@@ -2174,10 +2179,14 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 				    !strncmp(argv[optind], "-", 1))
 					break;
 
-				fio_client_add_ini_file(cur_client, argv[optind]);
+				fio_client_add_ini_file(cur_client, argv[optind], 0);
 				optind++;
 			}
 			break;
+		case 'R':
+			fio_client_add_ini_file(cur_client, optarg, 1);
+			did_arg = 1;
+			break;
 		case 'T':
 			did_arg = 1;
 			do_exit++;
diff --git a/server.c b/server.c
index 36713ee57160..fa029ca3bc38 100644
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
index 1b131b92f08a..67ba38d216d9 100644
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

--------------080608080105070300030904--

