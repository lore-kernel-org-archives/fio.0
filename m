Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DA130F7F2
	for <fio@vger.kernel.org>; Thu, 21 Aug 2025 12:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755777617; cv=none; b=Sf0k6eD8rFyBMWfb3cVZTQAyPSZ+0M/TIMUOMOEn8Kvw7Ar2rqVtecoRDcr0CGdWNZu0DlxUWw4DdCopwcU3FyTFyrHOm+/QbbVtuB8ASY6fYhkwhCErug01qM6JYuQBtx9L6VS1mz3NlYS7YqZ1FTBixxU1pU5vwFTmkzgxL9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755777617; c=relaxed/simple;
	bh=y35bxb44nJSn9QWhQE+CXLX8YunYQJaJ0bq/OUAQYrk=;
	h=Subject:From:To:Message-Id:Date; b=axokcAc87s0F+GBqzBkc4OudHd21JyGZEDL7E55NbRbG5G+GloGrBRUSEZ18ecANsu3+QQQqZmKN+xtP6obby3VD2hhYlqTEMAIQH/9LeqP3zg1CqIruvXNibuKfdWx2gviCeLchOzIohVau6KtX2fVIpfblWgKcMYZYd3XG+pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l2to4Cf+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l2to4Cf+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fjLnKR0X6caSS6kAynLqGkFEUaZgiOX0lMaS2ejZmL0=; b=l2to4Cf+2uHqamTYyKT8n3iNQ0
	FRBdF2mDNLCqalGCtKzEMD7JcTf7JXA5tRhds5+dGu3n91J8Xzc/3NU4Ji2oginQNGWZ55qlJ2CX6
	zHBynkvxjiS253aQ8OmplpU2m9R4NdILD8CrqHm2Wbmwqizfst40TFW/aEEghRzEDsQ6q6VHJT7wN
	FGeM1YGFDqua9KRNutL3HaEdO8sUTSROUfltDEoXGaJj/fjn3F1weOUnhQXa6ulQfW557Xzz6/BCk
	w26puqfVJC1IeOWAOioNBwEYtCAgII4WQ1VmDCb8Wz0fFH9zPXoxaWs1RSAdWa8yj0qa0FSnru3E8
	R0OeIiQQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up3xc-00000006Vbz-1sBA
	for fio@vger.kernel.org;
	Thu, 21 Aug 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 087361BC016B; Thu, 21 Aug 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250821120002.087361BC016B@kernel.dk>
Date: Thu, 21 Aug 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit efaeeea4a8b04e1c315943684aabd84f3198256b:

  Merge branch 'fix-install-paths' of https://github.com/kubo326/fio (2025-08-19 11:09:24 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4b327db09de9651a70e9a603e36c44715bf43c8b:

  engines: make engines static-correct (2025-08-20 10:25:11 -0400)

----------------------------------------------------------------
Tomas Winkler (3):
      stat: make stat.c static and const-correct
      engines/http: make fio_http_getevents static
      engines: make engines static-correct

 engines/cpu.c  |   4 +--
 engines/exec.c |   6 ++--
 engines/http.c |   2 +-
 engines/nvme.c |   4 +--
 engines/sg.c   |   2 +-
 stat.c         | 100 ++++++++++++++++++++++++++++-----------------------------
 stat.h         |  24 +++++++-------
 steadystate.c  |   4 +--
 steadystate.h  |   4 +--
 9 files changed, 75 insertions(+), 75 deletions(-)

---

Diff of recent changes:

diff --git a/engines/cpu.c b/engines/cpu.c
index ce74dbce..898fc00e 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -9,7 +9,7 @@
 #include "../optgroup.h"
 
 // number of 32 bit integers to sort
