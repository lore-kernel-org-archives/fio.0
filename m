Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59760 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdGEMAO (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2017 08:00:14 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dSiyb-0007OE-1h
        for fio@vger.kernel.org; Wed, 05 Jul 2017 12:00:13 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170705120002.43B542C0098@kernel.dk>
Date: Wed,  5 Jul 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 1be7afd7329ebdca520d637f571d2b31c33f6ba1:

  Merge branch 'fallocate_native' of https://github.com/sitsofe/fio (2017-07-03 16:51:31 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b034c0dd2cdb27d3523b300c1b4b93a1c5b84b3c:

  HOWTO: fix indentation for options and job parameters (2017-07-04 16:07:50 -0600)

----------------------------------------------------------------
Tomohiro Kusumi (7):
      man: sync OPTIONS section with HOWTO
      man: sync "JOB FILE FORMAT" section with HOWTO
      man: sync "JOB FILE PARAMETERS" section with HOWTO
      man: sync "PARAMETER TYPES" section with HOWTO
      man: refer to REPORTING-BUGS for bug reporting
      HOWTO: minor backports from the man page
      HOWTO: fix indentation for options and job parameters

 HOWTO  | 159 +++++++++++++++++++++--------------------
 README |   3 +-
 fio.1  | 250 ++++++++++++++++++++++++++++++++++++++++++++---------------------
 3 files changed, 251 insertions(+), 161 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 92c3b73..0b80a62 100644
--- a/HOWTO
+++ b/HOWTO
@@ -54,56 +54,66 @@ Command line options
 
 .. option:: --debug=type
 
-    Enable verbose tracing of various fio actions.  May be ``all`` for all types
-    or individual types separated by a comma (e.g. ``--debug=file,mem`` will
-    enable file and memory debugging).  Currently, additional logging is
-    available for:
+	Enable verbose tracing of various fio actions.  May be ``all`` for all types
+	or individual types separated by a comma (e.g. ``--debug=file,mem`` will
+	enable file and memory debugging).  Currently, additional logging is
+	available for:
 
-    *process*
+	*process*
 			Dump info related to processes.
-    *file*
+	*file*
 			Dump info related to file actions.
-    *io*
+	*io*
 			Dump info related to I/O queuing.
-    *mem*
+	*mem*
 			Dump info related to memory allocations.
-    *blktrace*
+	*blktrace*
 			Dump info related to blktrace setup.
-    *verify*
+	*verify*
 			Dump info related to I/O verification.
-    *all*
+	*all*
 			Enable all debug options.
-    *random*
+	*random*
 			Dump info related to random offset generation.
-    *parse*
+	*parse*
 			Dump info related to option matching and parsing.
-    *diskutil*
+	*diskutil*
 			Dump info related to disk utilization updates.
-    *job:x*
+	*job:x*
 			Dump info only related to job number x.
-    *mutex*
+	*mutex*
 			Dump info only related to mutex up/down ops.
-    *profile*
+	*profile*
 			Dump info related to profile extensions.
-    *time*
+	*time*
 			Dump info related to internal time keeping.
-    *net*
+	*net*
 			Dump info related to networking connections.
-    *rate*
+	*rate*
 			Dump info related to I/O rate switching.
-    *compress*
+	*compress*
 			Dump info related to log compress/decompress.
-    *?* or *help*
+	*?* or *help*
 			Show available debug options.
 
 .. option:: --parse-only
 
-    Parse options only, don\'t start any I/O.
+	Parse options only, don\'t start any I/O.
 
 .. option:: --output=filename
 
 	Write output to file `filename`.
 
+.. option:: --output-format=type
+
+	Set the reporting format to `normal`, `terse`, `json`, or `json+`.  Multiple
+	formats can be selected, separated by a comma.  `terse` is a CSV based
+	format.  `json+` is like `json`, except it adds a full dump of the latency
+	buckets.
+
+.. option:: --runtime
+	Limit run time to runtime seconds.
+
 .. option:: --bandwidth-log
 
 	Generate aggregate bandwidth logs.
@@ -114,16 +124,9 @@ Command line options
 
 .. option:: --append-terse
 
-    Print statistics in selected mode AND terse, semicolon-delimited format.
-    **deprecated**, use :option:`--output-format` instead to select multiple
-    formats.
-
-.. option:: --output-format=type
-
-	Set the reporting format to `normal`, `terse`, `json`, or `json+`.  Multiple
-	formats can be selected, separated by a comma.  `terse` is a CSV based
-	format.  `json+` is like `json`, except it adds a full dump of the latency
-	buckets.
+	Print statistics in selected mode AND terse, semicolon-delimited format.
+	**Deprecated**, use :option:`--output-format` instead to select multiple
+	formats.
 
 .. option:: --terse-version=type
 
@@ -131,7 +134,7 @@ Command line options
 
 .. option:: --version
 
-	Print version info and exit.
+	Print version information and exit.
 
 .. option:: --help
 
@@ -143,9 +146,9 @@ Command line options
 
 .. option:: --crctest=[test]
 
-    Test the speed of the built-in checksumming functions. If no argument is
-    given all of them are tested. Alternatively, a comma separated list can be passed, in
-    which case the given ones are tested.
+	Test the speed of the built-in checksumming functions. If no argument is
+	given, all of them are tested. Alternatively, a comma separated list can
+	be passed, in which case the given ones are tested.
 
 .. option:: --cmdhelp=command
 
@@ -153,27 +156,27 @@ Command line options
 
 .. option:: --enghelp=[ioengine[,command]]
 
-    List all commands defined by :option:`ioengine`, or print help for `command`
-    defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
-    available ioengines.
+	List all commands defined by :option:`ioengine`, or print help for `command`
+	defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
+	available ioengines.
 
 .. option:: --showcmd=jobfile
 
-	Turn a job file into command line options.
+	Convert `jobfile` to a set of command-line options.
 
 .. option:: --readonly
 
-    Turn on safety read-only checks, preventing writes.  The ``--readonly``
-    option is an extra safety guard to prevent users from accidentally starting
-    a write workload when that is not desired.  Fio will only write if
-    `rw=write/randwrite/rw/randrw` is given.  This extra safety net can be used
-    as an extra precaution as ``--readonly`` will also enable a write check in
-    the I/O engine core to prevent writes due to unknown user space bug(s).
+	Turn on safety read-only checks, preventing writes.  The ``--readonly``
+	option is an extra safety guard to prevent users from accidentally starting
+	a write workload when that is not desired.  Fio will only write if
+	`rw=write/randwrite/rw/randrw` is given.  This extra safety net can be used
+	as an extra precaution as ``--readonly`` will also enable a write check in
+	the I/O engine core to prevent writes due to unknown user space bug(s).
 
 .. option:: --eta=when
 
-	When real-time ETA estimate should be printed.  May be `always`, `never` or
-	`auto`.
+	Specifies when real-time ETA estimate should be printed.  `when` may be
+	`always`, `never` or `auto`.
 
 .. option:: --eta-newline=time
 
@@ -187,48 +190,48 @@ Command line options
 
 .. option:: --section=name
 
-    Only run specified section in job file.  Multiple sections can be specified.
-    The ``--section`` option allows one to combine related jobs into one file.
-    E.g. one job file could define light, moderate, and heavy sections. Tell
-    fio to run only the "heavy" section by giving ``--section=heavy``
-    command line option.  One can also specify the "write" operations in one
-    section and "verify" operation in another section.  The ``--section`` option
-    only applies to job sections.  The reserved *global* section is always
-    parsed and used.
+	Only run specified section `name` in job file.  Multiple sections can be specified.
+	The ``--section`` option allows one to combine related jobs into one file.
+	E.g. one job file could define light, moderate, and heavy sections. Tell
+	fio to run only the "heavy" section by giving ``--section=heavy``
+	command line option.  One can also specify the "write" operations in one
+	section and "verify" operation in another section.  The ``--section`` option
+	only applies to job sections.  The reserved *global* section is always
+	parsed and used.
 
 .. option:: --alloc-size=kb
 
-    Set the internal smalloc pool to this size in KiB.  The
-    ``--alloc-size`` switch allows one to use a larger pool size for smalloc.
-    If running large jobs with randommap enabled, fio can run out of memory.
-    Smalloc is an internal allocator for shared structures from a fixed size
-    memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
+	Set the internal smalloc pool size to `kb` in KiB.  The
+	``--alloc-size`` switch allows one to use a larger pool size for smalloc.
+	If running large jobs with randommap enabled, fio can run out of memory.
+	Smalloc is an internal allocator for shared structures from a fixed size
+	memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
 
-    NOTE: While running :file:`.fio_smalloc.*` backing store files are visible
-    in :file:`/tmp`.
+	NOTE: While running :file:`.fio_smalloc.*` backing store files are visible
+	in :file:`/tmp`.
 
 .. option:: --warnings-fatal
 
-    All fio parser warnings are fatal, causing fio to exit with an
-    error.
+	All fio parser warnings are fatal, causing fio to exit with an
+	error.
 
 .. option:: --max-jobs=nr
 
-	Maximum number of threads/processes to support.
+	Set the maximum number of threads/processes to support.
 
 .. option:: --server=args
 
-    Start a backend server, with `args` specifying what to listen to.
-    See `Client/Server`_ section.
+	Start a backend server, with `args` specifying what to listen to.
+	See `Client/Server`_ section.
 
 .. option:: --daemonize=pidfile
 
-    Background a fio server, writing the pid to the given `pidfile` file.
+	Background a fio server, writing the pid to the given `pidfile` file.
 
 .. option:: --client=hostname
 
-    Instead of running the jobs locally, send and run them on the given host or
-    set of hosts.  See `Client/Server`_ section.
+	Instead of running the jobs locally, send and run them on the given host or
+	set of hosts.  See `Client/Server`_ section.
 
 .. option:: --remote-config=file
 
@@ -236,7 +239,7 @@ Command line options
 
 .. option:: --idle-prof=option
 
-	Report CPU idleness. *option* is one of the following:
+	Report CPU idleness. `option` is one of the following:
 
 		**calibrate**
 			Run unit work calibration only and exit.
@@ -445,7 +448,7 @@ automatically substituted with the current system values when the job is
 run. Simple math is also supported on these keywords, so you can perform actions
 like::
 
-        size=8*$mb_memory
+	size=8*$mb_memory
 
 and get that properly expanded to 8 times the size of memory in the machine.
 
@@ -474,7 +477,7 @@ Parameter types
 ~~~~~~~~~~~~~~~
 
 **str**
-    String. This is a sequence of alpha characters.
+	String: A sequence of alphanumeric characters.
 
 **time**
 	Integer with possible time suffix.  Without a unit value is interpreted as
@@ -488,7 +491,7 @@ Parameter types
 	Integer. A whole number value, which may contain an integer prefix
 	and an integer suffix:
 
-        [*integer prefix*] **number** [*integer suffix*]
+	[*integer prefix*] **number** [*integer suffix*]
 
 	The optional *integer prefix* specifies the number's base. The default
 	is decimal. *0x* specifies hexadecimal.
@@ -521,7 +524,7 @@ Parameter types
 	compatibility with old scripts.  For example, 4k means 4096.
 
 	For quantities of data, an optional unit of 'B' may be included
-	(e.g.,  'kB' is the same as 'k').
+	(e.g., 'kB' is the same as 'k').
 
 	The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
 	not milli). 'b' and 'B' both mean byte, not bit.
