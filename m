Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E86919D074
	for <fio@vger.kernel.org>; Sun, 14 Jun 2026 12:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781438418; cv=none; b=fQNhB5iKb9FKEsPFAOfyCfa0NFr+wg68fzG+uSFocorZKvYBW3Wfj15Ys2CwZCugm7yH4PFYvMLvIcK8vB5kmRFEymj6zXagbxHrzyO2l1p+eSA3fIBeZIv9UcAYEThShsR7QaRdeSJ2TJYtteRbXyCtNc177mcgL6GeYZzgOE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781438418; c=relaxed/simple;
	bh=4svo7J7XEwiqA2/Phlm0t2gNM0+r4rP0uZYYPeex5y0=;
	h=Subject:From:To:Date:Message-Id; b=oIzrOsHQTH828XK9yXgwCjkfhykcNSKO+DB1KPLj1zbtrBZADgKXU/1WrZVFowCWEqgmFgUYfxsnXjc76mKzRo0UIR8+2ekcMlyXnX9drjnXfGsbD73il7cGIGdWCwNi8SGvLlH7K9Zwn5CjhKhjjY+FGolK8d3JNPhowJ9KM6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=k5K0SfV2; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k5K0SfV2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=t4iwIRuZJv0b9zur4HL16Kp6rJmO9cywrOdM9Or+PZw=; b=k5K0SfV2ABNW1ZWDka6XPEnyhZ
	cef0IvrqqyFrRPwDyhNf/S5GpYEf9SPay2zkAs32Ptq/GaLmvsD8xxIaJBcxTBDqcAR24VBoIYp9J
	i5k4mE0CmOOTO7Zuqk8i2f9l/2KmtqrayPISkpezDJyvjyCCwH0W3y1CKt8RijbihfQDKVUzhTC5I
	wsgCdo3Qu4QoHoYq4XxlKsfIkNw1ODMNRM15EDNnzXsEAORca09Qj7gbRtzMn6zcMvqWQZvfQqQZu
	mjLRBQoawgnkkITgqeoC7w8a7ODmouboSRHoAWzMDm+gAoqlmP+bwRJMtTBbf+0VPDUgczl1emk44
	U/HDL+Zg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYjVV-00000008Ofh-369b
	for fio@vger.kernel.org;
	Sun, 14 Jun 2026 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 672281BC0132; Sun, 14 Jun 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sun, 14 Jun 2026 06:00:01 -0600
Message-Id: <20260614120001.672281BC0132@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit d8380abcb6756d7356961ac496904acc12181bf7:

  Merge branch 'fix/trim-with-do-verify-0' of https://github.com/minwooim/fio (2026-06-10 20:31:50 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 19a6a29c6ba25ceb2caa89f1a601cc3a08ab981a:

  engines/io_uring: code style tweak (2026-06-13 06:32:38 -0600)

----------------------------------------------------------------
Caleb Sander Mateos (3):
      io_uring: consolidate fio_ioring{,_cmd}_queue_init()
      io_uring: consolidate fio_ioring{,_cmd}_post_init()
      io_uring: try to register ring fd

