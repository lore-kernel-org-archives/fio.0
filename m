Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:54046 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbbAFNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Jan 2015 08:00:06 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Y8Tjx-0007RF-6c
	for fio@vger.kernel.org; Tue, 06 Jan 2015 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150106130003.95D6140183@lyth.info>
Date: Tue,  6 Jan 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 17a2be5945b12959ad3066b7d75432577d29ae82:

  Avoid potential buffer overflow in make_filename() (2015-01-04 13:33:37 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c7b0978381243f25a06464cdbf57bb55a1dbaa33:

  server: use fio_gettime() for timeout variables (2015-01-05 13:51:22 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      init: fix potential mem leak on multiple trigger options
      client: fix potential buffer overrun in server name copy
      gluster: io_u->error should be a positive error value
      memory: double check that mmapfd isn't -1 before closing
      verify: fix potentially unterminated name
      server: use fio_gettime() for timeout variables

 client.c                  |    5 ++++-
 engines/glusterfs_async.c |    2 +-
 init.c                    |    6 ++++++
 memory.c                  |    2 +-
 server.c                  |    2 +-
 verify.c                  |    3 ++-
 6 files changed, 15 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 3cb7c1c..74c9c76 100644
--- a/client.c
+++ b/client.c
@@ -380,6 +380,7 @@ static const char *server_name(struct fio_client *client, char *buf,
 static void probe_client(struct fio_client *client)
 {
 	struct cmd_client_probe_pdu pdu;
+	const char *sname;
 	uint64_t tag;
 	char buf[64];
 
@@ -391,7 +392,9 @@ static void probe_client(struct fio_client *client)
 	pdu.flags = 0;
 #endif
 
-	strcpy((char *) pdu.server, server_name(client, buf, sizeof(buf)));
+	sname = server_name(client, buf, sizeof(buf));
+	memset(pdu.server, 0, sizeof(pdu.server));
+	strncpy((char *) pdu.server, sname, sizeof(pdu.server) - 1);
 
 	fio_net_send_cmd(client->fd, FIO_NET_CMD_PROBE, &pdu, sizeof(pdu), &tag, &client->cmd_list);
 }
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 8283f8b..7c2c139 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -122,7 +122,7 @@ static int fio_gf_async_queue(struct thread_data fio_unused * td,
 	else if (io_u->ddir == DDIR_SYNC)
 		r = glfs_fsync_async(g->fd, gf_async_cb, io_u);
 	else
-		r = -EINVAL;
+		r = EINVAL;
 
 	if (r) {
 		log_err("glfs queue failed.\n");
diff --git a/init.c b/init.c
index a0d4f8c..bb53a1e 100644
--- a/init.c
+++ b/init.c
@@ -2276,12 +2276,18 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			break;
 			}
 		case 'W':
+			if (trigger_file)
+				free(trigger_file);
 			trigger_file = strdup(optarg);
 			break;
 		case 'H':
+			if (trigger_cmd)
+				free(trigger_cmd);
 			trigger_cmd = strdup(optarg);
 			break;
 		case 'J':
+			if (trigger_remote_cmd)
+				free(trigger_remote_cmd);
 			trigger_remote_cmd = strdup(optarg);
 			break;
 		case 'B':
diff --git a/memory.c b/memory.c
index 76da8a8..f81c2dd 100644
--- a/memory.c
+++ b/memory.c
@@ -158,7 +158,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 	if (td->orig_buffer == MAP_FAILED) {
 		td_verror(td, errno, "mmap");
 		td->orig_buffer = NULL;
-		if (td->mmapfd != 1) {
+		if (td->mmapfd != 1 && td->mmapfd != -1) {
 			close(td->mmapfd);
 			if (td->o.mmapfile)
 				unlink(td->o.mmapfile);
diff --git a/server.c b/server.c
index 3171979..c249849 100644
--- a/server.c
+++ b/server.c
@@ -333,7 +333,7 @@ static uint64_t alloc_reply(uint64_t tag, uint16_t opcode)
 
 	reply = calloc(1, sizeof(*reply));
 	INIT_FLIST_HEAD(&reply->list);
-	gettimeofday(&reply->tv, NULL);
+	fio_gettime(&reply->tv, NULL);
 	reply->saved_tag = tag;
 	reply->opcode = opcode;
 
diff --git a/verify.c b/verify.c
index 2ae03f8..205f01a 100644
--- a/verify.c
+++ b/verify.c
@@ -1341,7 +1341,8 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		s->rand.s[1] = cpu_to_le32(td->random_state.s2);
 		s->rand.s[2] = cpu_to_le32(td->random_state.s3);
 		s->rand.s[3] = 0;
-		strncpy((char *) s->name, td->o.name, sizeof(s->name));
+		s->name[sizeof(s->name) - 1] = '\0';
+		strncpy((char *) s->name, td->o.name, sizeof(s->name) - 1);
 		next = io_list_next(s);
 	}
 
