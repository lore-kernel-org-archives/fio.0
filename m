Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F127C678DB
	for <fio@archiver.kernel.org>; Sat,  4 Mar 2023 13:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCDNA2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 4 Mar 2023 08:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCDNA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 4 Mar 2023 08:00:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64921D904
        for <fio@vger.kernel.org>; Sat,  4 Mar 2023 05:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ZVr9W8uvs4AfN8N7NpYEWNPWvolKBSO/rTJH/J+8W7Q=; b=a1U/52+RJjCgzycSfcWckYP5wI
        PJENA2FyyqkYLLD3uVE8fOmUa4TGJI3f70TsQQWDghAGw87uvPbDadlTDgk0+9g+Qf0RUc4SyHKkq
        IGRPsnvxSgHFb8qv5rm6CdAe9RN/IPLFzedq+pGWhE9vjEeSmKJprPexzX8ACMqzIIAJZbv+5PLWB
        IaJ4LCUO+qFaWT3JgtPuhMY17+uXKJTtM68uICZT1Zgn/u/hXqFnvjLl51+B3Ggo/4CVvee2Mydc1
        quPrQw2VEh4Z/bhS5u59CR2GMvPrON9viIgvG88V/SZpfSXQk8pzTdSfLRs2qqtPK+uUrdVlkWSDT
        ak2tCkEg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pYRUc-003r9f-9Y
        for fio@vger.kernel.org; Sat, 04 Mar 2023 13:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B25E61BC014F; Sat,  4 Mar 2023 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230304130001.B25E61BC014F@kernel.dk>
Date:   Sat,  4 Mar 2023 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 5f81856714671287e93e087af8943d3d1779dd5f:

  Merge branch 'fiologparser-fix' of https://github.com/patrakov/fio (2023-03-02 19:57:17 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 051b5785bc47ab216fa3db9dceb6184073dcc88a:

  Merge branch 'For_Each_Td_Private_Scope' of https://github.com/horshack-dpreview/fio (2023-03-03 10:46:26 -0700)

----------------------------------------------------------------
Horshack (2):
      Fix --bandwidth-log segmentation fault when numjobs even multiple of 8
      Refactor for_each_td() to catch inappropriate td ptr reuse

Jens Axboe (2):
      Merge branch 'Fix_calc_thread_status_ramp_time_check' of https://github.com/horshack-dpreview/fio
      Merge branch 'For_Each_Td_Private_Scope' of https://github.com/horshack-dpreview/fio

 backend.c          | 44 ++++++++++++++++++--------------------------
 dedupe.c           |  7 ++-----
 engines/libblkio.c |  6 ++----
 eta.c              | 36 ++++++++++++++++++++----------------
 fio.h              | 19 +++++++++++++++++--
 init.c             | 14 +++++---------
 iolog.c            |  6 ++----
 libfio.c           | 12 ++++--------
 rate-submit.c      |  7 +++----
 stat.c             | 48 +++++++++++++++++++++---------------------------
 steadystate.c      | 27 ++++++++++++---------------
 verify.c           | 17 ++++++++---------
 zbd.c              | 35 ++++++++++++++---------------------
 13 files changed, 128 insertions(+), 150 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 975ef489..f541676c 100644
--- a/backend.c
+++ b/backend.c
@@ -93,19 +93,16 @@ static void sig_int(int sig)
 #ifdef WIN32
 static void sig_break(int sig)
 {
-	struct thread_data *td;
-	int i;
-
 	sig_int(sig);
 
 	/**
 	 * Windows terminates all job processes on SIGBREAK after the handler
 	 * returns, so give them time to wrap-up and give stats
 	 */
-	for_each_td(td, i) {
+	for_each_td(td) {
 		while (td->runstate < TD_EXITED)
 			sleep(1);
-	}
+	} end_for_each();
 }
 #endif
 