@@ -3542,7 +3545,7 @@ If windowed logging is enabled and :option:`log_max_value` is set, then fio logs
 maximum values in that window instead of averages.  Since 'data direction' and
 'offset' are per-I/O values, they aren't applicable if windowed logging is enabled.
 
-Client/server
+Client/Server
 -------------
 
 Normally fio is invoked as a stand-alone application on the machine where the
diff --git a/README b/README
index ec3e9c0..a6eba8f 100644
--- a/README
+++ b/README
@@ -59,7 +59,8 @@ Mailing list
 ------------
 
 The fio project mailing list is meant for anything related to fio including
-general discussion, bug reporting, questions, and development.
+general discussion, bug reporting, questions, and development. For bug reporting,
+see REPORTING-BUGS.
 
 An automated mail detailing recent commits is automatically sent to the list at
 most daily. The list address is fio@vger.kernel.org, subscribe by sending an
diff --git a/fio.1 b/fio.1
index 9783646..bc477a2 100644
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
@@ -39,89 +42,152 @@ Print statistics in a terse, semicolon-delimited format.
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
 .TP
-.BI \-\-client \fR=\fPhost
-Instead of running the jobs locally, send and run them on the given host or set of hosts.  See client/server section.
+.BI \-\-client \fR=\fPhostname
+Instead of running the jobs locally, send and run them on the given host or set of hosts. See Client/Server section.
+.TP
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
-Job files are in `ini' format. They consist of one or more
-job definitions, which begin with a job name in square brackets and
-extend to the next job name.  The job name can be any ASCII string
-except `global', which has a special meaning.  Following the job name is
-a sequence of zero or more parameters, one per line, that define the
-behavior of the job.  Any line starting with a `;' or `#' character is
-considered a comment and ignored.
-.P
-If \fIjobfile\fR is specified as `-', the job file will be read from
-standard input.
-.SS "Global Section"
-The global section contains default parameters for jobs specified in the
-job file.  A job is only affected by global sections residing above it,
-and there may be any number of global sections.  Specific job definitions
-may override any parameter set in global sections.
-.SH "JOB PARAMETERS"
-.SS Types
-Some parameters may take arguments of a specific type.
-Anywhere a numeric value is required, an arithmetic expression may be used,
-provided it is surrounded by parentheses. Supported operators are:
+Any parameters following the options will be assumed to be job files, unless
+they match a job file parameter. Multiple job files can be listed and each job
+file will be regarded as a separate group. Fio will `stonewall` execution
+between each group.
+
+Fio accepts one or more job files describing what it is
+supposed to do. The job file format is the classic ini file, where the names
+enclosed in [] brackets define the job name. You are free to use any ASCII name
+you want, except *global* which has special meaning. Following the job name is
+a sequence of zero or more parameters, one per line, that define the behavior of
+the job. If the first character in a line is a ';' or a '#', the entire line is
+discarded as a comment.
+
+A *global* section sets defaults for the jobs described in that file. A job may
+override a *global* section parameter, and a job file may even have several
+*global* sections if so desired. A job is only affected by a *global* section
+residing above it.
+
+The \-\-cmdhelp option also lists all options. If used with an `option`
+argument, \-\-cmdhelp will detail the given `option`.
+
+See the `examples/` directory in the fio source for inspiration on how to write
+job files. Note the copyright and license requirements currently apply to
+`examples/` files.
+.SH "JOB FILE PARAMETERS"
+Some parameters take an option of a given type, such as an integer or a
+string. Anywhere a numeric value is required, an arithmetic expression may be
+used, provided it is surrounded by parentheses. Supported operators are:
 .RS
 .RS
 .TP
@@ -141,28 +207,37 @@ provided it is surrounded by parentheses. Supported operators are:
 .P
 For time values in expressions, units are microseconds by default. This is
 different than for time values not in expressions (not enclosed in
-parentheses). The types used are:
+parentheses).
+.SH "PARAMETER TYPES"
+The following parameter types are used.
 .TP
 .I str
-String: a sequence of alphanumeric characters.
+String. A sequence of alphanumeric characters.
+.TP
+.I time
+Integer with possible time suffix. Without a unit value is interpreted as
+seconds unless otherwise specified. Accepts a suffix of 'd' for days, 'h' for
+hours, 'm' for minutes, 's' for seconds, 'ms' (or 'msec') for milliseconds and 'us'
+(or 'usec') for microseconds. For example, use 10m for 10 minutes.
 .TP
 .I int
 Integer. A whole number value, which may contain an integer prefix
 and an integer suffix.
 
-[integer prefix]number[integer suffix]
+[*integer prefix*] **number** [*integer suffix*]
+
+The optional *integer prefix* specifies the number's base. The default
+is decimal. *0x* specifies hexadecimal.
 
-The optional integer prefix specifies the number's base. The default
-is decimal. 0x specifies hexadecimal.
+The optional *integer suffix* specifies the number's units, and includes an
+optional unit prefix and an optional unit. For quantities of data, the
+default unit is bytes. For quantities of time, the default unit is seconds
+unless otherwise specified.
 
-The optional integer suffix specifies the number's units, and includes
-an optional unit prefix and an optional unit.  For quantities
-of data, the default unit is bytes. For quantities of time,
-the default unit is seconds.
+With \fBkb_base=1000\fR, fio follows international standards for unit
+prefixes. To specify power-of-10 decimal values defined in the
+International System of Units (SI):
 
-With \fBkb_base=1000\fR, fio follows international standards for unit prefixes.
-To specify power-of-10 decimal values defined in the International
-System of Units (SI):
 .nf
 ki means kilo (K) or 1000
 mi means mega (M) or 1000**2
@@ -172,6 +247,7 @@ pi means peta (P) or 1000**5
 .fi
 
 To specify power-of-2 binary values defined in IEC 80000-13:
+
 .nf
 k means kibi (Ki) or 1024
 m means mebi (Mi) or 1024**2
@@ -180,12 +256,19 @@ t means tebi (Ti) or 1024**4
 p means pebi (Pi) or 1024**5
 .fi
 
-With \fBkb_base=1024\fR (the default), the unit prefixes are opposite from
-those specified in the SI and IEC 80000-13 standards to provide
-compatibility with old scripts.  For example, 4k means 4096.
+With \fBkb_base=1024\fR (the default), the unit prefixes are opposite
+from those specified in the SI and IEC 80000-13 standards to provide
+compatibility with old scripts. For example, 4k means 4096.
+
+For quantities of data, an optional unit of 'B' may be included
+(e.g., 'kB' is the same as 'k').
+
+The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
+not milli). 'b' and 'B' both mean byte, not bit.
 
-.nf
 Examples with \fBkb_base=1000\fR:
+
+.nf
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
 1 MiB: 1048576, 1m, 1024k
 1 MB: 1000000, 1mi, 1000ki
@@ -193,8 +276,9 @@ Examples with \fBkb_base=1000\fR:
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
 .fi
 
-.nf
 Examples with \fBkb_base=1024\fR (default):
+
+.nf
 4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
 1 MiB: 1048576, 1m, 1024k
 1 MB: 1000000, 1mi, 1000ki
@@ -202,13 +286,8 @@ Examples with \fBkb_base=1024\fR (default):
 1 TB: 1000000000, 1ti, 1000mi, 1000000ki
 .fi
 
-For quantities of data, an optional unit of 'B' may be included
-(e.g.,  'kb' is the same as 'k').
-
-The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega,
-not milli). 'b' and 'B' both mean byte, not bit.
-
 To specify times (units are not case sensitive):
+
 .nf
 D means days
 H means hours
@@ -218,21 +297,25 @@ ms or msec means milliseconds
 us or usec means microseconds
 .fi
 
+If the option accepts an upper and lower range, use a colon ':' or
+minus '-' to separate such values. See `irange` parameter type.
+If the lower value specified happens to be larger than the upper value
+the two values are swapped.
 .TP
 .I bool
-Boolean: a true or false value. `0' denotes false, `1' denotes true.
+Boolean. Usually parsed as an integer, however only defined for
+true and false (1 and 0).
 .TP
 .I irange
