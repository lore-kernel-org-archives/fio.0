Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:41014 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752854AbdF0MAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 27 Jun 2017 08:00:15 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dPpA9-0003In-3n
        for fio@vger.kernel.org; Tue, 27 Jun 2017 12:00:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170627120002.5A37C2C0235@kernel.dk>
Date: Tue, 27 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 036a159982656aaa98b0a0490defc36c6065aa93:

  Android: fix missing sysmacros.h include (2017-06-25 09:51:13 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to db84b73bd7b0c3b718596fbeb6a5f940b05a6735:

  stat: fix group percentage (2017-06-27 00:47:27 +0100)

----------------------------------------------------------------
Jens Axboe (1):
      stat: fix alignment of the iops stats

Sitsofe Wheeler (26):
      HOWTO: add defaults
      HOWTO: state default time unit
      HOWTO: grammar/spelling changes
      HOWTO: escape =
      HOWTO: update time specification
      HOWTO: update directory and filename option descriptions
      HOWTO: update command line option descriptions
      HOWTO: general consistency
      HOWTO: minor internal/reordering/formatting changes
      HOWTO: description rewording/fixes
      HOWTO: Fix some capitalisation
      HOWTO: make filesize syntax show it can take a typed range
      HOWTO: reword HDFS description
      HOWTO: add --output-format=terse as another way to get minimal output
      HOWTO: add rate example
      HOWTO: add some markup
      HOWTO: reorder client/server phrasing
      HOWTO: reword iodepth and submit distribution text
      HOWTO: Reword Log File Formats and add reference
      HOWTO: modernize output examples and descriptions
      HOWTO/examples: fix writetrim "typo"
      init: update --crctest help syntax
      HOWTO: note that crc32c will automatically use hw
      README: update Red Hat fio package URL
      stat: fix printf format specifier
      stat: fix group percentage

 HOWTO            | 575 +++++++++++++++++++++++++++++++------------------------
 README           |   2 +-
 examples/mtd.fio |   2 +-
 init.c           |   2 +-
 stat.c           |  12 +-
 5 files changed, 335 insertions(+), 258 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index b2db69d..2007dc0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -121,7 +121,7 @@ Command line options
 .. option:: --output-format=type
 
 	Set the reporting format to `normal`, `terse`, `json`, or `json+`.  Multiple
-	formats can be selected, separate by a comma.  `terse` is a CSV based
+	formats can be selected, separated by a comma.  `terse` is a CSV based
 	format.  `json+` is like `json`, except it adds a full dump of the latency
 	buckets.
 
@@ -135,16 +135,16 @@ Command line options
 
 .. option:: --help
 
-	Print this page.
+	Print a summary of the command line options and exit.
 
 .. option:: --cpuclock-test
 
 	Perform test and validation of internal CPU clock.
 
-.. option:: --crctest=test
+.. option:: --crctest=[test]
 
-    Test the speed of the builtin checksumming functions. If no argument is
-    given, all of them are tested. Or a comma separated list can be passed, in
+    Test the speed of the built-in checksumming functions. If no argument is
+    given all of them are tested. Alternatively, a comma separated list can be passed, in
     which case the given ones are tested.
 
 .. option:: --cmdhelp=command
@@ -177,11 +177,13 @@ Command line options
 
 .. option:: --eta-newline=time
 
-	Force a new line for every `time` period passed.
+	Force a new line for every `time` period passed.  When the unit is omitted,
+	the value is interpreted in seconds.
 
 .. option:: --status-interval=time
 
-	Force full status dump every `time` period passed.
+	Force full status dump every `time` period passed.  When the unit is
+	omitted, the value is interpreted in seconds.
 
 .. option:: --section=name
 
@@ -196,11 +198,11 @@ Command line options
 
 .. option:: --alloc-size=kb
 
-    Set the internal smalloc pool to this size in kb (def 1024).  The
+    Set the internal smalloc pool to this size in KiB.  The
     ``--alloc-size`` switch allows one to use a larger pool size for smalloc.
     If running large jobs with randommap enabled, fio can run out of memory.
     Smalloc is an internal allocator for shared structures from a fixed size
-    memory pool. The pool size defaults to 16M and can grow to 8 pools.
+    memory pool and can grow to 16 pools. The pool size defaults to 16MiB.
 
     NOTE: While running :file:`.fio_smalloc.*` backing store files are visible
     in :file:`/tmp`.
@@ -234,9 +236,16 @@ Command line options
 
 .. option:: --idle-prof=option
 
-	Report cpu idleness on a system or percpu basis
-	``--idle-prof=system,percpu`` or
-	run unit work calibration only ``--idle-prof=calibrate``.
+	Report CPU idleness. *option* is one of the following:
+
+		**calibrate**
+			Run unit work calibration only and exit.
+
+		**system**
+			Show aggregate system idleness and unit work.
+
+		**percpu**
+			As **system** but also show per CPU idleness.
 
 .. option:: --inflate-log=log
 
@@ -468,10 +477,10 @@ Parameter types
     String. This is a sequence of alpha characters.
 
 **time**
-	Integer with possible time suffix. In seconds unless otherwise
-	specified, use e.g. 10m for 10 minutes. Accepts s/m/h for seconds, minutes,
-	and hours, and accepts 'ms' (or 'msec') for milliseconds, and 'us' (or
-	'usec') for microseconds.
+	Integer with possible time suffix.  Without a unit value is interpreted as
+	seconds unless otherwise specified.  Accepts a suffix of 'd' for days, 'h' for
+	hours, 'm' for minutes, 's' for seconds, 'ms' (or 'msec') for milliseconds and
+	'us' (or 'usec') for microseconds.  For example, use 10m for 10 minutes.
 
 .. _int:
 
@@ -486,9 +495,10 @@ Parameter types
 
 	The optional *integer suffix* specifies the number's units, and includes an
 	optional unit prefix and an optional unit.  For quantities of data, the
-	default unit is bytes. For quantities of time, the default unit is seconds.
+	default unit is bytes. For quantities of time, the default unit is seconds
+	unless otherwise specified.
 
-	With :option:`kb_base` =1000, fio follows international standards for unit
+	With :option:`kb_base`\=1000, fio follows international standards for unit
 	prefixes.  To specify power-of-10 decimal values defined in the
 	International System of Units (SI):
 
@@ -506,7 +516,7 @@ Parameter types
 		* *T* -- means tebi (Ti) or 1024**4
 		* *P* -- means pebi (Pi) or 1024**5
 
-	With :option:`kb_base` =1024 (the default), the unit prefixes are opposite
+	With :option:`kb_base`\=1024 (the default), the unit prefixes are opposite
 	from those specified in the SI and IEC 80000-13 standards to provide
 	compatibility with old scripts.  For example, 4k means 4096.
 
@@ -516,7 +526,7 @@ Parameter types
 	The *integer suffix* is not case sensitive (e.g., m/mi mean mebi/mega,
 	not milli). 'b' and 'B' both mean byte, not bit.
 
-	Examples with :option:`kb_base` =1000:
+	Examples with :option:`kb_base`\=1000:
 
 		* *4 KiB*: 4096, 4096b, 4096B, 4ki, 4kib, 4kiB, 4Ki, 4KiB
 		* *1 MiB*: 1048576, 1mi, 1024ki
@@ -524,7 +534,7 @@ Parameter types
 		* *1 TiB*: 1099511627776, 1ti, 1024gi, 1048576mi
 		* *1 TB*: 1000000000, 1t, 1000m, 1000000k
 
-	Examples with :option:`kb_base` =1024 (default):
+	Examples with :option:`kb_base`\=1024 (default):
 
 		* *4 KiB*: 4096, 4096b, 4096B, 4k, 4kb, 4kB, 4K, 4KB
 		* *1 MiB*: 1048576, 1m, 1024k
@@ -536,15 +546,15 @@ Parameter types
 
 		* *D* -- means days
 		* *H* -- means hours
-		* *M* -- mean minutes
+		* *M* -- means minutes
 		* *s* -- or sec means seconds (default)
 		* *ms* -- or *msec* means milliseconds
 		* *us* -- or *usec* means microseconds
 
 	If the option accepts an upper and lower range, use a colon ':' or
 	minus '-' to separate such values. See :ref:`irange <irange>`.
-	If the lower value specified happens to be larger than the upper value,
-	two values are swapped.
+	If the lower value specified happens to be larger than the upper value
+	the two values are swapped.
 
 .. _bool:
 
@@ -638,7 +648,7 @@ Job description
 	larger number of threads/processes doing the same thing. Each thread is
 	reported separately; to see statistics for all clones as a whole, use
 	:option:`group_reporting` in conjunction with :option:`new_group`.
-	See :option:`--max-jobs`.
+	See :option:`--max-jobs`.  Default: 1.
 
 
 Time related parameters
@@ -649,7 +659,7 @@ Time related parameters
 	Tell fio to terminate processing after the specified period of time.  It
 	can be quite hard to determine for how long a specified job will run, so
 	this parameter is handy to cap the total runtime to a given time.  When
-	the unit is omitted, the value is given in seconds.
+	the unit is omitted, the value is intepreted in seconds.
 
 .. option:: time_based
 
@@ -659,10 +669,9 @@ Time related parameters
 
 .. option:: startdelay=irange(time)
 
-	Delay start of job for the specified number of seconds. Supports all time
-	suffixes to allow specification of hours, minutes, seconds and milliseconds
-	-- seconds are the default if a unit is omitted.  Can be given as a range
-	which causes each thread to choose randomly out of the range.
+	Delay the start of job for the specified amount of time.  Can be a single
+	value or a range.  When given as a range, each thread will choose a value
+	randomly from within the range.  Value is in seconds if a unit is omitted.
 
 .. option:: ramp_time=time
 
@@ -723,36 +732,41 @@ Target file/device
 	Prefix filenames with this directory. Used to place files in a different
 	location than :file:`./`.  You can specify a number of directories by
 	separating the names with a ':' character. These directories will be
-	assigned equally distributed to job clones creates with :option:`numjobs` as
+	assigned equally distributed to job clones created by :option:`numjobs` as
 	long as they are using generated filenames. If specific `filename(s)` are
 	set fio will use the first listed directory, and thereby matching the
 	`filename` semantic which generates a file each clone if not specified, but
 	let all clones use the same if set.
 
-	See the :option:`filename` option for escaping certain characters.
+	See the :option:`filename` option for information on how to escape "``:``" and
+	"``\``" characters within the directory path itself.
 
 .. option:: filename=str
 
 	Fio normally makes up a `filename` based on the job name, thread number, and
-	file number. If you want to share files between threads in a job or several
+	file number (see :option:`filename_format`). If you want to share files
+	between threads in a job or several
 	jobs with fixed file paths, specify a `filename` for each of them to override
 	the default. If the ioengine is file based, you can specify a number of files
 	by separating the names with a ':' colon. So if you wanted a job to open
 	:file:`/dev/sda` and :file:`/dev/sdb` as the two working files, you would use
 	``filename=/dev/sda:/dev/sdb``. This also means that whenever this option is
 	specified, :option:`nrfiles` is ignored. The size of regular files specified
-	by this option will be :option:`size` divided by number of files unless
+	by this option will be :option:`size` divided by number of files unless an
 	explicit size is specified by :option:`filesize`.
 
+	Each colon and backslash in the wanted path must be escaped with a ``\``
+	character.  For instance, if the path is :file:`/dev/dsk/foo@3,0:c` then you
+	would use ``filename=/dev/dsk/foo@3,0\:c`` and if the path is
+	:file:`F:\\filename` then you would use ``filename=F\:\\filename``.
+
 	On Windows, disk devices are accessed as :file:`\\\\.\\PhysicalDrive0` for
 	the first device, :file:`\\\\.\\PhysicalDrive1` for the second etc.
 	Note: Windows and FreeBSD prevent write access to areas
-	of the disk containing in-use data (e.g. filesystems).  If the wanted
-	`filename` does need to include a colon, then escape that with a ``\``
-	character. For instance, if the `filename` is :file:`/dev/dsk/foo@3,0:c`,
-	then you would use ``filename="/dev/dsk/foo@3,0\:c"``.  The
-	:file:`-` is a reserved name, meaning stdin or stdout.  Which of the two
-	depends on the read/write direction set.
+	of the disk containing in-use data (e.g. filesystems).
+
+	The filename "`-`" is a reserved name, meaning *stdin* or *stdout*.  Which
+	of the two depends on the read/write direction set.
 
 .. option:: filename_format=str
 
@@ -860,27 +874,28 @@ Target file/device
 
 	If true, serialize the file creation for the jobs.  This may be handy to
 	avoid interleaving of data files, which may greatly depend on the filesystem
-	used and even the number of processors in the system.
+	used and even the number of processors in the system.  Default: true.
 
 .. option:: create_fsync=bool
 
-	fsync the data file after creation. This is the default.
+	:manpage:`fsync(2)` the data file after creation. This is the default.
 
 .. option:: create_on_open=bool
 
-	Don't pre-setup the files for I/O, just create open() when it's time to do
-	I/O to that file.
+	If true, don't pre-create files but allow the job's open() to create a file
+	when it's time to do I/O.  Default: false -- pre-create all necessary files
+	when the job starts.
 
 .. option:: create_only=bool
 
 	If true, fio will only run the setup phase of the job.  If files need to be
-	laid out or updated on disk, only that will be done. The actual job contents
-	are not executed.
+	laid out or updated on disk, only that will be done -- the actual job contents
+	are not executed.  Default: false.
 
 .. option:: allow_file_create=bool
 
-	If true, fio is permitted to create files as part of its workload. This is
-	the default behavior. If this option is false, then fio will error out if
+	If true, fio is permitted to create files as part of its workload.  If this
+	option is false, then fio will error out if
 	the files it needs to use don't already exist. Default: true.
 
 .. option:: allow_mounted_write=bool
@@ -897,16 +912,18 @@ Target file/device
 	given I/O operation. This will also clear the :option:`invalidate` flag,
 	since it is pointless to pre-read and then drop the cache. This will only
 	work for I/O engines that are seek-able, since they allow you to read the
-	same data multiple times. Thus it will not work on e.g. network or splice I/O.
+	same data multiple times. Thus it will not work on non-seekable I/O engines
+	(e.g. network, splice). Default: false.
 
 .. option:: unlink=bool
 
 	Unlink the job files when done. Not the default, as repeated runs of that
-	job would then waste time recreating the file set again and again.
+	job would then waste time recreating the file set again and again. Default:
+	false.
 
 .. option:: unlink_each_loop=bool
 
-	Unlink job files after each iteration or loop.
+	Unlink job files after each iteration or loop.  Default: false.
 
 .. option:: zonesize=int
 
@@ -952,10 +969,10 @@ I/O type
 				Sequential writes.
 		**trim**
 				Sequential trims (Linux block devices only).
-		**randwrite**
-				Random writes.
 		**randread**
 				Random reads.
+		**randwrite**
+				Random writes.
 		**randtrim**
 				Random trims (Linux block devices only).
 		**rw,readwrite**
@@ -968,15 +985,16 @@ I/O type
 
 	Fio defaults to read if the option is not specified.  For the mixed I/O
 	types, the default is to split them 50/50.  For certain types of I/O the
-	result may still be skewed a bit, since the speed may be different. It is
-	possible to specify a number of I/O's to do before getting a new offset,
-	this is done by appending a ``:<nr>`` to the end of the string given.  For a
+	result may still be skewed a bit, since the speed may be different.
+
+	It is possible to specify the number of I/Os to do before getting a new
+	offset by appending ``:<nr>`` to the end of the string given.  For a
 	random read, it would look like ``rw=randread:8`` for passing in an offset
 	modifier with a value of 8. If the suffix is used with a sequential I/O
-	pattern, then the value specified will be added to the generated offset for
-	each I/O.  For instance, using ``rw=write:4k`` will skip 4k for every
-	write. It turns sequential I/O into sequential I/O with holes.  See the
-	:option:`rw_sequencer` option.
+	pattern, then the *<nr>* value specified will be **added** to the generated
+	offset for each I/O turning sequential I/O into sequential I/O with holes.
+	For instance, using ``rw=write:4k`` will skip 4k for every write.  Also see
+	the :option:`rw_sequencer` option.
 
 .. option:: rw_sequencer=str
 
@@ -1099,23 +1117,25 @@ I/O type
 
 .. option:: fsync=int
 
-	If writing to a file, issue a sync of the dirty data for every number of
-	blocks given. For example, if you give 32 as a parameter, fio will sync the
-	file for every 32 writes issued. If fio is using non-buffered I/O, we may
-	not sync the file. The exception is the sg I/O engine, which synchronizes
-	the disk cache anyway. Defaults to 0, which means no sync every certain
-	number of writes.
+	If writing to a file, issue an :manpage:`fsync(2)` (or its equivalent) of
+	the dirty data for every number of blocks given. For example, if you give 32
+	as a parameter, fio will sync the file after every 32 writes issued. If fio is
+	using non-buffered I/O, we may not sync the file. The exception is the sg
+	I/O engine, which synchronizes the disk cache anyway. Defaults to 0, which
+	means fio does not periodically issue and wait for a sync to complete. Also
+	see :option:`end_fsync` and :option:`fsync_on_close`.
 
 .. option:: fdatasync=int
 
 	Like :option:`fsync` but uses :manpage:`fdatasync(2)` to only sync data and
 	not metadata blocks.  In Windows, FreeBSD, and DragonFlyBSD there is no
-	:manpage:`fdatasync(2)`, this falls back to using :manpage:`fsync(2)`.
-	Defaults to 0, which means no sync data every certain number of writes.
+	:manpage:`fdatasync(2)` so this falls back to using :manpage:`fsync(2)`.
+	Defaults to 0, which means fio does not periodically issue and wait for a
+	data-only sync to complete.
 
 .. option:: write_barrier=int
 
-   Make every `N-th` write a barrier write.
+	Make every `N-th` write a barrier write.
 
 .. option:: sync_file_range=str:val
 
@@ -1140,17 +1160,18 @@ I/O type
 	If true, writes to a file will always overwrite existing data. If the file
 	doesn't already exist, it will be created before the write phase begins. If
 	the file exists and is large enough for the specified write phase, nothing
-	will be done.
+	will be done. Default: false.
 
 .. option:: end_fsync=bool
 
-	If true, fsync file contents when a write stage has completed.
+	If true, :manpage:`fsync(2)` file contents when a write stage has completed.
+	Default: false.
 
 .. option:: fsync_on_close=bool
 
 	If true, fio will :manpage:`fsync(2)` a dirty file on close.  This differs
-	from end_fsync in that it will happen on every file close, not just at the
-	end of the job.
+	from :option:`end_fsync` in that it will happen on every file close, not
+	just at the end of the job.  Default: false.
 
 .. option:: rwmixread=int
 
@@ -1383,8 +1404,8 @@ Buffers and memory
 .. option:: buffer_compress_percentage=int
 
 	If this is set, then fio will attempt to provide I/O buffer content (on
-	WRITEs) that compress to the specified level. Fio does this by providing a
-	mix of random data and a fixed pattern. The fixed pattern is either zeroes,
+	WRITEs) that compresses to the specified level. Fio does this by providing a
+	mix of random data and a fixed pattern. The fixed pattern is either zeros,
 	or the pattern specified by :option:`buffer_pattern`. If the pattern option
 	is used, it might skew the compression ratio slightly. Note that this is per
 	block size unit, for file/disk wide compression level that matches this
