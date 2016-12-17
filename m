Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49286 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753779AbcLQNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 17 Dec 2016 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cIEaq-0006Ds-2P
        for fio@vger.kernel.org; Sat, 17 Dec 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161217130002.5BCCB2C00E7@kernel.dk>
Date: Sat, 17 Dec 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0d60927f167d318a685b9e5309bb392c624776e4:

  fio: move _FORTIFY_SOURCE to only when optimization is turned on (2016-12-15 14:55:00 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 104ee4dea7246d51d053076c55b917548dd0e7e2:

  fio: add additional support for dev-dax ioengine (2016-12-16 16:05:05 -0700)

----------------------------------------------------------------
Dave Jiang (1):
      fio: add additional support for dev-dax ioengine

Jens Axboe (11):
      Add local TODO for steady-state work
      steady-state: convert options across the wire
      TODO: man page missing
      steadystate: move into its own header
      steadystate: cleanups
      steadystate: more cleanups
      steadystate: rename 'steadystate' to 'steadystate_enabled'
      steadystate: eliminate some steadystate_data members
      steadystate: kill off ->attained
      steadystate: kill ->last_in_group and ->ramp_time_over
      Merge https://bitbucket.org/vincentfu/fio-steadystate into steady-state-2

Vincent Fu (30):
      Allow fio to terminate jobs when steady state is attained
      Fix typo, restore unintended HOWTO deletion
      Add locking around reads of td->io_blocks and io_byes.
      Change steadystate reporting:
      Steady state detection: enhance reporting of results, change memory allocation point
      JSON output, code formatting changes
      Fix bug where measurements were not printed in the correct order when steady state was not attained
      Split helper thread debug logging away from steadystate debug logging
      Update test script for new JSON steadystate['criterion'] reporting
      Clear up white space errors
      steadystate: bug fixes
      steadystate: reject job if steadystate options are not consistent within reporting group
      steadystate: add example job file
      steadystate: update man page
      steadystate: rename __FIO_SS_LAST to __FIO_SS_DATA
      steadystate: get rid of ->ss_pct and encode this information in ->state via __FIO_SS_PCT
      steadystate: add line for output-format=normal
      steadystate: implement transmission of steadystate data over the wire in client/server mode
      steadystate: instead of including ss_sum_y in thread_stat record whether ss_sum_y is nonzero in ss_state via __FIO_SS_BUFFER_FULL
      steadystate: rename TODO to STEADYSTATE-TODO
      steadystate: ensure that pointers in thread_stat occupy the same amount of storage in 32- and 64-bit platforms
      steadystate: fix alignment in stat.h
      steadystate: use uint64_t for storing bw and iops calculations and related values. Also fix an overflow with group_bw on 32-bit platforms.
      steadystate: clean up checks for when steadystate termination is not engaged
      steadystate: rename options->ss to options->ss_state since ss is used elsewhere to refer to struct steadystate_data
      steadystate: improve output of test script
      steadystate: make file for read testing optional on posix systems
      steadystate: make test script work better under Windows
      Merge git://git.kernel.dk/fio into steady-state
      use type double in creating floating point JSON values

 HOWTO                           |  47 ++++-
 Makefile                        |   3 +-
 STEADYSTATE-TODO                |  14 ++
 backend.c                       |   7 +
 cconv.c                         |   8 +
 client.c                        |  25 +++
 debug.h                         |   2 +
 examples/dev-dax.fio            |  45 +++++
 examples/steadystate.fio        |  45 +++++
 fio.1                           |  47 +++++
 fio.h                           |   3 +
 helper_thread.c                 |  27 ++-
 init.c                          |  14 ++
 json.c                          |   2 +-
 libfio.c                        |   1 +
 options.c                       | 134 +++++++++++++++
 server.c                        |  32 +++-
 server.h                        |   2 +-
 stat.c                          |  94 ++++++++++
 stat.h                          |  24 ++-
 steadystate.c                   | 368 ++++++++++++++++++++++++++++++++++++++++
 steadystate.h                   |  61 +++++++
 thread_options.h                |   9 +
 unit_tests/steadystate_tests.py | 222 ++++++++++++++++++++++++
 24 files changed, 1225 insertions(+), 11 deletions(-)
 create mode 100644 STEADYSTATE-TODO
 create mode 100644 examples/dev-dax.fio
 create mode 100644 examples/steadystate.fio
 create mode 100644 steadystate.c
 create mode 100644 steadystate.h
 create mode 100755 unit_tests/steadystate_tests.py

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 577eed9..6893c86 100644
--- a/HOWTO
+++ b/HOWTO
@@ -297,7 +297,7 @@ irange	Integer range with suffix. Allows value range to be given, such
 	1k:4k. If the option allows two sets of ranges, they can be
 	specified with a ',' or '/' delimiter: 1k-4k/8k-32k. Also see
 	int.
-float_list	A list of floating numbers, separated by a ':' character.
+float_list	A list of floating point numbers, separated by a ':' character.
 
 With the above in mind, here follows the complete list of fio job
 parameters.
@@ -819,6 +819,9 @@ ioengine=str	Defines how the job issues io to the file. The following
 			pmemblk	Read and write through the NVML libpmemblk
 				interface.
 
+			dev-dax Read and write through a DAX device exposed
+				from persistent memory.
+
 			external Prefix to specify loading an external
 				IO engine object file. Append the engine
 				filename, eg ioengine=external:/tmp/foo.o
@@ -1218,6 +1221,48 @@ ramp_time=time	If set, fio will run the specified workload for this amount
 		thus it will increase the total runtime if a special timeout
 		or runtime is specified.
 
+steadystate=str:float
+ss=str:float	Define the criterion and limit for assessing steady state
+		performance. The first parameter designates the criterion
+		whereas the second parameter sets the threshold. When the
+		criterion falls below the threshold for the specified duration,
+		the job will stop. For example, iops_slope:0.1% will direct fio
+		to terminate the job when the least squares regression slope
+		falls below 0.1% of the mean IOPS. If group_reporting is
+		enabled this will apply to all jobs in the group. Below is the
+		list of available steady state assessment criteria. All
+		assessments are carried out using only data from the rolling
+		collection window. Threshold limits can be expressed as a fixed
+		value or as a percentage of the mean in the collection window.
+			iops	Collect IOPS data. Stop the job if all
+				individual IOPS measurements are within the
+				specified limit of the mean IOPS (e.g., iops:2
+				means that all individual IOPS values must be
+				within 2 of the mean, whereas iops:0.2% means
+				that all individual IOPS values must be within
+				0.2% of	the mean IOPS to terminate the job).
+			iops_slope
+				Collect IOPS data and calculate the least
+				squares regression slope. Stop the job if the
+				slope falls below the specified limit.
+			bw	Collect bandwidth data. Stop the job if all
+				individual bandwidth measurements are within
+				the specified limit of the mean bandwidth.
+			bw_slope
+				Collect bandwidth data and calculate the least
+				squares regression slope. Stop the job if the
+				slope falls below the specified limit.
+
+steadystate_duration=time
+ss_dur=time	A rolling window of this duration will be used to judge whether
+		steady state has been reached. Data will be collected once per
+		second. The default is 0 which disables steady state detection.
+
+steadystate_ramp_time=time
+ss_ramp=time	Allow the job to run for the specified duration before
+		beginning data collection for checking the steady state job
+		termination criterion. The default is 0.
+
 invalidate=bool	Invalidate the buffer/page cache parts for this file prior
 		to starting io. Defaults to true.
 
diff --git a/Makefile b/Makefile
index d27380b..4c64168 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,8 @@ SOURCE :=	$(patsubst $(SRCDIR)/%,%,$(wildcard $(SRCDIR)/crc/*.c)) \
 		server.c client.c iolog.c backend.c libfio.c flow.c cconv.c \
 		gettime-thread.c helpers.c json.c idletime.c td_error.c \
 		profiles/tiobench.c profiles/act.c io_u_queue.c filelock.c \
-		workqueue.c rate-submit.c optgroup.c helper_thread.c
+		workqueue.c rate-submit.c optgroup.c helper_thread.c \
+		steadystate.c
 
 ifdef CONFIG_LIBHDFS
   HDFSFLAGS= -I $(JAVA_HOME)/include -I $(JAVA_HOME)/include/linux -I $(FIO_LIBHDFS_INCLUDE)
diff --git a/STEADYSTATE-TODO b/STEADYSTATE-TODO
new file mode 100644
index 0000000..e4b146e
--- /dev/null
+++ b/STEADYSTATE-TODO
@@ -0,0 +1,14 @@
+Known issues/TODO (for steady-state)
+
+- Allow user to specify the frequency of measurements
+
+- Better documentation for output
+
+- Report read, write, trim IOPS/BW separately
+
+- Semantics for the ring buffer ss->head are confusing. ss->head points
+  to the beginning of the buffer up through the point where the buffer
+  is filled for the first time. afterwards, when a new element is added,
+  ss->head is advanced to point to the second element in the buffer. if
+  steady state is attained upon adding a new element, ss->head is not
+  advanced so it actually does point to the head of the buffer.
diff --git a/backend.c b/backend.c
index ac71521..a048452 100644
--- a/backend.c
+++ b/backend.c
@@ -1665,6 +1665,7 @@ static void *thread_main(void *data)
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
+	memcpy(&td->ss.prev_time, &td->epoch, sizeof(td->epoch));
 
 	if (o->ratemin[DDIR_READ] || o->ratemin[DDIR_WRITE] ||
 			o->ratemin[DDIR_TRIM]) {
@@ -2415,6 +2416,12 @@ int fio_backend(struct sk_out *sk_out)
 	}
 
 	for_each_td(td, i) {
+		if (td->ss.dur) {
+			if (td->ss.iops_data != NULL) {
+				free(td->ss.iops_data);
+				free(td->ss.bw_data);
+			}
+		}
 		fio_options_free(td);
 		if (td->rusage_sem) {
 			fio_mutex_remove(td->rusage_sem);
diff --git a/cconv.c b/cconv.c
index 0032cc0..336805b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -213,6 +213,10 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_delay_high = le64_to_cpu(top->start_delay_high);
 	o->timeout = le64_to_cpu(top->timeout);
 	o->ramp_time = le64_to_cpu(top->ramp_time);
+	o->ss_dur = le64_to_cpu(top->ss_dur);
+	o->ss_ramp_time = le64_to_cpu(top->ss_ramp_time);
+	o->ss_state = le32_to_cpu(top->ss_state);
+	o->ss_limit.u.f = fio_uint64_to_double(le64_to_cpu(top->ss_limit.u.i));
 	o->zone_range = le64_to_cpu(top->zone_range);
 	o->zone_size = le64_to_cpu(top->zone_size);
 	o->zone_skip = le64_to_cpu(top->zone_skip);
@@ -523,6 +527,10 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
 	top->timeout = __cpu_to_le64(o->timeout);
 	top->ramp_time = __cpu_to_le64(o->ramp_time);
+	top->ss_dur = __cpu_to_le64(top->ss_dur);
+	top->ss_ramp_time = __cpu_to_le64(top->ss_ramp_time);
+	top->ss_state = cpu_to_le32(top->ss_state);
+	top->ss_limit.u.i = __cpu_to_le64(fio_double_to_uint64(o->ss_limit.u.f));
 	top->zone_range = __cpu_to_le64(o->zone_range);
 	top->zone_size = __cpu_to_le64(o->zone_size);
 	top->zone_skip = __cpu_to_le64(o->zone_skip);
diff --git a/client.c b/client.c
index c613887..48d4c52 100644
--- a/client.c
+++ b/client.c
@@ -946,6 +946,21 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->nr_block_infos	= le64_to_cpu(src->nr_block_infos);
 	for (i = 0; i < dst->nr_block_infos; i++)
 		dst->block_infos[i] = le32_to_cpu(src->block_infos[i]);
+
+	dst->ss_dur		= le64_to_cpu(src->ss_dur);
+	dst->ss_state		= le32_to_cpu(src->ss_state);
+	dst->ss_head		= le32_to_cpu(src->ss_head);
+	dst->ss_limit.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_limit.u.i));
+	dst->ss_slope.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_slope.u.i));
+	dst->ss_deviation.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_deviation.u.i));
+	dst->ss_criterion.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_criterion.u.i));
+
+	if (dst->ss_state & __FIO_SS_DATA) {
+		for (i = 0; i < dst->ss_dur; i++ ) {
+			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
+			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
+		}
+	}
 }
 
 static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
@@ -1617,6 +1632,7 @@ int fio_handle_client(struct fio_client *client)
 {
 	struct client_ops *ops = client->ops;
 	struct fio_net_cmd *cmd;
+	int size;
 
 	dprint(FD_NET, "client: handle %s\n", client->hostname);
 
@@ -1649,6 +1665,15 @@ int fio_handle_client(struct fio_client *client)
 	case FIO_NET_CMD_TS: {
 		struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
 
+		dprint(FD_NET, "client: ts->ss_state = %u\n", (unsigned int) le32_to_cpu(p->ts.ss_state));
+		if (le32_to_cpu(p->ts.ss_state) & __FIO_SS_DATA) {
+			dprint(FD_NET, "client: received steadystate ring buffers\n");
+
+			size = le64_to_cpu(p->ts.ss_dur);
+			p->ts.ss_iops_data = (uint64_t *) ((struct cmd_ts_pdu *)cmd->payload + 1);
+			p->ts.ss_bw_data = p->ts.ss_iops_data + size;
+		}
+
 		convert_ts(&p->ts, &p->ts);
 		convert_gs(&p->rs, &p->rs);
 
diff --git a/debug.h b/debug.h
index 923fa39..e3aa3f1 100644
--- a/debug.h
+++ b/debug.h
@@ -21,6 +21,8 @@ enum {
 	FD_NET,
 	FD_RATE,
 	FD_COMPRESS,
+	FD_STEADYSTATE,
+	FD_HELPERTHREAD,
 	FD_DEBUG_MAX,
 };
 
diff --git a/examples/dev-dax.fio b/examples/dev-dax.fio
new file mode 100644
index 0000000..d9f430e
--- /dev/null
+++ b/examples/dev-dax.fio
@@ -0,0 +1,45 @@
+[global]
+bs=2m
+ioengine=dev-dax
+norandommap
+time_based=1
+runtime=30
+group_reporting
+disable_lat=1
+disable_slat=1
+disable_clat=1
+clat_percentiles=0
+cpus_allowed_policy=split
+
+# For the dev-dax engine:
+#
+#   IOs always complete immediately
+#   IOs are always direct
+#
+iodepth=1
+direct=0
+thread=1
+numjobs=16
+#
+# The dev-dax engine does IO to DAX device that are special character
+# devices exported by the kernel (e.g. /dev/dax0.0). The device is
+# opened normally and then the region is accessible via mmap. We do
+# not use the O_DIRECT flag because the device is naturally direct
+# access. The O_DIRECT flags will result in failure. The engine
+# access the underlying NVDIMM directly once the mmapping is setup.
+#
+# Check the alignment requirement of your DAX device. Currently the default
+# should be 2M. Blocksize (bs) should meet alignment requirement.
+#
+# An example of creating a dev dax device node from pmem:
+# ndctl create-namespace --reconfig=namespace0.0 --mode=dax --force
+#
+filename=/dev/dax0.0
+
+[dev-dax-write]
+rw=randwrite
+stonewall
+
+[dev-dax-read]
+rw=randread
+stonewall
diff --git a/examples/steadystate.fio b/examples/steadystate.fio
new file mode 100644
index 0000000..26fb808
--- /dev/null
+++ b/examples/steadystate.fio
@@ -0,0 +1,45 @@
+#
+# Example job file for steady state job termination
+# Use --output-format=json for detailed information
+#
+# For Windows, change the file names
+#
+
+[global]
+threads=1
+group_reporting=1
+time_based
+size=128m
+
+[ss-write]
+filename=/dev/null
+rw=write
+bs=128k
+numjobs=4
+runtime=5m
+ss=iops:10%
+ss_dur=30s
+ss_ramp=10s
+#
+# Begin ss detection 10s after job starts
+# Terminate job when largest deviation from mean IOPS is 10%
+# Use a rolling 30s window for deviations
+#
+
+
+[ss-read]
+new_group
+stonewall
+filename=/dev/zero
+rw=randread
+bs=4k
+numjobs=4
+runtime=5m
+ss=bw_slope:1%
+ss_dur=10s
+ss_ramp=5s
+#
+# Begin ss detection 5s after job starts
+# Terminate job when bandwidth slope is less than 1% of avg bw
+# Use a rolling 10s window for bw measurements
+#
diff --git a/fio.1 b/fio.1
index 07480f0..e8a327c 100644
--- a/fio.1
+++ b/fio.1
@@ -722,6 +722,9 @@ constraint.
 .TP
 .B pmemblk
 Read and write through the NVML libpmemblk interface.
+.TP
+.B dev-dax
+Read and write through a DAX device exposed from persistent memory.
 .RE
 .P
 .RE
@@ -1139,6 +1142,50 @@ logging results, thus minimizing the runtime required for stable results. Note
 that the \fBramp_time\fR is considered lead in time for a job, thus it will
 increase the total runtime if a special timeout or runtime is specified.
 .TP
+.BI steadystate \fR=\fPstr:float "\fR,\fP ss" \fR=\fPstr:float
+Define the criterion and limit for assessing steady state performance. The
+first parameter designates the criterion whereas the second parameter sets the
+threshold. When the criterion falls below the threshold for the specified
+duration, the job will stop. For example, iops_slope:0.1% will direct fio
+to terminate the job when the least squares regression slope falls below 0.1%
+of the mean IOPS. If group_reporting is enabled this will apply to all jobs in
+the group. All assessments are carried out using only data from the rolling
+collection window. Threshold limits can be expressed as a fixed value or as a
+percentage of the mean in the collection window. Below are the available steady
+state assessment criteria.
+.RS
+.RS
+.TP
+.B iops
+Collect IOPS data. Stop the job if all individual IOPS measurements are within
+the specified limit of the mean IOPS (e.g., iops:2 means that all individual
+IOPS values must be within 2 of the mean, whereas iops:0.2% means that all
+individual IOPS values must be within 0.2% of the mean IOPS to terminate the
+job).
+.TP
+.B iops_slope
+Collect IOPS data and calculate the least squares regression slope. Stop the
+job if the slope falls below the specified limit.
+.TP
+.B bw
+Collect bandwidth data. Stop the job if all individual bandwidth measurements
+are within the specified limit of the mean bandwidth.
+.TP
+.B bw_slope
+Collect bandwidth data and calculate the least squares regression slope. Stop
+the job if the slope falls below the specified limit.
+.RE
+.RE
+.TP
+.BI steadystate_duration \fR=\fPtime "\fR,\fP ss_dur" \fR=\fPtime
+A rolling window of this duration will be used to judge whether steady state
+has been reached. Data will be collected once per second. The default is 0
+which disables steady state detection.
+.TP
+.BI steadystate_ramp_time \fR=\fPtime "\fR,\fP ss_ramp" \fR=\fPtime
+Allow the job to run for the specified duration before beginning data collection
+for checking the steady state job termination criterion. The default is 0.
+.TP
 .BI invalidate \fR=\fPbool
 Invalidate buffer-cache for the file prior to starting I/O.  Default: true.
 .TP
diff --git a/fio.h b/fio.h
index 7e32788..5726bef 100644
--- a/fio.h
+++ b/fio.h
@@ -41,6 +41,7 @@
 #include "flow.h"
 #include "io_u_queue.h"
 #include "workqueue.h"
+#include "steadystate.h"
 
 #ifdef CONFIG_SOLARISAIO
 #include <sys/asynch.h>
@@ -395,6 +396,8 @@ struct thread_data {
 
 	void *pinned_mem;
 
+	struct steadystate_data ss;
+
 	char verror[FIO_VERROR_SIZE];
 };
 
diff --git a/helper_thread.c b/helper_thread.c
index f031df4..47ec728 100644
--- a/helper_thread.c
+++ b/helper_thread.c
@@ -1,6 +1,7 @@
 #include "fio.h"
 #include "smalloc.h"
 #include "helper_thread.h"
+#include "steadystate.h"
 
 static struct helper_data {
 	volatile int exit;
@@ -69,14 +70,15 @@ void helper_thread_exit(void)
 static void *helper_thread_main(void *data)
 {
 	struct helper_data *hd = data;
-	unsigned int msec_to_next_event, next_log;
-	struct timeval tv, last_du;
+	unsigned int msec_to_next_event, next_log, next_ss = STEADYSTATE_MSEC;
+	struct timeval tv, last_du, last_ss;
 	int ret = 0;
 
 	sk_out_assign(hd->sk_out);
 
 	gettimeofday(&tv, NULL);
 	memcpy(&last_du, &tv, sizeof(tv));
+	memcpy(&last_ss, &tv, sizeof(tv));
 
 	fio_mutex_up(hd->startup_mutex);
 
@@ -84,7 +86,7 @@ static void *helper_thread_main(void *data)
 	while (!ret && !hd->exit) {
 		struct timespec ts;
 		struct timeval now;
-		uint64_t since_du;
+		uint64_t since_du, since_ss = 0;
 
 		timeval_add_msec(&tv, msec_to_next_event);
 		ts.tv_sec = tv.tv_sec;
@@ -98,6 +100,7 @@ static void *helper_thread_main(void *data)
 		if (hd->reset) {
 			memcpy(&tv, &now, sizeof(tv));
 			memcpy(&last_du, &now, sizeof(last_du));
+			memcpy(&last_ss, &now, sizeof(last_ss));
 			hd->reset = 0;
 		}
 
@@ -122,7 +125,22 @@ static void *helper_thread_main(void *data)
 		if (!next_log)
 			next_log = DISK_UTIL_MSEC;
 
-		msec_to_next_event = min(next_log, msec_to_next_event);
+		if (steadystate_enabled) {
+			since_ss = mtime_since(&last_ss, &now);
+			if (since_ss >= STEADYSTATE_MSEC || STEADYSTATE_MSEC - since_ss < 10) {
+				steadystate_check();
+				timeval_add_msec(&last_ss, since_ss);
+				if (since_ss > STEADYSTATE_MSEC)
+					next_ss = STEADYSTATE_MSEC - (since_ss - STEADYSTATE_MSEC);
+				else
+					next_ss = STEADYSTATE_MSEC;
+			}
+			else
+				next_ss = STEADYSTATE_MSEC - since_ss;
+                }
+
+		msec_to_next_event = min(min(next_log, msec_to_next_event), next_ss);
+		dprint(FD_HELPERTHREAD, "since_ss: %llu, next_ss: %u, next_log: %u, msec_to_next_event: %u\n", (unsigned long long)since_ss, next_ss, next_log, msec_to_next_event);
 
 		if (!is_backend)
 			print_thread_status();
@@ -142,6 +160,7 @@ int helper_thread_create(struct fio_mutex *startup_mutex, struct sk_out *sk_out)
 	hd = smalloc(sizeof(*hd));
 
 	setup_disk_util();
+	steadystate_setup();
 
 	hd->sk_out = sk_out;
 
diff --git a/init.c b/init.c
index 36feb51..f26f35d 100644
--- a/init.c
+++ b/init.c
@@ -25,6 +25,7 @@
 #include "server.h"
 #include "idletime.h"
 #include "filelock.h"
+#include "steadystate.h"
 
 #include "oslib/getopt.h"
 #include "oslib/strcasestr.h"
@@ -1563,6 +1564,9 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			log_info("...\n");
 	}
 
+	if (td_steadystate_init(td))
+		goto err;
+
 	/*
 	 * recurse add identical jobs, clear numjobs and stonewall options
 	 * as they don't apply to sub-jobs
@@ -1578,6 +1582,8 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 		td_new->o.stonewall = 0;
 		td_new->o.new_group = 0;
 		td_new->subjob_number = numjobs;
+		td_new->o.ss_dur = o->ss_dur * 1000000l;
+		td_new->o.ss_limit = o->ss_limit;
 
 		if (file_alloced) {
 			if (td_new->files) {
@@ -2120,6 +2126,14 @@ struct debug_level debug_levels[] = {
 	  .help = "Log compression logging",
 	  .shift = FD_COMPRESS,
 	},
+	{ .name = "steadystate",
+	  .help = "Steady state detection logging",
+	  .shift = FD_STEADYSTATE,
+	},
+	{ .name = "helperthread",
+	  .help = "Helper thread logging",
+	  .shift = FD_HELPERTHREAD,
+	},
 	{ .name = NULL, },
 };
 
diff --git a/json.c b/json.c
index 190fa9e..e0227ec 100644
--- a/json.c
+++ b/json.c
@@ -40,7 +40,7 @@ static struct json_value *json_create_value_int(long long number)
 	return value;
 }
 
-static struct json_value *json_create_value_float(float number)
+static struct json_value *json_create_value_float(double number)
 {
 	struct json_value *value = malloc(sizeof(struct json_value));
 
diff --git a/libfio.c b/libfio.c
index 0f9f4e7..960daf6 100644
--- a/libfio.c
+++ b/libfio.c
@@ -152,6 +152,7 @@ void reset_all_stats(struct thread_data *td)
 	memcpy(&td->start, &td->epoch, sizeof(struct timeval));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(struct timeval));
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(struct timeval));
+	memcpy(&td->ss.prev_time, &td->epoch, sizeof(struct timeval));
 
 	lat_target_reset(td);
 	clear_rusage_stat(td);
diff --git a/options.c b/options.c
index dfecd9d..7638afc 100644
--- a/options.c
+++ b/options.c
@@ -1061,6 +1061,78 @@ static int str_random_distribution_cb(void *data, const char *str)
 	return 0;
 }
 
+static int str_steadystate_cb(void *data, const char *str)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	double val;
+	char *nr;
+	char *pct;
+	long long ll;
+
+	if (td->o.ss_state != FIO_SS_IOPS && td->o.ss_state != FIO_SS_IOPS_SLOPE &&
+	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE) {
+		/* should be impossible to get here */
+		log_err("fio: unknown steady state criterion\n");
+		return 1;
+	}
+
+	nr = get_opt_postfix(str);
+	if (!nr) {
+		log_err("fio: steadystate threshold must be specified in addition to criterion\n");
+		free(nr);
+		return 1;
+	}
+
+	/* ENHANCEMENT Allow fio to understand size=10.2% and use here */
+	pct = strstr(nr, "%");
+	if (pct) {
+		*pct = '\0';
+		strip_blank_end(nr);
+		if (!str_to_float(nr, &val, 0))	{
+			log_err("fio: could not parse steadystate threshold percentage\n");
+			free(nr);
+			return 1;
+		}
+
+		dprint(FD_PARSE, "set steady state threshold to %f%%\n", val);
+		free(nr);
+		if (parse_dryrun())
+			return 0;
+
+		td->o.ss_state |= __FIO_SS_PCT;
+		td->o.ss_limit.u.f = val;
+	} else if (td->o.ss_state & __FIO_SS_IOPS) {
+		if (!str_to_float(nr, &val, 0)) {
+			log_err("fio: steadystate IOPS threshold postfix parsing failed\n");
+			free(nr);
+			return 1;
+		}
+
+		dprint(FD_PARSE, "set steady state IOPS threshold to %f\n", val);
+		free(nr);
+		if (parse_dryrun())
+			return 0;
+
+		td->o.ss_limit.u.f = val;
+	} else {	/* bandwidth criterion */
+		if (str_to_decimal(nr, &ll, 1, td, 0, 0)) {
+			log_err("fio: steadystate BW threshold postfix parsing failed\n");
+			free(nr);
+			return 1;
+		}
+
+		dprint(FD_PARSE, "set steady state BW threshold to %lld\n", ll);
+		free(nr);
+		if (parse_dryrun())
+			return 0;
+
+		td->o.ss_limit.u.f = (double) ll;
+	}
+
+	td->ss.state = td->o.ss_state;
+	return 0;
+}
+
 /*
  * Return next name in the string. Files are separated with ':'. If the ':'
  * is escaped with a '\', then that ':' is part of the filename and does not
@@ -1698,6 +1770,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 
 #endif
+#ifdef CONFIG_LINUX_DEVDAX
+			  { .ival = "dev-dax",
+			    .help = "DAX Device based IO engine",
+			  },
+#endif
 			  { .ival = "external",
 			    .help = "Load external engine (append name)",
 			  },
@@ -4192,6 +4269,63 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_MTD,
 	},
 	{
+		.name   = "steadystate",
+		.lname  = "Steady state threshold",
+		.alias  = "ss",
+		.type   = FIO_OPT_STR,
+		.off1   = offsetof(struct thread_options, ss_state),
+		.cb	= str_steadystate_cb,
+		.help   = "Define the criterion and limit to judge when a job has reached steady state",
+		.def	= "iops_slope:0.01%",
+		.posval	= {
+			  { .ival = "iops",
+			    .oval = FIO_SS_IOPS,
+			    .help = "maximum mean deviation of IOPS measurements",
+			  },
+			  { .ival = "iops_slope",
+			    .oval = FIO_SS_IOPS_SLOPE,
+			    .help = "slope calculated from IOPS measurements",
+			  },
+			  { .ival = "bw",
+			    .oval = FIO_SS_BW,
+			    .help = "maximum mean deviation of bandwidth measurements",
+			  },
+			  {
+			    .ival = "bw_slope",
+			    .oval = FIO_SS_BW_SLOPE,
+			    .help = "slope calculated from bandwidth measurements",
+			  },
+		},
+		.category = FIO_OPT_C_GENERAL,
+		.group  = FIO_OPT_G_RUNTIME,
+	},
+        {
+		.name   = "steadystate_duration",
+		.lname  = "Steady state duration",
+		.alias  = "ss_dur",
+		.type   = FIO_OPT_STR_VAL_TIME,
+		.off1   = offsetof(struct thread_options, ss_dur),
+		.help   = "Stop workload upon attaining steady state for specified duration",
+		.def    = "0",
+		.is_seconds = 1,
+		.is_time = 1,
+		.category = FIO_OPT_C_GENERAL,
+		.group  = FIO_OPT_G_RUNTIME,
+	},
+        {
+		.name   = "steadystate_ramp_time",
+		.lname  = "Steady state ramp time",
+		.alias  = "ss_ramp",
+		.type   = FIO_OPT_STR_VAL_TIME,
+		.off1   = offsetof(struct thread_options, ss_ramp_time),
+		.help   = "Delay before initiation of data collection for steady state job termination testing",
+		.def    = "0",
+		.is_seconds = 1,
+		.is_time = 1,
+		.category = FIO_OPT_C_GENERAL,
+		.group  = FIO_OPT_G_RUNTIME,
+	},
+	{
 		.name = NULL,
 	},
 };
diff --git a/server.c b/server.c
index 172ccc0..2e05415 100644
--- a/server.c
+++ b/server.c
@@ -1462,6 +1462,8 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 {
 	struct cmd_ts_pdu p;
 	int i, j;
+	void *ss_buf;
+	uint64_t *ss_iops, *ss_bw;
 
 	dprint(FD_NET, "server sending end stats\n");
 
@@ -1545,9 +1547,37 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	for (i = 0; i < p.ts.nr_block_infos; i++)
 		p.ts.block_infos[i] = cpu_to_le32(ts->block_infos[i]);
 
+	p.ts.ss_dur		= cpu_to_le64(ts->ss_dur);
+	p.ts.ss_state		= cpu_to_le32(ts->ss_state);
+	p.ts.ss_head		= cpu_to_le32(ts->ss_head);
+	p.ts.ss_limit.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_limit.u.f));
+	p.ts.ss_slope.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_slope.u.f));
+	p.ts.ss_deviation.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_deviation.u.f));
+	p.ts.ss_criterion.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_criterion.u.f));
+
 	convert_gs(&p.rs, rs);
 
-	fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
+	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
+	if (ts->ss_state & __FIO_SS_DATA) {
+		dprint(FD_NET, "server sending steadystate ring buffers\n");
+
+		ss_buf = malloc(sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t));
+
+		memcpy(ss_buf, &p, sizeof(p));
+
+		ss_iops = (uint64_t *) ((struct cmd_ts_pdu *)ss_buf + 1);
+		ss_bw = ss_iops + (int) ts->ss_dur;
+		for (i = 0; i < ts->ss_dur; i++) {
+			ss_iops[i] = cpu_to_le64(ts->ss_iops_data[i]);
+			ss_bw[i] = cpu_to_le64(ts->ss_bw_data[i]);
+		}
+
+		fio_net_queue_cmd(FIO_NET_CMD_TS, ss_buf, sizeof(p) + 2*ts->ss_dur*sizeof(uint64_t), NULL, SK_F_COPY);
+
+		free(ss_buf);
+	}
+	else
+		fio_net_queue_cmd(FIO_NET_CMD_TS, &p, sizeof(p), NULL, SK_F_COPY);
 }
 
 void fio_server_send_gs(struct group_run_stats *rs)
diff --git a/server.h b/server.h
index 4a81bcd..3a1d0b0 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 59,
+	FIO_SERVER_VER			= 60,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 423aacd..3e57e54 100644
--- a/stat.c
+++ b/stat.c
@@ -657,6 +657,33 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 			 i == BLOCK_STATE_COUNT - 1 ? '\n' : ',');
 }
 
+static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
+{
+	char *p1, *p2;
+	unsigned long long bw_mean, iops_mean;
+	const int i2p = is_power_of_2(ts->kb_base);
+
+	if (!ts->ss_dur)
+		return;
+
+	bw_mean = steadystate_bw_mean(ts);
+	iops_mean = steadystate_iops_mean(ts);
+
+	p1 = num2str(bw_mean / ts->kb_base, 6, ts->kb_base, i2p, ts->unit_base);
+	p2 = num2str(iops_mean, 6, 1, 0, 0);
+
+	log_buf(out, "  steadystate  : attained=%s, bw=%s/s, iops=%s, %s%s=%.3f%s\n",
+		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
+		p1, p2,
+		ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
+		ts->ss_state & __FIO_SS_SLOPE ? " slope": " mean dev",
+		ts->ss_criterion.u.f,
+		ts->ss_state & __FIO_SS_PCT ? "%" : "");
+
+	free(p1);
+	free(p2);
+}
+
 static void show_thread_status_normal(struct thread_stat *ts,
 				      struct group_run_stats *rs,
 				      struct buf_output *out)
@@ -763,6 +790,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 	if (ts->nr_block_infos)
 		show_block_infos(ts->nr_block_infos, ts->block_infos,
 				  ts->percentile_list, out);
+
+	if (ts->ss_dur)
+		show_ss_normal(ts, out);
 }
 
 static void show_ddir_status_terse(struct thread_stat *ts,
@@ -1257,6 +1287,56 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 		}
 	}
 
+	if (ts->ss_dur) {
+		struct json_object *data;
+		struct json_array *iops, *bw;
+		int i, j, k;
+		char ss_buf[64];
+
+		snprintf(ss_buf, sizeof(ss_buf), "%s%s:%f%s",
+			ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
+			ts->ss_state & __FIO_SS_SLOPE ? "_slope" : "",
+			(float) ts->ss_limit.u.f,
+			ts->ss_state & __FIO_SS_PCT ? "%" : "");
+
+		tmp = json_create_object();
+		json_object_add_value_object(root, "steadystate", tmp);
+		json_object_add_value_string(tmp, "ss", ss_buf);
+		json_object_add_value_int(tmp, "duration", (int)ts->ss_dur);
+		json_object_add_value_int(tmp, "attained", (ts->ss_state & __FIO_SS_ATTAINED) > 0);
+
+		snprintf(ss_buf, sizeof(ss_buf), "%f%s", (float) ts->ss_criterion.u.f,
+			ts->ss_state & __FIO_SS_PCT ? "%" : "");
+		json_object_add_value_string(tmp, "criterion", ss_buf);
+		json_object_add_value_float(tmp, "max_deviation", ts->ss_deviation.u.f);
+		json_object_add_value_float(tmp, "slope", ts->ss_slope.u.f);
+
+		data = json_create_object();
+		json_object_add_value_object(tmp, "data", data);
+		bw = json_create_array();
+		iops = json_create_array();
+
+		/*
+		** if ss was attained or the buffer is not full,
+		** ss->head points to the first element in the list.
+		** otherwise it actually points to the second element
+		** in the list
+		*/
+		if ((ts->ss_state & __FIO_SS_ATTAINED) || !(ts->ss_state & __FIO_SS_BUFFER_FULL))
+			j = ts->ss_head;
+		else
+			j = ts->ss_head == 0 ? ts->ss_dur - 1 : ts->ss_head - 1;
+		for (i = 0; i < ts->ss_dur; i++) {
+			k = (j + i) % ts->ss_dur;
+			json_array_add_value_int(bw, ts->ss_bw_data[k]);
+			json_array_add_value_int(iops, ts->ss_iops_data[k]);
+		}
+		json_object_add_value_int(data, "bw_mean", steadystate_bw_mean(ts));
+		json_object_add_value_int(data, "iops_mean", steadystate_iops_mean(ts));
+		json_object_add_value_array(data, "iops", iops);
+		json_object_add_value_array(data, "bw", bw);
+	}
+
 	return root;
 }
 
