Return-Path: <yjhong@google.com>
From: Yu-ju Hong <yjhong@google.com>
Subject: [PATCH]     stats: Add a function to report completion latency percentiles
Date: Fri, 12 Aug 2011 11:52:33 -0700
Message-Id: <1313175153-5355-1-git-send-email-yjhong@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Nauman Rafique <nauman@google.com>, Eric Gouriou <egouriou@google.com>, Yu-Ju Hong <yuju.hong@gmail.com>, Yu-ju Hong <yjhong@google.com>
List-ID: <fio@vger.kernel.org>

    This patch introduces two new options:
    1) Specifying --clat_percentiles enables the reporting of
       completion latency percentiles.
    2) --percentile_list allows the user to customize the
       list of percentiles to report.

    Signed-off-by: Yu-ju Hong <yjhong@google.com>
---
 HOWTO     |   13 +++++
 fio.1     |   15 ++++++
 fio.h     |   98 ++++++++++++++++++++++++++++++++++++++
 init.c    |    6 ++
 options.c |   18 +++++++
 parse.c   |   80 ++++++++++++++++++++++++++++----
 parse.h   |    4 ++
 stat.c    |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 380 insertions(+), 9 deletions(-)

diff --git a/HOWTO b/HOWTO
index b47d733..3b60f58 100644
--- a/HOWTO
+++ b/HOWTO
@@ -244,6 +244,7 @@ irange	Integer range with suffix. Allows value range to be given, such
 	1k:4k. If the option allows two sets of ranges, they can be
 	specified with a ',' or '/' delimiter: 1k-4k/8k-32k. Also see
 	int.
+float_list	A list of floating numbers, separated by a ':' character.
 
 With the above in mind, here follows the complete list of fio job
 parameters.
@@ -1120,6 +1121,18 @@ disable_slat=bool Disable measurements of submission latency numbers. See
 disable_bw=bool	Disable measurements of throughput/bandwidth numbers. See
 		disable_lat.
 
+clat_percentiles=bool Enable the reporting of percentiles of
+		 completion latencies.
+
+percentile_list=float_list Overwrite the default list of percentiles
+		for completion latencies. Each number is a floating
+		number in the range (0,100], and the maximum length of
+		the list is 20. Use ':' to separate the numbers, and
+		list the numbers in ascending order. For example,
+		--percentile_list=99.5:99.9 will cause fio to report
+		the values of completion latency below which 99.5% and
+		99.9% of the observed latencies fell, respectively.
+
 gtod_reduce=bool Enable all of the gettimeofday() reducing options
 		(disable_clat, disable_slat, disable_bw) plus reduce
 		precision of the timeout somewhat to really shrink
