Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79A66C74A5B
	for <fio@archiver.kernel.org>; Tue, 21 Mar 2023 12:00:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbjCUMAW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Mar 2023 08:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjCUMAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Mar 2023 08:00:21 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D85EB54
        for <fio@vger.kernel.org>; Tue, 21 Mar 2023 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/wfFMvRYKQ/uL712K4z1RZj5hiNQKgDbb5j8j4MnCmY=; b=dF99/oLXRse2uKo04D7YsdInYg
        4of9rwfrou0kuiGTYYyLvt048ea83phP8W9X0pxXQ5xB0PjMW8EhBBnbuXnwKjRlyG3xPY7C5EoLA
        ogeyN+g66geYY/AQ9c/2z/bGbC3EBE91jBLnYdcZsuQWz4GxYwYCHsjXd6fTLmUtHhCP4RMXhUpiT
        TDlQ0/clzD35houKoEnwPK1Md2vSKXwC0C1WL5BGhZwk47xdt9bTCQn9uqA+dsFMYXQDBAEAOpDhu
        /F4Rf6PK9HCn0wNqXNtguiXvPVJwkLpo7mYGFHAEMK5qXvGyMYqz9ivSQssWajczQ2AA64umajdoa
        DPGdUUcg==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1peaeq-004FKp-1B
        for fio@vger.kernel.org;
        Tue, 21 Mar 2023 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id EEC881BC014B; Tue, 21 Mar 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20230321120001.EEC881BC014B@kernel.dk>
