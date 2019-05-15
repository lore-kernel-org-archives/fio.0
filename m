Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/5] client: do not print disk utilization for terse v2
Date: Wed, 15 May 2019 16:04:59 -0400
Message-Id: <20190515200503.23000-2-vincentfu@gmail.com>
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
References: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

terse version 2 omits disk utilization data when fio is run locally.
Make this behavior the same when fio is run in client/server mode.
---
 client.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/client.c b/client.c
index 4cbffb62..43156854 100644
--- a/client.c
+++ b/client.c
@@ -1219,7 +1219,7 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		json_array_add_disk_util(&du->dus, &du->agg, du_array);
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
-	} else if (output_format & FIO_OUTPUT_TERSE)
+	} else if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3)
 		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
 	else if (output_format & FIO_OUTPUT_NORMAL) {
 		__log_buf(&client->buf, "\nDisk stats (read/write):\n");
-- 
2.17.1