@@ -1438,8 +1459,8 @@ Buffers and memory
 
 .. option:: invalidate=bool
 
-	Invalidate the buffer/page cache parts for this file prior to starting
-	I/O if the platform and file type support it. Defaults to true.
+	Invalidate the buffer/page cache parts of the files to be used prior to
+	starting I/O if the platform and file type support it.  Defaults to true.
 	This will be ignored if :option:`pre_read` is also specified for the
 	same job.
 
@@ -1465,7 +1486,7 @@ Buffers and memory
 			Same as shm, but use huge pages as backing.
 
 		**mmap**
-			Use mmap to allocate buffers. May either be anonymous memory, or can
+			Use :manpage:`mmap(2)` to allocate buffers. May either be anonymous memory, or can
 			be file backed if a filename is given after the option. The format
 			is `mem=mmap:/path/to/file`.
 
@@ -1551,7 +1572,7 @@ I/O size
 	and :option:`io_size` is set to 40GiB, then fio will do 40GiB of I/O within
 	the 0..20GiB region.
 
-.. option:: filesize=int
+.. option:: filesize=irange(int)
 
 	Individual file sizes. May be a range, in which case fio will select sizes
 	for files at random within the given range and limited to :option:`size` in
@@ -1604,7 +1625,7 @@ I/O engine
 
 		**libaio**
 			Linux native asynchronous I/O. Note that Linux may only support
