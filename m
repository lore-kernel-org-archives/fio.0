Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v2 3/4] man: minor fixes for sections before "JOB PARAMETERS" for consistency
Date: Mon, 14 Aug 2017 17:54:57 +0300
Message-Id: <20170814145458.41333-4-tkusumi@tuxera.com>
In-Reply-To: <20170814145458.41333-1-tkusumi@tuxera.com>
References: <20170814145458.41333-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is the continuation of below series of patches as well as the
previous 2 commits to sync the man page with HOWTO.

[PATCH 0/7] Sync fio(1) man page with HOWTO
http://www.spinics.net/lists/fio/msg06008.html

This commit consists of minor fixes to sync formats in the earlier
sections (made by above series of pathches) with the previous 2 commits.
The contents remain the same.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 222 ++++++++++++++++++++++++++++++++----------------------------------
 1 file changed, 106 insertions(+), 116 deletions(-)

diff --git a/fio.1 b/fio.1
index 7110b3c..3c9b2c6 100644
--- a/fio.1
+++ b/fio.1
@@ -13,72 +13,73 @@ one wants to simulate.
 .SH OPTIONS
 .TP
 .BI \-\-debug \fR=\fPtype
-Enable verbose tracing of various fio actions. May be `all' for all types
-or individual types separated by a comma (e.g. \-\-debug=file,mem will enable
+Enable verbose tracing \fItype\fR of various fio actions. May be `all' for all \fItype\fRs
+or individual types separated by a comma (e.g. `\-\-debug=file,mem' will enable
 file and memory debugging). `help' will list all available tracing options.
 .TP
-.BI \-\-parse-only
+.BI \-\-parse\-only
 Parse options only, don't start any I/O.
 .TP
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
 .TP
-.BI \-\-output-format \fR=\fPformat
-Set the reporting format to \fInormal\fR, \fIterse\fR, \fIjson\fR, or
-\fIjson+\fR. Multiple formats can be selected, separate by a comma. \fIterse\fR
-is a CSV based format. \fIjson+\fR is like \fIjson\fR, except it adds a full
+.BI \-\-output\-format \fR=\fPformat
+Set the reporting \fIformat\fR to `normal', `terse', `json', or
+`json+'. Multiple formats can be selected, separate by a comma. `terse'
+is a CSV based format. `json+' is like `json', except it adds a full
 dump of the latency buckets.
 .TP
 .BI \-\-runtime \fR=\fPruntime
 Limit run time to \fIruntime\fR seconds.
 .TP
-.B \-\-bandwidth\-log
+.BI \-\-bandwidth\-log
 Generate aggregate bandwidth logs.
 .TP
-.B \-\-minimal
-Print statistics in a terse, semicolon-delimited format.
+.BI \-\-minimal
+Print statistics in a terse, semicolon\-delimited format.
 .TP
-.B \-\-append-terse
-Print statistics in selected mode AND terse, semicolon-delimited format.
-Deprecated, use \-\-output-format instead to select multiple formats.
+.BI \-\-append\-terse
+Print statistics in selected mode AND terse, semicolon\-delimited format.
+\fBDeprecated\fR, use \fB\-\-output\-format\fR instead to select multiple formats.
 .TP
 .BI \-\-terse\-version \fR=\fPversion
-Set terse version output format (default 3, or 2, 4, 5)
+Set terse \fIversion\fR output format (default `3', or `2', `4', `5').
 .TP
-.B \-\-version
+.BI \-\-version
 Print version information and exit.
 .TP
-.B \-\-help
+.BI \-\-help
 Print a summary of the command line options and exit.
 .TP
-.B \-\-cpuclock-test
+.BI \-\-cpuclock\-test
 Perform test and validation of internal CPU clock.
 .TP
 .BI \-\-crctest \fR=\fP[test]
-Test the speed of the built-in checksumming functions. If no argument is given,
+Test the speed of the built\-in checksumming functions. If no argument is given,
 all of them are tested. Alternatively, a comma separated list can be passed, in which
 case the given ones are tested.
 .TP
 .BI \-\-cmdhelp \fR=\fPcommand
 Print help information for \fIcommand\fR. May be `all' for all commands.
 .TP
-.BI \-\-enghelp \fR=\fPioengine[,command]
-List all commands defined by \fIioengine\fR, or print help for \fIcommand\fR defined by \fIioengine\fR.
-If no \fIioengine\fR is given, list all available ioengines.
+.BI \-\-enghelp \fR=\fP[ioengine[,command]]
+List all commands defined by \fIioengine\fR, or print help for \fIcommand\fR
+defined by \fIioengine\fR. If no \fIioengine\fR is given, list all
+available ioengines.
 .TP
 .BI \-\-showcmd \fR=\fPjobfile
-Convert \fIjobfile\fR to a set of command-line options.
+Convert \fIjobfile\fR to a set of command\-line options.
 .TP
 .BI \-\-readonly
-Turn on safety read-only checks, preventing writes. The \-\-readonly
+Turn on safety read\-only checks, preventing writes. The \fB\-\-readonly\fR
 option is an extra safety guard to prevent users from accidentally starting
 a write workload when that is not desired. Fio will only write if
-`rw=write/randwrite/rw/randrw` is given. This extra safety net can be used
-as an extra precaution as \-\-readonly will also enable a write check in
+`rw=write/randwrite/rw/randrw' is given. This extra safety net can be used
+as an extra precaution as \fB\-\-readonly\fR will also enable a write check in
 the I/O engine core to prevent writes due to unknown user space bug(s).
 .TP
 .BI \-\-eta \fR=\fPwhen
-Specifies when real-time ETA estimate should be printed. \fIwhen\fR may
+Specifies when real\-time ETA estimate should be printed. \fIwhen\fR may
 be `always', `never' or `auto'.
 .TP
 .BI \-\-eta\-newline \fR=\fPtime
@@ -91,43 +92,45 @@ the value is interpreted in seconds.
 .TP
 .BI \-\-section \fR=\fPname
 Only run specified section \fIname\fR in job file. Multiple sections can be specified.
-The \-\-section option allows one to combine related jobs into one file.
+The \fB\-\-section\fR option allows one to combine related jobs into one file.
 E.g. one job file could define light, moderate, and heavy sections. Tell
-fio to run only the "heavy" section by giving \-\-section=heavy
+fio to run only the "heavy" section by giving `\-\-section=heavy'
 command line option. One can also specify the "write" operations in one
-section and "verify" operation in another section. The \-\-section option
+section and "verify" operation in another section. The \fB\-\-section\fR option
 only applies to job sections. The reserved *global* section is always
 parsed and used.
 .TP
 .BI \-\-alloc\-size \fR=\fPkb
-Set the internal smalloc pool size to \fIkb\fP in KiB. The
-\-\-alloc-size switch allows one to use a larger pool size for smalloc.
+Set the internal smalloc pool size to \fIkb\fR in KiB. The
+\fB\-\-alloc\-size\fR switch allows one to use a larger pool size for smalloc.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
 memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
-NOTE: While running .fio_smalloc.* backing store files are visible
-in /tmp.
+NOTE: While running `.fio_smalloc.*' backing store files are visible
+in `/tmp'.
 .TP
 .BI \-\-warnings\-fatal
 All fio parser warnings are fatal, causing fio to exit with an error.
 .TP
 .BI \-\-max\-jobs \fR=\fPnr
-Set the maximum number of threads/processes to support.
+Set the maximum number of threads/processes to support to \fInr\fR.
 .TP
 .BI \-\-server \fR=\fPargs
-Start a backend server, with \fIargs\fP specifying what to listen to. See Client/Server section.
+Start a backend server, with \fIargs\fR specifying what to listen to.
+See \fBCLIENT/SERVER\fR section.
 .TP
 .BI \-\-daemonize \fR=\fPpidfile
-Background a fio server, writing the pid to the given \fIpidfile\fP file.
+Background a fio server, writing the pid to the given \fIpidfile\fR file.
 .TP
 .BI \-\-client \fR=\fPhostname
-Instead of running the jobs locally, send and run them on the given host or set of hosts. See Client/Server section.
+Instead of running the jobs locally, send and run them on the given \fIhostname\fR
+or set of \fIhostname\fRs. See \fBCLIENT/SERVER\fR section.
 .TP
-.BI \-\-remote-config \fR=\fPfile
-Tell fio server to load this local file.
+.BI \-\-remote\-config \fR=\fPfile
+Tell fio server to load this local \fIfile\fR.
 .TP
 .BI \-\-idle\-prof \fR=\fPoption
-Report CPU idleness. \fIoption\fP is one of the following:
+Report CPU idleness. \fIoption\fR is one of the following:
 .RS
 .RS
 .TP
@@ -138,31 +141,31 @@ Run unit work calibration only and exit.
 Show aggregate system idleness and unit work.
 .TP
 .B percpu
-As "system" but also show per CPU idleness.
+As \fBsystem\fR but also show per CPU idleness.
 .RE
 .RE
 .TP
-.BI \-\-inflate-log \fR=\fPlog
-Inflate and output compressed log.
+.BI \-\-inflate\-log \fR=\fPlog
+Inflate and output compressed \fIlog\fR.
 .TP
-.BI \-\-trigger-file \fR=\fPfile
-Execute trigger cmd when file exists.
+.BI \-\-trigger\-file \fR=\fPfile
+Execute trigger command when \fIfile\fR exists.
 .TP
-.BI \-\-trigger-timeout \fR=\fPt
-Execute trigger at this time.
+.BI \-\-trigger\-timeout \fR=\fPtime
+Execute trigger at this \fItime\fR.
 .TP
-.BI \-\-trigger \fR=\fPcmd
-Set this command as local trigger.
+.BI \-\-trigger \fR=\fPcommand
+Set this \fIcommand\fR as local trigger.
 .TP
-.BI \-\-trigger-remote \fR=\fPcmd
-Set this command as remote trigger.
+.BI \-\-trigger\-remote \fR=\fPcommand
+Set this \fIcommand\fR as remote trigger.
 .TP
-.BI \-\-aux-path \fR=\fPpath
-Use this path for fio state generated files.
+.BI \-\-aux\-path \fR=\fPpath
+Use this \fIpath\fR for fio state generated files.
 .SH "JOB FILE FORMAT"
 Any parameters following the options will be assumed to be job files, unless
 they match a job file parameter. Multiple job files can be listed and each job
-file will be regarded as a separate group. Fio will `stonewall` execution
+file will be regarded as a separate group. Fio will \fBstonewall\fR execution
 between each group.
 
 Fio accepts one or more job files describing what it is
@@ -178,32 +181,30 @@ override a *global* section parameter, and a job file may even have several
 *global* sections if so desired. A job is only affected by a *global* section
 residing above it.
 
-The \-\-cmdhelp option also lists all options. If used with an `option`
-argument, \-\-cmdhelp will detail the given `option`.
+The \fB\-\-cmdhelp\fR option also lists all options. If used with an \fIcommand\fR
+argument, \fB\-\-cmdhelp\fR will detail the given \fIcommand\fR.
 
-See the `examples/` directory in the fio source for inspiration on how to write
-job files. Note the copyright and license requirements currently apply to
-`examples/` files.
+See the `examples/' directory for inspiration on how to write job files. Note
+the copyright and license requirements currently apply to
+`examples/' files.
 .SH "JOB FILE PARAMETERS"
 Some parameters take an option of a given type, such as an integer or a
 string. Anywhere a numeric value is required, an arithmetic expression may be
 used, provided it is surrounded by parentheses. Supported operators are:
 .RS
-.RS
-.TP
+.P
 .B addition (+)
-.TP
-.B subtraction (-)
-.TP
+.P
+.B subtraction (\-)
+.P
 .B multiplication (*)
-.TP
+.P
 .B division (/)
-.TP
+.P
 .B modulus (%)
-.TP
+.P
 .B exponentiation (^)
 .RE
-.RE
 .P
 For time values in expressions, units are microseconds by default. This is
 different than for time values not in expressions (not enclosed in
@@ -238,45 +239,41 @@ default unit is bytes. For quantities of time, the default unit is seconds
 unless otherwise specified.
 .P
 With `kb_base=1000', fio follows international standards for unit
-prefixes. To specify power-of-10 decimal values defined in the
+prefixes. To specify power\-of\-10 decimal values defined in the
 International System of Units (SI):
 .RS
 .P
+.PD 0
 Ki means kilo (K) or 1000
-.RE
-.RS
+.P
 Mi means mega (M) or 1000**2
-.RE
-.RS
+.P
 Gi means giga (G) or 1000**3
-.RE
-.RS
+.P
 Ti means tera (T) or 1000**4
-.RE
-.RS
+.P
 Pi means peta (P) or 1000**5
+.PD
 .RE
 .P
-To specify power-of-2 binary values defined in IEC 80000-13:
+To specify power\-of\-2 binary values defined in IEC 80000\-13:
 .RS
 .P
+.PD 0
 K means kibi (Ki) or 1024
-.RE
-.RS
+.P
 M means mebi (Mi) or 1024**2
-.RE
-.RS
+.P
 G means gibi (Gi) or 1024**3
-.RE
-.RS
+.P
 T means tebi (Ti) or 1024**4
-.RE
-.RS
+.P
 P means pebi (Pi) or 1024**5
+.PD
 .RE
 .P
 With `kb_base=1024' (the default), the unit prefixes are opposite
-from those specified in the SI and IEC 80000-13 standards to provide
+from those specified in the SI and IEC 80000\-13 standards to provide
 compatibility with old scripts. For example, 4k means 4096.
 .P
 For quantities of data, an optional unit of 'B' may be included
@@ -288,62 +285,55 @@ not milli). 'b' and 'B' both mean byte, not bit.
 Examples with `kb_base=1000':
 .RS
 .P
+.PD 0
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
-.RE
-.RS
+.P
 1 MiB: 1048576, 1m, 1024k
-.RE
-.RS
+.P
 1 MB: 1000000, 1mi, 1000ki
-.RE
-.RS
+.P
 1 TiB: 1073741824, 1t, 1024m, 1048576k
-.RE
-.RS
+.P
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+.PD
 .RE
 .P
 Examples with `kb_base=1024' (default):
 .RS
 .P
+.PD 0
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
-.RE
-.RS
+.P
 1 MiB: 1048576, 1m, 1024k
-.RE
-.RS
+.P
 1 MB: 1000000, 1mi, 1000ki
-.RE
-.RS
+.P
 1 TiB: 1073741824, 1t, 1024m, 1048576k
-.RE
-.RS
+.P
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+.PD
 .RE
 .P
 To specify times (units are not case sensitive):
 .RS
 .P
+.PD 0
 D means days
-.RE
-.RS
+.P
 H means hours
-.RE
-.RS
+.P
 M mean minutes
-.RE
-.RS
+.P
 s or sec means seconds (default)
-.RE
-.RS
+.P
 ms or msec means milliseconds
-.RE
-.RS
+.P
 us or usec means microseconds
+.PD
 .RE
 .P
 If the option accepts an upper and lower range, use a colon ':' or
-minus '-' to separate such values. See `irange` parameter type.
+minus '\-' to separate such values. See \fIirange\fR parameter type.
 If the lower value specified happens to be larger than the upper value
 the two values are swapped.
 .RE
@@ -354,9 +344,9 @@ true and false (1 and 0).
 .TP
 .I irange
 Integer range with suffix. Allows value range to be given, such as
-1024-4096. A colon may also be used as the separator, e.g. 1k:4k. If the
+1024\-4096. A colon may also be used as the separator, e.g. 1k:4k. If the
 option allows two sets of ranges, they can be specified with a ',' or '/'
-delimiter: 1k-4k/8k-32k. Also see `int` parameter type.
+delimiter: 1k\-4k/8k\-32k. Also see \fIint\fR parameter type.
 .TP
 .I float_list
 A list of floating point numbers, separated by a ':' character.
-- 
2.9.4


