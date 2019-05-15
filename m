Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/5] client: handle disk util for all output formats
Date: Wed, 15 May 2019 16:05:00 -0400
Message-Id: <20190515200503.23000-3-vincentfu@gmail.com>
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
References: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Since fio allows multiple output formats, it should process the disk
utilization data for each output format that was requested by the user
when it is run in client/server mode.
---
 client.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/client.c b/client.c
index 43156854..7fe571ef 100644
--- a/client.c
+++ b/client.c
@@ -1219,12 +1219,13 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		json_array_add_disk_util(&du->dus, &du->agg, du_array);
 		duobj = json_array_last_value_object(du_array);
 		json_object_add_client_info(duobj, client);
-	} else if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3)
-		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
-	else if (output_format & FIO_OUTPUT_NORMAL) {
+	}
+	if (output_format & FIO_OUTPUT_NORMAL) {
 		__log_buf(&client->buf, "\nDisk stats (read/write):\n");
 		print_disk_util(&du->dus, &du->agg, 0, &client->buf);
 	}
+	if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3)
+		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
-- 
2.17.1


