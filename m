Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43918 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaKLNAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 12 Nov 2014 08:00:08 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XoXWn-0002eF-FD
	for fio@vger.kernel.org; Wed, 12 Nov 2014 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141112130004.2722D400C0@lyth.info>
Date: Wed, 12 Nov 2014 06:00:04 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 88038bc7193e648cef39061e0b8d6ef8203a1e63:

  Fixup some of the time (usec) based conversions (2014-11-10 20:31:26 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to e499aedc141da35cf778116d0abcb9cfcd53470c:

  verify: verify_state_gen_name() should check size (2014-11-11 20:51:37 -0700)

----------------------------------------------------------------
Jens Axboe (8):
      Makefile: add -Wshadow
      t/btrace2fio: fix divide-by-zero in rate calculation
      t/btrace2fio: don't dec inflight for requeue
      Add support for verify triggers and verify state saving
      client: replace duplicate code with read_data()
      Fio 2.1.14
      Merge branch 'verify-trigger'
      verify: verify_state_gen_name() should check size

 FIO-VERSION-GEN        |    2 +-
 HOWTO                  |   15 +++
 Makefile               |    2 +-
 backend.c              |  109 ++++++++++++++++++
 cconv.c                |    2 +
 client.c               |  164 ++++++++++++++++++++++-----
 client.h               |    1 +
 fio.1                  |   11 ++
 fio.h                  |   23 +++-
 init.c                 |   49 ++++++++
 io_u.c                 |   26 +++--
 lib/num2str.c          |   14 +--
 options.c              |   22 ++++
 os/windows/install.wxs |    2 +-
 server.c               |  141 +++++++++++++++++++++++-
 server.h               |   27 ++++-
 t/btrace2fio.c         |    8 +-
 thread_options.h       |    6 +-
 verify.c               |  288 ++++++++++++++++++++++++++++++++++++++++++++++++
 verify.h               |   58 ++++++++++
 20 files changed, 910 insertions(+), 60 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 3057fed..e2052c4 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.13
+DEF_VER=fio-2.1.14
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 73be9d7..cdb7b01 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1316,6 +1316,21 @@ verify_backlog_batch=int	Control how many blocks fio will verify
 		if verify_backlog_batch is larger than verify_backlog, some
 		blocks will be verified more than once.
 
+verify_state_save=bool	When a job exits during the write phase of a verify
+		workload, save its current state. This allows fio to replay
+		up until that point, if the verify state is loaded for the
+		verify read phase. The format of the filename is, roughly,
+		<type>-<jobname>-<jobindex>-verify.state. <type> is "local"
+		for a local run, "sock" for a client/server socket connection,
+		and "ip" (192.168.0.1, for instance) for a networked
+		client/server connection.
+
+verify_state_load=bool	If a verify termination trigger was used, fio stores
+		the current write state of each thread. This can be used at
+		verification time so that fio knows how far it should verify.
+		Without this information, fio will run a full verification
+		pass, according to the settings in the job file used.
+
 stonewall
 wait_for_previous Wait for preceding jobs in the job file to exit, before
 		starting this one. Can be used to insert serialization
diff --git a/Makefile b/Makefile
index 8a28f62..b7c1645 100644
--- a/Makefile
+++ b/Makefile
@@ -17,7 +17,7 @@ endif
 DEBUGFLAGS = -D_FORTIFY_SOURCE=2 -DFIO_INC_DEBUG
 CPPFLAGS= -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -DFIO_INTERNAL $(DEBUGFLAGS)
 OPTFLAGS= -O3 -g -ffast-math
-CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
+CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wshadow -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
 SCRIPTS = tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio
diff --git a/backend.c b/backend.c
index a93c458..77f5233 100644
--- a/backend.c
+++ b/backend.c
@@ -526,6 +526,11 @@ static void do_verify(struct thread_data *td, uint64_t verify_bytes)
 				break;
 		}
 
+		if (verify_state_should_stop(td, io_u)) {
+			put_io_u(td, io_u);
+			break;
+		}
+
 		if (td->o.verify_async)
 			io_u->end_io = verify_io_u_async;
 		else
@@ -758,6 +763,11 @@ static uint64_t do_io(struct thread_data *td)
 					io_u->rand_seed *= __rand(&td->verify_state);
 			}
 
+			if (verify_state_should_stop(td, io_u)) {
+				put_io_u(td, io_u);
+				break;
+			}
+
 			if (td->o.verify_async)
 				io_u->end_io = verify_io_u_async;
 			else
@@ -977,6 +987,9 @@ static void cleanup_io_u(struct thread_data *td)
 	io_u_rexit(&td->io_u_requeues);
 	io_u_qexit(&td->io_u_freelist);
 	io_u_qexit(&td->io_u_all);
+
+	if (td->last_write_comp)
+		sfree(td->last_write_comp);
 }
 
 static int init_io_u(struct thread_data *td)
@@ -1093,6 +1106,14 @@ static int init_io_u(struct thread_data *td)
 		p += max_bs;
 	}
 
+	if (td->o.verify != VERIFY_NONE) {
+		td->last_write_comp = scalloc(max_units, sizeof(uint64_t));
+		if (!td->last_write_comp) {
+			log_err("fio: failed to alloc write comp data\n");
+			return 1;
+		}
+	}
+
 	return 0;
 }
 
@@ -1529,6 +1550,18 @@ static void *thread_main(void *data)
 	td->ts.io_bytes[DDIR_WRITE] = td->io_bytes[DDIR_WRITE];
 	td->ts.io_bytes[DDIR_TRIM] = td->io_bytes[DDIR_TRIM];
 
+	if (td->o.verify_state_save && !(td->flags & TD_F_VSTATE_SAVED) &&
+	    (td->o.verify != VERIFY_NONE && td_write(td))) {
+		struct all_io_list *state;
+		size_t sz;
+
+		state = get_all_io_list(td->thread_number, &sz);
+		if (state) {
+			__verify_save_state(state, "local");
+			free(state);
+		}
+	}
+
 	fio_unpin_memory(td);
 
 	fio_writeout_logs(td);
@@ -1554,6 +1587,7 @@ err:
 	cleanup_io_u(td);
 	close_ioengine(td);
 	cgroup_shutdown(td, &cgroup_mnt);
+	verify_free_state(td);
 
 	if (o->cpumask_set) {
 		ret = fio_cpuset_exit(&o->cpumask);
@@ -1730,9 +1764,80 @@ reaped:
 		fio_terminate_threads(TERMINATE_ALL);
 }
 
