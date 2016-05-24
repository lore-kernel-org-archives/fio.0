Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36457 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbcEXMAD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 24 May 2016 08:00:03 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1b5B0E-0003Ar-Kf
	for fio@vger.kernel.org; Tue, 24 May 2016 12:00:02 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160524120001.C7A822C00DF@kernel.dk>
Date: Tue, 24 May 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ac32c6a20a37e850d721aee082493838b184fed1:

  Fio 2.10 (2016-05-21 09:00:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bbcacb72ac5f81b77a96981e6d00d9134360e7c5:

  parse: warn if option is missing a long option variant (2016-05-23 10:39:16 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      options: add 'unique_filename'
      cconv: wire up conversion of unique_filename
      options: add missing long option names
      parse: warn if option is missing a long option variant

 HOWTO            |  5 +++++
 cconv.c          |  2 ++
 filesetup.c      |  3 ++-
 fio.1            |  5 +++++
 options.c        | 29 +++++++++++++++++++++++++++--
 options.h        |  2 +-
 parse.c          |  2 ++
 server.h         |  2 +-
 thread_options.h |  8 +++++---
 9 files changed, 50 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 9ed2c5f..cec4e42 100644
--- a/HOWTO
+++ b/HOWTO
@@ -374,6 +374,11 @@ filename_format=str
 		default of $jobname.$jobnum.$filenum will be used if
 		no other format specifier is given.
 
+unique_filename=bool	To avoid collisions between networked clients, fio
+		defaults to prefixing any generated filenames (with a directory
+		specified) with the source of the client connecting. To disable
+		this behavior, set this option to 0.
+
 opendir=str	Tell fio to recursively add any file it can find in this
 		directory and down the file system tree.
 
diff --git a/cconv.c b/cconv.c
index 0c3a36c..ac826a3 100644
--- a/cconv.c
+++ b/cconv.c
@@ -139,6 +139,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 
 	o->ratecycle = le32_to_cpu(top->ratecycle);
 	o->io_submit_mode = le32_to_cpu(top->io_submit_mode);
+	o->unique_filename = le32_to_cpu(top->unique_filename);
 	o->nr_files = le32_to_cpu(top->nr_files);
 	o->open_files = le32_to_cpu(top->open_files);
 	o->file_lock_mode = le32_to_cpu(top->file_lock_mode);
@@ -333,6 +334,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->ratecycle = cpu_to_le32(o->ratecycle);
 	top->io_submit_mode = cpu_to_le32(o->io_submit_mode);
 	top->nr_files = cpu_to_le32(o->nr_files);
+	top->unique_filename = cpu_to_le32(o->unique_filename);
 	top->open_files = cpu_to_le32(o->open_files);
 	top->file_lock_mode = cpu_to_le32(o->file_lock_mode);
 	top->odirect = cpu_to_le32(o->odirect);
diff --git a/filesetup.c b/filesetup.c
index f721c36..012773b 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1335,7 +1335,8 @@ int add_file(struct thread_data *td, const char *fname, int numjob, int inc)
 	dprint(FD_FILE, "add file %s\n", fname);
 
 	if (td->o.directory)
-		len = set_name_idx(file_name, PATH_MAX, td->o.directory, numjob);
+		len = set_name_idx(file_name, PATH_MAX, td->o.directory, numjob,
+					td->o.unique_filename);
 
 	sprintf(file_name + len, "%s", fname);
 
diff --git a/fio.1 b/fio.1
index 5e4cd4f..839a359 100644
--- a/fio.1
+++ b/fio.1
@@ -247,6 +247,11 @@ will be used if no other format specifier is given.
 .RE
 .P
 .TP
+.BI unique_filename \fR=\fPbool
+To avoid collisions between networked clients, fio defaults to prefixing
+any generated filenames (with a directory specified) with the source of
+the client connecting. To disable this behavior, set this option to 0.
+.TP
 .BI lockfile \fR=\fPstr
 Fio defaults to not locking any files before it does IO to them. If a file or
 file descriptor is shared, fio can serialize IO to that file to make the end
diff --git a/options.c b/options.c
index 07589c4..7f0f2c0 100644
--- a/options.c
+++ b/options.c
@@ -1124,7 +1124,8 @@ static int get_max_name_idx(char *input)
  * Returns the directory at the index, indexes > entires will be
  * assigned via modulo division of the index
  */
-int set_name_idx(char *target, size_t tlen, char *input, int index)
+int set_name_idx(char *target, size_t tlen, char *input, int index,
+		 bool unique_filename)
 {
 	unsigned int cur_idx;
 	int len;
@@ -1136,7 +1137,7 @@ int set_name_idx(char *target, size_t tlen, char *input, int index)
 	for (cur_idx = 0; cur_idx <= index; cur_idx++)
 		fname = get_next_name(&str);
 
-	if (client_sockaddr_str[0]) {
+	if (client_sockaddr_str[0] && unique_filename) {
 		len = snprintf(target, tlen, "%s/%s.", fname,
 				client_sockaddr_str);
 	} else
@@ -1390,6 +1391,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "filename_format",
+		.lname	= "Filename Format",
 		.type	= FIO_OPT_STR_STORE,
 		.off1	= td_var_offset(filename_format),
 		.prio	= -1, /* must come after "directory" */
@@ -1399,6 +1401,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_FILENAME,
 	},
 	{
+		.name	= "unique_filename",
+		.lname	= "Unique Filename",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(unique_filename),
+		.help	= "For network clients, prefix file with source IP",
+		.def	= "1",
+		.category = FIO_OPT_C_FILE,
+		.group	= FIO_OPT_G_FILENAME,
+	},
+	{
 		.name	= "lockfile",
 		.lname	= "Lockfile",
 		.type	= FIO_OPT_STR,
@@ -1965,6 +1977,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "random_generator",
+		.lname	= "Random Generator",
 		.type	= FIO_OPT_STR,
 		.off1	= td_var_offset(random_generator),
 		.help	= "Type of random number generator to use",
@@ -1989,6 +2002,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "random_distribution",
+		.lname	= "Random Distribution",
 		.type	= FIO_OPT_STR,
 		.off1	= td_var_offset(random_distribution),
 		.cb	= str_random_distribution_cb,
@@ -2044,6 +2058,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "allrandrepeat",
+		.lname	= "All Random Repeat",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(allrand_repeatable),
 		.help	= "Use repeatable random numbers for everything",
@@ -2543,6 +2558,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "verifysort_nr",
+		.lname	= "Verify Sort Nr",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(verifysort_nr),
 		.help	= "Pre-load and sort verify blocks for a read workload",
@@ -2664,6 +2680,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #endif
 	{
 		.name	= "experimental_verify",
+		.lname	= "Experimental Verify",
 		.off1	= td_var_offset(experimental_verify),
 		.type	= FIO_OPT_BOOL,
 		.help	= "Enable experimental verification",
@@ -3078,6 +3095,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "max_latency",
+		.lname	= "Max Latency",
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(max_latency),
 		.help	= "Maximum tolerated IO latency (usec)",
@@ -3172,6 +3190,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "create_only",
+		.lname	= "Create Only",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(create_only),
 		.help	= "Only perform file creation phase",
@@ -3254,6 +3273,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 #ifdef CONFIG_LIBNUMA
 	{
 		.name	= "numa_cpu_nodes",
+		.lname	= "NUMA CPU Nodes",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_cpunodes_cb,
 		.off1	= td_var_offset(numa_cpunodes),
@@ -3263,6 +3283,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "numa_mem_policy",
+		.lname	= "NUMA Memory Policy",
 		.type	= FIO_OPT_STR,
 		.cb	= str_numa_mpol_cb,
 		.off1	= td_var_offset(numa_memnodes),
@@ -3353,6 +3374,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "per_job_logs",
+		.lname	= "Per Job Logs",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(per_job_logs),
 		.help	= "Include job number in generated log files or not",
@@ -3683,6 +3705,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "unified_rw_reporting",
+		.lname	= "Unified RW Reporting",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(unified_rw_rep),
 		.help	= "Unify reporting across data direction",
@@ -3736,6 +3759,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "ignore_error",
+		.lname	= "Ignore Error",
 		.type	= FIO_OPT_STR,
 		.cb	= str_ignore_error_cb,
 		.off1	= td_var_offset(ignore_error_nr),
@@ -3746,6 +3770,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 	},
 	{
 		.name	= "error_dump",
+		.lname	= "Error Dump",
 		.type	= FIO_OPT_BOOL,
 		.off1	= td_var_offset(error_dump),
 		.def	= "0",
diff --git a/options.h b/options.h
index 6a5db07..4727bac 100644
--- a/options.h
+++ b/options.h
@@ -20,7 +20,7 @@ void del_opt_posval(const char *, const char *);
 struct thread_data;
 void fio_options_free(struct thread_data *);
 char *get_name_idx(char *, int);
-int set_name_idx(char *, size_t, char *, int);
+int set_name_idx(char *, size_t, char *, int, bool);
 
 extern char client_sockaddr_str[];  /* used with --client option */
 
diff --git a/parse.c b/parse.c
index ec0f870..963f1f8 100644
--- a/parse.c
+++ b/parse.c
@@ -1234,6 +1234,8 @@ void option_init(struct fio_option *o)
 {
 	if (o->type == FIO_OPT_DEPRECATED)
 		return;
+	if (o->name && !o->lname)
+		log_err("Option %s: missing long option name\n", o->name);
 	if (o->type == FIO_OPT_BOOL) {
 		o->minval = 0;
 		o->maxval = 1;
diff --git a/server.h b/server.h
index 7fc3ec6..79c751d 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 53,
+	FIO_SERVER_VER			= 54,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/thread_options.h b/thread_options.h
index 10d7ba6..edf090d 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -65,6 +65,8 @@ struct thread_options {
 	unsigned int iodepth_batch_complete_min;
 	unsigned int iodepth_batch_complete_max;
 
+	unsigned int unique_filename;
+
 	unsigned long long size;
 	unsigned long long io_limit;
 	unsigned int size_percent;
@@ -325,6 +327,7 @@ struct thread_options_pack {
 	uint32_t size_percent;
 	uint32_t fill_device;
 	uint32_t file_append;
+	uint32_t unique_filename;
 	uint64_t file_size_low;
 	uint64_t file_size_high;
 	uint64_t start_offset;
@@ -388,6 +391,7 @@ struct thread_options_pack {
 	uint32_t bs_unaligned;
 	uint32_t fsync_on_close;
 	uint32_t bs_is_seq_rand;
+	uint32_t pad1;
 
 	uint32_t random_distribution;
 	uint32_t exitall_error;
@@ -411,7 +415,6 @@ struct thread_options_pack {
 	uint32_t fsync_blocks;
 	uint32_t fdatasync_blocks;
 	uint32_t barrier_blocks;
-	uint32_t pad1;
 	uint64_t start_delay;
 	uint64_t start_delay_high;
 	uint64_t timeout;
@@ -476,7 +479,6 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t pad2;
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
@@ -531,7 +533,7 @@ struct thread_options_pack {
 	uint64_t number_ios;
 
 	uint32_t sync_file_range;
-	uint32_t pad3;
+	uint32_t pad2;
 
 	uint64_t latency_target;
 	uint64_t latency_window;