-			queued behaviour with non-buffered I/O (set ``direct=1`` or
+			queued behavior with non-buffered I/O (set ``direct=1`` or
 			``buffered=0``).
 			This engine defines engine specific options.
 
@@ -1654,7 +1675,7 @@ I/O engine
 		**cpuio**
 			Doesn't transfer any data, but burns CPU cycles according to the
 			:option:`cpuload` and :option:`cpuchunks` options. Setting
-			:option:`cpuload` =85 will cause that job to do nothing but burn 85%
+			:option:`cpuload`\=85 will cause that job to do nothing but burn 85%
 			of the CPU. In case of SMP machines, use :option:`numjobs`
 			=<no_of_cpu> to get desired CPU usage, as the cpuload only loads a
 			single CPU at the desired rate. A job never finishes unless there is
@@ -1701,26 +1722,26 @@ I/O engine
 			ioengine defines engine specific options.
 
 		**gfapi**
-			Using Glusterfs libgfapi sync interface to direct access to
-			Glusterfs volumes without having to go through FUSE.  This ioengine
+			Using GlusterFS libgfapi sync interface to direct access to
+			GlusterFS volumes without having to go through FUSE.  This ioengine
 			defines engine specific options.
 
 		**gfapi_async**
-			Using Glusterfs libgfapi async interface to direct access to
-			Glusterfs volumes without having to go through FUSE. This ioengine
+			Using GlusterFS libgfapi async interface to direct access to
+			GlusterFS volumes without having to go through FUSE. This ioengine
 			defines engine specific options.
 
 		**libhdfs**
 			Read and write through Hadoop (HDFS).  The :file:`filename` option
 			is used to specify host,port of the hdfs name-node to connect.  This
 			engine interprets offsets a little differently.  In HDFS, files once
-			created cannot be modified.  So random writes are not possible. To
-			imitate this, libhdfs engine expects bunch of small files to be
-			created over HDFS, and engine will randomly pick a file out of those
-			files based on the offset generated by fio backend. (see the example
+			created cannot be modified so random writes are not possible. To
+			imitate this the libhdfs engine expects a bunch of small files to be
+			created over HDFS and will randomly pick a file from them
+			based on the offset generated by fio backend (see the example
 			job file to create such files, use ``rw=write`` option). Please
-			note, you might want to set necessary environment variables to work
-			with hdfs/libhdfs properly.  Each job uses its own connection to
+			note, it may be necessary to set environment variables to work
+			with HDFS/libhdfs properly.  Each job uses its own connection to
 			HDFS.
 
 		**mtd**
@@ -1728,7 +1749,7 @@ I/O engine
 			:file:`/dev/mtd0`). Discards are treated as erases. Depending on the
 			underlying device type, the I/O may have to go in a certain pattern,
 			e.g., on NAND, writing sequentially to erase blocks and discarding
-			before overwriting. The writetrim mode works well for this
+			before overwriting. The `trimwrite` mode works well for this
 			constraint.
 
 		**pmemblk**
@@ -1782,13 +1803,13 @@ caveat that when used on the command line, they must come after the
 
 .. option:: hostname=str : [netsplice] [net]
 
-	The host name or IP address to use for TCP or UDP based I/O.  If the job is
-	a TCP listener or UDP reader, the host name is not used and must be omitted
+	The hostname or IP address to use for TCP or UDP based I/O.  If the job is
+	a TCP listener or UDP reader, the hostname is not used and must be omitted
 	unless it is a valid UDP multicast address.
 
 .. option:: namenode=str : [libhdfs]
 
-	The host name or IP address of a HDFS cluster namenode to contact.
+	The hostname or IP address of a HDFS cluster namenode to contact.
 
 .. option:: port=int
 
@@ -1865,7 +1886,7 @@ caveat that when used on the command line, they must come after the
 
 .. option:: donorname=str : [e4defrag]
 
-	File will be used as a block donor(swap extents between files).
+	File will be used as a block donor (swap extents between files).
 
 .. option:: inplace=int : [e4defrag]
 
@@ -1919,7 +1940,7 @@ I/O depth
 	for small degrees when :option:`verify_async` is in use).  Even async
 	engines may impose OS restrictions causing the desired depth not to be
 	achieved.  This may happen on Linux when using libaio and not setting
