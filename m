Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH v3 2/4] man: sync "OUTPUT" section and after with HOWTO
Date: Mon, 14 Aug 2017 18:30:24 +0300
Message-Id: <20170814153026.44260-3-tkusumi@tuxera.com>
In-Reply-To: <20170814153026.44260-1-tkusumi@tuxera.com>
References: <20170814153026.44260-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

This is the continuation of below series of patches as well as the
previous commit to sync the man page with HOWTO. This commit covers the
rest of the sections.

[PATCH 0/7] Sync fio(1) man page with HOWTO
http://www.spinics.net/lists/fio/msg06008.html

This commit syncs the man page with HOWTO. It does not create new contents
that didn't exist in HOWTO, however formats (indentations, directives,
quotations, etc) are modified for some sections so that the entire man
page has consistent style.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 fio.1 | 977 +++++++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 554 insertions(+), 423 deletions(-)

diff --git a/fio.1 b/fio.1
index 7ef1bc7..4b4b111 100644
--- a/fio.1
+++ b/fio.1
@@ -2691,27 +2691,33 @@ Test directory.
 .BI threads\fR=\fPint
 Number of threads.
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
@@ -2731,96 +2737,200 @@ Running, doing mixed sequential reads/writes.
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
 .P
-The second set of brackets shows the estimated completion percentage of
-the current group.  The third set shows the read and write I/O rate,
-respectively. Finally, the estimated run time of the job is displayed.
+Note that the status string is displayed in order, so it's possible to tell which of
+the jobs are currently doing what. In the example above this means that jobs 1\-\-10
+are readers and 11\-\-20 are writers.
 .P
-When \fBfio\fR completes (or is interrupted by Ctrl-C), it will show data
-for each thread, each group of threads, and each disk, in that order.
+The other values are fairly self explanatory \-\- number of threads currently
+running and doing I/O, the number of currently open files (f=), the estimated
+completion percentage, the rate of I/O since last check (read speed listed first,
+then write speed and optionally trim speed) in terms of bandwidth and IOPS,
+and time to completion for the current running group. It's impossible to estimate
+runtime of the following groups (if any).
 .P
-Per-thread statistics first show the threads client number, group-id, and
-error code.  The remaining figures are as follows:
+When fio is done (or interrupted by Ctrl\-C), it will show the data for
+each thread, group of threads, and disks in that order. For each overall thread (or
+group) the output looks like:
+.P
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
+		    lat (usec) : 250=0.04%, 500=64.11%, 750=4.81%, 1000=2.79%
+		    lat (msec) : 2=4.16%, 4=1.84%, 10=4.90%, 20=11.33%, 50=5.37%
+		    lat (msec) : 100=0.65%
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
-.TP
-.B IO issued
-Number of read/write requests issued, and number of short read/write requests.
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
+.TP
+.B IO complete
+Like the above \fBsubmit\fR number, but for completions instead.
+.TP
+.B IO issued rwt
+The number of \fBread/write/trim\fR requests issued, and how many of them were
+short or dropped.
 .TP
 .B IO latencies
-Distribution of I/O completion latencies.  The numbers follow the same pattern
-as \fBIO depths\fR.
+The distribution of I/O completion latencies. This is the time from when
+I/O leaves fio and when it gets completed. The numbers follow the same
+pattern as the I/O \fBdepths\fR, meaning that 2=1.6% means that 1.6% of the
+I/O completed within 2 msecs, 20=12.8% means that 12.8% of the I/O took
+more than 10 msecs, but less than (or equal to) 20 msecs.
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
@@ -2832,517 +2942,538 @@ Number of merges performed by the I/O scheduler.
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
-terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
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
+		terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_min;read_clat_max;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_min;write_clat_max;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;cpu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
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
+Sample jobfiles are available in the `examples/' directory.
 .br
-These are typically located under /usr/share/doc/fio.
-
-\fBHOWTO\fR:  http://git.kernel.dk/cgit/fio/plain/HOWTO
-.br
-\fBREADME\fR: http://git.kernel.dk/cgit/fio/plain/README
+These are typically located under `/usr/share/doc/fio'.
+.P
+\fBHOWTO\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/HOWTO\fR
 .br
+\fBREADME\fR: \fIhttp://git.kernel.dk/cgit/fio/plain/README\fR
-- 
2.9.4


