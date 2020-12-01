Return-Path: <krish.reddy@samsung.com>
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: [PATCH 4/9] Adding a new copy operation.
Date: Tue,  1 Dec 2020 17:10:29 +0530
Message-Id: <20201201114034.8307-5-krish.reddy@samsung.com>
In-Reply-To: <20201201114034.8307-1-krish.reddy@samsung.com>
Content-Type: text/plain; charset="utf-8"
References: <20201201114034.8307-1-krish.reddy@samsung.com>
	<CGME20201201114100epcas5p2f02995779f5172f711cc6ad3d362d50a@epcas5p2.samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org, Ankit Kumar <ankit.kumar@samsung.com>, Krishna Kanth Reddy <krish.reddy@samsung.com>
List-ID: <fio@vger.kernel.org>

From: Ankit Kumar <ankit.kumar@samsung.com>

Changes for rw=copy and rw=randcopy
The copy operation requires two new FIO options.
dest_offset : The starting destination offset for the copy operation.
num_range : The number of source ranges for each copy operation.
The existing FIO option offset will be the starting source offset.

Data to be copied from source range can be random or sequential
according to rw=copy or randcopy option. The destination location
for the copy operation will be sequential.

Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
---
 HOWTO            | 24 ++++++++++++++++++++++--
 cconv.c          |  6 ++++++
 fio.1            | 21 ++++++++++++++++++++-
 options.c        | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h |  9 +++++++--
 5 files changed, 103 insertions(+), 5 deletions(-)

diff --git a/HOWTO b/HOWTO
index 386fd12a..5cbd46a2 100644
--- a/HOWTO
+++ b/HOWTO
@@ -177,8 +177,8 @@ Command line options
 	``--readonly`` option is an extra safety guard to prevent users from
 	accidentally starting a write or trim workload when that is not desired.
 	Fio will only modify the device under test if
-	`rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite` is given.  This
-	safety net can be used as an extra precaution.
+	`rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite/copy/randcopy` is given.
+	This safety net can be used as an extra precaution.
 
 .. option:: --eta=when
 
@@ -1096,6 +1096,9 @@ I/O type
 		**trim**
 				Sequential trims (Linux block devices and SCSI
 				character devices only).
+		**copy**
+				Sequential copy (Linux NVMe block device. Source offset
+				will be sequential).
 		**randread**
 				Random reads.
 		**randwrite**
@@ -1103,6 +1106,9 @@ I/O type
 		**randtrim**
 				Random trims (Linux block devices and SCSI
 				character devices only).
+		**randcopy**
+				Random copy (Linux NVMe block device. Source offset
+				will be random).
 		**rw,readwrite**
 				Sequential mixed reads and writes.
 		**randrw**
@@ -1280,6 +1286,20 @@ I/O type
 	If a percentage is given, the generated offset will be aligned to the minimum
 	``blocksize`` or to the value of ``offset_align`` if provided.
 
+.. option:: dest_offset=int
+
+	Destination offset in the file for copy command, given as either a fixed size
+	in bytes or a percentage. The option 'offset' is now used as source offset for
+	copy command. If a percentage is given, the generated offset will be aligned
+	to the minimum ``blocksize`` or to the value of ``offset_align`` if provided.
+	A percentage can be specified by a number between 1 and 100 followed by '%',
+	for example, ``dest_offset=40%`` to specify 40%.
+
+.. option:: num_range=int
+	For copy command this must be the number of source ranges to copy at a time.
+	The number of logical blocks per source range is determined by the option 'bs'
+	and it must be a multiple of logical block size.
+
 .. option:: number_ios=int
 
 	Fio will normally perform I/Os until it has exhausted the size of the region
diff --git a/cconv.c b/cconv.c
index 488dd799..08174af0 100644
--- a/cconv.c
+++ b/cconv.c
@@ -101,6 +101,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->serialize_overlap = le32_to_cpu(top->serialize_overlap);
 	o->size = le64_to_cpu(top->size);
 	o->io_size = le64_to_cpu(top->io_size);
+	o->num_range = le32_to_cpu(top->num_range);
 	o->size_percent = le32_to_cpu(top->size_percent);
 	o->io_size_percent = le32_to_cpu(top->io_size_percent);
 	o->fill_device = le32_to_cpu(top->fill_device);
