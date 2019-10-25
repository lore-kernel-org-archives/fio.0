Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37286 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393497AbfJYMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 25 Oct 2019 08:00:07 -0400
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNyGC-00038o-A7
        for fio@vger.kernel.org; Fri, 25 Oct 2019 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20191025120002.174822C00F5@kernel.dk>
Date: Fri, 25 Oct 2019 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit f6830780c2022a607b252191d4a5a1c6804e7513:

  Merge branch 'android-log-fix' of https://github.com/kdrag0n/fio (2019-10-21 08:46:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c656b9056e45f9acd1d374a85c5becf7cc6a00ca:

  Merge branch 'doc_fixes' of https://github.com/sitsofe/fio (2019-10-24 12:04:09 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'doc_fixes' of https://github.com/sitsofe/fio

Sitsofe Wheeler (2):
      man: don't use non-breaking minuses when they're not necessary
      doc: delete repeated word "will"

 HOWTO |   2 +-
 fio.1 | 138 +++++++++++++++++++++++++++++++++---------------------------------
 2 files changed, 70 insertions(+), 70 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 96a047de..64c6a033 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2713,7 +2713,7 @@ Threads, processes and job synchronization
 			Each job will get a unique CPU from the CPU set.
 
 	**shared** is the default behavior, if the option isn't specified. If
-	**split** is specified, then fio will will assign one cpu per job. If not
+	**split** is specified, then fio will assign one cpu per job. If not
 	enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
 	in the set.
 
diff --git a/fio.1 b/fio.1
index 6685e507..087d3778 100644
--- a/fio.1
+++ b/fio.1
@@ -255,7 +255,7 @@ default unit is bytes. For quantities of time, the default unit is seconds
 unless otherwise specified.
 .P
 With `kb_base=1000', fio follows international standards for unit
-prefixes. To specify power\-of\-10 decimal values defined in the
+prefixes. To specify power-of-10 decimal values defined in the
 International System of Units (SI):
 .RS
 .P
@@ -272,7 +272,7 @@ P means peta (P) or 1000**5
 .PD
 .RE
 .P
-To specify power\-of\-2 binary values defined in IEC 80000\-13:
+To specify power-of-2 binary values defined in IEC 80000-13:
 .RS
 .P
 .PD 0
@@ -289,7 +289,7 @@ Pi means pebi (Pi) or 1024**5
 .RE
 .P
 With `kb_base=1024' (the default), the unit prefixes are opposite
-from those specified in the SI and IEC 80000\-13 standards to provide
+from those specified in the SI and IEC 80000-13 standards to provide
 compatibility with old scripts. For example, 4k means 4096.
 .P
 For quantities of data, an optional unit of 'B' may be included
@@ -376,14 +376,14 @@ Select the interpretation of unit prefixes in input parameters.
 .RS
 .TP
 .B 1000
-Inputs comply with IEC 80000\-13 and the International
+Inputs comply with IEC 80000-13 and the International
 System of Units (SI). Use:
 .RS
 .P
 .PD 0
-\- power\-of\-2 values with IEC prefixes (e.g., KiB)
+\- power-of-2 values with IEC prefixes (e.g., KiB)
 .P
-\- power\-of\-10 values with SI prefixes (e.g., kB)
+\- power-of-10 values with SI prefixes (e.g., kB)
 .PD
 .RE
 .TP
@@ -392,9 +392,9 @@ Compatibility mode (default). To avoid breaking old scripts:
 .P
 .RS
 .PD 0
-\- power\-of\-2 values with SI prefixes
+\- power-of-2 values with SI prefixes
 .P
-\- power\-of\-10 values with IEC prefixes
+\- power-of-10 values with IEC prefixes
 .PD
 .RE
 .RE
@@ -402,7 +402,7 @@ Compatibility mode (default). To avoid breaking old scripts:
 See \fBbs\fR for more details on input parameters.
 .P
 Outputs always use correct prefixes. Most outputs include both
