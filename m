Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933325AbaJXMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 24 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XhdXI-0004K7-SY
	for fio@vger.kernel.org; Fri, 24 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141024120003.B1DA2401CA@lyth.info>
Date: Fri, 24 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 60a5a18b811cd60430d2912b49fa3970df0d5077:

  t/dedupe: fix init of all thread variables (2014-10-21 13:02:29 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 98b4b0a286c2a8c77d9cefd84cfaf47544b5b9e0:

  diskutil: get rid of disk_util_start_exit() (2014-10-23 23:47:01 -0600)

----------------------------------------------------------------
Jens Axboe (7):
      Fix exit being slowed by disk util stat time
      Get rid of (now unused) disk_util_mutex
      backend: remove debug du thread exit notice
      Start and stop status interval (or file) thread separately
      stat: avoid hang with race in stat thread exit and rusage update
      Consolidate disk util, eta, and status check thread
      diskutil: get rid of disk_util_start_exit()

 backend.c  |   86 ++++++++++++++++++++++++++++++++++++++----------------------
 diskutil.c |    2 +-
 diskutil.h |   10 ++-----
 fio.h      |    2 ++
 stat.c     |   41 +++++++++--------------------
 stat.h     |    1 +
 6 files changed, 73 insertions(+), 69 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 3016e98..d19d870 100644
--- a/backend.c
+++ b/backend.c
@@ -55,8 +55,11 @@
 #include "err.h"
 #include "lib/tp.h"
 
-static pthread_t disk_util_thread;
-static struct fio_mutex *disk_thread_mutex;
+static pthread_t helper_thread;
+static pthread_mutex_t helper_lock;
+pthread_cond_t helper_cond;
+int helper_do_stat = 0;
+
 static struct fio_mutex *startup_mutex;
 static struct flist_head *cgroup_list;
 static char *cgroup_mnt;
@@ -73,7 +76,7 @@ unsigned int stat_number = 0;
 int shm_id = 0;
 int temp_stall_ts;
 unsigned long done_secs = 0;
-volatile int disk_util_exit = 0;
+volatile int helper_exit = 0;
 
 #define PAGE_ALIGN(buf)	\
 	(char *) (((uintptr_t) (buf) + page_mask) & ~page_mask)
@@ -1562,13 +1565,17 @@ err:
 	if (o->write_iolog_file)
 		write_iolog_close(td);
 
-	fio_mutex_remove(td->rusage_sem);
-	td->rusage_sem = NULL;
-
 	fio_mutex_remove(td->mutex);
 	td->mutex = NULL;
 
 	td_set_runstate(td, TD_EXITED);
+
+	/*
+	 * Do this last after setting our runstate to exited, so we
+	 * know that the stat thread is signaled.
+	 */
+	check_update_rusage(td);
+
 	return (void *) (uintptr_t) td->error;
 }
 
@@ -1970,57 +1977,70 @@ static void run_threads(void)
 	update_io_ticks();
 }
 
-void wait_for_disk_thread_exit(void)
+static void wait_for_helper_thread_exit(void)
 {
-	fio_mutex_down(disk_thread_mutex);
+	void *ret;
+
+	helper_exit = 1;
+	pthread_cond_signal(&helper_cond);
+	pthread_join(helper_thread, &ret);
 }
 
 static void free_disk_util(void)
 {
-	disk_util_start_exit();
-	wait_for_disk_thread_exit();
 	disk_util_prune_entries();
+
+	pthread_cond_destroy(&helper_cond);
 }
 
