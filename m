Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343731AbhA0NAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Jan 2021 08:00:46 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11EAC061573
        for <fio@vger.kernel.org>; Wed, 27 Jan 2021 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l4kQV-0003qL-N2
        for fio@vger.kernel.org; Wed, 27 Jan 2021 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210127130001.CC1301BC0153@kernel.dk>
Date: Wed, 27 Jan 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e493ceaeccfaebda9d30435cbbe30e97058313a7:

  HOWTO: add sg 'hipri' option (2021-01-25 14:06:48 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7216b664d93ef9c59ca5dbc8f54bad2118231ee3:

  Calculate min_rate with the consideration of thinktime (2021-01-26 08:58:42 -0700)

----------------------------------------------------------------
Hongwei Qin (2):
      Add thinktime_blocks_type parameter
      Calculate min_rate with the consideration of thinktime

 HOWTO            |  7 +++++++
 backend.c        | 22 ++++++++++++++++------
 cconv.c          |  2 ++
 engines/cpu.c    |  1 +
 fio.1            |  6 ++++++
 fio.h            |  5 +++++
 options.c        | 22 ++++++++++++++++++++++
 thread_options.h |  5 +++++
 8 files changed, 64 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 3ec86aff..b6d1b58a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2574,6 +2574,13 @@ I/O rate
 	before we have to complete it and do our :option:`thinktime`. In other words, this
 	setting effectively caps the queue depth if the latter is larger.
 
+.. option:: thinktime_blocks_type=str
+
+	Only valid if :option:`thinktime` is set - control how :option:`thinktime_blocks`
+	triggers. The default is `complete`, which triggers thinktime when fio completes
+	:option:`thinktime_blocks` blocks. If this is set to `issue`, then the trigger happens
+	at the issue side.
+
 .. option:: rate=int[,int][,int]
 
 	Cap the bandwidth used by this job. The number is in bytes/sec, the normal
diff --git a/backend.c b/backend.c
index e20a2e07..f2efddd6 100644
--- a/backend.c
+++ b/backend.c
@@ -858,14 +858,15 @@ static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
 	return 0;
 }
 
-static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
+static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir,
+			     struct timespec *time)
 {
 	unsigned long long b;
 	uint64_t total;
 	int left;
 
-	b = ddir_rw_sum(td->io_blocks);
-	if (b % td->o.thinktime_blocks)
+	b = ddir_rw_sum(td->thinktime_blocks_counter);
+	if (b % td->o.thinktime_blocks || !b)
 		return;
 
 	io_u_quiesce(td);
@@ -898,6 +899,9 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 		/* adjust for rate_process=poisson */
 		td->last_usec[ddir] += total;
 	}
+
+	if (time && should_check_rate(td))
+		fio_gettime(time, NULL);
 }
 
 /*
@@ -1076,6 +1080,10 @@ reap:
 		}
 		if (ret < 0)
 			break;
+
+		if (ddir_rw(ddir) && td->o.thinktime)
+			handle_thinktime(td, ddir, &comp_time);
+
 		if (!ddir_rw_sum(td->bytes_done) &&
 		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
@@ -1090,9 +1098,6 @@ reap:
 		}
 		if (!in_ramp_time(td) && td->o.latency_target)
 			lat_target_check(td);
-
-		if (ddir_rw(ddir) && td->o.thinktime)
-			handle_thinktime(td, ddir);
 	}
 
 	check_update_rusage(td);
@@ -1744,6 +1749,11 @@ static void *thread_main(void *data)
 	if (rate_submit_init(td, sk_out))
 		goto err;
 
+	if (td->o.thinktime_blocks_type == THINKTIME_BLOCKS_TYPE_COMPLETE)
+		td->thinktime_blocks_counter = td->io_blocks;
+	else
+		td->thinktime_blocks_counter = td->io_issues;
+
 	set_epoch_time(td, o->log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
diff --git a/cconv.c b/cconv.c
index 62c2fc29..b10868fb 100644
--- a/cconv.c
+++ b/cconv.c
@@ -210,6 +210,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->thinktime = le32_to_cpu(top->thinktime);
 	o->thinktime_spin = le32_to_cpu(top->thinktime_spin);
 	o->thinktime_blocks = le32_to_cpu(top->thinktime_blocks);
+	o->thinktime_blocks_type = le32_to_cpu(top->thinktime_blocks_type);
 	o->fsync_blocks = le32_to_cpu(top->fsync_blocks);
 	o->fdatasync_blocks = le32_to_cpu(top->fdatasync_blocks);
 	o->barrier_blocks = le32_to_cpu(top->barrier_blocks);
@@ -431,6 +432,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->thinktime = cpu_to_le32(o->thinktime);
 	top->thinktime_spin = cpu_to_le32(o->thinktime_spin);
 	top->thinktime_blocks = cpu_to_le32(o->thinktime_blocks);
+	top->thinktime_blocks_type = __cpu_to_le32(o->thinktime_blocks_type);
 	top->fsync_blocks = cpu_to_le32(o->fsync_blocks);
 	top->fdatasync_blocks = cpu_to_le32(o->fdatasync_blocks);
 	top->barrier_blocks = cpu_to_le32(o->barrier_blocks);
diff --git a/engines/cpu.c b/engines/cpu.c
index ccbfe003..ce74dbce 100644
--- a/engines/cpu.c
+++ b/engines/cpu.c
@@ -268,6 +268,7 @@ static int fio_cpuio_init(struct thread_data *td)
 	 * set thinktime_sleep and thinktime_spin appropriately
 	 */
 	o->thinktime_blocks = 1;
