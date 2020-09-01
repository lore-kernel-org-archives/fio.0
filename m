Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728024AbgIAMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Sep 2020 08:00:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B871C061245
        for <fio@vger.kernel.org>; Tue,  1 Sep 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD4xI-0004eD-BW
        for fio@vger.kernel.org; Tue, 01 Sep 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200901120001.EBB681BC012D@kernel.dk>
Date: Tue,  1 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e68470637ae7c03d5f85a9243e148d7c46ad4487:

  Update the year to 2020 in os/windows/eula.rtf (2020-08-29 18:54:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 20c7a244e75e4aa705a31a74e7067de4c890dff7:

  options: flow should parse as FIO_OPT_INT (2020-08-31 09:07:12 -0600)

----------------------------------------------------------------
David, Bar (2):
      flow: reclaim flow when job is reaped
      flow: add ability for weight-based flow control on multiple jobs

Jens Axboe (2):
      Merge branch 'multi_job_flow' of https://github.com/bardavid/fio into master
      options: flow should parse as FIO_OPT_INT

 HOWTO                     |   9 +---
 arch/arch.h               |   7 +++
 backend.c                 |   1 +
 cconv.c                   |   6 +--
 examples/butterfly.fio    |   2 +-
 examples/flow.fio         |   5 +-
 fio.1                     |  23 ++++----
 fio.h                     |   1 +
 flow.c                    |  50 ++++++++++++------
 flow.h                    |   2 +
 options.c                 |  10 +---
 server.h                  |   2 +-
 t/jobs/t0011-5d2788d5.fio |   4 +-
 t/jobs/t0012.fio          |  23 ++++----
 t/jobs/t0014.fio          |  29 +++++++++++
 t/run-fio-tests.py        | 130 ++++++++++++++++++++++++++++++++++++++++++++--
 thread_options.h          |  24 +++++----
 17 files changed, 250 insertions(+), 78 deletions(-)
 create mode 100644 t/jobs/t0014.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e0403b08..5dc571f8 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2861,15 +2861,10 @@ Threads, processes and job synchronization
 	``flow=8`` and another job has ``flow=-1``, then there will be a roughly 1:8
 	ratio in how much one runs vs the other.
 
-.. option:: flow_watermark=int
-
-	The maximum value that the absolute value of the flow counter is allowed to
-	reach before the job must wait for a lower value of the counter.
-
 .. option:: flow_sleep=int
 
-	The period of time, in microseconds, to wait after the flow watermark has
-	been exceeded before retrying operations.
+	The period of time, in microseconds, to wait after the flow counter
+	has exceeded its proportion before retrying operations.
 
 .. option:: stonewall, wait_for_previous
 
diff --git a/arch/arch.h b/arch/arch.h
index 08c3d703..a25779d4 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -36,6 +36,13 @@ extern unsigned long arch_flags;
 
 #define ARCH_CPU_CLOCK_WRAPS
 
+#define atomic_add(p, v)					\
+	atomic_fetch_add((_Atomic typeof(*(p)) *)(p), v)
+#define atomic_sub(p, v)					\
+	atomic_fetch_sub((_Atomic typeof(*(p)) *)(p), v)
+#define atomic_load_relaxed(p)					\
+	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
+			     memory_order_relaxed)
 #define atomic_load_acquire(p)					\
 	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
 			     memory_order_acquire)
diff --git a/backend.c b/backend.c
index a4367672..05453ae2 100644
--- a/backend.c
+++ b/backend.c
@@ -2042,6 +2042,7 @@ reaped:
 
 		done_secs += mtime_since_now(&td->epoch) / 1000;
 		profile_td_exit(td);
+		flow_exit_job(td);
 	}
 
 	if (*nr_running == cputhreads && !pending && realthreads)
diff --git a/cconv.c b/cconv.c
index 4b0c3490..5dc0569f 100644
--- a/cconv.c
+++ b/cconv.c
@@ -281,8 +281,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->uid = le32_to_cpu(top->uid);
 	o->gid = le32_to_cpu(top->gid);
 	o->flow_id = __le32_to_cpu(top->flow_id);