@@ -2056,15 +2053,14 @@ err:
 static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
 			 uint64_t *m_rate)
 {
-	struct thread_data *td;
 	unsigned int cputhreads, realthreads, pending;
-	int i, status, ret;
+	int status, ret;
 
 	/*
 	 * reap exited threads (TD_EXITED -> TD_REAPED)
 	 */
 	realthreads = pending = cputhreads = 0;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		int flags = 0;
 
 		if (!strcmp(td->o.ioengine, "cpuio"))
@@ -2157,7 +2153,7 @@ reaped:
 		done_secs += mtime_since_now(&td->epoch) / 1000;
 		profile_td_exit(td);
 		flow_exit_job(td);
-	}
+	} end_for_each();
 
 	if (*nr_running == cputhreads && !pending && realthreads)
 		fio_terminate_threads(TERMINATE_ALL, TERMINATE_ALL);
@@ -2284,13 +2280,11 @@ static bool waitee_running(struct thread_data *me)
 {
 	const char *waitee = me->o.wait_for;
 	const char *self = me->o.name;
-	struct thread_data *td;
-	int i;
 
 	if (!waitee)
 		return false;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!strcmp(td->o.name, self) || strcmp(td->o.name, waitee))
 			continue;
 
@@ -2300,7 +2294,7 @@ static bool waitee_running(struct thread_data *me)
 					runstate_to_name(td->runstate));
 			return true;
 		}
-	}
+	} end_for_each();
 
 	dprint(FD_PROCESS, "%s: %s completed, can run\n", self, waitee);
 	return false;
@@ -2324,14 +2318,14 @@ static void run_threads(struct sk_out *sk_out)
 	set_sig_handlers();
 
 	nr_thread = nr_process = 0;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (check_mount_writes(td))
 			return;
 		if (td->o.use_thread)
 			nr_thread++;
 		else
 			nr_process++;
-	}
+	} end_for_each();
 
 	if (output_format & FIO_OUTPUT_NORMAL) {
 		struct buf_output out;
@@ -2357,7 +2351,7 @@ static void run_threads(struct sk_out *sk_out)
 	nr_started = 0;
 	m_rate = t_rate = 0;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		print_status_init(td->thread_number - 1);
 
 		if (!td->o.create_serialize)
@@ -2393,7 +2387,7 @@ reap:
 					td_io_close_file(td, f);
 			}
 		}
-	}
+	} end_for_each();
 
 	/* start idle threads before io threads start to run */
 	fio_idle_prof_start();
@@ -2409,7 +2403,7 @@ reap:
 		/*
 		 * create threads (TD_NOT_CREATED -> TD_CREATED)
 		 */
-		for_each_td(td, i) {
+		for_each_td(td) {
 			if (td->runstate != TD_NOT_CREATED)
 				continue;
 
@@ -2488,7 +2482,7 @@ reap:
 
 					ret = (int)(uintptr_t)thread_main(fd);
 					_exit(ret);
-				} else if (i == fio_debug_jobno)
+				} else if (__td_index == fio_debug_jobno)
 					*fio_debug_jobp = pid;
 				free(eo);
 				free(fd);
@@ -2504,7 +2498,7 @@ reap:
 				break;
 			}
 			dprint(FD_MUTEX, "done waiting on startup_sem\n");
-		}
+		} end_for_each();
 
 		/*
 		 * Wait for the started threads to transition to
@@ -2549,7 +2543,7 @@ reap:
 		/*
 		 * start created threads (TD_INITIALIZED -> TD_RUNNING).
 		 */
-		for_each_td(td, i) {
+		for_each_td(td) {
 			if (td->runstate != TD_INITIALIZED)
 				continue;
 
@@ -2563,7 +2557,7 @@ reap:
 			t_rate += ddir_rw_sum(td->o.rate);
 			todo--;
 			fio_sem_up(td->sem);
-		}
+		} end_for_each();
 
 		reap_threads(&nr_running, &t_rate, &m_rate);
 
@@ -2589,9 +2583,7 @@ static void free_disk_util(void)
 
 int fio_backend(struct sk_out *sk_out)
 {
-	struct thread_data *td;
 	int i;
-
 	if (exec_profile) {
 		if (load_profile(exec_profile))
 			return 1;
@@ -2647,7 +2639,7 @@ int fio_backend(struct sk_out *sk_out)
 		}
 	}
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		struct thread_stat *ts = &td->ts;
 
 		free_clat_prio_stats(ts);
