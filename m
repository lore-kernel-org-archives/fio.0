Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49349 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932305AbcK1NAD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 28 Nov 2016 08:00:03 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1cBLXP-0006H1-60
        for fio@vger.kernel.org; Mon, 28 Nov 2016 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20161128130002.2CB012C008C@kernel.dk>
Date: Mon, 28 Nov 2016 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 42f1ee68ceec87fbbfdc4972c35d3cdf7c08d9f6:

  Improve informativeness about directIO support or rather lackthereof on Solaris when errno is set to ENOTTY (2016-11-16 10:16:55 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7a3b2fc3434985fa519db55e8f81734c24af274d:

  server: bump protocol version (2016-11-27 21:40:26 +0000)

----------------------------------------------------------------
Sitsofe Wheeer (2):
      ioengines: Fix td->io_issues[ddir] over decrement
      Silence compiler warnings

Sitsofe Wheeler (5):
      fio: Fix (unsigned) integer overflow issues
      eta: Fix ramp time ETA
      eta: Fix ETA oddness at crossover points
      stat: Change access to io_sample union
      server: bump protocol version

 backend.c        |  7 ++++---
 cconv.c          |  8 ++++----
 client.c         | 16 ++++++++--------
 eta.c            | 38 ++++++++++++++++++++++++++------------
 fio.h            |  4 ++--
 gettime.c        |  2 +-
 init.c           |  2 +-
 io_u.c           |  3 ++-
 ioengines.c      |  1 +
 iolog.c          | 10 +++++-----
 iolog.h          | 14 ++++++++++----
 mutex.c          |  2 +-
 options.c        |  2 +-
 server.c         | 10 +++++-----
 server.h         |  2 +-
 stat.c           | 44 +++++++++++++++++++++++++-------------------
 stat.h           |  8 ++++----
 thread_options.h |  8 ++++----
 18 files changed, 105 insertions(+), 76 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 60cea3c..8616fc2 100644
--- a/backend.c
+++ b/backend.c
@@ -1864,8 +1864,8 @@ static void dump_td_info(struct thread_data *td)
 /*
  * Run over the job map and reap the threads that have exited, if any.
  */
-static void reap_threads(unsigned int *nr_running, unsigned int *t_rate,
-			 unsigned int *m_rate)
+static void reap_threads(unsigned int *nr_running, uint64_t *t_rate,
+			 uint64_t *m_rate)
 {
 	struct thread_data *td;
 	unsigned int cputhreads, realthreads, pending;
@@ -2103,7 +2103,8 @@ static bool waitee_running(struct thread_data *me)
 static void run_threads(struct sk_out *sk_out)
 {
 	struct thread_data *td;
-	unsigned int i, todo, nr_running, m_rate, t_rate, nr_started;
+	unsigned int i, todo, nr_running, nr_started;
+	uint64_t m_rate, t_rate;
 	uint64_t spent;
 
 	if (fio_gtod_offload && fio_start_gtod_thread())
diff --git a/cconv.c b/cconv.c
index 6e0f609..0032cc0 100644
--- a/cconv.c
+++ b/cconv.c
@@ -131,8 +131,8 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 		}
 
 		o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
-		o->rate[i] = le32_to_cpu(top->rate[i]);
-		o->ratemin[i] = le32_to_cpu(top->ratemin[i]);
+		o->rate[i] = le64_to_cpu(top->rate[i]);
+		o->ratemin[i] = le64_to_cpu(top->ratemin[i]);
 		o->rate_iops[i] = le32_to_cpu(top->rate_iops[i]);
 		o->rate_iops_min[i] = le32_to_cpu(top->rate_iops_min[i]);
 
@@ -505,8 +505,8 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 		}
 
 		top->rwmix[i] = cpu_to_le32(o->rwmix[i]);
-		top->rate[i] = cpu_to_le32(o->rate[i]);
-		top->ratemin[i] = cpu_to_le32(o->ratemin[i]);
+		top->rate[i] = cpu_to_le64(o->rate[i]);
+		top->ratemin[i] = cpu_to_le64(o->ratemin[i]);
 		top->rate_iops[i] = cpu_to_le32(o->rate_iops[i]);
 		top->rate_iops_min[i] = cpu_to_le32(o->rate_iops_min[i]);
 
diff --git a/client.c b/client.c
index 9698122..c613887 100644
--- a/client.c
+++ b/client.c
@@ -1135,11 +1135,11 @@ static void convert_jobs_eta(struct jobs_eta *je)
 	je->files_open		= le32_to_cpu(je->files_open);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-		je->m_rate[i]	= le32_to_cpu(je->m_rate[i]);
-		je->t_rate[i]	= le32_to_cpu(je->t_rate[i]);
+		je->m_rate[i]	= le64_to_cpu(je->m_rate[i]);
+		je->t_rate[i]	= le64_to_cpu(je->t_rate[i]);
 		je->m_iops[i]	= le32_to_cpu(je->m_iops[i]);
 		je->t_iops[i]	= le32_to_cpu(je->t_iops[i]);
-		je->rate[i]	= le32_to_cpu(je->rate[i]);
+		je->rate[i]	= le64_to_cpu(je->rate[i]);
 		je->iops[i]	= le32_to_cpu(je->iops[i]);
 	}
 
