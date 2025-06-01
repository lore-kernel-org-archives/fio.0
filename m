Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDBA19FA92
	for <fio@vger.kernel.org>; Sun,  1 Jun 2025 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748779212; cv=none; b=XnL3bojzs86XWyjTNi5SQQYfyx8cwUPHwnVKctlvkw0alEy5DqpwsUSH9hBJBiJ0+NquUpqJiMcYrvcFKyFpGOBrIkXhbnFtGaDUZqeHPPKUdBvBw41OOjA9Zb1IOqbRbuiU3rek8kyI0LhEwJIb+5mXvXXBOwWtJeCtgCQvexA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748779212; c=relaxed/simple;
	bh=kgwcaEK7w1bUN/HepOGg+b0rivC3uWI0K8fV8sh+wR0=;
	h=Subject:From:To:Message-Id:Date; b=Fou/KRSkUlL4cWF1/Bbrr1STH/D6xcnpj260edD1AH/jCxPriscMPsm3MZd+JgjZ6XMI887qU8tq8rvtAeEw7qzss2gYBSRChOk5KEZfzqB/qeHOPbmGnGUl64RLuZen7M5SGKxhtdvswIkz/v4/I+wV4zMyG6Tofle5+ScFSGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qzU+1+vv; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qzU+1+vv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YkQRJ7t8yDZOfsZ1v6YOxSPyBnsDPqNrhI+nr/cpz30=; b=qzU+1+vviDeqagIi93+PGlnJNC
	Wu/vZCvgHxcqirvb55Q9uzbQnq73onCvMwg7XQqdBTZFTnU81zGRZzpjDg8QSs5gOcQyAQWFI9zZa
	UncSH/LGkbUWuA+T+7bs/7kNuWohZDPpEmV/iiwc3Kx29dbRadXihat36uApMnB4ZwP7qVUBupM6j
	7Y57GHHcujUAcsOH+Z5UbkP1TP+CLBcsBF+fpKNv//sPoK3UzGH0HS1d0C5sKX+GBwIm8v+cIzqcm
	Kmfe5ZbQIs0iE7AekB2n65nUk7a1qe+xJvlMh3uOzr2+M+xz939IsPqLXECjibJWbtuCYrmYWGA27
	I3q7GOSA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uLhMC-0000000HYwo-2I8q
	for fio@vger.kernel.org;
	Sun, 01 Jun 2025 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 494DC1BC0147; Sun,  1 Jun 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20250601120001.494DC1BC0147@kernel.dk>
Date: Sun,  1 Jun 2025 06:00:01 -0600 (MDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit c348db31ccce60f2808dd84c1f43f36a1556141a:

  Add Zhaoxin support to enable tsc_reliable and arch_random features (2025-05-23 09:46:26 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to af8ed1ebebfa55c9b3078e450d2b514bc0bf72c9:

  Merge branch 'opt/io_uring-sq-full-check' of https://github.com/calebsander/fio (2025-05-31 14:22:37 -0600)

----------------------------------------------------------------
Caleb Sander Mateos (1):
      engines/io_uring: remove unnecessary SQ full check

Jens Axboe (1):
      Merge branch 'opt/io_uring-sq-full-check' of https://github.com/calebsander/fio

 engines/io_uring.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 08f220c8..51228037 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -775,7 +775,7 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	struct ioring_data *ld = td->io_ops_data;
 	struct ioring_options *o = td->eo;
 	struct io_sq_ring *ring = &ld->sq_ring;
-	unsigned tail, next_tail;
+	unsigned tail;
 
 	fio_ro_check(td, io_u);
 
@@ -795,11 +795,6 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 		return FIO_Q_COMPLETED;
 	}
 
-	tail = *ring->tail;
-	next_tail = tail + 1;
-	if (next_tail == atomic_load_relaxed(ring->head))
-		return FIO_Q_BUSY;
-
 	if (ld->cmdprio.mode != CMDPRIO_MODE_NONE)
 		fio_ioring_cmdprio_prep(td, io_u);
 
@@ -807,8 +802,9 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 		o->cmd_type == FIO_URING_CMD_NVME)
 		fio_ioring_cmd_nvme_pi(td, io_u);
 
+	tail = *ring->tail;
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
-	atomic_store_release(ring->tail, next_tail);
+	atomic_store_release(ring->tail, tail + 1);
 
 	ld->queued++;
 	return FIO_Q_QUEUED;
