Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84765245032
	for <fio@vger.kernel.org>; Fri, 25 Jul 2025 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753424273; cv=none; b=PsffECLWZ43ku9mDvROJppBD7kBhccCaxokMSLBlPnpXpq9d/8NxZW9/pffOeRRldDibqxCIg0RDvEUd35SWL5N3dzrKyvyCwaNxCbht5EaTDkz4LLqQvRtUGQ4BRPNhmNQOZLwudljM26WEy5r2KS4umo6e5kkmL9Bf4+Ij85Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753424273; c=relaxed/simple;
	bh=WijvVTSrW30kc1XZYIonjBG6JjjBu1Mu2vyoWbNE3Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKM35lu+jqD5Ad7NfauuQraq5wo9MKeQSSdYRTeychb6mlzfK9LYvnbYVhJEeaYX1H9Dk4v3LqHcsoyG7CZZBMILH8OPcbwzzfU0cCU6SzDGZYzPKMANip8qSKuWvxQWLttRZSFbhE5gUNLbEvTFOe5pdBiKlIN2aGtNjoI8qBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=I788SOjS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="I788SOjS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6hJ8FFnnNyaMOmy1o+INBnXrqNEdoMGu4liARmwM9LY=; b=I788SOjS/Pw1q+8E7TMlGjx+vj
	VetgMH1RuCdqVm3NZzpW2+LF+6mMz9Bk5fObJPcy5GbxvVDxLmT/3bZCAS8L3U4w9a8qtYZedaffZ
	WIEHOTxq+6WFaEvC6B0N6XU2tmicAPI6U3MNpjawGuBBxrGnObjMObUWvt2y4Ar9qTvkqjAOfV+C0
	RHtqOgzhdXf/KyFET4DNhga+4Rh2MBxtVUSfnXha6kV5K2/mpF9vwzKS2Qu+YW1p519X1t/HcXx4Y
	qLh7Xf1ZcRW1q1ZtgUKz6prkc4djhVc+Br0U+DhII2Cl3E1zfOBtbEVhayYbjiyoFS6rb74ag2FEJ
	ZGOk9Xlg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufBkc-000000099M2-3QNw;
	Fri, 25 Jul 2025 06:17:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: vincent.fu@samsung.com,
	fio@vger.kernel.org
Cc: mcgrof@kernel.org
Subject: [PATCH 2/2] fio: add latency steady state detection
Date: Thu, 24 Jul 2025 23:17:48 -0700
Message-ID: <20250725061748.2180898-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250725061748.2180898-1-mcgrof@kernel.org>
References: <20250725061748.2180898-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Add fio latency steady state support. This is based on the SNIA SSD
Performance Test Specification requirements for latency steady state
detection. The implementation calculates weighted average latency across
all I/O directions and supports both maximum mean deviation and slope-based
detection methods.

Tested successfully against NVMe device with debug output confirming
proper latency calculation and steady state evaluation.

Generated-by: Claude AI
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 HOWTO.rst                       | 12 +++++
 client.c                        |  1 +
 example_latency_steadystate.fio | 47 ++++++++++++++++++++
 options.c                       | 26 ++++++++++-
 stat.h                          | 10 +++++
 steadystate.c                   | 78 ++++++++++++++++++++++++++++-----
 steadystate.h                   |  7 +++
 7 files changed, 168 insertions(+), 13 deletions(-)
 create mode 100644 example_latency_steadystate.fio

diff --git a/HOWTO.rst b/HOWTO.rst
index 55ebc388..c5e6a0ad 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -4154,6 +4154,18 @@ Steady state
 			Collect bandwidth data and calculate the least squares regression
 			slope. Stop the job if the slope falls below the specified limit.
 
