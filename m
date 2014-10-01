Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50466 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbaJAMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Oct 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XZIZg-0000gO-Pt
	for fio@vger.kernel.org; Wed, 01 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141001120003.8657640128@lyth.info>
Date: Wed,  1 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 0bc27b0b7019e4c386f83258430fb6b3ac34cc06:

  filesetup: fix a bug where we overwrite the set size (2014-09-29 21:23:51 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a120ca7f793b41532b04e3915fcd6646fa37bb4f:

  engines/libaio: don't reap on EAGAIN and no pending events (2014-09-30 20:28:45 -0600)

----------------------------------------------------------------
Jens Axboe (5):
      Use calloc() instead of malloc + memset
      Constify 'td' in a few functions
      engines/libaio: fix issue with EAGAIN
      Constify a few more hot paths
      engines/libaio: don't reap on EAGAIN and no pending events

ordahan (1):
      HOWTO: fix typo

 HOWTO                       |    4 +-
 engines/binject.c           |    3 +-
 engines/glusterfs_async.c   |    2 +-
 engines/guasi.c             |    2 +-
 engines/libaio.c            |  110 ++++++++++++++++++++++++++++++++-----------
 engines/null.c              |    2 +-
 engines/posixaio.c          |    2 +-
 engines/rbd.c               |    2 +-
 engines/rdma.c              |    2 +-
 engines/sg.c                |    3 +-
 engines/skeleton_external.c |    2 +-
 engines/solarisaio.c        |    2 +-
 engines/sync.c              |    2 +-
 engines/windowsaio.c        |    5 +-
 fio.h                       |    2 +-
 fio_time.h                  |   10 ++--
 gettime.c                   |   10 ++--
 io_u.c                      |    2 +-
 io_u_queue.h                |    2 +-
 ioengine.h                  |   10 ++--
 ioengines.c                 |    9 ++--
 iolog.c                     |    8 ++--
 iolog.h                     |    4 +-
 json.c                      |   10 +---
 24 files changed, 131 insertions(+), 79 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index e770b99..693eeb1 100644
--- a/HOWTO
+++ b/HOWTO
@@ -379,7 +379,7 @@ rw=str		Type of io pattern. Accepted values are:
 		For certain types of io the result may still be skewed a bit,
 		since the speed may be different. It is possible to specify
 		a number of IO's to do before getting a new offset, this is
-		one by appending a ':<nr>' to the end of the string given.
+		done by appending a ':<nr>' to the end of the string given.
 		For a random read, it would look like 'rw=randread:8' for
 		passing in an offset modifier with a value of 8. If the
 		suffix is used with a sequential IO pattern, then the value
@@ -554,7 +554,7 @@ bssplit=str	Sometimes you want even finer grained control of the
 		while having 90% 4k writes and 10% 8k writes, you would
 		specify:
 
-		bssplit=2k/50:4k/50,4k/90,8k/10
+		bssplit=2k/50:4k/50,4k/90:8k/10
 
 blocksize_unaligned
 bs_unaligned	If this option is given, any byte size value within bsrange
diff --git a/engines/binject.c b/engines/binject.c
index 43e3169..c0baf9d 100644
--- a/engines/binject.c
+++ b/engines/binject.c
@@ -91,7 +91,8 @@ one_more:
 }
 
 static int fio_binject_getevents(struct thread_data *td, unsigned int min,
-			      unsigned int max, struct timespec fio_unused *t)
+				 unsigned int max,
+				 const struct timespec fio_unused *t)
 {
 	struct binject_data *bd = td->io_ops->data;
 	int left = max, ret, r = 0, ev_index = 0;
diff --git a/engines/glusterfs_async.c b/engines/glusterfs_async.c
index 7b0b30a..599bc5d 100644
--- a/engines/glusterfs_async.c
+++ b/engines/glusterfs_async.c
@@ -20,7 +20,7 @@ static struct io_u *fio_gf_event(struct thread_data *td, int event)
 }
 
 static int fio_gf_getevents(struct thread_data *td, unsigned int min,
-			    unsigned int max, struct timespec *t)
+			    unsigned int max, const struct timespec *t)
 {
 	struct gf_data *g = td->io_ops->data;
 	unsigned int events = 0;
diff --git a/engines/guasi.c b/engines/guasi.c
index c9c7429..c586f09 100644
--- a/engines/guasi.c
+++ b/engines/guasi.c
@@ -80,7 +80,7 @@ static struct io_u *fio_guasi_event(struct thread_data *td, int event)
 }
 
 static int fio_guasi_getevents(struct thread_data *td, unsigned int min,
-			       unsigned int max, struct timespec *t)
+			       unsigned int max, const struct timespec *t)
 {
 	struct guasi_data *ld = td->io_ops->data;
 	int n, r;
diff --git a/engines/libaio.c b/engines/libaio.c
index 9cc910d..ca7bfde 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -18,7 +18,20 @@ struct libaio_data {
 	struct io_event *aio_events;
 	struct iocb **iocbs;
 	struct io_u **io_us;
-	int iocbs_nr;
+
+	/*
+	 * Basic ring buffer. 'head' is incremented in _queue(), and
+	 * 'tail' is incremented in _commit(). We keep 'queued' so
+	 * that we know if the ring is full or empty, when
+	 * 'head' == 'tail'. 'entries' is the ring size, and
+	 * 'is_pow2' is just an optimization to use AND instead of
+	 * modulus to get the remainder on ring increment.
+	 */
+	int is_pow2;
+	unsigned int entries;
+	unsigned int queued;
+	unsigned int head;
+	unsigned int tail;
 };
 
 struct libaio_options {
@@ -41,6 +54,15 @@ static struct fio_option options[] = {
 	},
 };
 
+static inline void ring_inc(struct libaio_data *ld, unsigned int *val,
+			    unsigned int add)
+{
+	if (ld->is_pow2)
+		*val = (*val + add) & (ld->entries - 1);
+	else
+		*val = (*val + add) % ld->entries;
+}
+
 static int fio_libaio_prep(struct thread_data fio_unused *td, struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
@@ -117,13 +139,19 @@ static int user_io_getevents(io_context_t aio_ctx, unsigned int max,
 }
 
 static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
-				unsigned int max, struct timespec *t)
+				unsigned int max, const struct timespec *t)
 {
 	struct libaio_data *ld = td->io_ops->data;
 	struct libaio_options *o = td->eo;
 	unsigned actual_min = td->o.iodepth_batch_complete == 0 ? 0 : min;
+	struct timespec __lt, *lt = NULL;
 	int r, events = 0;
 
+	if (t) {
+		__lt = *t;
+		lt = &__lt;
+	}
+
 	do {
 		if (o->userspace_reap == 1
 		    && actual_min == 0
@@ -133,7 +161,7 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 				ld->aio_events + events);
 		} else {
 			r = io_getevents(ld->aio_ctx, actual_min,
-				max, ld->aio_events + events, t);
+				max, ld->aio_events + events, lt);
 		}
 		if (r >= 0)
 			events += r;
