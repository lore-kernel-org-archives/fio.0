Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387690AbgJKMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 11 Oct 2020 08:00:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0E4C0613CE
        for <fio@vger.kernel.org>; Sun, 11 Oct 2020 05:00:18 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kRa1E-0006VG-Kb
        for fio@vger.kernel.org; Sun, 11 Oct 2020 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201011120001.898B31BC0183@kernel.dk>
Date: Sun, 11 Oct 2020 06:00:01 -0600 (MDT)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 729071019ee23804d52bed47357e4324be6b06bf:

  Merge branch 'master' of https://github.com/chengli-rutgers/fio into master (2020-10-09 07:28:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 60c52212520b905a1740d3c8815c34cc48471c5c:

  Merge branch 'master' of https://github.com/bvanassche/fio into master (2020-10-10 20:30:52 -0600)

----------------------------------------------------------------
Alexey Dobriyan (1):
      simplify MB/s, IOPS interactive printout code

Bart Van Assche (9):
      configure: Remove the CLOCK_MONOTONIC_PRECISE probe
      gettime: Introduce fio_get_mono_time()
      gettime: Simplify get_cycles_per_msec()
      gettime: Introduce rel_time_since()
      helper_thread: Introduce a function for blocking Unix signals
      helper_thread: Introduce the wait_for_action() function
      Change the return value of two functions from 'void' into 'int'
      helper_thread: Rework the interval timer code
      helper_thread: Increase timer accuracy

Jens Axboe (3):
      flow: avoid holes in struct fio_flow
      flow: use unsigned long for the counter
      Merge branch 'master' of https://github.com/bvanassche/fio into master

 configure          |  61 ++++--------
 engines/posixaio.c |  41 +-------
 eta.c              |  70 +++++--------
 fio_time.h         |   2 +
 flow.c             |   6 +-
 gettime.c          |  76 ++++++++------
 gettime.h          |   1 +
 helper_thread.c    | 285 ++++++++++++++++++++++++++++++++++++-----------------
 stat.c             |   4 +-
 stat.h             |   2 +-
 steadystate.c      |   3 +-
 steadystate.h      |   2 +-
 12 files changed, 306 insertions(+), 247 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 12b7cb58..39a9248d 100755
--- a/configure
+++ b/configure
@@ -1104,46 +1104,6 @@ EOF
 fi
 print_config "CLOCK_MONOTONIC" "$clock_monotonic"
 
-##########################################
-# CLOCK_MONOTONIC_RAW probe
-if test "$clock_monotonic_raw" != "yes" ; then
-  clock_monotonic_raw="no"
-fi
-if test "$clock_gettime" = "yes" ; then
-  cat > $TMPC << EOF
-#include <stdio.h>
-#include <time.h>
-int main(int argc, char **argv)
-{
-  return clock_gettime(CLOCK_MONOTONIC_RAW, NULL);
-}
-EOF
-  if compile_prog "" "$LIBS" "clock monotonic"; then
-      clock_monotonic_raw="yes"
-  fi
-fi
-print_config "CLOCK_MONOTONIC_RAW" "$clock_monotonic_raw"
-
-##########################################
-# CLOCK_MONOTONIC_PRECISE probe
-if test "$clock_monotonic_precise" != "yes" ; then
-  clock_monotonic_precise="no"
-fi
-if test "$clock_gettime" = "yes" ; then
-  cat > $TMPC << EOF
-#include <stdio.h>
-#include <time.h>
-int main(int argc, char **argv)
-{
-  return clock_gettime(CLOCK_MONOTONIC_PRECISE, NULL);
-}
-EOF
-  if compile_prog "" "$LIBS" "clock monotonic precise"; then
-      clock_monotonic_precise="yes"
-  fi
-fi
-print_config "CLOCK_MONOTONIC_PRECISE" "$clock_monotonic_precise"
-
 ##########################################
 # clockid_t probe
 if test "$clockid_t" != "yes" ; then
