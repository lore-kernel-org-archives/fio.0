Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50150 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbcA2NAI (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 29 Jan 2016 08:00:08 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aP8eh-0002Nz-7U
	for fio@vger.kernel.org; Fri, 29 Jan 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160129130002.2BB1B2C0162@kernel.dk>
Date: Fri, 29 Jan 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a8381d78ec52d00541ddd7ef8bd7584e99361b0e:

  Fio 2.6 (2016-01-26 19:02:07 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a89c77abb152277ca3731f4766a7f377f0fc99df:

  server: send trigger state inline (2016-01-28 13:41:18 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      client: fix double removal of client on job file open failure
      server: send trigger state inline

 client.c | 5 ++++-
 server.c | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 515cbf2..6bc1145 100644
--- a/client.c
+++ b/client.c
@@ -816,6 +816,8 @@ int fio_clients_send_ini(const char *filename)
 	struct flist_head *entry, *tmp;
 
 	flist_for_each_safe(entry, tmp, &client_list) {
+		bool failed = false;
+
 		client = flist_entry(entry, struct fio_client, list);
 
 		if (client->nr_files) {
@@ -827,12 +829,13 @@ int fio_clients_send_ini(const char *filename)
 				cf = &client->files[i];
 
 				if (fio_client_send_cf(client, cf)) {
+					failed = true;
 					remove_client(client);
 					break;
 				}
 			}
 		}
-		if (client->sent_job)
+		if (client->sent_job || failed)
 			continue;
 		if (!filename || fio_client_send_ini(client, filename, 0))
 			remove_client(client);
diff --git a/server.c b/server.c
index 750717a..c3e034c 100644
--- a/server.c
+++ b/server.c
@@ -971,9 +971,9 @@ static int handle_trigger_cmd(struct fio_net_cmd *cmd)
 		struct all_io_list state;
 
 		state.threads = cpu_to_le64((uint64_t) 0);
-		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, &state, sizeof(state), NULL, SK_F_COPY);
+		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, &state, sizeof(state), NULL, SK_F_COPY | SK_F_INLINE);
 	} else
-		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE);
+		fio_net_queue_cmd(FIO_NET_CMD_VTRIGGER, rep, sz, NULL, SK_F_FREE | SK_F_INLINE);
 
 	exec_trigger(buf);
 	return 0;
