Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:34924 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933987AbdACNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Jan 2017 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cOOhA-0004VH-A0
        for fio@vger.kernel.org; Tue, 03 Jan 2017 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170103130001.A51AE2C1D80@kernel.dk>
Date: Tue,  3 Jan 2017 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 915ca9807717762e288ded3eba0fe5fc82a2ddcd:

  options: mark steadystate option parents (2016-12-29 09:07:57 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 747311bd9cb82c02bfa4622054b5142a71a6c8ec:

  t/stest: remove old test (2017-01-02 18:21:14 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      t/stest: remove old test

Rebecca Cran (1):
      Update Windows maintainer contact details

Robert Elliott (12):
      Avoid using units in option defaults
      gfio: Improve IOPS textbox labels
      Document trim workload choices and other nits
      tests, profiles: Use IEC prefixes for binary multiples
      Fix unit_base kb_base mixup in thread option conversion functions
      Line up colons across read, write, and trim thread stats
      gclient: Delete unused code
      gclient: Use proper time units in latency buckets chart
      Convert group_run_stats to use bytes instead of KiB/KB
      Clean up unit prefixes for binary multiples in comments and prints
      Improve IEC binary and SI decimal prefix handling
      Documentation for IEC binary and SI decimal prefix handling

 HOWTO                           | 299 +++++++++++++++++++++++++---------------
 README                          |   4 +-
 backend.c                       |  18 ++-
 cconv.c                         |   4 +-
 client.c                        |   2 +-
 crc/test.c                      |   4 +-
 engines/dev-dax.c               |   2 +-
 engines/mmap.c                  |   2 +-
 eta.c                           |  46 +++++--
 filesetup.c                     |   5 +-
 fio.1                           | 205 ++++++++++++++++++---------
 fio.h                           |   7 +
 gclient.c                       | 173 ++++++++++++-----------
 gfio.c                          |  10 +-
 goptions.c                      |   2 +-
 init.c                          |  39 ++----
 lib/num2str.c                   |  57 ++++++--
 memory.c                        |   4 +-
 options.c                       |  14 +-
 parse.c                         |  40 ++++--
 profiles/act.c                  |  14 +-
 profiles/tiobench.c             |   6 +-
 server.c                        |   2 +-
 stat.c                          | 114 ++++++++-------
 stat.h                          |   2 +-
 t/btrace2fio.c                  |  18 +--
 t/dedupe.c                      |   2 +-
 t/genzipf.c                     |  13 +-
 t/lfsr-test.c                   |   2 +-
 t/memlock.c                     |  14 +-
 t/read-to-pipe-async.c          |   4 +-
 t/stest.c                       |  12 --
 unit_tests/steadystate_tests.py |   2 +-
 33 files changed, 674 insertions(+), 468 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 7274c0e..4354e46 100644
--- a/HOWTO
+++ b/HOWTO
@@ -116,7 +116,7 @@ section residing above it. If the first character in a line is a ';' or a
 '#', the entire line is discarded as a comment.
 
 So let's look at a really simple job file that defines two processes, each
-randomly reading from a 128MB file.
+randomly reading from a 128MiB file.
 
 ; -- start job file --
 [global]
@@ -154,9 +154,9 @@ numjobs=4
 
 Here we have no global section, as we only have one job defined anyway.
 We want to use async io here, with a depth of 4 for each file. We also
-increased the buffer size used to 32KB and define numjobs to 4 to
+increased the buffer size used to 32KiB and define numjobs to 4 to
 fork 4 identical jobs. The result is 4 processes each randomly writing
-to their own 64MB file. Instead of using the above job file, you could
+to their own 64MiB file. Instead of using the above job file, you could
 have given the parameters on the command line. For this case, you would
 specify:
 
@@ -276,20 +276,70 @@ time	Integer with possible time suffix. In seconds unless otherwise
 	specified, use eg 10m for 10 minutes. Accepts s/m/h for seconds,
 	minutes, and hours, and accepts 'ms' (or 'msec') for milliseconds,
 	and 'us' (or 'usec') for microseconds.
-int	SI integer. A whole number value, which may contain a suffix
-	describing the base of the number. Accepted suffixes are k/m/g/t/p,
-	meaning kilo, mega, giga, tera, and peta. The suffix is not case
-	sensitive, and you may also include trailing 'b' (eg 'kb' is the same
-	as 'k'). So if you want to specify 4096, you could either write
-	out '4096' or just give 4k. The suffixes signify base 2 values, so
-	1024 is 1k and 1024k is 1m and so on, unless the suffix is explicitly
-	set to a base 10 value using 'kib', 'mib', 'gib', etc. If that is the
-	case, then 1000 is used as the multiplier. This can be handy for
-	disks, since manufacturers generally use base 10 values when listing
-	the capacity of a drive. If the option accepts an upper and lower
-	range, use a colon ':' or minus '-' to separate such values.  May also
-	include a prefix to indicate numbers base. If 0x is used, the number
-	is assumed to be hexadecimal.  See irange.
+
+int	Integer. A whole number value, which may contain an integer prefix
+	and an integer suffix.
+	[integer prefix]number[integer suffix]
+
+	The optional integer prefix specifies the number's base. The default
+	is decimal. 0x specifies hexadecimal.
+
+	The optional integer suffix specifies the number's units, and includes
+	an optional unit prefix and an optional unit.  For quantities of data,
+	the default unit is bytes. For quantities of time, the default unit
+	is seconds.
+
+	With kb_base=1000, fio follows international standards for unit prefixes.
+	To specify power-of-10 decimal values defined in the International
+	System of Units (SI):
+		Ki means kilo (K) or 1000
+		Mi means mega (M) or 1000**2
+		Gi means giga (G) or 1000**3
+		Ti means tera (T) or 1000**4
+		Pi means peta (P) or 1000**5
+
+	To specify power-of-2 binary values defined in IEC 80000-13:
+		k means kibi (Ki) or 1024
+		M means mebi (Mi) or 1024**2
+		G means gibi (Gi) or 1024**3
+		T means tebi (Ti) or 1024**4
+		P means pebi (Pi) or 1024**5
+
+	With kb_base=1024 (the default), the unit prefixes are opposite from
+	those specified in the SI and IEC 80000-13 standards to provide
+	compatibility with old scripts.  For example, 4k means 4096.
+
+	For quantities of data, an optional unit of 'B' may be included
+	(e.g.,  'kB' is the same as 'k').
+
+	The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega,
+	not milli). 'b' and 'B' both mean byte, not bit.
+
+	Examples with kb_base=1000:
+		4 KiB: 4096, 4096b, 4096B, 4ki, 4kib, 4kiB, 4Ki, 4KiB
+		1 MiB: 1048576, 1mi, 1024ki
+		1 MB: 1000000, 1m, 1000k
+		1 TiB: 1073741824, 1ti, 1024mi, 1048576ki
+		1 TB: 1000000000, 1t, 1000m, 1000000k
+
+	Examples with kb_base=1024 (default):
+		4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+		1 MiB: 1048576, 1m, 1024k
+		1 MB: 1000000, 1mi, 1000ki
+		1 TiB: 1073741824, 1t, 1024m, 1048576k
+		1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+
+	To specify times (units are not case sensitive):
+		D means days
+		H means hours
+		M mean minutes
+		s or sec means seconds (default)
+		ms or msec means milliseconds
+		us or usec means microseconds
+
+	If the option accepts an upper and lower range, use a colon ':' or
+	minus '-' to separate such values.   See irange.
+
 bool	Boolean. Usually parsed as an integer, however only defined for
 	true and false (1 and 0).
 irange	Integer range with suffix. Allows value range to be given, such
@@ -398,12 +448,13 @@ rw=str		Type of io pattern. Accepted values are:
 
 			read		Sequential reads
 			write		Sequential writes
+			trim		Sequential trims
 			randwrite	Random writes
 			randread	Random reads
+			randtrim	Random trims
 			rw,readwrite	Sequential mixed reads and writes
 			randrw		Random mixed reads and writes
-			trimwrite	Mixed trims and writes. Blocks will be
-					trimmed first, then written to.
+			trimwrite	Sequential trim+write sequences
 
 		Fio defaults to read if the option is not specified.
 		For the mixed io types, the default is to split them 50/50.
@@ -438,13 +489,27 @@ rw_sequencer=str If an offset modifier is given by appending a number to
 		the same offset 8 number of times before generating a new
 		offset.
 
-kb_base=int	The base unit for a kilobyte. The defacto base is 2^10, 1024.
-		Storage manufacturers like to use 10^3 or 1000 as a base
-		ten unit instead, for obvious reasons. Allow values are
-		1024 or 1000, with 1024 being the default.
+kb_base=int	Select the interpretation of unit prefixes in input parameters.
+		1000 = Inputs comply with IEC 80000-13 and the International
+		       System of Units (SI).  Use:
+			- power-of-2 values with IEC prefixes (e.g., KiB)
+			- power-of-10 values with SI prefixes (e.g., kB)
+		1024 = Compatibility mode (default).  To avoid breaking
+		       old scripts:
+			- power-of-2 values with SI prefixes
+			- power-of-10 values with IEC prefixes
+		See bs= for more details on input parameters.
+
+		Outputs always use correct prefixes.  Most outputs include
+		both side-by-side, like:
+			bw=2383.3kB/s (2327.4KiB/s)
+		If only one value is reported, then kb_base selects the
+		one to use:
+			1000 = SI prefixes
+			1024 = IEC prefixes
 
 unified_rw_reporting=bool	Fio normally reports statistics on a per
-		data direction basis, meaning that read, write, and trim are
+		data direction basis, meaning that reads, writes, and trims are
 		accounted and reported separately. If this option is set,
 		the fio will sum the results and report them as "mixed"
 		instead.
@@ -509,11 +574,11 @@ io_limit=int	Normally fio operates within the region set by 'size', which
 		means that the 'size' option sets both the region and size of
 		IO to be performed. Sometimes that is not what you want. With
 		this option, it is possible to define just the amount of IO
-		that fio should do. For instance, if 'size' is set to 20G and
-		'io_size' is set to 5G, fio will perform IO within the first
-		20G but exit when 5G have been done. The opposite is also
-		possible - if 'size' is set to 20G, and 'io_size' is set to
-		40G, then fio will do 40G of IO within the 0..20G region.
+		that fio should do. For instance, if 'size' is set to 20GiB and
+		'io_size' is set to 5GiB, fio will perform IO within the first
+		20GiB but exit when 5GiB have been done. The opposite is also
+		possible - if 'size' is set to 20GiB, and 'io_size' is set to
+		40GiB, then fio will do 40GiB of IO within the 0..20GiB region.
 
 filesize=int	Individual file sizes. May be a range, in which case fio
 		will select sizes for files at random within the given range
@@ -536,36 +601,36 @@ fill_fs=bool	Sets size to something really large and waits for ENOSPC (no
 		Additionally, writing beyond end-of-device will not return
 		ENOSPC there.
 
-blocksize=int
-bs=int		The block size used for the io units. Defaults to 4k. Values
-		can be given for both read and writes. If a single int is
-		given, it will apply to both. If a second int is specified
-		after a comma, it will apply to writes only. In other words,
-		the format is either bs=read_and_write or bs=read,write,trim.
-		bs=4k,8k will thus use 4k blocks for reads, 8k blocks for
-		writes, and 8k for trims. You can terminate the list with
-		a trailing comma. bs=4k,8k, would use the default value for
-		trims.. If you only wish to set the write size, you
-		can do so by passing an empty read size - bs=,8k will set
-		8k for writes and leave the read default value.
-
-blockalign=int
-ba=int		At what boundary to align random IO offsets. Defaults to
-		the same as 'blocksize' the minimum blocksize given.
-		Minimum alignment is typically 512b for using direct IO,
-		though it usually depends on the hardware block size. This
-		option is mutually exclusive with using a random map for
-		files, so it will turn off that option.
-
-blocksize_range=irange
-bsrange=irange	Instead of giving a single block size, specify a range
-		and fio will mix the issued io block sizes. The issued
-		io unit will always be a multiple of the minimum value
-		given (also see bs_unaligned). Applies to both reads and
-		writes, however a second range can be given after a comma.
-		See bs=.
-
-bssplit=str	Sometimes you want even finer grained control of the
+blocksize=int[,int][,int]
+bs=int[,int][,int]
+		The block size in bytes used for I/O units. Default: 4096.
+		A single value applies to reads, writes, and trims.
+		Comma-separated values may be specified for reads, writes,
+		and trims.  A value not terminated in a comma applies to
+		subsequent types.
+
+		Examples:
+		bs=256k    means 256k for reads, writes and trims
+		bs=8k,32k  means 8k for reads, 32k for writes and trims
+		bs=8k,32k, means 8k for reads, 32k for writes, and
+		           default for trims
+		bs=,8k     means default for reads, 8k for writes and trims
+		bs=,8k,    means default for reads, 8k for writes, and
+		           default for writes
+
+blocksize_range=irange[,irange][,irange]
+bsrange=irange[,irange][,irange]
+		A range of block sizes in bytes for I/O units.
+		The issued I/O unit will always be a multiple of the minimum
+		size, unless blocksize_unaligned is set.
+
+		Comma-separated ranges may be specified for reads, writes,
+		and trims as described in 'blocksize'.
+
+		Example: bsrange=1k-4k,2k-8k
+
+bssplit=str[,str][,str]
+		Sometimes you want even finer grained control of the
 		block sizes issued, not just an even split between them.
 		This option allows you to weight various block sizes,
 		so that you are able to define a specific amount of
@@ -589,24 +654,37 @@ bssplit=str	Sometimes you want even finer grained control of the
 		always add up to 100, if bssplit is given a range that adds
 		up to more, it will error out.
 
-		bssplit also supports giving separate splits to reads and
-		writes. The format is identical to what bs= accepts. You
-		have to separate the read and write parts with a comma. So
-		if you want a workload that has 50% 2k reads and 50% 4k reads,
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
+
+		If you want a workload that has 50% 2k reads and 50% 4k reads,
 		while having 90% 4k writes and 10% 8k writes, you would
 		specify:
 
 		bssplit=2k/50:4k/50,4k/90:8k/10
 
 blocksize_unaligned
-bs_unaligned	If this option is given, any byte size value within bsrange
-		may be used as a block range. This typically wont work with
-		direct IO, as that normally requires sector alignment.
+bs_unaligned	If set, fio will issue I/O units with any size within
+		blocksize_range, not just multiples of the minimum size.
+		This typically won't work with direct I/O, as that normally
+		requires sector alignment.
 
 bs_is_seq_rand	If this option is set, fio will use the normal read,write
-		blocksize settings as sequential,random instead. Any random
-		read or write will use the WRITE blocksize settings, and any
-		sequential read or write will use the READ blocksize setting.
+		blocksize settings as sequential,random blocksize settings
+		instead. Any random read or write will use the WRITE blocksize
+		settings, and any sequential read or write will use the READ
+		blocksize settings.
+
+blockalign=int[,int][,int]
+ba=int[,int][,int]
+		Boundary to which fio will align random I/O units.
+		Default: 'blocksize'.
+		Minimum alignment is typically 512b for using direct IO,
+		though it usually depends on the hardware block size. This
+		option is mutually exclusive with using a random map for
+		files, so it will turn off that option.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
 
 zero_buffers	If this option is given, fio will init the IO buffers to
 		all zeroes. The default is to fill them with random data.
@@ -836,7 +914,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 				filename, eg ioengine=external:/tmp/foo.o
 				to load ioengine foo.o in /tmp.
 
-iodepth=int	This defines how many io units to keep in flight against
+iodepth=int	This defines how many I/O units to keep in flight against
 		the file. The default is 1 for each file defined in this
 		job, can be overridden with a larger value for higher
 		concurrency. Note that increasing iodepth beyond 1 will not
@@ -989,7 +1067,8 @@ rwmixwrite=int	How large a percentage of the mix should be writes. If both
 		if fio is asked to limit reads or writes to a certain rate.
 		If that is the case, then the distribution may be skewed.
 
-random_distribution=str:float	By default, fio will use a completely uniform
+random_distribution=str:float[,str:float][,str:float]
+		By default, fio will use a completely uniform
 		random distribution when asked to perform random IO. Sometimes
 		it is useful to skew the distribution in specific ways,
 		ensuring that some parts of the data is more hot than others.
@@ -1031,14 +1110,15 @@ random_distribution=str:float	By default, fio will use a completely uniform
 		specify separate zones for reads, writes, and trims. If just
 		one set is given, it'll apply to all of them.
 
-percentage_random=int	For a random workload, set how big a percentage should
+percentage_random=int[,int][,int]
+		For a random workload, set how big a percentage should
 		be random. This defaults to 100%, in which case the workload
 		is fully random. It can be set from anywhere from 0 to 100.
 		Setting it to 0 would make the workload fully sequential. Any
 		setting in between will result in a random mix of sequential
-		and random IO, at the given percentages. It is possible to
-		set different values for reads, writes, and trim. To do so,
-		simply use a comma separated list. See blocksize.
+		and random IO, at the given percentages.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
 
 norandommap	Normally fio will cover every block of the file when doing
 		random IO. If this option is given, fio will just get a
@@ -1110,29 +1190,32 @@ thinktime_blocks=int
 		other words, this setting effectively caps the queue depth
 		if the latter is larger.
 
-rate=int	Cap the bandwidth used by this job. The number is in bytes/sec,
-		the normal suffix rules apply. You can use rate=500k to limit
-		reads and writes to 500k each, or you can specify read and
-		writes separately. Using rate=1m,500k would limit reads to
-		1MB/sec and writes to 500KB/sec. Capping only reads or
-		writes can be done with rate=,500k or rate=500k,. The former
-		will only limit writes (to 500KB/sec), the latter will only
-		limit reads.
-
-rate_min=int	Tell fio to do whatever it can to maintain at least this
-		bandwidth. Failing to meet this requirement, will cause
-		the job to exit. The same format as rate is used for
-		read vs write separation.
-
-rate_iops=int	Cap the bandwidth to this number of IOPS. Basically the same
+rate=int[,int][,int]
+		Cap the bandwidth used by this job. The number is in bytes/sec,
+		the normal suffix rules apply.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
+
+rate_min=int[,int][,int]
+		Tell fio to do whatever it can to maintain at least this
+		bandwidth. Failing to meet this requirement will cause
+		the job to exit.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
+
+rate_iops=int[,int][,int]
+		Cap the bandwidth to this number of IOPS. Basically the same
 		as rate, just specified independently of bandwidth. If the
 		job is given a block size range instead of a fixed value,
-		the smallest block size is used as the metric. The same format
-		as rate is used for read vs write separation.
+		the smallest block size is used as the metric.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
 
-rate_iops_min=int If fio doesn't meet this rate of IO, it will cause
-		the job to exit. The same format as rate is used for read vs
-		write separation.
+rate_iops_min=int[,int][,int]
+		If fio doesn't meet this rate of IO, it will cause
+		the job to exit.
+		Comma-separated values may be specified for reads, writes,
+		and trims as described in 'blocksize'.
 
 rate_process=str	This option controls how fio manages rated IO
 		submissions. The default is 'linear', which submits IO in a
@@ -1279,7 +1362,7 @@ sync=bool	Use sync io for buffered writes. For the majority of the
 		io engines, this means using O_SYNC.
 
 iomem=str
-mem=str		Fio can use various types of memory as the io unit buffer.
+mem=str		Fio can use various types of memory as the I/O unit buffer.
 		The allowed values are:
 
 			malloc	Use memory from malloc(3) as the buffers.
@@ -1307,7 +1390,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		that for shmhuge and mmaphuge to work, the system must have
 		free huge pages allocated. This can normally be checked
 		and set by reading/writing /proc/sys/vm/nr_hugepages on a
-		Linux system. Fio assumes a huge page is 4MB in size. So
+		Linux system. Fio assumes a huge page is 4MiB in size. So
 		to calculate the number of huge pages you need for a given
 		job file, add up the io depth of all jobs (normally one unless
 		iodepth= is used) and multiply by the maximum bs set. Then
@@ -1321,7 +1404,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		you would use mem=mmaphuge:/huge/somefile.
 
 iomem_align=int	This indicates the memory alignment of the IO memory buffers.
-		Note that the given alignment is applied to the first IO unit
+		Note that the given alignment is applied to the first I/O unit
 		buffer, if using iodepth the alignment of the following buffers
 		are given by the bs used. In other words, if using a bs that is
 		a multiple of the page sized in the system, all buffers will
@@ -1331,7 +1414,7 @@ iomem_align=int	This indicates the memory alignment of the IO memory buffers.
 
 hugepage-size=int
 		Defines the size of a huge page. Must at least be equal
-		to the system setting, see /proc/meminfo. Defaults to 4MB.
+		to the system setting, see /proc/meminfo. Defaults to 4MiB.
 		Should probably always be a multiple of megabytes, so using
 		hugepage-size=Xm is the preferred way to set this to avoid
 		setting a non-pow-2 bad value.
@@ -2023,7 +2106,7 @@ be the starting port number since fio will use a range of ports.
 fio spits out a lot of output. While running, fio will display the
 status of the jobs created. An example of that would be:
 
-Threads: 1: [_r] [24.8% done] [ 13509/  8334 kb/s] [eta 00h:01m:31s]
+Jobs: 1: [_r] [24.8% done] [r=20992KiB/s,w=24064KiB/s,t=0KiB/s] [r=82,w=94,t=0 iops] [eta 00h:01m:31s]
 
 The characters inside the square brackets denote the current status of
 each thread. The possible values (in typical life cycle order) are:
@@ -2052,7 +2135,7 @@ Fio will condense the thread string as not to take up more space on the
 command line as is needed. For instance, if you have 10 readers and 10
 writers running, the output would look like this:
 
-Jobs: 20 (f=20): [R(10),W(10)] [4.0% done] [2103MB/0KB/0KB /s] [538K/0/0 iops] [eta 57m:36s]
+Jobs: 20 (f=20): [R(10),W(10)] [4.0% done] [r=20992KiB/s,w=24064KiB/s,t=0KiB/s] [r=82,w=94,t=0 iops] [eta 57m:36s]
 
 Fio will still maintain the ordering, though. So the above means that jobs
 1..10 are readers, and 11..20 are writers.
@@ -2070,10 +2153,10 @@ each thread, group of threads, and disks in that order. For each data
 direction, the output looks like:
 
 Client1 (g=0): err= 0:
-  write: io=    32MB, bw=   666KB/s, iops=89 , runt= 50320msec
+  write: io=    32MiB, bw=   666KiB/s, iops=89 , runt= 50320msec
     slat (msec): min=    0, max=  136, avg= 0.03, stdev= 1.92
     clat (msec): min=    0, max=  631, avg=48.50, stdev=86.82
-    bw (KB/s) : min=    0, max= 1196, per=51.00%, avg=664.02, stdev=681.68
+    bw (KiB/s) : min=    0, max= 1196, per=51.00%, avg=664.02, stdev=681.68
   cpu        : usr=1.49%, sys=0.25%, ctx=7969, majf=0, minf=17
   IO depths    : 1=0.1%, 2=0.3%, 4=0.5%, 8=99.0%, 16=0.0%, 32=0.0%, >32=0.0%
      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
@@ -2192,19 +2275,19 @@ Split up, the format is as follows:
 
 	terse version, fio version, jobname, groupid, error
 	READ status:
-		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
+		Total IO (KiB), bandwidth (KiB/sec), IOPS, runtime (msec)
 		Submission latency: min, max, mean, stdev (usec)
 		Completion latency: min, max, mean, stdev (usec)
 		Completion latency percentiles: 20 fields (see below)
 		Total latency: min, max, mean, stdev (usec)
-		Bw (KB/s): min, max, aggregate percentage of total, mean, stdev
+		Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
 	WRITE status:
-		Total IO (KB), bandwidth (KB/sec), IOPS, runtime (msec)
+		Total IO (KiB), bandwidth (KiB/sec), IOPS, runtime (msec)
 		Submission latency: min, max, mean, stdev (usec)
 		Completion latency: min, max, mean, stdev(usec)
 		Completion latency percentiles: 20 fields (see below)
 		Total latency: min, max, mean, stdev (usec)
-		Bw (KB/s): min, max, aggregate percentage of total, mean, stdev
+		Bw (KiB/s): min, max, aggregate percentage of total, mean, stdev
 	CPU usage: user, system, context switches, major faults, minor faults
 	IO depths: <=1, 2, 4, 8, 16, 32, >=64
 	IO latencies microseconds: <=2, 4, 10, 20, 50, 100, 250, 500, 750, 1000
@@ -2395,7 +2478,7 @@ Time for the log entry is always in milliseconds. The value logged depends
 on the type of log, it will be one of the following:
 
 	Latency log		Value is latency in usecs
-	Bandwidth log		Value is in KB/sec
+	Bandwidth log		Value is in KiB/sec
 	IOPS log		Value is IOPS
 
 Data direction is one of the following:
diff --git a/README b/README
index a8a4fdf..a35842e 100644
--- a/README
+++ b/README
@@ -65,7 +65,7 @@ tool (http://www.opencsw.org/get-it/pkgutil/) and then install fio via
 'pkgutil -i fio'.
 
 Windows:
-Bruce Cran <bruce@cran.org.uk> has fio packages for Windows at
+Rebecca Cran <rebecca+fio@bluestop.org> has fio packages for Windows at
 http://www.bluestop.org/fio/ .
 
 
@@ -233,7 +233,7 @@ sections.  The reserved 'global' section is always parsed and used.
 The --alloc-size switch allows one to use a larger pool size for smalloc.
 If running large jobs with randommap enabled, fio can run out of memory.
 Smalloc is an internal allocator for shared structures from a fixed size
-memory pool. The pool size defaults to 16M and can grow to 8 pools.
+memory pool. The pool size defaults to 16MiB and can grow to 8 pools.
 
 NOTE: While running .fio_smalloc.* backing store files are visible in /tmp.
 
diff --git a/backend.c b/backend.c
index a048452..c8c6de6 100644
--- a/backend.c
+++ b/backend.c
@@ -180,8 +180,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 			 * check bandwidth specified rate
 			 */
 			if (bytes < td->rate_bytes[ddir]) {
-				log_err("%s: min rate %u not met\n", td->o.name,
-								ratemin);
+				log_err("%s: rate_min=%uB/s not met, only transferred %lluB\n",
+					td->o.name, ratemin, bytes);
 				return true;
 			} else {
 				if (spent)
@@ -191,9 +191,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 
 				if (rate < ratemin ||
 				    bytes < td->rate_bytes[ddir]) {
-					log_err("%s: min rate %u not met, got"
-						" %luKB/sec\n", td->o.name,
-							ratemin, rate);
+					log_err("%s: rate_min=%uB/s not met, got %luB/s\n",
+						td->o.name, ratemin, rate);
 					return true;
 				}
 			}
@@ -202,8 +201,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 			 * checks iops specified rate
 			 */
 			if (iops < rate_iops) {
-				log_err("%s: min iops rate %u not met\n",
-						td->o.name, rate_iops);
+				log_err("%s: rate_iops_min=%u not met, only performed %lu IOs\n",
+						td->o.name, rate_iops, iops);
 				return true;
 			} else {
 				if (spent)
@@ -213,9 +212,8 @@ static bool __check_min_rate(struct thread_data *td, struct timeval *now,
 
 				if (rate < rate_iops_min ||
 				    iops < td->rate_blocks[ddir]) {
-					log_err("%s: min iops rate %u not met,"
-						" got %lu\n", td->o.name,
-							rate_iops_min, rate);
+					log_err("%s: rate_iops_min=%u not met, got %lu IOPS\n",
+						td->o.name, rate_iops_min, rate);
 					return true;
 				}
 			}
diff --git a/cconv.c b/cconv.c
index 336805b..0c11629 100644
--- a/cconv.c
+++ b/cconv.c
@@ -88,7 +88,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
-	o->unit_base = le32_to_cpu(top->kb_base);
+	o->unit_base = le32_to_cpu(top->unit_base);
 	o->ddir_seq_nr = le32_to_cpu(top->ddir_seq_nr);
 	o->ddir_seq_add = le64_to_cpu(top->ddir_seq_add);
 	o->iodepth = le32_to_cpu(top->iodepth);
@@ -336,7 +336,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
-	top->unit_base = cpu_to_le32(o->kb_base);
+	top->unit_base = cpu_to_le32(o->unit_base);
 	top->ddir_seq_nr = cpu_to_le32(o->ddir_seq_nr);
 	top->iodepth = cpu_to_le32(o->iodepth);
 	top->iodepth_low = cpu_to_le32(o->iodepth_low);
diff --git a/client.c b/client.c
index 48d4c52..1b4d3d7 100644
--- a/client.c
+++ b/client.c
@@ -972,7 +972,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->min_run[i]		= le64_to_cpu(src->min_run[i]);
 		dst->max_bw[i]		= le64_to_cpu(src->max_bw[i]);
 		dst->min_bw[i]		= le64_to_cpu(src->min_bw[i]);
-		dst->io_kb[i]		= le64_to_cpu(src->io_kb[i]);
+		dst->iobytes[i]		= le64_to_cpu(src->iobytes[i]);
 		dst->agg[i]		= le64_to_cpu(src->agg[i]);
 	}
 
diff --git a/crc/test.c b/crc/test.c
index 213b5d5..300000d 100644
--- a/crc/test.c
+++ b/crc/test.c
@@ -338,9 +338,9 @@ int fio_crctest(const char *type)
 				sprintf(pre, "\t");
 			else
 				sprintf(pre, "\t\t");
-			printf("%s:%s%8.2f MB/sec\n", t[i].name, pre, mb_sec);
+			printf("%s:%s%8.2f MiB/sec\n", t[i].name, pre, mb_sec);
 		} else
-			printf("%s:inf MB/sec\n", t[i].name);
+			printf("%s:inf MiB/sec\n", t[i].name);
 		first = 0;
 	}
 
diff --git a/engines/dev-dax.c b/engines/dev-dax.c
index 6372576..2516bca 100644
--- a/engines/dev-dax.c
+++ b/engines/dev-dax.c
@@ -58,7 +58,7 @@
 #include "../verify.h"
 
 /*
- * Limits us to 1GB of mapped files in total to model after
+ * Limits us to 1GiB of mapped files in total to model after
  * mmap engine behavior
  */
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
diff --git a/engines/mmap.c b/engines/mmap.c
index c479ed3..99e1d6a 100644
--- a/engines/mmap.c
+++ b/engines/mmap.c
@@ -15,7 +15,7 @@
 #include "../verify.h"
 
 /*
- * Limits us to 1GB of mapped files in total
+ * Limits us to 1GiB of mapped files in total
  */
 #define MMAP_TOTAL_SZ	(1 * 1024 * 1024 * 1024UL)
 
diff --git a/eta.c b/eta.c
index 19afad5..1d66163 100644
--- a/eta.c
+++ b/eta.c
@@ -308,7 +308,7 @@ static void calc_rate(int unified_rw_rep, unsigned long mtime,
 
 		diff = io_bytes[i] - prev_io_bytes[i];
 		if (mtime)
-			this_rate = ((1000 * diff) / mtime) / 1024;
+			this_rate = ((1000 * diff) / mtime) / 1024; /* KiB/s */
 		else
 			this_rate = 0;
 
@@ -530,19 +530,28 @@ void display_thread_status(struct jobs_eta *je)
 	}
 
 	p += sprintf(p, "Jobs: %d (f=%d)", je->nr_running, je->files_open);
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
+
+	/* rate limits, if any */
+	if (je->m_rate[0] || je->m_rate[1] || je->m_rate[2] ||
+	    je->t_rate[0] || je->t_rate[1] || je->t_rate[2]) {
 		char *tr, *mr;
 
-		mr = num2str(je->m_rate[0] + je->m_rate[1], 4, 0, je->is_pow2, 8);
-		tr = num2str(je->t_rate[0] + je->t_rate[1], 4, 0, je->is_pow2, 8);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
+		mr = num2str(je->m_rate[0] + je->m_rate[1] + je->m_rate[2],
+				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+		tr = num2str(je->t_rate[0] + je->t_rate[1] + je->t_rate[2],
+				4, 0, je->is_pow2, N2S_BYTEPERSEC);
+
+		p += sprintf(p, ", %s-%s", mr, tr);
 		free(tr);
 		free(mr);
-	} else if (je->m_iops[0] || je->m_iops[1] || je->t_iops[0] || je->t_iops[1]) {
-		p += sprintf(p, ", CR=%d/%d IOPS",
-					je->t_iops[0] + je->t_iops[1],
-					je->m_iops[0] + je->m_iops[1]);
+	} else if (je->m_iops[0] || je->m_iops[1] || je->m_iops[2] ||
+		   je->t_iops[0] || je->t_iops[1] || je->t_iops[2]) {
+		p += sprintf(p, ", %d-%d IOPS",
+					je->m_iops[0] + je->m_iops[1] + je->m_iops[2],
+					je->t_iops[0] + je->t_iops[1] + je->t_iops[2]);
 	}
+
+	/* current run string, % done, bandwidth, iops, eta */
 	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char perc_str[32];
 		char *iops_str[DDIR_RWDIR_CNT];
@@ -553,7 +562,7 @@ void display_thread_status(struct jobs_eta *je)
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running ||
 		    je->eta_sec == -1)
-			strcpy(perc_str, "-.-% done");
+			strcpy(perc_str, "-.-%");
 		else {
 			double mult = 100.0;
 
@@ -562,22 +571,31 @@ void display_thread_status(struct jobs_eta *je)
 
 			eta_good = 1;
 			perc *= mult;
-			sprintf(perc_str, "%3.1f%% done", perc);
+			sprintf(perc_str, "%3.1f%%", perc);
 		}
 
 		for (ddir = DDIR_READ; ddir < DDIR_RWDIR_CNT; ddir++) {
-			rate_str[ddir] = num2str(je->rate[ddir], 5,
+			rate_str[ddir] = num2str(je->rate[ddir], 4,
 						1024, je->is_pow2, je->unit_base);
-			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, 0);
+			iops_str[ddir] = num2str(je->iops[ddir], 4, 1, 0, N2S_NONE);
 		}
 
 		left = sizeof(output) - (p - output) - 1;
 
-		l = snprintf(p, left, ": [%s] [%s] [%s/%s/%s /s] [%s/%s/%s iops] [eta %s]",
+		if (je->rate[DDIR_TRIM] || je->iops[DDIR_TRIM])
+			l = snprintf(p, left,
+				": [%s][%s][r=%s,w=%s,t=%s][r=%s,w=%s,t=%s IOPS][eta %s]",
 				je->run_str, perc_str, rate_str[DDIR_READ],
 				rate_str[DDIR_WRITE], rate_str[DDIR_TRIM],
 				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
 				iops_str[DDIR_TRIM], eta_str);
+		else
+			l = snprintf(p, left,
+				": [%s][%s][r=%s,w=%s][r=%s,w=%s IOPS][eta %s]",
+				je->run_str, perc_str,
+				rate_str[DDIR_READ], rate_str[DDIR_WRITE],
+				iops_str[DDIR_READ], iops_str[DDIR_WRITE],
+				eta_str);
 		p += l;
 		if (l >= 0 && l < linelen_last)
 			p += sprintf(p, "%*s", linelen_last - l, "");
diff --git a/filesetup.c b/filesetup.c
index 969e7cc..ef94bd2 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -948,9 +948,8 @@ int setup_files(struct thread_data *td)
 	if (need_extend) {
 		temp_stall_ts = 1;
 		if (output_format & FIO_OUTPUT_NORMAL)
-			log_info("%s: Laying out IO file(s) (%u file(s) /"
-				 " %lluMB)\n", o->name, need_extend,
-					extend_size >> 20);
+			log_info("%s: Laying out IO file(s) (%u file(s) / %lluMiB)\n",
+				 o->name, need_extend, extend_size >> 20);
 
 		for_each_file(td, f, i) {
 			unsigned long long old_len = -1ULL, extend_len = -1ULL;
diff --git a/fio.1 b/fio.1
index 6161760..f486276 100644
--- a/fio.1
+++ b/fio.1
@@ -1,4 +1,4 @@
-.TH fio 1 "December 2014" "User Manual"
+.TH fio 1 "December 2016" "User Manual"
 .SH NAME
 fio \- flexible I/O tester
 .SH SYNOPSIS
@@ -147,19 +147,77 @@ parentheses). The types used are:
 String: a sequence of alphanumeric characters.
 .TP
 .I int
-SI integer: a whole number, possibly containing a suffix denoting the base unit
-of the value.  Accepted suffixes are `k', 'M', 'G', 'T', and 'P', denoting
-kilo (1024), mega (1024^2), giga (1024^3), tera (1024^4), and peta (1024^5)
-respectively. If prefixed with '0x', the value is assumed to be base 16
-(hexadecimal). A suffix may include a trailing 'b', for instance 'kb' is
-identical to 'k'. You can specify a base 10 value by using 'KiB', 'MiB','GiB',
-etc. This is useful for disk drives where values are often given in base 10
-values. Specifying '30GiB' will get you 30*1000^3 bytes.
-When specifying times the default suffix meaning changes, still denoting the
-base unit of the value, but accepted suffixes are 'D' (days), 'H' (hours), 'M'
-(minutes), 'S' Seconds, 'ms' (or msec) milli seconds, 'us' (or 'usec') micro
-seconds. Time values without a unit specify seconds.
-The suffixes are not case sensitive.
+Integer. A whole number value, which may contain an integer prefix
+and an integer suffix.
+
+[integer prefix]number[integer suffix]
+
+The optional integer prefix specifies the number's base. The default
+is decimal. 0x specifies hexadecimal.
+
+The optional integer suffix specifies the number's units, and includes
+an optional unit prefix and an optional unit.  For quantities
+of data, the default unit is bytes. For quantities of time,
+the default unit is seconds.
+
+With \fBkb_base=1000\fR, fio follows international standards for unit prefixes.
+To specify power-of-10 decimal values defined in the International
+System of Units (SI):
+.nf
+ki means kilo (K) or 1000
+mi means mega (M) or 1000**2
+gi means giga (G) or 1000**3
+ti means tera (T) or 1000**4
+pi means peta (P) or 1000**5
+.fi
+
+To specify power-of-2 binary values defined in IEC 80000-13:
+.nf
+k means kibi (Ki) or 1024
+m means mebi (Mi) or 1024**2
+g means gibi (Gi) or 1024**3
+t means tebi (Ti) or 1024**4
+p means pebi (Pi) or 1024**5
+.fi
+
+With \fBkb_base=1024\fR (the default), the unit prefixes are opposite from
+those specified in the SI and IEC 80000-13 standards to provide
+compatibility with old scripts.  For example, 4k means 4096.
+
+.nf
+Examples with \fBkb_base=1000\fR:
+4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+1 MiB: 1048576, 1m, 1024k
+1 MB: 1000000, 1mi, 1000ki
+1 TiB: 1073741824, 1t, 1024m, 1048576k
+1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+.fi
+
+.nf
+Examples with \fBkb_base=1024\fR (default):
+4 KiB: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
+1 MiB: 1048576, 1m, 1024k
+1 MB: 1000000, 1mi, 1000ki
+1 TiB: 1073741824, 1t, 1024m, 1048576k
+1 TB: 1000000000, 1ti, 1000mi, 1000000ki
+.fi
+
+For quantities of data, an optional unit of 'B' may be included
+(e.g.,  'kb' is the same as 'k').
+
+The integer suffix is not case sensitive (e.g., m/mi mean mebi/mega,
+not milli). 'b' and 'B' both mean byte, not bit.
+
+To specify times (units are not case sensitive):
+.nf
+D means days
+H means hours
+M mean minutes
+s or sec means seconds (default)
+ms or msec means milliseconds
+us or usec means microseconds
+.fi
+
 .TP
 .I bool
 Boolean: a true or false value. `0' denotes false, `1' denotes true.
@@ -287,7 +345,7 @@ Sequential reads.
 Sequential writes.
 .TP
 .B trim
-Sequential trim (Linux block devices only).
+Sequential trims (Linux block devices only).
 .TP
 .B randread
 Random reads.
@@ -296,7 +354,7 @@ Random reads.
 Random writes.
 .TP
 .B randtrim
-Random trim (Linux block devices only).
+Random trims (Linux block devices only).
 .TP
 .B rw, readwrite
 Mixed sequential reads and writes.
@@ -305,8 +363,8 @@ Mixed sequential reads and writes.
 Mixed random reads and writes.
 .TP
 .B trimwrite
-Trim and write mixed workload. Blocks will be trimmed first, then the same
-blocks will be written to.
+Sequential trim and write mixed workload. Blocks will be trimmed first, then
+the same blocks will be written to.
 .RE
 .P
 Fio defaults to read if the option is not specified.
@@ -353,7 +411,7 @@ reasons. Allowed values are 1024 or 1000, with 1024 being the default.
 .TP
 .BI unified_rw_reporting \fR=\fPbool
 Fio normally reports statistics on a per data direction basis, meaning that
-read, write, and trim are accounted and reported separately. If this option is
+reads, writes, and trims are accounted and reported separately. If this option is
 set fio sums the results and reports them as "mixed" instead.
 .TP
 .BI randrepeat \fR=\fPbool
@@ -463,20 +521,32 @@ size of a file. If this option is set, then fio will append to the file
 instead. This has identical behavior to setting \fRoffset\fP to the size
 of a file. This option is ignored on non-regular files.
 .TP
-.BI blocksize \fR=\fPint[,int] "\fR,\fB bs" \fR=\fPint[,int]
-Block size for I/O units.  Default: 4k.  Values for reads, writes, and trims
-can be specified separately in the format \fIread\fR,\fIwrite\fR,\fItrim\fR
-either of which may be empty to leave that value at its default. If a trailing
-comma isn't given, the remainder will inherit the last value set.
-.TP
-.BI blocksize_range \fR=\fPirange[,irange] "\fR,\fB bsrange" \fR=\fPirange[,irange]
-Specify a range of I/O block sizes.  The issued I/O unit will always be a
-multiple of the minimum size, unless \fBblocksize_unaligned\fR is set.  Applies
-to both reads and writes if only one range is given, but can be specified
-separately with a comma separating the values. Example: bsrange=1k-4k,2k-8k.
-Also (see \fBblocksize\fR).
-.TP
-.BI bssplit \fR=\fPstr
+.BI blocksize \fR=\fPint[,int][,int] "\fR,\fB bs" \fR=\fPint[,int][,int]
+The block size in bytes for I/O units.  Default: 4096.
+A single value applies to reads, writes, and trims.
+Comma-separated values may be specified for reads, writes, and trims.
+Empty values separated by commas use the default value. A value not
+terminated in a comma applies to subsequent types.
+.nf
+Examples:
+bs=256k    means 256k for reads, writes and trims
+bs=8k,32k  means 8k for reads, 32k for writes and trims
+bs=8k,32k, means 8k for reads, 32k for writes, and default for trims
+bs=,8k     means default for reads, 8k for writes and trims
+bs=,8k,    means default for reads, 8k for writes, and default for writes
+.fi
+.TP
+.BI blocksize_range \fR=\fPirange[,irange][,irange] "\fR,\fB bsrange" \fR=\fPirange[,irange][,irange]
+A range of block sizes in bytes for I/O units.
+The issued I/O unit will always be a multiple of the minimum size, unless
+\fBblocksize_unaligned\fR is set.
+Comma-separated ranges may be specified for reads, writes, and trims
+as described in \fBblocksize\fR.
+.nf
+Example: bsrange=1k-4k,2k-8k.
+.fi
+.TP
+.BI bssplit \fR=\fPstr[,str][,str]
 This option allows even finer grained control of the block sizes issued,
 not just even splits between them. With this option, you can weight various
 block sizes for exact control of the issued IO for a job that has mixed
@@ -484,26 +554,28 @@ block sizes. The format of the option is bssplit=blocksize/percentage,
 optionally adding as many definitions as needed separated by a colon.
 Example: bssplit=4k/10:64k/50:32k/40 would issue 50% 64k blocks, 10% 4k
 blocks and 40% 32k blocks. \fBbssplit\fR also supports giving separate
-splits to reads and writes. The format is identical to what the
-\fBbs\fR option accepts, the read and write parts are separated with a
-comma.
+splits to reads, writes, and trims.
+Comma-separated values may be specified for reads, writes, and trims
+as described in \fBblocksize\fR.
 .TP
-.B blocksize_unaligned\fR,\fP bs_unaligned
-If set, any size in \fBblocksize_range\fR may be used.  This typically won't
+.B blocksize_unaligned\fR,\fB bs_unaligned
+If set, fio will issue I/O units with any size within \fBblocksize_range\fR,
+not just multiples of the minimum size.  This typically won't
 work with direct I/O, as that normally requires sector alignment.
 .TP
-.BI blockalign \fR=\fPint[,int] "\fR,\fB ba" \fR=\fPint[,int]
-At what boundary to align random IO offsets. Defaults to the same as 'blocksize'
-the minimum blocksize given.  Minimum alignment is typically 512b
-for using direct IO, though it usually depends on the hardware block size.
-This option is mutually exclusive with using a random map for files, so it
-will turn off that option.
-.TP
 .BI bs_is_seq_rand \fR=\fPbool
 If this option is set, fio will use the normal read,write blocksize settings as
-sequential,random instead. Any random read or write will use the WRITE
-blocksize settings, and any sequential read or write will use the READ
-blocksize setting.
+sequential,random blocksize settings instead. Any random read or write will
+use the WRITE blocksize settings, and any sequential read or write will use
+the READ blocksize settings.
+.TP
+.BI blockalign \fR=\fPint[,int][,int] "\fR,\fB ba" \fR=\fPint[,int][,int]
+Boundary to which fio will align random I/O units. Default: \fBblocksize\fR.
+Minimum alignment is typically 512b for using direct IO, though it usually
+depends on the hardware block size.  This option is mutually exclusive with
+using a random map for files, so it will turn off that option.
+Comma-separated values may be specified for reads, writes, and trims
+as described in \fBblocksize\fR.
 .TP
 .B zero_buffers
 Initialize buffers with all zeros. Default: fill buffers with random data.
@@ -735,7 +807,7 @@ properly.
 Read, write and erase an MTD character device (e.g., /dev/mtd0). Discards are
 treated as erases. Depending on the underlying device type, the I/O may have
 to go in a certain pattern, e.g., on NAND, writing sequentially to erase blocks
-and discarding before overwriting. The writetrim mode works well for this
+and discarding before overwriting. The trimwrite mode works well for this
 constraint.
 .TP
 .B pmemblk
@@ -963,7 +1035,7 @@ sizes. Like \fBbssplit\fR, it's possible to specify separate zones for reads,
 writes, and trims. If just one set is given, it'll apply to all of them.
 .RE
 .TP
-.BI percentage_random \fR=\fPint
+.BI percentage_random \fR=\fPint[,int][,int]
 For a random workload, set how big a percentage should be random. This defaults
 to 100%, in which case the workload is fully random. It can be set from
 anywhere from 0 to 100.  Setting it to 0 would make the workload fully
@@ -1032,28 +1104,29 @@ will be queued before we have to complete it and do our thinktime. In other
 words, this setting effectively caps the queue depth if the latter is larger.
 Default: 1.
 .TP
-.BI rate \fR=\fPint
+.BI rate \fR=\fPint[,int][,int]
 Cap bandwidth used by this job. The number is in bytes/sec, the normal postfix
 rules apply. You can use \fBrate\fR=500k to limit reads and writes to 500k each,
-or you can specify read and writes separately. Using \fBrate\fR=1m,500k would
-limit reads to 1MB/sec and writes to 500KB/sec. Capping only reads or writes
+or you can specify reads, write, and trim limits separately.
+Using \fBrate\fR=1m,500k would
+limit reads to 1MiB/sec and writes to 500KiB/sec. Capping only reads or writes
 can be done with \fBrate\fR=,500k or \fBrate\fR=500k,. The former will only
-limit writes (to 500KB/sec), the latter will only limit reads.
+limit writes (to 500KiB/sec), the latter will only limit reads.
 .TP
-.BI rate_min \fR=\fPint
+.BI rate_min \fR=\fPint[,int][,int]
 Tell \fBfio\fR to do whatever it can to maintain at least the given bandwidth.
 Failing to meet this requirement will cause the job to exit. The same format
-as \fBrate\fR is used for read vs write separation.
+as \fBrate\fR is used for read vs write vs trim separation.
 .TP
-.BI rate_iops \fR=\fPint
+.BI rate_iops \fR=\fPint[,int][,int]
 Cap the bandwidth to this number of IOPS. Basically the same as rate, just
 specified independently of bandwidth. The same format as \fBrate\fR is used for
-read vs write separation. If \fBblocksize\fR is a range, the smallest block
+read vs write vs trim separation. If \fBblocksize\fR is a range, the smallest block
 size is used as the metric.
 .TP
-.BI rate_iops_min \fR=\fPint
+.BI rate_iops_min \fR=\fPint[,int][,int]
 If this rate of I/O is not met, the job will exit. The same format as \fBrate\fR
-is used for read vs write separation.
+is used for read vs write vs trim separation.
 .TP
 .BI rate_process \fR=\fPstr
 This option controls how fio manages rated IO submissions. The default is
@@ -1257,7 +1330,7 @@ sum of the \fBiomem_align\fR and \fBbs\fR used.
 .TP
 .BI hugepage\-size \fR=\fPint
 Defines the size of a huge page.  Must be at least equal to the system setting.
-Should be a multiple of 1MB. Default: 4MB.
+Should be a multiple of 1MiB. Default: 4MiB.
 .TP
 .B exitall
 Terminate all jobs when one finishes.  Default: wait for each job to finish.
@@ -1891,7 +1964,7 @@ Preallocate donor's file on init
 .BI 1:
 allocate space immediately inside defragment event, and free right after event
 .RE
-.TP 
+.TP
 .BI (rbd)clustername \fR=\fPstr
 Specifies the name of the ceph cluster.
 .TP
@@ -1913,7 +1986,7 @@ While running, \fBfio\fR will display the status of the created jobs.  For
 example:
 .RS
 .P
-Threads: 1: [_r] [24.8% done] [ 13509/  8334 kb/s] [eta 00h:01m:31s]
+Jobs: 1: [_r] [24.8% done] [ 13509/  8334 kb/s] [eta 00h:01m:31s]
 .RE
 .P
 The characters in the first set of brackets denote the current status of each
@@ -2075,7 +2148,7 @@ change.  The fields are:
 .P
 Read status:
 .RS
-.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, IOPS, runtime \fR(ms)\fP
+.B Total I/O \fR(KiB)\fP, bandwidth \fR(KiB/s)\fP, IOPS, runtime \fR(ms)\fP
 .P
 Submission latency:
 .RS
@@ -2101,7 +2174,7 @@ Bandwidth:
 .P
 Write status:
 .RS
-.B Total I/O \fR(KB)\fP, bandwidth \fR(KB/s)\fP, IOPS, runtime \fR(ms)\fP
+.B Total I/O \fR(KiB)\fP, bandwidth \fR(KiB/s)\fP, IOPS, runtime \fR(ms)\fP
 .P
 Submission latency:
 .RS
@@ -2364,7 +2437,7 @@ on the type of log, it will be one of the following:
 Value is in latency in usecs
 .TP
 .B Bandwidth log
-Value is in KB/sec
+Value is in KiB/sec
 .TP
 .B IOPS log
 Value is in IOPS
diff --git a/fio.h b/fio.h
index df17074..62ff7ab 100644
--- a/fio.h
+++ b/fio.h
@@ -535,6 +535,13 @@ extern uintptr_t page_size;
 extern int initialize_fio(char *envp[]);
 extern void deinitialize_fio(void);
 
+#define N2S_NONE	0
+#define N2S_BITPERSEC 	1	/* match unit_base for bit rates */
+#define N2S_PERSEC	2
+#define N2S_BIT		3
+#define N2S_BYTE	4
+#define N2S_BYTEPERSEC 	8	/* match unit_base for byte rates */
+
 #define FIO_GETOPT_JOB		0x89000000
 #define FIO_GETOPT_IOENGINE	0x98000000
 #define FIO_NR_OPTIONS		(FIO_MAX_OPTS + 128)
diff --git a/gclient.c b/gclient.c
index 23b0899..5ce33d0 100644
--- a/gclient.c
+++ b/gclient.c
@@ -364,29 +364,11 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 	sprintf(tmp, "%u", je->files_open);
 	gtk_entry_set_text(GTK_ENTRY(ge->eta.files), tmp);
 
-#if 0
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
-	if (je->m_rate || je->t_rate) {
-		char *tr, *mr;
-
-		mr = num2str(je->m_rate, 4, 0, i2p);
-		tr = num2str(je->t_rate, 4, 0, i2p);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
-		free(tr);
-		free(mr);
-	} else if (je->m_iops || je->t_iops)
-		p += sprintf(p, ", CR=%d/%d IOPS", je->t_iops, je->m_iops);
-
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cr_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cr_iops), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cw_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ge->eta.cw_iops), "---");
-#endif
-
 	if (je->eta_sec != INT_MAX && je->nr_running) {
 		char *iops_str[DDIR_RWDIR_CNT];
 		char *rate_str[DDIR_RWDIR_CNT];
+		char *rate_alt[DDIR_RWDIR_CNT];
+		char tmp[128];
 		int i;
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
@@ -397,19 +379,26 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		rate_str[0] = num2str(je->rate[0], 5, 10, i2p, 0);
-		rate_str[1] = num2str(je->rate[1], 5, 10, i2p, 0);
-		rate_str[2] = num2str(je->rate[2], 5, 10, i2p, 0);
+		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
 
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, 0);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, 0);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, 0);
-
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), rate_str[0]);
+		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.read_iops), iops_str[0]);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), rate_str[1]);
+
+		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.write_iops), iops_str[1]);
-		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), rate_str[2]);
+
+		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
+		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ge->eta.trim_iops), iops_str[2]);
 
 		graph_add_xy_data(ge->graphs.iops_graph, ge->graphs.read_iops, je->elapsed_sec, je->iops[0], iops_str[0]);