@@ -2722,6 +2682,24 @@ else
   pdb=no
 fi
 print_config "Windows PDB generation" "$pdb"
+
+##########################################
+# check for timerfd support
+timerfd_create="no"
+cat > $TMPC << EOF
+#include <sys/time.h>
+#include <sys/timerfd.h>
+
+int main(int argc, char **argv)
+{
+	return timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
+}
+EOF
+if compile_prog "" "" "timerfd_create"; then
+  timerfd_create="yes"
+fi
+print_config "timerfd_create" "$timerfd_create"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -3023,6 +3001,9 @@ fi
 if test "$statx_syscall" = "yes"; then
   output_sym "CONFIG_HAVE_STATX_SYSCALL"
 fi
+if test "$timerfd_create" = "yes"; then
+  output_sym "CONFIG_HAVE_TIMERFD_CREATE"
+fi
 if test "$fallthrough" = "yes"; then
   CFLAGS="$CFLAGS -Wimplicit-fallthrough"
 fi
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 82c6aa65..135d088c 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -17,47 +17,14 @@ struct posixaio_data {
 	unsigned int queued;
 };
 
-static int fill_timespec(struct timespec *ts)
+static unsigned long long ts_utime_since_now(const struct timespec *start)
 {
-#ifdef CONFIG_CLOCK_GETTIME
-#ifdef CONFIG_CLOCK_MONOTONIC
-	clockid_t clk = CLOCK_MONOTONIC;
-#else
-	clockid_t clk = CLOCK_REALTIME;
-#endif
-	if (!clock_gettime(clk, ts))
-		return 0;
-
-	perror("clock_gettime");
-	return 1;
-#else
-	struct timeval tv;
-
-	gettimeofday(&tv, NULL);
-	ts->tv_sec = tv.tv_sec;
-	ts->tv_nsec = tv.tv_usec * 1000;
-	return 0;
-#endif
-}
-
-static unsigned long long ts_utime_since_now(struct timespec *t)
-{
-	long long sec, nsec;
 	struct timespec now;
 
-	if (fill_timespec(&now))
+	if (fio_get_mono_time(&now) < 0)
 		return 0;
-	
-	sec = now.tv_sec - t->tv_sec;
-	nsec = now.tv_nsec - t->tv_nsec;
-	if (sec > 0 && nsec < 0) {
-		sec--;
-		nsec += 1000000000;
-	}
 
-	sec *= 1000000;
-	nsec /= 1000;
-	return sec + nsec;
+	return utime_since(start, &now);
 }
 
 static int fio_posixaio_cancel(struct thread_data fio_unused *td,
@@ -102,7 +69,7 @@ static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
 	unsigned int r;
 	int i;
 
-	if (t && !fill_timespec(&start))
+	if (t && fio_get_mono_time(&start) == 0)
 		have_timeout = 1;
 	else
 		memset(&start, 0, sizeof(start));
diff --git a/eta.c b/eta.c
index e8c72780..d1c9449f 100644
--- a/eta.c
+++ b/eta.c
@@ -534,56 +534,38 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 static int gen_eta_str(struct jobs_eta *je, char *p, size_t left,
 		       char **rate_str, char **iops_str)
 {
-	bool has_r = je->rate[DDIR_READ] || je->iops[DDIR_READ];
-	bool has_w = je->rate[DDIR_WRITE] || je->iops[DDIR_WRITE];
-	bool has_t = je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM];
+	static const char c[DDIR_RWDIR_CNT] = {'r', 'w', 't'};
+	bool has[DDIR_RWDIR_CNT];
+	bool has_any = false;
+	const char *sep;
 	int l = 0;
 
-	if (!has_r && !has_w && !has_t)
+	for_each_rw_ddir(ddir) {
+		has[ddir] = (je->rate[ddir] || je->iops[ddir]);
+		has_any |= has[ddir];
+	}
+	if (!has_any)
 		return 0;
 
-	if (has_r) {
-		l += snprintf(p + l, left - l, "[r=%s", rate_str[DDIR_READ]);
-		if (!has_w)
-			l += snprintf(p + l, left - l, "]");
-	}
-	if (has_w) {
-		if (has_r)
-			l += snprintf(p + l, left - l, ",");
-		else
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "w=%s", rate_str[DDIR_WRITE]);
-		if (!has_t)
-			l += snprintf(p + l, left - l, "]");
-	}
-	if (has_t) {
-		if (has_r || has_w)
-			l += snprintf(p + l, left - l, ",");
-		else if (!has_r && !has_w)
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "t=%s]", rate_str[DDIR_TRIM]);
-	}
-	if (has_r) {
-		l += snprintf(p + l, left - l, "[r=%s", iops_str[DDIR_READ]);
-		if (!has_w)
-			l += snprintf(p + l, left - l, " IOPS]");
-	}
-	if (has_w) {
-		if (has_r)
-			l += snprintf(p + l, left - l, ",");
-		else
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "w=%s", iops_str[DDIR_WRITE]);
-		if (!has_t)
-			l += snprintf(p + l, left - l, " IOPS]");
+	l += snprintf(p + l, left - l, "[");
+	sep = "";
+	for_each_rw_ddir(ddir) {
+		if (has[ddir]) {
+			l += snprintf(p + l, left - l, "%s%c=%s",
+					sep, c[ddir], rate_str[ddir]);
+			sep = ",";
+		}
 	}