-	o->flow = __le32_to_cpu(top->flow);
-	o->flow_watermark = __le32_to_cpu(top->flow_watermark);
+	o->flow = le32_to_cpu(top->flow);
 	o->flow_sleep = le32_to_cpu(top->flow_sleep);
 	o->sync_file_range = le32_to_cpu(top->sync_file_range);
 	o->latency_target = le64_to_cpu(top->latency_target);
@@ -481,8 +480,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->uid = cpu_to_le32(o->uid);
 	top->gid = cpu_to_le32(o->gid);
 	top->flow_id = __cpu_to_le32(o->flow_id);
-	top->flow = __cpu_to_le32(o->flow);
-	top->flow_watermark = __cpu_to_le32(o->flow_watermark);
+	top->flow = cpu_to_le32(o->flow);
 	top->flow_sleep = cpu_to_le32(o->flow_sleep);
 	top->sync_file_range = cpu_to_le32(o->sync_file_range);
 	top->latency_target = __cpu_to_le64(o->latency_target);
diff --git a/examples/butterfly.fio b/examples/butterfly.fio
index 42d253d5..9678aa85 100644
--- a/examples/butterfly.fio
+++ b/examples/butterfly.fio
@@ -15,5 +15,5 @@ flow=2
 
 [backward]
 rw=read:-8k
-flow=-2
+flow=2
 #offset=50%
diff --git a/examples/flow.fio b/examples/flow.fio
index 4b078cf8..e34c6856 100644
--- a/examples/flow.fio
+++ b/examples/flow.fio
@@ -11,15 +11,14 @@ iodepth=256
 size=100g
 bs=8k
 filename=/tmp/testfile
-flow_watermark=100
 flow_sleep=1000
 
 [job2]
 numjobs=1
 rw=write
-flow=-8
+flow=1
 
 [job1]
 numjobs=1
 rw=randread
-flow=1
+flow=8
diff --git a/fio.1 b/fio.1
index 1c90e4a5..f15194ff 100644
--- a/fio.1
+++ b/fio.1
@@ -2549,21 +2549,18 @@ The ID of the flow. If not specified, it defaults to being a global
 flow. See \fBflow\fR.
 .TP
 .BI flow \fR=\fPint
-Weight in token-based flow control. If this value is used, then there is
-a 'flow counter' which is used to regulate the proportion of activity between
-two or more jobs. Fio attempts to keep this flow counter near zero. The
-\fBflow\fR parameter stands for how much should be added or subtracted to the
-flow counter on each iteration of the main I/O loop. That is, if one job has
-`flow=8' and another job has `flow=\-1', then there will be a roughly 1:8
-ratio in how much one runs vs the other.
-.TP
-.BI flow_watermark \fR=\fPint
-The maximum value that the absolute value of the flow counter is allowed to
-reach before the job must wait for a lower value of the counter.
+Weight in token-based flow control. If this value is used,
+then fio regulates the activity between two or more jobs
+sharing the same flow_id.
+Fio attempts to keep each job activity proportional to other jobs' activities
+in the same flow_id group, with respect to requested weight per job.
+That is, if one job has `flow=3', another job has `flow=2'
+and another with `flow=1`, then there will be a roughly 3:2:1 ratio
+in how much one runs vs the others.
 .TP
 .BI flow_sleep \fR=\fPint
-The period of time, in microseconds, to wait after the flow watermark has
-been exceeded before retrying operations.
+The period of time, in microseconds, to wait after the flow counter
+has exceeded its proportion before retrying operations.
 .TP
 .BI stonewall "\fR,\fB wait_for_previous"
 Wait for preceding jobs in the job file to exit, before starting this
