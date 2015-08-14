Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbbHNMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 14 Aug 2015 08:00:04 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1ZQDeV-0006ED-6U
	for fio@vger.kernel.org; Fri, 14 Aug 2015 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150814120002.40CBD2C00BE@kernel.dk>
Date: Fri, 14 Aug 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 669e8bf8d509458aa6b3978b9e8a2e3d666e892d:

  server: make the setsockopt() error output a bit more informative (2015-07-29 09:00:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 92060d6c59f1848e86cd9ddd7550907c79bda3d5:

  arch-ppc.h: Add ilog2 implementation for ppc64 (2015-08-13 12:45:20 -0600)

----------------------------------------------------------------
Chandan Rajendra (1):
      arch-ppc.h: Add ilog2 implementation for ppc64

DaveGlen (2):
      Implement new Rate Control
      initialize rate_io_issue_bytes

Jens Axboe (1):
      Whitespace fixup

 arch/arch-ppc.h | 12 ++++++++---
 backend.c       | 26 ++++++++++++++++++++++
 fio.h           |  3 ++-
 init.c          |  3 ++-
 io_u.c          | 67 +++++++++++++++------------------------------------------
 ioengines.c     |  2 ++
 libfio.c        |  2 ++
 workqueue.c     |  1 +
 8 files changed, 61 insertions(+), 55 deletions(-)

---

Diff of recent changes:

diff --git a/arch/arch-ppc.h b/arch/arch-ppc.h
index d4a080c..aed41f9 100644
--- a/arch/arch-ppc.h
+++ b/arch/arch-ppc.h
@@ -33,18 +33,24 @@
 
 #define write_barrier()	__asm__ __volatile__ ("sync" : : : "memory")
 
+#ifdef __powerpc64__
+#define PPC_CNTLZL "cntlzd"
+#else
+#define PPC_CNTLZL "cntlzw"
+#endif
+
 static inline int __ilog2(unsigned long bitmask)
 {
 	int lz;
 
-	asm ("cntlzw %0,%1" : "=r" (lz) : "r" (bitmask));
-	return 31 - lz;
+	asm (PPC_CNTLZL " %0,%1" : "=r" (lz) : "r" (bitmask));
+	return BITS_PER_LONG - 1 - lz;
 }
 
 static inline int arch_ffz(unsigned long bitmask)
 {
 	if ((bitmask = ~bitmask) == 0)
-		return 32;
+		return BITS_PER_LONG;
 	return  __ilog2(bitmask & -bitmask);
 }
 
diff --git a/backend.c b/backend.c
index 3eafff6..9307667 100644
--- a/backend.c
+++ b/backend.c
@@ -763,6 +763,25 @@ static int io_complete_bytes_exceeded(struct thread_data *td)
 }
 
 /*
+ * used to calculate the next io time for rate control
+ *
+ */
+static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
+{
+	uint64_t secs, remainder, bps, bytes;
+
+	assert(!(td->flags & TD_F_CHILD));
+	bytes = td->rate_io_issue_bytes[ddir];
+	bps = td->rate_bps[ddir];
+	if (bps) {
+		secs = bytes / bps;
+		remainder = bytes % bps;
+		return remainder * 1000000 / bps + secs * 1000000;
+	} else
+		return 0;
+}
+
+/*
  * Main IO worker function. It retrieves io_u's to process and queues
  * and reaps them, checking for rate and errors along the way.
  *
@@ -891,9 +910,16 @@ static uint64_t do_io(struct thread_data *td)
 			if (td->error)
 				break;
 			ret = workqueue_enqueue(&td->io_wq, io_u);
+
+			if (should_check_rate(td))
+				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
+
 		} else {
 			ret = td_io_queue(td, io_u);
 
+			if (should_check_rate(td))
+				td->rate_next_io_time[ddir] = usec_for_io(td, ddir);
+
 			if (io_queue_event(td, io_u, &ret, ddir, &bytes_issued, 0, &comp_time))
 				break;
 
diff --git a/fio.h b/fio.h
index 81d58e8..17bc02b 100644
--- a/fio.h
+++ b/fio.h
@@ -238,9 +238,10 @@ struct thread_data {
 	 * Rate state
 	 */
 	uint64_t rate_bps[DDIR_RWDIR_CNT];
-	long rate_pending_usleep[DDIR_RWDIR_CNT];
+	unsigned long rate_next_io_time[DDIR_RWDIR_CNT];
 	unsigned long rate_bytes[DDIR_RWDIR_CNT];
 	unsigned long rate_blocks[DDIR_RWDIR_CNT];