-side\-by\-side, like:
+side-by-side, like:
 .P
 .RS
 bw=2383.3kB/s (2327.4KiB/s)
@@ -425,7 +425,7 @@ Base unit for reporting. Allowed values are:
 .RS
 .TP
 .B 0
-Use auto\-detection (default).
+Use auto-detection (default).
 .TP
 .B 8
 Byte based.
@@ -565,7 +565,7 @@ would use `filename=/dev/dsk/foo@3,0\\:c' and if the path is
 On Windows, disk devices are accessed as `\\\\.\\PhysicalDrive0' for
 the first device, `\\\\.\\PhysicalDrive1' for the second etc.
 Note: Windows and FreeBSD prevent write access to areas
-of the disk containing in\-use data (e.g. filesystems).
+of the disk containing in-use data (e.g. filesystems).
 .P
 The filename `\-' is a reserved name, meaning *stdin* or *stdout*. Which
 of the two depends on the read/write direction set.
@@ -676,7 +676,7 @@ Alias for normal.
 For \fBrandom\fR, \fBroundrobin\fR, and \fBsequential\fR, a postfix can be appended to
 tell fio how many I/Os to issue before switching to a new file. For example,
 specifying `file_service_type=random:8' would cause fio to issue
-8 I/Os before selecting a new file at random. For the non\-uniform
+8 I/Os before selecting a new file at random. For the non-uniform
 distributions, a floating point postfix can be given to influence how the
 distribution is skewed. See \fBrandom_distribution\fR for a description
 of how that would work.
@@ -695,8 +695,8 @@ used and even the number of processors in the system. Default: true.
 \fBfsync\fR\|(2) the data file after creation. This is the default.
 .TP
 .BI create_on_open \fR=\fPbool
-If true, don't pre\-create files but allow the job's open() to create a file
-when it's time to do I/O. Default: false \-\- pre\-create all necessary files
+If true, don't pre-create files but allow the job's open() to create a file
+when it's time to do I/O. Default: false \-\- pre-create all necessary files
 when the job starts.
 .TP
 .BI create_only \fR=\fPbool
@@ -717,11 +717,11 @@ destroy data on the mounted file system. Note that some platforms don't allow
 writing against a mounted device regardless of this option. Default: false.
 .TP
 .BI pre_read \fR=\fPbool
-If this is given, files will be pre\-read into memory before starting the
+If this is given, files will be pre-read into memory before starting the
 given I/O operation. This will also clear the \fBinvalidate\fR flag,
-since it is pointless to pre\-read and then drop the cache. This will only
-work for I/O engines that are seek\-able, since they allow you to read the
-same data multiple times. Thus it will not work on non\-seekable I/O engines
+since it is pointless to pre-read and then drop the cache. This will only
+work for I/O engines that are seek-able, since they allow you to read the
+same data multiple times. Thus it will not work on non-seekable I/O engines
 (e.g. network, splice). Default: false.
 .TP
 .BI unlink \fR=\fPbool
@@ -820,7 +820,7 @@ previous parameter can be used to simulate garbage collection activity.
 .SS "I/O type"
 .TP
 .BI direct \fR=\fPbool
-If value is true, use non\-buffered I/O. This is usually O_DIRECT. Note that
+If value is true, use non-buffered I/O. This is usually O_DIRECT. Note that
 OpenBSD and ZFS on Solaris don't support direct I/O. On Windows the synchronous
 ioengines don't support direct I/O. Default: false.
 .TP
@@ -924,36 +924,36 @@ control what sequence of output is being generated. If not set, the random
 sequence depends on the \fBrandrepeat\fR setting.
 .TP
 .BI fallocate \fR=\fPstr
-Whether pre\-allocation is performed when laying down files.
+Whether pre-allocation is performed when laying down files.
 Accepted values are:
 .RS
 .RS
 .TP
 .B none
-Do not pre\-allocate space.
+Do not pre-allocate space.
 .TP
 .B native
-Use a platform's native pre\-allocation call but fall back to
+Use a platform's native pre-allocation call but fall back to
 \fBnone\fR behavior if it fails/is not implemented.
 .TP
 .B posix
-Pre\-allocate via \fBposix_fallocate\fR\|(3).
+Pre-allocate via \fBposix_fallocate\fR\|(3).
 .TP
 .B keep
-Pre\-allocate via \fBfallocate\fR\|(2) with
+Pre-allocate via \fBfallocate\fR\|(2) with
 FALLOC_FL_KEEP_SIZE set.
 .TP
 .B 0
-Backward\-compatible alias for \fBnone\fR.
+Backward-compatible alias for \fBnone\fR.
 .TP
 .B 1
-Backward\-compatible alias for \fBposix\fR.
+Backward-compatible alias for \fBposix\fR.
 .RE
 .P
 May not be available on all supported platforms. \fBkeep\fR is only available
 on Linux. If using ZFS on Solaris this cannot be set to \fBposix\fR
-because ZFS doesn't support pre\-allocation. Default: \fBnative\fR if any
-pre\-allocation methods are available, \fBnone\fR if not.
+because ZFS doesn't support pre-allocation. Default: \fBnative\fR if any
+pre-allocation methods are available, \fBnone\fR if not.
 .RE
 .TP
 .BI fadvise_hint \fR=\fPstr
@@ -1023,7 +1023,7 @@ offset is aligned to the minimum block size.
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes `\fBoffset\fR + \fBoffset_increment\fR
 * thread_number', where the thread number is a counter that starts at 0 and
