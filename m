Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF5A4A13A5
	for <fio@vger.kernel.org>; Thu,  8 Jan 2026 13:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767877215; cv=none; b=lr/TeLWK3YOkHehQRNHApWrLk2DCiSgEgOBJARwt0/tbeIAbFBTjSMOKqoNPYU6AP6XbYIJCUK734JXHT00O0VBnxdaleEbPmtu22j/1HuKStzBe9bPDnIlmm/J4XLdh6+YLGwlj7HpaY3qDmphdWKV3qZynpH7GMAr7DkfV5/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767877215; c=relaxed/simple;
	bh=G7ZdgxDo7yErlLh/57sy/uAdey9gTlKsmgU6KLIaYsk=;
	h=Subject:From:To:Date:Message-Id; b=jeszIvaOy+yQYShGsEikrxEkUlrTv/vLyM9fgE2++nSJKwA6X7p1bq7e/PnELPwXGbTIty85GIhkSytWYB7N8YVZaDRUYIVdTt6kWCvXsa/3l/VT5EEtXjVulyqBPO4CerxHQYwdc0xUfqx/zs3qOyo6ro9dR34/C9X9OOZF4rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D9FCYvVb; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D9FCYvVb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=kfRKb+uqPfOTHCg/UiVKzRKf47nMZO9n0d4sktPvGQU=; b=D9FCYvVbeSu5VeP6HexY/Q5x4o
	1VH7+bXryTHcK4+p5pqWD+Dh671WWd+bYS8ZrH2fbkOXQmdF3kUqU2GSbLkFENT14JHfRutTcgNvS
	HCTf2lfaMAkRC3j9If6XBHdL/Dk6xwtUFhTlmYWIrSmn5YzONfKhOd/OZo/1dn0+dzw7LCq83GACt
	ExKpvCK5yq9Wu13GcJzNMKgrzTFfBSQ7yF8wcp7peHRV9M15abW8V3ghzivna9R5c7E03g87lWnUR
	dW754EJZx6j8EZlN0bVwhYmKgrS9ABuoI0eglFBtt6x6GuYB4FuWgOwU5pWwzOHCnCBKNQLTKEEEP
	U1Bl4x6A==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdpcV-0000000DCjK-0EQ7
	for fio@vger.kernel.org;
	Thu, 08 Jan 2026 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 2FD041BC014F; Thu,  8 Jan 2026 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu,  8 Jan 2026 06:00:02 -0700
Message-Id: <20260108130002.2FD041BC014F@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit e12461d7864cf99581759f5417ca60dc68fee446:

  Merge branch 'master' of https://github.com/alex310110/fio (2025-12-29 13:08:16 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6ff32768ff322a269f87cd515ecfb218400f22bf:

  Add option to specify ramp period by amount of IO (2026-01-07 14:01:53 -0500)

----------------------------------------------------------------
Jan Kara (5):
      time: rename in_ramp_time() and ramp_time_over()
      td: Initialize ramp_period_over based on options
      eta: Use in_ramp_period() instead of opencoding it
      time: Evaluate ramp up condition once per second
      Add option to specify ramp period by amount of IO

 HOWTO.rst        |  10 +++++
 backend.c        |  12 ++---
 cconv.c          |   2 +
 eta.c            |   7 ++-
 fio.1            |   9 ++++
 fio.h            |   2 +-
 fio_time.h       |  10 ++++-
 helper_thread.c  |   8 +++-
 init.c           |   3 ++
 io_u.c           |   4 +-
 options.c        |  10 +++++
 server.h         |   2 +-
 stat.c           |   2 +-
 thread_options.h |   2 +
 time.c           | 131 ++++++++++++++++++++++++++++++++++++++++++++++---------
 15 files changed, 175 insertions(+), 39 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 3d74cb9f..b1642cf0 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -715,6 +715,16 @@ Time related parameters
 	:option:`runtime` is specified.  When the unit is omitted, the value is
 	given in seconds.
 
