Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH v2 3/4] fio: document locking for overlap checking in offload mode
Date: Wed, 17 Oct 2018 10:52:24 -0400
Message-Id: <20181017145225.14546-4-vincentfu@gmail.com>
In-Reply-To: <20181017145225.14546-1-vincentfu@gmail.com>
References: <20181017145225.14546-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Overlap checking in offload submission mode uses locks in an unusual
manner. Add some comments in the code to clarify how locks are used.
---
 backend.c     | 5 +++++
 ioengines.c   | 7 +++++++
 rate-submit.c | 8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/backend.c b/backend.c
index 1c60138c..d6450baf 100644
--- a/backend.c
+++ b/backend.c
@@ -1874,6 +1874,11 @@ static void *thread_main(void *data)
 			 "perhaps try --debug=io option for details?\n",
 			 td->o.name, td->io_ops->name);
 
+	/*
+	 * Acquire this lock if we were doing overlap checking in
+	 * offload mode so that we don't clean up this job while
+	 * another thread is checking its io_u's for overlap
+	 */
 	if (td_offload_overlap(td))
 		pthread_mutex_lock(&overlap_check);
 	td_set_runstate(td, TD_FINISHING);
diff --git a/ioengines.c b/ioengines.c
index 56723add..b7df8608 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -288,6 +288,13 @@ enum fio_q_status td_io_queue(struct thread_data *td, struct io_u *io_u)
 
 	assert((io_u->flags & IO_U_F_FLIGHT) == 0);
 	io_u_set(td, io_u, IO_U_F_FLIGHT);
+
+	/*
+	 * If overlap checking was enabled in offload mode we
+	 * can release this lock that was acquired when we
+	 * started the overlap check because the IO_U_F_FLIGHT
+	 * flag is now set
+	 */
 	if (td_offload_overlap(td))
 		pthread_mutex_unlock(&overlap_check);
 
diff --git a/rate-submit.c b/rate-submit.c
index 68ad755d..e5c62043 100644
--- a/rate-submit.c
+++ b/rate-submit.c
@@ -21,6 +21,14 @@ static void check_overlap(struct io_u *io_u)
 		 * time to prevent two threads from thinking the coast
 		 * is clear and then submitting IOs that overlap with
 		 * each other
+		 *
+		 * If an overlap is found, release the lock and
+		 * re-acquire it before checking again to give other
+		 * threads a chance to make progress
+		 *
+		 * If an overlap is not found, release the lock when the
+		 * io_u's IO_U_F_FLIGHT flag is set so that this io_u
+		 * can be checked by other threads as they assess overlap
 		 */
 		pthread_mutex_lock(&overlap_check);
 		for_each_td(td, i) {
-- 
2.17.1


