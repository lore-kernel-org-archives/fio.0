Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/7] HOWTO: minor backports from the man page
Date: Tue,  4 Jul 2017 21:08:15 +0300
Message-Id: <20170704180816.39585-7-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This commit mainly backports some minor fixups from the man page
sections covered in the several previous commits.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 41 ++++++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/HOWTO b/HOWTO
index 92c3b73..e982b1a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -104,6 +104,16 @@ Command line options
 
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
@@ -115,23 +125,16 @@ Command line options
 .. option:: --append-terse
 
     Print statistics in selected mode AND terse, semicolon-delimited format.
-    **deprecated**, use :option:`--output-format` instead to select multiple
+    **Deprecated**, use :option:`--output-format` instead to select multiple
     formats.
 
-.. option:: --output-format=type
-
-	Set the reporting format to `normal`, `terse`, `json`, or `json+`.  Multiple
-	formats can be selected, separated by a comma.  `terse` is a CSV based
-	format.  `json+` is like `json`, except it adds a full dump of the latency
-	buckets.
-
 .. option:: --terse-version=type
 
 	Set terse version output format (default 3, or 2 or 4 or 5).
 
 .. option:: --version
 
-	Print version info and exit.
+	Print version information and exit.
 
 .. option:: --help
 
@@ -144,7 +147,7 @@ Command line options
 .. option:: --crctest=[test]
 
     Test the speed of the built-in checksumming functions. If no argument is
-    given all of them are tested. Alternatively, a comma separated list can be passed, in
+    given, all of them are tested. Alternatively, a comma separated list can be passed, in
     which case the given ones are tested.
 
 .. option:: --cmdhelp=command
@@ -159,7 +162,7 @@ Command line options
 
 .. option:: --showcmd=jobfile
 
-	Turn a job file into command line options.
+	Convert `jobfile` to a set of command-line options.
 
 .. option:: --readonly
 
@@ -172,8 +175,8 @@ Command line options
 
 .. option:: --eta=when
 
-	When real-time ETA estimate should be printed.  May be `always`, `never` or
-	`auto`.
+	Specifies when real-time ETA estimate should be printed.  `when` may be
+	`always`, `never` or `auto`.
 
 .. option:: --eta-newline=time
 
@@ -187,7 +190,7 @@ Command line options
 
 .. option:: --section=name
 
-    Only run specified section in job file.  Multiple sections can be specified.
+    Only run specified section `name` in job file.  Multiple sections can be specified.
     The ``--section`` option allows one to combine related jobs into one file.
     E.g. one job file could define light, moderate, and heavy sections. Tell
     fio to run only the "heavy" section by giving ``--section=heavy``
@@ -198,7 +201,7 @@ Command line options
 
 .. option:: --alloc-size=kb
 
-    Set the internal smalloc pool to this size in KiB.  The
+    Set the internal smalloc pool size to `kb` in KiB.  The
     ``--alloc-size`` switch allows one to use a larger pool size for smalloc.
     If running large jobs with randommap enabled, fio can run out of memory.
     Smalloc is an internal allocator for shared structures from a fixed size
@@ -214,7 +217,7 @@ Command line options
 
 .. option:: --max-jobs=nr
 
-	Maximum number of threads/processes to support.
+	Set the maximum number of threads/processes to support.
 
 .. option:: --server=args
 
@@ -236,7 +239,7 @@ Command line options
 
 .. option:: --idle-prof=option
 
-	Report CPU idleness. *option* is one of the following:
+	Report CPU idleness. `option` is one of the following:
 
 		**calibrate**
 			Run unit work calibration only and exit.
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
-- 
2.9.4


