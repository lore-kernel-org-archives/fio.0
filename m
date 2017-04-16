Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 5/6] client/server: make sure that all elements in io_u_lat_m[] are transferred and received
Date: Sun, 16 Apr 2017 15:04:27 -0400
Message-Id: <1492369468-29448-5-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

FIO_IO_U_LAT_U_NR is 10 whereas FIO_IO_U_LAT_M_NR is 12. So we must iterate
over io_u_lat_u and io_u_lat_m separately.
---
 client.c | 4 ++--
 server.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/client.c b/client.c
index 7934661..80096bf 100644
--- a/client.c
+++ b/client.c
@@ -908,10 +908,10 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		dst->io_u_complete[i]	= le32_to_cpu(src->io_u_complete[i]);
 	}
 
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		dst->io_u_lat_u[i]	= le32_to_cpu(src->io_u_lat_u[i]);
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		dst->io_u_lat_m[i]	= le32_to_cpu(src->io_u_lat_m[i]);
-	}
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
diff --git a/server.c b/server.c
index 1b3bc30..1e269c2 100644
--- a/server.c
+++ b/server.c
@@ -1497,10 +1497,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 		p.ts.io_u_complete[i]	= cpu_to_le32(ts->io_u_complete[i]);
 	}
 
-	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++) {
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		p.ts.io_u_lat_u[i]	= cpu_to_le32(ts->io_u_lat_u[i]);
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		p.ts.io_u_lat_m[i]	= cpu_to_le32(ts->io_u_lat_m[i]);
-	}
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
-- 
2.7.4


