Return-Path: <dehrenberg@google.com>
Return-Path: <dehrenberg@google.com>
Sender: Daniel Ehrenberg <dehrenberg@google.com>
From: Dan Ehrenberg <dehrenberg@chromium.org>
Subject: [PATCH v2 3/7] Collect a block-wise histogram of trim and write errors
Date: Wed, 15 Apr 2015 10:41:31 -0700
Message-Id: <1429119695-22425-4-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
References: <1429119695-22425-1-git-send-email-dehrenberg@chromium.org>
To: fio@vger.kernel.org, axboe@kernel.dk
Cc: gwendal@chromium.org, Dan Ehrenberg <dehrenberg@chromium.org>
List-ID: <fio@vger.kernel.org>

This patch collects information on how many trims or writes each trim
block sized unit can undergo before its first error. It also records
the way in which an error occurred, if one did.

Output is provided with a histogram which can be output either in
normal or json output. Terse output is omitted, since it seemed like
that would require a version rev bump.

Signed-off-by: Dan Ehrenberg <dehrenberg@chromium.org>
---
 HOWTO            |  19 ++++--
 client.c         |   4 ++
 filesetup.c      |  21 ++++++
 fio.1            |  11 +++-
 init.c           |   7 ++
 io_u.c           |  13 ++++
 iolog.c          |  12 ++++
 options.c        |  15 ++++-
 server.c         |   4 ++
 stat.c           | 195 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 stat.h           |  27 ++++++++
 thread_options.h |   4 ++
 12 files changed, 320 insertions(+), 12 deletions(-)

diff --git a/HOWTO b/HOWTO
index 04e1b31..e49a257 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1474,6 +1474,11 @@ log_store_compressed=bool	If set, and log_compression is also set,
 		command line parameter. The files will be stored with a
 		.fz suffix.
 
+block_error_percentiles=bool	If set, record errors in trim block-sized
+		units from writes and trims and output a histogram of
+		how many trims it took to get to errors, and what kind
+		of error was encountered.
+
 lockmem=int	Pin down the specified amount of memory with mlock(2). Can
 		potentially be used instead of removing memory or booting
 		with less memory to simulate a smaller amount of memory.
@@ -1513,13 +1518,13 @@ clat_percentiles=bool Enable the reporting of percentiles of
 		 completion latencies.
 
 percentile_list=float_list Overwrite the default list of percentiles
-		for completion latencies. Each number is a floating
-		number in the range (0,100], and the maximum length of
-		the list is 20. Use ':' to separate the numbers, and
-		list the numbers in ascending order. For example,
-		--percentile_list=99.5:99.9 will cause fio to report
-		the values of completion latency below which 99.5% and
-		99.9% of the observed latencies fell, respectively.
+		for completion latencies and the block error histogram.
+		Each number is a floating number in the range (0,100],
+		and the maximum length of the list is 20. Use ':'
+		to separate the numbers, and list the numbers in ascending
+		order. For example, --percentile_list=99.5:99.9 will cause
+		fio to report the values of completion latency below which
+		99.5% and 99.9% of the observed latencies fell, respectively.
 
 clocksource=str	Use the given clocksource as the base of timing. The
 		supported options are:
diff --git a/client.c b/client.c
index 760ec85..af3407c 100644
--- a/client.c
+++ b/client.c
@@ -891,6 +891,10 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 	dst->latency_target	= le64_to_cpu(src->latency_target);
 	dst->latency_window	= le64_to_cpu(src->latency_window);
 	dst->latency_percentile.u.f = fio_uint64_to_double(le64_to_cpu(src->latency_percentile.u.i));
+
+	dst->nr_block_infos	= le64_to_cpu(src->nr_block_infos);
+	for (i = 0; i < dst->nr_block_infos; i++)
+		dst->block_infos[i] = le32_to_cpu(src->block_infos[i]);
 }
 
 static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
diff --git a/filesetup.c b/filesetup.c
index 4b63632..dbfb93b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -880,6 +880,27 @@ int setup_files(struct thread_data *td)
 		}
 	}
 
