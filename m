Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 1/7] man: sync OPTIONS section with HOWTO
Date: Tue,  4 Jul 2017 21:08:10 +0300
Message-Id: <20170704180816.39585-2-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit brings in updates from HOWTO. The exception is --debug
option, which is too verbose yet not that important for all debug types
to be listed in details.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 116 +++++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 87 insertions(+), 29 deletions(-)

diff --git a/fio.1 b/fio.1
index 9783646..016fb67 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "June 2017" "User Manual"
+.TH fio 1 "July 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -14,8 +14,11 @@ one wants to simulate.
 .TP
 .BI \-\-debug \fR=\fPtype
 Enable verbose tracing of various fio actions. May be `all' for all types
-or individual types separated by a comma (eg \-\-debug=io,file). `help' will
-list all available tracing options.
+or individual types separated by a comma (e.g. \-\-debug=file,mem will enable
+file and memory debugging). `help' will list all available tracing options.
+.TP
+.BI \-\-parse-only
+Parse options only, don't start any I/O.
 .TP
 .BI \-\-output \fR=\fPfilename
 Write output to \fIfilename\fR.
@@ -39,68 +42,123 @@ Print statistics in a terse, semicolon-delimited format.
 Print statistics in selected mode AND terse, semicolon-delimited format.
 Deprecated, use \-\-output-format instead to select multiple formats.
 .TP
-.B \-\-version
-Display version information and exit.
-.TP
 .BI \-\-terse\-version \fR=\fPversion
 Set terse version output format (default 3, or 2, 4, 5)
 .TP
+.B \-\-version
+Print version information and exit.
+.TP
 .B \-\-help
-Display usage information and exit.
+Print a summary of the command line options and exit.
 .TP
 .B \-\-cpuclock-test
-Perform test and validation of internal CPU clock
+Perform test and validation of internal CPU clock.
 .TP
-.BI \-\-crctest[\fR=\fPtest]
-Test the speed of the builtin checksumming functions. If no argument is given,
-all of them are tested. Or a comma separated list can be passed, in which
+.BI \-\-crctest \fR=\fP[test]
+Test the speed of the built-in checksumming functions. If no argument is given,
+all of them are tested. Alternatively, a comma separated list can be passed, in which
 case the given ones are tested.
 .TP
 .BI \-\-cmdhelp \fR=\fPcommand
-Print help information for \fIcommand\fR.  May be `all' for all commands.
+Print help information for \fIcommand\fR. May be `all' for all commands.
 .TP
 .BI \-\-enghelp \fR=\fPioengine[,command]
 List all commands defined by \fIioengine\fR, or print help for \fIcommand\fR defined by \fIioengine\fR.
+If no \fIioengine\fR is given, list all available ioengines.
 .TP
 .BI \-\-showcmd \fR=\fPjobfile
 Convert \fIjobfile\fR to a set of command-line options.
 .TP
+.BI \-\-readonly
+Turn on safety read-only checks, preventing writes. The \-\-readonly
+option is an extra safety guard to prevent users from accidentally starting
+a write workload when that is not desired. Fio will only write if
+`rw=write/randwrite/rw/randrw` is given. This extra safety net can be used
+as an extra precaution as \-\-readonly will also enable a write check in
+the I/O engine core to prevent writes due to unknown user space bug(s).
+.TP
 .BI \-\-eta \fR=\fPwhen
-Specifies when real-time ETA estimate should be printed.  \fIwhen\fR may
-be one of `always', `never' or `auto'.
+Specifies when real-time ETA estimate should be printed. \fIwhen\fR may
+be `always', `never' or `auto'.
 .TP
 .BI \-\-eta\-newline \fR=\fPtime
-Force an ETA newline for every `time` period passed.
+Force a new line for every \fItime\fR period passed. When the unit is omitted,
+the value is interpreted in seconds.
 .TP
 .BI \-\-status\-interval \fR=\fPtime
-Report full output status every `time` period passed.
-.TP
-.BI \-\-readonly
-Turn on safety read-only checks, preventing any attempted write.
-.TP
-.BI \-\-section \fR=\fPsec
-Only run section \fIsec\fR from job file. This option can be used multiple times to add more sections to run.
+Force full status dump every \fItime\fR period passed. When the unit is omitted,
+the value is interpreted in seconds.
+.TP
+.BI \-\-section \fR=\fPname
+Only run specified section \fIname\fR in job file. Multiple sections can be specified.
+The \-\-section option allows one to combine related jobs into one file.
+E.g. one job file could define light, moderate, and heavy sections. Tell
+fio to run only the "heavy" section by giving \-\-section=heavy
+command line option. One can also specify the "write" operations in one
+section and "verify" operation in another section. The \-\-section option
+only applies to job sections. The reserved *global* section is always
+parsed and used.
 .TP
 .BI \-\-alloc\-size \fR=\fPkb
-Set the internal smalloc pool size to \fIkb\fP kilobytes.
+Set the internal smalloc pool size to \fIkb\fP in KiB. The
+\-\-alloc-size switch allows one to use a larger pool size for smalloc.
+If running large jobs with randommap enabled, fio can run out of memory.
+Smalloc is an internal allocator for shared structures from a fixed size
+memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
+NOTE: While running .fio_smalloc.* backing store files are visible
+in /tmp.
 .TP
 .BI \-\-warnings\-fatal
 All fio parser warnings are fatal, causing fio to exit with an error.
 .TP
 .BI \-\-max\-jobs \fR=\fPnr
-Set the maximum allowed number of jobs (threads/processes) to support.
+Set the maximum number of threads/processes to support.
 .TP
 .BI \-\-server \fR=\fPargs
-Start a backend server, with \fIargs\fP specifying what to listen to. See client/server section.
+Start a backend server, with \fIargs\fP specifying what to listen to. See Client/Server section.
 .TP
 .BI \-\-daemonize \fR=\fPpidfile
-Background a fio server, writing the pid to the given pid file.
+Background a fio server, writing the pid to the given \fIpidfile\fP file.
+.TP
+.BI \-\-client \fR=\fPhostname
+Instead of running the jobs locally, send and run them on the given host or set of hosts. See Client/Server section.
 .TP
-.BI \-\-client \fR=\fPhost
-Instead of running the jobs locally, send and run them on the given host or set of hosts.  See client/server section.
+.BI \-\-remote-config \fR=\fPfile
+Tell fio server to load this local file.
 .TP
 .BI \-\-idle\-prof \fR=\fPoption
-Report cpu idleness on a system or percpu basis (\fIoption\fP=system,percpu) or run unit work calibration only (\fIoption\fP=calibrate).
+Report CPU idleness. \fIoption\fP is one of the following:
+.RS
+.RS
+.TP
+.B calibrate
+Run unit work calibration only and exit.
+.TP
+.B system
+Show aggregate system idleness and unit work.
+.TP
+.B percpu
+As "system" but also show per CPU idleness.
+.RE
+.RE
+.TP
+.BI \-\-inflate-log \fR=\fPlog
+Inflate and output compressed log.
+.TP
+.BI \-\-trigger-file \fR=\fPfile
+Execute trigger cmd when file exists.
+.TP
+.BI \-\-trigger-timeout \fR=\fPt
+Execute trigger at this time.
+.TP
+.BI \-\-trigger \fR=\fPcmd
+Set this command as local trigger.
+.TP
+.BI \-\-trigger-remote \fR=\fPcmd
+Set this command as remote trigger.
+.TP
+.BI \-\-aux-path \fR=\fPpath
+Use this path for fio state generated files.
 .SH "JOB FILE FORMAT"
 Job files are in `ini' format. They consist of one or more
 job definitions, which begin with a job name in square brackets and
-- 
2.9.4


