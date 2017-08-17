Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51326 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdHQMAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 17 Aug 2017 08:00:12 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1diJT9-0006MS-5W
        for fio@vger.kernel.org; Thu, 17 Aug 2017 12:00:11 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170817120001.DCA102C2FF1@kernel.dk>
Date: Thu, 17 Aug 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 29092211c1f926541db0e2863badc03d7378b31a:

  HOWTO: update and clarify description of latencies in normal output (2017-08-14 13:02:49 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bdadbb83ba3611a09888600830b8539bf3d19794:

  Fio 3.0 (2017-08-16 14:12:33 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      printing: use bigger on-stack buffer
      gfio: update copyright
      Fio 3.0

Tomohiro Kusumi (5):
      man: sync "JOB PARAMETERS" section with HOWTO
      man: sync "OUTPUT" section and after with HOWTO
      man: minor fixes for sections before "JOB PARAMETERS" for consistency
      HOWTO: minor fixes and backports from man page
      HOWTO: fix wrong kb_base= description

Vincent Fu (1):
      man: update description of normal output latencies

 FIO-VERSION-GEN        |    2 +-
 HOWTO                  |  213 ++-
 fio.1                  | 4300 ++++++++++++++++++++++++++++--------------------
 gfio.c                 |    2 +-
 os/windows/install.wxs |    2 +-
 printing.c             |    2 +-
 6 files changed, 2579 insertions(+), 1942 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index f82aeee..31acf1c 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.99
+DEF_VER=fio-3.0
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 71d9fa5..16ae708 100644
--- a/HOWTO
+++ b/HOWTO
@@ -54,7 +54,7 @@ Command line options
 
 .. option:: --debug=type
 
-	Enable verbose tracing of various fio actions.  May be ``all`` for all types
+	Enable verbose tracing `type` of various fio actions.  May be ``all`` for all types
 	or individual types separated by a comma (e.g. ``--debug=file,mem`` will
 	enable file and memory debugging).  Currently, additional logging is
 	available for:
@@ -104,9 +104,9 @@ Command line options
 
 	Write output to file `filename`.
 
-.. option:: --output-format=type
+.. option:: --output-format=format
 
-	Set the reporting format to `normal`, `terse`, `json`, or `json+`.  Multiple
+	Set the reporting `format` to `normal`, `terse`, `json`, or `json+`.  Multiple
 	formats can be selected, separated by a comma.  `terse` is a CSV based
 	format.  `json+` is like `json`, except it adds a full dump of the latency
 	buckets.
@@ -128,9 +128,9 @@ Command line options
 	**Deprecated**, use :option:`--output-format` instead to select multiple
 	formats.
 
-.. option:: --terse-version=type
+.. option:: --terse-version=version
 
-	Set terse version output format (default 3, or 2 or 4 or 5).
+	Set terse `version` output format (default 3, or 2 or 4 or 5).
 
 .. option:: --version
 
@@ -156,8 +156,8 @@ Command line options
 
 .. option:: --enghelp=[ioengine[,command]]
 
-	List all commands defined by :option:`ioengine`, or print help for `command`
-	defined by :option:`ioengine`.  If no :option:`ioengine` is given, list all
+	List all commands defined by `ioengine`, or print help for `command`
+	defined by `ioengine`.  If no `ioengine` is given, list all
 	available ioengines.
 
 .. option:: --showcmd=jobfile
@@ -217,7 +217,7 @@ Command line options
 
 .. option:: --max-jobs=nr
 
-	Set the maximum number of threads/processes to support.
+	Set the maximum number of threads/processes to support to `nr`.
 
 .. option:: --server=args
 
@@ -230,12 +230,12 @@ Command line options
 
 .. option:: --client=hostname
 
-	Instead of running the jobs locally, send and run them on the given host or
-	set of hosts.  See `Client/Server`_ section.
+	Instead of running the jobs locally, send and run them on the given `hostname`
+	or set of `hostname`s.  See `Client/Server`_ section.
 
 .. option:: --remote-config=file
 
-	Tell fio server to load this local file.
+	Tell fio server to load this local `file`.
 
 .. option:: --idle-prof=option
 
@@ -252,27 +252,27 @@ Command line options
 
 .. option:: --inflate-log=log
 
-	Inflate and output compressed log.
+	Inflate and output compressed `log`.
 
 .. option:: --trigger-file=file
 
-	Execute trigger cmd when file exists.
+	Execute trigger command when `file` exists.
 
-.. option:: --trigger-timeout=t
+.. option:: --trigger-timeout=time
 
-	Execute trigger at this time.
+	Execute trigger at this `time`.
 
-.. option:: --trigger=cmd
+.. option:: --trigger=command
 
-	Set this command as local trigger.
+	Set this `command` as local trigger.
 
-.. option:: --trigger-remote=cmd
+.. option:: --trigger-remote=command
 
-	Set this command as remote trigger.
+	Set this `command` as remote trigger.
 
 .. option:: --aux-path=path
 
-	Use this path for fio state generated files.
+	Use this `path` for fio state generated files.
 
 Any parameters following the options will be assumed to be job files, unless
 they match a job file parameter. Multiple job files can be listed and each job
@@ -296,8 +296,8 @@ override a *global* section parameter, and a job file may even have several
 *global* sections if so desired. A job is only affected by a *global* section
 residing above it.
 
-The :option:`--cmdhelp` option also lists all options. If used with an `option`
-argument, :option:`--cmdhelp` will detail the given `option`.
+The :option:`--cmdhelp` option also lists all options. If used with a `command`
+argument, :option:`--cmdhelp` will detail the given `command`.
 
 See the `examples/` directory for inspiration on how to write job files.  Note
 the copyright and license requirements currently apply to `examples/` files.
@@ -505,19 +505,19 @@ Parameter types
 	prefixes.  To specify power-of-10 decimal values defined in the
 	International System of Units (SI):
 
-		* *Ki* -- means kilo (K) or 1000
-		* *Mi* -- means mega (M) or 1000**2
-		* *Gi* -- means giga (G) or 1000**3
-		* *Ti* -- means tera (T) or 1000**4
-		* *Pi* -- means peta (P) or 1000**5
+		* *K* -- means kilo (K) or 1000
+		* *M* -- means mega (M) or 1000**2
+		* *G* -- means giga (G) or 1000**3
+		* *T* -- means tera (T) or 1000**4
+		* *P* -- means peta (P) or 1000**5
 
 	To specify power-of-2 binary values defined in IEC 80000-13:
 
-		* *K* -- means kibi (Ki) or 1024
-		* *M* -- means mebi (Mi) or 1024**2
-		* *G* -- means gibi (Gi) or 1024**3
-		* *T* -- means tebi (Ti) or 1024**4
-		* *P* -- means pebi (Pi) or 1024**5
+		* *Ki* -- means kibi (Ki) or 1024
+		* *Mi* -- means mebi (Mi) or 1024**2
+		* *Gi* -- means gibi (Gi) or 1024**3
+		* *Ti* -- means tebi (Ti) or 1024**4
+		* *Pi* -- means pebi (Pi) or 1024**5
 
 	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
@@ -847,7 +847,7 @@ Target file/device
 
 		**sequential**
 			Finish one file before moving on to the next. Multiple files can
-			still be open depending on 'openfiles'.
+			still be open depending on :option:`openfiles`.
 
 		**zipf**
 			Use a *Zipf* distribution to decide what file to access.
@@ -1167,9 +1167,9 @@ I/O type
 
 	Make every `N-th` write a barrier write.
 
-.. option:: sync_file_range=str:val
+.. option:: sync_file_range=str:int
 
-	Use :manpage:`sync_file_range(2)` for every `val` number of write
+	Use :manpage:`sync_file_range(2)` for every `int` number of write
 	operations. Fio will track range of writes that have happened since the last
 	:manpage:`sync_file_range(2)` call. `str` can currently be one or more of:
 
@@ -1239,9 +1239,9 @@ I/O type
 				Zoned random distribution
 
 	When using a **zipf** or **pareto** distribution, an input value is also
-	needed to define the access pattern. For **zipf**, this is the `zipf
+	needed to define the access pattern. For **zipf**, this is the `Zipf
 	theta`. For **pareto**, it's the `Pareto power`. Fio includes a test
-	program, :command:`genzipf`, that can be used visualize what the given input
+	program, :command:`fio-genzipf`, that can be used visualize what the given input
 	values will yield in terms of hit rates.  If you wanted to use **zipf** with
 	a `theta` of 1.2, you would use ``random_distribution=zipf:1.2`` as the
 	option. If a non-uniform model is used, fio will disable use of the random
@@ -1252,10 +1252,10 @@ I/O type
 	access that should fall within what range of the file or device. For
 	example, given a criteria of:
 
-	* 60% of accesses should be to the first 10%
-	* 30% of accesses should be to the next 20%
-	* 8% of accesses should be to the next 30%
-	* 2% of accesses should be to the next 40%
+		* 60% of accesses should be to the first 10%
+		* 30% of accesses should be to the next 20%
+		* 8% of accesses should be to the next 30%
+		* 2% of accesses should be to the next 40%
 
 	we can define that through zoning of the random accesses. For the above
 	example, the user would do::
@@ -1295,21 +1295,20 @@ I/O type
 
 .. option:: random_generator=str
 
-	Fio supports the following engines for generating
-	I/O offsets for random I/O:
+	Fio supports the following engines for generating I/O offsets for random I/O:
 
 		**tausworthe**
-			Strong 2^88 cycle random number generator
+			Strong 2^88 cycle random number generator.
 		**lfsr**
-			Linear feedback shift register generator
+			Linear feedback shift register generator.
 		**tausworthe64**
-			Strong 64-bit 2^258 cycle random number generator
+			Strong 64-bit 2^258 cycle random number generator.
 
 	**tausworthe** is a strong random number generator, but it requires tracking
 	on the side if we want to ensure that blocks are only read or written
-	once. **LFSR** guarantees that we never generate the same offset twice, and
+	once. **lfsr** guarantees that we never generate the same offset twice, and
 	it's also less computationally expensive. It's not a true random generator,
-	however, though for I/O purposes it's typically good enough. **LFSR** only
+	however, though for I/O purposes it's typically good enough. **lfsr** only
 	works with single block sizes, not with workloads that use multiple block
 	sizes. If used with such a workload, fio may read or write some blocks
 	multiple times. The default value is **tausworthe**, unless the required
@@ -1529,7 +1528,7 @@ Buffers and memory
 
 		**cudamalloc**
 			Use GPU memory as the buffers for GPUDirect RDMA benchmark.
-			The ioengine must be rdma.
+			The :option:`ioengine` must be `rdma`.
 
 	The area allocated is a function of the maximum allowed bs size for the job,
 	multiplied by the I/O depth given. Note that for **shmhuge** and
@@ -1548,7 +1547,7 @@ Buffers and memory
 	should point there. So if it's mounted in :file:`/huge`, you would use
 	`mem=mmaphuge:/huge/somefile`.
 
-.. option:: iomem_align=int
+.. option:: iomem_align=int, mem_align=int
 
 	This indicates the memory alignment of the I/O memory buffers.  Note that
 	the given alignment is applied to the first I/O unit buffer, if using
@@ -1683,8 +1682,8 @@ I/O engine
 			SCSI generic sg v3 I/O. May either be synchronous using the SG_IO
 			ioctl, or if the target is an sg character device we use
 			:manpage:`read(2)` and :manpage:`write(2)` for asynchronous
-			I/O. Requires filename option to specify either block or character
-			devices.
+			I/O. Requires :option:`filename` option to specify either block or
+			character devices.
 
 		**null**
 			Doesn't transfer any data, just pretends to.  This is mainly used to
@@ -1707,8 +1706,8 @@ I/O engine
 			Doesn't transfer any data, but burns CPU cycles according to the
 			:option:`cpuload` and :option:`cpuchunks` options. Setting
 			:option:`cpuload`\=85 will cause that job to do nothing but burn 85%
-			of the CPU. In case of SMP machines, use :option:`numjobs`
-			=<no_of_cpu> to get desired CPU usage, as the cpuload only loads a
+			of the CPU. In case of SMP machines, use :option:`numjobs`=<nr_of_cpu>
+			to get desired CPU usage, as the cpuload only loads a
 			single CPU at the desired rate. A job never finishes unless there is
 			at least one non-cpuio job.
 
@@ -1741,7 +1740,7 @@ I/O engine
 		**ftruncate**
 			I/O engine that sends :manpage:`ftruncate(2)` operations in response
 			to write (DDIR_WRITE) events. Each ftruncate issued sets the file's
-			size to the current block offset. Block size is ignored.
+			size to the current block offset. :option:`blocksize` is ignored.
 
 		**e4defrag**
 			I/O engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
@@ -1763,7 +1762,7 @@ I/O engine
 			defines engine specific options.
 
 		**libhdfs**
-			Read and write through Hadoop (HDFS).  The :file:`filename` option
+			Read and write through Hadoop (HDFS).  The :option:`filename` option
 			is used to specify host,port of the hdfs name-node to connect.  This
 			engine interprets offsets a little differently.  In HDFS, files once
 			created cannot be modified so random writes are not possible. To
@@ -1802,8 +1801,8 @@ I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 In addition, there are some parameters which are only valid when a specific
-ioengine is in use. These are used identically to normal parameters, with the
-caveat that when used on the command line, they must come after the
+:option:`ioengine` is in use. These are used identically to normal parameters,
+with the caveat that when used on the command line, they must come after the
 :option:`ioengine` that defines them is selected.
 
 .. option:: userspace_reap : [libaio]
@@ -1821,7 +1820,7 @@ caveat that when used on the command line, they must come after the
 
 .. option:: hipri_percentage : [pvsync2]
 
-	When hipri is set this determines the probability of a pvsync2 IO being high
+	When hipri is set this determines the probability of a pvsync2 I/O being high
 	priority. The default is 100%.
 
 .. option:: cpuload=int : [cpuio]
@@ -1837,18 +1836,16 @@ caveat that when used on the command line, they must come after the
 
 	Detect when I/O threads are done, then exit.
 
-.. option:: hostname=str : [netsplice] [net]
-
-	The hostname or IP address to use for TCP or UDP based I/O.  If the job is
-	a TCP listener or UDP reader, the hostname is not used and must be omitted
-	unless it is a valid UDP multicast address.
-
 .. option:: namenode=str : [libhdfs]
 
 	The hostname or IP address of a HDFS cluster namenode to contact.
 
 .. option:: port=int
 
+   [libhdfs]
+
+		The listening port of the HFDS cluster namenode.
+
    [netsplice], [net]
 
 		The TCP or UDP port to bind to or connect to. If this is used with
@@ -1856,9 +1853,11 @@ caveat that when used on the command line, they must come after the
 		this will be the starting port number since fio will use a range of
 		ports.
 
-   [libhdfs]
+.. option:: hostname=str : [netsplice] [net]
 
-		The listening port of the HFDS cluster namenode.
+	The hostname or IP address to use for TCP or UDP based I/O.  If the job is
+	a TCP listener or UDP reader, the hostname is not used and must be omitted
+	unless it is a valid UDP multicast address.
 
 .. option:: interface=str : [netsplice] [net]
 
@@ -1873,9 +1872,7 @@ caveat that when used on the command line, they must come after the
 
 	Set TCP_NODELAY on TCP connections.
 
-.. option:: protocol=str : [netsplice] [net]
-
-.. option:: proto=str : [netsplice] [net]
+.. option:: protocol=str, proto=str : [netsplice] [net]
 
 	The network protocol to use. Accepted values are:
 
@@ -1892,7 +1889,7 @@ caveat that when used on the command line, they must come after the
 
 	When the protocol is TCP or UDP, the port must also be given, as well as the
 	hostname if the job is a TCP listener or UDP reader. For unix sockets, the
-	normal filename option should be used and the port is invalid.
+	normal :option:`filename` option should be used and the port is invalid.
 
 .. option:: listen : [netsplice] [net]
 
@@ -2078,10 +2075,10 @@ I/O rate
 .. option:: thinktime_blocks=int
 
 	Only valid if :option:`thinktime` is set - control how many blocks to issue,
-	before waiting `thinktime` usecs. If not set, defaults to 1 which will make
-	fio wait `thinktime` usecs after every block. This effectively makes any
+	before waiting :option:`thinktime` usecs. If not set, defaults to 1 which will make
+	fio wait :option:`thinktime` usecs after every block. This effectively makes any
 	queue depth setting redundant, since no more than 1 I/O will be queued
-	before we have to complete it and do our thinktime. In other words, this
+	before we have to complete it and do our :option:`thinktime`. In other words, this
 	setting effectively caps the queue depth if the latter is larger.
 
 .. option:: rate=int[,int][,int]
@@ -2586,7 +2583,7 @@ Verification
 	state is loaded for the verify read phase. The format of the filename is,
 	roughly::
 
-	<type>-<jobname>-<jobindex>-verify.state.
+		<type>-<jobname>-<jobindex>-verify.state.
 
 	<type> is "local" for a local run, "sock" for a client/server socket
 	connection, and "ip" (192.168.0.1, for instance) for a networked
@@ -2722,8 +2719,8 @@ Measurements and reporting
 		write_lat_log=foo
 
 	The actual log names will be :file:`foo_slat.x.log`, :file:`foo_clat.x.log`,
-	and :file:`foo_lat.x.log`, where `x` is the index of the job (1..N, where N
-	is the number of jobs). This helps :command:`fio_generate_plot` find the
+	and :file:`foo_lat.x.log`, where `x` is the index of the job (`1..N`, where `N`
+	is the number of jobs). This helps :command:`fio_generate_plots` find the
 	logs automatically. If :option:`per_job_logs` is false, then the filename
 	will not include the job index.  See `Log File Formats`_.
 
@@ -2732,7 +2729,7 @@ Measurements and reporting
 	Same as :option:`write_lat_log`, but writes I/O completion latency
 	histograms. If no filename is given with this option, the default filename
 	of :file:`jobname_clat_hist.x.log` is used, where `x` is the index of the
-	job (1..N, where `N` is the number of jobs). Even if the filename is given,
+	job (`1..N`, where `N` is the number of jobs). Even if the filename is given,
 	fio will still append the type of log.  If :option:`per_job_logs` is false,
 	then the filename will not include the job index. See `Log File Formats`_.
 
@@ -2740,7 +2737,7 @@ Measurements and reporting
 
 	Same as :option:`write_bw_log`, but writes IOPS. If no filename is given
 	with this option, the default filename of :file:`jobname_type.x.log` is
-	used,where `x` is the index of the job (1..N, where `N` is the number of
+	used, where `x` is the index of the job (`1..N`, where `N` is the number of
 	jobs). Even if the filename is given, fio will still append the type of
 	log. If :option:`per_job_logs` is false, then the filename will not include
 	the job index. See `Log File Formats`_.
@@ -2855,7 +2852,7 @@ Measurements and reporting
 .. option:: disable_slat=bool
 
 	Disable measurements of submission latency numbers. See
-	:option:`disable_slat`.
+	:option:`disable_lat`.
 
 .. option:: disable_bw_measurement=bool, disable_bw=bool
 
@@ -2959,7 +2956,7 @@ other tools.
 To view a profile's additional options use :option:`--cmdhelp` after specifying
 the profile.  For example::
 
-$ fio --profile=act --cmdhelp
+	$ fio --profile=act --cmdhelp
 
 Act profile options
 ~~~~~~~~~~~~~~~~~~~
@@ -2983,7 +2980,7 @@ Act profile options
 .. option:: threads-per-queue=int
 	:noindex:
 
-	Number of read IO threads per device.  Default: 8.
+	Number of read I/O threads per device.  Default: 8.
 
 .. option:: read-req-num-512-blocks=int
 	:noindex:
@@ -3006,7 +3003,7 @@ Tiobench profile options
 .. option:: size=str
 	:noindex:
 
-	Size in MiB
+	Size in MiB.
 
 .. option:: block=int
 	:noindex:
@@ -3109,9 +3106,9 @@ are readers and 11--20 are writers.
 The other values are fairly self explanatory -- number of threads currently
 running and doing I/O, the number of currently open files (f=), the estimated
 completion percentage, the rate of I/O since last check (read speed listed first,
-then write speed and optionally trim speed) in terms of bandwidth and IOPS, and time to completion for the current
-running group. It's impossible to estimate runtime of the following groups (if
-any).
+then write speed and optionally trim speed) in terms of bandwidth and IOPS,
+and time to completion for the current running group. It's impossible to estimate
+runtime of the following groups (if any).
 
 ..
 	Example output was based on the following:
@@ -3261,7 +3258,7 @@ For each data direction it prints:
 **run**
 		The smallest and longest runtimes of the threads in this group.
 
-And finally, the disk statistics are printed. They will look like this::
+And finally, the disk statistics are printed. This is Linux specific. They will look like this::
 
   Disk stats (read/write):
     sda: ios=16398/16511, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
@@ -3312,7 +3309,7 @@ field was introduced or whether it's specific to some terse version):
 
     ::
 
-	terse version, fio version [v3], jobname, groupid, error
+        terse version, fio version [v3], jobname, groupid, error
 
     READ status::
 
@@ -3321,8 +3318,8 @@ field was introduced or whether it's specific to some terse version):
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
-	IOPS [v5]: min, max, mean, stdev, number of samples
+        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+        IOPS [v5]: min, max, mean, stdev, number of samples
 
     WRITE status:
 
@@ -3333,12 +3330,12 @@ field was introduced or whether it's specific to some terse version):
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
-	IOPS [v5]: min, max, mean, stdev, number of samples
+        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+        IOPS [v5]: min, max, mean, stdev, number of samples
 
     TRIM status [all but version 3]:
 
-	Fields are similar to READ/WRITE status.
+        Fields are similar to READ/WRITE status.
 
     CPU usage::
 
@@ -3358,10 +3355,8 @@ field was introduced or whether it's specific to some terse version):
 
     Disk utilization [v3]::
 
-        Disk name, Read ios, write ios,
-        Read merges, write merges,
-        Read ticks, write ticks,
-        Time spent in queue, disk utilization percentage
+        disk name, read ios, write ios, read merges, write merges, read ticks, write ticks,
+        time spent in queue, disk utilization percentage
 
     Additional Info (dependent on continue_on_error, default off)::
 
@@ -3374,17 +3369,17 @@ field was introduced or whether it's specific to some terse version):
 Completion latency percentiles can be a grouping of up to 20 sets, so for the
 terse output fio writes all of them. Each field will look like this::
 
-	1.00%=6112
+        1.00%=6112
 
 which is the Xth percentile, and the `usec` latency associated with it.
 
-For disk utilization, all disks used by fio are shown. So for each disk there
+For `Disk utilization`, all disks used by fio are shown. So for each disk there
 will be a disk utilization section.
 
 Below is a single line containing short names for each of the fields in the
 minimal output v3, separated by semicolons::
 
-	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10
 ;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+        terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_cla
 t_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
 JSON+ output
@@ -3405,7 +3400,7 @@ Also included with fio is a Python script `fio_jsonplus_clat2csv` that takes
 json+ output and generates CSV-formatted latency data suitable for plotting.
 
 The latency durations actually represent the midpoints of latency intervals.
-For details refer to stat.h.
+For details refer to :file:`stat.h`.
 
 
 Trace file format
@@ -3425,7 +3420,7 @@ Each line represents a single I/O action in the following format::
 
 	rw, offset, length
 
-where `rw=0/1` for read/write, and the offset and length entries being in bytes.
+where `rw=0/1` for read/write, and the `offset` and `length` entries being in bytes.
 
 This format is not supported in fio versions >= 1.20-rc3.
 
@@ -3447,15 +3442,15 @@ The file management format::
 
     filename action
 
-The filename is given as an absolute path. The action can be one of these:
+The `filename` is given as an absolute path. The `action` can be one of these:
 
 **add**
-		Add the given filename to the trace.
+		Add the given `filename` to the trace.
 **open**
-		Open the file with the given filename. The filename has to have
+		Open the file with the given `filename`. The `filename` has to have
 		been added with the **add** action before.
 **close**
-		Close the file with the given filename. The file has to have been
+		Close the file with the given `filename`. The file has to have been
 		opened before.
 
 
@@ -3538,8 +3533,8 @@ will then execute the trigger.
 Verification trigger example
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-Let's say we want to run a powercut test on the remote machine 'server'.  Our
-write workload is in :file:`write-test.fio`. We want to cut power to 'server' at
+Let's say we want to run a powercut test on the remote Linux machine 'server'.
+Our write workload is in :file:`write-test.fio`. We want to cut power to 'server' at
 some point during the run, and we'll run this test from the safety or our local
 machine, 'localbox'. On the server, we'll start the fio backend normally::
 
@@ -3626,7 +3621,7 @@ Under Test" while being controlled by a client on another machine.
 
 Start the server on the machine which has access to the storage DUT::
 
-	fio --server=args
+	$ fio --server=args
 
 where `args` defines what fio listens to. The arguments are of the form
 ``type,hostname`` or ``IP,port``. *type* is either ``ip`` (or ip4) for TCP/IP
diff --git a/fio.1 b/fio.1
index 14359e6..792bc9d 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "July 2017" "User Manual"
+.TH fio 1 "August 2017" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
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
-Ki means kilo (K) or 1000
-.RE
-.RS
-Mi means mega (M) or 1000**2
-.RE
-.RS
-Gi means giga (G) or 1000**3
-.RE
-.RS
-Ti means tera (T) or 1000**4
-.RE
-.RS
-Pi means peta (P) or 1000**5
-.RE
+.PD 0
+K means kilo (K) or 1000
 .P
-To specify power-of-2 binary values defined in IEC 80000-13:
-.RS
+M means mega (M) or 1000**2
 .P
-K means kibi (Ki) or 1024
-.RE
-.RS
-M means mebi (Mi) or 1024**2
-.RE
-.RS
-G means gibi (Gi) or 1024**3
-.RE
-.RS
-T means tebi (Ti) or 1024**4
+G means giga (G) or 1000**3
+.P
+T means tera (T) or 1000**4
+.P
+P means peta (P) or 1000**5
+.PD
 .RE
+.P
+To specify power\-of\-2 binary values defined in IEC 80000\-13:
 .RS
-P means pebi (Pi) or 1024**5
+.P
+.PD 0
+Ki means kibi (Ki) or 1024
+.P
+Mi means mebi (Mi) or 1024**2
+.P
+Gi means gibi (Gi) or 1024**3
+.P
+Ti means tebi (Ti) or 1024**4
+.P
+Pi means pebi (Pi) or 1024**5
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
@@ -354,63 +344,219 @@ true and false (1 and 0).
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
-.SH "JOB DESCRIPTION"
+.SH "JOB PARAMETERS"
 With the above in mind, here follows the complete list of fio job parameters.
+.SS "Units"
 .TP
-.BI name \fR=\fPstr
-May be used to override the job name.  On the command line, this parameter
-has the special purpose of signalling the start of a new job.
+.BI kb_base \fR=\fPint
+Select the interpretation of unit prefixes in input parameters.
+.RS
+.RS
 .TP
-.BI wait_for \fR=\fPstr
-Specifies the name of the already defined job to wait for. Single waitee name
-only may be specified. If set, the job won't be started until all workers of
-the waitee job are done.  Wait_for operates on the job name basis, so there are
-a few limitations. First, the waitee must be defined prior to the waiter job
-(meaning no forward references). Second, if a job is being referenced as a
-waitee, it must have a unique name (no duplicate waitees).
+.B 1000
+Inputs comply with IEC 80000\-13 and the International
+System of Units (SI). Use:
+.RS
+.P
+.PD 0
+\- power\-of\-2 values with IEC prefixes (e.g., KiB)
+.P
+\- power\-of\-10 values with SI prefixes (e.g., kB)
+.PD
+.RE
+.TP
+.B 1024
+Compatibility mode (default). To avoid breaking old scripts:
+.P
+.RS
+.PD 0
+\- power\-of\-2 values with SI prefixes
+.P
+\- power\-of\-10 values with IEC prefixes
+.PD
+.RE
+.RE
+.P
+See \fBbs\fR for more details on input parameters.
+.P
+Outputs always use correct prefixes. Most outputs include both
+side\-by\-side, like:
+.P
+.RS
+bw=2383.3kB/s (2327.4KiB/s)
+.RE
+.P
+If only one value is reported, then kb_base selects the one to use:
+.P
+.RS
+.PD 0
+1000 \-\- SI prefixes
+.P
+1024 \-\- IEC prefixes
+.PD
+.RE
+.RE
+.TP
+.BI unit_base \fR=\fPint
+Base unit for reporting. Allowed values are:
+.RS
+.RS
+.TP
+.B 0
+Use auto\-detection (default).
+.TP
+.B 8
+Byte based.
+.TP
+.B 1
+Bit based.
+.RE
+.RE
+.SS "Job description"
+.TP
+.BI name \fR=\fPstr
+ASCII name of the job. This may be used to override the name printed by fio
+for this job. Otherwise the job name is used. On the command line this
+parameter has the special purpose of also signaling the start of a new job.
 .TP
 .BI description \fR=\fPstr
-Human-readable description of the job. It is printed when the job is run, but
-otherwise has no special purpose.
+Text description of the job. Doesn't do anything except dump this text
+description when this job is run. It's not parsed.
+.TP
+.BI loops \fR=\fPint
+Run the specified number of iterations of this job. Used to repeat the same
+workload a given number of times. Defaults to 1.
+.TP
+.BI numjobs \fR=\fPint
+Create the specified number of clones of this job. Each clone of job
+is spawned as an independent thread or process. May be used to setup a
+larger number of threads/processes doing the same thing. Each thread is
+reported separately; to see statistics for all clones as a whole, use
+\fBgroup_reporting\fR in conjunction with \fBnew_group\fR.
+See \fB\-\-max\-jobs\fR. Default: 1.
+.SS "Time related parameters"
+.TP
+.BI runtime \fR=\fPtime
+Tell fio to terminate processing after the specified period of time. It
+can be quite hard to determine for how long a specified job will run, so
+this parameter is handy to cap the total runtime to a given time. When
+the unit is omitted, the value is intepreted in seconds.
+.TP
+.BI time_based
+If set, fio will run for the duration of the \fBruntime\fR specified
+even if the file(s) are completely read or written. It will simply loop over
+the same workload as many times as the \fBruntime\fR allows.
+.TP
+.BI startdelay \fR=\fPirange(int)
+Delay the start of job for the specified amount of time. Can be a single
+value or a range. When given as a range, each thread will choose a value
+randomly from within the range. Value is in seconds if a unit is omitted.
+.TP
+.BI ramp_time \fR=\fPtime
+If set, fio will run the specified workload for this amount of time before
+logging any performance numbers. Useful for letting performance settle
+before logging results, thus minimizing the runtime required for stable
+results. Note that the \fBramp_time\fR is considered lead in time for a job,
+thus it will increase the total runtime if a special timeout or
+\fBruntime\fR is specified. When the unit is omitted, the value is
+given in seconds.
+.TP
+.BI clocksource \fR=\fPstr
+Use the given clocksource as the base of timing. The supported options are:
+.RS
+.RS
+.TP
+.B gettimeofday
+\fBgettimeofday\fR\|(2)
+.TP
+.B clock_gettime
+\fBclock_gettime\fR\|(2)
+.TP
+.B cpu
+Internal CPU clock source
+.RE
+.P
+\fBcpu\fR is the preferred clocksource if it is reliable, as it is very fast (and
+fio is heavy on time calls). Fio will automatically use this clocksource if
+it's supported and considered reliable on the system it is running on,
+unless another clocksource is specifically set. For x86/x86\-64 CPUs, this
+means supporting TSC Invariant.
+.RE
+.TP
+.BI gtod_reduce \fR=\fPbool
+Enable all of the \fBgettimeofday\fR\|(2) reducing options
+(\fBdisable_clat\fR, \fBdisable_slat\fR, \fBdisable_bw_measurement\fR) plus
+reduce precision of the timeout somewhat to really shrink the
+\fBgettimeofday\fR\|(2) call count. With this option enabled, we only do
+about 0.4% of the \fBgettimeofday\fR\|(2) calls we would have done if all
+time keeping was enabled.
+.TP
+.BI gtod_cpu \fR=\fPint
+Sometimes it's cheaper to dedicate a single thread of execution to just
+getting the current time. Fio (and databases, for instance) are very
+intensive on \fBgettimeofday\fR\|(2) calls. With this option, you can set
+one CPU aside for doing nothing but logging current time to a shared memory
+location. Then the other threads/processes that run I/O workloads need only
+copy that segment, instead of entering the kernel with a
+\fBgettimeofday\fR\|(2) call. The CPU set aside for doing these time
+calls will be excluded from other uses. Fio will manually clear it from the
+CPU mask of other jobs.
+.SS "Target file/device"
 .TP
 .BI directory \fR=\fPstr
-Prefix filenames with this directory.  Used to place files in a location other
-than `./'.
-You can specify a number of directories by separating the names with a ':'
-character. These directories will be assigned equally distributed to job clones
-creates with \fInumjobs\fR as long as they are using generated filenames.
-If specific \fIfilename(s)\fR are set fio will use the first listed directory,
-and thereby matching the  \fIfilename\fR semantic which generates a file each
-clone if not specified, but let all clones use the same if set. See
-\fIfilename\fR for considerations regarding escaping certain characters on
-some platforms.
+Prefix \fBfilename\fRs with this directory. Used to place files in a different
+location than `./'. You can specify a number of directories by
+separating the names with a ':' character. These directories will be
+assigned equally distributed to job clones created by \fBnumjobs\fR as
+long as they are using generated filenames. If specific \fBfilename\fR(s) are
+set fio will use the first listed directory, and thereby matching the
+\fBfilename\fR semantic which generates a file each clone if not specified, but
+let all clones use the same if set.
+.RS
+.P
+See the \fBfilename\fR option for information on how to escape ':' and '\'
+characters within the directory path itself.
+.RE
 .TP
 .BI filename \fR=\fPstr
-.B fio
-normally makes up a file name based on the job name, thread number, and file
-number. If you want to share files between threads in a job or several jobs,
-specify a \fIfilename\fR for each of them to override the default.
-If the I/O engine is file-based, you can specify
-a number of files by separating the names with a `:' character. `\-' is a
-reserved name, meaning stdin or stdout, depending on the read/write direction
-set. On Windows, disk devices are accessed as \\.\PhysicalDrive0 for the first
-device, \\.\PhysicalDrive1 for the second etc. Note: Windows and FreeBSD
-prevent write access to areas of the disk containing in-use data
-(e.g. filesystems). If the wanted filename does need to include a colon, then
-escape that with a '\\' character. For instance, if the filename is
-"/dev/dsk/foo@3,0:c", then you would use filename="/dev/dsk/foo@3,0\\:c".
+Fio normally makes up a \fBfilename\fR based on the job name, thread number, and
+file number (see \fBfilename_format\fR). If you want to share files
+between threads in a job or several
+jobs with fixed file paths, specify a \fBfilename\fR for each of them to override
+the default. If the ioengine is file based, you can specify a number of files
+by separating the names with a ':' colon. So if you wanted a job to open
+`/dev/sda' and `/dev/sdb' as the two working files, you would use
+`filename=/dev/sda:/dev/sdb'. This also means that whenever this option is
+specified, \fBnrfiles\fR is ignored. The size of regular files specified
+by this option will be \fBsize\fR divided by number of files unless an
+explicit size is specified by \fBfilesize\fR.
+.RS
+.P
+Each colon and backslash in the wanted path must be escaped with a '\'
+character. For instance, if the path is `/dev/dsk/foo@3,0:c' then you
+would use `filename=/dev/dsk/foo@3,0\\:c' and if the path is
+`F:\\\\filename' then you would use `filename=F\\:\\\\filename'.
+.P
+On Windows, disk devices are accessed as `\\\\\\\\.\\\\PhysicalDrive0' for
+the first device, `\\\\\\\\.\\\\PhysicalDrive1' for the second etc.
+Note: Windows and FreeBSD prevent write access to areas
+of the disk containing in\-use data (e.g. filesystems).
+.P
+The filename `\-' is a reserved name, meaning *stdin* or *stdout*. Which
+of the two depends on the read/write direction set.
+.RE
 .TP
 .BI filename_format \fR=\fPstr
-If sharing multiple files between jobs, it is usually necessary to have
-fio generate the exact names that you want. By default, fio will name a file
+If sharing multiple files between jobs, it is usually necessary to have fio
+generate the exact names that you want. By default, fio will name a file
 based on the default file format specification of
-\fBjobname.jobnumber.filenumber\fP. With this option, that can be
+`jobname.jobnumber.filenumber'. With this option, that can be
 customized. Fio will recognize and replace the following keywords in this
 string:
 .RS
@@ -426,44 +572,168 @@ The incremental number of the worker thread or process.
 The incremental number of the file for that worker thread or process.
 .RE
 .P
-To have dependent jobs share a set of files, this option can be set to
-have fio generate filenames that are shared between the two. For instance,
-if \fBtestfiles.$filenum\fR is specified, file number 4 for any job will
-be named \fBtestfiles.4\fR. The default of \fB$jobname.$jobnum.$filenum\fR
+To have dependent jobs share a set of files, this option can be set to have
+fio generate filenames that are shared between the two. For instance, if
+`testfiles.$filenum' is specified, file number 4 for any job will be
+named `testfiles.4'. The default of `$jobname.$jobnum.$filenum'
 will be used if no other format specifier is given.
 .RE
-.P
 .TP
 .BI unique_filename \fR=\fPbool
-To avoid collisions between networked clients, fio defaults to prefixing
-any generated filenames (with a directory specified) with the source of
-the client connecting. To disable this behavior, set this option to 0.
+To avoid collisions between networked clients, fio defaults to prefixing any
+generated filenames (with a directory specified) with the source of the
+client connecting. To disable this behavior, set this option to 0.
+.TP
+.BI opendir \fR=\fPstr
+Recursively open any files below directory \fIstr\fR.
 .TP
 .BI lockfile \fR=\fPstr
-Fio defaults to not locking any files before it does IO to them. If a file or
-file descriptor is shared, fio can serialize IO to that file to make the end
-result consistent. This is usual for emulating real workloads that share files.
-The lock modes are:
+Fio defaults to not locking any files before it does I/O to them. If a file
+or file descriptor is shared, fio can serialize I/O to that file to make the
+end result consistent. This is usual for emulating real workloads that share
+files. The lock modes are:
 .RS
 .RS
 .TP
 .B none
-No locking. This is the default.
+No locking. The default.
 .TP
 .B exclusive
-Only one thread or process may do IO at a time, excluding all others.
+Only one thread or process may do I/O at a time, excluding all others.
 .TP
 .B readwrite
-Read-write locking on the file. Many readers may access the file at the same
-time, but writes get exclusive access.
+Read\-write locking on the file. Many readers may
+access the file at the same time, but writes get exclusive access.
+.RE
 .RE
+.TP
+.BI nrfiles \fR=\fPint
+Number of files to use for this job. Defaults to 1. The size of files
+will be \fBsize\fR divided by this unless explicit size is specified by
+\fBfilesize\fR. Files are created for each thread separately, and each
+file will have a file number within its name by default, as explained in
+\fBfilename\fR section.
+.TP
+.BI openfiles \fR=\fPint
+Number of files to keep open at the same time. Defaults to the same as
+\fBnrfiles\fR, can be set smaller to limit the number simultaneous
+opens.
+.TP
+.BI file_service_type \fR=\fPstr
+Defines how fio decides which file from a job to service next. The following
+types are defined:
+.RS
+.RS
+.TP
+.B random
+Choose a file at random.
+.TP
+.B roundrobin
+Round robin over opened files. This is the default.
+.TP
+.B sequential
+Finish one file before moving on to the next. Multiple files can
+still be open depending on \fBopenfiles\fR.
+.TP
+.B zipf
+Use a Zipf distribution to decide what file to access.
+.TP
+.B pareto
+Use a Pareto distribution to decide what file to access.
+.TP
+.B normal
+Use a Gaussian (normal) distribution to decide what file to access.
+.TP
+.B gauss
+Alias for normal.
 .RE
 .P
-.BI opendir \fR=\fPstr
-Recursively open any files below directory \fIstr\fR.
+For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be appended to
+tell fio how many I/Os to issue before switching to a new file. For example,
+specifying `file_service_type=random:8' would cause fio to issue
+8 I/Os before selecting a new file at random. For the non\-uniform
+distributions, a floating point postfix can be given to influence how the
+distribution is skewed. See \fBrandom_distribution\fR for a description
+of how that would work.
+.RE
+.TP
+.BI ioscheduler \fR=\fPstr
+Attempt to switch the device hosting the file to the specified I/O scheduler
+before running.
+.TP
+.BI create_serialize \fR=\fPbool
+If true, serialize the file creation for the jobs. This may be handy to
+avoid interleaving of data files, which may greatly depend on the filesystem
+used and even the number of processors in the system. Default: true.
+.TP
+.BI create_fsync \fR=\fPbool
+\fBfsync\fR\|(2) the data file after creation. This is the default.
+.TP
+.BI create_on_open \fR=\fPbool
+If true, don't pre\-create files but allow the job's open() to create a file
+when it's time to do I/O. Default: false \-\- pre\-create all necessary files
+when the job starts.
+.TP
+.BI create_only \fR=\fPbool
+If true, fio will only run the setup phase of the job. If files need to be
+laid out or updated on disk, only that will be done \-\- the actual job contents
+are not executed. Default: false.
+.TP
+.BI allow_file_create \fR=\fPbool
+If true, fio is permitted to create files as part of its workload. If this
+option is false, then fio will error out if
+the files it needs to use don't already exist. Default: true.
+.TP
+.BI allow_mounted_write \fR=\fPbool
+If this isn't set, fio will abort jobs that are destructive (e.g. that write)
+to what appears to be a mounted device or partition. This should help catch
+creating inadvertently destructive tests, not realizing that the test will
+destroy data on the mounted file system. Note that some platforms don't allow
+writing against a mounted device regardless of this option. Default: false.
+.TP
+.BI pre_read \fR=\fPbool
+If this is given, files will be pre\-read into memory before starting the
+given I/O operation. This will also clear the \fBinvalidate\fR flag,
+since it is pointless to pre\-read and then drop the cache. This will only
+work for I/O engines that are seek\-able, since they allow you to read the
+same data multiple times. Thus it will not work on non\-seekable I/O engines
+(e.g. network, splice). Default: false.
+.TP
+.BI unlink \fR=\fPbool
+Unlink the job files when done. Not the default, as repeated runs of that
+job would then waste time recreating the file set again and again. Default:
+false.
+.TP
+.BI unlink_each_loop \fR=\fPbool
+Unlink job files after each iteration or loop. Default: false.
+.TP
+.BI zonesize \fR=\fPint
+Divide a file into zones of the specified size. See \fBzoneskip\fR.
+.TP
+.BI zonerange \fR=\fPint
+Give size of an I/O zone. See \fBzoneskip\fR.
+.TP
+.BI zoneskip \fR=\fPint
+Skip the specified number of bytes when \fBzonesize\fR data has been
+read. The two zone options can be used to only do I/O on zones of a file.
+.SS "I/O type"
+.TP
+.BI direct \fR=\fPbool
+If value is true, use non\-buffered I/O. This is usually O_DIRECT. Note that
+ZFS on Solaris doesn't support direct I/O. On Windows the synchronous
+ioengines don't support direct I/O. Default: false.
+.TP
+.BI atomic \fR=\fPbool
+If value is true, attempt to use atomic direct I/O. Atomic writes are
+guaranteed to be stable once acknowledged by the operating system. Only
+Linux supports O_ATOMIC right now.
+.TP
+.BI buffered \fR=\fPbool
+If value is true, use buffered I/O. This is the opposite of the
+\fBdirect\fR option. Defaults to true.
 .TP
 .BI readwrite \fR=\fPstr "\fR,\fP rw" \fR=\fPstr
-Type of I/O pattern.  Accepted values are:
+Type of I/O pattern. Accepted values are:
 .RS
 .RS
 .TP
@@ -485,71 +755,67 @@ Random writes.
 .B randtrim
 Random trims (Linux block devices only).
 .TP
-.B rw, readwrite
-Mixed sequential reads and writes.
+.B rw,readwrite
+Sequential mixed reads and writes.
 .TP
 .B randrw
-Mixed random reads and writes.
+Random mixed reads and writes.
 .TP
 .B trimwrite
-Sequential trim and write mixed workload. Blocks will be trimmed first, then
-the same blocks will be written to.
+Sequential trim+write sequences. Blocks will be trimmed first,
+then the same blocks will be written to.
 .RE
 .P
-Fio defaults to read if the option is not specified.
-For mixed I/O, the default split is 50/50. For certain types of io the result
-may still be skewed a bit, since the speed may be different. It is possible to
-specify a number of IOs to do before getting a new offset, this is done by
-appending a `:\fI<nr>\fR to the end of the string given. For a random read, it
-would look like \fBrw=randread:8\fR for passing in an offset modifier with a
-value of 8. If the postfix is used with a sequential IO pattern, then the value
-specified will be added to the generated offset for each IO. For instance,
-using \fBrw=write:4k\fR will skip 4k for every write. It turns sequential IO
-into sequential IO with holes. See the \fBrw_sequencer\fR option.
+Fio defaults to read if the option is not specified. For the mixed I/O
+types, the default is to split them 50/50. For certain types of I/O the
+result may still be skewed a bit, since the speed may be different.
+.P
+It is possible to specify the number of I/Os to do before getting a new
+offset by appending `:<nr>' to the end of the string given. For a
+random read, it would look like `rw=randread:8' for passing in an offset
+modifier with a value of 8. If the suffix is used with a sequential I/O
+pattern, then the `<nr>' value specified will be added to the generated
+offset for each I/O turning sequential I/O into sequential I/O with holes.
+For instance, using `rw=write:4k' will skip 4k for every write. Also see
+the \fBrw_sequencer\fR option.
 .RE
 .TP
 .BI rw_sequencer \fR=\fPstr
-If an offset modifier is given by appending a number to the \fBrw=<str>\fR line,
-then this option controls how that number modifies the IO offset being
-generated. Accepted values are:
+If an offset modifier is given by appending a number to the `rw=\fIstr\fR'
+line, then this option controls how that number modifies the I/O offset
+being generated. Accepted values are:
 .RS
 .RS
 .TP
 .B sequential
-Generate sequential offset
+Generate sequential offset.
 .TP
 .B identical
-Generate the same offset
+Generate the same offset.
 .RE
 .P
-\fBsequential\fR is only useful for random IO, where fio would normally
-generate a new random offset for every IO. If you append eg 8 to randread, you
-would get a new random offset for every 8 IOs. The result would be a seek for
-only every 8 IOs, instead of for every IO. Use \fBrw=randread:8\fR to specify
-that. As sequential IO is already sequential, setting \fBsequential\fR for that
-would not result in any differences.  \fBidentical\fR behaves in a similar
-fashion, except it sends the same offset 8 number of times before generating a
-new offset.
+\fBsequential\fR is only useful for random I/O, where fio would normally
+generate a new random offset for every I/O. If you append e.g. 8 to randread,
+you would get a new random offset for every 8 I/Os. The result would be a
+seek for only every 8 I/Os, instead of for every I/O. Use `rw=randread:8'
+to specify that. As sequential I/O is already sequential, setting
+\fBsequential\fR for that would not result in any differences. \fBidentical\fR
+behaves in a similar fashion, except it sends the same offset 8 number of
+times before generating a new offset.
 .RE
-.P
-.TP
-.BI kb_base \fR=\fPint
-The base unit for a kilobyte. The defacto base is 2^10, 1024.  Storage
-manufacturers like to use 10^3 or 1000 as a base ten unit instead, for obvious
-reasons. Allowed values are 1024 or 1000, with 1024 being the default.
 .TP
 .BI unified_rw_reporting \fR=\fPbool
 Fio normally reports statistics on a per data direction basis, meaning that
-reads, writes, and trims are accounted and reported separately. If this option is
-set fio sums the results and reports them as "mixed" instead.
+reads, writes, and trims are accounted and reported separately. If this
+option is set fio sums the results and report them as "mixed" instead.
 .TP
 .BI randrepeat \fR=\fPbool
-Seed the random number generator used for random I/O patterns in a predictable
-way so the pattern is repeatable across runs.  Default: true.
+Seed the random number generator used for random I/O patterns in a
+predictable way so the pattern is repeatable across runs. Default: true.
 .TP
 .BI allrandrepeat \fR=\fPbool
 Seed all random number generators in a predictable way so results are
-repeatable across runs.  Default: false.
+repeatable across runs. Default: false.
 .TP
 .BI randseed \fR=\fPint
 Seed the random number generators based on this seed value, to be able to
@@ -557,35 +823,36 @@ control what sequence of output is being generated. If not set, the random
 sequence depends on the \fBrandrepeat\fR setting.
 .TP
 .BI fallocate \fR=\fPstr
-Whether pre-allocation is performed when laying down files. Accepted values
-are:
+Whether pre\-allocation is performed when laying down files.
+Accepted values are:
 .RS
 .RS
 .TP
 .B none
-Do not pre-allocate space.
+Do not pre\-allocate space.
 .TP
 .B native
-Use a platform's native pre-allocation call but fall back to 'none' behavior if
-it fails/is not implemented.
+Use a platform's native pre\-allocation call but fall back to
+\fBnone\fR behavior if it fails/is not implemented.
 .TP
 .B posix
-Pre-allocate via \fBposix_fallocate\fR\|(3).
+Pre\-allocate via \fBposix_fallocate\fR\|(3).
 .TP
 .B keep
-Pre-allocate via \fBfallocate\fR\|(2) with FALLOC_FL_KEEP_SIZE set.
+Pre\-allocate via \fBfallocate\fR\|(2) with
+FALLOC_FL_KEEP_SIZE set.
 .TP
 .B 0
-Backward-compatible alias for 'none'.
+Backward\-compatible alias for \fBnone\fR.
 .TP
 .B 1
-Backward-compatible alias for 'posix'.
+Backward\-compatible alias for \fBposix\fR.
 .RE
 .P
-May not be available on all supported platforms. 'keep' is only
-available on Linux. If using ZFS on Solaris this cannot be set to 'posix'
-because ZFS doesn't support it. Default: 'native' if any pre-allocation methods
-are available, 'none' if not.
+May not be available on all supported platforms. \fBkeep\fR is only available
+on Linux. If using ZFS on Solaris this cannot be set to \fBposix\fR
+because ZFS doesn't support pre\-allocation. Default: \fBnative\fR if any
+pre\-allocation methods are available, \fBnone\fR if not.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPstr
@@ -599,21 +866,20 @@ Backwards compatible hint for "no hint".
 .TP
 .B 1
 Backwards compatible hint for "advise with fio workload type". This
-uses \fBFADV_RANDOM\fR for a random workload, and \fBFADV_SEQUENTIAL\fR
+uses FADV_RANDOM for a random workload, and FADV_SEQUENTIAL
 for a sequential workload.
 .TP
 .B sequential
-Advise using \fBFADV_SEQUENTIAL\fR
+Advise using FADV_SEQUENTIAL.
 .TP
 .B random
-Advise using \fBFADV_RANDOM\fR
+Advise using FADV_RANDOM.
 .RE
 .RE
 .TP
 .BI write_hint \fR=\fPstr
-Use \fBfcntl\fR\|(2) to advise the kernel what life time to expect from a write.
-Only supported on Linux, as of version 4.13. The values are all relative to
-each other, and no absolute meaning should be associated with them. Accepted
+Use \fBfcntl\fR\|(2) to advise the kernel what life time to expect
+from a write. Only supported on Linux, as of version 4.13. Accepted
 values are:
 .RS
 .RS
@@ -633,235 +899,536 @@ Data written to this file has a long life time.
 .B extreme
 Data written to this file has a very long life time.
 .RE
+.P
+The values are all relative to each other, and no absolute meaning
+should be associated with them.
 .RE
 .TP
-.BI size \fR=\fPint
-Total size of I/O for this job.  \fBfio\fR will run until this many bytes have
-been transferred, unless limited by other options (\fBruntime\fR, for instance,
-or increased/descreased by \fBio_size\fR). Unless \fBnrfiles\fR and
-\fBfilesize\fR options are given, this amount will be divided between the
-available files for the job. If not set, fio will use the full size of the
-given files or devices. If the files do not exist, size must be given. It is
-also possible to give size as a percentage between 1 and 100. If size=20% is
-given, fio will use 20% of the full size of the given files or devices.
+.BI offset \fR=\fPint
+Start I/O at the provided offset in the file, given as either a fixed size in
+bytes or a percentage. If a percentage is given, the next \fBblockalign\fR\-ed
+offset will be used. Data before the given offset will not be touched. This
+effectively caps the file size at `real_size \- offset'. Can be combined with
+\fBsize\fR to constrain the start and end range of the I/O workload.
+A percentage can be specified by a number between 1 and 100 followed by '%',
+for example, `offset=20%' to specify 20%.
 .TP
-.BI io_size \fR=\fPint "\fR,\fB io_limit \fR=\fPint
-Normally fio operates within the region set by \fBsize\fR, which means that
-the \fBsize\fR option sets both the region and size of IO to be performed.
-Sometimes that is not what you want. With this option, it is possible to
-define just the amount of IO that fio should do. For instance, if \fBsize\fR
-is set to 20G and \fBio_limit\fR is set to 5G, fio will perform IO within
-the first 20G but exit when 5G have been done. The opposite is also
-possible - if \fBsize\fR is set to 20G, and \fBio_size\fR is set to 40G, then
-fio will do 40G of IO within the 0..20G region.
+.BI offset_increment \fR=\fPint
+If this is provided, then the real offset becomes `\fBoffset\fR + \fBoffset_increment\fR
+* thread_number', where the thread number is a counter that starts at 0 and
+is incremented for each sub\-job (i.e. when \fBnumjobs\fR option is
+specified). This option is useful if there are several jobs which are
+intended to operate on a file in parallel disjoint segments, with even
+spacing between the starting points.
 .TP
-.BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
-Sets size to something really large and waits for ENOSPC (no space left on
-device) as the terminating condition. Only makes sense with sequential write.
-For a read workload, the mount point will be filled first then IO started on
-the result. This option doesn't make sense if operating on a raw device node,
-since the size of that is already known by the file system. Additionally,
-writing beyond end-of-device will not return ENOSPC there.
-.TP
-.BI filesize \fR=\fPirange
-Individual file sizes. May be a range, in which case \fBfio\fR will select sizes
-for files at random within the given range, limited to \fBsize\fR in total (if
-that is given). If \fBfilesize\fR is not specified, each created file is the
-same size.
+.BI number_ios \fR=\fPint
+Fio will normally perform I/Os until it has exhausted the size of the region
+set by \fBsize\fR, or if it exhaust the allocated time (or hits an error
+condition). With this setting, the range/size can be set independently of
+the number of I/Os to perform. When fio reaches this number, it will exit
+normally and report status. Note that this does not extend the amount of I/O
+that will be done, it will only stop fio if this condition is met before
+other end\-of\-job criteria.
 .TP
-.BI file_append \fR=\fPbool
-Perform IO after the end of the file. Normally fio will operate within the
-size of a file. If this option is set, then fio will append to the file
-instead. This has identical behavior to setting \fRoffset\fP to the size
-of a file. This option is ignored on non-regular files.
+.BI fsync \fR=\fPint
+If writing to a file, issue an \fBfsync\fR\|(2) (or its equivalent) of
+the dirty data for every number of blocks given. For example, if you give 32
+as a parameter, fio will sync the file after every 32 writes issued. If fio is
+using non\-buffered I/O, we may not sync the file. The exception is the sg
+I/O engine, which synchronizes the disk cache anyway. Defaults to 0, which
+means fio does not periodically issue and wait for a sync to complete. Also
+see \fBend_fsync\fR and \fBfsync_on_close\fR.
+.TP
+.BI fdatasync \fR=\fPint
+Like \fBfsync\fR but uses \fBfdatasync\fR\|(2) to only sync data and
+not metadata blocks. In Windows, FreeBSD, and DragonFlyBSD there is no
+\fBfdatasync\fR\|(2) so this falls back to using \fBfsync\fR\|(2).
+Defaults to 0, which means fio does not periodically issue and wait for a
+data\-only sync to complete.
+.TP
+.BI write_barrier \fR=\fPint
+Make every N\-th write a barrier write.
+.TP
+.BI sync_file_range \fR=\fPstr:int
+Use \fBsync_file_range\fR\|(2) for every \fIint\fR number of write
+operations. Fio will track range of writes that have happened since the last
+\fBsync_file_range\fR\|(2) call. \fIstr\fR can currently be one or more of:
+.RS
+.RS
+.TP
+.B wait_before
+SYNC_FILE_RANGE_WAIT_BEFORE
+.TP
+.B write
+SYNC_FILE_RANGE_WRITE
+.TP
+.B wait_after
+SYNC_FILE_RANGE_WRITE_AFTER
+.RE
+.P
+So if you do `sync_file_range=wait_before,write:8', fio would use
+`SYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE' for every 8
+writes. Also see the \fBsync_file_range\fR\|(2) man page. This option is
+Linux specific.
+.RE
+.TP
+.BI overwrite \fR=\fPbool
+If true, writes to a file will always overwrite existing data. If the file
+doesn't already exist, it will be created before the write phase begins. If
+the file exists and is large enough for the specified write phase, nothing
+will be done. Default: false.
+.TP
+.BI end_fsync \fR=\fPbool
+If true, \fBfsync\fR\|(2) file contents when a write stage has completed.
+Default: false.
+.TP
+.BI fsync_on_close \fR=\fPbool
+If true, fio will \fBfsync\fR\|(2) a dirty file on close. This differs
+from \fBend_fsync\fR in that it will happen on every file close, not
+just at the end of the job. Default: false.
+.TP
+.BI rwmixread \fR=\fPint
+Percentage of a mixed workload that should be reads. Default: 50.
+.TP
+.BI rwmixwrite \fR=\fPint
+Percentage of a mixed workload that should be writes. If both
+\fBrwmixread\fR and \fBrwmixwrite\fR is given and the values do not
+add up to 100%, the latter of the two will be used to override the
+first. This may interfere with a given rate setting, if fio is asked to
+limit reads or writes to a certain rate. If that is the case, then the
+distribution may be skewed. Default: 50.
+.TP
+.BI random_distribution \fR=\fPstr:float[,str:float][,str:float]
+By default, fio will use a completely uniform random distribution when asked
+to perform random I/O. Sometimes it is useful to skew the distribution in
+specific ways, ensuring that some parts of the data is more hot than others.
+fio includes the following distribution models:
+.RS
+.RS
+.TP
+.B random
+Uniform random distribution
+.TP
+.B zipf
+Zipf distribution
+.TP
+.B pareto
+Pareto distribution
+.TP
+.B normal
+Normal (Gaussian) distribution
+.TP
+.B zoned
+Zoned random distribution
+.RE
+.P
+When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
+needed to define the access pattern. For \fBzipf\fR, this is the `Zipf theta'.
+For \fBpareto\fR, it's the `Pareto power'. Fio includes a test
+program, \fBfio\-genzipf\fR, that can be used visualize what the given input
+values will yield in terms of hit rates. If you wanted to use \fBzipf\fR with
+a `theta' of 1.2, you would use `random_distribution=zipf:1.2' as the
+option. If a non\-uniform model is used, fio will disable use of the random
+map. For the \fBnormal\fR distribution, a normal (Gaussian) deviation is
+supplied as a value between 0 and 100.
+.P
+For a \fBzoned\fR distribution, fio supports specifying percentages of I/O
+access that should fall within what range of the file or device. For
+example, given a criteria of:
+.RS
+.P
+.PD 0
+60% of accesses should be to the first 10%
+.P
+30% of accesses should be to the next 20%
+.P
+8% of accesses should be to the next 30%
+.P
+2% of accesses should be to the next 40%
+.PD
+.RE
+.P
+we can define that through zoning of the random accesses. For the above
+example, the user would do:
+.RS
+.P
+random_distribution=zoned:60/10:30/20:8/30:2/40
+.RE
+.P
+similarly to how \fBbssplit\fR works for setting ranges and percentages
+of block sizes. Like \fBbssplit\fR, it's possible to specify separate
+zones for reads, writes, and trims. If just one set is given, it'll apply to
+all of them.
+.RE
+.TP
+.BI percentage_random \fR=\fPint[,int][,int]
+For a random workload, set how big a percentage should be random. This
+defaults to 100%, in which case the workload is fully random. It can be set
+from anywhere from 0 to 100. Setting it to 0 would make the workload fully
+sequential. Any setting in between will result in a random mix of sequential
+and random I/O, at the given percentages. Comma\-separated values may be
+specified for reads, writes, and trims as described in \fBblocksize\fR.
+.TP
+.BI norandommap
+Normally fio will cover every block of the file when doing random I/O. If
+this option is given, fio will just get a new random offset without looking
+at past I/O history. This means that some blocks may not be read or written,
+and that some blocks may be read/written more than once. If this option is
+used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
+only intact blocks are verified, i.e., partially\-overwritten blocks are
+ignored.
+.TP
+.BI softrandommap \fR=\fPbool
+See \fBnorandommap\fR. If fio runs with the random block map enabled and
+it fails to allocate the map, if this option is set it will continue without
+a random block map. As coverage will not be as complete as with random maps,
+this option is disabled by default.
+.TP
+.BI random_generator \fR=\fPstr
+Fio supports the following engines for generating I/O offsets for random I/O:
+.RS
+.RS
+.TP
+.B tausworthe
+Strong 2^88 cycle random number generator.
+.TP
+.B lfsr
+Linear feedback shift register generator.
+.TP
+.B tausworthe64
+Strong 64\-bit 2^258 cycle random number generator.
+.RE
+.P
+\fBtausworthe\fR is a strong random number generator, but it requires tracking
+on the side if we want to ensure that blocks are only read or written
+once. \fBlfsr\fR guarantees that we never generate the same offset twice, and
+it's also less computationally expensive. It's not a true random generator,
+however, though for I/O purposes it's typically good enough. \fBlfsr\fR only
+works with single block sizes, not with workloads that use multiple block
+sizes. If used with such a workload, fio may read or write some blocks
+multiple times. The default value is \fBtausworthe\fR, unless the required
+space exceeds 2^32 blocks. If it does, then \fBtausworthe64\fR is
+selected automatically.
+.RE
+.SS "Block size"
 .TP
 .BI blocksize \fR=\fPint[,int][,int] "\fR,\fB bs" \fR=\fPint[,int][,int]
-The block size in bytes for I/O units.  Default: 4096.
-A single value applies to reads, writes, and trims.
-Comma-separated values may be specified for reads, writes, and trims.
-Empty values separated by commas use the default value. A value not
-terminated in a comma applies to subsequent types.
-.nf
-Examples:
-bs=256k    means 256k for reads, writes and trims
-bs=8k,32k  means 8k for reads, 32k for writes and trims
-bs=8k,32k, means 8k for reads, 32k for writes, and default for trims
-bs=,8k     means default for reads, 8k for writes and trims
-bs=,8k,    means default for reads, 8k for writes, and default for trims
-.fi
+The block size in bytes used for I/O units. Default: 4096. A single value
+applies to reads, writes, and trims. Comma\-separated values may be
+specified for reads, writes, and trims. A value not terminated in a comma
+applies to subsequent types. Examples:
+.RS
+.RS
+.P
+.PD 0
+bs=256k        means 256k for reads, writes and trims.
+.P
+bs=8k,32k      means 8k for reads, 32k for writes and trims.
+.P
+bs=8k,32k,     means 8k for reads, 32k for writes, and default for trims.
+.P
+bs=,8k         means default for reads, 8k for writes and trims.
+.P
+bs=,8k,        means default for reads, 8k for writes, and default for trims.
+.PD
+.RE
+.RE
 .TP
 .BI blocksize_range \fR=\fPirange[,irange][,irange] "\fR,\fB bsrange" \fR=\fPirange[,irange][,irange]
-A range of block sizes in bytes for I/O units.
-The issued I/O unit will always be a multiple of the minimum size, unless
+A range of block sizes in bytes for I/O units. The issued I/O unit will
+always be a multiple of the minimum size, unless
 \fBblocksize_unaligned\fR is set.
-Comma-separated ranges may be specified for reads, writes, and trims
-as described in \fBblocksize\fR.
-.nf
-Example: bsrange=1k-4k,2k-8k.
-.fi
+Comma\-separated ranges may be specified for reads, writes, and trims as
+described in \fBblocksize\fR. Example:
+.RS
+.RS
+.P
+bsrange=1k\-4k,2k\-8k
+.RE
+.RE
 .TP
 .BI bssplit \fR=\fPstr[,str][,str]
-This option allows even finer grained control of the block sizes issued,
-not just even splits between them. With this option, you can weight various
-block sizes for exact control of the issued IO for a job that has mixed
-block sizes. The format of the option is bssplit=blocksize/percentage,
-optionally adding as many definitions as needed separated by a colon.
-Example: bssplit=4k/10:64k/50:32k/40 would issue 50% 64k blocks, 10% 4k
-blocks and 40% 32k blocks. \fBbssplit\fR also supports giving separate
-splits to reads, writes, and trims.
-Comma-separated values may be specified for reads, writes, and trims
-as described in \fBblocksize\fR.
-.TP
-.B blocksize_unaligned\fR,\fB bs_unaligned
-If set, fio will issue I/O units with any size within \fBblocksize_range\fR,
-not just multiples of the minimum size.  This typically won't
-work with direct I/O, as that normally requires sector alignment.
+Sometimes you want even finer grained control of the block sizes issued, not
+just an even split between them. This option allows you to weight various
+block sizes, so that you are able to define a specific amount of block sizes
+issued. The format for this option is:
+.RS
+.RS
+.P
+bssplit=blocksize/percentage:blocksize/percentage
+.RE
+.P
+for as many block sizes as needed. So if you want to define a workload that
+has 50% 64k blocks, 10% 4k blocks, and 40% 32k blocks, you would write:
+.RS
+.P
+bssplit=4k/10:64k/50:32k/40
+.RE
+.P
+Ordering does not matter. If the percentage is left blank, fio will fill in
+the remaining values evenly. So a bssplit option like this one:
+.RS
+.P
+bssplit=4k/50:1k/:32k/
+.RE
+.P
+would have 50% 4k ios, and 25% 1k and 32k ios. The percentages always add up
+to 100, if bssplit is given a range that adds up to more, it will error out.
+.P
+Comma\-separated values may be specified for reads, writes, and trims as
+described in \fBblocksize\fR.
+.P
+If you want a workload that has 50% 2k reads and 50% 4k reads, while having
+90% 4k writes and 10% 8k writes, you would specify:
+.RS
+.P
+bssplit=2k/50:4k/50,4k/90,8k/10
+.RE
+.RE
+.TP
+.BI blocksize_unaligned "\fR,\fB bs_unaligned"
+If set, fio will issue I/O units with any size within
+\fBblocksize_range\fR, not just multiples of the minimum size. This
+typically won't work with direct I/O, as that normally requires sector
+alignment.
 .TP
 .BI bs_is_seq_rand \fR=\fPbool
-If this option is set, fio will use the normal read,write blocksize settings as
-sequential,random blocksize settings instead. Any random read or write will
-use the WRITE blocksize settings, and any sequential read or write will use
-the READ blocksize settings.
+If this option is set, fio will use the normal read,write blocksize settings
+as sequential,random blocksize settings instead. Any random read or write
+will use the WRITE blocksize settings, and any sequential read or write will
+use the READ blocksize settings.
 .TP
 .BI blockalign \fR=\fPint[,int][,int] "\fR,\fB ba" \fR=\fPint[,int][,int]
-Boundary to which fio will align random I/O units. Default: \fBblocksize\fR.
-Minimum alignment is typically 512b for using direct IO, though it usually
-depends on the hardware block size.  This option is mutually exclusive with
-using a random map for files, so it will turn off that option.
-Comma-separated values may be specified for reads, writes, and trims
-as described in \fBblocksize\fR.
-.TP
-.B zero_buffers
+Boundary to which fio will align random I/O units. Default:
+\fBblocksize\fR. Minimum alignment is typically 512b for using direct
+I/O, though it usually depends on the hardware block size. This option is
+mutually exclusive with using a random map for files, so it will turn off
+that option. Comma\-separated values may be specified for reads, writes, and
+trims as described in \fBblocksize\fR.
+.SS "Buffers and memory"
+.TP
+.BI zero_buffers
 Initialize buffers with all zeros. Default: fill buffers with random data.
 .TP
-.B refill_buffers
-If this option is given, fio will refill the IO buffers on every submit. The
-default is to only fill it at init time and reuse that data. Only makes sense
-if zero_buffers isn't specified, naturally. If data verification is enabled,
-refill_buffers is also automatically enabled.
+.BI refill_buffers
+If this option is given, fio will refill the I/O buffers on every
+submit. The default is to only fill it at init time and reuse that
+data. Only makes sense if zero_buffers isn't specified, naturally. If data
+verification is enabled, \fBrefill_buffers\fR is also automatically enabled.
 .TP
 .BI scramble_buffers \fR=\fPbool
 If \fBrefill_buffers\fR is too costly and the target is using data
-deduplication, then setting this option will slightly modify the IO buffer
-contents to defeat normal de-dupe attempts. This is not enough to defeat
-more clever block compression attempts, but it will stop naive dedupe
-of blocks. Default: true.
+deduplication, then setting this option will slightly modify the I/O buffer
+contents to defeat normal de\-dupe attempts. This is not enough to defeat
+more clever block compression attempts, but it will stop naive dedupe of
+blocks. Default: true.
 .TP
 .BI buffer_compress_percentage \fR=\fPint
-If this is set, then fio will attempt to provide IO buffer content (on WRITEs)
-that compress to the specified level. Fio does this by providing a mix of
-random data and a fixed pattern. The fixed pattern is either zeroes, or the
-pattern specified by \fBbuffer_pattern\fR. If the pattern option is used, it
-might skew the compression ratio slightly. Note that this is per block size
-unit, for file/disk wide compression level that matches this setting. Note
-that this is per block size unit, for file/disk wide compression level that
-matches this setting, you'll also want to set refill_buffers.
+If this is set, then fio will attempt to provide I/O buffer content (on
+WRITEs) that compresses to the specified level. Fio does this by providing a
+mix of random data and a fixed pattern. The fixed pattern is either zeros,
+or the pattern specified by \fBbuffer_pattern\fR. If the pattern option
+is used, it might skew the compression ratio slightly. Note that this is per
+block size unit, for file/disk wide compression level that matches this
+setting, you'll also want to set \fBrefill_buffers\fR.
 .TP
 .BI buffer_compress_chunk \fR=\fPint
-See \fBbuffer_compress_percentage\fR. This setting allows fio to manage how
-big the ranges of random data and zeroed data is. Without this set, fio will
-provide \fBbuffer_compress_percentage\fR of blocksize random data, followed by
-the remaining zeroed. With this set to some chunk size smaller than the block
-size, fio can alternate random and zeroed data throughout the IO buffer.
+See \fBbuffer_compress_percentage\fR. This setting allows fio to manage
+how big the ranges of random data and zeroed data is. Without this set, fio
+will provide \fBbuffer_compress_percentage\fR of blocksize random data,
+followed by the remaining zeroed. With this set to some chunk size smaller
+than the block size, fio can alternate random and zeroed data throughout the
+I/O buffer.
 .TP
 .BI buffer_pattern \fR=\fPstr
 If set, fio will fill the I/O buffers with this pattern or with the contents
 of a file. If not set, the contents of I/O buffers are defined by the other
 options related to buffer contents. The setting can be any pattern of bytes,
 and can be prefixed with 0x for hex values. It may also be a string, where
-the string must then be wrapped with ``""``. Or it may also be a filename,
-where the filename must be wrapped with ``''`` in which case the file is
+the string must then be wrapped with "". Or it may also be a filename,
+where the filename must be wrapped with '' in which case the file is
 opened and read. Note that not all the file contents will be read if that
 would cause the buffers to overflow. So, for example:
 .RS
 .RS
-\fBbuffer_pattern\fR='filename'
-.RS
-or
-.RE
-\fBbuffer_pattern\fR="abcd"
-.RS
-or
-.RE
-\fBbuffer_pattern\fR=-12
-.RS
-or
-.RE
-\fBbuffer_pattern\fR=0xdeadface
+.P
+.PD 0
+buffer_pattern='filename'
+.P
+or:
+.P
+buffer_pattern="abcd"
+.P
+or:
+.P
+buffer_pattern=\-12
+.P
+or:
+.P
+buffer_pattern=0xdeadface
+.PD
 .RE
-.LP
+.P
 Also you can combine everything together in any order:
-.LP
 .RS
-\fBbuffer_pattern\fR=0xdeadface"abcd"-12'filename'
+.P
+buffer_pattern=0xdeadface"abcd"\-12'filename'
 .RE
 .RE
 .TP
 .BI dedupe_percentage \fR=\fPint
-If set, fio will generate this percentage of identical buffers when writing.
-These buffers will be naturally dedupable. The contents of the buffers depend
-on what other buffer compression settings have been set. It's possible to have
-the individual buffers either fully compressible, or not at all. This option
-only controls the distribution of unique buffers.
+If set, fio will generate this percentage of identical buffers when
+writing. These buffers will be naturally dedupable. The contents of the
+buffers depend on what other buffer compression settings have been set. It's
+possible to have the individual buffers either fully compressible, or not at
+all. This option only controls the distribution of unique buffers.
 .TP
-.BI nrfiles \fR=\fPint
-Number of files to use for this job.  Default: 1.
+.BI invalidate \fR=\fPbool
+Invalidate the buffer/page cache parts of the files to be used prior to
+starting I/O if the platform and file type support it. Defaults to true.
+This will be ignored if \fBpre_read\fR is also specified for the
+same job.
 .TP
-.BI openfiles \fR=\fPint
-Number of files to keep open at the same time.  Default: \fBnrfiles\fR.
+.BI sync \fR=\fPbool
+Use synchronous I/O for buffered writes. For the majority of I/O engines,
+this means using O_SYNC. Default: false.
 .TP
-.BI file_service_type \fR=\fPstr
-Defines how files to service are selected.  The following types are defined:
+.BI iomem \fR=\fPstr "\fR,\fP mem" \fR=\fPstr
+Fio can use various types of memory as the I/O unit buffer. The allowed
+values are:
 .RS
 .RS
 .TP
-.B random
-Choose a file at random.
+.B malloc
+Use memory from \fBmalloc\fR\|(3) as the buffers. Default memory type.
 .TP
-.B roundrobin
-Round robin over opened files (default).
+.B shm
+Use shared memory as the buffers. Allocated through \fBshmget\fR\|(2).
 .TP
-.B sequential
-Do each file in the set sequentially.
+.B shmhuge
+Same as \fBshm\fR, but use huge pages as backing.
 .TP
-.B zipf
-Use a zipfian distribution to decide what file to access.
+.B mmap
+Use \fBmmap\fR\|(2) to allocate buffers. May either be anonymous memory, or can
+be file backed if a filename is given after the option. The format
+is `mem=mmap:/path/to/file'.
 .TP
-.B pareto
-Use a pareto distribution to decide what file to access.
+.B mmaphuge
+Use a memory mapped huge file as the buffer backing. Append filename
+after mmaphuge, ala `mem=mmaphuge:/hugetlbfs/file'.
 .TP
-.B normal
-Use a Gaussian (normal) distribution to decide what file to access.
+.B mmapshared
+Same as \fBmmap\fR, but use a MMAP_SHARED mapping.
 .TP
-.B gauss
-Alias for normal.
+.B cudamalloc
+Use GPU memory as the buffers for GPUDirect RDMA benchmark.
+The \fBioengine\fR must be \fBrdma\fR.
 .RE
 .P
-For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be
-appended to tell fio how many I/Os to issue before switching to a new file.
-For example, specifying \fBfile_service_type=random:8\fR would cause fio to
-issue \fI8\fR I/Os before selecting a new file at random. For the non-uniform
-distributions, a floating point postfix can be given to influence how the
-distribution is skewed. See \fBrandom_distribution\fR for a description of how
-that would work.
+The area allocated is a function of the maximum allowed bs size for the job,
+multiplied by the I/O depth given. Note that for \fBshmhuge\fR and
+\fBmmaphuge\fR to work, the system must have free huge pages allocated. This
+can normally be checked and set by reading/writing
+`/proc/sys/vm/nr_hugepages' on a Linux system. Fio assumes a huge page
+is 4MiB in size. So to calculate the number of huge pages you need for a
+given job file, add up the I/O depth of all jobs (normally one unless
+\fBiodepth\fR is used) and multiply by the maximum bs set. Then divide
+that number by the huge page size. You can see the size of the huge pages in
+`/proc/meminfo'. If no huge pages are allocated by having a non\-zero
+number in `nr_hugepages', using \fBmmaphuge\fR or \fBshmhuge\fR will fail. Also
+see \fBhugepage\-size\fR.
+.P
+\fBmmaphuge\fR also needs to have hugetlbfs mounted and the file location
+should point there. So if it's mounted in `/huge', you would use
+`mem=mmaphuge:/huge/somefile'.
 .RE
 .TP
+.BI iomem_align \fR=\fPint "\fR,\fP mem_align" \fR=\fPint
+This indicates the memory alignment of the I/O memory buffers. Note that
+the given alignment is applied to the first I/O unit buffer, if using
+\fBiodepth\fR the alignment of the following buffers are given by the
+\fBbs\fR used. In other words, if using a \fBbs\fR that is a
+multiple of the page sized in the system, all buffers will be aligned to
+this value. If using a \fBbs\fR that is not page aligned, the alignment
+of subsequent I/O memory buffers is the sum of the \fBiomem_align\fR and
+\fBbs\fR used.
+.TP
+.BI hugepage\-size \fR=\fPint
+Defines the size of a huge page. Must at least be equal to the system
+setting, see `/proc/meminfo'. Defaults to 4MiB. Should probably
+always be a multiple of megabytes, so using `hugepage\-size=Xm' is the
+preferred way to set this to avoid setting a non\-pow\-2 bad value.
+.TP
+.BI lockmem \fR=\fPint
+Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
+simulate a smaller amount of memory. The amount specified is per worker.
+.SS "I/O size"
+.TP
+.BI size \fR=\fPint
+The total size of file I/O for each thread of this job. Fio will run until
+this many bytes has been transferred, unless runtime is limited by other options
+(such as \fBruntime\fR, for instance, or increased/decreased by \fBio_size\fR).
+Fio will divide this size between the available files determined by options
+such as \fBnrfiles\fR, \fBfilename\fR, unless \fBfilesize\fR is
+specified by the job. If the result of division happens to be 0, the size is
+set to the physical size of the given files or devices if they exist.
+If this option is not specified, fio will use the full size of the given
+files or devices. If the files do not exist, size must be given. It is also
+possible to give size as a percentage between 1 and 100. If `size=20%' is
+given, fio will use 20% of the full size of the given files or devices.
+Can be combined with \fBoffset\fR to constrain the start and end range
+that I/O will be done within.
+.TP
+.BI io_size \fR=\fPint "\fR,\fB io_limit" \fR=\fPint
+Normally fio operates within the region set by \fBsize\fR, which means
+that the \fBsize\fR option sets both the region and size of I/O to be
+performed. Sometimes that is not what you want. With this option, it is
+possible to define just the amount of I/O that fio should do. For instance,
+if \fBsize\fR is set to 20GiB and \fBio_size\fR is set to 5GiB, fio
+will perform I/O within the first 20GiB but exit when 5GiB have been
+done. The opposite is also possible \-\- if \fBsize\fR is set to 20GiB,
+and \fBio_size\fR is set to 40GiB, then fio will do 40GiB of I/O within
+the 0..20GiB region.
+.TP
+.BI filesize \fR=\fPirange(int)
+Individual file sizes. May be a range, in which case fio will select sizes
+for files at random within the given range and limited to \fBsize\fR in
+total (if that is given). If not given, each created file is the same size.
+This option overrides \fBsize\fR in terms of file size, which means
+this value is used as a fixed size or possible range of each file.
+.TP
+.BI file_append \fR=\fPbool
+Perform I/O after the end of the file. Normally fio will operate within the
+size of a file. If this option is set, then fio will append to the file
+instead. This has identical behavior to setting \fBoffset\fR to the size
+of a file. This option is ignored on non\-regular files.
+.TP
+.BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
+Sets size to something really large and waits for ENOSPC (no space left on
+device) as the terminating condition. Only makes sense with sequential
+write. For a read workload, the mount point will be filled first then I/O
+started on the result. This option doesn't make sense if operating on a raw
+device node, since the size of that is already known by the file system.
+Additionally, writing beyond end\-of\-device will not return ENOSPC there.
+.SS "I/O engine"
+.TP
 .BI ioengine \fR=\fPstr
-Defines how the job issues I/O.  The following types are defined:
+Defines how the job issues I/O to the file. The following types are defined:
 .RS
 .RS
 .TP
 .B sync
-Basic \fBread\fR\|(2) or \fBwrite\fR\|(2) I/O.  \fBfseek\fR\|(2) is used to
-position the I/O location.
+Basic \fBread\fR\|(2) or \fBwrite\fR\|(2)
+I/O. \fBlseek\fR\|(2) is used to position the I/O location.
+See \fBfsync\fR and \fBfdatasync\fR for syncing write I/Os.
 .TP
 .B psync
-Basic \fBpread\fR\|(2) or \fBpwrite\fR\|(2) I/O.
-Default on all supported operating systems except for Windows.
+Basic \fBpread\fR\|(2) or \fBpwrite\fR\|(2) I/O. Default on
+all supported operating systems except for Windows.
 .TP
 .B vsync
-Basic \fBreadv\fR\|(2) or \fBwritev\fR\|(2) I/O. Will emulate queuing by
-coalescing adjacent IOs into a single submission.
+Basic \fBreadv\fR\|(2) or \fBwritev\fR\|(2) I/O. Will emulate
+queuing by coalescing adjacent I/Os into a single submission.
 .TP
 .B pvsync
 Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
@@ -870,10 +1437,14 @@ Basic \fBpreadv\fR\|(2) or \fBpwritev\fR\|(2) I/O.
 Basic \fBpreadv2\fR\|(2) or \fBpwritev2\fR\|(2) I/O.
 .TP
 .B libaio
-Linux native asynchronous I/O. This ioengine defines engine specific options.
+Linux native asynchronous I/O. Note that Linux may only support
+queued behavior with non\-buffered I/O (set `direct=1' or
+`buffered=0').
+This engine defines engine specific options.
 .TP
 .B posixaio
-POSIX asynchronous I/O using \fBaio_read\fR\|(3) and \fBaio_write\fR\|(3).
+POSIX asynchronous I/O using \fBaio_read\fR\|(3) and
+\fBaio_write\fR\|(3).
 .TP
 .B solarisaio
 Solaris native asynchronous I/O.
@@ -882,482 +1453,552 @@ Solaris native asynchronous I/O.
 Windows native asynchronous I/O. Default on Windows.
 .TP
 .B mmap
-File is memory mapped with \fBmmap\fR\|(2) and data copied using
-\fBmemcpy\fR\|(3).
+File is memory mapped with \fBmmap\fR\|(2) and data copied
+to/from using \fBmemcpy\fR\|(3).
 .TP
 .B splice
-\fBsplice\fR\|(2) is used to transfer the data and \fBvmsplice\fR\|(2) to
-transfer data from user-space to the kernel.
+\fBsplice\fR\|(2) is used to transfer the data and
+\fBvmsplice\fR\|(2) to transfer data from user space to the
+kernel.
 .TP
 .B sg
-SCSI generic sg v3 I/O. May be either synchronous using the SG_IO ioctl, or if
-the target is an sg character device, we use \fBread\fR\|(2) and
-\fBwrite\fR\|(2) for asynchronous I/O.
+SCSI generic sg v3 I/O. May either be synchronous using the SG_IO
+ioctl, or if the target is an sg character device we use
+\fBread\fR\|(2) and \fBwrite\fR\|(2) for asynchronous
+I/O. Requires \fBfilename\fR option to specify either block or
+character devices.
 .TP
 .B null
-Doesn't transfer any data, just pretends to.  Mainly used to exercise \fBfio\fR
-itself and for debugging and testing purposes.
+Doesn't transfer any data, just pretends to. This is mainly used to
+exercise fio itself and for debugging/testing purposes.
 .TP
 .B net
-Transfer over the network.  The protocol to be used can be defined with the
-\fBprotocol\fR parameter.  Depending on the protocol, \fBfilename\fR,
-\fBhostname\fR, \fBport\fR, or \fBlisten\fR must be specified.
-This ioengine defines engine specific options.
+Transfer over the network to given `host:port'. Depending on the
+\fBprotocol\fR used, the \fBhostname\fR, \fBport\fR,
+\fBlisten\fR and \fBfilename\fR options are used to specify
+what sort of connection to make, while the \fBprotocol\fR option
+determines which protocol will be used. This engine defines engine
+specific options.
 .TP
 .B netsplice
-Like \fBnet\fR, but uses \fBsplice\fR\|(2) and \fBvmsplice\fR\|(2) to map data
-and send/receive. This ioengine defines engine specific options.
+Like \fBnet\fR, but uses \fBsplice\fR\|(2) and
+\fBvmsplice\fR\|(2) to map data and send/receive.
+This engine defines engine specific options.
 .TP
 .B cpuio
-Doesn't transfer any data, but burns CPU cycles according to \fBcpuload\fR and
-\fBcpuchunks\fR parameters. A job never finishes unless there is at least one
-non-cpuio job.
+Doesn't transfer any data, but burns CPU cycles according to the
+\fBcpuload\fR and \fBcpuchunks\fR options. Setting
+\fBcpuload\fR\=85 will cause that job to do nothing but burn 85%
+of the CPU. In case of SMP machines, use `numjobs=<nr_of_cpu>'
+to get desired CPU usage, as the cpuload only loads a
+single CPU at the desired rate. A job never finishes unless there is
+at least one non\-cpuio job.
 .TP
 .B guasi
-The GUASI I/O engine is the Generic Userspace Asynchronous Syscall Interface
-approach to asynchronous I/O.
-.br
-See <http://www.xmailserver.org/guasi\-lib.html>.
+The GUASI I/O engine is the Generic Userspace Asyncronous Syscall
+Interface approach to async I/O. See \fIhttp://www.xmailserver.org/guasi\-lib.html\fR
+for more info on GUASI.
 .TP
 .B rdma
-The RDMA I/O engine supports both RDMA memory semantics (RDMA_WRITE/RDMA_READ)
-and channel semantics (Send/Recv) for the InfiniBand, RoCE and iWARP protocols.
-.TP
-.B external
-Loads an external I/O engine object file.  Append the engine filename as
-`:\fIenginepath\fR'.
+The RDMA I/O engine supports both RDMA memory semantics
+(RDMA_WRITE/RDMA_READ) and channel semantics (Send/Recv) for the
+InfiniBand, RoCE and iWARP protocols.
 .TP
 .B falloc
-   IO engine that does regular linux native fallocate call to simulate data
-transfer as fio ioengine
-.br
-  DDIR_READ  does fallocate(,mode = FALLOC_FL_KEEP_SIZE,)
-.br
-  DIR_WRITE does fallocate(,mode = 0)
-.br
-  DDIR_TRIM does fallocate(,mode = FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE)
+I/O engine that does regular fallocate to simulate data transfer as
+fio ioengine.
+.RS
+.P
+.PD 0
+DDIR_READ      does fallocate(,mode = FALLOC_FL_KEEP_SIZE,).
+.P
+DIR_WRITE      does fallocate(,mode = 0).
+.P
+DDIR_TRIM      does fallocate(,mode = FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE).
+.PD
+.RE
+.TP
+.B ftruncate
+I/O engine that sends \fBftruncate\fR\|(2) operations in response
+to write (DDIR_WRITE) events. Each ftruncate issued sets the file's
+size to the current block offset. \fBblocksize\fR is ignored.
 .TP
 .B e4defrag
-IO engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate defragment activity
-request to DDIR_WRITE event
+I/O engine that does regular EXT4_IOC_MOVE_EXT ioctls to simulate
+defragment activity in request to DDIR_WRITE event.
 .TP
 .B rbd
-IO engine supporting direct access to Ceph Rados Block Devices (RBD) via librbd
-without the need to use the kernel rbd driver. This ioengine defines engine specific
-options.
+I/O engine supporting direct access to Ceph Rados Block Devices
+(RBD) via librbd without the need to use the kernel rbd driver. This
+ioengine defines engine specific options.
 .TP
 .B gfapi
-Using Glusterfs libgfapi sync interface to direct access to Glusterfs volumes without
-having to go through FUSE. This ioengine defines engine specific
-options.
+Using GlusterFS libgfapi sync interface to direct access to
+GlusterFS volumes without having to go through FUSE. This ioengine
+defines engine specific options.
 .TP
 .B gfapi_async
-Using Glusterfs libgfapi async interface to direct access to Glusterfs volumes without
-having to go through FUSE. This ioengine defines engine specific
-options.
+Using GlusterFS libgfapi async interface to direct access to
+GlusterFS volumes without having to go through FUSE. This ioengine
+defines engine specific options.
 .TP
 .B libhdfs
-Read and write through Hadoop (HDFS).  The \fBfilename\fR option is used to
-specify host,port of the hdfs name-node to connect. This engine interprets
-offsets a little differently. In HDFS, files once created cannot be modified.
-So random writes are not possible. To imitate this, libhdfs engine expects
-bunch of small files to be created over HDFS, and engine will randomly pick a
-file out of those files based on the offset generated by fio backend. (see the
-example job file to create such files, use rw=write option). Please note, you
-might want to set necessary environment variables to work with hdfs/libhdfs
-properly.
+Read and write through Hadoop (HDFS). The \fBfilename\fR option
+is used to specify host,port of the hdfs name\-node to connect. This
+engine interprets offsets a little differently. In HDFS, files once
+created cannot be modified so random writes are not possible. To
+imitate this the libhdfs engine expects a bunch of small files to be
+created over HDFS and will randomly pick a file from them
+based on the offset generated by fio backend (see the example
+job file to create such files, use `rw=write' option). Please
+note, it may be necessary to set environment variables to work
+with HDFS/libhdfs properly. Each job uses its own connection to
+HDFS.
 .TP
 .B mtd
-Read, write and erase an MTD character device (e.g., /dev/mtd0). Discards are
-treated as erases. Depending on the underlying device type, the I/O may have
-to go in a certain pattern, e.g., on NAND, writing sequentially to erase blocks
-and discarding before overwriting. The trimwrite mode works well for this
+Read, write and erase an MTD character device (e.g.,
+`/dev/mtd0'). Discards are treated as erases. Depending on the
+underlying device type, the I/O may have to go in a certain pattern,
+e.g., on NAND, writing sequentially to erase blocks and discarding
+before overwriting. The \fBtrimwrite\fR mode works well for this
 constraint.
 .TP
 .B pmemblk
-Read and write using filesystem DAX to a file on a filesystem mounted with
-DAX on a persistent memory device through the NVML libpmemblk library.
-.TP
-.B dev-dax
-Read and write using device DAX to a persistent memory device
-(e.g., /dev/dax0.0) through the NVML libpmem library.
-.RE
-.P
-.RE
+Read and write using filesystem DAX to a file on a filesystem
+mounted with DAX on a persistent memory device through the NVML
+libpmemblk library.
 .TP
-.BI iodepth \fR=\fPint
-Number of I/O units to keep in flight against the file. Note that increasing
-iodepth beyond 1 will not affect synchronous ioengines (except for small
-degress when verify_async is in use). Even async engines may impose OS
-restrictions causing the desired depth not to be achieved.  This may happen on
-Linux when using libaio and not setting \fBdirect\fR=1, since buffered IO is
-not async on that OS. Keep an eye on the IO depth distribution in the
-fio output to verify that the achieved depth is as expected. Default: 1.
-.TP
-.BI iodepth_batch \fR=\fPint "\fR,\fP iodepth_batch_submit" \fR=\fPint
-This defines how many pieces of IO to submit at once. It defaults to 1
-which means that we submit each IO as soon as it is available, but can
-be raised to submit bigger batches of IO at the time. If it is set to 0
-the \fBiodepth\fR value will be used.
+.B dev\-dax
+Read and write using device DAX to a persistent memory device (e.g.,
+/dev/dax0.0) through the NVML libpmem library.
 .TP
-.BI iodepth_batch_complete_min \fR=\fPint "\fR,\fP iodepth_batch_complete" \fR=\fPint
-This defines how many pieces of IO to retrieve at once. It defaults to 1 which
- means that we'll ask for a minimum of 1 IO in the retrieval process from the
-kernel. The IO retrieval will go on until we hit the limit set by
-\fBiodepth_low\fR. If this variable is set to 0, then fio will always check for
-completed events before queuing more IO. This helps reduce IO latency, at the
-cost of more retrieval system calls.
+.B external
+Prefix to specify loading an external I/O engine object file. Append
+the engine filename, e.g. `ioengine=external:/tmp/foo.o' to load
+ioengine `foo.o' in `/tmp'.
+.SS "I/O engine specific parameters"
+In addition, there are some parameters which are only valid when a specific
+\fBioengine\fR is in use. These are used identically to normal parameters,
+with the caveat that when used on the command line, they must come after the
+\fBioengine\fR that defines them is selected.
 .TP
-.BI iodepth_batch_complete_max \fR=\fPint
-This defines maximum pieces of IO to
-retrieve at once. This variable should be used along with
-\fBiodepth_batch_complete_min\fR=int variable, specifying the range
-of min and max amount of IO which should be retrieved. By default
-it is equal to \fBiodepth_batch_complete_min\fR value.
-
-Example #1:
-.RS
-.RS
-\fBiodepth_batch_complete_min\fR=1
-.LP
-\fBiodepth_batch_complete_max\fR=<iodepth>
-.RE
-
-which means that we will retrieve at least 1 IO and up to the
-whole submitted queue depth. If none of IO has been completed
-yet, we will wait.
-
-Example #2:
-.RS
-\fBiodepth_batch_complete_min\fR=0
-.LP
-\fBiodepth_batch_complete_max\fR=<iodepth>
-.RE
-
-which means that we can retrieve up to the whole submitted
-queue depth, but if none of IO has been completed yet, we will
-NOT wait and immediately exit the system call. In this example
-we simply do polling.
-.RE
+.BI (libaio)userspace_reap
+Normally, with the libaio engine in use, fio will use the
+\fBio_getevents\fR\|(3) system call to reap newly returned events. With
+this flag turned on, the AIO ring will be read directly from user\-space to
+reap events. The reaping mode is only enabled when polling for a minimum of
+0 events (e.g. when `iodepth_batch_complete=0').
 .TP
-.BI iodepth_low \fR=\fPint
-Low watermark indicating when to start filling the queue again.  Default:
-\fBiodepth\fR.
+.BI (pvsync2)hipri
+Set RWF_HIPRI on I/O, indicating to the kernel that it's of higher priority
+than normal.
 .TP
-.BI serialize_overlap \fR=\fPbool
-Serialize in-flight I/Os that might otherwise cause or suffer from data races.
-When two or more I/Os are submitted simultaneously, there is no guarantee that
-the I/Os will be processed or completed in the submitted order. Further, if
-two or more of those I/Os are writes, any overlapping region between them can
-become indeterminate/undefined on certain storage. These issues can cause
-verification to fail erratically when at least one of the racing I/Os is
-changing data and the overlapping region has a non-zero size. Setting
-\fBserialize_overlap\fR tells fio to avoid provoking this behavior by explicitly
-serializing in-flight I/Os that have a non-zero overlap. Note that setting
-this option can reduce both performance and the \fBiodepth\fR achieved.
-Additionally this option does not work when \fBio_submit_mode\fR is set to
-offload. Default: false.
+.BI (pvsync2)hipri_percentage
+When hipri is set this determines the probability of a pvsync2 I/O being high
+priority. The default is 100%.
 .TP
-.BI io_submit_mode \fR=\fPstr
-This option controls how fio submits the IO to the IO engine. The default is
-\fBinline\fR, which means that the fio job threads submit and reap IO directly.
-If set to \fBoffload\fR, the job threads will offload IO submission to a
-dedicated pool of IO threads. This requires some coordination and thus has a
-bit of extra overhead, especially for lower queue depth IO where it can
-increase latencies. The benefit is that fio can manage submission rates
-independently of the device completion rates. This avoids skewed latency
-reporting if IO gets back up on the device side (the coordinated omission
-problem).
+.BI (cpuio)cpuload \fR=\fPint
+Attempt to use the specified percentage of CPU cycles. This is a mandatory
+option when using cpuio I/O engine.
 .TP
-.BI direct \fR=\fPbool
-If true, use non-buffered I/O (usually O_DIRECT).  Default: false.
+.BI (cpuio)cpuchunks \fR=\fPint
+Split the load into cycles of the given time. In microseconds.
 .TP
-.BI atomic \fR=\fPbool
-If value is true, attempt to use atomic direct IO. Atomic writes are guaranteed
-to be stable once acknowledged by the operating system. Only Linux supports
-O_ATOMIC right now.
+.BI (cpuio)exit_on_io_done \fR=\fPbool
+Detect when I/O threads are done, then exit.
 .TP
-.BI buffered \fR=\fPbool
-If true, use buffered I/O.  This is the opposite of the \fBdirect\fR parameter.
-Default: true.
+.BI (libhdfs)namenode \fR=\fPstr
+The hostname or IP address of a HDFS cluster namenode to contact.
 .TP
-.BI offset \fR=\fPint
-Start I/O at the provided offset in the file, given as either a fixed size in
-bytes or a percentage. If a percentage is given, the next \fBblockalign\fR-ed
-offset will be used. Data before the given offset will not be touched. This
-effectively caps the file size at (real_size - offset). Can be combined with
-\fBsize\fR to constrain the start and end range of the I/O workload. A percentage
-can be specified by a number between 1 and 100 followed by '%', for example,
-offset=20% to specify 20%.
+.BI (libhdfs)port
+The listening port of the HFDS cluster namenode.
 .TP
-.BI offset_increment \fR=\fPint
-If this is provided, then the real offset becomes the
-offset + offset_increment * thread_number, where the thread number is a
-counter that starts at 0 and is incremented for each sub-job (i.e. when
-numjobs option is specified). This option is useful if there are several jobs
-which are intended to operate on a file in parallel disjoint segments, with
-even spacing between the starting points.
+.BI (netsplice,net)port
+The TCP or UDP port to bind to or connect to. If this is used with
+\fBnumjobs\fR to spawn multiple instances of the same job type, then
+this will be the starting port number since fio will use a range of
+ports.
 .TP
-.BI number_ios \fR=\fPint
-Fio will normally perform IOs until it has exhausted the size of the region
-set by \fBsize\fR, or if it exhaust the allocated time (or hits an error
-condition). With this setting, the range/size can be set independently of
-the number of IOs to perform. When fio reaches this number, it will exit
-normally and report status. Note that this does not extend the amount
-of IO that will be done, it will only stop fio if this condition is met
-before other end-of-job criteria.
+.BI (netsplice,net)hostname \fR=\fPstr
+The hostname or IP address to use for TCP or UDP based I/O. If the job is
+a TCP listener or UDP reader, the hostname is not used and must be omitted
+unless it is a valid UDP multicast address.
 .TP
-.BI fsync \fR=\fPint
-How many I/Os to perform before issuing an \fBfsync\fR\|(2) of dirty data.  If
-0, don't sync.  Default: 0.
+.BI (netsplice,net)interface \fR=\fPstr
+The IP address of the network interface used to send or receive UDP
+multicast.
 .TP
-.BI fdatasync \fR=\fPint
-Like \fBfsync\fR, but uses \fBfdatasync\fR\|(2) instead to only sync the
-data parts of the file. Default: 0.
+.BI (netsplice,net)ttl \fR=\fPint
+Time\-to\-live value for outgoing UDP multicast packets. Default: 1.
 .TP
-.BI write_barrier \fR=\fPint
-Make every Nth write a barrier write.
+.BI (netsplice,net)nodelay \fR=\fPbool
+Set TCP_NODELAY on TCP connections.
 .TP
-.BI sync_file_range \fR=\fPstr:int
-Use \fBsync_file_range\fR\|(2) for every \fRval\fP number of write operations. Fio will
-track range of writes that have happened since the last \fBsync_file_range\fR\|(2) call.
-\fRstr\fP can currently be one or more of:
+.BI (netsplice,net)protocol \fR=\fPstr "\fR,\fP proto" \fR=\fPstr
+The network protocol to use. Accepted values are:
 .RS
-.TP
-.B wait_before
-SYNC_FILE_RANGE_WAIT_BEFORE
-.TP
-.B write
-SYNC_FILE_RANGE_WRITE
-.TP
-.B wait_after
-SYNC_FILE_RANGE_WAIT_AFTER
-.TP
-.RE
-.P
-So if you do sync_file_range=wait_before,write:8, fio would use
-\fBSYNC_FILE_RANGE_WAIT_BEFORE | SYNC_FILE_RANGE_WRITE\fP for every 8 writes.
-Also see the \fBsync_file_range\fR\|(2) man page.  This option is Linux specific.
-.TP
-.BI overwrite \fR=\fPbool
-If writing, setup the file first and do overwrites.  Default: false.
-.TP
-.BI end_fsync \fR=\fPbool
-Sync file contents when a write stage has completed.  Default: false.
-.TP
-.BI fsync_on_close \fR=\fPbool
-If true, sync file contents on close.  This differs from \fBend_fsync\fR in that
-it will happen on every close, not just at the end of the job.  Default: false.
-.TP
-.BI rwmixread \fR=\fPint
-Percentage of a mixed workload that should be reads. Default: 50.
-.TP
-.BI rwmixwrite \fR=\fPint
-Percentage of a mixed workload that should be writes.  If \fBrwmixread\fR and
-\fBrwmixwrite\fR are given and do not sum to 100%, the latter of the two
-overrides the first. This may interfere with a given rate setting, if fio is
-asked to limit reads or writes to a certain rate. If that is the case, then
-the distribution may be skewed. Default: 50.
-.TP
-.BI random_distribution \fR=\fPstr:float
-By default, fio will use a completely uniform random distribution when asked
-to perform random IO. Sometimes it is useful to skew the distribution in
-specific ways, ensuring that some parts of the data is more hot than others.
-Fio includes the following distribution models:
 .RS
 .TP
-.B random
-Uniform random distribution
-.TP
-.B zipf
-Zipf distribution
-.TP
-.B pareto
-Pareto distribution
+.B tcp
+Transmission control protocol.
 .TP
-.B normal
-Normal (Gaussian) distribution
+.B tcpv6
+Transmission control protocol V6.
 .TP
-.B zoned
-Zoned random distribution
+.B udp
+User datagram protocol.
 .TP
+.B udpv6
+User datagram protocol V6.
+.TP
+.B unix
+UNIX domain socket.
 .RE
-When using a \fBzipf\fR or \fBpareto\fR distribution, an input value is also
-needed to define the access pattern. For \fBzipf\fR, this is the zipf theta.
-For \fBpareto\fR, it's the pareto power. Fio includes a test program, genzipf,
-that can be used visualize what the given input values will yield in terms of
-hit rates. If you wanted to use \fBzipf\fR with a theta of 1.2, you would use
-random_distribution=zipf:1.2 as the option. If a non-uniform model is used,
-fio will disable use of the random map. For the \fBnormal\fR distribution, a
-normal (Gaussian) deviation is supplied as a value between 0 and 100.
-.P
-.RS
-For a \fBzoned\fR distribution, fio supports specifying percentages of IO
-access that should fall within what range of the file or device. For example,
-given a criteria of:
-.P
-.RS
-60% of accesses should be to the first 10%
-.RE
-.RS
-30% of accesses should be to the next 20%
-.RE
-.RS
-8% of accesses should be to the next 30%
+.P
+When the protocol is TCP or UDP, the port must also be given, as well as the
+hostname if the job is a TCP listener or UDP reader. For unix sockets, the
+normal \fBfilename\fR option should be used and the port is invalid.
 .RE
+.TP
+.BI (netsplice,net)listen
+For TCP network connections, tell fio to listen for incoming connections
+rather than initiating an outgoing connection. The \fBhostname\fR must
+be omitted if this option is used.
+.TP
+.BI (netsplice,net)pingpong
+Normally a network writer will just continue writing data, and a network
+reader will just consume packages. If `pingpong=1' is set, a writer will
+send its normal payload to the reader, then wait for the reader to send the
+same payload back. This allows fio to measure network latencies. The
+submission and completion latencies then measure local time spent sending or
+receiving, and the completion latency measures how long it took for the
+other end to receive and send back. For UDP multicast traffic
+`pingpong=1' should only be set for a single reader when multiple readers
+are listening to the same address.
+.TP
+.BI (netsplice,net)window_size \fR=\fPint
+Set the desired socket buffer size for the connection.
+.TP
+.BI (netsplice,net)mss \fR=\fPint
+Set the TCP maximum segment size (TCP_MAXSEG).
+.TP
+.BI (e4defrag)donorname \fR=\fPstr
+File will be used as a block donor (swap extents between files).
+.TP
+.BI (e4defrag)inplace \fR=\fPint
+Configure donor file blocks allocation strategy:
 .RS
-2% of accesses should be to the next 40%
-.RE
-.P
-we can define that through zoning of the random accesses. For the above
-example, the user would do:
-.P
 .RS
-.B random_distribution=zoned:60/10:30/20:8/30:2/40
+.TP
+.B 0
+Default. Preallocate donor's file on init.
+.TP
+.B 1
+Allocate space immediately inside defragment event, and free right
+after event.
 .RE
-.P
-similarly to how \fBbssplit\fR works for setting ranges and percentages of block
-sizes. Like \fBbssplit\fR, it's possible to specify separate zones for reads,
-writes, and trims. If just one set is given, it'll apply to all of them.
 .RE
 .TP
-.BI percentage_random \fR=\fPint[,int][,int]
-For a random workload, set how big a percentage should be random. This defaults
-to 100%, in which case the workload is fully random. It can be set from
-anywhere from 0 to 100.  Setting it to 0 would make the workload fully
-sequential. It is possible to set different values for reads, writes, and
-trim. To do so, simply use a comma separated list. See \fBblocksize\fR.
+.BI (rbd)clustername \fR=\fPstr
+Specifies the name of the Ceph cluster.
 .TP
-.B norandommap
-Normally \fBfio\fR will cover every block of the file when doing random I/O. If
-this parameter is given, a new offset will be chosen without looking at past
-I/O history.  This parameter is mutually exclusive with \fBverify\fR.
+.BI (rbd)rbdname \fR=\fPstr
+Specifies the name of the RBD.
 .TP
-.BI softrandommap \fR=\fPbool
-See \fBnorandommap\fR. If fio runs with the random block map enabled and it
-fails to allocate the map, if this option is set it will continue without a
-random block map. As coverage will not be as complete as with random maps, this
-option is disabled by default.
+.BI (rbd)pool \fR=\fPstr
+Specifies the name of the Ceph pool containing RBD.
 .TP
-.BI random_generator \fR=\fPstr
-Fio supports the following engines for generating IO offsets for random IO:
-.RS
+.BI (rbd)clientname \fR=\fPstr
+Specifies the username (without the 'client.' prefix) used to access the
+Ceph cluster. If the \fBclustername\fR is specified, the \fBclientname\fR shall be
+the full *type.id* string. If no type. prefix is given, fio will add 'client.'
+by default.
 .TP
-.B tausworthe
-Strong 2^88 cycle random number generator
+.BI (mtd)skip_bad \fR=\fPbool
+Skip operations against known bad blocks.
 .TP
-.B lfsr
-Linear feedback shift register generator
+.BI (libhdfs)hdfsdirectory
+libhdfs will create chunk in this HDFS directory.
 .TP
-.B tausworthe64
-Strong 64-bit 2^258 cycle random number generator
+.BI (libhdfs)chunk_size
+The size of the chunk to use for each file.
+.SS "I/O depth"
+.TP
+.BI iodepth \fR=\fPint
+Number of I/O units to keep in flight against the file. Note that
+increasing \fBiodepth\fR beyond 1 will not affect synchronous ioengines (except
+for small degrees when \fBverify_async\fR is in use). Even async
+engines may impose OS restrictions causing the desired depth not to be
+achieved. This may happen on Linux when using libaio and not setting
+`direct=1', since buffered I/O is not async on that OS. Keep an
+eye on the I/O depth distribution in the fio output to verify that the
+achieved depth is as expected. Default: 1.
+.TP
+.BI iodepth_batch_submit \fR=\fPint "\fR,\fP iodepth_batch" \fR=\fPint
+This defines how many pieces of I/O to submit at once. It defaults to 1
+which means that we submit each I/O as soon as it is available, but can be
+raised to submit bigger batches of I/O at the time. If it is set to 0 the
+\fBiodepth\fR value will be used.
+.TP
+.BI iodepth_batch_complete_min \fR=\fPint "\fR,\fP iodepth_batch_complete" \fR=\fPint
+This defines how many pieces of I/O to retrieve at once. It defaults to 1
+which means that we'll ask for a minimum of 1 I/O in the retrieval process
+from the kernel. The I/O retrieval will go on until we hit the limit set by
+\fBiodepth_low\fR. If this variable is set to 0, then fio will always
+check for completed events before queuing more I/O. This helps reduce I/O
+latency, at the cost of more retrieval system calls.
 .TP
+.BI iodepth_batch_complete_max \fR=\fPint
+This defines maximum pieces of I/O to retrieve at once. This variable should
+be used along with \fBiodepth_batch_complete_min\fR=\fIint\fR variable,
+specifying the range of min and max amount of I/O which should be
+retrieved. By default it is equal to \fBiodepth_batch_complete_min\fR
+value. Example #1:
+.RS
+.RS
+.P
+.PD 0
+iodepth_batch_complete_min=1
+.P
+iodepth_batch_complete_max=<iodepth>
+.PD
+.RE
+.P
+which means that we will retrieve at least 1 I/O and up to the whole
+submitted queue depth. If none of I/O has been completed yet, we will wait.
+Example #2:
+.RS
+.P
+.PD 0
+iodepth_batch_complete_min=0
+.P
+iodepth_batch_complete_max=<iodepth>
+.PD
 .RE
 .P
-Tausworthe is a strong random number generator, but it requires tracking on the
-side if we want to ensure that blocks are only read or written once. LFSR
-guarantees that we never generate the same offset twice, and it's also less
-computationally expensive. It's not a true random generator, however, though
-for IO purposes it's typically good enough. LFSR only works with single block
-sizes, not with workloads that use multiple block sizes. If used with such a
-workload, fio may read or write some blocks multiple times. The default
-value is tausworthe, unless the required space exceeds 2^32 blocks. If it does,
-then tausworthe64 is selected automatically.
+which means that we can retrieve up to the whole submitted queue depth, but
+if none of I/O has been completed yet, we will NOT wait and immediately exit
+the system call. In this example we simply do polling.
+.RE
 .TP
-.BI nice \fR=\fPint
-Run job with given nice value.  See \fBnice\fR\|(2).
+.BI iodepth_low \fR=\fPint
+The low water mark indicating when to start filling the queue
+again. Defaults to the same as \fBiodepth\fR, meaning that fio will
+attempt to keep the queue full at all times. If \fBiodepth\fR is set to
+e.g. 16 and \fBiodepth_low\fR is set to 4, then after fio has filled the queue of
+16 requests, it will let the depth drain down to 4 before starting to fill
+it again.
 .TP
-.BI prio \fR=\fPint
-Set I/O priority value of this job between 0 (highest) and 7 (lowest).  See
-\fBionice\fR\|(1).
+.BI serialize_overlap \fR=\fPbool
+Serialize in-flight I/Os that might otherwise cause or suffer from data races.
+When two or more I/Os are submitted simultaneously, there is no guarantee that
+the I/Os will be processed or completed in the submitted order. Further, if
+two or more of those I/Os are writes, any overlapping region between them can
+become indeterminate/undefined on certain storage. These issues can cause
+verification to fail erratically when at least one of the racing I/Os is
+changing data and the overlapping region has a non-zero size. Setting
+\fBserialize_overlap\fR tells fio to avoid provoking this behavior by explicitly
+serializing in-flight I/Os that have a non-zero overlap. Note that setting
+this option can reduce both performance and the \fBiodepth\fR achieved.
+Additionally this option does not work when \fBio_submit_mode\fR is set to
+offload. Default: false.
 .TP
-.BI prioclass \fR=\fPint
-Set I/O priority class.  See \fBionice\fR\|(1).
+.BI io_submit_mode \fR=\fPstr
+This option controls how fio submits the I/O to the I/O engine. The default
+is `inline', which means that the fio job threads submit and reap I/O
+directly. If set to `offload', the job threads will offload I/O submission
+to a dedicated pool of I/O threads. This requires some coordination and thus
+has a bit of extra overhead, especially for lower queue depth I/O where it
+can increase latencies. The benefit is that fio can manage submission rates
+independently of the device completion rates. This avoids skewed latency
+reporting if I/O gets backed up on the device side (the coordinated omission
+problem).
+.SS "I/O rate"
 .TP
-.BI thinktime \fR=\fPint
-Stall job for given number of microseconds between issuing I/Os.
+.BI thinktime \fR=\fPtime
+Stall the job for the specified period of time after an I/O has completed before issuing the
+next. May be used to simulate processing being done by an application.
+When the unit is omitted, the value is interpreted in microseconds. See
+\fBthinktime_blocks\fR and \fBthinktime_spin\fR.
 .TP
-.BI thinktime_spin \fR=\fPint
-Pretend to spend CPU time for given number of microseconds, sleeping the rest
-of the time specified by \fBthinktime\fR.  Only valid if \fBthinktime\fR is set.
+.BI thinktime_spin \fR=\fPtime
+Only valid if \fBthinktime\fR is set \- pretend to spend CPU time doing
+something with the data received, before falling back to sleeping for the
+rest of the period specified by \fBthinktime\fR. When the unit is
+omitted, the value is interpreted in microseconds.
 .TP
 .BI thinktime_blocks \fR=\fPint
-Only valid if thinktime is set - control how many blocks to issue, before
-waiting \fBthinktime\fR microseconds. If not set, defaults to 1 which will
-make fio wait \fBthinktime\fR microseconds after every block. This
-effectively makes any queue depth setting redundant, since no more than 1 IO
-will be queued before we have to complete it and do our thinktime. In other
-words, this setting effectively caps the queue depth if the latter is larger.
-Default: 1.
+Only valid if \fBthinktime\fR is set \- control how many blocks to issue,
+before waiting \fBthinktime\fR usecs. If not set, defaults to 1 which will make
+fio wait \fBthinktime\fR usecs after every block. This effectively makes any
+queue depth setting redundant, since no more than 1 I/O will be queued
+before we have to complete it and do our \fBthinktime\fR. In other words, this
+setting effectively caps the queue depth if the latter is larger.
 .TP
 .BI rate \fR=\fPint[,int][,int]
-Cap bandwidth used by this job. The number is in bytes/sec, the normal postfix
-rules apply. You can use \fBrate\fR=500k to limit reads and writes to 500k each,
-or you can specify reads, write, and trim limits separately.
-Using \fBrate\fR=1m,500k would
-limit reads to 1MiB/sec and writes to 500KiB/sec. Capping only reads or writes
-can be done with \fBrate\fR=,500k or \fBrate\fR=500k,. The former will only
-limit writes (to 500KiB/sec), the latter will only limit reads.
+Cap the bandwidth used by this job. The number is in bytes/sec, the normal
+suffix rules apply. Comma\-separated values may be specified for reads,
+writes, and trims as described in \fBblocksize\fR.
+.RS
+.P
+For example, using `rate=1m,500k' would limit reads to 1MiB/sec and writes to
+500KiB/sec. Capping only reads or writes can be done with `rate=,500k' or
+`rate=500k,' where the former will only limit writes (to 500KiB/sec) and the
+latter will only limit reads.
+.RE
 .TP
 .BI rate_min \fR=\fPint[,int][,int]
-Tell \fBfio\fR to do whatever it can to maintain at least the given bandwidth.
-Failing to meet this requirement will cause the job to exit. The same format
-as \fBrate\fR is used for read vs write vs trim separation.
+Tell fio to do whatever it can to maintain at least this bandwidth. Failing
+to meet this requirement will cause the job to exit. Comma\-separated values
+may be specified for reads, writes, and trims as described in
+\fBblocksize\fR.
 .TP
 .BI rate_iops \fR=\fPint[,int][,int]
-Cap the bandwidth to this number of IOPS. Basically the same as rate, just
-specified independently of bandwidth. The same format as \fBrate\fR is used for
-read vs write vs trim separation. If \fBblocksize\fR is a range, the smallest block
-size is used as the metric.
+Cap the bandwidth to this number of IOPS. Basically the same as
+\fBrate\fR, just specified independently of bandwidth. If the job is
+given a block size range instead of a fixed value, the smallest block size
+is used as the metric. Comma\-separated values may be specified for reads,
+writes, and trims as described in \fBblocksize\fR.
 .TP
 .BI rate_iops_min \fR=\fPint[,int][,int]
-If this rate of I/O is not met, the job will exit. The same format as \fBrate\fR
-is used for read vs write vs trim separation.
+If fio doesn't meet this rate of I/O, it will cause the job to exit.
+Comma\-separated values may be specified for reads, writes, and trims as
+described in \fBblocksize\fR.
 .TP
 .BI rate_process \fR=\fPstr
-This option controls how fio manages rated IO submissions. The default is
-\fBlinear\fR, which submits IO in a linear fashion with fixed delays between
-IOs that gets adjusted based on IO completion rates. If this is set to
-\fBpoisson\fR, fio will submit IO based on a more real world random request
+This option controls how fio manages rated I/O submissions. The default is
+`linear', which submits I/O in a linear fashion with fixed delays between
+I/Os that gets adjusted based on I/O completion rates. If this is set to
+`poisson', fio will submit I/O based on a more real world random request
 flow, known as the Poisson process
-(https://en.wikipedia.org/wiki/Poisson_process). The lambda will be
+(\fIhttps://en.wikipedia.org/wiki/Poisson_point_process\fR). The lambda will be
 10^6 / IOPS for the given workload.
+.SS "I/O latency"
 .TP
-.BI rate_cycle \fR=\fPint
-Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number of
-milliseconds.  Default: 1000ms.
-.TP
-.BI latency_target \fR=\fPint
+.BI latency_target \fR=\fPtime
 If set, fio will attempt to find the max performance point that the given
-workload will run at while maintaining a latency below this target. The
-values is given in microseconds. See \fBlatency_window\fR and
-\fBlatency_percentile\fR.
+workload will run at while maintaining a latency below this target. When
+the unit is omitted, the value is interpreted in microseconds. See
+\fBlatency_window\fR and \fBlatency_percentile\fR.
 .TP
-.BI latency_window \fR=\fPint
+.BI latency_window \fR=\fPtime
 Used with \fBlatency_target\fR to specify the sample window that the job
-is run at varying queue depths to test the performance. The value is given
-in microseconds.
+is run at varying queue depths to test the performance. When the unit is
+omitted, the value is interpreted in microseconds.
 .TP
 .BI latency_percentile \fR=\fPfloat
-The percentage of IOs that must fall within the criteria specified by
-\fBlatency_target\fR and \fBlatency_window\fR. If not set, this defaults
-to 100.0, meaning that all IOs must be equal or below to the value set
-by \fBlatency_target\fR.
+The percentage of I/Os that must fall within the criteria specified by
+\fBlatency_target\fR and \fBlatency_window\fR. If not set, this
+defaults to 100.0, meaning that all I/Os must be equal or below to the value
+set by \fBlatency_target\fR.
+.TP
+.BI max_latency \fR=\fPtime
+If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
+maximum latency. When the unit is omitted, the value is interpreted in
+microseconds.
+.TP
+.BI rate_cycle \fR=\fPint
+Average bandwidth for \fBrate\fR and \fBrate_min\fR over this number
+of milliseconds. Defaults to 1000.
+.SS "I/O replay"
+.TP
+.BI write_iolog \fR=\fPstr
+Write the issued I/O patterns to the specified file. See
+\fBread_iolog\fR. Specify a separate file for each job, otherwise the
+iologs will be interspersed and the file may be corrupt.
+.TP
+.BI read_iolog \fR=\fPstr
+Open an iolog with the specified filename and replay the I/O patterns it
+contains. This can be used to store a workload and replay it sometime
+later. The iolog given may also be a blktrace binary file, which allows fio
+to replay a workload captured by blktrace. See
+\fBblktrace\fR\|(8) for how to capture such logging data. For blktrace
+replay, the file needs to be turned into a blkparse binary data file first
+(`blkparse <device> \-o /dev/null \-d file_for_fio.bin').
+.TP
+.BI replay_no_stall \fR=\fPbool
+When replaying I/O with \fBread_iolog\fR the default behavior is to
+attempt to respect the timestamps within the log and replay them with the
+appropriate delay between IOPS. By setting this variable fio will not
+respect the timestamps and attempt to replay them as fast as possible while
+still respecting ordering. The result is the same I/O pattern to a given
+device, but different timings.
+.TP
+.BI replay_redirect \fR=\fPstr
+While replaying I/O patterns using \fBread_iolog\fR the default behavior
+is to replay the IOPS onto the major/minor device that each IOP was recorded
+from. This is sometimes undesirable because on a different machine those
+major/minor numbers can map to a different device. Changing hardware on the
+same system can also result in a different major/minor mapping.
+\fBreplay_redirect\fR causes all I/Os to be replayed onto the single specified
+device regardless of the device it was recorded
+from. i.e. `replay_redirect=/dev/sdc' would cause all I/O
+in the blktrace or iolog to be replayed onto `/dev/sdc'. This means
+multiple devices will be replayed onto a single device, if the trace
+contains multiple devices. If you want multiple devices to be replayed
+concurrently to multiple redirected devices you must blkparse your trace
+into separate traces and replay them with independent fio invocations.
+Unfortunately this also breaks the strict time ordering between multiple
+device accesses.
+.TP
+.BI replay_align \fR=\fPint
+Force alignment of I/O offsets and lengths in a trace to this power of 2
+value.
+.TP
+.BI replay_scale \fR=\fPint
+Scale sector offsets down by this factor when replaying traces.
+.SS "Threads, processes and job synchronization"
+.TP
+.BI thread
+Fio defaults to creating jobs by using fork, however if this option is
+given, fio will create jobs by using POSIX Threads' function
+\fBpthread_create\fR\|(3) to create threads instead.
+.TP
+.BI wait_for \fR=\fPstr
+If set, the current job won't be started until all workers of the specified
+waitee job are done.
+.\" ignore blank line here from HOWTO as it looks normal without it
+\fBwait_for\fR operates on the job name basis, so there are a few
+limitations. First, the waitee must be defined prior to the waiter job
+(meaning no forward references). Second, if a job is being referenced as a
+waitee, it must have a unique name (no duplicate waitees).
+.TP
+.BI nice \fR=\fPint
+Run the job with the given nice value. See man \fBnice\fR\|(2).
+.\" ignore blank line here from HOWTO as it looks normal without it
+On Windows, values less than \-15 set the process class to "High"; \-1 through
+\-15 set "Above Normal"; 1 through 15 "Below Normal"; and above 15 "Idle"
+priority class.
+.TP
+.BI prio \fR=\fPint
+Set the I/O priority value of this job. Linux limits us to a positive value
+between 0 and 7, with 0 being the highest. See man
+\fBionice\fR\|(1). Refer to an appropriate manpage for other operating
+systems since meaning of priority may differ.
 .TP
-.BI max_latency \fR=\fPint
-If set, fio will exit the job if it exceeds this maximum latency. It will exit
-with an ETIME error.
+.BI prioclass \fR=\fPint
+Set the I/O priority class. See man \fBionice\fR\|(1).
 .TP
 .BI cpumask \fR=\fPint
-Set CPU affinity for this job. \fIint\fR is a bitmask of allowed CPUs the job
-may run on.  See \fBsched_setaffinity\fR\|(2).
+Set the CPU affinity of this job. The parameter given is a bit mask of
+allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
+and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
+\fBsched_setaffinity\fR\|(2). This may not work on all supported
+operating systems or kernel versions. This option doesn't work well for a
+higher CPU count than what you can store in an integer mask, so it can only
+control cpus 1\-32. For boxes with larger CPU counts, use
+\fBcpus_allowed\fR.
 .TP
 .BI cpus_allowed \fR=\fPstr
-Same as \fBcpumask\fR, but allows a comma-delimited list of CPU numbers.
+Controls the same options as \fBcpumask\fR, but accepts a textual
+specification of the permitted CPUs instead. So to use CPUs 1 and 5 you
+would specify `cpus_allowed=1,5'. This option also allows a range of CPUs
+to be specified \-\- say you wanted a binding to CPUs 1, 5, and 8 to 15, you
+would set `cpus_allowed=1,5,8\-15'.
 .TP
 .BI cpus_allowed_policy \fR=\fPstr
-Set the policy of how fio distributes the CPUs specified by \fBcpus_allowed\fR
-or \fBcpumask\fR. Two policies are supported:
+Set the policy of how fio distributes the CPUs specified by
+\fBcpus_allowed\fR or \fBcpumask\fR. Two policies are supported:
 .RS
 .RS
 .TP
@@ -1368,839 +2009,705 @@ All jobs will share the CPU set specified.
 Each job will get a unique CPU from the CPU set.
 .RE
 .P
-\fBshared\fR is the default behaviour, if the option isn't specified. If
-\fBsplit\fR is specified, then fio will assign one cpu per job. If not enough
-CPUs are given for the jobs listed, then fio will roundrobin the CPUs in
-the set.
+\fBshared\fR is the default behavior, if the option isn't specified. If
+\fBsplit\fR is specified, then fio will will assign one cpu per job. If not
+enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
+in the set.
 .RE
-.P
 .TP
 .BI numa_cpu_nodes \fR=\fPstr
 Set this job running on specified NUMA nodes' CPUs. The arguments allow
-comma delimited list of cpu numbers, A-B ranges, or 'all'.
+comma delimited list of cpu numbers, A\-B ranges, or `all'. Note, to enable
+NUMA options support, fio must be built on a system with libnuma\-dev(el)
+installed.
 .TP
 .BI numa_mem_policy \fR=\fPstr
-Set this job's memory policy and corresponding NUMA nodes. Format of
-the arguments:
+Set this job's memory policy and corresponding NUMA nodes. Format of the
+arguments:
 .RS
-.TP
-.B <mode>[:<nodelist>]
-.TP
-.B mode
-is one of the following memory policy:
-.TP
-.B default, prefer, bind, interleave, local
-.TP
+.RS
+.P
+<mode>[:<nodelist>]
+.RE
+.P
+`mode' is one of the following memory poicies: `default', `prefer',
+`bind', `interleave' or `local'. For `default' and `local' memory
+policies, no node needs to be specified. For `prefer', only one node is
+allowed. For `bind' and `interleave' the `nodelist' may be as
+follows: a comma delimited list of numbers, A\-B ranges, or `all'.
 .RE
-For \fBdefault\fR and \fBlocal\fR memory policy, no \fBnodelist\fR is
-needed to be specified. For \fBprefer\fR, only one node is
-allowed. For \fBbind\fR and \fBinterleave\fR, \fBnodelist\fR allows
-comma delimited list of numbers, A-B ranges, or 'all'.
-.TP
-.BI startdelay \fR=\fPirange
-Delay start of job for the specified number of seconds. Supports all time
-suffixes to allow specification of hours, minutes, seconds and
-milliseconds - seconds are the default if a unit is omitted.
-Can be given as a range which causes each thread to choose randomly out of the
-range.
-.TP
-.BI runtime \fR=\fPint
-Terminate processing after the specified number of seconds.
-.TP
-.B time_based
-If given, run for the specified \fBruntime\fR duration even if the files are
-completely read or written. The same workload will be repeated as many times
-as \fBruntime\fR allows.
-.TP
-.BI ramp_time \fR=\fPint
-If set, fio will run the specified workload for this amount of time before
-logging any performance numbers. Useful for letting performance settle before
-logging results, thus minimizing the runtime required for stable results. Note
-that the \fBramp_time\fR is considered lead in time for a job, thus it will
-increase the total runtime if a special timeout or runtime is specified.
 .TP
-.BI steadystate \fR=\fPstr:float "\fR,\fP ss" \fR=\fPstr:float
-Define the criterion and limit for assessing steady state performance. The
-first parameter designates the criterion whereas the second parameter sets the
-threshold. When the criterion falls below the threshold for the specified
-duration, the job will stop. For example, iops_slope:0.1% will direct fio
-to terminate the job when the least squares regression slope falls below 0.1%
-of the mean IOPS. If group_reporting is enabled this will apply to all jobs in
-the group. All assessments are carried out using only data from the rolling
-collection window. Threshold limits can be expressed as a fixed value or as a
-percentage of the mean in the collection window. Below are the available steady
-state assessment criteria.
+.BI cgroup \fR=\fPstr
+Add job to this control group. If it doesn't exist, it will be created. The
+system must have a mounted cgroup blkio mount point for this to work. If
+your system doesn't have it mounted, you can do so with:
 .RS
 .RS
-.TP
-.B iops
-Collect IOPS data. Stop the job if all individual IOPS measurements are within
-the specified limit of the mean IOPS (e.g., iops:2 means that all individual
-IOPS values must be within 2 of the mean, whereas iops:0.2% means that all
-individual IOPS values must be within 0.2% of the mean IOPS to terminate the
-job).
-.TP
-.B iops_slope
-Collect IOPS data and calculate the least squares regression slope. Stop the
-job if the slope falls below the specified limit.
-.TP
-.B bw
-Collect bandwidth data. Stop the job if all individual bandwidth measurements
-are within the specified limit of the mean bandwidth.
-.TP
-.B bw_slope
-Collect bandwidth data and calculate the least squares regression slope. Stop
-the job if the slope falls below the specified limit.
+.P
+# mount \-t cgroup \-o blkio none /cgroup
 .RE
 .RE
 .TP
-.BI steadystate_duration \fR=\fPtime "\fR,\fP ss_dur" \fR=\fPtime
-A rolling window of this duration will be used to judge whether steady state
-has been reached. Data will be collected once per second. The default is 0
-which disables steady state detection.
-.TP
-.BI steadystate_ramp_time \fR=\fPtime "\fR,\fP ss_ramp" \fR=\fPtime
-Allow the job to run for the specified duration before beginning data collection
-for checking the steady state job termination criterion. The default is 0.
-.TP
-.BI invalidate \fR=\fPbool
-Invalidate buffer-cache for the file prior to starting I/O.  Default: true.
+.BI cgroup_weight \fR=\fPint
+Set the weight of the cgroup to this value. See the documentation that comes
+with the kernel, allowed values are in the range of 100..1000.
 .TP
-.BI sync \fR=\fPbool
-Use synchronous I/O for buffered writes.  For the majority of I/O engines,
-this means using O_SYNC.  Default: false.
+.BI cgroup_nodelete \fR=\fPbool
+Normally fio will delete the cgroups it has created after the job
+completion. To override this behavior and to leave cgroups around after the
+job completion, set `cgroup_nodelete=1'. This can be useful if one wants
+to inspect various cgroup files after job completion. Default: false.
 .TP
-.BI iomem \fR=\fPstr "\fR,\fP mem" \fR=\fPstr
-Allocation method for I/O unit buffer.  Allowed values are:
-.RS
-.RS
+.BI flow_id \fR=\fPint
+The ID of the flow. If not specified, it defaults to being a global
+flow. See \fBflow\fR.
 .TP
-.B malloc
-Allocate memory with \fBmalloc\fR\|(3). Default memory type.
+.BI flow \fR=\fPint
+Weight in token\-based flow control. If this value is used, then there is
+a 'flow counter' which is used to regulate the proportion of activity between
+two or more jobs. Fio attempts to keep this flow counter near zero. The
+\fBflow\fR parameter stands for how much should be added or subtracted to the
+flow counter on each iteration of the main I/O loop. That is, if one job has
+`flow=8' and another job has `flow=\-1', then there will be a roughly 1:8
+ratio in how much one runs vs the other.
 .TP
-.B shm
-Use shared memory buffers allocated through \fBshmget\fR\|(2).
+.BI flow_watermark \fR=\fPint
+The maximum value that the absolute value of the flow counter is allowed to
+reach before the job must wait for a lower value of the counter.
 .TP
-.B shmhuge
-Same as \fBshm\fR, but use huge pages as backing.
+.BI flow_sleep \fR=\fPint
+The period of time, in microseconds, to wait after the flow watermark has
+been exceeded before retrying operations.
 .TP
-.B mmap
-Use \fBmmap\fR\|(2) for allocation.  Uses anonymous memory unless a filename
-is given after the option in the format `:\fIfile\fR'.
+.BI stonewall "\fR,\fB wait_for_previous"
+Wait for preceding jobs in the job file to exit, before starting this
+one. Can be used to insert serialization points in the job file. A stone
+wall also implies starting a new reporting group, see
+\fBgroup_reporting\fR.
 .TP
-.B mmaphuge
-Same as \fBmmap\fR, but use huge files as backing.
+.BI exitall
+By default, fio will continue running all other jobs when one job finishes
+but sometimes this is not the desired action. Setting \fBexitall\fR will
+instead make fio terminate all other jobs when one job finishes.
 .TP
-.B mmapshared
-Same as \fBmmap\fR, but use a MMAP_SHARED mapping.
+.BI exec_prerun \fR=\fPstr
+Before running this job, issue the command specified through
+\fBsystem\fR\|(3). Output is redirected in a file called `jobname.prerun.txt'.
 .TP
-.B cudamalloc
-Use GPU memory as the buffers for GPUDirect RDMA benchmark. The ioengine must be \fBrdma\fR.
-.RE
-.P
-The amount of memory allocated is the maximum allowed \fBblocksize\fR for the
-job multiplied by \fBiodepth\fR.  For \fBshmhuge\fR or \fBmmaphuge\fR to work,
-the system must have free huge pages allocated.  \fBmmaphuge\fR also needs to
-have hugetlbfs mounted, and \fIfile\fR must point there. At least on Linux,
-huge pages must be manually allocated. See \fB/proc/sys/vm/nr_hugehages\fR
-and the documentation for that. Normally you just need to echo an appropriate
-number, eg echoing 8 will ensure that the OS has 8 huge pages ready for
-use.
-.RE
+.BI exec_postrun \fR=\fPstr
+After the job completes, issue the command specified though
+\fBsystem\fR\|(3). Output is redirected in a file called `jobname.postrun.txt'.
 .TP
-.BI iomem_align \fR=\fPint "\fR,\fP mem_align" \fR=\fPint
-This indicates the memory alignment of the IO memory buffers. Note that the
-given alignment is applied to the first IO unit buffer, if using \fBiodepth\fR
-the alignment of the following buffers are given by the \fBbs\fR used. In
-other words, if using a \fBbs\fR that is a multiple of the page sized in the
-system, all buffers will be aligned to this value. If using a \fBbs\fR that
-is not page aligned, the alignment of subsequent IO memory buffers is the
-sum of the \fBiomem_align\fR and \fBbs\fR used.
+.BI uid \fR=\fPint
+Instead of running as the invoking user, set the user ID to this value
+before the thread/process does any work.
 .TP
-.BI hugepage\-size \fR=\fPint
-Defines the size of a huge page.  Must be at least equal to the system setting.
-Should be a multiple of 1MiB. Default: 4MiB.
+.BI gid \fR=\fPint
+Set group ID, see \fBuid\fR.
+.SS "Verification"
 .TP
-.B exitall
-Terminate all jobs when one finishes.  Default: wait for each job to finish.
+.BI verify_only
+Do not perform specified workload, only verify data still matches previous
+invocation of this workload. This option allows one to check data multiple
+times at a later date without overwriting it. This option makes sense only
+for workloads that write data, and does not support workloads with the
+\fBtime_based\fR option set.
 .TP
-.B exitall_on_error
-Terminate all jobs if one job finishes in error.  Default: wait for each job
-to finish.
+.BI do_verify \fR=\fPbool
+Run the verify phase after a write phase. Only valid if \fBverify\fR is
+set. Default: true.
 .TP
-.BI bwavgtime \fR=\fPint
-Average bandwidth calculations over the given time in milliseconds. If the job
-also does bandwidth logging through \fBwrite_bw_log\fR, then the minimum of
-this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
+.BI verify \fR=\fPstr
+If writing to a file, fio can verify the file contents after each iteration
+of the job. Each verification method also implies verification of special
+header, which is written to the beginning of each block. This header also
+includes meta information, like offset of the block, block number, timestamp
+when block was written, etc. \fBverify\fR can be combined with
+\fBverify_pattern\fR option. The allowed values are:
+.RS
+.RS
 .TP
-.BI iopsavgtime \fR=\fPint
-Average IOPS calculations over the given time in milliseconds. If the job
-also does IOPS logging through \fBwrite_iops_log\fR, then the minimum of
-this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
+.B md5
+Use an md5 sum of the data area and store it in the header of
+each block.
 .TP
-.BI create_serialize \fR=\fPbool
-If true, serialize file creation for the jobs.  Default: true.
+.B crc64
+Use an experimental crc64 sum of the data area and store it in the
+header of each block.
 .TP
-.BI create_fsync \fR=\fPbool
-\fBfsync\fR\|(2) data file after creation.  Default: true.
+.B crc32c
+Use a crc32c sum of the data area and store it in the header of
+each block. This will automatically use hardware acceleration
+(e.g. SSE4.2 on an x86 or CRC crypto extensions on ARM64) but will
+fall back to software crc32c if none is found. Generally the
+fatest checksum fio supports when hardware accelerated.
 .TP
-.BI create_on_open \fR=\fPbool
-If true, the files are not created until they are opened for IO by the job.
+.B crc32c\-intel
+Synonym for crc32c.
 .TP
-.BI create_only \fR=\fPbool
-If true, fio will only run the setup phase of the job. If files need to be
-laid out or updated on disk, only that will be done. The actual job contents
-are not executed.
+.B crc32
+Use a crc32 sum of the data area and store it in the header of each
+block.
 .TP
-.BI allow_file_create \fR=\fPbool
-If true, fio is permitted to create files as part of its workload. This is
-the default behavior. If this option is false, then fio will error out if the
-files it needs to use don't already exist. Default: true.
+.B crc16
+Use a crc16 sum of the data area and store it in the header of each
+block.
 .TP
-.BI allow_mounted_write \fR=\fPbool
-If this isn't set, fio will abort jobs that are destructive (eg that write)
-to what appears to be a mounted device or partition. This should help catch
-creating inadvertently destructive tests, not realizing that the test will
-destroy data on the mounted file system. Default: false.
+.B crc7
+Use a crc7 sum of the data area and store it in the header of each
+block.
 .TP
-.BI pre_read \fR=\fPbool
-If this is given, files will be pre-read into memory before starting the given
-IO operation. This will also clear the \fR \fBinvalidate\fR flag, since it is
-pointless to pre-read and then drop the cache. This will only work for IO
-engines that are seekable, since they allow you to read the same data
-multiple times. Thus it will not work on eg network or splice IO.
+.B xxhash
+Use xxhash as the checksum function. Generally the fastest software
+checksum that fio supports.
 .TP
-.BI unlink \fR=\fPbool
-Unlink job files when done.  Default: false.
+.B sha512
+Use sha512 as the checksum function.
 .TP
-.BI unlink_each_loop \fR=\fPbool
-Unlink job files after each iteration or loop.  Default: false.
+.B sha256
+Use sha256 as the checksum function.
 .TP
-.BI loops \fR=\fPint
-Specifies the number of iterations (runs of the same workload) of this job.
-Default: 1.
+.B sha1
+Use optimized sha1 as the checksum function.
 .TP
-.BI verify_only
-Do not perform the specified workload, only verify data still matches previous
-invocation of this workload. This option allows one to check data multiple
-times at a later date without overwriting it. This option makes sense only for
-workloads that write data, and does not support workloads with the
-\fBtime_based\fR option set.
+.B sha3\-224
+Use optimized sha3\-224 as the checksum function.
 .TP
-.BI do_verify \fR=\fPbool
-Run the verify phase after a write phase.  Only valid if \fBverify\fR is set.
-Default: true.
+.B sha3\-256
+Use optimized sha3\-256 as the checksum function.
 .TP
-.BI verify \fR=\fPstr
-Method of verifying file contents after each iteration of the job. Each
-verification method also implies verification of special header, which is
-written to the beginning of each block. This header also includes meta
-information, like offset of the block, block number, timestamp when block
-was written, etc.  \fBverify\fR=str can be combined with \fBverify_pattern\fR=str
-option.  The allowed values are:
-.RS
-.RS
+.B sha3\-384
+Use optimized sha3\-384 as the checksum function.
 .TP
-.B md5 crc16 crc32 crc32c crc32c-intel crc64 crc7 sha256 sha512 sha1 sha3-224 sha3-256 sha3-384 sha3-512 xxhash
-Store appropriate checksum in the header of each block. crc32c-intel is
-hardware accelerated SSE4.2 driven, falls back to regular crc32c if
-not supported by the system.
+.B sha3\-512
+Use optimized sha3\-512 as the checksum function.
 .TP
 .B meta
-This option is deprecated, since now meta information is included in generic
-verification header and meta verification happens by default.  For detailed
-information see the description of the \fBverify\fR=str setting. This option
-is kept because of compatibility's sake with old configurations. Do not use it.
+This option is deprecated, since now meta information is included in
+generic verification header and meta verification happens by
+default. For detailed information see the description of the
+\fBverify\fR setting. This option is kept because of
+compatibility's sake with old configurations. Do not use it.
 .TP
 .B pattern
-Verify a strict pattern. Normally fio includes a header with some basic
-information and checksumming, but if this option is set, only the
-specific pattern set with \fBverify_pattern\fR is verified.
+Verify a strict pattern. Normally fio includes a header with some
+basic information and checksumming, but if this option is set, only
+the specific pattern set with \fBverify_pattern\fR is verified.
 .TP
 .B null
-Pretend to verify.  Used for testing internals.
+Only pretend to verify. Useful for testing internals with
+`ioengine=null', not for much else.
 .RE
-
-This option can be used for repeated burn-in tests of a system to make sure
-that the written data is also correctly read back. If the data direction given
-is a read or random read, fio will assume that it should verify a previously
-written file. If the data direction includes any form of write, the verify will
-be of the newly written data.
+.P
+This option can be used for repeated burn\-in tests of a system to make sure
+that the written data is also correctly read back. If the data direction
+given is a read or random read, fio will assume that it should verify a
+previously written file. If the data direction includes any form of write,
+the verify will be of the newly written data.
 .RE
 .TP
 .BI verifysort \fR=\fPbool
-If true, written verify blocks are sorted if \fBfio\fR deems it to be faster to
-read them back in a sorted manner.  Default: true.
+If true, fio will sort written verify blocks when it deems it faster to read
+them back in a sorted manner. This is often the case when overwriting an
+existing file, since the blocks are already laid out in the file system. You
+can ignore this option unless doing huge amounts of really fast I/O where
+the red\-black tree sorting CPU time becomes significant. Default: true.
 .TP
 .BI verifysort_nr \fR=\fPint
-Pre-load and sort verify blocks for a read workload.
+Pre\-load and sort verify blocks for a read workload.
 .TP
 .BI verify_offset \fR=\fPint
 Swap the verification header with data somewhere else in the block before
-writing.  It is swapped back before verifying.
+writing. It is swapped back before verifying.
 .TP
 .BI verify_interval \fR=\fPint
-Write the verification header for this number of bytes, which should divide
-\fBblocksize\fR.  Default: \fBblocksize\fR.
+Write the verification header at a finer granularity than the
+\fBblocksize\fR. It will be written for chunks the size of
+\fBverify_interval\fR. \fBblocksize\fR should divide this evenly.
 .TP
 .BI verify_pattern \fR=\fPstr
-If set, fio will fill the io buffers with this pattern. Fio defaults to filling
-with totally random bytes, but sometimes it's interesting to fill with a known
-pattern for io verification purposes. Depending on the width of the pattern,
-fio will fill 1/2/3/4 bytes of the buffer at the time(it can be either a
-decimal or a hex number). The verify_pattern if larger than a 32-bit quantity
-has to be a hex number that starts with either "0x" or "0X". Use with
-\fBverify\fP=str. Also, verify_pattern supports %o format, which means that for
-each block offset will be written and then verified back, e.g.:
+If set, fio will fill the I/O buffers with this pattern. Fio defaults to
+filling with totally random bytes, but sometimes it's interesting to fill
+with a known pattern for I/O verification purposes. Depending on the width
+of the pattern, fio will fill 1/2/3/4 bytes of the buffer at the time (it can
+be either a decimal or a hex number). The \fBverify_pattern\fR if larger than
+a 32\-bit quantity has to be a hex number that starts with either "0x" or
+"0X". Use with \fBverify\fR. Also, \fBverify_pattern\fR supports %o
+format, which means that for each block offset will be written and then
+verified back, e.g.:
 .RS
 .RS
-\fBverify_pattern\fR=%o
+.P
+verify_pattern=%o
 .RE
+.P
 Or use combination of everything:
-.LP
 .RS
-\fBverify_pattern\fR=0xff%o"abcd"-21
+.P
+verify_pattern=0xff%o"abcd"\-12
 .RE
 .RE
 .TP
 .BI verify_fatal \fR=\fPbool
-If true, exit the job on the first observed verification failure.  Default:
-false.
+Normally fio will keep checking the entire contents before quitting on a
+block verification failure. If this option is set, fio will exit the job on
+the first observed failure. Default: false.
 .TP
 .BI verify_dump \fR=\fPbool
-If set, dump the contents of both the original data block and the data block we
-read off disk to files. This allows later analysis to inspect just what kind of
-data corruption occurred. Off by default.
+If set, dump the contents of both the original data block and the data block
+we read off disk to files. This allows later analysis to inspect just what
+kind of data corruption occurred. Off by default.
 .TP
 .BI verify_async \fR=\fPint
-Fio will normally verify IO inline from the submitting thread. This option
-takes an integer describing how many async offload threads to create for IO
-verification instead, causing fio to offload the duty of verifying IO contents
-to one or more separate threads.  If using this offload option, even sync IO
-engines can benefit from using an \fBiodepth\fR setting higher than 1, as it
-allows them to have IO in flight while verifies are running.
+Fio will normally verify I/O inline from the submitting thread. This option
+takes an integer describing how many async offload threads to create for I/O
+verification instead, causing fio to offload the duty of verifying I/O
+contents to one or more separate threads. If using this offload option, even
+sync I/O engines can benefit from using an \fBiodepth\fR setting higher
+than 1, as it allows them to have I/O in flight while verifies are running.
+Defaults to 0 async threads, i.e. verification is not asynchronous.
 .TP
 .BI verify_async_cpus \fR=\fPstr
-Tell fio to set the given CPU affinity on the async IO verification threads.
-See \fBcpus_allowed\fP for the format used.
+Tell fio to set the given CPU affinity on the async I/O verification
+threads. See \fBcpus_allowed\fR for the format used.
 .TP
 .BI verify_backlog \fR=\fPint
 Fio will normally verify the written contents of a job that utilizes verify
 once that job has completed. In other words, everything is written then
 everything is read back and verified. You may want to verify continually
-instead for a variety of reasons. Fio stores the meta data associated with an
-IO block in memory, so for large verify workloads, quite a bit of memory would
-be used up holding this meta data. If this option is enabled, fio will write
-only N blocks before verifying these blocks.
+instead for a variety of reasons. Fio stores the meta data associated with
+an I/O block in memory, so for large verify workloads, quite a bit of memory
+would be used up holding this meta data. If this option is enabled, fio will
+write only N blocks before verifying these blocks.
 .TP
 .BI verify_backlog_batch \fR=\fPint
-Control how many blocks fio will verify if verify_backlog is set. If not set,
-will default to the value of \fBverify_backlog\fR (meaning the entire queue is
-read back and verified).  If \fBverify_backlog_batch\fR is less than
-\fBverify_backlog\fR then not all blocks will be verified,  if
-\fBverify_backlog_batch\fR is larger than \fBverify_backlog\fR,  some blocks
-will be verified more than once.
+Control how many blocks fio will verify if \fBverify_backlog\fR is
+set. If not set, will default to the value of \fBverify_backlog\fR
+(meaning the entire queue is read back and verified). If
+\fBverify_backlog_batch\fR is less than \fBverify_backlog\fR then not all
+blocks will be verified, if \fBverify_backlog_batch\fR is larger than
+\fBverify_backlog\fR, some blocks will be verified more than once.
+.TP
+.BI verify_state_save \fR=\fPbool
+When a job exits during the write phase of a verify workload, save its
+current state. This allows fio to replay up until that point, if the verify
+state is loaded for the verify read phase. The format of the filename is,
+roughly:
+.RS
+.RS
+.P
+<type>\-<jobname>\-<jobindex>\-verify.state.
+.RE
+.P
+<type> is "local" for a local run, "sock" for a client/server socket
+connection, and "ip" (192.168.0.1, for instance) for a networked
+client/server connection. Defaults to true.
+.RE
+.TP
+.BI verify_state_load \fR=\fPbool
+If a verify termination trigger was used, fio stores the current write state
+of each thread. This can be used at verification time so that fio knows how
+far it should verify. Without this information, fio will run a full
+verification pass, according to the settings in the job file used. Default
+false.
 .TP
 .BI trim_percentage \fR=\fPint
 Number of verify blocks to discard/trim.
 .TP
 .BI trim_verify_zero \fR=\fPbool
-Verify that trim/discarded blocks are returned as zeroes.
+Verify that trim/discarded blocks are returned as zeros.
 .TP
 .BI trim_backlog \fR=\fPint
-Trim after this number of blocks are written.
+Verify that trim/discarded blocks are returned as zeros.
 .TP
 .BI trim_backlog_batch \fR=\fPint
-Trim this number of IO blocks.
+Trim this number of I/O blocks.
 .TP
 .BI experimental_verify \fR=\fPbool
 Enable experimental verification.
+.SS "Steady state"
 .TP
-.BI verify_state_save \fR=\fPbool
-When a job exits during the write phase of a verify workload, save its
-current state. This allows fio to replay up until that point, if the
-verify state is loaded for the verify read phase.
-.TP
-.BI verify_state_load \fR=\fPbool
-If a verify termination trigger was used, fio stores the current write
-state of each thread. This can be used at verification time so that fio
-knows how far it should verify. Without this information, fio will run
-a full verification pass, according to the settings in the job file used.
-.TP
-.B stonewall "\fR,\fP wait_for_previous"
-Wait for preceding jobs in the job file to exit before starting this one.
-\fBstonewall\fR implies \fBnew_group\fR.
-.TP
-.B new_group
-Start a new reporting group.  If not given, all jobs in a file will be part
-of the same reporting group, unless separated by a stonewall.
-.TP
-.BI stats \fR=\fPbool
-By default, fio collects and shows final output results for all jobs that run.
-If this option is set to 0, then fio will ignore it in the final stat output.
-.TP
-.BI numjobs \fR=\fPint
-Number of clones (processes/threads performing the same workload) of this job.
-Default: 1.
-.TP
-.B group_reporting
-If set, display per-group reports instead of per-job when \fBnumjobs\fR is
-specified.
-.TP
-.B thread
-Use threads created with \fBpthread_create\fR\|(3) instead of processes created
-with \fBfork\fR\|(2).
-.TP
-.BI zonesize \fR=\fPint
-Divide file into zones of the specified size in bytes.  See \fBzoneskip\fR.
-.TP
-.BI zonerange \fR=\fPint
-Give size of an IO zone.  See \fBzoneskip\fR.
-.TP
-.BI zoneskip \fR=\fPint
-Skip the specified number of bytes when \fBzonesize\fR bytes of data have been
-read.
+.BI steadystate \fR=\fPstr:float "\fR,\fP ss" \fR=\fPstr:float
+Define the criterion and limit for assessing steady state performance. The
+first parameter designates the criterion whereas the second parameter sets
+the threshold. When the criterion falls below the threshold for the
+specified duration, the job will stop. For example, `iops_slope:0.1%' will
+direct fio to terminate the job when the least squares regression slope
+falls below 0.1% of the mean IOPS. If \fBgroup_reporting\fR is enabled
+this will apply to all jobs in the group. Below is the list of available
+steady state assessment criteria. All assessments are carried out using only
+data from the rolling collection window. Threshold limits can be expressed
+as a fixed value or as a percentage of the mean in the collection window.
+.RS
+.RS
 .TP
-.BI write_iolog \fR=\fPstr
-Write the issued I/O patterns to the specified file.  Specify a separate file
-for each job, otherwise the iologs will be interspersed and the file may be
-corrupt.
+.B iops
+Collect IOPS data. Stop the job if all individual IOPS measurements
+are within the specified limit of the mean IOPS (e.g., `iops:2'
+means that all individual IOPS values must be within 2 of the mean,
+whereas `iops:0.2%' means that all individual IOPS values must be
+within 0.2% of the mean IOPS to terminate the job).
 .TP
-.BI read_iolog \fR=\fPstr
-Replay the I/O patterns contained in the specified file generated by
-\fBwrite_iolog\fR, or may be a \fBblktrace\fR binary file.
+.B iops_slope
+Collect IOPS data and calculate the least squares regression
+slope. Stop the job if the slope falls below the specified limit.
 .TP
-.BI replay_no_stall \fR=\fPbool
-While replaying I/O patterns using \fBread_iolog\fR the default behavior
-attempts to respect timing information between I/Os.  Enabling
-\fBreplay_no_stall\fR causes I/Os to be replayed as fast as possible while
-still respecting ordering.
+.B bw
+Collect bandwidth data. Stop the job if all individual bandwidth
+measurements are within the specified limit of the mean bandwidth.
 .TP
-.BI replay_redirect \fR=\fPstr
-While replaying I/O patterns using \fBread_iolog\fR the default behavior
-is to replay the IOPS onto the major/minor device that each IOP was recorded
-from.  Setting \fBreplay_redirect\fR causes all IOPS to be replayed onto the
-single specified device regardless of the device it was recorded from.
+.B bw_slope
+Collect bandwidth data and calculate the least squares regression
+slope. Stop the job if the slope falls below the specified limit.
+.RE
+.RE
 .TP
-.BI replay_align \fR=\fPint
-Force alignment of IO offsets and lengths in a trace to this power of 2 value.
+.BI steadystate_duration \fR=\fPtime "\fR,\fP ss_dur" \fR=\fPtime
+A rolling window of this duration will be used to judge whether steady state
+has been reached. Data will be collected once per second. The default is 0
+which disables steady state detection. When the unit is omitted, the
+value is interpreted in seconds.
 .TP
-.BI replay_scale \fR=\fPint
-Scale sector offsets down by this factor when replaying traces.
+.BI steadystate_ramp_time \fR=\fPtime "\fR,\fP ss_ramp" \fR=\fPtime
+Allow the job to run for the specified duration before beginning data
+collection for checking the steady state job termination criterion. The
+default is 0. When the unit is omitted, the value is interpreted in seconds.
+.SS "Measurements and reporting"
 .TP
 .BI per_job_logs \fR=\fPbool
 If set, this generates bw/clat/iops log with per file private filenames. If
-not set, jobs with identical names will share the log filename. Default: true.
+not set, jobs with identical names will share the log filename. Default:
+true.
+.TP
+.BI group_reporting
+It may sometimes be interesting to display statistics for groups of jobs as
+a whole instead of for each individual job. This is especially true if
+\fBnumjobs\fR is used; looking at individual thread/process output
+quickly becomes unwieldy. To see the final report per\-group instead of
+per\-job, use \fBgroup_reporting\fR. Jobs in a file will be part of the
+same reporting group, unless if separated by a \fBstonewall\fR, or by
+using \fBnew_group\fR.
+.TP
+.BI new_group
+Start a new reporting group. See: \fBgroup_reporting\fR. If not given,
+all jobs in a file will be part of the same reporting group, unless
+separated by a \fBstonewall\fR.
+.TP
+.BI stats \fR=\fPbool
+By default, fio collects and shows final output results for all jobs
+that run. If this option is set to 0, then fio will ignore it in
+the final stat output.
 .TP
 .BI write_bw_log \fR=\fPstr
-If given, write a bandwidth log for this job. Can be used to store data of the
-bandwidth of the jobs in their lifetime. The included fio_generate_plots script
-uses gnuplot to turn these text files into nice graphs. See \fBwrite_lat_log\fR
-for behaviour of given filename. For this option, the postfix is _bw.x.log,
-where x is the index of the job (1..N, where N is the number of jobs). If
-\fBper_job_logs\fR is false, then the filename will not include the job index.
-See the \fBLOG FILE FORMATS\fR
-section.
+If given, write a bandwidth log for this job. Can be used to store data of
+the bandwidth of the jobs in their lifetime. The included
+\fBfio_generate_plots\fR script uses gnuplot to turn these
+text files into nice graphs. See \fBwrite_lat_log\fR for behavior of
+given filename. For this option, the postfix is `_bw.x.log', where `x'
+is the index of the job (1..N, where N is the number of jobs). If
+\fBper_job_logs\fR is false, then the filename will not include the job
+index. See \fBLOG FILE FORMATS\fR section.
 .TP
 .BI write_lat_log \fR=\fPstr
-Same as \fBwrite_bw_log\fR, but writes I/O completion latencies.  If no
-filename is given with this option, the default filename of
-"jobname_type.x.log" is used, where x is the index of the job (1..N, where
-N is the number of jobs). Even if the filename is given, fio will still
-append the type of log. If \fBper_job_logs\fR is false, then the filename will
-not include the job index. See the \fBLOG FILE FORMATS\fR section.
+Same as \fBwrite_bw_log\fR, except that this option stores I/O
+submission, completion, and total latencies instead. If no filename is given
+with this option, the default filename of `jobname_type.log' is
+used. Even if the filename is given, fio will still append the type of
+log. So if one specifies:
+.RS
+.RS
+.P
+write_lat_log=foo
+.RE
+.P
+The actual log names will be `foo_slat.x.log', `foo_clat.x.log',
+and `foo_lat.x.log', where `x' is the index of the job (1..N, where N
+is the number of jobs). This helps \fBfio_generate_plots\fR find the
+logs automatically. If \fBper_job_logs\fR is false, then the filename
+will not include the job index. See \fBLOG FILE FORMATS\fR section.
+.RE
 .TP
 .BI write_hist_log \fR=\fPstr
-Same as \fBwrite_lat_log\fR, but writes I/O completion latency histograms. If
-no filename is given with this option, the default filename of
-"jobname_clat_hist.x.log" is used, where x is the index of the job (1..N, where
-N is the number of jobs). Even if the filename is given, fio will still append
-the type of log. If \fBper_job_logs\fR is false, then the filename will not
-include the job index. See the \fBLOG FILE FORMATS\fR section.
+Same as \fBwrite_lat_log\fR, but writes I/O completion latency
+histograms. If no filename is given with this option, the default filename
+of `jobname_clat_hist.x.log' is used, where `x' is the index of the
+job (1..N, where N is the number of jobs). Even if the filename is given,
+fio will still append the type of log. If \fBper_job_logs\fR is false,
+then the filename will not include the job index. See \fBLOG FILE FORMATS\fR section.
 .TP
 .BI write_iops_log \fR=\fPstr
-Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given with this
-option, the default filename of "jobname_type.x.log" is used, where x is the
-index of the job (1..N, where N is the number of jobs). Even if the filename
-is given, fio will still append the type of log. If \fBper_job_logs\fR is false,
-then the filename will not include the job index. See the \fBLOG FILE FORMATS\fR
-section.
+Same as \fBwrite_bw_log\fR, but writes IOPS. If no filename is given
+with this option, the default filename of `jobname_type.x.log' is
+used, where `x' is the index of the job (1..N, where N is the number of
+jobs). Even if the filename is given, fio will still append the type of
+log. If \fBper_job_logs\fR is false, then the filename will not include
+the job index. See \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_avg_msec \fR=\fPint
 By default, fio will log an entry in the iops, latency, or bw log for every
-IO that completes. When writing to the disk log, that can quickly grow to a
+I/O that completes. When writing to the disk log, that can quickly grow to a
 very large size. Setting this option makes fio average the each log entry
 over the specified period of time, reducing the resolution of the log. See
-\fBlog_max_value\fR as well.  Defaults to 0, logging all entries.
-.TP
-.BI log_max_value \fR=\fPbool
-If \fBlog_avg_msec\fR is set, fio logs the average over that window. If you
-instead want to log the maximum value, set this option to 1.  Defaults to
-0, meaning that averaged values are logged.
+\fBlog_max_value\fR as well. Defaults to 0, logging all entries.
+Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_hist_msec \fR=\fPint
-Same as \fBlog_avg_msec\fR, but logs entries for completion latency histograms.
-Computing latency percentiles from averages of intervals using \fBlog_avg_msec\fR
-is innacurate. Setting this option makes fio log histogram entries over the
-specified period of time, reducing log sizes for high IOPS devices while
-retaining percentile accuracy. See \fBlog_hist_coarseness\fR as well. Defaults
-to 0, meaning histogram logging is disabled.
+Same as \fBlog_avg_msec\fR, but logs entries for completion latency
+histograms. Computing latency percentiles from averages of intervals using
+\fBlog_avg_msec\fR is inaccurate. Setting this option makes fio log
+histogram entries over the specified period of time, reducing log sizes for
+high IOPS devices while retaining percentile accuracy. See
+\fBlog_hist_coarseness\fR as well. Defaults to 0, meaning histogram
+logging is disabled.
 .TP
 .BI log_hist_coarseness \fR=\fPint
-Integer ranging from 0 to 6, defining the coarseness of the resolution of the
-histogram logs enabled with \fBlog_hist_msec\fR. For each increment in
-coarseness, fio outputs half as many bins. Defaults to 0, for which histogram
-logs contain 1216 latency bins. See the \fBLOG FILE FORMATS\fR section.
+Integer ranging from 0 to 6, defining the coarseness of the resolution of
+the histogram logs enabled with \fBlog_hist_msec\fR. For each increment
+in coarseness, fio outputs half as many bins. Defaults to 0, for which
+histogram logs contain 1216 latency bins. See \fBLOG FILE FORMATS\fR section.
+.TP
+.BI log_max_value \fR=\fPbool
+If \fBlog_avg_msec\fR is set, fio logs the average over that window. If
+you instead want to log the maximum value, set this option to 1. Defaults to
+0, meaning that averaged values are logged.
 .TP
 .BI log_offset \fR=\fPbool
-If this is set, the iolog options will include the byte offset for the IO
-entry as well as the other data values. Defaults to 0 meaning that offsets are
-not present in logs. See the \fBLOG FILE FORMATS\fR section.
+If this is set, the iolog options will include the byte offset for the I/O
+entry as well as the other data values. Defaults to 0 meaning that
+offsets are not present in logs. Also see \fBLOG FILE FORMATS\fR section.
 .TP
 .BI log_compression \fR=\fPint
-If this is set, fio will compress the IO logs as it goes, to keep the memory
-footprint lower. When a log reaches the specified size, that chunk is removed
-and compressed in the background. Given that IO logs are fairly highly
-compressible, this yields a nice memory savings for longer runs. The downside
-is that the compression will consume some background CPU cycles, so it may
-impact the run. This, however, is also true if the logging ends up consuming
-most of the system memory. So pick your poison. The IO logs are saved
-normally at the end of a run, by decompressing the chunks and storing them
-in the specified log file. This feature depends on the availability of zlib.
+If this is set, fio will compress the I/O logs as it goes, to keep the
+memory footprint lower. When a log reaches the specified size, that chunk is
+removed and compressed in the background. Given that I/O logs are fairly
+highly compressible, this yields a nice memory savings for longer runs. The
+downside is that the compression will consume some background CPU cycles, so
+it may impact the run. This, however, is also true if the logging ends up
+consuming most of the system memory. So pick your poison. The I/O logs are
+saved normally at the end of a run, by decompressing the chunks and storing
+them in the specified log file. This feature depends on the availability of
+zlib.
 .TP
 .BI log_compression_cpus \fR=\fPstr
-Define the set of CPUs that are allowed to handle online log compression
-for the IO jobs. This can provide better isolation between performance
+Define the set of CPUs that are allowed to handle online log compression for
+the I/O jobs. This can provide better isolation between performance
 sensitive jobs, and background compression work.
 .TP
 .BI log_store_compressed \fR=\fPbool
 If set, fio will store the log files in a compressed format. They can be
-decompressed with fio, using the \fB\-\-inflate-log\fR command line parameter.
-The files will be stored with a \fB\.fz\fR suffix.
+decompressed with fio, using the \fB\-\-inflate\-log\fR command line
+parameter. The files will be stored with a `.fz' suffix.
 .TP
 .BI log_unix_epoch \fR=\fPbool
 If set, fio will log Unix timestamps to the log files produced by enabling
-\fBwrite_type_log\fR for each log type, instead of the default zero-based
+write_type_log for each log type, instead of the default zero\-based
 timestamps.
 .TP
 .BI block_error_percentiles \fR=\fPbool
-If set, record errors in trim block-sized units from writes and trims and output
-a histogram of how many trims it took to get to errors, and what kind of error
-was encountered.
+If set, record errors in trim block\-sized units from writes and trims and
+output a histogram of how many trims it took to get to errors, and what kind
+of error was encountered.
 .TP
-.BI disable_lat \fR=\fPbool
-Disable measurements of total latency numbers. Useful only for cutting
-back the number of calls to \fBgettimeofday\fR\|(2), as that does impact performance at
-really high IOPS rates.  Note that to really get rid of a large amount of these
-calls, this option must be used with disable_slat and disable_bw as well.
-.TP
-.BI disable_clat \fR=\fPbool
-Disable measurements of completion latency numbers. See \fBdisable_lat\fR.
-.TP
-.BI disable_slat \fR=\fPbool
-Disable measurements of submission latency numbers. See \fBdisable_lat\fR.
-.TP
-.BI disable_bw_measurement \fR=\fPbool
-Disable measurements of throughput/bandwidth numbers. See \fBdisable_lat\fR.
-.TP
-.BI lockmem \fR=\fPint
-Pin the specified amount of memory with \fBmlock\fR\|(2).  Can be used to
-simulate a smaller amount of memory. The amount specified is per worker.
-.TP
-.BI exec_prerun \fR=\fPstr
-Before running the job, execute the specified command with \fBsystem\fR\|(3).
-.RS
-Output is redirected in a file called \fBjobname.prerun.txt\fR
-.RE
-.TP
-.BI exec_postrun \fR=\fPstr
-Same as \fBexec_prerun\fR, but the command is executed after the job completes.
-.RS
-Output is redirected in a file called \fBjobname.postrun.txt\fR
-.RE
+.BI bwavgtime \fR=\fPint
+Average the calculated bandwidth over the given time. Value is specified in
+milliseconds. If the job also does bandwidth logging through
+\fBwrite_bw_log\fR, then the minimum of this option and
+\fBlog_avg_msec\fR will be used. Default: 500ms.
 .TP
-.BI ioscheduler \fR=\fPstr
-Attempt to switch the device hosting the file to the specified I/O scheduler.
+.BI iopsavgtime \fR=\fPint
+Average the calculated IOPS over the given time. Value is specified in
+milliseconds. If the job also does IOPS logging through
+\fBwrite_iops_log\fR, then the minimum of this option and
+\fBlog_avg_msec\fR will be used. Default: 500ms.
 .TP
 .BI disk_util \fR=\fPbool
-Generate disk utilization statistics if the platform supports it. Default: true.
-.TP
-.BI clocksource \fR=\fPstr
-Use the given clocksource as the base of timing. The supported options are:
-.RS
-.TP
-.B gettimeofday
-\fBgettimeofday\fR\|(2)
-.TP
-.B clock_gettime
-\fBclock_gettime\fR\|(2)
-.TP
-.B cpu
-Internal CPU clock source
-.TP
-.RE
-.P
-\fBcpu\fR is the preferred clocksource if it is reliable, as it is very fast
-(and fio is heavy on time calls). Fio will automatically use this clocksource
-if it's supported and considered reliable on the system it is running on,
-unless another clocksource is specifically set. For x86/x86-64 CPUs, this
-means supporting TSC Invariant.
-.TP
-.BI gtod_reduce \fR=\fPbool
-Enable all of the \fBgettimeofday\fR\|(2) reducing options (disable_clat, disable_slat,
-disable_bw) plus reduce precision of the timeout somewhat to really shrink the
-\fBgettimeofday\fR\|(2) call count. With this option enabled, we only do about 0.4% of
-the gtod() calls we would have done if all time keeping was enabled.
-.TP
-.BI gtod_cpu \fR=\fPint
-Sometimes it's cheaper to dedicate a single thread of execution to just getting
-the current time. Fio (and databases, for instance) are very intensive on
-\fBgettimeofday\fR\|(2) calls. With this option, you can set one CPU aside for doing
-nothing but logging current time to a shared memory location. Then the other
-threads/processes that run IO workloads need only copy that segment, instead of
-entering the kernel with a \fBgettimeofday\fR\|(2) call. The CPU set aside for doing
-these time calls will be excluded from other uses. Fio will manually clear it
-from the CPU mask of other jobs.
-.TP
-.BI ignore_error \fR=\fPstr
-Sometimes you want to ignore some errors during test in that case you can specify
-error list for each error type.
-.br
-ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST
-.br
-errors for given error type is separated with ':'.
-Error may be symbol ('ENOSPC', 'ENOMEM') or an integer.
-.br
-Example: ignore_error=EAGAIN,ENOSPC:122 .
-.br
-This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from WRITE.
-.TP
-.BI error_dump \fR=\fPbool
-If set dump every error even if it is non fatal, true by default. If disabled
-only fatal error will be dumped
-.TP
-.BI profile \fR=\fPstr
-Select a specific builtin performance test.
-.TP
-.BI cgroup \fR=\fPstr
-Add job to this control group. If it doesn't exist, it will be created.
-The system must have a mounted cgroup blkio mount point for this to work. If
-your system doesn't have it mounted, you can do so with:
-
-# mount \-t cgroup \-o blkio none /cgroup
-.TP
-.BI cgroup_weight \fR=\fPint
-Set the weight of the cgroup to this value. See the documentation that comes
-with the kernel, allowed values are in the range of 100..1000.
-.TP
-.BI cgroup_nodelete \fR=\fPbool
-Normally fio will delete the cgroups it has created after the job completion.
-To override this behavior and to leave cgroups around after the job completion,
-set cgroup_nodelete=1. This can be useful if one wants to inspect various
-cgroup files after job completion. Default: false
-.TP
-.BI uid \fR=\fPint
-Instead of running as the invoking user, set the user ID to this value before
-the thread/process does any work.
-.TP
-.BI gid \fR=\fPint
-Set group ID, see \fBuid\fR.
-.TP
-.BI unit_base \fR=\fPint
-Base unit for reporting.  Allowed values are:
-.RS
-.TP
-.B 0
-Use auto-detection (default).
-.TP
-.B 8
-Byte based.
-.TP
-.B 1
-Bit based.
-.RE
-.P
+Generate disk utilization statistics, if the platform supports it.
+Default: true.
 .TP
-.BI flow_id \fR=\fPint
-The ID of the flow. If not specified, it defaults to being a global flow. See
-\fBflow\fR.
+.BI disable_lat \fR=\fPbool
+Disable measurements of total latency numbers. Useful only for cutting back
+the number of calls to \fBgettimeofday\fR\|(2), as that does impact
+performance at really high IOPS rates. Note that to really get rid of a
+large amount of these calls, this option must be used with
+\fBdisable_slat\fR and \fBdisable_bw_measurement\fR as well.
 .TP
-.BI flow \fR=\fPint
-Weight in token-based flow control. If this value is used, then there is a
-\fBflow counter\fR which is used to regulate the proportion of activity between
-two or more jobs. fio attempts to keep this flow counter near zero. The
-\fBflow\fR parameter stands for how much should be added or subtracted to the
-flow counter on each iteration of the main I/O loop. That is, if one job has
-\fBflow=8\fR and another job has \fBflow=-1\fR, then there will be a roughly
-1:8 ratio in how much one runs vs the other.
+.BI disable_clat \fR=\fPbool
+Disable measurements of completion latency numbers. See
+\fBdisable_lat\fR.
 .TP
-.BI flow_watermark \fR=\fPint
-The maximum value that the absolute value of the flow counter is allowed to
-reach before the job must wait for a lower value of the counter.
+.BI disable_slat \fR=\fPbool
+Disable measurements of submission latency numbers. See
+\fBdisable_lat\fR.
 .TP
-.BI flow_sleep \fR=\fPint
-The period of time, in microseconds, to wait after the flow watermark has been
-exceeded before retrying operations
+.BI disable_bw_measurement \fR=\fPbool "\fR,\fP disable_bw" \fR=\fPbool
+Disable measurements of throughput/bandwidth numbers. See
+\fBdisable_lat\fR.
 .TP
 .BI clat_percentiles \fR=\fPbool
 Enable the reporting of percentiles of completion latencies.
 .TP
 .BI percentile_list \fR=\fPfloat_list
 Overwrite the default list of percentiles for completion latencies and the
-block error histogram. Each number is a floating number in the range (0,100],
-and the maximum length of the list is 20. Use ':' to separate the
-numbers. For example, \-\-percentile_list=99.5:99.9 will cause fio to
-report the values of completion latency below which 99.5% and 99.9% of
-the observed latencies fell, respectively.
-.SS "Ioengine Parameters List"
-Some parameters are only valid when a specific ioengine is in use. These are
-used identically to normal parameters, with the caveat that when used on the
-command line, they must come after the ioengine.
+block error histogram. Each number is a floating number in the range
+(0,100], and the maximum length of the list is 20. Use ':' to separate the
+numbers, and list the numbers in ascending order. For example,
+`\-\-percentile_list=99.5:99.9' will cause fio to report the values of
+completion latency below which 99.5% and 99.9% of the observed latencies
+fell, respectively.
+.SS "Error handling"
 .TP
-.BI (cpuio)cpuload \fR=\fPint
-Attempt to use the specified percentage of CPU cycles.
-.TP
-.BI (cpuio)cpuchunks \fR=\fPint
-Split the load into cycles of the given time. In microseconds.
+.BI exitall_on_error
+When one job finishes in error, terminate the rest. The default is to wait
+for each job to finish.
 .TP
-.BI (cpuio)exit_on_io_done \fR=\fPbool
-Detect when IO threads are done, then exit.
+.BI continue_on_error \fR=\fPstr
+Normally fio will exit the job on the first observed failure. If this option
+is set, fio will continue the job when there is a 'non\-fatal error' (EIO or
+EILSEQ) until the runtime is exceeded or the I/O size specified is
+completed. If this option is used, there are two more stats that are
+appended, the total error count and the first error. The error field given
+in the stats is the first error that was hit during the run.
+The allowed values are:
+.RS
+.RS
 .TP
-.BI (libaio)userspace_reap
-Normally, with the libaio engine in use, fio will use
-the io_getevents system call to reap newly returned events.
-With this flag turned on, the AIO ring will be read directly
-from user-space to reap events. The reaping mode is only
-enabled when polling for a minimum of 0 events (eg when
-iodepth_batch_complete=0).
+.B none
+Exit on any I/O or verify errors.
 .TP
-.BI (pvsync2)hipri
-Set RWF_HIPRI on IO, indicating to the kernel that it's of
-higher priority than normal.
+.B read
+Continue on read errors, exit on all others.
 .TP
-.BI (pvsync2)hipri_percentage
-When hipri is set this determines the probability of a pvsync2 IO being high
-priority. The default is 100%.
+.B write
+Continue on write errors, exit on all others.
 .TP
-.BI (net,netsplice)hostname \fR=\fPstr
-The host name or IP address to use for TCP or UDP based IO.
-If the job is a TCP listener or UDP reader, the hostname is not
-used and must be omitted unless it is a valid UDP multicast address.
+.B io
+Continue on any I/O error, exit on all others.
 .TP
-.BI (net,netsplice)port \fR=\fPint
-The TCP or UDP port to bind to or connect to. If this is used with
-\fBnumjobs\fR to spawn multiple instances of the same job type, then
-this will be the starting port number since fio will use a range of ports.
+.B verify
+Continue on verify errors, exit on all others.
 .TP
-.BI (net,netsplice)interface \fR=\fPstr
-The IP address of the network interface used to send or receive UDP multicast
-packets.
+.B all
+Continue on all errors.
 .TP
-.BI (net,netsplice)ttl \fR=\fPint
-Time-to-live value for outgoing UDP multicast packets. Default: 1
+.B 0
+Backward\-compatible alias for 'none'.
 .TP
-.BI (net,netsplice)nodelay \fR=\fPbool
-Set TCP_NODELAY on TCP connections.
+.B 1
+Backward\-compatible alias for 'all'.
+.RE
+.RE
 .TP
-.BI (net,netsplice)protocol \fR=\fPstr "\fR,\fP proto" \fR=\fPstr
-The network protocol to use. Accepted values are:
+.BI ignore_error \fR=\fPstr
+Sometimes you want to ignore some errors during test in that case you can
+specify error list for each error type, instead of only being able to
+ignore the default 'non\-fatal error' using \fBcontinue_on_error\fR.
+`ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST' errors for
+given error type is separated with ':'. Error may be symbol ('ENOSPC', 'ENOMEM')
+or integer. Example:
 .RS
 .RS
+.P
+ignore_error=EAGAIN,ENOSPC:122
+.RE
+.P
+This option will ignore EAGAIN from READ, and ENOSPC and 122(EDQUOT) from
+WRITE. This option works by overriding \fBcontinue_on_error\fR with
+the list of errors for each error type if any.
+.RE
 .TP
-.B tcp
-Transmission control protocol
-.TP
-.B tcpv6
-Transmission control protocol V6
+.BI error_dump \fR=\fPbool
+If set dump every error even if it is non fatal, true by default. If
+disabled only fatal error will be dumped.
+.SS "Running predefined workloads"
+Fio includes predefined profiles that mimic the I/O workloads generated by
+other tools.
 .TP
-.B udp
-User datagram protocol
+.BI profile \fR=\fPstr
+The predefined workload to run. Current profiles are:
+.RS
+.RS
 .TP
-.B udpv6
-User datagram protocol V6
+.B tiobench
+Threaded I/O bench (tiotest/tiobench) like workload.
 .TP
-.B unix
-UNIX domain socket
+.B act
+Aerospike Certification Tool (ACT) like workload.
+.RE
 .RE
 .P
-When the protocol is TCP or UDP, the port must also be given,
-as well as the hostname if the job is a TCP listener or UDP
-reader. For unix sockets, the normal filename option should be
-used and the port is invalid.
+To view a profile's additional options use \fB\-\-cmdhelp\fR after specifying
+the profile. For example:
+.RS
+.TP
+$ fio \-\-profile=act \-\-cmdhelp
 .RE
+.SS "Act profile options"
 .TP
-.BI (net,netsplice)listen
-For TCP network connections, tell fio to listen for incoming
-connections rather than initiating an outgoing connection. The
-hostname must be omitted if this option is used.
+.BI device\-names \fR=\fPstr
+Devices to use.
 .TP
-.BI (net,netsplice)pingpong
-Normally a network writer will just continue writing data, and a network reader
-will just consume packets. If pingpong=1 is set, a writer will send its normal
-payload to the reader, then wait for the reader to send the same payload back.
-This allows fio to measure network latencies. The submission and completion
-latencies then measure local time spent sending or receiving, and the
-completion latency measures how long it took for the other end to receive and
-send back. For UDP multicast traffic pingpong=1 should only be set for a single
-reader when multiple readers are listening to the same address.
+.BI load \fR=\fPint
+ACT load multiplier. Default: 1.
 .TP
-.BI (net,netsplice)window_size \fR=\fPint
-Set the desired socket buffer size for the connection.
+.BI test\-duration\fR=\fPtime
+How long the entire test takes to run. When the unit is omitted, the value
+is given in seconds. Default: 24h.
 .TP
-.BI (net,netsplice)mss \fR=\fPint
-Set the TCP maximum segment size (TCP_MAXSEG).
+.BI threads\-per\-queue\fR=\fPint
+Number of read I/O threads per device. Default: 8.
 .TP
-.BI (e4defrag)donorname \fR=\fPstr
-File will be used as a block donor (swap extents between files)
+.BI read\-req\-num\-512\-blocks\fR=\fPint
+Number of 512B blocks to read at the time. Default: 3.
 .TP
-.BI (e4defrag)inplace \fR=\fPint
-Configure donor file block allocation strategy
-.RS
-.BI 0(default) :
-Preallocate donor's file on init
+.BI large\-block\-op\-kbytes\fR=\fPint
+Size of large block ops in KiB (writes). Default: 131072.
 .TP
-.BI 1:
-allocate space immediately inside defragment event, and free right after event
-.RE
+.BI prep
+Set to run ACT prep phase.
+.SS "Tiobench profile options"
 .TP
-.BI (rbd)clustername \fR=\fPstr
-Specifies the name of the ceph cluster.
+.BI size\fR=\fPstr
+Size in MiB.
 .TP
-.BI (rbd)rbdname \fR=\fPstr
-Specifies the name of the RBD.
+.BI block\fR=\fPint
+Block size in bytes. Default: 4096.
 .TP
-.BI (rbd)pool \fR=\fPstr
-Specifies the name of the Ceph pool containing the RBD.
+.BI numruns\fR=\fPint
+Number of runs.
 .TP
-.BI (rbd)clientname \fR=\fPstr
-Specifies the username (without the 'client.' prefix) used to access the Ceph
-cluster. If the clustername is specified, the clientname shall be the full
-type.id string. If no type. prefix is given, fio will add 'client.' by default.
+.BI dir\fR=\fPstr
+Test directory.
 .TP
-.BI (mtd)skip_bad \fR=\fPbool
-Skip operations against known bad blocks.
+.BI threads\fR=\fPint
+Number of threads.
 .SH OUTPUT
-While running, \fBfio\fR will display the status of the created jobs.  For
-example:
-.RS
-.P
-Jobs: 1: [_r] [24.8% done] [ 13509/  8334 kb/s] [eta 00h:01m:31s]
-.RE
+Fio spits out a lot of output. While running, fio will display the status of the
+jobs created. An example of that would be:
 .P
-The characters in the first set of brackets denote the current status of each
-threads.  The possible values are:
+.nf
+		Jobs: 1 (f=1): [_(1),M(1)][24.8%][r=20.5MiB/s,w=23.5MiB/s][r=82,w=94 IOPS][eta 01m:31s]
+.fi
 .P
-.PD 0
+The characters inside the first set of square brackets denote the current status of
+each thread. The first character is the first job defined in the job file, and so
+forth. The possible values (in typical life cycle order) are:
 .RS
 .TP
+.PD 0
 .B P
-Setup but not started.
+Thread setup, but not started.
 .TP
 .B C
 Thread created.
 .TP
 .B I
-Initialized, waiting.
+Thread initialized, waiting or generating necessary data.
+.TP
+.B P
+Thread running pre\-reading file(s).
+.TP
+.B /
+Thread is in ramp period.
 .TP
 .B R
 Running, doing sequential reads.
@@ -2220,96 +2727,210 @@ Running, doing mixed sequential reads/writes.
 .B m
 Running, doing mixed random reads/writes.
 .TP
+.B D
+Running, doing sequential trims.
+.TP
+.B d
+Running, doing random trims.
+.TP
 .B F
 Running, currently waiting for \fBfsync\fR\|(2).
 .TP
 .B V
-Running, verifying written data.
+Running, doing verification of written data.
+.TP
+.B f
+Thread finishing.
 .TP
 .B E
-Exited, not reaped by main thread.
+Thread exited, not reaped by main thread yet.
 .TP
 .B \-
-Exited, thread reaped.
-.RE
+Thread reaped.
+.TP
+.B X
+Thread reaped, exited with an error.
+.TP
+.B K
+Thread reaped, exited due to signal.
 .PD
+.RE
+.P
+Fio will condense the thread string as not to take up more space on the command
+line than needed. For instance, if you have 10 readers and 10 writers running,
+the output would look like this:
+.P
+.nf
+		Jobs: 20 (f=20): [R(10),W(10)][4.0%][r=20.5MiB/s,w=23.5MiB/s][r=82,w=94 IOPS][eta 57m:36s]
+.fi
+.P
+Note that the status string is displayed in order, so it's possible to tell which of
+the jobs are currently doing what. In the example above this means that jobs 1\-\-10
+are readers and 11\-\-20 are writers.
 .P
-The second set of brackets shows the estimated completion percentage of
-the current group.  The third set shows the read and write I/O rate,
-respectively. Finally, the estimated run time of the job is displayed.
+The other values are fairly self explanatory \-\- number of threads currently
+running and doing I/O, the number of currently open files (f=), the estimated
+completion percentage, the rate of I/O since last check (read speed listed first,
+then write speed and optionally trim speed) in terms of bandwidth and IOPS,
+and time to completion for the current running group. It's impossible to estimate
+runtime of the following groups (if any).
 .P
-When \fBfio\fR completes (or is interrupted by Ctrl-C), it will show data
-for each thread, each group of threads, and each disk, in that order.
+When fio is done (or interrupted by Ctrl\-C), it will show the data for
+each thread, group of threads, and disks in that order. For each overall thread (or
+group) the output looks like:
 .P
-Per-thread statistics first show the threads client number, group-id, and
-error code.  The remaining figures are as follows:
+.nf
+		Client1: (groupid=0, jobs=1): err= 0: pid=16109: Sat Jun 24 12:07:54 2017
+		  write: IOPS=88, BW=623KiB/s (638kB/s)(30.4MiB/50032msec)
+		    slat (nsec): min=500, max=145500, avg=8318.00, stdev=4781.50
+		    clat (usec): min=170, max=78367, avg=4019.02, stdev=8293.31
+		     lat (usec): min=174, max=78375, avg=4027.34, stdev=8291.79
+		    clat percentiles (usec):
+		     |  1.00th=[  302],  5.00th=[  326], 10.00th=[  343], 20.00th=[  363],
+		     | 30.00th=[  392], 40.00th=[  404], 50.00th=[  416], 60.00th=[  445],
+		     | 70.00th=[  816], 80.00th=[ 6718], 90.00th=[12911], 95.00th=[21627],
+		     | 99.00th=[43779], 99.50th=[51643], 99.90th=[68682], 99.95th=[72877],
+		     | 99.99th=[78119]
+		   bw (  KiB/s): min=  532, max=  686, per=0.10%, avg=622.87, stdev=24.82, samples=  100
+		   iops        : min=   76, max=   98, avg=88.98, stdev= 3.54, samples=  100
+		  lat (usec)   : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+		  lat (msec)   : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+		  lat (msec)   : 100=0.65%
+		  cpu          : usr=0.27%, sys=0.18%, ctx=12072, majf=0, minf=21
+		  IO depths    : 1=85.0%, 2=13.1%, 4=1.8%, 8=0.1%, 16=0.0%, 32=0.0%, >=64=0.0%
+		     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
+		     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
+		     issued rwt: total=0,4450,0, short=0,0,0, dropped=0,0,0
+		     latency   : target=0, window=0, percentile=100.00%, depth=8
+.fi
+.P
+The job name (or first job's name when using \fBgroup_reporting\fR) is printed,
+along with the group id, count of jobs being aggregated, last error id seen (which
+is 0 when there are no errors), pid/tid of that thread and the time the job/group
+completed. Below are the I/O statistics for each data direction performed (showing
+writes in the example above). In the order listed, they denote:
 .RS
 .TP
-.B io
-Number of megabytes of I/O performed.
-.TP
-.B bw
-Average data rate (bandwidth).
-.TP
-.B runt
-Threads run time.
+.B read/write/trim
+The string before the colon shows the I/O direction the statistics
+are for. \fIIOPS\fR is the average I/Os performed per second. \fIBW\fR
+is the average bandwidth rate shown as: value in power of 2 format
+(value in power of 10 format). The last two values show: (total
+I/O performed in power of 2 format / \fIruntime\fR of that thread).
 .TP
 .B slat
-Submission latency minimum, maximum, average and standard deviation. This is
-the time it took to submit the I/O.
+Submission latency (\fImin\fR being the minimum, \fImax\fR being the
+maximum, \fIavg\fR being the average, \fIstdev\fR being the standard
+deviation). This is the time it took to submit the I/O. For
+sync I/O this row is not displayed as the slat is really the
+completion latency (since queue/complete is one operation there).
+This value can be in nanoseconds, microseconds or milliseconds \-\-\-
+fio will choose the most appropriate base and print that (in the
+example above nanoseconds was the best scale). Note: in \fB\-\-minimal\fR mode
+latencies are always expressed in microseconds.
 .TP
 .B clat
-Completion latency minimum, maximum, average and standard deviation.  This
-is the time between submission and completion.
+Completion latency. Same names as slat, this denotes the time from
+submission to completion of the I/O pieces. For sync I/O, clat will
+usually be equal (or very close) to 0, as the time from submit to
+complete is basically just CPU time (I/O has already been done, see slat
+explanation).
+.TP
+.B lat
+Total latency. Same names as slat and clat, this denotes the time from
+when fio created the I/O unit to completion of the I/O operation.
 .TP
 .B bw
-Bandwidth minimum, maximum, percentage of aggregate bandwidth received, average
-and standard deviation.
+Bandwidth statistics based on samples. Same names as the xlat stats,
+but also includes the number of samples taken (\fIsamples\fR) and an
+approximate percentage of total aggregate bandwidth this thread
+received in its group (\fIper\fR). This last value is only really
+useful if the threads in this group are on the same disk, since they
+are then competing for disk access.
+.TP
+.B iops
+IOPS statistics based on samples. Same names as \fBbw\fR.
+.TP
+.B lat (nsec/usec/msec)
+The distribution of I/O completion latencies. This is the time from when
+I/O leaves fio and when it gets completed. Unlike the separate
+read/write/trim sections above, the data here and in the remaining
+sections apply to all I/Os for the reporting group. 250=0.04% means that
+0.04% of the I/Os completed in under 250us. 500=64.11% means that 64.11%
+of the I/Os required 250 to 499us for completion.
 .TP
 .B cpu
-CPU usage statistics. Includes user and system time, number of context switches
-this thread went through and number of major and minor page faults. The CPU
-utilization numbers are averages for the jobs in that reporting group, while
-the context and fault counters are summed.
+CPU usage. User and system time, along with the number of context
+switches this thread went through, usage of system and user time, and
+finally the number of major and minor page faults. The CPU utilization
+numbers are averages for the jobs in that reporting group, while the
+context and fault counters are summed.
 .TP
 .B IO depths
-Distribution of I/O depths.  Each depth includes everything less than (or equal)
-to it, but greater than the previous depth.
+The distribution of I/O depths over the job lifetime. The numbers are
+divided into powers of 2 and each entry covers depths from that value
+up to those that are lower than the next entry \-\- e.g., 16= covers
+depths from 16 to 31. Note that the range covered by a depth
+distribution entry can be different to the range covered by the
+equivalent \fBsubmit\fR/\fBcomplete\fR distribution entry.
+.TP
+.B IO submit
+How many pieces of I/O were submitting in a single submit call. Each
+entry denotes that amount and below, until the previous entry \-\- e.g.,
+16=100% means that we submitted anywhere between 9 to 16 I/Os per submit
+call. Note that the range covered by a \fBsubmit\fR distribution entry can
+be different to the range covered by the equivalent depth distribution
+entry.
 .TP
-.B IO issued
-Number of read/write requests issued, and number of short read/write requests.
+.B IO complete
+Like the above \fBsubmit\fR number, but for completions instead.
 .TP
-.B IO latencies
-Distribution of I/O completion latencies.  The numbers follow the same pattern
-as \fBIO depths\fR.
+.B IO issued rwt
+The number of \fBread/write/trim\fR requests issued, and how many of them were
+short or dropped.
+.TP
+.B IO latency
+These values are for \fBlatency-target\fR and related options. When
+these options are engaged, this section describes the I/O depth required
+to meet the specified latency target.
 .RE
 .P
-The group statistics show:
-.PD 0
+After each client has been listed, the group statistics are printed. They
+will look like this:
+.P
+.nf
+		Run status group 0 (all jobs):
+		   READ: bw=20.9MiB/s (21.9MB/s), 10.4MiB/s\-10.8MiB/s (10.9MB/s\-11.3MB/s), io=64.0MiB (67.1MB), run=2973\-3069msec
+		  WRITE: bw=1231KiB/s (1261kB/s), 616KiB/s\-621KiB/s (630kB/s\-636kB/s), io=64.0MiB (67.1MB), run=52747\-53223msec
+.fi
+.P
+For each data direction it prints:
 .RS
 .TP
-.B io
-Number of megabytes I/O performed.
-.TP
-.B aggrb
-Aggregate bandwidth of threads in the group.
-.TP
-.B minb
-Minimum average bandwidth a thread saw.
-.TP
-.B maxb
-Maximum average bandwidth a thread saw.
+.B bw
+Aggregate bandwidth of threads in this group followed by the
+minimum and maximum bandwidth of all the threads in this group.
+Values outside of brackets are power\-of\-2 format and those
+within are the equivalent value in a power\-of\-10 format.
 .TP
-.B mint
-Shortest runtime of threads in the group.
+.B io
+Aggregate I/O performed of all threads in this group. The
+format is the same as \fBbw\fR.
 .TP
-.B maxt
-Longest runtime of threads in the group.
+.B run
+The smallest and longest runtimes of the threads in this group.
 .RE
-.PD
 .P
-Finally, disk statistics are printed with reads first:
-.PD 0
+And finally, the disk statistics are printed. This is Linux specific.
+They will look like this:
+.P
+.nf
+		  Disk stats (read/write):
+		    sda: ios=16398/16511, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
+.fi
+.P
+Each value is printed for both reads and writes, with reads first. The
+numbers denote:
 .RS
 .TP
 .B ios
@@ -2321,517 +2942,538 @@ Number of merges performed by the I/O scheduler.
 .B ticks
 Number of ticks we kept the disk busy.
 .TP
-.B io_queue
+.B in_queue
 Total time spent in the disk queue.
 .TP
 .B util
-Disk utilization.
+The disk utilization. A value of 100% means we kept the disk
+busy constantly, 50% would be a disk idling half of the time.
 .RE
-.PD
 .P
-It is also possible to get fio to dump the current output while it is
-running, without terminating the job. To do that, send fio the \fBUSR1\fR
-signal.
+It is also possible to get fio to dump the current output while it is running,
+without terminating the job. To do that, send fio the USR1 signal. You can
+also get regularly timed dumps by using the \fB\-\-status\-interval\fR
+parameter, or by creating a file in `/tmp' named
+`fio\-dump\-status'. If fio sees this file, it will unlink it and dump the
+current output status.
 .SH TERSE OUTPUT
-If the \fB\-\-minimal\fR / \fB\-\-append-terse\fR options are given, the
-results will be printed/appended in a semicolon-delimited format suitable for
-scripted use.
-A job description (if provided) follows on a new line.  Note that the first
-number in the line is the version number. If the output has to be changed
-for some reason, this number will be incremented by 1 to signify that
-change. Numbers in brackets (e.g. "[v3]") indicate which terse version
-introduced a field. The fields are:
+For scripted usage where you typically want to generate tables or graphs of the
+results, fio can output the results in a semicolon separated format. The format
+is one long line of values, such as:
 .P
-.RS
-.B terse version, fio version [v3], jobname, groupid, error
+.nf
+		2;card0;0;0;7139336;121836;60004;1;10109;27.932460;116.933948;220;126861;3495.446807;1085.368601;226;126864;3523.635629;1089.012448;24063;99944;50.275485%;59818.274627;5540.657370;7155060;122104;60004;1;8338;29.086342;117.839068;388;128077;5032.488518;1234.785715;391;128085;5061.839412;1236.909129;23436;100928;50.287926%;59964.832030;5644.844189;14.595833%;19.394167%;123706;0;7313;0.1%;0.1%;0.1%;0.1%;0.1%;0.1%;100.0%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.01%;0.02%;0.05%;0.16%;6.04%;40.40%;52.68%;0.64%;0.01%;0.00%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%
+		A description of this job goes here.
+.fi
 .P
-Read status:
-.RS
-.B Total I/O \fR(KiB)\fP, bandwidth \fR(KiB/s)\fP, IOPS, runtime \fR(ms)\fP
+The job description (if provided) follows on a second line.
 .P
-Submission latency:
-.RS
-.B min, max, mean, standard deviation
-.RE
-Completion latency:
-.RS
-.B min, max, mean, standard deviation
-.RE
-Completion latency percentiles (20 fields):
-.RS
-.B Xth percentile=usec
-.RE
-Total latency:
-.RS
-.B min, max, mean, standard deviation
-.RE
-Bandwidth:
-.RS
-.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
-.RE
-IOPS [v5]:
-.RS
-.B min, max, mean, standard deviation, number of samples
-.RE
-.RE
+To enable terse output, use the \fB\-\-minimal\fR or
+`\-\-output\-format=terse' command line options. The
+first value is the version of the terse output format. If the output has to be
+changed for some reason, this number will be incremented by 1 to signify that
+change.
 .P
-Write status:
-.RS
-.B Total I/O \fR(KiB)\fP, bandwidth \fR(KiB/s)\fP, IOPS, runtime \fR(ms)\fP
+Split up, the format is as follows (comments in brackets denote when a
+field was introduced or whether it's specific to some terse version):
 .P
-Submission latency:
-.RS
-.B min, max, mean, standard deviation
-.RE
-Completion latency:
-.RS
-.B min, max, mean, standard deviation
-.RE
-Completion latency percentiles (20 fields):
-.RS
-.B Xth percentile=usec
-.RE
-Total latency:
+.nf
+			terse version, fio version [v3], jobname, groupid, error
+.fi
 .RS
-.B min, max, mean, standard deviation
+.P
+.B
+READ status:
 .RE
-Bandwidth:
+.P
+.nf
+			Total IO (KiB), bandwidth (KiB/sec), IOPS, runtime (msec)
+			Submission latency: min, max, mean, stdev (usec)
+			Completion latency: min, max, mean, stdev (usec)
+			Completion latency percentiles: 20 fields (see below)
+			Total latency: min, max, mean, stdev (usec)
+			Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+			IOPS [v5]: min, max, mean, stdev, number of samples
+.fi
 .RS
-.B min, max, aggregate percentage of total, mean, standard deviation, number of samples [v5]
+.P
+.B
+WRITE status:
 .RE
-IOPS [v5]:
+.P
+.nf
+			Total IO (KiB), bandwidth (KiB/sec), IOPS, runtime (msec)
+			Submission latency: min, max, mean, stdev (usec)
+			Completion latency: min, max, mean, stdev (usec)
+			Completion latency percentiles: 20 fields (see below)
+			Total latency: min, max, mean, stdev (usec)
+			Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+			IOPS [v5]: min, max, mean, stdev, number of samples
+.fi
 .RS
-.B min, max, mean, standard deviation, number of samples
-.RE
+.P
+.B
+TRIM status [all but version 3]:
 .RE
 .P
-Trim status [all but version 3]:
+.nf
+			Fields are similar to \fBREAD/WRITE\fR status.
+.fi
 .RS
-Similar to Read/Write status but for trims.
-.RE
 .P
+.B
 CPU usage:
-.RS
-.B user, system, context switches, major page faults, minor page faults
 .RE
 .P
-IO depth distribution:
+.nf
+			user, system, context switches, major faults, minor faults
+.fi
 .RS
-.B <=1, 2, 4, 8, 16, 32, >=64
+.P
+.B
+I/O depths:
 .RE
 .P
-IO latency distribution:
-.RS
-Microseconds:
+.nf
+			<=1, 2, 4, 8, 16, 32, >=64
+.fi
 .RS
-.B <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
+.P
+.B
+I/O latencies microseconds:
 .RE
-Milliseconds:
+.P
+.nf
+			<=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
+.fi
 .RS
-.B <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, 2000, >=2000
-.RE
+.P
+.B
+I/O latencies milliseconds:
 .RE
 .P
-Disk utilization (1 for each disk used) [v3]:
+.nf
+			<=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000, 2000, >=2000
+.fi
 .RS
-.B name, read ios, write ios, read merges, write merges, read ticks, write ticks, read in-queue time, write in-queue time, disk utilization percentage
+.P
+.B
+Disk utilization [v3]:
 .RE
 .P
-Error Info (dependent on continue_on_error, default off):
+.nf
+			disk name, read ios, write ios, read merges, write merges, read ticks, write ticks, time spent in queue, disk utilization percentage
+.fi
 .RS
-.B total # errors, first error code
-.RE
 .P
-.B text description (if provided in config - appears on newline)
+.B
+Additional Info (dependent on continue_on_error, default off):
 .RE
 .P
-Below is a single line containing short names for each of the fields in
-the minimal output v3, separated by semicolons:
+.nf
+			total # errors, first error code
+.fi
 .RS
 .P
+.B
+Additional Info (dependent on description being set):
+.RE
+.P
 .nf
-terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+			Text description
+.fi
+.P
+Completion latency percentiles can be a grouping of up to 20 sets, so for the
+terse output fio writes all of them. Each field will look like this:
+.P
+.nf
+		1.00%=6112
+.fi
+.P
+which is the Xth percentile, and the `usec' latency associated with it.
+.P
+For \fBDisk utilization\fR, all disks used by fio are shown. So for each disk there
+will be a disk utilization section.
+.P
+Below is a single line containing short names for each of the fields in the
+minimal output v3, separated by semicolons:
+.P
+.nf
+		terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct1
 0;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 .fi
-.RE
 .SH JSON+ OUTPUT
 The \fBjson+\fR output format is identical to the \fBjson\fR output format except that it
 adds a full dump of the completion latency bins. Each \fBbins\fR object contains a
 set of (key, value) pairs where keys are latency durations and values count how
 many I/Os had completion latencies of the corresponding duration. For example,
 consider:
-
 .RS
+.P
 "bins" : { "87552" : 1, "89600" : 1, "94720" : 1, "96768" : 1, "97792" : 1, "99840" : 1, "100864" : 2, "103936" : 6, "104960" : 534, "105984" : 5995, "107008" : 7529, ... }
 .RE
-
+.P
 This data indicates that one I/O required 87,552ns to complete, two I/Os required
 100,864ns to complete, and 7529 I/Os required 107,008ns to complete.
-
+.P
 Also included with fio is a Python script \fBfio_jsonplus_clat2csv\fR that takes
-json+ output and generates CSV-formatted latency data suitable for plotting.
-
+json+ output and generates CSV\-formatted latency data suitable for plotting.
+.P
 The latency durations actually represent the midpoints of latency intervals.
-For details refer to stat.h.
-
-
+For details refer to `stat.h' in the fio source.
 .SH TRACE FILE FORMAT
-There are two trace file format that you can encounter. The older (v1) format
-is unsupported since version 1.20-rc3 (March 2008). It will still be described
+There are two trace file format that you can encounter. The older (v1) format is
+unsupported since version 1.20\-rc3 (March 2008). It will still be described
 below in case that you get an old trace and want to understand it.
-
-In any case the trace is a simple text file with a single action per line.
-
 .P
+In any case the trace is a simple text file with a single action per line.
+.TP
 .B Trace file format v1
+Each line represents a single I/O action in the following format:
 .RS
-Each line represents a single io action in the following format:
-
+.RS
+.P
 rw, offset, length
-
-where rw=0/1 for read/write, and the offset and length entries being in bytes.
-
-This format is not supported in Fio versions => 1.20-rc3.
-
 .RE
 .P
+where `rw=0/1' for read/write, and the `offset' and `length' entries being in bytes.
+.P
+This format is not supported in fio versions >= 1.20\-rc3.
+.RE
+.TP
 .B Trace file format v2
+The second version of the trace file format was added in fio version 1.17. It
+allows to access more then one file per trace and has a bigger set of possible
+file actions.
 .RS
-The second version of the trace file format was added in Fio version 1.17.
-It allows one to access more then one file per trace and has a bigger set of
-possible file actions.
-
+.P
 The first line of the trace file has to be:
-
-\fBfio version 2 iolog\fR
-
+.RS
+.P
+"fio version 2 iolog"
+.RE
+.P
 Following this can be lines in two different formats, which are described below.
+.P
+.B
 The file management format:
-
-\fBfilename action\fR
-
-The filename is given as an absolute path. The action can be one of these:
-
+.RS
+filename action
 .P
-.PD 0
+The `filename' is given as an absolute path. The `action' can be one of these:
 .RS
 .TP
 .B add
-Add the given filename to the trace
+Add the given `filename' to the trace.
 .TP
 .B open
-Open the file with the given filename. The filename has to have been previously
-added with the \fBadd\fR action.
+Open the file with the given `filename'. The `filename' has to have
+been added with the \fBadd\fR action before.
 .TP
 .B close
-Close the file with the given filename. The file must have previously been
-opened.
+Close the file with the given `filename'. The file has to have been
+\fBopen\fRed before.
+.RE
 .RE
-.PD
 .P
-
-The file io action format:
-
-\fBfilename action offset length\fR
-
-The filename is given as an absolute path, and has to have been added and opened
-before it can be used with this format. The offset and length are given in
-bytes. The action can be one of these:
-
+.B
+The file I/O action format:
+.RS
+filename action offset length
 .P
-.PD 0
+The `filename' is given as an absolute path, and has to have been \fBadd\fRed and
+\fBopen\fRed before it can be used with this format. The `offset' and `length' are
+given in bytes. The `action' can be one of these:
 .RS
 .TP
 .B wait
-Wait for 'offset' microseconds. Everything below 100 is discarded.  The time is
-relative to the previous wait statement.
+Wait for `offset' microseconds. Everything below 100 is discarded.
+The time is relative to the previous `wait' statement.
 .TP
 .B read
-Read \fBlength\fR bytes beginning from \fBoffset\fR
+Read `length' bytes beginning from `offset'.
 .TP
 .B write
-Write \fBlength\fR bytes beginning from \fBoffset\fR
+Write `length' bytes beginning from `offset'.
 .TP
 .B sync
-fsync() the file
+\fBfsync\fR\|(2) the file.
 .TP
 .B datasync
-fdatasync() the file
+\fBfdatasync\fR\|(2) the file.
 .TP
 .B trim
-trim the given file from the given \fBoffset\fR for \fBlength\fR bytes
+Trim the given file from the given `offset' for `length' bytes.
+.RE
 .RE
-.PD
-.P
-
 .SH CPU IDLENESS PROFILING
-In some cases, we want to understand CPU overhead in a test. For example,
-we test patches for the specific goodness of whether they reduce CPU usage.
-fio implements a balloon approach to create a thread per CPU that runs at
-idle priority, meaning that it only runs when nobody else needs the cpu.
-By measuring the amount of work completed by the thread, idleness of each
-CPU can be derived accordingly.
-
-An unit work is defined as touching a full page of unsigned characters. Mean
-and standard deviation of time to complete an unit work is reported in "unit
-work" section. Options can be chosen to report detailed percpu idleness or
-overall system idleness by aggregating percpu stats.
-
+In some cases, we want to understand CPU overhead in a test. For example, we
+test patches for the specific goodness of whether they reduce CPU usage.
+Fio implements a balloon approach to create a thread per CPU that runs at idle
+priority, meaning that it only runs when nobody else needs the cpu.
+By measuring the amount of work completed by the thread, idleness of each CPU
+can be derived accordingly.
+.P
+An unit work is defined as touching a full page of unsigned characters. Mean and
+standard deviation of time to complete an unit work is reported in "unit work"
+section. Options can be chosen to report detailed percpu idleness or overall
+system idleness by aggregating percpu stats.
 .SH VERIFICATION AND TRIGGERS
-Fio is usually run in one of two ways, when data verification is done. The
-first is a normal write job of some sort with verify enabled. When the
-write phase has completed, fio switches to reads and verifies everything
-it wrote. The second model is running just the write phase, and then later
-on running the same job (but with reads instead of writes) to repeat the
-same IO patterns and verify the contents. Both of these methods depend
-on the write phase being completed, as fio otherwise has no idea how much
-data was written.
-
-With verification triggers, fio supports dumping the current write state
-to local files. Then a subsequent read verify workload can load this state
-and know exactly where to stop. This is useful for testing cases where
-power is cut to a server in a managed fashion, for instance.
-
+Fio is usually run in one of two ways, when data verification is done. The first
+is a normal write job of some sort with verify enabled. When the write phase has
+completed, fio switches to reads and verifies everything it wrote. The second
+model is running just the write phase, and then later on running the same job
+(but with reads instead of writes) to repeat the same I/O patterns and verify
+the contents. Both of these methods depend on the write phase being completed,
+as fio otherwise has no idea how much data was written.
+.P
+With verification triggers, fio supports dumping the current write state to
+local files. Then a subsequent read verify workload can load this state and know
+exactly where to stop. This is useful for testing cases where power is cut to a
+server in a managed fashion, for instance.
+.P
 A verification trigger consists of two things:
-
 .RS
-Storing the write state of each job
-.LP
-Executing a trigger command
+.P
+1) Storing the write state of each job.
+.P
+2) Executing a trigger command.
 .RE
-
-The write state is relatively small, on the order of hundreds of bytes
-to single kilobytes. It contains information on the number of completions
-done, the last X completions, etc.
-
-A trigger is invoked either through creation (\fBtouch\fR) of a specified
-file in the system, or through a timeout setting. If fio is run with
-\fB\-\-trigger\-file=/tmp/trigger-file\fR, then it will continually check for
-the existence of /tmp/trigger-file. When it sees this file, it will
-fire off the trigger (thus saving state, and executing the trigger
+.P
+The write state is relatively small, on the order of hundreds of bytes to single
+kilobytes. It contains information on the number of completions done, the last X
+completions, etc.
+.P
+A trigger is invoked either through creation ('touch') of a specified file in
+the system, or through a timeout setting. If fio is run with
+`\-\-trigger\-file=/tmp/trigger\-file', then it will continually
+check for the existence of `/tmp/trigger\-file'. When it sees this file, it
+will fire off the trigger (thus saving state, and executing the trigger
 command).
-
-For client/server runs, there's both a local and remote trigger. If
-fio is running as a server backend, it will send the job states back
-to the client for safe storage, then execute the remote trigger, if
-specified. If a local trigger is specified, the server will still send
-back the write state, but the client will then execute the trigger.
-
+.P
+For client/server runs, there's both a local and remote trigger. If fio is
+running as a server backend, it will send the job states back to the client for
+safe storage, then execute the remote trigger, if specified. If a local trigger
+is specified, the server will still send back the write state, but the client
+will then execute the trigger.
 .RE
 .P
 .B Verification trigger example
 .RS
-
-Lets say we want to run a powercut test on the remote machine 'server'.
-Our write workload is in write-test.fio. We want to cut power to 'server'
-at some point during the run, and we'll run this test from the safety
-or our local machine, 'localbox'. On the server, we'll start the fio
-backend normally:
-
-server# \fBfio \-\-server\fR
-
+Let's say we want to run a powercut test on the remote Linux machine 'server'.
+Our write workload is in `write\-test.fio'. We want to cut power to 'server' at
+some point during the run, and we'll run this test from the safety or our local
+machine, 'localbox'. On the server, we'll start the fio backend normally:
+.RS
+.P
+server# fio \-\-server
+.RE
+.P
 and on the client, we'll fire off the workload:
-
-localbox$ \fBfio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger-remote="bash \-c "echo b > /proc/sysrq-triger""\fR
-
-We set \fB/tmp/my-trigger\fR as the trigger file, and we tell fio to execute
-
-\fBecho b > /proc/sysrq-trigger\fR
-
-on the server once it has received the trigger and sent us the write
-state. This will work, but it's not \fIreally\fR cutting power to the server,
-it's merely abruptly rebooting it. If we have a remote way of cutting
-power to the server through IPMI or similar, we could do that through
-a local trigger command instead. Lets assume we have a script that does
-IPMI reboot of a given hostname, ipmi-reboot. On localbox, we could
-then have run fio with a local trigger instead:
-
-localbox$ \fBfio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger="ipmi-reboot server"\fR
-
-For this case, fio would wait for the server to send us the write state,
-then execute 'ipmi-reboot server' when that happened.
-
+.RS
+.P
+localbox$ fio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger\-remote="bash \-c "echo b > /proc/sysrq\-triger""
+.RE
+.P
+We set `/tmp/my\-trigger' as the trigger file, and we tell fio to execute:
+.RS
+.P
+echo b > /proc/sysrq\-trigger
+.RE
+.P
+on the server once it has received the trigger and sent us the write state. This
+will work, but it's not really cutting power to the server, it's merely
+abruptly rebooting it. If we have a remote way of cutting power to the server
+through IPMI or similar, we could do that through a local trigger command
+instead. Let's assume we have a script that does IPMI reboot of a given hostname,
+ipmi\-reboot. On localbox, we could then have run fio with a local trigger
+instead:
+.RS
+.P
+localbox$ fio \-\-client=server \-\-trigger\-file=/tmp/my\-trigger \-\-trigger="ipmi\-reboot server"
+.RE
+.P
+For this case, fio would wait for the server to send us the write state, then
+execute `ipmi\-reboot server' when that happened.
 .RE
 .P
 .B Loading verify state
 .RS
-To load store write state, read verification job file must contain
-the verify_state_load option. If that is set, fio will load the previously
+To load stored write state, a read verification job file must contain the
+\fBverify_state_load\fR option. If that is set, fio will load the previously
 stored state. For a local fio run this is done by loading the files directly,
-and on a client/server run, the server backend will ask the client to send
-the files over and load them from there.
-
+and on a client/server run, the server backend will ask the client to send the
+files over and load them from there.
 .RE
-
 .SH LOG FILE FORMATS
-
 Fio supports a variety of log file formats, for logging latencies, bandwidth,
 and IOPS. The logs share a common format, which looks like this:
-
-.B time (msec), value, data direction, block size (bytes), offset (bytes)
-
-Time for the log entry is always in milliseconds. The value logged depends
-on the type of log, it will be one of the following:
-
+.RS
 .P
-.PD 0
+time (msec), value, data direction, block size (bytes), offset (bytes)
+.RE
+.P
+`Time' for the log entry is always in milliseconds. The `value' logged depends
+on the type of log, it will be one of the following:
+.RS
 .TP
 .B Latency log
-Value is in latency in usecs
+Value is latency in usecs
 .TP
 .B Bandwidth log
 Value is in KiB/sec
 .TP
 .B IOPS log
-Value is in IOPS
-.PD
-.P
-
-Data direction is one of the following:
-
+Value is IOPS
+.RE
 .P
-.PD 0
+`Data direction' is one of the following:
+.RS
 .TP
 .B 0
-IO is a READ
+I/O is a READ
 .TP
 .B 1
-IO is a WRITE
+I/O is a WRITE
 .TP
 .B 2
-IO is a TRIM
-.PD
-.P
-
-The entry's *block size* is always in bytes. The \fIoffset\fR is the offset, in
-bytes, from the start of the file, for that particular IO. The logging of the
-offset can be toggled with \fBlog_offset\fR.
-
-If windowed logging is enabled through \fBlog_avg_msec\fR, then fio doesn't log
-individual IOs. Instead of logs the average values over the specified
-period of time. Since \fIdata direction\fR, \fIblock size\fR and \fIoffset\fR
-are per-IO values, if windowed logging is enabled they aren't applicable and
-will be 0. If windowed logging is enabled and \fBlog_max_value\fR is set, then
-fio logs maximum values in that window instead of averages.
-
-For histogram logging the logs look like this:
-
-.B time (msec), data direction, block-size, bin 0, bin 1, ..., bin 1215
-
-Where 'bin i' gives the frequency of IO requests with a latency falling in
-the i-th bin. See \fBlog_hist_coarseness\fR for logging fewer bins.
-
+I/O is a TRIM
 .RE
-
+.P
+The entry's `block size' is always in bytes. The `offset' is the offset, in bytes,
+from the start of the file, for that particular I/O. The logging of the offset can be
+toggled with \fBlog_offset\fR.
+.P
+Fio defaults to logging every individual I/O. When IOPS are logged for individual
+I/Os the `value' entry will always be 1. If windowed logging is enabled through
+\fBlog_avg_msec\fR, fio logs the average values over the specified period of time.
+If windowed logging is enabled and \fBlog_max_value\fR is set, then fio logs
+maximum values in that window instead of averages. Since `data direction', `block size'
+and `offset' are per\-I/O values, if windowed logging is enabled they
+aren't applicable and will be 0.
 .SH CLIENT / SERVER
-Normally you would run fio as a stand-alone application on the machine
-where the IO workload should be generated. However, it is also possible to
-run the frontend and backend of fio separately. This makes it possible to
-have a fio server running on the machine(s) where the IO workload should
-be running, while controlling it from another machine.
-
-To start the server, you would do:
-
-\fBfio \-\-server=args\fR
-
-on that machine, where args defines what fio listens to. The arguments
-are of the form 'type:hostname or IP:port'. 'type' is either 'ip' (or ip4)
-for TCP/IP v4, 'ip6' for TCP/IP v6, or 'sock' for a local unix domain
-socket. 'hostname' is either a hostname or IP address, and 'port' is the port to
-listen to (only valid for TCP/IP, not a local socket). Some examples:
-
+Normally fio is invoked as a stand\-alone application on the machine where the
+I/O workload should be generated. However, the backend and frontend of fio can
+be run separately i.e., the fio server can generate an I/O workload on the "Device
+Under Test" while being controlled by a client on another machine.
+.P
+Start the server on the machine which has access to the storage DUT:
+.RS
+.P
+$ fio \-\-server=args
+.RE
+.P
+where `args' defines what fio listens to. The arguments are of the form
+`type,hostname' or `IP,port'. `type' is either `ip' (or ip4) for TCP/IP
+v4, `ip6' for TCP/IP v6, or `sock' for a local unix domain socket.
+`hostname' is either a hostname or IP address, and `port' is the port to listen
+to (only valid for TCP/IP, not a local socket). Some examples:
+.RS
+.TP
 1) \fBfio \-\-server\fR
-
-   Start a fio server, listening on all interfaces on the default port (8765).
-
+Start a fio server, listening on all interfaces on the default port (8765).
+.TP
 2) \fBfio \-\-server=ip:hostname,4444\fR
-
-   Start a fio server, listening on IP belonging to hostname and on port 4444.
-
+Start a fio server, listening on IP belonging to hostname and on port 4444.
+.TP
 3) \fBfio \-\-server=ip6:::1,4444\fR
