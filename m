Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A373311966
	for <fio@vger.kernel.org>; Mon, 12 Jan 2026 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768222810; cv=none; b=UBr8gPDOoOyT1QUY4F6Ky/Vkt6NmaAUFY5CfEM/+R3pfVl/iAAjeZqoyCKgQbJXAHcpYl40cuW5TTELzD1BepuTW9OcoBW0I1VC7Zko9nyqN2+CjM49+X+Lny7Z7dF0CJ1xaAZAAWKOr0p9cSRUYoqbvEBt9QOp0zFIiqktqg9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768222810; c=relaxed/simple;
	bh=uJzpyrxORsJeJN+zeIVGoHh3PYoFkeEQh9B4a1RJYNM=;
	h=Subject:From:To:Date:Message-Id; b=t1gKBTz2uF65ix0XDl5d856Y27jNrHbXXiPvXexGBNAcEOXn2wunH1pzbap6jRqfJ3/ut3s9SknP1WNGXrc62GEzEbeYC5OoLng7rhO2Q2vztAO1163EZmOm0mxzRvTr9/rqjWUYcQ8hBa+n2MR3BZum5VshZxWTYZpVoo5G8do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GFhl5VZy; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GFhl5VZy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=o46WJb83LAOMwspeO9A5gmPGJJYCfI6bwuMeA6TN7Wo=; b=GFhl5VZy1FIUdf+GbvzP8SEFLk
	KhFu/OfPdn1PGS0bl9mw3Sb6EHHhFcl1wRuBSW1WCgwdXr79AeIywSVq3QAUEUAn8s15+U4EbN8Fz
	kKlDkpl8CLWVSpqjGK/T6HhzzUeogtiGi7YoZvOBR+laurStGtVPD9sJYlA6f7pqo6/SCcrQzkMmD
	sm0Cw4YSQwVm+WSlgs4gJlt6oXoIeqLkc7szUZqy/eeGJGm4dZMIS7tk/Zs0rvuFgN+vSPbOTrM5D
	6wOxle8iJPags/7hEt5RS38FzIt+IfBxxvAkhxUu5fpjzw7kx7wgbVB8w+QSBi8lsbp5g4LVTOlKJ
	vqeOvCMQ==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfHWg-00000000jHZ-0vkC
	for fio@vger.kernel.org;
	Mon, 12 Jan 2026 13:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 820D61BC0145; Mon, 12 Jan 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Mon, 12 Jan 2026 06:00:01 -0700
