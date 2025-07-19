Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55018C928
	for <fio@vger.kernel.org>; Sat, 19 Jul 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752926412; cv=none; b=HIkYp6u/LWvjvjU2yXnwNDzQ3byoCCPGpn2bUnkwubULRZ3Wyjsl+uS2eYPCqoElDpHT8wxf0UujNxeV77/uounbXeZYvdNMSiQ848zYJxRU8ONpCVZi+K35Suo5VW+G+1nfA7zjtP5lcKZKd2DQ8baEVhjl+KEMo8YG0CjwhiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752926412; c=relaxed/simple;
	bh=YvF+X6JgNcWIEAxzAQAdUyMZ/4UIG6sco4GIlEynybM=;
	h=Subject:From:To:Message-Id:Date; b=dxlSVHsZ2zrCG5Qc6EM+X5IKx2MZvyScUOgRO+4sQ9vEeXpWPAf4VS3cOPCVkmhL0sBN1EaMZjEplRMQj5eEiZM9B+nzMB3YtVBAXeTjgSQH7o9XPndUcq4KxIQafLOU6XJTtX+tEHYq6ZAlVhpfRCQLR/eyE7VFKYM0qmM+0/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nulRu4A6; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nulRu4A6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=haivQvxkpt2y3iBUimN42kNeVGjWnNp5BPVGUV+c4MA=; b=nulRu4A6HvaFcpAQeXTrJx/ltX
	v2LBREQS6WITtyucSMDNBnavxbC2zysKUjFJiHGNGxt9pUS0FzJCx/2nwNeFnwSRIKzy4BXbJJo+B
	7uZOsryyizdGeZlGsZaYDo+Xla6jD+/UBUNtv8V+TAuezZBtnJNgov5K+VQiADSvAUz5doItZSysc
	MEZnotv5LxtzTfoLpyxqUEvUTkhysKdIqheKBtQXduN+7y7xHHpKnIl4CuLMAEv+QCKIQtr7HuvFi
	ZMRXlEJgMS/1+BYL0PXhG6DuxBV2o98XGEaDrk2bkOiVmKhTCQ9Y88NOsTfYFUP3y+VWc8EXH7ouW
	2Kolrt/w==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ud6EX-0000000E3fn-0jGD
	for fio@vger.kernel.org;
	Sat, 19 Jul 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 1B3021BC0155; Sat, 19 Jul 2025 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250719120002.1B3021BC0155@kernel.dk>
Date: Sat, 19 Jul 2025 06:00:02 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 34fa726e0ae0236c36fb1409bddeab2bab7839d2:

  Merge branch 'fsync-get-io-u-from-freelist' of https://github.com/jeongjonghwi/fio (2025-07-16 11:59:46 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 60c19edf22e4a81fe0320370c2386c5b42127dc0:

  Merge branch 'fix/io_uring-cq-reap' of https://github.com/calebsander/fio (2025-07-18 12:38:12 -0600)

----------------------------------------------------------------
Caleb Sander Mateos (7):
      Revert "engines/io_uring: update getevents max to reflect previously seen events"
      engines/io_uring: consolidate fio_ioring_cqring_reap() arguments
      engines/io_uring: remove loop over CQEs in fio_ioring_cqring_reap()
      engines/io_uring: return unsigned from fio_ioring_cqring_reap()
      engines/io_uring: simplify getevents control flow
      arch: add atomic_store_relaxed()
      engines/io_uring: relax CQ head atomic store ordering

Jens Axboe (1):
      Merge branch 'fix/io_uring-cq-reap' of https://github.com/calebsander/fio

 arch/arch.h        |  5 +++++
 engines/io_uring.c | 46 +++++++++++++++++++++++-----------------------
 2 files changed, 28 insertions(+), 23 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch.h b/arch/arch.h
index 7e294ddf..437736f8 100644
--- a/arch/arch.h
+++ b/arch/arch.h
@@ -53,6 +53,8 @@ extern unsigned long arch_flags;
 #define atomic_load_acquire(p)					\
 	std::atomic_load_explicit(p,				\
 			     std::memory_order_acquire)
+#define atomic_store_relaxed(p, v)				\
+	std::atomic_store_explicit((p), (v), std::memory_order_relaxed)
 #define atomic_store_release(p, v)				\
 	std::atomic_store_explicit(p, (v),			\
 			     std::memory_order_release)
@@ -67,6 +69,9 @@ extern unsigned long arch_flags;
 #define atomic_load_acquire(p)					\
 	atomic_load_explicit((_Atomic typeof(*(p)) *)(p),	\
 			     memory_order_acquire)
+#define atomic_store_relaxed(p, v)				\
+	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v),	\
+			      memory_order_relaxed)
 #define atomic_store_release(p, v)				\
 	atomic_store_explicit((_Atomic typeof(*(p)) *)(p), (v),	\
 			      memory_order_release)
diff --git a/engines/io_uring.c b/engines/io_uring.c
index c87e1cd4..87018f84 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -674,25 +674,26 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 	return msg;
 }
 
-static int fio_ioring_cqring_reap(struct thread_data *td, unsigned int events,
-				   unsigned int max)
+static unsigned fio_ioring_cqring_reap(struct thread_data *td, unsigned int max)
 {
 	struct ioring_data *ld = td->io_ops_data;
 	struct io_cq_ring *ring = &ld->cq_ring;
-	unsigned head, reaped = 0;
+	unsigned head = *ring->head;
+	unsigned available = atomic_load_acquire(ring->tail) - head;
 
-	head = *ring->head;
-	do {
-		if (head == atomic_load_acquire(ring->tail))
-			break;
-		reaped++;
-		head++;
-	} while (reaped + events < max);
-
-	if (reaped)
-		atomic_store_release(ring->head, head);
+	if (!available)
+		return 0;
 
-	return reaped;
+	available = min(available, max);
+	/*
+	 * The CQ consumer index is advanced before the CQEs are actually read.
+	 * This is generally unsafe, as it lets the kernel reuse the CQE slots.
+	 * However, the CQ is sized large enough for the maximum iodepth and a
+	 * new SQE won't be submitted until the CQE is processed, so the CQE
+	 * slot won't actually be reused until it has been processed.
+	 */
+	atomic_store_relaxed(ring->head, head + available);
+	return available;
 }
 
 static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
@@ -706,14 +707,15 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 	int r;
 
 	ld->cq_ring_off = *ring->head;
-	do {
-		r = fio_ioring_cqring_reap(td, events, max);
+	for (;;) {
+		r = fio_ioring_cqring_reap(td, max - events);
 		if (r) {
 			events += r;
-			max -= r;
+			if (events >= min)
+				return events;
+
 			if (actual_min != 0)
 				actual_min -= r;
-			continue;
 		}
 
 		if (!o->sqpoll_thread) {
@@ -724,12 +726,10 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
 					continue;
 				r = -errno;
 				td_verror(td, errno, "io_uring_enter");
-				break;
+				return r;
 			}
 		}
-	} while (events < min);
-
-	return r < 0 ? r : events;
+	}
 }
 
 static inline void fio_ioring_cmd_nvme_pi(struct thread_data *td,
@@ -884,7 +884,7 @@ static int fio_ioring_commit(struct thread_data *td)
 			continue;
 		} else {
 			if (errno == EAGAIN || errno == EINTR) {
-				ret = fio_ioring_cqring_reap(td, 0, ld->queued);
+				ret = fio_ioring_cqring_reap(td, ld->queued);
 				if (ret)
 					continue;
 				/* Shouldn't happen */
