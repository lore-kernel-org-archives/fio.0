Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 2/2] stat: eliminate unneeded curly braces
Date: Mon, 25 Mar 2019 10:20:28 -0400
Message-Id: <20190325142028.32550-3-vincentfu@gmail.com>
In-Reply-To: <20190325142028.32550-1-vincentfu@gmail.com>
References: <20190325142028.32550-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

---
 stat.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

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
 
-- 
2.17.1


