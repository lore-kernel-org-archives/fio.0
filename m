Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5543ECAAD3
	for <fio@archiver.kernel.org>; Thu,  1 Sep 2022 12:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiIAMAM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiIAMAJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Sep 2022 08:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1408F58B
        for <fio@vger.kernel.org>; Thu,  1 Sep 2022 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KIKft2yhXfdj1n2wyXo+nfAVEwLf7EXRbkt4/24BIfg=; b=CCImiQsLhYsTw8zeoW+C9FvWvc
        YV60EgHohwqUGa36XyqZq5wgWpQXXuM+8FfhIYfCD5cduvgVbQdWJUw+3MZ8xYqs2U6WYpzaRBYIM
        asYYDgjWM8xenX0JIO5vmioF3zqzD8S3cybuG1GxHKAA4r1gWBMAczTg7SaCEp1Hhg9+HJwBn4Hp7
        iUfhyCXJPEJUjraL6tNy1M5S1ztgoge0ebG1cdl3DRgOKvxOfcWBwnRNxHBALfExYCpi5cGCekuUr
        OPSaNJusBa8CuOQqCYBqO17CFfufHDkAkvWWu3rq3ysAw60nXOVOskP0LEA4mtouhc8WZi7y5A+yw
        VKDtfNyw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTird-0060Mn-LC
        for fio@vger.kernel.org; Thu, 01 Sep 2022 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2D0E21BC0168; Thu,  1 Sep 2022 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20220901120002.2D0E21BC0168@kernel.dk>
Date:   Thu,  1 Sep 2022 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit c9be6f0007ab79e3f83952c650af8e7a0c324953:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-08-30 18:19:30 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2be18f6b266f3fcba89719b354672090f49d53d9:

  t/io_uring: take advantage of new io_uring setup flags (2022-08-31 18:44:52 -0600)

----------------------------------------------------------------
Jens Axboe (4):
      engines/io_uring: set COOP_TASKRUN for ring setup
      engines/io_uring: set single issuer and defer taskrun
      t/io_uring: unify getting of the offset
      t/io_uring: take advantage of new io_uring setup flags

 engines/io_uring.c  | 21 +++++++++++++++
 os/linux/io_uring.h | 12 +++++++++
 t/io_uring.c        | 75 ++++++++++++++++++++++++++++++++---------------------
 3 files changed, 78 insertions(+), 30 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 94376efa..d0fc61dc 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -809,9 +809,30 @@ static int fio_ioring_queue_init(struct thread_data *td)
 	p.flags |= IORING_SETUP_CQSIZE;
 	p.cq_entries = depth;
 
