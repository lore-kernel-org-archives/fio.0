Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52677 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752047AbdHHMAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Aug 2017 08:00:16 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1df3BI-0005oG-95
        for fio@vger.kernel.org; Tue, 08 Aug 2017 12:00:16 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170808120002.74DA22C0167@kernel.dk>
Date: Tue,  8 Aug 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2b455dbf8038ee5998f9280fac40f8089175adf7:

  HOWTO: minor fix and backport from man page (2017-08-01 13:55:09 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d4a507c17533f05bcf6d6eeb8d00f3dad1a020a1:

  Merge branch 'fio-jsonplus-patches' of https://github.com/vincentkfu/fio (2017-08-07 13:44:01 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'fio-jsonplus-patches' of https://github.com/vincentkfu/fio

Tomohiro Kusumi (4):
      man: add proper indentation to "PARAMETER TYPES" section
      HOWTO: fix unit type suffix in "Parameter types" section
      HOWTO: use proper (or drop wrong usage of) option type =bool
      move skip_bad= option to engines/mtd.c

Vincent Fu (3):
      tools: add fio_jsonplus_clat2csv
      HOWTO: add section providing details about json+ output format
      man: add section describing json+ output format

 HOWTO                       |  47 +++++++++----
 Makefile                    |   2 +-
 cconv.c                     |   2 -
 engines/mtd.c               |  28 +++++++-
 fio.1                       | 139 +++++++++++++++++++++++++++----------
 options.c                   |  11 ---
 thread_options.h            |   2 -
 tools/fio_jsonplus_clat2csv | 164 ++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 329 insertions(+), 66 deletions(-)
 create mode 100755 tools/fio_jsonplus_clat2csv

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index ee2b996..6c69a0e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -505,19 +505,19 @@ Parameter types
 	prefixes.  To specify power-of-10 decimal values defined in the
 	International System of Units (SI):
 
-		* *Ki* -- means kilo (K) or 1000
-		* *Mi* -- means mega (M) or 1000**2
-		* *Gi* -- means giga (G) or 1000**3
-		* *Ti* -- means tera (T) or 1000**4
-		* *Pi* -- means peta (P) or 1000**5
+		* *ki* -- means kilo (K) or 1000
+		* *mi* -- means mega (M) or 1000**2
+		* *gi* -- means giga (G) or 1000**3
+		* *ti* -- means tera (T) or 1000**4
+		* *pi* -- means peta (P) or 1000**5
 
 	To specify power-of-2 binary values defined in IEC 80000-13:
 
 		* *k* -- means kibi (Ki) or 1024
-		* *M* -- means mebi (Mi) or 1024**2
-		* *G* -- means gibi (Gi) or 1024**3
-		* *T* -- means tebi (Ti) or 1024**4
-		* *P* -- means pebi (Pi) or 1024**5
+		* *m* -- means mebi (Mi) or 1024**2
+		* *g* -- means gibi (Gi) or 1024**3
+		* *t* -- means tebi (Ti) or 1024**4
+		* *p* -- means pebi (Pi) or 1024**5
 
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
@@ -1392,7 +1392,7 @@ Block size
 	typically won't work with direct I/O, as that normally requires sector
 	alignment.
 
-.. option:: bs_is_seq_rand
+.. option:: bs_is_seq_rand=bool
 
 	If this option is set, fio will use the normal read,write blocksize settings
 	as sequential,random blocksize settings instead. Any random read or write
@@ -2166,7 +2166,7 @@ I/O replay
 	replay, the file needs to be turned into a blkparse binary data file first
 	(``blkparse <device> -o /dev/null -d file_for_fio.bin``).
 
-.. option:: replay_no_stall=int
+.. option:: replay_no_stall=bool
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
 	attempt to respect the timestamps within the log and replay them with the
@@ -2680,7 +2680,7 @@ Measurements and reporting
 	all jobs in a file will be part of the same reporting group, unless
 	separated by a :option:`stonewall`.
 
-.. option:: stats
+.. option:: stats=bool
 
 	By default, fio collects and shows final output results for all jobs
 	that run. If this option is set to 0, then fio will ignore it in
@@ -2763,7 +2763,7 @@ Measurements and reporting
 	you instead want to log the maximum value, set this option to 1. Defaults to
 	0, meaning that averaged values are logged.
 
-.. option:: log_offset=int
+.. option:: log_offset=bool
 
 	If this is set, the iolog options will include the byte offset for the I/O
 	entry as well as the other data values. Defaults to 0 meaning that
@@ -3363,6 +3363,27 @@ minimal output v3, separated by semicolons::
 	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10
 ;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
+JSON+ output
+------------
+
+The `json+` output format is identical to the `json` output format except that it
+adds a full dump of the completion latency bins. Each `bins` object contains a
+set of (key, value) pairs where keys are latency durations and values count how
+many I/Os had completion latencies of the corresponding duration. For example,
+consider:
+
+	"bins" : { "87552" : 1, "89600" : 1, "94720" : 1, "96768" : 1, "97792" : 1, "99840" : 1, "100864" : 2, "103936" : 6, "104960" : 534, "105984" : 5995, "107008" : 7529, ... }
+
+This data indicates that one I/O required 87,552ns to complete, two I/Os required
+100,864ns to complete, and 7529 I/Os required 107,008ns to complete.
+
+Also included with fio is a Python script `fio_jsonplus_clat2csv` that takes
+json+ output and generates CSV-formatted latency data suitable for plotting.
+
+The latency durations actually represent the midpoints of latency intervals.
+For details refer to stat.h.
+
+
 Trace file format
 -----------------
 
diff --git a/Makefile b/Makefile
index e8ea6cb..540ffb2 100644
--- a/Makefile
+++ b/Makefile
@@ -26,7 +26,7 @@ OPTFLAGS= -g -ffast-math
 CFLAGS	= -std=gnu99 -Wwrite-strings -Wall -Wdeclaration-after-statement $(OPTFLAGS) $(EXTFLAGS) $(BUILD_CFLAGS) -I. -I$(SRCDIR)
 LIBS	+= -lm $(EXTLIBS)
 PROGS	= fio
-SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py)
+SCRIPTS = $(addprefix $(SRCDIR)/,tools/fio_generate_plots tools/plot/fio2gnuplot tools/genfio tools/fiologparser.py tools/hist/fiologparser_hist.py tools/fio_jsonplus_clat2csv)
 
 ifndef CONFIG_FIO_NO_OPT
   CFLAGS += -O3 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
