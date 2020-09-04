Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgIDMAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Sep 2020 08:00:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B1BC061244
        for <fio@vger.kernel.org>; Fri,  4 Sep 2020 05:00:06 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kEANw-000718-14
        for fio@vger.kernel.org; Fri, 04 Sep 2020 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200904120001.9218C1BC011A@kernel.dk>
Date: Fri,  4 Sep 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 3412afb7b365b97ba515df9c72dfc89bf75aca0a:

  t/zbd: Remove unnecessary option for zbc_reset_zone (2020-09-01 08:37:45 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2dd96cc46fa83a73acc1c9238c3ac59203e10213:

  engines/io_uring: use the atomic load acquire instead of a barrier (2020-09-03 08:49:51 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      engines/io_uring: move sqe clear out of hot path
      t/io_uring: allow setting fixed files/buffers as arguments
      engines/io_uring: use the atomic load acquire instead of a barrier

 engines/io_uring.c | 20 +++++++++++++++-----
 t/io_uring.c       | 10 ++++++++--
 2 files changed, 23 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index ec8cb18a..ca5b90c9 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -218,9 +218,6 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 
 	sqe = &ld->sqes[io_u->index];
 
-	/* zero out fields not used in this submission */
-	memset(sqe, 0, sizeof(*sqe));
-
 	if (o->registerfiles) {
 		sqe->fd = f->engine_pos;
 		sqe->flags = IOSQE_FIXED_FILE;
@@ -262,13 +259,18 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
 		if (ld->ioprio_set)
 			sqe->ioprio |= td->o.ioprio;
 		sqe->off = io_u->offset;
+		sqe->rw_flags = 0;
 	} else if (ddir_sync(io_u->ddir)) {
+		sqe->ioprio = 0;
 		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
 			sqe->off = f->first_write;
 			sqe->len = f->last_write - f->first_write;
 			sqe->sync_range_flags = td->o.sync_file_range;
 			sqe->opcode = IORING_OP_SYNC_FILE_RANGE;
 		} else {
+			sqe->off = 0;
+			sqe->addr = 0;
+			sqe->len = 0;
 			if (io_u->ddir == DDIR_DATASYNC)
 				sqe->fsync_flags |= IORING_FSYNC_DATASYNC;
 			sqe->opcode = IORING_OP_FSYNC;
@@ -444,9 +446,10 @@ static int fio_ioring_commit(struct thread_data *td)
 	 */
 	if (o->sqpoll_thread) {
 		struct io_sq_ring *ring = &ld->sq_ring;
+		unsigned flags;
 
-		read_barrier();
-		if (*ring->flags & IORING_SQ_NEED_WAKEUP)
+		flags = atomic_load_acquire(ring->flags);
+		if (flags & IORING_SQ_NEED_WAKEUP)
 			io_uring_enter(ld, ld->queued, 0,
 					IORING_ENTER_SQ_WAKEUP);
 		ld->queued = 0;
@@ -681,6 +684,13 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
+	for (i = 0; i < td->o.iodepth; i++) {
+		struct io_uring_sqe *sqe;
+
+		sqe = &ld->sqes[i];
+		memset(sqe, 0, sizeof(*sqe));
+	}
+
 	if (o->registerfiles) {
 		err = fio_ioring_register_files(td);
 		if (err) {
diff --git a/t/io_uring.c b/t/io_uring.c
index 8d258136..044f9195 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -535,7 +535,7 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:h?")) != -1) {
 		switch (opt) {
 		case 'd':
 			depth = atoi(optarg);
@@ -552,6 +552,12 @@ int main(int argc, char *argv[])
 		case 'p':
 			polled = !!atoi(optarg);
 			break;
+		case 'B':
+			fixedbufs = !!atoi(optarg);
+			break;
+		case 'F':
+			register_files = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -628,7 +634,7 @@ int main(int argc, char *argv[])
 		printf("ring setup failed: %s, %d\n", strerror(errno), err);
 		return 1;
 	}
-	printf("polled=%d, fixedbufs=%d, buffered=%d", polled, fixedbufs, buffered);
+	printf("polled=%d, fixedbufs=%d, register_files=%d, buffered=%d", polled, fixedbufs, register_files, buffered);
 	printf(" QD=%d, sq_ring=%d, cq_ring=%d\n", depth, *s->sq_ring.ring_entries, *s->cq_ring.ring_entries);
 
 	pthread_create(&s->thread, NULL, submitter_fn, s);

