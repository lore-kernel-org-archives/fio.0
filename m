Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v3 4/4] HOWTO: minor fixes and backports from man page
Date: Mon, 14 Aug 2017 18:30:26 +0300
Message-Id: <20170814153026.44260-5-tkusumi@tuxera.com>
In-Reply-To: <20170814153026.44260-1-tkusumi@tuxera.com>
References: <20170814153026.44260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

These are minor fixes not worth separating into different commits,
which are partly backports from the previous 3 commits, and partly
its own minor fixes.

 * Use proper argument name (option -> command).
 * Use proper quotation (``).
 * Add missing :option:`` directives.
 * Add missing :file:`` directive (stat.h).
 * Add indentation.
 * Add missing alias (mem_align=).
 * Add missing period.
 * Add $ for fio command line examples
 * Cleanup ordering of some ioengine specific options.
 * Change inconsistent quotations for "1..N" and "N" to always use ``.
 * Avoid mixing of whitespace and tab indentation within the same section/block.
 * Correct fio commands' name (fio-genzipf, fio_generate_plots)
 * Correct typos ("used,where", "See disable_slat" in disable_slat)
 * Change "IO" to "I/O" which has been corrected in the past commits as well,
   except for "IO" in the output of fio itself.
 * Mention verification trigger (using magic sysrq) is Linux specific.
 * Mention "Disk stats" output (using sysfs) is Linux specific.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 HOWTO | 193 ++++++++++++++++++++++++++++++++----------------------------------
 1 file changed, 94 insertions(+), 99 deletions(-)

diff --git a/HOWTO b/HOWTO
index 8a7cb1a..57d4a39 100644
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
@@ -3251,7 +3248,7 @@ For each data direction it prints:
 **run**
 		The smallest and longest runtimes of the threads in this group.
 
-And finally, the disk statistics are printed. They will look like this::
+And finally, the disk statistics are printed. This is Linux specific. They will look like this::
 
   Disk stats (read/write):
     sda: ios=16398/16511, merge=30/162, ticks=6853/819634, in_queue=826487, util=100.00%
@@ -3302,7 +3299,7 @@ field was introduced or whether it's specific to some terse version):
 
     ::
 
-	terse version, fio version [v3], jobname, groupid, error
+        terse version, fio version [v3], jobname, groupid, error
 
     READ status::
 
@@ -3311,8 +3308,8 @@ field was introduced or whether it's specific to some terse version):
         Completion latency: min, max, mean, stdev (usec)
         Completion latency percentiles: 20 fields (see below)
         Total latency: min, max, mean, stdev (usec)
-	Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
-	IOPS [v5]: min, max, mean, stdev, number of samples
+        Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev, number of samples [v5]
+        IOPS [v5]: min, max, mean, stdev, number of samples
 
     WRITE status:
 
@@ -3323,12 +3320,12 @@ field was introduced or whether it's specific to some terse version):
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
 
@@ -3348,10 +3345,8 @@ field was introduced or whether it's specific to some terse version):
 
     Disk utilization [v3]::
 
-        Disk name, Read ios, write ios,
-        Read merges, write merges,
-        Read ticks, write ticks,
-        Time spent in queue, disk utilization percentage
+        disk name, read ios, write ios, read merges, write merges, read ticks, write ticks,
+        time spent in queue, disk utilization percentage
 
     Additional Info (dependent on continue_on_error, default off)::
 
@@ -3364,17 +3359,17 @@ field was introduced or whether it's specific to some terse version):
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
 
-	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+        terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
 JSON+ output
@@ -3395,7 +3390,7 @@ Also included with fio is a Python script `fio_jsonplus_clat2csv` that takes
 json+ output and generates CSV-formatted latency data suitable for plotting.
 
 The latency durations actually represent the midpoints of latency intervals.
-For details refer to stat.h.
+For details refer to :file:`stat.h`.
 
 
 Trace file format
@@ -3415,7 +3410,7 @@ Each line represents a single I/O action in the following format::
 
 	rw, offset, length
 
-where `rw=0/1` for read/write, and the offset and length entries being in bytes.
+where `rw=0/1` for read/write, and the `offset` and `length` entries being in bytes.
 
 This format is not supported in fio versions >= 1.20-rc3.
 
@@ -3437,15 +3432,15 @@ The file management format::
 
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
 
 
@@ -3528,8 +3523,8 @@ will then execute the trigger.
 Verification trigger example
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-Let's say we want to run a powercut test on the remote machine 'server'.  Our
-write workload is in :file:`write-test.fio`. We want to cut power to 'server' at
+Let's say we want to run a powercut test on the remote Linux machine 'server'.
+Our write workload is in :file:`write-test.fio`. We want to cut power to 'server' at
 some point during the run, and we'll run this test from the safety or our local
 machine, 'localbox'. On the server, we'll start the fio backend normally::
 
@@ -3616,7 +3611,7 @@ Under Test" while being controlled by a client on another machine.
 
 Start the server on the machine which has access to the storage DUT::
 
-	fio --server=args
+	$ fio --server=args
 
 where `args` defines what fio listens to. The arguments are of the form
 ``type,hostname`` or ``IP,port``. *type* is either ``ip`` (or ip4) for TCP/IP
-- 
2.9.4