@@ -2660,7 +2652,7 @@ int fio_backend(struct sk_out *sk_out)
 		}
 		fio_sem_remove(td->sem);
 		td->sem = NULL;
-	}
+	} end_for_each();
 
 	free_disk_util();
 	if (cgroup_list) {
diff --git a/dedupe.c b/dedupe.c
index 8214a786..61705689 100644
--- a/dedupe.c
+++ b/dedupe.c
@@ -7,16 +7,13 @@
  */
 int init_global_dedupe_working_set_seeds(void)
 {
-	int i;
-	struct thread_data *td;
-
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!td->o.dedupe_global)
 			continue;
 
 		if (init_dedupe_working_set_seeds(td, 1))
 			return 1;
-	}
+	} end_for_each();
 
 	return 0;
 }
diff --git a/engines/libblkio.c b/engines/libblkio.c
index 054aa800..ee42d11c 100644
--- a/engines/libblkio.c
+++ b/engines/libblkio.c
@@ -283,16 +283,14 @@ static bool possibly_null_strs_equal(const char *a, const char *b)
  */
 static int total_threaded_subjobs(bool hipri)
 {
-	struct thread_data *td;
-	unsigned int i;
 	int count = 0;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		const struct fio_blkio_options *options = td->eo;
 		if (strcmp(td->o.ioengine, "libblkio") == 0 &&
 		    td->o.use_thread && (bool)options->hipri == hipri)
 			++count;
-	}
+	} end_for_each();
 
 	return count;
 }
diff --git a/eta.c b/eta.c
index 6017ca31..ce1c6f2d 100644
--- a/eta.c
+++ b/eta.c
@@ -381,8 +381,8 @@ bool eta_time_within_slack(unsigned int time)
  */
 bool calc_thread_status(struct jobs_eta *je, int force)
 {
-	struct thread_data *td;
-	int i, unified_rw_rep;
+	int unified_rw_rep;
+	bool any_td_in_ramp;
 	uint64_t rate_time, disp_time, bw_avg_time, *eta_secs;
 	unsigned long long io_bytes[DDIR_RWDIR_CNT] = {};
 	unsigned long long io_iops[DDIR_RWDIR_CNT] = {};
@@ -416,7 +416,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 
 	bw_avg_time = ULONG_MAX;
 	unified_rw_rep = 0;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		unified_rw_rep += td->o.unified_rw_rep;
 		if (is_power_of_2(td->o.kb_base))
 			je->is_pow2 = 1;
@@ -458,9 +458,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 			je->nr_pending++;
 
 		if (je->elapsed_sec >= 3)
-			eta_secs[i] = thread_eta(td);
+			eta_secs[__td_index] = thread_eta(td);
 		else
-			eta_secs[i] = INT_MAX;
+			eta_secs[__td_index] = INT_MAX;
 
 		check_str_update(td);
 
@@ -477,26 +477,26 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 				}
 			}
 		}
-	}
+	} end_for_each();
 
 	if (exitall_on_terminate) {
 		je->eta_sec = INT_MAX;
-		for_each_td(td, i) {
-			if (eta_secs[i] < je->eta_sec)
-				je->eta_sec = eta_secs[i];
-		}
+		for_each_td_index() {
+			if (eta_secs[__td_index] < je->eta_sec)
+				je->eta_sec = eta_secs[__td_index];
+		} end_for_each();
 	} else {
 		unsigned long eta_stone = 0;
 
 		je->eta_sec = 0;
-		for_each_td(td, i) {
+		for_each_td(td) {
 			if ((td->runstate == TD_NOT_CREATED) && td->o.stonewall)
-				eta_stone += eta_secs[i];
+				eta_stone += eta_secs[__td_index];
 			else {
-				if (eta_secs[i] > je->eta_sec)
-					je->eta_sec = eta_secs[i];
+				if (eta_secs[__td_index] > je->eta_sec)
+					je->eta_sec = eta_secs[__td_index];
 			}
-		}
+		} end_for_each();
 		je->eta_sec += eta_stone;
 	}
 
