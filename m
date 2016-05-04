Return-Path: <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk> <572A02B9.1040902@kernel.dk>
 <572A24AC.5090106@kernel.dk> <c85dc095-f2d2-851b-7246-8530230e997c@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <572A60D1.3050700@kernel.dk>
Date: Wed, 4 May 2016 14:51:29 -0600
MIME-Version: 1.0
In-Reply-To: <c85dc095-f2d2-851b-7246-8530230e997c@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 05/04/2016 11:43 AM, Mark Nelson wrote:
> On 05/04/2016 11:34 AM, Jens Axboe wrote:
>> On 05/04/2016 08:10 AM, Jens Axboe wrote:
>>> On 04/27/2016 02:38 PM, Jens Axboe wrote:
>>>> I'll try and see if I can reproduce this.
>>>
>>> So I took a look at your logged output. The way that fio logs is that it
>>> does it on IO completion. You have set 1s intervals, so it checks, when
>>> an IO completes, if we're due for logging the previous interval IOPS:
>>>
>>> spent = mtime_since(&td->iops_sample_time, t);
>>> if (spent < td->o.iops_avg_time)
>>>          return;
>>>
>>> If you are doing lots of IO, it matches pretty evenly. But for slow
>>> workloads, it will end up being skewed a bit. It won't be too hard to
>>> fix the drift, though, but it still won't make it clock precise at exact
>>> 1s intervals.
>>>
>>> We could move this part into the main thread, and out of the workers.
>>> Then we could make it more precise. Might not be a bad idea in general,
>>> since it'll move some of this code out of the fast path.
>>>
>>> I'll take a stab at it.
>>
>> Can you try the below patch?
>
> I'll also try to take a look at this as we've seen a fair amount of skew
> in the logs doing fio librbd upstream ceph testing.

That'd be great. More complete version below, fwiw.

> I actually wrote a
> first stab at a parser to aggregate logs from multiple fio processes
> with the assumption of non-uniform sampling:
>
> https://github.com/ceph/cbt/blob/master/tools/fiologpaser.py
>
> The idea is you have say 8 fio bw logs in a directory you can do:
>
> fiologparser.py -f *bw*
>
> which will return average values from the logs over user defined
> intervals by taking weighted scores from samples that overlap.  You can
> also look at per-interval averages, sums, or just a global average.
>
> various option flags:
>
> -i <interval time in ms>
> -d <divide results by d (say if you want a different unit of output)
> -f <show full interval data>
> -a <show average interval data across logs>
> -s <show sums for interval data across logs>

That looks useful. Might want to put that in the fio repo as well, if
you are interested.


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
index 1723b8f..975517a 100644
--- a/backend.c
+++ b/backend.c
@@ -1722,7 +1722,7 @@ static void *thread_main(void *data)

  	fio_unpin_memory(td);

-	fio_writeout_logs(td);
+	td_writeout_logs(td, true);

  	iolog_compress_exit(td);
  	rate_submit_exit(td);
