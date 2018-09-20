Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 3/4] blktrace: add option to scale a trace
Date: Thu, 20 Sep 2018 14:08:09 -0400
Message-Id: <20180920180810.70608-4-dennis@kernel.org>
In-Reply-To: <20180920180810.70608-1-dennis@kernel.org>
References: <20180920180810.70608-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

As we explore stacking traces, it is nice to be able to scale a trace to
understand how the traces end up interacting.

This patch adds scaling by letting the user pass in percentages to scale
a trace by. When passed '--merge_blktrace_scalars="100"', the trace is
ran at 100% speed. If passed 50%, this will halve the trace timestamps.
The new option takes in a comma separated list that index-wise pairs
with the passed files in "--read_iolog".

This option differs from "--replay_time_scale" which scales the trace
during runtime and will not change the output unlike this option.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 HOWTO            | 15 +++++++++++++++
 blktrace.c       | 35 +++++++++++++++++++++++++++++++++++
 blktrace.h       |  1 +
 cconv.c          |  6 ++++++
 fio.1            | 14 ++++++++++++++
 options.c        | 10 ++++++++++
 server.h         |  2 +-
 thread_options.h |  2 ++
 8 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 0c767dd7..f94264b3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2504,6 +2504,16 @@ I/O replay
 	This limits the influence of the scheduler compared to replaying multiple
 	blktraces via concurrent jobs.
 
+.. option:: merge_blktrace_scalars=float_list
+
+	This is a percentage based option that is index paired with the list of
+	files passed to :option:`read_iolog`. When merging is performed, scale
+	the time of each event by the corresponding amount. For example,
+	``--merge_blktrace_scalars="50:100"`` runs the first trace in halftime
+	and the second trace in realtime. This knob is separately tunable from
+	:option:`replay_time_scale` which scales the trace during runtime and
+	does not change the output of the merge unlike this option.
+
 .. option:: replay_no_stall=bool
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
@@ -3873,6 +3883,11 @@ only file passed to :option:`read_iolog`. An example would look like::
 Creating only the merged file can be done by passing the command line argument
 :option:`merge-blktrace-only`.
 
+Scaling traces can be done to see the relative impact of any particular trace
+being slowed down or sped up. :option:`merge_blktrace_scalars` takes in a colon
+separated list of percentage scalars. It is index paired with the files passed
+to :option:`read_iolog`.
+
 
 CPU idleness profiling
 ----------------------
diff --git a/blktrace.c b/blktrace.c
index 9cdbd3ca..14acc699 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/ioctl.h>
+#include <unistd.h>
 #include <linux/fs.h>
 
 #include "flist.h"
@@ -614,6 +615,28 @@ err:
 	return false;
 }
 
+static int init_merge_param_list(fio_fp64_t *vals, struct blktrace_cursor *bcs,
+				 int nr_logs, int def, size_t off)
+{
+	int i = 0, len = 0;
+
+	while (len < FIO_IO_U_LIST_MAX_LEN && vals[len].u.f != 0.0)
+		len++;
+
+	if (len && len != nr_logs)
+		return len;
+
+	for (i = 0; i < nr_logs; i++) {
+		int *val = (int *)((char *)&bcs[i] + off);
+		*val = def;
+		if (len)
+			*val = (int)vals[i].u.f;
+	}
+
+	return 0;
+
+}
+
 static int find_earliest_io(struct blktrace_cursor *bcs, int nr_logs)
 {
 	__u64 time = ~(__u64)0;
@@ -674,6 +697,8 @@ read_skip:
 		goto read_skip;
 	}
 
+	t->time = t->time * bc->scalar / 100;
+
 	return ret;
 }
 
@@ -694,6 +719,15 @@ int merge_blktrace_iologs(struct thread_data *td)
 	char *str, *ptr, *name, *merge_buf;
 	int i, ret;
 
+	ret = init_merge_param_list(td->o.merge_blktrace_scalars, bcs, nr_logs,
+				    100, offsetof(struct blktrace_cursor,
+						  scalar));
+	if (ret) {
+		log_err("fio: merge_blktrace_scalars(%d) != nr_logs(%d)\n",
+			ret, nr_logs);
+		goto err_param;
+	}
+
 	/* setup output file */
 	merge_fp = fopen(td->o.merge_blktrace_file, "w");
 	merge_buf = malloc(128 * 1024);
