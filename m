Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48358 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761828AbcINMAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Sep 2016 08:00:05 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bk8rE-00065I-0i
        for fio@vger.kernel.org; Wed, 14 Sep 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160914120002.2752E2C18F3@kernel.dk>
Date: Wed, 14 Sep 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 247e54360a9dff433e815f91b500073fe3c1a820:

  Makefile: fixup java path for libhdfs (2016-09-12 08:10:45 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 308d69b5d340577b7886696f39753b7ba5ae9e11:

  client: ignore SEND_ETA, if we can't fin a reply command (2016-09-13 09:08:00 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      client: ignore SEND_ETA, if we can't fin a reply command

 client.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 3456665..c8069a0 100644
--- a/client.c
+++ b/client.c
@@ -1183,7 +1183,7 @@ void fio_client_sum_jobs_eta(struct jobs_eta *dst, struct jobs_eta *je)
 	strcpy((char *) dst->run_str, (char *) je->run_str);
 }
 
-static void remove_reply_cmd(struct fio_client *client, struct fio_net_cmd *cmd)
+static bool remove_reply_cmd(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct fio_net_cmd_reply *reply = NULL;
 	struct flist_head *entry;
@@ -1199,12 +1199,13 @@ static void remove_reply_cmd(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (!reply) {
 		log_err("fio: client: unable to find matching tag (%llx)\n", (unsigned long long) cmd->tag);
-		return;
+		return false;
 	}
 
 	flist_del(&reply->list);
 	cmd->tag = reply->saved_tag;
 	free(reply);
+	return true;
 }
 
 int fio_client_wait_for_reply(struct fio_client *client, uint64_t tag)
@@ -1653,7 +1654,8 @@ int fio_handle_client(struct fio_client *client)
 	case FIO_NET_CMD_ETA: {
 		struct jobs_eta *je = (struct jobs_eta *) cmd->payload;
 
-		remove_reply_cmd(client, cmd);
+		if (!remove_reply_cmd(client, cmd))
+			break;
 		convert_jobs_eta(je);
 		handle_eta(client, cmd);
 		break;