-size_t qsort_size = (256 * (1ULL << 10)); // 256KB
+static size_t qsort_size = (256 * (1ULL << 10)); // 256KB
 
 struct mwc {
 	uint32_t w;
@@ -93,7 +93,7 @@ static struct fio_option options[] = {
  *      fast pseudo random number generator, see
  *      http://www.cse.yorku.ca/~oz/marsaglia-rng.html
  */
-uint32_t mwc32(struct mwc *mwc)
+static uint32_t mwc32(struct mwc *mwc)
 {
         mwc->z = 36969 * (mwc->z & 65535) + (mwc->z >> 16);
         mwc->w = 18000 * (mwc->w & 65535) + (mwc->w >> 16);
diff --git a/engines/exec.c b/engines/exec.c
index 20e50e00..af20d5e1 100644
--- a/engines/exec.c
+++ b/engines/exec.c
@@ -62,7 +62,7 @@ static struct fio_option options[] = {
 	},
 };
 
-char *str_replace(char *orig, const char *rep, const char *with)
+static char *str_replace(char *orig, const char *rep, const char *with)
 {
 	/*
 	 * Replace a substring by another.
@@ -106,7 +106,7 @@ char *str_replace(char *orig, const char *rep, const char *with)
 	return result;
 }
 
-char *expand_variables(struct thread_options *o, char *arguments)
+static char *expand_variables(const struct thread_options *o, char *arguments)
 {
 	char str[16];
 	char *expanded_runtime, *expanded_name;
@@ -122,7 +122,7 @@ char *expand_variables(struct thread_options *o, char *arguments)
 	return expanded_name;
 }
 
-static int exec_background(struct thread_options *o, struct exec_options *eo)
+static int exec_background(const struct thread_options *o, struct exec_options *eo)
 {
 	char *outfilename = NULL, *errfilename = NULL;
 	int outfd = 0, errfd = 0;
diff --git a/engines/http.c b/engines/http.c
index 1a1787bf..83891f1f 100644
--- a/engines/http.c
+++ b/engines/http.c
@@ -810,7 +810,7 @@ static struct io_u *fio_http_event(struct thread_data *td, int event)
 	return NULL;
 }
 
-int fio_http_getevents(struct thread_data *td, unsigned int min,
+static int fio_http_getevents(struct thread_data *td, unsigned int min,
 	unsigned int max, const struct timespec *t)
 {
 	/* sync IO engine - never any outstanding events */
diff --git a/engines/nvme.c b/engines/nvme.c
index 4b3d3860..528b2a29 100644
--- a/engines/nvme.c
+++ b/engines/nvme.c
@@ -312,8 +312,8 @@ next:
 
 	return 0;
 }
-void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
-				  struct nvme_dsm *dsm)
+static void fio_nvme_uring_cmd_trim_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
+					 struct nvme_dsm *dsm)
 {
 	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
 	struct trim_range *range;
diff --git a/engines/sg.c b/engines/sg.c
index 9df70bd2..7912e9c8 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -1136,7 +1136,7 @@ static int fio_sgio_open(struct thread_data *td, struct fio_file *f)
 	return 0;
 }
 
-int fio_sgio_close(struct thread_data *td, struct fio_file *f)
+static int fio_sgio_close(struct thread_data *td, struct fio_file *f)
 {
 	struct sg_options *o = td->eo;
 	int ret;
diff --git a/stat.c b/stat.c
index f1984dce..ee5bdf1f 100644
--- a/stat.c
+++ b/stat.c
@@ -148,7 +148,7 @@ static int double_cmp(const void *a, const void *b)
 	return cmp;
 }
 
-unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
+unsigned int calc_clat_percentiles(const uint64_t *io_u_plat, unsigned long long nr,
 				   fio_fp64_t *plist, unsigned long long **output,
 				   unsigned long long *maxv, unsigned long long *minv)
 {
@@ -212,7 +212,7 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 /*
  * Find and display the p-th percentile of clat
  */
-static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
+static void show_clat_percentiles(const uint64_t *io_u_plat, unsigned long long nr,
 				  fio_fp64_t *plist, unsigned int precision,
 				  const char *pre, struct buf_output *out)
 {
@@ -287,7 +287,7 @@ static int get_nr_prios_with_samples(struct thread_stat *ts, enum fio_ddir ddir)
 	return nr_prios_with_samples;
 }
 
-bool calc_lat(struct io_stat *is, unsigned long long *min,
+bool calc_lat(const struct io_stat *is, unsigned long long *min,
 	      unsigned long long *max, double *mean, double *dev)
 {
 	double n = (double) is->samples;
@@ -307,7 +307,7 @@ bool calc_lat(struct io_stat *is, unsigned long long *min,
 	return true;
 }
 
-void show_mixed_group_stats(struct group_run_stats *rs, struct buf_output *out) 
+static void show_mixed_group_stats(const struct group_run_stats *rs, struct buf_output *out)
 {
 	char *io, *agg, *min, *max;
 	char *ioalt, *aggalt, *minalt, *maxalt;
@@ -348,7 +348,7 @@ void show_mixed_group_stats(struct group_run_stats *rs, struct buf_output *out)
 	free(maxalt);
 }
 
-void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
+void show_group_stats(const struct group_run_stats *rs, struct buf_output *out)
 {
 	char *io, *agg, *min, *max;
 	char *ioalt, *aggalt, *minalt, *maxalt;
@@ -392,7 +392,7 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		show_mixed_group_stats(rs, out);
 }
 
-void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist)
+void stat_calc_dist(const uint64_t *map, unsigned long total, double *io_u_dist)
 {
 	int i;
 
@@ -410,8 +410,8 @@ void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist)
 	}
 }
 
