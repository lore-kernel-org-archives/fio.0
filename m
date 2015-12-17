Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36130 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbbLQNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a9YAF-0000WY-AD
	for fio@vger.kernel.org; Thu, 17 Dec 2015 13:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151217130002.611062C01DE@kernel.dk>
Date: Thu, 17 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit bc0fec0e12f19dd424f4bf83cfca89d434184c8d:

  client/server: ensure we don't overrun memory for long option values (2015-12-15 21:02:51 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to dde7b2361bf5b052a9c5c727bb2b062c604c7d42:

  gclient: don't free pdu on iolog return (2015-12-16 15:05:54 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      parse: fix segfault if posval option doesn't have a value
      verify: dump failed header, if verification fails
      client: fix double free of command on timeout
      gclient: don't free pdu on iolog return

 client.c  | 7 +++----
 gclient.c | 1 -
 parse.c   | 2 ++
 verify.c  | 5 +++++
 4 files changed, 10 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 637cd3f..f4b95d3 100644
--- a/client.c
+++ b/client.c
@@ -1666,12 +1666,13 @@ static void request_client_etas(struct client_ops *ops)
 static int handle_cmd_timeout(struct fio_client *client,
 			      struct fio_net_cmd_reply *reply)
 {
+	flist_del(&reply->list);
+	free(reply);
+
 	if (reply->opcode != FIO_NET_CMD_SEND_ETA)
 		return 1;
 
 	log_info("client <%s>: timeout on SEND_ETA\n", client->hostname);
-	flist_del(&reply->list);
-	free(reply);
 
 	flist_del_init(&client->eta_list);
 	if (client->eta_in_flight) {
@@ -1706,8 +1707,6 @@ static int client_check_cmd_timeout(struct fio_client *client,
 
 		log_err("fio: client %s, timeout on cmd %s\n", client->hostname,
 						fio_server_op(reply->opcode));
-		flist_del(&reply->list);
-		free(reply);
 		ret = 1;
 	}
 
diff --git a/gclient.c b/gclient.c
index 17af38a..949ad42 100644
--- a/gclient.c
+++ b/gclient.c
@@ -696,7 +696,6 @@ static void gfio_client_job_start(struct fio_client *client, struct fio_net_cmd
 static void gfio_client_iolog(struct fio_client *client, struct cmd_iolog_pdu *pdu)
 {
 	printf("got iolog: name=%s, type=%u, entries=%lu\n", pdu->name, pdu->log_type, (unsigned long) pdu->nr_samples);
-	free(pdu);
 }
 
 static void gfio_add_total_depths_tree(GtkListStore *model,
diff --git a/parse.c b/parse.c
index df42e22..0ef00b8 100644
--- a/parse.c
+++ b/parse.c
@@ -483,6 +483,8 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 			if (!vp->ival || vp->ival[0] == '\0')
 				continue;
 			all_skipped = 0;
+			if (!ptr)
+				break;
 			if (!strncmp(vp->ival, ptr, str_match_len(vp, ptr))) {
 				ret = 0;
 				if (o->off1)
diff --git a/verify.c b/verify.c
index 268c060..5d491d7 100644
--- a/verify.c
+++ b/verify.c
@@ -780,6 +780,11 @@ err:
 	log_err(" at file %s offset %llu, length %u\n",
 		io_u->file->file_name,
 		io_u->offset + hdr_num * hdr_len, hdr_len);
+
+	if (td->o.verify_dump)
+		dump_buf(p, hdr_len, io_u->offset + hdr_num * hdr_len,
+				"hdr_fail", io_u->file);
+
 	return EILSEQ;
 }
 
