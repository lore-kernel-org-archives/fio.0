Return-Path: <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk> <572A02B9.1040902@kernel.dk>
 <572A24AC.5090106@kernel.dk> <c85dc095-f2d2-851b-7246-8530230e997c@gmail.com>
 <572A60D1.3050700@kernel.dk> <572A69F7.4010102@kernel.dk>
 <bbbda45d-dc91-0cdf-cd65-d0541c5ffc20@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <572CD03F.6060507@kernel.dk>
Date: Fri, 6 May 2016 11:11:27 -0600
MIME-Version: 1.0
In-Reply-To: <bbbda45d-dc91-0cdf-cd65-d0541c5ffc20@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 05/05/2016 01:33 PM, Mark Nelson wrote:
>>>>> Can you try the below patch?
>>>>
>>>> I'll also try to take a look at this as we've seen a fair amount of
>>>> skew
>>>> in the logs doing fio librbd upstream ceph testing.
>>>
>>> That'd be great. More complete version below, fwiw.
>
> Ok, I'll try this one.  It might be a bit before I can test it since I'm
> bisecting ceph right now looking for a regression that only hits 128k
> sequential rbd reads.  Go figure. :)

When you get to it, here's an updated version. I'm tempted to shove this
into a new branch, instead of flinging diffs around... Let me know what
you prefer.

I've tested various mutations of real time or windowed logging, and with
and without log compression enabled. Seems to work for me, and it should
be accurate and eliminate drifting.


diff --git a/HOWTO b/HOWTO
index 1f523d3..a74a112 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1263,10 +1263,14 @@ exitall_on_error	When one job finishes in error, 
terminate the rest. The
  		default is to wait for each job to finish.

  bwavgtime=int	Average the calculated bandwidth over the given time. Value
-		is specified in milliseconds.
+		is specified in milliseconds. If the job also does bandwidth
+		logging through 'write_bw_log', then the minimum of this option
+		and 'log_avg_msec' will be used.  Default: 500ms.

  iopsavgtime=int	Average the calculated IOPS over the given time. Value
-		is specified in milliseconds.
+		is specified in milliseconds. If the job also does IOPS logging
+		through 'write_iops_log', then the minimum of this option and
+		'log_avg_msec' will be used.  Default: 500ms.

  create_serialize=bool	If true, serialize the file creating for the jobs.
  			This may be handy to avoid interleaving of data
diff --git a/backend.c b/backend.c
index 1723b8f..f0cb1bc 100644
--- a/backend.c
+++ b/backend.c
@@ -58,11 +58,6 @@
  #include "lib/mountcheck.h"
  #include "rate-submit.h"

-static pthread_t helper_thread;
-static pthread_mutex_t helper_lock;
-pthread_cond_t helper_cond;
-int helper_do_stat = 0;
-
  static struct fio_mutex *startup_mutex;
  static struct flist_head *cgroup_list;
  static char *cgroup_mnt;
@@ -79,7 +74,16 @@ unsigned int stat_number = 0;
  int shm_id = 0;
  int temp_stall_ts;
  unsigned long done_secs = 0;
-volatile int helper_exit = 0;
+
+static struct helper_data {
+	volatile int exit;
+	volatile int reset;
+	volatile int do_stat;
+	struct sk_out *sk_out;
+	pthread_t thread;
+	pthread_mutex_t lock;
+	pthread_cond_t cond;
+} *helper_data;

  #define PAGE_ALIGN(buf)	\
  	(char *) (((uintptr_t) (buf) + page_mask) & ~page_mask)
@@ -1722,7 +1726,7 @@ static void *thread_main(void *data)

  	fio_unpin_memory(td);

-	fio_writeout_logs(td);
+	td_writeout_logs(td, true);

  	iolog_compress_exit(td);
  	rate_submit_exit(td);
@@ -2319,78 +2323,154 @@ reap:
  	update_io_ticks();
  }