-is incremented for each sub\-job (i.e. when \fBnumjobs\fR option is
+is incremented for each sub-job (i.e. when \fBnumjobs\fR option is
 specified). This option is useful if there are several jobs which are
 intended to operate on a file in parallel disjoint segments, with even
 spacing between the starting points. Percentages can be used for this option.
@@ -1037,13 +1037,13 @@ condition). With this setting, the range/size can be set independently of
 the number of I/Os to perform. When fio reaches this number, it will exit
 normally and report status. Note that this does not extend the amount of I/O
 that will be done, it will only stop fio if this condition is met before
-other end\-of\-job criteria.
+other end-of-job criteria.
 .TP
 .BI fsync \fR=\fPint
 If writing to a file, issue an \fBfsync\fR\|(2) (or its equivalent) of
 the dirty data for every number of blocks given. For example, if you give 32
 as a parameter, fio will sync the file after every 32 writes issued. If fio is
-using non\-buffered I/O, we may not sync the file. The exception is the sg
+using non-buffered I/O, we may not sync the file. The exception is the sg
 I/O engine, which synchronizes the disk cache anyway. Defaults to 0, which
 means fio does not periodically issue and wait for a sync to complete. Also
 see \fBend_fsync\fR and \fBfsync_on_close\fR.
@@ -1053,7 +1053,7 @@ Like \fBfsync\fR but uses \fBfdatasync\fR\|(2) to only sync data and
 not metadata blocks. In Windows, FreeBSD, DragonFlyBSD or OSX there is no
 \fBfdatasync\fR\|(2) so this falls back to using \fBfsync\fR\|(2).
 Defaults to 0, which means fio does not periodically issue and wait for a
-data\-only sync to complete.
+data-only sync to complete.
 .TP
 .BI write_barrier \fR=\fPint
 Make every N\-th write a barrier write.
@@ -1200,7 +1200,7 @@ For a random workload, set how big a percentage should be random. This
 defaults to 100%, in which case the workload is fully random. It can be set
 from anywhere from 0 to 100. Setting it to 0 would make the workload fully
 sequential. Any setting in between will result in a random mix of sequential
-and random I/O, at the given percentages. Comma\-separated values may be
+and random I/O, at the given percentages. Comma-separated values may be
 specified for reads, writes, and trims as described in \fBblocksize\fR.
 .TP
 .BI norandommap
