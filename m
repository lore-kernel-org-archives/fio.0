Return-Path: <dennisszhou@gmail.com>
Return-Path: <dennisszhou@gmail.com>
From: Dennis Zhou <dennis@kernel.org>
Subject: [PATCH 2/4] blktrace: add support to interleave blktrace files
Date: Thu, 20 Sep 2018 14:08:08 -0400
Message-Id: <20180920180810.70608-3-dennis@kernel.org>
In-Reply-To: <20180920180810.70608-1-dennis@kernel.org>
References: <20180920180810.70608-1-dennis@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com, Dennis Zhou <dennis@kernel.org>
List-ID: <fio@vger.kernel.org>

Running concurrent workloads via multiple jobs can lead to
nondeterministic results as we are at the scheduler's mercy. While the
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
 HOWTO            |  35 +++++++++++
 blktrace.c       | 156 +++++++++++++++++++++++++++++++++++++++++++++++
 blktrace.h       |  11 ++++
 cconv.c          |   3 +
 fio.1            |  30 +++++++++
 init.c           |  21 +++++++
 options.c        |   9 +++
 server.h         |   2 +-
 thread_options.h |   2 +
 9 files changed, 268 insertions(+), 1 deletion(-)

diff --git a/HOWTO b/HOWTO
index 0c5b7109..0c767dd7 100644
--- a/HOWTO
+++ b/HOWTO
@@ -100,6 +100,10 @@ Command line options
 
 	Parse options only, don't start any I/O.
 
+.. option:: --merge-blktrace-only
+
+	Merge blktraces only, don't start any I/O.
+
 .. option:: --output=filename
 
 	Write output to file `filename`.
@@ -2491,6 +2495,15 @@ I/O replay
 	will be read at once. If selected true, input from iolog will be read
 	gradually. Useful when iolog is very large, or it is generated.
 
+.. option:: merge_blktrace_file=str
+
+	When specified, rather than replaying the logs passed to :option:`read_iolog`,
+	the logs go through a merge phase which aggregates them into a single
+	blktrace. The resulting file is then passed on as the :option:`read_iolog`
+	parameter. The intention here is to make the order of events consistent.
+	This limits the influence of the scheduler compared to replaying multiple
+	blktraces via concurrent jobs.
+
 .. option:: replay_no_stall=bool
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
@@ -3839,6 +3852,28 @@ given in bytes. The `action` can be one of these:
 **trim**
 	   Trim the given file from the given `offset` for `length` bytes.
 
+
+I/O Replay - Merging Traces
+---------------------------
+
+Colocation is a common practice used to get the most out of a machine.
+Knowing which workloads play nicely with each other and which ones don't is
+a much harder task. While fio can replay workloads concurrently via multiple
+jobs, it leaves some variability up to the scheduler making results harder to
+reproduce. Merging is a way to make the order of events consistent.
+
+Merging is integrated into I/O replay and done when a
+:option:`merge_blktrace_file` is specified. The list of files passed to
+:option:`read_iolog` go through the merge process and output a single file
+stored to the specified file. The output file is passed on as if it were the
+only file passed to :option:`read_iolog`. An example would look like::
+
+	$ fio --read_iolog="<file1>:<file2>" --merge_blktrace_file="<output_file>"
+
+Creating only the merged file can be done by passing the command line argument
+:option:`merge-blktrace-only`.
+
+
 CPU idleness profiling
 ----------------------
 
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
 
diff --git a/cconv.c b/cconv.c
index 1d7f6f22..45fff126 100644
--- a/cconv.c
+++ b/cconv.c
@@ -37,6 +37,7 @@ static void free_thread_options_to_cpu(struct thread_options *o)
 	free(o->mmapfile);
 	free(o->read_iolog_file);
 	free(o->write_iolog_file);
+	free(o->merge_blktrace_file);
 	free(o->bw_log_file);
 	free(o->lat_log_file);
 	free(o->iops_log_file);
@@ -73,6 +74,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->mmapfile, top->mmapfile);
 	string_to_cpu(&o->read_iolog_file, top->read_iolog_file);
 	string_to_cpu(&o->write_iolog_file, top->write_iolog_file);
+	string_to_cpu(&o->merge_blktrace_file, top->merge_blktrace_file);
 	string_to_cpu(&o->bw_log_file, top->bw_log_file);
 	string_to_cpu(&o->lat_log_file, top->lat_log_file);
 	string_to_cpu(&o->iops_log_file, top->iops_log_file);
