Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58380 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164680AbeCBNA2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Mar 2018 08:00:28 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1erkIV-0004rD-Lv
        for fio@vger.kernel.org; Fri, 02 Mar 2018 13:00:27 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180302130001.A0AA72C0085@kernel.dk>
Date: Fri,  2 Mar 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e09d68c8da4ab91397490577454de928106651f5:

  Merge branch 'win_build' of https://github.com/sitsofe/fio (2018-02-28 09:44:08 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 892930839558edf72052e0471714f227c1391132:

  Merge branch 'hotfix_counter_overflow' of https://github.com/ifke/fio (2018-03-01 09:18:43 -0700)

----------------------------------------------------------------
Alexander Larin (1):
      Fix overflow of counters incremented on each I/O operation

Jens Axboe (1):
      Merge branch 'hotfix_counter_overflow' of https://github.com/ifke/fio

 client.c  | 20 ++++++++++----------
 gclient.c |  2 +-
 io_u.c    |  2 +-
 iolog.c   | 16 ++++++++--------
 iolog.h   |  2 +-
 server.c  | 16 ++++++++--------
 server.h  |  2 +-
 stat.c    | 12 ++++++------
 stat.h    | 23 +++++++++++------------
 9 files changed, 47 insertions(+), 48 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 6fe6d9f..bff0adc 100644
--- a/client.c
+++ b/client.c
@@ -905,21 +905,21 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	}
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
-		dst->io_u_map[i]	= le32_to_cpu(src->io_u_map[i]);
-		dst->io_u_submit[i]	= le32_to_cpu(src->io_u_submit[i]);
-		dst->io_u_complete[i]	= le32_to_cpu(src->io_u_complete[i]);
+		dst->io_u_map[i]	= le64_to_cpu(src->io_u_map[i]);
+		dst->io_u_submit[i]	= le64_to_cpu(src->io_u_submit[i]);
+		dst->io_u_complete[i]	= le64_to_cpu(src->io_u_complete[i]);
 	}
 
 	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
-		dst->io_u_lat_n[i]	= le32_to_cpu(src->io_u_lat_n[i]);
+		dst->io_u_lat_n[i]	= le64_to_cpu(src->io_u_lat_n[i]);
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		dst->io_u_lat_u[i]	= le32_to_cpu(src->io_u_lat_u[i]);
+		dst->io_u_lat_u[i]	= le64_to_cpu(src->io_u_lat_u[i]);
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		dst->io_u_lat_m[i]	= le32_to_cpu(src->io_u_lat_m[i]);
+		dst->io_u_lat_m[i]	= le64_to_cpu(src->io_u_lat_m[i]);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
-			dst->io_u_plat[i][j] = le32_to_cpu(src->io_u_plat[i][j]);
+			dst->io_u_plat[i][j] = le64_to_cpu(src->io_u_plat[i][j]);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		dst->total_io_u[i]	= le64_to_cpu(src->total_io_u[i]);
@@ -1283,7 +1283,7 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 	int log_offset;
 	uint64_t i, j, nr_samples;
 	struct io_u_plat_entry *entry;
-	unsigned int *io_u_plat;
+	uint64_t *io_u_plat;
 
 	int stride = 1 << hist_coarseness;
 
@@ -1306,9 +1306,9 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
 						io_sample_ddir(s), s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
-			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat, NULL));
+			fprintf(f, "%llu, ", (unsigned long long)hist_sum(j, stride, io_u_plat, NULL));
 		}
-		fprintf(f, "%lu\n", (unsigned long)
+		fprintf(f, "%llu\n", (unsigned long long)
 			hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat, NULL));
 
 	}
diff --git a/gclient.c b/gclient.c
index 70dda48..5087b6b 100644
--- a/gclient.c
+++ b/gclient.c
@@ -1099,7 +1099,7 @@ static void gfio_show_clat_percentiles(struct gfio_client *gc,
 				       GtkWidget *vbox, struct thread_stat *ts,
 				       int ddir)
 {
-	unsigned int *io_u_plat = ts->io_u_plat[ddir];
+	uint64_t *io_u_plat = ts->io_u_plat[ddir];
 	unsigned long long nr = ts->clat_stat[ddir].samples;
 	fio_fp64_t *plist = ts->percentile_list;
 	unsigned int len, scale_down;
diff --git a/io_u.c b/io_u.c
index b54a79c..61d09ba 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1012,7 +1012,7 @@ out:
 	return 0;
 }
 