+	o->thinktime_blocks_type = THINKTIME_BLOCKS_TYPE_COMPLETE;
 	o->thinktime_spin = 0;
 	o->thinktime = ((unsigned long long) co->cpucycle *
 				(100 - co->cpuload)) / co->cpuload;
diff --git a/fio.1 b/fio.1
index 9636a85f..aa248a3b 100644
--- a/fio.1
+++ b/fio.1
@@ -2323,6 +2323,12 @@ queue depth setting redundant, since no more than 1 I/O will be queued
 before we have to complete it and do our \fBthinktime\fR. In other words, this
 setting effectively caps the queue depth if the latter is larger.
 .TP
+.BI thinktime_blocks_type \fR=\fPstr
+Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks\fR triggers.
+The default is `complete', which triggers \fBthinktime\fR when fio completes
+\fBthinktime_blocks\fR blocks. If this is set to `issue', then the trigger happens
+at the issue side.
+.TP
 .BI rate \fR=\fPint[,int][,int]
 Cap the bandwidth used by this job. The number is in bytes/sec, the normal
 suffix rules apply. Comma-separated values may be specified for reads,
diff --git a/fio.h b/fio.h
index 062abfa7..b05cb3df 100644
--- a/fio.h
+++ b/fio.h
@@ -149,6 +149,9 @@ enum {
 
 	RATE_PROCESS_LINEAR = 0,
 	RATE_PROCESS_POISSON = 1,
+
+	THINKTIME_BLOCKS_TYPE_COMPLETE = 0,
+	THINKTIME_BLOCKS_TYPE_ISSUE = 1,
 };
 
 enum {
@@ -354,6 +357,8 @@ struct thread_data {
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
+	uint64_t *thinktime_blocks_counter;
+
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
 	 */
diff --git a/options.c b/options.c
index 955bf959..e62e0cfb 100644
--- a/options.c
+++ b/options.c
@@ -3608,6 +3608,28 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_THINKTIME,
 	},
+	{
+		.name	= "thinktime_blocks_type",
+		.lname	= "Thinktime blocks type",
+		.type	= FIO_OPT_STR,
+		.off1	= offsetof(struct thread_options, thinktime_blocks_type),
+		.help	= "How thinktime_blocks takes effect",
+		.def	= "complete",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_THINKTIME,
+		.posval = {
+			  { .ival = "complete",
+			    .oval = THINKTIME_BLOCKS_TYPE_COMPLETE,
+			    .help = "thinktime_blocks takes effect at the completion side",
+			  },
+			  {
+			    .ival = "issue",
+			    .oval = THINKTIME_BLOCKS_TYPE_ISSUE,
+			    .help = "thinktime_blocks takes effect at the issue side",
+			  },
+		},
+		.parent = "thinktime",
+	},
 	{
 		.name	= "rate",
 		.lname	= "I/O rate",
diff --git a/thread_options.h b/thread_options.h
index 0a033430..f6b15403 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -177,6 +177,7 @@ struct thread_options {
 	unsigned int thinktime;
 	unsigned int thinktime_spin;
 	unsigned int thinktime_blocks;
+	unsigned int thinktime_blocks_type;
 	unsigned int fsync_blocks;
 	unsigned int fdatasync_blocks;
 	unsigned int barrier_blocks;
@@ -479,6 +480,7 @@ struct thread_options_pack {
 	uint32_t thinktime;
 	uint32_t thinktime_spin;
 	uint32_t thinktime_blocks;
+	uint32_t thinktime_blocks_type;
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
 	uint32_t barrier_blocks;
@@ -506,6 +508,9 @@ struct thread_options_pack {
 	uint32_t stonewall;
 	uint32_t new_group;
 	uint32_t numjobs;
+
+	uint8_t pad3[4];
+
 	/*
 	 * We currently can't convert these, so don't enable them
 	 */