-	:option:`direct` =1, since buffered I/O is not async on that OS.  Keep an
+	:option:`direct`\=1, since buffered I/O is not async on that OS.  Keep an
 	eye on the I/O depth distribution in the fio output to verify that the
 	achieved depth is as expected. Default: 1.
 
@@ -1942,9 +1963,9 @@ I/O depth
 .. option:: iodepth_batch_complete_max=int
 
 	This defines maximum pieces of I/O to retrieve at once. This variable should
-	be used along with :option:`iodepth_batch_complete_min` =int variable,
+	be used along with :option:`iodepth_batch_complete_min`\=int variable,
 	specifying the range of min and max amount of I/O which should be
-	retrieved. By default it is equal to :option:`iodepth_batch_complete_min`
+	retrieved. By default it is equal to the :option:`iodepth_batch_complete_min`
 	value.
 
 	Example #1::
@@ -1982,7 +2003,7 @@ I/O depth
 	has a bit of extra overhead, especially for lower queue depth I/O where it
 	can increase latencies. The benefit is that fio can manage submission rates
 	independently of the device completion rates. This avoids skewed latency
-	reporting if I/O gets back up on the device side (the coordinated omission
+	reporting if I/O gets backed up on the device side (the coordinated omission
 	problem).
 
 
@@ -1993,7 +2014,7 @@ I/O rate
 
 	Stall the job for the specified period of time after an I/O has completed before issuing the
 	next. May be used to simulate processing being done by an application.
-	When the unit is omitted, the value is given in microseconds.  See
+	When the unit is omitted, the value is interpreted in microseconds.  See
 	:option:`thinktime_blocks` and :option:`thinktime_spin`.
 
 .. option:: thinktime_spin=time
@@ -2001,7 +2022,7 @@ I/O rate
 	Only valid if :option:`thinktime` is set - pretend to spend CPU time doing
 	something with the data received, before falling back to sleeping for the
 	rest of the period specified by :option:`thinktime`.  When the unit is
-	omitted, the value is given in microseconds.
+	omitted, the value is interpreted in microseconds.
 
 .. option:: thinktime_blocks=int
 
@@ -2018,6 +2039,11 @@ I/O rate
 	suffix rules apply.  Comma-separated values may be specified for reads,
 	writes, and trims as described in :option:`blocksize`.
 
+	For example, using `rate=1m,500k` would limit reads to 1MiB/sec and writes to
+	500KiB/sec.  Capping only reads or writes can be done with `rate=,500k` or
+	`rate=500k,` where the former will only limit writes (to 500KiB/sec) and the
+	latter will only limit reads.
+
 .. option:: rate_min=int[,int][,int]
 
 	Tell fio to do whatever it can to maintain at least this bandwidth. Failing
@@ -2057,14 +2083,14 @@ I/O latency
 
 	If set, fio will attempt to find the max performance point that the given
 	workload will run at while maintaining a latency below this target.  When
-	the unit is omitted, the value is given in microseconds.  See
+	the unit is omitted, the value is interpreted in microseconds.  See
 	:option:`latency_window` and :option:`latency_percentile`.
 
 .. option:: latency_window=time
 
 	Used with :option:`latency_target` to specify the sample window that the job
 	is run at varying queue depths to test the performance.  When the unit is
-	omitted, the value is given in microseconds.
+	omitted, the value is interpreted in microseconds.
 
 .. option:: latency_percentile=float
 
@@ -2076,13 +2102,13 @@ I/O latency
 .. option:: max_latency=time
 
 	If set, fio will exit the job with an ETIMEDOUT error if it exceeds this
-	maximum latency. When the unit is omitted, the value is given in
+	maximum latency. When the unit is omitted, the value is interpreted in
 	microseconds.
 
 .. option:: rate_cycle=int
 
 	Average bandwidth for :option:`rate` and :option:`rate_min` over this number
-	of milliseconds.
+	of milliseconds. Defaults to 1000.
 
 
 I/O replay
@@ -2096,7 +2122,7 @@ I/O replay
 
 .. option:: read_iolog=str
 
-	Open an iolog with the specified file name and replay the I/O patterns it
+	Open an iolog with the specified filename and replay the I/O patterns it
 	contains. This can be used to store a workload and replay it sometime
 	later. The iolog given may also be a blktrace binary file, which allows fio
 	to replay a workload captured by :command:`blktrace`. See
@@ -2107,7 +2133,7 @@ I/O replay
 .. option:: replay_no_stall=int
 
 	When replaying I/O with :option:`read_iolog` the default behavior is to
-	attempt to respect the time stamps within the log and replay them with the
+	attempt to respect the timestamps within the log and replay them with the
 	appropriate delay between IOPS. By setting this variable fio will not
 	respect the timestamps and attempt to replay them as fast as possible while
 	still respecting ordering. The result is the same I/O pattern to a given
@@ -2120,9 +2146,9 @@ I/O replay
 	from.  This is sometimes undesirable because on a different machine those
 	major/minor numbers can map to a different device.  Changing hardware on the
 	same system can also result in a different major/minor mapping.
-	``replay_redirect`` causes all IOPS to be replayed onto the single specified
+	``replay_redirect`` causes all I/Os to be replayed onto the single specified
 	device regardless of the device it was recorded
-	from. i.e. :option:`replay_redirect` = :file:`/dev/sdc` would cause all I/O
+	from. i.e. :option:`replay_redirect`\= :file:`/dev/sdc` would cause all I/O
 	in the blktrace or iolog to be replayed onto :file:`/dev/sdc`.  This means
 	multiple devices will be replayed onto a single device, if the trace
 	contains multiple devices. If you want multiple devices to be replayed
@@ -2146,15 +2172,14 @@ Threads, processes and job synchronization
 
 .. option:: thread
 
-	Fio defaults to forking jobs, however if this option is given, fio will use
-	POSIX Threads function :manpage:`pthread_create(3)` to create threads instead
-	of forking processes.
+	Fio defaults to creating jobs by using fork, however if this option is
+	given, fio will create jobs by using POSIX Threads' function
+	:manpage:`pthread_create(3)` to create threads instead.
 
 .. option:: wait_for=str
 
-	Specifies the name of the already defined job to wait for. Single waitee
-	name only may be specified. If set, the job won't be started until all
-	workers of the waitee job are done.
+	If set, the current job won't be started until all workers of the specified
+	waitee job are done.
 
 	``wait_for`` operates on the job name basis, so there are a few
 	limitations. First, the waitee must be defined prior to the waiter job
@@ -2182,8 +2207,8 @@ Threads, processes and job synchronization
 
 .. option:: cpumask=int
 
-	Set the CPU affinity of this job. The parameter given is a bitmask of
-	allowed CPU's the job may run on. So if you want the allowed CPUs to be 1
+	Set the CPU affinity of this job. The parameter given is a bit mask of
+	allowed CPUs the job may run on. So if you want the allowed CPUs to be 1
 	and 5, you would pass the decimal value of (1 << 1 | 1 << 5), or 34. See man
 	:manpage:`sched_setaffinity(2)`. This may not work on all supported
 	operating systems or kernel versions. This option doesn't work well for a
@@ -2193,23 +2218,23 @@ Threads, processes and job synchronization
 
 .. option:: cpus_allowed=str
 
-	Controls the same options as :option:`cpumask`, but it allows a text setting
-	of the permitted CPUs instead. So to use CPUs 1 and 5, you would specify
-	``cpus_allowed=1,5``. This options also allows a range of CPUs. Say you
-	wanted a binding to CPUs 1, 5, and 8-15, you would set
-	``cpus_allowed=1,5,8-15``.
+	Controls the same options as :option:`cpumask`, but accepts a textual
+	specification of the permitted CPUs instead. So to use CPUs 1 and 5 you
+	would specify ``cpus_allowed=1,5``. This option also allows a range of CPUs
+	to be specified -- say you wanted a binding to CPUs 1, 5, and 8 to 15, you
+	would set ``cpus_allowed=1,5,8-15``.
 
 .. option:: cpus_allowed_policy=str
 
 	Set the policy of how fio distributes the CPUs specified by
-	:option:`cpus_allowed` or cpumask. Two policies are supported:
+	:option:`cpus_allowed` or :option:`cpumask`. Two policies are supported:
 
 		**shared**
 			All jobs will share the CPU set specified.
 		**split**
 			Each job will get a unique CPU from the CPU set.
 
-	**shared** is the default behaviour, if the option isn't specified. If
+	**shared** is the default behavior, if the option isn't specified. If
 	**split** is specified, then fio will will assign one cpu per job. If not
 	enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
 	in the set.
@@ -2218,7 +2243,7 @@ Threads, processes and job synchronization
 
 	Set this job running on specified NUMA nodes' CPUs. The arguments allow
 	comma delimited list of cpu numbers, A-B ranges, or `all`. Note, to enable
-	numa options support, fio must be built on a system with libnuma-dev(el)
+	NUMA options support, fio must be built on a system with libnuma-dev(el)
 	installed.
 
 .. option:: numa_mem_policy=str
@@ -2228,11 +2253,11 @@ Threads, processes and job synchronization
 
 		<mode>[:<nodelist>]
 
-	``mode`` is one of the following memory policy: ``default``, ``prefer``,
-	``bind``, ``interleave``, ``local`` For ``default`` and ``local`` memory
-	policy, no node is needed to be specified.  For ``prefer``, only one node is
-	allowed.  For ``bind`` and ``interleave``, it allow comma delimited list of
-	numbers, A-B ranges, or `all`.
+	``mode`` is one of the following memory poicies: ``default``, ``prefer``,
+	``bind``, ``interleave`` or ``local``. For ``default`` and ``local`` memory
+	policies, no node needs to be specified.  For ``prefer``, only one node is
+	allowed.  For ``bind`` and ``interleave`` the ``nodelist`` may be as
+	follows: a comma delimited list of numbers, A-B ranges, or `all`.
 
 .. option:: cgroup=str
 
@@ -2288,8 +2313,9 @@ Threads, processes and job synchronization
 
 .. option:: exitall
 
-	When one job finishes, terminate the rest. The default is to wait for each
-	job to finish, sometimes that is not the desired action.
+	By default, fio will continue running all other jobs when one job finishes
+	but sometimes this is not the desired action.  Setting ``exitall`` will
+	instead make fio terminate all other jobs when one job finishes.
 
 .. option:: exec_prerun=str
 
@@ -2347,13 +2373,14 @@ Verification
 			header of each block.
 
 		**crc32c**
-			Use a crc32c sum of the data area and store it in the header of each
-			block.
+			Use a crc32c sum of the data area and store it in the header of
+			each block. This will automatically use hardware acceleration
+			(e.g. SSE4.2 on an x86 or CRC crypto extensions on ARM64) but will
+			fall back to software crc32c if none is found. Generally the
+			fatest checksum fio supports when hardware accelerated.
 
 		**crc32c-intel**
-			Use hardware assisted crc32c calculation provided on SSE4.2 enabled
-			processors. Falls back to regular software crc32c, if not supported
-			by the system.
+			Synonym for crc32c.
 
 		**crc32**
 			Use a crc32 sum of the data area and store it in the header of each
@@ -2406,7 +2433,7 @@ Verification
 
 		**null**
 			Only pretend to verify. Useful for testing internals with
-			:option:`ioengine` `=null`, not for much else.
+			:option:`ioengine`\=null, not for much else.
 
 	This option can be used for repeated burn-in tests of a system to make sure
 	that the written data is also correctly read back. If the data direction
@@ -2442,7 +2469,7 @@ Verification
 	If set, fio will fill the I/O buffers with this pattern. Fio defaults to
 	filling with totally random bytes, but sometimes it's interesting to fill
 	with a known pattern for I/O verification purposes. Depending on the width
-	of the pattern, fio will fill 1/2/3/4 bytes of the buffer at the time(it can
+	of the pattern, fio will fill 1/2/3/4 bytes of the buffer at the time (it can
 	be either a decimal or a hex number).  The ``verify_pattern`` if larger than
 	a 32-bit quantity has to be a hex number that starts with either "0x" or
 	"0X". Use with :option:`verify`. Also, ``verify_pattern`` supports %o
@@ -2519,7 +2546,8 @@ Verification
 	If a verify termination trigger was used, fio stores the current write state
 	of each thread. This can be used at verification time so that fio knows how
 	far it should verify.  Without this information, fio will run a full
-	verification pass, according to the settings in the job file used.
+	verification pass, according to the settings in the job file used.  Default
+	false.
 
 .. option:: trim_percentage=int
 
@@ -2527,11 +2555,11 @@ Verification
 
 .. option:: trim_verify_zero=bool
 
-	Verify that trim/discarded blocks are returned as zeroes.
+	Verify that trim/discarded blocks are returned as zeros.
 
 .. option:: trim_backlog=int
 
-	Verify that trim/discarded blocks are returned as zeroes.
+	Verify that trim/discarded blocks are returned as zeros.
 
 .. option:: trim_backlog_batch=int
 
@@ -2582,13 +2610,13 @@ Steady state
 	A rolling window of this duration will be used to judge whether steady state
 	has been reached. Data will be collected once per second. The default is 0
 	which disables steady state detection.  When the unit is omitted, the
-	value is given in seconds.
+	value is interpreted in seconds.
 
 .. option:: steadystate_ramp_time=time, ss_ramp=time
 
 	Allow the job to run for the specified duration before beginning data
 	collection for checking the steady state job termination criterion. The
-	default is 0.  When the unit is omitted, the value is given in seconds.
+	default is 0.  When the unit is omitted, the value is interpreted in seconds.
 
 
 Measurements and reporting
@@ -2627,7 +2655,7 @@ Measurements and reporting
 	If given, write a bandwidth log for this job. Can be used to store data of
 	the bandwidth of the jobs in their lifetime. The included
 	:command:`fio_generate_plots` script uses :command:`gnuplot` to turn these
-	text files into nice graphs. See :option:`write_lat_log` for behaviour of
+	text files into nice graphs. See :option:`write_lat_log` for behavior of
 	given filename. For this option, the postfix is :file:`_bw.x.log`, where `x`
 	is the index of the job (`1..N`, where `N` is the number of jobs). If
 	:option:`per_job_logs` is false, then the filename will not include the job
@@ -2674,6 +2702,7 @@ Measurements and reporting
 	very large size. Setting this option makes fio average the each log entry
 	over the specified period of time, reducing the resolution of the log.  See
 	:option:`log_max_value` as well. Defaults to 0, logging all entries.
+	Also see `Log File Formats`_.
 
 .. option:: log_hist_msec=int
 
@@ -2897,7 +2926,8 @@ Act profile options
 .. option:: test-duration=time
 	:noindex:
 
-	How long the entire test takes to run.  Default: 24h.
+	How long the entire test takes to run.  When the unit is omitted, the value
+	is given in seconds.  Default: 24h.
 
 .. option:: threads-per-queue=int
 	:noindex:
@@ -2950,13 +2980,20 @@ Tiobench profile options
 Interpreting the output
 -----------------------
 
+..
+	Example output was based on the following:
+	TZ=UTC fio --iodepth=8 --ioengine=null --size=100M --time_based \
+		--rate=1256k --bs=14K --name=quick --runtime=1s --name=mixed \
+		--runtime=2m --rw=rw
+
 Fio spits out a lot of output. While running, fio will display the status of the
 jobs created. An example of that would be::
 
     Jobs: 1 (f=1): [_(1),M(1)][24.8%][r=20.5MiB/s,w=23.5MiB/s][r=82,w=94 IOPS][eta 01m:31s]
 
-The characters inside the square brackets denote the current status of each
-thread. The possible values (in typical life cycle order) are:
+The characters inside the first set of square brackets denote the current status of
+each thread.  The first character is the first job defined in the job file, and so
+forth.  The possible values (in typical life cycle order) are:
 
 +------+-----+-----------------------------------------------------------+
 | Idle | Run |                                                           |
@@ -2969,6 +3006,8 @@ thread. The possible values (in typical life cycle order) are:
 +------+-----+-----------------------------------------------------------+
 |      |  p  | Thread running pre-reading file(s).                       |
 +------+-----+-----------------------------------------------------------+
+|      |  /  | Thread is in ramp period.                                 |
++------+-----+-----------------------------------------------------------+
 |      |  R  | Running, doing sequential reads.                          |
 +------+-----+-----------------------------------------------------------+
 |      |  r  | Running, doing random reads.                              |
@@ -2981,77 +3020,103 @@ thread. The possible values (in typical life cycle order) are:
 +------+-----+-----------------------------------------------------------+
 |      |  m  | Running, doing mixed random reads/writes.                 |
 +------+-----+-----------------------------------------------------------+
-|      |  F  | Running, currently waiting for :manpage:`fsync(2)`        |
+|      |  D  | Running, doing sequential trims.                          |
++------+-----+-----------------------------------------------------------+
+|      |  d  | Running, doing random trims.                              |
++------+-----+-----------------------------------------------------------+
+|      |  F  | Running, currently waiting for :manpage:`fsync(2)`.       |
 +------+-----+-----------------------------------------------------------+
 |      |  V  | Running, doing verification of written data.              |
 +------+-----+-----------------------------------------------------------+
+| f    |     | Thread finishing.                                         |
++------+-----+-----------------------------------------------------------+
 | E    |     | Thread exited, not reaped by main thread yet.             |
 +------+-----+-----------------------------------------------------------+
-| _    |     | Thread reaped, or                                         |
+| _    |     | Thread reaped.                                            |
 +------+-----+-----------------------------------------------------------+
 | X    |     | Thread reaped, exited with an error.                      |
 +------+-----+-----------------------------------------------------------+
 | K    |     | Thread reaped, exited due to signal.                      |
 +------+-----+-----------------------------------------------------------+
 
+..
+	Example output was based on the following:
+	TZ=UTC fio --iodepth=8 --ioengine=null --size=100M --runtime=58m \
+		--time_based --rate=2512k --bs=256K --numjobs=10 \
+		--name=readers --rw=read --name=writers --rw=write
+
 Fio will condense the thread string as not to take up more space on the command
-line as is needed. For instance, if you have 10 readers and 10 writers running,
+line than needed. For instance, if you have 10 readers and 10 writers running,
 the output would look like this::
 
     Jobs: 20 (f=20): [R(10),W(10)][4.0%][r=20.5MiB/s,w=23.5MiB/s][r=82,w=94 IOPS][eta 57m:36s]
 
-Fio will still maintain the ordering, though. So the above means that jobs 1..10
-are readers, and 11..20 are writers.
+Note that the status string is displayed in order, so it's possible to tell which of
+the jobs are currently doing what.  In the example above this means that jobs 1--10
+are readers and 11--20 are writers.
 
 The other values are fairly self explanatory -- number of threads currently
-running and doing I/O, the number of currently open files (f=), the rate of I/O
-since last check (read speed listed first, then write speed and optionally trim
-speed), and the estimated completion percentage and time for the current
+running and doing I/O, the number of currently open files (f=), the estimated
+completion percentage, the rate of I/O since last check (read speed listed first,
+then write speed and optionally trim speed) in terms of bandwidth and IOPS, and time to completion for the current
 running group. It's impossible to estimate runtime of the following groups (if
-any). Note that the string is displayed in order, so it's possible to tell which
-of the jobs are currently doing what. The first character is the first job
-defined in the job file, and so forth.
-
-When fio is done (or interrupted by :kbd:`ctrl-c`), it will show the data for
-each thread, group of threads, and disks in that order. For each data direction,
-the output looks like::
-
-    Client1 (g=0): err= 0:
-      write: io=    32MiB, bw=   666KiB/s, iops=89 , runt= 50320msec
-        slat (msec): min=    0, max=  136, avg= 0.03, stdev= 1.92
-        clat (msec): min=    0, max=  631, avg=48.50, stdev=86.82
-        bw (KiB/s) : min=    0, max= 1196, per=51.00%, avg=664.02, stdev=681.68
-      cpu        : usr=1.49%, sys=0.25%, ctx=7969, majf=0, minf=17
-      IO depths    : 1=0.1%, 2=0.3%, 4=0.5%, 8=99.0%, 16=0.0%, 32=0.0%, >32=0.0%
-         submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
-         complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
-         issued r/w: total=0/32768, short=0/0
-         lat (msec): 2=1.6%, 4=0.0%, 10=3.2%, 20=12.8%, 50=38.4%, 100=24.8%,
-         lat (msec): 250=15.2%, 500=0.0%, 750=0.0%, 1000=0.0%, >=2048=0.0%
-
-The client number is printed, along with the group id and error of that
-thread. Below is the I/O statistics, here for writes. In the order listed, they
-denote:
-
-**io**
-		Number of megabytes I/O performed.
-
-**bw**
-		Average bandwidth rate.
-
-**iops**
-		Average I/Os performed per second.
-
-**runt**
-		The runtime of that thread.
+any).
+
+..
+	Example output was based on the following:
+	TZ=UTC fio --iodepth=16 --ioengine=posixaio --filename=/tmp/fiofile \
+		--direct=1 --size=100M --time_based --runtime=50s --rate_iops=89 \
+		--bs=7K --name=Client1 --rw=write
+
+When fio is done (or interrupted by :kbd:`Ctrl-C`), it will show the data for
+each thread, group of threads, and disks in that order. For each overall thread (or
+group) the output looks like::
+
+	Client1: (groupid=0, jobs=1): err= 0: pid=16109: Sat Jun 24 12:07:54 2017
+	  write: IOPS=88, BW=623KiB/s (638kB/s)(30.4MiB/50032msec)
+	    slat (nsec): min=500, max=145500, avg=8318.00, stdev=4781.50
+	    clat (usec): min=170, max=78367, avg=4019.02, stdev=8293.31
+	     lat (usec): min=174, max=78375, avg=4027.34, stdev=8291.79
+	    clat percentiles (usec):
+	     |  1.00th=[  302],  5.00th=[  326], 10.00th=[  343], 20.00th=[  363],
+	     | 30.00th=[  392], 40.00th=[  404], 50.00th=[  416], 60.00th=[  445],
+	     | 70.00th=[  816], 80.00th=[ 6718], 90.00th=[12911], 95.00th=[21627],
+	     | 99.00th=[43779], 99.50th=[51643], 99.90th=[68682], 99.95th=[72877],
+	     | 99.99th=[78119]
+	   bw (  KiB/s): min=  532, max=  686, per=0.10%, avg=622.87, stdev=24.82, samples=  100
+	   iops        : min=   76, max=   98, avg=88.98, stdev= 3.54, samples=  100
+	    lat (usec) : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+	    lat (msec) : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+	    lat (msec) : 100=0.65%
+	  cpu          : usr=0.27%, sys=0.18%, ctx=12072, majf=0, minf=21
+	  IO depths    : 1=85.0%, 2=13.1%, 4=1.8%, 8=0.1%, 16=0.0%, 32=0.0%, >=64=0.0%
+	     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
+	     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
+	     issued rwt: total=0,4450,0, short=0,0,0, dropped=0,0,0
+	     latency   : target=0, window=0, percentile=100.00%, depth=8
+
+The job name (or first job's name when using :option:`group_reporting`) is printed,
+along with the group id, count of jobs being aggregated, last error id seen (which
+is 0 when there are no errors), pid/tid of that thread and the time the job/group
+completed.  Below are the I/O statistics for each data direction performed (showing
+writes in the example above).  In the order listed, they denote:
+
+**read/write/trim**
+		The string before the colon shows the I/O direction the statistics
+		are for.  **IOPS** is the average I/Os performed per second.  **BW**
+		is the average bandwidth rate shown as: value in power of 2 format
+		(value in power of 10 format).  The last two values show: (**total
+		I/O performed** in power of 2 format / **runtime** of that thread).
 
 **slat**
-		Submission latency (avg being the average, stdev being the standard
-		deviation). This is the time it took to submit the I/O. For sync I/O,
-		the slat is really the completion latency, since queue/complete is one
-		operation there. This value can be in milliseconds or microseconds, fio
-		will choose the most appropriate base and print that. In the example
-		above, milliseconds is the best scale. Note: in :option:`--minimal` mode
+		Submission latency (**min** being the minimum, **max** being the
+		maximum, **avg** being the average, **stdev** being the standard
+		deviation).  This is the time it took to submit the I/O.  For
+		sync I/O this row is not displayed as the slat is really the
+		completion latency (since queue/complete is one operation there).
+		This value can be in nanoseconds, microseconds or milliseconds ---
+		fio will choose the most appropriate base and print that (in the
+		example above nanoseconds was the best scale).  Note: in :option:`--minimal` mode
 		latencies are always expressed in microseconds.
 
 **clat**
@@ -3062,11 +3127,15 @@ denote:
 		explanation).
 
 **bw**