Date:   Tue, 21 Mar 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit a967e54d34afe3bb10cd521d78bcaea2dd8c7cdc:

  stat: Fix ioprio print (2023-03-15 19:18:47 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 51bbb1a120c96ae7b93d058c7ce418962b202515:

  docs: clean up steadystate options (2023-03-20 13:57:47 -0400)

----------------------------------------------------------------
Christian Loehle (1):
      fio: steadystate: allow for custom check interval

Vincent Fu (3):
      steadystate: fix slope calculation for variable check intervals
      steadystate: add some TODO items
      docs: clean up steadystate options

 HOWTO.rst              | 17 +++++++++---
 STEADYSTATE-TODO       | 10 ++++++-
 cconv.c                |  2 ++
 fio.1                  | 13 +++++++--
 helper_thread.c        |  2 +-
 init.c                 | 19 +++++++++++++
 options.c              | 14 ++++++++++
 stat.c                 |  7 +++--
 steadystate.c          | 74 ++++++++++++++++++++++++++++++--------------------
 steadystate.h          |  3 +-
 t/steadystate_tests.py |  1 +
 thread_options.h       |  2 ++
 12 files changed, 120 insertions(+), 44 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index bbd9496e..5240f9da 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3821,10 +3821,11 @@ Steady state
 
 .. option:: steadystate_duration=time, ss_dur=time
 
-	A rolling window of this duration will be used to judge whether steady state
-	has been reached. Data will be collected once per second. The default is 0
-	which disables steady state detection.  When the unit is omitted, the
-	value is interpreted in seconds.
+        A rolling window of this duration will be used to judge whether steady
+        state has been reached. Data will be collected every
+        :option:`ss_interval`.  The default is 0 which disables steady state
+        detection.  When the unit is omitted, the value is interpreted in
+        seconds.
 
 .. option:: steadystate_ramp_time=time, ss_ramp=time
 
@@ -3832,6 +3833,14 @@ Steady state
 	collection for checking the steady state job termination criterion. The
 	default is 0.  When the unit is omitted, the value is interpreted in seconds.
 
+.. option:: steadystate_check_interval=time, ss_interval=time
+
+        The values during the rolling window will be collected with a period of
+        this value. If :option:`ss_interval` is 30s and :option:`ss_dur` is
+        300s, 10 measurements will be taken. Default is 1s but that might not
+        converge, especially for slower devices, so set this accordingly. When
+        the unit is omitted, the value is interpreted in seconds.
+
 
 Measurements and reporting
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
diff --git a/STEADYSTATE-TODO b/STEADYSTATE-TODO
index e4b146e9..2848eb54 100644
--- a/STEADYSTATE-TODO
+++ b/STEADYSTATE-TODO
@@ -1,6 +1,14 @@
 Known issues/TODO (for steady-state)
 
-- Allow user to specify the frequency of measurements
+- Replace the test script with a better one
+  - Add test cases for the new check_interval option
+  - Parse debug=steadystate output to check calculations
+
+- Instead of calculating `intervals` every time, calculate it once and stash it
+  somewhere
+
+- Add the time unit to the ss_dur and check_interval variable names to reduce
+  possible confusion
 
 - Better documentation for output
 
diff --git a/cconv.c b/cconv.c
index 05ac75e3..1ae38b1b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -252,6 +252,7 @@ int convert_thread_options_to_cpu(struct thread_options *o,
 	o->ss_ramp_time = le64_to_cpu(top->ss_ramp_time);
 	o->ss_state = le32_to_cpu(top->ss_state);
 	o->ss_limit.u.f = fio_uint64_to_double(le64_to_cpu(top->ss_limit.u.i));
+	o->ss_check_interval = le64_to_cpu(top->ss_check_interval);
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
 	o->zone_capacity = le64_to_cpu(top->zone_capacity);
@@ -614,6 +615,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->ss_ramp_time = __cpu_to_le64(top->ss_ramp_time);
 	top->ss_state = cpu_to_le32(top->ss_state);
 	top->ss_limit.u.i = __cpu_to_le64(fio_double_to_uint64(o->ss_limit.u.f));
+	top->ss_check_interval = __cpu_to_le64(top->ss_check_interval);
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
 	top->zone_capacity = __cpu_to_le64(o->zone_capacity);
diff --git a/fio.1 b/fio.1
index a238331c..e2db3a3f 100644
--- a/fio.1
+++ b/fio.1
@@ -3532,14 +3532,21 @@ slope. Stop the job if the slope falls below the specified limit.
 .TP
 .BI steadystate_duration \fR=\fPtime "\fR,\fP ss_dur" \fR=\fPtime
 A rolling window of this duration will be used to judge whether steady state
-has been reached. Data will be collected once per second. The default is 0
-which disables steady state detection. When the unit is omitted, the
-value is interpreted in seconds.
+has been reached. Data will be collected every \fBss_interval\fR. The default
+is 0 which disables steady state detection. When the unit is omitted, the value
+is interpreted in seconds.
 .TP
 .BI steadystate_ramp_time \fR=\fPtime "\fR,\fP ss_ramp" \fR=\fPtime
 Allow the job to run for the specified duration before beginning data
 collection for checking the steady state job termination criterion. The
 default is 0. When the unit is omitted, the value is interpreted in seconds.
+.TP
+.BI steadystate_check_interval \fR=\fPtime "\fR,\fP ss_interval" \fR=\fPtime
+The values suring the rolling window will be collected with a period of this
+value. If \fBss_interval\fR is 30s and \fBss_dur\fR is 300s, 10 measurements
+will be taken. Default is 1s but that might not converge, especially for slower
+devices, so set this accordingly. When the unit is omitted, the value is
+interpreted in seconds.
 .SS "Measurements and reporting"
 .TP
 .BI per_job_logs \fR=\fPbool
diff --git a/helper_thread.c b/helper_thread.c
index b9b83db3..77016638 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -281,7 +281,7 @@ static void *helper_thread_main(void *data)
 		},
 		{
 			.name = "steadystate",
-			.interval_ms = steadystate_enabled ? STEADYSTATE_MSEC :
+			.interval_ms = steadystate_enabled ? ss_check_interval :
 				0,
 			.func = steadystate_check,
 		}
diff --git a/init.c b/init.c
index 442dab42..a70f749a 100644
--- a/init.c
+++ b/init.c
@@ -981,6 +981,25 @@ static int fixup_options(struct thread_data *td)
 		}
 	}
 
+	for_each_td(td2) {
+		if (td->o.ss_check_interval != td2->o.ss_check_interval) {
+			log_err("fio: conflicting ss_check_interval: %llu and %llu, must be globally equal\n",
+					td->o.ss_check_interval, td2->o.ss_check_interval);
+			ret |= 1;
+		}
+	} end_for_each();
+	if (td->o.ss_dur && td->o.ss_check_interval / 1000L < 1000) {
+		log_err("fio: ss_check_interval must be at least 1s\n");
+		ret |= 1;
+
+	}
+	if (td->o.ss_dur && (td->o.ss_dur % td->o.ss_check_interval != 0 || td->o.ss_dur <= td->o.ss_check_interval)) {
+		log_err("fio: ss_duration %lluus must be multiple of ss_check_interval %lluus\n",
+				td->o.ss_dur, td->o.ss_check_interval);
+		ret |= 1;
+	}
+
+
 	return ret;
 }
 