@@ -150,7 +178,7 @@ static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 
 	fio_ro_check(td, io_u);
 
-	if (ld->iocbs_nr == (int) td->o.iodepth)
+	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
 	/*
@@ -160,7 +188,7 @@ static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 	 * have pending io, to let fio complete those first.
 	 */
 	if (ddir_sync(io_u->ddir)) {
-		if (ld->iocbs_nr)
+		if (ld->queued)
 			return FIO_Q_BUSY;
 
 		do_io_u_sync(td, io_u);
@@ -168,16 +196,17 @@ static int fio_libaio_queue(struct thread_data *td, struct io_u *io_u)
 	}
 
 	if (io_u->ddir == DDIR_TRIM) {
-		if (ld->iocbs_nr)
+		if (ld->queued)
 			return FIO_Q_BUSY;
 
 		do_io_u_trim(td, io_u);
 		return FIO_Q_COMPLETED;
 	}
 
-	ld->iocbs[ld->iocbs_nr] = &io_u->iocb;
-	ld->io_us[ld->iocbs_nr] = io_u;
-	ld->iocbs_nr++;
+	ld->iocbs[ld->head] = &io_u->iocb;
+	ld->io_us[ld->head] = io_u;
+	ring_inc(ld, &ld->head, 1);
+	ld->queued++;
 	return FIO_Q_QUEUED;
 }
 
