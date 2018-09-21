Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389873AbeIURsk (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Sep 2018 13:48:40 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g3K6R-0007iE-N3
        for fio@vger.kernel.org; Fri, 21 Sep 2018 12:00:07 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20180921120002.744AA2C031B@kernel.dk>
Date: Fri, 21 Sep 2018 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 5fa4aff59e4eec471b2c534702f0162006845c4b:

  Merge branch 'epoch-time-hist-logs' of https://github.com/parallel-fs-utils/fio (2018-09-19 09:42:47 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4d2707ef027cc5b2418ab5de622318e0f70c096a:

  blktrace: fix leak of 'merge_buf' (2018-09-20 14:25:56 -0600)

----------------------------------------------------------------
Dennis Zhou (4):
      options: rename name string operations for more general use
      blktrace: add support to interleave blktrace files
      blktrace: add option to scale a trace
      blktrace: add option to iterate over a trace multiple times

Jens Axboe (2):
      blktrace: provide empty merge_blktrace_iologs()
      blktrace: fix leak of 'merge_buf'

 HOWTO            |  71 +++++++++++++++++++
 blktrace.c       | 211 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 blktrace.h       |  22 ++++++
 cconv.c          |  15 ++++
 fio.1            |  66 +++++++++++++++++
 init.c           |  21 ++++++
 options.c        |  47 ++++++++++---
 options.h        |   2 +
 server.h         |   2 +-
 thread_options.h |   6 ++
 10 files changed, 453 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 0c5b710..45cf0bd 100644
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
@@ -2491,6 +2495,33 @@ I/O replay
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
@@ -3839,6 +3870,46 @@ given in bytes. The `action` can be one of these:
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
+Scaling traces can be done to see the relative impact of any particular trace
+being slowed down or sped up. :option:`merge_blktrace_scalars` takes in a colon
+separated list of percentage scalars. It is index paired with the files passed
+to :option:`read_iolog`.
+
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
+
 CPU idleness profiling
 ----------------------
 
diff --git a/blktrace.c b/blktrace.c
index 36a7180..772a0c7 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -4,6 +4,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/ioctl.h>
+#include <unistd.h>
 #include <linux/fs.h>
 
 #include "flist.h"
@@ -613,3 +614,213 @@ err:
 	fifo_free(fifo);
 	return false;
 }
+
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
+	bcs[i].iter++;
+	if (bcs[i].iter < bcs[i].nr_iter) {
+		lseek(bcs[i].fd, 0, SEEK_SET);
+		return;
+	}
+
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
+	if (ret < 0) {
+		return ret;
+	} else if (!ret) {
+		if (!bc->length)
+			bc->length = bc->t.time;
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
+	t->time = (t->time + bc->iter * bc->length) * bc->scalar / 100;
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
+	ret = init_merge_param_list(td->o.merge_blktrace_scalars, bcs, nr_logs,
+				    100, offsetof(struct blktrace_cursor,
+						  scalar));
+	if (ret) {
+		log_err("fio: merge_blktrace_scalars(%d) != nr_logs(%d)\n",
+			ret, nr_logs);
+		goto err_param;
+	}
+
+	ret = init_merge_param_list(td->o.merge_blktrace_iters, bcs, nr_logs,
+				    1, offsetof(struct blktrace_cursor,
+						nr_iter));
+	if (ret) {
+		log_err("fio: merge_blktrace_iters(%d) != nr_logs(%d)\n",
+			ret, nr_logs);
+		goto err_param;
+	}
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
+	free(merge_buf);
+err_param:
+	free(bcs);
+
+	return ret;
+}
diff --git a/blktrace.h b/blktrace.h
index 096993e..a0e82fa 100644
--- a/blktrace.h
+++ b/blktrace.h
@@ -1,10 +1,27 @@
 #ifndef FIO_BLKTRACE_H
 #define FIO_BLKTRACE_H
 
+
 #ifdef FIO_HAVE_BLKTRACE
 
