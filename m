Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbeHUW3x (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Aug 2018 18:29:53 -0400
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/2] client: respect terse output on client <--> backend relationship
Date: Tue, 21 Aug 2018 12:08:23 -0700
Message-Id: <20180821190824.29928-2-mcgrof@kernel.org>
In-Reply-To: <20180821190824.29928-1-mcgrof@kernel.org>
References: <20180821190824.29928-1-mcgrof@kernel.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: andrey.o.kudryavtsev@intel.com, Luis Chamberlain <mcgrof@kernel.org>

You end up with different results if you run this terse output
on a local system which also runs its own backend Vs running a
client to connect to a remote server which is running fio as a
backend only. The reason is the client ops handle printing of
threads / disk utils separately. The terse output created *by*
the backend is the right and expected output, so just use that,
and we can piggy back off of the fact that the server will send
its own output via FIO_NET_CMD_TEXT.

Another solution is to address getting the disk util data sent
to be cached locally, and then upon handle_ts() print that, but that
would require significant re-architecturing.

Terse output is supposed to be just that, terse. This implies
that it will not be clear from what backend data came from, but
for this the best strategy is to *extend* the terse version with
yet another field, the remote hostname/ip address.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 client.c | 16 +++++++++++++---
 stat.c   |  2 ++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/client.c b/client.c
index e2525c81..bc0275b6 100644
--- a/client.c
+++ b/client.c
@@ -1058,6 +1058,9 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct flist_head *opt_list = NULL;
 	struct json_object *tsobj;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (client->opt_lists && p->ts.thread_number <= client->jobs)
 		opt_list = &client->opt_lists[p->ts.thread_number - 1];
 
@@ -1094,6 +1097,9 @@ static void handle_gs(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct group_run_stats *gs = (struct group_run_stats *) cmd->payload;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (output_format & FIO_OUTPUT_NORMAL)
 		show_group_stats(gs, NULL);
 }
@@ -1140,7 +1146,7 @@ static void handle_text(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	name = client->name ? client->name : client->hostname;
 
-	if (!client->skip_newline)
+	if (!client->skip_newline && !(output_format & FIO_OUTPUT_TERSE))
 		fprintf(f_out, "<%s> ", name);
 	ret = fwrite(buf, pdu->buf_len, 1, f_out);
 	fflush(f_out);
@@ -1184,6 +1190,9 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 {
 	struct cmd_du_pdu *du = (struct cmd_du_pdu *) cmd->payload;
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	if (!client->disk_stats_shown) {
 		client->disk_stats_shown = true;
 		log_info("\nDisk stats (read/write):\n");
@@ -1195,8 +1204,6 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
 	}
-	if (output_format & FIO_OUTPUT_TERSE)
-		print_disk_util(&du->dus, &du->agg, 1, NULL);
 	if (output_format & FIO_OUTPUT_NORMAL)
 		print_disk_util(&du->dus, &du->agg, 0, NULL);
 }
@@ -1456,6 +1463,9 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	const char *os, *arch;
 	char bit[16];
 
+	if (output_format & FIO_OUTPUT_TERSE)
+		return;
+
 	os = fio_get_os_string(probe->os);
 	if (!os)
 		os = "unknown";
diff --git a/stat.c b/stat.c
index 82e79dfc..edf9ecf6 100644
--- a/stat.c
+++ b/stat.c
@@ -1922,6 +1922,8 @@ void __show_run_stats(void)
 		if (is_backend) {
 			fio_server_send_job_options(opt_lists[i], i);
 			fio_server_send_ts(ts, rs);
+			if (output_format & FIO_OUTPUT_TERSE)
+				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
 		} else {
 			if (output_format & FIO_OUTPUT_TERSE)
 				show_thread_status_terse(ts, rs, &output[__FIO_OUTPUT_TERSE]);
-- 
2.18.0


