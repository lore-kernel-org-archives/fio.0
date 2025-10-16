Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5492330C62B
	for <fio@vger.kernel.org>; Thu, 16 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760616017; cv=none; b=J7YHutsWvEG4I7OU/zy6METGy9cQ8aALX1Yv9mzzn9wHpvf1Z1orwStoyg6EJ9euh1yJLQ8sTuWTN10uTEQbT2Yw20jNwOoLEa7E+u2moDuljO2P6DAb4ZeqN+dVrcAsnv8b7oRJD4IZFuQ1pNhx7ZJrxrv/y91TZFyaA20Ks2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760616017; c=relaxed/simple;
	bh=6xRpVInC047gWLhMSeAFkPq5iEii9Cu8ZJBE1FG1eME=;
	h=Subject:From:To:Date:Message-Id; b=uq0pBh3Ar1YxlVcXq84VIxQD5GyLNkPMkBNWO9luwXmFHlLbPoxAuaxLp+X9546qFB4zd7c0bcpp11tgBmaOGqJ4grhrhDPPe/N7wyPProzugZemcUKCvFwEKMl+jv1XZYo5ijKO1bYuGGda107MIICBD1E4folILOnLm0j35iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c14SsflI; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c14SsflI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=cDfddP2e06MSvWejgKrx014gqv2le3TQeMSpkoTidtU=; b=c14SsflIM6L50kIaSKFJSkM6tK
	S4okwBkOHJkz+DyOG3PSTmMKDZlRk6RRhiAg7Q1yXYwomChCbwW4bFLtgil5gBGsOUuonZFUTTMZP
	mj6J2eNRupe7ZOeoY1xChaG82hqb8kiT8dMILoMXxv03h67xAkYIOKv1UD+B9QVOnLDOe4oThqH57
	zvBu81TDqk20lOPxb10KT/46ffGP9nTAlGmq42ibF1zlXxt0qNW9262YZrO9l7TdCYj5DWe4gOtFF
	VhERAkEteh9E6rbvdXMZE6rQebRL/JX6ujEDKgjYrszVBz4NplRB6AQjjIELIphQDU+ve6PuhdfLN
	pEQ8DX3Q==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9MeK-00000006ipt-3TjV
	for fio@vger.kernel.org;
	Thu, 16 Oct 2025 12:00:06 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id D00331BC0155; Thu, 16 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Thu, 16 Oct 2025 06:00:01 -0600
Message-Id: <20251016120001.D00331BC0155@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit ae3475defe994e855f912d4b8dadf69c479b9ca2:

  memory: fix typo in cuda < 13 cuCtxCreate() (2025-10-10 14:56:44 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7272fd82813a65e3d72ef5c543c7473ec411f4cd:

  t/io_uring: use IORING_SETUP_NO_SQARRAY if available (2025-10-15 08:12:57 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      os/linux: sync io_uring.h header for setup flags
      t/io_uring: use IORING_SETUP_NO_SQARRAY if available

 os/linux/io_uring.h | 26 ++++++++++++++++++++++++++
 t/io_uring.c        | 15 +++++++++++----
 2 files changed, 37 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/os/linux/io_uring.h b/os/linux/io_uring.h
index 7b099902..10cb3c4c 100644
--- a/os/linux/io_uring.h
+++ b/os/linux/io_uring.h
@@ -162,6 +162,32 @@ enum {
  */
 #define IORING_SETUP_DEFER_TASKRUN	(1U << 13)
 
+/*
+ * Application provides the memory for the rings
+ */
+#define IORING_SETUP_NO_MMAP		(1U << 14)
+
+/*
+ * Register the ring fd in itself for use with
+ * IORING_REGISTER_USE_REGISTERED_RING; return a registered fd index rather
+ * than an fd.
+ */
+#define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
+
+/*
+ * Removes indirection through the SQ index array.
+ */
+#define IORING_SETUP_NO_SQARRAY		(1U << 16)
+
+/* Use hybrid poll in iopoll process */
+#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
+
+/*
+ * Allow both 16b and 32b CQEs. If a 32b CQE is posted, it will have
+ * IORING_CQE_F_32 set in cqe->flags.
+ */
+#define IORING_SETUP_CQE_MIXED		(1U << 18)
+
 enum {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/t/io_uring.c b/t/io_uring.c
index 2a5d0c81..9da5cc9e 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -439,6 +439,7 @@ static int io_uring_setup(unsigned entries, struct io_uring_params *p)
 	p->flags |= IORING_SETUP_COOP_TASKRUN;
 	p->flags |= IORING_SETUP_SINGLE_ISSUER;
 	p->flags |= IORING_SETUP_DEFER_TASKRUN;
+	p->flags |= IORING_SETUP_NO_SQARRAY;
 retry:
 	ret = syscall(__NR_io_uring_setup, entries, p);
 	if (!ret)
@@ -456,6 +457,10 @@ retry:
 		p->flags &= ~IORING_SETUP_DEFER_TASKRUN;
 		goto retry;
 	}
+	if (errno == EINVAL && p->flags & IORING_SETUP_NO_SQARRAY) {
+		p->flags &= ~IORING_SETUP_NO_SQARRAY;
+		goto retry;
+	}
 
 	return ret;
 }
@@ -941,9 +946,14 @@ static int setup_ring(struct submitter *s)
 	sring->ring_mask = ptr + p.sq_off.ring_mask;
 	sring->ring_entries = ptr + p.sq_off.ring_entries;
 	sring->flags = ptr + p.sq_off.flags;
-	sring->array = ptr + p.sq_off.array;
 	sq_ring_mask = *sring->ring_mask;
 
+	if (!(p.flags & IORING_SETUP_NO_SQARRAY)) {
+		sring->array = ptr + p.sq_off.array;
+		for (i = 0; i < p.sq_entries; i++)
+			sring->array[i] = i;
+	}
+
 	if (p.flags & IORING_SETUP_SQE128)
 		len = 2 * p.sq_entries * sizeof(struct io_uring_sqe);
 	else
@@ -969,9 +979,6 @@ static int setup_ring(struct submitter *s)
 	cring->cqes = ptr + p.cq_off.cqes;
 	cq_ring_mask = *cring->ring_mask;
 
-	for (i = 0; i < p.sq_entries; i++)
-		sring->array[i] = i;
-
 	s->per_file_depth = INT_MAX;
 	if (s->nr_files)
 		s->per_file_depth = (depth + s->nr_files - 1) / s->nr_files;