@@ -505,7 +505,11 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	fio_gettime(&now, NULL);
 	rate_time = mtime_since(&rate_prev_time, &now);
 
-	if (write_bw_log && rate_time > bw_avg_time && !in_ramp_time(td)) {
+	any_td_in_ramp = false;
+	for_each_td(td) {
+		any_td_in_ramp |= in_ramp_time(td);
+	} end_for_each();
+	if (write_bw_log && rate_time > bw_avg_time && !any_td_in_ramp) {
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
 				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
diff --git a/fio.h b/fio.h
index 09c44149..32535517 100644
--- a/fio.h
+++ b/fio.h
@@ -753,9 +753,24 @@ extern void lat_target_reset(struct thread_data *);
 
 /*
  * Iterates all threads/processes within all the defined jobs
+ * Usage:
+ *		for_each_td(var_name_for_td) {
+ *			<< bodoy of your loop >>
+ *			 Note: internally-scoped loop index availble as __td_index
+ *		} end_for_each_td()
  */
-#define for_each_td(td, i)	\
-	for ((i) = 0, (td) = &segments[0].threads[0]; (i) < (int) thread_number; (i)++, (td) = tnumber_to_td((i)))
+#define for_each_td(td)			\
+{								\
+	int __td_index;				\
+	struct thread_data *(td);	\
+	for (__td_index = 0, (td) = &segments[0].threads[0];\
+		__td_index < (int) thread_number; __td_index++, (td) = tnumber_to_td(__td_index))
+#define for_each_td_index()	    \
+{								\
+	int __td_index;				\
+	for (__td_index = 0; __td_index < (int) thread_number; __td_index++)
+#define	end_for_each()	}
+
 #define for_each_file(td, f, i)	\
 	if ((td)->files_index)						\
 		for ((i) = 0, (f) = (td)->files[0];			\
diff --git a/init.c b/init.c
index 78c6c803..442dab42 100644
--- a/init.c
+++ b/init.c
@@ -1405,15 +1405,14 @@ static void gen_log_name(char *name, size_t size, const char *logtype,
 
 static int check_waitees(char *waitee)
 {
-	struct thread_data *td;
-	int i, ret = 0;
+	int ret = 0;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->subjob_number)
 			continue;
 
 		ret += !strcmp(td->o.name, waitee);
-	}
+	} end_for_each();
 
 	return ret;
 }
@@ -1448,10 +1447,7 @@ static bool wait_for_ok(const char *jobname, struct thread_options *o)
 
 static int verify_per_group_options(struct thread_data *td, const char *jobname)
 {
-	struct thread_data *td2;
-	int i;
-
-	for_each_td(td2, i) {
+	for_each_td(td2) {
 		if (td->groupid != td2->groupid)
 			continue;
 
@@ -1461,7 +1457,7 @@ static int verify_per_group_options(struct thread_data *td, const char *jobname)
 				jobname);
 			return 1;
 		}
-	}
+	} end_for_each();
 
 	return 0;
 }
diff --git a/iolog.c b/iolog.c
index ea779632..cc2cbc65 100644
--- a/iolog.c
+++ b/iolog.c
@@ -1875,9 +1875,7 @@ void td_writeout_logs(struct thread_data *td, bool unit_logs)
 
 void fio_writeout_logs(bool unit_logs)
 {
-	struct thread_data *td;
-	int i;
-
-	for_each_td(td, i)
+	for_each_td(td) {
 		td_writeout_logs(td, unit_logs);
+	} end_for_each();
 }
diff --git a/libfio.c b/libfio.c
index ac521974..a52014ce 100644
--- a/libfio.c
+++ b/libfio.c
@@ -240,13 +240,11 @@ void fio_mark_td_terminate(struct thread_data *td)
 
 void fio_terminate_threads(unsigned int group_id, unsigned int terminate)
 {
-	struct thread_data *td;
 	pid_t pid = getpid();
-	int i;
 
 	dprint(FD_PROCESS, "terminate group_id=%d\n", group_id);
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if ((terminate == TERMINATE_GROUP && group_id == TERMINATE_ALL) ||
 		    (terminate == TERMINATE_GROUP && group_id == td->groupid) ||
 		    (terminate == TERMINATE_STONEWALL && td->runstate >= TD_RUNNING) ||
@@ -274,22 +272,20 @@ void fio_terminate_threads(unsigned int group_id, unsigned int terminate)
 					ops->terminate(td);
 			}
 		}
-	}
+	} end_for_each();
 }
 
 int fio_running_or_pending_io_threads(void)
 {
-	struct thread_data *td;
-	int i;
 	int nr_io_threads = 0;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->io_ops_init && td_ioengine_flagged(td, FIO_NOIO))
 			continue;
 		nr_io_threads++;
 		if (td->runstate < TD_EXITED)
 			return 1;
