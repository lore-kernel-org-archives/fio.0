Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:39492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388748AbeLVTDN (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 22 Dec 2018 14:03:13 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gagst-0005za-CB
        for fio@vger.kernel.org; Sat, 22 Dec 2018 13:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20181222130001.DFADB2C2843@kernel.dk>
Date: Sat, 22 Dec 2018 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit d63a472d4b213533236ae9aab9cf9e0ec2854c31:

  engines/aio-ring: initialization error handling (2018-12-19 12:55:10 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 10c4d1318fff63eef1d22c6be6d816210277ae17:

  t/aio-ring: print head/tail as unsigneds (2018-12-21 15:37:16 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      engines/aioring: update for continually rolling ring
      t/aio-ring: update for continually rolling ring
      engines/aioring: fix harmless typo
      t/aio-ring: print head/tail as unsigneds

 engines/aioring.c | 49 ++++++++++++++++++++++++-------------------------
 t/aio-ring.c      | 34 ++++++++++++++++------------------
 2 files changed, 40 insertions(+), 43 deletions(-)

---

Diff of recent changes:

diff --git a/engines/aioring.c b/engines/aioring.c
index 59551f9c..50826964 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -17,6 +17,7 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 #include "../lib/memalign.h"
+#include "../lib/fls.h"
 
 #ifdef ARCH_HAVE_AIORING
 
@@ -99,12 +100,15 @@ struct aioring_data {
 
 	struct aio_sq_ring *sq_ring;
 	struct iocb *iocbs;
+	unsigned sq_ring_mask;
 
 	struct aio_cq_ring *cq_ring;
 	struct io_event *events;
+	unsigned cq_ring_mask;
 
 	int queued;
 	int cq_ring_off;
+	unsigned iodepth;
 
 	uint64_t cachehit;
 	uint64_t cachemiss;
@@ -223,11 +227,9 @@ static struct io_u *fio_aioring_event(struct thread_data *td, int event)
 	struct aioring_data *ld = td->io_ops_data;
 	struct io_event *ev;
 	struct io_u *io_u;
-	int index;
+	unsigned index;
 
-	index = event + ld->cq_ring_off;
-	if (index >= ld->cq_ring->nr_events)
-		index -= ld->cq_ring->nr_events;
+	index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
 
 	ev = &ld->cq_ring->events[index];
 	io_u = ev->data;
@@ -264,8 +266,6 @@ static int fio_aioring_cqring_reap(struct thread_data *td, unsigned int events,
 			break;
 		reaped++;
 		head++;
-		if (head == ring->nr_events)
-			head = 0;
 	} while (reaped + events < max);
 
 	ring->head = head;
@@ -280,7 +280,8 @@ static int fio_aioring_getevents(struct thread_data *td, unsigned int min,
 	unsigned actual_min = td->o.iodepth_batch_complete_min == 0 ? 0 : min;
 	struct aioring_options *o = td->eo;
 	struct aio_cq_ring *ring = ld->cq_ring;
-	int r, events = 0;
+	unsigned events = 0;
+	int r;
 
 	ld->cq_ring_off = ring->head;
 	do {
@@ -314,7 +315,7 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 
-	if (ld->queued == td->o.iodepth)
+	if (ld->queued == ld->iodepth)
 		return FIO_Q_BUSY;
 
 	if (io_u->ddir == DDIR_TRIM) {
@@ -329,13 +330,11 @@ static enum fio_q_status fio_aioring_queue(struct thread_data *td,
 
 	tail = ring->tail;
 	next_tail = tail + 1;
-	if (next_tail == ring->nr_events)
-		next_tail = 0;
 	read_barrier();
 	if (next_tail == ring->head)
 		return FIO_Q_BUSY;
 
-	ring->array[tail] = io_u->index;
+	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	ring->tail = next_tail;
 	write_barrier();
 
@@ -354,15 +353,13 @@ static void fio_aioring_queued(struct thread_data *td, int start, int nr)
 	fio_gettime(&now, NULL);
 
 	while (nr--) {
-		int index = ld->sq_ring->array[start];
-		struct io_u *io_u = io_u = ld->io_u_index[index];
+		int index = ld->sq_ring->array[start & ld->sq_ring_mask];
+		struct io_u *io_u = ld->io_u_index[index];
 
 		memcpy(&io_u->issue_time, &now, sizeof(now));
 		io_u_queued(td, io_u);
 
 		start++;
-		if (start == ld->sq_ring->nr_events)
-			start = 0;
 	}
 }
 
@@ -386,7 +383,7 @@ static int fio_aioring_commit(struct thread_data *td)
 	}
 
 	do {
-		int start = ld->sq_ring->head;
+		unsigned start = ld->sq_ring->head;
 		long nr = ld->queued;
 
 		ret = io_ring_enter(ld->aio_ctx, nr, 0, IORING_FLAG_SUBMIT |
@@ -432,6 +429,11 @@ static size_t aioring_sq_size(struct thread_data *td)
 	return sizeof(struct aio_sq_ring) + td->o.iodepth * sizeof(u32);
 }
 
+static unsigned roundup_pow2(unsigned depth)
+{
+	return 1UL << __fls(depth - 1);
+}
+
 static void fio_aioring_cleanup(struct thread_data *td)
 {
 	struct aioring_data *ld = td->io_ops_data;
@@ -440,9 +442,6 @@ static void fio_aioring_cleanup(struct thread_data *td)
 		td->ts.cachehit += ld->cachehit;
 		td->ts.cachemiss += ld->cachemiss;
 
-		/* Bump depth to match init depth */
-		td->o.iodepth++;
-
 		/*
 		 * Work-around to avoid huge RCU stalls at exit time. If we
 		 * don't do this here, then it'll be torn down by exit_aio().
@@ -516,9 +515,6 @@ static int fio_aioring_post_init(struct thread_data *td)
 
 	err = fio_aioring_queue_init(td);
 
-	/* Adjust depth back again */
-	td->o.iodepth--;
-
 	if (err) {
 		td_verror(td, errno, "io_queue_init");
 		return 1;
@@ -531,11 +527,12 @@ static int fio_aioring_init(struct thread_data *td)
 {
 	struct aioring_data *ld;
 
-	/* ring needs an extra entry, add one to achieve QD set */
-	td->o.iodepth++;
-
 	ld = calloc(1, sizeof(*ld));
 
+	/* ring depth must be a power-of-2 */
+	ld->iodepth = td->o.iodepth;
+	td->o.iodepth = roundup_pow2(td->o.iodepth);
+
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
 	ld->io_us = calloc(td->o.iodepth, sizeof(struct io_u *));
@@ -547,10 +544,12 @@ static int fio_aioring_init(struct thread_data *td)
 	memset(ld->sq_ring, 0, aioring_sq_size(td));
 	ld->sq_ring->nr_events = td->o.iodepth;
 	ld->sq_ring->iocbs = (u64) (uintptr_t) ld->iocbs;
+	ld->sq_ring_mask = td->o.iodepth - 1;
 
 	ld->cq_ring = fio_memalign(page_size, aioring_cq_size(td), false);
 	memset(ld->cq_ring, 0, aioring_cq_size(td));
 	ld->cq_ring->nr_events = td->o.iodepth * 2;
+	ld->cq_ring_mask = (2 * td->o.iodepth) - 1;
 
 	td->io_ops_data = ld;
 	return 0;
diff --git a/t/aio-ring.c b/t/aio-ring.c
index c813c4e7..900f4640 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -70,13 +70,15 @@ struct aio_cq_ring {
 #define IORING_FLAG_GETEVENTS	(1 << 1)
 
 #define DEPTH			32
-#define RING_SIZE		(DEPTH + 1)
 
 #define BATCH_SUBMIT		8
 #define BATCH_COMPLETE		8
 
 #define BS			4096
 
+static unsigned sq_ring_mask = DEPTH - 1;
+static unsigned cq_ring_mask = (2 * DEPTH) - 1;
+
 struct submitter {
 	pthread_t thread;
 	unsigned long max_blocks;
@@ -141,20 +143,18 @@ static void init_io(struct submitter *s, int fd, struct iocb *iocb)
 static int prep_more_ios(struct submitter *s, int fd, int max_ios)
 {
 	struct aio_sq_ring *ring = s->sq_ring;
-	u32 tail, next_tail, prepped = 0;
+	u32 index, tail, next_tail, prepped = 0;
 
 	next_tail = tail = ring->tail;
 	do {
 		next_tail++;
-		if (next_tail == ring->nr_events)
-			next_tail = 0;
-
 		barrier();
 		if (next_tail == ring->head)
 			break;
 
-		init_io(s, fd, &s->iocbs[tail]);
-		s->sq_ring->array[tail] = tail;
+		index = tail & sq_ring_mask;
+		init_io(s, fd, &s->iocbs[index]);
+		s->sq_ring->array[index] = index;
 		prepped++;
 		tail = next_tail;
 	} while (prepped < max_ios);
@@ -201,7 +201,7 @@ static int reap_events(struct submitter *s)
 		barrier();
 		if (head == ring->tail)
 			break;
-		ev = &ring->events[head];
+		ev = &ring->events[head & cq_ring_mask];
 		if (ev->res != BS) {
 			struct iocb *iocb = ev->obj;
 
@@ -215,8 +215,6 @@ static int reap_events(struct submitter *s)
 			s->cachemiss++;
 		reaped++;
 		head++;
-		if (head == ring->nr_events)
-			head = 0;
 	} while (1);
 
 	s->inflight -= reaped;
@@ -361,30 +359,30 @@ int main(int argc, char *argv[])
 
 	arm_sig_int();
 
-	size = sizeof(struct iocb) * RING_SIZE;
+	size = sizeof(struct iocb) * DEPTH;
 	if (posix_memalign(&p, 4096, size))
 		return 1;
 	memset(p, 0, size);
 	s->iocbs = p;
 
-	size = sizeof(struct aio_sq_ring) + RING_SIZE * sizeof(u32);
+	size = sizeof(struct aio_sq_ring) + DEPTH * sizeof(u32);
 	if (posix_memalign(&p, 4096, size))
 		return 1;
 	s->sq_ring = p;
 	memset(p, 0, size);
-	s->sq_ring->nr_events = RING_SIZE;
+	s->sq_ring->nr_events = DEPTH;
 	s->sq_ring->iocbs = (u64) s->iocbs;
 
 	/* CQ ring must be twice as big */
 	size = sizeof(struct aio_cq_ring) +
-			2 * RING_SIZE * sizeof(struct io_event);
+			2 * DEPTH * sizeof(struct io_event);
 	if (posix_memalign(&p, 4096, size))
 		return 1;
 	s->cq_ring = p;
 	memset(p, 0, size);
-	s->cq_ring->nr_events = 2 * RING_SIZE;
+	s->cq_ring->nr_events = 2 * DEPTH;
 
-	for (j = 0; j < RING_SIZE; j++) {
+	for (j = 0; j < DEPTH; j++) {
 		struct iocb *iocb = &s->iocbs[j];
 
 		if (posix_memalign(&iocb->u.c.buf, BS, BS)) {
@@ -406,7 +404,7 @@ int main(int argc, char *argv[])
 		s->sq_ring->sq_thread_cpu = sq_thread_cpu;
 	}
 
-	err = io_setup2(RING_SIZE, flags, s->sq_ring, s->cq_ring, &s->ioc);
+	err = io_setup2(DEPTH, flags, s->sq_ring, s->cq_ring, &s->ioc);
 	if (err) {
 		printf("ctx_init failed: %s, %d\n", strerror(errno), err);
 		return 1;
@@ -445,7 +443,7 @@ int main(int argc, char *argv[])
 			rpc = (this_done - done) / (this_call - calls);
 			ipc = (this_reap - reap) / (this_call - calls);
 		}
-		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%d tail=%d), Cachehit=%0.2f%%\n",
+		printf("IOPS=%lu, IOS/call=%lu/%lu, inflight=%u (head=%u tail=%u), Cachehit=%0.2f%%\n",
 				this_done - done, rpc, ipc, s->inflight,
 				s->cq_ring->head, s->cq_ring->tail, hit);
 		done = this_done;