-		Bandwidth. Same names as the xlat stats, but also includes an
-		approximate percentage of total aggregate bandwidth this thread received
-		in this group. This last value is only really useful if the threads in
-		this group are on the same disk, since they are then competing for disk
-		access.
+		Bandwidth statistics based on samples. Same names as the xlat stats,
+		but also includes the number of samples taken (**samples**) and an
+		approximate percentage of total aggregate bandwidth this thread
+		received in its group (**per**). This last value is only really
+		useful if the threads in this group are on the same disk, since they
+		are then competing for disk access.
+
+**iops**
+		IOPS statistics based on samples. Same names as bw.
 
 **cpu**
 		CPU usage. User and system time, along with the number of context
@@ -3076,23 +3145,27 @@ denote:
 		context and fault counters are summed.
 
 **IO depths**
-		The distribution of I/O depths over the job life time. The numbers are
-		divided into powers of 2, so for example the 16= entries includes depths
-		up to that value but higher than the previous entry. In other words, it
-		covers the range from 16 to 31.
+		The distribution of I/O depths over the job lifetime.  The numbers are
+		divided into powers of 2 and each entry covers depths from that value
+		up to those that are lower than the next entry -- e.g., 16= covers
+		depths from 16 to 31.  Note that the range covered by a depth
+		distribution entry can be different to the range covered by the
+		equivalent submit/complete distribution entry.
 
 **IO submit**
 		How many pieces of I/O were submitting in a single submit call. Each
 		entry denotes that amount and below, until the previous entry -- e.g.,