-Integer range: a range of integers specified in the format
-\fIlower\fR:\fIupper\fR or \fIlower\fR\-\fIupper\fR. \fIlower\fR and
-\fIupper\fR may contain a suffix as described above.  If an option allows two
-sets of ranges, they are separated with a `,' or `/' character. For example:
-`8\-8k/8M\-4G'.
+Integer range with suffix. Allows value range to be given, such as
+1024-4096. A colon may also be used as the separator, e.g. 1k:4k. If the
+option allows two sets of ranges, they can be specified with a ',' or '/'
+delimiter: 1k-4k/8k-32k. Also see `int` parameter type.
 .TP
 .I float_list
-List of floating numbers: A list of floating numbers, separated by
-a ':' character.
-.SS "Parameter List"
+A list of floating point numbers, separated by a ':' character.
+.SH "JOB DESCRIPTION"
+With the above in mind, here follows the complete list of fio job parameters.
 .TP
 .BI name \fR=\fPstr
 May be used to override the job name.  On the command line, this parameter
@@ -2630,7 +2713,10 @@ This man page was written by Aaron Carroll <aaronc@cse.unsw.edu.au> based
 on documentation by Jens Axboe.
 .SH "REPORTING BUGS"
 Report bugs to the \fBfio\fR mailing list <fio@vger.kernel.org>.
-See \fBREADME\fR.
+.br
+See \fBREPORTING-BUGS\fR.
+
+\fBREPORTING-BUGS\fR: http://git.kernel.dk/cgit/fio/plain/REPORTING-BUGS
 .SH "SEE ALSO"
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
