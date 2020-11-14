Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgKNNAF (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 14 Nov 2020 08:00:05 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E91C0613D1
        for <fio@vger.kernel.org>; Sat, 14 Nov 2020 05:00:05 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdv9v-0006As-4F
        for fio@vger.kernel.org; Sat, 14 Nov 2020 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201114130001.9CE5B1BC011F@kernel.dk>
Date: Sat, 14 Nov 2020 06:00:01 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 84f9318fc16e33633ac9f789dcef7cc58c3b8595:

  t/latency_percentiles.py: tweak terse output parse (2020-11-12 11:26:58 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2ee239fb084355e115cf8c2bf8051e8807c4222a:

  Merge branch 'segmented-threads' (2020-11-13 10:06:26 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Wrap thread_data in thread_segment
      Add thread_segments as needed
      Kill off 'max_jobs'
      Merge branch 'segmented-threads'

 backend.c        |   5 +-
 fio.h            |  27 +++++++++--
 gettime-thread.c |   2 +-
 init.c           | 142 +++++++++++++++++++++++++++++--------------------------
 libfio.c         |   5 ++
 os/os-mac.h      |   6 ---
 os/os.h          |   4 --
 server.c         |   2 +-
 8 files changed, 108 insertions(+), 85 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index f91f3caf..2e6a377c 100644
--- a/backend.c
+++ b/backend.c
@@ -62,8 +62,9 @@ struct io_log *agg_io_log[DDIR_RWDIR_CNT];
 
 int groupid = 0;
 unsigned int thread_number = 0;
+unsigned int nr_segments = 0;
+unsigned int cur_segment = 0;
 unsigned int stat_number = 0;
-int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
 #ifdef PTHREAD_ERRORCHECK_MUTEX_INITIALIZER_NP
@@ -76,7 +77,7 @@ pthread_mutex_t overlap_check = PTHREAD_MUTEX_INITIALIZER;
 
 static void sig_int(int sig)
 {
-	if (threads) {
+	if (nr_segments) {
 		if (is_backend)
 			fio_server_got_signal(sig);
 		else {
diff --git a/fio.h b/fio.h
index 9d189eb8..fffec001 100644
--- a/fio.h
+++ b/fio.h
@@ -467,6 +467,12 @@ struct thread_data {
 
 };
 
+struct thread_segment {
+	struct thread_data *threads;
+	int shm_id;
+	int nr_threads;
+};
+
 /*
  * when should interactive ETA output be generated
  */
@@ -510,10 +516,15 @@ enum {
 #define __fio_stringify_1(x)	#x
 #define __fio_stringify(x)	__fio_stringify_1(x)
 
+#define REAL_MAX_JOBS		4096
+#define JOBS_PER_SEG		8
+#define REAL_MAX_SEG		(REAL_MAX_JOBS / JOBS_PER_SEG)
+
 extern bool exitall_on_terminate;
 extern unsigned int thread_number;
 extern unsigned int stat_number;
-extern int shm_id;
+extern unsigned int nr_segments;
+extern unsigned int cur_segment;
 extern int groupid;
 extern int output_format;
 extern int append_terse_output;
@@ -542,7 +553,15 @@ extern char *trigger_remote_cmd;
 extern long long trigger_timeout;
 extern char *aux_path;
 
-extern struct thread_data *threads;
+extern struct thread_segment segments[REAL_MAX_SEG];
+
+static inline struct thread_data *tnumber_to_td(unsigned int tnumber)
+{
+	struct thread_segment *seg;
+
+	seg = &segments[tnumber / JOBS_PER_SEG];
+	return &seg->threads[tnumber & (JOBS_PER_SEG - 1)];
+}
 
 static inline bool is_running_backend(void)
 {
@@ -557,8 +576,6 @@ static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 	       !(io_u->ddir == DDIR_TRIM && !td_trim(td)));
 }
 
-#define REAL_MAX_JOBS		4096
-
 static inline bool should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
@@ -709,7 +726,7 @@ extern void lat_target_reset(struct thread_data *);
  * Iterates all threads/processes within all the defined jobs
  */
 #define for_each_td(td, i)	\
-	for ((i) = 0, (td) = &threads[0]; (i) < (int) thread_number; (i)++, (td)++)
+	for ((i) = 0, (td) = &segments[0].threads[0]; (i) < (int) thread_number; (i)++, (td) = tnumber_to_td((i)))
 #define for_each_file(td, f, i)	\
 	if ((td)->files_index)						\
 		for ((i) = 0, (f) = (td)->files[0];			\
diff --git a/gettime-thread.c b/gettime-thread.c
index 953e4e67..86c2e2ef 100644
--- a/gettime-thread.c
+++ b/gettime-thread.c
@@ -58,7 +58,7 @@ static void *gtod_thread_main(void *data)
 	 * but I'm not sure what to use outside of a simple CPU nop to relax
 	 * it - we don't want to lose precision.
 	 */
-	while (threads) {
+	while (nr_segments) {
 		fio_gtod_update();
 		nop;
 	}
diff --git a/init.c b/init.c
index 7f64ce21..f9c20bdb 100644
--- a/init.c
+++ b/init.c
@@ -45,13 +45,12 @@ const char fio_version_string[] = FIO_VERSION;
 #define FIO_RANDSEED		(0xb1899bedUL)
 
 static char **ini_file;
-static int max_jobs = FIO_MAX_JOBS;
 static bool dump_cmdline;
 static bool parse_only;
 static bool merge_blktrace_only;
 
 static struct thread_data def_thread;
-struct thread_data *threads = NULL;
+struct thread_segment segments[REAL_MAX_SEG];
 static char **job_sections;
 static int nr_job_sections;
 
@@ -301,25 +300,34 @@ static struct option l_opts[FIO_NR_OPTIONS] = {
 
 void free_threads_shm(void)
 {
-	if (threads) {
-		void *tp = threads;
+	int i;
+
+	for (i = 0; i < nr_segments; i++) {
+		struct thread_segment *seg = &segments[i];
+
+		if (seg->threads) {
+			void *tp = seg->threads;
 #ifndef CONFIG_NO_SHM
-		struct shmid_ds sbuf;
+			struct shmid_ds sbuf;
 
-		threads = NULL;
-		shmdt(tp);
-		shmctl(shm_id, IPC_RMID, &sbuf);
-		shm_id = -1;
+			seg->threads = NULL;
+			shmdt(tp);
+			shmctl(seg->shm_id, IPC_RMID, &sbuf);
+			seg->shm_id = -1;
 #else
-		threads = NULL;
-		free(tp);
+			seg->threads = NULL;
+			free(tp);
 #endif
+		}
 	}
+
+	nr_segments = 0;
+	cur_segment = 0;
 }
 
 static void free_shm(void)
 {
-	if (threads) {
+	if (nr_segments) {
 		flow_exit();
 		fio_debug_jobp = NULL;
 		fio_warned = NULL;
@@ -337,71 +345,79 @@ static void free_shm(void)
 	scleanup();
 }
 
-/*
- * The thread area is shared between the main process and the job
- * threads/processes. So setup a shared memory segment that will hold
- * all the job info. We use the end of the region for keeping track of
- * open files across jobs, for file sharing.
- */
-static int setup_thread_area(void)
+static int add_thread_segment(void)
 {
+	struct thread_segment *seg = &segments[nr_segments];
+	size_t size = JOBS_PER_SEG * sizeof(struct thread_data);
 	int i;
 
-	if (threads)
-		return 0;
-
-	/*
-	 * 1024 is too much on some machines, scale max_jobs if
-	 * we get a failure that looks like too large a shm segment
-	 */
-	do {
-		size_t size = max_jobs * sizeof(struct thread_data);
+	if (nr_segments + 1 >= REAL_MAX_SEG) {
+		log_err("error: maximum number of jobs reached.\n");
+		return -1;
+	}
 
-		size += 2 * sizeof(unsigned int);
+	size += 2 * sizeof(unsigned int);
 
 #ifndef CONFIG_NO_SHM
-		shm_id = shmget(0, size, IPC_CREAT | 0600);
-		if (shm_id != -1)
-			break;
-		if (errno != EINVAL && errno != ENOMEM && errno != ENOSPC) {
+	seg->shm_id = shmget(0, size, IPC_CREAT | 0600);
+	if (seg->shm_id == -1) {
+		if (errno != EINVAL && errno != ENOMEM && errno != ENOSPC)
 			perror("shmget");
-			break;
-		}
+		return -1;
+	}
 #else
-		threads = malloc(size);
-		if (threads)
-			break;
+	seg->threads = malloc(size);
+	if (!seg->threads)
+		return -1;
 #endif
 
-		max_jobs >>= 1;
-	} while (max_jobs);
-
 #ifndef CONFIG_NO_SHM
-	if (shm_id == -1)
-		return 1;
-
-	threads = shmat(shm_id, NULL, 0);
-	if (threads == (void *) -1) {
+	seg->threads = shmat(seg->shm_id, NULL, 0);
+	if (seg->threads == (void *) -1) {
 		perror("shmat");
 		return 1;
 	}
 	if (shm_attach_to_open_removed())
-		shmctl(shm_id, IPC_RMID, NULL);
+		shmctl(seg->shm_id, IPC_RMID, NULL);
 #endif
 
-	memset(threads, 0, max_jobs * sizeof(struct thread_data));
-	for (i = 0; i < max_jobs; i++)
-		DRD_IGNORE_VAR(threads[i]);
-	fio_debug_jobp = (unsigned int *)(threads + max_jobs);
+	nr_segments++;
+
+	memset(seg->threads, 0, JOBS_PER_SEG * sizeof(struct thread_data));
+	for (i = 0; i < JOBS_PER_SEG; i++)
+		DRD_IGNORE_VAR(seg->threads[i]);
+	seg->nr_threads = 0;
+
+	/* Not first segment, we're done */
+	if (nr_segments != 1) {
+		cur_segment++;
+		return 0;
+	}
+
+	fio_debug_jobp = (unsigned int *)(seg->threads + JOBS_PER_SEG);
 	*fio_debug_jobp = -1;
 	fio_warned = fio_debug_jobp + 1;
 	*fio_warned = 0;
 
 	flow_init();
-
 	return 0;
 }
 
+/*
+ * The thread areas are shared between the main process and the job
+ * threads/processes, and is split into chunks of JOBS_PER_SEG. If the current
+ * segment has no more room, add a new chunk.
+ */
+static int expand_thread_area(void)
+{
+	struct thread_segment *seg = &segments[cur_segment];
+
+	if (nr_segments && seg->nr_threads < JOBS_PER_SEG)
+		return 0;
+
+	return add_thread_segment();
+}
+
 static void dump_print_option(struct print_option *p)
 {
 	const char *delim;
@@ -470,21 +486,19 @@ static void copy_opt_list(struct thread_data *dst, struct thread_data *src)
 static struct thread_data *get_new_job(bool global, struct thread_data *parent,
 				       bool preserve_eo, const char *jobname)
 {
+	struct thread_segment *seg;
 	struct thread_data *td;
 
 	if (global)
 		return &def_thread;
-	if (setup_thread_area()) {
+	if (expand_thread_area()) {
 		log_err("error: failed to setup shm segment\n");
 		return NULL;
 	}
-	if (thread_number >= max_jobs) {
-		log_err("error: maximum number of jobs (%d) reached.\n",
-				max_jobs);
-		return NULL;
-	}
 
-	td = &threads[thread_number++];
+	seg = &segments[cur_segment];
+	td = &seg->threads[seg->nr_threads++];
+	thread_number++;
 	*td = *parent;
 
 	INIT_FLIST_HEAD(&td->opt_list);
@@ -534,7 +548,8 @@ static void put_job(struct thread_data *td)
 	if (td->o.name)
 		free(td->o.name);
 
-	memset(&threads[td->thread_number - 1], 0, sizeof(*td));
+	memset(td, 0, sizeof(*td));
+	segments[cur_segment].nr_threads--;
 	thread_number--;
 }
 
@@ -2722,12 +2737,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 			warnings_fatal = 1;
 			break;
 		case 'j':
-			max_jobs = atoi(optarg);
-			if (!max_jobs || max_jobs > REAL_MAX_JOBS) {
-				log_err("fio: invalid max jobs: %d\n", max_jobs);
-				do_exit++;
-				exit_val = 1;
-			}
+			/* we don't track/need this anymore, ignore it */
 			break;
 		case 'S':
 			did_arg = true;
diff --git a/libfio.c b/libfio.c
index 7348b164..6144a474 100644
--- a/libfio.c
+++ b/libfio.c
@@ -156,8 +156,13 @@ void reset_all_stats(struct thread_data *td)
 
 void reset_fio_state(void)
 {
+	int i;
+
 	groupid = 0;
 	thread_number = 0;
+	cur_segment = 0;
+	for (i = 0; i < nr_segments; i++)
+		segments[i].nr_threads = 0;
 	stat_number = 0;
 	done_secs = 0;
 }
diff --git a/os/os-mac.h b/os/os-mac.h
index 2852ac67..683aab32 100644
--- a/os/os-mac.h
+++ b/os/os-mac.h
@@ -27,12 +27,6 @@
 #define fio_swap32(x)	OSSwapInt32(x)
 #define fio_swap64(x)	OSSwapInt64(x)
 
-/*
- * OSX has a pitifully small shared memory segment by default,
- * so default to a lower number of max jobs supported
- */
-#define FIO_MAX_JOBS		128
-
 #ifndef CONFIG_CLOCKID_T
 typedef unsigned int clockid_t;
 #endif
diff --git a/os/os.h b/os/os.h
index 9a280e54..b46f4164 100644
--- a/os/os.h
+++ b/os/os.h
@@ -172,10 +172,6 @@ extern int fio_cpus_split(os_cpu_mask_t *mask, unsigned int cpu);
 #endif
 #endif
 
-#ifndef FIO_MAX_JOBS
-#define FIO_MAX_JOBS		4096
-#endif
-
 #ifndef CONFIG_SOCKLEN_T
 typedef unsigned int socklen_t;
 #endif
diff --git a/server.c b/server.c
index 248a2d44..1b65297e 100644
--- a/server.c
+++ b/server.c
@@ -950,7 +950,7 @@ static int handle_update_job_cmd(struct fio_net_cmd *cmd)
 		return 0;
 	}
 
-	td = &threads[tnumber - 1];
+	td = tnumber_to_td(tnumber);
 	convert_thread_options_to_cpu(&td->o, &pdu->top);
 	send_update_job_reply(cmd->tag, 0);
 	return 0;

