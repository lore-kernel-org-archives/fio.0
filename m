Return-Path: <glqinhongwei@gmail.com>
Return-Path: <glqinhongwei@gmail.com>
From: Hongwei Qin <glqinhongwei@gmail.com>
Subject: [PATCH v6 1/3] Add a new parameter.
Date: Mon, 25 Jan 2021 20:39:59 +0800
Message-Id: <8927bcb9b10a520f9d3be783d56cc30191fddc8c.1611578199.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1611578199.git.glqinhongwei@gmail.com>
References: <cover.1611578199.git.glqinhongwei@gmail.com>
In-Reply-To: <cover.1611578199.git.glqinhongwei@gmail.com>
References: <cover.1611578199.git.glqinhongwei@gmail.com>
To: fio@vger.kernel.org
Cc: axboe@kernel.dk, sitsofe@gmail.com, Hongwei Qin <glqinhongwei@gmail.com>
List-ID: <fio@vger.kernel.org>

This patch adds a new parameter thinktime_blocks_type to control
the behavior of thinktime_blocks. It can be either `complete`
or `issue`.
If it is `complete` (default), fio triggers thinktime when
thinktime_blocks number of blocks are **completed**.
If it is `issue`, fio triggers thinktime when thinktime_blocks
number of blocks are **issued**

Tests:
jobfile1:
```
[global]
thread
kb_base=1000
direct=1
size=1GiB
group_reporting
io_size=96KiB
ioengine=libaio
iodepth=8
bs=4096
filename=/dev/qblkdev
rw=randwrite

[fio_randwrite]
thinktime=2s
thinktime_blocks=4
```

jobfile2:
```
[global]
thread
kb_base=1000
direct=1
size=1GiB
group_reporting
io_size=96KiB
ioengine=libaio
iodepth=8
bs=4096
filename=/dev/qblkdev
rw=randwrite

[fio_randwrite]
thinktime=2s
thinktime_blocks=4
thinktime_blocks_type=issue
```

Results:
Current HEAD:
fio jobfile1:
	write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4002msec); 0 zone resets
blktrace:
	11 reqs -- 2s -- 8 reqs -- 2s -- 5 reqs -- end

This patch:
fio jobfile1:
	write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4001msec); 0 zone resets
blktrace:
	11 reqs -- 2s -- 8 reqs -- 2s -- 5 reqs -- end

fio jobfile2:
	write: IOPS=1, BW=8190B/s (8190B/s)(98.3kB/12002msec); 0 zone resets
blktrace:
	4 reqs -- 2s -- 4 reqs ... -- 4 reqs -- 2s -- end

Server:
fio --server=192.168.1.172,8765
Client (On the same machine):
fio --client=192.168.1.172,8765 jobfile1
	write: IOPS=5, BW=24.6kB/s (24.0KiB/s)(98.3kB/4001msec); 0 zone resets
blktrace:
	11 reqs -- 2s -- 8 reqs -- 2s -- 5 reqs -- end

fio --client=192.168.1.172,8765 jobfile2
	write: IOPS=1, BW=8191B/s (8191B/s)(98.3kB/12001msec); 0 zone resets
blktrace:
	4 reqs -- 2s -- 4 reqs ... -- 4 reqs -- 2s -- end

Signed-off-by: Hongwei Qin <glqinhongwei@gmail.com>
---
 HOWTO            |  7 +++++++
 backend.c        | 16 +++++++++++-----
 cconv.c          |  2 ++
 engines/cpu.c    |  1 +
 fio.1            |  6 ++++++
 fio.h            |  5 +++++
 options.c        | 22 ++++++++++++++++++++++
 thread_options.h |  5 +++++
 8 files changed, 59 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index 372f268..e178bdf 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2562,6 +2562,13 @@ I/O rate
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
index e20a2e0..874e193 100644
--- a/backend.c
+++ b/backend.c
@@ -864,8 +864,8 @@ static void handle_thinktime(struct thread_data *td, enum fio_ddir ddir)
 	uint64_t total;
 	int left;
 
-	b = ddir_rw_sum(td->io_blocks);
-	if (b % td->o.thinktime_blocks)
+	b = ddir_rw_sum(td->thinktime_blocks_counter);
+	if (b % td->o.thinktime_blocks || !b)
 		return;
 
 	io_u_quiesce(td);
@@ -1076,6 +1076,10 @@ reap:
 		}
 		if (ret < 0)
 			break;
+
+		if (ddir_rw(ddir) && td->o.thinktime)
+			handle_thinktime(td, ddir);
+
 		if (!ddir_rw_sum(td->bytes_done) &&
 		    !td_ioengine_flagged(td, FIO_NOIO))
 			continue;
@@ -1090,9 +1094,6 @@ reap:
 		}
 		if (!in_ramp_time(td) && td->o.latency_target)
 			lat_target_check(td);
-
-		if (ddir_rw(ddir) && td->o.thinktime)
-			handle_thinktime(td, ddir);
 	}
 
 	check_update_rusage(td);
@@ -1744,6 +1745,11 @@ static void *thread_main(void *data)
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
index 62c2fc2..b10868f 100644
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
index ccbfe00..ce74dbc 100644
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
index d477b50..5d08e81 100644
--- a/fio.1
+++ b/fio.1
@@ -2313,6 +2313,12 @@ queue depth setting redundant, since no more than 1 I/O will be queued
 before we have to complete it and do our \fBthinktime\fR. In other words, this
 setting effectively caps the queue depth if the latter is larger.
 .TP
+.BI thinktime_blocks_type \fR=\fPstr
+Only valid if \fBthinktime\fR is set - control how \fBthinktime_blocks triggers.
+The default is `complete`, which triggers thinktime when fio completes
+\fBthinktime_blocks blocks. If this is set to `issue`, then the trigger happens
+at the issue side.
+.TP
 .BI rate \fR=\fPint[,int][,int]
 Cap the bandwidth used by this job. The number is in bytes/sec, the normal
 suffix rules apply. Comma-separated values may be specified for reads,
diff --git a/fio.h b/fio.h
index ee582a7..ae6ac76 100644
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
@@ -355,6 +358,8 @@ struct thread_data {
 	struct fio_sem *sem;
 	uint64_t bytes_done[DDIR_RWDIR_CNT];
 
+	uint64_t *thinktime_blocks_counter;
+
 	/*
 	 * State for random io, a bitmap of blocks done vs not done
 	 */
diff --git a/options.c b/options.c
index 955bf95..e62e0cf 100644
--- a/options.c
+++ b/options.c
@@ -3609,6 +3609,28 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_THINKTIME,
 	},
 	{
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
+	{
 		.name	= "rate",
 		.lname	= "I/O rate",
 		.type	= FIO_OPT_ULL,
diff --git a/thread_options.h b/thread_options.h
index 0a03343..f6b1540 100644
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
-- 
1.8.3.1