@@ -1209,7 +1209,7 @@ this option is given, fio will just get a new random offset without looking
 at past I/O history. This means that some blocks may not be read or written,
 and that some blocks may be read/written more than once. If this option is
 used with \fBverify\fR and multiple blocksizes (via \fBbsrange\fR),
-only intact blocks are verified, i.e., partially\-overwritten blocks are
+only intact blocks are verified, i.e., partially-overwritten blocks are
 ignored.  With an async I/O engine and an I/O depth > 1, it is possible for
 the same block to be overwritten, which can cause verification errors.  Either
 do not use norandommap in this case, or also use the lfsr random generator.
@@ -1250,7 +1250,7 @@ selected automatically.
 .TP
 .BI blocksize \fR=\fPint[,int][,int] "\fR,\fB bs" \fR=\fPint[,int][,int]
 The block size in bytes used for I/O units. Default: 4096. A single value
-applies to reads, writes, and trims. Comma\-separated values may be
+applies to reads, writes, and trims. Comma-separated values may be
 specified for reads, writes, and trims. A value not terminated in a comma
 applies to subsequent types. Examples:
 .RS
@@ -1274,7 +1274,7 @@ bs=,8k,        means default for reads, 8k for writes, and default for trims.
 A range of block sizes in bytes for I/O units. The issued I/O unit will
 always be a multiple of the minimum size, unless
 \fBblocksize_unaligned\fR is set.
-Comma\-separated ranges may be specified for reads, writes, and trims as
+Comma-separated ranges may be specified for reads, writes, and trims as
 described in \fBblocksize\fR. Example:
 .RS
 .RS
@@ -1311,7 +1311,7 @@ bssplit=4k/50:1k/:32k/
 would have 50% 4k ios, and 25% 1k and 32k ios. The percentages always add up
 to 100, if bssplit is given a range that adds up to more, it will error out.
 .P
-Comma\-separated values may be specified for reads, writes, and trims as
+Comma-separated values may be specified for reads, writes, and trims as
 described in \fBblocksize\fR.
 .P
 If you want a workload that has 50% 2k reads and 50% 4k reads, while having
@@ -1341,7 +1341,7 @@ Boundary to which fio will align random I/O units. Default:
 \fBblocksize\fR. Minimum alignment is typically 512b for using direct
 I/O, though it usually depends on the hardware block size. This option is
 mutually exclusive with using a random map for files, so it will turn off
-that option. Comma\-separated values may be specified for reads, writes, and
+that option. Comma-separated values may be specified for reads, writes, and
 trims as described in \fBblocksize\fR.
 .SS "Buffers and memory"
 .TP
@@ -1357,7 +1357,7 @@ verification is enabled, \fBrefill_buffers\fR is also automatically enabled.
 .BI scramble_buffers \fR=\fPbool
 If \fBrefill_buffers\fR is too costly and the target is using data
 deduplication, then setting this option will slightly modify the I/O buffer
-contents to defeat normal de\-dupe attempts. This is not enough to defeat
+contents to defeat normal de-dupe attempts. This is not enough to defeat
 more clever block compression attempts, but it will stop naive dedupe of
 blocks. Default: true.
 .TP
@@ -1482,7 +1482,7 @@ is 4MiB in size. So to calculate the number of huge pages you need for a
 given job file, add up the I/O depth of all jobs (normally one unless
 \fBiodepth\fR is used) and multiply by the maximum bs set. Then divide
 that number by the huge page size. You can see the size of the huge pages in
