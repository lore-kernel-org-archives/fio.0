Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:35788 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753934AbcHSMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Aug 2016 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1baiSx-0007yc-Tz
        for fio@vger.kernel.org; Fri, 19 Aug 2016 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160819120002.324BB2C0285@kernel.dk>
Date: Fri, 19 Aug 2016 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c22825bb537af1f84a18dcb4af6d8c6844f751ac:

  Fix backwards reads with --size smaller than the file size (2016-08-16 15:22:17 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d1f6fcadb7cb28a5e57a5e573395fe2deb3cfd7b:

  Manual page for fiologparser_hist.py and Makefile updates to install them. (2016-08-18 18:56:17 -0400)

----------------------------------------------------------------
Jens Axboe (4):
      fio: use the proper enum type for the shifted IO engine flags
      Add basic write/read-and-verify example job file
      parse: fix void * pointer math complaint
      Merge branch 'epoch' of https://github.com/cronburg/fio

Karl Cronburg (2):
      Option for changing log files to use Unix epoch instead of being     zero-based (when fio starts) epoch.
      Manual page for fiologparser_hist.py and Makefile updates to install     them.

 HOWTO                             |   4 +
 Makefile                          |   6 +-
 backend.c                         |   2 +-
 cconv.c                           |   2 +
 examples/basic-verify.fio         |  12 +++
 fio.1                             |   5 +
 fio.h                             |   9 +-
 fio_time.h                        |   1 +
 libfio.c                          |  10 +-
 options.c                         |   9 ++
 parse.h                           |   2 +-
 rate-submit.c                     |   2 +-
 stat.c                            |   2 +-
 thread_options.h                  |   3 +
 time.c                            |  11 +++
 tools/hist/fiologparser_hist.py   | 117 ++--------------------
 tools/hist/fiologparser_hist.py.1 | 201 ++++++++++++++++++++++++++++++++++++++
 17 files changed, 272 insertions(+), 126 deletions(-)
 create mode 100644 examples/basic-verify.fio
 create mode 100644 tools/hist/fiologparser_hist.py.1

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index c1b768d..07419a1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1681,6 +1681,10 @@ log_store_compressed=bool	If set, fio will store the log files in a
 		the --inflate-log command line parameter. The files will be
 		stored with a .fz suffix.
 
+log_unix_epoch=bool	If set, fio will log Unix timestamps to the log
+		files produced by enabling write_type_log for each log type, instead
+		of the default zero-based timestamps.
+
 block_error_percentiles=bool	If set, record errors in trim block-sized
 		units from writes and trims and output a histogram of
 		how many trims it took to get to errors, and what kind
diff --git a/Makefile b/Makefile
index b54f7e9..3f67ab7 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/fio_latency2csv.py tools/hist/fiologparser_hist.py)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3
@@ -430,7 +430,7 @@ clean: FORCE
 	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) $(T_TEST_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d oslib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do] lexer.h
 
 distclean: clean FORCE
-	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
+	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf fiologparser_hist.pdf
 
 cscope:
 	@cscope -b -R
@@ -442,6 +442,7 @@ doc: tools/plot/fio2gnuplot.1
 	@man -t ./fio.1 | ps2pdf - fio.pdf
 	@man -t tools/fio_generate_plots.1 | ps2pdf - fio_generate_plots.pdf
 	@man -t tools/plot/fio2gnuplot.1 | ps2pdf - fio2gnuplot.pdf
+	@man -t tools/hist/fiologparser_hist.py.1 | ps2pdf - fiologparser_hist.pdf
 
 test:
 
@@ -452,5 +453,6 @@ install: $(PROGS) $(SCRIPTS) tools/plot/fio2gnuplot.1 FORCE
 	$(INSTALL) -m 644 $(SRCDIR)/fio.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 $(SRCDIR)/tools/fio_generate_plots.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/fio2gnuplot.1 $(DESTDIR)$(mandir)/man1