+#include <asm/types.h>
+
+#include "blktrace_api.h"
+
+struct blktrace_cursor {
+	struct fifo		*fifo;	// fifo queue for reading
+	int			fd;	// blktrace file
+	__u64			length; // length of trace
+	struct blk_io_trace	t;	// current io trace
+	int			swap;	// bitwise reverse required
+	int			scalar;	// scale percentage
+	int			iter;	// current iteration
+	int			nr_iter; // number of iterations to run
+};
+
 bool is_blktrace(const char *, int *);
 bool load_blktrace(struct thread_data *, const char *, int);
+int merge_blktrace_iologs(struct thread_data *td);
 
 #else
 
@@ -19,5 +36,10 @@ static inline bool load_blktrace(struct thread_data *td, const char *fname,
 	return false;
 }
 
+static inline int merge_blktrace_iologs(struct thread_data *td)
+{
+	return false;
+}
+
 #endif
 #endif
diff --git a/cconv.c b/cconv.c
index 1d7f6f2..50e45c6 100644
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
@@ -304,6 +306,12 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		o->percentile_list[i].u.f = fio_uint64_to_double(le64_to_cpu(top->percentile_list[i].u.i));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		o->merge_blktrace_scalars[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_scalars[i].u.i));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		o->merge_blktrace_iters[i].u.f = fio_uint64_to_double(le64_to_cpu(top->merge_blktrace_iters[i].u.i));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
@@ -330,6 +338,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->mmapfile, o->mmapfile);
 	string_to_net(top->read_iolog_file, o->read_iolog_file);
 	string_to_net(top->write_iolog_file, o->write_iolog_file);
+	string_to_net(top->merge_blktrace_file, o->merge_blktrace_file);
 	string_to_net(top->bw_log_file, o->bw_log_file);
 	string_to_net(top->lat_log_file, o->lat_log_file);
 	string_to_net(top->iops_log_file, o->iops_log_file);
@@ -565,6 +574,12 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
 		top->percentile_list[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->percentile_list[i].u.f));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		top->merge_blktrace_scalars[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_scalars[i].u.f));
+
+	for (i = 0; i < FIO_IO_U_LIST_MAX_LEN; i++)
+		top->merge_blktrace_iters[i].u.i = __cpu_to_le64(fio_double_to_uint64(o->merge_blktrace_iters[i].u.f));
 #if 0
 	uint8_t cpumask[FIO_TOP_STR_MAX];
 	uint8_t verify_cpumask[FIO_TOP_STR_MAX];
diff --git a/fio.1 b/fio.1
index 593f4db..81164ae 100644
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
@@ -2198,6 +2201,30 @@ Determines how iolog is read. If false (default) entire \fBread_iolog\fR will
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
+.BI merge_blktrace_scalars \fR=\fPfloat_list
+This is a percentage based option that is index paired with the list of files
+passed to \fBread_iolog\fR. When merging is performed, scale the time of each
+event by the corresponding amount. For example,
+`\-\-merge_blktrace_scalars="50:100"' runs the first trace in halftime and the
+second trace in realtime. This knob is separately tunable from
+\fBreplay_time_scale\fR which scales the trace during runtime and will not
+change the output of the merge unlike this option.
+.TP
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
@@ -3531,6 +3558,45 @@ Write `length' bytes beginning from `offset'.
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
+.P
+Scaling traces can be done to see the relative impact of any particular trace
+being slowed down or sped up. \fBmerge_blktrace_scalars\fR takes in a colon
+separated list of percentage scalars. It is index paired with the files passed
+to \fBread_iolog\fR.
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
diff --git a/init.c b/init.c
index c235b05..560da8f 100644
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
@@ -287,6 +289,11 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 		.val		= 'K',
 	},
 	{
+		.name		= (char *) "merge-blktrace-only",
+		.has_arg	= no_argument,
+		.val		= 'A' | FIO_CLIENT_FLAG,
+	},
+	{
 		.name		= NULL,
 	},
 };
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
index 6bd7455..9b27730 100644
--- a/options.c
+++ b/options.c
@@ -1155,7 +1155,7 @@ static int str_steadystate_cb(void *data, const char *str)
  * is escaped with a '\', then that ':' is part of the filename and does not
  * indicate a new file.
  */
-static char *get_next_name(char **ptr)
+char *get_next_str(char **ptr)
 {
 	char *str = *ptr;
 	char *p, *start;
@@ -1197,14 +1197,14 @@ static char *get_next_name(char **ptr)
 }
 
 
