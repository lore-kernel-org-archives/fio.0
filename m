Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhCINAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Mar 2021 08:00:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA2C06174A
        for <fio@vger.kernel.org>; Tue,  9 Mar 2021 05:00:06 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lJby0-004V41-Rk
        for fio@vger.kernel.org; Tue, 09 Mar 2021 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20210309130002.346BC1BC0157@kernel.dk>
Date: Tue,  9 Mar 2021 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ea9be958d8948cab0c5593a7afc695d17bd6ba79:

  Merge branch 'clock_monotonic_unused' of https://github.com/foxeng/fio (2021-03-06 15:37:56 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 267b164c372d57145880f365bab8d8a52bf8baa7:

  Fio 3.26 (2021-03-08 17:44:38 -0700)

----------------------------------------------------------------
Jens Axboe (2):
      t/io_uring: SQPOLL fixes
      Fio 3.26

 FIO-VERSION-GEN |  2 +-
 t/io_uring.c    | 28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 13 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index 81a6355b..29486071 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.25
+DEF_VER=fio-3.26
 
 LF='
 '
diff --git a/t/io_uring.c b/t/io_uring.c
index 044f9195..ff4c7a7c 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -233,8 +233,7 @@ static int prep_more_ios(struct submitter *s, int max_ios)
 	next_tail = tail = *ring->tail;
 	do {
 		next_tail++;
-		read_barrier();
-		if (next_tail == *ring->head)
+		if (next_tail == atomic_load_acquire(ring->head))
 			break;
 
 		index = tail & sq_ring_mask;
@@ -244,10 +243,8 @@ static int prep_more_ios(struct submitter *s, int max_ios)
 		tail = next_tail;
 	} while (prepped < max_ios);
 
-	if (*ring->tail != tail) {
-		*ring->tail = tail;
-		write_barrier();
-	}
+	if (prepped)
+		atomic_store_release(ring->tail, tail);
 	return prepped;
 }
 
@@ -284,7 +281,7 @@ static int reap_events(struct submitter *s)
 		struct file *f;
 
 		read_barrier();
-		if (head == *ring->tail)
+		if (head == atomic_load_acquire(ring->tail))
 			break;
 		cqe = &ring->cqes[head & cq_ring_mask];
 		if (!do_nop) {
@@ -301,9 +298,10 @@ static int reap_events(struct submitter *s)
 		head++;
 	} while (1);
 
-	s->inflight -= reaped;
-	*ring->head = head;
-	write_barrier();
+	if (reaped) {
+		s->inflight -= reaped;
+		atomic_store_release(ring->head, head);
+	}
 	return reaped;
 }
 
@@ -320,6 +318,7 @@ static void *submitter_fn(void *data)
 	prepped = 0;
 	do {
 		int to_wait, to_submit, this_reap, to_prep;
+		unsigned ring_flags = 0;
 
 		if (!prepped && s->inflight < depth) {
 			to_prep = min(depth - s->inflight, batch_submit);
@@ -338,15 +337,20 @@ submit:
 		 * Only need to call io_uring_enter if we're not using SQ thread
 		 * poll, or if IORING_SQ_NEED_WAKEUP is set.
 		 */
-		if (!sq_thread_poll || (*ring->flags & IORING_SQ_NEED_WAKEUP)) {
+		if (sq_thread_poll)
+			ring_flags = atomic_load_acquire(ring->flags);
+		if (!sq_thread_poll || ring_flags & IORING_SQ_NEED_WAKEUP) {
 			unsigned flags = 0;
 
 			if (to_wait)
 				flags = IORING_ENTER_GETEVENTS;
-			if ((*ring->flags & IORING_SQ_NEED_WAKEUP))
+			if (ring_flags & IORING_SQ_NEED_WAKEUP)
 				flags |= IORING_ENTER_SQ_WAKEUP;
 			ret = io_uring_enter(s, to_submit, to_wait, flags);
 			s->calls++;
+		} else {
+			/* for SQPOLL, we submitted it all effectively */
+			ret = to_submit;
 		}
 
 		/*