+	$(INSTALL) -m 644 $(SRCDIR)/tools/hist/fiologparser_hist.py.1 $(DESTDIR)$(mandir)/man1
 	$(INSTALL) -m 755 -d $(DESTDIR)$(sharedir)
 	$(INSTALL) -m 644 $(SRCDIR)/tools/plot/*gpm $(DESTDIR)$(sharedir)/
diff --git a/backend.c b/backend.c
index b43486d..d986586 100644
--- a/backend.c
+++ b/backend.c
@@ -1675,7 +1675,7 @@ static void *thread_main(void *data)
 	if (rate_submit_init(td, sk_out))
 		goto err;
 
-	fio_gettime(&td->epoch, NULL);
+	set_epoch_time(td, o->log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	memcpy(&td->bw_sample_time, &td->epoch, sizeof(td->epoch));
 	memcpy(&td->iops_sample_time, &td->epoch, sizeof(td->epoch));
diff --git a/cconv.c b/cconv.c
index 8d9a0a8..194e342 100644
--- a/cconv.c
+++ b/cconv.c
@@ -187,6 +187,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->log_offset = le32_to_cpu(top->log_offset);
 	o->log_gz = le32_to_cpu(top->log_gz);
 	o->log_gz_store = le32_to_cpu(top->log_gz_store);
+	o->log_unix_epoch = le32_to_cpu(top->log_unix_epoch);
 	o->norandommap = le32_to_cpu(top->norandommap);
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
@@ -379,6 +380,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->log_offset = cpu_to_le32(o->log_offset);
 	top->log_gz = cpu_to_le32(o->log_gz);
 	top->log_gz_store = cpu_to_le32(o->log_gz_store);
+	top->log_unix_epoch = cpu_to_le32(o->log_unix_epoch);
 	top->norandommap = cpu_to_le32(o->norandommap);
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
diff --git a/examples/basic-verify.fio b/examples/basic-verify.fio
new file mode 100644
index 0000000..7871aeb
--- /dev/null
+++ b/examples/basic-verify.fio
@@ -0,0 +1,12 @@
+# The most basic form of data verification. Write the device randomly
+# in 4K chunks, then read it back and verify the contents.
+[write-and-verify]
+rw=randwrite
+bs=4k
+direct=1
+ioengine=libaio
+iodepth=16
+verify=crc32c
+# Use /dev/XXX. For running this on a file instead, remove the filename
+# option and add a size=32G (or whatever file size you want) instead.
+filename=/dev/XXX
diff --git a/fio.1 b/fio.1
index 696664a..8d596fb 100644
--- a/fio.1
+++ b/fio.1
@@ -1546,6 +1546,11 @@ If set, fio will store the log files in a compressed format. They can be
 decompressed with fio, using the \fB\-\-inflate-log\fR command line parameter.
 The files will be stored with a \fB\.fz\fR suffix.
 .TP
+.BI log_unix_epoch \fR=\fPbool
+If set, fio will log Unix timestamps to the log files produced by enabling
+\fBwrite_type_log\fR for each log type, instead of the default zero-based
+timestamps.
+.TP
 .BI block_error_percentiles \fR=\fPbool
 If set, record errors in trim block-sized units from writes and trims and output
 a histogram of how many trims it took to get to errors, and what kind of error
diff --git a/fio.h b/fio.h
index 0da0bc5..df4fbb1 100644
--- a/fio.h
+++ b/fio.h
@@ -311,6 +311,7 @@ struct thread_data {
 
 	struct timeval start;	/* start of this loop */
 	struct timeval epoch;	/* time job was started */
+	unsigned long long unix_epoch; /* Time job was started, unix epoch based. */
 	struct timeval last_issue;
 	long time_offset;
 	struct timeval tv_cache;
@@ -563,7 +564,8 @@ enum {
 
 static inline enum fio_ioengine_flags td_ioengine_flags(struct thread_data *td)
 {
-	return (td->flags >> TD_ENG_FLAG_SHIFT) & TD_ENG_FLAG_MASK;
+	return (enum fio_ioengine_flags)
+		((td->flags >> TD_ENG_FLAG_SHIFT) & TD_ENG_FLAG_MASK);
 }
 
 static inline void td_set_ioengine_flags(struct thread_data *td)
@@ -571,9 +573,10 @@ static inline void td_set_ioengine_flags(struct thread_data *td)
 	td->flags |= (td->io_ops->flags << TD_ENG_FLAG_SHIFT);
 }
 
