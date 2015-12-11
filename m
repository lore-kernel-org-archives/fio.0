Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:45971 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbLKNAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Dec 2015 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1a71iR-0000WG-JC
	for fio@vger.kernel.org; Thu, 10 Dec 2015 13:57:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20151211130002.8B8782C00C7@kernel.dk>
Date: Fri, 11 Dec 2015 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c5103619279883ee9291ed4793bb6ad39b436101:

  eta: use bool for forcing jobs_eta return (2015-12-09 12:44:09 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 408e0b90d74196f173c2008bc0034b70e9b56ddf:

  log: remove log_local_buf() (2015-12-10 15:31:02 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      Add exitall_on_error option
      mutex: fixup fio_mutex_down_timeout()
      Add backend related data
      log: remove log_local_buf()

 HOWTO            |  3 +++
 backend.c        | 18 +++++++++++-------
 cconv.c          |  2 ++
 fio.1            |  4 ++++
 fio.c            |  2 +-
 fio.h            | 11 ++++++++++-
 init.c           |  1 +
 log.c            | 30 ++++++++++++++----------------
 log.h            |  1 -
 mutex.c          | 27 ++++++++++++++++++---------
 options.c        |  9 +++++++++
 server.c         |  6 +++---
 thread_options.h |  3 ++-
 13 files changed, 78 insertions(+), 39 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index eb9c824..b21d27e 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1227,6 +1227,9 @@ exitall		When one job finishes, terminate the rest. The default is
 		to wait for each job to finish, sometimes that is not the
 		desired action.
 
+exitall_on_error	When one job finishes in error, terminate the rest. The
+		default is to wait for each job to finish.
+
 bwavgtime=int	Average the calculated bandwidth over the given time. Value
 		is specified in milliseconds.
 
diff --git a/backend.c b/backend.c
index 425b0ee..c8554bc 100644
--- a/backend.c
+++ b/backend.c
@@ -974,7 +974,7 @@ reap:
 
 		if (!in_ramp_time(td) && should_check_rate(td)) {
 			if (check_min_rate(td, &comp_time)) {
-				if (exitall_on_terminate)
+				if (exitall_on_terminate || td->o.exitall_error)
 					fio_terminate_threads(td->groupid);
 				td_verror(td, EIO, "check_min_rate");
 				break;
@@ -1662,7 +1662,7 @@ static void *thread_main(void *data)
 	if (o->exec_postrun)
 		exec_string(o, o->exec_postrun, (const char *)"postrun");
 
-	if (exitall_on_terminate)
+	if (exitall_on_terminate || (o->exitall_error && td->error))
 		fio_terminate_threads(td->groupid);
 
 err:
@@ -2117,7 +2117,7 @@ reap:
 					*fio_debug_jobp = pid;
 			}
 			dprint(FD_MUTEX, "wait on startup_mutex\n");
-			if (fio_mutex_down_timeout(startup_mutex, 10)) {
+			if (fio_mutex_down_timeout(startup_mutex, 10000)) {
 				log_err("fio: job startup hung? exiting.\n");
 				fio_terminate_threads(TERMINATE_ALL);
 				fio_abort = 1;
@@ -2220,8 +2220,12 @@ static void free_disk_util(void)
 
 static void *helper_thread_main(void *data)
 {
+	struct backend_data *d = data;
 	int ret = 0;
 
+	if (d)
+		pthread_setspecific(d->key, d->ptr);
+
 	fio_mutex_up(startup_mutex);
 
 	while (!ret) {
@@ -2255,7 +2259,7 @@ static void *helper_thread_main(void *data)
 	return NULL;
 }
 
-static int create_helper_thread(void)
+static int create_helper_thread(struct backend_data *data)
 {
 	int ret;
 
@@ -2264,7 +2268,7 @@ static int create_helper_thread(void)
 	pthread_cond_init(&helper_cond, NULL);
 	pthread_mutex_init(&helper_lock, NULL);
 
-	ret = pthread_create(&helper_thread, NULL, helper_thread_main, NULL);
+	ret = pthread_create(&helper_thread, NULL, helper_thread_main, data);
 	if (ret) {
 		log_err("Can't create helper thread: %s\n", strerror(ret));
 		return 1;
@@ -2276,7 +2280,7 @@ static int create_helper_thread(void)
 	return 0;
 }
 
-int fio_backend(void)
+int fio_backend(struct backend_data *data)
 {
 	struct thread_data *td;
 	int i;
@@ -2306,7 +2310,7 @@ int fio_backend(void)
 
 	set_genesis_time();
 	stat_init();
-	create_helper_thread();
+	create_helper_thread(data);
 
 	cgroup_list = smalloc(sizeof(*cgroup_list));
 	INIT_FLIST_HEAD(cgroup_list);
diff --git a/cconv.c b/cconv.c
index c0168c4..a476aad 100644
--- a/cconv.c
+++ b/cconv.c
@@ -167,6 +167,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->fsync_on_close = le32_to_cpu(top->fsync_on_close);
 	o->bs_is_seq_rand = le32_to_cpu(top->bs_is_seq_rand);
 	o->random_distribution = le32_to_cpu(top->random_distribution);
+	o->exitall_error = le32_to_cpu(top->exitall_error);
 	o->zipf_theta.u.f = fio_uint64_to_double(le64_to_cpu(top->zipf_theta.u.i));
 	o->pareto_h.u.f = fio_uint64_to_double(le64_to_cpu(top->pareto_h.u.i));
 	o->gauss_dev.u.f = fio_uint64_to_double(le64_to_cpu(top->gauss_dev.u.i));
@@ -353,6 +354,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->fsync_on_close = cpu_to_le32(o->fsync_on_close);
 	top->bs_is_seq_rand = cpu_to_le32(o->bs_is_seq_rand);
 	top->random_distribution = cpu_to_le32(o->random_distribution);
+	top->exitall_error = cpu_to_le32(o->exitall_error);
 	top->zipf_theta.u.i = __cpu_to_le64(fio_double_to_uint64(o->zipf_theta.u.f));
 	top->pareto_h.u.i = __cpu_to_le64(fio_double_to_uint64(o->pareto_h.u.f));
 	top->gauss_dev.u.i = __cpu_to_le64(fio_double_to_uint64(o->gauss_dev.u.f));
diff --git a/fio.1 b/fio.1
index eab20d7..4fe1be2 100644
--- a/fio.1
+++ b/fio.1
@@ -1126,6 +1126,10 @@ Should be a multiple of 1MB. Default: 4MB.
 .B exitall
 Terminate all jobs when one finishes.  Default: wait for each job to finish.
 .TP
+.B exitall_on_error \fR=\fPbool
+Terminate all jobs if one job finishes in error.  Default: wait for each job
+to finish.
+.TP
 .BI bwavgtime \fR=\fPint
 Average bandwidth calculations over the given time in milliseconds.  Default:
 500ms.
diff --git a/fio.c b/fio.c
index bafbd48..bd3e260 100644
--- a/fio.c
+++ b/fio.c
@@ -57,7 +57,7 @@ int main(int argc, char *argv[], char *envp[])
 			goto done;
 		ret = fio_handle_clients(&fio_client_ops);
 	} else
-		ret = fio_backend();
+		ret = fio_backend(NULL);
 
 done:
 	deinitialize_fio();
diff --git a/fio.h b/fio.h
index 6f85266..63778b6 100644
--- a/fio.h
+++ b/fio.h
@@ -108,6 +108,15 @@ enum {
 };
 
 /*
+ * Per-thread/process specific data. Only used for the network client
+ * for now.
+ */
+struct backend_data {
+	pthread_key_t key;
+	void *ptr;
+};
+
+/*
  * This describes a single thread/process executing a fio job.
  */
 struct thread_data {
@@ -468,7 +477,7 @@ extern int __must_check fio_init_options(void);
 extern int __must_check parse_options(int, char **);
 extern int parse_jobs_ini(char *, int, int, int);
 extern int parse_cmd_line(int, char **, int);
-extern int fio_backend(void);
+extern int fio_backend(struct backend_data *);
 extern void reset_fio_state(void);
 extern void clear_io_state(struct thread_data *, int);
 extern int fio_options_parse(struct thread_data *, char **, int, int);
diff --git a/init.c b/init.c
index 0100da2..63ba324 100644
--- a/init.c
+++ b/init.c
@@ -47,6 +47,7 @@ static char **job_sections;
 static int nr_job_sections;
 
 int exitall_on_terminate = 0;
+int exitall_on_terminate_error = 0;
 int output_format = FIO_OUTPUT_NORMAL;
 int eta_print = FIO_ETA_AUTO;
 int eta_new_line = 0;
diff --git a/log.c b/log.c
index d508267..4eb4af5 100644
--- a/log.c
+++ b/log.c
@@ -8,9 +8,13 @@
 
 size_t log_info_buf(const char *buf, size_t len)
 {
-	if (is_backend)
-		return fio_server_text_output(FIO_LOG_INFO, buf, len);
-	else if (log_syslog) {
+	if (is_backend) {
+		size_t ret = fio_server_text_output(FIO_LOG_INFO, buf, len);
+		if (ret != -1)
+			return ret;
+	}
+
+	if (log_syslog) {
 		syslog(LOG_INFO, "%s", buf);
 		return len;
 	} else
@@ -27,16 +31,6 @@ size_t log_valist(const char *str, va_list args)
 	return log_info_buf(buffer, min(len, sizeof(buffer) - 1));
 }
 
-size_t log_local_buf(const char *buf, size_t len)
-{
-	if (log_syslog)
-		syslog(LOG_INFO, "%s", buf);
-	else
-		len = fwrite(buf, len, 1, f_out);
-
-	return len;
-}
-
 size_t log_info(const char *format, ...)
 {
 	char buffer[1024];
@@ -82,9 +76,13 @@ size_t log_err(const char *format, ...)
 	va_end(args);
 	len = min(len, sizeof(buffer) - 1);
 
-	if (is_backend)
-		return fio_server_text_output(FIO_LOG_ERR, buffer, len);
-	else if (log_syslog) {
+	if (is_backend) {
+		size_t ret = fio_server_text_output(FIO_LOG_ERR, buffer, len);
+		if (ret != -1)
+			return ret;
+	}
+
+	if (log_syslog) {
 		syslog(LOG_INFO, "%s", buffer);
 		return len;
 	} else {
diff --git a/log.h b/log.h
index f1cf003..a39dea6 100644
--- a/log.h
+++ b/log.h
@@ -13,7 +13,6 @@ extern size_t log_err(const char *format, ...) __attribute__ ((__format__ (__pri
 extern size_t log_info(const char *format, ...) __attribute__ ((__format__ (__printf__, 1, 2)));
 extern size_t __log_buf(struct buf_output *, const char *format, ...) __attribute__ ((__format__ (__printf__, 2, 3)));
 extern size_t log_valist(const char *str, va_list);
-extern size_t log_local_buf(const char *buf, size_t);
 extern size_t log_info_buf(const char *buf, size_t len);
 extern int log_info_flush(void);
 
diff --git a/mutex.c b/mutex.c
index 7612b32..a48e37d 100644
--- a/mutex.c
+++ b/mutex.c
@@ -92,12 +92,15 @@ struct fio_mutex *fio_mutex_init(int value)
 	return NULL;
 }
 
-static bool mutex_timed_out(struct timeval *t, unsigned int seconds)
+static bool mutex_timed_out(struct timeval *t, unsigned int msecs)
 {
-	return mtime_since_now(t) >= seconds * 1000;
+	struct timeval now;
+
+	gettimeofday(&now, NULL);
+	return mtime_since(t, &now) >= msecs;
 }
 
-int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int seconds)
+int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 {
 	struct timeval tv_s;
 	struct timespec t;
@@ -106,30 +109,36 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int seconds)
 	assert(mutex->magic == FIO_MUTEX_MAGIC);
 
 	gettimeofday(&tv_s, NULL);
-	t.tv_sec = tv_s.tv_sec + seconds;
+	t.tv_sec = tv_s.tv_sec;
 	t.tv_nsec = tv_s.tv_usec * 1000;
 
+	t.tv_sec += msecs / 1000;
+	t.tv_nsec += ((msecs * 1000000) % 1000000000);
+	if (t.tv_nsec >= 1000000000) {
+		t.tv_nsec -= 1000000000;
+		t.tv_sec++;
+	}
+
 	pthread_mutex_lock(&mutex->lock);
 
+	mutex->waiters++;
 	while (!mutex->value && !ret) {
-		mutex->waiters++;
-
 		/*
 		 * Some platforms (FreeBSD 9?) seems to return timed out
 		 * way too early, double check.
 		 */
 		ret = pthread_cond_timedwait(&mutex->cond, &mutex->lock, &t);
-		if (ret == ETIMEDOUT && !mutex_timed_out(&tv_s, seconds))
+		if (ret == ETIMEDOUT && !mutex_timed_out(&tv_s, msecs))
 			ret = 0;
-
-		mutex->waiters--;
 	}
+	mutex->waiters--;
 
 	if (!ret) {
 		mutex->value--;
 		pthread_mutex_unlock(&mutex->lock);
 	}
 
+	pthread_mutex_unlock(&mutex->lock);
 	return ret;
 }
 
diff --git a/options.c b/options.c
index 627029c..46d5fb9 100644
--- a/options.c
+++ b/options.c
@@ -3141,6 +3141,15 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.group	= FIO_OPT_G_PROCESS,
 	},
 	{
+		.name	= "exitall_on_error",
+		.lname	= "Exit-all on terminate in error",
+		.type	= FIO_OPT_BOOL,
+		.off1	= td_var_offset(unlink),
+		.help	= "Terminate all jobs when one exits in error",
+		.category = FIO_OPT_C_GENERAL,
+		.group	= FIO_OPT_G_PROCESS,
+	},
+	{
 		.name	= "stonewall",
 		.lname	= "Wait for previous",
 		.alias	= "wait_for_previous",
diff --git a/server.c b/server.c
index cf01733..27ea282 100644
--- a/server.c
+++ b/server.c
@@ -601,7 +601,7 @@ static int handle_run_cmd(struct flist_head *job_list, struct fio_net_cmd *cmd)
 		return 0;
 	}
 
-	ret = fio_backend();
+	ret = fio_backend(NULL);
 	free_threads_shm();
 	_exit(ret);
 }
@@ -1061,7 +1061,7 @@ int fio_server_text_output(int level, const char *buf, size_t len)
 	struct timeval tv;
 
 	if (server_fd == -1)
-		return log_local_buf(buf, len);
+		return -1;
 
 	tlen = sizeof(*pdu) + len;
 	pdu = malloc(tlen);
@@ -1445,7 +1445,7 @@ int fio_server_get_verify_state(const char *name, int threadnumber,
 	/*
 	 * Wait for the backend to receive the reply
 	 */
-	if (fio_mutex_down_timeout(&rep->lock, 10)) {
+	if (fio_mutex_down_timeout(&rep->lock, 10000)) {
 		log_err("fio: timed out waiting for reply\n");
 		goto fail;
 	}
diff --git a/thread_options.h b/thread_options.h
index 02c867f..6ae0335 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -131,6 +131,7 @@ struct thread_options {
 	unsigned int verify_only;
 
 	unsigned int random_distribution;
+	unsigned int exitall_error;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
@@ -376,7 +377,7 @@ struct thread_options_pack {
 	uint32_t bs_is_seq_rand;
 
 	uint32_t random_distribution;
-	uint32_t pad;
+	uint32_t exitall_error;
 
 	fio_fp64_t zipf_theta;
 	fio_fp64_t pareto_h;
