Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34C21DB37C
	for <fio@vger.kernel.org>; Wed,  6 Nov 2024 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898011; cv=none; b=jQNxqDW2XyuEBBnMeEyy0daJmMCNVuOwFb3f59rLk/XetYWC60afVAzH8cweUWQNhISmonRD0TDSP4wWCettVRb+BQK2Nh7NGdmQZBbCPr223+2kVQKl4WsCFqFu4bPck+dB1l8QRkDsll1zg9Xba9FcjnFBQBSZZvJ6rVoRYAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898011; c=relaxed/simple;
	bh=rh0Q2gp1CwOZtgxgj83sLuhopt0uLho1AMz91P7i85U=;
	h=Subject:From:To:Message-Id:Date; b=HGgt2qxAJuaqwCopnT98ERYIAb5lQRbp24n36qpD0oTtvYdJi/Gzc5bsY3o0r/QoEfcugGXYNG5WmQdkkFSnjNUF2b7r6Qy8Fru70B/sWerY3fTW3A33QTZjpaNe+nuBN6JZABSVoQYWjor83RNkmfEP0DxLrgqkTcrCcQx5/mE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HN5hwKfN; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HN5hwKfN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=zYcMLkvdO1ycq5VjAn3dd8awpp2W+l3CUXLDstP5ihQ=; b=HN5hwKfN+i2i4aJ0Sw7Of8XOxZ
	N3eRL9s3l/1ZBlov433NFSJ80XM4sacxH7ZZl6R4Ifggm9lIeOYhHLaXKHFkGe4V/C6BSZ1Y21K1J
	J8j1Q3BO9vrlRDChPTUwh1wUns7K6CabA+KA/uiPMxvHvir/oC87qGmxrZru8wevh5wc0bO/Q+LNc
	UcQGusSol13iGw2Qbn7wYsmQpyjHWXJczqBcLp/fE/vEEKaoeTZ1JW1g3Lv5lWZSiO6Ws+rMXUHT9
	RoFVneAUuyUhdk9C7Emgc3ciK6Yvog71scP12VM0kS4aB9bZ/+656YjNK3oETYfD7LF4x+9+W6H5u
	ovxAInbA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t8fdj-00000004aXG-1P72
	for fio@vger.kernel.org;
	Wed, 06 Nov 2024 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D31D61BC0153; Wed,  6 Nov 2024 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20241106130001.D31D61BC0153@kernel.dk>
Date: Wed,  6 Nov 2024 06:00:01 -0700 (MST)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 6a193ce90a4d8958d5000809dd8e3286e8215d0f:

  t/io_uring: add symbolic defines for NOP flags (2024-11-04 10:27:06 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to f2415d711a11fec6d5e4081a7bdc060b98c76043:

  t/io_uring: fix size confusion in allocate_mem() (2024-11-05 07:57:41 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      engines/io_uring: don't mess with non power-of-2 queue depth
      Merge branch 'io_uring-depth'
      t/io_uring: fix size confusion in allocate_mem()

 engines/io_uring.c | 23 ++++++++++++++---------
 t/io_uring.c       |  2 +-
 2 files changed, 15 insertions(+), 10 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 60b4f653..79eacbc4 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -770,7 +770,8 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 
 	fio_ro_check(td, io_u);
 
-	if (ld->queued == ld->iodepth)
+	/* should not hit... */
+	if (ld->queued == td->o.iodepth)
 		return FIO_Q_BUSY;
 
 	/* if async trim has been tried and failed, punt to sync */
@@ -1006,7 +1007,7 @@ static int fio_ioring_queue_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
-	int depth = td->o.iodepth;
+	int depth = ld->iodepth;
 	struct io_uring_params p;
 	int ret;
 
@@ -1086,7 +1087,7 @@ static int fio_ioring_cmd_queue_init(struct thread_data *td)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
-	int depth = td->o.iodepth;
+	int depth = ld->iodepth;
 	struct io_uring_params p;
 	int ret;
 
@@ -1231,7 +1232,7 @@ static int fio_ioring_post_init(struct thread_data *td)
 		return 1;
 	}
 
-	for (i = 0; i < td->o.iodepth; i++) {
+	for (i = 0; i < ld->iodepth; i++) {
 		struct io_uring_sqe *sqe;
 
 		sqe = &ld->sqes[i];
@@ -1272,7 +1273,7 @@ static int fio_ioring_cmd_post_init(struct thread_data *td)
 		return 1;
 	}
 
-	for (i = 0; i < td->o.iodepth; i++) {
+	for (i = 0; i < ld->iodepth; i++) {
 		struct io_uring_sqe *sqe;
 
 		if (o->cmd_type == FIO_URING_CMD_NVME) {
@@ -1330,9 +1331,13 @@ static int fio_ioring_init(struct thread_data *td)
 
 	ld = calloc(1, sizeof(*ld));
 
-	/* ring depth must be a power-of-2 */
-	ld->iodepth = td->o.iodepth;
-	td->o.iodepth = roundup_pow2(td->o.iodepth);
+	/*
+	 * The internal io_uring queue depth must be a power-of-2, as that's
+	 * how the ring interface works. So round that up, in case the user
+	 * set iodepth isn't a power-of-2. Leave the fio depth the same, as
+	 * not to be driving too much of an iodepth, if we did round up.
+	 */
+	ld->iodepth = roundup_pow2(td->o.iodepth);
 
 	/* io_u index */
 	ld->io_u_index = calloc(td->o.iodepth, sizeof(struct io_u *));
@@ -1362,7 +1367,7 @@ static int fio_ioring_init(struct thread_data *td)
 	}
 	parse_prchk_flags(o);
 
-	ld->iovecs = calloc(td->o.iodepth, sizeof(struct iovec));
+	ld->iovecs = calloc(ld->iodepth, sizeof(struct iovec));
 
 	td->io_ops_data = ld;
 
diff --git a/t/io_uring.c b/t/io_uring.c
index dec9552b..eea5fe0a 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1006,7 +1006,7 @@ static void *allocate_mem(struct submitter *s, int size)
 		return numa_alloc_onnode(size, s->numa_node);
 #endif
 
-	if (posix_memalign(&buf, t_io_uring_page_size, bs)) {
+	if (posix_memalign(&buf, t_io_uring_page_size, size)) {
 		printf("failed alloc\n");
 		return NULL;
 	}