-static inline bool td_ioengine_flagged(struct thread_data *td, unsigned int val)
+static inline bool td_ioengine_flagged(struct thread_data *td,
+				       enum fio_ioengine_flags flags)
 {
-	return ((td->flags >> TD_ENG_FLAG_SHIFT) & val) != 0;
+	return ((td->flags >> TD_ENG_FLAG_SHIFT) & flags) != 0;
 }
 
 extern void td_set_runstate(struct thread_data *, int);
diff --git a/fio_time.h b/fio_time.h
index e31ea09..b49cc82 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -20,5 +20,6 @@ extern bool ramp_time_over(struct thread_data *);
 extern bool in_ramp_time(struct thread_data *);
 extern void fio_time_init(void);
 extern void timeval_add_msec(struct timeval *, unsigned int);
+extern void set_epoch_time(struct thread_data *, int);
 
 #endif
diff --git a/libfio.c b/libfio.c
index fb7d35a..d88ed4e 100644
--- a/libfio.c
+++ b/libfio.c
@@ -134,7 +134,6 @@ void clear_io_state(struct thread_data *td, int all)
 
 void reset_all_stats(struct thread_data *td)
 {
-	struct timeval tv;
 	int i;
 
 	reset_io_counters(td, 1);
@@ -148,11 +147,10 @@ void reset_all_stats(struct thread_data *td)
 		td->rwmix_issues = 0;
 	}
 
-	fio_gettime(&tv, NULL);
-	memcpy(&td->epoch, &tv, sizeof(tv));
-	memcpy(&td->start, &tv, sizeof(tv));
-	memcpy(&td->iops_sample_time, &tv, sizeof(tv));
-	memcpy(&td->bw_sample_time, &tv, sizeof(tv));
+	set_epoch_time(td, td->o.log_unix_epoch);
+	memcpy(&td->start, &td->epoch, sizeof(struct timeval));
+	memcpy(&td->iops_sample_time, &td->epoch, sizeof(struct timeval));
+	memcpy(&td->bw_sample_time, &td->epoch, sizeof(struct timeval));
 
 	lat_target_reset(td);
 	clear_rusage_stat(td);