diff --git a/options.c b/options.c
index 91049af5..18857795 100644
--- a/options.c
+++ b/options.c
@@ -5228,6 +5228,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_GENERAL,
 		.group  = FIO_OPT_G_RUNTIME,
 	},
+        {
+		.name   = "steadystate_check_interval",
+		.lname  = "Steady state check interval",
+		.alias  = "ss_interval",
+		.parent	= "steadystate",
+		.type   = FIO_OPT_STR_VAL_TIME,
+		.off1   = offsetof(struct thread_options, ss_check_interval),
+		.help   = "Polling interval for the steady state check (too low means steadystate will not converge)",
+		.def    = "1",
+		.is_seconds = 1,
+		.is_time = 1,
+		.category = FIO_OPT_C_GENERAL,
+		.group  = FIO_OPT_G_RUNTIME,
+	},
 	{
 		.name = NULL,
 	},
diff --git a/stat.c b/stat.c
index 56be330b..d779a90f 100644
--- a/stat.c
+++ b/stat.c
@@ -1874,6 +1874,7 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		struct json_array *iops, *bw;
 		int j, k, l;
 		char ss_buf[64];
+		int intervals = ts->ss_dur / (ss_check_interval / 1000L);
 
 		snprintf(ss_buf, sizeof(ss_buf), "%s%s:%f%s",
 			ts->ss_state & FIO_SS_IOPS ? "iops" : "bw",
@@ -1907,9 +1908,9 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		if ((ts->ss_state & FIO_SS_ATTAINED) || !(ts->ss_state & FIO_SS_BUFFER_FULL))
 			j = ts->ss_head;
 		else
-			j = ts->ss_head == 0 ? ts->ss_dur - 1 : ts->ss_head - 1;
-		for (l = 0; l < ts->ss_dur; l++) {
-			k = (j + l) % ts->ss_dur;
+			j = ts->ss_head == 0 ? intervals - 1 : ts->ss_head - 1;
+		for (l = 0; l < intervals; l++) {
+			k = (j + l) % intervals;
 			json_array_add_value_int(bw, ts->ss_bw_data[k]);
 			json_array_add_value_int(iops, ts->ss_iops_data[k]);
 		}
diff --git a/steadystate.c b/steadystate.c
index 14cdf0ed..3e3683f3 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -4,6 +4,7 @@
 #include "steadystate.h"
 
 bool steadystate_enabled = false;
+unsigned int ss_check_interval = 1000;
 
 void steadystate_free(struct thread_data *td)
 {
@@ -15,8 +16,10 @@ void steadystate_free(struct thread_data *td)
 
 static void steadystate_alloc(struct thread_data *td)
 {
-	td->ss.bw_data = calloc(td->ss.dur, sizeof(uint64_t));
-	td->ss.iops_data = calloc(td->ss.dur, sizeof(uint64_t));
+	int intervals = td->ss.dur / (ss_check_interval / 1000L);
+
+	td->ss.bw_data = calloc(intervals, sizeof(uint64_t));
+	td->ss.iops_data = calloc(intervals, sizeof(uint64_t));
 
 	td->ss.state |= FIO_SS_DATA;
 }
@@ -64,6 +67,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 	double result;
 	struct steadystate_data *ss = &td->ss;
 	uint64_t new_val;
+	int intervals = ss->dur / (ss_check_interval / 1000L);
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
@@ -73,15 +77,15 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 	else
 		new_val = bw;
 
-	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
 			/* first time through */
-			for(i = 0, ss->sum_y = 0; i < ss->dur; i++) {
+			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
 				else
 					ss->sum_y += ss->bw_data[i];
-				j = (ss->head + i) % ss->dur;
+				j = (ss->head + i) % intervals;
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_xy += i * ss->iops_data[j];
 				else
@@ -91,7 +95,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 		} else {		/* easy to update the sums */
 			ss->sum_y -= ss->oldest_y;
 			ss->sum_y += new_val;
-			ss->sum_xy = ss->sum_xy - ss->sum_y + ss->dur * new_val;
+			ss->sum_xy = ss->sum_xy - ss->sum_y + intervals * new_val;
 		}
 
 		if (ss->state & FIO_SS_IOPS)
@@ -105,10 +109,10 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 		 * equally spaced when they are often off by a few milliseconds.
 		 * This assumption greatly simplifies the calculations.
 		 */
-		ss->slope = (ss->sum_xy - (double) ss->sum_x * ss->sum_y / ss->dur) /
-				(ss->sum_x_sq - (double) ss->sum_x * ss->sum_x / ss->dur);
+		ss->slope = (ss->sum_xy - (double) ss->sum_x * ss->sum_y / intervals) /
+				(ss->sum_x_sq - (double) ss->sum_x * ss->sum_x / intervals);
 		if (ss->state & FIO_SS_PCT)
-			ss->criterion = 100.0 * ss->slope / (ss->sum_y / ss->dur);
+			ss->criterion = 100.0 * ss->slope / (ss->sum_y / intervals);
 		else
 			ss->criterion = ss->slope;
 
@@ -123,9 +127,9 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 			return true;
 	}
 
-	ss->tail = (ss->tail + 1) % ss->dur;
+	ss->tail = (ss->tail + 1) % intervals;
 	if (ss->tail <= ss->head)
-		ss->head = (ss->head + 1) % ss->dur;
+		ss->head = (ss->head + 1) % intervals;
 
 	return false;
 }
@@ -138,18 +142,20 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 	double mean;
 
 	struct steadystate_data *ss = &td->ss;
+	int intervals = ss->dur / (ss_check_interval / 1000L);
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
 
-	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals  - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
 			/* first time through */
-			for(i = 0, ss->sum_y = 0; i < ss->dur; i++)
+			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
 				else
 					ss->sum_y += ss->bw_data[i];
+			}
 			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sum */
 			ss->sum_y -= ss->oldest_y;
