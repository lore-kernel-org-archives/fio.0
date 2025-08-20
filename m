Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.152.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120332DD5EF
	for <fio@vger.kernel.org>; Wed, 20 Aug 2025 13:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.152.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755695078; cv=none; b=fjPuih8G2qQtrdrcYoaUTJmR3a+4dm0kv1nYbBVoyQS+/jsd6SJxVNbj/hIc+TvwhmgDq8OGMlcB56utq9bG4imts1yM5JuFhoQnb/DSvGgLeR4WZrtd7Ghz9G3SJEeBa67bgICZ5rFnctjBBjVfy1HNoFJQHT32vPBSGwxEgk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755695078; c=relaxed/simple;
	bh=q6TpgYYHoTMgVyRi+NIL9PUSIcUTrjxE+Lm6l5O98VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqROCF47aCz7UGa/vmXi3mi6FHW1RkD5q2t4z/zB2S9iiuvAOkBjWEiNb3d6VnYIgCZGgG/8+9rjvfiDMhT65gjw5sAUUgJ3SevGnzQyNbP82z2+usXWsZIi7zF6lsyYwasm6R2lQX6myZU8N3wMs9YGw8K7jzeqjVPkribrpdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=ilITU8Ps; arc=none smtp.client-ip=216.71.152.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="ilITU8Ps"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1755695076; x=1787231076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q6TpgYYHoTMgVyRi+NIL9PUSIcUTrjxE+Lm6l5O98VM=;
  b=ilITU8Ps5h6rV65TAL6NBya25TT+TEOAFcta7Oa8O6LChpfeMuaWBwku
   /h+80/+pDVCe+OVAQWqo6KBET4DGYNdiz4OD2tD4TVqg70o+DLLxn2gkv
   Ko5l8YGv1lLYEa8GzkL6BT+rCmhxqnBJ2PYKp/bUh71DwACBZ6IPYnTmU
   Rz22VdTRCzH0HhDMXWWi5Z0THfll870V22sZx/9oGW0qPH38zDYMqA4Bw
   VUCr3VUU5C6z/uXiaTvBHSvxfoczwoBcghBopJmZiY0KHci7s6doT4mEU
   9Ite6dPsEhfthCfXwaBEX8eDJqKFHId66jcx1JFB63ZFMvxon5JoW2AmY
   w==;
X-CSE-ConnectionGUID: QYdHQiFsSsallyqQE36y6w==
X-CSE-MsgGUID: grM+xcyBQzK8CXOMlO0Crg==
Received: from unknown (HELO uls-op-esaep01.corp.sandisk.com) ([129.253.192.43])
  by ob1.hc6817-7.iphmx.com with ESMTP; 20 Aug 2025 06:03:29 -0700
IronPort-SDR: 68a5c7a1_DJHcKTvrTpMcWYaMWaNZyGkDM+iBuD/GbPPrcjtcMj1RCfF
 xHWP/ioi0pusVSsItK0v+iBK/qgll22CZ4KAViQ==
Received: from unknown (HELO uls-op-esaip01.corp.sandisk.com) ([10.15.0.10])
  by uls-op-esaep01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:28 -0700
SanDiskIronportException: Internal
Received: from ulssdxvpxsnip.corp.sandisk.com (HELO WDAP-HWJc7y5WZG.wdc.com) ([10.9.34.160])
  by uls-op-esaip01.corp.sandisk.com with ESMTP; 20 Aug 2025 06:03:27 -0700
From: Tomas Winkler <tomas.winkler@sandisk.com>
To: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincentfu@gmail.com>
Cc: fio@vger.kernel.org,
	Tomas Winkler <tomas.winkler@sandisk.com>
Subject: [PATCH 1/3] stat: make stat.c static and const-correct
Date: Wed, 20 Aug 2025 16:03:19 +0300
Message-ID: <20250820130321.73376-2-tomas.winkler@sandisk.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820130321.73376-1-tomas.winkler@sandisk.com>
References: <20250820130321.73376-1-tomas.winkler@sandisk.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mark internal function static and input only parameters const.

Signed-off-by: Tomas Winkler <tomas.winkler@sandisk.com>
---
 stat.c        | 100 +++++++++++++++++++++++++-------------------------
 stat.h        |  24 ++++++------
 steadystate.c |   4 +-
 steadystate.h |   4 +-
 4 files changed, 66 insertions(+), 66 deletions(-)

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
-- 
2.43.0