@@ -110,6 +111,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->start_offset = le64_to_cpu(top->start_offset);
 	o->start_offset_align = le64_to_cpu(top->start_offset_align);
 	o->start_offset_percent = le32_to_cpu(top->start_offset_percent);
+	o->dest_offset = le64_to_cpu(top->dest_offset);
+	o->dest_offset_percent = le32_to_cpu(top->dest_offset_percent);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		o->bs[i] = le64_to_cpu(top->bs[i]);
@@ -553,6 +556,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 
 	top->size = __cpu_to_le64(o->size);
 	top->io_size = __cpu_to_le64(o->io_size);
+	top->num_range = __cpu_to_le32(o->num_range);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
 	top->start_delay = __cpu_to_le64(o->start_delay);
 	top->start_delay_high = __cpu_to_le64(o->start_delay_high);
@@ -574,6 +578,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->start_offset = __cpu_to_le64(o->start_offset);
 	top->start_offset_align = __cpu_to_le64(o->start_offset_align);
 	top->start_offset_percent = __cpu_to_le32(o->start_offset_percent);
+	top->dest_offset = __cpu_to_le64(o->dest_offset);
+	top->dest_offset_percent = __cpu_to_le32(o->dest_offset_percent);
 	top->trim_backlog = __cpu_to_le64(o->trim_backlog);
 	top->offset_increment_percent = __cpu_to_le32(o->offset_increment_percent);
 	top->offset_increment = __cpu_to_le64(o->offset_increment);
diff --git a/fio.1 b/fio.1
index 48119325..d4da1b0c 100644
--- a/fio.1
+++ b/fio.1
@@ -74,7 +74,7 @@ Convert \fIjobfile\fR to a set of command\-line options.
 Turn on safety read\-only checks, preventing writes and trims. The \fB\-\-readonly\fR
 option is an extra safety guard to prevent users from accidentally starting
 a write or trim workload when that is not desired. Fio will only modify the
-device under test if `rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite'
+device under test if `rw=write/randwrite/rw/randrw/trim/randtrim/trimwrite/copy/randcopy'
 is given. This safety net can be used as an extra precaution.
 .TP
 .BI \-\-eta \fR=\fPwhen
@@ -860,6 +860,9 @@ Sequential writes.
 .B trim
 Sequential trims (Linux block devices and SCSI character devices only).
 .TP
+.B copy
+Sequential copy (Linux NVMe block device. Source offset will be sequential).
+.TP
 .B randread
 Random reads.
 .TP
@@ -869,6 +872,9 @@ Random writes.
 .B randtrim
 Random trims (Linux block devices and SCSI character devices only).
 .TP
+.B randcopy
+Random copy (Linux NVMe block device. Source offset will be random).
+.TP
 .B rw,readwrite
 Sequential mixed reads and writes.
 .TP
@@ -1055,6 +1061,19 @@ spacing between the starting points. Percentages can be used for this option.
 If a percentage is given, the generated offset will be aligned to the minimum
 \fBblocksize\fR or to the value of \fBoffset_align\fR if provided.
 .TP
