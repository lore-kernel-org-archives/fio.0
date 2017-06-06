Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:56580 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751415AbdFFMAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Jun 2017 08:00:19 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dID9m-0001hh-8o
        for fio@vger.kernel.org; Tue, 06 Jun 2017 12:00:18 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170606120002.368282C0090@kernel.dk>
Date: Tue,  6 Jun 2017 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 9af5a2450a555a725dd18e6845967cd7cf3aad64:

  use correct syscall name in log_err() (2017-06-02 13:38:43 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c12d597ac36632a6f08c749df302135bbd339cb2:

  stat: correct json 'io_bytes' output (2017-06-05 14:05:43 -0600)

----------------------------------------------------------------
Brantley West (1):
      allow a percent value for the offset parameter

Ian Chakeres (1):
      Added information about minimal output to documentation

Jens Axboe (4):
      Merge branch 'size_perc' of https://github.com/sitsofe/fio
      Merge branch 'master' of https://github.com/cbwest3/fio
      Merge branch 'more-minimal-info-in-docs' of https://github.com/ianchakeres/fio
      stat: correct json 'io_bytes' output

Sitsofe Wheeler (1):
      filesetup: fix size percentage calculations when using offset

 HOWTO            | 14 ++++++++++----
 cconv.c          |  2 ++
 filesetup.c      | 36 +++++++++++++++++++++++++++++++++---
 fio.1            | 15 ++++++++++++++-
 options.c        | 16 ++++++++++++++++
 stat.c           |  3 ++-
 thread_options.h |  3 ++-
 7 files changed, 79 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 6c9e9a4..ea9466a 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1072,10 +1072,11 @@ I/O type
 
 .. option:: offset=int
 
-	Start I/O at the given offset in the file. The data before the given offset
-	will not be touched. This effectively caps the file size at `real_size -
-	offset`. Can be combined with :option:`size` to constrain the start and
-	end range that I/O will be done within.
+	Start I/O at the provided offset in the file, given as either a fixed size or
+	a percentage. If a percentage is given, the next ``blockalign``-ed offset
+	will be used. Data before the given offset will not be touched. This
+	effectively caps the file size at `real_size - offset`. Can be combined with
+	:option:`size` to constrain the start and end range of the I/O workload.
 
 .. option:: offset_increment=int
 
@@ -3225,6 +3226,11 @@ which is the Xth percentile, and the `usec` latency associated with it.
 For disk utilization, all disks used by fio are shown. So for each disk there
 will be a disk utilization section.
 
+Below is a single line containing short names for each of the fields in the
+minimal output v3, separated by semicolons:
+
+terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+
 
 Trace file format
 -----------------
diff --git a/cconv.c b/cconv.c
index 3295824..bf4c517 100644
--- a/cconv.c
+++ b/cconv.c
@@ -104,6 +104,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->file_size_low = le64_to_cpu(top->file_size_low);
 	o->file_size_high = le64_to_cpu(top->file_size_high);
 	o->start_offset = le64_to_cpu(top->start_offset);
+	o->start_offset_percent = le32_to_cpu(top->start_offset_percent);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		o->bs[i] = le32_to_cpu(top->bs[i]);
@@ -543,6 +544,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->file_size_low = __cpu_to_le64(o->file_size_low);
 	top->file_size_high = __cpu_to_le64(o->file_size_high);
 	top->start_offset = __cpu_to_le64(o->start_offset);
+	top->start_offset_percent = __cpu_to_le32(o->start_offset_percent);
 	top->trim_backlog = __cpu_to_le64(o->trim_backlog);
 	top->offset_increment = __cpu_to_le64(o->offset_increment);
 	top->number_ios = __cpu_to_le64(o->number_ios);
diff --git a/filesetup.c b/filesetup.c
index 612e794..e548d21 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -833,12 +833,35 @@ static unsigned long long get_fs_free_counts(struct thread_data *td)
 uint64_t get_start_offset(struct thread_data *td, struct fio_file *f)
 {
 	struct thread_options *o = &td->o;
+	unsigned long long align_bs;  /* align the offset to this block size */
+	unsigned long long offset;  /* align_bs-aligned offset */
 
 	if (o->file_append && f->filetype == FIO_TYPE_FILE)
 		return f->real_file_size;
 
-	return td->o.start_offset +
-		td->subjob_number * td->o.offset_increment;
+	if (o->start_offset_percent > 0) {
+
+		/* if blockalign is provided, find the min across read, write, and trim */
+		if (fio_option_is_set(o, ba)) {
+			align_bs = (unsigned long long) min(o->ba[DDIR_READ], o->ba[DDIR_WRITE]);
+			align_bs = min((unsigned long long) o->ba[DDIR_TRIM], align_bs);
+		} else {  /* else take the minimum block size */
+			align_bs = td_min_bs(td);
+		}
+
+		/* calculate the raw offset */
+		offset = (f->real_file_size * o->start_offset_percent / 100) +
+			(td->subjob_number * o->offset_increment);
+
+		/* block align the offset at the next available boundary at
+		   ceiling(offset / align_bs) * align_bs */
+		offset = (offset / align_bs + (offset % align_bs != 0)) * align_bs;
+
+	} else {  /* start_offset_percent not set */
+		offset = o->start_offset + o->start_offset +
+			td->subjob_number * o->offset_increment;
+	}
+	return offset;
 }
 
 /*
@@ -986,7 +1009,14 @@ int setup_files(struct thread_data *td)
 			total_size = -1ULL;
 		else {
                         if (o->size_percent) {
-				f->io_size = (f->io_size * o->size_percent) / 100;
+				uint64_t file_size;
+
+				file_size = f->io_size + f->file_offset;
+				f->io_size = (file_size *
+					      o->size_percent) / 100;
+				if (f->io_size > (file_size - f->file_offset))
+					f->io_size = file_size - f->file_offset;
+
 				f->io_size -= (f->io_size % td_min_bs(td));
 			}
 			total_size += f->io_size;
diff --git a/fio.1 b/fio.1
index 9956867..e153d46 100644
--- a/fio.1
+++ b/fio.1
@@ -904,7 +904,11 @@ If true, use buffered I/O.  This is the opposite of the \fBdirect\fR parameter.
 Default: true.
 .TP
 .BI offset \fR=\fPint
-Offset in the file to start I/O. Data before the offset will not be touched.
+Start I/O at the provided offset in the file, given as either a fixed size or a
+percentage. If a percentage is given, the next \fBblockalign\fR-ed offset will
+be used. Data before the given offset will not be touched. This effectively
+caps the file size at (real_size - offset). Can be combined with \fBsize\fR to
+constrain the start and end range of the I/O workload.
 .TP
 .BI offset_increment \fR=\fPint
 If this is provided, then the real offset becomes the
@@ -2241,6 +2245,15 @@ Error Info (dependent on continue_on_error, default off):
 .P
 .B text description (if provided in config - appears on newline)
 .RE
+.P
+Below is a single line containing short names for each of the fields in
+the minimal output v3, separated by semicolons:
+.RS
+.P
+.nf
+terse_version_3;fio_version;jobname;groupid;error;read_kb;read_bandwidth;read_iops;read_runtime_ms;read_slat_min;read_slat_max;read_slat_mean;read_slat_dev;read_clat_max;read_clat_min;read_clat_mean;read_clat_dev;read_clat_pct01;read_clat_pct02;read_clat_pct03;read_clat_pct04;read_clat_pct05;read_clat_pct06;read_clat_pct07;read_clat_pct08;read_clat_pct09;read_clat_pct10;read_clat_pct11;read_clat_pct12;read_clat_pct13;read_clat_pct14;read_clat_pct15;read_clat_pct16;read_clat_pct17;read_clat_pct18;read_clat_pct19;read_clat_pct20;read_tlat_min;read_lat_max;read_lat_mean;read_lat_dev;read_bw_min;read_bw_max;read_bw_agg_pct;read_bw_mean;read_bw_dev;write_kb;write_bandwidth;write_iops;write_runtime_ms;write_slat_min;write_slat_max;write_slat_mean;write_slat_dev;write_clat_max;write_clat_min;write_clat_mean;write_clat_dev;write_clat_pct01;write_clat_pct02;write_clat_pct03;write_clat_pct04;write_clat_pct05;write_clat_pct06;write_clat_pct07;write_clat_pct08;write_clat_pct09;write_clat_pct10;
 write_clat_pct11;write_clat_pct12;write_clat_pct13;write_clat_pct14;write_clat_pct15;write_clat_pct16;write_clat_pct17;write_clat_pct18;write_clat_pct19;write_clat_pct20;write_tlat_min;write_lat_max;write_lat_mean;write_lat_dev;write_bw_min;write_bw_max;write_bw_agg_pct;write_bw_mean;write_bw_dev;cpu_user;cpu_sys;cpu_csw;cpu_mjf;pu_minf;iodepth_1;iodepth_2;iodepth_4;iodepth_8;iodepth_16;iodepth_32;iodepth_64;lat_2us;lat_4us;lat_10us;lat_20us;lat_50us;lat_100us;lat_250us;lat_500us;lat_750us;lat_1000us;lat_2ms;lat_4ms;lat_10ms;lat_20ms;lat_50ms;lat_100ms;lat_250ms;lat_500ms;lat_750ms;lat_1000ms;lat_2000ms;lat_over_2000ms;disk_name;disk_read_iops;disk_write_iops;disk_read_merges;disk_write_merges;disk_read_ticks;write_ticks;disk_queue_time;disk_util
+.fi
+.RE
 .SH TRACE FILE FORMAT
 There are two trace file format that you can encounter. The older (v1) format
 is unsupported since version 1.20-rc3 (March 2008). It will still be described
diff --git a/options.c b/options.c
index b489e90..dcee7e5 100644
--- a/options.c
+++ b/options.c
@@ -1381,6 +1381,21 @@ static int str_gtod_reduce_cb(void *data, int *il)
 	return 0;
 }
 
+static int str_offset_cb(void *data, unsigned long long *__val)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	unsigned long long v = *__val;
+
+	if (parse_is_percent(v)) {
+		td->o.start_offset = 0;
+		td->o.start_offset_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET start_offset_percent %d\n", td->o.start_offset_percent);
+	} else
+		td->o.start_offset = v;
+
+	return 0;
+}
+
 static int str_size_cb(void *data, unsigned long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1938,6 +1953,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.lname	= "IO offset",
 		.alias	= "fileoffset",
 		.type	= FIO_OPT_STR_VAL,
+		.cb	= str_offset_cb,
 		.off1	= offsetof(struct thread_options, start_offset),
 		.help	= "Start IO from this offset",
 		.def	= "0",
diff --git a/stat.c b/stat.c
index e433c6d..fd3ad5a 100644
--- a/stat.c
+++ b/stat.c
@@ -919,7 +919,8 @@ static void add_ddir_status_json(struct thread_stat *ts,
 		iops = (1000.0 * (uint64_t) ts->total_io_u[ddir]) / runt;
 	}
 
-	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir] >> 10);
+	json_object_add_value_int(dir_object, "io_bytes", ts->io_bytes[ddir]);
+	json_object_add_value_int(dir_object, "io_kbytes", ts->io_bytes[ddir] >> 10);
 	json_object_add_value_int(dir_object, "bw", bw);
 	json_object_add_value_float(dir_object, "iops", iops);
 	json_object_add_value_int(dir_object, "runtime", ts->runtime[ddir]);
diff --git a/thread_options.h b/thread_options.h
index d0f3fe9..493e92e 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -200,6 +200,7 @@ struct thread_options {
 	unsigned int numa_mem_prefer_node;
 	char *numa_memnodes;
 	unsigned int gpu_dev_id;
+	unsigned int start_offset_percent;
 
 	unsigned int iolog;
 	unsigned int rwmixcycle;
@@ -469,7 +470,7 @@ struct thread_options_pack {
 	uint8_t log_gz_cpumask[FIO_TOP_STR_MAX];
 #endif
 	uint32_t gpu_dev_id;
-	uint32_t pad;
+	uint32_t start_offset_percent;
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