@@ -1276,7 +1276,7 @@ static void client_flush_hist_samples(FILE *f, int hist_coarseness, void *sample
 		s = (struct io_sample *)((char *)__get_sample(samples, log_offset, i) +
 			i * sizeof(struct io_u_plat_entry));
 
-		entry = s->plat_entry;
+		entry = s->data.plat_entry;
 		io_u_plat = entry->io_u_plat;
 
 		fprintf(f, "%lu, %u, %u, ", (unsigned long) s->time,
@@ -1552,7 +1552,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 			s = (struct io_sample *)((void *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
-		s->val		= le64_to_cpu(s->val);
+		s->data.val	= le64_to_cpu(s->data.val);
 		s->__ddir	= le32_to_cpu(s->__ddir);
 		s->bs		= le32_to_cpu(s->bs);
 
@@ -1563,9 +1563,9 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		}
 
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
-			s->plat_entry = (struct io_u_plat_entry *)(((void *)s) + sizeof(*s));
-			s->plat_entry->list.next = NULL;
-			s->plat_entry->list.prev = NULL;
+			s->data.plat_entry = (struct io_u_plat_entry *)(((void *)s) + sizeof(*s));
+			s->data.plat_entry->list.next = NULL;
+			s->data.plat_entry->list.prev = NULL;
 		}
 	}
 
diff --git a/eta.c b/eta.c
index 3c1aeee..19afad5 100644
--- a/eta.c
+++ b/eta.c
@@ -225,7 +225,11 @@ static unsigned long thread_eta(struct thread_data *td)
 			}
 		}
 
-		eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
+		if (perc == 0.0) {
+			eta_sec = timeout;
+		} else {
+			eta_sec = (unsigned long) (elapsed * (1.0 / perc)) - elapsed;
+		}
 
 		if (td->o.timeout &&
 		    eta_sec > (timeout + done_secs - elapsed))