-	}
+	} end_for_each();
 
 	if (!nr_io_threads)
 		return -1; /* we only had cpuio threads to begin with */
diff --git a/rate-submit.c b/rate-submit.c
index 3cc17eaa..103a80aa 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -12,8 +12,7 @@
 
 static void check_overlap(struct io_u *io_u)
 {
-	int i, res;
-	struct thread_data *td;
+	int res;
 
 	/*
 	 * Allow only one thread to check for overlap at a time to prevent two
@@ -31,7 +30,7 @@ static void check_overlap(struct io_u *io_u)
 	assert(res == 0);
 
 retry:
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->runstate <= TD_SETTING_UP ||
 		    td->runstate >= TD_FINISHING ||
 		    !td->o.serialize_overlap ||
@@ -46,7 +45,7 @@ retry:
 		res = pthread_mutex_lock(&overlap_check);
 		assert(res == 0);
 		goto retry;
-	}
+	} end_for_each();
 }
 
 static int io_workqueue_fn(struct submit_worker *sw,
diff --git a/stat.c b/stat.c
index b963973a..e0a2dcc6 100644
--- a/stat.c
+++ b/stat.c
@@ -2366,7 +2366,6 @@ void init_thread_stat(struct thread_stat *ts)
 
 static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
 {
-	struct thread_data *td;
 	struct thread_stat *ts;
 	int i, j, last_ts, idx;
 	enum fio_ddir ddir;
@@ -2380,7 +2379,7 @@ static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
 	 * store a 1 in ts->disable_prio_stat, and then do an additional
 	 * loop at the end where we invert the ts->disable_prio_stat values.
 	 */
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!td->o.stats)
 			continue;
 		if (idx &&
@@ -2407,7 +2406,7 @@ static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
 		}
 
 		idx++;
-	}
+	} end_for_each();
 
 	/* Loop through all dst threadstats and fixup the values. */
 	for (i = 0; i < nr_ts; i++) {
@@ -2419,7 +2418,6 @@ static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
 void __show_run_stats(void)
 {
 	struct group_run_stats *runstats, *rs;
-	struct thread_data *td;
 	struct thread_stat *threadstats, *ts;
 	int i, j, k, nr_ts, last_ts, idx;
 	bool kb_base_warned = false;
@@ -2440,7 +2438,7 @@ void __show_run_stats(void)
 	 */
 	nr_ts = 0;
 	last_ts = -1;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!td->o.group_reporting) {
 			nr_ts++;
 			continue;
@@ -2452,7 +2450,7 @@ void __show_run_stats(void)
 
 		last_ts = td->groupid;
 		nr_ts++;
-	}
+	} end_for_each();
 
 	threadstats = malloc(nr_ts * sizeof(struct thread_stat));
 	opt_lists = malloc(nr_ts * sizeof(struct flist_head *));