@@ -421,6 +410,7 @@ static void gfio_update_client_eta(struct fio_client *client, struct jobs_eta *j
 
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			free(rate_str[i]);
+			free(rate_alt[i]);
 			free(iops_str[i]);
 		}
 	}
@@ -457,31 +447,13 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 		eta_to_str(eta_str, je->eta_sec);
 	}
 
-#if 0
-	if (je->m_rate[0] || je->m_rate[1] || je->t_rate[0] || je->t_rate[1]) {
-	if (je->m_rate || je->t_rate) {
-		char *tr, *mr;
-
-		mr = num2str(je->m_rate, 4, 0, i2p);
-		tr = num2str(je->t_rate, 4, 0, i2p);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta);
-		p += sprintf(p, ", CR=%s/%s KB/s", tr, mr);
-		free(tr);
-		free(mr);
-	} else if (je->m_iops || je->t_iops)
-		p += sprintf(p, ", CR=%d/%d IOPS", je->t_iops, je->m_iops);
-
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cr_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cr_iops), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cw_bw), "---");
-	gtk_entry_set_text(GTK_ENTRY(ui->eta.cw_iops), "---");
-#endif
-
 	entry_set_int_value(ui->eta.jobs, je->nr_running);
 
 	if (je->eta_sec != INT_MAX && je->nr_running) {
-		char *iops_str[3];
-		char *rate_str[3];
+		char *iops_str[DDIR_RWDIR_CNT];
+		char *rate_str[DDIR_RWDIR_CNT];
+		char *rate_alt[DDIR_RWDIR_CNT];
+		char tmp[128];
 
 		if ((!je->eta_sec && !eta_good) || je->nr_ramp == je->nr_running)
 			strcpy(output, "-.-% done");
@@ -491,19 +463,26 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 			sprintf(output, "%3.1f%% done", perc);
 		}
 