+	if (td->o.block_error_hist) {
+		int len;
+
+		assert(td->o.nr_files == 1);	/* checked in fixup_options */
+		f = td->files[0];
+		len = f->io_size / td->o.bs[DDIR_TRIM];
+		if (len > MAX_NR_BLOCK_INFOS || len <= 0) {
+			log_err("fio: cannot calculate block histogram with "
+				"%d trim blocks, maximum %d\n",
+				len, MAX_NR_BLOCK_INFOS);
+			td_verror(td, EINVAL, "block_error_hist");
+			goto err_out;
+		}
+
+		td->ts.nr_block_infos = len;
+		for (int i = 0; i < len; i++)
+			td->ts.block_infos[i] =
+				BLOCK_INFO(0, BLOCK_STATE_UNINIT);
+	} else
+		td->ts.nr_block_infos = 0;
+
 	if (!o->size || (total_size && o->size > total_size))
 		o->size = total_size;
 
diff --git a/fio.1 b/fio.1
index 6e41d35..26531bd 100644
--- a/fio.1
+++ b/fio.1
@@ -1296,6 +1296,11 @@ a compressed format. They can be decompressed with fio, using the
 \fB\-\-inflate-log\fR command line parameter. The files will be stored with a
 \fB\.fz\fR suffix.
 .TP
+.BI block_error_percentiles \fR=\fPbool
+If set, record errors in trim block-sized units from writes and trims and output
+a histogram of how many trims it took to get to errors, and what kind of error
+was encountered.
+.TP
 .BI disable_lat \fR=\fPbool
 Disable measurements of total latency numbers. Useful only for cutting
 back the number of calls to \fBgettimeofday\fR\|(2), as that does impact performance at
@@ -1454,9 +1459,9 @@ exceeded before retrying operations
 Enable the reporting of percentiles of completion latencies.
 .TP
 .BI percentile_list \fR=\fPfloat_list
-Overwrite the default list of percentiles for completion
-latencies. Each number is a floating number in the range (0,100], and
-the maximum length of the list is 20. Use ':' to separate the
+Overwrite the default list of percentiles for completion latencies and the
+block error histogram. Each number is a floating number in the range (0,100],
+and the maximum length of the list is 20. Use ':' to separate the
 numbers. For example, \-\-percentile_list=99.5:99.9 will cause fio to
 report the values of completion latency below which 99.5% and 99.9% of
 the observed latencies fell, respectively.
diff --git a/init.c b/init.c
index 95e26b8..a126f79 100644
--- a/init.c
+++ b/init.c
@@ -767,6 +767,13 @@ static int fixup_options(struct thread_data *td)
 	if (!td->loops)
 		td->loops = 1;
 
+	if (td->o.block_error_hist && td->o.nr_files != 1) {
+		log_err("fio: block error histogram only available with "
+			"with a single file per job, but %d files "
+			"provided\n", td->o.nr_files);
+		ret = 1;
+	}
+
 	return ret;
 }
 
diff --git a/io_u.c b/io_u.c
index 7153ba2..5a35f25 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1595,6 +1595,19 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 
 	if (!gtod_reduce(td))
 		add_iops_sample(td, idx, bytes, &icd->time);
+
+	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
+		uint32_t *info = io_u_block_info(td, io_u);
+		if (BLOCK_INFO_STATE(*info) < BLOCK_STATE_TRIM_FAILURE) {
+			if (io_u->ddir == DDIR_TRIM) {
+				*info = BLOCK_INFO(BLOCK_STATE_TRIMMED,
+						BLOCK_INFO_TRIMS(*info) + 1);
+			} else if (io_u->ddir == DDIR_WRITE) {
+				*info = BLOCK_INFO_SET_STATE(BLOCK_STATE_WRITTEN,
+								*info);
+			}
+		}
+	}
 }
 
 static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