-	if (has_t) {
-		if (has_r || has_w)
-			l += snprintf(p + l, left - l, ",");
-		else if (!has_r && !has_w)
-			l += snprintf(p + l, left - l, "[");
-		l += snprintf(p + l, left - l, "t=%s IOPS]", iops_str[DDIR_TRIM]);
+	l += snprintf(p + l, left - l, "][");
+	sep = "";
+	for_each_rw_ddir(ddir) {
+		if (has[ddir]) {
+			l += snprintf(p + l, left - l, "%s%c=%s",
+					sep, c[ddir], iops_str[ddir]);
+			sep = ",";
+		}
 	}
+	l += snprintf(p + l, left - l, " IOPS]");
 
 	return l;
 }
diff --git a/fio_time.h b/fio_time.h
index c00f8e78..b3bbd4c0 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -13,6 +13,8 @@ extern uint64_t ntime_since(const struct timespec *, const struct timespec *);
 extern uint64_t ntime_since_now(const struct timespec *);
 extern uint64_t utime_since(const struct timespec *, const struct timespec *);
 extern uint64_t utime_since_now(const struct timespec *);
+extern int64_t rel_time_since(const struct timespec *,
+			      const struct timespec *);
 extern uint64_t mtime_since(const struct timespec *, const struct timespec *);
 extern uint64_t mtime_since_now(const struct timespec *);
 extern uint64_t mtime_since_tv(const struct timeval *, const struct timeval *);
diff --git a/flow.c b/flow.c
index ee4d761d..ea6b0ec9 100644
--- a/flow.c
+++ b/flow.c
@@ -5,9 +5,9 @@
 
 struct fio_flow {
 	unsigned int refs;
-	struct flist_head list;
 	unsigned int id;
-	unsigned long long flow_counter;
+	struct flist_head list;
+	unsigned long flow_counter;
 	unsigned int total_weight;
 };
 
@@ -90,7 +90,7 @@ static struct fio_flow *flow_get(unsigned int id)
 	return flow;
 }
 
