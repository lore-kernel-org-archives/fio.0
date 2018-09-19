Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 3/4] blktrace: add option to scale a trace
Date: Wed, 19 Sep 2018 14:25:31 -0400
Message-Id: <20180919182532.8405-4-dennis@kernel.org>
In-Reply-To: <20180919182532.8405-1-dennis@kernel.org>
References: <20180919182532.8405-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

As we explore stacking traces, it is nice to be able to scale a trace to
understand how the traces end up interacting.

This patch adds scaling by letting the user pass in percentages to scale
a trace by. When passed '--merge_blktrace_scalars="100", the trace is
ran at 100% speed. If passed 50%, this will halve the trace timestamps.
The new option takes in a comma separated list that index-wise pairs
with the passed files in "--read_iolog".

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 blktrace.c       | 35 +++++++++++++++++++++++++++++++++++
 blktrace.h       |  1 +
 options.c        | 10 ++++++++++
 thread_options.h |  1 +
 4 files changed, 47 insertions(+)

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
diff --git a/thread_options.h b/thread_options.h
index 99552326..9eb6d53e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -259,6 +259,7 @@ struct thread_options {
 	bool read_iolog_chunked;
 	char *write_iolog_file;
 	char *merge_blktrace_file;
+	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
-- 
2.17.1


