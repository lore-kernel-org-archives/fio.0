Return-Path: <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
References: <eBGJ1s00E1TeosZ01BGKGG> <036a01d19f62$717af530$5470df90$@cox.net>
 <20160427203823.GB25397@kernel.dk> <572A02B9.1040902@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <572A24AC.5090106@kernel.dk>
Date: Wed, 4 May 2016 10:34:52 -0600
MIME-Version: 1.0
In-Reply-To: <572A02B9.1040902@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

On 05/04/2016 08:10 AM, Jens Axboe wrote:
> On 04/27/2016 02:38 PM, Jens Axboe wrote:
>> I'll try and see if I can reproduce this.
>
> So I took a look at your logged output. The way that fio logs is that it
> does it on IO completion. You have set 1s intervals, so it checks, when
> an IO completes, if we're due for logging the previous interval IOPS:
>
> spent = mtime_since(&td->iops_sample_time, t);
> if (spent < td->o.iops_avg_time)
>          return;
>
> If you are doing lots of IO, it matches pretty evenly. But for slow
> workloads, it will end up being skewed a bit. It won't be too hard to
> fix the drift, though, but it still won't make it clock precise at exact
> 1s intervals.
>
> We could move this part into the main thread, and out of the workers.
> Then we could make it more precise. Might not be a bad idea in general,
> since it'll move some of this code out of the fast path.
>
> I'll take a stab at it.

Can you try the below patch?

diff --git a/backend.c b/backend.c
index 1723b8f..6ce54fc 100644
--- a/backend.c
+++ b/backend.c
@@ -1722,8 +1722,6 @@ static void *thread_main(void *data)

  	fio_unpin_memory(td);

-	fio_writeout_logs(td);
-
  	iolog_compress_exit(td);
  	rate_submit_exit(td);