+.. option:: ramp_size=size
+
+	If set, fio will wait until the job does given amount of IO before
+	logging any performance numbers. When ``group_reporting`` is enabled,
+	the logging starts when all jobs in the group together perform given
+	amount of IO. Similarly to ``ramp_time`` this is useful for letting
+	performance to settle before logging results and will increase the total
+	runtime if a special timeout or :option:`runtime` is specified. When
+	the unit is omitted, the value is given in bytes.
+
 .. option:: clocksource=str
 
 	Use the given clocksource as the base of timing. The supported options are:
diff --git a/backend.c b/backend.c
index 13c77552..1e4c4a38 100644
--- a/backend.c
+++ b/backend.c
@@ -298,7 +298,7 @@ static inline void update_ts_cache(struct thread_data *td)
 
 static inline bool runtime_exceeded(struct thread_data *td, struct timespec *t)
 {
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		return false;
 	if (!td->o.timeout)
 		return false;
@@ -1031,7 +1031,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++)
 		bytes_done[i] = td->bytes_done[i];
 
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		td_set_runstate(td, TD_RAMP);
 	else
 		td_set_runstate(td, TD_RUNNING);
@@ -1162,7 +1162,7 @@ static void do_io(struct thread_data *td, uint64_t *bytes_done)
 			else
 				io_u->end_io = verify_io_u;
 			td_set_runstate(td, TD_VERIFYING);
-		} else if (in_ramp_time(td))
+		} else if (in_ramp_period(td))
 			td_set_runstate(td, TD_RAMP);
 		else
 			td_set_runstate(td, TD_RUNNING);
@@ -1232,7 +1232,7 @@ reap:
 		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 
-		if (!in_ramp_time(td) && should_check_rate(td)) {
+		if (!in_ramp_period(td) && should_check_rate(td)) {
 			if (check_min_rate(td, &comp_time)) {
 				if (exitall_on_terminate || td->o.exitall_error)
 					fio_terminate_threads(td->groupid, td->o.exit_what);
@@ -1240,7 +1240,7 @@ reap:
 				break;
 			}
 		}
-		if (!in_ramp_time(td) && td->o.latency_target)
+		if (!in_ramp_period(td) && td->o.latency_target)
 			lat_target_check(td);
 	}
 
@@ -2673,7 +2673,7 @@ reap:
 			if (td->runstate != TD_INITIALIZED)
 				continue;
 
-			if (in_ramp_time(td))
+			if (in_ramp_period(td))
 				td_set_runstate(td, TD_RAMP);
 			else
 				td_set_runstate(td, TD_RUNNING);
diff --git a/cconv.c b/cconv.c
index e7bbfc53..0c4a3f2d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -258,6 +258,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_delay_high = le64_to_cpu(top->start_delay_high);
 	o->timeout = le64_to_cpu(top->timeout);
 	o->ramp_time = le64_to_cpu(top->ramp_time);
+	o->ramp_size = le64_to_cpu(top->ramp_size);
 	o->ss_dur = le64_to_cpu(top->ss_dur);
 	o->ss_ramp_time = le64_to_cpu(top->ss_ramp_time);
 	o->ss_state = le32_to_cpu(top->ss_state);
@@ -636,6 +637,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
 	top->timeout = __cpu_to_le64(o->timeout);
 	top->ramp_time = __cpu_to_le64(o->ramp_time);
+	top->ramp_size = __cpu_to_le64(o->ramp_size);
 	top->ss_dur = __cpu_to_le64(top->ss_dur);
 	top->ss_ramp_time = __cpu_to_le64(top->ss_ramp_time);
 	top->ss_state = cpu_to_le32(top->ss_state);
diff --git a/eta.c b/eta.c
index 16109510..c6e3cffb 100644
--- a/eta.c
+++ b/eta.c
@@ -274,12 +274,11 @@ static unsigned long thread_eta(struct thread_data *td)
 			uint64_t ramp_time = td->o.ramp_time;
 
 			t_eta = __timeout + start_delay;
-			if (!td->ramp_time_over) {
+			if (in_ramp_period(td))
 				t_eta += ramp_time;
-			}
 			t_eta /= 1000000ULL;
 