+void helper_reset(void)
+{
+	if (!helper_data)
+		return;
+
+	pthread_mutex_lock(&helper_data->lock);
+
+	if (!helper_data->reset) {
+		helper_data->reset = 1;
+		pthread_cond_signal(&helper_data->cond);
+	}
+
+	pthread_mutex_unlock(&helper_data->lock);
+}
+
+void helper_do_stat(void)
+{
+	if (!helper_data)
+		return;
+
+	pthread_mutex_lock(&helper_data->lock);
+	helper_data->do_stat = 1;
+	pthread_cond_signal(&helper_data->cond);
+	pthread_mutex_unlock(&helper_data->lock);
+}
+
+bool helper_should_exit(void)
+{
+	if (!helper_data)
+		return true;
+
+	return helper_data->exit;
+}
+
  static void wait_for_helper_thread_exit(void)
  {
  	void *ret;

-	helper_exit = 1;
-	pthread_cond_signal(&helper_cond);
-	pthread_join(helper_thread, &ret);
+	pthread_mutex_lock(&helper_data->lock);
+	helper_data->exit = 1;
+	pthread_cond_signal(&helper_data->cond);
+	pthread_mutex_unlock(&helper_data->lock);
+
+	pthread_join(helper_data->thread, &ret);
  }

  static void free_disk_util(void)
  {
  	disk_util_prune_entries();

-	pthread_cond_destroy(&helper_cond);
+	pthread_cond_destroy(&helper_data->cond);
+	pthread_mutex_destroy(&helper_data->lock);
+	sfree(helper_data);
  }

  static void *helper_thread_main(void *data)
  {
-	struct sk_out *sk_out = data;
+	struct helper_data *hd = data;
+	unsigned int msec_to_next_event, next_log;
+	struct timeval tv, last_du;
  	int ret = 0;

-	sk_out_assign(sk_out);
+	sk_out_assign(hd->sk_out);
+
+	gettimeofday(&tv, NULL);
+	memcpy(&last_du, &tv, sizeof(tv));

  	fio_mutex_up(startup_mutex);

-	while (!ret) {
-		uint64_t sec = DISK_UTIL_MSEC / 1000;
-		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
+	msec_to_next_event = DISK_UTIL_MSEC;
+	while (!ret && !hd->exit) {
  		struct timespec ts;
-		struct timeval tv;
+		struct timeval now;
+		uint64_t since_du;
+
+		timeval_add_msec(&tv, msec_to_next_event);
+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec * 1000;
+
+		pthread_mutex_lock(&hd->lock);
+		pthread_cond_timedwait(&hd->cond, &hd->lock, &ts);

-		gettimeofday(&tv, NULL);
-		ts.tv_sec = tv.tv_sec + sec;
-		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
+		gettimeofday(&now, NULL);

-		if (ts.tv_nsec >= 1000000000ULL) {
-			ts.tv_nsec -= 1000000000ULL;
-			ts.tv_sec++;
+		if (hd->reset) {
+			memcpy(&tv, &now, sizeof(tv));
+			memcpy(&last_du, &now, sizeof(last_du));
+			hd->reset = 0;
  		}

-		pthread_cond_timedwait(&helper_cond, &helper_lock, &ts);
+		pthread_mutex_unlock(&hd->lock);

-		ret = update_io_ticks();
+		since_du = mtime_since(&last_du, &now);
+		if (since_du >= DISK_UTIL_MSEC || DISK_UTIL_MSEC - since_du < 10) {
+			ret = update_io_ticks();
+			timeval_add_msec(&last_du, DISK_UTIL_MSEC);
+			msec_to_next_event = DISK_UTIL_MSEC;
+			if (since_du >= DISK_UTIL_MSEC)
+				msec_to_next_event -= (since_du - DISK_UTIL_MSEC);
+		} else {
+			if (since_du >= DISK_UTIL_MSEC)
+				msec_to_next_event = DISK_UTIL_MSEC - (DISK_UTIL_MSEC - since_du);
+			else
+				msec_to_next_event = DISK_UTIL_MSEC;
+		}

-		if (helper_do_stat) {
-			helper_do_stat = 0;
+		if (hd->do_stat) {
+			hd->do_stat = 0;
  			__show_running_run_stats();
  		}

+		next_log = calc_log_samples();
+		if (!next_log)
+			next_log = DISK_UTIL_MSEC;
+
+		msec_to_next_event = min(next_log, msec_to_next_event);
+
  		if (!is_backend)
  			print_thread_status();
  	}

+	fio_writeout_logs(false);
+
  	sk_out_drop();
  	return NULL;
  }

  static int create_helper_thread(struct sk_out *sk_out)
  {
+	struct helper_data *hd;
  	int ret;

+	hd = smalloc(sizeof(*hd));
+
  	setup_disk_util();

-	pthread_cond_init(&helper_cond, NULL);
-	pthread_mutex_init(&helper_lock, NULL);
+	hd->sk_out = sk_out;
+	pthread_cond_init(&hd->cond, NULL);
+	pthread_mutex_init(&hd->lock, NULL);

-	ret = pthread_create(&helper_thread, NULL, helper_thread_main, sk_out);
+	ret = pthread_create(&hd->thread, NULL, helper_thread_main, hd);
  	if (ret) {
  		log_err("Can't create helper thread: %s\n", strerror(ret));
  		return 1;
  	}

+	helper_data = hd;
+
  	dprint(FD_MUTEX, "wait on startup_mutex\n");
  	fio_mutex_down(startup_mutex);
  	dprint(FD_MUTEX, "done waiting on startup_mutex\n");
diff --git a/diskutil.c b/diskutil.c
index c25c5c9..315c1e1 100644
--- a/diskutil.c
+++ b/diskutil.c
@@ -121,7 +121,7 @@ int update_io_ticks(void)

  	fio_mutex_down(disk_util_mutex);

-	if (!helper_exit) {
+	if (!helper_should_exit()) {
  		flist_for_each(entry, &disk_list) {
  			du = flist_entry(entry, struct disk_util, list);
  			update_io_tick_disk(du);
diff --git a/fio.1 b/fio.1
index 73fdee6..e9bb72e 100644
--- a/fio.1
+++ b/fio.1
@@ -1180,12 +1180,14 @@ Terminate all jobs if one job finishes in error. 
  Default: wait for each job
  to finish.
  .TP
  .BI bwavgtime \fR=\fPint
-Average bandwidth calculations over the given time in milliseconds. 
Default:
-500ms.
+Average bandwidth calculations over the given time in milliseconds. If 
the job
+also does bandwidth logging through \fBwrite_bw_log\fR, then the minimum of
+this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
  .TP
  .BI iopsavgtime \fR=\fPint
-Average IOPS calculations over the given time in milliseconds.  Default:
-500ms.
+Average IOPS calculations over the given time in milliseconds. If the job
+also does IOPS logging through \fBwrite_iops_log\fR, then the minimum of
+this option and \fBlog_avg_msec\fR will be used.  Default: 500ms.
  .TP
  .BI create_serialize \fR=\fPbool
  If true, serialize file creation for the jobs.  Default: true.
diff --git a/fio.h b/fio.h
index 829cc81..20ff26f 100644
--- a/fio.h
+++ b/fio.h
@@ -445,8 +445,6 @@ extern int nr_clients;
  extern int log_syslog;
  extern int status_interval;
  extern const char fio_version_string[];
-extern int helper_do_stat;
-extern pthread_cond_t helper_cond;
  extern char *trigger_file;
  extern char *trigger_cmd;
  extern char *trigger_remote_cmd;
@@ -734,4 +732,8 @@ enum {
  extern void exec_trigger(const char *);
  extern void check_trigger_file(void);

+extern void helper_reset(void);
+extern void helper_do_stat(void);
+extern bool helper_should_exit(void);
+
  #endif
diff --git a/fio_time.h b/fio_time.h
index 79f324a..cb271c2 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -17,5 +17,6 @@ extern void set_genesis_time(void);
  extern int ramp_time_over(struct thread_data *);
  extern int in_ramp_time(struct thread_data *);
  extern void fio_time_init(void);
+extern void timeval_add_msec(struct timeval *, unsigned int);

  #endif
diff --git a/init.c b/init.c
index 89e05c0..c579d5c 100644
--- a/init.c
+++ b/init.c
@@ -1416,6 +1416,11 @@ static int add_job(struct thread_data *td, const 
char *jobname, int job_add_num,
  		};
  		const char *suf;

+		if (fio_option_is_set(o, bw_avg_time))
+			p.avg_msec = min(o->log_avg_msec, o->bw_avg_time);
+		else
+			o->bw_avg_time = p.avg_msec;
+
  		if (p.log_gz_store)
  			suf = "log.fz";
  		else
@@ -1436,6 +1441,11 @@ static int add_job(struct thread_data *td, const 
char *jobname, int job_add_num,
  		};
  		const char *suf;

+		if (fio_option_is_set(o, iops_avg_time))
+			p.avg_msec = min(o->log_avg_msec, o->iops_avg_time);
+		else
+			o->iops_avg_time = p.avg_msec;
+
  		if (p.log_gz_store)
  			suf = "log.fz";
  		else
diff --git a/io_u.c b/io_u.c
index 6622bc0..eb15dc2 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1710,16 +1710,18 @@ static void account_io_completion(struct 
thread_data *td, struct io_u *io_u,
  		}
  	}

-	if (!td->o.disable_clat) {
-		add_clat_sample(td, idx, lusec, bytes, io_u->offset);
-		io_u_mark_latency(td, lusec);
-	}
+	if (ddir_rw(idx)) {
+		if (!td->o.disable_clat) {
+			add_clat_sample(td, idx, lusec, bytes, io_u->offset);
+			io_u_mark_latency(td, lusec);
+		}

-	if (!td->o.disable_bw)
-		add_bw_sample(td, idx, bytes, &icd->time);
+		if (!td->o.disable_bw && per_unit_log(td->bw_log))
+			add_bw_sample(td, io_u, bytes, lusec);

-	if (no_reduce)
-		add_iops_sample(td, idx, bytes, &icd->time);
+		if (no_reduce && per_unit_log(td->iops_log))
+			add_iops_sample(td, io_u, bytes);
+	}

  	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
  		uint32_t *info = io_u_block_info(td, io_u);
diff --git a/iolog.c b/iolog.c
index 94d3f3c..71afe86 100644
--- a/iolog.c
+++ b/iolog.c
@@ -18,6 +18,7 @@
  #include "verify.h"
  #include "trim.h"
  #include "filelock.h"
+#include "smalloc.h"

  static const char iolog_ver2[] = "fio version 2 iolog";

@@ -574,14 +575,12 @@ void setup_log(struct io_log **log, struct 
log_params *p,
  {
  	struct io_log *l;

-	l = calloc(1, sizeof(*l));
+	l = smalloc(sizeof(*l));
  	l->nr_samples = 0;
-	l->max_samples = DEF_LOG_ENTRIES;
  	l->log_type = p->log_type;
  	l->log_offset = p->log_offset;
  	l->log_gz = p->log_gz;
  	l->log_gz_store = p->log_gz_store;
-	l->log = malloc(l->max_samples * log_entry_sz(l));
  	l->avg_msec = p->avg_msec;
  	l->filename = strdup(filename);
  	l->td = p->td;
@@ -631,7 +630,7 @@ void free_log(struct io_log *log)
  {
  	free(log->log);
  	free(log->filename);
-	free(log);
+	sfree(log);
  }

  void flush_samples(FILE *f, void *samples, uint64_t sample_size)
@@ -1202,29 +1201,74 @@ static int __write_log(struct thread_data *td, 
struct io_log *log, int try)
  	return 0;
  }

-static int write_iops_log(struct thread_data *td, int try)
+static int write_iops_log(struct thread_data *td, int try, bool unit_log)
  {
-	return __write_log(td, td->iops_log, try);
+	int ret;
+
+	if (per_unit_log(td->iops_log) != unit_log)
+		return 0;
+
+	ret = __write_log(td, td->iops_log, try);
+	if (!ret)
+		td->iops_log = NULL;
+
+	return ret;
  }

-static int write_slat_log(struct thread_data *td, int try)
+static int write_slat_log(struct thread_data *td, int try, bool unit_log)
  {
-	return __write_log(td, td->slat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->slat_log, try);
+	if (!ret)
+		td->slat_log = NULL;
+
+	return ret;
  }

-static int write_clat_log(struct thread_data *td, int try)
+static int write_clat_log(struct thread_data *td, int try, bool unit_log)
  {
-	return __write_log(td, td->clat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->clat_log, try);
+	if (!ret)
+		td->clat_log = NULL;
+
+	return ret;
  }

-static int write_lat_log(struct thread_data *td, int try)
+static int write_lat_log(struct thread_data *td, int try, bool unit_log)
  {
-	return __write_log(td, td->lat_log, try);
+	int ret;
+
+	if (!unit_log)
+		return 0;
+
+	ret = __write_log(td, td->lat_log, try);
+	if (!ret)
+		td->lat_log = NULL;
+
+	return ret;
  }

-static int write_bandw_log(struct thread_data *td, int try)
+static int write_bandw_log(struct thread_data *td, int try, bool unit_log)
  {
-	return __write_log(td, td->bw_log, try);
+	int ret;
+
+	if (per_unit_log(td->bw_log) != unit_log)
+		return 0;
+
+	ret = __write_log(td, td->bw_log, try);
+	if (!ret)
+		td->bw_log = NULL;
+
+	return ret;
  }

  enum {
@@ -1239,7 +1283,7 @@ enum {

  struct log_type {
  	unsigned int mask;
-	int (*fn)(struct thread_data *, int);
+	int (*fn)(struct thread_data *, int, bool);
  };

  static struct log_type log_types[] = {
@@ -1265,7 +1309,7 @@ static struct log_type log_types[] = {
  	},
  };

-void fio_writeout_logs(struct thread_data *td)
+void td_writeout_logs(struct thread_data *td, bool unit_logs)
  {
  	unsigned int log_mask = 0;
  	unsigned int log_left = ALL_LOG_NR;
@@ -1273,7 +1317,7 @@ void fio_writeout_logs(struct thread_data *td)

  	old_state = td_bump_runstate(td, TD_FINISHING);

-	finalize_logs(td);
+	finalize_logs(td, unit_logs);

  	while (log_left) {
  		int prev_log_left = log_left;
@@ -1283,7 +1327,7 @@ void fio_writeout_logs(struct thread_data *td)
  			int ret;

  			if (!(log_mask & lt->mask)) {
-				ret = lt->fn(td, log_left != 1);
+				ret = lt->fn(td, log_left != 1, unit_logs);
  				if (!ret) {
  					log_left--;
  					log_mask |= lt->mask;
@@ -1297,3 +1341,12 @@ void fio_writeout_logs(struct thread_data *td)

  	td_restore_runstate(td, old_state);
  }
+
+void fio_writeout_logs(bool unit_logs)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i)
+		td_writeout_logs(td, unit_logs);
+}
diff --git a/iolog.h b/iolog.h
index 74f2170..739a7c8 100644
--- a/iolog.h
+++ b/iolog.h
@@ -207,12 +207,18 @@ struct log_params {
  	int log_compress;
  };

-extern void finalize_logs(struct thread_data *td);
+static inline bool per_unit_log(struct io_log *log)
+{
+	return log && !log->avg_msec;
+}
+
+extern void finalize_logs(struct thread_data *td, bool);
  extern void setup_log(struct io_log **, struct log_params *, const 
char *);
  extern void flush_log(struct io_log *, int);
  extern void flush_samples(FILE *, void *, uint64_t);
  extern void free_log(struct io_log *);
-extern void fio_writeout_logs(struct thread_data *);
+extern void fio_writeout_logs(bool);
+extern void td_writeout_logs(struct thread_data *, bool);
  extern int iolog_flush(struct io_log *, int);

  static inline void init_ipo(struct io_piece *ipo)
diff --git a/libfio.c b/libfio.c
index b17f148..790c036 100644
--- a/libfio.c
+++ b/libfio.c
@@ -151,6 +151,7 @@ void reset_all_stats(struct thread_data *td)

  	lat_target_reset(td);
  	clear_rusage_stat(td);
+	helper_reset();
  }

  void reset_fio_state(void)
diff --git a/stat.c b/stat.c
index 6d8d4d0..8c41914 100644
--- a/stat.c
+++ b/stat.c
@@ -1862,13 +1862,21 @@ static void __add_log_sample(struct io_log 
*iolog, unsigned long val,
  		iolog->avg_last = t;

  	if (iolog->nr_samples == iolog->max_samples) {
-		size_t new_size;
+		size_t new_size, new_samples;
  		void *new_log;

-		new_size = 2 * iolog->max_samples * log_entry_sz(iolog);
+		if (!iolog->max_samples)
+			new_samples = DEF_LOG_ENTRIES;
+		else
+			new_samples = iolog->max_samples * 2;
+
+		new_size = new_samples * log_entry_sz(iolog);

  		if (iolog->log_gz && (new_size > iolog->log_gz)) {
-			if (iolog_flush(iolog, 0)) {
+			if (!iolog->log) {
+				iolog->log = malloc(new_size);
+				iolog->max_samples = new_samples;
+			} else if (iolog_flush(iolog, 0)) {
  				log_err("fio: failed flushing iolog! Will stop logging.\n");
  				iolog->disabled = 1;
  				return;
@@ -1882,7 +1890,7 @@ static void __add_log_sample(struct io_log *iolog, 
unsigned long val,
  				return;
  			}
  			iolog->log = new_log;
-			iolog->max_samples <<= 1;
+			iolog->max_samples = new_samples;
  		}
  	}

@@ -2013,21 +2021,21 @@ static void add_log_sample(struct thread_data 
*td, struct io_log *iolog,
  	iolog->avg_last = elapsed;
  }

-void finalize_logs(struct thread_data *td)
+void finalize_logs(struct thread_data *td, bool unit_logs)
  {
  	unsigned long elapsed;

  	elapsed = mtime_since_now(&td->epoch);

-	if (td->clat_log)
+	if (td->clat_log && unit_logs)
  		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
-	if (td->slat_log)
+	if (td->slat_log && unit_logs)
  		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
-	if (td->lat_log)
+	if (td->lat_log && unit_logs)
  		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
-	if (td->bw_log)
+	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
  		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
-	if (td->iops_log)
+	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
  		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
  }

@@ -2056,9 +2064,6 @@ void add_clat_sample(struct thread_data *td, enum 
fio_ddir ddir,
  {
  	struct thread_stat *ts = &td->ts;

-	if (!ddir_rw(ddir))
-		return;
-
  	td_io_u_lock(td);

  	add_stat_sample(&ts->clat_stat[ddir], usec);
@@ -2108,18 +2113,41 @@ void add_lat_sample(struct thread_data *td, enum 
fio_ddir ddir,
  	td_io_u_unlock(td);
  }

-void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned 
int bs,
-		   struct timeval *t)
+void add_bw_sample(struct thread_data *td, struct io_u *io_u,
+		   unsigned int bytes, unsigned long spent)
+{
+	struct thread_stat *ts = &td->ts;
+	unsigned long rate;
+
+	if (spent)
+		rate = bytes * 1000 / spent;
+	else
+		rate = 0;
+
+	td_io_u_lock(td);
+
+	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
+
+	if (td->bw_log)
+		add_log_sample(td, td->bw_log, rate, io_u->ddir, bytes, io_u->offset);
+
+	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
+	td_io_u_unlock(td);
+}
+
+static int add_bw_samples(struct thread_data *td, struct timeval *t)
  {
  	struct thread_stat *ts = &td->ts;
  	unsigned long spent, rate;
+	enum fio_ddir ddir;

-	if (!ddir_rw(ddir))
-		return;
+	if (per_unit_log(td->bw_log))
+		return 0;

  	spent = mtime_since(&td->bw_sample_time, t);
-	if (spent < td->o.bw_avg_time)
-		return;
+	if (spent < td->o.bw_avg_time &&
+	    td->o.bw_avg_time - spent >= 10)
+		return td->o.bw_avg_time - spent;

  	td_io_u_lock(td);

@@ -2141,27 +2169,50 @@ void add_bw_sample(struct thread_data *td, enum 
fio_ddir ddir, unsigned int bs,
  		add_stat_sample(&ts->bw_stat[ddir], rate);

  		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			add_log_sample(td, td->bw_log, rate, ddir, 0, 0);

  		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
  	}

-	fio_gettime(&td->bw_sample_time, NULL);
+	timeval_add_msec(&td->bw_sample_time, td->o.bw_avg_time);
+
+	td_io_u_unlock(td);
+
+	if (spent <= td->o.bw_avg_time)
+		return td->o.bw_avg_time;
+
+	return td->o.bw_avg_time - (1 + spent - td->o.bw_avg_time);
+}
+
+void add_iops_sample(struct thread_data *td, struct io_u *io_u,
+		     unsigned int bytes)
+{
+	struct thread_stat *ts = &td->ts;
+
+	td_io_u_lock(td);
+
+	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
+
+	if (td->iops_log)
+		add_log_sample(td, td->iops_log, 1, io_u->ddir, bytes, io_u->offset);
+
+	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
  	td_io_u_unlock(td);
  }

-void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, 
unsigned int bs,
-		     struct timeval *t)
+static int add_iops_samples(struct thread_data *td, struct timeval *t)
  {
  	struct thread_stat *ts = &td->ts;
  	unsigned long spent, iops;
+	enum fio_ddir ddir;

-	if (!ddir_rw(ddir))
-		return;
+	if (per_unit_log(td->iops_log))
+		return 0;

  	spent = mtime_since(&td->iops_sample_time, t);
-	if (spent < td->o.iops_avg_time)
-		return;
+	if (spent < td->o.iops_avg_time &&
+	    td->o.iops_avg_time - spent >= 10)
+		return td->o.iops_avg_time - spent;

  	td_io_u_lock(td);

@@ -2183,13 +2234,53 @@ void add_iops_sample(struct thread_data *td, 
enum fio_ddir ddir, unsigned int bs
  		add_stat_sample(&ts->iops_stat[ddir], iops);

  		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			add_log_sample(td, td->iops_log, iops, ddir, 0, 0);

  		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
  	}

-	fio_gettime(&td->iops_sample_time, NULL);
+	timeval_add_msec(&td->iops_sample_time, td->o.iops_avg_time);
+
  	td_io_u_unlock(td);
+
+	if (spent <= td->o.iops_avg_time)
+		return td->o.iops_avg_time;
+
+	printf("%lu over\n", spent - td->o.iops_avg_time);
+	return td->o.iops_avg_time - (1 + spent - td->o.iops_avg_time);
+}
+
+/*
+ * Returns msecs to next event
+ */
+int calc_log_samples(void)
+{
+	struct thread_data *td;
+	unsigned int next = ~0U, tmp;
+	struct timeval now;
+	int i;
+
+	fio_gettime(&now, NULL);
+
+	for_each_td(td, i) {
+		if (!ramp_time_over(td) ||
+		    !(td->runstate == TD_RUNNING || td->runstate == TD_VERIFYING)) {
+			next = min(td->o.iops_avg_time, td->o.bw_avg_time);
+			continue;
+		}
+		if (!per_unit_log(td->bw_log)) {
+			tmp = add_bw_samples(td, &now);
+			if (tmp < next)
+				next = tmp;
+		}
+		if (!per_unit_log(td->iops_log)) {
+			tmp = add_iops_samples(td, &now);
+			if (tmp < next)
+				next = tmp;
+		}
+	}
+
+	return next == ~0U ? 0 : next;
  }

  void stat_init(void)
@@ -2212,8 +2303,7 @@ void stat_exit(void)
   */
  void show_running_run_stats(void)
  {
-	helper_do_stat = 1;
-	pthread_cond_signal(&helper_cond);
+	helper_do_stat();
  }

  uint32_t *io_u_block_info(struct thread_data *td, struct io_u *io_u)
diff --git a/stat.h b/stat.h
index 9c3f192..86f1a0b 100644
--- a/stat.h
+++ b/stat.h
@@ -276,11 +276,12 @@ extern void add_clat_sample(struct thread_data *, 
enum fio_ddir, unsigned long,
  				unsigned int, uint64_t);
  extern void add_slat_sample(struct thread_data *, enum fio_ddir, 
unsigned long,
  				unsigned int, uint64_t);
-extern void add_bw_sample(struct thread_data *, enum fio_ddir, unsigned 
int,
-				struct timeval *);
-extern void add_iops_sample(struct thread_data *, enum fio_ddir, 
unsigned int,
-				struct timeval *);
  extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
+extern void add_iops_sample(struct thread_data *, struct io_u *,
+				unsigned int);
+extern void add_bw_sample(struct thread_data *, struct io_u *,
+				unsigned int, unsigned long);
+extern int calc_log_samples(void);

  extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
  extern int write_bw_log;
diff --git a/time.c b/time.c
index b145e90..7c7fa96 100644
--- a/time.c
+++ b/time.c
@@ -6,6 +6,15 @@
  static struct timeval genesis;
  static unsigned long ns_granularity;

+void timeval_add_msec(struct timeval *tv, unsigned int msec)
+{
+	tv->tv_usec += 1000 * msec;
+	if (tv->tv_usec > 1000000) {
+		tv->tv_usec -= 1000000;
+		tv->tv_sec++;
+	}
+}
+
  /*
   * busy looping version for the last few usec
   */
diff --git a/workqueue.c b/workqueue.c
index 6e67f3e..4f9c414 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -9,6 +9,7 @@
  #include "fio.h"
  #include "flist.h"
  #include "workqueue.h"
+#include "smalloc.h"

  enum {
  	SW_F_IDLE	= 1 << 0,
@@ -263,7 +264,7 @@ void workqueue_exit(struct workqueue *wq)
  		}
  	} while (shutdown && shutdown != wq->max_workers);

-	free(wq->workers);
+	sfree(wq->workers);
  	wq->workers = NULL;
  	pthread_mutex_destroy(&wq->flush_lock);
  	pthread_cond_destroy(&wq->flush_cond);
@@ -317,7 +318,7 @@ int workqueue_init(struct thread_data *td, struct 
workqueue *wq,
  	pthread_mutex_init(&wq->flush_lock, NULL);
  	pthread_mutex_init(&wq->stat_lock, NULL);

-	wq->workers = calloc(wq->max_workers, sizeof(struct submit_worker));
+	wq->workers = smalloc(wq->max_workers * sizeof(struct submit_worker));

  	for (i = 0; i < wq->max_workers; i++)
  		if (start_worker(wq, i, sk_out))

-- 
Jens Axboe