@@ -330,6 +332,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->mmapfile, o->mmapfile);
 	string_to_net(top->read_iolog_file, o->read_iolog_file);
 	string_to_net(top->write_iolog_file, o->write_iolog_file);
+	string_to_net(top->merge_blktrace_file, o->merge_blktrace_file);
 	string_to_net(top->bw_log_file, o->bw_log_file);
 	string_to_net(top->lat_log_file, o->lat_log_file);
 	string_to_net(top->iops_log_file, o->iops_log_file);
diff --git a/fio.1 b/fio.1
index 593f4db1..e28a1fa7 100644
--- a/fio.1
+++ b/fio.1
@@ -20,6 +20,9 @@ file and memory debugging). `help' will list all available tracing options.
 .BI \-\-parse\-only
 Parse options only, don't start any I/O.
 .TP
+.BI \-\-merge\-blktrace\-only
+Merge blktraces only, don't start any I/O.
+.TP
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
 .TP
@@ -2198,6 +2201,14 @@ Determines how iolog is read. If false (default) entire \fBread_iolog\fR will
 be read at once. If selected true, input from iolog will be read gradually.
 Useful when iolog is very large, or it is generated.
 .TP
+.BI merge_blktrace_file \fR=\fPstr
+When specified, rather than replaying the logs passed to \fBread_iolog\fR,
+the logs go through a merge phase which aggregates them into a single blktrace.
+The resulting file is then passed on as the \fBread_iolog\fR parameter. The
+intention here is to make the order of events consistent. This limits the
+influence of the scheduler compared to replaying multiple blktraces via
+concurrent jobs.
+.TP
 .BI replay_no_stall \fR=\fPbool
 When replaying I/O with \fBread_iolog\fR the default behavior is to
 attempt to respect the timestamps within the log and replay them with the
@@ -3531,6 +3542,25 @@ Write `length' bytes beginning from `offset'.
 Trim the given file from the given `offset' for `length' bytes.
 .RE
 .RE
+.SH I/O REPLAY \- MERGING TRACES
+Colocation is a common practice used to get the most out of a machine.
+Knowing which workloads play nicely with each other and which ones don't is
+a much harder task. While fio can replay workloads concurrently via multiple
+jobs, it leaves some variability up to the scheduler making results harder to
+reproduce. Merging is a way to make the order of events consistent.
+.P
+Merging is integrated into I/O replay and done when a \fBmerge_blktrace_file\fR
+is specified. The list of files passed to \fBread_iolog\fR go through the merge
+process and output a single file stored to the specified file. The output file is
+passed on as if it were the only file passed to \fBread_iolog\fR. An example would
+look like:
+.RS
+.P
+$ fio \-\-read_iolog="<file1>:<file2>" \-\-merge_blktrace_file="<output_file>"
+.RE
+.P
+Creating only the merged file can be done by passing the command line argument
+\fBmerge-blktrace-only\fR.
 .SH CPU IDLENESS PROFILING
 In some cases, we want to understand CPU overhead in a test. For example, we
 test patches for the specific goodness of whether they reduce CPU usage.
diff --git a/init.c b/init.c
index c235b05e..560da8ff 100644
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
@@ -2173,6 +2188,7 @@ static void usage(const char *name)
 	printf("  --debug=options\tEnable debug logging. May be one/more of:\n");
 	show_debug_categories();
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
+	printf("  --merge-blktrace-only\tMerge blktraces only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
 	printf("  --bandwidth-log\tGenerate aggregate bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
@@ -2889,6 +2905,11 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
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
diff --git a/server.h b/server.h
index 37d2f76a..ebd05907 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 74,
+	FIO_SERVER_VER			= 75,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 39315834..8b06f55a 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -258,6 +258,7 @@ struct thread_options {
 	char *read_iolog_file;
 	bool read_iolog_chunked;
 	char *write_iolog_file;
+	char *merge_blktrace_file;
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
@@ -540,6 +541,7 @@ struct thread_options_pack {
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
+	uint8_t merge_blktrace_file[FIO_TOP_STR_MAX];
 
 	uint32_t write_bw_log;
 	uint32_t write_lat_log;
-- 
2.17.1