-static void __io_u_mark_map(unsigned int *map, unsigned int nr)
+static void __io_u_mark_map(uint64_t *map, unsigned int nr)
 {
 	int idx = 0;
 
diff --git a/iolog.c b/iolog.c
index 34e74a8..fc3dade 100644
--- a/iolog.c
+++ b/iolog.c
@@ -694,10 +694,10 @@ void free_log(struct io_log *log)
 	sfree(log);
 }
 
-unsigned long hist_sum(int j, int stride, unsigned int *io_u_plat,
-		unsigned int *io_u_plat_last)
+uint64_t hist_sum(int j, int stride, uint64_t *io_u_plat,
+		uint64_t *io_u_plat_last)
 {
-	unsigned long sum;
+	uint64_t sum;
 	int k;
 
 	if (io_u_plat_last) {
@@ -718,8 +718,8 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	int log_offset;
 	uint64_t i, j, nr_samples;
 	struct io_u_plat_entry *entry, *entry_before;
-	unsigned int *io_u_plat;
-	unsigned int *io_u_plat_before;
+	uint64_t *io_u_plat;
+	uint64_t *io_u_plat_before;
 
 	int stride = 1 << hist_coarseness;
 	
@@ -743,10 +743,10 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
 						io_sample_ddir(s), s->bs);
 		for (j = 0; j < FIO_IO_U_PLAT_NR - stride; j += stride) {
-			fprintf(f, "%lu, ", hist_sum(j, stride, io_u_plat,
-						io_u_plat_before));
+			fprintf(f, "%llu, ", (unsigned long long)
+			        hist_sum(j, stride, io_u_plat, io_u_plat_before));
 		}
-		fprintf(f, "%lu\n", (unsigned long)
+		fprintf(f, "%llu\n", (unsigned long long)
 		        hist_sum(FIO_IO_U_PLAT_NR - stride, stride, io_u_plat,
 					io_u_plat_before));
 
diff --git a/iolog.h b/iolog.h
index bc3a0b5..2266617 100644
--- a/iolog.h
+++ b/iolog.h
@@ -286,7 +286,7 @@ extern void finalize_logs(struct thread_data *td, bool);
 extern void setup_log(struct io_log **, struct log_params *, const char *);
 extern void flush_log(struct io_log *, bool);
 extern void flush_samples(FILE *, void *, uint64_t);
-extern unsigned long hist_sum(int, int, unsigned int *, unsigned int *);
+extern uint64_t hist_sum(int, int, uint64_t *, uint64_t *);
 extern void free_log(struct io_log *);
 extern void fio_writeout_logs(bool);
 extern void td_writeout_logs(struct thread_data *, bool);
diff --git a/server.c b/server.c
index ce9dca3..959786f 100644
--- a/server.c
+++ b/server.c
@@ -1497,21 +1497,21 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	}
 
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
-		p.ts.io_u_map[i]	= cpu_to_le32(ts->io_u_map[i]);
-		p.ts.io_u_submit[i]	= cpu_to_le32(ts->io_u_submit[i]);
-		p.ts.io_u_complete[i]	= cpu_to_le32(ts->io_u_complete[i]);
+		p.ts.io_u_map[i]	= cpu_to_le64(ts->io_u_map[i]);
+		p.ts.io_u_submit[i]	= cpu_to_le64(ts->io_u_submit[i]);
+		p.ts.io_u_complete[i]	= cpu_to_le64(ts->io_u_complete[i]);
 	}
 
 	for (i = 0; i < FIO_IO_U_LAT_N_NR; i++)
-		p.ts.io_u_lat_n[i]	= cpu_to_le32(ts->io_u_lat_n[i]);
+		p.ts.io_u_lat_n[i]	= cpu_to_le64(ts->io_u_lat_n[i]);
 	for (i = 0; i < FIO_IO_U_LAT_U_NR; i++)
-		p.ts.io_u_lat_u[i]	= cpu_to_le32(ts->io_u_lat_u[i]);
+		p.ts.io_u_lat_u[i]	= cpu_to_le64(ts->io_u_lat_u[i]);
 	for (i = 0; i < FIO_IO_U_LAT_M_NR; i++)