diff --git a/fio.h b/fio.h
index 8045c32f..9d189eb8 100644
--- a/fio.h
+++ b/fio.h
@@ -440,6 +440,7 @@ struct thread_data {
 	int first_error;
 
 	struct fio_flow *flow;
+	unsigned long long flow_counter;
 
 	/*
 	 * Can be overloaded by profiles
diff --git a/flow.c b/flow.c
index a8dbfb9b..ee4d761d 100644
--- a/flow.c
+++ b/flow.c
@@ -7,7 +7,8 @@ struct fio_flow {
 	unsigned int refs;
 	struct flist_head list;
 	unsigned int id;
-	long long int flow_counter;
+	unsigned long long flow_counter;
+	unsigned int total_weight;
 };
 
 static struct flist_head *flow_list;
@@ -16,17 +17,23 @@ static struct fio_sem *flow_lock;
 int flow_threshold_exceeded(struct thread_data *td)
 {
 	struct fio_flow *flow = td->flow;
-	long long flow_counter;
+	double flow_counter_ratio, flow_weight_ratio;
 
 	if (!flow)
 		return 0;
 
-	if (td->o.flow > 0)
-		flow_counter = flow->flow_counter;
-	else
-		flow_counter = -flow->flow_counter;
-
-	if (flow_counter > td->o.flow_watermark) {
+	flow_counter_ratio = (double)td->flow_counter /
+		atomic_load_relaxed(&flow->flow_counter);
+	flow_weight_ratio = (double)td->o.flow /
+		atomic_load_relaxed(&flow->total_weight);
+
+	/*
+	 * each thread/process executing a fio job will stall based on the
+	 * expected  user ratio for a given flow_id group. the idea is to keep
+	 * 2 counters, flow and job-specific counter to test if the
+	 * ratio between them is proportional to other jobs in the same flow_id
+	 */
+	if (flow_counter_ratio > flow_weight_ratio) {
 		if (td->o.flow_sleep) {
 			io_u_quiesce(td);
 			usleep(td->o.flow_sleep);
@@ -35,9 +42,13 @@ int flow_threshold_exceeded(struct thread_data *td)
 		return 1;
 	}
 
-	/* No synchronization needed because it doesn't
-	 * matter if the flow count is slightly inaccurate */
-	flow->flow_counter += td->o.flow;
+	/*
+	 * increment flow(shared counter, therefore atomically)
+	 * and job-specific counter
+	 */
+	atomic_add(&flow->flow_counter, 1);
+	++td->flow_counter;
+
 	return 0;
 }
 
@@ -68,7 +79,8 @@ static struct fio_flow *flow_get(unsigned int id)
 		flow->refs = 0;
 		INIT_FLIST_HEAD(&flow->list);
 		flow->id = id;
-		flow->flow_counter = 0;
+		flow->flow_counter = 1;
+		flow->total_weight = 0;
 
 		flist_add_tail(&flow->list, flow_list);
 	}
@@ -78,14 +90,19 @@ static struct fio_flow *flow_get(unsigned int id)
 	return flow;
 }
 
