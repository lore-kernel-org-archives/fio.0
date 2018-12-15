Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41932 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729192AbeLONIP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Dec 2018 08:08:15 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gY9fy-0001Y6-Kp
        for fio@vger.kernel.org; Sat, 15 Dec 2018 13:08:14 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181215130002.2C2D52C0053@kernel.dk>
Date: Sat, 15 Dec 2018 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 771c99012e26af0dc2a0b7e0762e5097534144bd:

  engines/aioring: enable IOCTX_FLAG_SQPOLL (2018-12-13 13:52:35 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 5b8f19b7afe0cabc002c453a1a4abd7a494880bb:

  Fix 'min' latency times being 0 with ramp_time (2018-12-14 14:36:52 -0700)

----------------------------------------------------------------
Jens Axboe (6):
      engines/aioring: update to newer API
      client/server: convert nr_zone_resets on the wire
      Add cache hit stats
      t/aio-ring: add cache hit statistics
      engines/aioring: get rid of old error on sqwq and sqthread
      Fix 'min' latency times being 0 with ramp_time

 client.c          |  4 ++++
 engines/aioring.c | 31 ++++++++++++++++++++++++-------
 server.c          |  4 ++++
 server.h          |  2 +-
 stat.c            | 34 +++++++++++++++++++++++++++++-----
 stat.h            |  3 +++
 t/aio-ring.c      | 30 ++++++++++++++++++++++++++----
 7 files changed, 91 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 32489067..480425f6 100644
--- a/client.c
+++ b/client.c
@@ -1000,6 +1000,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 
 	dst->total_submit	= le64_to_cpu(src->total_submit);
 	dst->total_complete	= le64_to_cpu(src->total_complete);
+	dst->nr_zone_resets	= le64_to_cpu(src->nr_zone_resets);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		dst->io_bytes[i]	= le64_to_cpu(src->io_bytes[i]);
@@ -1038,6 +1039,9 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
 			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
 		}
 	}
+
+	dst->cachehit		= le64_to_cpu(src->cachehit);
+	dst->cachemiss		= le64_to_cpu(src->cachemiss);
 }
 
 static void convert_gs(struct group_run_stats *dst, struct group_run_stats *src)
diff --git a/engines/aioring.c b/engines/aioring.c
index cb13b415..925b8862 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -61,6 +61,10 @@ typedef uint64_t u64;
 typedef uint32_t u32;
 typedef uint16_t u16;
 
