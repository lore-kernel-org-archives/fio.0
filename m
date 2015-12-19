Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbLSNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 19 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aAH7L-0001mx-7t
	for fio@vger.kernel.org; Sat, 19 Dec 2015 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151219130002.3D4BB2C0EA8@kernel.dk>
Date: Sat, 19 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit dfc8e76c8d438da9861acfcdc96c46afe4339148:

  server: code cleanups (2015-12-17 15:23:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 70c6807675291c2c5ccb38cc9c81b45bcaed0ce1:

  backend: count iterative bytes for progress (2015-12-18 22:33:35 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      client: iolog cleanups
      server: don't store command tag on the stack
      server: command tag cleanup
      backend: count iterative bytes for progress

 backend.c |  7 ++++++-
 client.c  | 28 +++++++++++++++++++---------
 server.c  | 38 ++++++++++++++++----------------------
 3 files changed, 41 insertions(+), 32 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index c9875f4..89ac76b 100644
--- a/backend.c
+++ b/backend.c
@@ -813,6 +813,10 @@ static uint64_t do_io(struct thread_data *td)
 	unsigned int i;
 	int ret = 0;
 	uint64_t total_bytes, bytes_issued = 0;
+	uint64_t this_bytes[2];
+
+	this_bytes[0] = td->bytes_done[DDIR_WRITE];
+	this_bytes[1] = td->bytes_done[DDIR_TRIM];
 
 	if (in_ramp_time(td))
 		td_set_runstate(td, TD_RAMP);
@@ -1046,7 +1050,8 @@ reap:
 	if (!ddir_rw_sum(td->this_io_bytes))
 		td->done = 1;
 
-	return td->bytes_done[DDIR_WRITE] + td->bytes_done[DDIR_TRIM];
+	return (td->bytes_done[DDIR_WRITE] - this_bytes[0]) +
+		(td->bytes_done[DDIR_TRIM] - this_bytes[1]);
 }
 
 static void cleanup_io_u(struct thread_data *td)
diff --git a/client.c b/client.c
index 27a764d..df13254 100644
--- a/client.c
+++ b/client.c
@@ -1226,14 +1226,17 @@ static void handle_eta(struct fio_client *client, struct fio_net_cmd *cmd)
 	fio_client_dec_jobs_eta(eta, client->ops->eta);
 }
 
-void fio_client_handle_iolog(struct fio_client *client, struct fio_net_cmd *cmd)
+static int fio_client_handle_iolog(struct fio_client *client,
+				   struct fio_net_cmd *cmd)
 {
 	struct cmd_iolog_pdu *pdu;
 	bool store_direct;
 
 	pdu = convert_iolog(cmd, &store_direct);
-	if (!pdu)
-		return;
+	if (!pdu) {
+		log_err("fio: failed converting IO log\n");
+		return 1;
+	}
 
 	if (store_direct) {
 		ssize_t ret;
@@ -1243,26 +1246,33 @@ void fio_client_handle_iolog(struct fio_client *client, struct fio_net_cmd *cmd)
 		fd = open((const char *) pdu->name,
 				O_WRONLY | O_CREAT | O_TRUNC, 0644);
 		if (fd < 0) {
-			perror("open log");
-			return;
+			log_err("fio: open log: %s\n", strerror(errno));
+			return 1;
 		}
+
 		sz = cmd->pdu_len - sizeof(*pdu);
 		ret = write(fd, pdu->samples, sz);
-		if (ret != sz)
-			log_err("fio: short write on compressed log\n");
 		close(fd);
+
+		if (ret != sz) {
+			log_err("fio: short write on compressed log\n");
+			return 1;
+		}
+
+		return 0;
 	} else {
 		FILE *f;
 
 		f = fopen((const char *) pdu->name, "w");
 		if (!f) {
-			perror("fopen log");
-			return;
+			log_err("fio: fopen log: %s\n", strerror(errno));
+			return 1;
 		}
 
 		flush_samples(f, pdu->samples,
 				pdu->nr_samples * sizeof(struct io_sample));
 		fclose(f);
+		return 0;
 	}
 }
 