diff --git a/iolog.c b/iolog.c
index dfa329f..b29684a 100644
--- a/iolog.c
+++ b/iolog.c
@@ -291,6 +291,18 @@ void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
 {
 	struct io_piece *ipo = io_u->ipo;
 
+	if (td->ts.nr_block_infos) {
+		uint32_t *info = io_u_block_info(td, io_u);
+		if (BLOCK_INFO_STATE(*info) < BLOCK_STATE_TRIM_FAILURE) {
+			if (io_u->ddir == DDIR_TRIM)
+				*info = BLOCK_INFO_SET_STATE(*info,
+						BLOCK_STATE_TRIM_FAILURE);
+			else if (io_u->ddir == DDIR_WRITE)
+				*info = BLOCK_INFO_SET_STATE(*info,
+						BLOCK_STATE_WRITE_FAILURE);
+		}
+	}
+
 	if (!ipo)
 		return;
 
diff --git a/options.c b/options.c
index ba2692c..cda4790 100644
--- a/options.c
+++ b/options.c
@@ -3185,6 +3185,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 #endif
 	{
+		.name	= "block_error_percentiles",
+		.lname	= "Block error percentiles",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(block_error_hist),
+		.help	= "Record trim block errors and make a histogram",
+		.def	= "0",
+		.category = FIO_OPT_C_LOG,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "bwavgtime",
 		.lname	= "Bandwidth average time",
 		.type	= FIO_OPT_INT,
@@ -3308,11 +3318,12 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "percentile_list",
-		.lname	= "Completion latency percentile list",
+		.lname	= "Percentile list",
 		.type	= FIO_OPT_FLOAT_LIST,
 		.off1	= td_var_offset(percentile_list),
 		.off2	= td_var_offset(percentile_precision),
-		.help	= "Specify a custom list of percentiles to report",
+		.help	= "Specify a custom list of percentiles to report for "
+			  "completion latency and block errors",
 		.def    = "1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:99.9:99.95:99.99",
 		.maxlen	= FIO_IO_U_LIST_MAX_LEN,
 		.minfp	= 0.0,
diff --git a/server.c b/server.c
index c249849..93c0987 100644
--- a/server.c
+++ b/server.c
@@ -1158,6 +1158,10 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.latency_window	= cpu_to_le64(ts->latency_window);
 	p.ts.latency_percentile.u.i = cpu_to_le64(fio_double_to_uint64(ts->latency_percentile.u.f));
 
+	p.ts.nr_block_infos	= le64_to_cpu(ts->nr_block_infos);
+	for (i = 0; i < p.ts.nr_block_infos; i++)
+		p.ts.block_infos[i] = le32_to_cpu(ts->block_infos[i]);
+
 	convert_gs(&p.rs, rs);
 
 	fio_net_send_cmd(server_fd, FIO_NET_CMD_TS, &p, sizeof(p), NULL, NULL);
diff --git a/stat.c b/stat.c
index 252b2dc..34e3792 100644
--- a/stat.c
+++ b/stat.c
@@ -497,6 +497,147 @@ static void show_latencies(struct thread_stat *ts)
 	show_lat_m(io_u_lat_m);
 }
 
+static int block_state_category(int block_state)
+{
+	switch (block_state) {
+	case BLOCK_STATE_UNINIT:
+		return 0;
+	case BLOCK_STATE_TRIMMED:
+	case BLOCK_STATE_WRITTEN:
+		return 1;
+	case BLOCK_STATE_WRITE_FAILURE:
+	case BLOCK_STATE_TRIM_FAILURE:
+		return 2;
+	default:
+		assert(0);
+	}
+}
+
+static int compare_block_infos(const void *bs1, const void *bs2)
+{
+	uint32_t block1 = *(uint32_t *)bs1;
+	uint32_t block2 = *(uint32_t *)bs2;
+	int state1 = BLOCK_INFO_STATE(block1);
+	int state2 = BLOCK_INFO_STATE(block2);
+	int bscat1 = block_state_category(state1);
+	int bscat2 = block_state_category(state2);
+	int cycles1 = BLOCK_INFO_TRIMS(block1);
+	int cycles2 = BLOCK_INFO_TRIMS(block2);
+
+	if (bscat1 < bscat2)
+		return -1;
+	if (bscat1 > bscat2)
+		return 1;
+
+	if (cycles1 < cycles2)
+		return -1;
+	if (cycles1 > cycles2)
+		return 1;
+
+	if (state1 < state2)
+		return -1;
+	if (state1 > state2)
+		return 1;
+
+	assert(block1 == block2);
+	return 0;
+}
+
+static int calc_block_percentiles(int nr_block_infos, uint32_t *block_infos,
+				  fio_fp64_t *plist, unsigned int **percentiles,
+				  unsigned int *types)
+{
+	int len = 0;
+	int i, nr_uninit;
+
+	qsort(block_infos, nr_block_infos, sizeof(uint32_t), compare_block_infos);
+
+	while (len < FIO_IO_U_LIST_MAX_LEN && plist[len].u.f != 0.0)
+		len++;
+
+	if (!len)
+		return 0;
+
+	/*
+	 * Sort the percentile list. Note that it may already be sorted if
+	 * we are using the default values, but since it's a short list this
+	 * isn't a worry. Also note that this does not work for NaN values.
+	 */
+	if (len > 1)
+		qsort((void *)plist, len, sizeof(plist[0]), double_cmp);
+
+	nr_uninit = 0;
+	/* Start only after the uninit entries end */
+	for (nr_uninit = 0;
+	     nr_uninit < nr_block_infos
+		&& BLOCK_INFO_STATE(block_infos[nr_uninit]) == BLOCK_STATE_UNINIT;
+	     nr_uninit ++)
+		;
+
+	if (nr_uninit == nr_block_infos)
+		return 0;
+
+	*percentiles = calloc(len, sizeof(**percentiles));
+
+	for (i = 0; i < len; i++) {
+		int idx = (plist[i].u.f * (nr_block_infos - nr_uninit) / 100)
+				+ nr_uninit;
+		(*percentiles)[i] = BLOCK_INFO_TRIMS(block_infos[idx]);
+	}
+
+	memset(types, 0, sizeof(*types) * BLOCK_STATE_COUNT);
+	for (i = 0; i < nr_block_infos; i++)
+		types[BLOCK_INFO_STATE(block_infos[i])]++;
+
+	return len;
+}
+
+static const char *block_state_names[] = {
+	[BLOCK_STATE_UNINIT] = "unwritten",
+	[BLOCK_STATE_TRIMMED] = "trimmed",
+	[BLOCK_STATE_WRITTEN] = "written",
+	[BLOCK_STATE_TRIM_FAILURE] = "trim failure",
+	[BLOCK_STATE_WRITE_FAILURE] = "write failure",
+};
+
+static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
+			     fio_fp64_t *plist)
+{
+	int len, pos, i;
+	unsigned int *percentiles = NULL;
+	unsigned int block_state_counts[BLOCK_STATE_COUNT];
+
+	len = calc_block_percentiles(nr_block_infos, block_infos, plist,
+				     &percentiles, block_state_counts);
+
+	log_info("  block lifetime percentiles :\n   |");
+	pos = 0;
+	for (i = 0; i < len; i++) {
+		uint32_t block_info = percentiles[i];
+#define LINE_LENGTH	75
+		char str[LINE_LENGTH];
+		int strln = snprintf(str, LINE_LENGTH, " %3.2fth=%u%c",
+				     plist[i].u.f, block_info,
+				     i == len - 1 ? '\n' : ',');
+		assert(strln < LINE_LENGTH);
+		if (pos + strln > LINE_LENGTH) {
+			pos = 0;
+			log_info("\n   |");
+		}
+		log_info("%s", str);
+		pos += strln;
+#undef LINE_LENGTH
+	}
+	if (percentiles)
+		free(percentiles);
+
+	log_info("        states               :");
+	for (i = 0; i < BLOCK_STATE_COUNT; i++)
+		log_info(" %s=%u%c",
+			 block_state_names[i], block_state_counts[i],
+			 i == BLOCK_STATE_COUNT - 1 ? '\n' : ',');
+}
+
 static void show_thread_status_normal(struct thread_stat *ts,
 				      struct group_run_stats *rs)
 {
@@ -596,6 +737,10 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					ts->latency_percentile.u.f,
 					ts->latency_depth);
 	}