+#define IORING_SQ_NEED_WAKEUP	(1 << 0)
+
+#define IOEV_RES2_CACHEHIT	(1 << 0)
+
 struct aio_sq_ring {
 	union {
 		struct {
@@ -68,6 +72,7 @@ struct aio_sq_ring {
 			u32 tail;
 			u32 nr_events;
 			u16 sq_thread_cpu;
+			u16 kflags;
 			u64 iocbs;
 		};
 		u32 pad[16];
@@ -100,6 +105,9 @@ struct aioring_data {
 
 	int queued;
 	int cq_ring_off;
+
+	uint64_t cachehit;
+	uint64_t cachemiss;
 };
 
 struct aioring_options {
@@ -238,6 +246,13 @@ static struct io_u *fio_aioring_event(struct thread_data *td, int event)
 	} else
 		io_u->error = 0;
 
+	if (io_u->ddir == DDIR_READ) {
+		if (ev->res2 & IOEV_RES2_CACHEHIT)
+			ld->cachehit++;
+		else
+			ld->cachemiss++;
+	}
+
 	return io_u;
 }
 
@@ -368,6 +383,10 @@ static int fio_aioring_commit(struct thread_data *td)
 
 	/* Nothing to do */
 	if (o->sqthread_poll) {
+		struct aio_sq_ring *ring = ld->sq_ring;
+
+		if (ring->kflags & IORING_SQ_NEED_WAKEUP)
+			io_ring_enter(ld->aio_ctx, ld->queued, 0, IORING_FLAG_SUBMIT);
 		ld->queued = 0;
 		return 0;
 	}
@@ -424,6 +443,9 @@ static void fio_aioring_cleanup(struct thread_data *td)
 	struct aioring_data *ld = td->io_ops_data;
 
 	if (ld) {
+		td->ts.cachehit += ld->cachehit;
+		td->ts.cachemiss += ld->cachemiss;
+
 		/* Bump depth to match init depth */
 		td->o.iodepth++;
 
@@ -458,7 +480,8 @@ static int fio_aioring_queue_init(struct thread_data *td)
 		flags |= IOCTX_FLAG_SQTHREAD;
 		if (o->sqthread_poll)
 			flags |= IOCTX_FLAG_SQPOLL;
-	} else if (o->sqwq)
+	}
+	if (o->sqwq)
 		flags |= IOCTX_FLAG_SQWQ;
 
 	if (o->fixedbufs) {
@@ -510,14 +533,8 @@ static int fio_aioring_post_init(struct thread_data *td)
 
 static int fio_aioring_init(struct thread_data *td)
 {
-	struct aioring_options *o = td->eo;
 	struct aioring_data *ld;
 
-	if (o->sqthread_set && o->sqwq) {
-		log_err("fio: aioring sqthread and sqwq are mutually exclusive\n");
-		return 1;
-	}
-
 	/* ring needs an extra entry, add one to achieve QD set */
 	td->o.iodepth++;
 
diff --git a/server.c b/server.c
index 90d3396b..2a337707 100644
--- a/server.c
+++ b/server.c
@@ -1530,6 +1530,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 
 	p.ts.total_submit	= cpu_to_le64(ts->total_submit);
 	p.ts.total_complete	= cpu_to_le64(ts->total_complete);
+	p.ts.nr_zone_resets	= cpu_to_le64(ts->nr_zone_resets);
 
 	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
 		p.ts.io_bytes[i]	= cpu_to_le64(ts->io_bytes[i]);
@@ -1562,6 +1563,9 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
 	p.ts.ss_deviation.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_deviation.u.f));
 	p.ts.ss_criterion.u.i	= cpu_to_le64(fio_double_to_uint64(ts->ss_criterion.u.f));
 
+	p.ts.cachehit		= cpu_to_le64(ts->cachehit);
+	p.ts.cachemiss		= cpu_to_le64(ts->cachemiss);
+
 	convert_gs(&p.rs, rs);
 
 	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
diff --git a/server.h b/server.h
index 371e51ea..abb23bad 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 77,
+	FIO_SERVER_VER			= 78,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
diff --git a/stat.c b/stat.c
index 887509fe..351c49cc 100644
--- a/stat.c
+++ b/stat.c
@@ -419,7 +419,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	unsigned long runt;
 	unsigned long long min, max, bw, iops;
 	double mean, dev;
-	char *io_p, *bw_p, *bw_p_alt, *iops_p, *zbd_w_st = NULL;
+	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
 	int i2p;
 
 	if (ddir_sync(ddir)) {
@@ -451,15 +451,25 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
 	iops = (1000 * (uint64_t)ts->total_io_u[ddir]) / runt;
 	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
 	if (ddir == DDIR_WRITE)
-		zbd_w_st = zbd_write_status(ts);
+		post_st = zbd_write_status(ts);
+	else if (ddir == DDIR_READ && ts->cachehit && ts->cachemiss) {
+		uint64_t total;
+		double hit;
+
+		total = ts->cachehit + ts->cachemiss;
+		hit = (double) ts->cachehit / (double) total;
+		hit *= 100.0;
+		if (asprintf(&post_st, "; Cachehit=%0.2f%%", hit) < 0)
+			post_st = NULL;
+	}
 
 	log_buf(out, "  %s: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
 			rs->unified_rw_rep ? "mixed" : io_ddir_name(ddir),
 			iops_p, bw_p, bw_p_alt, io_p,
 			(unsigned long long) ts->runtime[ddir],
-			zbd_w_st ? : "");
+			post_st ? : "");
 
-	free(zbd_w_st);
+	free(post_st);
 	free(io_p);
 	free(bw_p);
 	free(bw_p_alt);
@@ -1153,6 +1163,16 @@ static void add_ddir_status_json(struct thread_stat *ts,
 	json_object_add_value_float(dir_object, "iops_stddev", dev);
 	json_object_add_value_int(dir_object, "iops_samples",
 				(&ts->iops_stat[ddir])->samples);
+
+	if (ts->cachehit + ts->cachemiss) {
+		uint64_t total;
+		double hit;
+
+		total = ts->cachehit + ts->cachemiss;
+		hit = (double) ts->cachehit / (double) total;
+		hit *= 100.0;
+		json_object_add_value_float(dir_object, "cachehit", hit);
+	}
 }
 
 static void show_thread_status_terse_all(struct thread_stat *ts,
@@ -1695,6 +1715,8 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
 	dst->total_submit += src->total_submit;
 	dst->total_complete += src->total_complete;
 	dst->nr_zone_resets += src->nr_zone_resets;
+	dst->cachehit += src->cachehit;
+	dst->cachemiss += src->cachemiss;
 }
 
 void init_group_run_stat(struct group_run_stats *gs)
@@ -2329,7 +2351,8 @@ static void __add_log_sample(struct io_log *iolog, union io_sample_data data,
 
 static inline void reset_io_stat(struct io_stat *ios)
 {
-	ios->max_val = ios->min_val = ios->samples = 0;
+	ios->min_val = -1ULL;
+	ios->max_val = ios->samples = 0;
 	ios->mean.u.f = ios->S.u.f = 0;
 }
 
@@ -2376,6 +2399,7 @@ void reset_io_stats(struct thread_data *td)
 	ts->total_submit = 0;
 	ts->total_complete = 0;
 	ts->nr_zone_resets = 0;
+	ts->cachehit = ts->cachemiss = 0;
 }
 
 static void __add_stat_to_log(struct io_log *iolog, enum fio_ddir ddir,
diff --git a/stat.h b/stat.h
index b4ba71e3..e9551381 100644
--- a/stat.h
+++ b/stat.h
@@ -246,6 +246,9 @@ struct thread_stat {
 		uint64_t *ss_bw_data;
 		uint64_t pad5;
 	};
+
+	uint64_t cachehit;
+	uint64_t cachemiss;
 } __attribute__((packed));
 
 struct jobs_eta {
diff --git a/t/aio-ring.c b/t/aio-ring.c
index 322f2ffa..c813c4e7 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -30,6 +30,8 @@
 #define IOCTX_FLAG_SQTHREAD	(1 << 3)	/* Use SQ thread */
 #define IOCTX_FLAG_SQWQ		(1 << 4)	/* Use SQ wq */
 
+#define IOEV_RES2_CACHEHIT	(1 << 0)
+
 #define barrier()	__asm__ __volatile__("": : :"memory")
 
 #define min(a, b)		((a < b) ? (a) : (b))
@@ -87,6 +89,7 @@ struct submitter {
 	unsigned long reaps;
 	unsigned long done;
 	unsigned long calls;
+	unsigned long cachehit, cachemiss;
 	volatile int finish;
 	char filename[128];
 };
@@ -206,6 +209,10 @@ static int reap_events(struct submitter *s)
 			printf("offset=%lu, size=%lu\n", (unsigned long) iocb->u.c.offset, (unsigned long) iocb->u.c.nbytes);
 			return -1;
 		}
+		if (ev->res2 & IOEV_RES2_CACHEHIT)
+			s->cachehit++;
+		else
+			s->cachemiss++;
 		reaped++;
 		head++;
 		if (head == ring->nr_events)
@@ -333,7 +340,7 @@ static void arm_sig_int(void)
 int main(int argc, char *argv[])
 {
 	struct submitter *s = &submitters[0];
-	unsigned long done, calls, reap;
+	unsigned long done, calls, reap, cache_hit, cache_miss;
 	int flags = 0, err;
 	int j;
 	size_t size;
@@ -410,27 +417,42 @@ int main(int argc, char *argv[])
 
 	pthread_create(&s->thread, NULL, submitter_fn, s);
 
-	reap = calls = done = 0;
+	cache_hit = cache_miss = reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
 		unsigned long this_reap = 0;
 		unsigned long this_call = 0;
+		unsigned long this_cache_hit = 0;
+		unsigned long this_cache_miss = 0;
 		unsigned long rpc = 0, ipc = 0;
+		double hit = 0.0;
 
 		sleep(1);
 		this_done += s->done;
 		this_call += s->calls;
 		this_reap += s->reaps;
+		this_cache_hit += s->cachehit;
+		this_cache_miss += s->cachemiss;
+		if (this_cache_hit && this_cache_miss) {
+			unsigned long hits, total;
+
+			hits = this_cache_hit - cache_hit;
+			total = hits + this_cache_miss - cache_miss;
+			hit = (double) hits / (double) total;
+			hit *= 100.0;
+		}
 		if (this_call - calls) {
 			rpc = (this_done - done) / (this_call - calls);
 			ipc = (this_reap - reap) / (this_call - calls);
 		}
-		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%d tail=%d), %lu, %lu\n",
+		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%d tail=%d), Cachehit=%0.2f%%\n",
 				this_done - done, rpc, ipc, s->inflight,
-				s->cq_ring->head, s->cq_ring->tail, s->reaps, s->done);
+				s->cq_ring->head, s->cq_ring->tail, hit);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
+		cache_hit = s->cachehit;
+		cache_miss = s->cachemiss;
 	} while (!finish);
 
 	pthread_join(s->thread, &ret);