Message-Id: <20260112130001.820D61BC0145@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6ff32768ff322a269f87cd515ecfb218400f22bf:

  Add option to specify ramp period by amount of IO (2026-01-07 14:01:53 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to adeceb86edb28070cbae79dd38b5ec7354271063:

  Merge branch 'sync-fileop' of https://github.com/struschev/fio (2026-01-11 13:05:54 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      t/io_uring: enable setting an opcode and register opcode filter
      Merge branch 'patch-1' of https://github.com/CookiePLMonster/fio
      Merge branch 'sync-fileop' of https://github.com/struschev/fio

Sergey Truschev (1):
      fio: add sync capability for file operations

Silent (1):
      windows: fix Y2038 bug caused by 32 bit truncation

 engines/falloc.c         | 20 +++++++++++-------
 engines/fileoperations.c |  2 ++
 engines/ftruncate.c      | 11 +++++-----
 os/windows/posix.c       |  2 +-
 t/io_uring.c             | 54 ++++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 73 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/engines/falloc.c b/engines/falloc.c
index 290b980f..5bd5aa54 100644
--- a/engines/falloc.c
+++ b/engines/falloc.c
@@ -76,14 +76,18 @@ static enum fio_q_status fio_fallocate_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 
-	if (io_u->ddir == DDIR_READ)
-		flags = FALLOC_FL_KEEP_SIZE;
-	else if (io_u->ddir == DDIR_WRITE)
-		flags = 0;
-	else if (io_u->ddir == DDIR_TRIM)
-		flags = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
-
-	ret = fallocate(f->fd, flags, io_u->offset, io_u->xfer_buflen);
+	if (io_u->ddir != DDIR_SYNC) {
+		if (io_u->ddir == DDIR_READ)
+			flags = FALLOC_FL_KEEP_SIZE;
+		else if (io_u->ddir == DDIR_WRITE)
+			flags = 0;
+		else if (io_u->ddir == DDIR_TRIM)
+			flags = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
+
+		ret = fallocate(f->fd, flags, io_u->offset, io_u->xfer_buflen);
+	} else {
+		ret = do_io_u_sync(td, io_u);
+	}
 
 	if (ret)
 		io_u->error = errno;
diff --git a/engines/fileoperations.c b/engines/fileoperations.c
index e5303359..ce3e7c39 100644
--- a/engines/fileoperations.c
+++ b/engines/fileoperations.c
@@ -264,6 +264,8 @@ static int invalidate_do_nothing(struct thread_data *td, struct fio_file *f)
 
 static enum fio_q_status queue_io(struct thread_data *td, struct io_u *io_u)
 {
+	if (io_u->ddir == DDIR_SYNC && do_io_u_sync(td, io_u))
+		io_u->error = errno;
 	return FIO_Q_COMPLETED;
 }
 
diff --git a/engines/ftruncate.c b/engines/ftruncate.c
index d1757b79..70211e07 100644
--- a/engines/ftruncate.c
+++ b/engines/ftruncate.c
@@ -15,16 +15,17 @@ static enum fio_q_status fio_ftruncate_queue(struct thread_data *td,
 					     struct io_u *io_u)
 {
 	struct fio_file *f = io_u->file;
-	int ret;
+	int ret = 0;
 
 	fio_ro_check(td, io_u);
 
-	if (io_u->ddir != DDIR_WRITE) {
+	if (io_u->ddir == DDIR_WRITE)
+		ret = ftruncate(f->fd, io_u->offset);
+	else if (io_u->ddir == DDIR_SYNC)
+		ret = do_io_u_sync(td, io_u);
+	else
 		io_u->error = EINVAL;
-		return FIO_Q_COMPLETED;
-	}
 
-	ret = ftruncate(f->fd, io_u->offset);
 	if (ret)
 		io_u->error = errno;
 
diff --git a/os/windows/posix.c b/os/windows/posix.c
index 4c692a1e..ca3ee389 100644
--- a/os/windows/posix.c
+++ b/os/windows/posix.c
@@ -297,7 +297,7 @@ void Time_tToSystemTime(time_t dosTime, SYSTEMTIME *systemTime)
 	LONGLONG jan1970;
 	SYSTEMTIME tempSystemTime;
 
-	jan1970 = Int32x32To64(dosTime, 10000000) + 116444736000000000;
+	jan1970 = (dosTime * 10000000LL) + 116444736000000000LL;
 	utcFT.dwLowDateTime = (DWORD)jan1970;
 	utcFT.dwHighDateTime = jan1970 >> 32;
 
diff --git a/t/io_uring.c b/t/io_uring.c
index 9da5cc9e..0a04af4e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -148,6 +148,7 @@ static int use_sync = 0;	/* use preadv2 */
 static int numa_placement = 0;	/* set to node of device */
 static int vectored = 0;	/* use vectored IO */
 static int pt = 0;		/* passthrough I/O or not */
+static int restriction = 0;	/* for testing restriction filter */
 
 static unsigned long tsc_rate;
 
@@ -883,6 +884,39 @@ static int setup_aio(struct submitter *s)
 #endif
 }
 
+static int io_uring_register_restrictions(struct submitter *s)
+{
+	struct io_uring_restriction res[8] = { };
+	int ret;
+
+	res[0].opcode = IORING_RESTRICTION_SQE_OP;
+	res[0].sqe_op = IORING_OP_NOP;
+	res[1].opcode = IORING_RESTRICTION_SQE_OP;
+	res[1].sqe_op = IORING_OP_READ;
+	res[2].opcode = IORING_RESTRICTION_SQE_OP;
+	res[2].sqe_op = IORING_OP_READV;
+	res[3].opcode = IORING_RESTRICTION_SQE_OP;
+	res[3].sqe_op = IORING_OP_READ_FIXED;
+
+	res[4].opcode = IORING_RESTRICTION_REGISTER_OP;
+	res[4].sqe_op = IORING_REGISTER_BUFFERS;
+	res[5].opcode = IORING_RESTRICTION_REGISTER_OP;
+	res[5].sqe_op = IORING_REGISTER_ENABLE_RINGS;
+	res[6].opcode = IORING_RESTRICTION_REGISTER_OP;
+	res[6].sqe_op = IORING_REGISTER_RING_FDS;
+	res[7].opcode = IORING_RESTRICTION_REGISTER_OP;
+	res[7].sqe_op = IORING_REGISTER_FILES;
+
+	ret = syscall(__NR_io_uring_register, s->ring_fd,
+			IORING_REGISTER_RESTRICTIONS, res, 8);
+	if (ret) {
+		fprintf(stderr, "IORING_REGISTER_RESTRICTIONS: %d\n", ret);
+		return ret;
+	}
+
+	return syscall(__NR_io_uring_register, s->ring_fd, IORING_REGISTER_ENABLE_RINGS, NULL, 0);
+}
+
 static int setup_ring(struct submitter *s)
 {
 	struct io_sq_ring *sring = &s->sq_ring;
@@ -907,6 +941,8 @@ static int setup_ring(struct submitter *s)
 		p.flags |= IORING_SETUP_SQE128;
 		p.flags |= IORING_SETUP_CQE32;
 	}
+	if (restriction)
+		p.flags |= IORING_SETUP_R_DISABLED;
 
 	fd = io_uring_setup(depth, &p);
 	if (fd < 0) {
@@ -915,6 +951,15 @@ static int setup_ring(struct submitter *s)
 	}
 	s->ring_fd = s->enter_ring_fd = fd;
 
+	if (restriction) {
+		/* enables rings too */
+		ret = io_uring_register_restrictions(s);
+		if (ret) {
+			fprintf(stderr, "Failed to set restrictions\n");
+			return ret;
+		}
+	}
+
 	if (fixedbufs) {
 		struct rlimit rlim;
 
@@ -1510,11 +1555,13 @@ static void usage(char *argv, int status)
 		" -X <bool> : Use registered ring %d\n"
 		" -P <bool> : Automatically place on device home node %d\n"
 		" -V <bool> : Vectored IO, default %d\n"
+		" -e <bool> : Set restriction filter on opcodes %d\n"
 		" -u <bool> : Use nvme-passthrough I/O, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, register_files, nthreads, !buffered, do_nop,
 		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio,
-		use_sync, register_ring, numa_placement, vectored, pt);
+		use_sync, register_ring, numa_placement, vectored, restriction,
+		pt);
 	exit(status);
 }
 
@@ -1573,7 +1620,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:V:u:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "e:d:s:c:b:p:B:F:n:N:O:t:T:a:r:D:R:X:S:P:V:u:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1657,6 +1704,9 @@ int main(int argc, char *argv[])
 		case 'u':
 			pt = !!atoi(optarg);
 			break;
+		case 'e':
+			restriction = !!atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
