Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E391D5AD8
	for <fio@vger.kernel.org>; Tue,  5 Nov 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730811608; cv=none; b=rpiC78tlXVkJFSuy6p8eRxrEe5x5ohtcBjupHTnSOI29aNfst3grRAC+uqvZulSq+qYGHXFH5X0BwQmEXHrcV1+j6I6uCuVtbdzVkVECpgw1EwVN0t9eRoNDivvLErru/NH0Q3xOF6CpqI5WoN7pDOkDuloCqG1EGawNbCfKdTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730811608; c=relaxed/simple;
	bh=qn3qX8/RIx7Zd6ZdXqWCO3VS+N+Kx0gr1xWOZDZabDk=;
	h=Subject:From:To:Message-Id:Date; b=mgIFdyOi1XlQkE/irHcTnkmPeEGP0wdhwWLJop6nI8WcjLQ5u9ICgQA2U+3bHychs6IYPORFd+WFsz2n1qpsEFzCrdVoF9b0T9PpbbYWMQvhjDmFlZYWPU87Mrct26Ig2GRV2/lvzClfISeTjdAgHNajKHhXJWw1sfqXq9RUGog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qEIXSI3J; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qEIXSI3J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=I/OmdnWUZCZt1l417S5VO27PriUGJ7zUn2/N4V6NadM=; b=qEIXSI3JGxWVR2IqErrqxZsMWX
	rlpm+EaRXjQ0aCa77qdmZpIqvB6qEoeppB7PGHFHpHJoN4MQ1ifH3i4JuDoDUR3qpGtiJ5MNjEN0Z
	rW2WUx0BowkSRzlp09m+PkqWOHXZdw38l+gC06MJdVBaA7aMTKs0yXeSTZc1BaNWixGOfzuQAGlyz
	NYHDWQYCUJ9Els3ez/QoqCXFbH1LYRKkmYdI3VNjpWIWHLRoWB77EJbmvfdv3PCOcV+gPGW/YhYJa
	3MAwAxTkHw7GnsrSp1qEoJowD7vh03+y6pmcYdjemV2lJjQEHYYu8T9kjFtZpjI1lUEXIGN/6u4uf
	I83w+/hg==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t8JAB-00000002t5n-3wXG
	for fio@vger.kernel.org;
	Tue, 05 Nov 2024 13:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4E2ED1BC015D; Tue,  5 Nov 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241105130001.4E2ED1BC015D@kernel.dk>