-		8=100% mean that we submitted anywhere in between 5-8 I/Os per submit
-		call.
+		16=100% means that we submitted anywhere between 9 to 16 I/Os per submit
+		call.  Note that the range covered by a submit distribution entry can
+		be different to the range covered by the equivalent depth distribution
+		entry.
 
 **IO complete**
 		Like the above submit number, but for completions instead.
 
-**IO issued**
-		The number of read/write requests issued, and how many of them were
-		short.
+**IO issued rwt**
+		The number of read/write/trim requests issued, and how many of them were
+		short or dropped.
 
 **IO latencies**
 		The distribution of I/O completion latencies. This is the time from when
@@ -3101,27 +3174,31 @@ denote:
 		I/O completed within 2 msecs, 20=12.8% means that 12.8% of the I/O took
 		more than 10 msecs, but less than (or equal to) 20 msecs.
 
+..
+	Example output was based on the following:
+	TZ=UTC fio --ioengine=null --iodepth=2 --size=100M --numjobs=2 \
+		--rate_process=poisson --io_limit=32M --name=read --bs=128k \
+		--rate=11M --name=write --rw=write --bs=2k --rate=700k
+
 After each client has been listed, the group statistics are printed. They
 will look like this::
 
     Run status group 0 (all jobs):
-       READ: io=64MB, aggrb=22178, minb=11355, maxb=11814, mint=2840msec, maxt=2955msec
-      WRITE: io=64MB, aggrb=1302, minb=666, maxb=669, mint=50093msec, maxt=50320msec
+       READ: bw=20.9MiB/s (21.9MB/s), 10.4MiB/s-10.8MiB/s (10.9MB/s-11.3MB/s), io=64.0MiB (67.1MB), run=2973-3069msec
+      WRITE: bw=1231KiB/s (1261kB/s), 616KiB/s-621KiB/s (630kB/s-636kB/s), io=64.0MiB (67.1MB), run=52747-53223msec
 
