Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751067AbdA1NBB (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 08:01:01 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cXSby-0002fh-IJ
        for fio@vger.kernel.org; Sat, 28 Jan 2017 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170128130002.81C2B2C0094@kernel.dk>
Date: Sat, 28 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f0ac17190989b4ada1d4d74be8d7a4ef3a76dfbb:

  Merge branch 'shm_rm' of https://github.com/sitsofe/fio (2017-01-26 10:07:48 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c60ebc45bccb8603a360f88c494ecca40a7becef:

  doc: minor consistency and spelling changes (2017-01-27 09:44:05 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (2):
      doc: minor documentation changes
      doc: minor consistency and spelling changes

 HOWTO     | 68 +++++++++++++++++++++++++++++++--------------------------------
 README    | 11 ++++++-----
 options.c |  2 +-
 3 files changed, 41 insertions(+), 40 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index d63fff7..e917e77 100644
--- a/HOWTO
+++ b/HOWTO
@@ -55,7 +55,7 @@ Command line options
 .. option:: --debug=type
 
     Enable verbose tracing of various fio actions.  May be ``all`` for all types
-    or individual types separated by a comma (eg ``--debug=file,mem`` will
+    or individual types separated by a comma (e.g. ``--debug=file,mem`` will
     enable file and memory debugging).  Currently, additional logging is
     available for:
 
@@ -273,7 +273,7 @@ Job file format
 
 As previously described, fio accepts one or more job files describing what it is
 supposed to do. The job file format is the classic ini file, where the names
-enclosed in [] brackets define the job name. You are free to use any ascii name
+enclosed in [] brackets define the job name. You are free to use any ASCII name
 you want, except *global* which has special meaning.  Following the job name is
 a sequence of zero or more parameters, one per line, that define the behavior of
 the job. If the first character in a line is a ';' or a '#', the entire line is
@@ -469,7 +469,7 @@ Parameter types
 
 **time**
 	Integer with possible time suffix. In seconds unless otherwise
-	specified, use eg 10m for 10 minutes. Accepts s/m/h for seconds, minutes,
+	specified, use e.g. 10m for 10 minutes. Accepts s/m/h for seconds, minutes,
 	and hours, and accepts 'ms' (or 'msec') for milliseconds, and 'us' (or
 	'usec') for microseconds.
 
@@ -554,7 +554,7 @@ Parameter types
 
 **irange**
 	Integer range with suffix. Allows value range to be given, such as
-	1024-4096. A colon may also be used as the separator, eg 1k:4k. If the
+	1024-4096. A colon may also be used as the separator, e.g. 1k:4k. If the
 	option allows two sets of ranges, they can be specified with a ',' or '/'
 	delimiter: 1k-4k/8k-32k. Also see :ref:`int <int>`.
 
@@ -653,7 +653,7 @@ Time related parameters
 	even if the file(s) are completely read or written. It will simply loop over
 	the same workload as many times as the :option:`runtime` allows.
 
-.. option:: startdelay=irange
+.. option:: startdelay=irange(time)
 
 	Delay start of job for the specified number of seconds. Supports all time
 	suffixes to allow specification of hours, minutes, seconds and milliseconds
@@ -820,13 +820,13 @@ Target file/device
 			still be open depending on 'openfiles'.
 
 		**zipf**
-			Use a *zipfian* distribution to decide what file to access.
+			Use a *Zipf* distribution to decide what file to access.
 
 		**pareto**
-			Use a *pareto* distribution to decide what file to access.
+			Use a *Pareto* distribution to decide what file to access.
 
 		**gauss**
-			Use a *gaussian* (normal) distribution to decide what file to
+			Use a *Gaussian* (normal) distribution to decide what file to
 			access.
 
 	For *random*, *roundrobin*, and *sequential*, a postfix can be appended to
@@ -871,7 +871,7 @@ Target file/device
 
 .. option:: allow_mounted_write=bool
 
-	If this isn't set, fio will abort jobs that are destructive (eg that write)
+	If this isn't set, fio will abort jobs that are destructive (e.g. that write)
 	to what appears to be a mounted device or partition. This should help catch
 	creating inadvertently destructive tests, not realizing that the test will
 	destroy data on the mounted file system. Default: false.
@@ -882,7 +882,7 @@ Target file/device
 	given I/O operation. This will also clear the :option:`invalidate` flag,
 	since it is pointless to pre-read and then drop the cache. This will only
 	work for I/O engines that are seek-able, since they allow you to read the
-	same data multiple times. Thus it will not work on eg network or splice I/O.
+	same data multiple times. Thus it will not work on e.g. network or splice I/O.
 
 .. option:: unlink=bool
 
@@ -975,7 +975,7 @@ I/O type
 			Generate the same offset.
 
 	``sequential`` is only useful for random I/O, where fio would normally
-	generate a new random offset for every I/O. If you append eg 8 to randread,
+	generate a new random offset for every I/O. If you append e.g. 8 to randread,
 	you would get a new random offset for every 8 I/O's. The result would be a
 	seek for only every 8 I/O's, instead of for every I/O. Use ``rw=randread:8``
 	to specify that. As sequential I/O is already sequential, setting
@@ -1072,10 +1072,10 @@ I/O type
 
 .. option:: number_ios=int
 
-	Fio will normally perform IOs until it has exhausted the size of the region
+	Fio will normally perform I/Os until it has exhausted the size of the region
 	set by :option:`size`, or if it exhaust the allocated time (or hits an error
 	condition). With this setting, the range/size can be set independently of
-	the number of IOs to perform. When fio reaches this number, it will exit
+	the number of I/Os to perform. When fio reaches this number, it will exit
 	normally and report status. Note that this does not extend the amount of I/O
 	that will be done, it will only stop fio if this condition is met before
 	other end-of-job criteria.
@@ -1163,14 +1163,14 @@ I/O type
 				Pareto distribution
 
 		**gauss**
-				Normal (gaussian) distribution
+				Normal (Gaussian) distribution
 
 		**zoned**
 				Zoned random distribution
 
 	When using a **zipf** or **pareto** distribution, an input value is also
 	needed to define the access pattern. For **zipf**, this is the `zipf
-	theta`. For **pareto**, it's the `pareto power`. Fio includes a test
+	theta`. For **pareto**, it's the `Pareto power`. Fio includes a test
 	program, :command:`genzipf`, that can be used visualize what the given input
 	values will yield in terms of hit rates.  If you wanted to use **zipf** with
 	a `theta` of 1.2, you would use ``random_distribution=zipf:1.2`` as the
@@ -1556,7 +1556,7 @@ I/O engine
 
 		**vsync**
 			Basic :manpage:`readv(2)` or :manpage:`writev(2)` I/O.  Will emulate
-			queuing by coalescing adjacent IOs into a single submission.
+			queuing by coalescing adjacent I/Os into a single submission.
 
 		**pvsync**
 			Basic :manpage:`preadv(2)` or :manpage:`pwritev(2)` I/O.
@@ -1699,7 +1699,7 @@ I/O engine
 
 		**external**
 			Prefix to specify loading an external I/O engine object file. Append
-			the engine filename, eg ``ioengine=external:/tmp/foo.o`` to load
+			the engine filename, e.g. ``ioengine=external:/tmp/foo.o`` to load
 			ioengine :file:`foo.o` in :file:`/tmp`.
 
 
@@ -1717,7 +1717,7 @@ caveat that when used on the command line, they must come after the
 	:manpage:`io_getevents(2)` system call to reap newly returned events.  With
 	this flag turned on, the AIO ring will be read directly from user-space to
 	reap events. The reaping mode is only enabled when polling for a minimum of
-	0 events (eg when :option:`iodepth_batch_complete` `=0`).
+	0 events (e.g. when :option:`iodepth_batch_complete` `=0`).
 
 .. option:: hipri : [psyncv2]
 
@@ -1872,7 +1872,7 @@ I/O depth
 
 	Number of I/O units to keep in flight against the file.  Note that
 	increasing *iodepth* beyond 1 will not affect synchronous ioengines (except
-	for small degress when :option:`verify_async` is in use).  Even async
+	for small degrees when :option:`verify_async` is in use).  Even async
 	engines may impose OS restrictions causing the desired depth not to be
 	achieved.  This may happen on Linux when using libaio and not setting
 	:option:`direct` =1, since buffered I/O is not async on that OS.  Keep an
@@ -1925,7 +1925,7 @@ I/O depth
 	The low water mark indicating when to start filling the queue
 	again. Defaults to the same as :option:`iodepth`, meaning that fio will
 	attempt to keep the queue full at all times.  If :option:`iodepth` is set to
-	eg 16 and *iodepth_low* is set to 4, then after fio has filled the queue of
+	e.g. 16 and *iodepth_low* is set to 4, then after fio has filled the queue of
 	16 requests, it will let the depth drain down to 4 before starting to fill
 	it again.
 
@@ -1945,13 +1945,13 @@ I/O depth
 I/O rate
 ~~~~~~~~
 
-.. option:: thinktime=int
+.. option:: thinktime=time
 
 	Stall the job x microseconds after an I/O has completed before issuing the
 	next. May be used to simulate processing being done by an application. See
 	:option:`thinktime_blocks` and :option:`thinktime_spin`.
 
-.. option:: thinktime_spin=int
+.. option:: thinktime_spin=time
 
 	Only valid if :option:`thinktime` is set - pretend to spend CPU time doing
 	something with the data received, before falling back to sleeping for the
@@ -1997,7 +1997,7 @@ I/O rate
 
 	This option controls how fio manages rated I/O submissions. The default is
 	`linear`, which submits I/O in a linear fashion with fixed delays between
-	IOs that gets adjusted based on I/O completion rates. If this is set to
+	I/Os that gets adjusted based on I/O completion rates. If this is set to
 	`poisson`, fio will submit I/O based on a more real world random request
 	flow, known as the Poisson process
 	(https://en.wikipedia.org/wiki/Poisson_point_process). The lambda will be
@@ -2007,14 +2007,14 @@ I/O rate
 I/O latency
 ~~~~~~~~~~~
 
-.. option:: latency_target=int
+.. option:: latency_target=time
 
 	If set, fio will attempt to find the max performance point that the given
 	workload will run at while maintaining a latency below this target. The
 	values is given in microseconds.  See :option:`latency_window` and
 	:option:`latency_percentile`.
 
-.. option:: latency_window=int
+.. option:: latency_window=time
 
 	Used with :option:`latency_target` to specify the sample window that the job
 	is run at varying queue depths to test the performance. The value is given
@@ -2022,12 +2022,12 @@ I/O latency
 
 .. option:: latency_percentile=float
 
-	The percentage of IOs that must fall within the criteria specified by
+	The percentage of I/Os that must fall within the criteria specified by
 	:option:`latency_target` and :option:`latency_window`. If not set, this
-	defaults to 100.0, meaning that all IOs must be equal or below to the value
+	defaults to 100.0, meaning that all I/Os must be equal or below to the value
 	set by :option:`latency_target`.
 
-.. option:: max_latency=int
+.. option:: max_latency=time
 
 	If set, fio will exit the job if it exceeds this maximum latency. It will
 	exit with an ETIME error.
@@ -2611,7 +2611,7 @@ Measurements and reporting
 
 	Same as :option:`log_avg_msec`, but logs entries for completion latency
 	histograms. Computing latency percentiles from averages of intervals using
-	:option:`log_avg_msec` is innacurate. Setting this option makes fio log
+	:option:`log_avg_msec` is inaccurate. Setting this option makes fio log
 	histogram entries over the specified period of time, reducing log sizes for
 	high IOPS devices while retaining percentile accuracy.  See
 	:option:`log_hist_coarseness` as well. Defaults to 0, meaning histogram
@@ -2883,7 +2883,7 @@ denote:
 		Average bandwidth rate.
 
 **iops**
-		Average IOs performed per second.
+		Average I/Os performed per second.
 
 **runt**
 		The runtime of that thread.
@@ -2926,8 +2926,8 @@ denote:
 
 **IO submit**
 		How many pieces of I/O were submitting in a single submit call. Each
-		entry denotes that amount and below, until the previous entry -- eg,
-		8=100% mean that we submitted anywhere in between 5-8 IOs per submit
+		entry denotes that amount and below, until the previous entry -- e.g.,
+		8=100% mean that we submitted anywhere in between 5-8 I/Os per submit
 		call.
 
 **IO complete**
@@ -2975,7 +2975,7 @@ Each value is printed for both reads and writes, with reads first. The
 numbers denote:
 
 **ios**
-		Number of ios performed by all groups.
+		Number of I/Os performed by all groups.
 **merge**
 		Number of merges I/O the I/O scheduler.
 **ticks**
@@ -3279,7 +3279,7 @@ particular I/O. The logging of the offset can be toggled with
 :option:`log_offset`.
 
 If windowed logging is enabled through :option:`log_avg_msec` then fio doesn't
-log individual IOs. Instead of logs the average values over the specified period
+log individual I/Os. Instead of logs the average values over the specified period
 of time. Since 'data direction' and 'offset' are per-I/O values, they aren't
 applicable if windowed logging is enabled. If windowed logging is enabled and
 :option:`log_max_value` is set, then fio logs maximum values in that window
diff --git a/README b/README
index 8f5385e..9493c2a 100644
--- a/README
+++ b/README
@@ -92,16 +92,17 @@ Binary packages
 
 Debian:
 	Starting with Debian "Squeeze", fio packages are part of the official
-	Debian repository. http://packages.debian.org/search?keywords=fio.
+	Debian repository. http://packages.debian.org/search?keywords=fio .
 
 Ubuntu:
 	Starting with Ubuntu 10.04 LTS (aka "Lucid Lynx"), fio packages are part
 	of the Ubuntu "universe" repository.
-	http://packages.ubuntu.com/search?keywords=fio.
+	http://packages.ubuntu.com/search?keywords=fio .
 
-Red Hat, CentOS & Co:
-	Dag Wie��rs has RPMs for Red Hat related distros, find them here:
-	http://dag.wieers.com/rpm/packages/fio/.
+Red Hat, Fedora, CentOS & Co:
+	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
+	packages are part of the Fedora/EPEL repositories.
+	https://admin.fedoraproject.org/pkgdb/package/rpms/fio/ .
 
 Mandriva:
 	Mandriva has integrated fio into their package repository, so installing
diff --git a/options.c b/options.c
index 713112f..1fa99b6 100644
--- a/options.c
+++ b/options.c
@@ -2235,7 +2235,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			  },
 			  { .ival = "gauss",
 			    .oval = FIO_FSERVICE_GAUSS,
-			    .help = "Normal (gaussian) distribution",
+			    .help = "Normal (Gaussian) distribution",
 			  },
 			  { .ival = "roundrobin",
 			    .oval = FIO_FSERVICE_RR,
