Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 3/5] client: add a newline after terse disk util
Date: Wed, 15 May 2019 16:05:01 -0400
Message-Id: <20190515200503.23000-4-vincentfu@gmail.com>
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
References: <20190515200503.23000-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

In client/server mode terse disk utilization output appears at the end
of each blob of terse output. We need a newline so that the next blob of
terse output starts at the beginning of a line.
---
 client.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/client.c b/client.c
index 7fe571ef..43cfbd43 100644
--- a/client.c
+++ b/client.c
@@ -1224,8 +1224,10 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 		__log_buf(&client->buf, "\nDisk stats (read/write):\n");
 		print_disk_util(&du->dus, &du->agg, 0, &client->buf);
 	}
-	if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3)
+	if (output_format & FIO_OUTPUT_TERSE && terse_version >= 3) {
 		print_disk_util(&du->dus, &du->agg, 1, &client->buf);
+		__log_buf(&client->buf, "\n");
+	}
 }
 
 static void convert_jobs_eta(struct jobs_eta *je)
-- 
2.17.1