diff --git a/server.c b/server.c
index f53e2c8..a71562b 100644
--- a/server.c
+++ b/server.c
@@ -46,7 +46,7 @@ struct sk_entry {
 	int opcode;		/* Actual command fields */
 	void *buf;
 	off_t size;
-	uint64_t *tagptr;
+	uint64_t tag;
 	struct flist_head next;	/* Other sk_entry's, if linked command */
 };
 
@@ -536,7 +536,10 @@ static struct sk_entry *fio_net_prep_cmd(uint16_t opcode, void *buf,
 		entry->buf = buf;
 
 	entry->size = size;
-	entry->tagptr = tagptr;
+	if (tagptr)
+		entry->tag = *tagptr;
+	else
+		entry->tag = 0;
 	entry->flags = flags;
 	return entry;
 }
@@ -1069,29 +1072,24 @@ static void finish_entry(struct sk_entry *entry)
 	sfree(entry);
 }
 
-static void entry_set_flags_tag(struct sk_entry *entry, struct flist_head *list,
-				unsigned int *flags, uint64_t *tag)
+static void entry_set_flags(struct sk_entry *entry, struct flist_head *list,
+			    unsigned int *flags)
 {
 	if (!flist_empty(list))
 		*flags = FIO_NET_CMD_F_MORE;
 	else
 		*flags = 0;
-
-	if (entry->tagptr)
-		*tag = *entry->tagptr;
-	else
-		*tag = 0;
 }
 
 static int send_vec_entry(struct sk_out *sk_out, struct sk_entry *first)
 {
 	unsigned int flags;
-	uint64_t tag;
 	int ret;
 
-	entry_set_flags_tag(first, &first->next, &flags, &tag);
+	entry_set_flags(first, &first->next, &flags);
 
-	ret = fio_send_cmd_ext_pdu(sk_out->sk, first->opcode, first->buf, first->size, tag, flags);
+	ret = fio_send_cmd_ext_pdu(sk_out->sk, first->opcode, first->buf,
+					first->size, first->tag, flags);
 
 	while (!flist_empty(&first->next)) {
 		struct sk_entry *next;
@@ -1099,9 +1097,10 @@ static int send_vec_entry(struct sk_out *sk_out, struct sk_entry *first)
 		next = flist_first_entry(&first->next, struct sk_entry, list);
 		flist_del_init(&next->list);
 
-		entry_set_flags_tag(next, &first->next, &flags, &tag);
+		entry_set_flags(next, &first->next, &flags);
 
-		ret += fio_send_cmd_ext_pdu(sk_out->sk, next->opcode, next->buf, next->size, tag, flags);
+		ret += fio_send_cmd_ext_pdu(sk_out->sk, next->opcode, next->buf,
+						next->size, next->tag, flags);
 		finish_entry(next);
 	}
 
@@ -1117,16 +1116,11 @@ static int handle_sk_entry(struct sk_out *sk_out, struct sk_entry *entry)
 	if (entry->flags & SK_F_VEC)
 		ret = send_vec_entry(sk_out, entry);
 	else if (entry->flags & SK_F_SIMPLE) {
-		uint64_t tag = 0;
-
-		if (entry->tagptr)
-			tag = *entry->tagptr;
-
-		ret = fio_net_send_simple_cmd(sk_out->sk, entry->opcode, tag,
-						NULL);
+		ret = fio_net_send_simple_cmd(sk_out->sk, entry->opcode,
+						entry->tag, NULL);
 	} else {
 		ret = fio_net_send_cmd(sk_out->sk, entry->opcode, entry->buf,
-					entry->size, entry->tagptr, NULL);
+					entry->size, &entry->tag, NULL);
 	}
 
 	fio_mutex_up(&sk_out->xmit);