+		**lat**
+			Collect completion latency data and calculate the maximum mean
+			deviation. Stop the job if the deviation falls below the specified
+			limit. The latency values are weighted by the number of I/O samples
+			in each measurement interval.
+
+		**lat_slope**
+			Collect completion latency data and calculate the least squares
+			regression slope. Stop the job if the slope falls below the
+			specified limit. The latency values are weighted by the number
+			of I/O samples in each measurement interval.
+
 .. option:: steadystate_duration=time, ss_dur=time
 
         A rolling window of this duration will be used to judge whether steady
diff --git a/client.c b/client.c
index 923b092e..af37aea1 100644
--- a/client.c
+++ b/client.c
@@ -1077,6 +1077,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 		for (i = 0; i < dst->ss_dur; i++ ) {
 			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
 			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
+			dst->ss_lat_data[i] = le64_to_cpu(src->ss_lat_data[i]);
 		}
 	}
 
diff --git a/example_latency_steadystate.fio b/example_latency_steadystate.fio
new file mode 100644
index 00000000..b769ad15
--- /dev/null
+++ b/example_latency_steadystate.fio
@@ -0,0 +1,47 @@
+# Example FIO job file demonstrating latency steady state detection
+# This example shows how to use FIO's latency steady state detection
+# to automatically terminate workloads when latency stabilizes
+#
+# Based on SNIA SSD Performance Test Specification requirements:
+# - Steady state is achieved when latency measurements don't change more than
+#   20% for 5 measurement windows and remain within 5% of a line with 10% slope
+# - This example uses more conservative 5% deviation threshold for demonstration
+
+[global]
+# Basic I/O parameters
+ioengine=libaio
+iodepth=32
+bs=4k
+direct=1
+rw=randread
+numjobs=1
+time_based=1
+runtime=3600  # Max runtime: 1 hour (will terminate early if steady state reached)
+
+# Steady state detection parameters
+steadystate=lat:5%           # Stop when latency mean deviation < 5% of average
+steadystate_duration=300     # Use 5-minute rolling window for measurements
+steadystate_ramp_time=60     # Wait 1 minute before starting measurements
+steadystate_check_interval=10 # Take measurements every 10 seconds
+
+# Output options
+write_lat_log=lat_steadystate
+log_avg_msec=10000           # Log average latency every 10 seconds
+
+[latency_steady_test]
+filename=/dev/nvme3n1
+size=10G
+
+# Alternative steady state configurations (uncomment to try):
+
+# Use slope-based detection instead of deviation:
+# steadystate=lat_slope:0.1%
+
+# More aggressive detection (faster convergence):
+# steadystate=lat:2%
+# steadystate_duration=120    # 2-minute window
+# steadystate_check_interval=5 # Check every 5 seconds
+
+# More conservative detection (slower convergence):
+# steadystate=lat:10%
+# steadystate_duration=600    # 10-minute window
diff --git a/options.c b/options.c
index 6295a616..8884dd8a 100644
--- a/options.c
+++ b/options.c
@@ -1370,7 +1370,8 @@ static int str_steadystate_cb(void *data, const char *str)
 	long long ll;
 
 	if (td->o.ss_state != FIO_SS_IOPS && td->o.ss_state != FIO_SS_IOPS_SLOPE &&
-	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE) {
+	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE &&
+	    td->o.ss_state != FIO_SS_LAT && td->o.ss_state != FIO_SS_LAT_SLOPE) {
 		/* should be impossible to get here */
 		log_err("fio: unknown steady state criterion\n");
 		return 1;
@@ -1414,6 +1415,21 @@ static int str_steadystate_cb(void *data, const char *str)
 			return 0;
 
 		td->o.ss_limit.u.f = val;
+        } else if (td->o.ss_state & FIO_SS_LAT) {
+                long long tns;
+                if (check_str_time(nr, &tns, 0)) {
+                        log_err("fio: steadystate latency threshold parsing failed\n");
+                        free(nr);
+                        return 1;
+                }
+
+                dprint(FD_PARSE, "set steady state latency threshold to %lld nsec\n", tns);
+                free(nr);
+                if (parse_dryrun())
+                        return 0;
+
+                td->o.ss_limit.u.f = (double) tns;
+
 	} else {	/* bandwidth criterion */
 		if (str_to_decimal(nr, &ll, 1, td, 0, 0)) {
 			log_err("fio: steadystate BW threshold postfix parsing failed\n");
@@ -5489,6 +5505,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = FIO_SS_BW_SLOPE,
 			    .help = "slope calculated from bandwidth measurements",
 			  },
+                          { .ival = "lat",
+                            .oval = FIO_SS_LAT,
+                            .help = "maximum mean deviation of latency measurements",
+                          },
+                          { .ival = "lat_slope",
+                            .oval = FIO_SS_LAT_SLOPE,
+                            .help = "slope calculated from latency measurements",
+                          },
 		},
 		.category = FIO_OPT_C_GENERAL,
 		.group  = FIO_OPT_G_RUNTIME,