@@ -2338,17 +2336,21 @@ static void free_disk_util(void)
  static void *helper_thread_main(void *data)
  {
  	struct sk_out *sk_out = data;
+	struct timeval last_du;
+	uint64_t msec_to_next_event = DISK_UTIL_MSEC;
  	int ret = 0;

  	sk_out_assign(sk_out);

  	fio_mutex_up(startup_mutex);

-	while (!ret) {
-		uint64_t sec = DISK_UTIL_MSEC / 1000;
-		uint64_t nsec = (DISK_UTIL_MSEC % 1000) * 1000000;
+	gettimeofday(&last_du, NULL);
+
+	while (!ret && !helper_exit) {
+		uint64_t sec = msec_to_next_event / 1000;
+		uint64_t nsec = (msec_to_next_event % 1000) * 1000000;
  		struct timespec ts;
-		struct timeval tv;
+		struct timeval now, tv;

  		gettimeofday(&tv, NULL);
  		ts.tv_sec = tv.tv_sec + sec;
@@ -2361,7 +2363,16 @@ static void *helper_thread_main(void *data)

  		pthread_cond_timedwait(&helper_cond, &helper_lock, &ts);

-		ret = update_io_ticks();
+		gettimeofday(&now, NULL);
+
+		if (mtime_since(&last_du, &now) >= DISK_UTIL_MSEC) {
+			ret = update_io_ticks();
+			memcpy(&last_du, &now, sizeof(now));
+		}
+
+		msec_to_next_event = calc_log_samples();
+		if (!msec_to_next_event || msec_to_next_event > DISK_UTIL_MSEC)
+			msec_to_next_event = DISK_UTIL_MSEC;

  		if (helper_do_stat) {
  			helper_do_stat = 0;
@@ -2372,6 +2383,8 @@ static void *helper_thread_main(void *data)
  			print_thread_status();
  	}

+	fio_writeout_logs();
+
  	sk_out_drop();
  	return NULL;
  }
diff --git a/io_u.c b/io_u.c
index 6622bc0..881fd67 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1715,12 +1715,6 @@ static void account_io_completion(struct 
thread_data *td, struct io_u *io_u,
  		io_u_mark_latency(td, lusec);
  	}

-	if (!td->o.disable_bw)
-		add_bw_sample(td, idx, bytes, &icd->time);
-
-	if (no_reduce)
-		add_iops_sample(td, idx, bytes, &icd->time);
-
  	if (td->ts.nr_block_infos && io_u->ddir == DDIR_TRIM) {
  		uint32_t *info = io_u_block_info(td, io_u);
  		if (BLOCK_INFO_STATE(*info) < BLOCK_STATE_TRIM_FAILURE) {
diff --git a/iolog.c b/iolog.c
index feda9ed..6f53f3f 100644
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
@@ -1302,7 +1301,7 @@ static struct log_type log_types[] = {
  	},
  };

-void fio_writeout_logs(struct thread_data *td)
+static void td_writeout_logs(struct thread_data *td)
  {
  	unsigned int log_mask = 0;
  	unsigned int log_left = ALL_LOG_NR;
@@ -1334,3 +1333,12 @@ void fio_writeout_logs(struct thread_data *td)

  	td_restore_runstate(td, old_state);
  }
+
+void fio_writeout_logs(void)
+{
+	struct thread_data *td;
+	int i;
+
+	for_each_td(td, i)
+		td_writeout_logs(td);
+}
diff --git a/iolog.h b/iolog.h
index 297daf5..a1b2ec5 100644
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
@@ -210,7 +212,7 @@ extern void setup_log(struct io_log **, struct 
log_params *, const char *);
  extern void flush_log(struct io_log *, int);
  extern void flush_samples(FILE *, void *, uint64_t);
  extern void free_log(struct io_log *);
-extern void fio_writeout_logs(struct thread_data *);
+extern void fio_writeout_logs(void);
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
index 6d8d4d0..8087970 100644
--- a/stat.c
+++ b/stat.c
@@ -1865,7 +1865,11 @@ static void __add_log_sample(struct io_log 
*iolog, unsigned long val,
  		size_t new_size;
  		void *new_log;

-		new_size = 2 * iolog->max_samples * log_entry_sz(iolog);
+		if (!iolog->max_samples) {
+			iolog->max_samples = DEF_LOG_ENTRIES;
+			new_size = DEF_LOG_ENTRIES * log_entry_sz(iolog);
+		} else
+			new_size = 2 * iolog->max_samples * log_entry_sz(iolog);

  		if (iolog->log_gz && (new_size > iolog->log_gz)) {
  			if (iolog_flush(iolog, 0)) {
@@ -1882,7 +1886,7 @@ static void __add_log_sample(struct io_log *iolog, 
unsigned long val,
  				return;
  			}
  			iolog->log = new_log;
-			iolog->max_samples <<= 1;
+			iolog->max_samples = new_size;
  		}
  	}

@@ -2108,18 +2112,15 @@ void add_lat_sample(struct thread_data *td, enum 
fio_ddir ddir,
  	td_io_u_unlock(td);
  }

-void add_bw_sample(struct thread_data *td, enum fio_ddir ddir, unsigned 
int bs,
-		   struct timeval *t)
+static uint64_t add_bw_sample(struct thread_data *td, struct timeval *t)
  {
  	struct thread_stat *ts = &td->ts;
  	unsigned long spent, rate;
-
-	if (!ddir_rw(ddir))
-		return;
+	enum fio_ddir ddir;

  	spent = mtime_since(&td->bw_sample_time, t);
  	if (spent < td->o.bw_avg_time)
-		return;
+		return td->o.bw_avg_time - spent;

  	td_io_u_lock(td);

@@ -2141,27 +2142,25 @@ void add_bw_sample(struct thread_data *td, enum 
fio_ddir ddir, unsigned int bs,
  		add_stat_sample(&ts->bw_stat[ddir], rate);

  		if (td->bw_log)
-			add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			add_log_sample(td, td->bw_log, rate, ddir, 0, 0);

  		td->stat_io_bytes[ddir] = td->this_io_bytes[ddir];
  	}

  	fio_gettime(&td->bw_sample_time, NULL);
  	td_io_u_unlock(td);
+	return td->o.bw_avg_time;
  }

-void add_iops_sample(struct thread_data *td, enum fio_ddir ddir, 
unsigned int bs,
-		     struct timeval *t)
+static uint64_t add_iops_sample(struct thread_data *td, struct timeval *t)
  {
  	struct thread_stat *ts = &td->ts;
  	unsigned long spent, iops;
-
-	if (!ddir_rw(ddir))
-		return;
+	enum fio_ddir ddir;

  	spent = mtime_since(&td->iops_sample_time, t);
  	if (spent < td->o.iops_avg_time)
-		return;
+		return td->o.iops_avg_time - spent;

  	td_io_u_lock(td);

@@ -2183,13 +2182,41 @@ void add_iops_sample(struct thread_data *td, 
enum fio_ddir ddir, unsigned int bs
  		add_stat_sample(&ts->iops_stat[ddir], iops);

  		if (td->iops_log)
-			add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			add_log_sample(td, td->iops_log, iops, ddir, 0, 0);

  		td->stat_io_blocks[ddir] = td->this_io_blocks[ddir];
  	}

  	fio_gettime(&td->iops_sample_time, NULL);
  	td_io_u_unlock(td);
+	return td->o.iops_avg_time;
+}
+
+uint64_t calc_log_samples(void)
+{
+	struct thread_data *td;
+	struct timeval now;
+	uint64_t next = ~0ULL, tmp;
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
+		tmp = add_bw_sample(td, &now);
+		if (tmp < next)
+			next = tmp;
+
+		tmp = add_iops_sample(td, &now);
+		if (tmp < next)
+			next = tmp;
+	}
+
+	return next == ~0ULL ? 0 : next;
  }

  void stat_init(void)
diff --git a/stat.h b/stat.h
index 9c3f192..91a8cff 100644
--- a/stat.h
+++ b/stat.h
@@ -276,11 +276,8 @@ extern void add_clat_sample(struct thread_data *, 
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
+extern uint64_t calc_log_samples(void);

  extern struct io_log *agg_io_log[DDIR_RWDIR_CNT];
  extern int write_bw_log;

-- 
Jens Axboe


