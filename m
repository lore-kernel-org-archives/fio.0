Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60473 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbcCINAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 9 Mar 2016 08:00:07 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1addie-0001p7-Li
	for fio@vger.kernel.org; Wed, 09 Mar 2016 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160309130002.07D532C0105@kernel.dk>
Date: Wed,  9 Mar 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit de4096e8682a064ed9125af7ac30a3fe4021167b:

  rand: use bools (2016-03-07 15:38:44 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 4f126cad8fc5ed71c7ac8155726e38395c689905:

  .gitignore: ignore vim undo files (2016-03-08 11:19:17 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      Update documentation on log file formats
      Add t/gen-rand to test random generator
      .gitignore: ignore vim undo files

 .gitignore   |  1 +
 HOWTO        | 43 ++++++++++++++++++++++++++++++++++----
 Makefile     |  9 ++++++++
 fio.1        | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 t/gen-rand.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 174 insertions(+), 7 deletions(-)
 create mode 100644 t/gen-rand.c

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index c9d90fb..bd9b032 100644
--- a/.gitignore
+++ b/.gitignore
@@ -9,3 +9,4 @@
 /fio
 y.tab.*
 lex.yy.c
+*.un~
diff --git a/HOWTO b/HOWTO
index e2a4b15..0d3d2fb 100644
--- a/HOWTO
+++ b/HOWTO
@@ -11,6 +11,8 @@ Table of contents
 8. Trace file format
 9. CPU idleness profiling
 10. Verification and triggers
+11. Log File Formats
+
 
 1.0 Overview and history
 ------------------------
@@ -1564,7 +1566,7 @@ write_bw_log=str If given, write a bandwidth log of the jobs in this job
 		filename. For this option, the suffix is _bw.x.log, where
 		x is the index of the job (1..N, where N is the number of
 		jobs). If 'per_job_logs' is false, then the filename will not
-		include the job index.
+		include the job index. See 'Log File Formats'.
 
 write_lat_log=str Same as write_bw_log, except that this option stores io
 		submission, completion, and total latencies instead. If no
@@ -1578,8 +1580,8 @@ write_lat_log=str Same as write_bw_log, except that this option stores io
 		and foo_lat.x.log, where x is the index of the job (1..N,
 		where N is the number of jobs). This helps fio_generate_plot
 		fine the logs automatically. If 'per_job_logs' is false, then
-		the filename will not include the job index.
-
+		the filename will not include the job index. See 'Log File
+		Formats'.
 
 write_iops_log=str Same as write_bw_log, but writes IOPS. If no filename is
 		given with this option, the default filename of
@@ -1587,7 +1589,7 @@ write_iops_log=str Same as write_bw_log, but writes IOPS. If no filename is
 		(1..N, where N is the number of jobs). Even if the filename
 		is given, fio will still append the type of log. If
 		'per_job_logs' is false, then the filename will not include
-		the job index.
+		the job index. See 'Log File Formats'.
 
 log_avg_msec=int By default, fio will log an entry in the iops, latency,
 		or bw log for every IO that completes. When writing to the
@@ -2253,3 +2255,36 @@ the verify_state_load option. If that is set, fio will load the previously
 stored state. For a local fio run this is done by loading the files directly,
 and on a client/server run, the server backend will ask the client to send
 the files over and load them from there.
+
+
+11.0 Log File Formats
+---------------------
+
+Fio supports a variety of log file formats, for logging latencies, bandwidth,
+and IOPS. The logs share a common format, which looks like this:
+
+time (msec), value, data direction, offset
+
+Time for the log entry is always in milliseconds. The value logged depends
+on the type of log, it will be one of the following:
+
+	Latency log		Value is latency in usecs
+	Bandwidth log		Value is in KB/sec
+	IOPS log		Value is IOPS
+
+Data direction is one of the following:
+
+	0			IO is a READ
+	1			IO is a WRITE
+	2			IO is a TRIM
+
+The offset is the offset, in bytes, from the start of the file, for that
+particular IO. The logging of the offset can be toggled with 'log_offset'.
+
+If windowed logging is enabled though 'log_avg_msec', then fio doesn't log
+individual IOs. Instead of logs the average values over the specified
+period of time. Since 'data direction' and 'offset' are per-IO values,
+they aren't applicable if windowed logging is enabled. If windowed logging
+is enabled and 'log_max_value' is set, then fio logs maximum values in
+that window instead of averages.
+
diff --git a/Makefile b/Makefile
index 684b565..6b4c9db 100644
--- a/Makefile
+++ b/Makefile
@@ -211,6 +211,10 @@ T_LFSR_TEST_OBJS = t/lfsr-test.o
 T_LFSR_TEST_OBJS += lib/lfsr.o gettime.o t/log.o t/debug.o
 T_LFSR_TEST_PROGS = t/lfsr-test
 
+T_GEN_RAND_OBJS = t/gen-rand.o
+T_GEN_RAND_OBJS += t/log.o t/debug.o lib/rand.o lib/pattern.o lib/strntol.o
+T_GEN_RAND_PROGS = t/gen-rand
+
 ifeq ($(CONFIG_TARGET_OS), Linux)
 T_BTRACE_FIO_OBJS = t/btrace2fio.o
 T_BTRACE_FIO_OBJS += fifo.o lib/flist_sort.o t/log.o oslib/linux-dev-lookup.o
@@ -231,6 +235,7 @@ T_OBJS += $(T_IEEE_OBJS)
 T_OBJS += $(T_ZIPF_OBJS)
 T_OBJS += $(T_AXMAP_OBJS)
 T_OBJS += $(T_LFSR_TEST_OBJS)
+T_OBJS += $(T_GEN_RAND_OBJS)
 T_OBJS += $(T_BTRACE_FIO_OBJS)
 T_OBJS += $(T_DEDUPE_OBJS)
 T_OBJS += $(T_VS_OBJS)
@@ -246,6 +251,7 @@ T_TEST_PROGS += $(T_IEEE_PROGS)
 T_PROGS += $(T_ZIPF_PROGS)
 T_TEST_PROGS += $(T_AXMAP_PROGS)
 T_TEST_PROGS += $(T_LFSR_TEST_PROGS)
+T_TEST_PROGS += $(T_GEN_RAND_PROGS)
 T_PROGS += $(T_BTRACE_FIO_PROGS)
 T_PROGS += $(T_DEDUPE_PROGS)
 T_PROGS += $(T_VS_PROGS)
@@ -386,6 +392,9 @@ t/axmap: $(T_AXMAP_OBJS)
 t/lfsr-test: $(T_LFSR_TEST_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_LFSR_TEST_OBJS) $(LIBS)
 
+t/gen-rand: $(T_GEN_RAND_OBJS)
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_GEN_RAND_OBJS) $(LIBS)
+
 ifeq ($(CONFIG_TARGET_OS), Linux)
 t/fio-btrace2fio: $(T_BTRACE_FIO_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_BTRACE_FIO_OBJS) $(LIBS)
diff --git a/fio.1 b/fio.1
index 87404c1..df140cf 100644
--- a/fio.1
+++ b/fio.1
@@ -1441,7 +1441,8 @@ fio_generate_plots script uses gnuplot to turn these text files into nice
 graphs. See \fBwrite_lat_log\fR for behaviour of given filename. For this
 option, the postfix is _bw.x.log, where x is the index of the job (1..N,
 where N is the number of jobs). If \fBper_job_logs\fR is false, then the
-filename will not include the job index.
+filename will not include the job index. See the \fBLOG FILE FORMATS\fR
+section.
 .TP
 .BI write_lat_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes I/O completion latencies.  If no
@@ -1449,14 +1450,15 @@ filename is given with this option, the default filename of
 "jobname_type.x.log" is used, where x is the index of the job (1..N, where
 N is the number of jobs). Even if the filename is given, fio will still
 append the type of log. If \fBper_job_logs\fR is false, then the filename will
-not include the job index.
+not include the job index. See the \fBLOG FILE FORMATS\fR section.
 .TP
 .BI write_iops_log \fR=\fPstr
 Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with this
 option, the default filename of "jobname_type.x.log" is used, where x is the
 index of the job (1..N, where N is the number of jobs). Even if the filename
 is given, fio will still append the type of log. If \fBper_job_logs\fR is false,
-then the filename will not include the job index.
+then the filename will not include the job index. See the \fBLOG FILE FORMATS\fR
+section.
 .TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
@@ -2219,6 +2221,58 @@ the files over and load them from there.
 
 .RE
 
+.SH LOG FILE FORMATS
+
+Fio supports a variety of log file formats, for logging latencies, bandwidth,
+and IOPS. The logs share a common format, which looks like this:
+
+.B time (msec), value, data direction, offset
+
+Time for the log entry is always in milliseconds. The value logged depends
+on the type of log, it will be one of the following:
+
+.P
+.PD 0
+.TP
+.B Latency log
+Value is in latency in usecs
+.TP
+.B Bandwidth log
+Value is in KB/sec
+.TP
+.B IOPS log
+Value is in IOPS
+.PD
+.P
+
+Data direction is one of the following:
+
+.P
+.PD 0
+.TP
+.B 0
+IO is a READ
+.TP
+.B 1
+IO is a WRITE
+.TP
+.B 2
+IO is a TRIM
+.PD
+.P
+
+The \fIoffset\fR is the offset, in bytes, from the start of the file, for that
+particular IO. The logging of the offset can be toggled with \fBlog_offset\fR.
+
+If windowed logging is enabled though \fBlog_avg_msec\fR, then fio doesn't log
+individual IOs. Instead of logs the average values over the specified
+period of time. Since \fIdata direction\fR and \fIoffset\fR are per-IO values,
+they aren't applicable if windowed logging is enabled. If windowed logging
+is enabled and \fBlog_max_value\fR is set, then fio logs maximum values in
+that window instead of averages.
+
+.RE
+
 .SH CLIENT / SERVER
 Normally you would run fio as a stand-alone application on the machine
 where the IO workload should be generated. However, it is also possible to
diff --git a/t/gen-rand.c b/t/gen-rand.c
new file mode 100644
index 0000000..c2a31bc
--- /dev/null
+++ b/t/gen-rand.c
@@ -0,0 +1,68 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <inttypes.h>
+#include <assert.h>
+#include <math.h>
+#include <string.h>
+
+#include "../lib/types.h"
+#include "../log.h"
+#include "../lib/lfsr.h"
+#include "../lib/axmap.h"
+#include "../smalloc.h"
+#include "../minmax.h"
+#include "../lib/rand.h"
+
+int main(int argc, char *argv[])
+{
+	struct frand_state s;
+	uint64_t i, start, end, nvalues;
+	unsigned long *buckets, index, pass, fail;
+	double p, dev, mean, vmin, vmax;
+
+	if (argc < 4) {
+		log_err("%s: start end nvalues\n", argv[0]);
+		return 1;
+	}
+
+	start = strtoul(argv[1], NULL, 10);
+	end = strtoul(argv[2], NULL, 10);
+
+	if (start >= end) {
+		log_err("%s: start must be smaller than end\n", argv[0]);
+		return 1;
+	}
+	index = 1 + end - start;
+	buckets = calloc(index, sizeof(unsigned long));
+
+	nvalues = strtoul(argv[3], NULL, 10);
+
+	init_rand(&s, true);
+
+	for (i = 0; i < nvalues; i++) {
+		int v = rand_between(&s, start, end);
+
+		buckets[v - start]++;
+	}
+
+	p = 1.0 / index;
+	dev = sqrt(nvalues * p * (1.0 - p));
+	mean = nvalues * p;
+	vmin = mean - dev;
+	vmax = mean + dev;
+
+	pass = fail = 0;
+	for (i = 0; i < index; i++) {
+		if (buckets[i] < vmin || buckets[i] > vmax) {
+			printf("FAIL bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", i + 1, buckets[i], vmin, mean, vmax);
+			fail++;
+		} else {
+			printf("PASS bucket%4lu: val=%8lu (%.1f < %.1f > %.1f)\n", i + 1, buckets[i], vmin, mean, vmax);
+			pass++;
+		}
+	}
+
+	printf("Passes=%lu, Fail=%lu\n", pass, fail);
+
+	return 0;
+}
