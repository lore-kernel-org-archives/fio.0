Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55242 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeHZPml (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Aug 2018 11:42:41 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1fttiM-0004pT-62
        for fio@vger.kernel.org; Sun, 26 Aug 2018 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180826120001.E39AC2C013C@kernel.dk>
Date: Sun, 26 Aug 2018 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 632b28a93154cb1be203d911f758d5932c0a8f86:

  Merge branch 'master' of https://github.com/bvanassche/fio (2018-08-24 18:22:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 26b3a1880d38bc24b633a643339c9ca31f303d1c:

  Make td_io_u_lock/unlock() explicit (2018-08-25 10:22:31 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Make td_io_u_lock/unlock() explicit

Tomohiro Kusumi (1):
      client: suppress non JSON default outputs on --output-format=json/json+

 client.c      | 19 ++++++++++++++-----
 fio.h         | 10 ++++------
 io_u.c        | 26 ++++++++++++++++++++------
 stat.c        | 44 ++++++++++++++++++++++++++++++++------------
 steadystate.c |  9 +++++++--
 5 files changed, 77 insertions(+), 31 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index bc0275b..a868e3a 100644
--- a/client.c
+++ b/client.c
@@ -32,6 +32,7 @@ static void handle_stop(struct fio_client *client);
 static void handle_start(struct fio_client *client, struct fio_net_cmd *cmd);
 
 static void convert_text(struct fio_net_cmd *cmd);
+static void client_display_thread_status(struct jobs_eta *je);
 
 struct client_ops fio_client_ops = {
 	.text		= handle_text,
@@ -40,7 +41,7 @@ struct client_ops fio_client_ops = {
 	.group_stats	= handle_gs,
 	.stop		= handle_stop,
 	.start		= handle_start,
-	.eta		= display_thread_status,
+	.eta		= client_display_thread_status,
 	.probe		= handle_probe,
 	.eta_msec	= FIO_CLIENT_DEF_ETA_MSEC,
 	.client_type	= FIO_CLIENT_TYPE_CLI,
@@ -1195,7 +1196,8 @@ static void handle_du(struct fio_client *client, struct fio_net_cmd *cmd)
 
 	if (!client->disk_stats_shown) {
 		client->disk_stats_shown = true;
-		log_info("\nDisk stats (read/write):\n");
+		if (!(output_format & FIO_OUTPUT_JSON))
+			log_info("\nDisk stats (read/write):\n");
 	}
 
 	if (output_format & FIO_OUTPUT_JSON) {
@@ -1477,9 +1479,10 @@ static void handle_probe(struct fio_client *client, struct fio_net_cmd *cmd)
 	sprintf(bit, "%d-bit", probe->bpp * 8);
 	probe->flags = le64_to_cpu(probe->flags);
 
-	log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
-		probe->hostname, probe->bigendian, bit, os, arch,
-		probe->fio_version, (unsigned long) probe->flags);
+	if (!(output_format & FIO_OUTPUT_JSON))
+		log_info("hostname=%s, be=%u, %s, os=%s, arch=%s, fio=%s, flags=%lx\n",
+			probe->hostname, probe->bigendian, bit, os, arch,
+			probe->fio_version, (unsigned long) probe->flags);
 
 	if (!client->name)
 		client->name = strdup((char *) probe->hostname);
@@ -2112,3 +2115,9 @@ int fio_handle_clients(struct client_ops *ops)
 	free(pfds);
 	return retval || error_clients;
 }
+
+static void client_display_thread_status(struct jobs_eta *je)
+{
+	if (!(output_format & FIO_OUTPUT_JSON))
+		display_thread_status(je);
+}
diff --git a/fio.h b/fio.h
index 42015d3..9e99da1 100644
--- a/fio.h
+++ b/fio.h
@@ -774,16 +774,14 @@ static inline bool td_async_processing(struct thread_data *td)
  * We currently only need to do locking if we have verifier threads
  * accessing our internal structures too
  */
-static inline void td_io_u_lock(struct thread_data *td)
+static inline void __td_io_u_lock(struct thread_data *td)
 {
-	if (td_async_processing(td))
-		pthread_mutex_lock(&td->io_u_lock);
+	pthread_mutex_lock(&td->io_u_lock);
 }
 
-static inline void td_io_u_unlock(struct thread_data *td)
+static inline void __td_io_u_unlock(struct thread_data *td)
 {
-	if (td_async_processing(td))
-		pthread_mutex_unlock(&td->io_u_lock);
+	pthread_mutex_unlock(&td->io_u_lock);
 }
 
 static inline void td_io_u_free_notify(struct thread_data *td)
diff --git a/io_u.c b/io_u.c
index 3fbcf0f..a3540d1 100644
--- a/io_u.c
+++ b/io_u.c
@@ -768,6 +768,8 @@ void put_file_log(struct thread_data *td, struct fio_file *f)
 
 void put_io_u(struct thread_data *td, struct io_u *io_u)
 {
+	const bool needs_lock = td_async_processing(td);
+
 	if (io_u->post_submit) {
 		io_u->post_submit(io_u, io_u->error == 0);
 		io_u->post_submit = NULL;
@@ -776,7 +778,8 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 	if (td->parent)
 		td = td->parent;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	if (io_u->file && !(io_u->flags & IO_U_F_NO_FILE_PUT))
 		put_file_log(td, io_u->file);
@@ -790,7 +793,9 @@ void put_io_u(struct thread_data *td, struct io_u *io_u)
 	}
 	io_u_qpush(&td->io_u_freelist, io_u);
 	td_io_u_free_notify(td);
-	td_io_u_unlock(td);
+
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 void clear_io_u(struct thread_data *td, struct io_u *io_u)
@@ -801,6 +806,7 @@ void clear_io_u(struct thread_data *td, struct io_u *io_u)
 
 void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct io_u *__io_u = *io_u;
 	enum fio_ddir ddir = acct_ddir(__io_u);
 
@@ -809,7 +815,8 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 	if (td->parent)
 		td = td->parent;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	io_u_set(td, __io_u, IO_U_F_FREE);
 	if ((__io_u->flags & IO_U_F_FLIGHT) && ddir_rw(ddir))
@@ -823,7 +830,10 @@ void requeue_io_u(struct thread_data *td, struct io_u **io_u)
 
 	io_u_rpush(&td->io_u_requeues, __io_u);
 	td_io_u_free_notify(td);
-	td_io_u_unlock(td);
+
+	if (needs_lock)
+		__td_io_u_unlock(td);
+
 	*io_u = NULL;
 }
 
@@ -1504,13 +1514,15 @@ bool queue_full(const struct thread_data *td)
 
 struct io_u *__get_io_u(struct thread_data *td)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct io_u *io_u = NULL;
 	int ret;
 
 	if (td->stop_io)
 		return NULL;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 again:
 	if (!io_u_rempty(&td->io_u_requeues))
@@ -1547,7 +1559,9 @@ again:
 		goto again;
 	}
 
-	td_io_u_unlock(td);
+	if (needs_lock)
+		__td_io_u_unlock(td);
+
 	return io_u;
 }
 
diff --git a/stat.c b/stat.c
index abdbb0e..1a9c553 100644
--- a/stat.c
+++ b/stat.c
@@ -2475,11 +2475,13 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long long nsec, unsigned long long bs,
 		     uint64_t offset)
 {
+	const bool needs_lock = td_async_processing(td);
 	unsigned long elapsed, this_window;
 	struct thread_stat *ts = &td->ts;
 	struct io_log *iolog = td->clat_hist_log;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	add_stat_sample(&ts->clat_stat[ddir], nsec);
 
@@ -2528,37 +2530,43 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		}
 	}
 