-static void stat_calc_lat(struct thread_stat *ts, double *dst,
-			  uint64_t *src, int nr)
+static void stat_calc_lat(const struct thread_stat *ts, double *dst,
+			  const uint64_t *src, int nr)
 {
 	unsigned long total = ddir_rw_sum(ts->total_io_u);
 	int i;
@@ -434,7 +434,7 @@ static void stat_calc_lat(struct thread_stat *ts, double *dst,
  * To keep the terse format unaltered, add all of the ns latency
  * buckets to the first us latency bucket
  */
-static void stat_calc_lat_nu(struct thread_stat *ts, double *io_u_lat_u)
+static void stat_calc_lat_nu(const struct thread_stat *ts, double *io_u_lat_u)
 {
 	unsigned long ntotal = 0, total = ddir_rw_sum(ts->total_io_u);
 	int i;
@@ -447,17 +447,17 @@ static void stat_calc_lat_nu(struct thread_stat *ts, double *io_u_lat_u)
 	io_u_lat_u[0] += 100.0 * (double) ntotal / (double) total;
 }
 
-void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat)
+void stat_calc_lat_n(const struct thread_stat *ts, double *io_u_lat)
 {
 	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_n, FIO_IO_U_LAT_N_NR);
 }
 
-void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat)
+void stat_calc_lat_u(const struct thread_stat *ts, double *io_u_lat)
 {
 	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_u, FIO_IO_U_LAT_U_NR);
 }
 
-void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat)
+void stat_calc_lat_m(const struct thread_stat *ts, double *io_u_lat)
 {
 	stat_calc_lat(ts, io_u_lat, ts->io_u_lat_m, FIO_IO_U_LAT_M_NR);
 }
@@ -484,7 +484,7 @@ static void display_lat(const char *name, unsigned long long min,
 	free(maxp);
 }
 
-static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
+static struct thread_stat *gen_mixed_ddir_stats_from_ts(const struct thread_stat *ts)
 {
 	struct thread_stat *ts_lcl;
 
@@ -514,7 +514,7 @@ static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
 	return ts_lcl;
 }
 
