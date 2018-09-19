Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 2/4] blktrace: add support to interleave blktrace files
Date: Wed, 19 Sep 2018 14:25:30 -0400
Message-Id: <20180919182532.8405-3-dennis@kernel.org>
In-Reply-To: <20180919182532.8405-1-dennis@kernel.org>
References: <20180919182532.8405-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

Running concurrent workloads via multiple jobs can lead to
nondeterministic results as we are at the schedulers mercy. While the
actual performance of the workload may vary regardless, this makes the
order of events consistent.

This patch introduces two flags: --merge_blktrace_file=<file> and
--merge-blktrace-only. When the first is specified, files that are ':'
separated in --read_iolog are passed to a merge function wich then
produces a single sorted trace file. This file is then passed on in
place of the sorted list or fio exists if --merge-blktrace-only is
specified.

During merging, events are filtered based on what fio cares about and
the pdu is discarded as well.

Signed-off-by: Dennis Zhou <dennis@kernel.org>
---
 blktrace.c       | 156 +++++++++++++++++++++++++++++++++++++++++++++++
 blktrace.h       |  11 ++++
 init.c           |  20 ++++++
 options.c        |   9 +++
 thread_options.h |   1 +
 5 files changed, 197 insertions(+)

diff --git a/blktrace.c b/blktrace.c
index 36a71809..9cdbd3ca 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -613,3 +613,159 @@ err:
 	fifo_free(fifo);
 	return false;
 }
+
+static int find_earliest_io(struct blktrace_cursor *bcs, int nr_logs)
+{
+	__u64 time = ~(__u64)0;
+	int idx = 0, i;
+
+	for (i = 0; i < nr_logs; i++) {
+		if (bcs[i].t.time < time) {
+			time = bcs[i].t.time;
+			idx = i;
+		}
+	}
+
+	return idx;
+}
+
+static void merge_finish_file(struct blktrace_cursor *bcs, int i, int *nr_logs)
+{
+	*nr_logs -= 1;
+
+	/* close file */
+	fifo_free(bcs[i].fifo);
+	close(bcs[i].fd);
+
+	/* keep active files contiguous */
+	memmove(&bcs[i], &bcs[*nr_logs], sizeof(bcs[i]));
+}
+
+static int read_trace(struct thread_data *td, struct blktrace_cursor *bc)
+{
+	int ret = 0;
+	struct blk_io_trace *t = &bc->t;
+
+read_skip:
+	/* read an io trace */
+	ret = trace_fifo_get(td, bc->fifo, bc->fd, t, sizeof(*t));
+	if (ret <= 0) {
+		return ret;
+	} else if (ret < (int) sizeof(*t)) {
+		log_err("fio: short fifo get\n");
+		return -1;
+	}
+
+	if (bc->swap)
+		byteswap_trace(t);
+
+	/* skip over actions that fio does not care about */
+	if ((t->action & 0xffff) != __BLK_TA_QUEUE ||
+	    t_get_ddir(t) == DDIR_INVAL) {
+		ret = discard_pdu(td, bc->fifo, bc->fd, t);
+		if (ret < 0) {
+			td_verror(td, ret, "blktrace lseek");
+			return ret;
+		} else if (t->pdu_len != ret) {
+			log_err("fio: discarded %d of %d\n", ret,
+				t->pdu_len);
+			return -1;
+		}
+		goto read_skip;
+	}
+
+	return ret;
+}
+
+static int write_trace(FILE *fp, struct blk_io_trace *t)
+{
+	/* pdu is not used so just write out only the io trace */
+	t->pdu_len = 0;
+	return fwrite((void *)t, sizeof(*t), 1, fp);
+}
+
+int merge_blktrace_iologs(struct thread_data *td)
+{
+	int nr_logs = get_max_str_idx(td->o.read_iolog_file);
+	struct blktrace_cursor *bcs = malloc(sizeof(struct blktrace_cursor) *
+					     nr_logs);
+	struct blktrace_cursor *bc;
+	FILE *merge_fp;
+	char *str, *ptr, *name, *merge_buf;
+	int i, ret;
+
+	/* setup output file */
+	merge_fp = fopen(td->o.merge_blktrace_file, "w");
+	merge_buf = malloc(128 * 1024);
+	ret = setvbuf(merge_fp, merge_buf, _IOFBF, 128 * 1024);
+	if (ret)
+		goto err_out_file;
+
+	/* setup input files */
+	str = ptr = strdup(td->o.read_iolog_file);
+	nr_logs = 0;
+	for (i = 0; (name = get_next_str(&ptr)) != NULL; i++) {
+		bcs[i].fd = open(name, O_RDONLY);
+		if (bcs[i].fd < 0) {
+			log_err("fio: could not open file: %s\n", name);
+			ret = bcs[i].fd;
+			goto err_file;
+		}
+		bcs[i].fifo = fifo_alloc(TRACE_FIFO_SIZE);
+		nr_logs++;
+
+		if (!is_blktrace(name, &bcs[i].swap)) {
+			log_err("fio: file is not a blktrace: %s\n", name);
+			goto err_file;
+		}
+
+		ret = read_trace(td, &bcs[i]);
+		if (ret < 0) {
+			goto err_file;
+		} else if (!ret) {
+			merge_finish_file(bcs, i, &nr_logs);
+			i--;
+		}
+	}
+	free(str);
+
+	/* merge files */
+	while (nr_logs) {
+		i = find_earliest_io(bcs, nr_logs);
+		bc = &bcs[i];
+		/* skip over the pdu */
+		ret = discard_pdu(td, bc->fifo, bc->fd, &bc->t);
+		if (ret < 0) {
+			td_verror(td, ret, "blktrace lseek");
+			goto err_file;
+		} else if (bc->t.pdu_len != ret) {
+			log_err("fio: discarded %d of %d\n", ret,
+				bc->t.pdu_len);
+			goto err_file;
+		}
+
+		ret = write_trace(merge_fp, &bc->t);
+		ret = read_trace(td, bc);
+		if (ret < 0)
+			goto err_file;
+		else if (!ret)
+			merge_finish_file(bcs, i, &nr_logs);
+	}
+
+	/* set iolog file to read from the newly merged file */
+	td->o.read_iolog_file = td->o.merge_blktrace_file;
+	ret = 0;
+
+err_file:
+	/* cleanup */
+	for (i = 0; i < nr_logs; i++) {
+		fifo_free(bcs[i].fifo);
+		close(bcs[i].fd);
+	}
+err_out_file:
+	fflush(merge_fp);
+	fclose(merge_fp);
+	free(bcs);
+
+	return ret;
+}
diff --git a/blktrace.h b/blktrace.h
index 096993ed..1b2bb76b 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -1,10 +1,21 @@
 #ifndef FIO_BLKTRACE_H
 #define FIO_BLKTRACE_H
 