-`/proc/meminfo'. If no huge pages are allocated by having a non\-zero
+`/proc/meminfo'. If no huge pages are allocated by having a non-zero
 number in `nr_hugepages', using \fBmmaphuge\fR or \fBshmhuge\fR will fail. Also
 see \fBhugepage\-size\fR.
 .P
@@ -1505,7 +1505,7 @@ of subsequent I/O memory buffers is the sum of the \fBiomem_align\fR and
 Defines the size of a huge page. Must at least be equal to the system
 setting, see `/proc/meminfo'. Defaults to 4MiB. Should probably
 always be a multiple of megabytes, so using `hugepage\-size=Xm' is the
-preferred way to set this to avoid setting a non\-pow\-2 bad value.
+preferred way to set this to avoid setting a non-pow-2 bad value.
 .TP
 .BI lockmem \fR=\fPint
 Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
@@ -1549,7 +1549,7 @@ this value is used as a fixed size or possible range of each file.
 Perform I/O after the end of the file. Normally fio will operate within the
 size of a file. If this option is set, then fio will append to the file
 instead. This has identical behavior to setting \fBoffset\fR to the size
-of a file. This option is ignored on non\-regular files.
+of a file. This option is ignored on non-regular files.
 .TP
 .BI fill_device \fR=\fPbool "\fR,\fB fill_fs" \fR=\fPbool
 Sets size to something really large and waits for ENOSPC (no space left on
@@ -1557,7 +1557,7 @@ device) as the terminating condition. Only makes sense with sequential
 write. For a read workload, the mount point will be filled first then I/O
 started on the result. This option doesn't make sense if operating on a raw
 device node, since the size of that is already known by the file system.
-Additionally, writing beyond end\-of\-device will not return ENOSPC there.
+Additionally, writing beyond end-of-device will not return ENOSPC there.
 .SS "I/O engine"
 .TP
 .BI ioengine \fR=\fPstr
@@ -1586,7 +1586,7 @@ Basic \fBpreadv2\fR\|(2) or \fBpwritev2\fR\|(2) I/O.
 .TP
 .B libaio
 Linux native asynchronous I/O. Note that Linux may only support
-queued behavior with non\-buffered I/O (set `direct=1' or
+queued behavior with non-buffered I/O (set `direct=1' or
 `buffered=0').
 This engine defines engine specific options.
 .TP
@@ -1641,11 +1641,11 @@ Doesn't transfer any data, but burns CPU cycles according to the
 of the CPU. In case of SMP machines, use `numjobs=<nr_of_cpu>'
 to get desired CPU usage, as the cpuload only loads a
 single CPU at the desired rate. A job never finishes unless there is
-at least one non\-cpuio job.
+at least one non-cpuio job.
 .TP
 .B guasi
 The GUASI I/O engine is the Generic Userspace Asynchronous Syscall
-Interface approach to async I/O. See \fIhttp://www.xmailserver.org/guasi\-lib.html\fR
+Interface approach to async I/O. See \fIhttp://www.xmailserver.org/guasi-lib.html\fR
 for more info on GUASI.
 .TP
 .B rdma
@@ -1810,7 +1810,7 @@ should be used for the polling thread.
 .BI (libaio)userspace_reap
 Normally, with the libaio engine in use, fio will use the
 \fBio_getevents\fR\|(3) system call to reap newly returned events. With
-this flag turned on, the AIO ring will be read directly from user\-space to
+this flag turned on, the AIO ring will be read directly from user-space to
 reap events. The reaping mode is only enabled when polling for a minimum of
 0 events (e.g. when `iodepth_batch_complete=0').
 .TP
@@ -2165,13 +2165,13 @@ When the unit is omitted, the value is interpreted in microseconds. See
 \fBthinktime_blocks\fR and \fBthinktime_spin\fR.
 .TP
 .BI thinktime_spin \fR=\fPtime
-Only valid if \fBthinktime\fR is set \- pretend to spend CPU time doing
+Only valid if \fBthinktime\fR is set - pretend to spend CPU time doing
 something with the data received, before falling back to sleeping for the
 rest of the period specified by \fBthinktime\fR. When the unit is
 omitted, the value is interpreted in microseconds.
 .TP
 .BI thinktime_blocks \fR=\fPint
-Only valid if \fBthinktime\fR is set \- control how many blocks to issue,
+Only valid if \fBthinktime\fR is set - control how many blocks to issue,
 before waiting \fBthinktime\fR usecs. If not set, defaults to 1 which will make
 fio wait \fBthinktime\fR usecs after every block. This effectively makes any
 queue depth setting redundant, since no more than 1 I/O will be queued
@@ -2180,7 +2180,7 @@ setting effectively caps the queue depth if the latter is larger.
 .TP
 .BI rate \fR=\fPint[,int][,int]
 Cap the bandwidth used by this job. The number is in bytes/sec, the normal
-suffix rules apply. Comma\-separated values may be specified for reads,
+suffix rules apply. Comma-separated values may be specified for reads,
 writes, and trims as described in \fBblocksize\fR.
 .RS
 .P
@@ -2192,7 +2192,7 @@ latter will only limit reads.
 .TP
 .BI rate_min \fR=\fPint[,int][,int]
 Tell fio to do whatever it can to maintain at least this bandwidth. Failing
-to meet this requirement will cause the job to exit. Comma\-separated values
+to meet this requirement will cause the job to exit. Comma-separated values
 may be specified for reads, writes, and trims as described in
 \fBblocksize\fR.
 .TP
@@ -2200,12 +2200,12 @@ may be specified for reads, writes, and trims as described in
 Cap the bandwidth to this number of IOPS. Basically the same as
 \fBrate\fR, just specified independently of bandwidth. If the job is
 given a block size range instead of a fixed value, the smallest block size
-is used as the metric. Comma\-separated values may be specified for reads,
+is used as the metric. Comma-separated values may be specified for reads,
 writes, and trims as described in \fBblocksize\fR.
 .TP
 .BI rate_iops_min \fR=\fPint[,int][,int]
 If fio doesn't meet this rate of I/O, it will cause the job to exit.
-Comma\-separated values may be specified for reads, writes, and trims as
+Comma-separated values may be specified for reads, writes, and trims as
 described in \fBblocksize\fR.
 .TP
 .BI rate_process \fR=\fPstr
@@ -2411,7 +2411,7 @@ Each job will get a unique CPU from the CPU set.
 .RE
 .P
 \fBshared\fR is the default behavior, if the option isn't specified. If
-\fBsplit\fR is specified, then fio will will assign one cpu per job. If not
+\fBsplit\fR is specified, then fio will assign one cpu per job. If not
 enough CPUs are given for the jobs listed, then fio will roundrobin the CPUs
 in the set.
 .RE
@@ -2474,7 +2474,7 @@ The ID of the flow. If not specified, it defaults to being a global
 flow. See \fBflow\fR.
 .TP
 .BI flow \fR=\fPint
-Weight in token\-based flow control. If this value is used, then there is
+Weight in token-based flow control. If this value is used, then there is
 a 'flow counter' which is used to regulate the proportion of activity between
 two or more jobs. Fio attempts to keep this flow counter near zero. The
 \fBflow\fR parameter stands for how much should be added or subtracted to the
@@ -2795,8 +2795,8 @@ true.
 It may sometimes be interesting to display statistics for groups of jobs as
 a whole instead of for each individual job. This is especially true if
 \fBnumjobs\fR is used; looking at individual thread/process output
-quickly becomes unwieldy. To see the final report per\-group instead of
-per\-job, use \fBgroup_reporting\fR. Jobs in a file will be part of the
+quickly becomes unwieldy. To see the final report per-group instead of
+per-job, use \fBgroup_reporting\fR. Jobs in a file will be part of the
 same reporting group, unless if separated by a \fBstonewall\fR, or by
 using \fBnew_group\fR.
 .TP
@@ -2915,11 +2915,11 @@ parameter. The files will be stored with a `.fz' suffix.
 .TP
 .BI log_unix_epoch \fR=\fPbool
 If set, fio will log Unix timestamps to the log files produced by enabling
-write_type_log for each log type, instead of the default zero\-based
+write_type_log for each log type, instead of the default zero-based
 timestamps.
 .TP
 .BI block_error_percentiles \fR=\fPbool
-If set, record errors in trim block\-sized units from writes and trims and
+If set, record errors in trim block-sized units from writes and trims and
 output a histogram of how many trims it took to get to errors, and what kind
 of error was encountered.
 .TP
@@ -2989,7 +2989,7 @@ for each job to finish.
 .TP
 .BI continue_on_error \fR=\fPstr
 Normally fio will exit the job on the first observed failure. If this option
-is set, fio will continue the job when there is a 'non\-fatal error' (EIO or
+is set, fio will continue the job when there is a 'non-fatal error' (EIO or
 EILSEQ) until the runtime is exceeded or the I/O size specified is
 completed. If this option is used, there are two more stats that are
 appended, the total error count and the first error. The error field given
@@ -3017,17 +3017,17 @@ Continue on verify errors, exit on all others.
 Continue on all errors.
 .TP
 .B 0
-Backward\-compatible alias for 'none'.
+Backward-compatible alias for 'none'.
 .TP
 .B 1
-Backward\-compatible alias for 'all'.
+Backward-compatible alias for 'all'.
 .RE
 .RE
 .TP
 .BI ignore_error \fR=\fPstr
 Sometimes you want to ignore some errors during test in that case you can
 specify error list for each error type, instead of only being able to
-ignore the default 'non\-fatal error' using \fBcontinue_on_error\fR.
+ignore the default 'non-fatal error' using \fBcontinue_on_error\fR.
 `ignore_error=READ_ERR_LIST,WRITE_ERR_LIST,VERIFY_ERR_LIST' errors for
 given error type is separated with ':'. Error may be symbol ('ENOSPC', 'ENOMEM')
 or integer. Example:
@@ -3131,7 +3131,7 @@ Thread created.
 Thread initialized, waiting or generating necessary data.
 .TP
 .B p
-Thread running pre\-reading file(s).
+Thread running pre-reading file(s).
 .TP
 .B /
 Thread is in ramp period.
@@ -3337,8 +3337,8 @@ For each data direction it prints:
 .B bw
 Aggregate bandwidth of threads in this group followed by the
 minimum and maximum bandwidth of all the threads in this group.
-Values outside of brackets are power\-of\-2 format and those
-within are the equivalent value in a power\-of\-10 format.
+Values outside of brackets are power-of-2 format and those
+within are the equivalent value in a power-of-10 format.
 .TP
 .B io
 Aggregate I/O performed of all threads in this group. The
@@ -3555,7 +3555,7 @@ This data indicates that one I/O required 87,552ns to complete, two I/Os require
 100,864ns to complete, and 7529 I/Os required 107,008ns to complete.
 .P
 Also included with fio is a Python script \fBfio_jsonplus_clat2csv\fR that takes
-json+ output and generates CSV\-formatted latency data suitable for plotting.
+json+ output and generates CSV-formatted latency data suitable for plotting.
 .P
 The latency durations actually represent the midpoints of latency intervals.
 For details refer to `stat.h' in the fio source.
@@ -3828,7 +3828,7 @@ is recorded. Each `data direction' seen within the window period will aggregate
 its values in a separate row. Further, when using windowed logging the `block
 size' and `offset' entries will always contain 0.
 .SH CLIENT / SERVER
-Normally fio is invoked as a stand\-alone application on the machine where the
+Normally fio is invoked as a stand-alone application on the machine where the
 I/O workload should be generated. However, the backend and frontend of fio can
 be run separately i.e., the fio server can generate an I/O workload on the "Device
 Under Test" while being controlled by a client on another machine.
@@ -3911,7 +3911,7 @@ The fio command would then be:
 $ fio \-\-client=host.list <job file(s)>
 .RE
 .P
-In this mode, you cannot input server\-specific parameters or job files \-\- all
+In this mode, you cannot input server-specific parameters or job files \-\- all
 servers receive the same job file.
 .P
 In order to let `fio \-\-client' runs use a shared filesystem from multiple