diff --git a/stat.h b/stat.h
index ac74d6c2..fad7e8d3 100644
--- a/stat.h
+++ b/stat.h
@@ -282,6 +282,16 @@ struct thread_stat {
 		uint64_t pad5;
 	};
 
+	union {
+		uint64_t *ss_lat_data;
+		/*
+		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
+		 * be stored at this offset from the start of the payload.
+		 */
+		uint64_t ss_lat_data_offset;
+		uint64_t pad5b;
+	};
+
 	union {
 		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
 		/*
diff --git a/steadystate.c b/steadystate.c
index 3e3683f3..96924b96 100644
--- a/steadystate.c
+++ b/steadystate.c
@@ -10,8 +10,10 @@ void steadystate_free(struct thread_data *td)
 {
 	free(td->ss.iops_data);
 	free(td->ss.bw_data);
+	free(td->ss.lat_data);
 	td->ss.iops_data = NULL;
 	td->ss.bw_data = NULL;
+	td->ss.lat_data = NULL;
 }
 
 static void steadystate_alloc(struct thread_data *td)
@@ -20,6 +22,7 @@ static void steadystate_alloc(struct thread_data *td)
 
 	td->ss.bw_data = calloc(intervals, sizeof(uint64_t));
 	td->ss.iops_data = calloc(intervals, sizeof(uint64_t));
+	td->ss.lat_data = calloc(intervals, sizeof(uint64_t));
 
 	td->ss.state |= FIO_SS_DATA;
 }
@@ -60,7 +63,7 @@ void steadystate_setup(void)
 		steadystate_alloc(prev_td);
 }
 
-static bool steadystate_slope(uint64_t iops, uint64_t bw,
+static bool steadystate_slope(uint64_t iops, uint64_t bw, double lat,
 			      struct thread_data *td)
 {
 	int i, j;
@@ -71,11 +74,14 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
+	ss->lat_data[ss->tail] = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_IOPS)
 		new_val = iops;
-	else
+	else if (ss->state & FIO_SS_BW)
 		new_val = bw;
+	else
+		new_val = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
@@ -83,13 +89,17 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_y += ss->bw_data[i];
+				else
+					ss->sum_y += ss->lat_data[i];
 				j = (ss->head + i) % intervals;
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_xy += i * ss->iops_data[j];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_xy += i * ss->bw_data[j];
+				else
+					ss->sum_xy += i * ss->lat_data[j];
 			}
 			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sums */
@@ -100,8 +110,10 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 
 		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
-		else
+		else if (ss->state & FIO_SS_BW)
 			ss->oldest_y = ss->bw_data[ss->head];
+		else
+			ss->oldest_y = ss->lat_data[ss->head];
 
 		/*
 		 * calculate slope as (sum_xy - sum_x * sum_y / n) / (sum_(x^2)
@@ -134,7 +146,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
 	return false;
 }
 
-static bool steadystate_deviation(uint64_t iops, uint64_t bw,
+static bool steadystate_deviation(uint64_t iops, uint64_t bw, double lat,
 				  struct thread_data *td)
 {
 	int i;
@@ -146,6 +158,7 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 
 	ss->bw_data[ss->tail] = bw;
 	ss->iops_data[ss->tail] = iops;
+	ss->lat_data[ss->tail] = (uint64_t)lat;
 
 	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals  - 1) {
 		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
@@ -153,22 +166,28 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
 				if (ss->state & FIO_SS_IOPS)
 					ss->sum_y += ss->iops_data[i];
-				else
+				else if (ss->state & FIO_SS_BW)
 					ss->sum_y += ss->bw_data[i];
+				else
+					ss->sum_y += ss->lat_data[i];
 			}
 			ss->state |= FIO_SS_BUFFER_FULL;
 		} else {		/* easy to update the sum */
 			ss->sum_y -= ss->oldest_y;
 			if (ss->state & FIO_SS_IOPS)
 				ss->sum_y += ss->iops_data[ss->tail];
-			else
+			else if (ss->state & FIO_SS_BW)
 				ss->sum_y += ss->bw_data[ss->tail];
+			else
+				ss->sum_y += ss->lat_data[ss->tail];
 		}
 
 		if (ss->state & FIO_SS_IOPS)
 			ss->oldest_y = ss->iops_data[ss->head];