@@ -205,29 +234,56 @@ static int fio_libaio_commit(struct thread_data *td)
 	struct libaio_data *ld = td->io_ops->data;
 	struct iocb **iocbs;
 	struct io_u **io_us;
-	int ret;
+	struct timeval tv;
+	int ret, wait_start = 0;
 
-	if (!ld->iocbs_nr)
+	if (!ld->queued)
 		return 0;
 
-	io_us = ld->io_us;
-	iocbs = ld->iocbs;
 	do {
-		ret = io_submit(ld->aio_ctx, ld->iocbs_nr, iocbs);
+		long nr = ld->queued;
+
+		nr = min((unsigned int) nr, ld->entries - ld->tail);
+		io_us = ld->io_us + ld->tail;
+		iocbs = ld->iocbs + ld->tail;
+
+		ret = io_submit(ld->aio_ctx, nr, iocbs);
 		if (ret > 0) {
 			fio_libaio_queued(td, io_us, ret);
 			io_u_mark_submit(td, ret);
-			ld->iocbs_nr -= ret;
-			io_us += ret;
-			iocbs += ret;
+
+			ld->queued -= ret;
+			ring_inc(ld, &ld->tail, ret);
 			ret = 0;
-		} else if (!ret || ret == -EAGAIN || ret == -EINTR) {
+		} else if (ret == -EINTR || !ret) {
 			if (!ret)
 				io_u_mark_submit(td, ret);
 			continue;
+		} else if (ret == -EAGAIN) {
+			/*
+			 * If we get EAGAIN, we should break out without
+			 * error and let the upper layer reap some
+			 * events for us. If we have no queued IO, we
+			 * must loop here. If we loop for more than 30s,
+			 * just error out, something must be buggy in the
+			 * IO path.
+			 */
+			if (ld->queued) {
+				ret = 0;
+				break;
+			}
+			if (!wait_start) {
+				fio_gettime(&tv, NULL);
+				wait_start = 0;
+			} else if (mtime_since_now(&tv) > 30000) {
+				log_err("fio: aio appears to be stalled, giving up\n");
+				break;
+			}
+			usleep(1);
+			continue;
 		} else
 			break;
-	} while (ld->iocbs_nr);
+	} while (ld->head != ld->tail);
 
 	return ret;
 }