-static int get_max_name_idx(char *input)
+int get_max_str_idx(char *input)
 {
 	unsigned int cur_idx;
 	char *str, *p;
 
 	p = str = strdup(input);
 	for (cur_idx = 0; ; cur_idx++)
-		if (get_next_name(&str) == NULL)
+		if (get_next_str(&str) == NULL)
 			break;
 
 	free(p);
@@ -1224,9 +1224,9 @@ int set_name_idx(char *target, size_t tlen, char *input, int index,
 
 	p = str = strdup(input);
 
-	index %= get_max_name_idx(input);
+	index %= get_max_str_idx(input);
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
-		fname = get_next_name(&str);
+		fname = get_next_str(&str);
 
 	if (client_sockaddr_str[0] && unique_filename) {
 		len = snprintf(target, tlen, "%s/%s.", fname,
@@ -1247,9 +1247,9 @@ char* get_name_by_idx(char *input, int index)
 
 	p = str = strdup(input);
 
-	index %= get_max_name_idx(input);
+	index %= get_max_str_idx(input);
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
-		fname = get_next_name(&str);
+		fname = get_next_str(&str);
 
 	fname = strdup(fname);
 	free(p);
@@ -1273,7 +1273,7 @@ static int str_filename_cb(void *data, const char *input)
 	if (!td->files_index)
 		td->o.nr_files = 0;
 
-	while ((fname = get_next_name(&str)) != NULL) {
+	while ((fname = get_next_str(&str)) != NULL) {
 		if (!strlen(fname))
 			break;
 		add_file(td, fname, 0, 1);
@@ -1294,7 +1294,7 @@ static int str_directory_cb(void *data, const char fio_unused *unused)
 		return 0;
 
 	p = str = strdup(td->o.directory);
-	while ((dirname = get_next_name(&str)) != NULL) {
+	while ((dirname = get_next_str(&str)) != NULL) {
 		if (lstat(dirname, &sb) < 0) {
 			ret = errno;
 
@@ -3199,6 +3199,35 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IOLOG,
 	},
 	{
+		.name	= "merge_blktrace_file",
+		.lname	= "Merged blktrace output filename",
+		.type	= FIO_OPT_STR_STORE,
+		.off1	= offsetof(struct thread_options, merge_blktrace_file),
+		.help	= "Merged blktrace output filename",
+		.category = FIO_OPT_C_IO,
+		.group = FIO_OPT_G_IOLOG,
+	},
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
+	{
 		.name	= "exec_prerun",
 		.lname	= "Pre-execute runnable",
 		.type	= FIO_OPT_STR_STORE,
diff --git a/options.h b/options.h
index 8fdd136..5276f31 100644
--- a/options.h
+++ b/options.h
@@ -16,6 +16,8 @@ void add_opt_posval(const char *, const char *, const char *);
 void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
+char *get_next_str(char **ptr);
+int get_max_str_idx(char *input);
 char* get_name_by_idx(char *input, int index);
 int set_name_idx(char *, size_t, char *, int, bool);
 
diff --git a/server.h b/server.h
index 37d2f76..40b9eac 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 74,
+	FIO_SERVER_VER			= 77,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 3931583..4f791cf 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -258,6 +258,9 @@ struct thread_options {
 	char *read_iolog_file;
 	bool read_iolog_chunked;
 	char *write_iolog_file;
+	char *merge_blktrace_file;
+	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t merge_blktrace_iters[FIO_IO_U_LIST_MAX_LEN];
 
 	unsigned int write_bw_log;
 	unsigned int write_lat_log;
@@ -540,6 +543,9 @@ struct thread_options_pack {
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
 	uint8_t write_iolog_file[FIO_TOP_STR_MAX];
+	uint8_t merge_blktrace_file[FIO_TOP_STR_MAX];
+	fio_fp64_t merge_blktrace_scalars[FIO_IO_U_LIST_MAX_LEN];
+	fio_fp64_t merge_blktrace_iters[FIO_IO_U_LIST_MAX_LEN];
 
 	uint32_t write_bw_log;
 	uint32_t write_lat_log;