-		else
+		else if (ss->state & FIO_SS_BW)
 			ss->oldest_y = ss->bw_data[ss->head];
+		else
+			ss->oldest_y = ss->lat_data[ss->head];
 
 		mean = (double) ss->sum_y / intervals;
 		ss->deviation = 0.0;
@@ -176,8 +195,10 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
 		for (i = 0; i < intervals; i++) {
 			if (ss->state & FIO_SS_IOPS)
 				diff = ss->iops_data[i] - mean;
-			else
+			else if (ss->state & FIO_SS_BW)
 				diff = ss->bw_data[i] - mean;
+			else
+				diff = ss->lat_data[i] - mean;
 			ss->deviation = max(ss->deviation, diff * (diff < 0.0 ? -1.0 : 1.0));
 		}
 
@@ -209,13 +230,18 @@ int steadystate_check(void)
 	unsigned long rate_time;
 	struct timespec now;
 	uint64_t group_bw = 0, group_iops = 0;
+	double group_lat_sum = 0.0;
+	uint64_t group_lat_samples = 0;
 	uint64_t td_iops, td_bytes;
+	double group_lat;
 	bool ret;
 
 	prev_groupid = -1;
 	for_each_td(td) {
 		const bool needs_lock = td_async_processing(td);
 		struct steadystate_data *ss = &td->ss;
+		double td_lat_sum = 0.0;
+		uint64_t td_lat_samples = 0;
 
 		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
 		    td->runstate >= TD_EXITED || !ss->state ||
@@ -228,6 +254,8 @@ int steadystate_check(void)
 		    (td->o.group_reporting && td->groupid != prev_groupid)) {
 			group_bw = 0;
 			group_iops = 0;
+			group_lat_sum = 0.0;
+			group_lat_samples = 0;
 			group_ramp_time_over = 0;
 		}
 		prev_groupid = td->groupid;
@@ -248,6 +276,9 @@ int steadystate_check(void)
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			td_iops += td->io_blocks[ddir];
 			td_bytes += td->io_bytes[ddir];
+			td_lat_sum += td->ts.clat_stat[ddir].mean.u.f *
+				      td->ts.clat_stat[ddir].samples;
+			td_lat_samples += td->ts.clat_stat[ddir].samples;
 		}
 
 		if (needs_lock)
@@ -261,10 +292,14 @@ int steadystate_check(void)
 				(ss_check_interval * ss_check_interval / 1000L);
 			group_iops += rate_time * (td_iops - ss->prev_iops) /
 				(ss_check_interval * ss_check_interval / 1000L);
