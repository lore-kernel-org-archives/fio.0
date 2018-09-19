Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 4/4] blktrace: add option to iterate over a trace multiple times
Date: Wed, 19 Sep 2018 14:25:32 -0400
Message-Id: <20180919182532.8405-5-dennis@kernel.org>
In-Reply-To: <20180919182532.8405-1-dennis@kernel.org>
References: <20180919182532.8405-1-dennis@kernel.org>
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
--merge_blktrace_scalars="50,100" can be set and then
--merge_blktrace_iters="2,1". This runs trace A at 2x the speed twice for
approximately the same runtime as a single run of trace B.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 blktrace.c       | 23 +++++++++++++++++++++--
 blktrace.h       |  5 +++++
 options.c        | 10 ++++++++++
 thread_options.h |  1 +
 4 files changed, 37 insertions(+), 2 deletions(-)

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
diff --git a/thread_options.h b/thread_options.h
index 9eb6d53e..b3c1e06c 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -260,6 +260,7 @@ struct thread_options {
 	char *write_iolog_file;
 	char *merge_blktrace_file;
 	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t merge_blktrace_iters[FIO_IO_U_LIST_MAX_LEN];
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
-- 
2.17.1


