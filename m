Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51220 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfCZMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Mar 2019 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h8kkY-00053T-ST
        for fio@vger.kernel.org; Tue, 26 Mar 2019 12:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190326120002.166C12C0124@kernel.dk>
Date: Tue, 26 Mar 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c5daece64fd56763f264a59965a547433d4da799:

  stat: fix accumulation of latency buckets (2019-03-21 10:53:39 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bf14b39eb98873ebd61e78d37b51233d47ed8aef:

  stat: eliminate unneeded curly braces (2019-03-25 08:23:13 -0600)

----------------------------------------------------------------
Vincent Fu (2):
      client: put All clients section at end of normal output
      stat: eliminate unneeded curly braces

 client.c |  6 +++++-
 stat.c   | 11 +++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 8d7c0331..4cbffb62 100644
--- a/client.c
+++ b/client.c
@@ -59,6 +59,7 @@ struct group_run_stats client_gs;
 int sum_stat_clients;
 
 static int sum_stat_nr;
+static struct buf_output allclients;
 static struct json_object *root = NULL;
 static struct json_object *job_opt_object = NULL;
 static struct json_array *clients_array = NULL;
@@ -1103,7 +1104,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (++sum_stat_nr == sum_stat_clients) {
 		strcpy(client_ts.name, "All clients");
-		tsobj = show_thread_status(&client_ts, &client_gs, NULL, &client->buf);
+		tsobj = show_thread_status(&client_ts, &client_gs, NULL, &allclients);
 		if (tsobj) {
 			json_object_add_client_info(tsobj, client);
 			json_array_add_value_object(clients_array, tsobj);
@@ -2129,6 +2130,9 @@ int fio_handle_clients(struct client_ops *ops)
 		}
 	}
 
+	log_info_buf(allclients.buf, allclients.buflen);
+	buf_output_free(&allclients);
+
 	fio_client_json_fini();
 
 	free(pfds);
diff --git a/stat.c b/stat.c
index ecef1099..2bc21dad 100644
--- a/stat.c
+++ b/stat.c
@@ -1682,15 +1682,14 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		dst->io_u_submit[k] += src->io_u_submit[k];
 		dst->io_u_complete[k] += src->io_u_complete[k];
 	}
-	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++) {
+
+	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++)
 		dst->io_u_lat_n[k] += src->io_u_lat_n[k];
-	}
-	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++) {
+	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++)
 		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
-	}
-	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++) {
+	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++)
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
-	}
+
 	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
 		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
 