-For each data direction, it prints:
+For each data direction it prints:
 
+**bw**
+		Aggregate bandwidth of threads in this group followed by the
+		minimum and maximum bandwidth of all the threads in this group.
+		Values outside of brackets are power-of-2 format and those
+		within are the equivalent value in a power-of-10 format.
 **io**
-		Number of megabytes I/O performed.
-**aggrb**
-		Aggregate bandwidth of threads in this group.
-**minb**
-		The minimum average bandwidth a thread saw.
-**maxb**
-		The maximum average bandwidth a thread saw.
-**mint**
-		The smallest runtime of the threads in that group.
-**maxt**
-		The longest runtime of the threads in that group.
+		Aggregate I/O performed of all threads in this group. The
+		format is the same as bw.
+**run**
+		The smallest and longest runtimes of the threads in this group.
 
 And finally, the disk statistics are printed. They will look like this::
 
@@ -3137,7 +3214,7 @@ numbers denote:
 		Number of merges I/O the I/O scheduler.
 **ticks**
 		Number of ticks we kept the disk busy.
-**io_queue**
+**in_queue**
 		Total time spent in the disk queue.
 **util**
 		The disk utilization. A value of 100% means we kept the disk
@@ -3163,7 +3240,8 @@ is one long line of values, such as::
 
 The job description (if provided) follows on a second line.
 
-To enable terse output, use the :option:`--minimal` command line option. The
+To enable terse output, use the :option:`--minimal` or
+:option:`--output-format`\=terse command line options. The
 first value is the version of the terse output format. If the output has to be
 changed for some reason, this number will be incremented by 1 to signify that
 change.
@@ -3243,9 +3321,9 @@ For disk utilization, all disks used by fio are shown. So for each disk there
 will be a disk utilization section.
 
 Below is a single line containing short names for each of the fields in the
-minimal output v3, separated by semicolons:
+minimal output v3, separated by semicolons::
 
-terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+	terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10
 ;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
 
 
 Trace file format
@@ -3267,7 +3345,7 @@ Each line represents a single I/O action in the following format::
 
 where `rw=0/1` for read/write, and the offset and length entries being in bytes.
 
-This format is not supported in fio versions => 1.20-rc3.
+This format is not supported in fio versions >= 1.20-rc3.
 
 
 Trace file format v2
@@ -3364,7 +3442,7 @@ completions, etc.
 
 A trigger is invoked either through creation ('touch') of a specified file in
 the system, or through a timeout setting. If fio is run with
-:option:`--trigger-file` = :file:`/tmp/trigger-file`, then it will continually
+:option:`--trigger-file`\= :file:`/tmp/trigger-file`, then it will continually
 check for the existence of :file:`/tmp/trigger-file`. When it sees this file, it
 will fire off the trigger (thus saving state, and executing the trigger
 command).