-static void flow_put(struct fio_flow *flow, unsigned long long flow_counter,
+static void flow_put(struct fio_flow *flow, unsigned long flow_counter,
 				        unsigned int weight)
 {
 	if (!flow_lock)
diff --git a/gettime.c b/gettime.c
index c3a4966b..f85da6e0 100644
--- a/gettime.c
+++ b/gettime.c
@@ -127,18 +127,33 @@ static void fio_init gtod_init(void)
 
 #endif /* FIO_DEBUG_TIME */
 
-#ifdef CONFIG_CLOCK_GETTIME
-static int fill_clock_gettime(struct timespec *ts)
+/*
+ * Queries the value of the monotonic clock if a monotonic clock is available
+ * or the wall clock time if no monotonic clock is available. Returns 0 if
+ * querying the clock succeeded or -1 if querying the clock failed.
+ */
+int fio_get_mono_time(struct timespec *ts)
 {
-#if defined(CONFIG_CLOCK_MONOTONIC_RAW)
-	return clock_gettime(CLOCK_MONOTONIC_RAW, ts);
-#elif defined(CONFIG_CLOCK_MONOTONIC)
-	return clock_gettime(CLOCK_MONOTONIC, ts);
+	int ret;
+
+#ifdef CONFIG_CLOCK_GETTIME
+#if defined(CONFIG_CLOCK_MONOTONIC)
+	ret = clock_gettime(CLOCK_MONOTONIC, ts);
 #else
-	return clock_gettime(CLOCK_REALTIME, ts);
+	ret = clock_gettime(CLOCK_REALTIME, ts);
 #endif
-}
+#else
+	struct timeval tv;
+
+	ret = gettimeofday(&tv, NULL);
+	if (ret == 0) {
+		ts->tv_sec = tv.tv_sec;
+		ts->tv_nsec = tv.tv_usec * 1000;
+	}
 #endif
+	assert(ret <= 0);
+	return ret;
+}
 
 static void __fio_gettime(struct timespec *tp)
 {
@@ -155,8 +170,8 @@ static void __fio_gettime(struct timespec *tp)
 #endif
 #ifdef CONFIG_CLOCK_GETTIME
 	case CS_CGETTIME: {
-		if (fill_clock_gettime(tp) < 0) {
-			log_err("fio: clock_gettime fails\n");
+		if (fio_get_mono_time(tp) < 0) {
+			log_err("fio: fio_get_mono_time() fails\n");
 			assert(0);
 		}
 		break;
@@ -224,19 +239,13 @@ static unsigned long get_cycles_per_msec(void)
 {
 	struct timespec s, e;
 	uint64_t c_s, c_e;
-	enum fio_cs old_cs = fio_clock_source;
 	uint64_t elapsed;
 
-#ifdef CONFIG_CLOCK_GETTIME
-	fio_clock_source = CS_CGETTIME;
-#else
-	fio_clock_source = CS_GTOD;
-#endif
-	__fio_gettime(&s);
+	fio_get_mono_time(&s);
 
 	c_s = get_cpu_clock();
 	do {
-		__fio_gettime(&e);
+		fio_get_mono_time(&e);
 		c_e = get_cpu_clock();
 
 		elapsed = ntime_since(&s, &e);
@@ -244,7 +253,6 @@ static unsigned long get_cycles_per_msec(void)
 			break;
 	} while (1);
 
-	fio_clock_source = old_cs;
 	return (c_e - c_s) * 1000000 / elapsed;
 }
 
@@ -516,23 +524,33 @@ uint64_t mtime_since_now(const struct timespec *s)
 	return mtime_since(s, &t);
 }
 
-uint64_t mtime_since(const struct timespec *s, const struct timespec *e)
+/*
+ * Returns *e - *s in milliseconds as a signed integer. Note: rounding is
+ * asymmetric. If the difference yields +1 ns then 0 is returned. If the
+ * difference yields -1 ns then -1 is returned.
+ */
+int64_t rel_time_since(const struct timespec *s, const struct timespec *e)
 {
-	int64_t sec, usec;
+	int64_t sec, nsec;
 
 	sec = e->tv_sec - s->tv_sec;
-	usec = (e->tv_nsec - s->tv_nsec) / 1000;
-	if (sec > 0 && usec < 0) {
+	nsec = e->tv_nsec - s->tv_nsec;
+	if (nsec < 0) {
 		sec--;
-		usec += 1000000;
+		nsec += 1000ULL * 1000 * 1000;
 	}
+	assert(0 <= nsec && nsec < 1000ULL * 1000 * 1000);
 
-	if (sec < 0 || (sec == 0 && usec < 0))
-		return 0;
+	return sec * 1000 + nsec / (1000 * 1000);
+}
 
-	sec *= 1000;
-	usec /= 1000;
-	return sec + usec;
+/*
+ * Returns *e - *s in milliseconds as an unsigned integer. Returns 0 if
+ * *e < *s.
+ */
+uint64_t mtime_since(const struct timespec *s, const struct timespec *e)
+{
+	return max(rel_time_since(s, e), (int64_t)0);
 }
 
 uint64_t time_since_now(const struct timespec *s)
diff --git a/gettime.h b/gettime.h
index c55f5cba..f1d619ad 100644
--- a/gettime.h
+++ b/gettime.h
@@ -16,6 +16,7 @@ enum fio_cs {
 	CS_INVAL,
 };
 
+extern int fio_get_mono_time(struct timespec *);
 extern void fio_gettime(struct timespec *, void *);
 extern void fio_gtod_init(void);
 extern void fio_clock_init(void);
diff --git a/helper_thread.c b/helper_thread.c
index a2fb7c29..2d553654 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -1,4 +1,8 @@
 #include <signal.h>
+#include <unistd.h>
+#ifdef CONFIG_HAVE_TIMERFD_CREATE
+#include <sys/timerfd.h>
+#endif
 #ifdef CONFIG_VALGRIND_DEV
 #include <valgrind/drd.h>
 #else
@@ -11,6 +15,9 @@
 #include "steadystate.h"
 #include "pshared.h"
 
+static int sleep_accuracy_ms;
+static int timerfd = -1;
+
 enum action {
 	A_EXIT		= 1,
 	A_RESET		= 2,
@@ -25,6 +32,13 @@ static struct helper_data {
 	struct fio_sem *startup_sem;
 } *helper_data;
 
+struct interval_timer {
+	const char	*name;
+	struct timespec	expires;
+	uint32_t	interval_ms;
+	int		(*func)(void);
+};
+
 void helper_thread_destroy(void)
 {
 	if (!helper_data)
@@ -83,6 +97,18 @@ static int read_from_pipe(int fd, void *buf, size_t len)
 }
 #endif
 
+static void block_signals(void)
+{
+#ifdef HAVE_PTHREAD_SIGMASK
+	sigset_t sigmask;
+
+	ret = pthread_sigmask(SIG_UNBLOCK, NULL, &sigmask);
+	assert(ret == 0);
+	ret = pthread_sigmask(SIG_BLOCK, &sigmask, NULL);
+	assert(ret == 0);
+#endif
+}
+
 static void submit_action(enum action a)
 {
 	const char data = a;
@@ -128,128 +154,207 @@ void helper_thread_exit(void)
 	pthread_join(helper_data->thread, NULL);
 }
 
-static unsigned int task_helper(struct timespec *last, struct timespec *now, unsigned int period, void do_task())
+/* Resets timers and returns the time in milliseconds until the next event. */
+static int reset_timers(struct interval_timer timer[], int num_timers,
+			struct timespec *now)
 {
-	unsigned int next, since;
-
-	since = mtime_since(last, now);
-	if (since >= period || period - since < 10) {
-		do_task();
-		timespec_add_msec(last, since);
-		if (since > period)
-			next = period - (since - period);
-		else
-			next = period;
-	} else
-		next = period - since;
-
-	return next;
+	uint32_t msec_to_next_event = INT_MAX;
+	int i;
+
+	for (i = 0; i < num_timers; ++i) {
+		timer[i].expires = *now;
+		timespec_add_msec(&timer[i].expires, timer[i].interval_ms);
+		msec_to_next_event = min_not_zero(msec_to_next_event,
+						  timer[i].interval_ms);
+	}
+
+	return msec_to_next_event;
 }
 
-static void *helper_thread_main(void *data)
+/*
+ * Waits for an action from fd during at least timeout_ms. `fd` must be in
+ * non-blocking mode.
+ */
+static uint8_t wait_for_action(int fd, unsigned int timeout_ms)
 {
-	struct helper_data *hd = data;
-	unsigned int msec_to_next_event, next_log, next_si = status_interval;
-	unsigned int next_ss = STEADYSTATE_MSEC;
-	struct timespec ts, last_du, last_ss, last_si;
-	char action;
-	int ret = 0;
-
-	sk_out_assign(hd->sk_out);
+	struct timeval timeout = {
+		.tv_sec  = timeout_ms / 1000,
+		.tv_usec = (timeout_ms % 1000) * 1000,
+	};
+	fd_set rfds, efds;
+	uint8_t action = 0;
+	uint64_t exp;
+	int res;
 
-#ifdef HAVE_PTHREAD_SIGMASK
+	res = read_from_pipe(fd, &action, sizeof(action));
+	if (res > 0 || timeout_ms == 0)
+		return action;
+	FD_ZERO(&rfds);
+	FD_SET(fd, &rfds);
+	FD_ZERO(&efds);
+	FD_SET(fd, &efds);
+#ifdef CONFIG_HAVE_TIMERFD_CREATE
 	{
-	sigset_t sigmask;
-
-	/* Let another thread handle signals. */
-	ret = pthread_sigmask(SIG_UNBLOCK, NULL, &sigmask);
-	assert(ret == 0);
-	ret = pthread_sigmask(SIG_BLOCK, &sigmask, NULL);
-	assert(ret == 0);
+		/*
+		 * If the timer frequency is 100 Hz, select() will round up
+		 * `timeout` to the next multiple of 1 / 100 Hz = 10 ms. Hence
+		 * use a high-resolution timer if possible to increase
+		 * select() timeout accuracy.
+		 */
+		struct itimerspec delta = {};
+
+		delta.it_value.tv_sec = timeout.tv_sec;
+		delta.it_value.tv_nsec = timeout.tv_usec * 1000;
+		res = timerfd_settime(timerfd, 0, &delta, NULL);
+		assert(res == 0);
+		FD_SET(timerfd, &rfds);
 	}
 #endif
+	res = select(max(fd, timerfd) + 1, &rfds, NULL, &efds,
+		     timerfd >= 0 ? NULL : &timeout);
+	if (res < 0) {
+		log_err("fio: select() call in helper thread failed: %s",
+			strerror(errno));
+		return A_EXIT;
+	}
+	if (FD_ISSET(fd, &rfds))
+		read_from_pipe(fd, &action, sizeof(action));
+	if (timerfd >= 0 && FD_ISSET(timerfd, &rfds)) {
+		res = read(timerfd, &exp, sizeof(exp));
+		assert(res == sizeof(exp));
+	}
+	return action;
+}
+
+/*
+ * Verify whether or not timer @it has expired. If timer @it has expired, call
+ * @it->func(). @now is the current time. @msec_to_next_event is an
+ * input/output parameter that represents the time until the next event.
+ */
+static int eval_timer(struct interval_timer *it, const struct timespec *now,
+		      unsigned int *msec_to_next_event)
+{
+	int64_t delta_ms;
+	bool expired;
+
+	/* interval == 0 means that the timer is disabled. */
+	if (it->interval_ms == 0)
+		return 0;
+
+	delta_ms = rel_time_since(now, &it->expires);
+	expired = delta_ms <= sleep_accuracy_ms;
+	if (expired) {
+		timespec_add_msec(&it->expires, it->interval_ms);
+		delta_ms = rel_time_since(now, &it->expires);
+		if (delta_ms < it->interval_ms - sleep_accuracy_ms ||
+		    delta_ms > it->interval_ms + sleep_accuracy_ms) {
+			dprint(FD_HELPERTHREAD,
+			       "%s: delta = %" PRIi64 " <> %u. Clock jump?\n",
+			       it->name, delta_ms, it->interval_ms);
+			delta_ms = it->interval_ms;
+			it->expires = *now;
+			timespec_add_msec(&it->expires, it->interval_ms);
+		}
+	}
+	*msec_to_next_event = min((unsigned int)delta_ms, *msec_to_next_event);
+	return expired ? it->func() : 0;
+}
+
+static void *helper_thread_main(void *data)
+{
+	struct helper_data *hd = data;
+	unsigned int msec_to_next_event, next_log;
+	struct interval_timer timer[] = {
+		{
+			.name = "disk_util",
+			.interval_ms = DISK_UTIL_MSEC,
+			.func = update_io_ticks,
+		},
+		{
+			.name = "status_interval",
+			.interval_ms = status_interval,
+			.func = __show_running_run_stats,
+		},
+		{
+			.name = "steadystate",
+			.interval_ms = steadystate_enabled ? STEADYSTATE_MSEC :
+				0,
+			.func = steadystate_check,
+		}
+	};
+	struct timespec ts;
+	int clk_tck, ret = 0;
 
-#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
-	clock_gettime(CLOCK_MONOTONIC, &ts);
+#ifdef _SC_CLK_TCK
+	clk_tck = sysconf(_SC_CLK_TCK);
 #else
-	clock_gettime(CLOCK_REALTIME, &ts);
+	/*
+	 * The timer frequence is variable on Windows. Instead of trying to
+	 * query it, use 64 Hz, the clock frequency lower bound. See also
+	 * https://carpediemsystems.co.uk/2019/07/18/windows-system-timer-granularity/.
+	 */
+	clk_tck = 64;
+#endif
+	dprint(FD_HELPERTHREAD, "clk_tck = %d\n", clk_tck);
+	assert(clk_tck > 0);
+	sleep_accuracy_ms = (1000 + clk_tck - 1) / clk_tck;
+
+#ifdef CONFIG_HAVE_TIMERFD_CREATE
+	timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
+	assert(timerfd >= 0);
+	sleep_accuracy_ms = 1;
 #endif
-	memcpy(&last_du, &ts, sizeof(ts));
-	memcpy(&last_ss, &ts, sizeof(ts));
-	memcpy(&last_si, &ts, sizeof(ts));
+
+	sk_out_assign(hd->sk_out);
+
+	/* Let another thread handle signals. */
+	block_signals();
+
+	fio_get_mono_time(&ts);
+	msec_to_next_event = reset_timers(timer, ARRAY_SIZE(timer), &ts);
 
 	fio_sem_up(hd->startup_sem);
 
-	msec_to_next_event = DISK_UTIL_MSEC;
 	while (!ret && !hd->exit) {
-		uint64_t since_du;
-		struct timeval timeout = {
-			.tv_sec  = msec_to_next_event / 1000,
-			.tv_usec = (msec_to_next_event % 1000) * 1000,
-		};
-		fd_set rfds, efds;
-
-		if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) < 0) {
-			FD_ZERO(&rfds);
-			FD_SET(hd->pipe[0], &rfds);
-			FD_ZERO(&efds);
-			FD_SET(hd->pipe[0], &efds);
-			if (select(1, &rfds, NULL, &efds, &timeout) < 0) {
-				log_err("fio: select() call in helper thread failed: %s",
-					strerror(errno));
-				ret = 1;
-			}
-			if (read_from_pipe(hd->pipe[0], &action, sizeof(action)) <
-			    0)
-				action = 0;
-		}
+		uint8_t action;
+		int i;
 
-#ifdef CONFIG_PTHREAD_CONDATTR_SETCLOCK
-		clock_gettime(CLOCK_MONOTONIC, &ts);
-#else
-		clock_gettime(CLOCK_REALTIME, &ts);
-#endif
+		action = wait_for_action(hd->pipe[0], msec_to_next_event);
+		if (action == A_EXIT)
+			break;
 
-		if (action == A_RESET) {
-			last_du = ts;
-			last_ss = ts;
-		}
+		fio_get_mono_time(&ts);
+
+		msec_to_next_event = INT_MAX;
 
-		since_du = mtime_since(&last_du, &ts);
-		if (since_du >= DISK_UTIL_MSEC || DISK_UTIL_MSEC - since_du < 10) {
-			ret = update_io_ticks();
-			timespec_add_msec(&last_du, DISK_UTIL_MSEC);
-			msec_to_next_event = DISK_UTIL_MSEC;
-			if (since_du >= DISK_UTIL_MSEC)
-				msec_to_next_event -= (since_du - DISK_UTIL_MSEC);
-		} else
-			msec_to_next_event = DISK_UTIL_MSEC - since_du;
+		if (action == A_RESET)
+			msec_to_next_event = reset_timers(timer,
+						ARRAY_SIZE(timer), &ts);
+
+		for (i = 0; i < ARRAY_SIZE(timer); ++i)
+			ret = eval_timer(&timer[i], &ts, &msec_to_next_event);
 
 		if (action == A_DO_STAT)
 			__show_running_run_stats();
 
-		if (status_interval) {
-			next_si = task_helper(&last_si, &ts, status_interval, __show_running_run_stats);
-			msec_to_next_event = min(next_si, msec_to_next_event);
-		}
-
 		next_log = calc_log_samples();
 		if (!next_log)
 			next_log = DISK_UTIL_MSEC;
 
-		if (steadystate_enabled) {
-			next_ss = task_helper(&last_ss, &ts, STEADYSTATE_MSEC, steadystate_check);
-			msec_to_next_event = min(next_ss, msec_to_next_event);
-                }
-
 		msec_to_next_event = min(next_log, msec_to_next_event);
-		dprint(FD_HELPERTHREAD, "next_si: %u, next_ss: %u, next_log: %u, msec_to_next_event: %u\n",
-			next_si, next_ss, next_log, msec_to_next_event);
+		dprint(FD_HELPERTHREAD,
+		       "next_log: %u, msec_to_next_event: %u\n",
+		       next_log, msec_to_next_event);
 
 		if (!is_backend)
 			print_thread_status();
 	}
 
+	if (timerfd >= 0) {
+		close(timerfd);
+		timerfd = -1;
+	}
+
 	fio_writeout_logs(false);
 
 	sk_out_drop();
diff --git a/stat.c b/stat.c
index 7f987c7f..eb40bd7f 100644
--- a/stat.c
+++ b/stat.c
@@ -2299,7 +2299,7 @@ void __show_run_stats(void)
 	free(opt_lists);
 }
 
-void __show_running_run_stats(void)
+int __show_running_run_stats(void)
 {
 	struct thread_data *td;
 	unsigned long long *rt;
@@ -2350,6 +2350,8 @@ void __show_running_run_stats(void)
 
 	free(rt);
 	fio_sem_up(stat_sem);
+
+	return 0;
 }
 
 static bool status_file_disabled;
diff --git a/stat.h b/stat.h
index 0d141666..6dd5ef74 100644
--- a/stat.h
+++ b/stat.h
@@ -319,7 +319,7 @@ extern void show_group_stats(struct group_run_stats *rs, struct buf_output *);
 extern bool calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void __show_run_stats(void);
-extern void __show_running_run_stats(void);
+extern int __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, bool first);
diff --git a/steadystate.c b/steadystate.c
index bd2f70dd..2e3da1db 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -196,7 +196,7 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 	return false;
 }
 
-void steadystate_check(void)
+int steadystate_check(void)
 {
 	int i, j, ddir, prev_groupid, group_ramp_time_over = 0;
 	unsigned long rate_time;
@@ -302,6 +302,7 @@ void steadystate_check(void)
 			}
 		}
 	}
+	return 0;
 }
 
 int td_steadystate_init(struct thread_data *td)
diff --git a/steadystate.h b/steadystate.h
index 51472c46..bbb86fbb 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -4,7 +4,7 @@
 #include "thread_options.h"
 
 extern void steadystate_free(struct thread_data *);
-extern void steadystate_check(void);
+extern int steadystate_check(void);
 extern void steadystate_setup(void);
 extern int td_steadystate_init(struct thread_data *);
 extern uint64_t steadystate_bw_mean(struct thread_stat *);