@@ -2467,7 +2465,7 @@ void __show_run_stats(void)
 	j = 0;
 	last_ts = -1;
 	idx = 0;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!td->o.stats)
 			continue;
 		if (idx && (!td->o.group_reporting ||
@@ -2569,7 +2567,7 @@ void __show_run_stats(void)
 		}
 		else
 			ts->ss_dur = ts->ss_state = 0;
-	}
+	} end_for_each();
 
 	for (i = 0; i < nr_ts; i++) {
 		unsigned long long bw;
@@ -2722,17 +2720,15 @@ void __show_run_stats(void)
 
 int __show_running_run_stats(void)
 {
-	struct thread_data *td;
 	unsigned long long *rt;
 	struct timespec ts;
-	int i;
 
 	fio_sem_down(stat_sem);
 
 	rt = malloc(thread_number * sizeof(unsigned long long));
 	fio_gettime(&ts, NULL);
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->runstate >= TD_EXITED)
 			continue;
 
@@ -2742,16 +2738,16 @@ int __show_running_run_stats(void)
 		}
 		td->ts.total_run_time = mtime_since(&td->epoch, &ts);
 
-		rt[i] = mtime_since(&td->start, &ts);
+		rt[__td_index] = mtime_since(&td->start, &ts);
 		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
-			td->ts.runtime[DDIR_READ] += rt[i];
+			td->ts.runtime[DDIR_READ] += rt[__td_index];
 		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
-			td->ts.runtime[DDIR_WRITE] += rt[i];
+			td->ts.runtime[DDIR_WRITE] += rt[__td_index];
 		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
-			td->ts.runtime[DDIR_TRIM] += rt[i];
-	}
+			td->ts.runtime[DDIR_TRIM] += rt[__td_index];
+	} end_for_each();
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->runstate >= TD_EXITED)
 			continue;
 		if (td->rusage_sem) {
@@ -2759,21 +2755,21 @@ int __show_running_run_stats(void)
 			fio_sem_down(td->rusage_sem);
 		}
 		td->update_rusage = 0;
-	}
+	} end_for_each();
 
 	__show_run_stats();
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->runstate >= TD_EXITED)
 			continue;
 
 		if (td_read(td) && td->ts.io_bytes[DDIR_READ])
-			td->ts.runtime[DDIR_READ] -= rt[i];
+			td->ts.runtime[DDIR_READ] -= rt[__td_index];
 		if (td_write(td) && td->ts.io_bytes[DDIR_WRITE])
-			td->ts.runtime[DDIR_WRITE] -= rt[i];
+			td->ts.runtime[DDIR_WRITE] -= rt[__td_index];
 		if (td_trim(td) && td->ts.io_bytes[DDIR_TRIM])
-			td->ts.runtime[DDIR_TRIM] -= rt[i];
-	}
+			td->ts.runtime[DDIR_TRIM] -= rt[__td_index];
+	} end_for_each();
 
 	free(rt);
 	fio_sem_up(stat_sem);
@@ -3554,15 +3550,13 @@ static int add_iops_samples(struct thread_data *td, struct timespec *t)
  */
 int calc_log_samples(void)
 {
-	struct thread_data *td;
 	unsigned int next = ~0U, tmp = 0, next_mod = 0, log_avg_msec_min = -1U;
 	struct timespec now;
-	int i;
 	long elapsed_time = 0;
 
 	fio_gettime(&now, NULL);
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		elapsed_time = mtime_since_now(&td->epoch);
 
 		if (!td->o.stats)
@@ -3589,7 +3583,7 @@ int calc_log_samples(void)
 
 		if (tmp < next)
 			next = tmp;
-	}
+	} end_for_each();
 
 	/* if log_avg_msec_min has not been changed, set it to 0 */
 	if (log_avg_msec_min == -1U)
diff --git a/steadystate.c b/steadystate.c
index ad19318c..14cdf0ed 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -23,8 +23,8 @@ static void steadystate_alloc(struct thread_data *td)
 
 void steadystate_setup(void)
 {
-	struct thread_data *td, *prev_td;
-	int i, prev_groupid;
+	struct thread_data *prev_td;
+	int prev_groupid;
 
 	if (!steadystate_enabled)
 		return;
@@ -36,7 +36,7 @@ void steadystate_setup(void)
 	 */
 	prev_groupid = -1;
 	prev_td = NULL;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (!td->ss.dur)
 			continue;
 
@@ -51,7 +51,7 @@ void steadystate_setup(void)
 			prev_groupid = td->groupid;
 		}
 		prev_td = td;