-static double convert_agg_kbytes_percent(struct group_run_stats *rs,
+static double convert_agg_kbytes_percent(const struct group_run_stats *rs,
 					 enum fio_ddir ddir, int mean)
 {
 	double p_of_agg = 100.0;
@@ -527,7 +527,7 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs,
 	return p_of_agg;
 }
 
-static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
+static void show_ddir_status(const struct group_run_stats *rs, struct thread_stat *ts,
 			     enum fio_ddir ddir, struct buf_output *out)
 {
 	unsigned long runt;
@@ -707,8 +707,8 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 }
 
-static void show_mixed_ddir_status(struct group_run_stats *rs,
-				   struct thread_stat *ts,
+static void show_mixed_ddir_status(const struct group_run_stats *rs,
+				   const struct thread_stat *ts,
 				   struct buf_output *out)
 {
 	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
@@ -720,7 +720,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
 	free(ts_lcl);
 }
 
-static bool show_lat(double *io_u_lat, int nr, const char **ranges,
+static bool show_lat(const double *io_u_lat, int nr, const char **ranges,
 		     const char *msg, struct buf_output *out)
 {
 	bool new_line = true, shown = false;
@@ -751,7 +751,7 @@ static bool show_lat(double *io_u_lat, int nr, const char **ranges,
 	return true;
 }
 
-static void show_lat_n(double *io_u_lat_n, struct buf_output *out)
+static void show_lat_n(const double *io_u_lat_n, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
 				 "250=", "500=", "750=", "1000=", };
@@ -759,7 +759,7 @@ static void show_lat_n(double *io_u_lat_n, struct buf_output *out)
 	show_lat(io_u_lat_n, FIO_IO_U_LAT_N_NR, ranges, "nsec", out);
 }
 
-static void show_lat_u(double *io_u_lat_u, struct buf_output *out)
+static void show_lat_u(const double *io_u_lat_u, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
 				 "250=", "500=", "750=", "1000=", };
@@ -767,7 +767,7 @@ static void show_lat_u(double *io_u_lat_u, struct buf_output *out)
 	show_lat(io_u_lat_u, FIO_IO_U_LAT_U_NR, ranges, "usec", out);
 }
 
-static void show_lat_m(double *io_u_lat_m, struct buf_output *out)
+static void show_lat_m(const double *io_u_lat_m, struct buf_output *out)
 {
 	const char *ranges[] = { "2=", "4=", "10=", "20=", "50=", "100=",
 				 "250=", "500=", "750=", "1000=", "2000=",
@@ -776,7 +776,7 @@ static void show_lat_m(double *io_u_lat_m, struct buf_output *out)
 	show_lat(io_u_lat_m, FIO_IO_U_LAT_M_NR, ranges, "msec", out);
 }
 
-static void show_latencies(struct thread_stat *ts, struct buf_output *out)
+static void show_latencies(const struct thread_stat *ts, struct buf_output *out)
 {
 	double io_u_lat_n[FIO_IO_U_LAT_N_NR];
 	double io_u_lat_u[FIO_IO_U_LAT_U_NR];
@@ -933,7 +933,7 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 			 i == BLOCK_STATE_COUNT - 1 ? '\n' : ',');
 }
 
-static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
+static void show_ss_normal(const struct thread_stat *ts, struct buf_output *out)
 {
 	char *p1, *p1alt, *p2;
 	unsigned long long bw_mean, iops_mean;
@@ -962,7 +962,7 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	free(p2);
 }
 
-static void show_agg_stats(struct disk_util_agg *agg, int terse,
+static void show_agg_stats(const struct disk_util_agg *agg, int terse,
 			   struct buf_output *out)
 {
 	if (!agg->slavecount)
@@ -1030,7 +1030,7 @@ static void aggregate_slaves_stats(struct disk_util *masterdu)
 		agg->max_util.u.f = 100.0;
 }
 
-void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
+void print_disk_util(const struct disk_util_stat *dus, const struct disk_util_agg *agg,
 		     int terse, struct buf_output *out)
 {
 	double util = 0;
@@ -1081,8 +1081,8 @@ void print_disk_util(struct disk_util_stat *dus, struct disk_util_agg *agg,
 		log_buf(out, "\n");
 }
 
-void json_array_add_disk_util(struct disk_util_stat *dus,
-		struct disk_util_agg *agg, struct json_array *array)
+void json_array_add_disk_util(const struct disk_util_stat *dus,
+			      const struct disk_util_agg *agg, struct json_array *array)
 {
 	struct json_object *obj;
 	double util = 0;
@@ -1151,8 +1151,8 @@ static void json_object_add_disk_utils(struct json_object *obj,
 	}
 }
 
-void show_disk_util(int terse, struct json_object *parent,
-		    struct buf_output *out)
+static void show_disk_util(int terse, struct json_object *parent,
+			   struct buf_output *out)
 {
 	struct flist_head *entry;
 	struct disk_util *du;
@@ -1185,7 +1185,7 @@ void show_disk_util(int terse, struct json_object *parent,
 }
 
 static void show_thread_status_normal(struct thread_stat *ts,
-				      struct group_run_stats *rs,
+				      const struct group_run_stats *rs,
 				      struct buf_output *out)
 {
 	double usr_cpu, sys_cpu;
@@ -1301,7 +1301,7 @@ static void show_thread_status_normal(struct thread_stat *ts,
 }
 
 static void show_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs,
+				   const struct group_run_stats *rs,
 				   enum fio_ddir ddir, int ver,
 				   struct buf_output *out)
 {
@@ -1393,9 +1393,9 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	}
 }
 
-static void show_mixed_ddir_status_terse(struct thread_stat *ts,
-				   struct group_run_stats *rs,
-				   int ver, struct buf_output *out)
+static void show_mixed_ddir_status_terse(const struct thread_stat *ts,
+					 const struct group_run_stats *rs,
+					 int ver, struct buf_output *out)
 {
 	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
 
@@ -1408,8 +1408,8 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
 
 static struct json_object *add_ddir_lat_json(struct thread_stat *ts,
 					     uint32_t percentiles,
-					     struct io_stat *lat_stat,
-					     uint64_t *io_u_plat)
+					     const struct io_stat *lat_stat,
+					     const uint64_t *io_u_plat)
 {
 	char buf[120];
 	double mean, dev;
@@ -1459,7 +1459,7 @@ static struct json_object *add_ddir_lat_json(struct thread_stat *ts,
 }
 
 static void add_ddir_status_json(struct thread_stat *ts,
-				 struct group_run_stats *rs, enum fio_ddir ddir,
+				 const struct group_run_stats *rs, enum fio_ddir ddir,
 				 struct json_object *parent)
 {
 	unsigned long long min, max;
@@ -1976,7 +1976,7 @@ struct json_object *show_thread_status(struct thread_stat *ts,
 	return ret;
 }
 
-static void __sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
+static void __sum_stat(struct io_stat *dst, const struct io_stat *src, bool first)
 {
 	double mean, S;
 
@@ -2015,7 +2015,7 @@ static void __sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
  * numbers. For group_reporting, we should just add those up, not make
  * them the mean of everything.
  */
-static void sum_stat(struct io_stat *dst, struct io_stat *src, bool pure_sum)
+static void sum_stat(struct io_stat *dst, const struct io_stat *src, bool pure_sum)
 {
 	bool first = dst->samples == 0;
 
@@ -2042,9 +2042,9 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, bool pure_sum)
 	}
 }
 
-void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
+void sum_group_stats(struct group_run_stats *dst, const struct group_run_stats *src)
 {
-	int i;
+	unsigned int i;
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		if (dst->max_run[i] < src->max_run[i])
@@ -2166,7 +2166,7 @@ static int alloc_or_get_clat_prio_index(struct thread_stat *dst,
 	return 0;
 }
 
-static int clat_prio_stats_copy(struct thread_stat *dst, struct thread_stat *src,
+static int clat_prio_stats_copy(struct thread_stat *dst, const struct thread_stat *src,
 				enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
 {
 	size_t sz = sizeof(*src->clat_prio[src_ddir]) *
@@ -2186,8 +2186,8 @@ static int clat_prio_stats_copy(struct thread_stat *dst, struct thread_stat *src
 
 static int clat_prio_stat_add_samples(struct thread_stat *dst,
 				      enum fio_ddir dst_ddir, uint32_t ioprio,
-				      struct io_stat *io_stat,
-				      uint64_t *io_u_plat)
+				      const struct io_stat *io_stat,
+				      const uint64_t *io_u_plat)
 {
 	int i, dst_index;
 
@@ -2207,12 +2207,12 @@ static int clat_prio_stat_add_samples(struct thread_stat *dst,
 }
 
 static int sum_clat_prio_stats_src_single_prio(struct thread_stat *dst,
-					       struct thread_stat *src,
+					       const struct thread_stat *src,
 					       enum fio_ddir dst_ddir,
 					       enum fio_ddir src_ddir)
 {
-	struct io_stat *io_stat;
-	uint64_t *io_u_plat;
+	const struct io_stat *io_stat;
+	const uint64_t *io_u_plat;
 
 	/*
 	 * If src ts has no clat_prio_stat array, then all I/Os were submitted
@@ -2235,7 +2235,7 @@ static int sum_clat_prio_stats_src_single_prio(struct thread_stat *dst,
 }
 
 static int sum_clat_prio_stats_src_multi_prio(struct thread_stat *dst,
-					      struct thread_stat *src,
+					      const struct thread_stat *src,
 					      enum fio_ddir dst_ddir,
 					      enum fio_ddir src_ddir)
 {
@@ -2267,7 +2267,7 @@ static int sum_clat_prio_stats_src_multi_prio(struct thread_stat *dst,
 	return 0;
 }
 
-static int sum_clat_prio_stats(struct thread_stat *dst, struct thread_stat *src,
+static int sum_clat_prio_stats(struct thread_stat *dst, const struct thread_stat *src,
 			       enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
 {
 	if (dst->disable_prio_stat)
@@ -2280,7 +2280,7 @@ static int sum_clat_prio_stats(struct thread_stat *dst, struct thread_stat *src,
 	return sum_clat_prio_stats_src_multi_prio(dst, src, dst_ddir, src_ddir);
 }
 
-void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
+void sum_thread_stats(struct thread_stat *dst, const struct thread_stat *src)
 {
 	int k, l, m;
 
diff --git a/stat.h b/stat.h
index ac74d6c2..02bea976 100644
--- a/stat.h
+++ b/stat.h
@@ -344,24 +344,24 @@ extern void stat_init(void);
 extern void stat_exit(void);
 
 extern struct json_object * show_thread_status(struct thread_stat *ts, struct group_run_stats *rs, struct flist_head *, struct buf_output *);
-extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
+extern void show_group_stats(const struct group_run_stats *rs, struct buf_output *);
 extern void display_thread_status(struct jobs_eta *je);
 extern void __show_run_stats(void);
 extern int __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
-extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src);
-extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
+extern void sum_thread_stats(struct thread_stat *dst, const struct thread_stat *src);
+extern void sum_group_stats(struct group_run_stats *dst, const struct group_run_stats *src);
 extern void init_thread_stat_min_vals(struct thread_stat *ts);
 extern void init_thread_stat(struct thread_stat *ts);
 extern void init_group_run_stat(struct group_run_stats *gs);
 extern void eta_to_str(char *str, unsigned long eta_sec);
-extern bool calc_lat(struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
-extern unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
-extern void stat_calc_lat_n(struct thread_stat *ts, double *io_u_lat);
-extern void stat_calc_lat_m(struct thread_stat *ts, double *io_u_lat);
-extern void stat_calc_lat_u(struct thread_stat *ts, double *io_u_lat);
-extern void stat_calc_dist(uint64_t *map, unsigned long total, double *io_u_dist);
+extern bool calc_lat(const struct io_stat *is, unsigned long long *min, unsigned long long *max, double *mean, double *dev);
+extern unsigned int calc_clat_percentiles(const uint64_t *io_u_plat, unsigned long long nr, fio_fp64_t *plist, unsigned long long **output, unsigned long long *maxv, unsigned long long *minv);
+extern void stat_calc_lat_n(const struct thread_stat *ts, double *io_u_lat);
+extern void stat_calc_lat_m(const struct thread_stat *ts, double *io_u_lat);
+extern void stat_calc_lat_u(const struct thread_stat *ts, double *io_u_lat);
+extern void stat_calc_dist(const uint64_t *map, unsigned long total, double *io_u_dist);
 extern void reset_io_stats(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
 extern void clear_rusage_stat(struct thread_data *);
@@ -384,9 +384,9 @@ extern int calc_log_samples(void);
 extern void free_clat_prio_stats(struct thread_stat *);
 extern int alloc_clat_prio_stat_ddir(struct thread_stat *, enum fio_ddir, int);
 
-extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
-extern void json_array_add_disk_util(struct disk_util_stat *dus,
-				struct disk_util_agg *agg, struct json_array *parent);
+extern void print_disk_util(const struct disk_util_stat *, const struct disk_util_agg *, int terse, struct buf_output *);
+extern void json_array_add_disk_util(const struct disk_util_stat *dus,
+				     const struct disk_util_agg *agg, struct json_array *parent);
 
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern bool write_bw_log;
diff --git a/steadystate.c b/steadystate.c
index 3e3683f3..9e47df2c 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -353,7 +353,7 @@ int td_steadystate_init(struct thread_data *td)
 	return 0;
 }
 
-uint64_t steadystate_bw_mean(struct thread_stat *ts)
+uint64_t steadystate_bw_mean(const struct thread_stat *ts)
 {
 	int i;
 	uint64_t sum;
@@ -368,7 +368,7 @@ uint64_t steadystate_bw_mean(struct thread_stat *ts)
 	return sum / intervals;
 }
 
-uint64_t steadystate_iops_mean(struct thread_stat *ts)
+uint64_t steadystate_iops_mean(const struct thread_stat *ts)
 {
 	int i;
 	uint64_t sum;
diff --git a/steadystate.h b/steadystate.h
index f1ef2b20..e25fd9d0 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -7,8 +7,8 @@ extern void steadystate_free(struct thread_data *);
 extern int steadystate_check(void);
 extern void steadystate_setup(void);
 extern int td_steadystate_init(struct thread_data *);
-extern uint64_t steadystate_bw_mean(struct thread_stat *);
-extern uint64_t steadystate_iops_mean(struct thread_stat *);
+extern uint64_t steadystate_bw_mean(const struct thread_stat *);
+extern uint64_t steadystate_iops_mean(const struct thread_stat *);
 
 extern bool steadystate_enabled;
 extern unsigned int ss_check_interval;