@@ -1580,6 +1660,20 @@ void __show_run_stats(void)
 			ts->block_infos[k] = td->ts.block_infos[k];
 
 		sum_thread_stats(ts, &td->ts, idx == 1);
+
+		if (td->o.ss_dur) {
+			ts->ss_state = td->ss.state;
+			ts->ss_dur = td->ss.dur;
+			ts->ss_head = td->ss.head;
+			ts->ss_bw_data = td->ss.bw_data;
+			ts->ss_iops_data = td->ss.iops_data;
+			ts->ss_limit.u.f = td->ss.limit;
+			ts->ss_slope.u.f = td->ss.slope;
+			ts->ss_deviation.u.f = td->ss.deviation;
+			ts->ss_criterion.u.f = td->ss.criterion;
+		}
+		else
+			ts->ss_dur = ts->ss_state = 0;
 	}
 
 	for (i = 0; i < nr_ts; i++) {
diff --git a/stat.h b/stat.h
index 75d1f4e..22083da 100644
--- a/stat.h
+++ b/stat.h
@@ -198,10 +198,10 @@ struct thread_stat {
 	 */
 	union {
 		uint16_t continue_on_error;
-		uint64_t pad2;
+		uint32_t pad2;
 	};
-	uint64_t total_err_count;
 	uint32_t first_error;
+	uint64_t total_err_count;
 
 	uint64_t nr_block_infos;
 	uint32_t block_infos[MAX_NR_BLOCK_INFOS];
@@ -210,9 +210,29 @@ struct thread_stat {
 	uint32_t unit_base;
 
 	uint32_t latency_depth;
+	uint32_t pad3;
 	uint64_t latency_target;
 	fio_fp64_t latency_percentile;
 	uint64_t latency_window;
+
+	uint64_t ss_dur;
+	uint32_t ss_state;
+	uint32_t ss_head;
+
+	fio_fp64_t ss_limit;
+	fio_fp64_t ss_slope;
+	fio_fp64_t ss_deviation;
+	fio_fp64_t ss_criterion;
+
+	union {
+		uint64_t *ss_iops_data;
+		uint64_t pad4;
+	};
+
+	union {
+		uint64_t *ss_bw_data;
+		uint64_t pad5;
+	};
 } __attribute__((packed));
 
 struct jobs_eta {
diff --git a/steadystate.c b/steadystate.c
new file mode 100644
index 0000000..951376f
--- /dev/null
+++ b/steadystate.c
@@ -0,0 +1,368 @@
+#include <stdlib.h>
+
+#include "fio.h"
+#include "steadystate.h"
+#include "helper_thread.h"
+
+bool steadystate_enabled = false;
+
+static void steadystate_alloc(struct thread_data *td)
+{
+	int i;
+
+	td->ss.bw_data = malloc(td->ss.dur * sizeof(uint64_t));
+	td->ss.iops_data = malloc(td->ss.dur * sizeof(uint64_t));
+	/* initialize so that it is obvious if the cache is not full in the output */
+	for (i = 0; i < td->ss.dur; i++)
+		td->ss.iops_data[i] = td->ss.bw_data[i] = 0;
+
+	td->ss.state |= __FIO_SS_DATA;
+}
+
+void steadystate_setup(void)
+{
+	int i, prev_groupid;
+	struct thread_data *td, *prev_td;
+
+	if (!steadystate_enabled)
+		return;
+
+	/*
+	 * if group reporting is enabled, identify the last td
+	 * for each group and use it for storing steady state
+	 * data
+	 */
+	prev_groupid = -1;
+	prev_td = NULL;
+	for_each_td(td, i) {
+		if (!td->ss.dur)
+			continue;
+
+		if (!td->o.group_reporting) {
+			steadystate_alloc(td);
+			continue;
+		}
+
+		if (prev_groupid != td->groupid) {
+			if (prev_td != NULL) {
+				steadystate_alloc(prev_td);
+			}
+			prev_groupid = td->groupid;
+		}
+		prev_td = td;
+	}
+
+	if (prev_td != NULL && prev_td->o.group_reporting) {
+		steadystate_alloc(prev_td);
+	}
+}
+
+static bool steadystate_slope(uint64_t iops, uint64_t bw,
+			      struct thread_data *td)
+{
+	int i, j;
+	double result;
+	struct steadystate_data *ss = &td->ss;
+	uint64_t new_val;
+
+	ss->bw_data[ss->tail] = bw;
+	ss->iops_data[ss->tail] = iops;
+
+	if (ss->state & __FIO_SS_IOPS)
+		new_val = iops;
+	else
+		new_val = bw;
+
+	if (ss->state & __FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+		if (!(ss->state & __FIO_SS_BUFFER_FULL)) {
+			/* first time through */
+			for(i = 0, ss->sum_y = 0; i < ss->dur; i++) {
+				if (ss->state & __FIO_SS_IOPS)
+					ss->sum_y += ss->iops_data[i];
+				else
+					ss->sum_y += ss->bw_data[i];
+				j = (ss->head + i) % ss->dur;
+				if (ss->state & __FIO_SS_IOPS)
+					ss->sum_xy += i * ss->iops_data[j];
+				else
+					ss->sum_xy += i * ss->bw_data[j];
+			}
+			ss->state |= __FIO_SS_BUFFER_FULL;
+		} else {		/* easy to update the sums */
+			ss->sum_y -= ss->oldest_y;
+			ss->sum_y += new_val;
+			ss->sum_xy = ss->sum_xy - ss->sum_y + ss->dur * new_val;
+		}
+
+		if (ss->state & __FIO_SS_IOPS)
+			ss->oldest_y = ss->iops_data[ss->head];
+		else
+			ss->oldest_y = ss->bw_data[ss->head];
+
+		/*
+		 * calculate slope as (sum_xy - sum_x * sum_y / n) / (sum_(x^2)
+		 * - (sum_x)^2 / n) This code assumes that all x values are
+		 * equally spaced when they are often off by a few milliseconds.
+		 * This assumption greatly simplifies the calculations.
+		 */
+		ss->slope = (ss->sum_xy - (double) ss->sum_x * ss->sum_y / ss->dur) /
+				(ss->sum_x_sq - (double) ss->sum_x * ss->sum_x / ss->dur);
+		if (ss->state & __FIO_SS_PCT)
+			ss->criterion = 100.0 * ss->slope / (ss->sum_y / ss->dur);
+		else
+			ss->criterion = ss->slope;
+
+		dprint(FD_STEADYSTATE, "sum_y: %llu, sum_xy: %llu, slope: %f, "
+					"criterion: %f, limit: %f\n",
+					(unsigned long long) ss->sum_y,
+					(unsigned long long) ss->sum_xy,
+					ss->slope, ss->criterion, ss->limit);
+
+		result = ss->criterion * (ss->criterion < 0.0 ? -1.0 : 1.0);
+		if (result < ss->limit)
+			return true;
+	}
+
+	ss->tail = (ss->tail + 1) % ss->dur;
+	if (ss->tail <= ss->head)
+		ss->head = (ss->head + 1) % ss->dur;
+
+	return false;
+}
+
+static bool steadystate_deviation(uint64_t iops, uint64_t bw,
+				  struct thread_data *td)
+{
+	int i;
+	double diff;
+	double mean;
+
+	struct steadystate_data *ss = &td->ss;
+
+	ss->bw_data[ss->tail] = bw;
+	ss->iops_data[ss->tail] = iops;
+
+	if (ss->state & __FIO_SS_BUFFER_FULL || ss->tail - ss->head == ss->dur - 1) {
+		if (!(ss->state & __FIO_SS_BUFFER_FULL)) {
+			/* first time through */
+			for(i = 0, ss->sum_y = 0; i < ss->dur; i++)
+				if (ss->state & __FIO_SS_IOPS)
+					ss->sum_y += ss->iops_data[i];
+				else
+					ss->sum_y += ss->bw_data[i];
+			ss->state |= __FIO_SS_BUFFER_FULL;
+		} else {		/* easy to update the sum */
+			ss->sum_y -= ss->oldest_y;
+			if (ss->state & __FIO_SS_IOPS)
+				ss->sum_y += ss->iops_data[ss->tail];
+			else
+				ss->sum_y += ss->bw_data[ss->tail];
+		}
+
+		if (ss->state & __FIO_SS_IOPS)
+			ss->oldest_y = ss->iops_data[ss->head];
+		else
+			ss->oldest_y = ss->bw_data[ss->head];
+
+		mean = (double) ss->sum_y / ss->dur;
+		ss->deviation = 0.0;
+
+		for (i = 0; i < ss->dur; i++) {
+			if (ss->state & __FIO_SS_IOPS)
+				diff = ss->iops_data[i] - mean;
+			else
+				diff = ss->bw_data[i] - mean;
+			ss->deviation = max(ss->deviation, diff * (diff < 0.0 ? -1.0 : 1.0));
+		}
+
+		if (ss->state & __FIO_SS_PCT)
+			ss->criterion = 100.0 * ss->deviation / mean;
+		else
+			ss->criterion = ss->deviation;
+
+		dprint(FD_STEADYSTATE, "sum_y: %llu, mean: %f, max diff: %f, "
+					"objective: %f, limit: %f\n",
+					(unsigned long long) ss->sum_y, mean,
+					ss->deviation, ss->criterion, ss->limit);
+
+		if (ss->criterion < ss->limit)
+			return true;
+	}
+
+	ss->tail = (ss->tail + 1) % ss->dur;
+	if (ss->tail <= ss->head)
+		ss->head = (ss->head + 1) % ss->dur;
+
+	return false;
+}
+
+void steadystate_check(void)
+{
+	int i, j, ddir, prev_groupid, group_ramp_time_over = 0;
+	unsigned long rate_time;
+	struct thread_data *td, *td2;
+	struct timeval now;
+	uint64_t group_bw = 0, group_iops = 0;
+	uint64_t td_iops, td_bytes;
+	bool ret;
+
+	prev_groupid = -1;
+	for_each_td(td, i) {
+		struct steadystate_data *ss = &td->ss;
+
+		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
+		    td->runstate >= TD_EXITED || !ss->state ||
+		    ss->state & __FIO_SS_ATTAINED)
+			continue;
+
+		td_iops = 0;
+		td_bytes = 0;
+		if (!td->o.group_reporting ||
+		    (td->o.group_reporting && td->groupid != prev_groupid)) {
+			group_bw = 0;
+			group_iops = 0;
+			group_ramp_time_over = 0;
+		}
+		prev_groupid = td->groupid;
+
+		fio_gettime(&now, NULL);
+		if (ss->ramp_time && !(ss->state & __FIO_SS_RAMP_OVER)) {
+			/*
+			 * Begin recording data one second after ss->ramp_time
+			 * has elapsed
+			 */
+			if (utime_since(&td->epoch, &now) >= (ss->ramp_time + 1000000L))
+				ss->state |= __FIO_SS_RAMP_OVER;
+		}
+
+		td_io_u_lock(td);
+		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
+			td_iops += td->io_blocks[ddir];
+			td_bytes += td->io_bytes[ddir];
+		}
+		td_io_u_unlock(td);
+
+		rate_time = mtime_since(&ss->prev_time, &now);
+		memcpy(&ss->prev_time, &now, sizeof(now));
+
+		/*
+		 * Begin monitoring when job starts but don't actually use
+		 * data in checking stopping criterion until ss->ramp_time is
+		 * over. This ensures that we will have a sane value in
+		 * prev_iops/bw the first time through after ss->ramp_time
+		 * is done.
+		 */
+		if (ss->state & __FIO_SS_RAMP_OVER) {
+			group_bw += 1000 * (td_bytes - ss->prev_bytes) / rate_time;
+			group_iops += 1000 * (td_iops - ss->prev_iops) / rate_time;
+			++group_ramp_time_over;
+		}
+		ss->prev_iops = td_iops;
+		ss->prev_bytes = td_bytes;
+
+		if (td->o.group_reporting && !(ss->state & __FIO_SS_DATA))
+			continue;
+
+		/*
+		 * Don't begin checking criterion until ss->ramp_time is over
+		 * for at least one thread in group
+		 */
+		if (!group_ramp_time_over)
+			continue;
+
+		dprint(FD_STEADYSTATE, "steadystate_check() thread: %d, "
+					"groupid: %u, rate_msec: %ld, "
+					"iops: %llu, bw: %llu, head: %d, tail: %d\n",
+					i, td->groupid, rate_time,
+					(unsigned long long) group_iops,
+					(unsigned long long) group_bw,
+					ss->head, ss->tail);
+
+		if (ss->state & __FIO_SS_SLOPE)
+			ret = steadystate_slope(group_iops, group_bw, td);
+		else
+			ret = steadystate_deviation(group_iops, group_bw, td);
+
+		if (ret) {
+			if (td->o.group_reporting) {
+				for_each_td(td2, j) {
+					if (td2->groupid == td->groupid) {
+						td2->ss.state |= __FIO_SS_ATTAINED;
+						fio_mark_td_terminate(td2);
+					}
+				}
+			} else {
+				ss->state |= __FIO_SS_ATTAINED;
+				fio_mark_td_terminate(td);
+			}
+		}
+	}
+}
+
+int td_steadystate_init(struct thread_data *td)
+{
+	struct steadystate_data *ss = &td->ss;
+	struct thread_options *o = &td->o;
+	struct thread_data *td2;
+	int j;
+
+	memset(ss, 0, sizeof(*ss));
+
+	if (o->ss_dur) {
+		steadystate_enabled = true;
+		o->ss_dur /= 1000000L;
+
+		/* put all steady state info in one place */
+		ss->dur = o->ss_dur;
+		ss->limit = o->ss_limit.u.f;
+		ss->ramp_time = o->ss_ramp_time;
+
+		ss->state = o->ss_state;
+		if (!td->ss.ramp_time)
+			ss->state |= __FIO_SS_RAMP_OVER;
+
+		ss->sum_x = o->ss_dur * (o->ss_dur - 1) / 2;
+		ss->sum_x_sq = (o->ss_dur - 1) * (o->ss_dur) * (2*o->ss_dur - 1) / 6;
+	}
+
+	/* make sure that ss options are consistent within reporting group */
+	for_each_td(td2, j) {
+		if (td2->groupid == td->groupid) {
+			struct steadystate_data *ss2 = &td2->ss;
+
+			if (ss2->dur != ss->dur ||
+			    ss2->limit != ss->limit ||
+			    ss2->ramp_time != ss->ramp_time ||
+			    ss2->state != ss->state ||
+			    ss2->sum_x != ss->sum_x ||
+			    ss2->sum_x_sq != ss->sum_x_sq) {
+				td_verror(td, EINVAL, "job rejected: steadystate options must be consistent within reporting groups");
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+uint64_t steadystate_bw_mean(struct thread_stat *ts)
+{
+	int i;
+	uint64_t sum;
+
+	for (i = 0, sum = 0; i < ts->ss_dur; i++)
+		sum += ts->ss_bw_data[i];
+
+	return sum / ts->ss_dur;
+}
+
+uint64_t steadystate_iops_mean(struct thread_stat *ts)
+{
+	int i;
+	uint64_t sum;
+
+	for (i = 0, sum = 0; i < ts->ss_dur; i++)
+		sum += ts->ss_iops_data[i];
+
+	return sum / ts->ss_dur;
+}
diff --git a/steadystate.h b/steadystate.h
new file mode 100644
index 0000000..20ccd30
--- /dev/null
+++ b/steadystate.h
@@ -0,0 +1,61 @@
+#ifndef FIO_STEADYSTATE_H
+#define FIO_STEADYSTATE_H
+
+#include "stat.h"
+#include "thread_options.h"
+#include "lib/ieee754.h"
+
+extern void steadystate_check(void);
+extern void steadystate_setup(void);
+extern int td_steadystate_init(struct thread_data *);
+extern uint64_t steadystate_bw_mean(struct thread_stat *);
+extern uint64_t steadystate_iops_mean(struct thread_stat *);
+
+extern bool steadystate_enabled;
+
+struct steadystate_data {
+	double limit;
+	unsigned long long dur;
+	unsigned long long ramp_time;
+
+	uint32_t state;
+
+	unsigned int head;
+	unsigned int tail;
+	uint64_t *iops_data;
+	uint64_t *bw_data;
+
+	double slope;
+	double deviation;
+	double criterion;
+
+	uint64_t sum_y;
+	uint64_t sum_x;
+	uint64_t sum_x_sq;
+	uint64_t sum_xy;
+	uint64_t oldest_y;
+
+	struct timeval prev_time;
+	uint64_t prev_iops;
+	uint64_t prev_bytes;
+};
+
+enum {
+	__FIO_SS_IOPS		= 1,
+	__FIO_SS_BW		= 2,
+	__FIO_SS_SLOPE		= 4,
+	__FIO_SS_ATTAINED	= 8,
+	__FIO_SS_RAMP_OVER	= 16,
+	__FIO_SS_DATA		= 32,
+	__FIO_SS_PCT		= 64,
+	__FIO_SS_BUFFER_FULL	= 128,
+
+	FIO_SS_IOPS		= __FIO_SS_IOPS,
+	FIO_SS_IOPS_SLOPE	= __FIO_SS_IOPS | __FIO_SS_SLOPE,
+	FIO_SS_BW		= __FIO_SS_BW,
+	FIO_SS_BW_SLOPE		= __FIO_SS_BW | __FIO_SS_SLOPE,
+};
+
+#define STEADYSTATE_MSEC	1000
+
+#endif
diff --git a/thread_options.h b/thread_options.h
index 8ec6b97..dd5b9ef 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -170,6 +170,10 @@ struct thread_options {
 	unsigned long long start_delay_high;
 	unsigned long long timeout;
 	unsigned long long ramp_time;
+	unsigned int ss_state;
+	fio_fp64_t ss_limit;
+	unsigned long long ss_dur;
+	unsigned long long ss_ramp_time;
 	unsigned int overwrite;
 	unsigned int bw_avg_time;
 	unsigned int iops_avg_time;
@@ -434,6 +438,10 @@ struct thread_options_pack {
 	uint64_t start_delay_high;
 	uint64_t timeout;
 	uint64_t ramp_time;
+	uint64_t ss_dur;
+	uint64_t ss_ramp_time;
+	uint32_t ss_state;
+	fio_fp64_t ss_limit;
 	uint32_t overwrite;
 	uint32_t bw_avg_time;
 	uint32_t iops_avg_time;
@@ -494,6 +502,7 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t padding;	/* REMOVE ME when possible to maintain alignment */
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
new file mode 100755
index 0000000..a8e4e39
--- /dev/null
+++ b/unit_tests/steadystate_tests.py
@@ -0,0 +1,222 @@
+#!/usr/bin/python
+#
+# steadystate_tests.py
+#
+# Test option parsing and functonality for fio's steady state detection feature.
+#
+# steadystate_tests.py ./fio file-for-read-testing file-for-write-testing
+#
+# REQUIREMENTS
+# Python 2.6+
+# SciPy
+#
+# KNOWN ISSUES
+# only option parsing and read tests are carried out
+# On Windows this script works under Cygwin but not from cmd.exe
+# On Windows I encounter frequent fio problems generating JSON output (nothing to decode)
+# min runtime:
+# if ss attained: min runtime = ss_dur + ss_ramp
+# if not attained: runtime = timeout
+
+import os
+import sys
+import json
+import uuid
+import pprint
+import argparse
+import subprocess
+from scipy import stats
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('fio',
+                        help='path to fio executable');
+    parser.add_argument('--read',
+                        help='target for read testing')
+    parser.add_argument('--write',
+                        help='target for write testing')
+    args = parser.parse_args()
+
+    return args
+
+
+def check(data, iops, slope, pct, limit, dur, criterion):
+    measurement = 'iops' if iops else 'bw'
+    data = data[measurement]
+    mean = sum(data) / len(data)
+    if slope:
+        x = range(len(data))
+        m, intercept, r_value, p_value, std_err = stats.linregress(x,data)
+        m = abs(m)
+        if pct:
+            target = m / mean * 100
+            criterion = criterion[:-1]
+        else:
+            target = m
+    else:
+        maxdev = 0
+        for x in data:
+            maxdev = max(abs(mean-x), maxdev)
+        if pct:
+            target = maxdev / mean * 100
+            criterion = criterion[:-1]
+        else:
+            target = maxdev
+
+    criterion = float(criterion)
+    return (abs(target - criterion) / criterion < 0.005), target < limit, mean, target
+
+
+if __name__ == '__main__':
+    args = parse_args()
+
+    pp = pprint.PrettyPrinter(indent=4)
+
+#
+# test option parsing
+#
+    parsing = [ { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10", "--ss_ramp=5"],
+                  'output': "set steady state IOPS threshold to 10.000000" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:10%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 10.000000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=iops:.1%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 0.100000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:10%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 10.000000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:.1%", "--ss_ramp=5"],
+                  'output': "set steady state threshold to 0.100000%" },
+                { 'args': ["--parse-only", "--debug=parse", "--ss_dur=10s", "--ss=bw:12", "--ss_ramp=5"],
+                  'output': "set steady state BW threshold to 12" },
+              ]
+    for test in parsing:
+        output = subprocess.check_output([args.fio] + test['args']);
+        if test['output'] in output:
+            print "PASSED '{0}' found with arguments {1}".format(test['output'], test['args'])
+        else:
+            print "FAILED '{0}' NOT found with arguments {1}".format(test['output'], test['args'])
+
+#
+# test some read workloads
+#
+# if ss active and attained,
+#   check that runtime is less than job time
+#   check criteria
+#   how to check ramp time?
+#
+# if ss inactive
+#   check that runtime is what was specified
+#
+    reads = [ {'s': True, 'timeout': 100, 'numjobs': 1, 'ss_dur': 5, 'ss_ramp': 3, 'iops': True, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+              {'s': False, 'timeout': 20, 'numjobs': 2},
+              {'s': True, 'timeout': 100, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 5, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+              {'s': True, 'timeout': 10, 'numjobs': 3, 'ss_dur': 10, 'ss_ramp': 500, 'iops': False, 'slope': True, 'ss_limit': 0.1, 'pct': True},
+            ]
+
+    if args.read == None:
+        if os.name == 'posix':
+            args.read = '/dev/zero'
+            extra = [ "--size=128M" ]
+        else:
+            print "ERROR: file for read testing must be specified on non-posix systems"
+            sys.exit(1)
+    else:
+        extra = []
+
+    jobnum = 0
+    for job in reads:
+
+        tf = uuid.uuid4().hex
+        parameters = [ "--name=job{0}".format(jobnum) ]
+        parameters.extend(extra)
+        parameters.extend([ "--thread",
+                            "--output-format=json",
+                            "--output={0}".format(tf),
+                            "--filename={0}".format(args.read),
+                            "--rw=randrw",
+                            "--rwmixread=100",
+                            "--stonewall",
+                            "--group_reporting",
+                            "--numjobs={0}".format(job['numjobs']),
+                            "--time_based",
+                            "--runtime={0}".format(job['timeout']) ])
+        if job['s']:
+           if job['iops']:
+               ss = 'iops'
+           else:
+               ss = 'bw'
+           if job['slope']:
+               ss += "_slope"
+           ss += ":" + str(job['ss_limit'])
+           if job['pct']:
+               ss += '%'
+           parameters.extend([ '--ss_dur={0}'.format(job['ss_dur']),
+                               '--ss={0}'.format(ss),
+                               '--ss_ramp={0}'.format(job['ss_ramp']) ])
+
+        output = subprocess.call([args.fio] + parameters)
+        with open(tf, 'r') as source:
+            jsondata = json.loads(source.read())
+        os.remove(tf)
+
+        for jsonjob in jsondata['jobs']:
+            line = "job {0}".format(jsonjob['job options']['name'])
+            if job['s']:
+                if jsonjob['steadystate']['attained'] == 1:
+                    # check runtime >= ss_dur + ss_ramp, check criterion, check criterion < limit
+                    mintime = (job['ss_dur'] + job['ss_ramp']) * 1000
+                    actual = jsonjob['read']['runtime']
+                    if mintime > actual:
+                        line = 'FAILED ' + line + ' ss attained, runtime {0} < ss_dur {1} + ss_ramp {2}'.format(actual, job['ss_dur'], job['ss_ramp'])
+                    else:
+                        line = line + ' ss attained, runtime {0} > ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
+                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
+                            iops=job['iops'],
+                            slope=job['slope'],
+                            pct=job['pct'],
+                            limit=job['ss_limit'],
+                            dur=job['ss_dur'],
+                            criterion=jsonjob['steadystate']['criterion'])
+                        if not objsame:
+                            line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                        else:
+                            if met:
+                                line = 'PASSED ' + line + ' target {0} < limit {1}'.format(target, job['ss_limit'])
+                            else:
+                                line = 'FAILED ' + line + ' target {0} < limit {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                else:
+                    # check runtime, confirm criterion calculation, and confirm that criterion was not met
+                    expected = job['timeout'] * 1000
+                    actual = jsonjob['read']['runtime']
+                    if abs(expected - actual) > 10:
+                        line = 'FAILED ' + line + ' ss not attained, expected runtime {0} != actual runtime {1}'.format(expected, actual)
+                    else:
+                        line = line + ' ss not attained, runtime {0} != ss_dur {1} + ss_ramp {2},'.format(actual, job['ss_dur'], job['ss_ramp'])
+                        objsame, met, mean, target = check(data=jsonjob['steadystate']['data'],
+                            iops=job['iops'],
+                            slope=job['slope'],
+                            pct=job['pct'],
+                            limit=job['ss_limit'],
+                            dur=job['ss_dur'],
+                            criterion=jsonjob['steadystate']['criterion'])
+                        if not objsame:
+                            if actual > (job['ss_dur'] + job['ss_ramp'])*1000:
+                                line = 'FAILED ' + line + ' fio criterion {0} != calculated criterion {1} '.format(jsonjob['steadystate']['criterion'], target)
+                            else:
+                                line = 'PASSED ' + line + ' fio criterion {0} == 0.0 since ss_dur + ss_ramp has not elapsed '.format(jsonjob['steadystate']['criterion'])
+                        else:
+                            if met:
+                                line = 'FAILED ' + line + ' target {0} < threshold {1} but fio reports ss not attained '.format(target, job['ss_limit'])
+                            else:
+                                line = 'PASSED ' + line + ' criterion {0} > threshold {1}'.format(target, job['ss_limit'])
+            else:
+                expected = job['timeout'] * 1000
+                actual = jsonjob['read']['runtime']
+                if abs(expected - actual) < 10:
+                    result = 'PASSED '
+                else:
+                    result = 'FAILED '
+                line = result + line + ' no ss, expected runtime {0} ~= actual runtime {1}'.format(expected, actual)
+            print line
+            if 'steadystate' in jsonjob:
+                pp.pprint(jsonjob['steadystate'])
+        jobnum += 1
