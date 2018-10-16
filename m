Return-Path: <vincentfu@gmail.com>
Return-Path: <vincentfu@gmail.com>
From: vincentfu@gmail.com
Subject: [PATCH 1/2] serialize_overlap: document locking for cross-job overlap checking
Date: Tue, 16 Oct 2018 11:26:49 -0400
Message-Id: <20181016152650.7784-2-vincentfu@gmail.com>
In-Reply-To: <20181016152650.7784-1-vincentfu@gmail.com>
References: <20181016152650.7784-1-vincentfu@gmail.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Vincent Fu <vincent.fu@wdc.com>

Add some comments to clarify how locking is used for cross-job overlap
checking
---
 backend.c     | 5 +++++
 ioengines.c   | 7 +++++++
 rate-submit.c | 8 ++++++++
 3 files changed, 20 insertions(+)

diff --git a/backend.c b/backend.c
index cc3c4e78..2a05abb7 100644
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
 	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
 		pthread_mutex_lock(&overlap_check);
 	td_set_runstate(td, TD_FINISHING);
diff --git a/ioengines.c b/ioengines.c
index 47f606a7..fca1f0ed 100644
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
 	if (td->o.serialize_overlap && td->o.io_submit_mode == IO_MODE_OFFLOAD)
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


