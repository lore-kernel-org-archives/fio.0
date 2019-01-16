Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36506 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390382AbfAPNAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Jan 2019 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gjknd-0000JI-46
        for fio@vger.kernel.org; Wed, 16 Jan 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190116130002.0212E2C0089@kernel.dk>
Date: Wed, 16 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 93d1811ce6a510d36d61381840283d1ae9933b37:

  t/io_uring: pick next file if we're over the limti (2019-01-15 05:57:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2b9415ddc260726c3ea9ae3436826f9181811143:

  engines/io_uring: ensure sqe stores are ordered SQ ring tail update (2019-01-15 22:06:05 -0700)

----------------------------------------------------------------
Jens Axboe (7):
      t/io_uring: print file depths
      t/io_uring: wait if we're at queue limit
      t/io_uring: terminate buf[] file depth string
      t/io_uring: fixes
      x86-64: correct read/write barriers
      t/io_uring: use fio provided memory barriers
      engines/io_uring: ensure sqe stores are ordered SQ ring tail update

 arch/arch-x86_64.h |  4 ++--
 engines/io_uring.c |  2 ++
 t/io_uring.c       | 51 ++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 40 insertions(+), 17 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-x86_64.h b/arch/arch-x86_64.h
index 665c6b04..0cd21b8f 100644
--- a/arch/arch-x86_64.h
+++ b/arch/arch-x86_64.h
@@ -27,8 +27,8 @@ static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
 #define	FIO_HUGE_PAGE		2097152
 
 #define nop		__asm__ __volatile__("rep;nop": : :"memory")
-#define read_barrier()	__asm__ __volatile__("lfence":::"memory")
-#define write_barrier()	__asm__ __volatile__("sfence":::"memory")
+#define read_barrier()	__asm__ __volatile__("":::"memory")
+#define write_barrier()	__asm__ __volatile__("":::"memory")
 
 static inline unsigned long arch_ffz(unsigned long bitmask)
 {
diff --git a/engines/io_uring.c b/engines/io_uring.c
index 56af8d71..8c5d9deb 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -289,6 +289,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (next_tail == *ring->head)
 		return FIO_Q_BUSY;
 
+	/* ensure sqe stores are ordered with tail update */
+	write_barrier();
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
 	*ring->tail = next_tail;
 	write_barrier();
diff --git a/t/io_uring.c b/t/io_uring.c
index b5f1e094..ef5d52d1 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -24,8 +24,6 @@
 #include "../lib/types.h"
 #include "../os/linux/io_uring.h"
 
-#define barrier()	__asm__ __volatile__("": : :"memory")
-
 #define min(a, b)		((a < b) ? (a) : (b))
 
 struct io_sq_ring {
@@ -47,8 +45,8 @@ struct io_cq_ring {
 
 #define DEPTH			128
 
-#define BATCH_SUBMIT		64
-#define BATCH_COMPLETE		64
+#define BATCH_SUBMIT		32
+#define BATCH_COMPLETE		32
 
 #define BS			4096
 
@@ -211,7 +209,7 @@ static int prep_more_ios(struct submitter *s, int max_ios)
 	next_tail = tail = *ring->tail;
 	do {
 		next_tail++;
-		barrier();
+		read_barrier();
 		if (next_tail == *ring->head)
 			break;
 
@@ -224,9 +222,9 @@ static int prep_more_ios(struct submitter *s, int max_ios)
 
 	if (*ring->tail != tail) {
 		/* order tail store with writes to sqes above */
-		barrier();
+		write_barrier();
 		*ring->tail = tail;
-		barrier();
+		write_barrier();
 	}
 	return prepped;
 }
@@ -263,7 +261,7 @@ static int reap_events(struct submitter *s)
 	do {
 		struct file *f;
 
-		barrier();
+		read_barrier();
 		if (head == *ring->tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
@@ -285,7 +283,7 @@ static int reap_events(struct submitter *s)
 
 	s->inflight -= reaped;
 	*ring->head = head;
-	barrier();
+	write_barrier();
 	return reaped;
 }
 
@@ -311,7 +309,7 @@ static void *submitter_fn(void *data)
 submit_more:
 		to_submit = prepped;
 submit:
-		if (to_submit && (s->inflight + to_submit < DEPTH))
+		if (to_submit && (s->inflight + to_submit <= DEPTH))
 			to_wait = 0;
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
@@ -338,9 +336,10 @@ submit:
 		do {
 			int r;
 			r = reap_events(s);
-			if (r == -1)
+			if (r == -1) {
+				s->finish = 1;
 				break;
-			else if (r > 0)
+			} else if (r > 0)
 				this_reap += r;
 		} while (sq_thread_poll && this_reap < to_wait);
 		s->reaps += this_reap;
@@ -406,7 +405,7 @@ static int setup_ring(struct submitter *s)
 
 	memset(&p, 0, sizeof(p));
 
-	if (polled)
+	if (polled && !do_nop)
 		p.flags |= IORING_SETUP_IOPOLL;
 	if (sq_thread_poll) {
 		p.flags |= IORING_SETUP_SQPOLL;
@@ -469,11 +468,30 @@ static int setup_ring(struct submitter *s)
 	return 0;
 }
 
+static void file_depths(char *buf)
+{
+	struct submitter *s = &submitters[0];
+	char *p;
+	int i;
+
+	buf[0] = '\0';
+	p = buf;
+	for (i = 0; i < s->nr_files; i++) {
+		struct file *f = &s->files[i];
+
+		if (i + 1 == s->nr_files)
+			p += sprintf(p, "%d", f->pending_ios);
+		else
+			p += sprintf(p, "%d, ", f->pending_ios);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	struct submitter *s = &submitters[0];
 	unsigned long done, calls, reap, cache_hit, cache_miss;
 	int err, i, flags, fd;
+	char *fdepths;
 	void *ret;
 
 	if (!do_nop && argc < 2) {
@@ -544,6 +562,7 @@ int main(int argc, char *argv[])
 
 	pthread_create(&s->thread, NULL, submitter_fn, s);
 
+	fdepths = malloc(8 * s->nr_files);
 	cache_hit = cache_miss = reap = calls = done = 0;
 	do {
 		unsigned long this_done = 0;
@@ -573,9 +592,10 @@ int main(int argc, char *argv[])
 			ipc = (this_reap - reap) / (this_call - calls);
 		} else
 			rpc = ipc = -1;
-		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (head=%u tail=%u), Cachehit=%0.2f%%\n",
+		file_depths(fdepths);
+		printf("IOPS=%lu, IOS/call=%ld/%ld, inflight=%u (%s), Cachehit=%0.2f%%\n",
 				this_done - done, rpc, ipc, s->inflight,
-				*s->cq_ring.head, *s->cq_ring.tail, hit);
+				fdepths, hit);
 		done = this_done;
 		calls = this_call;
 		reap = this_reap;
@@ -585,5 +605,6 @@ int main(int argc, char *argv[])
 
 	pthread_join(s->thread, &ret);
 	close(s->ring_fd);
+	free(fdepths);
 	return 0;
 }