@@ -765,6 +799,7 @@ err_file:
 err_out_file:
 	fflush(merge_fp);
 	fclose(merge_fp);
+err_param:
 	free(bcs);
 
 	return ret;
diff --git a/blktrace.h b/blktrace.h
index 1b2bb76b..cebd54d6 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -11,6 +11,7 @@ struct blktrace_cursor {
 	int			fd;	// blktrace file
 	struct blk_io_trace	t;	// current io trace
 	int			swap;	// bitwise reverse required
+	int			scalar;	// scale percentage
 };
 
 bool is_blktrace(const char *, int *);
diff --git a/cconv.c b/cconv.c
index 45fff126..dd136a08 100644
--- a/cconv.c
+++ b/cconv.c
@@ -306,6 +306,9 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->percentile_list[i].u.f = fio_uint64_to_double(le64_to_cpu(top->percentile_list[i].u.i));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		o->merge_blktrace_scalars[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_scalars[i].u.i));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -568,6 +571,9 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->percentile_list[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->percentile_list[i].u.f));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		top->merge_blktrace_scalars[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_scalars[i].u.f));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/fio.1 b/fio.1
index e28a1fa7..620b6b37 100644
--- a/fio.1
+++ b/fio.1
@@ -2209,6 +2209,15 @@ intention here is to make the order of events consistent. This limits the
 influence of the scheduler compared to replaying multiple blktraces via
 concurrent jobs.
 .TP
+.BI merge_blktrace_scalars \fR=\fPfloat_list
+This is a percentage based option that is index paired with the list of files
+passed to \fBread_iolog\fR. When merging is performed, scale the time of each
+event by the corresponding amount. For example,
+`\-\-merge_blktrace_scalars="50:100"' runs the first trace in halftime and the
+second trace in realtime. This knob is separately tunable from
+\fBreplay_time_scale\fR which scales the trace during runtime and will not
+change the output of the merge unlike this option.
+.TP
 .BI replay_no_stall \fR=\fPbool
 When replaying I/O with \fBread_iolog\fR the default behavior is to
 attempt to respect the timestamps within the log and replay them with the
@@ -3561,6 +3570,11 @@ $ fio \-\-read_iolog="<file1>:<file2>" \-\-merge_blktrace_file="<output_file>"
 .P
 Creating only the merged file can be done by passing the command line argument
 \fBmerge-blktrace-only\fR.
+.P
+Scaling traces can be done to see the relative impact of any particular trace
+being slowed down or sped up. \fBmerge_blktrace_scalars\fR takes in a colon
+separated list of percentage scalars. It is index paired with the files passed
+to \fBread_iolog\fR.
 .SH CPU IDLENESS PROFILING
 In some cases, we want to understand CPU overhead in a test. For example, we
 test patches for the specific goodness of whether they reduce CPU usage.
diff --git a/options.c b/options.c
index c0deffcb..706f98fd 100644
--- a/options.c
+++ b/options.c
@@ -3207,6 +3207,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group = FIO_OPT_G_IOLOG,
 	},
+	{
+		.name	= "merge_blktrace_scalars",
+		.lname	= "Percentage to scale each trace",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.off1	= offsetof(struct thread_options, merge_blktrace_scalars),
+		.maxlen	= FIO_IO_U_LIST_MAX_LEN,
+		.help	= "Percentage to scale each trace",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IOLOG,
+	},
 	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
diff --git a/server.h b/server.h
index ebd05907..3d5e0115 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 75,
+	FIO_SERVER_VER			= 76,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 8b06f55a..f7757494 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -259,6 +259,7 @@ struct thread_options {
 	bool read_iolog_chunked;
 	char *write_iolog_file;
 	char *merge_blktrace_file;
+	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
@@ -542,6 +543,7 @@ struct thread_options_pack {
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t merge_blktrace_file[FIO_TOP_STR_MAX];
+	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
 
 	uint32_t write_bw_log;
 	uint32_t write_lat_log;
-- 
2.17.1


