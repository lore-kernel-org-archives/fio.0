Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55682 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgB0NAN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Feb 2020 08:00:13 -0500
Received: from [65.144.74.35] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j7Ilw-0008Af-4V
        for fio@vger.kernel.org; Thu, 27 Feb 2020 13:00:12 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200227130002.4A8C81BC016D@kernel.dk>
Date: Thu, 27 Feb 2020 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fb34110eac72f01651543095656693f196d895ca:

  Merge branch 'div-by-zero' of https://github.com/vincentkfu/fio (2020-02-24 08:23:52 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 58d3994d9be0783990af82571cea819b499d526c:

  io_uring: we should not need two write barriers for SQ updates (2020-02-26 19:54:12 -0700)

----------------------------------------------------------------
Eric Sandeen (1):
      fio: remove duplicate global definition of tsc_reliable

Jens Axboe (1):
      io_uring: we should not need two write barriers for SQ updates

 engines/io_uring.c | 2 --
 t/arch.c           | 1 -
 t/io_uring.c       | 2 --
 3 files changed, 5 deletions(-)

---

Diff of recent changes:

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 5e59f975..1efc6cff 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -374,8 +374,6 @@ static enum fio_q_status fio_ioring_queue(struct thread_data *td,
 	if (next_tail == *ring->head)
 		return FIO_Q_BUSY;
 
-	/* ensure sqe stores are ordered with tail update */
-	write_barrier();
 	if (o->cmdprio_percentage)
 		fio_ioring_prio_prep(td, io_u);
 	ring->array[tail & ld->sq_ring_mask] = io_u->index;
diff --git a/t/arch.c b/t/arch.c
index bd28a848..a72cef3a 100644
--- a/t/arch.c
+++ b/t/arch.c
@@ -1,5 +1,4 @@
 #include "../arch/arch.h"
 
 unsigned long arch_flags = 0;
-bool tsc_reliable;
 int arch_random;
diff --git a/t/io_uring.c b/t/io_uring.c
index 55b75f6e..e84a2b6b 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -216,8 +216,6 @@ static int prep_more_ios(struct submitter *s, int max_ios)
 	} while (prepped < max_ios);
 
 	if (*ring->tail != tail) {
-		/* order tail store with writes to sqes above */
-		write_barrier();
 		*ring->tail = tail;
 		write_barrier();
 	}