@@ -235,7 +239,7 @@ static unsigned long thread_eta(struct thread_data *td)
 			|| td->runstate == TD_SETTING_UP
 			|| td->runstate == TD_RAMP
 			|| td->runstate == TD_PRE_READING) {
-		int t_eta = 0, r_eta = 0;
+		int64_t t_eta = 0, r_eta = 0;
 		unsigned long long rate_bytes;
 
 		/*
@@ -247,7 +251,10 @@ static unsigned long thread_eta(struct thread_data *td)
 			uint64_t start_delay = td->o.start_delay;
 			uint64_t ramp_time = td->o.ramp_time;
 
-			t_eta = __timeout + start_delay + ramp_time;
+			t_eta = __timeout + start_delay;
+			if (!td->ramp_time_over) {
+				t_eta += ramp_time;
+			}
 			t_eta /= 1000000ULL;
 
 			if ((td->runstate == TD_RAMP) && in_ramp_time(td)) {
@@ -259,9 +266,16 @@ static unsigned long thread_eta(struct thread_data *td)
 					t_eta -= ramp_left;
 			}
 		}
-		rate_bytes = ddir_rw_sum(td->o.rate);
+		rate_bytes = 0;
+		if (td_read(td))
+			rate_bytes  = td->o.rate[DDIR_READ];
+		if (td_write(td))
+			rate_bytes += td->o.rate[DDIR_WRITE];
+		if (td_trim(td))
+			rate_bytes += td->o.rate[DDIR_TRIM];
+
 		if (rate_bytes) {
-			r_eta = (bytes_total / 1024) / rate_bytes;
+			r_eta = bytes_total / rate_bytes;
 			r_eta += (td->o.start_delay / 1000000ULL);
 		}
 
@@ -285,7 +299,7 @@ static unsigned long thread_eta(struct thread_data *td)
 
 static void calc_rate(int unified_rw_rep, unsigned long mtime,
 		      unsigned long long *io_bytes,
-		      unsigned long long *prev_io_bytes, unsigned int *rate)
+		      unsigned long long *prev_io_bytes, uint64_t *rate)
 {
 	int i;
 
@@ -341,7 +355,7 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 {
 	struct thread_data *td;
 	int i, unified_rw_rep;
-	unsigned long rate_time, disp_time, bw_avg_time, *eta_secs;
+	uint64_t rate_time, disp_time, bw_avg_time, *eta_secs;
 	unsigned long long io_bytes[DDIR_RWDIR_CNT];
 	unsigned long long io_iops[DDIR_RWDIR_CNT];
 	struct timeval now;
@@ -367,8 +381,8 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 	if (!ddir_rw_sum(disp_io_bytes))
 		fill_start_time(&disp_prev_time);
 
-	eta_secs = malloc(thread_number * sizeof(unsigned long));
-	memset(eta_secs, 0, thread_number * sizeof(unsigned long));
+	eta_secs = malloc(thread_number * sizeof(uint64_t));
+	memset(eta_secs, 0, thread_number * sizeof(uint64_t));
 
 	je->elapsed_sec = (mtime_since_genesis() + 999) / 1000;
 
@@ -468,9 +482,9 @@ bool calc_thread_status(struct jobs_eta *je, int force)
 		calc_rate(unified_rw_rep, rate_time, io_bytes, rate_io_bytes,
 				je->rate);
 		memcpy(&rate_prev_time, &now, sizeof(now));
-		add_agg_sample(je->rate[DDIR_READ], DDIR_READ, 0);
-		add_agg_sample(je->rate[DDIR_WRITE], DDIR_WRITE, 0);
-		add_agg_sample(je->rate[DDIR_TRIM], DDIR_TRIM, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_READ]), DDIR_READ, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_WRITE]), DDIR_WRITE, 0);
+		add_agg_sample(sample_val(je->rate[DDIR_TRIM]), DDIR_TRIM, 0);
 	}
 
 	disp_time = mtime_since(&disp_prev_time, &now);
diff --git a/fio.h b/fio.h
index 74c1b30..7e32788 100644
--- a/fio.h
+++ b/fio.h
@@ -269,10 +269,10 @@ struct thread_data {
 	 * Rate state
 	 */
 	uint64_t rate_bps[DDIR_RWDIR_CNT];
-	unsigned long rate_next_io_time[DDIR_RWDIR_CNT];
+	uint64_t rate_next_io_time[DDIR_RWDIR_CNT];
 	unsigned long rate_bytes[DDIR_RWDIR_CNT];
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
-	unsigned long rate_io_issue_bytes[DDIR_RWDIR_CNT];
+	unsigned long long rate_io_issue_bytes[DDIR_RWDIR_CNT];
 	struct timeval lastrate[DDIR_RWDIR_CNT];
 	int64_t last_usec;
 	struct frand_state poisson_state;
diff --git a/gettime.c b/gettime.c
index 73b48b0..85ba7cb 100644
--- a/gettime.c
+++ b/gettime.c
@@ -381,7 +381,7 @@ void fio_clock_init(void)
 
 uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 {
-	long sec, usec;
+	int64_t sec, usec;
 
 	sec = e->tv_sec - s->tv_sec;
 	usec = e->tv_usec - s->tv_usec;
diff --git a/init.c b/init.c
index d8c0bd1..382fa1f 100644
--- a/init.c
+++ b/init.c
@@ -1679,7 +1679,7 @@ static int is_empty_or_comment(char *line)
 /*
  * This is our [ini] type file parser.
  */
-int __parse_jobs_ini(struct thread_data *td,
+static int __parse_jobs_ini(struct thread_data *td,
 		char *file, int is_buf, int stonewall_flag, int type,
 		int nested, char *name, char ***popts, int *aopts, int *nopts)
 {
diff --git a/io_u.c b/io_u.c
index 7b51dd2..428d4b7 100644
--- a/io_u.c
+++ b/io_u.c
@@ -659,7 +659,8 @@ int io_u_quiesce(struct thread_data *td)
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 {
 	enum fio_ddir odir = ddir ^ 1;
-	long usec, now;
+	long usec;
+	uint64_t now;
 
 	assert(ddir_rw(ddir));
 	now = utime_since_now(&td->start);
diff --git a/ioengines.c b/ioengines.c
index 4c53fe5..1b58168 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -298,6 +298,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 		td->io_issues[ddir]--;
 		td->io_issue_bytes[ddir] -= buflen;
 		td->rate_io_issue_bytes[ddir] -= buflen;
+		io_u_clear(td, io_u, IO_U_F_FLIGHT);
 	}
 
 	/*
diff --git a/iolog.c b/iolog.c
index f0ce3b2..2bc3e3a 100644
--- a/iolog.c
+++ b/iolog.c
@@ -720,7 +720,7 @@ static void flush_hist_samples(FILE *f, int hist_coarseness, void *samples,
 	for (i = 0; i < nr_samples; i++) {
 		s = __get_sample(samples, log_offset, i);
 
-		entry = (struct io_u_plat_entry *) (uintptr_t) s->val;
+		entry = s->data.plat_entry;
 		io_u_plat = entry->io_u_plat;
 
 		entry_before = flist_first_entry(&entry->list, struct io_u_plat_entry, list);
@@ -759,16 +759,16 @@ void flush_samples(FILE *f, void *samples, uint64_t sample_size)
 		s = __get_sample(samples, log_offset, i);
 
 		if (!log_offset) {
-			fprintf(f, "%lu, %lu, %u, %u\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %u\n",
 					(unsigned long) s->time,
-					(unsigned long) s->val,
+					s->data.val,
 					io_sample_ddir(s), s->bs);
 		} else {
 			struct io_sample_offset *so = (void *) s;
 
-			fprintf(f, "%lu, %lu, %u, %u, %llu\n",
+			fprintf(f, "%lu, %" PRId64 ", %u, %u, %llu\n",
 					(unsigned long) s->time,
-					(unsigned long) s->val,
+					s->data.val,
 					io_sample_ddir(s), s->bs,
 					(unsigned long long) so->offset);
 		}
diff --git a/iolog.h b/iolog.h
index de641d5..ee28944 100644
--- a/iolog.h
+++ b/iolog.h
@@ -24,15 +24,21 @@ struct io_hist {
 	struct flist_head list;
 };
 
+
+union io_sample_data {
+	uint64_t val;
+	struct io_u_plat_entry *plat_entry;
+};
+
+#define sample_val(value) ((union io_sample_data) { .val = value })
+#define sample_plat(plat) ((union io_sample_data) { .plat_entry = plat })
+
 /*
  * A single data sample
  */
 struct io_sample {
 	uint64_t time;
-	union {
-		uint64_t val;
-		struct io_u_plat_entry *plat_entry;
-	};
+	union io_sample_data data;
 	uint32_t __ddir;
 	uint32_t bs;
 };
diff --git a/mutex.c b/mutex.c
index e5b045e..5e5a064 100644
--- a/mutex.c
+++ b/mutex.c
@@ -162,7 +162,7 @@ int fio_mutex_down_timeout(struct fio_mutex *mutex, unsigned int msecs)
 	t.tv_nsec = tv_s.tv_usec * 1000;
 
 	t.tv_sec += msecs / 1000;
-	t.tv_nsec += ((msecs * 1000000) % 1000000000);
+	t.tv_nsec += ((msecs * 1000000ULL) % 1000000000);
 	if (t.tv_nsec >= 1000000000) {
 		t.tv_nsec -= 1000000000;
 		t.tv_sec++;
diff --git a/options.c b/options.c
index 5937eb6..dfecd9d 100644
--- a/options.c
+++ b/options.c
@@ -22,7 +22,7 @@ char client_sockaddr_str[INET6_ADDRSTRLEN] = { 0 };
 
 #define cb_data_to_td(data)	container_of(data, struct thread_data, o)
 
-struct pattern_fmt_desc fmt_desc[] = {
+static struct pattern_fmt_desc fmt_desc[] = {
 	{
 		.fmt   = "%o",
 		.len   = FIELD_SIZE(struct io_u *, offset),
diff --git a/server.c b/server.c
index 091c161..ab3e7cf 100644
--- a/server.c
+++ b/server.c
@@ -912,11 +912,11 @@ static int handle_send_eta_cmd(struct fio_net_cmd *cmd)
 		je->files_open		= cpu_to_le32(je->files_open);
 
 		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
-			je->m_rate[i]	= cpu_to_le32(je->m_rate[i]);
-			je->t_rate[i]	= cpu_to_le32(je->t_rate[i]);
+			je->m_rate[i]	= cpu_to_le64(je->m_rate[i]);
+			je->t_rate[i]	= cpu_to_le64(je->t_rate[i]);
 			je->m_iops[i]	= cpu_to_le32(je->m_iops[i]);
 			je->t_iops[i]	= cpu_to_le32(je->t_iops[i]);
-			je->rate[i]	= cpu_to_le32(je->rate[i]);
+			je->rate[i]	= cpu_to_le64(je->rate[i]);
 			je->iops[i]	= cpu_to_le32(je->iops[i]);
 		}
 
@@ -1730,7 +1730,7 @@ static int __fio_append_iolog_gz_hist(struct sk_entry *first, struct io_log *log
 		/* Do the subtraction on server side so that client doesn't have to
 		 * reconstruct our linked list from packets.
 		 */
-		cur_plat_entry  = s->plat_entry;
+		cur_plat_entry  = s->data.plat_entry;
 		prev_plat_entry = flist_first_entry(&cur_plat_entry->list, struct io_u_plat_entry, list);
 		cur_plat  = cur_plat_entry->io_u_plat;
 		prev_plat = prev_plat_entry->io_u_plat;
@@ -1934,7 +1934,7 @@ int fio_send_iolog(struct thread_data *td, struct io_log *log, const char *name)
 			struct io_sample *s = get_sample(log, cur_log, i);
 
 			s->time		= cpu_to_le64(s->time);
-			s->val		= cpu_to_le64(s->val);
+			s->data.val	= cpu_to_le64(s->data.val);
 			s->__ddir	= cpu_to_le32(s->__ddir);
 			s->bs		= cpu_to_le32(s->bs);
 
diff --git a/server.h b/server.h
index 3b592c7..4a81bcd 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 58,
+	FIO_SERVER_VER			= 59,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 1e889f5..423aacd 100644
--- a/stat.c
+++ b/stat.c
@@ -2005,7 +2005,7 @@ static struct io_logs *get_cur_log(struct io_log *iolog)
 	return iolog->pending;
 }
 
-static void __add_log_sample(struct io_log *iolog, unsigned long val,
+static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 			     enum fio_ddir ddir, unsigned int bs,
 			     unsigned long t, uint64_t offset)
 {
@@ -2022,7 +2022,7 @@ static void __add_log_sample(struct io_log *iolog, unsigned long val,
 
 		s = get_sample(iolog, cur_log, cur_log->nr_samples);
 
-		s->val = val;
+		s->data = data;
 		s->time = t + (iolog->td ? iolog->td->unix_epoch : 0);
 		io_sample_set_ddir(iolog, s, ddir);
 		s->bs = bs;
@@ -2091,14 +2091,14 @@ static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
 	 * had actual samples done.
 	 */
 	if (iolog->avg_window[ddir].samples) {
-		unsigned long val;
+		union io_sample_data data;
 
 		if (log_max)
-			val = iolog->avg_window[ddir].max_val;
+			data.val = iolog->avg_window[ddir].max_val;
 		else
-			val = iolog->avg_window[ddir].mean.u.f + 0.50;
+			data.val = iolog->avg_window[ddir].mean.u.f + 0.50;
 
-		__add_log_sample(iolog, val, ddir, 0, elapsed, 0);
+		__add_log_sample(iolog, data, ddir, 0, elapsed, 0);
 	}
 
 	reset_io_stat(&iolog->avg_window[ddir]);
@@ -2114,7 +2114,7 @@ static void _add_stat_to_log(struct io_log *iolog, unsigned long elapsed,
 }
 
 static long add_log_sample(struct thread_data *td, struct io_log *iolog,
-			   unsigned long val, enum fio_ddir ddir,
+			   union io_sample_data data, enum fio_ddir ddir,
 			   unsigned int bs, uint64_t offset)
 {
 	unsigned long elapsed, this_window;
@@ -2128,7 +2128,7 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * If no time averaging, just add the log sample.
 	 */
 	if (!iolog->avg_msec) {
-		__add_log_sample(iolog, val, ddir, bs, elapsed, offset);
+		__add_log_sample(iolog, data, ddir, bs, elapsed, offset);
 		return 0;
 	}
 
@@ -2136,7 +2136,7 @@ static long add_log_sample(struct thread_data *td, struct io_log *iolog,
 	 * Add the sample. If the time period has passed, then
 	 * add that entry to the log and clear.
 	 */
-	add_stat_sample(&iolog->avg_window[ddir], val);
+	add_stat_sample(&iolog->avg_window[ddir], data.val);
 
 	/*
 	 * If period hasn't passed, adding the above sample is all we
@@ -2176,7 +2176,7 @@ void finalize_logs(struct thread_data *td, bool unit_logs)
 		_add_stat_to_log(td->iops_log, elapsed, td->o.log_max != 0);
 }
 
-void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
+void add_agg_sample(union io_sample_data data, enum fio_ddir ddir, unsigned int bs)
 {
 	struct io_log *iolog;
 
@@ -2184,7 +2184,7 @@ void add_agg_sample(unsigned long val, enum fio_ddir ddir, unsigned int bs)
 		return;
 
 	iolog = agg_io_log[ddir];
-	__add_log_sample(iolog, val, ddir, bs, mtime_since_genesis(), 0);
+	__add_log_sample(iolog, data, ddir, bs, mtime_since_genesis(), 0);
 }
 
 static void add_clat_percentile_sample(struct thread_stat *ts,
@@ -2208,7 +2208,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->clat_stat[ddir], usec);
 
 	if (td->clat_log)
-		add_log_sample(td, td->clat_log, usec, ddir, bs, offset);
+		add_log_sample(td, td->clat_log, sample_val(usec), ddir, bs,
+			       offset);
 
 	if (ts->clat_percentiles)
 		add_clat_percentile_sample(ts, usec, ddir);
@@ -2238,7 +2239,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
 			memcpy(&(dst->io_u_plat), io_u_plat,
 				FIO_IO_U_PLAT_NR * sizeof(unsigned int));
 			flist_add(&dst->list, &hw->list);
-			__add_log_sample(iolog, (unsigned long)dst, ddir, bs,
+			__add_log_sample(iolog, sample_plat(dst), ddir, bs,
 						elapsed, offset);
 
 			/*
@@ -2267,7 +2268,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->slat_stat[ddir], usec);
 
 	if (td->slat_log)
-		add_log_sample(td, td->slat_log, usec, ddir, bs, offset);
+		add_log_sample(td, td->slat_log, sample_val(usec), ddir, bs, offset);
 
 	td_io_u_unlock(td);
 }
@@ -2285,7 +2286,8 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
 	add_stat_sample(&ts->lat_stat[ddir], usec);
 
 	if (td->lat_log)
-		add_log_sample(td, td->lat_log, usec, ddir, bs, offset);
+		add_log_sample(td, td->lat_log, sample_val(usec), ddir, bs,
+			       offset);
 
 	td_io_u_unlock(td);
 }
@@ -2306,7 +2308,8 @@ void add_bw_sample(struct thread_data *td, struct io_u *io_u,
 	add_stat_sample(&ts->bw_stat[io_u->ddir], rate);
 
 	if (td->bw_log)
-		add_log_sample(td, td->bw_log, rate, io_u->ddir, bytes, io_u->offset);
+		add_log_sample(td, td->bw_log, sample_val(rate), io_u->ddir,
+			       bytes, io_u->offset);
 
 	td->stat_io_bytes[io_u->ddir] = td->this_io_bytes[io_u->ddir];
 	td_io_u_unlock(td);
@@ -2351,7 +2354,8 @@ static int add_bw_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, td->bw_log, rate, ddir, bs, 0);
+			next = add_log_sample(td, td->bw_log, sample_val(rate),
+					      ddir, bs, 0);
 			next_log = min(next_log, next);
 		}
 
@@ -2379,7 +2383,8 @@ void add_iops_sample(struct thread_data *td, struct io_u *io_u,
 	add_stat_sample(&ts->iops_stat[io_u->ddir], 1);
 
 	if (td->iops_log)
-		add_log_sample(td, td->iops_log, 1, io_u->ddir, bytes, io_u->offset);
+		add_log_sample(td, td->iops_log, sample_val(1), io_u->ddir,
+			       bytes, io_u->offset);
 
 	td->stat_io_blocks[io_u->ddir] = td->this_io_blocks[io_u->ddir];
 	td_io_u_unlock(td);
@@ -2424,7 +2429,8 @@ static int add_iops_samples(struct thread_data *td, struct timeval *t)
 			if (td->o.min_bs[ddir] == td->o.max_bs[ddir])
 				bs = td->o.min_bs[ddir];
 
-			next = add_log_sample(td, td->iops_log, iops, ddir, bs, 0);
+			next = add_log_sample(td, td->iops_log,
+					      sample_val(iops), ddir, bs, 0);
 			next_log = min(next_log, next);
 		}
 
diff --git a/stat.h b/stat.h
index e6f7759..75d1f4e 100644
--- a/stat.h
+++ b/stat.h
@@ -123,7 +123,7 @@ struct group_run_stats {
 #define BLOCK_INFO_STATE(block_info)		\
 	((block_info) >> BLOCK_INFO_STATE_SHIFT)
 #define BLOCK_INFO(state, trim_cycles)	\
-	((trim_cycles) | ((state) << BLOCK_INFO_STATE_SHIFT))
+	((trim_cycles) | ((unsigned int) (state) << BLOCK_INFO_STATE_SHIFT))
 #define BLOCK_INFO_SET_STATE(block_info, state)	\
 	BLOCK_INFO(state, BLOCK_INFO_TRIMS(block_info))
 enum block_info_state {
@@ -224,9 +224,9 @@ struct jobs_eta {
 
 	uint32_t files_open;
 
-	uint32_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
+	uint64_t m_rate[DDIR_RWDIR_CNT], t_rate[DDIR_RWDIR_CNT];
 	uint32_t m_iops[DDIR_RWDIR_CNT], t_iops[DDIR_RWDIR_CNT];
-	uint32_t rate[DDIR_RWDIR_CNT];
+	uint64_t rate[DDIR_RWDIR_CNT];
 	uint32_t iops[DDIR_RWDIR_CNT];
 	uint64_t elapsed_sec;
 	uint64_t eta_sec;
@@ -281,7 +281,7 @@ extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int, uint64_t);
 extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long,
 				unsigned int, uint64_t);
-extern void add_agg_sample(unsigned long, enum fio_ddir, unsigned int);
+extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned int);
 extern void add_iops_sample(struct thread_data *, struct io_u *,
 				unsigned int);
 extern void add_bw_sample(struct thread_data *, struct io_u *,
diff --git a/thread_options.h b/thread_options.h
index 5e379e3..8ec6b97 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -251,8 +251,8 @@ struct thread_options {
 	char *exec_prerun;
 	char *exec_postrun;
 
-	unsigned int rate[DDIR_RWDIR_CNT];
-	unsigned int ratemin[DDIR_RWDIR_CNT];
+	uint64_t rate[DDIR_RWDIR_CNT];
+	uint64_t ratemin[DDIR_RWDIR_CNT];
 	unsigned int ratecycle;
 	unsigned int io_submit_mode;
 	unsigned int rate_iops[DDIR_RWDIR_CNT];
@@ -516,8 +516,8 @@ struct thread_options_pack {
 	uint8_t exec_prerun[FIO_TOP_STR_MAX];
 	uint8_t exec_postrun[FIO_TOP_STR_MAX];
 
-	uint32_t rate[DDIR_RWDIR_CNT];
-	uint32_t ratemin[DDIR_RWDIR_CNT];
+	uint64_t rate[DDIR_RWDIR_CNT];
+	uint64_t ratemin[DDIR_RWDIR_CNT];
 	uint32_t ratecycle;
 	uint32_t io_submit_mode;
 	uint32_t rate_iops[DDIR_RWDIR_CNT];
