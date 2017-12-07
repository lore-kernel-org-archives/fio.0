Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51653 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754243AbdLGNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Dec 2017 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eMvmX-0002W0-UN
        for fio@vger.kernel.org; Thu, 07 Dec 2017 13:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20171207130001.DD5822C0098@kernel.dk>
Date: Thu,  7 Dec 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 67bfebe6af2e6d030ec739fa45ccb211f3e50a0e:

  Merge branch 'wip-cleanup' of https://github.com/ZVampirEM77/fio (2017-12-03 10:11:53 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 395feabb53806d5cff2e0b73b6c94048f05b5aae:

  io_u: rate cleanup and spelling error (2017-12-06 12:30:20 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      Add option to ignore thinktime for rated IO
      io_u: rate cleanup and spelling error

 HOWTO            |  7 +++++++
 backend.c        | 61 +++++++++++++++++++++++++++++++++++---------------------
 cconv.c          |  2 ++
 fio.1            |  6 ++++++
 io_u.c           |  9 ++++-----
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 thread_options.h |  3 +++
 8 files changed, 71 insertions(+), 29 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 4caaf54..563ca93 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2208,6 +2208,13 @@ I/O rate
 	(https://en.wikipedia.org/wiki/Poisson_point_process). The lambda will be
 	10^6 / IOPS for the given workload.
 
+.. option:: rate_ignore_thinktime=bool
+
+	By default, fio will attempt to catch up to the specified rate setting,
+	if any kind of thinktime setting was used. If this option is set, then
+	fio will ignore the thinktime and continue doing IO at the specified
+	rate, instead of entering a catch-up mode after thinktime is done.
+
 
 I/O latency
 ~~~~~~~~~~~
diff --git a/backend.c b/backend.c
index 6c805c7..69f03dc 100644
--- a/backend.c
+++ b/backend.c
@@ -844,14 +844,13 @@ static bool io_complete_bytes_exceeded(struct thread_data *td)
  */
 static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 {
-	uint64_t secs, remainder, bps, bytes, iops;
+	uint64_t bps = td->rate_bps[ddir];
 
 	assert(!(td->flags & TD_F_CHILD));
-	bytes = td->rate_io_issue_bytes[ddir];
-	bps = td->rate_bps[ddir];
 
 	if (td->o.rate_process == RATE_PROCESS_POISSON) {
-		uint64_t val;
+		uint64_t val, iops;
+
 		iops = bps / td->o.bs[ddir];
 		val = (int64_t) (1000000 / iops) *
 				-logf(__rand_0_1(&td->poisson_state[ddir]));
@@ -863,14 +862,44 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 		td->last_usec[ddir] += val;
 		return td->last_usec[ddir];
 	} else if (bps) {
-		secs = bytes / bps;
-		remainder = bytes % bps;
+		uint64_t bytes = td->rate_io_issue_bytes[ddir];
+		uint64_t secs = bytes / bps;
+		uint64_t remainder = bytes % bps;
+
 		return remainder * 1000000 / bps + secs * 1000000;
 	}
 
 	return 0;
 }
 
+static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
+{
+	unsigned long long b;
+	uint64_t total;
+	int left;
+
+	b = ddir_rw_sum(td->io_blocks);
+	if (b % td->o.thinktime_blocks)
+		return;
+
+	io_u_quiesce(td);
+
+	total = 0;
+	if (td->o.thinktime_spin)
+		total = usec_spin(td->o.thinktime_spin);
+
+	left = td->o.thinktime - total;
+	if (left)
+		total += usec_sleep(td, left);
+
+	/*
+	 * If we're ignoring thinktime for the rate, add the number of bytes
+	 * we would have done while sleeping.
+	 */
+	if (total && td->rate_bps[ddir] && td->o.rate_ign_think)
+		td->rate_io_issue_bytes[ddir] += (td->rate_bps[ddir] * 1000000) / total;
+}
+
 /*
  * Main IO worker function. It retrieves io_u's to process and queues
  * and reaps them, checking for rate and errors along the way.
@@ -955,6 +984,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			int err = PTR_ERR(io_u);
 
 			io_u = NULL;
+			ddir = DDIR_INVAL;
 			if (err == -EBUSY) {
 				ret = FIO_Q_BUSY;
 				goto reap;
@@ -1062,23 +1092,8 @@ reap:
 		if (!in_ramp_time(td) && td->o.latency_target)
 			lat_target_check(td);
 
-		if (td->o.thinktime) {
-			unsigned long long b;
-
-			b = ddir_rw_sum(td->io_blocks);
-			if (!(b % td->o.thinktime_blocks)) {
-				int left;
-
-				io_u_quiesce(td);
-
-				if (td->o.thinktime_spin)
-					usec_spin(td->o.thinktime_spin);
-
-				left = td->o.thinktime - td->o.thinktime_spin;
-				if (left)
-					usec_sleep(td, left);
-			}
-		}
+		if (ddir_rw(ddir) && td->o.thinktime)
+			handle_thinktime(td, ddir);
 	}
 
 	check_update_rusage(td);
diff --git a/cconv.c b/cconv.c
index 5ed4640..92996b1 100644
--- a/cconv.c
+++ b/cconv.c
@@ -298,6 +298,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 
 	o->trim_backlog = le64_to_cpu(top->trim_backlog);
 	o->rate_process = le32_to_cpu(top->rate_process);
+	o->rate_ign_think = le32_to_cpu(top->rate_ign_think);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->percentile_list[i].u.f = fio_uint64_to_double(le64_to_cpu(top->percentile_list[i].u.i));
@@ -557,6 +558,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->offset_increment = __cpu_to_le64(o->offset_increment);
 	top->number_ios = __cpu_to_le64(o->number_ios);
 	top->rate_process = cpu_to_le32(o->rate_process);
+	top->rate_ign_think = cpu_to_le32(o->rate_ign_think);
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->percentile_list[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->percentile_list[i].u.f));
diff --git a/fio.1 b/fio.1
index 54d1b0f..80abc14 100644
--- a/fio.1
+++ b/fio.1
@@ -1955,6 +1955,12 @@ I/Os that gets adjusted based on I/O completion rates. If this is set to
 flow, known as the Poisson process
 (\fIhttps://en.wikipedia.org/wiki/Poisson_point_process\fR). The lambda will be
 10^6 / IOPS for the given workload.
+.TP
+.BI rate_ignore_thinktime \fR=\fPbool
+By default, fio will attempt to catch up to the specified rate setting, if any
+kind of thinktime setting was used. If this option is set, then fio will
+ignore the thinktime and continue doing IO at the specified rate, instead of
+entering a catch-up mode after thinktime is done.
 .SS "I/O latency"
 .TP
 .BI latency_target \fR=\fPtime
diff --git a/io_u.c b/io_u.c
index 44933a1..42d98eb 100644
--- a/io_u.c
+++ b/io_u.c
@@ -759,11 +759,11 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 			return odir;
 
 		/*
-		 * Both directions are ahead of rate. sleep the min
-		 * switch if necissary
+		 * Both directions are ahead of rate. sleep the min,
+		 * switch if necessary
 		 */
 		if (td->rate_next_io_time[ddir] <=
-			td->rate_next_io_time[odir]) {
+		    td->rate_next_io_time[odir]) {
 			usec = td->rate_next_io_time[ddir] - now;
 		} else {
 			usec = td->rate_next_io_time[odir] - now;
@@ -775,8 +775,7 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	if (td->o.io_submit_mode == IO_MODE_INLINE)
 		io_u_quiesce(td);
 
-	usec = usec_sleep(td, usec);
-
+	usec_sleep(td, usec);
 	return ddir;
 }
 
diff --git a/options.c b/options.c
index 3fa646c..9a3431d 100644
--- a/options.c
+++ b/options.c
@@ -3460,6 +3460,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_RATE,
 	},
 	{
+		.name	= "rate_ignore_thinktime",
+		.lname	= "Rate ignore thinktime",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, rate_ign_think),
+		.help	= "Rated IO ignores thinktime settings",
+		.parent = "rate",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_RATE,
+	},
+	{
 		.name	= "max_latency",
 		.lname	= "Max Latency (usec)",
 		.type	= FIO_OPT_STR_VAL_TIME,
diff --git a/server.h b/server.h
index 438a6c3..1a9b650 100644
--- a/server.h
+++ b/server.h
@@ -49,7 +49,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 68,
+	FIO_SERVER_VER			= 69,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 793df8a..dc290b0 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -273,6 +273,7 @@ struct thread_options {
 	unsigned int rate_iops[DDIR_RWDIR_CNT];
 	unsigned int rate_iops_min[DDIR_RWDIR_CNT];
 	unsigned int rate_process;
+	unsigned int rate_ign_think;
 
 	char *ioscheduler;
 
@@ -547,6 +548,8 @@ struct thread_options_pack {
 	uint32_t rate_iops[DDIR_RWDIR_CNT];
 	uint32_t rate_iops_min[DDIR_RWDIR_CNT];
 	uint32_t rate_process;
+	uint32_t rate_ign_think;
+	uint32_t pad;
 
 	uint8_t ioscheduler[FIO_TOP_STR_MAX];
 