+static int __check_trigger_file(void)
+{
+	struct stat sb;
+
+	if (!trigger_file)
+		return 0;
+
+	if (stat(trigger_file, &sb))
+		return 0;
+
+	if (unlink(trigger_file) < 0)
+		log_err("fio: failed to unlink %s: %s\n", trigger_file,
+							strerror(errno));
+
+	return 1;
+}
+
+static int trigger_timedout(void)
+{
+	if (trigger_timeout)
+		return time_since_genesis() >= trigger_timeout;
+
+	return 0;
+}
+
+void exec_trigger(const char *cmd)
+{
+	int ret;
+
+	if (!cmd)
+		return;
+
+	ret = system(cmd);
+	if (ret == -1)
+		log_err("fio: failed executing %s trigger\n", cmd);
+}
+
+void check_trigger_file(void)
+{
+	if (__check_trigger_file() || trigger_timedout()) {
+		if (nr_clients)
+			fio_clients_send_trigger(trigger_cmd);
+		else {
+			verify_save_state();
+			fio_terminate_threads(TERMINATE_ALL);
+			exec_trigger(trigger_cmd);
+		}
+	}
+}
+
+static int fio_verify_load_state(struct thread_data *td)
+{
+	int ret;
+
+	if (!td->o.verify_state)
+		return 0;
+
+	if (is_backend) {
+		void *data;
+
+		ret = fio_server_get_verify_state(td->o.name,
+					td->thread_number - 1, &data);
+		if (!ret)
+			verify_convert_assign_state(td, data);
+	} else
+		ret = verify_load_state(td, "local");
+
+	return ret;
+}
+
 static void do_usleep(unsigned int usecs)
 {
 	check_for_running_stats();
+	check_trigger_file();
 	usleep(usecs);
 }
 
@@ -1786,12 +1891,16 @@ static void run_threads(void)
 		if (!td->o.create_serialize)
 			continue;
 
+		if (fio_verify_load_state(td))
+			goto reap;
+
 		/*
 		 * do file setup here so it happens sequentially,
 		 * we don't want X number of threads getting their
 		 * client data interspersed on disk
 		 */
 		if (setup_files(td)) {
+reap:
 			exit_value++;
 			if (td->error)
 				log_err("fio: pid=%d, err=%d/%s\n",
diff --git a/cconv.c b/cconv.c
index 607cede..d0a124e 100644
--- a/cconv.c
+++ b/cconv.c
@@ -131,6 +131,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->verifysort = le32_to_cpu(top->verifysort);
 	o->verifysort_nr = le32_to_cpu(top->verifysort_nr);
 	o->experimental_verify = le32_to_cpu(top->experimental_verify);
+	o->verify_state = le32_to_cpu(top->verify_state);
 	o->verify_interval = le32_to_cpu(top->verify_interval);
 	o->verify_offset = le32_to_cpu(top->verify_offset);
 
@@ -308,6 +309,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->verifysort = cpu_to_le32(o->verifysort);
 	top->verifysort_nr = cpu_to_le32(o->verifysort_nr);
 	top->experimental_verify = cpu_to_le32(o->experimental_verify);
+	top->verify_state = cpu_to_le32(o->verify_state);
 	top->verify_interval = cpu_to_le32(o->verify_interval);
 	top->verify_offset = cpu_to_le32(o->verify_offset);
 	top->verify_pattern_bytes = cpu_to_le32(o->verify_pattern_bytes);
diff --git a/client.c b/client.c
index 56ee6dc..52440f0 100644
--- a/client.c
+++ b/client.c
@@ -23,6 +23,7 @@
 #include "server.h"
 #include "flist.h"
 #include "hash.h"
+#include "verify.h"
 
 static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd);
 static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd);
@@ -88,6 +89,30 @@ static void fio_init fio_client_hash_init(void)
 		INIT_FLIST_HEAD(&client_hash[i]);
 }
 
+static int read_data(int fd, void *data, size_t size)
+{
+	ssize_t ret;
+
+	while (size) {
+		ret = read(fd, data, size);
+		if (ret < 0) {
+			if (errno == EAGAIN || errno == EINTR)
+				continue;
+			break;
+		} else if (!ret)
+			break;
+		else {
+			data += ret;
+			size -= ret;
+		}
+	}
+
+	if (size)
+		return EAGAIN;
+
+	return 0;
+}
+
 static void fio_client_json_init(void)
 {
 	if (output_format != FIO_OUTPUT_JSON)
@@ -337,10 +362,26 @@ int fio_client_add(struct client_ops *ops, const char *hostname, void **cookie)
 	return 0;
 }
 
+static const char *server_name(struct fio_client *client, char *buf,
+			       size_t bufsize)
+{
+	const char *from;
+
+	if (client->ipv6)
+		from = inet_ntop(AF_INET6, (struct sockaddr *) &client->addr6.sin6_addr, buf, bufsize);
+	else if (client->is_sock)
+		from = "sock";
+	else
+		from = inet_ntop(AF_INET, (struct sockaddr *) &client->addr.sin_addr, buf, bufsize);
+
+	return from;
+}
+
 static void probe_client(struct fio_client *client)
 {
 	struct cmd_client_probe_pdu pdu;
 	uint64_t tag;
+	char buf[64];
 
 	dprint(FD_NET, "client: send probe\n");
 
@@ -350,6 +391,8 @@ static void probe_client(struct fio_client *client)
 	pdu.flags = 0;
 #endif
 
+	strcpy((char *) pdu.server, server_name(client, buf, sizeof(buf)));
+
 	fio_net_send_cmd(client->fd, FIO_NET_CMD_PROBE, &pdu, sizeof(pdu), &tag, &client->cmd_list);
 }
 
