Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 4/4] blktrace: add option to iterate over a trace multiple times
Date: Thu, 20 Sep 2018 14:08:10 -0400
Message-Id: <20180920180810.70608-5-dennis@kernel.org>
In-Reply-To: <20180920180810.70608-1-dennis@kernel.org>
References: <20180920180810.70608-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

Scaling a particular trace may result in different runtimes among the
merging traces. By knowing the approximate length of each trace as a
user, the overall runtime of each can be tuned to line up by letting
certain traces loop multiple times.

First, the last timestamp of a trace is recorded at the end of the first
iteration to denote the length of a trace. This value is then used to
offset subsequent iterations of a trace.

Next, the "--merge_blktrace_iters" option is introduced to let the user
specify the number of times to loop over each specific trace. This is
done by passing a comma separated list that index-wise pairs with the
passed files in "--read_iolog". Iteration counts are introduced as well
as keeping track of the length of each trace.

In an example, given two traces, A and B, each 60s long. If we want to
see the impact of trace A issuing IOs twice as fast, the
--merge_blktrace_scalars="50:100" can be set and then
--merge_blktrace_iters="2:1". This runs trace A at 2x the speed twice for
approximately the same runtime as a single run of trace B.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 HOWTO            | 21 +++++++++++++++++++++
 blktrace.c       | 23 +++++++++++++++++++++--
 blktrace.h       |  5 +++++
 cconv.c          |  6 ++++++
 fio.1            | 22 ++++++++++++++++++++++
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 8 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/HOWTO b/HOWTO
index f94264b3..45cf0bdf 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2514,6 +2514,14 @@ I/O replay
 	:option:`replay_time_scale` which scales the trace during runtime and
 	does not change the output of the merge unlike this option.
 
+.. option:: merge_blktrace_iters=float_list
+
+	This is a whole number option that is index paired with the list of files
+	passed to :option:`read_iolog`. When merging is performed, run each trace
+	for the specified number of iterations. For example,
+	``--merge_blktrace_iters="2:1"`` runs the first trace for two iterations
+	and the second trace for one iteration.
+
 .. option:: replay_no_stall=bool
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
@@ -3888,6 +3896,19 @@ being slowed down or sped up. :option:`merge_blktrace_scalars` takes in a colon
 separated list of percentage scalars. It is index paired with the files passed
 to :option:`read_iolog`.
 
+With scaling, it may be desirable to match the running time of all traces.
+This can be done with :option:`merge_blktrace_iters`. It is index paired with
+:option:`read_iolog` just like :option:`merge_blktrace_scalars`.
+
+In an example, given two traces, A and B, each 60s long. If we want to see
+the impact of trace A issuing IOs twice as fast and repeat trace A over the
+runtime of trace B, the following can be done::
+
+	$ fio --read_iolog="<trace_a>:"<trace_b>" --merge_blktrace_file"<output_file>" --merge_blktrace_scalars="50:100" --merge_blktrace_iters="2:1"
+
+This runs trace A at 2x the speed twice for approximately the same runtime as
+a single run of trace B.
+
 
 CPU idleness profiling
 ----------------------
diff --git a/blktrace.c b/blktrace.c
index 14acc699..1d33c6a4 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -654,6 +654,12 @@ static int find_earliest_io(struct blktrace_cursor *bcs, int nr_logs)
 
 static void merge_finish_file(struct blktrace_cursor *bcs, int i, int *nr_logs)
 {
+	bcs[i].iter++;
+	if (bcs[i].iter < bcs[i].nr_iter) {
+		lseek(bcs[i].fd, 0, SEEK_SET);
+		return;
+	}
+
 	*nr_logs -= 1;
 
 	/* close file */
@@ -672,7 +678,11 @@ static int read_trace(struct thread_data *td, struct blktrace_cursor *bc)
 read_skip:
 	/* read an io trace */
 	ret = trace_fifo_get(td, bc->fifo, bc->fd, t, sizeof(*t));
-	if (ret <= 0) {
+	if (ret < 0) {
+		return ret;
+	} else if (!ret) {
+		if (!bc->length)
+			bc->length = bc->t.time;
 		return ret;
 	} else if (ret < (int) sizeof(*t)) {
 		log_err("fio: short fifo get\n");
@@ -697,7 +707,7 @@ read_skip:
 		goto read_skip;
 	}
 
-	t->time = t->time * bc->scalar / 100;
+	t->time = (t->time + bc->iter * bc->length) * bc->scalar / 100;
 
 	return ret;
 }
@@ -728,6 +738,15 @@ int merge_blktrace_iologs(struct thread_data *td)
 		goto err_param;
 	}
 