diff --git a/options.c b/options.c
index 517ee68..50b4d09 100644
--- a/options.c
+++ b/options.c
@@ -3648,6 +3648,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 #endif
 	{
+		.name = "log_unix_epoch",
+		.lname = "Log epoch unix",
+		.type = FIO_OPT_BOOL,
+		.off1 = offsetof(struct thread_options, log_unix_epoch),
+		.help = "Use Unix time in log files",
+		.category = FIO_OPT_C_LOG,
+		.group = FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "block_error_percentiles",
 		.lname	= "Block error percentiles",
 		.type	= FIO_OPT_BOOL,
diff --git a/parse.h b/parse.h
index d852ddc..7ba4e37 100644
--- a/parse.h
+++ b/parse.h
@@ -116,7 +116,7 @@ static inline void *td_var(struct thread_options *to, struct fio_option *o,
 	else
 		ret = to;
 
-	return ret + offset;
+	return (char *) ret + offset;
 }
 
 static inline int parse_is_percent(unsigned long long val)
diff --git a/rate-submit.c b/rate-submit.c
index 2efbdcb..42927ff 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -123,7 +123,7 @@ static int io_workqueue_init_worker_fn(struct submit_worker *sw)
 	if (td_io_init(td))
 		goto err_io_init;
 
-	fio_gettime(&td->epoch, NULL);
+	set_epoch_time(td, td->o.log_unix_epoch);
 	fio_getrusage(&td->ru_start);
 	clear_io_state(td, 1);
 
diff --git a/stat.c b/stat.c
index 5e7c593..552d88d 100644
--- a/stat.c
+++ b/stat.c
@@ -2020,7 +2020,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
 		s->val = val;
-		s->time = t;
+		s->time = t + iolog->td->unix_epoch;
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
 
diff --git a/thread_options.h b/thread_options.h
index d70fda3..1b4590f 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -135,6 +135,7 @@ struct thread_options {
 	unsigned int log_offset;
 	unsigned int log_gz;
 	unsigned int log_gz_store;
+	unsigned int log_unix_epoch;
 	unsigned int norandommap;
 	unsigned int softrandommap;
 	unsigned int bs_unaligned;
@@ -393,11 +394,13 @@ struct thread_options_pack {
 	uint32_t log_offset;
 	uint32_t log_gz;
 	uint32_t log_gz_store;
+	uint32_t log_unix_epoch;
 	uint32_t norandommap;
 	uint32_t softrandommap;
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
 	uint32_t bs_is_seq_rand;
+	uint32_t pad1;
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
diff --git a/time.c b/time.c
index f1c5d3f..f5dc049 100644
--- a/time.c
+++ b/time.c
@@ -151,6 +151,17 @@ void set_genesis_time(void)
 	fio_gettime(&genesis, NULL);
 }
 
+void set_epoch_time(struct thread_data *td, int log_unix_epoch)
+{
+	fio_gettime(&td->epoch, NULL);
+	if (log_unix_epoch) {
+		struct timeval tv;
+		gettimeofday(&tv, NULL);
+		td->unix_epoch = (unsigned long long)(tv.tv_sec) * 1000 +
+		                 (unsigned long long)(tv.tv_usec) / 1000;
+	}
+}
+
 void fill_start_time(struct timeval *t)
 {
 	memcpy(t, &genesis, sizeof(genesis));
diff --git a/tools/hist/fiologparser_hist.py b/tools/hist/fiologparser_hist.py
index 5891427..778cc00 100755
--- a/tools/hist/fiologparser_hist.py
+++ b/tools/hist/fiologparser_hist.py
@@ -11,111 +11,6 @@
             4000, 39, 1152, 1546.962, 1545.785, 1627.192, 1640.019, 1691.204, 1744
             ...
     
-    Notes:
-
-    * end-times are calculated to be uniform increments of the --interval value given,
-      regardless of when histogram samples are reported. Of note:
-        
-        * Intervals with no samples are omitted. In the example above this means
-          "no statistics from 2 to 3 seconds" and "39 samples influenced the statistics
-          of the interval from 3 to 4 seconds".
-        
-        * Intervals with a single sample will have the same value for all statistics
-        
-    * The number of samples is unweighted, corresponding to the total number of samples
-      which have any effect whatsoever on the interval.
-
-    * Min statistics are computed using value of the lower boundary of the first bin
-      (in increasing bin order) with non-zero samples in it. Similarly for max,
-      we take the upper boundary of the last bin with non-zero samples in it.
-      This is semantically identical to taking the 0th and 100th percentiles with a
-      50% bin-width buffer (because percentiles are computed using mid-points of
-      the bins). This enforces the following nice properties:
-
-        * min <= 50th <= 90th <= 95th <= 99th <= max
-
-        * min and max are strict lower and upper bounds on the actual
-          min / max seen by fio (and reported in *_clat.* with averaging turned off).
-
-    * Average statistics use a standard weighted arithmetic mean.
-
-    * Percentile statistics are computed using the weighted percentile method as
-      described here: https://en.wikipedia.org/wiki/Percentile#Weighted_percentile
-      See weights() method for details on how weights are computed for individual
-      samples. In process_interval() we further multiply by the height of each bin
-      to get weighted histograms.
-    
-    * We convert files given on the command line, assumed to be fio histogram files,
-      An individual histogram file can contain the
-      histograms for multiple different r/w directions (notably when --rw=randrw). This
-      is accounted for by tracking each r/w direction separately. In the statistics
-      reported we ultimately merge *all* histograms (regardless of r/w direction).
-
-    * The value of *_GROUP_NR in stat.h (and *_BITS) determines how many latency bins
-      fio outputs when histogramming is enabled. Namely for the current default of
-      GROUP_NR=19, we get 1,216 bins with a maximum latency of approximately 17
-      seconds. For certain applications this may not be sufficient. With GROUP_NR=24
-      we have 1,536 bins, giving us a maximum latency of 541 seconds (~ 9 minutes). If
-      you expect your application to experience latencies greater than 17 seconds,
-      you will need to recompile fio with a larger GROUP_NR, e.g. with:
-        
-            sed -i.bak 's/^#define FIO_IO_U_PLAT_GROUP_NR 19\n/#define FIO_IO_U_PLAT_GROUP_NR 24/g' stat.h
-            make fio
-            
-      Quick reference table for the max latency corresponding to a sampling of
-      values for GROUP_NR:
-            
-            GROUP_NR | # bins | max latency bin value
-            19       | 1216   | 16.9 sec
-            20       | 1280   | 33.8 sec
-            21       | 1344   | 67.6 sec
-            22       | 1408   | 2  min, 15 sec
-            23       | 1472   | 4  min, 32 sec
-            24       | 1536   | 9  min, 4  sec
-            25       | 1600   | 18 min, 8  sec
-            26       | 1664   | 36 min, 16 sec
-      
-    * At present this program automatically detects the number of histogram bins in
-      the log files, and adjusts the bin latency values accordingly. In particular if
-      you use the --log_hist_coarseness parameter of fio, you get output files with
-      a number of bins according to the following table (note that the first
-      row is identical to the table above):
-
-      coarse \ GROUP_NR
-                  19     20    21     22     23     24     25     26
-             -------------------------------------------------------
-            0  [[ 1216,  1280,  1344,  1408,  1472,  1536,  1600,  1664],
-            1   [  608,   640,   672,   704,   736,   768,   800,   832],
-            2   [  304,   320,   336,   352,   368,   384,   400,   416],
-            3   [  152,   160,   168,   176,   184,   192,   200,   208],
-            4   [   76,    80,    84,    88,    92,    96,   100,   104],
-            5   [   38,    40,    42,    44,    46,    48,    50,    52],
-            6   [   19,    20,    21,    22,    23,    24,    25,    26],
-            7   [  N/A,    10,   N/A,    11,   N/A,    12,   N/A,    13],
-            8   [  N/A,     5,   N/A,   N/A,   N/A,     6,   N/A,   N/A]]
-
-      For other values of GROUP_NR and coarseness, this table can be computed like this:    
-        
-            bins = [1216,1280,1344,1408,1472,1536,1600,1664]
-            max_coarse = 8
-            fncn = lambda z: list(map(lambda x: z/2**x if z % 2**x == 0 else nan, range(max_coarse + 1)))
-            np.transpose(list(map(fncn, bins)))
-      
-      Also note that you can achieve the same downsampling / log file size reduction
-      by pre-processing (before inputting into this script) with half_bins.py.
-
-    * If you have not adjusted GROUP_NR for your (high latency) application, then you
-      will see the percentiles computed by this tool max out at the max latency bin
-      value as in the first table above, and in this plot (where GROUP_NR=19 and thus we see
-      a max latency of ~16.7 seconds in the red line):
-
-            https://www.cronburg.com/fio/max_latency_bin_value_bug.png
-    
-    * Motivation for, design decisions, and the implementation process are
-      described in further detail here:
-
-            https://www.cronburg.com/fio/cloud-latency-problem-measurement/
-
     @author Karl Cronburg <karl.cronburg@gmail.com>
 """
 import os
@@ -216,7 +111,7 @@ def histogram_generator(ctx, fps, sz):
             rdrs[fp] = pandas.read_csv(fp, dtype=int, header=None, chunksize=sz)
         except ValueError as e:
             if e.message == 'No columns to parse from file':
-                if not ctx.nowarn: sys.stderr.write("WARNING: Empty input file encountered.\n")
+                if ctx.warn: sys.stderr.write("WARNING: Empty input file encountered.\n")
                 rdrs[fp] = None
             else:
                 raise(e)
@@ -441,11 +336,11 @@ if __name__ == '__main__':
         type=int,
         help='number of decimal places to print floats to')
 
-    arg('--nowarn',
-        dest='nowarn',
-        action='store_false',
-        default=True,
-        help='do not print any warning messages to stderr')
+    arg('--warn',
+        dest='warn',
+        action='store_true',
+        default=False,
+        help='print warning messages to stderr')
 
     arg('--group_nr',
         default=19,
diff --git a/tools/hist/fiologparser_hist.py.1 b/tools/hist/fiologparser_hist.py.1
new file mode 100644
index 0000000..ed22c74
--- /dev/null
+++ b/tools/hist/fiologparser_hist.py.1
@@ -0,0 +1,201 @@
+.TH fiologparser_hist.py 1 "August 18, 2016"
+.SH NAME
+fiologparser_hist.py \- Calculate statistics from fio histograms
+.SH SYNOPSIS
+.B fiologparser_hist.py
+[\fIoptions\fR] [clat_hist_files]...
+.SH DESCRIPTION
+.B fiologparser_hist.py
+is a utility for converting *_clat_hist* files
+generated by fio into a CSV of latency statistics including minimum,
+average, maximum latency, and 50th, 95th, and 99th percentiles.
+.SH EXAMPLES
+.PP
+.nf
+$ fiologparser_hist.py *_clat_hist*
+end-time, samples, min, avg, median, 90%, 95%, 99%, max
+1000, 15, 192, 1678.107, 1788.859, 1856.076, 1880.040, 1899.208, 1888.000
+2000, 43, 152, 1642.368, 1714.099, 1816.659, 1845.552, 1888.131, 1888.000
+4000, 39, 1152, 1546.962, 1545.785, 1627.192, 1640.019, 1691.204, 1744
+...
+.fi
+.PP
+
+.SH OPTIONS
+.TP
+.BR \-\-help
+Print these options.
+.TP
+.BR \-\-buff_size \fR=\fPint
+Number of samples to buffer into numpy at a time. Default is 10,000.
+This can be adjusted to help performance.
+.TP
+.BR \-\-max_latency \fR=\fPint
+Number of seconds of data to process at a time. Defaults to 20 seconds,
+in order to handle the 17 second upper bound on latency in histograms
+reported by fio. This should be increased if fio has been
+run with a larger maximum latency. Lowering this when a lower maximum
+latency is known can improve performance. See NOTES for more details.
+.TP
+.BR \-i ", " \-\-interval \fR=\fPint
+Interval at which statistics are reported. Defaults to 1000 ms. This
+should be set a minimum of the value for \fBlog_hist_msec\fR as given
+to fio.
+.TP
+.BR \-d ", " \-\-divisor \fR=\fPint
+Divide statistics by this value. Defaults to 1. Useful if you want to
+convert latencies from milliseconds to seconds (\fBdivisor\fR=\fP1000\fR).
+.TP
+.BR \-\-warn
+Enables warning messages printed to stderr, useful for debugging.
+.TP
+.BR \-\-group_nr \fR=\fPint
+Set this to the value of \fIFIO_IO_U_PLAT_GROUP_NR\fR as defined in
+\fPstat.h\fR if fio has been recompiled. Defaults to 19, the
+current value used in fio. See NOTES for more details.
+
+.SH NOTES
+end-times are calculated to be uniform increments of the \fB\-\-interval\fR value given,
+regardless of when histogram samples are reported. Of note:
+
+.RS
+Intervals with no samples are omitted. In the example above this means
+"no statistics from 2 to 3 seconds" and "39 samples influenced the statistics
+of the interval from 3 to 4 seconds".
+.LP
+Intervals with a single sample will have the same value for all statistics
+.RE
+
+.PP
+The number of samples is unweighted, corresponding to the total number of samples
+which have any effect whatsoever on the interval.
+
+Min statistics are computed using value of the lower boundary of the first bin
+(in increasing bin order) with non-zero samples in it. Similarly for max,
+we take the upper boundary of the last bin with non-zero samples in it.
+This is semantically identical to taking the 0th and 100th percentiles with a
+50% bin-width buffer (because percentiles are computed using mid-points of
+the bins). This enforces the following nice properties:
+
+.RS
+min <= 50th <= 90th <= 95th <= 99th <= max
+.LP
+min and max are strict lower and upper bounds on the actual
+min / max seen by fio (and reported in *_clat.* with averaging turned off).
+.RE
+
+.PP
+Average statistics use a standard weighted arithmetic mean.
+
+Percentile statistics are computed using the weighted percentile method as
+described here: \fIhttps://en.wikipedia.org/wiki/Percentile#Weighted_percentile\fR.
+See weights() method for details on how weights are computed for individual
+samples. In process_interval() we further multiply by the height of each bin
+to get weighted histograms.
+
+We convert files given on the command line, assumed to be fio histogram files,
+An individual histogram file can contain the
+histograms for multiple different r/w directions (notably when \fB\-\-rw\fR=\fPrandrw\fR). This
+is accounted for by tracking each r/w direction separately. In the statistics
+reported we ultimately merge *all* histograms (regardless of r/w direction).
+
+The value of *_GROUP_NR in \fIstat.h\fR (and *_BITS) determines how many latency bins
+fio outputs when histogramming is enabled. Namely for the current default of
+GROUP_NR=19, we get 1,216 bins with a maximum latency of approximately 17
+seconds. For certain applications this may not be sufficient. With GROUP_NR=24
+we have 1,536 bins, giving us a maximum latency of 541 seconds (~ 9 minutes). If
+you expect your application to experience latencies greater than 17 seconds,
+you will need to recompile fio with a larger GROUP_NR, e.g. with:
+
+.RS
+.PP
+.nf
+sed -i.bak 's/^#define FIO_IO_U_PLAT_GROUP_NR 19\n/#define FIO_IO_U_PLAT_GROUP_NR 24/g' stat.h
+make fio
+.fi
+.PP
+.RE
+
+.PP
+Quick reference table for the max latency corresponding to a sampling of
+values for GROUP_NR:
+
+.RS
+.PP
+.nf
+GROUP_NR | # bins | max latency bin value
+19       | 1216   | 16.9 sec
+20       | 1280   | 33.8 sec
+21       | 1344   | 67.6 sec
+22       | 1408   | 2  min, 15 sec
+23       | 1472   | 4  min, 32 sec
+24       | 1536   | 9  min, 4  sec
+25       | 1600   | 18 min, 8  sec
+26       | 1664   | 36 min, 16 sec
+.fi
+.PP
+.RE
+
+.PP
+At present this program automatically detects the number of histogram bins in
+the log files, and adjusts the bin latency values accordingly. In particular if
+you use the \fB\-\-log_hist_coarseness\fR parameter of fio, you get output files with
+a number of bins according to the following table (note that the first
+row is identical to the table above):
+
+.RS
+.PP
+.nf
+coarse \\ GROUP_NR
+        19     20    21     22     23     24     25     26
+   -------------------------------------------------------
+  0  [[ 1216,  1280,  1344,  1408,  1472,  1536,  1600,  1664],
+  1   [  608,   640,   672,   704,   736,   768,   800,   832],
+  2   [  304,   320,   336,   352,   368,   384,   400,   416],
+  3   [  152,   160,   168,   176,   184,   192,   200,   208],
+  4   [   76,    80,    84,    88,    92,    96,   100,   104],
+  5   [   38,    40,    42,    44,    46,    48,    50,    52],
+  6   [   19,    20,    21,    22,    23,    24,    25,    26],
+  7   [  N/A,    10,   N/A,    11,   N/A,    12,   N/A,    13],
+  8   [  N/A,     5,   N/A,   N/A,   N/A,     6,   N/A,   N/A]]
+.fi
+.PP
+.RE
+
+.PP
+For other values of GROUP_NR and coarseness, this table can be computed like this:
+
+.RS
+.PP
+.nf
+bins = [1216,1280,1344,1408,1472,1536,1600,1664]
+max_coarse = 8
+fncn = lambda z: list(map(lambda x: z/2**x if z % 2**x == 0 else nan, range(max_coarse + 1)))
+np.transpose(list(map(fncn, bins)))
+.fi
+.PP
+.RE
+
+.PP
+If you have not adjusted GROUP_NR for your (high latency) application, then you
+will see the percentiles computed by this tool max out at the max latency bin
+value as in the first table above, and in this plot (where GROUP_NR=19 and thus we see
+a max latency of ~16.7 seconds in the red line):
+
+.RS
+\fIhttps://www.cronburg.com/fio/max_latency_bin_value_bug.png
+.RE
+
+.PP
+Motivation for, design decisions, and the implementation process are
+described in further detail here:
+
+.RS
+\fIhttps://www.cronburg.com/fio/cloud-latency-problem-measurement/
+.RE
+
+.SH AUTHOR
+.B fiologparser_hist.py
+and this manual page were written by Karl Cronburg <karl.cronburg@gmail.com>.
+.SH "REPORTING BUGS"
+Report bugs to the \fBfio\fR mailing list <fio@vger.kernel.org>.
