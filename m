Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44310 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbdAaNAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 Jan 2017 08:00:16 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cYY2c-0002dk-7i
        for fio@vger.kernel.org; Tue, 31 Jan 2017 13:00:10 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170131130002.7D13E2C016D@kernel.dk>
Date: Tue, 31 Jan 2017 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c60ebc45bccb8603a360f88c494ecca40a7becef:

  doc: minor consistency and spelling changes (2017-01-27 09:44:05 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f75ede1d8fe9a255be06f1bf0bde4b99b75acef9:

  doc: document profiles, minor fixes (2017-01-30 13:25:52 +0000)

----------------------------------------------------------------
Sitsofe Wheeler (1):
      doc: document profiles, minor fixes

 HOWTO | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 110 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e917e77..295dc10 100644
--- a/HOWTO
+++ b/HOWTO
@@ -643,9 +643,10 @@ Time related parameters
 
 .. option:: runtime=time
 
-	Tell fio to terminate processing after the specified number of seconds. It
+	Tell fio to terminate processing after the specified period of time.  It
 	can be quite hard to determine for how long a specified job will run, so
-	this parameter is handy to cap the total runtime to a given time.
+	this parameter is handy to cap the total runtime to a given time.  When
+	the unit is omitted, the value is given in seconds.
 
 .. option:: time_based
 
@@ -667,7 +668,8 @@ Time related parameters
 	before logging results, thus minimizing the runtime required for stable
 	results. Note that the ``ramp_time`` is considered lead in time for a job,
 	thus it will increase the total runtime if a special timeout or
-	:option:`runtime` is specified.
+	:option:`runtime` is specified.  When the unit is omitted, the value is
+	given in seconds.
 
 .. option:: clocksource=str
 
@@ -691,7 +693,7 @@ Time related parameters
 .. option:: gtod_reduce=bool
 
 	Enable all of the :manpage:`gettimeofday(2)` reducing options
-	(:option:`disable_clat`, :option:`disable_slat`, :option:`disable_bw`) plus
+	(:option:`disable_clat`, :option:`disable_slat`, :option:`disable_bw_measurement`) plus
 	reduce precision of the timeout somewhat to really shrink the
 	:manpage:`gettimeofday(2)` call count. With this option enabled, we only do
 	about 0.4% of the :manpage:`gettimeofday(2)` calls we would have done if all
@@ -1947,15 +1949,17 @@ I/O rate
 
 .. option:: thinktime=time
 
-	Stall the job x microseconds after an I/O has completed before issuing the
-	next. May be used to simulate processing being done by an application. See
+	Stall the job for the specified period of time after an I/O has completed before issuing the
+	next. May be used to simulate processing being done by an application.
+	When the unit is omitted, the value is given in microseconds.  See
 	:option:`thinktime_blocks` and :option:`thinktime_spin`.
 
 .. option:: thinktime_spin=time
 
 	Only valid if :option:`thinktime` is set - pretend to spend CPU time doing
 	something with the data received, before falling back to sleeping for the
-	rest of the period specified by :option:`thinktime`.
+	rest of the period specified by :option:`thinktime`.  When the unit is
+	omitted, the value is given in microseconds.
 
 .. option:: thinktime_blocks=int
 
@@ -2010,15 +2014,15 @@ I/O latency
 .. option:: latency_target=time
 
 	If set, fio will attempt to find the max performance point that the given
-	workload will run at while maintaining a latency below this target. The
-	values is given in microseconds.  See :option:`latency_window` and
-	:option:`latency_percentile`.
+	workload will run at while maintaining a latency below this target.  When
+	the unit is omitted, the value is given in microseconds.  See
+	:option:`latency_window` and :option:`latency_percentile`.
 
 .. option:: latency_window=time
 
 	Used with :option:`latency_target` to specify the sample window that the job
-	is run at varying queue depths to test the performance. The value is given
-	in microseconds.
+	is run at varying queue depths to test the performance.  When the unit is
+	omitted, the value is given in microseconds.
 
 .. option:: latency_percentile=float
 
@@ -2029,8 +2033,9 @@ I/O latency
 
 .. option:: max_latency=time
 
-	If set, fio will exit the job if it exceeds this maximum latency. It will
-	exit with an ETIME error.
+	If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
+	maximum latency. When the unit is omitted, the value is given in
+	microseconds.
 
 .. option:: rate_cycle=int
 
@@ -2520,13 +2525,14 @@ Steady state
 
 	A rolling window of this duration will be used to judge whether steady state
 	has been reached. Data will be collected once per second. The default is 0
-	which disables steady state detection.
+	which disables steady state detection.  When the unit is omitted, the
+	value is given in seconds.
 
 .. option:: steadystate_ramp_time=time, ss_ramp=time
 
 	Allow the job to run for the specified duration before beginning data
 	collection for checking the steady state job termination criterion. The
-	default is 0.
+	default is 0.  When the unit is omitted, the value is given in seconds.
 
 
 Measurements and reporting
@@ -2697,7 +2703,7 @@ Measurements and reporting
 	the number of calls to :manpage:`gettimeofday(2)`, as that does impact
 	performance at really high IOPS rates.  Note that to really get rid of a
 	large amount of these calls, this option must be used with
-	:option:`disable_slat` and :option:`disable_bw` as well.
+	:option:`disable_slat` and :option:`disable_bw_measurement` as well.
 
 .. option:: disable_clat=bool
 
@@ -2709,7 +2715,7 @@ Measurements and reporting
 	Disable measurements of submission latency numbers. See
 	:option:`disable_slat`.
 
-.. option:: disable_bw=bool
+.. option:: disable_bw_measurement=bool, disable_bw=bool
 
 	Disable measurements of throughput/bandwidth numbers. See
 	:option:`disable_lat`.
@@ -2790,6 +2796,92 @@ Error handling
 	If set dump every error even if it is non fatal, true by default. If
 	disabled only fatal error will be dumped.
 
+Running predefined workloads
+----------------------------
+
+Fio includes predefined profiles that mimic the I/O workloads generated by
+other tools.
+
+.. option:: profile=str
+
+	The predefined workload to run.  Current profiles are:
+
+		**tiobench**
+			Threaded I/O bench (tiotest/tiobench) like workload.
+
+		**act**
+			Aerospike Certification Tool (ACT) like workload.
+
+To view a profile's additional options use :option:`--cmdhelp` after specifying
+the profile.  For example::
+
+$ fio --profile=act --cmdhelp
+
+Act profile options
+~~~~~~~~~~~~~~~~~~~
+
+.. option:: device-names=str
+	:noindex:
+
+	Devices to use.
+
+.. option:: load=int
+	:noindex:
+
+	ACT load multiplier.  Default: 1.
+
+.. option:: test-duration=time
+	:noindex:
+
+	How long the entire test takes to run.  Default: 24h.
+
+.. option:: threads-per-queue=int
+	:noindex:
+
+	Number of read IO threads per device.  Default: 8.
+
+.. option:: read-req-num-512-blocks=int
+	:noindex:
+
+	Number of 512B blocks to read at the time.  Default: 3.
+
+.. option:: large-block-op-kbytes=int
+	:noindex:
+
+	Size of large block ops in KiB (writes).  Default: 131072.
+
+.. option:: prep
+	:noindex:
+
+	Set to run ACT prep phase.
+
+Tiobench profile options
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+.. option:: size=str
+	:noindex:
+
+	Size in MiB
+
+.. option:: block=int
+	:noindex:
+
+	Block size in bytes.  Default: 4096.
+
+.. option:: numruns=int
+	:noindex:
+
+	Number of runs.
+
+.. option:: dir=str
+	:noindex:
+
+	Test directory.
+
+.. option:: threads=int
+	:noindex:
+
+	Number of threads.
 
 Interpreting the output
 -----------------------
