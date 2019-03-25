Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] client: put All clients section at end of normal output
Date: Mon, 25 Mar 2019 10:20:27 -0400
Message-Id: <20190325142028.32550-2-vincentfu@gmail.com>
In-Reply-To: <20190325142028.32550-1-vincentfu@gmail.com>
References: <20190325142028.32550-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

When fio runs multiple jobs on servers, it is possible for the "All
clients" output to appear in the middle of output for the individual
jobs. This patch puts the "All clients" output into a separate buffer
and displays it after the output for all the individual jobs.
---
 client.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
-- 
2.17.1