@@ -254,11 +310,11 @@ static void fio_libaio_cleanup(struct thread_data *td)
 
 static int fio_libaio_init(struct thread_data *td)
 {
-	struct libaio_data *ld = malloc(sizeof(*ld));
 	struct libaio_options *o = td->eo;
+	struct libaio_data *ld;
 	int err = 0;
 
-	memset(ld, 0, sizeof(*ld));
+	ld = calloc(1, sizeof(*ld));
 
 	/*
 	 * First try passing in 0 for queue depth, since we don't
@@ -276,13 +332,11 @@ static int fio_libaio_init(struct thread_data *td)
 		return 1;
 	}
 
-	ld->aio_events = malloc(td->o.iodepth * sizeof(struct io_event));
-	memset(ld->aio_events, 0, td->o.iodepth * sizeof(struct io_event));
-	ld->iocbs = malloc(td->o.iodepth * sizeof(struct iocb *));
-	memset(ld->iocbs, 0, sizeof(struct iocb *));
-	ld->io_us = malloc(td->o.iodepth * sizeof(struct io_u *));
-	memset(ld->io_us, 0, td->o.iodepth * sizeof(struct io_u *));
-	ld->iocbs_nr = 0;
+	ld->entries = td->o.iodepth;
+	ld->is_pow2 = is_power_of_2(ld->entries);
+	ld->aio_events = calloc(ld->entries, sizeof(struct io_event));
+	ld->iocbs = calloc(ld->entries, sizeof(struct iocb *));
+	ld->io_us = calloc(ld->entries, sizeof(struct io_u *));
 
 	td->io_ops->data = ld;
 	return 0;
diff --git a/engines/null.c b/engines/null.c
index e7df6a1..6000930 100644
--- a/engines/null.c
+++ b/engines/null.c
@@ -32,7 +32,7 @@ static struct io_u *fio_null_event(struct thread_data *td, int event)
 
 static int fio_null_getevents(struct thread_data *td, unsigned int min_events,
 			      unsigned int fio_unused max,
-			      struct timespec fio_unused *t)
+			      const struct timespec fio_unused *t)
 {
 	struct null_data *nd = (struct null_data *) td->io_ops->data;
 	int ret = 0;
diff --git a/engines/posixaio.c b/engines/posixaio.c
index 2df26af..8ab88fb 100644
--- a/engines/posixaio.c
+++ b/engines/posixaio.c
@@ -91,7 +91,7 @@ static int fio_posixaio_prep(struct thread_data fio_unused *td,
 #define SUSPEND_ENTRIES	8
 
 static int fio_posixaio_getevents(struct thread_data *td, unsigned int min,
-				  unsigned int max, struct timespec *t)
+				  unsigned int max, const struct timespec *t)
 {
 	struct posixaio_data *pd = td->io_ops->data;
 	os_aiocb_t *suspend_list[SUSPEND_ENTRIES];
diff --git a/engines/rbd.c b/engines/rbd.c
index 85a705f..6fe87b8 100644
--- a/engines/rbd.c
+++ b/engines/rbd.c
@@ -222,7 +222,7 @@ static struct io_u *fio_rbd_event(struct thread_data *td, int event)
 }
 
 static int fio_rbd_getevents(struct thread_data *td, unsigned int min,
-			     unsigned int max, struct timespec *t)
+			     unsigned int max, const struct timespec *t)
 {
 	struct rbd_data *rbd_data = td->io_ops->data;
 	unsigned int events = 0;
diff --git a/engines/rdma.c b/engines/rdma.c
index af50187..5081202 100644
--- a/engines/rdma.c
+++ b/engines/rdma.c
@@ -524,7 +524,7 @@ static struct io_u *fio_rdmaio_event(struct thread_data *td, int event)
 }
 
 static int fio_rdmaio_getevents(struct thread_data *td, unsigned int min,
-				unsigned int max, struct timespec *t)
+				unsigned int max, const struct timespec *t)
 {
 	struct rdmaio_data *rd = td->io_ops->data;
 	enum ibv_wc_opcode comp_opcode;
diff --git a/engines/sg.c b/engines/sg.c
index 1a027da..6272b79 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -62,7 +62,8 @@ static int pollin_events(struct pollfd *pfds, int fds)
 }
 
 static int fio_sgio_getevents(struct thread_data *td, unsigned int min,
-			      unsigned int max, struct timespec fio_unused *t)
+			      unsigned int max,
+			      const struct timespec fio_unused *t)
 {
 	struct sgio_data *sd = td->io_ops->data;
 	int left = max, ret, r = 0;
diff --git a/engines/skeleton_external.c b/engines/skeleton_external.c
index f9a0e1c..63a6f8d 100644
--- a/engines/skeleton_external.c
+++ b/engines/skeleton_external.c
@@ -38,7 +38,7 @@ static struct io_u *fio_skeleton_event(struct thread_data *td, int event)
  * numbers. Required.
  */
 static int fio_skeleton_getevents(struct thread_data *td, unsigned int min,
-				  unsigned int max, struct timespec *t)
+				  unsigned int max, const struct timespec *t)
 {
 	return 0;
 }