diff --git a/fio.1 b/fio.1
index 4fcd511..40940f3 100644
--- a/fio.1
+++ b/fio.1
@@ -96,6 +96,10 @@ Integer range: a range of integers specified in the format
 \fIupper\fR may contain a suffix as described above.  If an option allows two
 sets of ranges, they are separated with a `,' or `/' character. For example:
 `8\-8k/8M\-4G'.
+.TP
+.I float_list
+List of floating numbers: A list of floating numbers, separated by
+a ':' charcater.
 .SS "Parameter List"
 .TP
 .BI name \fR=\fPstr
@@ -900,6 +904,17 @@ the thread/process does any work.
 .TP
 .BI gid \fR=\fPint
 Set group ID, see \fBuid\fR.
+.TP
+.BI clat_percentiles \fR=\fPbool
+Enable the reporting of percentiles of completion latencies.
+.TP
+.BI percentile_list \fR=\fPfloat_list
+Overwrite the default list of percentiles for completion
+latencies. Each number is a floating number in the range (0,100], and
+the maximum length of the list is 20. Use ':' to separate the
+numbers. For example, --percentile_list=99.5:99.9 will cause fio to
+report the values of completion latency below which 99.5% and 99.9% of
+the observed latencies fell, respectively.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
 example:
diff --git a/fio.h b/fio.h
index d8e3011..6766351 100644
--- a/fio.h
+++ b/fio.h
@@ -78,6 +78,97 @@ enum {
 #define FIO_IO_U_LAT_U_NR 10
 #define FIO_IO_U_LAT_M_NR 12
 
+/*
+ * Aggregate clat samples to report percentile(s) of them.
+ *
+ * EXECUTIVE SUMMARY
+ *
+ * FIO_IO_U_PLAT_BITS determines the maximum statistical error on the
+ * value of resulting percentiles. The error will be approximately
+ * 1/2^(FIO_IO_U_PLAT_BITS+1) of the value.
+ *
+ * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the maximum
+ * range being tracked for latency samples. The maximum value tracked
+ * accurately will be 2^(GROUP_NR + PLAT_BITS -1) microseconds.
+ *
+ * FIO_IO_U_PLAT_GROUP_NR and FIO_IO_U_PLAT_BITS determine the memory
+ * requirement of storing those aggregate counts. The memory used will
+ * be (FIO_IO_U_PLAT_GROUP_NR * 2^FIO_IO_U_PLAT_BITS) * sizeof(int)
+ * bytes.
+ *
+ * FIO_IO_U_PLAT_NR is the total number of buckets.
+ *
+ * DETAILS
+ *
+ * Suppose the clat varies from 0 to 999 (usec), the straightforward
+ * method is to keep an array of (999 + 1) buckets, in which a counter
+ * keeps the count of samples which fall in the bucket, e.g.,
+ * {[0],[1],...,[999]}. However this consumes a huge amount of space,
+ * and can be avoided if an approximation is acceptable.
+ *
+ * One such method is to let the range of the bucket to be greater
+ * than one. This method has low accuracy when the value is small. For
+ * example, let the buckets be {[0,99],[100,199],...,[900,999]}, and
+ * the represented value of each bucket be the mean of the range. Then
+ * a value 0 has an round-off error of 49.5. To improve on this, we
+ * use buckets with non-uniform ranges, while bounding the error of
+ * each bucket within a ratio of the sample value. A simple example
+ * would be when error_bound = 0.005, buckets are {
+ * {[0],[1],...,[99]}, {[100,101],[102,103],...,[198,199]},..,
+ * {[900,909],[910,919]...}  }. The total range is partitioned into
+ * groups with different ranges, then buckets with uniform ranges. An
+ * upper bound of the error is (range_of_bucket/2)/value_of_bucket
+ *
+ * For better efficiency, we implement this using base two. We group
+ * samples by their Most Significant Bit (MSB), extract the next M bit
+ * of them as an index within the group, and discard the rest of the
+ * bits.
+ *
+ * E.g., assume a sample 'x' whose MSB is bit n (starting from bit 0),
+ * and use M bit for indexing
+ *
+ *        | n |    M bits   | bit (n-M-1) ... bit 0 |
+ *
+ * Because x is at least 2^n, and bit 0 to bit (n-M-1) is at most
+ * (2^(n-M) - 1), discarding bit 0 to (n-M-1) makes the round-off
+ * error
+ *
+ *           2^(n-M)-1    2^(n-M)    1
+ *      e <= --------- <= ------- = ---
+ *             2^n          2^n     2^M
+ *
+ * Furthermore, we use "mean" of the range to represent the bucket,
+ * the error e can be lowered by half to 1 / 2^(M+1). By using M bits
+ * as the index, each group must contains 2^M buckets.
+ *
+ * E.g. Let M (FIO_IO_U_PLAT_BITS) be 6
+ *      Error bound is 1/2^(6+1) = 0.0078125 (< 1%)
+ *
+ *	Group	MSB	#discarded	range of		#buckets
+ *			error_bits	value
+ *	----------------------------------------------------------------
+ *	0*	0~5	0		[0,63]			64
+ *	1*	6	0		[64,127]		64
+ *	2	7	1		[128,255]		64
+ *	3	8	2		[256,511]		64
+ *	4	9	3		[512,1023]		64
+ *	...	...	...		[...,...]		...
+ *	18	23	17		[8838608,+inf]**	64
+ *
+ *  * Special cases: when n < (M-1) or when n == (M-1), in both cases,
+ *    the value cannot be rounded off. Use all bits of the sample as
+ *    index.
+ *
+ *  ** If a sample's MSB is greater than 23, it will be counted as 23.
+ */
+
+#define FIO_IO_U_PLAT_BITS 6
+#define FIO_IO_U_PLAT_VAL (1 << FIO_IO_U_PLAT_BITS)
+#define FIO_IO_U_PLAT_GROUP_NR 19
+#define FIO_IO_U_PLAT_NR (FIO_IO_U_PLAT_GROUP_NR * FIO_IO_U_PLAT_VAL)
+#define FIO_IO_U_LIST_MAX_LEN 20 /* The size of the default and user-specified
+					list of percentiles */
+
 #define MAX_PATTERN_SIZE 512
 
 struct thread_stat {
@@ -118,11 +209,15 @@ struct thread_stat {
 	/*
 	 * IO depth and latency stats
 	 */
+	unsigned int clat_percentiles;
+	double* percentile_list;
+
 	unsigned int io_u_map[FIO_IO_U_MAP_NR];
 	unsigned int io_u_submit[FIO_IO_U_MAP_NR];
 	unsigned int io_u_complete[FIO_IO_U_MAP_NR];
 	unsigned int io_u_lat_u[FIO_IO_U_LAT_U_NR];
 	unsigned int io_u_lat_m[FIO_IO_U_LAT_M_NR];
+	unsigned int io_u_plat [2][FIO_IO_U_PLAT_NR];
 	unsigned long total_io_u[3];
 	unsigned long short_io_u[3];
 	unsigned long total_submit;
@@ -266,6 +361,9 @@ struct thread_options {
 	unsigned int trim_batch;
 	unsigned int trim_zero;
 	unsigned long long trim_backlog;
+	unsigned int clat_percentiles;
+	unsigned int overwrite_plist;
+	double percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	char *read_iolog_file;
 	char *write_iolog_file;
diff --git a/init.c b/init.c
index 9b386c5..a920c6e 100644
--- a/init.c
+++ b/init.c
@@ -616,6 +616,12 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num)
 
 	td->mutex = fio_mutex_init(0);
 
+	td->ts.clat_percentiles = td->o.clat_percentiles;
+	if (td->o.overwrite_plist)
+		td->ts.percentile_list = td->o.percentile_list;
+	else
+		td->ts.percentile_list = NULL;
+
 	td->ts.clat_stat[0].min_val = td->ts.clat_stat[1].min_val = ULONG_MAX;
 	td->ts.slat_stat[0].min_val = td->ts.slat_stat[1].min_val = ULONG_MAX;
 	td->ts.lat_stat[0].min_val = td->ts.lat_stat[1].min_val = ULONG_MAX;
diff --git a/options.c b/options.c
index 82e3e27..3d8a720 100644
--- a/options.c
+++ b/options.c
@@ -1935,6 +1935,24 @@ static struct fio_option options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(refill_buffers),
 		.help	= "Refill IO buffers on every IO submit",
 	},
+	{
+		.name	= "clat_percentiles",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(clat_percentiles),
+		.help	= "Enable the reporting of completion latency percentiles",
+		.def	= "0",
+	},
+	{
+		.name	= "percentile_list",
+		.type	= FIO_OPT_FLOAT_LIST,
+		.off1	= td_var_offset(percentile_list),
+		.off2   = td_var_offset(overwrite_plist),
+		.help	= "Specify a custom list of percentiles to report",
+		.maxlen	= FIO_IO_U_LIST_MAX_LEN,
+		.minfp	= 0.0,
+		.maxfp	= 100.0,
+	},
+
 #ifdef FIO_HAVE_DISK_UTIL
 	{
 		.name	= "disk_util",
diff --git a/parse.c b/parse.c
index 3e15b54..c2c5bf2 100644
--- a/parse.c
+++ b/parse.c
@@ -9,6 +9,7 @@
 #include <errno.h>
 #include <limits.h>
 #include <stdlib.h>
+#include <math.h>
 
 #include "parse.h"
 #include "debug.h"
@@ -45,13 +46,23 @@ static void posval_sort(struct fio_option *o, struct value_pair *vpmap)
 
 static void show_option_range(struct fio_option *o, FILE *out)
 {
-	if (!o->minval && !o->maxval)
-		return;
+	if (o->type == FIO_OPT_FLOAT_LIST){
+		if (isnan(o->minfp) && isnan(o->maxfp))
+			return;
+
+		fprintf(out, "%20s: min=%f", "range", o->minfp);
+		if (!isnan(o->maxfp))
+			fprintf(out, ", max=%f", o->maxfp);
+		fprintf(out, "\n");
+	} else {
+		if (!o->minval && !o->maxval)
+			return;
 
-	fprintf(out, "%20s: min=%d", "range", o->minval);
-	if (o->maxval)
-		fprintf(out, ", max=%d", o->maxval);
-	fprintf(out, "\n");
+		fprintf(out, "%20s: min=%d", "range", o->minval);
+		if (o->maxval)
+			fprintf(out, ", max=%d", o->maxval);
+		fprintf(out, "\n");
+	}
 }
 
 static void show_option_values(struct fio_option *o)
@@ -86,6 +97,7 @@ static void show_option_help(struct fio_option *o, FILE *out)
 		"string with dual range (opt=1k-4k,4k-8k)",
 		"integer value (opt=100)",
 		"boolean value (opt=1)",
+		"list of floating point values separated by ':' (opt=5.9:7.8)",
 		"no argument (opt)",
 		"deprecated",
 	};
@@ -195,6 +207,14 @@ static unsigned long long get_mult_bytes(const char *str, int len, void *data,
 }
 
 /*
+ * Convert string into a floating number. Return 1 for success and 0 otherwise.
+ */
+int str_to_float(const char *str, double *val)
+{
+	return (1 == sscanf(str, "%lf", val));
+}
+
+/*
  * convert string into decimal value, noting any size suffix
  */
 int str_to_decimal(const char *str, long long *val, int kilo, void *data)
@@ -317,11 +337,13 @@ static int opt_len(const char *str)
 	} while (0)
 
 static int __handle_option(struct fio_option *o, const char *ptr, void *data,
-			   int first, int more)
+			   int first, int more, int curr)
 {
 	int il, *ilp;
+	double* flp;
 	long long ull, *ullp;
 	long ul1, ul2;
+	double uf;
 	char **cp;
 	int ret = 0, is_time = 0;
 
@@ -429,6 +451,39 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 		}
 		break;
 	}
+	case FIO_OPT_FLOAT_LIST: {
+
+		if (first) {
+			ul2 = 1;
+			ilp = td_var(data, o->off2);
+			*ilp = ul2;
+		}
+		if (curr >= o->maxlen) {
+			fprintf(stderr, "the list exceeding max length %d\n",
+					o->maxlen);
+			return 1;
+		}
+		if(!str_to_float(ptr, &uf)){
+			fprintf(stderr, "not a floating point value: %s\n",
+					ptr);
+			return 1;
+		}
+		if (!isnan(o->maxfp) && uf > o->maxfp) {
+			fprintf(stderr, "value out of range: %f"
+				" (range max: %f)\n", uf, o->maxfp);
+			return 1;
+		}
+		if (!isnan(o->minfp) && uf < o->minfp) {
+			fprintf(stderr, "value out of range: %f"
+				" (range min: %f)\n", uf, o->minfp);
+			return 1;
+		}
+
+		flp = td_var(data, o->off1);
+		flp[curr] = uf;
+
+		break;
+	}
 	case FIO_OPT_STR_STORE: {
 		fio_opt_str_fn *fn = o->cb;
 
@@ -596,7 +651,8 @@ static int handle_option(struct fio_option *o, const char *__ptr, void *data)
 		ptr2 = NULL;
 		if (ptr &&
 		    (o->type != FIO_OPT_STR_STORE) &&
-		    (o->type != FIO_OPT_STR)) {
+		    (o->type != FIO_OPT_STR) &&
+		    (o->type != FIO_OPT_FLOAT_LIST)) {
 			ptr2 = strchr(ptr, ',');
 			if (ptr2 && *(ptr2 + 1) == '\0')
 				*ptr2 = '\0';
@@ -606,6 +662,8 @@ static int handle_option(struct fio_option *o, const char *__ptr, void *data)
 				if (!ptr2)
 					ptr2 = strchr(ptr, '-');
 			}
+		} else if (ptr && o->type == FIO_OPT_FLOAT_LIST) {
+			ptr2 = strchr(ptr, ':');
 		}
 
 		/*
@@ -613,7 +671,7 @@ static int handle_option(struct fio_option *o, const char *__ptr, void *data)
 		 * we are doing multiple arguments, we can allow the first one
 		 * being empty.
 		 */
-		__ret = __handle_option(o, ptr, data, !done, !!ptr2);
+		__ret = __handle_option(o, ptr, data, !done, !!ptr2, done);
 		if (ret)
 			ret = __ret;
 
@@ -968,6 +1026,10 @@ void option_init(struct fio_option *o)
 		o->minval = 0;
 		o->maxval = 1;
 	}
+	if (o->type == FIO_OPT_FLOAT_LIST) {
+		o->minfp = NAN;
+		o->maxfp = NAN;
+	}
 	if (o->type == FIO_OPT_STR_SET && o->def) {
 		fprintf(stderr, "Option %s: string set option with"
 				" default will always be true\n", o->name);
diff --git a/parse.h b/parse.h
index 2dd8459..c5a7417 100644
--- a/parse.h
+++ b/parse.h
@@ -16,6 +16,7 @@ enum fio_opt_type {
 	FIO_OPT_RANGE,
 	FIO_OPT_INT,
 	FIO_OPT_BOOL,
+	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
 	FIO_OPT_DEPRECATED,
 };
@@ -47,6 +48,9 @@ struct fio_option {
 	void *roff1, *roff2, *roff3, *roff4;
 	unsigned int maxval;		/* max and min value */
 	int minval;
+	double maxfp;			/* max and min floating value */
+	double minfp;
+	unsigned int maxlen;		/* max length */
 	int neg;			/* negate value stored */
 	int prio;
 	void *cb;			/* callback */
diff --git a/stat.c b/stat.c
index 8be4be5..25dd179 100644
--- a/stat.c
+++ b/stat.c
@@ -28,6 +28,134 @@ void update_rusage_stat(struct thread_data *td)
 	memcpy(&ts->ru_start, &ts->ru_end, sizeof(ts->ru_end));
 }
 
+/*
+ * Given a latency, return the index of the corresponding bucket in
+ * the structure tracking percentiles.
+ *
+ * (1) find the group (and error bits) that the value (latency)
+ * belongs to by looking at its MSB. (2) find the bucket number in the
+ * group by looking at the index bits.
+ *
+ */
+static unsigned int plat_val_to_idx(unsigned int val)
+{
+	unsigned int msb, error_bits, base, offset, idx;
+
+	/* Find MSB starting from bit 0 */
+	if (val == 0)
+		msb = 0;
+	else
+		msb = (sizeof(val)*8) - __builtin_clz(val) - 1;
+
+	/* MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
+	 * all bits of the sample as index */
+	if (msb <= FIO_IO_U_PLAT_BITS)
+		return val;
+
+	/* Compute the number of error bits to discard*/
+	error_bits = msb - FIO_IO_U_PLAT_BITS;
+
+	/* Compute the number of buckets before the group */
+	base = (error_bits + 1) << FIO_IO_U_PLAT_BITS;
+
+	/* Discard the error bits and apply the mask to find the
+         * index for the buckets in the group */
+	offset = (FIO_IO_U_PLAT_VAL - 1) & (val >> error_bits);
+
+	/* Make sure the index does not exceed (array size - 1) */
+	idx = (base + offset) < (FIO_IO_U_PLAT_NR - 1)?
+		(base + offset) : (FIO_IO_U_PLAT_NR - 1);
+
+	return idx;
+}
+
+/*
+ * Convert the given index of the bucket array to the value
+ * represented by the bucket
+ */
+static unsigned int plat_idx_to_val(unsigned int idx)
+{
+	unsigned int error_bits, k, base;
+
+	assert(idx < FIO_IO_U_PLAT_NR);
+
+	/* MSB <= (FIO_IO_U_PLAT_BITS-1), cannot be rounded off. Use
+	 * all bits of the sample as index */
+	if (idx < (FIO_IO_U_PLAT_VAL << 1) )
+		return idx;
+
+	/* Find the group and compute the minimum value of that group */
+	error_bits = (idx >> FIO_IO_U_PLAT_BITS) -1;
+	base = 1 << (error_bits + FIO_IO_U_PLAT_BITS);
+
+	/* Find its bucket number of the group */
+	k = idx % FIO_IO_U_PLAT_VAL;
+
+	/* Return the mean of the range of the bucket */
+	return base + ((k + 0.5) * (1 << error_bits));
+}
+
+static int double_cmp(const void *a, const void *b)
+{
+	const double fa = *(const double *)a;
+	const double fb = *(const double *)b;
+	int cmp = 0;
+
+	if (fa > fb)
+		cmp = 1;
+	else if (fa < fb)
+		cmp = -1;
+
+	return cmp;
+}
+
+/*
+ * Find and display the p-th percentile of clat
+ */
+static void show_clat_percentiles(unsigned int* io_u_plat, unsigned long nr,
+				 double* user_list)
+{
+	unsigned long sum = 0;
+	unsigned int len, i, j = 0;
+	static const double def_list[FIO_IO_U_LIST_MAX_LEN] = {
+			1.0, 5.0, 10.0, 20.0, 30.0,
+			40.0, 50.0, 60.0, 70.0, 80.0,
+			90.0, 95.0, 99.0, 99.5, 99.9};
+
+	const double* plist = user_list? user_list: def_list;
+	for (len = 0; len <FIO_IO_U_LIST_MAX_LEN && plist[len] != 0; len++) {}
+
+	/* Sort the user-specified list. Note that this does not work
+	   for NaN values */
+	if (user_list && len > 1)
+		qsort((void*)user_list, len, sizeof(user_list[0]), double_cmp);
+
+	int is_last = 0;
+	log_info("    clat percentiles (usec) :");
+
+	for (i = 0; i <FIO_IO_U_PLAT_NR && !is_last; i++) {
+		sum += io_u_plat[i];
+		while (sum >= (plist[j]/100 * nr)) {
+			assert(plist[j] <= 100.0);
+
+			if (j!=0 && (j%4) == 0)	/* for formatting */
+				log_info("                             ");
+
+			/* end of the list */
+			is_last = (j == len - 1);
+
+			log_info(" %2.2fth=%u%c", plist[j], plat_idx_to_val(i),
+				 (is_last? '\n' : ','));
+
+			if (is_last) break;
+
+			if (j%4 == 3)	/* for formatting */
+				log_info("\n");
+			j++;
+		}
+	}
+}
+
 static int calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 		    double *mean, double *dev)
 {
@@ -228,6 +356,11 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		free(minp);
 		free(maxp);
 	}
+	if (ts->clat_percentiles) {
+		show_clat_percentiles(ts->io_u_plat[ddir],
+					ts->clat_stat[ddir].samples,
+					ts->percentile_list);
+	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg;
 
@@ -565,6 +698,12 @@ void show_run_stats(void)
 
 		ts = &threadstats[j];
 
+		ts->clat_percentiles = td->o.clat_percentiles;
+		if (td->o.overwrite_plist)
+			ts->percentile_list = td->o.percentile_list;
+		else
+			ts->percentile_list = NULL;
+
 		idx++;
 		ts->members++;
 
@@ -636,6 +775,10 @@ void show_run_stats(void)
 		for (k = 0; k <= 2; k++) {
 			ts->total_io_u[k] += td->ts.total_io_u[k];
 			ts->short_io_u[k] += td->ts.short_io_u[k];
+
+			int m;
+			for (m = 0; m < FIO_IO_U_PLAT_NR; m++)
+				ts->io_u_plat[k][m] += td->ts.io_u_plat[k][m];
 		}
 
 		ts->total_run_time += td->ts.total_run_time;
@@ -774,6 +917,15 @@ void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
 	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis());
 }
 
+static void add_clat_percentile_sample(struct thread_stat *ts,
+				unsigned long usec, enum fio_ddir ddir)
+{
+	unsigned int idx = plat_val_to_idx(usec);
+	assert(idx < FIO_IO_U_PLAT_NR);
+
+	ts->io_u_plat[ddir][idx]++;
+}
+
 void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 		     unsigned long usec, unsigned int bs)
 {
@@ -786,6 +938,9 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 
 	if (ts->clat_log)
 		add_log_sample(td, ts->clat_log, usec, ddir, bs);
+
+	if (ts->clat_percentiles)
+		add_clat_percentile_sample(ts, usec, ddir);
 }
 
 void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
-- 
1.7.3.1