-
-   Start a fio server, listening on IPv6 localhost ::1 and on port 4444.
-
+Start a fio server, listening on IPv6 localhost ::1 and on port 4444.
+.TP
 4) \fBfio \-\-server=,4444\fR
-
-   Start a fio server, listening on all interfaces on port 4444.
-
+Start a fio server, listening on all interfaces on port 4444.
+.TP
 5) \fBfio \-\-server=1.2.3.4\fR
-
-   Start a fio server, listening on IP 1.2.3.4 on the default port.
-
+Start a fio server, listening on IP 1.2.3.4 on the default port.
+.TP
 6) \fBfio \-\-server=sock:/tmp/fio.sock\fR
-
-   Start a fio server, listening on the local socket /tmp/fio.sock.
-
-When a server is running, you can connect to it from a client. The client
-is run with:
-
-\fBfio \-\-local-args \-\-client=server \-\-remote-args <job file(s)>\fR
-
-where \-\-local-args are arguments that are local to the client where it is
-running, 'server' is the connect string, and \-\-remote-args and <job file(s)>
-are sent to the server. The 'server' string follows the same format as it
-does on the server side, to allow IP/hostname/socket and port strings.
-You can connect to multiple clients as well, to do that you could run:
-
-\fBfio \-\-client=server2 \-\-client=server2 <job file(s)>\fR
-
-If the job file is located on the fio server, then you can tell the server
-to load a local file as well. This is done by using \-\-remote-config:
-
-\fBfio \-\-client=server \-\-remote-config /path/to/file.fio\fR
-
-Then fio will open this local (to the server) job file instead
-of being passed one from the client.
-
+Start a fio server, listening on the local socket `/tmp/fio.sock'.
+.RE
+.P
+Once a server is running, a "client" can connect to the fio server with:
+.RS
+.P
+$ fio <local\-args> \-\-client=<server> <remote\-args> <job file(s)>
+.RE
+.P
+where `local\-args' are arguments for the client where it is running, `server'
+is the connect string, and `remote\-args' and `job file(s)' are sent to the
+server. The `server' string follows the same format as it does on the server
+side, to allow IP/hostname/socket and port strings.
+.P
+Fio can connect to multiple servers this way:
+.RS
+.P
+$ fio \-\-client=<server1> <job file(s)> \-\-client=<server2> <job file(s)>
+.RE
+.P
+If the job file is located on the fio server, then you can tell the server to
+load a local file as well. This is done by using \fB\-\-remote\-config\fR:
+.RS
+.P
+$ fio \-\-client=server \-\-remote\-config /path/to/file.fio
+.RE
+.P
+Then fio will open this local (to the server) job file instead of being passed
+one from the client.
+.P
 If you have many servers (example: 100 VMs/containers), you can input a pathname
-of a file containing host IPs/names as the parameter value for the \-\-client option.
-For example, here is an example "host.list" file containing 2 hostnames:
-
+of a file containing host IPs/names as the parameter value for the
+\fB\-\-client\fR option. For example, here is an example `host.list'
+file containing 2 hostnames:
+.RS
+.P
+.PD 0
 host1.your.dns.domain