+	unsigned long rate_io_issue_bytes[DDIR_RWDIR_CNT];
 	struct timeval lastrate[DDIR_RWDIR_CNT];
 
 	/*
diff --git a/init.c b/init.c
index 5edd53e..8e1f295 100644
--- a/init.c
+++ b/init.c
@@ -465,7 +465,8 @@ static int __setup_rate(struct thread_data *td, enum fio_ddir ddir)
 		return -1;
 	}
 
-	td->rate_pending_usleep[ddir] = 0;
+	td->rate_next_io_time[ddir] = 0;
+	td->rate_io_issue_bytes[ddir] = 0;
 	return 0;
 }
 
diff --git a/io_u.c b/io_u.c
index d80ef98..9f10206 100644
--- a/io_u.c
+++ b/io_u.c
@@ -568,49 +568,47 @@ void io_u_quiesce(struct thread_data *td)
 static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 {
 	enum fio_ddir odir = ddir ^ 1;
-	long usec;
+	long usec, now;
 
 	assert(ddir_rw(ddir));
+	now = utime_since_now(&td->start);
 
-	if (td->rate_pending_usleep[ddir] <= 0)
+	/*
+	 * if rate_next_io_time is in the past, need to catch up to rate
+	 */
+	if (td->rate_next_io_time[ddir] <= now)
 		return ddir;
 
 	/*
-	 * We have too much pending sleep in this direction. See if we
+	 * We are ahead of rate in this direction. See if we
 	 * should switch.
 	 */
 	if (td_rw(td) && td->o.rwmix[odir]) {
 		/*
-		 * Other direction does not have too much pending, switch
+		 * Other direction is behind rate, switch
 		 */
-		if (td->rate_pending_usleep[odir] < 100000)
+		if (td->rate_next_io_time[odir] <= now)
 			return odir;
 
 		/*
-		 * Both directions have pending sleep. Sleep the minimum time
-		 * and deduct from both.
+		 * Both directions are ahead of rate. sleep the min
+		 * switch if necissary
 		 */
-		if (td->rate_pending_usleep[ddir] <=
-			td->rate_pending_usleep[odir]) {
-			usec = td->rate_pending_usleep[ddir];
+		if (td->rate_next_io_time[ddir] <=
+			td->rate_next_io_time[odir]) {
+			usec = td->rate_next_io_time[ddir] - now;
 		} else {
-			usec = td->rate_pending_usleep[odir];
+			usec = td->rate_next_io_time[odir] - now;
 			ddir = odir;
 		}
 	} else
-		usec = td->rate_pending_usleep[ddir];
+		usec = td->rate_next_io_time[ddir] - now;
 
 	if (td->o.io_submit_mode == IO_MODE_INLINE)
 		io_u_quiesce(td);
 
 	usec = usec_sleep(td, usec);
 
-	td->rate_pending_usleep[ddir] -= usec;
-
-	odir = ddir ^ 1;
-	if (td_rw(td) && __should_check_rate(td, odir))
-		td->rate_pending_usleep[odir] -= usec;
-
 	return ddir;
 }
 
@@ -1656,18 +1654,6 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
 	}
 }
 
-static long long usec_for_io(struct thread_data *td, enum fio_ddir ddir)
-{
-	uint64_t secs, remainder, bps, bytes;
-
-	assert(!(td->flags & TD_F_CHILD));
-	bytes = td->this_io_bytes[ddir];
-	bps = td->rate_bps[ddir];
-	secs = bytes / bps;
-	remainder = bytes % bps;
-	return remainder * 1000000 / bps + secs * 1000000;
-}
-
 static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 			 struct io_completion_data *icd)
 {
@@ -1709,7 +1695,6 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 
 	if (!io_u->error && ddir_rw(ddir)) {
 		unsigned int bytes = io_u->buflen - io_u->resid;
-		const enum fio_ddir oddir = ddir ^ 1;
 		int ret;
 
 		td->io_blocks[ddir]++;
@@ -1738,27 +1723,9 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
 		}
 
 		if (ramp_time_over(td) && (td->runstate == TD_RUNNING ||
-					   td->runstate == TD_VERIFYING)) {
-			struct thread_data *__td = td;
-
+					   td->runstate == TD_VERIFYING))
 			account_io_completion(td, io_u, icd, ddir, bytes);
 
-			if (td->parent)
-				__td = td->parent;
-
-			if (__should_check_rate(__td, ddir)) {
-				__td->rate_pending_usleep[ddir] =
-					(usec_for_io(__td, ddir) -
-					 utime_since_now(&__td->start));
-			}
-			if (ddir != DDIR_TRIM &&
-			    __should_check_rate(__td, oddir)) {
-				__td->rate_pending_usleep[oddir] =
-					(usec_for_io(__td, oddir) -
-					 utime_since_now(&__td->start));
-			}
-		}
-
 		icd->bytes_done[ddir] += bytes;
 
 		if (io_u->end_io) {
diff --git a/ioengines.c b/ioengines.c
index 958731d..9c5ac60 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -299,6 +299,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (ddir_rw(ddir)) {
 		td->io_issues[ddir]++;
 		td->io_issue_bytes[ddir] += buflen;
+		td->rate_io_issue_bytes[ddir] += buflen;
 	}
 
 	ret = td->io_ops->queue(td, io_u);
@@ -308,6 +309,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 	if (ret == FIO_Q_BUSY && ddir_rw(ddir)) {
 		td->io_issues[ddir]--;
 		td->io_issue_bytes[ddir] -= buflen;
+		td->rate_io_issue_bytes[ddir] -= buflen;
 	}
 
 	/*
diff --git a/libfio.c b/libfio.c
index b0141a7..d4cad3e 100644
--- a/libfio.c
+++ b/libfio.c
@@ -89,6 +89,8 @@ static void reset_io_counters(struct thread_data *td)
 		td->rate_bytes[ddir] = 0;
 		td->rate_blocks[ddir] = 0;
 		td->bytes_done[ddir] = 0;
+		td->rate_io_issue_bytes[ddir] = 0;
+		td->rate_next_io_time[ddir] = 0;
 	}
 	td->zone_bytes = 0;
 
diff --git a/workqueue.c b/workqueue.c
index 0a6cd20..e236516 100644
--- a/workqueue.c
+++ b/workqueue.c
@@ -124,6 +124,7 @@ int workqueue_enqueue(struct workqueue *wq, struct io_u *io_u)
 		if (ddir_rw(ddir)) {
 			parent->io_issues[ddir]++;
 			parent->io_issue_bytes[ddir] += io_u->xfer_buflen;
+			parent->rate_io_issue_bytes[ddir] += io_u->xfer_buflen;
 		}
 
 		pthread_mutex_lock(&sw->lock);
