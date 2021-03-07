Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhCGNAT (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 7 Mar 2021 08:00:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B354C06174A
        for <fio@vger.kernel.org>; Sun,  7 Mar 2021 05:00:19 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lIt0x-00EGy7-Fz
        for fio@vger.kernel.org; Sun, 07 Mar 2021 13:00:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210307130001.947DF1BC0142@kernel.dk>
Date: Sun,  7 Mar 2021 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ab02be41807ec9451c47b17129cf61457ef21db6:

  Add a new file to gitignore (2021-02-21 06:14:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ea9be958d8948cab0c5593a7afc695d17bd6ba79:

  Merge branch 'clock_monotonic_unused' of https://github.com/foxeng/fio (2021-03-06 15:37:56 -0700)

----------------------------------------------------------------
Alexey Dobriyan (4):
      parse: simplify parse_is_percent()
      zbd: simplify zoneskip= validness check
      zbd: fix check against 32-bit zone size
      zbd: support 'z' suffix for zone granularity

Fotis Xenakis (1):
      configure: remove unused CLOCK_MONOTONIC_* symbols

Friendy.Su@sony.com (1):
      engines/filecreate: remove improper message print

Jens Axboe (1):
      Merge branch 'clock_monotonic_unused' of https://github.com/foxeng/fio

 configure              |  6 ------
 engines/filecreate.c   |  2 +-
 filesetup.c            | 18 +++++++++++++-----
 fio.1                  | 13 ++++++++-----
 options.c              | 48 +++++++++++++++++++++++++++++++++++++----------
 parse.c                | 30 ++++++++++++++++++++++++++++-
 parse.h                | 11 +++++++++--
 server.h               |  2 +-
 t/zbd/test-zbd-support | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 thread_options.h       | 17 +++++++++++++----
 zbd.c                  | 51 +++++++++++++++++++++++++++++++++++++++++++-------
 zbd.h                  |  2 ++
 12 files changed, 206 insertions(+), 42 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 748f7014..71b31868 100755
--- a/configure
+++ b/configure
@@ -2794,12 +2794,6 @@ fi
 if test "$clock_monotonic" = "yes" ; then
   output_sym "CONFIG_CLOCK_MONOTONIC"
 fi
-if test "$clock_monotonic_raw" = "yes" ; then
-  output_sym "CONFIG_CLOCK_MONOTONIC_RAW"
-fi
-if test "$clock_monotonic_precise" = "yes" ; then
-  output_sym "CONFIG_CLOCK_MONOTONIC_PRECISE"
-fi
 if test "$clockid_t" = "yes"; then
   output_sym "CONFIG_CLOCKID_T"
 fi
diff --git a/engines/filecreate.c b/engines/filecreate.c
index 5fec8544..16c64928 100644
--- a/engines/filecreate.c
+++ b/engines/filecreate.c
@@ -22,7 +22,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
 	dprint(FD_FILE, "fd open %s\n", f->file_name);
 
 	if (f->filetype != FIO_TYPE_FILE) {
-		log_err("fio: only files are supported fallocate \n");
+		log_err("fio: only files are supported\n");
 		return 1;
 	}
 	if (!strcmp(f->file_name, "-")) {
diff --git a/filesetup.c b/filesetup.c
index 661d4c2f..e664f8b4 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1118,6 +1118,13 @@ int setup_files(struct thread_data *td)
 	if (o->read_iolog_file)
 		goto done;
 
+	if (td->o.zone_mode == ZONE_MODE_ZBD) {
+		err = zbd_init_files(td);
+		if (err)
+			goto err_out;
+	}
+	zbd_recalc_options_with_zone_granularity(td);
+
 	/*
 	 * check sizes. if the files/devices do not exist and the size
 	 * isn't passed to fio, abort.
@@ -1395,16 +1402,17 @@ int setup_files(struct thread_data *td)
 	}
 
 done:
-	if (o->create_only)
-		td->done = 1;
-
-	td_restore_runstate(td, old_state);
-
 	if (td->o.zone_mode == ZONE_MODE_ZBD) {
 		err = zbd_setup_files(td);
 		if (err)
 			goto err_out;
 	}
+
+	if (o->create_only)
+		td->done = 1;
+
+	td_restore_runstate(td, old_state);
+
 	return 0;
 
 err_offset:
diff --git a/fio.1 b/fio.1
index accc6a32..2c0d8348 100644
--- a/fio.1
+++ b/fio.1
@@ -348,6 +348,9 @@ us or usec means microseconds
 .PD
 .RE
 .P
+`z' suffix specifies that the value is measured in zones.
+Value is recalculated once block device's zone size becomes known.
+.P
 If the option accepts an upper and lower range, use a colon ':' or
 minus '\-' to separate such values. See \fIirange\fR parameter type.
 If the lower value specified happens to be larger than the upper value
@@ -783,7 +786,7 @@ If not specified it defaults to the zone size. If the target device is a zoned
 block device, the zone capacity is obtained from the device information and this
 option is ignored.
 .TP
-.BI zoneskip \fR=\fPint
+.BI zoneskip \fR=\fPint[z]
 For \fBzonemode\fR=strided, the number of bytes to skip after \fBzonesize\fR
 bytes of data have been transferred.
 
@@ -1033,7 +1036,7 @@ The values are all relative to each other, and no absolute meaning
 should be associated with them.
 .RE
 .TP
-.BI offset \fR=\fPint
+.BI offset \fR=\fPint[%|z]
 Start I/O at the provided offset in the file, given as either a fixed size in
 bytes or a percentage. If a percentage is given, the generated offset will be
 aligned to the minimum \fBblocksize\fR or to the value of \fBoffset_align\fR if
@@ -1048,7 +1051,7 @@ If set to non-zero value, the byte offset generated by a percentage \fBoffset\fR
 is aligned upwards to this value. Defaults to 0 meaning that a percentage
 offset is aligned to the minimum block size.
 .TP
-.BI offset_increment \fR=\fPint
+.BI offset_increment \fR=\fPint[%|z]
 If this is provided, then the real offset becomes `\fBoffset\fR + \fBoffset_increment\fR
 * thread_number', where the thread number is a counter that starts at 0 and
 is incremented for each sub-job (i.e. when \fBnumjobs\fR option is
@@ -1570,7 +1573,7 @@ Pin the specified amount of memory with \fBmlock\fR\|(2). Can be used to
 simulate a smaller amount of memory. The amount specified is per worker.
 .SS "I/O size"
 .TP
-.BI size \fR=\fPint
+.BI size \fR=\fPint[%|z]
 The total size of file I/O for each thread of this job. Fio will run until
 this many bytes has been transferred, unless runtime is limited by other options
 (such as \fBruntime\fR, for instance, or increased/decreased by \fBio_size\fR).
@@ -1585,7 +1588,7 @@ given, fio will use 20% of the full size of the given files or devices.
 Can be combined with \fBoffset\fR to constrain the start and end range
 that I/O will be done within.
 .TP
-.BI io_size \fR=\fPint "\fR,\fB io_limit" \fR=\fPint
+.BI io_size \fR=\fPint[%|z] "\fR,\fB io_limit" \fR=\fPint[%|z]
 Normally fio operates within the region set by \fBsize\fR, which means
 that the \fBsize\fR option sets both the region and size of I/O to be
 performed. Sometimes that is not what you want. With this option, it is
diff --git a/options.c b/options.c
index e62e0cfb..e3b0c4ef 100644
--- a/options.c
+++ b/options.c
@@ -1471,8 +1471,13 @@ static int str_offset_cb(void *data, unsigned long long *__val)
 	if (parse_is_percent(v)) {
 		td->o.start_offset = 0;
 		td->o.start_offset_percent = -1ULL - v;
+		td->o.start_offset_nz = 0;
 		dprint(FD_PARSE, "SET start_offset_percent %d\n",
 					td->o.start_offset_percent);
+	} else if (parse_is_zone(v)) {
+		td->o.start_offset = 0;
+		td->o.start_offset_percent = 0;
+		td->o.start_offset_nz = v - ZONE_BASE_VAL;
 	} else
 		td->o.start_offset = v;
 
@@ -1487,8 +1492,13 @@ static int str_offset_increment_cb(void *data, unsigned long long *__val)
 	if (parse_is_percent(v)) {
 		td->o.offset_increment = 0;
 		td->o.offset_increment_percent = -1ULL - v;
+		td->o.offset_increment_nz = 0;
 		dprint(FD_PARSE, "SET offset_increment_percent %d\n",
 					td->o.offset_increment_percent);
+	} else if (parse_is_zone(v)) {
+		td->o.offset_increment = 0;
+		td->o.offset_increment_percent = 0;
+		td->o.offset_increment_nz = v - ZONE_BASE_VAL;
 	} else
 		td->o.offset_increment = v;
 
@@ -1505,6 +1515,10 @@ static int str_size_cb(void *data, unsigned long long *__val)
 		td->o.size_percent = -1ULL - v;
 		dprint(FD_PARSE, "SET size_percent %d\n",
 					td->o.size_percent);
+	} else if (parse_is_zone(v)) {
+		td->o.size = 0;
+		td->o.size_percent = 0;
+		td->o.size_nz = v - ZONE_BASE_VAL;
 	} else
 		td->o.size = v;
 
@@ -1525,12 +1539,30 @@ static int str_io_size_cb(void *data, unsigned long long *__val)
 		}
 		dprint(FD_PARSE, "SET io_size_percent %d\n",
 					td->o.io_size_percent);
+	} else if (parse_is_zone(v)) {
+		td->o.io_size = 0;
+		td->o.io_size_percent = 0;
+		td->o.io_size_nz = v - ZONE_BASE_VAL;
 	} else
 		td->o.io_size = v;
 
 	return 0;
 }
 
+static int str_zoneskip_cb(void *data, unsigned long long *__val)
+{
+	struct thread_data *td = cb_data_to_td(data);
+	unsigned long long v = *__val;
+
+	if (parse_is_zone(v)) {
+		td->o.zone_skip = 0;
+		td->o.zone_skip_nz = v - ZONE_BASE_VAL;
+	} else
+		td->o.zone_skip = v;
+
+	return 0;
+}
+
 static int str_write_bw_log_cb(void *data, const char *str)
 {
 	struct thread_data *td = cb_data_to_td(data);
@@ -2081,11 +2113,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "size",
 		.lname	= "Size",
-		.type	= FIO_OPT_STR_VAL,
+		.type	= FIO_OPT_STR_VAL_ZONE,
 		.cb	= str_size_cb,
 		.off1	= offsetof(struct thread_options, size),
 		.help	= "Total size of device or files",
-		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -2093,11 +2124,10 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "io_size",
 		.alias	= "io_limit",
 		.lname	= "IO Size",
-		.type	= FIO_OPT_STR_VAL,
+		.type	= FIO_OPT_STR_VAL_ZONE,
 		.cb	= str_io_size_cb,
 		.off1	= offsetof(struct thread_options, io_size),
 		.help	= "Total size of I/O to be performed",
-		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -2138,12 +2168,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.name	= "offset",
 		.lname	= "IO offset",
 		.alias	= "fileoffset",
-		.type	= FIO_OPT_STR_VAL,
+		.type	= FIO_OPT_STR_VAL_ZONE,
 		.cb	= str_offset_cb,
 		.off1	= offsetof(struct thread_options, start_offset),
 		.help	= "Start IO from this offset",
 		.def	= "0",
-		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -2161,14 +2190,13 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "offset_increment",
 		.lname	= "IO offset increment",
-		.type	= FIO_OPT_STR_VAL,
+		.type	= FIO_OPT_STR_VAL_ZONE,
 		.cb	= str_offset_increment_cb,
 		.off1	= offsetof(struct thread_options, offset_increment),
 		.help	= "What is the increment from one offset to the next",
 		.parent = "offset",
 		.hide	= 1,
 		.def	= "0",
-		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_INVALID,
 	},
@@ -3404,11 +3432,11 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	{
 		.name	= "zoneskip",
 		.lname	= "Zone skip",
-		.type	= FIO_OPT_STR_VAL,
+		.type	= FIO_OPT_STR_VAL_ZONE,
+		.cb	= str_zoneskip_cb,
 		.off1	= offsetof(struct thread_options, zone_skip),
 		.help	= "Space between IO zones",
 		.def	= "0",
-		.interval = 1024 * 1024,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_ZONE,
 	},
diff --git a/parse.c b/parse.c
index 44bf9507..45f4f2d3 100644
--- a/parse.c
+++ b/parse.c
@@ -37,6 +37,7 @@ static const char *opt_type_names[] = {
 	"OPT_BOOL",
 	"OPT_FLOAT_LIST",
 	"OPT_STR_SET",
+	"OPT_STR_VAL_ZONE",
 	"OPT_DEPRECATED",
 	"OPT_SOFT_DEPRECATED",
 	"OPT_UNSUPPORTED",
@@ -599,9 +600,35 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 		fallthrough;
 	case FIO_OPT_ULL:
 	case FIO_OPT_INT:
-	case FIO_OPT_STR_VAL: {
+	case FIO_OPT_STR_VAL:
+	case FIO_OPT_STR_VAL_ZONE:
+	{
 		fio_opt_str_val_fn *fn = o->cb;
 		char tmp[128], *p;
+		size_t len = strlen(ptr);
+
+		if (len > 0 && ptr[len - 1] == 'z') {
+			if (o->type == FIO_OPT_STR_VAL_ZONE) {
+				char *ep;
+				unsigned long long val;
+
+				errno = 0;
+				val = strtoul(ptr, &ep, 10);
+				if (errno == 0 && ep != ptr && *ep == 'z') {
+					ull = ZONE_BASE_VAL + (uint32_t)val;
+					ret = 0;
+					goto store_option_value;
+				} else {
+					log_err("%s: unexpected zone value '%s'\n",
+						o->name, ptr);
+					return 1;
+				}
+			} else {
+				log_err("%s: 'z' suffix isn't applicable\n",
+					o->name);
+				return 1;
+			}
+		}
 
 		if (!is_time && o->is_time)
 			is_time = o->is_time;
@@ -655,6 +682,7 @@ static int __handle_option(const struct fio_option *o, const char *ptr,
 			}
 		}
 
+store_option_value:
 		if (fn)
 			ret = fn(data, &ull);
 		else {
diff --git a/parse.h b/parse.h
index e6663ed4..4cf08fd2 100644
--- a/parse.h
+++ b/parse.h
@@ -21,6 +21,7 @@ enum fio_opt_type {
 	FIO_OPT_BOOL,
 	FIO_OPT_FLOAT_LIST,
 	FIO_OPT_STR_SET,
+	FIO_OPT_STR_VAL_ZONE,
 	FIO_OPT_DEPRECATED,
 	FIO_OPT_SOFT_DEPRECATED,
 	FIO_OPT_UNSUPPORTED,	/* keep this last */
@@ -130,12 +131,18 @@ static inline void *td_var(void *to, const struct fio_option *o,
 
 static inline int parse_is_percent(unsigned long long val)
 {
-	return val <= -1ULL && val >= (-1ULL - 100ULL);
+	return val >= -101;
 }
 
+#define ZONE_BASE_VAL ((-1ULL >> 1) + 1)
 static inline int parse_is_percent_uncapped(unsigned long long val)
 {
-	return (long long)val <= -1;
+	return ZONE_BASE_VAL + -1U < val;
+}
+
+static inline int parse_is_zone(unsigned long long val)
+{
+	return (val - ZONE_BASE_VAL) <= -1U;
 }
 
 struct print_option {
diff --git a/server.h b/server.h
index 9256d44c..74618ca7 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 87,
+	FIO_SERVER_VER			= 88,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
index 1658dc25..be129615 100755
--- a/t/zbd/test-zbd-support
+++ b/t/zbd/test-zbd-support
@@ -1153,6 +1153,54 @@ test54() {
 		>> "${logfile}.${test_number}" 2>&1 || return $?
 }
 
+# test 'z' suffix parsing only
+test55() {
+	local bs
+	bs=$((logical_block_size))
+
+	require_zbd || return $SKIP_TESTCASE
+	# offset=1z + offset_increment=10z + size=2z
+	require_seq_zones 13 || return $SKIP_TESTCASE
+
+	run_fio	--name=j		\
+		--filename=${dev}	\
+		--direct=1		\
+		"$(ioengine "psync")"	\
+		--zonemode=zbd		\
+		--zonesize=${zone_size}	\
+		--rw=write		\
+		--bs=${bs}		\
+		--numjobs=2		\
+		--offset_increment=10z	\
+		--offset=1z		\
+		--size=2z		\
+		--io_size=3z		\
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
+# test 'z' suffix parsing only
+test56() {
+	local bs
+	bs=$((logical_block_size))
+
+	require_regular_block_dev || return $SKIP_TESTCASE
+	require_seq_zones 10 || return $SKIP_TESTCASE
+
+	run_fio	--name=j		\
+		--filename=${dev}	\
+		--direct=1		\
+		"$(ioengine "psync")"	\
+		--zonemode=strided	\
+		--zonesize=${zone_size}	\
+		--rw=write		\
+		--bs=${bs}		\
+		--size=10z		\
+		--zoneskip=2z		\
+		${job_var_opts[@]} --debug=zbd \
+		>> "${logfile}.${test_number}" 2>&1 || return $?
+}
+
 SECONDS=0
 tests=()
 dynamic_analyzer=()
diff --git a/thread_options.h b/thread_options.h
index f6b15403..88fd7ad9 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -83,13 +83,16 @@ struct thread_options {
 	unsigned long long size;
 	unsigned long long io_size;
 	unsigned int size_percent;
+	unsigned int size_nz;
 	unsigned int io_size_percent;
+	unsigned int io_size_nz;
 	unsigned int fill_device;
 	unsigned int file_append;
 	unsigned long long file_size_low;
 	unsigned long long file_size_high;
 	unsigned long long start_offset;
 	unsigned long long start_offset_align;
+	unsigned int start_offset_nz;
 
 	unsigned long long bs[DDIR_RWDIR_CNT];
 	unsigned long long ba[DDIR_RWDIR_CNT];
@@ -198,6 +201,7 @@ struct thread_options {
 	unsigned long long zone_size;
 	unsigned long long zone_capacity;
 	unsigned long long zone_skip;
+	uint32_t zone_skip_nz;
 	enum fio_zone_mode zone_mode;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
@@ -315,6 +319,7 @@ struct thread_options {
 	unsigned int gid;
 
 	unsigned int offset_increment_percent;
+	unsigned int offset_increment_nz;
 	unsigned long long offset_increment;
 	unsigned long long number_ios;
 
@@ -384,14 +389,19 @@ struct thread_options_pack {
 	uint64_t size;
 	uint64_t io_size;
 	uint32_t size_percent;
+	uint32_t size_nz;
 	uint32_t io_size_percent;
+	uint32_t io_size_nz;
 	uint32_t fill_device;
 	uint32_t file_append;
 	uint32_t unique_filename;
+	uint32_t pad3;
 	uint64_t file_size_low;
 	uint64_t file_size_high;
 	uint64_t start_offset;
 	uint64_t start_offset_align;
+	uint32_t start_offset_nz;
+	uint32_t pad4;
 
 	uint64_t bs[DDIR_RWDIR_CNT];
 	uint64_t ba[DDIR_RWDIR_CNT];
@@ -464,8 +474,6 @@ struct thread_options_pack {
 	struct zone_split zone_split[DDIR_RWDIR_CNT][ZONESPLIT_MAX];
 	uint32_t zone_split_nr[DDIR_RWDIR_CNT];
 
-	uint8_t pad1[4];
-
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
 	fio_fp64_t gauss_dev;
@@ -501,6 +509,7 @@ struct thread_options_pack {
 	uint64_t zone_capacity;
 	uint64_t zone_skip;
 	uint64_t lockmem;
+	uint32_t zone_skip_nz;
 	uint32_t mem_type;
 	uint32_t mem_align;
 
@@ -509,8 +518,6 @@ struct thread_options_pack {
 	uint32_t new_group;
 	uint32_t numjobs;
 
-	uint8_t pad3[4];
-
 	/*
 	 * We currently can't convert these, so don't enable them
 	 */
@@ -616,12 +623,14 @@ struct thread_options_pack {
 	uint32_t gid;
 
 	uint32_t offset_increment_percent;
+	uint32_t offset_increment_nz;
 	uint64_t offset_increment;
 	uint64_t number_ios;
 
 	uint64_t latency_target;
 	uint64_t latency_window;
 	uint64_t max_latency;
+	uint32_t pad5;
 	fio_fp64_t latency_percentile;
 	uint32_t latency_run;
 
diff --git a/zbd.c b/zbd.c
index 6a26fe10..d16b890f 100644
--- a/zbd.c
+++ b/zbd.c
@@ -285,9 +285,7 @@ static bool zbd_verify_sizes(void)
 				return false;
 			}
 
-			if (td->o.zone_skip &&
-			    (td->o.zone_skip < td->o.zone_size ||
-			     td->o.zone_skip % td->o.zone_size)) {
+			if (td->o.zone_skip % td->o.zone_size) {
 				log_err("%s: zoneskip %llu is not a multiple of the device zone size %llu.\n",
 					f->file_name, (unsigned long long) td->o.zone_skip,
 					(unsigned long long) td->o.zone_size);
@@ -335,20 +333,21 @@ static bool zbd_verify_bs(void)
 {
 	struct thread_data *td;
 	struct fio_file *f;
-	uint32_t zone_size;
 	int i, j, k;
 
 	for_each_td(td, i) {
 		for_each_file(td, f, j) {
+			uint64_t zone_size;
+
 			if (!f->zbd_info)
 				continue;
 			zone_size = f->zbd_info->zone_size;
 			for (k = 0; k < FIO_ARRAY_SIZE(td->o.bs); k++) {
 				if (td->o.verify != VERIFY_NONE &&
 				    zone_size % td->o.bs[k] != 0) {
-					log_info("%s: block size %llu is not a divisor of the zone size %d\n",
+					log_info("%s: block size %llu is not a divisor of the zone size %llu\n",
 						 f->file_name, td->o.bs[k],
-						 zone_size);
+						 (unsigned long long)zone_size);
 					return false;
 				}
 			}
@@ -648,7 +647,7 @@ static bool zbd_open_zone(struct thread_data *td, const struct fio_file *f,
 static int zbd_reset_zone(struct thread_data *td, struct fio_file *f,
 			  struct fio_zone_info *z);
 
-int zbd_setup_files(struct thread_data *td)
+int zbd_init_files(struct thread_data *td)
 {
 	struct fio_file *f;
 	int i;
@@ -657,6 +656,44 @@ int zbd_setup_files(struct thread_data *td)
 		if (zbd_init_zone_info(td, f))
 			return 1;
 	}
+	return 0;
+}
+
+void zbd_recalc_options_with_zone_granularity(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i;
+
+	for_each_file(td, f, i) {
+		struct zoned_block_device_info *zbd = f->zbd_info;
+		// zonemode=strided doesn't get per-file zone size.
+		uint64_t zone_size = zbd ? zbd->zone_size : td->o.zone_size;
+
+		if (zone_size == 0)
+			continue;
+
+		if (td->o.size_nz > 0) {
+			td->o.size = td->o.size_nz * zone_size;
+		}
+		if (td->o.io_size_nz > 0) {
+			td->o.io_size = td->o.io_size_nz * zone_size;
+		}
+		if (td->o.start_offset_nz > 0) {
+			td->o.start_offset = td->o.start_offset_nz * zone_size;
+		}
+		if (td->o.offset_increment_nz > 0) {
+			td->o.offset_increment = td->o.offset_increment_nz * zone_size;
+		}
+		if (td->o.zone_skip_nz > 0) {
+			td->o.zone_skip = td->o.zone_skip_nz * zone_size;
+		}
+	}
+}
+
+int zbd_setup_files(struct thread_data *td)
+{
+	struct fio_file *f;
+	int i;
 
 	if (!zbd_using_direct_io()) {
 		log_err("Using direct I/O is mandatory for writing to ZBD drives\n\n");
diff --git a/zbd.h b/zbd.h
index cc3ab624..64534393 100644
--- a/zbd.h
+++ b/zbd.h
@@ -87,6 +87,8 @@ struct zoned_block_device_info {
 	struct fio_zone_info	zone_info[0];
 };
 
+int zbd_init_files(struct thread_data *td);
+void zbd_recalc_options_with_zone_granularity(struct thread_data *td);
 int zbd_setup_files(struct thread_data *td);
 void zbd_free_zone_info(struct fio_file *f);
 void zbd_file_reset(struct thread_data *td, struct fio_file *f);