-	}
+	} end_for_each();
 
 	if (prev_td && prev_td->o.group_reporting)
 		steadystate_alloc(prev_td);
@@ -198,16 +198,15 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 
 int steadystate_check(void)
 {
-	int i, j, ddir, prev_groupid, group_ramp_time_over = 0;
+	int  ddir, prev_groupid, group_ramp_time_over = 0;
 	unsigned long rate_time;
-	struct thread_data *td, *td2;
 	struct timespec now;
 	uint64_t group_bw = 0, group_iops = 0;
 	uint64_t td_iops, td_bytes;
 	bool ret;
 
 	prev_groupid = -1;
-	for_each_td(td, i) {
+	for_each_td(td) {
 		const bool needs_lock = td_async_processing(td);
 		struct steadystate_data *ss = &td->ss;
 
@@ -271,7 +270,7 @@ int steadystate_check(void)
 		dprint(FD_STEADYSTATE, "steadystate_check() thread: %d, "
 					"groupid: %u, rate_msec: %ld, "
 					"iops: %llu, bw: %llu, head: %d, tail: %d\n",
-					i, td->groupid, rate_time,
+					__td_index, td->groupid, rate_time,
 					(unsigned long long) group_iops,
 					(unsigned long long) group_bw,
 					ss->head, ss->tail);
@@ -283,18 +282,18 @@ int steadystate_check(void)
 
 		if (ret) {
 			if (td->o.group_reporting) {
-				for_each_td(td2, j) {
+				for_each_td(td2) {
 					if (td2->groupid == td->groupid) {
 						td2->ss.state |= FIO_SS_ATTAINED;
 						fio_mark_td_terminate(td2);
 					}
-				}
+				} end_for_each();
 			} else {
 				ss->state |= FIO_SS_ATTAINED;
 				fio_mark_td_terminate(td);
 			}
 		}
-	}
+	} end_for_each();
 	return 0;
 }
 
@@ -302,8 +301,6 @@ int td_steadystate_init(struct thread_data *td)
 {
 	struct steadystate_data *ss = &td->ss;
 	struct thread_options *o = &td->o;
-	struct thread_data *td2;
-	int j;
 
 	memset(ss, 0, sizeof(*ss));
 
@@ -325,7 +322,7 @@ int td_steadystate_init(struct thread_data *td)
 	}
 
 	/* make sure that ss options are consistent within reporting group */
-	for_each_td(td2, j) {
+	for_each_td(td2) {
 		if (td2->groupid == td->groupid) {
 			struct steadystate_data *ss2 = &td2->ss;
 
@@ -339,7 +336,7 @@ int td_steadystate_init(struct thread_data *td)
 				return 1;
 			}
 		}
-	}
+	} end_for_each();
 
 	return 0;
 }
