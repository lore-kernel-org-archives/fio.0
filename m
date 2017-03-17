Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:43642 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdCQMAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Mar 2017 08:00:08 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1coqYA-0000GG-ET
        for fio@vger.kernel.org; Fri, 17 Mar 2017 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20170317120001.7A2A62C27A4@kernel.dk>
Date: Fri, 17 Mar 2017 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 06eac6b2318da7759a055c4a3ac01c2c1e8aa764:

  configure: add generic pshared mutex test (2017-03-14 10:52:42 +0000)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8243be59aa35aa016fcbeee99353b08376953911:

  Add 'stats' option (2017-03-16 14:43:37 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      filesetup: remove bogus message on forcing file size
      Add 'stats' option

 HOWTO            |  6 ++++++
 cconv.c          |  2 ++
 filesetup.c      |  3 ---
 fio.1            |  4 ++++
 io_u.c           |  5 ++++-
 options.c        | 10 ++++++++++
 stat.c           |  6 ++++++
 thread_options.h |  3 ++-
 8 files changed, 34 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e376ea5..5d378f3 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2593,6 +2593,12 @@ Measurements and reporting
 	all jobs in a file will be part of the same reporting group, unless
 	separated by a :option:`stonewall`.
 
+.. option:: stats
+
+	By default, fio collects and shows final output results for all jobs
+	that run. If this option is set to 0, then fio will ignore it in
+	the final stat output.
+
 .. option:: write_bw_log=str
 
 	If given, write a bandwidth log for this job. Can be used to store data of
diff --git a/cconv.c b/cconv.c
index b329bf4..886140d 100644
--- a/cconv.c
+++ b/cconv.c
@@ -242,6 +242,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->ioprio_class = le32_to_cpu(top->ioprio_class);
 	o->file_service_type = le32_to_cpu(top->file_service_type);
 	o->group_reporting = le32_to_cpu(top->group_reporting);
+	o->stats = le32_to_cpu(top->stats);
 	o->fadvise_hint = le32_to_cpu(top->fadvise_hint);
 	o->fallocate_mode = le32_to_cpu(top->fallocate_mode);
 	o->zero_buffers = le32_to_cpu(top->zero_buffers);
@@ -426,6 +427,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->ioprio_class = cpu_to_le32(o->ioprio_class);
 	top->file_service_type = cpu_to_le32(o->file_service_type);
 	top->group_reporting = cpu_to_le32(o->group_reporting);
+	top->stats = cpu_to_le32(o->stats);
 	top->fadvise_hint = cpu_to_le32(o->fadvise_hint);
 	top->fallocate_mode = cpu_to_le32(o->fallocate_mode);
 	top->zero_buffers = cpu_to_le32(o->zero_buffers);
diff --git a/filesetup.c b/filesetup.c
index f2e47b1..c9f2b5f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -942,9 +942,6 @@ int setup_files(struct thread_data *td)
 				if (f->file_offset > f->real_file_size)
 					goto err_offset;
 				f->io_size = f->real_file_size - f->file_offset;
-				log_info("fio: forcing file %s size to %llu\n",
-					f->file_name,
-					(unsigned long long)f->io_size);
 				if (!f->io_size)
 					log_info("fio: file %s may be ignored\n",
 						f->file_name);
diff --git a/fio.1 b/fio.1
index 3348513..b59025d 100644
--- a/fio.1
+++ b/fio.1
@@ -1548,6 +1548,10 @@ Wait for preceding jobs in the job file to exit before starting this one.
 Start a new reporting group.  If not given, all jobs in a file will be part
 of the same reporting group, unless separated by a stonewall.
 .TP
+.BI stats \fR=\fPbool
+By default, fio collects and shows final output results for all jobs that run.
+If this option is set to 0, then fio will ignore it in the final stat output.
+.TP
 .BI numjobs \fR=\fPint
 Number of clones (processes/threads performing the same workload) of this job.
 Default: 1.
diff --git a/io_u.c b/io_u.c
index cb8fc4a..f6efae0 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1734,6 +1734,9 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	if (td->parent)
 		td = td->parent;
 
+	if (!td->o.stats)
+		return;
+
 	if (no_reduce)
 		lusec = utime_since(&io_u->issue_time, &icd->time);
 
@@ -1994,7 +1997,7 @@ int io_u_queued_complete(struct thread_data *td, int min_evts)
  */
 void io_u_queued(struct thread_data *td, struct io_u *io_u)
 {
-	if (!td->o.disable_slat && ramp_time_over(td)) {
+	if (!td->o.disable_slat && ramp_time_over(td) && td->o.stats) {
 		unsigned long slat_time;
 
 		slat_time = utime_since(&io_u->start_time, &io_u->issue_time);
diff --git a/options.c b/options.c
index dcf0eea..e0deab0 100644
--- a/options.c
+++ b/options.c
@@ -3866,6 +3866,16 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_INVALID,
 	},
 	{
+		.name	= "stats",
+		.lname	= "Stats",
+		.type	= FIO_OPT_BOOL,
+		.off1	= offsetof(struct thread_options, stats),
+		.help	= "Enable collection of stats",
+		.def	= "1",
+		.category = FIO_OPT_C_STAT,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "zero_buffers",
 		.lname	= "Zero I/O buffers",
 		.type	= FIO_OPT_STR_SET,
diff --git a/stat.c b/stat.c
index 0bb21d0..fde7af2 100644
--- a/stat.c
+++ b/stat.c
@@ -1582,6 +1582,8 @@ void __show_run_stats(void)
 		}
 		if (last_ts == td->groupid)
 			continue;
+		if (!td->o.stats)
+			continue;
 
 		last_ts = td->groupid;
 		nr_ts++;
@@ -1599,6 +1601,8 @@ void __show_run_stats(void)
 	last_ts = -1;
 	idx = 0;
 	for_each_td(td, i) {
+		if (!td->o.stats)
+			continue;
 		if (idx && (!td->o.group_reporting ||
 		    (td->o.group_reporting && last_ts != td->groupid))) {
 			idx = 0;
@@ -2569,6 +2573,8 @@ int calc_log_samples(void)
 	fio_gettime(&now, NULL);
 
 	for_each_td(td, i) {
+		if (!td->o.stats)
+			continue;
 		if (in_ramp_time(td) ||
 		    !(td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING)) {
 			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
diff --git a/thread_options.h b/thread_options.h
index 5e72867..2b2df33 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -206,6 +206,7 @@ struct thread_options {
 	unsigned int ioprio_class;
 	unsigned int file_service_type;
 	unsigned int group_reporting;
+	unsigned int stats;
 	unsigned int fadvise_hint;
 	unsigned int fadvise_stream;
 	enum fio_fallocate_mode fallocate_mode;
@@ -475,6 +476,7 @@ struct thread_options_pack {
 	uint32_t ioprio_class;
 	uint32_t file_service_type;
 	uint32_t group_reporting;
+	uint32_t stats;
 	uint32_t fadvise_hint;
 	uint32_t fadvise_stream;
 	uint32_t fallocate_mode;
@@ -502,7 +504,6 @@ struct thread_options_pack {
 	uint64_t trim_backlog;
 	uint32_t clat_percentiles;
 	uint32_t percentile_precision;
-	uint32_t padding;	/* REMOVE ME when possible to maintain alignment */
 	fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
 
 	uint8_t read_iolog_file[FIO_TOP_STR_MAX];
