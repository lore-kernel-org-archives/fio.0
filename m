Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57170 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgASNAR (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 19 Jan 2020 08:00:17 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1itABc-0006Uq-1e
        for fio@vger.kernel.org; Sun, 19 Jan 2020 13:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200119130001.D8B681BC0CA8@kernel.dk>
Date: Sun, 19 Jan 2020 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e08e2dd7b77f99e4bb904fc1df2395c2fe2ffbbe:

  Merge branch 'fix_verify_push' of https://github.com/gwendalcr/fio (2020-01-16 15:44:44 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d9b7596a1fad5adf7f6731d067e1513c56eabe96:

  Merge branch 'master' of https://github.com/bvanassche/fio (2020-01-18 09:35:25 -0700)

----------------------------------------------------------------
Bart Van Assche (8):
      stat: Remove two superfluous casts
      stat: Remove more superfluous casts
      stat: Remove several superfluous if-tests
      stat: Fix a memory leak in add_ddir_status_json()
      stat: Fix another memory leak in add_ddir_status_json()
      lib/memcpy: Suppress a Coverity leak report for setup_tests()
      pmemblk: Fix a memory leak
      client: Fix memory leaks in handle_job_opt()

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 client.c          |  4 ++++
 engines/pmemblk.c |  2 ++
 lib/memcpy.c      |  3 +++
 stat.c            | 43 ++++++++++++++++++++++---------------------
 4 files changed, 31 insertions(+), 21 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 55d89a0e..93bca5df 100644
--- a/client.c
+++ b/client.c
@@ -1157,6 +1157,10 @@ static void handle_job_opt(struct fio_client *client, struct fio_net_cmd *cmd)
 		struct flist_head *opt_list = &client->opt_lists[pdu->groupid];
 
 		flist_add_tail(&p->list, opt_list);
+	} else {
+		free(p->value);
+		free(p->name);
+		free(p);
 	}
 }
 
diff --git a/engines/pmemblk.c b/engines/pmemblk.c
index 45f6fb65..730f4d77 100644
--- a/engines/pmemblk.c
+++ b/engines/pmemblk.c
@@ -226,6 +226,8 @@ static fio_pmemblk_file_t pmb_open(const char *pathspec, int flags)
 
 	pthread_mutex_unlock(&CacheLock);
 
+	free(path);
+
 	return pmb;
 
 error:
diff --git a/lib/memcpy.c b/lib/memcpy.c
index cf8572e2..a5521343 100644
--- a/lib/memcpy.c
+++ b/lib/memcpy.c
@@ -201,6 +201,9 @@ static int setup_tests(void)
 	void *src, *dst;
 	int i;
 
+	if (!tests[0].name)
+		return 0;
+
 	src = malloc(BUF_SIZE);
 	dst = malloc(BUF_SIZE);
 	if (!src || !dst) {
diff --git a/stat.c b/stat.c
index 55d83fcc..4d3b728c 100644
--- a/stat.c
+++ b/stat.c
@@ -159,7 +159,7 @@ unsigned int calc_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	 * isn't a worry. Also note that this does not work for NaN values.
 	 */
 	if (len > 1)
-		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
+		qsort(plist, len, sizeof(plist[0]), double_cmp);
 
 	ovals = malloc(len * sizeof(*ovals));
 	if (!ovals)
@@ -259,8 +259,7 @@ static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
 	}
 
 out:
-	if (ovals)
-		free(ovals);
+	free(ovals);
 }
 
 bool calc_lat(struct io_stat *is, unsigned long long *min,
@@ -684,7 +683,7 @@ static int calc_block_percentiles(int nr_block_infos, uint32_t *block_infos,
 	 * isn't a worry. Also note that this does not work for NaN values.
 	 */
 	if (len > 1)
-		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
+		qsort(plist, len, sizeof(plist[0]), double_cmp);
 
 	/* Start only after the uninit entries end */
 	for (nr_uninit = 0;
@@ -1168,8 +1167,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	else
 		log_buf(out, ";%llu;%llu;%f;%f", 0ULL, 0ULL, 0.0, 0.0);
 
-	if (ovals)
-		free(ovals);
+	free(ovals);
 
 	bw_stat = calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev);
 	if (bw_stat) {
@@ -1208,7 +1206,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	double mean, dev, iops;
 	unsigned int len;
 	int i;
-	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object = NULL;
+	struct json_object *dir_object, *tmp_object, *percentile_object = NULL,
+		*clat_bins_object = NULL;
 	char buf[120];
 	double p_of_agg = 100.0;
 
@@ -1303,29 +1302,34 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	} else
 		len = 0;
 
-	percentile_object = json_create_object();
-	if (ts->clat_percentiles)
+	if (ts->clat_percentiles) {
+		percentile_object = json_create_object();
 		json_object_add_value_object(tmp_object, "percentile", percentile_object);
-	for (i = 0; i < len; i++) {
-		snprintf(buf, sizeof(buf), "%f", ts->percentile_list[i].u.f);
-		json_object_add_value_int(percentile_object, (const char *)buf, ovals[i]);
+		for (i = 0; i < len; i++) {
+			snprintf(buf, sizeof(buf), "%f",
+				 ts->percentile_list[i].u.f);
+			json_object_add_value_int(percentile_object, buf,
+						  ovals[i]);
+		}
 	}
 
-	if (output_format & FIO_OUTPUT_JSON_PLUS) {
+	free(ovals);
+
+	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->clat_percentiles) {
 		clat_bins_object = json_create_object();
-		if (ts->clat_percentiles)
-			json_object_add_value_object(tmp_object, "bins", clat_bins_object);
+		json_object_add_value_object(tmp_object, "bins",
+					     clat_bins_object);
 
 		for(i = 0; i < FIO_IO_U_PLAT_NR; i++) {
 			if (ddir_rw(ddir)) {
 				if (ts->io_u_plat[ddir][i]) {
 					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
-					json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_plat[ddir][i]);
+					json_object_add_value_int(clat_bins_object, buf, ts->io_u_plat[ddir][i]);
 				}
 			} else {
 				if (ts->io_u_sync_plat[i]) {
 					snprintf(buf, sizeof(buf), "%llu", plat_idx_to_val(i));
-					json_object_add_value_int(clat_bins_object, (const char *)buf, ts->io_u_sync_plat[i]);
+					json_object_add_value_int(clat_bins_object, buf, ts->io_u_sync_plat[i]);
 				}
 			}
 		}
@@ -1349,9 +1353,6 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	if (output_format & FIO_OUTPUT_JSON_PLUS && ts->lat_percentiles)
 		json_object_add_value_object(tmp_object, "bins", clat_bins_object);
 
-	if (ovals)
-		free(ovals);
-
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		if (rs->agg[ddir]) {
 			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
@@ -1661,7 +1662,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 				snprintf(buf, sizeof(buf), "%f",
 					 ts->percentile_list[i].u.f);
 				json_object_add_value_int(percentile_object,
-							  (const char *)buf,
+							  buf,
 							  percentiles[i]);
 			}
 