-.br
+.P
 host2.your.dns.domain
-
+.PD
+.RE
+.P
 The fio command would then be:
-
-\fBfio \-\-client=host.list <job file>\fR
-
-In this mode, you cannot input server-specific parameters or job files, and all
+.RS
+.P
+$ fio \-\-client=host.list <job file(s)>
+.RE
+.P
+In this mode, you cannot input server\-specific parameters or job files \-\- all
 servers receive the same job file.
-
-In order to enable fio \-\-client runs utilizing a shared filesystem from multiple hosts,
-fio \-\-client now prepends the IP address of the server to the filename. For example,
-if fio is using directory /mnt/nfs/fio and is writing filename fileio.tmp,
-with a \-\-client hostfile
-containing two hostnames h1 and h2 with IP addresses 192.168.10.120 and 192.168.10.121, then
-fio will create two files:
-
+.P
+In order to let `fio \-\-client' runs use a shared filesystem from multiple
+hosts, `fio \-\-client' now prepends the IP address of the server to the
+filename. For example, if fio is using the directory `/mnt/nfs/fio' and is
+writing filename `fileio.tmp', with a \fB\-\-client\fR `hostfile'
+containing two hostnames `h1' and `h2' with IP addresses 192.168.10.120 and
+192.168.10.121, then fio will create two files:
+.RS
+.P
+.PD 0
 /mnt/nfs/fio/192.168.10.120.fileio.tmp
