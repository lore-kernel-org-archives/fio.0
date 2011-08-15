Return-Path: <egouriou@google.com>
From: Eric Gouriou <egouriou@google.com>
Subject: [PATCH] stats: fix io_u_plat out-of-bound accesses (round 2)
Date: Mon, 15 Aug 2011 16:23:10 -0700
Message-Id: <1313450590-22069-1-git-send-email-egouriou@google.com>
To: Jens Axboe <axboe@kernel.dk>, Zhu Yanhai <zhu.yanhai@gmail.com>
Cc: Yu-Ju Hong <yuju.hong@gmail.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>
List-ID: <fio@vger.kernel.org>

Commit 833491908a1afd67 introduced the ability to report completion
latency percentiles. It also caused a memory corruption when running
with multiple threads due to out of bound accesses in show_run_stats().
The major index of the io_u_plat two-dimensional array is meant
to be DDIR_ value in {DDIR_READ, DDIR_WRITE} (i.e., {0, 1}). The
code in show_run_stats() incorrectly wrote into the array using
a major index with values {0, 1, 2}. Commit 0a0b49007cbce8d1 fixed
the out of bound accesses by increasing the size of the major
dimension of the io_u_plat array from 2 to 3.

This patch reverts the size change from 0a0b49007cbce8d1 in favor
of avoiding the out-of-bound accesses in show_run_stats().

Signed-off-by: Eric Gouriou <egouriou@google.com>
---
Jens, Zhu,

Yu-Ju is unlikely to be checking fio email traffic this week,
hence my follow-up. The error was introduced while porting
the patch between different versions of fio. The internal version
was tested appropriately but not the upstream version.

Apologies for the trouble.

Regards - Eric

---
 fio.h  |    2 +-
 stat.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fio.h b/fio.h
index c741162..6c57496 100644
--- a/fio.h
+++ b/fio.h
@@ -217,7 +217,7 @@ struct thread_stat {
 	unsigned int io_u_complete[FIO_IO_U_MAP_NR];
 	unsigned int io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	unsigned int io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	unsigned int io_u_plat[3][FIO_IO_U_PLAT_NR];
+	unsigned int io_u_plat[2][FIO_IO_U_PLAT_NR];
 	unsigned long total_io_u[3];
 	unsigned long short_io_u[3];
 	unsigned long total_submit;
diff --git a/stat.c b/stat.c
index ee6ee51..ae3c71a 100644
--- a/stat.c
+++ b/stat.c
@@ -773,11 +773,12 @@ void show_run_stats(void)
 
 
 		for (k = 0; k <= 2; k++) {
-			int m;
-
 			ts->total_io_u[k] += td->ts.total_io_u[k];
 			ts->short_io_u[k] += td->ts.short_io_u[k];
+		}
 
+		for (k = 0; k <= DDIR_WRITE; k++) {
+			int m;
 			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
 				ts->io_u_plat[k][m] += td->ts.io_u_plat[k][m];
 		}
-- 
1.7.3.1