-			if ((td->runstate == TD_RAMP) && in_ramp_time(td)) {
+			if ((td->runstate == TD_RAMP) && in_ramp_period(td)) {
 				unsigned long ramp_left;
 
 				ramp_left = mtime_since_now(&td->epoch);
@@ -522,7 +521,7 @@ static bool calc_thread_status(struct jobs_eta *je, int force)
 
 	any_td_in_ramp = false;
 	for_each_td(td) {
-		any_td_in_ramp |= in_ramp_time(td);
+		any_td_in_ramp |= in_ramp_period(td);
 	} end_for_each();
 	if (write_bw_log && rate_time > bw_avg_time && !any_td_in_ramp) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
diff --git a/fio.1 b/fio.1
index 9c4ff08c..3ee154ed 100644
--- a/fio.1
+++ b/fio.1
@@ -497,6 +497,15 @@ thus it will increase the total runtime if a special timeout or
 \fBruntime\fR is specified. When the unit is omitted, the value is
 given in seconds.
 .TP
+.BI ramp_size \fR=\fPsize
+If set, fio will wait until the job does given amount of IO before
+logging any performance numbers. When \fBgroup_reporting\fR is enabled,
+the logging starts when all jobs in the group together perform given
+amount of IO. Similarly to \fBramp_time\fR this is useful for letting
+performance to settle before logging results and will increase the total
+runtime if a special timeout or \fBruntime\fR is specified. When
+the unit is omitted, the value is given in bytes.
+.TP
 .BI clocksource \fR=\fPstr
 Use the given clocksource as the base of timing. The supported options are:
 .RS
diff --git a/fio.h b/fio.h
index 037678d1..fdd36fa4 100644
--- a/fio.h
+++ b/fio.h
@@ -417,7 +417,7 @@ struct thread_data {
 	struct timespec terminate_time;
 	unsigned int ts_cache_nr;
 	unsigned int ts_cache_mask;
-	bool ramp_time_over;
+	unsigned int ramp_period_state;
 
 	/*
 	 * Time since last latency_window was started
diff --git a/fio_time.h b/fio_time.h
index 969ad68d..ef107c50 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -8,6 +8,10 @@
 /* IWYU pragma: end_exports */
 #include "lib/types.h"
 
+#define RAMP_PERIOD_CHECK_MSEC 1000
+
+extern bool ramp_period_enabled;
+
 struct thread_data;
 extern uint64_t ntime_since(const struct timespec *, const struct timespec *);
 extern uint64_t ntime_since_now(const struct timespec *);
@@ -27,8 +31,10 @@ extern uint64_t usec_spin(unsigned int);
 extern uint64_t usec_sleep(struct thread_data *, unsigned long);
 extern void fill_start_time(struct timespec *);
 extern void set_genesis_time(void);
-extern bool ramp_time_over(struct thread_data *);
-extern bool in_ramp_time(struct thread_data *);
+extern int ramp_period_check(void);
+extern bool ramp_period_over(struct thread_data *);
+extern bool in_ramp_period(struct thread_data *);
+extern int td_ramp_period_init(struct thread_data *);
 extern void fio_time_init(void);
 extern void timespec_add_msec(struct timespec *, unsigned int);
 extern void set_epoch_time(struct thread_data *, clockid_t, clockid_t);
diff --git a/helper_thread.c b/helper_thread.c
index fed21d1d..88614e58 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -290,7 +290,13 @@ static void *helper_thread_main(void *data)
 			.interval_ms = steadystate_enabled ? ss_check_interval :
 				0,
 			.func = steadystate_check,
-		}
+		},
+		{
+			.name = "ramp_period",
+			.interval_ms = ramp_period_enabled ?
+				RAMP_PERIOD_CHECK_MSEC : 0,
+			.func = ramp_period_check,
+		},
 	};
 	struct timespec ts;
 	long clk_tck;
