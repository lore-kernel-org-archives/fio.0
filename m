Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: Vincent Fu <vincentfu@gmail.com>
Subject: [PATCH 4/6] stat: reset_io_stats: fix a problem, rearrange some code
Date: Sun, 16 Apr 2017 15:04:26 -0400
Message-Id: <1492369468-29448-4-git-send-email-vincentfu@gmail.com>
In-Reply-To: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
References: <1492369468-29448-1-git-send-email-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@sandisk.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <Vincent.Fu@sandisk.com>

1) Make sure all the io_u_lat_u/m are reset
2) Only need to zero out total_submit/complete once
3) Reset total/short/drop_io_u inside the other loop that iterates over data directions
---
 stat.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/stat.c b/stat.c
index 4a6e1b9..5061bea 100644
--- a/stat.c
+++ b/stat.c
@@ -2171,6 +2171,9 @@ void reset_io_stats(struct thread_data *td)
 
 		ts->io_bytes[i] = 0;
 		ts->runtime[i] = 0;
+		ts->total_io_u[i] = 0;
+		ts->short_io_u[i] = 0;
+		ts->drop_io_u[i] = 0;
 
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
 			ts->io_u_plat[i][j] = 0;
@@ -2180,17 +2183,15 @@ void reset_io_stats(struct thread_data *td)
 		ts->io_u_map[i] = 0;
 		ts->io_u_submit[i] = 0;
 		ts->io_u_complete[i] = 0;
+	}
+
+	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
 		ts->io_u_lat_u[i] = 0;
+	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
 		ts->io_u_lat_m[i] = 0;
-		ts->total_submit = 0;
-		ts->total_complete = 0;
-	}
 
-	for (i = 0; i < 3; i++) {
-		ts->total_io_u[i] = 0;
-		ts->short_io_u[i] = 0;
-		ts->drop_io_u[i] = 0;
-	}
+	ts->total_submit = 0;
+	ts->total_complete = 0;
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
-- 
2.7.4


