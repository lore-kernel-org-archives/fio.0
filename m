Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47306 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbbLJNAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Dec 2015 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a6fEs-0000V2-UT
	for fio@vger.kernel.org; Wed, 09 Dec 2015 13:57:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151210130002.AAF692C015D@kernel.dk>
Date: Thu, 10 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c08f9fe23b0f257f914b2d9e0e4f1117418e5da6:

  options: add log_compression_cpus option (2015-12-08 15:45:12 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c5103619279883ee9291ed4793bb6ad39b436101:

  eta: use bool for forcing jobs_eta return (2015-12-09 12:44:09 -0700)

----------------------------------------------------------------
Jens Axboe (8):
      backend: terminate loop if we didn't do IO
      Fix ramp time for io_submit_mode=offload
      eta: fix comparison reversal for time based jobs
      iolog: don't copy log samples for compression
      thread_options: kill converted cpu masks
      server: always end back ETA reply
      server: ensure we send the right sized jobs_eta when faking it
      eta: use bool for forcing jobs_eta return

 backend.c        |  5 ++++-
 eta.c            |  6 +++---
 iolog.c          | 22 +++++++++-------------
 server.c         | 50 ++++++++++++++++++++++++++++----------------------
 stat.c           |  2 +-
 stat.h           |  2 +-
 thread_options.h |  5 +++++
 time.c           | 13 +++++++++++++
 8 files changed, 64 insertions(+), 41 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index ae26120..425b0ee 100644
--- a/backend.c
+++ b/backend.c
@@ -1587,8 +1587,11 @@ static void *thread_main(void *data)
 
 		if (td->o.verify_only && (td_write(td) || td_rw(td)))
 			verify_bytes = do_dry_run(td);
-		else
+		else {
 			verify_bytes = do_io(td);
+			if (!verify_bytes)
+				fio_mark_td_terminate(td);
+		}
 
 		clear_state = 1;
 
diff --git a/eta.c b/eta.c
index 8785540..ffab34e 100644
--- a/eta.c
+++ b/eta.c
@@ -214,7 +214,7 @@ static unsigned long thread_eta(struct thread_data *td)
 		if (td->o.time_based) {
 			if (timeout) {
 				perc_t = (double) elapsed / (double) timeout;
-				if (perc_t > perc)
+				if (perc_t < perc)
 					perc = perc_t;
 			} else {
 				/*
@@ -589,7 +589,7 @@ void display_thread_status(struct jobs_eta *je)
 	fflush(stdout);
 }
 
-struct jobs_eta *get_jobs_eta(int force, size_t *size)
+struct jobs_eta *get_jobs_eta(bool force, size_t *size)
 {
 	struct jobs_eta *je;
 
@@ -616,7 +616,7 @@ void print_thread_status(void)
 	struct jobs_eta *je;
 	size_t size;
 
-	je = get_jobs_eta(0, &size);
+	je = get_jobs_eta(false, &size);
 	if (je)
 		display_thread_status(je);
 
diff --git a/iolog.c b/iolog.c
index 27d00ff..e674171 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1154,15 +1154,15 @@ void iolog_compress_exit(struct thread_data *td)
 }
 
 /*
- * Queue work item to compress the existing log entries. We copy the
- * samples, and reset the log sample count to 0 (so the logging will
- * continue to use the memory associated with the log). If called with
- * wait == 1, will not return until the log compression has completed.
+ * Queue work item to compress the existing log entries. We reset the
+ * current log to a small size, and reference the existing log in the
+ * data that we queue for compression. Once compression has been done,
+ * this old log is freed. If called with wait == 1, will not return until
+ * the log compression has completed.
  */
 int iolog_flush(struct io_log *log, int wait)
 {
 	struct iolog_flush_data *data;
-	size_t sample_size;
 
 	data = malloc(sizeof(*data));
 	if (!data)
@@ -1170,16 +1170,12 @@ int iolog_flush(struct io_log *log, int wait)
 
 	data->log = log;
 
-	sample_size = log->nr_samples * log_entry_sz(log);
-	data->samples = malloc(sample_size);
-	if (!data->samples) {
-		free(data);
-		return 1;
-	}
-
-	memcpy(data->samples, log->log, sample_size);
+	data->samples = log->log;
 	data->nr_samples = log->nr_samples;
+
 	log->nr_samples = 0;
+	log->max_samples = 128;
+	log->log = malloc(log->max_samples * log_entry_sz(log));
 
 	data->wait = wait;
 	if (data->wait) {
diff --git a/server.c b/server.c
index 18b3a08..cf01733 100644
--- a/server.c
+++ b/server.c
@@ -709,33 +709,39 @@ static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
 	size_t size;
 	int i;
 
-	je = get_jobs_eta(1, &size);
-	if (!je)
-		return 0;
-
 	dprint(FD_NET, "server sending status\n");
 
-	je->nr_running		= cpu_to_le32(je->nr_running);
-	je->nr_ramp		= cpu_to_le32(je->nr_ramp);
-	je->nr_pending		= cpu_to_le32(je->nr_pending);
-	je->nr_setting_up	= cpu_to_le32(je->nr_setting_up);
-	je->files_open		= cpu_to_le32(je->files_open);
+	/*
+	 * Fake ETA return if we don't have a local one, otherwise the client
+	 * will end up timing out waiting for a response to the ETA request
+	 */
+	je = get_jobs_eta(true, &size);
+	if (!je) {
+		size = sizeof(*je);
+		je = calloc(1, size);
+	} else {
+		je->nr_running		= cpu_to_le32(je->nr_running);
+		je->nr_ramp		= cpu_to_le32(je->nr_ramp);
+		je->nr_pending		= cpu_to_le32(je->nr_pending);
+		je->nr_setting_up	= cpu_to_le32(je->nr_setting_up);
+		je->files_open		= cpu_to_le32(je->files_open);
+
+		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+			je->m_rate[i]	= cpu_to_le32(je->m_rate[i]);
+			je->t_rate[i]	= cpu_to_le32(je->t_rate[i]);
+			je->m_iops[i]	= cpu_to_le32(je->m_iops[i]);
+			je->t_iops[i]	= cpu_to_le32(je->t_iops[i]);
+			je->rate[i]	= cpu_to_le32(je->rate[i]);
+			je->iops[i]	= cpu_to_le32(je->iops[i]);
+		}
 
-	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		je->m_rate[i]	= cpu_to_le32(je->m_rate[i]);
-		je->t_rate[i]	= cpu_to_le32(je->t_rate[i]);
-		je->m_iops[i]	= cpu_to_le32(je->m_iops[i]);
-		je->t_iops[i]	= cpu_to_le32(je->t_iops[i]);
-		je->rate[i]	= cpu_to_le32(je->rate[i]);
-		je->iops[i]	= cpu_to_le32(je->iops[i]);
+		je->elapsed_sec		= cpu_to_le64(je->elapsed_sec);
+		je->eta_sec		= cpu_to_le64(je->eta_sec);
+		je->nr_threads		= cpu_to_le32(je->nr_threads);
+		je->is_pow2		= cpu_to_le32(je->is_pow2);
+		je->unit_base		= cpu_to_le32(je->unit_base);
 	}
 
-	je->elapsed_sec		= cpu_to_le64(je->elapsed_sec);
-	je->eta_sec		= cpu_to_le64(je->eta_sec);
-	je->nr_threads		= cpu_to_le32(je->nr_threads);
-	je->is_pow2		= cpu_to_le32(je->is_pow2);
-	je->unit_base		= cpu_to_le32(je->unit_base);
-
 	fio_net_send_cmd(server_fd, FIO_NET_CMD_ETA, je, size, &tag, NULL);
 	free(je);
 	return 0;
diff --git a/stat.c b/stat.c
index 818756d..ca06617 100644
--- a/stat.c
+++ b/stat.c
@@ -1104,7 +1104,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	json_object_add_value_int(root, "error", ts->error);
 
 	/* ETA Info */
-	je = get_jobs_eta(1, &size);
+	je = get_jobs_eta(true, &size);
 	if (je) {
 		json_object_add_value_int(root, "eta", je->eta_sec);
 		json_object_add_value_int(root, "elapsed", je->elapsed_sec);
diff --git a/stat.h b/stat.h
index 33afd9b..dda88fc 100644
--- a/stat.h
+++ b/stat.h
@@ -242,7 +242,7 @@ struct jobs_eta {
 
 extern struct fio_mutex *stat_mutex;
 
-extern struct jobs_eta *get_jobs_eta(int force, size_t *size);
+extern struct jobs_eta *get_jobs_eta(bool force, size_t *size);
 
 extern void stat_init(void);
 extern void stat_exit(void);
diff --git a/thread_options.h b/thread_options.h
index f9c1562..02c867f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -414,9 +414,14 @@ struct thread_options_pack {
 	uint32_t stonewall;
 	uint32_t new_group;
 	uint32_t numjobs;
+	/*
+	 * We currently can't convert these, so don't enable them
+	 */
+#if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
+#endif
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
diff --git a/time.c b/time.c
index f1833c7..b145e90 100644
--- a/time.c
+++ b/time.c
@@ -80,6 +80,18 @@ int in_ramp_time(struct thread_data *td)
 	return td->o.ramp_time && !td->ramp_time_over;
 }
 
+static void parent_update_ramp(struct thread_data *td)
+{
+	struct thread_data *parent = td->parent;
+
+	if (!parent || parent->ramp_time_over)
+		return;
+
+	reset_all_stats(parent);
+	parent->ramp_time_over = 1;
+	td_set_runstate(parent, TD_RAMP);
+}
+
 int ramp_time_over(struct thread_data *td)
 {
 	struct timeval tv;
@@ -92,6 +104,7 @@ int ramp_time_over(struct thread_data *td)
 		td->ramp_time_over = 1;
 		reset_all_stats(td);
 		td_set_runstate(td, TD_RAMP);
+		parent_update_ramp(td);
 		return 1;
 	}
 
