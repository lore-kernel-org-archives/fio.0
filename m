Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH] stat: fix accumulation of latency buckets
Date: Thu, 21 Mar 2019 12:45:13 -0400
Message-Id: <20190321164513.6475-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

The numbers of buckets for nsec, usec, and msec latencies may differ
from each other. So we need to iterate separately over the three types
of buckets.
---
 stat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/stat.c b/stat.c
index 66a13bca..ecef1099 100644
--- a/stat.c
+++ b/stat.c
@@ -1684,7 +1684,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	}
 	for (k = 0; k < FIO_IO_U_LAT_N_NR; k++) {
 		dst->io_u_lat_n[k] += src->io_u_lat_n[k];
+	}
+	for (k = 0; k < FIO_IO_U_LAT_U_NR; k++) {
 		dst->io_u_lat_u[k] += src->io_u_lat_u[k];
+	}
+	for (k = 0; k < FIO_IO_U_LAT_M_NR; k++) {
 		dst->io_u_lat_m[k] += src->io_u_lat_m[k];
 	}
 	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
-- 
2.17.1