-	td_io_u_unlock(td);
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long usec, unsigned long long bs, uint64_t offset)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
 
 	if (!ddir_rw(ddir))
 		return;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
 	if (td->slat_log)
 		add_log_sample(td, td->slat_log, sample_val(usec), ddir, bs, offset);
 
-	td_io_u_unlock(td);
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 		    unsigned long long nsec, unsigned long long bs,
 		    uint64_t offset)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
 
 	if (!ddir_rw(ddir))
 		return;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	add_stat_sample(&ts->lat_stat[ddir], nsec);
 
@@ -2569,12 +2577,14 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	if (ts->lat_percentiles)
 		add_clat_percentile_sample(ts, nsec, ddir);
 
-	td_io_u_unlock(td);
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 		   unsigned int bytes, unsigned long long spent)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
 	unsigned long rate;
 
@@ -2583,7 +2593,8 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 	else
 		rate = 0;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
 
@@ -2592,7 +2603,9 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 			       bytes, io_u->offset);
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
-	td_io_u_unlock(td);
+
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
@@ -2601,6 +2614,7 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 			 struct io_stat *stat, struct io_log *log,
 			 bool is_kb)
 {
+	const bool needs_lock = td_async_processing(td);
 	unsigned long spent, rate;
 	enum fio_ddir ddir;
 	unsigned long next, next_log;
@@ -2611,7 +2625,8 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 	if (spent < avg_time && avg_time - spent >= LOG_MSEC_SLACK)
 		return avg_time - spent;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	/*
 	 * Compute both read and write rates for the interval.
@@ -2648,7 +2663,8 @@ static int __add_samples(struct thread_data *td, struct timespec *parent_tv,
 
 	timespec_add_msec(parent_tv, avg_time);
 
-	td_io_u_unlock(td);
+	if (needs_lock)
+		__td_io_u_unlock(td);
 
 	if (spent <= avg_time)
 		next = avg_time;
@@ -2668,9 +2684,11 @@ static int add_bw_samples(struct thread_data *td, struct timespec *t)
 void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 		     unsigned int bytes)
 {
+	const bool needs_lock = td_async_processing(td);
 	struct thread_stat *ts = &td->ts;
 
-	td_io_u_lock(td);
+	if (needs_lock)
+		__td_io_u_lock(td);
 
 	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
 
@@ -2679,7 +2697,9 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 			       bytes, io_u->offset);
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
-	td_io_u_unlock(td);
+
+	if (needs_lock)
+		__td_io_u_unlock(td);
 }
 
 static int add_iops_samples(struct thread_data *td, struct timespec *t)
diff --git a/steadystate.c b/steadystate.c
index ee1c0e5..bd2f70d 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -208,6 +208,7 @@ void steadystate_check(void)
 
 	prev_groupid = -1;
 	for_each_td(td, i) {
+		const bool needs_lock = td_async_processing(td);
 		struct steadystate_data *ss = &td->ss;
 
 		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
@@ -235,12 +236,16 @@ void steadystate_check(void)
 				ss->state |= FIO_SS_RAMP_OVER;
 		}
 
-		td_io_u_lock(td);
+		if (needs_lock)
+			__td_io_u_lock(td);
+
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			td_iops += td->io_blocks[ddir];
 			td_bytes += td->io_bytes[ddir];
 		}
-		td_io_u_unlock(td);
+
+		if (needs_lock)
+			__td_io_u_unlock(td);
 
 		rate_time = mtime_since(&ss->prev_time, &now);
 		memcpy(&ss->prev_time, &now, sizeof(now));

