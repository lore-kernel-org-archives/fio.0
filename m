Return-Path: <fio-owner@vger.kernel.org>
Received: from g9t5009.houston.hpe.com ([15.241.48.73]:53267 "EHLO
        g9t5009.houston.hpe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941603AbcLVUrs (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2016 15:47:48 -0500
Received: from g9t2301.houston.hpecorp.net (g9t2301.houston.hpecorp.net [16.220.97.129])
        by g9t5009.houston.hpe.com (Postfix) with ESMTP id D9A6885
        for <fio@vger.kernel.org>; Thu, 22 Dec 2016 20:47:46 +0000 (UTC)
From: Robert Elliott <elliott@hpe.com>
Subject: [PATCH v2 12/12] Documentation for IEC binary and SI decimal prefix handling
Date: Thu, 22 Dec 2016 14:50:51 -0600
Message-Id: <20161222205051.4677-12-elliott@hpe.com>
In-Reply-To: <20161222205051.4677-1-elliott@hpe.com>
References: <20161222060853.64104-1-elliott@hpe.com>
 <20161222205051.4677-1-elliott@hpe.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Robert Elliott <elliott@hpe.com>

Documentation for the previous patch improving IEC and SI
decimal prefix handling (e.g., KiB, MiB, GiB vs. KB, MB, GB).

Includes updates to int, kb_base, and the parameters using
int to express quantities of data (e.g., bs, ba, bsrange, bssplit).

Includes updates to parameters that accept comma-separated
values (usually ints) for reads, writes, and trims; trims were
often not mentioned.
---
 HOWTO | 292 ++++++++++++++++++++++++++++++++++++++++++------------------------
 fio.1 | 193 +++++++++++++++++++++++++++++--------------
 2 files changed, 320 insertions(+), 165 deletions(-)

diff --git a/HOWTO b/HOWTO
index 181e94c..4354e46 100644
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
@@ -439,10 +489,24 @@ rw_sequencer=str If an offset modifier is given by appending a number to
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
 		data direction basis, meaning that reads, writes, and trims are
@@ -510,11 +574,11 @@ io_limit=int	Normally fio operates within the region set by 'size', which
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
@@ -537,36 +601,36 @@ fill_fs=bool	Sets size to something really large and waits for ENOSPC (no
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
@@ -590,24 +654,37 @@ bssplit=str	Sometimes you want even finer grained control of the
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
@@ -837,7 +914,7 @@ ioengine=str	Defines how the job issues io to the file. The following
 				filename, eg ioengine=external:/tmp/foo.o
 				to load ioengine foo.o in /tmp.
 
-iodepth=int	This defines how many io units to keep in flight against
+iodepth=int	This defines how many I/O units to keep in flight against
 		the file. The default is 1 for each file defined in this
 		job, can be overridden with a larger value for higher
 		concurrency. Note that increasing iodepth beyond 1 will not
@@ -990,7 +1067,8 @@ rwmixwrite=int	How large a percentage of the mix should be writes. If both
 		if fio is asked to limit reads or writes to a certain rate.
 		If that is the case, then the distribution may be skewed.
 
-random_distribution=str:float	By default, fio will use a completely uniform
+random_distribution=str:float[,str:float][,str:float]
+		By default, fio will use a completely uniform
 		random distribution when asked to perform random IO. Sometimes
 		it is useful to skew the distribution in specific ways,
 		ensuring that some parts of the data is more hot than others.
@@ -1032,14 +1110,15 @@ random_distribution=str:float	By default, fio will use a completely uniform
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
@@ -1111,29 +1190,32 @@ thinktime_blocks=int
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
@@ -1280,7 +1362,7 @@ sync=bool	Use sync io for buffered writes. For the majority of the
 		io engines, this means using O_SYNC.
 
 iomem=str
-mem=str		Fio can use various types of memory as the io unit buffer.
+mem=str		Fio can use various types of memory as the I/O unit buffer.
 		The allowed values are:
 
 			malloc	Use memory from malloc(3) as the buffers.
@@ -1308,7 +1390,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		that for shmhuge and mmaphuge to work, the system must have
 		free huge pages allocated. This can normally be checked
 		and set by reading/writing /proc/sys/vm/nr_hugepages on a
-		Linux system. Fio assumes a huge page is 4MB in size. So
+		Linux system. Fio assumes a huge page is 4MiB in size. So
 		to calculate the number of huge pages you need for a given
 		job file, add up the io depth of all jobs (normally one unless
 		iodepth= is used) and multiply by the maximum bs set. Then
@@ -1322,7 +1404,7 @@ mem=str		Fio can use various types of memory as the io unit buffer.
 		you would use mem=mmaphuge:/huge/somefile.
 
 iomem_align=int	This indicates the memory alignment of the IO memory buffers.
-		Note that the given alignment is applied to the first IO unit
+		Note that the given alignment is applied to the first I/O unit
 		buffer, if using iodepth the alignment of the following buffers
 		are given by the bs used. In other words, if using a bs that is
 		a multiple of the page sized in the system, all buffers will
@@ -1332,7 +1414,7 @@ iomem_align=int	This indicates the memory alignment of the IO memory buffers.
 
 hugepage-size=int
 		Defines the size of a huge page. Must at least be equal
-		to the system setting, see /proc/meminfo. Defaults to 4MB.
+		to the system setting, see /proc/meminfo. Defaults to 4MiB.
 		Should probably always be a multiple of megabytes, so using
 		hugepage-size=Xm is the preferred way to set this to avoid
 		setting a non-pow-2 bad value.
@@ -2024,7 +2106,7 @@ be the starting port number since fio will use a range of ports.
 fio spits out a lot of output. While running, fio will display the
 status of the jobs created. An example of that would be:
 
-Threads: 1: [_r] [24.8% done] [ 13509/  8334 kb/s] [eta 00h:01m:31s]
+Jobs: 1: [_r] [24.8% done] [r=20992KiB/s,w=24064KiB/s,t=0KiB/s] [r=82,w=94,t=0 iops] [eta 00h:01m:31s]
 
 The characters inside the square brackets denote the current status of
 each thread. The possible values (in typical life cycle order) are:
@@ -2053,7 +2135,7 @@ Fio will condense the thread string as not to take up more space on the
 command line as is needed. For instance, if you have 10 readers and 10
 writers running, the output would look like this:
 
-Jobs: 20 (f=20): [R(10),W(10)] [4.0% done] [2103MB/0KB/0KB /s] [538K/0/0 iops] [eta 57m:36s]
+Jobs: 20 (f=20): [R(10),W(10)] [4.0% done] [r=20992KiB/s,w=24064KiB/s,t=0KiB/s] [r=82,w=94,t=0 iops] [eta 57m:36s]
 
 Fio will still maintain the ordering, though. So the above means that jobs
 1..10 are readers, and 11..20 are writers.
@@ -2071,10 +2153,10 @@ each thread, group of threads, and disks in that order. For each data
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
@@ -2193,19 +2275,19 @@ Split up, the format is as follows:
 
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
@@ -2396,7 +2478,7 @@ Time for the log entry is always in milliseconds. The value logged depends
 on the type of log, it will be one of the following:
 
 	Latency log		Value is latency in usecs
-	Bandwidth log		Value is in KB/sec
+	Bandwidth log		Value is in KiB/sec
 	IOPS log		Value is IOPS
 
 Data direction is one of the following:
diff --git a/fio.1 b/fio.1
index 7363a37..f486276 100644
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
-- 
2.9.3

