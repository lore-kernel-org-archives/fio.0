Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38293 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAZNAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 26 Jan 2018 08:00:11 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.89 #1 (Red Hat Linux))
        id 1ef3c2-0004k8-LM
        for fio@vger.kernel.org; Fri, 26 Jan 2018 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180126130001.AAD4D2C0092@kernel.dk>
Date: Fri, 26 Jan 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2ea93f982e728343f823c2cf63b4674a104575bf:

  Switch last_was_sync and terminate to bool and pack better (2018-01-24 20:22:50 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f5ec81235eaf21bd3a97556427d4a84e48a87e54:

  stat: add total fsync ios to json output (2018-01-25 16:04:20 -0700)

----------------------------------------------------------------
Jens Axboe (5):
      Track fsync/fdatasync/sync_file_range issue count
      stat: ensure that we align ts->sync_stat appropriately
      io_ddir: move count values out of the enum fio_ddir
      io_ddir: revert separate ddir count change
      stat: add total fsync ios to json output

 init.c      |  1 +
 io_ddir.h   |  4 +++-
 ioengines.c |  4 ++--
 stat.c      | 13 ++++++++++---
 stat.h      |  4 ++--
 5 files changed, 18 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 8a80138..ae3c4f7 100644
--- a/init.c
+++ b/init.c
@@ -1481,6 +1481,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td->ts.bw_stat[i].min_val = ULONG_MAX;
 		td->ts.iops_stat[i].min_val = ULONG_MAX;
 	}
+	td->ts.sync_stat.min_val = ULONG_MAX;
 	td->ddir_seq_nr = o->ddir_seq_nr;
 
 	if ((o->stonewall || o->new_group) && prev_group_jobs) {
diff --git a/io_ddir.h b/io_ddir.h
index 613d5fb..deaa8b5 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -5,13 +5,15 @@ enum fio_ddir {
 	DDIR_READ = 0,
 	DDIR_WRITE = 1,
 	DDIR_TRIM = 2,
-	DDIR_RWDIR_CNT = 3,
 	DDIR_SYNC = 3,
 	DDIR_DATASYNC,
 	DDIR_SYNC_FILE_RANGE,
 	DDIR_WAIT,
 	DDIR_LAST,
 	DDIR_INVAL = -1,
+
+	DDIR_RWDIR_CNT = 3,
+	DDIR_RWDIR_SYNC_CNT = 4,
 };
 
 static inline const char *io_ddir_name(enum fio_ddir ddir)
diff --git a/ioengines.c b/ioengines.c
index fb475e9..5dd2311 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -357,7 +357,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (ret == FIO_Q_COMPLETED) {
-		if (ddir_rw(io_u->ddir)) {
+		if (ddir_rw(io_u->ddir) || ddir_sync(io_u->ddir)) {
 			io_u_mark_depth(td, 1);
 			td->ts.total_io_u[io_u->ddir]++;
 		}
@@ -366,7 +366,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 		td->io_u_queued++;
 
-		if (ddir_rw(io_u->ddir))
+		if (ddir_rw(io_u->ddir) || ddir_sync(io_u->ddir))
 			td->ts.total_io_u[io_u->ddir]++;
 
 		if (td->io_u_queued >= td->o.iodepth_batch) {
diff --git a/stat.c b/stat.c
index 3a014d6..a980a1d 100644
--- a/stat.c
+++ b/stat.c
@@ -854,12 +854,13 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
-	log_buf(out, "     issued rwt: total=%llu,%llu,%llu,"
-				 " short=%llu,%llu,%llu,"
-				 " dropped=%llu,%llu,%llu\n",
+	log_buf(out, "     issued rwts: total=%llu,%llu,%llu,%llu"
+				 " short=%llu,%llu,%llu,0"
+				 " dropped=%llu,%llu,%llu,0\n",
 					(unsigned long long) ts->total_io_u[0],
 					(unsigned long long) ts->total_io_u[1],
 					(unsigned long long) ts->total_io_u[2],
+					(unsigned long long) ts->total_io_u[3],
 					(unsigned long long) ts->short_io_u[0],
 					(unsigned long long) ts->short_io_u[1],
 					(unsigned long long) ts->short_io_u[2],
@@ -1048,6 +1049,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 
 		tmp_object = json_create_object();
 		json_object_add_value_object(dir_object, "lat_ns", tmp_object);
+		json_object_add_value_int(dir_object, "total_ios", ts->total_io_u[DDIR_SYNC]);
 		json_object_add_value_int(tmp_object, "min", min);
 		json_object_add_value_int(tmp_object, "max", max);
 		json_object_add_value_float(tmp_object, "mean", mean);
@@ -1609,6 +1611,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 		}
 	}
 
+	dst->total_io_u[DDIR_SYNC] += src->total_io_u[DDIR_SYNC];
+
 	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
 		int m;
 
@@ -1647,6 +1651,7 @@ void init_thread_stat(struct thread_stat *ts)
 		ts->bw_stat[j].min_val = -1UL;
 		ts->iops_stat[j].min_val = -1UL;
 	}
+	ts->sync_stat.min_val = -1UL;
 	ts->groupid = -1;
 }
 
@@ -2287,6 +2292,8 @@ void reset_io_stats(struct thread_data *td)
 		}
 	}
 
+	ts->total_io_u[DDIR_SYNC] = 0;
+
 	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
 		ts->io_u_map[i] = 0;
 		ts->io_u_submit[i] = 0;
diff --git a/stat.h b/stat.h
index e32a21e..cc91dfc 100644
--- a/stat.h
+++ b/stat.h
@@ -159,10 +159,10 @@ struct thread_stat {
 	/*
 	 * bandwidth and latency stats
 	 */
+	struct io_stat sync_stat __attribute__((aligned(8)));/* fsync etc stats */
 	struct io_stat clat_stat[DDIR_RWDIR_CNT]; /* completion latency */
 	struct io_stat slat_stat[DDIR_RWDIR_CNT]; /* submission latency */
 	struct io_stat lat_stat[DDIR_RWDIR_CNT]; /* total latency */
-	struct io_stat sync_stat;		/* fsync etc stats */
 	struct io_stat bw_stat[DDIR_RWDIR_CNT]; /* bandwidth stats */
 	struct io_stat iops_stat[DDIR_RWDIR_CNT]; /* IOPS stats */
 
@@ -192,7 +192,7 @@ struct thread_stat {
 	uint32_t io_u_sync_plat[FIO_IO_U_PLAT_NR];
 	uint32_t pad;
 
-	uint64_t total_io_u[DDIR_RWDIR_CNT];
+	uint64_t total_io_u[DDIR_RWDIR_SYNC_CNT];
 	uint64_t short_io_u[DDIR_RWDIR_CNT];
 	uint64_t drop_io_u[DDIR_RWDIR_CNT];
 	uint64_t total_submit;