+	/*
+	 * Setup COOP_TASKRUN as we don't need to get IPI interrupted for
+	 * completing IO operations.
+	 */
+	p.flags |= IORING_SETUP_COOP_TASKRUN;
+
+	/*
+	 * io_uring is always a single issuer, and we can defer task_work
+	 * runs until we reap events.
+	 */
+	p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
+
 retry:
 	ret = syscall(__NR_io_uring_setup, depth, &p);
 	if (ret < 0) {
+		if (errno == EINVAL && p.flags & IORING_SETUP_DEFER_TASKRUN) {
+			p.flags &= ~IORING_SETUP_DEFER_TASKRUN;
+			p.flags &= ~IORING_SETUP_SINGLE_ISSUER;
+			goto retry;
+		}
+		if (errno == EINVAL && p.flags & IORING_SETUP_COOP_TASKRUN) {
+			p.flags &= ~IORING_SETUP_COOP_TASKRUN;
+			goto retry;
+		}
 		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
 			p.flags &= ~IORING_SETUP_CQSIZE;
 			goto retry;
diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 929997f8..6604e736 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -131,6 +131,18 @@ enum {
 #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
 #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
 
+/*
+ * Only one task is allowed to submit requests
+ */
+#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
+
+/*
+ * Defer running task work to get events.
+ * Rather than running bits of task work whenever the task transitions
+ * try to do it just before it is needed.
+ */
+#define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
+
 enum {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/t/io_uring.c b/t/io_uring.c
index e8e41796..5b46015a 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -449,6 +449,8 @@ static int io_uring_register_files(struct submitter *s)
 
 static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 {
+	int ret;
+
 	/*
 	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
 	 * than that.
@@ -456,7 +458,28 @@ static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 	p->flags |= IORING_SETUP_CQSIZE;
 	p->cq_entries = entries;
 
-	return syscall(__NR_io_uring_setup, entries, p);
+	p->flags |= IORING_SETUP_COOP_TASKRUN;
+	p->flags |= IORING_SETUP_SINGLE_ISSUER;
+	p->flags |= IORING_SETUP_DEFER_TASKRUN;
+retry:
+	ret = syscall(__NR_io_uring_setup, entries, p);
+	if (!ret)
+		return 0;
+
+	if (errno == EINVAL && p->flags & IORING_SETUP_COOP_TASKRUN) {
+		p->flags &= ~IORING_SETUP_COOP_TASKRUN;
+		goto retry;
+	}
+	if (errno == EINVAL && p->flags & IORING_SETUP_SINGLE_ISSUER) {
+		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
+		goto retry;
+	}
+	if (errno == EINVAL && p->flags & IORING_SETUP_DEFER_TASKRUN) {
+		p->flags &= ~IORING_SETUP_DEFER_TASKRUN;
+		goto retry;
+	}
+
+	return ret;
 }
 
 static void io_uring_probe(int fd)
@@ -501,12 +524,28 @@ static unsigned file_depth(struct submitter *s)
 	return (depth + s->nr_files - 1) / s->nr_files;
 }
 
+static unsigned long long get_offset(struct submitter *s, struct file *f)
+{
+	unsigned long long offset;
+	long r;
+
+	if (random_io) {
+		r = __rand64(&s->rand_state);
+		offset = (r % (f->max_blocks - 1)) * bs;
+	} else {
+		offset = f->cur_off;
+		f->cur_off += bs;
+		if (f->cur_off + bs > f->max_size)
+			f->cur_off = 0;
+	}
+
+	return offset;
+}
+
 static void init_io(struct submitter *s, unsigned index)
 {
 	struct io_uring_sqe *sqe = &s->sqes[index];
-	unsigned long offset;
 	struct file *f;
-	long r;
 
 	if (do_nop) {
 		sqe->opcode = IORING_OP_NOP;
@@ -526,16 +565,6 @@ static void init_io(struct submitter *s, unsigned index)
 	}
 	f->pending_ios++;
 
-	if (random_io) {
-		r = __rand64(&s->rand_state);
-		offset = (r % (f->max_blocks - 1)) * bs;
-	} else {
-		offset = f->cur_off;
-		f->cur_off += bs;
-		if (f->cur_off + bs > f->max_size)
-			f->cur_off = 0;
-	}
-
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
 		sqe->fd = f->fixed_fd;
@@ -560,7 +589,7 @@ static void init_io(struct submitter *s, unsigned index)
 		sqe->buf_index = 0;
 	}
 	sqe->ioprio = 0;
-	sqe->off = offset;
+	sqe->off = get_offset(s, f);
 	sqe->user_data = (unsigned long) f->fileno;
 	if (stats && stats_running)
 		sqe->user_data |= ((uint64_t)s->clock_index << 32);
@@ -1072,10 +1101,8 @@ static int submitter_init(struct submitter *s)
 static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocbs)
 {
 	uint64_t data;
-	long long offset;
 	struct file *f;
 	unsigned index;
-	long r;
 
 	index = 0;
 	while (index < max_ios) {
@@ -1094,10 +1121,8 @@ static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocb
 		}
 		f->pending_ios++;
 
-		r = lrand48();
-		offset = (r % (f->max_blocks - 1)) * bs;
 		io_prep_pread(iocb, f->real_fd, s->iovecs[index].iov_base,
-				s->iovecs[index].iov_len, offset);
+				s->iovecs[index].iov_len, get_offset(s, f));
 
 		data = f->fileno;
 		if (stats && stats_running)
@@ -1380,7 +1405,6 @@ static void *submitter_sync_fn(void *data)
 	do {
 		uint64_t offset;
 		struct file *f;
-		long r;
 
 		if (s->nr_files == 1) {
 			f = &s->files[0];
@@ -1395,16 +1419,6 @@ static void *submitter_sync_fn(void *data)
 		}
 		f->pending_ios++;
 
-		if (random_io) {
-			r = __rand64(&s->rand_state);
-			offset = (r % (f->max_blocks - 1)) * bs;
-		} else {
-			offset = f->cur_off;
-			f->cur_off += bs;
-			if (f->cur_off + bs > f->max_size)
-				f->cur_off = 0;
-		}
-
 #ifdef ARCH_HAVE_CPU_CLOCK
 		if (stats)
 			s->clock_batch[s->clock_index] = get_cpu_clock();
@@ -1413,6 +1427,7 @@ static void *submitter_sync_fn(void *data)
 		s->inflight++;
 		s->calls++;
 
+		offset = get_offset(s, f);
 		if (polled)
 			ret = preadv2(f->real_fd, &s->iovecs[0], 1, offset, RWF_HIPRI);
 		else
