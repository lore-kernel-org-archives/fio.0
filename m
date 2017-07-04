Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 7/7] HOWTO: fix indentation for options and job parameters
Date: Tue,  4 Jul 2017 21:08:16 +0300
Message-Id: <20170704180816.39585-8-tkusumi@tuxera.com>
In-Reply-To: <20170704180816.39585-1-tkusumi@tuxera.com>
References: <20170704180816.39585-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

HOWTO mostly uses tab indentations for command line options and job
file parameters, so replace white spaces with tabs.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 126 +++++++++++++++++++++++++++++++++---------------------------------
 1 file changed, 63 insertions(+), 63 deletions(-)

diff --git a/HOWTO b/HOWTO
index e982b1a..0b80a62 100644
--- a/HOWTO
+++ b/HOWTO
@@ -54,51 +54,51 @@ Command line options
 
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
 
@@ -124,9 +124,9 @@ Command line options
 
 .. option:: --append-terse
 
-    Print statistics in selected mode AND terse, semicolon-delimited format.
-    **Deprecated**, use :option:`--output-format` instead to select multiple
-    formats.
+	Print statistics in selected mode AND terse, semicolon-delimited format.
+	**Deprecated**, use :option:`--output-format` instead to select multiple
+	formats.
 
 .. option:: --terse-version=type
 
@@ -146,9 +146,9 @@ Command line options
 
 .. option:: --crctest=[test]
 
-    Test the speed of the built-in checksumming functions. If no argument is
-    given, all of them are tested. Alternatively, a comma separated list can be passed, in
-    which case the given ones are tested.
+	Test the speed of the built-in checksumming functions. If no argument is
+	given, all of them are tested. Alternatively, a comma separated list can
+	be passed, in which case the given ones are tested.
 
 .. option:: --cmdhelp=command
 
@@ -156,9 +156,9 @@ Command line options
 
 .. option:: --enghelp=[ioengine[,command]]
 
-    List all commands defined by :option:`ioengine`, or print help for `command`
-    defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
-    available ioengines.
+	List all commands defined by :option:`ioengine`, or print help for `command`
+	defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
+	available ioengines.
 
 .. option:: --showcmd=jobfile
 
@@ -166,12 +166,12 @@ Command line options
 
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
 
@@ -190,30 +190,30 @@ Command line options
 
 .. option:: --section=name
 
-    Only run specified section `name` in job file.  Multiple sections can be specified.
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
 
-    Set the internal smalloc pool size to `kb` in KiB.  The
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
 
@@ -221,17 +221,17 @@ Command line options
 
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
 
@@ -448,7 +448,7 @@ automatically substituted with the current system values when the job is
 run. Simple math is also supported on these keywords, so you can perform actions
 like::
 
-        size=8*$mb_memory
+	size=8*$mb_memory
 
 and get that properly expanded to 8 times the size of memory in the machine.
 
@@ -477,7 +477,7 @@ Parameter types
 ~~~~~~~~~~~~~~~
 
 **str**
-    String. This is a sequence of alpha characters.
+	String: A sequence of alphanumeric characters.
 
 **time**
 	Integer with possible time suffix.  Without a unit value is interpreted as
@@ -491,7 +491,7 @@ Parameter types
 	Integer. A whole number value, which may contain an integer prefix
 	and an integer suffix:
 
-        [*integer prefix*] **number** [*integer suffix*]
+	[*integer prefix*] **number** [*integer suffix*]
 
 	The optional *integer prefix* specifies the number's base. The default
 	is decimal. *0x* specifies hexadecimal.
-- 
2.9.4


