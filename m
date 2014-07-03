Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:37468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaGCMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Jul 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X2fgK-0003jB-Ku
	for fio@vger.kernel.org; Thu, 03 Jul 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140703120003.313C7400D1@lyth.info>
Date: Thu,  3 Jul 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3310fcedbf11916c20aca6cffc20264a6e781e32:

  client: fix missing init of 'i' (2014-07-01 16:07:59 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 518dac097ec305d76fab3f0f45ce785a3849d8b5:

  log: fix use-after-free (2014-07-02 13:36:34 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      Cleanup logging
      --latency-log is now gone
      cconv: convert ->log_offset on the wire
      log: fix use-after-free

 README    |    1 -
 backend.c |   19 +++++++------
 cconv.c   |    2 ++
 init.c    |   31 ++++++++++++---------
 iolog.c   |   90 ++++++++++++++++++++++++++++---------------------------------
 iolog.h   |    7 +++--
 6 files changed, 78 insertions(+), 72 deletions(-)

---

Diff of recent changes:

diff --git a/README b/README
index 5897339..1f72876 100644
--- a/README
+++ b/README
@@ -148,7 +148,6 @@ $ fio
 	--parse-only		Parse options only, don't start any IO
 	--output		Write output to file
 	--runtime		Runtime in seconds
-	--latency-log		Generate per-job latency logs
 	--bandwidth-log		Generate per-job bandwidth logs
 	--minimal		Minimal (terse) output
 	--output-format=type	Output format (terse,json,normal)
diff --git a/backend.c b/backend.c
index ac6ed3e..448fc59 100644
--- a/backend.c
+++ b/backend.c
@@ -2020,9 +2020,9 @@ int fio_backend(void)
 		return 0;
 
 	if (write_bw_log) {
-		setup_log(&agg_io_log[DDIR_READ], 0, IO_LOG_TYPE_BW, 0);
-		setup_log(&agg_io_log[DDIR_WRITE], 0, IO_LOG_TYPE_BW, 0);
-		setup_log(&agg_io_log[DDIR_TRIM], 0, IO_LOG_TYPE_BW, 0);
+		setup_log(&agg_io_log[DDIR_READ], 0, IO_LOG_TYPE_BW, 0, "agg-read_bw.log");
+		setup_log(&agg_io_log[DDIR_WRITE], 0, IO_LOG_TYPE_BW, 0, "agg-write_bw.log");
+		setup_log(&agg_io_log[DDIR_TRIM], 0, IO_LOG_TYPE_BW, 0, "agg-trim_bw.log");
 	}
 
 	startup_mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
@@ -2041,11 +2041,14 @@ int fio_backend(void)
 	if (!fio_abort) {
 		show_run_stats();
 		if (write_bw_log) {
-			__finish_log(agg_io_log[DDIR_READ], "agg-read_bw.log");
-			__finish_log(agg_io_log[DDIR_WRITE],
-					"agg-write_bw.log");
-			__finish_log(agg_io_log[DDIR_TRIM],
-					"agg-write_bw.log");
+			int i;
+
+			for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+				struct io_log *log = agg_io_log[i];
+
+				__finish_log(log);
+				free_log(log);
+			}
 		}
 	}
 
diff --git a/cconv.c b/cconv.c
index 2f7177d..d253975 100644
--- a/cconv.c
+++ b/cconv.c
@@ -151,6 +151,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->rand_seed = le64_to_cpu(top->rand_seed);
 	o->use_os_rand = le32_to_cpu(top->use_os_rand);
 	o->log_avg_msec = le32_to_cpu(top->log_avg_msec);
+	o->log_offset = le32_to_cpu(top->log_offset);
 	o->norandommap = le32_to_cpu(top->norandommap);
 	o->softrandommap = le32_to_cpu(top->softrandommap);
 	o->bs_unaligned = le32_to_cpu(top->bs_unaligned);
@@ -321,6 +322,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->rand_seed = __cpu_to_le64(o->rand_seed);
 	top->use_os_rand = cpu_to_le32(o->use_os_rand);
 	top->log_avg_msec = cpu_to_le32(o->log_avg_msec);
+	top->log_offset = cpu_to_le32(o->log_offset);
 	top->norandommap = cpu_to_le32(o->norandommap);
 	top->softrandommap = cpu_to_le32(o->softrandommap);
 	top->bs_unaligned = cpu_to_le32(o->bs_unaligned);
diff --git a/init.c b/init.c
index 4f8b38d..c2d6109 100644
--- a/init.c
+++ b/init.c
@@ -64,8 +64,6 @@ int write_bw_log = 0;
 int read_only = 0;
 int status_interval = 0;
 
-static int write_lat_log;
-
 static int prev_group_jobs;
 
 unsigned long fio_debug = 0;
@@ -1056,6 +1054,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	char fname[PATH_MAX];
 	int numjobs, file_alloced;
 	struct thread_options *o = &td->o;
+	char logname[PATH_MAX + 32];
 
 	/*
 	 * the def_thread is just for options, it's not a real job
@@ -1145,20 +1144,27 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
 	if (setup_rate(td))
 		goto err;
 
-	if (o->lat_log_file || write_lat_log) {
+	if (o->lat_log_file) {
+		snprintf(logname, sizeof(logname), "%s_lat.log", o->lat_log_file);
 		setup_log(&td->lat_log, o->log_avg_msec, IO_LOG_TYPE_LAT,
-				o->log_offset);
+				o->log_offset, logname);
+		snprintf(logname, sizeof(logname), "%s_slat.log", o->lat_log_file);
 		setup_log(&td->slat_log, o->log_avg_msec, IO_LOG_TYPE_SLAT,
-				o->log_offset);
+				o->log_offset, logname);
+		snprintf(logname, sizeof(logname), "%s_clat.log", o->lat_log_file);
 		setup_log(&td->clat_log, o->log_avg_msec, IO_LOG_TYPE_CLAT,
-				o->log_offset);
+				o->log_offset, logname);
 	}
-	if (o->bw_log_file || write_bw_log)
+	if (o->bw_log_file) {
+		snprintf(logname, sizeof(logname), "%s_bw.log", o->bw_log_file);
 		setup_log(&td->bw_log, o->log_avg_msec, IO_LOG_TYPE_BW,
-				o->log_offset);
-	if (o->iops_log_file)
+				o->log_offset, logname);
+	}
+	if (o->iops_log_file) {
+		snprintf(logname, sizeof(logname), "%s_iops.log", o->iops_log_file);
 		setup_log(&td->iops_log, o->log_avg_msec, IO_LOG_TYPE_IOPS,
-				o->log_offset);
+				o->log_offset, logname);
+	}
 
 	if (!o->name)
 		o->name = strdup(jobname);
@@ -1515,7 +1521,6 @@ static void usage(const char *name)
 	printf("  --parse-only\t\tParse options only, don't start any IO\n");
 	printf("  --output\t\tWrite output to file\n");
 	printf("  --runtime\t\tRuntime in seconds\n");
-	printf("  --latency-log\t\tGenerate per-job latency logs\n");
 	printf("  --bandwidth-log\tGenerate per-job bandwidth logs\n");
 	printf("  --minimal\t\tMinimal (terse) output\n");
 	printf("  --output-format=x\tOutput format (terse,json,normal)\n");
@@ -1756,7 +1761,9 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			}
 			break;
 		case 'l':
-			write_lat_log = 1;
+			log_err("fio: --latency-log is deprecated. Use per-job latency log options.\n");
+			do_exit++;
+			exit_val = 1;
 			break;
 		case 'b':
 			write_bw_log = 1;
diff --git a/iolog.c b/iolog.c
index a79efe2..96afec6 100644
--- a/iolog.c
+++ b/iolog.c
@@ -540,7 +540,7 @@ int init_iolog(struct thread_data *td)
 }
 
 void setup_log(struct io_log **log, unsigned long avg_msec, int log_type,
-	       int log_offset)
+	       int log_offset, const char *filename)
 {
 	struct io_log *l = malloc(sizeof(*l));
 
@@ -551,6 +551,7 @@ void setup_log(struct io_log **log, unsigned long avg_msec, int log_type,
 	l->log_offset = log_offset;
 	l->log = malloc(l->max_samples * log_entry_sz(l));
 	l->avg_msec = avg_msec;
+	l->filename = strdup(filename);
 	*log = l;
 }
 
@@ -580,13 +581,20 @@ static void clear_file_buffer(void *buf)
 }
 #endif
 
-void __finish_log(struct io_log *log, const char *name)
+void free_log(struct io_log *log)
+{
+	free(log->log);
+	free(log->filename);
+	free(log);
+}
+
+void __finish_log(struct io_log *log)
 {
 	uint64_t i;
 	void *buf;
 	FILE *f;
 
-	f = fopen(name, "a");
+	f = fopen(log->filename, "a");
 	if (!f) {
 		perror("fopen log");
 		return;
@@ -615,90 +623,74 @@ void __finish_log(struct io_log *log, const char *name)
 
 	fclose(f);
 	clear_file_buffer(buf);
-	free(log->log);
-	free(log);
 }
 
-static int finish_log_named(struct thread_data *td, struct io_log *log,
-			    const char *prefix, const char *postfix,
-			    int trylock)
+static int finish_log(struct thread_data *td, struct io_log *log, int trylock)
 {
-	char file_name[256];
-
-	snprintf(file_name, sizeof(file_name), "%s_%s.log", prefix, postfix);
-
 	if (trylock) {
-		if (fio_trylock_file(file_name))
+		if (fio_trylock_file(log->filename))
 			return 1;
 	} else
-		fio_lock_file(file_name);
+		fio_lock_file(log->filename);
 
 	if (td->client_type == FIO_CLIENT_TYPE_GUI) {
-		fio_send_iolog(td, log, file_name);
-		free(log->log);
-		free(log);
+		fio_send_iolog(td, log, log->filename);
 	} else
-		__finish_log(log, file_name);
+		__finish_log(log);
 
-	fio_unlock_file(file_name);
+	fio_unlock_file(log->filename);
+	free_log(log);
 	return 0;
 }
 
-static int finish_log(struct thread_data *td, struct io_log *log,
-		      const char *name, int trylock)
-{
-	return finish_log_named(td, log, td->o.name, name, trylock);
-}
-
-static int write_this_log(struct thread_data *td, struct io_log *log,
-			  const char *log_file, const char *name, int try)
+static int write_iops_log(struct thread_data *td, int try)
 {
-	int ret;
+	struct io_log *log = td->iops_log;
 
 	if (!log)
 		return 0;
 
-	if (log_file)
-		ret = finish_log_named(td, log, log_file, name, try);
-	else
-		ret = finish_log(td, log, name, try);
-
-	return ret;
-}
-
-static int write_iops_log(struct thread_data *td, int try)
-{
-	struct thread_options *o = &td->o;
-
-	return write_this_log(td, td->iops_log, o->iops_log_file, "iops", try);
+	return finish_log(td, log, try);
 }
 
 static int write_slat_log(struct thread_data *td, int try)
 {
-	struct thread_options *o = &td->o;
+	struct io_log *log = td->slat_log;
 
-	return write_this_log(td, td->slat_log, o->lat_log_file, "slat", try);
+	if (!log)
+		return 0;
+
+	return finish_log(td, log, try);
 }
 
 static int write_clat_log(struct thread_data *td, int try)
 {
-	struct thread_options *o = &td->o;
+	struct io_log *log = td->clat_log;
 
-	return write_this_log(td, td->clat_log, o->lat_log_file, "clat" , try);
+	if (!log)
+		return 0;
+
+	return finish_log(td, log, try);
 }
 
 static int write_lat_log(struct thread_data *td, int try)
 {
-	struct thread_options *o = &td->o;
+	struct io_log *log = td->lat_log;
+
+	if (!log)
+		return 0;
 
-	return write_this_log(td, td->lat_log, o->lat_log_file, "lat", try);
+	return finish_log(td, log, try);
 }
 
 static int write_bandw_log(struct thread_data *td, int try)
 {
-	struct thread_options *o = &td->o;
+	struct io_log *log = td->bw_log;
+
+	if (!log)
+		return 0;
 
-	return write_this_log(td, td->bw_log, o->bw_log_file, "bw", try);
+	return finish_log(td, log, try);
 }
 
 enum {
diff --git a/iolog.h b/iolog.h
index eed9297..f97d91f 100644
--- a/iolog.h
+++ b/iolog.h
@@ -52,6 +52,8 @@ struct io_log {
 	uint64_t max_samples;
 	void *log;
 
+	char *filename;
+
 	unsigned int log_type;
 
 	/*
@@ -167,8 +169,9 @@ extern void add_iops_sample(struct thread_data *, enum fio_ddir, unsigned int,
 				struct timeval *);
 extern void init_disk_util(struct thread_data *);
 extern void update_rusage_stat(struct thread_data *);
-extern void setup_log(struct io_log **, unsigned long, int, int);
-extern void __finish_log(struct io_log *, const char *);
+extern void setup_log(struct io_log **, unsigned long, int, int, const char *);
+extern void __finish_log(struct io_log *);
+extern void free_log(struct io_log *);
 extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 extern int write_bw_log;
 extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