-static void *disk_thread_main(void *data)
+static void *helper_thread_main(void *data)
 {
 	int ret = 0;
 
 	fio_mutex_up(startup_mutex);
 
-	while (threads && !ret) {
-		usleep(DISK_UTIL_MSEC * 1000);
-		if (!threads)
-			break;
+	while (!ret) {
+		uint64_t sec = DISK_UTIL_MSEC / 1000;
+		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
+		struct timespec ts;
+		struct timeval tv;
+
+		gettimeofday(&tv, NULL);
+		ts.tv_sec = tv.tv_sec + sec;
+		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
+		if (ts.tv_nsec > 1000000000ULL) {
+			ts.tv_nsec -= 1000000000ULL;
+			ts.tv_sec++;
+		}
+
+		pthread_cond_timedwait(&helper_cond, &helper_lock, &ts);
+
 		ret = update_io_ticks();
 
+		if (helper_do_stat) {
+			helper_do_stat = 0;
+			__show_running_run_stats();
+		}
+
 		if (!is_backend)
 			print_thread_status();
 	}
 
-	fio_mutex_up(disk_thread_mutex);
 	return NULL;
 }
 
-static int create_disk_util_thread(void)
+static int create_helper_thread(void)
 {
 	int ret;
 
 	setup_disk_util();
 
-	disk_thread_mutex = fio_mutex_init(FIO_MUTEX_LOCKED);
+	pthread_cond_init(&helper_cond, NULL);
+	pthread_mutex_init(&helper_lock, NULL);
 
-	ret = pthread_create(&disk_util_thread, NULL, disk_thread_main, NULL);
+	ret = pthread_create(&helper_thread, NULL, helper_thread_main, NULL);
 	if (ret) {
-		fio_mutex_remove(disk_thread_mutex);
-		log_err("Can't create disk util thread: %s\n", strerror(ret));
-		return 1;
-	}
-
-	ret = pthread_detach(disk_util_thread);
-	if (ret) {
-		fio_mutex_remove(disk_thread_mutex);
-		log_err("Can't detatch disk util thread: %s\n", strerror(ret));
+		log_err("Can't create helper thread: %s\n", strerror(ret));
 		return 1;
 	}
 
@@ -2060,13 +2080,15 @@ int fio_backend(void)
 
 	set_genesis_time();
 	stat_init();
-	create_disk_util_thread();
+	create_helper_thread();
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	INIT_FLIST_HEAD(cgroup_list);
 
 	run_threads();
 
+	wait_for_helper_thread_exit();
+
 	if (!fio_abort) {
 		__show_run_stats();
 		if (write_bw_log) {
@@ -2081,8 +2103,11 @@ int fio_backend(void)
 		}
 	}
 
-	for_each_td(td, i)
+	for_each_td(td, i) {
 		fio_options_free(td);
+		fio_mutex_remove(td->rusage_sem);
+		td->rusage_sem = NULL;
+	}
 
 	free_disk_util();
 	cgroup_kill(cgroup_list);
@@ -2090,7 +2115,6 @@ int fio_backend(void)
 	sfree(cgroup_mnt);
 
 	fio_mutex_remove(startup_mutex);
-	fio_mutex_remove(disk_thread_mutex);
 	stat_exit();
 	return exit_value;
 }
diff --git a/diskutil.c b/diskutil.c
index c5c5ea6..51da8a0 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -117,7 +117,7 @@ int update_io_ticks(void)
 
 	fio_mutex_down(disk_util_mutex);
 
-	if (!disk_util_exit) {
+	if (!helper_exit) {
 		flist_for_each(entry, &disk_list) {
 			du = flist_entry(entry, struct disk_util, list);
 			update_io_tick_disk(du);
diff --git a/diskutil.h b/diskutil.h
index d86e4ec..8623fd7 100644
--- a/diskutil.h
+++ b/diskutil.h
@@ -3,7 +3,7 @@
 #include "json.h"
 #define FIO_DU_NAME_SZ		64
 
-extern volatile int disk_util_exit;
+extern volatile int helper_exit;
 
 struct disk_util_stats {
 	uint32_t ios[2];
@@ -100,8 +100,6 @@ static inline void disk_util_dec(struct disk_util *du)
 
 extern struct flist_head disk_list;
 
-extern void wait_for_disk_thread_exit(void);
-
 /*
  * disk util stuff
  */
@@ -127,12 +125,8 @@ static inline void print_disk_util(struct disk_util_stat *du,
 
 static inline int update_io_ticks(void)
 {
-	return disk_util_exit;
+	return helper_exit;
 }
 #endif
 
-static inline void disk_util_start_exit(void)
-{
-	disk_util_exit = 1;
-}
 #endif
diff --git a/fio.h b/fio.h
index f981739..f453d92 100644
--- a/fio.h
+++ b/fio.h
@@ -403,6 +403,8 @@ extern int nr_clients;
 extern int log_syslog;
 extern int status_interval;
 extern const char fio_version_string[];
+extern int helper_do_stat;
+extern pthread_cond_t helper_cond;
 
 extern struct thread_data *threads;
 
diff --git a/stat.c b/stat.c
index 03dc458..84d9eef 100644
--- a/stat.c
+++ b/stat.c
@@ -1422,7 +1422,7 @@ void show_run_stats(void)
 	fio_mutex_up(stat_mutex);
 }
 
-static void *__show_running_run_stats(void *arg)
+void __show_running_run_stats(void)
 {
 	struct thread_data *td;
 	unsigned long long *rt;
@@ -1451,6 +1451,8 @@ static void *__show_running_run_stats(void *arg)
 	}
 
 	for_each_td(td, i) {
+		if (td->runstate >= TD_EXITED)
+			continue;
 		if (td->rusage_sem) {
 			td->update_rusage = 1;
 			fio_mutex_down(td->rusage_sem);
@@ -1471,34 +1473,6 @@ static void *__show_running_run_stats(void *arg)
 
 	free(rt);
 	fio_mutex_up(stat_mutex);
-	free(arg);
-	return NULL;
-}
-
-/*
- * Called from signal handler. It _should_ be safe to just run this inline
- * in the sig handler, but we should be disturbing the system less by just
- * creating a thread to do it.
- */
-void show_running_run_stats(void)
-{
-	pthread_t *thread;
-
-	thread = calloc(1, sizeof(*thread));
-	if (!thread)
-		return;
-
-	if (!pthread_create(thread, NULL, __show_running_run_stats, thread)) {
-		int err;
-
-		err = pthread_detach(*thread);
-		if (err)
-			log_err("fio: DU thread detach failed: %s\n", strerror(err));
-
-		return;
-	}
-
-	free(thread);
 }
 
 static int status_interval_init;
@@ -1917,3 +1891,12 @@ void stat_exit(void)
 	fio_mutex_down(stat_mutex);
 	fio_mutex_remove(stat_mutex);
 }
+
+/*
+ * Called from signal handler. Wake up status thread.
+ */
+void show_running_run_stats(void)
+{
+	helper_do_stat = 1;
+	pthread_cond_signal(&helper_cond);
+}
diff --git a/stat.h b/stat.h
index d834cff..32ea226 100644
--- a/stat.h
+++ b/stat.h
@@ -221,6 +221,7 @@ extern int calc_thread_status(struct jobs_eta *je, int force);
 extern void display_thread_status(struct jobs_eta *je);
 extern void show_run_stats(void);
 extern void __show_run_stats(void);
+extern void __show_running_run_stats(void);
 extern void show_running_run_stats(void);
 extern void check_for_running_stats(void);
 extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, int nr);