-		rate_str[0] = num2str(je->rate[0], 5, 10, i2p, 0);
-		rate_str[1] = num2str(je->rate[1], 5, 10, i2p, 0);
-		rate_str[2] = num2str(je->rate[2], 5, 10, i2p, 0);
+		iops_str[0] = num2str(je->iops[0], 4, 1, 0, N2S_PERSEC);
+		iops_str[1] = num2str(je->iops[1], 4, 1, 0, N2S_PERSEC);
+		iops_str[2] = num2str(je->iops[2], 4, 1, 0, N2S_PERSEC);
 
-		iops_str[0] = num2str(je->iops[0], 4, 1, 0, 0);
-		iops_str[1] = num2str(je->iops[1], 4, 1, 0, 0);
-		iops_str[2] = num2str(je->iops[2], 4, 1, 0, 0);
-
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), rate_str[0]);
+		rate_str[0] = num2str(je->rate[0], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[0] = num2str(je->rate[0], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[0], rate_alt[0]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.read_iops), iops_str[0]);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), rate_str[1]);
+
+		rate_str[1] = num2str(je->rate[1], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[1] = num2str(je->rate[1], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[1], rate_alt[1]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.write_iops), iops_str[1]);
-		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), rate_str[2]);
+
+		rate_str[2] = num2str(je->rate[2], 4, 10, i2p, N2S_BYTEPERSEC);
+		rate_alt[2] = num2str(je->rate[2], 4, 10, !i2p, N2S_BYTEPERSEC);
+		snprintf(tmp, sizeof(tmp), "%s (%s)", rate_str[2], rate_alt[2]);
+		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_bw), tmp);
 		gtk_entry_set_text(GTK_ENTRY(ui->eta.trim_iops), iops_str[2]);
 
 		graph_add_xy_data(ui->graphs.iops_graph, ui->graphs.read_iops, je->elapsed_sec, je->iops[0], iops_str[0]);