@@ -164,10 +170,10 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 		else
 			ss->oldest_y = ss->bw_data[ss->head];
 
-		mean = (double) ss->sum_y / ss->dur;
+		mean = (double) ss->sum_y / intervals;
 		ss->deviation = 0.0;
 
-		for (i = 0; i < ss->dur; i++) {
+		for (i = 0; i < intervals; i++) {
 			if (ss->state & FIO_SS_IOPS)
 				diff = ss->iops_data[i] - mean;
 			else
@@ -180,8 +186,9 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 		else
 			ss->criterion = ss->deviation;
 
-		dprint(FD_STEADYSTATE, "sum_y: %llu, mean: %f, max diff: %f, "
+		dprint(FD_STEADYSTATE, "intervals: %d, sum_y: %llu, mean: %f, max diff: %f, "
 					"objective: %f, limit: %f\n",
+					intervals,
 					(unsigned long long) ss->sum_y, mean,
 					ss->deviation, ss->criterion, ss->limit);
 
@@ -189,9 +196,9 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 			return true;
 	}
 
-	ss->tail = (ss->tail + 1) % ss->dur;
-	if (ss->tail <= ss->head)
-		ss->head = (ss->head + 1) % ss->dur;
+	ss->tail = (ss->tail + 1) % intervals;
+	if (ss->tail == ss->head)
+		ss->head = (ss->head + 1) % intervals;
 
 	return false;
 }
@@ -228,10 +235,10 @@ int steadystate_check(void)
 		fio_gettime(&now, NULL);
 		if (ss->ramp_time && !(ss->state & FIO_SS_RAMP_OVER)) {
 			/*
-			 * Begin recording data one second after ss->ramp_time
+			 * Begin recording data one check interval after ss->ramp_time
 			 * has elapsed
 			 */
-			if (utime_since(&td->epoch, &now) >= (ss->ramp_time + 1000000L))
+			if (utime_since(&td->epoch, &now) >= (ss->ramp_time + ss_check_interval * 1000L))
 				ss->state |= FIO_SS_RAMP_OVER;
 		}
 
@@ -250,8 +257,10 @@ int steadystate_check(void)
 		memcpy(&ss->prev_time, &now, sizeof(now));
 
 		if (ss->state & FIO_SS_RAMP_OVER) {
-			group_bw += 1000 * (td_bytes - ss->prev_bytes) / rate_time;
-			group_iops += 1000 * (td_iops - ss->prev_iops) / rate_time;
+			group_bw += rate_time * (td_bytes - ss->prev_bytes) /
+				(ss_check_interval * ss_check_interval / 1000L);
+			group_iops += rate_time * (td_iops - ss->prev_iops) /
+				(ss_check_interval * ss_check_interval / 1000L);
 			++group_ramp_time_over;
 		}
 		ss->prev_iops = td_iops;
@@ -301,6 +310,7 @@ int td_steadystate_init(struct thread_data *td)
 {
 	struct steadystate_data *ss = &td->ss;
 	struct thread_options *o = &td->o;
+	int intervals;
 
 	memset(ss, 0, sizeof(*ss));
 
@@ -312,13 +322,15 @@ int td_steadystate_init(struct thread_data *td)
 		ss->dur = o->ss_dur;
 		ss->limit = o->ss_limit.u.f;
 		ss->ramp_time = o->ss_ramp_time;
+		ss_check_interval = o->ss_check_interval / 1000L;
 
 		ss->state = o->ss_state;
 		if (!td->ss.ramp_time)
 			ss->state |= FIO_SS_RAMP_OVER;
 
-		ss->sum_x = o->ss_dur * (o->ss_dur - 1) / 2;
-		ss->sum_x_sq = (o->ss_dur - 1) * (o->ss_dur) * (2*o->ss_dur - 1) / 6;
+		intervals = ss->dur / (ss_check_interval / 1000L);
+		ss->sum_x = intervals * (intervals - 1) / 2;
+		ss->sum_x_sq = (intervals - 1) * (intervals) * (2*intervals - 1) / 6;
 	}
 
 	/* make sure that ss options are consistent within reporting group */
@@ -345,26 +357,28 @@ uint64_t steadystate_bw_mean(struct thread_stat *ts)
 {
 	int i;
 	uint64_t sum;
-
+	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
+	
 	if (!ts->ss_dur)
 		return 0;
 
-	for (i = 0, sum = 0; i < ts->ss_dur; i++)
+	for (i = 0, sum = 0; i < intervals; i++)
 		sum += ts->ss_bw_data[i];
 
-	return sum / ts->ss_dur;
+	return sum / intervals;
 }
 
 uint64_t steadystate_iops_mean(struct thread_stat *ts)
 {
 	int i;
 	uint64_t sum;
+	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
 
 	if (!ts->ss_dur)
 		return 0;
 
-	for (i = 0, sum = 0; i < ts->ss_dur; i++)
+	for (i = 0, sum = 0; i < intervals; i++)
 		sum += ts->ss_iops_data[i];
 
-	return sum / ts->ss_dur;
+	return sum / intervals;
 }
diff --git a/steadystate.h b/steadystate.h
index bbb86fbb..f1ef2b20 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -11,6 +11,7 @@ extern uint64_t steadystate_bw_mean(struct thread_stat *);
 extern uint64_t steadystate_iops_mean(struct thread_stat *);
 
 extern bool steadystate_enabled;
+extern unsigned int ss_check_interval;
 
 struct steadystate_data {
 	double limit;
@@ -64,6 +65,4 @@ enum {
 	FIO_SS_BW_SLOPE		= FIO_SS_BW | FIO_SS_SLOPE,
 };
 
-#define STEADYSTATE_MSEC	1000
-
 #endif
diff --git a/t/steadystate_tests.py b/t/steadystate_tests.py
index d6ffd177..d0fa73b2 100755
--- a/t/steadystate_tests.py
+++ b/t/steadystate_tests.py
@@ -115,6 +115,7 @@ if __name__ == '__main__':
               {'s': False, 'timeout': 20, 'numjobs': 2},
               {'s': True, 'timeout': 100, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 5, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
               {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+              {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True, 'ss_interval': 5},
             ]
 
     jobnum = 0
diff --git a/thread_options.h b/thread_options.h
index 2520357c..6670cbbf 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -211,6 +211,7 @@ struct thread_options {
 	fio_fp64_t ss_limit;
 	unsigned long long ss_dur;
 	unsigned long long ss_ramp_time;
+	unsigned long long ss_check_interval;
 	unsigned int overwrite;
 	unsigned int bw_avg_time;
 	unsigned int iops_avg_time;
@@ -533,6 +534,7 @@ struct thread_options_pack {
 	uint64_t ss_ramp_time;
 	uint32_t ss_state;
 	fio_fp64_t ss_limit;
+	uint64_t ss_check_interval;
 	uint32_t overwrite;
 	uint32_t bw_avg_time;
 	uint32_t iops_avg_time;