+.BI dest_offset \fR=\fPint
+Destination offset in the file for copy command, given as either a fixed size in
+bytes or a percentage. The \fBoffset\fR is now used as source offset for copy command.
+If a percentage is given, the generated destination offset will be aligned to the
+minimum \fBblocksize\fR or to the value of \fBoffset_align\fR if provided.
+A percentage can be specified by a number between 1 and 100 followed by '%',
+for example, `dest_offset=40%' to specify 40%.
+.TP
+.BI num_range \fR=\fPint
+For copy command this must be the number of source ranges to copy at a time.
+The number of logical blocks per source range is determined by the option\fBbs\fR
+and it must be a multiple of logical block size.
+.TP
 .BI number_ios \fR=\fPint
 Fio will normally perform I/Os until it has exhausted the size of the region
 set by \fBsize\fR, or if it exhaust the allocated time (or hits an error
diff --git a/options.c b/options.c
index f68ae8c2..e085ab25 100644
--- a/options.c
+++ b/options.c
@@ -1460,6 +1460,22 @@ static int str_offset_increment_cb(void *data, unsigned long long *__val)
 	return 0;
 }
 
+static int str_dest_offset_cb(void *data, unsigned long long *__val)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	unsigned long long v = *__val;
+
+	if (parse_is_percent(v)) {
+		td->o.dest_offset = 0;
+		td->o.dest_offset_percent = -1ULL - v;
+		dprint(FD_PARSE, "SET dest_offset_percent %d\n",
+					td->o.dest_offset_percent);
+	} else
+		td->o.dest_offset = v;
+
+	return 0;
+}
+
 static int str_size_cb(void *data, unsigned long long *__val)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -1737,6 +1753,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = TD_DDIR_TRIM,
 			    .help = "Sequential trim",
 			  },
+			  { .ival = "copy",
+			    .oval = TD_DDIR_COPY,
+			    .help = "Sequential copy",
+			  },
 			  { .ival = "randread",
 			    .oval = TD_DDIR_RANDREAD,
 			    .help = "Random read",
@@ -1749,6 +1769,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 			    .oval = TD_DDIR_RANDTRIM,
 			    .help = "Random trim",
 			  },
+			  { .ival = "randcopy",
+			    .oval = TD_DDIR_RANDCOPY,
+			    .help = "Random copy",
+			  },
 			  { .ival = "rw",
 			    .oval = TD_DDIR_RW,
 			    .help = "Sequential read and write mix",
@@ -2111,6 +2135,30 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
+	{
+		.name	= "dest_offset",
+		.lname	= "Destination offset",
+		.type	= FIO_OPT_STR_VAL,
+		.cb	= str_dest_offset_cb,
+		.off1	= offsetof(struct thread_options, dest_offset),
+		.help	= "Start of the destination offset",
+		.def	= "0",
+		.interval = 1024 * 1024,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
+		.name	= "num_range",
+		.lname	= "Number of ranges",
+		.type	= FIO_OPT_INT,
+		.off1	= offsetof(struct thread_options, num_range),
+		.help	= "Number of ranges for copy command",
+		.minval = 0,
+		.interval = 1,
+		.def	= "0",
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_IO_BASIC,
+	},
 	{
 		.name	= "offset_align",
 		.lname	= "IO offset alignment",
diff --git a/thread_options.h b/thread_options.h
index 97c400fe..dac82144 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -77,6 +77,7 @@ struct thread_options {
 	unsigned int iodepth_batch_complete_min;
 	unsigned int iodepth_batch_complete_max;
 	unsigned int serialize_overlap;
+	unsigned int num_range;
 
 	unsigned int unique_filename;
 
@@ -90,6 +91,7 @@ struct thread_options {
 	unsigned long long file_size_high;
 	unsigned long long start_offset;
 	unsigned long long start_offset_align;
+	unsigned long long dest_offset;
 
 	unsigned long long bs[DDIR_RWDIR_CNT];
 	unsigned long long ba[DDIR_RWDIR_CNT];
@@ -217,6 +219,7 @@ struct thread_options {
 	char *numa_memnodes;
 	unsigned int gpu_dev_id;
 	unsigned int start_offset_percent;
+	unsigned int dest_offset_percent;
 
 	unsigned int iolog;
 	unsigned int rwmixcycle;
@@ -379,6 +382,7 @@ struct thread_options_pack {
 	uint32_t serialize_overlap;
 	uint32_t pad;
 
+	uint32_t num_range;
 	uint64_t size;
 	uint64_t io_size;
 	uint32_t size_percent;
@@ -390,6 +394,7 @@ struct thread_options_pack {
 	uint64_t file_size_high;
 	uint64_t start_offset;
 	uint64_t start_offset_align;
+	uint64_t dest_offset;
 
 	uint64_t bs[DDIR_RWDIR_CNT];
 	uint64_t ba[DDIR_RWDIR_CNT];
@@ -462,8 +467,6 @@ struct thread_options_pack {
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
-	uint8_t pad1[4];
-
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
@@ -514,6 +517,7 @@ struct thread_options_pack {
 #endif
 	uint32_t gpu_dev_id;
 	uint32_t start_offset_percent;
+	uint32_t dest_offset_percent;
 	uint32_t cpus_allowed_policy;
 	uint32_t iolog;
 	uint32_t rwmixcycle;
@@ -552,6 +556,7 @@ struct thread_options_pack {
 	uint32_t lat_percentiles;
 	uint32_t slat_percentiles;
 	uint32_t percentile_precision;
+	uint32_t pad3;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
-- 
2.17.1