diff --git a/init.c b/init.c
index 76ec96d4..76e1a86d 100644
--- a/init.c
+++ b/init.c
@@ -1703,6 +1703,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
+	if (td_ramp_period_init(td))
+		goto err;
+
 	if (o->write_lat_log) {
 		struct log_params p = {
 			.td = td,
diff --git a/io_u.c b/io_u.c
index ec3f668c..be0a0555 100644
--- a/io_u.c
+++ b/io_u.c
@@ -2106,7 +2106,7 @@ static void file_log_write_comp(const struct thread_data *td, struct fio_file *f
 
 static bool should_account(struct thread_data *td)
 {
-	return ramp_time_over(td) && (td->runstate == TD_RUNNING ||
+	return ramp_period_over(td) && (td->runstate == TD_RUNNING ||
 					   td->runstate == TD_VERIFYING);
 }
 
@@ -2333,7 +2333,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
  */
 void io_u_queued(struct thread_data *td, struct io_u *io_u)
 {
-	if (!td->o.disable_slat && ramp_time_over(td) && td->o.stats) {
+	if (!td->o.disable_slat && ramp_period_over(td) && td->o.stats) {
 		if (td->parent)
 			td = td->parent;
 		add_slat_sample(td, io_u);
diff --git a/options.c b/options.c
index 6bd94e13..f526f5eb 100644
--- a/options.c
+++ b/options.c
@@ -3114,6 +3114,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
 	},
+	{
+		.name	= "ramp_size",
+		.lname	= "Ramp size",
+		.type	= FIO_OPT_STR_VAL,
+		.off1	= offsetof(struct thread_options, ramp_size),
+		.minval = 1,
+		.help	= "Amount of data transferred before measuring performance",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_RUNTIME,
+	},
 	{
 		.name	= "clocksource",
 		.lname	= "Clock source",
diff --git a/server.h b/server.h
index a3b163b1..09e6663e 100644
--- a/server.h
+++ b/server.h
@@ -51,7 +51,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 115,
+	FIO_SERVER_VER			= 116,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index d28feb3e..b999eb4b 100644
--- a/stat.c
+++ b/stat.c
@@ -3657,7 +3657,7 @@ static int add_iops_samples(struct thread_data *td, struct timespec *t)
 
 static bool td_in_logging_state(struct thread_data *td)
 {
-	if (in_ramp_time(td))
+	if (in_ramp_period(td))
 		return false;
 
 	switch(td->runstate) {
diff --git a/thread_options.h b/thread_options.h
index 3abce731..b4dd8d7a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -212,6 +212,7 @@ struct thread_options {
 	unsigned long long start_delay_high;
 	unsigned long long timeout;
 	unsigned long long ramp_time;
+	unsigned long long ramp_size;
 	unsigned int ss_state;
 	fio_fp64_t ss_limit;
 	unsigned long long ss_dur;
@@ -546,6 +547,7 @@ struct thread_options_pack {
 	uint64_t start_delay_high;
 	uint64_t timeout;
 	uint64_t ramp_time;
+	uint64_t ramp_size;
 	uint64_t ss_dur;
 	uint64_t ss_ramp_time;
 	uint32_t ss_state;
diff --git a/time.c b/time.c
index 7f85c8de..386c76fc 100644
--- a/time.c
+++ b/time.c
@@ -6,6 +6,12 @@
 static struct timespec genesis;
 static unsigned long ns_granularity;
 
+enum ramp_period_states {
+	RAMP_RUNNING,
+	RAMP_FINISHING,
+	RAMP_DONE
+};
+
 void timespec_add_msec(struct timespec *ts, unsigned int msec)
 {
 	uint64_t adj_nsec = 1000000ULL * msec;
@@ -110,47 +116,130 @@ uint64_t utime_since_genesis(void)
 	return utime_since_now(&genesis);
 }
 
-bool in_ramp_time(struct thread_data *td)
+bool in_ramp_period(struct thread_data *td)
 {
-	return td->o.ramp_time && !td->ramp_time_over;
+	return td->ramp_period_state != RAMP_DONE;
+}
+
+bool ramp_period_enabled = false;
+
+int ramp_period_check(void)
+{
+	uint64_t group_bytes = 0;
+	int prev_groupid = -1;
+	bool group_ramp_period_over = false;
+
+	for_each_td(td) {
+		if (td->ramp_period_state != RAMP_RUNNING)
+			continue;
+
+		if (td->o.ramp_time &&
+		    utime_since_now(&td->epoch) >= td->o.ramp_time) {
+			td->ramp_period_state = RAMP_FINISHING;
+			continue;
+		}
+
+		if (td->o.ramp_size) {
+			int ddir;
+			const bool needs_lock = td_async_processing(td);
+
+			if (!td->o.group_reporting ||
+			    (td->o.group_reporting &&
+			     td->groupid != prev_groupid)) {
+				group_bytes = 0;
+				prev_groupid = td->groupid;
+				group_ramp_period_over = false;
+			}
+
+			if (needs_lock)
+				__td_io_u_lock(td);
+
+			for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++)
+				group_bytes += td->io_bytes[ddir];
+
+			if (needs_lock)
+				__td_io_u_unlock(td);
+
+			if (group_bytes >= td->o.ramp_size) {
+				td->ramp_period_state = RAMP_FINISHING;
+				/*
+				 * Mark ramp up for all threads in the group as
+				 * done.
+				 */
+				if (td->o.group_reporting &&
+				    !group_ramp_period_over) {
+					group_ramp_period_over = true;
+					for_each_td(td2) {
+						if (td2->groupid == td->groupid)
+							 td2->ramp_period_state = RAMP_FINISHING;
+					} end_for_each();
+				}
+			}
+		}
+	} end_for_each();
+
+	return 0;
 }
 
 static bool parent_update_ramp(struct thread_data *td)
 {
 	struct thread_data *parent = td->parent;
 
-	if (!parent || parent->ramp_time_over)
+	if (!parent || parent->ramp_period_state == RAMP_DONE)
 		return false;
 
 	reset_all_stats(parent);
-	parent->ramp_time_over = true;
+	parent->ramp_period_state = RAMP_DONE;
 	td_set_runstate(parent, TD_RAMP);
 	return true;
 }
 
-bool ramp_time_over(struct thread_data *td)
+
+bool ramp_period_over(struct thread_data *td)
 {
-	if (!td->o.ramp_time || td->ramp_time_over)
+	if (td->ramp_period_state == RAMP_DONE)
 		return true;
 
-	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
-		td->ramp_time_over = true;
-		reset_all_stats(td);
-		reset_io_stats(td);
-		td_set_runstate(td, TD_RAMP);
+	if (td->ramp_period_state == RAMP_RUNNING)
+		return false;
 
-		/*
-		 * If we have a parent, the parent isn't doing IO. Hence
-		 * the parent never enters do_io(), which will switch us
-		 * from RAMP -> RUNNING. Do this manually here.
-		 */
-		if (parent_update_ramp(td))
-			td_set_runstate(td, TD_RUNNING);
+	td->ramp_period_state = RAMP_DONE;
+	reset_all_stats(td);
+	reset_io_stats(td);
+	td_set_runstate(td, TD_RAMP);
 
-		return true;
-	}
+	/*
+	 * If we have a parent, the parent isn't doing IO. Hence
+	 * the parent never enters do_io(), which will switch us
+	 * from RAMP -> RUNNING. Do this manually here.
+	 */
+	if (parent_update_ramp(td))
+		td_set_runstate(td, TD_RUNNING);
+
+	return true;
+}
 
-	return false;
+int td_ramp_period_init(struct thread_data *td)
+{
+	if (td->o.ramp_time || td->o.ramp_size) {
+		if (td->o.ramp_time && td->o.ramp_size) {
+			td_verror(td, EINVAL, "job rejected: cannot specify both ramp_time and ramp_size");
+			return 1;
+		}
+		/* Make sure options are consistent within reporting group */
+		for_each_td(td2) {
+			if (td->groupid == td2->groupid &&
+			    td->o.ramp_size != td2->o.ramp_size) {
+				td_verror(td, EINVAL, "job rejected: inconsistent ramp_size within reporting group");
+				return 1;
+			}
+		} end_for_each();
+		td->ramp_period_state = RAMP_RUNNING;
+		ramp_period_enabled = true;
+	} else {
+		td->ramp_period_state = RAMP_DONE;
+	}
+	return 0;
 }
 
 void fio_time_init(void)