+			group_lat_sum += td_lat_sum - ss->prev_lat_sum;
+			group_lat_samples += td_lat_samples - ss->prev_lat_samples;
 			++group_ramp_time_over;
 		}
 		ss->prev_iops = td_iops;
 		ss->prev_bytes = td_bytes;
+		ss->prev_lat_sum = td_lat_sum;
+		ss->prev_lat_samples = td_lat_samples;
 
 		if (td->o.group_reporting && !(ss->state & FIO_SS_DATA))
 			continue;
@@ -284,10 +319,14 @@ int steadystate_check(void)
 					(unsigned long long) group_bw,
 					ss->head, ss->tail);
 
+		group_lat = 0.0;
+		if (group_lat_samples)
+			group_lat = group_lat_sum / group_lat_samples;
+
 		if (ss->state & FIO_SS_SLOPE)
-			ret = steadystate_slope(group_iops, group_bw, td);
+			ret = steadystate_slope(group_iops, group_bw, group_lat, td);
 		else
-			ret = steadystate_deviation(group_iops, group_bw, td);
+			ret = steadystate_deviation(group_iops, group_bw, group_lat, td);
 
 		if (ret) {
 			if (td->o.group_reporting) {
@@ -382,3 +421,18 @@ uint64_t steadystate_iops_mean(struct thread_stat *ts)
 
 	return sum / intervals;
 }
+
+uint64_t steadystate_lat_mean(struct thread_stat *ts)
+{
+	int i;
+	uint64_t sum;
+	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
+
+	if (!ts->ss_dur)
+		return 0;
+
+	for (i = 0, sum = 0; i < intervals; i++)
+		sum += ts->ss_lat_data[i];
+
+	return sum / intervals;
+}
diff --git a/steadystate.h b/steadystate.h
index f1ef2b20..fffcb463 100644
--- a/steadystate.h
+++ b/steadystate.h
@@ -9,6 +9,7 @@ extern void steadystate_setup(void);
 extern int td_steadystate_init(struct thread_data *);
 extern uint64_t steadystate_bw_mean(struct thread_stat *);
 extern uint64_t steadystate_iops_mean(struct thread_stat *);
+extern uint64_t steadystate_lat_mean(struct thread_stat *);
 
 extern bool steadystate_enabled;
 extern unsigned int ss_check_interval;
@@ -24,6 +25,7 @@ struct steadystate_data {
 	unsigned int tail;
 	uint64_t *iops_data;
 	uint64_t *bw_data;
+	uint64_t *lat_data;
 
 	double slope;
 	double deviation;
@@ -38,6 +40,8 @@ struct steadystate_data {
 	struct timespec prev_time;
 	uint64_t prev_iops;
 	uint64_t prev_bytes;
+	double prev_lat_sum;
+	uint64_t prev_lat_samples;
 };
 
 enum {
@@ -49,6 +53,7 @@ enum {
 	__FIO_SS_DATA,
 	__FIO_SS_PCT,
 	__FIO_SS_BUFFER_FULL,
+	__FIO_SS_LAT,
 };
 
 enum {
@@ -60,9 +65,11 @@ enum {
 	FIO_SS_DATA		= 1 << __FIO_SS_DATA,
 	FIO_SS_PCT		= 1 << __FIO_SS_PCT,
 	FIO_SS_BUFFER_FULL	= 1 << __FIO_SS_BUFFER_FULL,
+	FIO_SS_LAT		= 1 << __FIO_SS_LAT,
 
 	FIO_SS_IOPS_SLOPE	= FIO_SS_IOPS | FIO_SS_SLOPE,
 	FIO_SS_BW_SLOPE		= FIO_SS_BW | FIO_SS_SLOPE,
+	FIO_SS_LAT_SLOPE	= FIO_SS_LAT | FIO_SS_SLOPE,
 };
 
 #endif
-- 
2.47.2