diff --git a/engines/solarisaio.c b/engines/solarisaio.c
index 137dc22..55a0cb9 100644
--- a/engines/solarisaio.c
+++ b/engines/solarisaio.c
@@ -73,7 +73,7 @@ static void wait_for_event(struct timeval *tv)
 }
 
 static int fio_solarisaio_getevents(struct thread_data *td, unsigned int min,
-				    unsigned int max, struct timespec *t)
+				    unsigned int max, const struct timespec *t)
 {
 	struct solarisaio_data *sd = td->io_ops->data;
 	struct timeval tv;
diff --git a/engines/sync.c b/engines/sync.c
index 1329946..41612df 100644
--- a/engines/sync.c
+++ b/engines/sync.c
@@ -138,7 +138,7 @@ static int fio_syncio_queue(struct thread_data *td, struct io_u *io_u)
 
 static int fio_vsyncio_getevents(struct thread_data *td, unsigned int min,
 				 unsigned int max,
-				 struct timespec fio_unused *t)
+				 const struct timespec fio_unused *t)
 {
 	struct syncio_data *sd = td->io_ops->data;
 	int ret;
diff --git a/engines/windowsaio.c b/engines/windowsaio.c
index 16df740..ec8222c 100644
--- a/engines/windowsaio.c
+++ b/engines/windowsaio.c
@@ -37,7 +37,7 @@ struct thread_ctx {
 
 static BOOL timeout_expired(DWORD start_count, DWORD end_count);
 static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
-					unsigned int max, struct timespec *t);
+				unsigned int max, const struct timespec *t);
 static struct io_u *fio_windowsaio_event(struct thread_data *td, int event);
 static int fio_windowsaio_queue(struct thread_data *td,
 				  struct io_u *io_u);
@@ -256,7 +256,8 @@ static struct io_u* fio_windowsaio_event(struct thread_data *td, int event)
 }
 
 static int fio_windowsaio_getevents(struct thread_data *td, unsigned int min,
-					unsigned int max, struct timespec *t)
+				    unsigned int max,
+				    const struct timespec *t)
 {
 	struct windowsaio_data *wd = td->io_ops->data;
 	unsigned int dequeued = 0;
diff --git a/fio.h b/fio.h
index 136b430..f981739 100644
--- a/fio.h
+++ b/fio.h
@@ -406,7 +406,7 @@ extern const char fio_version_string[];
 
 extern struct thread_data *threads;
 
-static inline void fio_ro_check(struct thread_data *td, struct io_u *io_u)
+static inline void fio_ro_check(const struct thread_data *td, struct io_u *io_u)
 {
 	assert(!(io_u->ddir == DDIR_WRITE && !td_write(td)));
 }
diff --git a/fio_time.h b/fio_time.h
index 9f7d209..5fd3847 100644
--- a/fio_time.h
+++ b/fio_time.h
@@ -2,11 +2,11 @@
 #define FIO_TIME_H
 
 struct thread_data;
-extern uint64_t utime_since(struct timeval *, struct timeval *);
-extern uint64_t utime_since_now(struct timeval *);
-extern uint64_t mtime_since(struct timeval *, struct timeval *);
-extern uint64_t mtime_since_now(struct timeval *);
-extern uint64_t time_since_now(struct timeval *);
+extern uint64_t utime_since(const struct timeval *,const  struct timeval *);
+extern uint64_t utime_since_now(const struct timeval *);
+extern uint64_t mtime_since(const struct timeval *, const struct timeval *);
+extern uint64_t mtime_since_now(const struct timeval *);
+extern uint64_t time_since_now(const struct timeval *);
 extern uint64_t mtime_since_genesis(void);
 extern uint64_t utime_since_genesis(void);
 extern void usec_spin(unsigned int);
diff --git a/gettime.c b/gettime.c
index 8a13923..9f83620 100644
--- a/gettime.c
+++ b/gettime.c
@@ -377,7 +377,7 @@ void fio_clock_init(void)
 		log_info("fio: clocksource=cpu may not be reliable\n");
 }
 
-uint64_t utime_since(struct timeval *s, struct timeval *e)
+uint64_t utime_since(const struct timeval *s, const struct timeval *e)
 {
 	long sec, usec;
 	uint64_t ret;
@@ -400,7 +400,7 @@ uint64_t utime_since(struct timeval *s, struct timeval *e)
 	return ret;
 }
 
-uint64_t utime_since_now(struct timeval *s)
+uint64_t utime_since_now(const struct timeval *s)
 {
 	struct timeval t;
 
@@ -408,7 +408,7 @@ uint64_t utime_since_now(struct timeval *s)
 	return utime_since(s, &t);
 }
 
