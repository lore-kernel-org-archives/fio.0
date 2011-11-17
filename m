Return-Path: <fio-owner@vger.kernel.org>
Received: from 67-207-137-80.slicehost.net ([67.207.137.80]:33076 "EHLO
	joshcarter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab1KQVWn convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 17 Nov 2011 16:22:43 -0500
Received: from [192.168.4.140] (207-225-98-3.dia.static.qwest.net [207.225.98.3])
	by joshcarter.com (Postfix) with ESMTPSA id 7D75D3D897
	for <fio@vger.kernel.org>; Thu, 17 Nov 2011 21:01:26 +0000 (UTC)
From: Josh Carter <public@joshcarter.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: bandwidth rate stepping
Date: Thu, 17 Nov 2011 14:01:24 -0700
Message-Id: <B0E0F2D6-B65B-4921-93E4-703A3090B702@joshcarter.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm wanting to use fio to test the latency of a storage system at various bandwidths. While I could use a script to run fio repeatedly at various rate= settings, that would give the storage device some "settle" time between tests, and I'd prefer to keep the test running constantly.

I've added this feature to my local copy, and it *just about* works ;) Config file and patch attached. Here's my problem: I'm getting a blip in bandwidth every time I step up the rate. This is very obvious when used with low rates/steps, like the config file below.

Second problem, at high rates/steps (like 1m/1m), bandwidth logging gets messed up. While tracking this down, it appeared that after the first rate step, td->bw_sample_time was getting reset every 250ms whereas the default bw_avg_time is 500ms, hence no logging. (Note: if I analyze the latency logs, it appears the stepping did actually work correctly, and with no spikes.)

As I keep messing with this, it's clear I don't fully understand the interaction between my change and the big loop in thread_main(). Can someone here take a look at my changes and give me some guidance?

Many thanks,
Josh


-- fio job file

[global]
thread
ioengine=null
size=1m
time_based
runtime=30s
write_bw_log
write_lat_log

[ratestep]
rw=write
rate=,10k
ratestep=,5k
bs=4k


- Adding "ratestep=" option to config files; when used with "rate="
  option, it will step the rate up by ratestep every (ratecycle * 5)
  milliseconds. (Yea, should make the step interval configurable
  separately.)

- Added step_rate() near the end of do_io(), just after we do the
  check_min_rate() part.

Currently very fiddly; seems to get blips in bandwidth just after a
rate step, also at high rates/steps it messes up bandwidth logging.
Need feedback from mailing list.
---
 fio.c     |   40 ++++++++++++++++++++++++++++++++++++++++
 fio.h     |    4 +++-
 init.c    |    4 ++++
 options.c |    8 ++++++++
 4 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/fio.c b/fio.c
index 5b58ab8..9063c03 100644
--- a/fio.c
+++ b/fio.c
@@ -341,6 +341,39 @@ static int check_min_rate(struct thread_data *td, struct timeval *now,
 	return ret;
 }
 
+static int __step_rate(struct thread_data *td, struct timeval *now,
+		       enum fio_ddir ddir)
+{
+        unsigned long spent;
+        unsigned long long new_rate;
+	
+	assert(ddir_rw(ddir));
+
+	if (!td->o.ratestep[ddir])
+		return 0;
+
+	spent = mtime_since(&td->lastratestep[ddir], now);
+
+	if (spent < td->o.ratecycle * 5)
+	        return 0;
+		
+        new_rate = td->rate_bps[ddir] + td->o.ratestep[ddir];
+        td->o.rate[ddir] = td->rate_bps[ddir] = new_rate;
+
+	memcpy(&td->lastratestep[ddir], now, sizeof(*now));
+	return 0;
+}
+
+static int step_rate(struct thread_data *td, struct timeval *now)
+{
+	int ret = 0;
+
+	ret |= __step_rate(td, now, DDIR_READ);
+	ret |= __step_rate(td, now, DDIR_WRITE);
+
+	return ret;
+}
+
 static inline int runtime_exceeded(struct thread_data *td, struct timeval *t)
 {
 	if (!td->o.timeout)
@@ -813,6 +846,8 @@ sync_done:
 				td_verror(td, EIO, "check_min_rate");
 				break;
 			}
+			
+                        step_rate(td, &comp_time);
 		}
 
 		if (td->o.thinktime) {
@@ -1237,6 +1272,11 @@ static void *thread_main(void *data)
 	fio_gettime(&td->epoch, NULL);
 	getrusage(RUSAGE_SELF, &td->ru_start);
 
+	if (td->o.ratestep[0] || td->o.ratestep[1]) {
+		memcpy(&td->lastratestep[0], &td->epoch, sizeof(td->epoch));
+		memcpy(&td->lastratestep[1], &td->epoch, sizeof(td->epoch));
+	}
+
 	clear_state = 0;
 	while (keep_running(td)) {
 		fio_gettime(&td->start, NULL);
diff --git a/fio.h b/fio.h
index cc1f65f..36b15aa 100644
--- a/fio.h
+++ b/fio.h
@@ -212,6 +212,7 @@ struct thread_options {
 
 	unsigned int rate[2];
 	unsigned int ratemin[2];
+	unsigned int ratestep[2];
 	unsigned int ratecycle;
 	unsigned int rate_iops[2];
 	unsigned int rate_iops_min[2];
@@ -361,6 +362,7 @@ struct thread_data {
 	unsigned long rate_bytes[2];
 	unsigned long rate_blocks[2];
 	struct timeval lastrate[2];
+    struct timeval lastratestep[2];
 
 	unsigned long long total_io_size;
 	unsigned long long fill_device_size;
@@ -659,7 +661,7 @@ static inline int __should_check_rate(struct thread_data *td,
 	 * If some rate setting was given, we need to check it
 	 */
 	if (o->rate[ddir] || o->ratemin[ddir] || o->rate_iops[ddir] ||
-	    o->rate_iops_min[ddir])
+	    o->rate_iops_min[ddir] || o->ratestep[ddir])
 		return 1;
 
 	return 0;
diff --git a/init.c b/init.c
index 482ce09..717dfc5 100644
--- a/init.c
+++ b/init.c
@@ -498,6 +498,10 @@ static int fixup_options(struct thread_data *td)
 		log_err("fio: minimum rate exceeds rate\n");
 		ret = 1;
 	}
+	if ((o->ratestep[0] && !o->rate[0]) || (o->ratestep[1] && !o->rate[1])) {
+		log_err("fio: ratestep requires initial rate also set\n");
+                ret = 1;
+	}
 
 	if (!o->timeout && o->time_based) {
 		log_err("fio: time_based requires a runtime/timeout setting\n");
diff --git a/options.c b/options.c
index 53c3a82..a276bcb 100644
--- a/options.c
+++ b/options.c
@@ -1772,6 +1772,14 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.help	= "Job must meet this rate or it will be shutdown",
 		.parent	= "rate",
 	},
+        {
+        	.name	= "ratestep",
+        	.type	= FIO_OPT_INT,
+        	.off1	= td_var_offset(ratestep[0]),
+        	.off2	= td_var_offset(ratestep[1]),
+        	.help	= "Job will increment bandwidth rate by this amount each ratecycle",
+        	.parent	= "rate",
+        },
 	{
 		.name	= "rate_iops",
 		.type	= FIO_OPT_INT,
-- 
1.7.4.4