@@ -672,21 +715,7 @@ static int __fio_client_send_local_ini(struct fio_client *client,
 
 	len = sb.st_size;
 	p = buf;
-	do {
-		ret = read(fd, p, len);
-		if (ret > 0) {
-			len -= ret;
-			if (!len)
-				break;
-			p += ret;
-			continue;
-		} else if (!ret)
-			break;
-		else if (errno == EAGAIN || errno == EINTR)
-			continue;
-	} while (1);
-
-	if (len) {
+	if (read_data(fd, p, len)) {
 		log_err("fio: failed reading job file %s\n", filename);
 		close(fd);
 		free(pdu);
@@ -1304,6 +1333,47 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 	return ret;
 }
 
+static void sendfile_reply(int fd, struct cmd_sendfile_reply *rep,
+			   size_t size, uint64_t tag)
+{
+	rep->error = cpu_to_le32(rep->error);
+	fio_net_send_cmd(fd, FIO_NET_CMD_SENDFILE, rep, size, &tag, NULL);
+}
+
+static int send_file(struct fio_client *client, struct cmd_sendfile *pdu,
+		     uint64_t tag)
+{
+	struct cmd_sendfile_reply *rep;
+	struct stat sb;
+	size_t size;
+	int fd;
+
+	size = sizeof(*rep);
+	rep = malloc(size);
+
+	if (stat((char *)pdu->path, &sb) < 0) {
+fail:
+		rep->error = errno;
+		sendfile_reply(client->fd, rep, size, tag);
+		free(rep);
+		return 1;
+	}
+
+	size += sb.st_size;
+	rep = realloc(rep, size);
+	rep->size = cpu_to_le32((uint32_t) sb.st_size);
+
+	fd = open((char *)pdu->path, O_RDONLY);
+	if (fd == -1 )
+		goto fail;
+
+	rep->error = read_data(fd, &rep->data, sb.st_size);
+	sendfile_reply(client->fd, rep, size, tag);
+	free(rep);
+	close(fd);
+	return 0;
+}
+
 int fio_handle_client(struct fio_client *client)
 {
 	struct client_ops *ops = client->ops;
@@ -1323,12 +1393,10 @@ int fio_handle_client(struct fio_client *client)
 		if (ops->quit)
 			ops->quit(client, cmd);
 		remove_client(client);
-		free(cmd);
 		break;
 	case FIO_NET_CMD_TEXT:
 		convert_text(cmd);
 		ops->text(client, cmd);
-		free(cmd);
 		break;
 	case FIO_NET_CMD_DU: {
 		struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
@@ -1337,7 +1405,6 @@ int fio_handle_client(struct fio_client *client)
 		convert_agg(&du->agg);
 
 		ops->disk_util(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_TS: {
@@ -1347,7 +1414,6 @@ int fio_handle_client(struct fio_client *client)
 		convert_gs(&p->rs, &p->rs);
 
 		ops->thread_status(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_GS: {
@@ -1356,7 +1422,6 @@ int fio_handle_client(struct fio_client *client)
 		convert_gs(gs, gs);
 
 		ops->group_stats(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_ETA: {
@@ -1365,26 +1430,22 @@ int fio_handle_client(struct fio_client *client)
 		remove_reply_cmd(client, cmd);
 		convert_jobs_eta(je);
 		handle_eta(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_PROBE:
 		remove_reply_cmd(client, cmd);
 		ops->probe(client, cmd);
-		free(cmd);
 		break;
 	case FIO_NET_CMD_SERVER_START:
 		client->state = Client_running;
 		if (ops->job_start)
 			ops->job_start(client, cmd);
-		free(cmd);
 		break;
 	case FIO_NET_CMD_START: {
 		struct cmd_start_pdu *pdu = (struct cmd_start_pdu *) cmd->payload;
 
 		pdu->jobs = le32_to_cpu(pdu->jobs);
 		ops->start(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_STOP: {
@@ -1395,7 +1456,6 @@ int fio_handle_client(struct fio_client *client)
 		client->error = le32_to_cpu(pdu->error);
 		client->signal = le32_to_cpu(pdu->signal);
 		ops->stop(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_ADD_JOB: {
@@ -1406,7 +1466,6 @@ int fio_handle_client(struct fio_client *client)
 
 		if (ops->add_job)
 			ops->add_job(client, cmd);
-		free(cmd);
 		break;
 		}
 	case FIO_NET_CMD_IOLOG:
@@ -1416,22 +1475,62 @@ int fio_handle_client(struct fio_client *client)
 			pdu = convert_iolog(cmd);
 			ops->iolog(client, pdu);
 		}
-		free(cmd);
 		break;
 	case FIO_NET_CMD_UPDATE_JOB:
 		ops->update_job(client, cmd);
 		remove_reply_cmd(client, cmd);
-		free(cmd);
 		break;
+	case FIO_NET_CMD_VTRIGGER: {
+		struct all_io_list *pdu = (struct all_io_list *) cmd->payload;
+		char buf[64];
+
+		__verify_save_state(pdu, server_name(client, buf, sizeof(buf)));
+		break;
+		}
+	case FIO_NET_CMD_SENDFILE: {
+		struct cmd_sendfile *pdu = (struct cmd_sendfile *) cmd->payload;
+		send_file(client, pdu, cmd->tag);
+		break;
+		}
 	default:
 		log_err("fio: unknown client op: %s\n", fio_server_op(cmd->opcode));
-		free(cmd);
 		break;
 	}
 
+	free(cmd);
 	return 1;
 }
 
+int fio_clients_send_trigger(const char *cmd)
+{
+	struct flist_head *entry;
+	struct fio_client *client;
+	size_t slen;
+
+	dprint(FD_NET, "client: send vtrigger: %s\n", cmd);
+
+	if (!cmd)
+		slen = 0;
+	else
+		slen = strlen(cmd);
+
+	flist_for_each(entry, &client_list) {
+		struct cmd_vtrigger_pdu *pdu;
+
+		client = flist_entry(entry, struct fio_client, list);
+
+		pdu = malloc(sizeof(*pdu) + slen);
+		pdu->len = cpu_to_le16((uint16_t) slen);
+		if (slen)
+			memcpy(pdu->cmd, cmd, slen);
+		fio_net_send_cmd(client->fd, FIO_NET_CMD_VTRIGGER, pdu,
+					sizeof(*pdu) + slen, NULL, NULL);
+		free(pdu);
+	}
+
+	return 0;
+}
+
 static void request_client_etas(struct client_ops *ops)
 {
 	struct fio_client *client;
@@ -1558,6 +1657,7 @@ int fio_handle_clients(struct client_ops *ops)
 
 		do {
 			struct timeval tv;
+			int timeout;
 
 			fio_gettime(&tv, NULL);
 			if (mtime_since(&eta_tv, &tv) >= 900) {
@@ -1568,7 +1668,11 @@ int fio_handle_clients(struct client_ops *ops)
 					break;
 			}
 
-			ret = poll(pfds, nr_clients, ops->eta_msec);
+			check_trigger_file();
+
+			timeout = min(100u, ops->eta_msec);
+
+			ret = poll(pfds, nr_clients, timeout);
 			if (ret < 0) {
 				if (errno == EINTR)
 					continue;
diff --git a/client.h b/client.h
index d632f46..8818de2 100644
--- a/client.h
+++ b/client.h
@@ -137,6 +137,7 @@ extern struct fio_client *fio_get_client(struct fio_client *);
 extern void fio_put_client(struct fio_client *);
 extern int fio_client_update_options(struct fio_client *, struct thread_options *, uint64_t *);
 extern int fio_client_wait_for_reply(struct fio_client *, uint64_t);
+extern int fio_clients_send_trigger(const char *);
 
 #define FIO_CLIENT_DEF_ETA_MSEC		900
 
diff --git a/fio.1 b/fio.1
index 82868a8..89cbb82 100644
--- a/fio.1
+++ b/fio.1
@@ -1173,6 +1173,17 @@ Trim this number of IO blocks.
 .BI experimental_verify \fR=\fPbool
 Enable experimental verification.
 .TP
+.BI verify_state_save \fR=\fPbool
+When a job exits during the write phase of a verify workload, save its
+current state. This allows fio to replay up until that point, if the
+verify state is loaded for the verify read phase.
+.TP
+.BI verify_state_load \fR=\fPbool
+If a verify termination trigger was used, fio stores the current write
+state of each thread. This can be used at verification time so that fio
+knows how far it should verify. Without this information, fio will run
+a full verification pass, according to the settings in the job file used.
+.TP
 .B stonewall "\fR,\fP wait_for_previous"
 Wait for preceding jobs in the job file to exit before starting this one.
 \fBstonewall\fR implies \fBnew_group\fR.
diff --git a/fio.h b/fio.h
index 28f4597..50cf1b0 100644
--- a/fio.h
+++ b/fio.h
@@ -74,6 +74,7 @@ enum {
 	TD_F_COMPRESS		= 128,
 	TD_F_NOIO		= 256,
 	TD_F_COMPRESS_LOG	= 512,
+	TD_F_VSTATE_SAVED	= 1024,
 };
 
 enum {
@@ -123,6 +124,13 @@ struct thread_data {
 	uint64_t stat_io_blocks[DDIR_RWDIR_CNT];
 	struct timeval iops_sample_time;
 
+	/*
+	 * Tracks the last iodepth number of completed writes, if data
+	 * verification is enabled
+	 */
+	uint64_t *last_write_comp;
+	unsigned int last_write_idx;
+
 	volatile int update_rusage;
 	struct fio_mutex *rusage_sem;
 	struct rusage ru_start;
@@ -142,6 +150,7 @@ struct thread_data {
 	int error;
 	int sig;
 	int done;
+	int stop_io;
 	pid_t pid;
 	char *orig_buffer;
 	size_t orig_buffer_size;
@@ -171,6 +180,8 @@ struct thread_data {
 	unsigned int verify_batch;
 	unsigned int trim_batch;
 
+	struct thread_io_list *vstate;
+
 	int shm_id;
 
 	/*
@@ -224,7 +235,7 @@ struct thread_data {
 	uint64_t total_io_size;
 	uint64_t fill_device_size;
 
-	unsigned long io_issues[DDIR_RWDIR_CNT];
+	uint64_t io_issues[DDIR_RWDIR_CNT];
 	uint64_t io_blocks[DDIR_RWDIR_CNT];
 	uint64_t this_io_blocks[DDIR_RWDIR_CNT];
 	uint64_t io_bytes[DDIR_RWDIR_CNT];
@@ -380,6 +391,9 @@ extern int status_interval;
 extern const char fio_version_string[];
 extern int helper_do_stat;
 extern pthread_cond_t helper_cond;
+extern char *trigger_file;
+extern char *trigger_cmd;
+extern long long trigger_timeout;
 
 extern struct thread_data *threads;
 
@@ -422,7 +436,7 @@ extern void fio_options_mem_dupe(struct thread_data *);
 extern void options_mem_dupe(void *data, struct fio_option *options);
 extern void td_fill_rand_seeds(struct thread_data *);
 extern void add_job_opts(const char **, int);
-extern char *num2str(unsigned long, int, int, int, int);
+extern char *num2str(uint64_t, int, int, int, int);
 extern int ioengine_load(struct thread_data *);
 extern int parse_dryrun(void);
 extern int fio_running_or_pending_io_threads(void);
@@ -580,7 +594,7 @@ static inline unsigned int td_min_bs(struct thread_data *td)
 	return min(td->o.min_bs[DDIR_TRIM], min_bs);
 }
 
-static inline int is_power_of_2(unsigned long val)
+static inline int is_power_of_2(uint64_t val)
 {
 	return (val != 0 && ((val & (val - 1)) == 0));
 }
@@ -636,4 +650,7 @@ enum {
 	FIO_CPUS_SPLIT,
 };
 
+extern void exec_trigger(const char *);
+extern void check_trigger_file(void);
+
 #endif
diff --git a/init.c b/init.c
index 70d5d06..c7fdcdd 100644
--- a/init.c
+++ b/init.c
@@ -64,6 +64,10 @@ int write_bw_log = 0;
 int read_only = 0;
 int status_interval = 0;
 
+char *trigger_file = NULL;
+char *trigger_cmd = NULL;
+long long trigger_timeout = 0;
+
 static int prev_group_jobs;
 
 unsigned long fio_debug = 0;
@@ -242,6 +246,16 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'L',
 	},
 	{
+		.name		= (char *) "trigger",
+		.has_arg	= required_argument,
+		.val		= 'W',
+	},
+	{
+		.name		= (char *) "trigger-timeout",
+		.has_arg	= required_argument,
+		.val		= 'B',
+	},
+	{
 		.name		= NULL,
 	},
 };
@@ -1665,6 +1679,8 @@ static void usage(const char *name)
 #ifdef CONFIG_ZLIB
 	printf("  --inflate-log=log\tInflate and output compressed log\n");
 #endif
+	printf("  --trigger=file:cmd\tExecute trigger cmd when file exists\n");
+	printf("  --trigger-timeout=t\tExecute trigger af this time\n");
 	printf("\nFio was written by Jens Axboe <jens.axboe@oracle.com>");
 	printf("\n                   Jens Axboe <jaxboe@fusionio.com>");
 	printf("\n                   Jens Axboe <axboe@fb.com>\n");
@@ -2184,6 +2200,39 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			status_interval = val / 1000;
 			break;
 			}
+		case 'W': {
+			char *split, *cmd;
+			size_t sz;
+
+			split = strchr(optarg, ':');
+			if (!split) {
+				log_err("fio: trigger is file:command\n");
+				do_exit++;
+				exit_val = 1;
+			}
+
+			sz = split - optarg;
+			trigger_file = calloc(1, sz + 1);
+			strncpy(trigger_file, optarg, sz);
+
+			split++;
+			cmd = trigger_cmd = strdup(split);
+			strip_blank_front(&trigger_cmd);
+			strip_blank_end(trigger_cmd);
+			if (strlen(trigger_cmd) == 0) {
+				free(cmd);
+				trigger_cmd = NULL;
+			}
+			break;
+			}
+		case 'B':
+			if (check_str_time(optarg, &trigger_timeout, 1)) {
+				log_err("fio: failed parsing time %s\n", optarg);
+				do_exit++;
+				exit_val = 1;
+			}
+			trigger_timeout /= 1000000;
+			break;
 		case '?':
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
diff --git a/io_u.c b/io_u.c
index e8894d5..c51982d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1282,6 +1282,9 @@ struct io_u *__get_io_u(struct thread_data *td)
 {
 	struct io_u *io_u = NULL;
 
+	if (td->stop_io)
+		return NULL;
+
 	td_io_u_lock(td);
 
 again:
@@ -1642,13 +1645,22 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		if (!(io_u->flags & IO_U_F_VER_LIST))
 			td->this_io_bytes[ddir] += bytes;
 
-		if (ddir == DDIR_WRITE && f) {
-			if (f->first_write == -1ULL ||
-			    io_u->offset < f->first_write)
-				f->first_write = io_u->offset;
-			if (f->last_write == -1ULL ||
-			    ((io_u->offset + bytes) > f->last_write))
-				f->last_write = io_u->offset + bytes;
+		if (ddir == DDIR_WRITE) {
+			if (f) {
+				if (f->first_write == -1ULL ||
+				    io_u->offset < f->first_write)
+					f->first_write = io_u->offset;
+				if (f->last_write == -1ULL ||
+				    ((io_u->offset + bytes) > f->last_write))
+					f->last_write = io_u->offset + bytes;
+			}
+			if (td->last_write_comp) {
+				int idx = td->last_write_idx++;
+
+				td->last_write_comp[idx] = io_u->offset;
+				if (td->last_write_idx == td->o.iodepth)
+					td->last_write_idx = 0;
+			}
 		}
 
 		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
diff --git a/lib/num2str.c b/lib/num2str.c
index 8961868..0ed05f3 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -9,7 +9,7 @@
 /*
  * Cheesy number->string conversion, complete with carry rounding error.
  */
-char *num2str(unsigned long num, int maxlen, int base, int pow2, int unit_base)
+char *num2str(uint64_t num, int maxlen, int base, int pow2, int unit_base)
 {
 	const char *postfix[] = { "", "K", "M", "G", "P", "E" };
 	const char *byte_postfix[] = { "", "B", "bit" };
@@ -36,7 +36,7 @@ char *num2str(unsigned long num, int maxlen, int base, int pow2, int unit_base)
 
 	modulo = -1U;
 	while (post_index < sizeof(postfix)) {
-		sprintf(tmp, "%lu", num);
+		sprintf(tmp, "%llu", (unsigned long long) num);
 		if (strlen(tmp) <= maxlen)
 			break;
 
@@ -51,12 +51,12 @@ done:
 		if (post_index >= ARRAY_LENGTH(postfix))
 			post_index = 0;
 
-		sprintf(buf, "%lu%s%s", num, postfix[post_index],
-			byte_postfix[byte_post_index]);
+		sprintf(buf, "%llu%s%s", (unsigned long long) num,
+			postfix[post_index], byte_postfix[byte_post_index]);
 		return buf;
 	}
 
-	sprintf(tmp, "%lu", num);
+	sprintf(tmp, "%llu", (unsigned long long) num);
 	decimals = maxlen - strlen(tmp);
 	if (decimals <= 1) {
 		if (carry)
@@ -72,7 +72,7 @@ done:
 		modulo = (modulo + 9) / 10;
 	} while (1);
 
-	sprintf(buf, "%lu.%u%s%s", num, modulo, postfix[post_index],
-		byte_postfix[byte_post_index]);
+	sprintf(buf, "%llu.%u%s%s", (unsigned long long) num, modulo,
+			postfix[post_index], byte_postfix[byte_post_index]);
 	return buf;
 }
diff --git a/options.c b/options.c
index ac09480..23469d8 100644
--- a/options.c
+++ b/options.c
@@ -2524,6 +2524,28 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(experimental_verify),
 		.type	= FIO_OPT_BOOL,
 		.help	= "Enable experimental verification",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
+	{
+		.name	= "verify_state_load",
+		.lname	= "Load verify state",
+		.off1	= td_var_offset(verify_state),
+		.type	= FIO_OPT_BOOL,
+		.help	= "Load verify termination state",
+		.parent	= "verify",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_VERIFY,
+	},
+	{
+		.name	= "verify_state_save",
+		.lname	= "Save verify state",
+		.off1	= td_var_offset(verify_state_save),
+		.type	= FIO_OPT_BOOL,
+		.def	= "1",
+		.help	= "Save verify state on termination",
+		.parent	= "verify",
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_VERIFY,
 	},
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 7338d63..3e15676 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.13">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.14">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/server.c b/server.c
index d70444b..c4ab906 100644
--- a/server.c
+++ b/server.c
@@ -24,6 +24,8 @@
 #include "server.h"
 #include "crc/crc16.h"
 #include "lib/ieee754.h"
+#include "verify.h"
+#include "smalloc.h"
 
 int fio_net_port = FIO_NET_PORT;
 
@@ -41,6 +43,7 @@ static unsigned int has_zlib = 1;
 static unsigned int has_zlib = 0;
 #endif
 static unsigned int use_zlib;
+static char me[128];
 
 struct fio_fork_item {
 	struct flist_head list;
@@ -50,6 +53,13 @@ struct fio_fork_item {
 	pid_t pid;
 };
 
+struct cmd_reply {
+	struct fio_mutex lock;
+	void *data;
+	size_t size;
+	int error;
+};
+
 static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"",
 	"QUIT",
@@ -67,10 +77,12 @@ static const char *fio_server_ops[FIO_NET_CMD_NR] = {
 	"DISK_UTIL",
 	"SERVER_START",
 	"ADD_JOB",
-	"CMD_RUN",
-	"CMD_IOLOG",
-	"CMD_UPDATE_JOB",
-	"CMD_LOAD_FILE",
+	"RUN",
+	"IOLOG",
+	"UPDATE_JOB",
+	"LOAD_FILE",
+	"VTRIGGER",
+	"SENDFILE",
 };
 
 const char *fio_server_op(unsigned int op)
@@ -661,6 +673,8 @@ static int handle_probe_cmd(struct fio_net_cmd *cmd)
 
 	dprint(FD_NET, "server: sending probe reply\n");
 
+	strcpy(me, (char *) pdu->server);
+
 	memset(&probe, 0, sizeof(probe));
 	gethostname((char *) probe.hostname, sizeof(probe.hostname));
 #ifdef CONFIG_BIG_ENDIAN
@@ -756,6 +770,31 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 	return 0;
 }
 
+static int handle_trigger_cmd(struct fio_net_cmd *cmd)
+{
+	struct cmd_vtrigger_pdu *pdu = (struct cmd_vtrigger_pdu *) cmd->payload;
+	char *buf = (char *) pdu->cmd;
+	struct all_io_list *rep;
+	size_t sz;
+
+	pdu->len = le16_to_cpu(pdu->len);
+	buf[pdu->len] = '\0';
+
+	rep = get_all_io_list(IO_LIST_ALL, &sz);
+	if (!rep) {
+		struct all_io_list state;
+
+		state.threads = cpu_to_le64((uint64_t) 0);
+		fio_net_send_cmd(server_fd, FIO_NET_CMD_VTRIGGER, &state, sizeof(state), NULL, NULL);
+	} else {
+		fio_net_send_cmd(server_fd, FIO_NET_CMD_VTRIGGER, rep, sz, NULL, NULL);
+		free(rep);
+	}
+
+	exec_trigger(buf);
+	return 0;
+}
+
 static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 {
 	int ret;
@@ -792,6 +831,35 @@ static int handle_command(struct flist_head *job_list, struct fio_net_cmd *cmd)
 	case FIO_NET_CMD_UPDATE_JOB:
 		ret = handle_update_job_cmd(cmd);
 		break;
+	case FIO_NET_CMD_VTRIGGER:
+		ret = handle_trigger_cmd(cmd);
+		break;
+	case FIO_NET_CMD_SENDFILE: {
+		struct cmd_sendfile_reply *in;
+		struct cmd_reply *rep;
+
+		rep = (struct cmd_reply *) (uintptr_t) cmd->tag;
+
+		in = (struct cmd_sendfile_reply *) cmd->payload;
+		in->size = le32_to_cpu(in->size);
+		in->error = le32_to_cpu(in->error);
+		if (in->error) {
+			ret = 1;
+			rep->error = in->error;
+		} else {
+			ret = 0;
+			rep->data = smalloc(in->size);
+			if (!rep->data) {
+				ret = 1;
+				rep->error = ENOMEM;
+			} else {
+				rep->size = in->size;
+				memcpy(rep->data, in->data, in->size);
+			}
+		}
+		fio_mutex_up(&rep->lock);
+		break;
+		}
 	default:
 		log_err("fio: unknown opcode: %s\n", fio_server_op(cmd->opcode));
 		ret = 1;
@@ -1302,6 +1370,71 @@ void fio_server_send_start(struct thread_data *td)
 	fio_net_send_simple_cmd(server_fd, FIO_NET_CMD_SERVER_START, 0, NULL);
 }
 
+int fio_server_get_verify_state(const char *name, int threadnumber,
+				void **datap)
+{
+	struct thread_io_list *s;
+	struct cmd_sendfile out;
+	struct cmd_reply *rep;
+	uint64_t tag;
+	void *data;
+
+	dprint(FD_NET, "server: request verify state\n");
+
+	rep = smalloc(sizeof(*rep));
+	if (!rep) {
+		log_err("fio: smalloc pool too small\n");
+		return 1;
+	}
+
+	__fio_mutex_init(&rep->lock, FIO_MUTEX_LOCKED);
+	rep->data = NULL;
+	rep->error = 0;
+
+	verify_state_gen_name((char *) out.path, sizeof(out.path), name, me,
+				threadnumber);
+	tag = (uint64_t) (uintptr_t) rep;
+	fio_net_send_cmd(server_fd, FIO_NET_CMD_SENDFILE, &out, sizeof(out),
+				&tag, NULL);
+
+	/*
+	 * Wait for the backend to receive the reply
+	 */
+	if (fio_mutex_down_timeout(&rep->lock, 10)) {
+		log_err("fio: timed out waiting for reply\n");
+		goto fail;
+	}
+
+	if (rep->error) {
+		log_err("fio: failure on receiving state file: %s\n", strerror(rep->error));
+fail:
+		*datap = NULL;
+		sfree(rep);
+		fio_net_send_quit(server_fd);
+		return 1;
+	}
+
+	/*
+	 * The format is verify_state_hdr, then thread_io_list. Verify
+	 * the header, and the thread_io_list checksum
+	 */
+	s = rep->data + sizeof(struct verify_state_hdr);
+	if (verify_state_hdr(rep->data, s))
+		goto fail;
+
+	/*
+	 * Don't need the header from now, copy just the thread_io_list
+	 */
+	rep->size -= sizeof(struct verify_state_hdr);
+	data = malloc(rep->size);
+	memcpy(data, s, rep->size);
+	*datap = data;
+
+	sfree(rep->data);
+	sfree(rep);
+	return 0;
+}
+
 static int fio_init_server_ip(void)
 {
 	struct sockaddr *addr;
diff --git a/server.h b/server.h
index 46d05a6..84a06a1 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 38,
+	FIO_SERVER_VER			= 39,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
@@ -62,7 +62,9 @@ enum {
 	FIO_NET_CMD_IOLOG		= 17,
 	FIO_NET_CMD_UPDATE_JOB		= 18,
 	FIO_NET_CMD_LOAD_FILE		= 19,
-	FIO_NET_CMD_NR			= 20,
+	FIO_NET_CMD_VTRIGGER		= 20,
+	FIO_NET_CMD_SENDFILE		= 21,
+	FIO_NET_CMD_NR			= 22,
 
 	FIO_NET_CMD_F_MORE		= 1UL << 0,
 
@@ -77,6 +79,25 @@ enum {
 	FIO_PROBE_FLAG_ZLIB		= 1UL << 0,
 };
 
+struct cmd_sendfile {
+	uint8_t path[FIO_NET_NAME_MAX];
+};
+
+struct cmd_sendfile_reply {
+	uint32_t size;
+	uint32_t error;
+	uint8_t data[0];
+};
+
+/*
+ * Client sends this to server on VTRIGGER, server sends back a full
+ * all_io_list structure.
+ */
+struct cmd_vtrigger_pdu {
+	uint16_t len;
+	uint8_t cmd[];
+};
+
 struct cmd_load_file_pdu {
 	uint16_t name_len;
 	uint16_t client_type;
@@ -95,6 +116,7 @@ struct cmd_du_pdu {
 
 struct cmd_client_probe_pdu {
 	uint64_t flags;
+	uint8_t server[128];
 };
 
 struct cmd_probe_reply_pdu {
@@ -175,6 +197,7 @@ extern void fio_server_send_ts(struct thread_stat *, struct group_run_stats *);
 extern void fio_server_send_gs(struct group_run_stats *);
 extern void fio_server_send_du(void);
 extern void fio_server_idle_loop(void);
+extern int fio_server_get_verify_state(const char *, int, void **);
 
 extern int fio_recv_data(int sk, void *p, unsigned int len);
 extern int fio_send_data(int sk, const void *p, unsigned int len);
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index bf67ed0..04d4a28 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -365,8 +365,6 @@ static int handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 	if (act == __BLK_TA_QUEUE) {
 		inflight_add(p, t->sector, t->bytes);
 		ret = handle_queue_trace(t, p);
-	} else if (act == __BLK_TA_REQUEUE) {
-		p->o.inflight--;
 	} else if (act == __BLK_TA_BACKMERGE) {
 		struct inflight *i;
 
@@ -549,8 +547,12 @@ static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
 	if (!usec)
 		return 0;
 
+	usec /= 1000;
+	if (!usec)
+		return 0;
+
 	val = o->kb[rw] * 1000ULL;
-	return val / (usec / 1000ULL);
+	return val / usec;
 }
 
 static uint64_t o_first_ttime(struct btrace_out *o)
diff --git a/thread_options.h b/thread_options.h
index 74c3e99..f311e2c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -99,6 +99,8 @@ struct thread_options {
 	unsigned long long verify_backlog;
 	unsigned int verify_batch;
 	unsigned int experimental_verify;
+	unsigned int verify_state;
+	unsigned int verify_state_save;
 	unsigned int use_thread;
 	unsigned int unlink;
 	unsigned int do_disk_util;
@@ -330,6 +332,9 @@ struct thread_options_pack {
 	uint64_t verify_backlog;
 	uint32_t verify_batch;
 	uint32_t experimental_verify;
+	uint32_t verify_state;
+	uint32_t verify_state_save;
+	uint32_t pad;
 	uint32_t use_thread;
 	uint32_t unlink;
 	uint32_t do_disk_util;
@@ -349,7 +354,6 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
-	uint32_t pad;
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 
diff --git a/verify.c b/verify.c
index f5c009c..f05e85d 100644
--- a/verify.c
+++ b/verify.c
@@ -1286,3 +1286,291 @@ void verify_async_exit(struct thread_data *td)
 	free(td->verify_threads);
 	td->verify_threads = NULL;
 }
+
+struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
+{
+	struct all_io_list *rep;
+	struct thread_data *td;
+	size_t depth;
+	void *next;
+	int i, nr;
+
+	compiletime_assert(sizeof(struct all_io_list) == 8, "all_io_list");
+
+	/*
+	 * Calculate reply space needed. We need one 'io_state' per thread,
+	 * and the size will vary depending on depth.
+	 */
+	depth = 0;
+	nr = 0;
+	for_each_td(td, i) {
+		if (save_mask != IO_LIST_ALL && (i + 1) != save_mask)
+			continue;
+		td->stop_io = 1;
+		td->flags |= TD_F_VSTATE_SAVED;
+		depth += td->o.iodepth;
+		nr++;
+	}
+
+	if (!nr)
+		return NULL;
+
+	*sz = sizeof(*rep);
+	*sz += nr * sizeof(struct thread_io_list);
+	*sz += depth * sizeof(uint64_t);
+	rep = malloc(*sz);
+
+	rep->threads = cpu_to_le64((uint64_t) nr);
+
+	next = &rep->state[0];
+	for_each_td(td, i) {
+		struct thread_io_list *s = next;
+		unsigned int comps;
+
+		if (save_mask != IO_LIST_ALL && (i + 1) != save_mask)
+			continue;
+
+		if (td->last_write_comp) {
+			int j, k;
+
+			if (td->io_blocks[DDIR_WRITE] < td->o.iodepth)
+				comps = td->io_blocks[DDIR_WRITE];
+			else
+				comps = td->o.iodepth;
+
+			k = td->last_write_idx - 1;
+			for (j = 0; j < comps; j++) {
+				if (k == -1)
+					k = td->o.iodepth - 1;
+				s->offsets[j] = cpu_to_le64(td->last_write_comp[k]);
+				k--;
+			}
+		} else
+			comps = 0;
+
+		s->no_comps = cpu_to_le64((uint64_t) comps);
+		s->depth = cpu_to_le64((uint64_t) td->o.iodepth);
+		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
+		s->index = cpu_to_le64((uint64_t) i);
+		s->rand.s[0] = cpu_to_le32(td->random_state.s1);
+		s->rand.s[1] = cpu_to_le32(td->random_state.s2);
+		s->rand.s[2] = cpu_to_le32(td->random_state.s3);
+		s->rand.s[3] = 0;
+		strncpy((char *) s->name, td->o.name, sizeof(s->name));
+		next = io_list_next(s);
+	}
+
+	return rep;
+}
+
+static int open_state_file(const char *name, const char *prefix, int num,
+			   int for_write)
+{
+	char out[64];
+	int flags;
+	int fd;
+
+	if (for_write)
+		flags = O_CREAT | O_TRUNC | O_WRONLY | O_SYNC;
+	else
+		flags = O_RDONLY;
+
+	verify_state_gen_name(out, sizeof(out), name, prefix, num);
+
+	fd = open(out, flags, 0644);
+	if (fd == -1) {
+		perror("fio: open state file");
+		return -1;
+	}
+
+	return fd;
+}
+
+static int write_thread_list_state(struct thread_io_list *s,
+				   const char *prefix)
+{
+	struct verify_state_hdr hdr;
+	uint64_t crc;
+	ssize_t ret;
+	int fd;
+
+	fd = open_state_file((const char *) s->name, prefix, s->index, 1);
+	if (fd == -1)
+		return 1;
+
+	crc = fio_crc32c((void *)s, thread_io_list_sz(s));
+
+	hdr.version = cpu_to_le64((uint64_t) VSTATE_HDR_VERSION);
+	hdr.size = cpu_to_le64((uint64_t) thread_io_list_sz(s));
+	hdr.crc = cpu_to_le64(crc);
+	ret = write(fd, &hdr, sizeof(hdr));
+	if (ret != sizeof(hdr))
+		goto write_fail;
+
+	ret = write(fd, s, thread_io_list_sz(s));
+	if (ret != thread_io_list_sz(s)) {
+write_fail:
+		if (ret < 0)
+			perror("fio: write state file");
+		log_err("fio: failed to write state file\n");
+		ret = 1;
+	} else
+		ret = 0;
+
+	close(fd);
+	return ret;
+}
+
+void __verify_save_state(struct all_io_list *state, const char *prefix)
+{
+	struct thread_io_list *s = &state->state[0];
+	unsigned int i;
+
+	for (i = 0; i < le64_to_cpu(state->threads); i++) {
+		write_thread_list_state(s,  prefix);
+		s = io_list_next(s);
+	}
+}
+
+void verify_save_state(void)
+{
+	struct all_io_list *state;
+	size_t sz;
+
+	state = get_all_io_list(IO_LIST_ALL, &sz);
+	if (state) {
+		__verify_save_state(state, "local");
+		free(state);
+	}
+}
+
+void verify_free_state(struct thread_data *td)
+{
+	if (td->vstate)
+		free(td->vstate);
+}
+
+void verify_convert_assign_state(struct thread_data *td,
+				 struct thread_io_list *s)
+{
+	int i;
+
+	s->no_comps = le64_to_cpu(s->no_comps);
+	s->depth = le64_to_cpu(s->depth);
+	s->numberio = le64_to_cpu(s->numberio);
+	for (i = 0; i < 4; i++)
+		s->rand.s[i] = le32_to_cpu(s->rand.s[i]);
+	for (i = 0; i < s->no_comps; i++)
+		s->offsets[i] = le64_to_cpu(s->offsets[i]);
+
+	td->vstate = s;
+}
+
+int verify_state_hdr(struct verify_state_hdr *hdr, struct thread_io_list *s)
+{
+	uint64_t crc;
+
+	hdr->version = le64_to_cpu(hdr->version);
+	hdr->size = le64_to_cpu(hdr->size);
+	hdr->crc = le64_to_cpu(hdr->crc);
+
+	if (hdr->version != VSTATE_HDR_VERSION)
+		return 1;
+
+	crc = fio_crc32c((void *)s, hdr->size);
+	if (crc != hdr->crc)
+		return 1;
+
+	return 0;
+}
+
+int verify_load_state(struct thread_data *td, const char *prefix)
+{
+	struct thread_io_list *s = NULL;
+	struct verify_state_hdr hdr;
+	uint64_t crc;
+	ssize_t ret;
+	int fd;
+
+	if (!td->o.verify_state)
+		return 0;
+
+	fd = open_state_file(td->o.name, prefix, td->thread_number - 1, 0);
+	if (fd == -1)
+		return 1;
+
+	ret = read(fd, &hdr, sizeof(hdr));
+	if (ret != sizeof(hdr)) {
+		if (ret < 0)
+			td_verror(td, errno, "read verify state hdr");
+		log_err("fio: failed reading verify state header\n");
+		goto err;
+	}
+
+	hdr.version = le64_to_cpu(hdr.version);
+	hdr.size = le64_to_cpu(hdr.size);
+	hdr.crc = le64_to_cpu(hdr.crc);
+
+	if (hdr.version != VSTATE_HDR_VERSION) {
+		log_err("fio: bad version in verify state header\n");
+		goto err;
+	}
+
+	s = malloc(hdr.size);
+	ret = read(fd, s, hdr.size);
+	if (ret != hdr.size) {
+		if (ret < 0)
+			td_verror(td, errno, "read verify state");
+		log_err("fio: failed reading verity state\n");
+		goto err;
+	}
+
+	crc = fio_crc32c((void *)s, hdr.size);
+	if (crc != hdr.crc) {
+		log_err("fio: verify state is corrupt\n");
+		goto err;
+	}
+
+	close(fd);
+
+	verify_convert_assign_state(td, s);
+	return 0;
+err:
+	if (s)
+		free(s);
+	close(fd);
+	return 1;
+}
+
+/*
+ * Use the loaded verify state to know when to stop doing verification
+ */
+int verify_state_should_stop(struct thread_data *td, struct io_u *io_u)
+{
+	struct thread_io_list *s = td->vstate;
+	int i;
+
+	if (!s)
+		return 0;
+
+	/*
+	 * If we're not into the window of issues - depth yet, continue
+	 */
+	if (td->io_blocks[DDIR_READ] < s->depth ||
+	    s->numberio - td->io_blocks[DDIR_READ] > s->depth)
+		return 0;
+
+	/*
+	 * We're in the window of having to check if this io was
+	 * completed or not. If the IO was seen as completed, then
+	 * lets verify it.
+	 */
+	for (i = 0; i < s->no_comps; i++)
+		if (io_u->offset == s->offsets[i])
+			return 0;
+
+	/*
+	 * Not found, we have to stop
+	 */
+	return 1;
+}
diff --git a/verify.h b/verify.h
index bb3fd49..43de887 100644
--- a/verify.h
+++ b/verify.h
@@ -88,4 +88,62 @@ extern void fio_verify_init(struct thread_data *td);
 extern int verify_async_init(struct thread_data *);
 extern void verify_async_exit(struct thread_data *);
 
+struct thread_rand_state {
+	uint32_t s[4];
+};
+
+/*
+ * For dumping current write state
+ */
+struct thread_io_list {
+	uint64_t no_comps;
+	uint64_t depth;
+	uint64_t numberio;
+	uint64_t index;
+	struct thread_rand_state rand;
+	uint8_t name[64];
+	uint64_t offsets[0];
+};
+
+struct all_io_list {
+	uint64_t threads;
+	struct thread_io_list state[0];
+};
+
+#define VSTATE_HDR_VERSION	0x01
+
+struct verify_state_hdr {
+	uint64_t version;
+	uint64_t size;
+	uint64_t crc;
+};
+
+#define IO_LIST_ALL		0xffffffff
+extern struct all_io_list *get_all_io_list(int, size_t *);
+extern void __verify_save_state(struct all_io_list *, const char *);
+extern void verify_save_state(void);
+extern int verify_load_state(struct thread_data *, const char *);
+extern void verify_free_state(struct thread_data *);
+extern int verify_state_should_stop(struct thread_data *, struct io_u *);
+extern void verify_convert_assign_state(struct thread_data *, struct thread_io_list *);
+extern int verify_state_hdr(struct verify_state_hdr *, struct thread_io_list *);
+
+static inline size_t thread_io_list_sz(struct thread_io_list *s)
+{
+	return sizeof(*s) + le64_to_cpu(s->depth) * sizeof(uint64_t);
+}
+
+static inline struct thread_io_list *io_list_next(struct thread_io_list *s)
+{
+	return (void *) s + thread_io_list_sz(s);
+}
+
+static inline void verify_state_gen_name(char *out, size_t size,
+					 const char *name, const char *prefix,
+					 int num)
+{
+	snprintf(out, size, "%s-%s-%d-verify.state", prefix, name, num);
+	out[size - 1] = '\0';
+}
+
 #endif