diff --git a/cconv.c b/cconv.c
index b8d9ddc..f9f2b30 100644
--- a/cconv.c
+++ b/cconv.c
@@ -283,7 +283,6 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->compress_percentage = le32_to_cpu(top->compress_percentage);
 	o->compress_chunk = le32_to_cpu(top->compress_chunk);
 	o->dedupe_percentage = le32_to_cpu(top->dedupe_percentage);
-	o->skip_bad = le32_to_cpu(top->skip_bad);
 	o->block_error_hist = le32_to_cpu(top->block_error_hist);
 	o->replay_align = le32_to_cpu(top->replay_align);
 	o->replay_scale = le32_to_cpu(top->replay_scale);
@@ -471,7 +470,6 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->compress_chunk = cpu_to_le32(o->compress_chunk);
 	top->dedupe_percentage = cpu_to_le32(o->dedupe_percentage);
 	top->block_error_hist = cpu_to_le32(o->block_error_hist);
-	top->skip_bad = cpu_to_le32(o->skip_bad);
 	top->replay_align = cpu_to_le32(o->replay_align);
 	top->replay_scale = cpu_to_le32(o->replay_scale);
 	top->per_job_logs = cpu_to_le32(o->per_job_logs);
diff --git a/engines/mtd.c b/engines/mtd.c
index 3c22a1b..b4a6600 100644
--- a/engines/mtd.c
+++ b/engines/mtd.c
@@ -13,6 +13,7 @@
 #include <mtd/mtd-user.h>
 
 #include "../fio.h"
+#include "../optgroup.h"
 #include "../verify.h"
 #include "../oslib/libmtd.h"
 
@@ -22,6 +23,28 @@ struct fio_mtd_data {
 	struct mtd_dev_info info;
 };
 
+struct fio_mtd_options {
+	void *pad; /* avoid off1 == 0 */
+	unsigned int skip_bad;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	= "skip_bad",
+		.lname	= "Skip operations against bad blocks",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct fio_mtd_options, skip_bad),
+		.help	= "Skip operations against known bad blocks.",
+		.hide	= 1,
+		.def	= "0",
+		.category = FIO_OPT_C_ENGINE,
+		.group	= FIO_OPT_G_MTD,
+	},
+	{
+		.name	= NULL,
+	},
+};
+
 static int fio_mtd_maybe_mark_bad(struct thread_data *td,
 				  struct fio_mtd_data *fmd,
 				  struct io_u *io_u, int eb)
