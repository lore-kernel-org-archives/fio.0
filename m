Return-Path: <fio-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12387 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751490AbdJLF6i (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 Oct 2017 01:58:38 -0400
From: Andrzej Jakowski <andrzej.jakowski@intel.com>
Subject: [PATCH v2] Fix overflow in percentile calculation for Windows
Date: Wed, 11 Oct 2017 22:57:58 -0700
Message-Id: <20171012055758.11167-1-andrzej.jakowski@intel.com>
In-Reply-To: <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
References: <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, vincentfu@gmail.com, Andrzej Jakowski <andrzej.jakowski@intel.com>

This patch fixes percentile calculation for Windows where overflow
on 32 bit type happened while calculating actual percentiles.

Signed-off-by: Andrzej Jakowski <andrzej.jakowski@intel.com>
---
 gclient.c | 2 +-
 stat.c    | 6 +++---
 stat.h    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/gclient.c b/gclient.c
index 43c8a089..daa91538 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1099,7 +1099,7 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 				       int ddir)
 {
 	unsigned int *io_u_plat = ts->io_u_plat[ddir];
-	unsigned long nr = ts->clat_stat[ddir].samples;
+	unsigned long long nr = ts->clat_stat[ddir].samples;
 	fio_fp64_t *plist = ts->percentile_list;
 	unsigned int len, scale_down;
 	unsigned long long *ovals, minv, maxv;
diff --git a/stat.c b/stat.c
index c5a68ad5..c8a45dbd 100644
--- a/stat.c
+++ b/stat.c
@@ -135,11 +135,11 @@ static int double_cmp(const void *a, const void *b)
 	return cmp;
 }
 
-unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
+unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
-	unsigned long sum = 0;
+	unsigned long long sum = 0;
 	unsigned int len, i, j = 0;
 	unsigned int oval_len = 0;
 	unsigned long long *ovals = NULL;
@@ -198,7 +198,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
 /*
  * Find and display the p-th percentile of clat
  */
-static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long nr,
+static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
 				  fio_fp64_t *plist, unsigned int precision,
 				  bool is_clat, struct buf_output *out)
 {
diff --git a/stat.h b/stat.h
index 3fda0841..6ddcad25 100644
--- a/stat.h
+++ b/stat.h
@@ -293,7 +293,7 @@ extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
 extern bool calc_lat(struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
-extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
+extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
 extern void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
-- 
2.13.6