diff --git a/verify.c b/verify.c
index ddfadcc8..e7e4c69c 100644
--- a/verify.c
+++ b/verify.c
@@ -1568,10 +1568,9 @@ static int fill_file_completions(struct thread_data *td,
 struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 {
 	struct all_io_list *rep;
-	struct thread_data *td;
 	size_t depth;
 	void *next;
-	int i, nr;
+	int nr;
 
 	compiletime_assert(sizeof(struct all_io_list) == 8, "all_io_list");
 
@@ -1581,14 +1580,14 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	 */
 	depth = 0;
 	nr = 0;
-	for_each_td(td, i) {
-		if (save_mask != IO_LIST_ALL && (i + 1) != save_mask)
+	for_each_td(td) {
+		if (save_mask != IO_LIST_ALL && (__td_index + 1) != save_mask)
 			continue;
 		td->stop_io = 1;
 		td->flags |= TD_F_VSTATE_SAVED;
 		depth += (td->o.iodepth * td->o.nr_files);
 		nr++;
-	}
+	} end_for_each();
 
 	if (!nr)
 		return NULL;
@@ -1602,11 +1601,11 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 	rep->threads = cpu_to_le64((uint64_t) nr);
 
 	next = &rep->state[0];
-	for_each_td(td, i) {
+	for_each_td(td) {
 		struct thread_io_list *s = next;
 		unsigned int comps, index = 0;
 
-		if (save_mask != IO_LIST_ALL && (i + 1) != save_mask)
+		if (save_mask != IO_LIST_ALL && (__td_index + 1) != save_mask)
 			continue;
 
 		comps = fill_file_completions(td, s, &index);
@@ -1615,7 +1614,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		s->depth = cpu_to_le64((uint64_t) td->o.iodepth);
 		s->nofiles = cpu_to_le64((uint64_t) td->o.nr_files);
 		s->numberio = cpu_to_le64((uint64_t) td->io_issues[DDIR_WRITE]);
-		s->index = cpu_to_le64((uint64_t) i);
+		s->index = cpu_to_le64((uint64_t) __td_index);
 		if (td->random_state.use64) {
 			s->rand.state64.s[0] = cpu_to_le64(td->random_state.state64.s1);
 			s->rand.state64.s[1] = cpu_to_le64(td->random_state.state64.s2);
@@ -1633,7 +1632,7 @@ struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
 		}
 		snprintf((char *) s->name, sizeof(s->name), "%s", td->o.name);
 		next = io_list_next(s);
-	}
+	} end_for_each();
 
 	return rep;
 }
diff --git a/zbd.c b/zbd.c
index d6f8f800..f5fb923a 100644
--- a/zbd.c
+++ b/zbd.c
@@ -524,11 +524,10 @@ out:
 /* Verify whether direct I/O is used for all host-managed zoned block drives. */
 static bool zbd_using_direct_io(void)
 {
-	struct thread_data *td;
 	struct fio_file *f;
-	int i, j;
+	int j;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->o.odirect || !(td->o.td_ddir & TD_DDIR_WRITE))
 			continue;
 		for_each_file(td, f, j) {
@@ -536,7 +535,7 @@ static bool zbd_using_direct_io(void)
 			    f->zbd_info->model == ZBD_HOST_MANAGED)
 				return false;
 		}
-	}
+	} end_for_each();
 
 	return true;
 }
@@ -639,27 +638,25 @@ static bool zbd_zone_align_file_sizes(struct thread_data *td,
  */
 static bool zbd_verify_sizes(void)
 {
-	struct thread_data *td;
 	struct fio_file *f;
-	int i, j;
+	int j;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		for_each_file(td, f, j) {
 			if (!zbd_zone_align_file_sizes(td, f))
 				return false;
 		}
-	}
+	} end_for_each();
 
 	return true;
 }
 
 static bool zbd_verify_bs(void)
 {
-	struct thread_data *td;
 	struct fio_file *f;
-	int i, j;
+	int j;
 
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td_trim(td) &&
 		    (td->o.min_bs[DDIR_TRIM] != td->o.max_bs[DDIR_TRIM] ||
 		     td->o.bssplit_nr[DDIR_TRIM])) {
@@ -680,7 +677,7 @@ static bool zbd_verify_bs(void)
 				return false;
 			}
 		}
-	}
+	} end_for_each();
 	return true;
 }
 
@@ -1010,11 +1007,10 @@ void zbd_free_zone_info(struct fio_file *f)
  */
 static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 {
-	struct thread_data *td2;
 	struct fio_file *f2;
-	int i, j, ret;
+	int j, ret;
 
-	for_each_td(td2, i) {
+	for_each_td(td2) {
 		for_each_file(td2, f2, j) {
 			if (td2 == td && f2 == file)
 				continue;
@@ -1025,7 +1021,7 @@ static int zbd_init_zone_info(struct thread_data *td, struct fio_file *file)
 			file->zbd_info->refcount++;
 			return 0;
 		}
-	}
+	} end_for_each();
 
 	ret = zbd_create_zone_info(td, file);
 	if (ret < 0)
@@ -1289,13 +1285,10 @@ static uint32_t pick_random_zone_idx(const struct fio_file *f,
 
 static bool any_io_in_flight(void)
 {
-	struct thread_data *td;
-	int i;
-
-	for_each_td(td, i) {
+	for_each_td(td) {
 		if (td->io_u_in_flight)
 			return true;
-	}
+	} end_for_each();
 
 	return false;
 }