+
+	if (ts->nr_block_infos)
+		show_block_infos(ts->nr_block_infos, ts->block_infos,
+				  ts->percentile_list);
 }
 
 static void show_ddir_status_terse(struct thread_stat *ts,
@@ -998,6 +1143,45 @@ static struct json_object *show_thread_status_json(struct thread_stat *ts,
 	if (strlen(ts->description))
 		json_object_add_value_string(root, "desc", ts->description);
 
+	if (ts->nr_block_infos) {
+		/* Block error histogram and types */
+		int len;
+		unsigned int *percentiles = NULL;
+		unsigned int block_state_counts[BLOCK_STATE_COUNT];
+
+		len = calc_block_percentiles(ts->nr_block_infos, ts->block_infos,
+					     ts->percentile_list,
+					     &percentiles, block_state_counts);
+
+		if (len) {
+			struct json_object *block, *percentile_object, *states;
+			int state, i;
+			block = json_create_object();
+			json_object_add_value_object(root, "block", block);
+
+			percentile_object = json_create_object();
+			json_object_add_value_object(block, "percentiles",
+						     percentile_object);
+			for (i = 0; i < len; i++) {
+				char buf[20];
+				snprintf(buf, sizeof(buf), "%f",
+					 ts->percentile_list[i].u.f);
+				json_object_add_value_int(percentile_object,
+							  (const char *)buf,
+							  percentiles[i]);
+			}
+
+			states = json_create_object();
+			json_object_add_value_object(block, "states", states);
+			for (state = 0; state < BLOCK_STATE_COUNT; state++) {
+				json_object_add_value_int(states,
+					block_state_names[state],
+					block_state_counts[state]);
+			}
+			free(percentiles);
+		}
+	}
+
 	return root;
 }
 
@@ -1913,3 +2097,14 @@ void show_running_run_stats(void)
 	helper_do_stat = 1;
 	pthread_cond_signal(&helper_cond);
 }