@@ -515,6 +494,7 @@ static void gfio_update_all_eta(struct jobs_eta *je)
 
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			free(rate_str[i]);
+			free(rate_alt[i]);
 			free(iops_str[i]);
 		}
 	}
@@ -592,6 +572,7 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	struct thread_options *o;
 	char *c1, *c2, *c3, *c4;
 	char tmp[80];
+	int i2p;
 
 	p->thread_number = le32_to_cpu(p->thread_number);
 	p->groupid = le32_to_cpu(p->groupid);
@@ -605,11 +586,13 @@ static void gfio_add_job_op(struct fio_client *client, struct fio_net_cmd *cmd)
 	sprintf(tmp, "%s %s", o->odirect ? "direct" : "buffered", ddir_str(o->td_ddir));
 	multitext_add_entry(&ge->eta.iotype, tmp);
 
-	c1 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-	c2 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
-	c3 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-	c4 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
-	sprintf(tmp, "%s-%s/%s-%s", c1, c2, c3, c4);
+	i2p = is_power_of_2(o->kb_base);
+	c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+	c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+	c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+	c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+
+	sprintf(tmp, "%s-%s,%s-%s", c1, c2, c3, c4);
 	free(c1);
 	free(c2);
 	free(c3);
@@ -948,10 +931,10 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 				      struct thread_stat *ts)
 {
 	double io_u_lat[FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR];
-	const char *ranges[] = { "2u", "4u", "10u", "20u", "50u", "100u",
-				 "250u", "500u", "750u", "1m", "2m",
-				 "4m", "10m", "20m", "50m", "100m",
-				 "250m", "500m", "750m", "1s", "2s", ">= 2s" };
+	const char *ranges[] = { "2us", "4us", "10us", "20us", "50us", "100us",
+				 "250us", "500us", "750us", "1ms", "2ms",
+				 "4ms", "10ms", "20ms", "50ms", "100ms",
+				 "250ms", "500ms", "750ms", "1s", "2s", ">= 2s" };
 	int start, end, i;
 	const int total = FIO_IO_U_LAT_U_NR + FIO_IO_U_LAT_M_NR;
 	GtkWidget *frame, *tree_view, *hbox, *completion_vbox, *drawing_area;
@@ -980,7 +963,7 @@ static void gfio_show_latency_buckets(struct gfio_client *gc, GtkWidget *vbox,
 		return;
 
 	tree_view = gfio_output_lat_buckets(&io_u_lat[start], &ranges[start], end - start + 1);
-	ge->lat_bucket_graph = setup_lat_bucket_graph("Latency Buckets", &io_u_lat[start], &ranges[start], end - start + 1, 700.0, 300.0);
+	ge->lat_bucket_graph = setup_lat_bucket_graph("Latency buckets", &io_u_lat[start], &ranges[start], end - start + 1, 700.0, 300.0);
 
 	frame = gtk_frame_new("Latency buckets");
 	gtk_box_pack_start(GTK_BOX(vbox), frame, FALSE, FALSE, 5);
@@ -1011,8 +994,8 @@ static void gfio_show_lat(GtkWidget *vbox, const char *name, unsigned long min,
 	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
-	minp = num2str(min, 6, 1, 0, 0);
-	maxp = num2str(max, 6, 1, 0, 0);
+	minp = num2str(min, 6, 1, 0, N2S_NONE);
+	maxp = num2str(max, 6, 1, 0, N2S_NONE);
 
 	sprintf(tmp, "%s %s", name, base);
 	frame = gtk_frame_new(tmp);
@@ -1173,7 +1156,8 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	unsigned long long bw, iops;
 	unsigned int flags = 0;
 	double mean[3], dev[3];
-	char *io_p, *bw_p, *iops_p;
+	char *io_p, *io_palt, *bw_p, *bw_palt, *iops_p;
+	char tmp[128];
 	int i2p;
 
 	if (!ts->runtime[ddir])
@@ -1183,11 +1167,9 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	runt = ts->runtime[ddir];
 
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
-	io_p = num2str(ts->io_bytes[ddir], 6, 1, i2p, 8);
-	bw_p = num2str(bw, 6, 1, i2p, ts->unit_base);
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 6, 1, 0, 0);
+	iops_p = num2str(iops, 4, 1, 0, N2S_PERSEC);
 
 	box = gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(mbox), box, TRUE, FALSE, 3);
@@ -1202,9 +1184,17 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 	gtk_box_pack_start(GTK_BOX(main_vbox), box, TRUE, FALSE, 3);
 
 	label = new_info_label_in_frame(box, "IO");
-	gtk_label_set_text(GTK_LABEL(label), io_p);
+	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
+	io_palt = num2str(ts->io_bytes[ddir], 4, 1, !i2p, N2S_BYTE);
+	snprintf(tmp, sizeof(tmp), "%s (%s)", io_p, io_palt);
+	gtk_label_set_text(GTK_LABEL(label), tmp);
+
 	label = new_info_label_in_frame(box, "Bandwidth");
-	gtk_label_set_text(GTK_LABEL(label), bw_p);
+	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
+	bw_palt = num2str(bw, 4, 1, !i2p, ts->unit_base);
+	snprintf(tmp, sizeof(tmp), "%s (%s)", bw_p, bw_palt);
+	gtk_label_set_text(GTK_LABEL(label), tmp);
+
 	label = new_info_label_in_frame(box, "IOPS");
 	gtk_label_set_text(GTK_LABEL(label), iops_p);
 	label = new_info_label_in_frame(box, "Runtime (msec)");
@@ -1212,7 +1202,7 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 
 	if (calc_lat(&ts->bw_stat[ddir], &min[0], &max[0], &mean[0], &dev[0])) {
 		double p_of_agg = 100.0;
-		const char *bw_str = "KB";
+		const char *bw_str = "KiB/s";
 		char tmp[32];
 
 		if (rs->agg[ddir]) {
@@ -1221,14 +1211,21 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 				p_of_agg = 100.0;
 		}
 
-		if (mean[0] > 999999.9) {
-			min[0] /= 1000.0;
-			max[0] /= 1000.0;
-			mean[0] /= 1000.0;
-			dev[0] /= 1000.0;
-			bw_str = "MB";
+		if (mean[0] > 1073741824.9) {
+			min[0] /= 1048576.0;
+			max[0] /= 1048576.0;
+			mean[0] /= 1048576.0;
+			dev[0] /= 1048576.0;
+			bw_str = "GiB/s";
 		}
 
+		if (mean[0] > 1047575.9) {
+			min[0] /= 1024.0;
+			max[0] /= 1024.0;
+			mean[0] /= 1024.0;
+			dev[0] /= 1024.0;
+			bw_str = "MiB/s";
+		}
 		sprintf(tmp, "Bandwidth (%s)", bw_str);
 		frame = gtk_frame_new(tmp);
 		gtk_box_pack_start(GTK_BOX(main_vbox), frame, FALSE, FALSE, 5);
@@ -1278,6 +1275,8 @@ static void gfio_show_ddir_status(struct gfio_client *gc, GtkWidget *mbox,
 
 	free(io_p);
 	free(bw_p);
+	free(io_palt);
+	free(bw_palt);
 	free(iops_p);
 }
 
diff --git a/gfio.c b/gfio.c
index ce18091..9ccf78c 100644
--- a/gfio.c
+++ b/gfio.c
@@ -1215,7 +1215,7 @@ static void about_dialog(GtkWidget *w, gpointer data)
 {
 	const char *authors[] = {
 		"Jens Axboe <axboe@kernel.dk>",
-		"Stephen Carmeron <stephenmcameron@gmail.com>",
+		"Stephen Cameron <stephenmcameron@gmail.com>",
 		NULL
 	};
 	const char *license[] = {
@@ -1386,7 +1386,7 @@ static GtkWidget *new_client_page(struct gui_entry *ge)
 	g_signal_connect(ge->eta.names, "changed", G_CALLBACK(combo_entry_changed), ge);
 	g_signal_connect(ge->eta.names, "destroy", G_CALLBACK(combo_entry_destroy), ge);
 	ge->eta.iotype.entry = new_info_entry_in_frame(probe_box, "IO");
-	ge->eta.bs.entry = new_info_entry_in_frame(probe_box, "Blocksize (Read/Write)");
+	ge->eta.bs.entry = new_info_entry_in_frame(probe_box, "Blocksize (Read/Write/Trim)");
 	ge->eta.ioengine.entry = new_info_entry_in_frame(probe_box, "IO Engine");
 	ge->eta.iodepth.entry = new_info_entry_in_frame(probe_box, "IO Depth");
 	ge->eta.jobs = new_info_entry_in_frame(probe_box, "Jobs");
@@ -1395,11 +1395,11 @@ static GtkWidget *new_client_page(struct gui_entry *ge)
 	probe_box = gtk_hbox_new(FALSE, 3);
 	gtk_box_pack_start(GTK_BOX(probe_frame), probe_box, FALSE, FALSE, 3);
 	ge->eta.read_bw = new_info_entry_in_frame_rgb(probe_box, "Read BW", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
-	ge->eta.read_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
+	ge->eta.read_iops = new_info_entry_in_frame_rgb(probe_box, "Read IOPS", GFIO_READ_R, GFIO_READ_G, GFIO_READ_B);
 	ge->eta.write_bw = new_info_entry_in_frame_rgb(probe_box, "Write BW", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
-	ge->eta.write_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
+	ge->eta.write_iops = new_info_entry_in_frame_rgb(probe_box, "Write IOPS", GFIO_WRITE_R, GFIO_WRITE_G, GFIO_WRITE_B);
 	ge->eta.trim_bw = new_info_entry_in_frame_rgb(probe_box, "Trim BW", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
-	ge->eta.trim_iops = new_info_entry_in_frame_rgb(probe_box, "IOPS", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
+	ge->eta.trim_iops = new_info_entry_in_frame_rgb(probe_box, "Trim IOPS", GFIO_TRIM_R, GFIO_TRIM_G, GFIO_TRIM_B);
 
 	/*
 	 * Only add this if we have a commit rate
diff --git a/goptions.c b/goptions.c
index b3d3684..16938ed 100644
--- a/goptions.c
+++ b/goptions.c
@@ -826,7 +826,7 @@ static struct gopt *gopt_new_str_val(struct gopt_job_view *gjv,
 				     unsigned long long *p, unsigned int idx)
 {
 	struct gopt_str_val *g;
-	const gchar *postfix[] = { "B", "KB", "MB", "GB", "PB", "TB", "" };
+	const gchar *postfix[] = { "B", "KiB", "MiB", "GiB", "PiB", "PiB", "" };
 	GtkWidget *label;
 	int i;
 
diff --git a/init.c b/init.c
index f26f35d..3c925a3 100644
--- a/init.c
+++ b/init.c
@@ -31,6 +31,7 @@
 #include "oslib/strcasestr.h"
 
 #include "crc/test.h"
+#include "lib/pow2.h"
 
 const char fio_version_string[] = FIO_VERSION;
 
@@ -865,27 +866,6 @@ static int fixup_options(struct thread_data *td)
 	return ret;
 }
 
-/*
- * This function leaks the buffer
- */
-char *fio_uint_to_kmg(unsigned int val)
-{
-	char *buf = malloc(32);
-	char post[] = { 0, 'K', 'M', 'G', 'P', 'E', 0 };
-	char *p = post;
-
-	do {
-		if (val & 1023)
-			break;
-
-		val >>= 10;
-		p++;
-	} while (*p);
-
-	snprintf(buf, 32, "%u%c", val, *p);
-	return buf;
-}
-
 /* External engines are specified by "external:name.o") */
 static const char *get_engine_name(const char *str)
 {
@@ -1528,15 +1508,16 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 			if (!td_ioengine_flagged(td, FIO_NOIO)) {
 				char *c1, *c2, *c3, *c4;
 				char *c5 = NULL, *c6 = NULL;
+				int i2p = is_power_of_2(o->kb_base);
 
-				c1 = fio_uint_to_kmg(o->min_bs[DDIR_READ]);
-				c2 = fio_uint_to_kmg(o->max_bs[DDIR_READ]);
-				c3 = fio_uint_to_kmg(o->min_bs[DDIR_WRITE]);
-				c4 = fio_uint_to_kmg(o->max_bs[DDIR_WRITE]);
+				c1 = num2str(o->min_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+				c2 = num2str(o->max_bs[DDIR_READ], 4, 1, i2p, N2S_BYTE);
+				c3 = num2str(o->min_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
+				c4 = num2str(o->max_bs[DDIR_WRITE], 4, 1, i2p, N2S_BYTE);
 
 				if (!o->bs_is_seq_rand) {
-					c5 = fio_uint_to_kmg(o->min_bs[DDIR_TRIM]);
-					c6 = fio_uint_to_kmg(o->max_bs[DDIR_TRIM]);
+					c5 = num2str(o->min_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
+					c6 = num2str(o->max_bs[DDIR_TRIM], 4, 1, i2p, N2S_BYTE);
 				}
 
 				log_info("%s: (g=%d): rw=%s, ", td->o.name,
@@ -1544,10 +1525,10 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 							ddir_str(o->td_ddir));
 
 				if (o->bs_is_seq_rand)
-					log_info("bs(seq/rand)=%s-%s/%s-%s, ",
+					log_info("bs=%s-%s,%s-%s, bs_is_seq_rand, ",
 							c1, c2, c3, c4);
 				else
-					log_info("bs=%s-%s/%s-%s/%s-%s, ",
+					log_info("bs=%s-%s,%s-%s,%s-%s, ",
 							c1, c2, c3, c4, c5, c6);
 
 				log_info("ioengine=%s, iodepth=%u\n",
diff --git a/lib/num2str.c b/lib/num2str.c
index 0ed05f3..940d4a5 100644
--- a/lib/num2str.c
+++ b/lib/num2str.c
@@ -6,36 +6,63 @@
 
 #define ARRAY_LENGTH(arr)	sizeof(arr) / sizeof((arr)[0])
 
-/*
- * Cheesy number->string conversion, complete with carry rounding error.
+/**
+ * num2str() - Cheesy number->string conversion, complete with carry rounding error.
+ * @num: quantity (e.g., number of blocks, bytes or bits)
+ * @maxlen: max number of digits in the output string (not counting prefix and units)
+ * @base: multiplier for num (e.g., if num represents Ki, use 1024)
+ * @pow2: select unit prefix - 0=power-of-10 decimal SI, nonzero=power-of-2 binary IEC
+ * @units: select units - N2S_* macros defined in fio.h
+ * @returns a malloc'd buffer containing "number[<unit prefix>][<units>]"
  */
-char *num2str(uint64_t num, int maxlen, int base, int pow2, int unit_base)
+char *num2str(uint64_t num, int maxlen, int base, int pow2, int units)
 {
-	const char *postfix[] = { "", "K", "M", "G", "P", "E" };
-	const char *byte_postfix[] = { "", "B", "bit" };
+	const char *sistr[] = { "", "k", "M", "G", "T", "P" };
+	const char *iecstr[] = { "", "Ki", "Mi", "Gi", "Ti", "Pi" };
+	const char **unitprefix;
+	const char *unitstr[] = { "", "/s", "B", "bit", "B/s", "bit/s" };
 	const unsigned int thousand[] = { 1000, 1024 };
 	unsigned int modulo, decimals;
-	int byte_post_index = 0, post_index, carry = 0;
+	int unit_index = 0, post_index, carry = 0;
 	char tmp[32];
 	char *buf;
 
+	compiletime_assert(sizeof(sistr) == sizeof(iecstr), "unit prefix arrays must be identical sizes");
+
 	buf = malloc(128);
+	if (!buf)
+		return NULL;
+
+	if (pow2)
+		unitprefix = iecstr;
+	else
+		unitprefix = sistr;
 
 	for (post_index = 0; base > 1; post_index++)
 		base /= thousand[!!pow2];
 
-	switch (unit_base) {
-	case 1:
-		byte_post_index = 2;
+	switch (units) {
+	case N2S_PERSEC:
+		unit_index = 1;
+		break;
+	case N2S_BYTE:
+		unit_index = 2;
+		break;
+	case N2S_BIT:
+		unit_index = 3;
 		num *= 8;
 		break;
-	case 8:
-		byte_post_index = 1;
+	case N2S_BYTEPERSEC:
+		unit_index = 4;
+		break;
+	case N2S_BITPERSEC:
+		unit_index = 5;
+		num *= 8;
 		break;
 	}
 
 	modulo = -1U;
-	while (post_index < sizeof(postfix)) {
+	while (post_index < sizeof(sistr)) {
 		sprintf(tmp, "%llu", (unsigned long long) num);
 		if (strlen(tmp) <= maxlen)
 			break;
@@ -48,11 +75,11 @@ char *num2str(uint64_t num, int maxlen, int base, int pow2, int unit_base)
 
 	if (modulo == -1U) {
 done:
-		if (post_index >= ARRAY_LENGTH(postfix))
+		if (post_index >= ARRAY_LENGTH(sistr))
 			post_index = 0;
 
 		sprintf(buf, "%llu%s%s", (unsigned long long) num,
-			postfix[post_index], byte_postfix[byte_post_index]);
+			unitprefix[post_index], unitstr[unit_index]);
 		return buf;
 	}
 
@@ -73,6 +100,6 @@ done:
 	} while (1);
 
 	sprintf(buf, "%llu.%u%s%s", (unsigned long long) num, modulo,
-			postfix[post_index], byte_postfix[byte_post_index]);
+			unitprefix[post_index], unitstr[unit_index]);
 	return buf;
 }
diff --git a/memory.c b/memory.c
index 9124117..9e73f10 100644
--- a/memory.c
+++ b/memory.c
@@ -33,13 +33,13 @@ int fio_pin_memory(struct thread_data *td)
 	dprint(FD_MEM, "pinning %llu bytes\n", td->o.lockmem);
 
 	/*
-	 * Don't allow mlock of more than real_mem-128MB
+	 * Don't allow mlock of more than real_mem-128MiB
 	 */
 	phys_mem = os_phys_mem();
 	if (phys_mem) {
 		if ((td->o.lockmem + 128 * 1024 * 1024) > phys_mem) {
 			td->o.lockmem = phys_mem - 128 * 1024 * 1024;
-			log_info("fio: limiting mlocked memory to %lluMB\n",
+			log_info("fio: limiting mlocked memory to %lluMiB\n",
 							td->o.lockmem >> 20);
 		}
 	}
diff --git a/options.c b/options.c
index d8b4012..0f2adcd 100644
--- a/options.c
+++ b/options.c
@@ -1965,7 +1965,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off3	= offsetof(struct thread_options, bs[DDIR_TRIM]),
 		.minval = 1,
 		.help	= "Block size unit",
-		.def	= "4k",
+		.def	= "4096",
 		.parent = "rw",
 		.hide	= 1,
 		.interval = 512,
@@ -2885,7 +2885,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= offsetof(struct thread_options, trim_percentage),
 		.minval = 0,
 		.maxval = 100,
-		.help	= "Number of verify blocks to discard/trim",
+		.help	= "Number of verify blocks to trim (i.e., discard)",
 		.parent	= "verify",
 		.def	= "0",
 		.interval = 1,
@@ -2897,7 +2897,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "trim_verify_zero",
 		.lname	= "Verify trim zero",
 		.type	= FIO_OPT_BOOL,
-		.help	= "Verify that trim/discarded blocks are returned as zeroes",
+		.help	= "Verify that trimmed (i.e., discarded) blocks are returned as zeroes",
 		.off1	= offsetof(struct thread_options, trim_zero),
 		.parent	= "trim_percentage",
 		.hide	= 1,
@@ -4180,20 +4180,20 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.posval = {
 			  { .ival = "1024",
 			    .oval = 1024,
-			    .help = "Use 1024 as the K base",
+			    .help = "Inputs invert IEC and SI prefixes (for compatibility); outputs prefer binary",
 			  },
 			  { .ival = "1000",
 			    .oval = 1000,
-			    .help = "Use 1000 as the K base",
+			    .help = "Inputs use IEC and SI prefixes; outputs prefer SI",
 			  },
 		},
-		.help	= "How many bytes per KB for reporting (1000 or 1024)",
+		.help	= "Unit prefix interpretation for quantities of data (IEC and SI)",
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
 		.name	= "unit_base",
-		.lname	= "Base unit for reporting (Bits or Bytes)",
+		.lname	= "Unit for quantities of data (Bits or Bytes)",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct thread_options, unit_base),
 		.prio	= 1,
diff --git a/parse.c b/parse.c
index 8ed4619..518c2df 100644
--- a/parse.c
+++ b/parse.c
@@ -207,32 +207,50 @@ static unsigned long long __get_mult_bytes(const char *p, void *data,
 		}
 	}
 
+	/* If kb_base is 1000, use true units.
+	 * If kb_base is 1024, use opposite units.
+	 */
 	if (!strncmp("pib", c, 3)) {
 		pow = 5;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
+		else if (kb_base == 1024)
+			mult = 1000;
 	} else if (!strncmp("tib", c, 3)) {
 		pow = 4;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
+		else if (kb_base == 1024)
+			mult = 1000;
 	} else if (!strncmp("gib", c, 3)) {
 		pow = 3;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
+		else if (kb_base == 1024)
+			mult = 1000;
 	} else if (!strncmp("mib", c, 3)) {
 		pow = 2;
-		mult = 1000;
+		if (kb_base == 1000)
+			mult = 1024;
+		else if (kb_base == 1024)
+			mult = 1000;
 	} else if (!strncmp("kib", c, 3)) {
 		pow = 1;
-		mult = 1000;
-	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2))
+		if (kb_base == 1000)
+			mult = 1024;
+		else if (kb_base == 1024)
+			mult = 1000;
+	} else if (!strncmp("p", c, 1) || !strncmp("pb", c, 2)) {
 		pow = 5;
-	else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2))
+	} else if (!strncmp("t", c, 1) || !strncmp("tb", c, 2)) {
 		pow = 4;
-	else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2))
+	} else if (!strncmp("g", c, 1) || !strncmp("gb", c, 2)) {
 		pow = 3;
-	else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2))
+	} else if (!strncmp("m", c, 1) || !strncmp("mb", c, 2)) {
 		pow = 2;
-	else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2))
+	} else if (!strncmp("k", c, 1) || !strncmp("kb", c, 2)) {
 		pow = 1;
-	else if (!strncmp("%", c, 1)) {
+	} else if (!strncmp("%", c, 1)) {
 		*percent = 1;
 		free(c);
 		return ret;
diff --git a/profiles/act.c b/profiles/act.c
index 3e9238b..643f8a8 100644
--- a/profiles/act.c
+++ b/profiles/act.c
@@ -130,21 +130,21 @@ static struct fio_option options[] = {
 	},
 	{
 		.name	= "read-req-num-512-blocks",
-		.lname	= "Number of 512b blocks to read",
+		.lname	= "Number of 512B blocks to read",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct act_options, num_read_blocks),
-		.help	= "Number of 512b blocks to read at the time",
+		.help	= "Number of 512B blocks to read at the time",
 		.def	= "3",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
 	},
 	{
 		.name	= "large-block-op-kbytes",
-		.lname	= "Size of large block ops (writes)",
+		.lname	= "Size of large block ops in KiB (writes)",
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct act_options, write_size),
-		.help	= "Size of large block ops (writes)",
-		.def	= "128k",
+		.help	= "Size of large block ops in KiB (writes)",
+		.def	= "131072",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_ACT,
 	},
@@ -220,7 +220,7 @@ static int act_add_dev_prep(const char *dev)
 		return 1;
 	if (act_add_opt("filename=%s", dev))
 		return 1;
-	if (act_add_opt("bs=1M"))
+	if (act_add_opt("bs=1048576"))
 		return 1;
 	if (act_add_opt("zero_buffers"))
 		return 1;
@@ -234,7 +234,7 @@ static int act_add_dev_prep(const char *dev)
 		return 1;
 	if (act_add_opt("filename=%s", dev))
 		return 1;
-	if (act_add_opt("bs=4k"))
+	if (act_add_opt("bs=4096"))
 		return 1;
 	if (act_add_opt("ioengine=libaio"))
 		return 1;
diff --git a/profiles/tiobench.c b/profiles/tiobench.c
index 8af6f4e..9d9885a 100644
--- a/profiles/tiobench.c
+++ b/profiles/tiobench.c
@@ -39,7 +39,7 @@ static struct fio_option options[] = {
 		.lname	= "Tiobench size",
 		.type	= FIO_OPT_STR_VAL,
 		.off1	= offsetof(struct tiobench_options, size),
-		.help	= "Size in MB",
+		.help	= "Size in MiB",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
 	},
@@ -49,7 +49,7 @@ static struct fio_option options[] = {
 		.type	= FIO_OPT_INT,
 		.off1	= offsetof(struct tiobench_options, bs),
 		.help	= "Block size in bytes",
-		.def	= "4k",
+		.def	= "4096",
 		.category = FIO_OPT_C_PROFILE,
 		.group	= FIO_OPT_G_TIOBENCH,
 	},
@@ -91,7 +91,7 @@ static struct fio_option options[] = {
 static int tb_prep_cmdline(void)
 {
 	/*
-	 * tiobench uses size as MB, so multiply up
+	 * tiobench uses size as MiB, so multiply up
 	 */
 	size *= 1024 * 1024ULL;
 	if (size)
diff --git a/server.c b/server.c
index 2e05415..b7ebd63 100644
--- a/server.c
+++ b/server.c
@@ -1444,7 +1444,7 @@ static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
 		dst->min_run[i]		= cpu_to_le64(src->min_run[i]);
 		dst->max_bw[i]		= cpu_to_le64(src->max_bw[i]);
 		dst->min_bw[i]		= cpu_to_le64(src->min_bw[i]);
-		dst->io_kb[i]		= cpu_to_le64(src->io_kb[i]);
+		dst->iobytes[i]		= cpu_to_le64(src->iobytes[i]);
 		dst->agg[i]		= cpu_to_le64(src->agg[i]);
 	}
 
diff --git a/stat.c b/stat.c
index 3e57e54..f1d468c 100644
--- a/stat.c
+++ b/stat.c
@@ -279,7 +279,8 @@ bool calc_lat(struct io_stat *is, unsigned long *min, unsigned long *max,
 
 void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 {
-	char *p1, *p2, *p3, *p4;
+	char *io, *agg, *min, *max;
+	char *ioalt, *aggalt, *minalt, *maxalt;
 	const char *str[] = { "   READ", "  WRITE" , "   TRIM"};
 	int i;
 
@@ -291,22 +292,28 @@ void show_group_stats(struct group_run_stats *rs, struct buf_output *out)
 		if (!rs->max_run[i])
 			continue;
 
-		p1 = num2str(rs->io_kb[i], 6, rs->kb_base, i2p, 8);
-		p2 = num2str(rs->agg[i], 6, rs->kb_base, i2p, rs->unit_base);
-		p3 = num2str(rs->min_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
-		p4 = num2str(rs->max_bw[i], 6, rs->kb_base, i2p, rs->unit_base);
-
-		log_buf(out, "%s: io=%s, aggrb=%s/s, minb=%s/s, maxb=%s/s,"
-			 " mint=%llumsec, maxt=%llumsec\n",
+		io = num2str(rs->iobytes[i], 4, 1, i2p, N2S_BYTE);
+		ioalt = num2str(rs->iobytes[i], 4, 1, !i2p, N2S_BYTE);
+		agg = num2str(rs->agg[i], 4, 1, i2p, rs->unit_base);
+		aggalt = num2str(rs->agg[i], 4, 1, !i2p, rs->unit_base);
+		min = num2str(rs->min_bw[i], 4, 1, i2p, rs->unit_base);
+		minalt = num2str(rs->min_bw[i], 4, 1, !i2p, rs->unit_base);
+		max = num2str(rs->max_bw[i], 4, 1, i2p, rs->unit_base);
+		maxalt = num2str(rs->max_bw[i], 4, 1, !i2p, rs->unit_base);
+		log_buf(out, "%s: bw=%s (%s), %s-%s (%s-%s), io=%s (%s), run=%llu-%llumsec\n",
 				rs->unified_rw_rep ? "  MIXED" : str[i],
-				p1, p2, p3, p4,
+				agg, aggalt, min, max, minalt, maxalt, io, ioalt,
 				(unsigned long long) rs->min_run[i],
 				(unsigned long long) rs->max_run[i]);
 
-		free(p1);
-		free(p2);
-		free(p3);
-		free(p4);
+		free(io);
+		free(agg);
+		free(min);
+		free(max);
+		free(ioalt);
+		free(aggalt);
+		free(minalt);
+		free(maxalt);
 	}
 }
 
@@ -367,8 +374,8 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 	if (usec_to_msec(&min, &max, &mean, &dev))
 		base = "(msec)";
 
-	minp = num2str(min, 6, 1, 0, 0);
-	maxp = num2str(max, 6, 1, 0, 0);
+	minp = num2str(min, 6, 1, 0, N2S_NONE);
+	maxp = num2str(max, 6, 1, 0, N2S_NONE);
 
 	log_buf(out, "    %s %s: min=%s, max=%s, avg=%5.02f,"
 		 " stdev=%5.02f\n", name, base, minp, maxp, mean, dev);
@@ -380,11 +387,11 @@ static void display_lat(const char *name, unsigned long min, unsigned long max,
 static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			     int ddir, struct buf_output *out)
 {
-	const char *str[] = { "read ", "write", "trim" };
+	const char *str[] = { " read", "write", " trim" };
 	unsigned long min, max, runt;
 	unsigned long long bw, iops;
 	double mean, dev;
-	char *io_p, *bw_p, *iops_p;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p;
 	int i2p;
 
 	assert(ddir_rw(ddir));
@@ -396,19 +403,21 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	runt = ts->runtime[ddir];
 
 	bw = (1000 * ts->io_bytes[ddir]) / runt;
-	io_p = num2str(ts->io_bytes[ddir], 6, 1, i2p, 8);
-	bw_p = num2str(bw, 6, 1, i2p, ts->unit_base);
+	io_p = num2str(ts->io_bytes[ddir], 4, 1, i2p, N2S_BYTE);
+	bw_p = num2str(bw, 4, 1, i2p, ts->unit_base);
+	bw_p_alt = num2str(bw, 4, 1, !i2p, ts->unit_base);
 
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
-	iops_p = num2str(iops, 6, 1, 0, 0);
+	iops_p = num2str(iops, 4, 1, 0, N2S_NONE);
 
-	log_buf(out, "  %s: io=%s, bw=%s/s, iops=%s, runt=%6llumsec\n",
-				rs->unified_rw_rep ? "mixed" : str[ddir],
-				io_p, bw_p, iops_p,
-				(unsigned long long) ts->runtime[ddir]);
+	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)\n",
+			rs->unified_rw_rep ? "mixed" : str[ddir],
+			iops_p, bw_p, bw_p_alt, io_p,
+			(unsigned long long) ts->runtime[ddir]);
 
 	free(io_p);
 	free(bw_p);
+	free(bw_p_alt);
 	free(iops_p);
 
 	if (calc_lat(&ts->slat_stat[ddir], &min, &max, &mean, &dev))
@@ -426,7 +435,16 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	}
 	if (calc_lat(&ts->bw_stat[ddir], &min, &max, &mean, &dev)) {
 		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
-		const char *bw_str = (rs->unit_base == 1 ? "Kbit" : "KB");
+		const char *bw_str;
+
+		if ((rs->unit_base == 1) && i2p)
+			bw_str = "Kibit";
+		else if (rs->unit_base == 1)
+			bw_str = "kbit";
+		else if (i2p)
+			bw_str = "KiB";
+		else
+			bw_str = "kB";
 
 		if (rs->unit_base == 1) {
 			min *= 8.0;
@@ -446,12 +464,11 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 			max /= fkb_base;
 			mean /= fkb_base;
 			dev /= fkb_base;
-			bw_str = (rs->unit_base == 1 ? "Mbit" : "MB");
+			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
 		}
 
-		log_buf(out, "    bw (%-4s/s): min=%5lu, max=%5lu, per=%3.2f%%,"
-			 " avg=%5.02f, stdev=%5.02f\n", bw_str, min, max,
-							p_of_agg, mean, dev);
+		log_buf(out, "   bw (%5s/s): min=%5lu, max=%5lu, per=%3.2f%%, avg=%5.02f, stdev=%5.02f\n",
+			bw_str, min, max, p_of_agg, mean, dev);
 	}
 }
 
@@ -659,7 +676,7 @@ static void show_block_infos(int nr_block_infos, uint32_t *block_infos,
 
 static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 {
-	char *p1, *p2;
+	char *p1, *p1alt, *p2;
 	unsigned long long bw_mean, iops_mean;
 	const int i2p = is_power_of_2(ts->kb_base);
 
@@ -669,18 +686,20 @@ static void show_ss_normal(struct thread_stat *ts, struct buf_output *out)
 	bw_mean = steadystate_bw_mean(ts);
 	iops_mean = steadystate_iops_mean(ts);
 
-	p1 = num2str(bw_mean / ts->kb_base, 6, ts->kb_base, i2p, ts->unit_base);
-	p2 = num2str(iops_mean, 6, 1, 0, 0);
+	p1 = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, i2p, ts->unit_base);
+	p1alt = num2str(bw_mean / ts->kb_base, 4, ts->kb_base, !i2p, ts->unit_base);
+	p2 = num2str(iops_mean, 4, 1, 0, N2S_NONE);
 
-	log_buf(out, "  steadystate  : attained=%s, bw=%s/s, iops=%s, %s%s=%.3f%s\n",
+	log_buf(out, "  steadystate  : attained=%s, bw=%s (%s), iops=%s, %s%s=%.3f%s\n",
 		ts->ss_state & __FIO_SS_ATTAINED ? "yes" : "no",
-		p1, p2,
+		p1, p1alt, p2,
 		ts->ss_state & __FIO_SS_IOPS ? "iops" : "bw",
 		ts->ss_state & __FIO_SS_SLOPE ? " slope": " mean dev",
 		ts->ss_criterion.u.f,
 		ts->ss_state & __FIO_SS_PCT ? "%" : "");
 
 	free(p1);
+	free(p1alt);
 	free(p2);
 }
 
@@ -761,9 +780,9 @@ static void show_thread_status_normal(struct thread_stat *ts,
 					io_u_dist[1], io_u_dist[2],
 					io_u_dist[3], io_u_dist[4],
 					io_u_dist[5], io_u_dist[6]);
-	log_buf(out, "     issued    : total=r=%llu/w=%llu/d=%llu,"
-				 " short=r=%llu/w=%llu/d=%llu,"
-				 " drop=r=%llu/w=%llu/d=%llu\n",
+	log_buf(out, "     issued rwt: total=%llu,%llu,%llu,"
+				 " short=%llu,%llu,%llu,"
+				 " dropped=%llu,%llu,%llu\n",
 					(unsigned long long) ts->total_io_u[0],
 					(unsigned long long) ts->total_io_u[1],
 					(unsigned long long) ts->total_io_u[2],
@@ -812,7 +831,7 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
-		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
+		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024; /* KiB/s */
 		iops = (1000 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
@@ -896,7 +915,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	if (ts->runtime[ddir]) {
 		uint64_t runt = ts->runtime[ddir];
 
-		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024;
+		bw = ((1000 * ts->io_bytes[ddir]) / runt) / 1024; /* KiB/s */
 		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
@@ -1418,7 +1437,7 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
 		if (dst->min_bw[i] && dst->min_bw[i] > src->min_bw[i])
 			dst->min_bw[i] = src->min_bw[i];
 
-		dst->io_kb[i] += src->io_kb[i];
+		dst->iobytes[i] += src->iobytes[i];
 		dst->agg[i] += src->agg[i];
 	}
 
@@ -1696,19 +1715,14 @@ void __show_run_stats(void)
 				rs->max_run[j] = ts->runtime[j];
 
 			bw = 0;
-			if (ts->runtime[j]) {
-				unsigned long runt = ts->runtime[j];
-				unsigned long long kb;
-
-				kb = ts->io_bytes[j] / rs->kb_base;
-				bw = kb * 1000 / runt;
-			}
+			if (ts->runtime[j])
+				bw = ts->io_bytes[j] * 1000 / ts->runtime[j];
 			if (bw < rs->min_bw[j])
 				rs->min_bw[j] = bw;
 			if (bw > rs->max_bw[j])
 				rs->max_bw[j] = bw;
 
-			rs->io_kb[j] += ts->io_bytes[j] / rs->kb_base;
+			rs->iobytes[j] += ts->io_bytes[j];
 		}
 	}
 
@@ -1719,7 +1733,7 @@ void __show_run_stats(void)
 
 		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
 			if (rs->max_run[ddir])
-				rs->agg[ddir] = (rs->io_kb[ddir] * 1000) /
+				rs->agg[ddir] = (rs->iobytes[ddir] * 1000) /
 						rs->max_run[ddir];
 		}
 	}
@@ -2436,7 +2450,7 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			continue; /* No entries for interval */
 
 		if (spent)
-			rate = delta * 1000 / spent / 1024;
+			rate = delta * 1000 / spent / 1024; /* KiB/s */
 		else
 			rate = 0;
 
diff --git a/stat.h b/stat.h
index 22083da..aa4ad80 100644
--- a/stat.h
+++ b/stat.h
@@ -7,7 +7,7 @@
 struct group_run_stats {
 	uint64_t max_run[DDIR_RWDIR_CNT], min_run[DDIR_RWDIR_CNT];
 	uint64_t max_bw[DDIR_RWDIR_CNT], min_bw[DDIR_RWDIR_CNT];
-	uint64_t io_kb[DDIR_RWDIR_CNT];
+	uint64_t iobytes[DDIR_RWDIR_CNT];
 	uint64_t agg[DDIR_RWDIR_CNT];
 	uint32_t kb_base;
 	uint32_t unit_base;
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index c589cea..4cdb38d 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -62,7 +62,7 @@ struct btrace_out {
 
 	uint64_t first_ttime[DDIR_RWDIR_CNT];
 	uint64_t last_ttime[DDIR_RWDIR_CNT];
-	uint64_t kb[DDIR_RWDIR_CNT];
+	uint64_t kib[DDIR_RWDIR_CNT];
 
 	uint64_t start_delay;
 };
@@ -406,7 +406,7 @@ static int handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 
 		i = inflight_find(t->sector + (t->bytes >> 9));
 		if (i) {
-			i->p->o.kb[t_to_rwdir(t)] += (t->bytes >> 10);
+			i->p->o.kib[t_to_rwdir(t)] += (t->bytes >> 10);
 			i->p->o.complete_seen = 1;
 			inflight_remove(i);
 		}
@@ -556,7 +556,7 @@ static int bs_cmp(const void *ba, const void *bb)
 	return bsb->nr - bsa->nr;
 }
 
-static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
+static unsigned long o_to_kib_rate(struct btrace_out *o, int rw)
 {
 	uint64_t usec = (o->last_ttime[rw] - o->first_ttime[rw]) / 1000ULL;
 	uint64_t val;
@@ -568,7 +568,7 @@ static unsigned long o_to_kb_rate(struct btrace_out *o, int rw)
 	if (!usec)
 		return 0;
 
-	val = o->kb[rw] * 1000ULL;
+	val = o->kib[rw] * 1000ULL;
 	return val / usec;
 }
 
@@ -623,7 +623,7 @@ static void __output_p_ascii(struct btrace_pid *p, unsigned long *ios)
 		printf("\tmerges: %lu (perc=%3.2f%%)\n", o->merges[i], perc);
 		perc = ((float) o->seq[i] * 100.0) / (float) o->ios[i];
 		printf("\tseq:    %lu (perc=%3.2f%%)\n", (unsigned long) o->seq[i], perc);
-		printf("\trate:   %lu KB/sec\n", o_to_kb_rate(o, i));
+		printf("\trate:   %lu KiB/sec\n", o_to_kib_rate(o, i));
 
 		for (j = 0; j < o->nr_bs[i]; j++) {
 			struct bs *bs = &o->bs[i][j];
@@ -746,7 +746,7 @@ static int __output_p_fio(struct btrace_pid *p, unsigned long *ios)
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 			unsigned long rate;
 
-			rate = o_to_kb_rate(o, i);
+			rate = o_to_kib_rate(o, i);
 			if (i)
 				printf(",");
 			if (rate)
@@ -810,7 +810,7 @@ static int prune_entry(struct btrace_out *o)
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		unsigned long this_rate;
 
-		this_rate = o_to_kb_rate(o, i);
+		this_rate = o_to_kib_rate(o, i);
 		if (this_rate < rate_threshold) {
 			remove_ddir(o, i);
 			this_rate = 0;
@@ -926,7 +926,7 @@ static int merge_entries(struct btrace_pid *pida, struct btrace_pid *pidb)
 		oa->ios[i] += ob->ios[i];
 		oa->merges[i] += ob->merges[i];
 		oa->seq[i] += ob->seq[i];
-		oa->kb[i] += ob->kb[i];
+		oa->kib[i] += ob->kib[i];
 		oa->first_ttime[i] = min(oa->first_ttime[i], ob->first_ttime[i]);
 		oa->last_ttime[i] = max(oa->last_ttime[i], ob->last_ttime[i]);
 		merge_bs(&oa->bs[i], &oa->nr_bs[i], ob->bs[i], ob->nr_bs[i]);
@@ -1021,7 +1021,7 @@ static int usage(char *argv[])
 	log_err("\t-n\tNumber IOS threshold to ignore task\n");
 	log_err("\t-f\tFio job file output\n");
 	log_err("\t-d\tUse this file/device for replay\n");
-	log_err("\t-r\tIgnore jobs with less than this KB/sec rate\n");
+	log_err("\t-r\tIgnore jobs with less than this KiB/sec rate\n");
 	log_err("\t-R\tSet rate in fio job (def=%u)\n", set_rate);
 	log_err("\t-D\tCap queue depth at this value (def=%u)\n", max_depth);
 	log_err("\t-c\tCollapse \"identical\" jobs (def=%u)\n", collapse_entries);
diff --git a/t/dedupe.c b/t/dedupe.c
index 7856da1..c0e9a69 100644
--- a/t/dedupe.c
+++ b/t/dedupe.c
@@ -363,7 +363,7 @@ static void show_progress(struct worker_thread *threads, unsigned long total)
 		tdiff = mtime_since_now(&last_tv);
 		if (tdiff) {
 			this_items = (this_items * 1000) / (tdiff * 1024);
-			printf("%3.2f%% done (%luKB/sec)\r", perc, this_items);
+			printf("%3.2f%% done (%luKiB/sec)\r", perc, this_items);
 			last_nitems = nitems;
 			fio_gettime(&last_tv, NULL);
 		} else
diff --git a/t/genzipf.c b/t/genzipf.c
index d8253c3..9faec38 100644
--- a/t/genzipf.c
+++ b/t/genzipf.c
@@ -3,8 +3,8 @@
  * what an access pattern would look like.
  *
  * For instance, the following would generate a zipf distribution
- * with theta 1.2, using 262144 (1 GB / 4096) values and split the reporting into
- * 20 buckets:
+ * with theta 1.2, using 262144 (1 GiB / 4096) values and split the
+ * reporting into 20 buckets:
  *
  *	./t/fio-genzipf -t zipf -i 1.2 -g 1 -b 4096 -o 20
  *
@@ -49,7 +49,7 @@ enum {
 };
 
 static int dist_type = TYPE_ZIPF;
-static unsigned long gb_size = 500;
+static unsigned long gib_size = 500;
 static unsigned long block_size = 4096;
 static unsigned long output_nranges = DEF_NR_OUTPUT;
 static double percentage;
@@ -131,7 +131,7 @@ static int parse_options(int argc, char *argv[])
 			}
 			break;
 		case 'g':
-			gb_size = strtoul(optarg, NULL, 10);
+			gib_size = strtoul(optarg, NULL, 10);
 			break;
 		case 'i':
 			dist_val = atof(optarg);
@@ -291,9 +291,10 @@ int main(int argc, char *argv[])
 		return 1;
 
 	if (output_type != OUTPUT_CSV)
-		printf("Generating %s distribution with %f input and %lu GB size and %lu block_size.\n", dist_types[dist_type], dist_val, gb_size, block_size);
+		printf("Generating %s distribution with %f input and %lu GiB size and %lu block_size.\n",
+		       dist_types[dist_type], dist_val, gib_size, block_size);
 
-	nranges = gb_size * 1024 * 1024 * 1024ULL;
+	nranges = gib_size * 1024 * 1024 * 1024ULL;
 	nranges /= block_size;
 
 	if (dist_type == TYPE_ZIPF)
diff --git a/t/lfsr-test.c b/t/lfsr-test.c
index bad5097..7016f26 100644
--- a/t/lfsr-test.c
+++ b/t/lfsr-test.c
@@ -80,7 +80,7 @@ int main(int argc, char *argv[])
 		v_size = numbers * sizeof(uint8_t);
 		v = malloc(v_size);
 		memset(v, 0, v_size);
-		printf("\nVerification table is %lf KBs\n", (double)(v_size) / 1024);
+		printf("\nVerification table is %lf KiB\n", (double)(v_size) / 1024);
 	}
 	v_start = v;
 
diff --git a/t/memlock.c b/t/memlock.c
index d9d586d..3d3579a 100644
--- a/t/memlock.c
+++ b/t/memlock.c
@@ -4,7 +4,7 @@
 #include <pthread.h>
 
 static struct thread_data {
-	unsigned long mb;
+	unsigned long mib;
 } td;
 
 static void *worker(void *data)
@@ -15,14 +15,14 @@ static void *worker(void *data)
 	char *buf;
 	int i, first = 1;
 
-	size = td->mb * 1024UL * 1024UL;
+	size = td->mib * 1024UL * 1024UL;
 	buf = malloc(size);
 
 	for (i = 0; i < 100000; i++) {
 		for (index = 0; index + 4096 < size; index += 4096)
 			memset(&buf[index+512], 0x89, 512);
 		if (first) {
-			printf("loop%d: did %lu MB\n", i+1, size/(1024UL*1024UL));
+			printf("loop%d: did %lu MiB\n", i+1, size/(1024UL*1024UL));
 			first = 0;
 		}
 	}
@@ -31,20 +31,20 @@ static void *worker(void *data)
 
 int main(int argc, char *argv[])
 {
-	unsigned long mb, threads;
+	unsigned long mib, threads;
 	pthread_t *pthreads;
 	int i;
 
 	if (argc < 3) {
-		printf("%s: <mb per thread> <threads>\n", argv[0]);
+		printf("%s: <MiB per thread> <threads>\n", argv[0]);
 		return 1;
 	}
 
-	mb = strtoul(argv[1], NULL, 10);
+	mib = strtoul(argv[1], NULL, 10);
 	threads = strtoul(argv[2], NULL, 10);
 
 	pthreads = calloc(threads, sizeof(pthread_t));
-	td.mb = mb;
+	td.mib = mib;
 
 	for (i = 0; i < threads; i++)
 		pthread_create(&pthreads[i], NULL, worker, &td);
diff --git a/t/read-to-pipe-async.c b/t/read-to-pipe-async.c
index e8bdc85..ebdd8f1 100644
--- a/t/read-to-pipe-async.c
+++ b/t/read-to-pipe-async.c
@@ -661,9 +661,9 @@ int main(int argc, char *argv[])
 
 	bytes /= 1024;
 	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &re);
-	fprintf(stderr, "Read rate (KB/sec) : %lu\n", rate);
+	fprintf(stderr, "Read rate (KiB/sec) : %lu\n", rate);
 	rate = (bytes * 1000UL * 1000UL) / utime_since(&s, &we);
-	fprintf(stderr, "Write rate (KB/sec): %lu\n", rate);
+	fprintf(stderr, "Write rate (KiB/sec): %lu\n", rate);
 
 	close(fd);
 	return 0;
diff --git a/t/stest.c b/t/stest.c
index 0e0d8b0..04df60d 100644
--- a/t/stest.c
+++ b/t/stest.c
@@ -59,15 +59,6 @@ static int do_rand_allocs(void)
 	return 0;
 }
 
-static int do_specific_alloc(unsigned long size)
-{
-	void *ptr;
-
-	ptr = smalloc(size);
-	sfree(ptr);
-	return 0;
-}
-
 int main(int argc, char *argv[])
 {
 	arch_init(argv);
@@ -76,9 +67,6 @@ int main(int argc, char *argv[])
 
 	do_rand_allocs();
 
-	/* smalloc bug, commit 271067a6 */
-	do_specific_alloc(671386584);
-
 	scleanup();
 	return 0;
 }
diff --git a/unit_tests/steadystate_tests.py b/unit_tests/steadystate_tests.py
index a8e4e39..91c79a4 100755
--- a/unit_tests/steadystate_tests.py
+++ b/unit_tests/steadystate_tests.py
@@ -115,7 +115,7 @@ if __name__ == '__main__':
     if args.read == None:
         if os.name == 'posix':
             args.read = '/dev/zero'
-            extra = [ "--size=128M" ]
+            extra = [ "--size=134217728" ]  # 128 MiB
         else:
             print "ERROR: file for read testing must be specified on non-posix systems"
             sys.exit(1)