+	ret = init_merge_param_list(td->o.merge_blktrace_iters, bcs, nr_logs,
+				    1, offsetof(struct blktrace_cursor,
+						nr_iter));
+	if (ret) {
+		log_err("fio: merge_blktrace_iters(%d) != nr_logs(%d)\n",
+			ret, nr_logs);
+		goto err_param;
+	}
+
 	/* setup output file */
 	merge_fp = fopen(td->o.merge_blktrace_file, "w");
 	merge_buf = malloc(128 * 1024);
diff --git a/blktrace.h b/blktrace.h
index cebd54d6..72d74cf8 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -4,14 +4,19 @@
 
 #ifdef FIO_HAVE_BLKTRACE
 
+#include <asm/types.h>
+
 #include "blktrace_api.h"
 
 struct blktrace_cursor {
 	struct fifo		*fifo;	// fifo queue for reading
 	int			fd;	// blktrace file
+	__u64			length; // length of trace
 	struct blk_io_trace	t;	// current io trace
 	int			swap;	// bitwise reverse required
 	int			scalar;	// scale percentage
+	int			iter;	// current iteration
+	int			nr_iter; // number of iterations to run
 };
 
 bool is_blktrace(const char *, int *);
diff --git a/cconv.c b/cconv.c
index dd136a08..50e45c63 100644
--- a/cconv.c
+++ b/cconv.c
@@ -309,6 +309,9 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->merge_blktrace_scalars[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_scalars[i].u.i));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -574,6 +577,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->merge_blktrace_scalars[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_scalars[i].u.f));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/fio.1 b/fio.1
index 620b6b37..81164ae0 100644
--- a/fio.1
+++ b/fio.1
@@ -2218,6 +2218,13 @@ second trace in realtime. This knob is separately tunable from
 \fBreplay_time_scale\fR which scales the trace during runtime and will not
 change the output of the merge unlike this option.
 .TP
+.BI merge_blktrace_iters \fR=\fPfloat_list
+This is a whole number option that is index paired with the list of files
+passed to \fBread_iolog\fR. When merging is performed, run each trace for
+the specified number of iterations. For example,
+`\-\-merge_blktrace_iters="2:1"' runs the first trace for two iterations
+and the second trace for one iteration.
+.TP
 .BI replay_no_stall \fR=\fPbool
 When replaying I/O with \fBread_iolog\fR the default behavior is to
 attempt to respect the timestamps within the log and replay them with the
@@ -3575,6 +3582,21 @@ Scaling traces can be done to see the relative impact of any particular trace
 being slowed down or sped up. \fBmerge_blktrace_scalars\fR takes in a colon
 separated list of percentage scalars. It is index paired with the files passed
 to \fBread_iolog\fR.
+.P
+With scaling, it may be desirable to match the running time of all traces.
+This can be done with \fBmerge_blktrace_iters\fR. It is index paired with
+\fBread_iolog\fR just like \fBmerge_blktrace_scalars\fR.
+.P
+In an example, given two traces, A and B, each 60s long. If we want to see
+the impact of trace A issuing IOs twice as fast and repeat trace A over the
+runtime of trace B, the following can be done:
+.RS
+.P
+$ fio \-\-read_iolog="<trace_a>:"<trace_b>" \-\-merge_blktrace_file"<output_file>" \-\-merge_blktrace_scalars="50:100" \-\-merge_blktrace_iters="2:1"
+.RE
+.P
+This runs trace A at 2x the speed twice for approximately the same runtime as
+a single run of trace B.
 .SH CPU IDLENESS PROFILING
 In some cases, we want to understand CPU overhead in a test. For example, we
 test patches for the specific goodness of whether they reduce CPU usage.
diff --git a/options.c b/options.c
index 706f98fd..9b277309 100644
--- a/options.c
+++ b/options.c
@@ -3217,6 +3217,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IOLOG,
 	},
+	{
+		.name	= "merge_blktrace_iters",
+		.lname	= "Number of iterations to run per trace",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.off1	= offsetof(struct thread_options, merge_blktrace_iters),
+		.maxlen	= FIO_IO_U_LIST_MAX_LEN,
+		.help	= "Number of iterations to run per trace",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
 	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
diff --git a/server.h b/server.h
index 3d5e0115..40b9eac2 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 76,
+	FIO_SERVER_VER			= 77,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index f7757494..4f791cf3 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -260,6 +260,7 @@ struct thread_options {
 	char *write_iolog_file;
 	char *merge_blktrace_file;
 	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t merge_blktrace_iters[FIO_IO_U_LIST_MAX_LEN];
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
@@ -544,6 +545,7 @@ struct thread_options_pack {
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t merge_blktrace_file[FIO_TOP_STR_MAX];
 	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t merge_blktrace_iters[FIO_IO_U_LIST_MAX_LEN];
 
 	uint32_t write_bw_log;
 	uint32_t write_lat_log;
-- 
2.17.1