-static void flow_put(struct fio_flow *flow)
+static void flow_put(struct fio_flow *flow, unsigned long long flow_counter,
+				        unsigned int weight)
 {
 	if (!flow_lock)
 		return;
 
 	fio_sem_down(flow_lock);
 
+	atomic_sub(&flow->flow_counter, flow_counter);
+	atomic_sub(&flow->total_weight, weight);
+
 	if (!--flow->refs) {
+		assert(flow->flow_counter == 1);
 		flist_del(&flow->list);
 		sfree(flow);
 	}
@@ -95,14 +112,17 @@ static void flow_put(struct fio_flow *flow)
 
 void flow_init_job(struct thread_data *td)
 {
-	if (td->o.flow)
+	if (td->o.flow) {
 		td->flow = flow_get(td->o.flow_id);
+		td->flow_counter = 0;
+		atomic_add(&td->flow->total_weight, td->o.flow);
+	}
 }
 
 void flow_exit_job(struct thread_data *td)
 {
 	if (td->flow) {
-		flow_put(td->flow);
+		flow_put(td->flow, td->flow_counter, td->o.flow);
 		td->flow = NULL;
 	}
 }
diff --git a/flow.h b/flow.h
index c0a45c3c..95e766de 100644
--- a/flow.h
+++ b/flow.h
@@ -1,6 +1,8 @@
 #ifndef FIO_FLOW_H
 #define FIO_FLOW_H
 
+#define FLOW_MAX_WEIGHT 1000
+
 int flow_threshold_exceeded(struct thread_data *td);
 void flow_init_job(struct thread_data *td);
 void flow_exit_job(struct thread_data *td);
diff --git a/options.c b/options.c
index 251ad2c1..0d64e7c0 100644
--- a/options.c
+++ b/options.c
@@ -4702,20 +4702,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.parent	= "flow_id",
 		.hide	= 1,
 		.def	= "0",
+		.maxval	= FLOW_MAX_WEIGHT,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_FLOW,
 	},
 	{
 		.name	= "flow_watermark",
 		.lname	= "I/O flow watermark",
-		.type	= FIO_OPT_INT,
-		.off1	= offsetof(struct thread_options, flow_watermark),
-		.help	= "High watermark for flow control. This option"
-			" should be set to the same value for all threads"
-			" with non-zero flow.",
-		.parent	= "flow_id",
-		.hide	= 1,
-		.def	= "1024",
+		.type	= FIO_OPT_SOFT_DEPRECATED,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IO_FLOW,
 	},
diff --git a/server.h b/server.h
index efa70e7c..3cd60096 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 84,
+	FIO_SERVER_VER			= 85,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/jobs/t0011-5d2788d5.fio b/t/jobs/t0011-5d2788d5.fio
index f90cee90..ad11f921 100644
--- a/t/jobs/t0011-5d2788d5.fio
+++ b/t/jobs/t0011-5d2788d5.fio
@@ -11,8 +11,8 @@ runtime=10
 flow_id=1
 
 [flow1]
-flow=-8
+flow=1
 rate_iops=1000
 
 [flow2]
-flow=1
+flow=8
diff --git a/t/jobs/t0012.fio b/t/jobs/t0012.fio
index 03fea627..d7123966 100644
--- a/t/jobs/t0012.fio
+++ b/t/jobs/t0012.fio
@@ -1,20 +1,25 @@
-# Expected results: no parse warnings, runs and with roughly 1/8 iops between
-#			the two jobs.
-# Buggy result: parse warning on flow value overflow, no 1/8 division between
-#			jobs.
+# Expected results: no parse warnings, runs and with roughly 1:5:10 iops
+#			between the three jobs.
+# Buggy result: parse warning on flow value overflow, no 1:5:10 division
+#			between jobs.
 #
 
 [global]
 bs=4k
 ioengine=null
 size=100g
-runtime=10
+runtime=12
 flow_id=1
-gtod_cpu=1
+flow_sleep=100
+thread
+log_avg_msec=1000
+write_iops_log=t0012.fio
 
 [flow1]
-flow=-8
-rate_iops=1000
+flow=1
 
 [flow2]
-flow=1
+flow=5
+
+[flow3]
+flow=10
diff --git a/t/jobs/t0014.fio b/t/jobs/t0014.fio
new file mode 100644
index 00000000..d9b45651
--- /dev/null
+++ b/t/jobs/t0014.fio
@@ -0,0 +1,29 @@
+# Expected results: no parse warnings, runs and with roughly 1:2:3 iops
+#			between the three jobs for the first 5 seconds, then
+#			runs with roughly 1:2 iops between the two jobs for
+#			the remaining 5 seconds.
+#
+# Buggy result: parse warning on flow value overflow, no 1:2:3 division between
+#			the three jobs for the first 5 seconds or no 1:2 division between
+#			the first two jobs for the remaining 5 seconds.
+#
+
+[global]
+bs=4k
+ioengine=null
+size=100g
+runtime=12
+flow_id=1
+thread
+log_avg_msec=1000
+write_iops_log=t0014.fio
+
+[flow1]
+flow=1
+
+[flow2]
+flow=2
+
+[flow3]
+flow=3
+runtime=5
diff --git a/t/run-fio-tests.py b/t/run-fio-tests.py
index 6f1fc092..e5c2f17c 100755
--- a/t/run-fio-tests.py
+++ b/t/run-fio-tests.py
@@ -420,6 +420,118 @@ class FioJobTest_t0009(FioJobTest):
             self.passed = False
 
 