Jens Axboe (2):
      Merge branch 'opt/register-ring-fd' of https://github.com/calebsander/fio
      engines/io_uring: code style tweak

 engines/io_uring.c | 156 ++++++-----------------------------------------------
 1 file changed, 17 insertions(+), 139 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index b7b912b3..0db7abd6 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -141,6 +141,8 @@ struct ioring_mmap {
 
 struct ioring_data {
 	int ring_fd;
+	int enter_ring_fd;
+	unsigned enter_extra_flags;
 
 	struct io_u **io_u_index;
 	char *md_buf;
@@ -578,11 +580,12 @@ static struct fio_option options[] = {
 static int io_uring_enter(struct ioring_data *ld, unsigned int to_submit,
 			 unsigned int min_complete, unsigned int flags)
 {
+	flags |= ld->enter_extra_flags;
 #ifdef FIO_ARCH_HAS_SYSCALL
-	return __do_syscall6(__NR_io_uring_enter, ld->ring_fd, to_submit,
+	return __do_syscall6(__NR_io_uring_enter, ld->enter_ring_fd, to_submit,
 				min_complete, flags, NULL, 0);
 #else
-	return syscall(__NR_io_uring_enter, ld->ring_fd, to_submit,
+	return syscall(__NR_io_uring_enter, ld->enter_ring_fd, to_submit,
 			min_complete, flags, NULL, 0);
 #endif
 }
@@ -1306,6 +1309,7 @@ static int fio_ioring_queue_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
+	struct io_uring_rsrc_update reg_ring_fd = {.offset = -1};
 	int depth = ld->iodepth;
 	struct io_uring_params p;
 	int ret;
@@ -1329,6 +1333,8 @@ static int fio_ioring_queue_init(struct thread_data *td)
 		 */
 		td->o.disable_slat = 1;
 	}
+	if (ld->is_uring_cmd_eng)
+		p.flags |= IORING_SETUP_SQE128 | IORING_SETUP_CQE32;
 
 	/*
 	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
@@ -1370,92 +1376,15 @@ retry:
 
 	if (p.features & IORING_FEAT_NO_IOWAIT)
 		enter_flags |= IORING_ENTER_NO_IOWAIT;
-	ld->ring_fd = ret;
-
-	fio_ioring_probe(td);
-
-	if (o->fixedbufs) {
-		ret = syscall(__NR_io_uring_register, ld->ring_fd,
-				IORING_REGISTER_BUFFERS, ld->iovecs, depth);
-		if (ret < 0)
-			return ret;
-	}
-
-	return fio_ioring_mmap(ld, &p);
-}
-
-static int fio_ioring_cmd_queue_init(struct thread_data *td)
-{
-	struct ioring_data *ld = td->io_ops_data;
-	struct ioring_options *o = td->eo;
-	int depth = ld->iodepth;
-	struct io_uring_params p;
-	int ret;
-
-	memset(&p, 0, sizeof(p));
-
-	if (o->hipri)
-		p.flags |= IORING_SETUP_IOPOLL;
-	if (o->sqpoll_thread) {
-		p.flags |= IORING_SETUP_SQPOLL;
-		if (o->sqpoll_set) {
-			p.flags |= IORING_SETUP_SQ_AFF;
-			p.sq_thread_cpu = o->sqpoll_cpu;
-		}
-
-		/*
-		 * Submission latency for sqpoll_thread is just the time it
-		 * takes to fill in the SQ ring entries, and any syscall if
-		 * IORING_SQ_NEED_WAKEUP is set, we don't need to log that time
-		 * separately.
-		 */
-		td->o.disable_slat = 1;
-	}
-	if (o->cmd_type == FIO_URING_CMD_NVME) {
-		p.flags |= IORING_SETUP_SQE128;
-		p.flags |= IORING_SETUP_CQE32;
-	}
-
-	/*
-	 * Clamp CQ ring size at our SQ ring size, we don't need more entries
-	 * than that.
-	 */
-	p.flags |= IORING_SETUP_CQSIZE;
-	p.cq_entries = depth;
-
-	/*
-	 * Setup COOP_TASKRUN as we don't need to get IPI interrupted for
-	 * completing IO operations.
-	 */
-	p.flags |= IORING_SETUP_COOP_TASKRUN;
-
-	/*
-	 * io_uring is always a single issuer, and we can defer task_work
-	 * runs until we reap events.
-	 */
-	p.flags |= IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN;
-
-retry:
-	ret = syscall(__NR_io_uring_setup, depth, &p);
-	if (ret < 0) {
-		if (errno == EINVAL && p.flags & IORING_SETUP_DEFER_TASKRUN) {
-			p.flags &= ~IORING_SETUP_DEFER_TASKRUN;
-			p.flags &= ~IORING_SETUP_SINGLE_ISSUER;
-			goto retry;
-		}
-		if (errno == EINVAL && p.flags & IORING_SETUP_COOP_TASKRUN) {
-			p.flags &= ~IORING_SETUP_COOP_TASKRUN;
-			goto retry;
-		}
-		if (errno == EINVAL && p.flags & IORING_SETUP_CQSIZE) {
-			p.flags &= ~IORING_SETUP_CQSIZE;
-			goto retry;
-		}
-		return ret;
+	ld->ring_fd = ld->enter_ring_fd = reg_ring_fd.data = ret;
+	ld->enter_extra_flags = 0;
+	ret = syscall(__NR_io_uring_register, ld->ring_fd,
+		      IORING_REGISTER_RING_FDS, &reg_ring_fd, 1);
+	if (ret > 0) {
+		ld->enter_ring_fd = reg_ring_fd.offset;
+		ld->enter_extra_flags = IORING_ENTER_REGISTERED_RING;
 	}
 
-	ld->ring_fd = ret;
-
 	fio_ioring_probe(td);
 
 	if (o->fixedbufs) {
@@ -1533,58 +1462,7 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
-	for (i = 0; i < ld->iodepth; i++) {
-		struct io_uring_sqe *sqe;
-
-		sqe = &ld->sqes[i];
-		memset(sqe, 0, sizeof(*sqe));
-	}
-
-	if (o->registerfiles) {
-		err = fio_ioring_register_files(td);
-		if (err) {
-			td_verror(td, errno, "ioring_register_files");
-			return 1;
-		}
-	}
-
-	return 0;
-}
-
-static int fio_ioring_cmd_post_init(struct thread_data *td)
-{
-	struct ioring_data *ld = td->io_ops_data;
-	struct ioring_options *o = td->eo;
-	struct io_u *io_u;
-	int err, i;
-
-	for (i = 0; i < td->o.iodepth; i++) {
-		struct iovec *iov = &ld->iovecs[i];
-
-		io_u = ld->io_u_index[i];
-		iov->iov_base = io_u->buf;
-		iov->iov_len = td_max_bs(td);
-	}
-
-	err = fio_ioring_cmd_queue_init(td);
-	if (err) {
-		int init_err = errno;
-
-		td_verror(td, init_err, "io_queue_init");
-		return 1;
-	}
-
-	for (i = 0; i < ld->iodepth; i++) {
-		struct io_uring_sqe *sqe;
-
-		if (o->cmd_type == FIO_URING_CMD_NVME) {
-			sqe = &ld->sqes[i << 1];
-			memset(sqe, 0, 2 * sizeof(*sqe));
-		} else {
-			sqe = &ld->sqes[i];
-			memset(sqe, 0, sizeof(*sqe));
-		}
-	}
+	memset(ld->sqes, 0, ld->iodepth * sizeof(*ld->sqes) << ld->is_uring_cmd_eng);
 
 	if (o->registerfiles) {
 		err = fio_ioring_register_files(td);
@@ -2238,7 +2116,7 @@ static struct ioengine_ops ioengine_uring_cmd = {
 					FIO_MULTI_RANGE_TRIM |
 					FIO_ASYNCIO_SYNC_SYNCFS,
 	.init			= fio_ioring_init,
-	.post_init		= fio_ioring_cmd_post_init,
+	.post_init		= fio_ioring_post_init,
 	.io_u_init		= fio_ioring_io_u_init,
 	.io_u_free		= fio_ioring_io_u_free,
 	.prep			= fio_ioring_cmd_prep,