-.br
+.P
 /mnt/nfs/fio/192.168.10.121.fileio.tmp
-
+.PD
+.RE
 .SH AUTHORS
-
 .B fio
 was written by Jens Axboe <jens.axboe@oracle.com>,
 now Jens Axboe <axboe@fb.com>.
 .br
 This man page was written by Aaron Carroll <aaronc@cse.unsw.edu.au> based
 on documentation by Jens Axboe.
+.br
+This man page was rewritten by Tomohiro Kusumi <tkusumi@tuxera.com> based
+on documentation by Jens Axboe.
 .SH "REPORTING BUGS"
 Report bugs to the \fBfio\fR mailing list <fio@vger.kernel.org>.
 .br
-See \fBREPORTING-BUGS\fR.
-
-\fBREPORTING-BUGS\fR: http://git.kernel.dk/cgit/fio/plain/REPORTING-BUGS
+See \fBREPORTING\-BUGS\fR.
+.P
+\fBREPORTING\-BUGS\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/REPORTING\-BUGS\fR
 .SH "SEE ALSO"
 For further documentation see \fBHOWTO\fR and \fBREADME\fR.
 .br
-Sample jobfiles are available in the \fBexamples\fR directory.
-.br
-These are typically located under /usr/share/doc/fio.
-
-\fBHOWTO\fR:  http://git.kernel.dk/cgit/fio/plain/HOWTO
+Sample jobfiles are available in the `examples/' directory.
 .br
-\fBREADME\fR: http://git.kernel.dk/cgit/fio/plain/README
+These are typically located under `/usr/share/doc/fio'.
+.P
+\fBHOWTO\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/HOWTO\fR
 .br
+\fBREADME\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/README\fR
diff --git a/gfio.c b/gfio.c
index 7c92a50..7160c3a 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1243,7 +1243,7 @@ static void about_dialog(GtkWidget *w, gpointer data)
 		"website", "http://git.kernel.dk/cgit/fio/",
 		"authors", authors,
 		"version", fio_version_string,
-		"copyright", "�� 2012 Jens Axboe <axboe@kernel.dk>",
+		"copyright", "�� 2012-2017 Jens Axboe <axboe@kernel.dk>",
 		"logo-icon-name", "fio",
 		/* Must be last: */
 		"wrap-license", TRUE,
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 500d64c..edfefa8 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.99">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="3.0">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/printing.c b/printing.c
index 4dcc986..b58996b 100644
--- a/printing.c
+++ b/printing.c
@@ -31,7 +31,7 @@ static void results_draw_page(GtkPrintOperation *operation,
 			      gpointer data)
 {
 	cairo_t *cr;
-	char str[20];
+	char str[32];
 	double x, y;
 
 	cr = gtk_print_context_get_cairo_context(context);
