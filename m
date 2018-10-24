Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50598 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726899AbeJXU2H (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Oct 2018 16:28:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gFHpg-0008RU-Pe
        for fio@vger.kernel.org; Wed, 24 Oct 2018 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181024120002.0E3132C008B@kernel.dk>
Date: Wed, 24 Oct 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 307f2246d65d9dbea7e5f56cd17734cb68c2817f:

  docs: serialize_overlap=1 with io_submit_mode=offload no longer requires threads (2018-10-19 11:09:23 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d7e92306bde2117702ed96b7c5647d9485869047:

  io_u: move trim error notification out-of-line (2018-10-24 05:00:53 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      stat: use helper for IO direction name
      io_u: move trim error notification out-of-line

 io_u.c | 24 ++++++++++++------------
 stat.c | 10 ++++------
 2 files changed, 16 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/io_u.c b/io_u.c
index a3540d1..56abe6f 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1798,6 +1798,16 @@ static inline bool gtod_reduce(struct thread_data *td)
 			|| td->o.gtod_reduce;
 }
 
+static void trim_block_info(struct thread_data *td, struct io_u *io_u)
+{
+	uint32_t *info = io_u_block_info(td, io_u);
+
+	if (BLOCK_INFO_STATE(*info) >= BLOCK_STATE_TRIM_FAILURE)
+		return;
+
+	*info = BLOCK_INFO(BLOCK_STATE_TRIMMED, BLOCK_INFO_TRIMS(*info) + 1);
+}
+
 static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 				  struct io_completion_data *icd,
 				  const enum fio_ddir idx, unsigned int bytes)
@@ -1849,18 +1859,8 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	} else if (ddir_sync(idx) && !td->o.disable_clat)
 		add_sync_clat_sample(&td->ts, llnsec);
 
-	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
-		uint32_t *info = io_u_block_info(td, io_u);
-		if (BLOCK_INFO_STATE(*info) < BLOCK_STATE_TRIM_FAILURE) {
-			if (io_u->ddir == DDIR_TRIM) {
-				*info = BLOCK_INFO(BLOCK_STATE_TRIMMED,
-						BLOCK_INFO_TRIMS(*info) + 1);
-			} else if (io_u->ddir == DDIR_WRITE) {
-				*info = BLOCK_INFO_SET_STATE(BLOCK_STATE_WRITTEN,
-								*info);
-			}
-		}
-	}
+	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM)
+		trim_block_info(td, io_u);
 }
 
 static void file_log_write_comp(const struct thread_data *td, struct fio_file *f,
diff --git a/stat.c b/stat.c
index ef9c4af..331abf6 100644
--- a/stat.c
+++ b/stat.c
@@ -416,7 +416,6 @@ static void display_lat(const char *name, unsigned long long min,
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
-	const char *str[] = { " read", "write", " trim", "sync" };
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
@@ -426,12 +425,12 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	if (ddir_sync(ddir)) {
 		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
 			log_buf(out, "  %s:\n", "fsync/fdatasync/sync_file_range");
-			display_lat(str[ddir], min, max, mean, dev, out);
+			display_lat(io_ddir_name(ddir), min, max, mean, dev, out);
 			show_clat_percentiles(ts->io_u_sync_plat,
 						ts->sync_stat.samples,
 						ts->percentile_list,
 						ts->percentile_precision,
-						str[ddir], out);
+						io_ddir_name(ddir), out);
 		}
 		return;
 	}
@@ -455,7 +454,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		zbd_w_st = zbd_write_status(ts);
 
 	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
-			rs->unified_rw_rep ? "mixed" : str[ddir],
+			rs->unified_rw_rep ? "mixed" : io_ddir_name(ddir),
 			iops_p, bw_p, bw_p_alt, io_p,
 			(unsigned long long) ts->runtime[ddir],
 			zbd_w_st ? : "");
@@ -985,7 +984,6 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	double mean, dev, iops;
 	unsigned int len;
 	int i;
-	const char *ddirname[] = { "read", "write", "trim", "sync" };
 	struct json_object *dir_object, *tmp_object, *percentile_object, *clat_bins_object = NULL;
 	char buf[120];
 	double p_of_agg = 100.0;
@@ -997,7 +995,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 	dir_object = json_create_object();
 	json_object_add_value_object(parent,
-		ts->unified_rw_rep ? "mixed" : ddirname[ddir], dir_object);
+		ts->unified_rw_rep ? "mixed" : io_ddir_name(ddir), dir_object);
 
 	if (ddir_rw(ddir)) {
 		bw_bytes = 0;