-uint64_t mtime_since(struct timeval *s, struct timeval *e)
+uint64_t mtime_since(const struct timeval *s, const struct timeval *e)
 {
 	long sec, usec, ret;
 
@@ -429,7 +429,7 @@ uint64_t mtime_since(struct timeval *s, struct timeval *e)
 	return ret;
 }
 
-uint64_t mtime_since_now(struct timeval *s)
+uint64_t mtime_since_now(const struct timeval *s)
 {
 	struct timeval t;
 	void *p = __builtin_return_address(0);
@@ -438,7 +438,7 @@ uint64_t mtime_since_now(struct timeval *s)
 	return mtime_since(s, &t);
 }
 
-uint64_t time_since_now(struct timeval *s)
+uint64_t time_since_now(const struct timeval *s)
 {
 	return mtime_since_now(s) / 1000;
 }
diff --git a/io_u.c b/io_u.c
index 9adc31b..612057d 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1301,7 +1301,7 @@ void lat_target_check(struct thread_data *td)
  * If latency target is enabled, we might be ramping up or down and not
  * using the full queue depth available.
  */
-int queue_full(struct thread_data *td)
+int queue_full(const struct thread_data *td)
 {
 	const int qempty = io_u_qempty(&td->io_u_freelist);
 
diff --git a/io_u_queue.h b/io_u_queue.h
index b702b1f..bda40d5 100644
--- a/io_u_queue.h
+++ b/io_u_queue.h
@@ -28,7 +28,7 @@ static inline void io_u_qpush(struct io_u_queue *q, struct io_u *io_u)
 	q->io_us[q->nr++] = io_u;
 }
 
-static inline int io_u_qempty(struct io_u_queue *q)
+static inline int io_u_qempty(const struct io_u_queue *q)
 {
 	return !q->nr;
 }
diff --git a/ioengine.h b/ioengine.h
index 108c97c..dfe84ac 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -137,7 +137,7 @@ struct ioengine_ops {
 	int (*prep)(struct thread_data *, struct io_u *);
 	int (*queue)(struct thread_data *, struct io_u *);
 	int (*commit)(struct thread_data *);
-	int (*getevents)(struct thread_data *, unsigned int, unsigned int, struct timespec *);
+	int (*getevents)(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 	struct io_u *(*event)(struct thread_data *, int);
 	int (*cancel)(struct thread_data *, struct io_u *);
 	void (*cleanup)(struct thread_data *);
@@ -182,7 +182,7 @@ extern int __must_check td_io_init(struct thread_data *);
 extern int __must_check td_io_prep(struct thread_data *, struct io_u *);
 extern int __must_check td_io_queue(struct thread_data *, struct io_u *);
 extern int __must_check td_io_sync(struct thread_data *, struct fio_file *);
-extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, struct timespec *);
+extern int __must_check td_io_getevents(struct thread_data *, unsigned int, unsigned int, const struct timespec *);
 extern int __must_check td_io_commit(struct thread_data *);
 extern int __must_check td_io_open_file(struct thread_data *, struct fio_file *);
 extern int td_io_close_file(struct thread_data *, struct fio_file *);
@@ -215,10 +215,10 @@ extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned
 extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
 void io_u_mark_complete(struct thread_data *, unsigned int);
 void io_u_mark_submit(struct thread_data *, unsigned int);
-int queue_full(struct thread_data *);
+int queue_full(const struct thread_data *);
 
-int do_io_u_sync(struct thread_data *, struct io_u *);
-int do_io_u_trim(struct thread_data *, struct io_u *);
+int do_io_u_sync(const struct thread_data *, struct io_u *);
+int do_io_u_trim(const struct thread_data *, struct io_u *);
 
 #ifdef FIO_INC_DEBUG
 static inline void dprint_io_u(struct io_u *io_u, const char *p)
diff --git a/ioengines.c b/ioengines.c
index 3010f6c..07d1d56 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -220,7 +220,7 @@ int td_io_prep(struct thread_data *td, struct io_u *io_u)
 }
 
 int td_io_getevents(struct thread_data *td, unsigned int min, unsigned int max,
-		    struct timespec *t)
+		    const struct timespec *t)
 {
 	int r = 0;
 
@@ -522,7 +522,8 @@ int td_io_get_file_size(struct thread_data *td, struct fio_file *f)
 	return td->io_ops->get_file_size(td, f);
 }
 
