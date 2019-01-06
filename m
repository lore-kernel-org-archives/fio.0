Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34596 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfAFNAQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 6 Jan 2019 08:00:16 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gg82J-0004pu-TQ
        for fio@vger.kernel.org; Sun, 06 Jan 2019 13:00:15 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190106130001.589052C0118@kernel.dk>
Date: Sun,  6 Jan 2019 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ac122fea7540ca115c157e0a835a74b891f10484:

  aioring: update to newer API (2019-01-04 22:22:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f310970e737975088e41ea14c399450ba8ae3a49:

  t/aio-ring: cleanup the code a bit (2019-01-05 07:42:30 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      aioring: make sq/cqring_offsets a bit more future proof
      t/aio-ring: cleanup the code a bit

 engines/aioring.c |  3 +++
 t/aio-ring.c      | 43 +++++++++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 18 deletions(-)

---

Diff of recent changes:

diff --git a/engines/aioring.c b/engines/aioring.c
index ca60b281..8cecb6ad 100644
--- a/engines/aioring.c
+++ b/engines/aioring.c
@@ -68,7 +68,9 @@ struct aio_sqring_offsets {
 	u32 ring_mask;
 	u32 ring_entries;
 	u32 flags;
+	u32 dropped;
 	u32 array;
+	u32 resv[3];
 };
 
 struct aio_cqring_offsets {
@@ -78,6 +80,7 @@ struct aio_cqring_offsets {
 	u32 ring_entries;
 	u32 overflow;
 	u32 events;
+	u32 resv[4];
 };
 
 struct aio_uring_params {
diff --git a/t/aio-ring.c b/t/aio-ring.c
index 71978c68..1a4fe44b 100644
--- a/t/aio-ring.c
+++ b/t/aio-ring.c
@@ -52,7 +52,9 @@ struct aio_sqring_offsets {
 	u32 ring_mask;
 	u32 ring_entries;
 	u32 flags;
+	u32 dropped;
 	u32 array;
+	u32 resv[3];
 };
 
 struct aio_cqring_offsets {
@@ -62,6 +64,7 @@ struct aio_cqring_offsets {
 	u32 ring_entries;
 	u32 overflow;
 	u32 events;
+	u32 resv[4];
 };
 
 struct aio_uring_params {
@@ -104,7 +107,7 @@ static unsigned sq_ring_mask, cq_ring_mask;
 struct submitter {
 	pthread_t thread;
 	unsigned long max_blocks;
-	int fd;
+	int ring_fd;
 	struct drand48_data rand;
 	struct aio_sq_ring sq_ring;
 	struct iocb *iocbs;
@@ -137,8 +140,8 @@ static int io_uring_setup(unsigned entries, struct iovec *iovecs,
 static int io_uring_enter(struct submitter *s, unsigned int to_submit,
 			  unsigned int min_complete, unsigned int flags)
 {
-	return syscall(__NR_sys_io_uring_enter, s->fd, to_submit, min_complete,
-			flags);
+	return syscall(__NR_sys_io_uring_enter, s->ring_fd, to_submit,
+			min_complete, flags);
 }
 
 static int gettid(void)
@@ -228,7 +231,9 @@ static int reap_events(struct submitter *s)
 			struct iocb *iocb = ev->obj;
 
 			printf("io: unexpected ret=%ld\n", ev->res);
-			printf("offset=%lu, size=%lu\n", (unsigned long) iocb->u.c.offset, (unsigned long) iocb->u.c.nbytes);
+			printf("offset=%lu, size=%lu\n",
+					(unsigned long) iocb->u.c.offset,
+					(unsigned long) iocb->u.c.nbytes);
 			return -1;
 		}
 		if (ev->res2 & IOEV_RES2_CACHEHIT)
@@ -265,21 +270,22 @@ static void *submitter_fn(void *data)
 		printf("failed getting size of device/file\n");
 		goto err;
 	}
-	if (!s->max_blocks) {
+	if (s->max_blocks <= 1) {
 		printf("Zero file/device size?\n");
 		goto err;
 	}
-
 	s->max_blocks--;
 
 	srand48_r(pthread_self(), &s->rand);
 
 	prepped = 0;
 	do {
-		int to_wait, to_submit, this_reap;
+		int to_wait, to_submit, this_reap, to_prep;
 
-		if (!prepped && s->inflight < DEPTH)
-			prepped = prep_more_ios(s, fd, min(DEPTH - s->inflight, BATCH_SUBMIT));
+		if (!prepped && s->inflight < DEPTH) {
+			to_prep = min(DEPTH - s->inflight, BATCH_SUBMIT);
+			prepped = prep_more_ios(s, fd, to_prep);
+		}
 		s->inflight += prepped;
 submit_more:
 		to_submit = prepped;
@@ -289,7 +295,8 @@ submit:
 		else
 			to_wait = min(s->inflight + to_submit, BATCH_COMPLETE);
 
-		ret = io_uring_enter(s, to_submit, to_wait, IORING_ENTER_GETEVENTS);
+		ret = io_uring_enter(s, to_submit, to_wait,
+					IORING_ENTER_GETEVENTS);
 		s->calls++;
 
 		this_reap = reap_events(s);
@@ -381,11 +388,10 @@ static int setup_ring(struct submitter *s)
 		return 1;
 	}
 
-	s->fd = fd;
-
+	s->ring_fd = fd;
 	ptr = mmap(0, p.sq_off.array + p.sq_entries * sizeof(u32),
-			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
-			fd, IORING_OFF_SQ_RING);
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_SQ_RING);
 	printf("sq_ring ptr = 0x%p\n", ptr);
 	sring->head = ptr + p.sq_off.head;
 	sring->tail = ptr + p.sq_off.tail;
@@ -394,13 +400,14 @@ static int setup_ring(struct submitter *s)
 	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
-	s->iocbs = mmap(0, p.sq_entries * sizeof(struct iocb), PROT_READ | PROT_WRITE,
-			MAP_SHARED | MAP_POPULATE, fd, IORING_OFF_IOCB);
+	s->iocbs = mmap(0, p.sq_entries * sizeof(struct iocb),
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_IOCB);
 	printf("iocbs ptr   = 0x%p\n", s->iocbs);
 
 	ptr = mmap(0, p.cq_off.events + p.cq_entries * sizeof(struct io_event),
-			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE,
-			fd, IORING_OFF_CQ_RING);
+			PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE, fd,
+			IORING_OFF_CQ_RING);
 	printf("cq_ring ptr = 0x%p\n", ptr);
 	cring->head = ptr + p.cq_off.head;
 	cring->tail = ptr + p.cq_off.tail;