+
+uint32_t *io_u_block_info(struct thread_data *td, struct io_u *io_u)
+{
+	/* Ignore io_u's which span multiple blocks--they will just get
+	 * inaccurate counts. */
+	int idx = (io_u->offset - io_u->file->file_offset)
+			/ td->o.bs[DDIR_TRIM];
+	uint32_t *info = &td->ts.block_infos[idx];
+	assert(idx < td->ts.nr_block_infos);
+	return info;
+}
diff --git a/stat.h b/stat.h
index 8b4416c..dd34012 100644
--- a/stat.h
+++ b/stat.h
@@ -112,6 +112,28 @@ struct group_run_stats {
 #define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
 					list of percentiles */
 
+/*
+ * Trim cycle count measurements
+ */
+#define MAX_NR_BLOCK_INFOS	8192
+#define BLOCK_INFO_STATE_SHIFT	29
+#define BLOCK_INFO_TRIMS(block_info)	\
+	((block_info) & ((1 << BLOCK_INFO_STATE_SHIFT) - 1))
+#define BLOCK_INFO_STATE(block_info)		\
+	((block_info) >> BLOCK_INFO_STATE_SHIFT)
+#define BLOCK_INFO(state, trim_cycles)	\
+	((trim_cycles) | ((state) << BLOCK_INFO_STATE_SHIFT))
+#define BLOCK_INFO_SET_STATE(block_info, state)	\
+	BLOCK_INFO(state, BLOCK_INFO_TRIMS(block_info))
+enum block_info_state {
+	BLOCK_STATE_UNINIT,
+	BLOCK_STATE_TRIMMED,
+	BLOCK_STATE_WRITTEN,
+	BLOCK_STATE_TRIM_FAILURE,
+	BLOCK_STATE_WRITE_FAILURE,
+	BLOCK_STATE_COUNT,
+} state;
+
 #define MAX_PATTERN_SIZE	512
 #define FIO_JOBNAME_SIZE	128
 #define FIO_JOBDESC_SIZE	256
@@ -180,6 +202,9 @@ struct thread_stat {
 	uint64_t total_err_count;
 	uint32_t first_error;
 
+	uint64_t nr_block_infos;
+	uint32_t block_infos[MAX_NR_BLOCK_INFOS];
+
 	uint32_t kb_base;
 	uint32_t unit_base;
 
@@ -261,4 +286,6 @@ static inline int usec_to_msec(unsigned long *min, unsigned long *max,
 #define __THREAD_RUNSTR_SZ(nr)	((nr) * 5)
 #define THREAD_RUNSTR_SZ	__THREAD_RUNSTR_SZ(thread_number)
 
+uint32_t *io_u_block_info(struct thread_data *td, struct io_u *io_u);
+
 #endif
diff --git a/thread_options.h b/thread_options.h
index 5a2428a..59e32ac 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -260,6 +260,8 @@ struct thread_options {
 	unsigned long long latency_target;
 	unsigned long long latency_window;
 	fio_fp64_t latency_percentile;
+
+	unsigned block_error_hist;
 };
 
 #define FIO_TOP_STR_MAX		256
@@ -485,6 +487,8 @@ struct thread_options_pack {
 	uint64_t latency_window;
 	uint32_t pad3;
 	fio_fp64_t latency_percentile;
+
+	uint32_t block_error_hist;
 } __attribute__((packed));
 
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct thread_options_pack *top);
-- 
2.2.0.rc0.207.ga3a616c