+
 #ifdef FIO_HAVE_BLKTRACE
 
+#include "blktrace_api.h"
+
+struct blktrace_cursor {
+	struct fifo		*fifo;	// fifo queue for reading
+	int			fd;	// blktrace file
+	struct blk_io_trace	t;	// current io trace
+	int			swap;	// bitwise reverse required
+};
+
 bool is_blktrace(const char *, int *);
 bool load_blktrace(struct thread_data *, const char *, int);
+int merge_blktrace_iologs(struct thread_data *td);
 
 #else
 
diff --git a/init.c b/init.c
index c235b05e..1297726d 100644
--- a/init.c
+++ b/init.c
@@ -30,6 +30,7 @@
 #include "idletime.h"
 #include "filelock.h"
 #include "steadystate.h"
+#include "blktrace.h"
 
 #include "oslib/getopt.h"
 #include "oslib/strcasestr.h"
@@ -46,6 +47,7 @@ static char **ini_file;
 static int max_jobs = FIO_MAX_JOBS;
 static int dump_cmdline;
 static int parse_only;
+static int merge_blktrace_only;
 
 static struct thread_data def_thread;
 struct thread_data *threads = NULL;
@@ -286,6 +288,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.has_arg	= required_argument,
 		.val		= 'K',
 	},
+	{
+		.name		= (char *) "merge-blktrace-only",
+		.has_arg	= no_argument,
+		.val		= 'A' | FIO_CLIENT_FLAG,
+	},
 	{
 		.name		= NULL,
 	},
@@ -1724,6 +1731,14 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (td_steadystate_init(td))
 		goto err;
 
+	if (o->merge_blktrace_file && !merge_blktrace_iologs(td))
+		goto err;
+
+	if (merge_blktrace_only) {
+		put_job(td);
+		return 0;
+	}
+
 	/*
 	 * recurse add identical jobs, clear numjobs and stonewall options
 	 * as they don't apply to sub-jobs
@@ -2889,6 +2904,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			trigger_timeout /= 1000000;
 			break;
+
+		case 'A':
+			did_arg = true;
+			merge_blktrace_only = 1;
+			break;
 		case '?':
 			log_err("%s: unrecognized option '%s'\n", argv[0],
 							argv[optind - 1]);
diff --git a/options.c b/options.c
index 824abee0..c0deffcb 100644
--- a/options.c
+++ b/options.c
@@ -3198,6 +3198,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_IOLOG,
 	},
+	{
+		.name	= "merge_blktrace_file",
+		.lname	= "Merged blktrace output filename",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct thread_options, merge_blktrace_file),
+		.help	= "Merged blktrace output filename",
+		.category = FIO_OPT_C_IO,
+		.group = FIO_OPT_G_IOLOG,
+	},
 	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
diff --git a/thread_options.h b/thread_options.h
index 39315834..99552326 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -258,6 +258,7 @@ struct thread_options {
 	char *read_iolog_file;
 	bool read_iolog_chunked;
 	char *write_iolog_file;
+	char *merge_blktrace_file;
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
-- 
2.17.1