+class FioJobTest_t0012(FioJobTest):
+    """Test consists of fio test job t0012
+    Confirm ratios of job iops are 1:5:10
+    job1,job2,job3 respectively"""
+
+    def check_result(self):
+        super(FioJobTest_t0012, self).check_result()
+
+        if not self.passed:
+            return
+
+        iops_files = []
+        for i in range(1,4):
+            file_data, success = self.get_file(os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(self.fio_job), i)))
+
+            if not success:
+                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
+                self.passed = False
+                return
+
+            iops_files.append(file_data.splitlines())
+
+        # there are 9 samples for job1 and job2, 4 samples for job3
+        iops1 = 0.0
+        iops2 = 0.0
+        iops3 = 0.0
+        for i in range(9):
+            iops1 = iops1 + float(iops_files[0][i].split(',')[1])
+            iops2 = iops2 + float(iops_files[1][i].split(',')[1])
+            iops3 = iops3 + float(iops_files[2][i].split(',')[1])
+
+            ratio1 = iops3/iops2
+            ratio2 = iops3/iops1
+            logging.debug(
+                "sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} job3/job2={4:.3f} job3/job1={5:.3f}".format(
+                    i, iops1, iops2, iops3, ratio1, ratio2
+                )
+            )
+
+        # test job1 and job2 succeeded to recalibrate
+        if ratio1 < 1 or ratio1 > 3 or ratio2 < 7 or ratio2 > 13:
+            self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} iops3={3} expected r1~2 r2~10 got r1={4:.3f} r2={5:.3f},".format(
+                self.failure_reason, iops1, iops2, iops3, ratio1, ratio2
+            )
+            self.passed = False
+            return
+
+
+class FioJobTest_t0014(FioJobTest):
+    """Test consists of fio test job t0014
+	Confirm that job1_iops / job2_iops ~ 1:2 for entire duration
+	and that job1_iops / job3_iops ~ 1:3 for first half of duration.
+
+    The test is about making sure the flow feature can
+    re-calibrate the activity dynamically"""
+
+    def check_result(self):
+        super(FioJobTest_t0014, self).check_result()
+
+        if not self.passed:
+            return
+
+        iops_files = []
+        for i in range(1,4):
+            file_data, success = self.get_file(os.path.join(self.test_dir, "{0}_iops.{1}.log".format(os.path.basename(self.fio_job), i)))
+
+            if not success:
+                self.failure_reason = "{0} unable to open output file,".format(self.failure_reason)
+                self.passed = False
+                return
+
+            iops_files.append(file_data.splitlines())
+
+        # there are 9 samples for job1 and job2, 4 samples for job3
+        iops1 = 0.0
+        iops2 = 0.0
+        iops3 = 0.0
+        for i in range(9):
+            if i < 4:
+                iops3 = iops3 + float(iops_files[2][i].split(',')[1])
+            elif i == 4:
+                ratio1 = iops1 / iops2
+                ratio2 = iops1 / iops3
+
+
+                if ratio1 < 0.43 or ratio1 > 0.57 or ratio2 < 0.21 or ratio2 > 0.45:
+                    self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} iops3={3}\
+                                                expected r1~0.5 r2~0.33 got r1={4:.3f} r2={5:.3f},".format(
+                        self.failure_reason, iops1, iops2, iops3, ratio1, ratio2
+                    )
+                    self.passed = False
+
+            iops1 = iops1 + float(iops_files[0][i].split(',')[1])
+            iops2 = iops2 + float(iops_files[1][i].split(',')[1])
+
+            ratio1 = iops1/iops2
+            ratio2 = iops1/iops3
+            logging.debug(
+                "sample {0}: job1 iops={1} job2 iops={2} job3 iops={3} job1/job2={4:.3f} job1/job3={5:.3f}".format(
+                    i, iops1, iops2, iops3, ratio1, ratio2
+                )
+            )
+
+        # test job1 and job2 succeeded to recalibrate
+        if ratio1 < 0.43 or ratio1 > 0.57:
+            self.failure_reason = "{0} iops ratio mismatch iops1={1} iops2={2} expected ratio~0.5 got ratio={3:.3f},".format(
+                self.failure_reason, iops1, iops2, ratio1
+            )
+            self.passed = False
+            return
+
+
 class FioJobTest_iops_rate(FioJobTest):
     """Test consists of fio test job t0009
     Confirm that job0 iops == 1000
@@ -442,7 +554,7 @@ class FioJobTest_iops_rate(FioJobTest):
             self.failure_reason = "{0} iops value mismatch,".format(self.failure_reason)
             self.passed = False
 
-        if ratio < 7 or ratio > 9:
+        if ratio < 6 or ratio > 10:
             self.failure_reason = "{0} iops ratio mismatch,".format(self.failure_reason)
             self.passed = False
 
@@ -680,15 +792,13 @@ TEST_LIST = [
     },
     {
         'test_id':          12,
-        'test_class':       FioJobTest_iops_rate,
+        'test_class':       FioJobTest_t0012,
         'job':              't0012.fio',
         'success':          SUCCESS_DEFAULT,
         'pre_job':          None,
         'pre_success':      None,
         'output_format':    'json',
-        'requirements':     [Requirements.not_macos],
-        # mac os does not support CPU affinity
-        # which is required for gtod offloading
+        'requirements':     [],
     },
     {
         'test_id':          13,
@@ -700,6 +810,16 @@ TEST_LIST = [
         'output_format':    'json',
         'requirements':     [],
     },
+    {
+        'test_id':          14,
+        'test_class':       FioJobTest_t0014,
+        'job':              't0014.fio',
+        'success':          SUCCESS_DEFAULT,
+        'pre_job':          None,
+        'pre_success':      None,
+        'output_format':    'json',
+        'requirements':     [],
+    },
     {
         'test_id':          1000,
         'test_class':       FioExeTest,
diff --git a/thread_options.h b/thread_options.h
index 14f1cbe9..7c0a3158 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -311,11 +311,6 @@ struct thread_options {
 	unsigned int uid;
 	unsigned int gid;
 
-	int flow_id;
-	int flow;
-	int flow_watermark;
-	unsigned int flow_sleep;
-
 	unsigned int offset_increment_percent;
 	unsigned long long offset_increment;
 	unsigned long long number_ios;
@@ -327,6 +322,13 @@ struct thread_options {
 	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
 
+	/*
+	 * flow support
+	 */
+	int flow_id;
+	unsigned int flow;
+	unsigned int flow_sleep;
+
 	unsigned int sig_figs;
 
 	unsigned block_error_hist;
@@ -602,11 +604,6 @@ struct thread_options_pack {
 	uint32_t uid;
 	uint32_t gid;
 
-	int32_t flow_id;
-	int32_t flow;
-	int32_t flow_watermark;
-	uint32_t flow_sleep;
-
 	uint32_t offset_increment_percent;
 	uint64_t offset_increment;
 	uint64_t number_ios;
@@ -617,6 +614,13 @@ struct thread_options_pack {
 	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
 
+	/*
+	 * flow support
+	 */
+	int32_t flow_id;
+	uint32_t flow;
+	uint32_t flow_sleep;
+
 	uint32_t sig_figs;
 
 	uint32_t block_error_hist;

