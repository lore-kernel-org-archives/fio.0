Return-Path: <fio-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:38238 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbeHXWHU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Aug 2018 18:07:20 -0400
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 08/11] Collect and show zone reset statistics
Date: Fri, 24 Aug 2018 11:31:28 -0700
Message-Id: <20180824183131.13278-9-bart.vanassche@wdc.com>
In-Reply-To: <20180824183131.13278-1-bart.vanassche@wdc.com>
References: <20180824183131.13278-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>

Show how many zone resets have been performed in the I/O statistics.
An example:
[ ... ]
  write: IOPS=17.0k, BW=66.5MiB/s (69.8MB/s)(1024MiB/15387msec); 4 zone resets
[ ... ]

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 stat.c | 13 ++++++++++---
 stat.h |  3 +++
 zbd.c  | 12 ++++++++++++
 zbd.h  |  6 ++++++
 4 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/stat.c b/stat.c
index 6cb704eb11bb..abdbb0e3fb9b 100644
--- a/stat.c
+++ b/stat.c
@@ -14,6 +14,7 @@
 #include "lib/output_buffer.h"
 #include "helper_thread.h"
 #include "smalloc.h"
+#include "zbd.h"
 
 #define LOG_MSEC_SLACK	1
 
@@ -419,7 +420,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
-	char *io_p, *bw_p, *bw_p_alt, *iops_p;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p, *zbd_w_st = NULL;
 	int i2p;
 
 	if (ddir_sync(ddir)) {
@@ -450,12 +451,16 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
+	if (ddir == DDIR_WRITE)
+		zbd_w_st = zbd_write_status(ts);
 
-	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)\n",
+	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
 			rs->unified_rw_rep ? "mixed" : str[ddir],
 			iops_p, bw_p, bw_p_alt, io_p,
-			(unsigned long long) ts->runtime[ddir]);
+			(unsigned long long) ts->runtime[ddir],
+			zbd_w_st ? : "");
 
+	free(zbd_w_st);
 	free(io_p);
 	free(bw_p);
 	free(bw_p_alt);
@@ -1655,6 +1660,7 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	dst->total_run_time += src->total_run_time;
 	dst->total_submit += src->total_submit;
 	dst->total_complete += src->total_complete;
+	dst->nr_zone_resets += src->nr_zone_resets;
 }
 
 void init_group_run_stat(struct group_run_stats *gs)
@@ -2337,6 +2343,7 @@ void reset_io_stats(struct thread_data *td)
 
 	ts->total_submit = 0;
 	ts->total_complete = 0;
+	ts->nr_zone_resets = 0;
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
diff --git a/stat.h b/stat.h
index 5dcaae029cde..98de281e2e11 100644
--- a/stat.h
+++ b/stat.h
@@ -211,6 +211,9 @@ struct thread_stat {
 	uint32_t first_error;
 	uint64_t total_err_count;
 
+	/* ZBD stats */
+	uint64_t nr_zone_resets;
+
 	uint64_t nr_block_infos;
 	uint32_t block_infos[MAX_NR_BLOCK_INFOS];
 
diff --git a/zbd.c b/zbd.c
index 42487780ca77..f4105b422522 100644
--- a/zbd.c
+++ b/zbd.c
@@ -594,6 +594,8 @@ static int zbd_reset_range(struct thread_data *td, const struct fio_file *f,
 		pthread_mutex_unlock(&z->mutex);
 	}
 
+	td->ts.nr_zone_resets += ze - zb;
+
 	return ret;
 }
 
@@ -969,3 +971,13 @@ eof:
 		pthread_mutex_unlock(&zb->mutex);
 	return io_u_eof;
 }
+
+/* Return a string with ZBD statistics */
+char *zbd_write_status(const struct thread_stat *ts)
+{
+	char *res;
+
+	if (asprintf(&res, "; %ld zone resets", ts->nr_zone_resets) < 0)
+		return NULL;
+	return res;
+}
diff --git a/zbd.h b/zbd.h
index ec5d85e1bd50..82ce4662834f 100644
--- a/zbd.h
+++ b/zbd.h
@@ -86,6 +86,7 @@ bool zbd_unaligned_write(int error_code);
 enum io_u_action zbd_adjust_block(struct thread_data *td, struct io_u *io_u);
 int zbd_do_trim(struct thread_data *td, const struct io_u *io_u);
 void zbd_update_wp(struct thread_data *td, const struct io_u *io_u);
+char *zbd_write_status(const struct thread_stat *ts);
 #else
 static inline void zbd_free_zone_info(struct fio_file *f)
 {
@@ -120,6 +121,11 @@ static inline void zbd_update_wp(struct thread_data *td,
 				 const struct io_u *io_u)
 {
 }
+
+static inline char *zbd_write_status(const struct thread_stat *ts)
+{
+	return NULL;
+}
 #endif
 
 #endif /* FIO_ZBD_H */
-- 
2.18.0