@@ -55,6 +78,7 @@ static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
 	struct fio_mtd_data *fmd = FILE_ENG_DATA(f);
+	struct fio_mtd_options *o = td->eo;
 	int local_offs = 0;
 	int ret;
 
@@ -77,7 +101,7 @@ static int fio_mtd_queue(struct thread_data *td, struct io_u *io_u)
 			      (int)fmd->info.eb_size - eb_offs);
 		char *buf = ((char *)io_u->buf) + local_offs;
 
-		if (td->o.skip_bad) {
+		if (o->skip_bad) {
 			ret = fio_mtd_is_bad(td, fmd, io_u, eb);
 			if (ret == -1)
 				break;
@@ -190,6 +214,8 @@ static struct ioengine_ops ioengine = {
 	.close_file	= fio_mtd_close_file,
 	.get_file_size	= fio_mtd_get_file_size,
 	.flags		= FIO_SYNCIO | FIO_NOEXTEND,
+	.options	= options,
+	.option_struct_size	= sizeof(struct fio_mtd_options),
 };
 
 static void fio_init fio_mtd_register(void)
diff --git a/fio.1 b/fio.1
index a5ec199..ab978ab 100644
--- a/fio.1
+++ b/fio.1
@@ -223,84 +223,130 @@ hours, 'm' for minutes, 's' for seconds, 'ms' (or 'msec') for milliseconds and '
 .I int
 Integer. A whole number value, which may contain an integer prefix
 and an integer suffix.
-
+.RS
+.RS
+.P
 [*integer prefix*] **number** [*integer suffix*]
-
+.RE
+.P
 The optional *integer prefix* specifies the number's base. The default
 is decimal. *0x* specifies hexadecimal.
-
+.P
 The optional *integer suffix* specifies the number's units, and includes an
 optional unit prefix and an optional unit. For quantities of data, the
 default unit is bytes. For quantities of time, the default unit is seconds
 unless otherwise specified.
-
-With \fBkb_base=1000\fR, fio follows international standards for unit
+.P
+With `kb_base=1000', fio follows international standards for unit
 prefixes. To specify power-of-10 decimal values defined in the
 International System of Units (SI):
-
-.nf
+.RS
+.P
 ki means kilo (K) or 1000
+.RE
+.RS
 mi means mega (M) or 1000**2
+.RE
+.RS
 gi means giga (G) or 1000**3
+.RE
+.RS
 ti means tera (T) or 1000**4
+.RE
+.RS
 pi means peta (P) or 1000**5
-.fi
-
+.RE
+.P
 To specify power-of-2 binary values defined in IEC 80000-13:
-
-.nf
+.RS
+.P
 k means kibi (Ki) or 1024
+.RE
+.RS
 m means mebi (Mi) or 1024**2
+.RE
+.RS
 g means gibi (Gi) or 1024**3
+.RE
+.RS
 t means tebi (Ti) or 1024**4
+.RE
+.RS
 p means pebi (Pi) or 1024**5
-.fi
-
-With \fBkb_base=1024\fR (the default), the unit prefixes are opposite
+.RE
+.P
+With `kb_base=1024' (the default), the unit prefixes are opposite
 from those specified in the SI and IEC 80000-13 standards to provide
 compatibility with old scripts. For example, 4k means 4096.
-
+.P
 For quantities of data, an optional unit of 'B' may be included
 (e.g., 'kB' is the same as 'k').
-
+.P
 The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
 not milli). 'b' and 'B' both mean byte, not bit.
-
-Examples with \fBkb_base=1000\fR:
-
-.nf
+.P
+Examples with `kb_base=1000':
+.RS
+.P
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+.RE
+.RS
 1 MiB: 1048576, 1m, 1024k
+.RE
+.RS
 1 MB: 1000000, 1mi, 1000ki
+.RE
+.RS
 1 TiB: 1073741824, 1t, 1024m, 1048576k
+.RE
+.RS
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
-.fi
-
-Examples with \fBkb_base=1024\fR (default):
-
-.nf
+.RE
+.P
+Examples with `kb_base=1024' (default):
+.RS
+.P
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+.RE
+.RS
 1 MiB: 1048576, 1m, 1024k
+.RE
+.RS
 1 MB: 1000000, 1mi, 1000ki
+.RE
+.RS
 1 TiB: 1073741824, 1t, 1024m, 1048576k
+.RE
+.RS
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
-.fi
-
+.RE
+.P
 To specify times (units are not case sensitive):
-
-.nf
+.RS
+.P
 D means days
+.RE
+.RS
 H means hours
+.RE
+.RS
 M mean minutes
+.RE
+.RS
 s or sec means seconds (default)
+.RE
+.RS
 ms or msec means milliseconds
+.RE
+.RS
 us or usec means microseconds
-.fi
-
+.RE
+.P
 If the option accepts an upper and lower range, use a colon ':' or
 minus '-' to separate such values. See `irange` parameter type.
 If the lower value specified happens to be larger than the upper value
 the two values are swapped.
+.RE
 .TP
 .I bool
 Boolean. Usually parsed as an integer, however only defined for
@@ -1464,7 +1510,7 @@ Should be a multiple of 1MiB. Default: 4MiB.
 .B exitall
 Terminate all jobs when one finishes.  Default: wait for each job to finish.
 .TP
-.B exitall_on_error \fR=\fPbool
+.B exitall_on_error
 Terminate all jobs if one job finishes in error.  Default: wait for each job
 to finish.
 .TP
@@ -1520,7 +1566,7 @@ Unlink job files after each iteration or loop.  Default: false.
 Specifies the number of iterations (runs of the same workload) of this job.
 Default: 1.
 .TP
-.BI verify_only \fR=\fPbool
+.BI verify_only
 Do not perform the specified workload, only verify data still matches previous
 invocation of this workload. This option allows one to check data multiple
 times at a later date without overwriting it. This option makes sense only for
@@ -1710,7 +1756,7 @@ corrupt.
 Replay the I/O patterns contained in the specified file generated by
 \fBwrite_iolog\fR, or may be a \fBblktrace\fR binary file.
 .TP
-.BI replay_no_stall \fR=\fPint
+.BI replay_no_stall \fR=\fPbool
 While replaying I/O patterns using \fBread_iolog\fR the default behavior
 attempts to respect timing information between I/Os.  Enabling
 \fBreplay_no_stall\fR causes I/Os to be replayed as fast as possible while
@@ -2074,7 +2120,7 @@ For TCP network connections, tell fio to listen for incoming
 connections rather than initiating an outgoing connection. The
 hostname must be omitted if this option is used.
 .TP
-.BI (net,netsplice)pingpong \fR=\fPbool
+.BI (net,netsplice)pingpong
 Normally a network writer will just continue writing data, and a network reader
 will just consume packets. If pingpong=1 is set, a writer will send its normal
 payload to the reader, then wait for the reader to send the same payload back.
@@ -2117,7 +2163,7 @@ Specifies the username (without the 'client.' prefix) used to access the Ceph
 cluster. If the clustername is specified, the clientname shall be the full
 type.id string. If no type. prefix is given, fio will add 'client.' by default.
 .TP
-.BI (mtd)skipbad \fR=\fPbool
+.BI (mtd)skip_bad \fR=\fPbool
 Skip operations against known bad blocks.
 .SH OUTPUT
 While running, \fBfio\fR will display the status of the created jobs.  For
@@ -2393,6 +2439,27 @@ the minimal output v3, separated by semicolons:
 terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 .fi
 .RE
+.SH JSON+ OUTPUT
+The \fBjson+\fR output format is identical to the \fBjson\fR output format except that it
+adds a full dump of the completion latency bins. Each \fBbins\fR object contains a
+set of (key, value) pairs where keys are latency durations and values count how
+many I/Os had completion latencies of the corresponding duration. For example,
+consider:
+
+.RS
+"bins" : { "87552" : 1, "89600" : 1, "94720" : 1, "96768" : 1, "97792" : 1, "99840" : 1, "100864" : 2, "103936" : 6, "104960" : 534, "105984" : 5995, "107008" : 7529, ... }
+.RE
+
+This data indicates that one I/O required 87,552ns to complete, two I/Os required
+100,864ns to complete, and 7529 I/Os required 107,008ns to complete.
+
+Also included with fio is a Python script \fBfio_jsonplus_clat2csv\fR that takes
+json+ output and generates CSV-formatted latency data suitable for plotting.
+
+The latency durations actually represent the midpoints of latency intervals.
+For details refer to stat.h.
+
+
 .SH TRACE FILE FORMAT
 There are two trace file format that you can encounter. The older (v1) format
 is unsupported since version 1.20-rc3 (March 2008). It will still be described
diff --git a/options.c b/options.c
index 5a2ab57..f2b2bb9 100644
--- a/options.c
+++ b/options.c
@@ -4379,17 +4379,6 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_IO_FLOW,
 	},
 	{
-		.name	= "skip_bad",
-		.lname	= "Skip operations against bad blocks",
-		.type	= FIO_OPT_BOOL,
-		.off1	= offsetof(struct thread_options, skip_bad),
-		.help	= "Skip operations against known bad blocks.",
-		.hide	= 1,
-		.def	= "0",
-		.category = FIO_OPT_C_IO,
-		.group	= FIO_OPT_G_MTD,
-	},
-	{
 		.name   = "steadystate",
 		.lname  = "Steady state threshold",
 		.alias  = "ss",
diff --git a/thread_options.h b/thread_options.h
index 72d86cf..f3dfd42 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -306,7 +306,6 @@ struct thread_options {
 	fio_fp64_t latency_percentile;
 
 	unsigned block_error_hist;
-	unsigned int skip_bad;
 
 	unsigned int replay_align;
 	unsigned int replay_scale;
@@ -579,7 +578,6 @@ struct thread_options_pack {
 	fio_fp64_t latency_percentile;
 
 	uint32_t block_error_hist;
-	uint32_t skip_bad;
 
 	uint32_t replay_align;
 	uint32_t replay_scale;
diff --git a/tools/fio_jsonplus_clat2csv b/tools/fio_jsonplus_clat2csv
new file mode 100755
index 0000000..d4ac16e
--- /dev/null
+++ b/tools/fio_jsonplus_clat2csv
@@ -0,0 +1,164 @@
+#!/usr/bin/python
+#
+# fio_jsonplus_clat2csv
+#
+# This script converts fio's json+ completion latency data to CSV format.
+#
+# For example:
+#
+# Run the following fio jobs:
+# ../fio --output=fio-jsonplus.output --output-format=json+ --name=test1
+#  	--ioengine=null --time_based --runtime=5s --size=1G --rw=randrw
+# 	--name=test2 --ioengine=null --time_based --runtime=3s --size=1G
+# 	--rw=read --name=test3 --ioengine=null --time_based --runtime=4s
+# 	--size=8G --rw=write
+#
+# Then run:
+# fio_jsonplus_clat2csv fio-jsonplus.output fio-latency.csv
+#
+# You will end up with the following 3 files
+#
+# -rw-r--r-- 1 root root  6467 Jun 27 14:57 fio-latency_job0.csv
+# -rw-r--r-- 1 root root  3985 Jun 27 14:57 fio-latency_job1.csv
+# -rw-r--r-- 1 root root  4490 Jun 27 14:57 fio-latency_job2.csv
+#
+# fio-latency_job0.csv will look something like:
+#
+# clat_nsec, read_count, read_cumulative, read_percentile, write_count,
+# 	write_cumulative, write_percentile, trim_count, trim_cumulative,
+# 	trim_percentile,
+# 25, 1, 1, 1.50870705013e-07, , , , , , ,
+# 26, 12, 13, 1.96131916517e-06, 947, 947, 0.000142955890032, , , ,
+# 27, 843677, 843690, 0.127288105112, 838347, 839294, 0.126696959629, , , ,
+# 28, 1877982, 2721672, 0.410620573454, 1870189, 2709483, 0.409014312345, , , ,
+# 29, 4471, 2726143, 0.411295116376, 7718, 2717201, 0.410179395301, , , ,
+# 30, 2142885, 4869028, 0.734593687087, 2138164, 4855365, 0.732949340025, , , ,
+# ...
+# 2544, , , , 2, 6624404, 0.999997433738, , , ,
+# 2576, 3, 6628178, 0.99999788781, 4, 6624408, 0.999998037564, , , ,
+# 2608, 4, 6628182, 0.999998491293, 4, 6624412, 0.999998641391, , , ,
+# 2640, 3, 6628185, 0.999998943905, 2, 6624414, 0.999998943304, , , ,
+# 2672, 1, 6628186, 0.999999094776, 3, 6624417, 0.999999396174, , , ,
+# 2736, 1, 6628187, 0.999999245646, 1, 6624418, 0.99999954713, , , ,
+# 2768, 2, 6628189, 0.999999547388, 1, 6624419, 0.999999698087, , , ,
+# 2800, , , , 1, 6624420, 0.999999849043, , , ,
+# 2832, 1, 6628190, 0.999999698259, , , , , , ,
+# 4192, 1, 6628191, 0.999999849129, , , , , , ,
+# 5792, , , , 1, 6624421, 1.0, , , ,
+# 10304, 1, 6628192, 1.0, , , , , , ,
+#
+# The first line says that you had one read IO with 25ns clat,
+# the cumulative number of read IOs at or below 25ns is 1, and
+# 25ns is the 0.00001509th percentile for read latency
+#
+# The job had 2 write IOs complete in 2544ns,
+# 6624404 write IOs completed in 2544ns or less,
+# and this represents the 99.99974th percentile for write latency
+#
+# The last line says that one read IO had 10304ns clat,
+# 6628192 read IOs had 10304ns or shorter clat, and
+# 10304ns is the 100th percentile for read latency
+#
+
+import os
+import json
+import argparse
+
+
+def parse_args():
+    parser = argparse.ArgumentParser()
+    parser.add_argument('source',
+                        help='fio json+ output file containing completion '
+                             'latency data')
+    parser.add_argument('dest',
+                        help='destination file stub for latency data in CSV '
+                             'format. job number will be appended to filename')
+    args = parser.parse_args()
+
+    return args
+
+
+def percentile(idx, run_total):
+    total = run_total[len(run_total)-1]
+    if total == 0:
+        return 0
+
+    return float(run_total[idx]) / total
+
+
+def more_lines(indices, bins):
+    for key, value in indices.iteritems():
+        if value < len(bins[key]):
+            return True
+
+    return False
+
+
+def main():
+    args = parse_args()
+
+    with open(args.source, 'r') as source:
+        jsondata = json.loads(source.read())
+
+    for jobnum in range(0, len(jsondata['jobs'])):
+        bins = {}
+        run_total = {}
+        ddir_set = set(['read', 'write', 'trim'])
+
+        prev_ddir = None
+        for ddir in ddir_set:
+            bins[ddir] = [[int(key), value] for key, value in
+                          jsondata['jobs'][jobnum][ddir]['clat_ns']
+                          ['bins'].iteritems()]
+            bins[ddir] = sorted(bins[ddir], key=lambda bin: bin[0])
+
+            run_total[ddir] = [0 for x in range(0, len(bins[ddir]))]
+            if len(bins[ddir]) > 0:
+                run_total[ddir][0] = bins[ddir][0][1]
+                for x in range(1, len(bins[ddir])):
+                    run_total[ddir][x] = run_total[ddir][x-1] + \
+                        bins[ddir][x][1]
+
+        stub, ext = os.path.splitext(args.dest)
+        outfile = stub + '_job' + str(jobnum) + ext
+
+        with open(outfile, 'w') as output:
+            output.write("clat_nsec, ")
+            ddir_list = list(ddir_set)
+            for ddir in ddir_list:
+                output.write("{0}_count, {0}_cumulative, {0}_percentile, ".
+                             format(ddir))
+            output.write("\n")
+
+#
+# Have a counter for each ddir
+# In each round, pick the shortest remaining duration
+# and output a line with any values for that duration
+#
+            indices = {x: 0 for x in ddir_list}
+            while more_lines(indices, bins):
+                min_lat = 17112760320
+                for ddir in ddir_list:
+                    if indices[ddir] < len(bins[ddir]):
+                        min_lat = min(bins[ddir][indices[ddir]][0], min_lat)
+
+                output.write("{0}, ".format(min_lat))
+
+                for ddir in ddir_list:
+                    if indices[ddir] < len(bins[ddir]) and \
+                       min_lat == bins[ddir][indices[ddir]][0]:
+                        count = bins[ddir][indices[ddir]][1]
+                        cumulative = run_total[ddir][indices[ddir]]
+                        ptile = percentile(indices[ddir], run_total[ddir])
+                        output.write("{0}, {1}, {2}, ".format(count,
+                                     cumulative, ptile))
+                        indices[ddir] += 1
+                    else:
+                        output.write(", , , ")
+                output.write("\n")
+
+            print "{0} generated".format(outfile)
+
+
+if __name__ == '__main__':
+    main()