Date: Tue,  5 Nov 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit a191635ad42893a60d0a917b27e97e3fc73f7fee:

  engines/io_uring_cmd: do not send data buffer for write zeroes (2024-10-28 12:25:15 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6a193ce90a4d8958d5000809dd8e3286e8215d0f:

  t/io_uring: add symbolic defines for NOP flags (2024-11-04 10:27:06 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      t/io_uring: register single buffer for whole IO region
      t/io_uring: enable registered file/buffer testing with NOP
      t/io_uring: add symbolic defines for NOP flags

 os/linux/io_uring.h |  5 +++++
 t/io_uring.c        | 58 +++++++++++++++++++++++++++++++++--------------------
 2 files changed, 41 insertions(+), 22 deletions(-)

---

Diff of recent changes:

diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 1040f690..b3876381 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -245,6 +245,11 @@ enum {
 #define IORING_POLL_UPDATE_EVENTS	(1U << 1)
 #define IORING_POLL_UPDATE_USER_DATA	(1U << 2)
 
+#define IORING_NOP_INJECT_RESULT	(1U << 0)
+#define IORING_NOP_FILE			(1U << 1)
+#define IORING_NOP_FIXED_FILE		(1U << 2)
+#define IORING_NOP_FIXED_BUFFER		(1U << 3)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
diff --git a/t/io_uring.c b/t/io_uring.c
index 0fa01837..dec9552b 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -137,6 +137,7 @@ static int buffered = 0;	/* use buffered IO, not O_DIRECT */
 static int sq_thread_poll = 0;	/* use kernel submission/poller thread */
 static int sq_thread_cpu = -1;	/* pin above thread to this CPU */
 static int do_nop = 0;		/* no-op SQ ring commands */
+static int use_files = 1;
 static int nthreads = 1;
 static int stats = 0;		/* generate IO stats */
 static int aio = 0;		/* use libaio */
@@ -398,20 +399,23 @@ static void add_stat(struct submitter *s, int clock_index, int nr)
 
 static int io_uring_register_buffers(struct submitter *s)
 {
-	if (do_nop)
-		return 0;
+	int ret;
 
-	return syscall(__NR_io_uring_register, s->ring_fd,
-			IORING_REGISTER_BUFFERS, s->iovecs, roundup_pow2(depth));
+	/*
+	 * All iovecs are filled in case of readv, but it's all contig
+	 * from vec0. Just register a single buffer for all buffers.
+	 */
+	s->iovecs[0].iov_len = bs * roundup_pow2(depth);
+	ret = syscall(__NR_io_uring_register, s->ring_fd,
+			IORING_REGISTER_BUFFERS, s->iovecs, 1);
+	s->iovecs[0].iov_len = bs;
+	return ret;
 }
 
 static int io_uring_register_files(struct submitter *s)
 {
 	int i;
 
-	if (do_nop)
-		return 0;
-
 	s->fds = calloc(s->nr_files, sizeof(__s32));
 	for (i = 0; i < s->nr_files; i++) {
 		s->fds[i] = s->files[i].real_fd;
@@ -539,13 +543,24 @@ static void init_io(struct submitter *s, unsigned index)
 	struct io_uring_sqe *sqe = &s->sqes[index];
 	struct file *f;
 
+	f = get_next_file(s);
+
 	if (do_nop) {
+		sqe->rw_flags = IORING_NOP_FILE;
+		if (register_files) {
+			sqe->fd = f->fixed_fd;
+			sqe->rw_flags |= IORING_NOP_FIXED_FILE;
+		} else {
+			sqe->fd = f->real_fd;
+		}
+		if (fixedbufs)
+			sqe->rw_flags |= IORING_NOP_FIXED_BUFFER;
+		sqe->rw_flags |= IORING_NOP_INJECT_RESULT;
+		sqe->len = bs;
 		sqe->opcode = IORING_OP_NOP;
 		return;
 	}
 
-	f = get_next_file(s);
-
 	if (register_files) {
 		sqe->flags = IOSQE_FIXED_FILE;
 		sqe->fd = f->fixed_fd;
@@ -557,7 +572,7 @@ static void init_io(struct submitter *s, unsigned index)
 		sqe->opcode = IORING_OP_READ_FIXED;
 		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
 		sqe->len = bs;
-		sqe->buf_index = index;
+		sqe->buf_index = 0;
 	} else if (!vectored) {
 		sqe->opcode = IORING_OP_READ;
 		sqe->addr = (unsigned long) s->iovecs[index].iov_base;
@@ -710,7 +725,7 @@ static int reap_events_uring(struct submitter *s)
 		if (head == tail)
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
-		if (!do_nop) {
+		if (use_files) {
 			int fileno = cqe->user_data & 0xffffffff;
 
 			f = &s->files[fileno];
@@ -1003,10 +1018,12 @@ static int submitter_init(struct submitter *s)
 {
 	int i, nr_batch, err;
 	static int init_printed;
+	void *mem, *ptr;
 	char buf[80];
+
 	s->tid = gettid();
-	printf("submitter=%d, tid=%d, file=%s, nfiles=%d, node=%d\n", s->index, s->tid,
-							s->filename, s->nr_files, s->numa_node);
+	printf("submitter=%d, tid=%d, file=%s, nfiles=%d, node=%d\n", s->index,
+				s->tid, s->filename, s->nr_files, s->numa_node);
 
 	set_affinity(s);
 
@@ -1016,14 +1033,11 @@ static int submitter_init(struct submitter *s)
 	for (i = 0; i < MAX_FDS; i++)
 		s->files[i].fileno = i;
 
-	for (i = 0; i < roundup_pow2(depth); i++) {
-		void *buf;
-
-		buf = allocate_mem(s, bs);
-		if (!buf)
-			return -1;
-		s->iovecs[i].iov_base = buf;
+	mem = allocate_mem(s, bs * roundup_pow2(depth));
+	for (i = 0, ptr = mem; i < roundup_pow2(depth); i++) {
+		s->iovecs[i].iov_base = ptr;
 		s->iovecs[i].iov_len = bs;
+		ptr += bs;
 	}
 
 	if (use_sync) {
@@ -1683,7 +1697,7 @@ int main(int argc, char *argv[])
 	j = 0;
 	i = optind;
 	nfiles = argc - i;
-	if (!do_nop) {
+	if (use_files) {
 		if (!nfiles) {
 			printf("No files specified\n");
 			usage(argv[0], 1);
@@ -1696,7 +1710,7 @@ int main(int argc, char *argv[])
 			threads_rem = nthreads - threads_per_f * nfiles;
 		}
 	}
-	while (!do_nop && i < argc) {
+	while (use_files && i < argc) {
 		int k, limit;
 
 		memset(&f, 0, sizeof(f));