-static int do_sync_file_range(struct thread_data *td, struct fio_file *f)
+static int do_sync_file_range(const struct thread_data *td,
+			      struct fio_file *f)
 {
 	off64_t offset, nbytes;
 
@@ -535,7 +536,7 @@ static int do_sync_file_range(struct thread_data *td, struct fio_file *f)
 	return sync_file_range(f->fd, offset, nbytes, td->o.sync_file_range);
 }
 
-int do_io_u_sync(struct thread_data *td, struct io_u *io_u)
+int do_io_u_sync(const struct thread_data *td, struct io_u *io_u)
 {
 	int ret;
 
@@ -561,7 +562,7 @@ int do_io_u_sync(struct thread_data *td, struct io_u *io_u)
 	return ret;
 }
 
-int do_io_u_trim(struct thread_data *td, struct io_u *io_u)
+int do_io_u_trim(const struct thread_data *td, struct io_u *io_u)
 {
 #ifndef FIO_HAVE_TRIM
 	io_u->error = EINVAL;
diff --git a/iolog.c b/iolog.c
index ef8b841..4a7d939 100644
--- a/iolog.c
+++ b/iolog.c
@@ -28,7 +28,7 @@ void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 	td->total_io_size += ipo->len;
 }
 
-void log_io_u(struct thread_data *td, struct io_u *io_u)
+void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 {
 	if (!td->o.write_iolog_file)
 		return;
@@ -282,7 +282,7 @@ void unlog_io_piece(struct thread_data *td, struct io_u *io_u)
 	td->io_hist_len--;
 }
 
-void trim_io_piece(struct thread_data *td, struct io_u *io_u)
+void trim_io_piece(struct thread_data *td, const struct io_u *io_u)
 {
 	struct io_piece *ipo = io_u->ipo;
 
@@ -539,9 +539,9 @@ int init_iolog(struct thread_data *td)
 void setup_log(struct io_log **log, struct log_params *p,
 	       const char *filename)
 {
-	struct io_log *l = malloc(sizeof(*l));
+	struct io_log *l;
 
-	memset(l, 0, sizeof(*l));
+	l = calloc(1, sizeof(*l));
 	l->nr_samples = 0;
 	l->max_samples = 1024;
 	l->log_type = p->log_type;
diff --git a/iolog.h b/iolog.h
index fcd6794..a1e32ae 100644
--- a/iolog.h
+++ b/iolog.h
@@ -174,12 +174,12 @@ enum file_log_act {
 
 struct io_u;
 extern int __must_check read_iolog_get(struct thread_data *, struct io_u *);
-extern void log_io_u(struct thread_data *, struct io_u *);
+extern void log_io_u(const struct thread_data *, const struct io_u *);
 extern void log_file(struct thread_data *, struct fio_file *, enum file_log_act);
 extern int __must_check init_iolog(struct thread_data *td);
 extern void log_io_piece(struct thread_data *, struct io_u *);
 extern void unlog_io_piece(struct thread_data *, struct io_u *);
-extern void trim_io_piece(struct thread_data *, struct io_u *);
+extern void trim_io_piece(struct thread_data *, const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
diff --git a/json.c b/json.c
index 7480a61..6145ee4 100644
--- a/json.c
+++ b/json.c
@@ -8,18 +8,12 @@
 
 struct json_object *json_create_object(void)
 {
-	struct json_object *obj = malloc(sizeof(struct json_object));
-	if (obj)
-		memset(obj, 0, sizeof(struct json_object));
-	return obj;
+	return calloc(1, sizeof(struct json_object));
 }
 
 struct json_array *json_create_array(void)
 {
-	struct json_array *array = malloc(sizeof(struct json_array));
-	if (array)
-		memset(array, 0, sizeof(struct json_array));
-	return array;
+	return calloc(1, sizeof(struct json_array));
 }
 
 static struct json_pair *json_create_pair(const char *name, struct json_value *value)