-		p.ts.io_u_lat_m[i]	= cpu_to_le32(ts->io_u_lat_m[i]);
+		p.ts.io_u_lat_m[i]	= cpu_to_le64(ts->io_u_lat_m[i]);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		for (j = 0; j < FIO_IO_U_PLAT_NR; j++)
-			p.ts.io_u_plat[i][j] = cpu_to_le32(ts->io_u_plat[i][j]);
+			p.ts.io_u_plat[i][j] = cpu_to_le64(ts->io_u_plat[i][j]);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		p.ts.total_io_u[i]	= cpu_to_le64(ts->total_io_u[i]);
@@ -1748,7 +1748,7 @@ static int __fio_append_iolog_gz_hist(struct sk_entry *first, struct io_log *log
 	for (i = 0; i < cur_log->nr_samples; i++) {
 		struct io_sample *s;
 		struct io_u_plat_entry *cur_plat_entry, *prev_plat_entry;
-		unsigned int *cur_plat, *prev_plat;
+		uint64_t *cur_plat, *prev_plat;
 
 		s = get_sample(log, cur_log, i);
 		ret = __deflate_pdu_buffer(s, sample_sz, &out_pdu, &entry, stream, first);
diff --git a/server.h b/server.h
index cabd447..bd892fc 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 70,
+	FIO_SERVER_VER			= 71,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index bd2c27d..5bbc056 100644
--- a/stat.c
+++ b/stat.c
@@ -135,7 +135,7 @@ static int double_cmp(const void *a, const void *b)
 	return cmp;
 }
 
-unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
+unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
@@ -198,7 +198,7 @@ unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long n
 /*
  * Find and display the p-th percentile of clat
  */
-static void show_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr,
+static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 				  fio_fp64_t *plist, unsigned int precision,
 				  const char *pre, struct buf_output *out)
 {
@@ -323,7 +323,7 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 	}
 }
 
-void stat_calc_dist(unsigned int *map, unsigned long total, double *io_u_dist)
+void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist)
 {
 	int i;
 
@@ -342,7 +342,7 @@ void stat_calc_dist(unsigned int *map, unsigned long total, double *io_u_dist)
 }
 
 static void stat_calc_lat(struct thread_stat *ts, double *dst,
-			  unsigned int *src, int nr)
+			  uint64_t *src, int nr)
 {
 	unsigned long total = ddir_rw_sum(ts->total_io_u);
 	int i;
@@ -2460,7 +2460,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		this_window = elapsed - hw->hist_last;
 		
 		if (this_window >= iolog->hist_msec) {
-			unsigned int *io_u_plat;
+			uint64_t *io_u_plat;
 			struct io_u_plat_entry *dst;
 
 			/*
@@ -2470,7 +2470,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			 * located in iolog.c after printing this sample to the
 			 * log file.
 			 */
-			io_u_plat = (unsigned int *) td->ts.io_u_plat[ddir];
+			io_u_plat = (uint64_t *) td->ts.io_u_plat[ddir];
 			dst = malloc(sizeof(struct io_u_plat_entry));
 			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(unsigned int));
diff --git a/stat.h b/stat.h
index cc91dfc..7580f0d 100644
--- a/stat.h
+++ b/stat.h
@@ -182,15 +182,14 @@ struct thread_stat {
 	uint64_t percentile_precision;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
-	uint32_t io_u_map[FIO_IO_U_MAP_NR];
-	uint32_t io_u_submit[FIO_IO_U_MAP_NR];
-	uint32_t io_u_complete[FIO_IO_U_MAP_NR];
-	uint32_t io_u_lat_n[FIO_IO_U_LAT_N_NR];
-	uint32_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
-	uint32_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
-	uint32_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
-	uint32_t io_u_sync_plat[FIO_IO_U_PLAT_NR];
-	uint32_t pad;
+	uint64_t io_u_map[FIO_IO_U_MAP_NR];
+	uint64_t io_u_submit[FIO_IO_U_MAP_NR];
+	uint64_t io_u_complete[FIO_IO_U_MAP_NR];
+	uint64_t io_u_lat_n[FIO_IO_U_LAT_N_NR];
+	uint64_t io_u_lat_u[FIO_IO_U_LAT_U_NR];
+	uint64_t io_u_lat_m[FIO_IO_U_LAT_M_NR];
+	uint64_t io_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
+	uint64_t io_u_sync_plat[FIO_IO_U_PLAT_NR];
 
 	uint64_t total_io_u[DDIR_RWDIR_SYNC_CNT];
 	uint64_t short_io_u[DDIR_RWDIR_CNT];
@@ -275,7 +274,7 @@ struct jobs_eta {
 
 struct io_u_plat_entry {
 	struct flist_head list;
-	unsigned int io_u_plat[FIO_IO_U_PLAT_NR];
+	uint64_t io_u_plat[FIO_IO_U_PLAT_NR];
 };
 
 extern struct fio_mutex *stat_mutex;
@@ -300,11 +299,11 @@ extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
 extern bool calc_lat(struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
-extern unsigned int calc_clat_percentiles(unsigned int *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
+extern unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
 extern void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
 extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
-extern void stat_calc_dist(unsigned int *map, unsigned long total, double *io_u_dist);
+extern void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist);
 extern void reset_io_stats(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