@@ -2337,41 +2337,64 @@ static void free_disk_util(void)

  static void *helper_thread_main(void *data)
  {
+	unsigned int msec_to_next_event, next_log;
  	struct sk_out *sk_out = data;
+	struct timeval tv, last_du;
  	int ret = 0;

  	sk_out_assign(sk_out);

+	gettimeofday(&tv, NULL);
+	memcpy(&last_du, &tv, sizeof(tv));
+
  	fio_mutex_up(startup_mutex);

-	while (!ret) {
-		uint64_t sec = DISK_UTIL_MSEC / 1000;
-		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
+	msec_to_next_event = DISK_UTIL_MSEC;
+	while (!ret && !helper_exit) {
  		struct timespec ts;
-		struct timeval tv;
-
-		gettimeofday(&tv, NULL);
-		ts.tv_sec = tv.tv_sec + sec;
-		ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
+		struct timeval now;

-		if (ts.tv_nsec >= 1000000000ULL) {
-			ts.tv_nsec -= 1000000000ULL;
-			ts.tv_sec++;
+		tv.tv_usec += msec_to_next_event * 1000;
+		if (tv.tv_usec >= 1000000) {
+			tv.tv_usec -= 1000000;
+			tv.tv_sec++;
  		}

+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec * 1000;
+
  		pthread_cond_timedwait(&helper_cond, &helper_lock, &ts);

-		ret = update_io_ticks();
+		gettimeofday(&now, NULL);
+
+		if (mtime_since(&last_du, &now) >= DISK_UTIL_MSEC) {
+			ret = update_io_ticks();
+			memcpy(&last_du, &now, sizeof(now));
+			msec_to_next_event = DISK_UTIL_MSEC;
+		} else {
+			msec_to_next_event = DISK_UTIL_MSEC -
+						mtime_since(&last_du, &now);
+		}

  		if (helper_do_stat) {
  			helper_do_stat = 0;
  			__show_running_run_stats();
  		}

+		next_log = calc_log_samples();
+		if (!next_log)
+			next_log = DISK_UTIL_MSEC;
+
+		msec_to_next_event = min(next_log, msec_to_next_event);
+		if (msec_to_next_event)
+			msec_to_next_event--;
+
  		if (!is_backend)
  			print_thread_status();
  	}

+	fio_writeout_logs(false);
+
  	sk_out_drop();
  	return NULL;
  }
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
index 6622bc0..a268c9b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1715,11 +1715,11 @@ static void account_io_completion(struct 
thread_data *td, struct io_u *io_u,
  		io_u_mark_latency(td, lusec);
  	}

-	if (!td->o.disable_bw)
-		add_bw_sample(td, idx, bytes, &icd->time);
+	if (!td->o.disable_bw && (per_unit_log(td->bw_log) || !td->o.bw_avg_time))
+		add_bw_sample(td, io_u, bytes, lusec);

-	if (no_reduce)
-		add_iops_sample(td, idx, bytes, &icd->time);
+	if (no_reduce && (per_unit_log(td->iops_log) || !td->o.iops_avg_time))
+		add_iops_sample(td, io_u, bytes, lusec);

  	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
  		uint32_t *info = io_u_block_info(td, io_u);
diff --git a/iolog.c b/iolog.c
index feda9ed..21ab9c8 100644
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
-	l->max_samples = 1024;
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
@@ -1239,29 +1238,74 @@ static int __write_log(struct thread_data *td, 
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
+	if (per_unit_log(td->slat_log) != unit_log)
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
+	if (per_unit_log(td->clat_log) != unit_log)
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
+	if (per_unit_log(td->lat_log) != unit_log)
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
@@ -1276,7 +1320,7 @@ enum {

  struct log_type {
  	unsigned int mask;
-	int (*fn)(struct thread_data *, int);
+	int (*fn)(struct thread_data *, int, bool);
  };

  static struct log_type log_types[] = {
@@ -1302,7 +1346,7 @@ static struct log_type log_types[] = {
  	},
  };

-void fio_writeout_logs(struct thread_data *td)
+void td_writeout_logs(struct thread_data *td, bool unit_logs)
  {
  	unsigned int log_mask = 0;
  	unsigned int log_left = ALL_LOG_NR;
@@ -1310,7 +1354,7 @@ void fio_writeout_logs(struct thread_data *td)

  	old_state = td_bump_runstate(td, TD_FINISHING);

-	finalize_logs(td);
+	finalize_logs(td, unit_logs);

  	while (log_left) {
  		int prev_log_left = log_left;
@@ -1320,7 +1364,7 @@ void fio_writeout_logs(struct thread_data *td)
  			int ret;

  			if (!(log_mask & lt->mask)) {
-				ret = lt->fn(td, log_left != 1);
+				ret = lt->fn(td, log_left != 1, unit_logs);
  				if (!ret) {
  					log_left--;
  					log_mask |= lt->mask;
@@ -1334,3 +1378,12 @@ void fio_writeout_logs(struct thread_data *td)

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
index 297daf5..739a7c8 100644
--- a/iolog.h
+++ b/iolog.h
@@ -41,6 +41,8 @@ enum {
  	IO_LOG_TYPE_IOPS,
  };

+#define DEF_LOG_ENTRIES		1024
+
  /*
   * Dynamically growing data sample log
   */
@@ -205,12 +207,18 @@ struct log_params {
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
index c626d15..b17f148 100644
--- a/libfio.c
+++ b/libfio.c
@@ -146,6 +146,8 @@ void reset_all_stats(struct thread_data *td)
  	fio_gettime(&tv, NULL);
  	memcpy(&td->epoch, &tv, sizeof(tv));
  	memcpy(&td->start, &tv, sizeof(tv));
+	memcpy(&td->iops_sample_time, &tv, sizeof(tv));
+	memcpy(&td->bw_sample_time, &tv, sizeof(tv));

  	lat_target_reset(td);
  	clear_rusage_stat(td);
diff --git a/stat.c b/stat.c
index 6d8d4d0..49ce2e6 100644
--- a/stat.c
+++ b/stat.c
@@ -1862,10 +1862,15 @@ static void __add_log_sample(struct io_log 
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
  			if (iolog_flush(iolog, 0)) {
@@ -1882,7 +1887,7 @@ static void __add_log_sample(struct io_log *iolog, 
unsigned long val,
  				return;
  			}
  			iolog->log = new_log;
-			iolog->max_samples <<= 1;
+			iolog->max_samples = new_samples;
  		}
  	}

@@ -2013,21 +2018,21 @@ static void add_log_sample(struct thread_data 
*td, struct io_log *iolog,
  	iolog->avg_last = elapsed;
  }

-void finalize_logs(struct thread_data *td)
+void finalize_logs(struct thread_data *td, bool unit_logs)
  {
  	unsigned long elapsed;

  	elapsed = mtime_since_now(&td->epoch);

-	if (td->clat_log)
+	if (td->clat_log && (unit_logs == per_unit_log(td->clat_log)))
  		_add_stat_to_log(td->clat_log, elapsed, td->o.log_max != 0);
-	if (td->slat_log)
+	if (td->slat_log && (unit_logs == per_unit_log(td->slat_log)))
  		_add_stat_to_log(td->slat_log, elapsed, td->o.log_max != 0);
-	if (td->lat_log)
+	if (td->lat_log && (unit_logs == per_unit_log(td->lat_log)))
  		_add_stat_to_log(td->lat_log, elapsed, td->o.log_max != 0);
-	if (td->bw_log)
+	if (td->bw_log && (unit_logs == per_unit_log(td->bw_log)))
  		_add_stat_to_log(td->bw_log, elapsed, td->o.log_max != 0);
-	if (td->iops_log)
+	if (td->iops_log && (unit_logs == per_unit_log(td->iops_log)))
  		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
  }

@@ -2108,18 +2113,48 @@ void add_lat_sample(struct thread_data *td, enum 
fio_ddir ddir,
  	td_io_u_unlock(td);
  }

-void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned 
int bs,
-		   struct timeval *t)
+void add_bw_sample(struct thread_data *td, struct io_u *io_u,
+		   unsigned int bytes, unsigned long spent)
  {
  	struct thread_stat *ts = &td->ts;
-	unsigned long spent, rate;
+	unsigned long rate;
+	uint64_t delta;

-	if (!ddir_rw(ddir))
+	if (!ddir_rw(io_u->ddir))
  		return;

+	td_io_u_lock(td);
+
+	delta = td->this_io_bytes[io_u->ddir] - td->stat_io_bytes[io_u->ddir];
+	if (!delta)
+		return;
+
+	if (spent)
+		rate = delta * 1000 / spent / 1024;
+	else
+		rate = 0;
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
+uint64_t add_bw_samples(struct thread_data *td, struct timeval *t)
+{
+	struct thread_stat *ts = &td->ts;
+	unsigned long spent, rate;
+	enum fio_ddir ddir;
+
+	if (per_unit_log(td->bw_log) || !td->o.bw_avg_time)
+		return 0;
+
  	spent = mtime_since(&td->bw_sample_time, t);
  	if (spent < td->o.bw_avg_time)
-		return;
+		return td->o.bw_avg_time - spent;

  	td_io_u_lock(td);

@@ -2141,27 +2176,59 @@ void add_bw_sample(struct thread_data *td, enum 
fio_ddir ddir, unsigned int bs,
  		add_stat_sample(&ts->bw_stat[ddir], rate);

  		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			add_log_sample(td, td->bw_log, rate, ddir, 0, 0);

  		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
  	}

-	fio_gettime(&td->bw_sample_time, NULL);
+	memcpy(&td->bw_sample_time, t, sizeof(*t));
  	td_io_u_unlock(td);
+
+	return td->o.bw_avg_time;
  }

-void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, 
unsigned int bs,
-		     struct timeval *t)
+void add_iops_sample(struct thread_data *td, struct io_u *io_u,
+		     unsigned int bytes, unsigned long spent)
  {
  	struct thread_stat *ts = &td->ts;
-	unsigned long spent, iops;
+	unsigned long iops;
+	uint64_t delta;

-	if (!ddir_rw(ddir))
+	if (!ddir_rw(io_u->ddir))
  		return;

+	td_io_u_lock(td);
+
+	delta = td->this_io_blocks[io_u->ddir] - td->stat_io_blocks[io_u->ddir];
+	if (!delta)
+		return;
+
+	if (spent)
+		iops = (delta * 1000) / spent;
+	else
+		iops = 0;
+
+	add_stat_sample(&ts->iops_stat[io_u->ddir], iops);
+
+	if (td->iops_log)
+		add_log_sample(td, td->iops_log, iops, io_u->ddir, bytes, io_u->offset);
+
+	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
+	td_io_u_unlock(td);
+}
+
+uint64_t add_iops_samples(struct thread_data *td, struct timeval *t)
+{
+	struct thread_stat *ts = &td->ts;
+	unsigned long spent, iops;
+	enum fio_ddir ddir;
+
+	if (per_unit_log(td->iops_log) || !td->o.iops_avg_time)
+		return 0;
+
  	spent = mtime_since(&td->iops_sample_time, t);
  	if (spent < td->o.iops_avg_time)
-		return;
+		return td->o.iops_avg_time - spent;

  	td_io_u_lock(td);

@@ -2183,13 +2250,48 @@ void add_iops_sample(struct thread_data *td, 
enum fio_ddir ddir, unsigned int bs
  		add_stat_sample(&ts->iops_stat[ddir], iops);

  		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			add_log_sample(td, td->iops_log, iops, ddir, 0, 0);

  		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
  	}

-	fio_gettime(&td->iops_sample_time, NULL);
+	memcpy(&td->iops_sample_time, t, sizeof(*t));
  	td_io_u_unlock(td);
+
+	return td->o.iops_avg_time;
+}
+
+/*
+ * Returns msecs to next event
+ */
+unsigned int calc_log_samples(void)
+{
+	struct thread_data *td;
+	struct timeval now;
+	unsigned int next = ~0U, tmp;
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
diff --git a/stat.h b/stat.h
index 9c3f192..d95a2a7 100644
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
+				unsigned int, unsigned long);
+extern void add_bw_sample(struct thread_data *, struct io_u *,
+				unsigned int, unsigned long);
+extern unsigned int calc_log_samples(void);

  extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
  extern int write_bw_log;

-- 
Jens Axboe