@@ -3378,7 +3456,7 @@ will then execute the trigger.
 Verification trigger example
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-Lets say we want to run a powercut test on the remote machine 'server'.  Our
+Let's say we want to run a powercut test on the remote machine 'server'.  Our
 write workload is in :file:`write-test.fio`. We want to cut power to 'server' at
 some point during the run, and we'll run this test from the safety or our local
 machine, 'localbox'. On the server, we'll start the fio backend normally::
@@ -3397,7 +3475,7 @@ on the server once it has received the trigger and sent us the write state. This
 will work, but it's not **really** cutting power to the server, it's merely
 abruptly rebooting it. If we have a remote way of cutting power to the server
 through IPMI or similar, we could do that through a local trigger command
-instead. Lets assume we have a script that does IPMI reboot of a given hostname,
+instead. Let's assume we have a script that does IPMI reboot of a given hostname,
 ipmi-reboot. On localbox, we could then have run fio with a local trigger
 instead::
 
@@ -3409,7 +3487,7 @@ execute ``ipmi-reboot server`` when that happened.
 Loading verify state
 ~~~~~~~~~~~~~~~~~~~~
 
-To load store write state, read verification job file must contain the
+To load stored write state, a read verification job file must contain the
 :option:`verify_state_load` option. If that is set, fio will load the previously
 stored state. For a local fio run this is done by loading the files directly,
 and on a client/server run, the server backend will ask the client to send the
@@ -3447,27 +3525,26 @@ The *offset* is the offset, in bytes, from the start of the file, for that
 particular I/O. The logging of the offset can be toggled with
 :option:`log_offset`.
 
-If windowed logging is enabled through :option:`log_avg_msec` then fio doesn't
-log individual I/Os. Instead of logs the average values over the specified period
-of time. Since 'data direction' and 'offset' are per-I/O values, they aren't
-applicable if windowed logging is enabled. If windowed logging is enabled and
-:option:`log_max_value` is set, then fio logs maximum values in that window
-instead of averages.
-
+Fio defaults to logging every individual I/O.  When IOPS are logged for individual
+I/Os the value entry will always be 1.  If windowed logging is enabled through
+:option:`log_avg_msec`, fio logs the average values over the specified period of time.
+If windowed logging is enabled and :option:`log_max_value` is set, then fio logs
+maximum values in that window instead of averages.  Since 'data direction' and
+'offset' are per-I/O values, they aren't applicable if windowed logging is enabled.
 
 Client/server
 -------------
 
 Normally fio is invoked as a stand-alone application on the machine where the
-I/O workload should be generated. However, the frontend and backend of fio can
-be run separately. Ie the fio server can generate an I/O workload on the "Device
-Under Test" while being controlled from another machine.
+I/O workload should be generated. However, the backend and frontend of fio can
+be run separately i.e., the fio server can generate an I/O workload on the "Device
+Under Test" while being controlled by a client on another machine.
 
 Start the server on the machine which has access to the storage DUT::
 
 	fio --server=args
 
-where args defines what fio listens to. The arguments are of the form
+where `args` defines what fio listens to. The arguments are of the form
 ``type,hostname`` or ``IP,port``. *type* is either ``ip`` (or ip4) for TCP/IP
 v4, ``ip6`` for TCP/IP v6, or ``sock`` for a local unix domain socket.
 *hostname* is either a hostname or IP address, and *port* is the port to listen
@@ -3495,7 +3572,7 @@ to (only valid for TCP/IP, not a local socket). Some examples:
 
 6) ``fio --server=sock:/tmp/fio.sock``
 
-   Start a fio server, listening on the local socket /tmp/fio.sock.
+   Start a fio server, listening on the local socket :file:`/tmp/fio.sock`.
 
 Once a server is running, a "client" can connect to the fio server with::
 
@@ -3535,7 +3612,7 @@ servers receive the same job file.
 
 In order to let ``fio --client`` runs use a shared filesystem from multiple
 hosts, ``fio --client`` now prepends the IP address of the server to the
-filename.  For example, if fio is using directory :file:`/mnt/nfs/fio` and is
+filename.  For example, if fio is using the directory :file:`/mnt/nfs/fio` and is
 writing filename :file:`fileio.tmp`, with a :option:`--client` `hostfile`
 containing two hostnames ``h1`` and ``h2`` with IP addresses 192.168.10.120 and
 192.168.10.121, then fio will create two files::
diff --git a/README b/README
index 6bff82b..ec3e9c0 100644
--- a/README
+++ b/README
@@ -102,7 +102,7 @@ Ubuntu:
 Red Hat, Fedora, CentOS & Co:
 	Starting with Fedora 9/Extra Packages for Enterprise Linux 4, fio
 	packages are part of the Fedora/EPEL repositories.
-	https://admin.fedoraproject.org/pkgdb/package/rpms/fio/ .
+	https://apps.fedoraproject.org/packages/fio .
 
 Mandriva:
 	Mandriva has integrated fio into their package repository, so installing
diff --git a/examples/mtd.fio b/examples/mtd.fio
index ca09735..e5dcea4 100644
--- a/examples/mtd.fio
+++ b/examples/mtd.fio
@@ -17,5 +17,5 @@ rw=write
 [write]
 stonewall
 block_error_percentiles=1
-rw=writetrim
+rw=trimwrite
 loops=4
diff --git a/init.c b/init.c
index 934b9d7..a4b5adb 100644
--- a/init.c
+++ b/init.c
@@ -2022,7 +2022,7 @@ static void usage(const char *name)
 	printf("  --version\t\tPrint version info and exit\n");
 	printf("  --help\t\tPrint this page\n");
 	printf("  --cpuclock-test\tPerform test/validation of CPU clock\n");
-	printf("  --crctest=type\tTest speed of checksum functions\n");
+	printf("  --crctest=[type]\tTest speed of checksum functions\n");
 	printf("  --cmdhelp=cmd\t\tPrint command help, \"all\" for all of"
 		" them\n");
 	printf("  --enghelp=engine\tPrint ioengine help, or list"
diff --git a/stat.c b/stat.c
index b3b2cb3..beec574 100644
--- a/stat.c
+++ b/stat.c
@@ -483,7 +483,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		}
 
 		if (rs->agg[ddir]) {
-			p_of_agg = mean * 100 / (double) rs->agg[ddir];
+			p_of_agg = mean * 100 / (double) (rs->agg[ddir] / 1024);
 			if (p_of_agg > 100.0)
 				p_of_agg = 100.0;
 		}
@@ -497,13 +497,13 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 		}
 
 		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
-			"avg=%5.02f, stdev=%5.02f, samples=%5lu\n",
+			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
 			bw_str, min, max, p_of_agg, mean, dev,
 			(&ts->bw_stat[ddir])->samples);
 	}
 	if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev)) {
-		log_buf(out, "   iops : min=%5llu, max=%5llu, avg=%5.02f, "
-			"stdev=%5.02f, samples=%5lu\n",
+		log_buf(out, "   iops        : min=%5llu, max=%5llu, "
+			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
 			min, max, mean, dev, (&ts->iops_stat[ddir])->samples);
 	}
 }
@@ -935,12 +935,12 @@ static void show_ddir_status_terse(struct thread_stat *ts,
 
 	if (ver == 5) {
 		if (bw_stat)
-			log_buf(out, ";%lu", (&ts->bw_stat[ddir])->samples);
+			log_buf(out, ";%" PRIu64, (&ts->bw_stat[ddir])->samples);
 		else
 			log_buf(out, ";%lu", 0UL);
 
 		if (calc_lat(&ts->iops_stat[ddir], &min, &max, &mean, &dev))
-			log_buf(out, ";%llu;%llu;%f;%f;%lu", min, max,
+			log_buf(out, ";%llu;%llu;%f;%f;%" PRIu64, min, max,
 				mean, dev, (&ts->iops_stat[ddir])->samples);
 		else
 			log_buf(out, ";%llu;%llu;%f;%f;%lu", 0ULL, 0ULL, 0.0, 0.0, 0UL);
